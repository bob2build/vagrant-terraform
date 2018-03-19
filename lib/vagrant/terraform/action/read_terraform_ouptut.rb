require "fog"
require "log4r"

module VagrantPlugins
  module Terraform
    module Action
      # This action connects to AWS, verifies credentials work, and
      # puts the AWS connection object into the `:aws_compute` key
      # in the environment.
      class RunTerraformOutput
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrant_terraform::action::run_terraform_apply")
        end

        def call(env)
          workspace = env[:machine].provider_config.terraform_project
          runner = TerraformRunner.new(workspace)
          runner.init
          runner.output
          @app.call(env)
        end
      end
    end
  end
end
