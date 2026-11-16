module DiscussionPostsHelper
  def render_markdown(content)
    html = Commonmarker.to_html(
      content.to_s,
      options: {
        render: {
          unsafe: false
        }
      }
    )

    sanitize(
      html,
      tags: %w[p br strong em del blockquote ul ol li h1 h2 h3 h4 h5 h6 pre code a hr table thead tbody tr th td],
      attributes: %w[href title]
    )
  end
end
