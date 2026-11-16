require "test_helper"

class DiscussionPostsHelperTest < ActionView::TestCase
  test "renders markdown formatting" do
    result = render_markdown("**Hello**")

    assert_includes result, "<strong>Hello</strong>"
  end

  test "does not render unsafe HTML" do
    result = render_markdown('<script>alert("XSS")</script>')

    assert_not_includes result, "<script>"
    assert_not_includes result, "alert"
  end
end
