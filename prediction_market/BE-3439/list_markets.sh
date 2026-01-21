 curl --request GET \
  --url 'https://api.domeapi.io/v1/polymarket/markets?status=open&event_slug=nba-chi-min-2026-01-22' \
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


 curl --request GET \
  --url 'https://api.domeapi.io/v1/polymarket/markets?status=open&event_slug=nba-cle-cha-2026-01-21' \
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


############### polymarket

curl -s "https://gamma-api.polymarket.com/events/slug/nba-chi-min-2026-01-22" \
  | jq -r '
    .markets[]
    | "\(.id)\t\(.slug)\t\(.question)\t\(.active)"
  '

  
curl -s "https://gamma-api.polymarket.com/events/slug/nba-cle-cha-2026-01-21" \
  | jq -r '
    .markets[]
    | "\(.id)\t\(.slug)\t\(.question)\t\(.active)"
  '
