require 'open3'
require 'json'
module VagrantPlugins
  module Terraform
    class TerraformRunner
      @@logger = Log4r::Logger.new("vagrant_terraform::action::terraform_runner")

      def initialize(workspace, binary = '/usr/local/bin/terraform')
        @binary = binary
        @workspace = workspace
      end

      def init
        @@logger.info("Initializing workspace at #{@workspace}")
        Dir.chdir(@workspace) do
          Open3.popen2e(initcmd) do |stdin, stdout_stderr, wait_thread|
            Thread.new do
              stdout_stderr.each {|l| @@logger.debug(l)}
            end
            stdin.close
            status = wait_thread.value
            if status.exitstatus != 0
              fail Errors::VagrantTerraformError, :message => 'terraform init failed'
            end
          end
          @@logger.info("Terraform initialized ")
        end
      end

      def apply
        @@logger.info("Applying plan")
        Dir.chdir(@workspace) do
          Open3.popen2e(applycmd) do |stdin, stdout_stderr, wait_thread|
            Thread.new do
              stdout_stderr.each {|l| @@logger.debug(l)}
            end
            stdin.close
            status = wait_thread.value
            if status.exitstatus != 0
              fail Errors::VagrantTerraformError, :message => 'terraform apply failed'
            end
          end
          @@logger.info("Terraform apply complete")
        end
      end

      def apply_needed?
        @@logger.info("Running terraform plan")
        Dir.chdir(@workspace) do
          Open3.popen2e(plancmd) do |stdin, stdout_stderr, wait_thread|
            Thread.new do
              stdout_stderr.each {|l| @@logger.debug(l)}
            end
            stdin.close
            status = wait_thread.value
            if status.exitstatus == 1
              fail Errors::VagrantTerraformError, :message => 'terraform plan failed'
            end
            if status.exitstatus == 0
              false
            else
              true
            end
          end
        end
      end

      def output
        @@logger.info("Extracting output")
        Dir.chdir(@workspace) do
          stdout, stderr, status = Open3.capture3(outputcmd)
          if status.exitstatus != 0
            fail Errors::VagrantTerraformError, :message => 'terraform output failed'
          end
          begin
            JSON.parse(stdout)
          rescue Exception => e
            fail Errors::VagrantTerraformError, :message => "terraform output [#{stdout}] is not a valid json"
          end
        end
      end

      private

      def initcmd
        "#{@binary} init -input=false"
      end

      def applycmd
        "#{@binary} apply -input=false -auto-approve"
      end

      def outputcmd
        "#{@binary} output -input=false -json"
      end

      def plancmd
        "#{@binary} plan -input=false -detailed-exitcode"
      end

      def env
        {
            'TF_IN_AUTOMATION' => '1',

        }
      end
    end
  end
end