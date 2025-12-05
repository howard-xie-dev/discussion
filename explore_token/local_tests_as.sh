 curl --location 'http://localhost:8000/assets/tokens/trending?min_token_age=5m&max_token_age=30d' | jq '.data[].created_date'

 curl --location 'http://localhost:8000/assets/tokens/trending?min_wallet_age=5h&max_wallet_age=30d&limit=2' | jq '.data[].created_date'
