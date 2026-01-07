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

# list all series 
curl --request GET \
  --url "https://prediction-markets-api.dflow.net/api/v1/series" \
  --header "x-api-key: pRUpP2gm6MocIOMN7ctj" \
| jq -r '.series[] | "\(.ticker)\t\(.title)"'


# look for a specific series given its ticker 
 curl --request GET \
  --url "https://prediction-markets-api.dflow.net/api/v1/series/SENATEMD" \
  --header "x-api-key: pRUpP2gm6MocIOMN7ctj"


#look for events with nested markets -- I.E. look for all markets associated to an event
 curl -sS \
  "https://prediction-markets-api.dflow.net/api/v1/event/KXNFLGAME-26JAN04LACDEN?withNestedMarkets=true" \
  -H "x-api-key: pRUpP2gm6MocIOMN7ctj"

# entity info aggregation
curl -sS \
  "https://prediction-markets-api.dflow.net/api/v1/events?withNestedMarkets=true&limit=2" \
  -H "x-api-key: pRUpP2gm6MocIOMN7ctj" \
| jq -r '
  .events[]
  | . as $e
  | ($e.markets // [])[]
  | [
      ($e.series_ticker // $e.seriesTicker // ""),
      ($e.ticker // ""),
      ($e.title // ""),
      (.ticker // ""),
      (.title // ""),
      (.status // ""),
      (.volume // .volumeUsd // .volume_usd // "" | tostring),
      (.open_interest // .openInterest // "" | tostring)
    ]
  | @tsv
' \
| awk 'BEGIN{print "series_ticker\tevent_ticker\tevent_title\tmarket_ticker\tmarket_title\tmarket_status\tmarket_volume\topen_interest"} {print}' \
| column -t -s $'\t'


curl -sS \
  "https://prediction-markets-api.dflow.net/api/v1/events?withNestedMarkets=true&limit=2" \
  -H "x-api-key: pRUpP2gm6MocIOMN7ctj" \
| jq -r '
  .events[]
  | . as $e
  | ($e.markets // [])[]
  | [($e.series_ticker // $e.seriesTicker // ""), ($e.ticker // ""), (.ticker // "")]
  | @tsv
' \
| awk 'BEGIN{print "series_ticker\tevent_ticker\tmarket_ticker"} {print}' \
| column -t -s $'\t'




