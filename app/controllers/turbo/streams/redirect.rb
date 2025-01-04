module Turbo::Streams::Redirect
  extend ActiveSupport::Concern

  private

  # Instruct Turbo Drive to redirect the page, regardless of whether or not the
  # request was made from within a `<turbo-frame>` element.
  #
  # When handling requests made from outside a `<turbo-frame>` elements (without
  # the `Turbo-Frame` HTTP header), respond with a typical HTML redirect
  # response.
  #
  # When handling request made from inside a `<turbo-frame>` element (with the
  # `Turbo-Frame` HTTP header), render a `<turbo-stream action="visit">` element
  # with the redirect's pathname or URL encoded into the `[location]` attribute.
  #
  # When Turbo Drive receives the response, it will call `Turbo.visit()` with
  # the value read from the `[location]` attribute.
  #
  #   class ArticlesController < ApplicationController
  #     def show
  #       @article = Article.find(params[:id])
  #     end
  #
  #     def create
  #       @article = Article.new(article_params)
  #
  #       if @article.save
  #         break_out_of_turbo_frame_and_redirect_to @article
  #       else
  #         render :new, status: :unprocessable_entity
  #       end
  #     end
  #   end
  #
  # Response options (like `:notice`, `:alert`, `:status`, etc.) are forwarded
  # to the underlying redirection mechanism (`#redirect_to` for `Mime[:html]`
  # requests and `#turbo_stream_redirect_to` for `Mime[:turbo_stream]`
  # requests).
  def break_out_of_turbo_frame_and_redirect_to(options = {}, response_options_and_flash = {}) # :doc:
    respond_to do |format|
      format.html { redirect_to(options, response_options_and_flash) }

      if turbo_frame_request?
        format.turbo_stream { turbo_stream_redirect_to(options, response_options_and_flash) }
      end
    end
  end

  # Respond with a `<turbo-stream action="visit">` with the `[location]`
  # attribute set to the pathname or URL. Preserves `:alert`, `:notice`, and
  # `:flash` options.
  #
  # When passed a `:status` HTTP status code option between `300` and `399`,
  # replace it with a `201 Created` status and set the `Location` HTTP header to
  # the pathname or URL.
  def turbo_stream_redirect_to(options = {}, response_options_and_flash = {}) # :doc:
    location = url_for(options)

    self.class._flash_types.each do |flash_type|
      if (type = response_options_and_flash.delete(flash_type))
        flash[flash_type] = type
      end
    end

    if (other_flashes = response_options_and_flash.delete(:flash))
      flash.update(other_flashes)
    end

    case Rack::Utils.status_code(response_options_and_flash.fetch(:status, :created))
    when 201, 300..399
      response_options_and_flash[:status] = :created
      response_options_and_flash[:location] = location
    end

    render turbo_stream: turbo_stream.visit(location), **response_options_and_flash
  end
end
