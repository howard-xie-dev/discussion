# get conditions for markets in an event
   curl --request GET \
  --url 'https://api.domeapi.io/v1/polymarket/markets?status=open&event_slug=nba-atl-bos-2026-01-28' \
  --header "Authorization: Bearer $DOME_API_KEY" \
  --header "Accept: application/json" | jq -r '
  .markets[]
  | [
      .market_slug,
      .condition_id,
      .side_a.label,
      .side_b.label
    ]
  | @csv
'

# get top holders for markets/conditions
curl --request GET \
  --url 'https://data-api.polymarket.com/holders?limit=20&minBalance=1&market=0xcabe8b4a1ad5d4385a7895a64eda7c9339ca64cfed0cf8c585d4ef8a74d370a6'  | jq -r '
  ["token","proxyWallet","asset","name"],
  (.[] | .token as $t | .holders[] | [$t, .proxyWallet, .asset, (.name // "")] )
  | @csv
'

# fetch position given an address(user) and a market (condition)
curl --request GET \
  --url 'https://data-api.polymarket.com/positions?sizeThreshold=1&limit=10&sortBy=TOKENS&sortDirection=DESC&user=0xd12cfe28c79312d68855de22984e946726d3ed3d&market=0xcabe8b4a1ad5d4385a7895a64eda7c9339ca64cfed0cf8c585d4ef8a74d370a6' | jq .


