class Home::IndexPage < MainLayout
  def page_title
    "Scribe"
  end

  def content
    h1 "Scribe"
    h2 "An alternative frontend to Medium"
    para do
          a(
            "Here's an example",
            href: "/@ftrain/big-data-small-effort-b62607a43a8c"
          )
        end
    article do
      section do
        h2 "How-To"
        para do
          text "To view a Medium post simply replace "
          code "medium.com", class: "highlight"
          text " with "
          code app_domain, class: "highlight"
        end
        para do
          text "If the URL is: "
          code do
            span "medium.com", class: "highlight"
            text "/@user/my-post-09a6af907a2"
          end
          text " change it to "
          code do
            span app_domain, class: "highlight"
            text "/@user/my-post-09a6af907a2"
          end
        end
      end
      section do
        h2 "How-To Automatically"
        para do
          text "If you don't want to manually change the URL every time, you can use an extension to do it for you. "
          a "This extension", href: "https://einaregilsson.com/redirector/"
          text " works well across most browsers."
        end
        para "Once installed, create a new redirect with the following settings:"
        ul do
          li do
            strong "Description: "
            code "Medium -> Scribe"
          end
          li do
            strong "Example URL: "
            code "https://medium.com/@user/post-123456abcdef"
          end
          li do
            strong "Include pattern: "
            code ".*medium.com/(.*)"
          end
          li do
            strong "Redirect to: "
            code "https://scribe.rip/$1"
          end
          li do
            strong "Pattern type: "
            code "( ) Wildcard   (•) Regular Expression"
          end
        end
        para "Visiting any medium.com site (including user.medium.com subdomains) should now redirect to Scribe instead!"
      end
      section do
        footer do
          para do
            a "Source code", href: "https://git.sr.ht/~edwardloveall/scribe"
          end
        end
      end
    end
  end

  def app_domain
    URI.parse(Home::Index.url).normalize
      .to_s
      .sub(/\/$/, "")
      .sub(/^https?:\/\//, "")
  end
end
