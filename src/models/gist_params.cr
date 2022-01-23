class GistParams
  class MissingGistId < Exception
  end

  GIST_ID_REGEX = /[a-f\d]+$/i

  getter id : String
  getter filename : String?

  def self.extract_from_url(href : String)
    uri = URI.parse(href)
    maybe_id = Monads::Try(Regex::MatchData)
      .new(->{ uri.path.match(GIST_ID_REGEX) })
      .to_maybe
      .fmap(->(matches : Regex::MatchData) { matches[0] })
    case maybe_id
    in Monads::Just
      id = maybe_id.value!
    in Monads::Nothing, Monads::Maybe
      raise MissingGistId.new(href)
    end

    filename = uri.query_params["file"]?

    new(id: id, filename: filename)
  end

  def initialize(@id : String, @filename : String?)
  end
end
