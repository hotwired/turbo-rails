ActiveSupport.on_load :turbo_streams_tag_builder do
  def highlight(target)
    action :highlight, target
  end

  def highlight_all(targets)
    action_all :highlight, targets
  end

  # Custom action without target for testing issue #771
  def redirect_to(url)
    action :redirect_to, attributes: { redirect_to: url }
  end

  # Custom action with target and attributes for testing issue #771
  def flash(target, type:)
    action :flash, target, attributes: { type: type }
  end

  # Custom action with targets and attributes for testing issue #771
  def flash_all(targets, type:)
    action_all :flash, targets, attributes: { type: type }
  end
end
