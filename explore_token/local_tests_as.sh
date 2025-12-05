 curl --location 'http://localhost:8000/assets/tokens/trending?min_token_age=5&min_token_age_unit=m&max_token_age=30&max_token_age_unit=d' | jq '.data[].created_date'

