class Turbo::Debouncer
  attr_accessor :cleanup
  attr_reader :delay, :scheduled_task

  DEFAULT_DELAY = 0.5

  def initialize(delay: DEFAULT_DELAY, cleanup: nil)
    @delay = delay
    @scheduled_task = nil
    @cleanup = cleanup
  end

  def throttle(&block)
    scheduled_task&.cancel unless scheduled_task&.complete?
    @scheduled_task = Concurrent::ScheduledTask.execute(delay) do
      block.call.tap { cleanup&.call }
    end
  end

  def wait
    scheduled_task&.wait(wait_timeout)
  end

  private
    def wait_timeout
      delay + 1
    end
end
