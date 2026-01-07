# fetch all markets and fetch their tickers
curl --request GET \
  --url https://prediction-markets-api.dflow.net/api/v1/markets \
  --header "x-api-key: pRUpP2gm6MocIOMN7ctj" \
| jq -r '.markets[] | "\(.ticker)\t\(.eventTicker)"'

# fetch all events and their tickers
curl --request GET \
  --url https://prediction-markets-api.dflow.net/api/v1/events \
  --header "x-api-key: pRUpP2gm6MocIOMN7ctj" \
| jq -r '.events[] | "\(.ticker)\t\(.title)"'

# fetch market info given its ticker
 curl --request GET \
  --url https://prediction-markets-api.dflow.net/api/v1/market/KXNFLGAME-25SEP18MIABUF-BUF  \
  --header "x-api-key: pRUpP2gm6MocIOMN7ctj"

# fetch event info given its ticker
 curl --request GET \
  --url https://prediction-markets-api.dflow.net/api/v1/event/KXNFLGAME-26JAN04LACDEN \
  --header "x-api-key: pRUpP2gm6MocIOMN7ctj"

