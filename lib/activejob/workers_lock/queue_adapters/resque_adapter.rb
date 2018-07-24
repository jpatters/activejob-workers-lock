require 'active_job/queue_adapters/resque_adapter'

begin
  require 'resque/plugins/workers/lock'
rescue LoadError
  false
end

module ActiveJob
  module QueueAdapters

    class ResqueAdapter

      def wrapper(job)
        job.lock ? JobWrapperWithLock : JobWrapper
      end

      def enqueue(job) #:nodoc:
        klass = wrapper(job)
        klass.instance_variable_set(:@queue, job.queue_name)
        Resque.enqueue_to job.queue_name, klass, job.serialize
      end

      def enqueue_at(job, timestamp) #:nodoc:
        unless Resque.respond_to?(:enqueue_at_with_queue)
          raise NotImplementedError, "To be able to schedule jobs with Resque you need the " \
            "resque-scheduler gem. Please add it to your Gemfile and run bundle install"
        end
        Resque.enqueue_at_with_queue job.queue_name, timestamp, wrapper(job), job.serialize
      end

      class JobWrapperWithLock < JobWrapper
        extend Resque::Plugins::Workers::Lock

        def self.lock_workers(job_data)
          @job ||= Base.deserialize(job_data)

          @job.apply_lock
        end

        def self.reenqueue(job_data)
          @job ||= Base.deserialize(job_data)
          if defined? Resque::Scheduler
            # schedule a job in requeue_perform_delay seconds
            timestamp = Time.now + requeue_perform_delay
            Resque.enqueue_at_with_queue @job.queue_name, timestamp, self, job_data
          else
            sleep(requeue_perform_delay)
            Resque.enqueue_to @job.queue_name, self, job_data
          end
          raise Resque::Job::DontPerform
        end
      end
    end
  end
end