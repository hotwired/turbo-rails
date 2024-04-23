# A decorated debouncer that will store instances in the current thread clearing them
# after the debounced logic triggers.
class Turbo::ThreadThrottler
  delegate :wait, to: :throttler

  def self.for(key, throttler:)
    Thread.current[key] ||= new(key, Thread.current, throttler)
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
      klass, args = extract_throttler_class_and_arguments(throttler)
      klass.new(**args)
    end

    def extract_throttler_class_and_arguments(throttler)
      [
        extract_throttler_class(throttler), 
        extract_throttler_arguments(throttler)
      ]
    end


    def extract_throttler_class(throttler)
      case throttler
      when Symbol
        "Turbo::#{throttler.to_s.camelize}".constantize
      when String
        throttler.constantize
      when Hash
        extract_throttler_class(throttler.fetch(:type))
      else
        throttler
      end
    end

    def extract_throttler_arguments(throttler)
      case throttler
      when Hash
        throttler.except(:type)
      else
        {}
      end
    end
end
