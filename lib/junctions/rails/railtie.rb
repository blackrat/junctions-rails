module Junctions
  module Rails
    class Railtie < ::Rails::Railtie
      config.junctions = ActiveSupport::OrderedOptions.new

      initializer 'junctions.config_extensions' do
        require 'junctions'
      end

      initializer :load_environment_config do |app|
        Junctions::Engine.junction_classes do |junction|
          app.config.paths['config/environments'] << "config/junctions/environments/#{junction}"
          app.config.paths['config/initializers'] << "config/junctions/initializers/#{junction}"
          app.config.paths['config/database'] = "config/junctions/databases/#{junction}/database.yml"
          app.config.paths['config.routes.rb'] = "config/junctions/routes/#{junction}/routes.rb"
        end
      end

      # initializer :append_migrations do |app|
      #   app.config.paths['db/migrate'].expanded.each do |expanded_path|
      #     app.config.paths['db/migrate'] << expanded_path
      #   end
      # end

      initializer :add_junction_view_paths do |app|
        Junctions::Engine.junction_classes do |junction|
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

      def include_environment
        Junctions::Engine.junction_classes.each do |junction_class|
          require "config/junctions/environments/#{junction_class}/#{Rails.env}"
        end
      end
    end
  end
end
