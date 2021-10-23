class Faq::IndexPage < MainLayout
  def page_title
    "Scribe FAQ"
  end

  def content
    h1 "Frequently Asked Questions"
    article do
      auto_redirect
      why_would_i_want_this
      mount Shared::LayoutFooter
    end
  end

  private def auto_redirect
    section do
      h2 "How-to Automatically Redirect Medium Articles"
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
          code "^https?://(?:.*\\.)*(?<!link\\.)medium\\.com(/.*)?$"
        end
        li do
          strong "Redirect to: "
          code "https://"
          code app_domain
          code "$1"
        end
        li do
          strong "Pattern type: "
          code "( ) Wildcard   (•) Regular Expression"
        end
      end
      para "Visiting any medium.com site (including user.medium.com subdomains) should now redirect to Scribe instead!"
    end
  end

  private def why_would_i_want_this
    section do
      h2 "Why Would I Want to Use This?"
      para do
        text "There are a number of potential reasons:"
        ul do
          li do
            text "You believe in an "
            a "open web", href: "http://scripting.com/liveblog/users/davewiner/2016/01/20/0900.html"
          end
          li do
            text "You believe more in "
            a "the author", href: "https://www.manton.org/2016/01/15/silos-as-shortcuts.html"
            text " than the platform"
          end
          li do
            text "You "
            a "don't like the reading experience", href: "https://twitter.com/BretFisher/status/1206766086961745920"
            text " that Medium provides"
          end
          li do
            text "You object to "
            a "Medium's extortionist business tactics", href: "https://www.cdevn.com/why-medium-actually-sucks/"
          end
          li do
            text "You're concerned about how "
            a "Medium uses your data", href: "https://tosdr.org/en/service/1003"
          end
          li do
            a "Other reasons", href: "https://nomedium.dev/"
          end
        end
      end
    end
  end
end
