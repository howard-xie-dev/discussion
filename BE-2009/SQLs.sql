WITH grouped_actions AS (
    SELECT
        user_address,
        chain_id,
        transaction_hash,
        category,
        MAX(block_time) as block_time,
        MAX(process_time) as process_time,
        jsonb_agg(
            jsonb_build_object(
                'category', category,
                'label', label,
                'block_time', block_time,
                'block_hash', block_hash,
                'tx_from_address', tx_from_address,
                'tx_to_address', tx_to_address,
                'contract_address', contract_address,
                'is_event', is_event,
                'log_index', log_index,
                'trace_index', trace_index,
                'extra_fields', extra_fields
            ) ORDER BY block_time DESC, uniqueness_index
        ) as action_items
    FROM evm_staging.actions AS actions
    WHERE 1=1
    AND transaction_hash IN (
       '0xefea8aa8756c900c50ea5ff98ab7d5ee295ffd24ce86955e02859645e738d7b1',
       '0x6b8e12b9f2a0fcaa5e29ef10b8615d96744e68623363c20979b99f9cf8314b5b'
    )
    AND label IN ('nft_buy', 'nft_mint', 'nft_sell', 'token_buy', 'token_sell')
    GROUP BY 1,2,3,4
)
SELECT
    user_address,
    grouped_actions.chain_id,
    transaction_hash,
    block_time,
    process_time,
    grouped_actions.category,
    action_items,
    jsonb_array_length(action_items) as action_item_length,
    am.processed_at as asset_metadata_processed_at,
    -- NFT metadata fields (only populated when category = 'nft')
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'nft') THEN am.name END as nft_token_name,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'nft') THEN am.symbol END as nft_token_symbol,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'nft') THEN am.decimals END as nft_token_decimals,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'nft') THEN am.image_url END as nft_token_image_url,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'nft') THEN am.image_previews END as nft_token_image_previews,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'nft') THEN am.image_properties END as nft_token_image_properties,
    -- Token metadata fields (only populated when category = 'token')
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am.name END as sell_token_name,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am.symbol END as sell_token_symbol,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am.decimals END as sell_token_decimals,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am.image_url END as sell_token_image_url,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am.image_previews END as sell_token_image_previews,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am.image_properties END as sell_token_image_properties,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am2.name END as buy_token_name,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am2.symbol END as buy_token_symbol,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am2.decimals END as buy_token_decimals,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am2.image_url END as buy_token_image_url,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am2.image_previews END as buy_image_previews,
    CASE WHEN (am.processed_at > process_time AND grouped_actions.category = 'token') THEN am2.image_properties END as buy_token_image_properties
FROM grouped_actions
LEFT JOIN staging.asset_metadata as am ON (
    grouped_actions.category = 'nft' AND action_items[0]->'extra_fields'->'nft_info'->>'token_address' = am.contract_address
    OR
    grouped_actions.category = 'token' AND ((action_items[0]->'extra_fields'->'swap_info'->>'tokens_sold')::jsonb)[0]->>'token_address' = am.contract_address
)
LEFT JOIN staging.asset_metadata as am2 ON (
    grouped_actions.category = 'token' AND ((action_items[0]->'extra_fields'->'swap_info'->>'tokens_bought')::jsonb)[0]->>'token_address' = am2.contract_address
)
ORDER BY block_time DESC, user_address, chain_id, transaction_hash
LIMIT 10
