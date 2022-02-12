require "json"

class Articles::Show < BrowserAction
  fallback do
    post_id = maybe_post_id(context.request)
    case post_id
    in Monads::Just
      response = client_class.post_data(post_id.value!)
      page = PageConverter.new.convert(response.data)
      html ShowPage, page: page
    in Monads::Nothing, Monads::Maybe
      html(
        Errors::ParseErrorPage,
        message: "Error parsing the URL",
        status_code: 500,
        original_path: request.path,
      )
    end
  end

  def maybe_post_id(request : HTTP::Request)
    from_params = post_id_from_params(request.query_params)
    from_path = post_id_from_path(request.path)
    from_path.or(from_params)
  end

  def post_id_from_path(request_path : String)
    Monads::Try(Regex::MatchData)
      .new(->{ request_path.match(/([0-9a-f]+)$/i) })
      .to_maybe
      .fmap(->(matches : Regex::MatchData) { matches[1] })
  end

  def post_id_from_params(params : URI::Params)
    maybe_uri = Monads::Try(String)
      .new(->{ params["redirectUrl"] })
      .to_maybe
      .fmap(->(url : String) { URI.parse(url) })
      .bind(->(uri : URI) { post_id_from_path(uri.path) })
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
