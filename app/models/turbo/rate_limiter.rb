class Turbo::RateLimiter
  attr_accessor :cleanup
  attr_reader :count, :interval, :scheduled_task

  DEFAUL_COUNT = 1
  DEFAULT_INTERVAL = 2

  def initialize(count: DEFAUL_COUNT, interval: DEFAULT_INTERVAL)
    @interval = interval
    @count = count
  end

  def throttle(&block)
    return if @scheduled_task && !@scheduled_task.complete?

    @scheduled_task = Concurrent::ScheduledTask.execute(delay) do
      cleanup&.call
    end

    block.call
  end

  def wait
    scheduled_task&.wait(wait_timeout)
  end

  private
    def delay
      interval / count
    end

    def wait_timeout
      delay + 1
    end
end
