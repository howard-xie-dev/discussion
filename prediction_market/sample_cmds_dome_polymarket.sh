 curl -s \
  --request GET \
  --url "https://gamma-api.polymarket.com/events?limit=10" \
  --header "Authorization: Bearer $DOME_API_KEY" \
  --header "Accept: application/json" | jq -r '.[].slug'


curl -s \
  --request GET \
  --url "https://gamma-api.polymarket.com/events/slug/nba-will-the-mavericks-beat-the-grizzlies-by-more-than-5pt5-points-in-their-december-4-matchup" \
  --header "Authorization: Bearer $DOME_API_KEY" \
  --header "Accept: application/json"


