# Load .env file before any other config or app code
require "lucky_env"
LuckyEnv.load?(".env")

# Require your shards here
require "avram"
require "lucky"
require "authentic"
require "monads"
