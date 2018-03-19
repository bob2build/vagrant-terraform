require "fog"
require "log4r"

module VagrantPlugins
  module Terraform
    module Action
      class RunTerraformApply
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_terraform::action::run_terraform_apply")
        end

        def call(env)
          workspace = env[:machine].provider_config.terraform_project
          runner = TerraformRunner.new(workspace)
          runner.init
          runner.apply
          @app.call(env)
        end
      end
    end
  end
end
