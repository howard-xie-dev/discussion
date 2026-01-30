-- curl --location 'http://staging-actions-service-alb-403269508.us-east-1.elb.amazonaws.com/action/0x9e6dbfec934b50249a43fb991348ca1747f3c2cb-eip155:137-order:0x0e679e30d422c5aa3b889f88e0a4df4078a827c94b71d7dd954a33e0057a7f07' \
-- --header 'x-request-id: 0d9d21fb-e26d-41f5-9842-a5ba221cacc8'



SELECT
    user_address,
    chain_id,
    transaction_hash,
    -- prediction_trade_info scalars
    extra_fields -> 'prediction_trade_info' ->> 'market_id' AS market_id,
    extra_fields -> 'prediction_trade_info' ->> 'market_title' AS market_title,
    extra_fields -> 'prediction_trade_info' ->> 'order_hash' AS order_hash,
    extra_fields -> 'prediction_trade_info' ->> 'outcome_id' AS outcome_id,
    extra_fields -> 'prediction_trade_info' ->> 'outcome_title' AS outcome_title,
    extra_fields -> 'prediction_trade_info' ->> 'outcome_type' AS outcome_type,
    extra_fields -> 'prediction_trade_info' ->> 'token_label' AS token_label,
    extra_fields -> 'prediction_trade_info' ->> 'condition_id' AS condition_id,
    extra_fields -> 'prediction_trade_info' ->> 'clob_token_id' AS clob_token_id,
    extra_fields -> 'prediction_trade_info' ->> 'side' AS side,
    (extra_fields -> 'prediction_trade_info' ->> 'odds')::int AS odds,
    (extra_fields -> 'prediction_trade_info' ->> 'price_usd')::numeric AS price_usd,
    extra_fields -> 'prediction_trade_info' ->> 'user_proxy_address' AS user_proxy_address,
    (extra_fields -> 'prediction_trade_info' ->> 'num_outcome_contracts_traded')::numeric AS num_outcome_contracts_traded,
    -- prediction_trade_info nested objects (full JSONB)
    extra_fields -> 'prediction_trade_info' -> 'prediction_market' AS prediction_market,
    extra_fields -> 'prediction_trade_info' -> 'prediction_event' AS prediction_event,
    extra_fields -> 'prediction_trade_info' -> 'prediction_outcome' AS prediction_outcome
FROM evm_staging.actions
WHERE label IN ('prediction_buy', 'prediction_sell')
and extra_fields -> 'prediction_trade_info' -> 'prediction_event' ->> 'id' = 'nba-por-nyk-2026-01-30'
and user_address = '0x9e6dbfec934b50249a43fb991348ca1747f3c2cb'
and transaction_hash = '0x0e679e30d422c5aa3b889f88e0a4df4078a827c94b71d7dd954a33e0057a7f07'
;


-[ RECORD 1 ]----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
user_address                 | 0x9e6dbfec934b50249a43fb991348ca1747f3c2cb
chain_id                     | eip155:137
transaction_hash             | 0x0e679e30d422c5aa3b889f88e0a4df4078a827c94b71d7dd954a33e0057a7f07
market_id                    | nba-por-nyk-2026-01-30
market_title                 | Trail Blazers vs. Knicks
order_hash                   | 0x0e679e30d422c5aa3b889f88e0a4df4078a827c94b71d7dd954a33e0057a7f07
outcome_id                   |
outcome_title                |
outcome_type                 |
token_label                  |
condition_id                 | 0xc47422ece69ef00d586ecdb6170e5c39946dcce86ec61b0ab02dfe6b921fd1ff
clob_token_id                | 24328506897085435730742182813071940627870618571756588852047109911777641794479
side                         | BUY
odds                         | 29
price_usd                    | 0.29
user_proxy_address           | 0xc1b550b4a09e02ff722d1f372374ca3c708f2e74
num_outcome_contracts_traded | 8
prediction_market            | {"id": "nba-por-nyk-2026-01-30:trail-blazers", "image": {"url": "https://polymarket-upload.s3.us-east-2.amazonaws.com/super+cool+basketball+in+red+and+blue+wow.png"}, "title": "Trail Blazers", "status": "active", "event_id": "nba-por-nyk-2026-01-30"}
prediction_event             | {"id": "nba-por-nyk-2026-01-30", "image": {"url": "https://polymarket-upload.s3.us-east-2.amazonaws.com/super+cool+basketball+in+red+and+blue+wow.png"}, "title": "Trail Blazers vs. Knicks", "event_type": "polymarket"}
prediction_outcome           | {"type": null, "title": "", "outcome_id": null, "clob_token_id": "24328506897085435730742182813071940627870618571756588852047109911777641794479"}




