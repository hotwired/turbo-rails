# Most page updates are rendered either asynchronously via <tt>Turbo::Broadcastable</tt>/<tt>Turbo::UpdatesChannel</tt> or
# rendered in templates with the <tt>page_update.erb</tt> extension. But it's also possible to render page updates inline
# in controllers, like so:
#
#   def destroy
#     @user.destroy!
#
#     respond_to do |format|
#       format.html        { redirect_to users_url, notice: "User removed" }
#       format.page_update { render page_update: page_update.remove(@user) }
#     end
#   end
#
# This module adds that page_update object to all controllers. It's an instance of <tt>Turbo::Updates::TagBuilder</tt>
# instantiated with the current <tt>view_context</tt>.
module Turbo::Updates::PageUpdateTagBuilder
  private

  def page_update
    Turbo::Updates::TagBuilder.new(view_context)
  end
end
