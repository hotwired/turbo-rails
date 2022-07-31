require "test_helper"

class Turbo::Streams::RedirectTest < ActionDispatch::IntegrationTest
  test "html requests respond with a redirect HTTP status" do
    post articles_path, params: {
      turbo_frame: "_top", status: 303,
      article: {body: "A valid value"}
    }

    assert_response :see_other
    assert_redirected_to articles_url
    assert_equal "Created!", flash[:notice]
  end

  test "html redirects write to the flash" do
    post articles_path, params: {
      turbo_frame: "_top", flash: {alert: "Wrote to alert:"},
      article: {body: "A valid value"}
    }

    assert_equal "Wrote to alert:", flash[:alert]
  end

  test "html redirects write to alert" do
    post articles_path, params: {
      turbo_frame: "_top", alert: "Wrote to alert:",
      article: {body: "A valid value"}
    }

    assert_equal "Wrote to alert:", flash[:alert]
  end

  test "html redirects write to notice" do
    post articles_path, params: {
      turbo_frame: "_top", notice: "Wrote to notice:",
      article: {body: "A valid value"}
    }

    assert_equal "Wrote to notice:", flash[:notice]
  end

  test "turbo_stream requests with the turbo_frame: option responds with a redirect Turbo Stream" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top",
      article: {body: "A valid value"}
    }

    assert_turbo_stream action: :append, targets: "head", status: :created do
      assert_select "script[data-turbo-cache=false]", count: 1 do |script|
        assert_includes script.text, %(frame: "_top",)
        assert_not_includes script.text, %(action:)
      end
    end
    assert_equal articles_url, response.location
  end

  test "turbo_stream requests with the turbo_frame: and turbo_action: options responds with a redirect Turbo Stream" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top",
      turbo_action: "replace",
      article: {body: "A valid value"}
    }

    assert_turbo_stream action: :append, targets: "head", status: :created do
      assert_select "script[data-turbo-cache=false]", count: 1 do |script|
        assert_includes script.text, %(frame: "_top",)
        assert_includes script.text, %(action: "replace",)
      end
    end
    assert_equal articles_url, response.location
  end

  test "turbo_stream requests with the turbo_frame: option preserves status: values in the 2xx range" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top", status: 200,
      article: { body: "A valid value" }
    }

    assert_response 200
  end

  test "turbo_stream requests with the turbo_frame: option replaces status: values in the 3xx range with 201 Created" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top", status: 303,
      article: { body: "A valid value" }
    }

    assert_response 201
  end

  test "turbo_stream requests with the turbo_frame: option preserves status: values in the 4xx range" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top", status: 403,
      article: { body: "A valid value" }
    }

    assert_response 403
  end

  test "turbo_stream requests with the turbo_frame: option preserves status: values in the 5xx range" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top", status: 500,
      article: { body: "A valid value" }
    }

    assert_response 500
  end

  test "turbo_stream requests without the turbo_frame: option respond with a redirect HTTP status" do
    post articles_path, as: :turbo_stream, params: {
      article: { body: "A valid value" }
    }

    assert_redirected_to articles_url
  end

  test "turbo_stream redirects write to the flash" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top", flash: {alert: "Wrote to alert:"},
      article: {body: "A valid value"}
    }

    assert_equal "Wrote to alert:", flash[:alert]
  end

  test "turbo_stream redirects write to alert" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top", alert: "Wrote to alert:",
      article: {body: "A valid value"}
    }

    assert_equal "Wrote to alert:", flash[:alert]
  end

  test "turbo_stream redirects write to notice" do
    post articles_path, as: :turbo_stream, params: {
      turbo_frame: "_top", notice: "Wrote to notice:",
      article: {body: "A valid value"}
    }

    assert_equal "Wrote to notice:", flash[:notice]
  end
end
