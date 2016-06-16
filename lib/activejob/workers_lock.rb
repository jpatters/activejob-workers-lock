require 'active_support'
require 'active_job/base'
require 'activejob/workers_lock/version'
require 'activejob/workers_lock/queue_adapters'
require 'active_support/concern'

module ActiveJob
  module WorkersLock
    extend ActiveSupport::Concern

    module ClassMethods

      def lock_with(lock = nil, &block)
        if block_given?
          self.lock = block
        else
          self.lock = lock
        end
      end
    end

    included do
      class_attribute :lock
    end

    def apply_lock
      key = if lock.is_a?(Proc)
        deserialize_arguments_if_needed
        lock.call(*arguments)
      else
        lock
      end
      "#{key}"
    end
  end
  Base.include(WorkersLock)
end

