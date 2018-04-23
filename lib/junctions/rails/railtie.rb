module Junctions
  module Rails
    class Railtie < ::Rails::Railtie
      config.junctions = ActiveSupport::OrderedOptions.new
      initializer 'junctions.config_extensions', after: :load_config_initializers do
        require 'junctions'
      end

      initializer :load_environment_config, before: :load_environment_hook, group: :all do |app|
        for_all_junctions_reversed do |junction|
          app.config.paths['config/environments'] << "config/junctions/environments/#{junction}"
          app.config.paths['config/initializers'] << "config/junctions/initializers/#{junction}"
          #TODO This isn't being loaded for the rake db:create, although the rake db:migrate is using it
          #TODO Find out and fix the config/database, config/routes.rb not loading the latest instance
          #TODO unless you overwrite it.
          app.config.paths['config/database'] = "config/junctions/databases/#{junction}/database.yml"
          app.config.paths['config.routes.rb'] = "config/junctions/routes/#{junction}/routes.rb"
        end
      end

      initializer :append_migrations do |app|
        unless already_in_root?(app)
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end

      initializer :add_eager_load_lib do |app|
        for_all_junctions_reversed do |junction|
          junction_config(app.config,junction)
        end
        base_config(app.config)
        app.config.paths.add 'lib/junctions/app', eager_load: true, glob: '*'
      end

      initializer :add_junction_view_paths do |app|
        unless already_in_root?(app)
          for_all_junctions_reversed do |junction|
            view_config(junction).each do |junction_view|
              ActiveSupport.on_load(:action_controller){
                prepend_view_path(junction_view) if respond_to?(:prepend_view_path)
              }
              ActiveSupport.on_load(:action_mailer){
                prepend_view_path(junction_view)
              }
            end
          end
        end
      end


      def include_environment
        junction_classes.each do |junction_class|
          require "config/junctions/environments/#{junction_class}/#{Rails.env}"
        end
      end

    end
  end
end
