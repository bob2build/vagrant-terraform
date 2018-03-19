require "vagrant"
require "iniparse"

module VagrantPlugins
  module Terraform
    class Config < Vagrant.plugin("2", :config)

      # The Terraform file which will be used to manage cloud resources
      attr_accessor :template

      def initialize(region_specific = false)
        @template = UNSET_VALUE
      end

      #-------------------------------------------------------------------
      # Internal methods.
      #-------------------------------------------------------------------

      def finalize!
        # Mark that we finalized
        if @template == UNSET_VALUE
          @template = nil
        end
        @__finalized = true
      end

      def validate(machine)
        errors = _detected_errors
        errors << I18n.t('vagrant_terraform.config.template_required') if @template.nil?
        {"AWS Provider" => errors}
      end

      def to_s
        "VagrantPlugins::Terraform::Config[terraform_template=#{@template}]"
      end

    end
  end
end
