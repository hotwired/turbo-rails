# Most page updates are rendered either asynchronously via <tt>Turbo::Broadcastable</tt>/<tt>Turbo::UpdatesChannel</tt> or
# rendered in templates with the <tt>turbo_update.erb</tt> extension. But it's also possible to render updates inline
# in controllers, like so:
#
#   def destroy
#     @user.destroy!
#
#     respond_to do |format|
#       format.html         { redirect_to users_url, notice: "User removed" }
#       format.turbo_update { render turbo_update: turbo_update.remove(@user) }
#     end
#   end
#
# This module adds that turbo_update object to all controllers. It's an instance of <tt>Turbo::Updates::TagBuilder</tt>
# instantiated with the current <tt>view_context</tt>.
module Turbo::Updates::TurboUpdatesTagBuilder
  private

  def turbo_update
    Turbo::Updates::TagBuilder.new(view_context)
  end
end
