 curl --request GET \
  --url 'https://api.domeapi.io/v1/polymarket/markets?status=open&event_slug=nba-bkn-nyk-2026-01-21' \
  --header "Authorization: Bearer $DOME_API_KEY" \
  --header "Accept: application/json" | jq -r '
  .markets[]
  | [
      .event_slug,
      .market_slug,
      .condition_id,
      .status,
      .title,
      .side_a.label,
      .side_b.label
    ]
  | @csv
'
