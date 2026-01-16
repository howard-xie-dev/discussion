# step 1, fetch event by slug via polymarket API, here we get its markets and conditions
curl -s \
  --request GET \
  --url "https://gamma-api.polymarket.com/events/slug/super-bowl-champion-2026-731" \
  --header "Authorization: Bearer $DOME_API_KEY" \
  --header "Accept: application/json" | jq -r '
  . as $event
  | $event.markets[]
  | [
      $event.slug,
      .slug,
      .conditionId,
    ]
  | @csv
'

# Alternative, better solution, use dome API's get markets by event slug API to fetch markets
 curl --request GET \
  --url 'https://api.domeapi.io/v1/polymarket/markets?status=open&event_slug=super-bowl-champion-2026-731' \
  --header "Authorization: Bearer $DOME_API_KEY" \
  --header "Accept: application/json" | jq -r '
  .markets[]
  | [
      .event_slug,
      .market_slug,
      .condition_id,
      .status
    ]
  | @csv
'

# step 2, fetch candlesticks by condition, with default 1 day zoom and 1 min interval
 curl -sS \
  --url "https://api.domeapi.io/v1/polymarket/candlesticks/0x17815081230e3b9c78b098162c33b1ffa68c4ec29c123d3d14989599e0c2e113?start_time=$(date -v-1d +%s)&end_time=$(date +%s)&interval=1" \
  --header "Authorization: Bearer ${DOME_API_KEY}" \
| jq . | less

# fetch 2 minutes zoom with 1 min interval, exactly two data points
 curl -sS \
  --url "https://api.domeapi.io/v1/polymarket/candlesticks/0x17815081230e3b9c78b098162c33b1ffa68c4ec29c123d3d14989599e0c2e113?start_time=$(date -v-2M +%s)&end_time=$(date +%s)&interval=1" \
  --header "Authorization: Bearer ${DOME_API_KEY}" \
| jq . 

# fetch 2 days with 1 day interval, if market is resolved before window range, there is no data
 curl -sS \
  --url "https://api.domeapi.io/v1/polymarket/candlesticks/0xa0eafdfa7da17483796f77f4b287d28834ab97db4a9a6e999b52c1ba239bc2f3?start_time=$(date -v-2d +%s)&end_time=$(date +%s)&interval=1440" \
  --header "Authorization: Bearer ${DOME_API_KEY}" \
| jq -r '
  ["token_id","side","end_period_ts","yes_ask.close","yes_bid.close"],
  (
    .candlesticks[]
    | .[1] as $meta
    | .[0][]
    | [
        $meta.token_id,
        $meta.side,
        .end_period_ts,
        .yes_ask.close,
        .yes_bid.close
      ]
  )
  | @csv'






