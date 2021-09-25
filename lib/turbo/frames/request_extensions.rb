module Turbo
  module Frames
    module RequestExtensions
      def turbo_frame?
        turbo_frame.present?
      end

      def turbo_frame
        headers["Turbo-Frame"]
      end
    end
  end
end
