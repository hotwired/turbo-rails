# When streaming from a model instance using <tt>turbo_stream_from @post</tt>, it can be useful to locate the instance
# in <tt>config.turbo.base_stream_channel_class</tt>. These helper methods are available as a convenience for applications
# to implement custom logic such as authorization.
module Turbo::Streams::LocatableName
  # Locate a single streamable. Useful when subscribing with <tt>turbo_stream_from @post</tt>. It can be used e.g to
  # implement application-specific authorization, ex: <tt>current_user.can_access? locate_streamable</tt>
  def locate_streamable
    @locate_streamable ||= GlobalID::Locator.locate(verified_stream_name_from_params)
  end

  # Locate multiple streamables. Useful when subscribing with <tt>turbo_stream_from @post1, @post2</tt>. It can be
  # used e.g to implement application-specific authorization, ex:
  # <tt>locate_streamables.present? && locate_streamables.all? { |streamable| current_user.can_access?(streamable) }</tt>
  def locate_streamables
    @locate_streamables ||= GlobalID::Locator.locate_many(verified_stream_name_parts_from_params)
  end
end
