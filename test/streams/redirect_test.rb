require "test_helper"

class Turbo::Streams::RedirectHtmlRequestTest < ActionDispatch::IntegrationTest
  test "#break_out_of_turbo_frame_and_redirect_to forwards option to redirect_to" do
    post articles_path,
      params: {
        article: {body: "A valid value"},
        redirect_to_options: {
          status: 303,
          notice: "Notice!",
          flash: {alert: "Alert!"}
        }
      }

    assert_redirected_to articles_url, status: :see_other
    assert_equal "Notice!", flash.notice
    assert_equal "Alert!", flash.alert
  end
end

class Turbo::Streams::RedirectTurboStreamRequetTest < ActionDispatch::IntegrationTest
  test "#break_out_of_turbo_frame_and_redirect_to without Turbo-Frame header redirects to as if Mime[:html]" do
    post articles_path,
      as: :turbo_stream,
      params: {
        article: {body: "A valid value"},
        redirect_to_options: {
          status: 303,
          notice: "Notice!",
          flash: {alert: "Alert!"}
        }
      }

    assert_redirected_to articles_url, status: :see_other
    assert_equal "Notice!", flash.notice
    assert_equal "Alert!", flash.alert
  end

  test "#break_out_of_turbo_frame_and_redirect_to with Turbo-Frame header responds with turbo-stream[action=visit]" do
    post articles_path,
      as: :turbo_stream,
      headers: {"Turbo-Frame" => "frame-id"},
      params: {
        article: {body: "A valid value"},
        redirect_to_options: {
          notice: "Notice!",
          flash: {alert: "Alert!"}
        }
      }

    assert_turbo_stream action: :visit, location: articles_url, status: :created, count: 1
    assert_equal articles_url, response.location
    assert_equal "Notice!", flash.notice
    assert_equal "Alert!", flash.alert
  end

  test "#break_out_of_turbo_frame_and_redirect_to with the Turbo-Frame header preserves status: values in the 2xx range" do
    post articles_path,
      as: :turbo_stream,
      headers: {"Turbo-Frame" => "frame-id"},
      params: {
        article: {body: "A valid value"},
        redirect_to_options: {status: 200}
      }

    assert_turbo_stream action: :visit, location: articles_url, status: :ok, count: 1
  end

  test "turbo_stream requests with the turbo_frame: option replaces status: values in the 3xx range with 201 Created" do
    post articles_path,
      as: :turbo_stream,
      headers: {"Turbo-Frame" => "frame-id"},
      params: {
        article: {body: "A valid value"},
        redirect_to_options: {status: 303}
      }

    assert_turbo_stream action: :visit, location: articles_url, status: :created, count: 1
    assert_equal articles_url, response.location
  end

  test "turbo_stream requests with the turbo_frame: option preserves status: values in the 4xx range" do
    post articles_path,
      as: :turbo_stream,
      headers: {"Turbo-Frame" => "frame-id"},
      params: {
        article: {body: "A valid value"},
        redirect_to_options: {status: 403}
      }

    assert_turbo_stream action: :visit, location: articles_url, status: :forbidden, count: 1
  end

  test "turbo_stream requests with the turbo_frame: option preserves status: values in the 5xx range" do
    post articles_path,
      as: :turbo_stream,
      headers: {"Turbo-Frame" => "frame-id"},
      params: {
        article: {body: "A valid value"},
        redirect_to_options: {status: 500}
      }

    assert_turbo_stream action: :visit, location: articles_url, status: 500, count: 1
  end
end
