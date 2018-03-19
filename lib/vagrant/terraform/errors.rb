require "vagrant"

module VagrantPlugins
  module Terraform
    module Errors
      class VagrantTerraformError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_terraform.errors")
      end

    end
  end
end
