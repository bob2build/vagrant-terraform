require "log4r"
require_relative "../util/runner"

module VagrantPlugins
  module Terraform
    module Action
      # This action runs terraform plan and checks if an apply is needed.
      # If apply is not needed, Runs terraform output and reads the state and puts in env[:state]
      class ReadTerraformState
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_terraform::action::read_terraform_state")
        end

        def call(env)
          workspace = File.dirname(env[:machine].provider_config.template)
          runner = VagrantPlugins::Terraform::TerraformRunner.new(workspace)
          runner.init
          if runner.apply_needed?
            env[:machine_state_id] = :not_created
          else
            env[:machine_state_id] = :running
          end
          @app.call(env)
        end
      end
    end
  end
end
