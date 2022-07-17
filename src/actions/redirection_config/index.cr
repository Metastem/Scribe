class RedirectionConfig::Index < Lucky::Action
  include Lucky::ProtectFromForgery
  include Lucky::EnforceUnderscoredRoute
  include Lucky::SecureHeaders::DisableFLoC

  default_format :json

  get "/redirection_config" do
    data(
      data: config_json,
      content_type: "application/json",
      disposition: "attachment",
      filename: "redirector-config.json"
    )
  end

  private def config_json
    <<-JSON
      {
        "createdBy": "Redirector v3.5.3",
        "createdAt": "2022-07-17T00:00:00.000Z",
        "redirects": [
          {
            "description": "Medium -> Scribe",
            "exampleUrl": "https://medium.com/@user/post-123456abcdef",
            "exampleResult": "https://#{app_domain}/@user/post-123456abcdef",
            "error": null,
            "includePattern": "^https?://(?:.*\\.)*(?<!(link\\.|cdn\\-images\\-\\d+\\.))medium\\.com(/.*)?$",
            "excludePattern": "",
            "patternDesc": "",
            "redirectUrl": "https://#{app_domain}$2",
            "patternType": "R",
            "processMatches": "noProcessing",
            "disabled": false,
            "grouped": false,
            "appliesTo": [
              "main_frame",
              "sub_frame",
              "xmlhttprequest",
              "history",
              "other"
            ]
          }
        ]
      }
    JSON
  end

  private def app_domain
    URI.parse(Home::Index.url).normalize
      .to_s
      .sub(/\/$/, "")
      .sub(/^https?:\/\//, "")
  end
end
