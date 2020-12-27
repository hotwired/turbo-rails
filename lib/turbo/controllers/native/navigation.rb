# Turbo is built to work with native navigation principles and present those alongside what's required for the web. When you
# have Turbo Native clients running (see the Turbo iOS and Turbo Android projects for details), you can respond to native
# requests with three dedicated responses: <tt>recede</tt>, <tt>resume</tt>, <tt>refresh</tt>.
#
# FIXME: Supply full description of when we use either.
module Turbo::Native::Navigation
  private

  def recede_or_redirect_to(url, **options)
    turbo_native_action_or_redirect url, :recede, :to, options
  end

  def resume_or_redirect_to(url, **options)
    turbo_native_action_or_redirect url, :resume, :to, options
  end

  def refresh_or_redirect_to(url, **options)
    turbo_native_action_or_redirect url, :refresh, :to, options
  end


  def recede_or_redirect_back_or_to(url, **options)
    turbo_native_action_or_redirect url, :recede, :back, options
  end

  def resume_or_redirect_back_or_to(url, **options)
    turbo_native_action_or_redirect url, :resume, :back, options
  end

  def refresh_or_redirect_back_or_to(url, **options)
    turbo_native_action_or_redirect url, :refresh, :back, options
  end

  # :nodoc:
  def turbo_native_action_or_redirect(url, action, redirect_type, options = {})
    if turbo_native_app?
      redirect_to send("turbo_#{action}_historical_location_url", notice: options[:notice] || options.delete(:native_notice))
    elsif redirect_type == :back
      redirect_back fallback_location: url, **options
    else
      redirect_to url, options
    end
  end

  # Turbo Native applications are identified by having the string "Turbo Native" as part of their user agent.
  def turbo_native_app?
    request.user_agent.to_s.match?(/Turbo Native/)
  end
end
