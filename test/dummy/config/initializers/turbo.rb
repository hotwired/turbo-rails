ActiveSupport.on_load :turbo_streams_tag_builder do
  def highlight(target)
    action :highlight, target
  end

  def highlight_all(targets)
    action_all :highlight, targets
  end
end
