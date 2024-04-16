module Turbo::LinkToHelper
  # Allows creation of a link that can navigate outside of the turbo frame:
  #
  #   <%= external_link_to "Click me", "https://example.com" %>
  #
  # This will render:
  #
  #  <a href="https://example.com" target="_top">Click me</a>
  def external_link_to(*args, **options, &block)
    options[:target] = "_top"
    link_to(*args, **options, &block)
  end
end
