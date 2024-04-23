class Turbo::RateLimiter
  attr_accessor :cleanup
  attr_reader :count, :max, :interval, :scheduled_task

  DEFAUL_MAX = 1
  DEFAULT_INTERVAL = 2

  def initialize(max: DEFAUL_MAX, interval: DEFAULT_INTERVAL, cleanup: nil)
    @interval = interval
    @max = max
    @count = Concurrent::AtomicFixnum.new(0)
    @cleanup = cleanup
  end

  def throttle(&block)
    return if count.value >= max

    @count.increment
    block.call

    return if @scheduled_task && !@scheduled_task.complete?

    @scheduled_task = Concurrent::ScheduledTask.execute(interval) do
      @count.value = 0
      cleanup&.call
    end
  end

  def wait
    scheduled_task&.wait(wait_timeout)
  end

  private
    def wait_timeout
      interval + 1
    end
end
