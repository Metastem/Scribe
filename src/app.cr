require "./shards"

# Load the asset manifest
Lucky::AssetHelpers.load_manifest "public/mix-manifest.json"

require "./version"
require "../config/server"
require "../config/**"
require "./constants"
require "./models/base_model"
require "./models/mixins/**"
require "./models/**"
require "./queries/mixins/**"
require "./queries/**"
require "./operations/mixins/**"
require "./operations/**"
require "./serializers/base_serializer"
require "./serializers/**"
require "./actions/mixins/**"
require "./actions/**"
require "./components/base_component"
require "./components/**"
require "./classes/**"
require "./clients/**"
require "./pages/**"
require "../db/migrations/**"
require "./app_server"
