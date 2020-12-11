# Most page updates are rendered either asynchronously via <tt>Turbo::Broadcastable</tt>/<tt>Turbo::StreamChannel</tt> or
# rendered in templates with the <tt>turbo_stream.erb</tt> extension. But it's also possible to render updates inline
# in controllers, like so:
#
#   def destroy
#     @user.destroy!
#
#     respond_to do |format|
#       format.html         { redirect_to users_url, notice: "User removed" }
#       format.turbo_stream { render turbo_stream: turbo_stream.remove(@user) }
#     end
#   end
#
# This module adds that turbo_stream object to all controllers. It's an instance of <tt>Turbo::Stream::TagBuilder</tt>
# instantiated with the current <tt>view_context</tt>.
module Turbo::Stream::TurboStreamTagBuilder
  private

  def turbo_stream
    Turbo::Stream::TagBuilder.new(view_context)
  end
end
