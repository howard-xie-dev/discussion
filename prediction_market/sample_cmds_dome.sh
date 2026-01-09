 curl -s \
  --request GET \
  --url "https://gamma-api.polymarket.com/events?limit=10" \
  --header "Authorization: Bearer $DOME_API_KEY" \
  --header "Accept: application/json" | jq -r '.[].slug'

