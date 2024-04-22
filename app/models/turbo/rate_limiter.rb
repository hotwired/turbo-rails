class Turbo::RateLimiter
  attr_accessor :cleanup
  attr_reader :count, :max, :interval, :scheduled_task

  DEFAUL_MAX = 1
  DEFAULT_INTERVAL = 2

  def initialize(max: DEFAUL_MAX, interval: DEFAULT_INTERVAL)
    @interval = interval
    @max = max
    @count = 0
  end

  def throttle(&block)
    return if count >= max

    @count += 1
    block.call

    return if @scheduled_task && !@scheduled_task.complete?

    @scheduled_task = Concurrent::ScheduledTask.execute(delay) do
      cleanup&.call
    end
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
