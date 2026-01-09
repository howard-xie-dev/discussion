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


curl -s \
  --url "https://api.domeapi.io/v1/polymarket/markets?limit=10" \
  --header "Authorization: Bearer $DOME_API_KEY" \
| jq -r '.markets[].market_slug'


 curl -s \
  --url "https://api.domeapi.io/v1/polymarket/markets?highest-temperature-in-nyc-on-january-11-41forbelow" \
  --header "Authorization: Bearer $DOME_API_KEY" \
| jq '.markets[0]'


 curl -s \
  --url "https://gamma-api.polymarket.com/markets/slug/highest-temperature-in-nyc-on-january-11-41forbelow" \
  --header "Authorization: Bearer $DOME_API_KEY" \
| jq '{market_slug: .slug, conditionId: .conditionId, events: (.events | map({id, slug, title}))}'


curl -s \
  --url "https://data-api.polymarket.com/positions?user=0x607f420d584632934fc6e351bf55041446c976a2" \
  --header "Authorization: Bearer $DOME_API_KEY" \
| jq .


curl -s \
  --url "https://data-api.polymarket.com/closed-positions?user=0x607f420d584632934fc6e351bf55041446c976a2" \
  --header "Authorization: Bearer $DOME_API_KEY" \
| jq .



 curl -s "https://gamma-api.polymarket.com/events/slug/will-biden-complete-his-term-as-president" \
| jq -r '.markets[].conditionId'

 curl -s "https://data-api.polymarket.com/holders?market=0xd1e760f57415093db2e8378b79fe37ec8dc9ad09ee57f6f0cdc2468ae29fea23&limit=20&minBalance=1" \
| jq -r '.[].holders[].proxyWallet' \
| sort -u


