require "json"

class Articles::Show < BrowserAction
  fallback do
    post_id = ArticleIdParser.parse(context.request)
    case post_id
    in Monads::Just
      response = client_class.post_data(post_id.value!)
      page = PageConverter.new.convert(response.data)
      html ShowPage, page: page
    in Monads::Nothing, Monads::Maybe
      html(
        Errors::ParseErrorPage,
        message: "Error parsing the URL",
        status_code: 422,
        original_resource: request.resource,
      )
    end
  end

  def client_class
    if use_local?
      LocalClient
    else
      MediumClient
    end
  end

  def use_local?
    ENV.fetch("USE_LOCAL", "false") == "true"
  end
end
