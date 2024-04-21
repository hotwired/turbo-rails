# A decorated debouncer that will store instances in the current thread clearing them
# after the debounced logic triggers.
class Turbo::ThreadThrottler
  delegate :wait, to: :throttler

  def self.for(key, throttler: nil)
    Thread.current[key] ||= new(key, Thread.current, throttler || :debouncer)
  end

  private_class_method :new

  def initialize(key, thread, throttler)
    @key = key
    @thread = thread
    @throttler = build_throttler(throttler)
    @throttler.cleanup = -> { thread[key] = nil }
  end

  def throttle
    throttler.throttle do
      yield
    end
  end

  private
    attr_reader :key, :throttler, :thread

    def build_throttler(throttler)
      case throttler
      when Symbol, String
        "Turbo::#{throttler.to_s.camelize}".constantize.new
      when Hash
        "Turbo::#{throttler.fetch(:type).to_s.camelize}".constantize.new(**throttler.except(:type))
      else
        throttler
      end
    end
end
