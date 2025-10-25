WITH grouped_actions AS (
    SELECT 
        a.user_address,
        a.chain_id,
        a.transaction_hash,
        a.block_time,
        jsonb_agg(
            jsonb_build_object(
                'category', a.category,
                'label', a.label,
                'block_time', a.block_time,
                'block_hash', a.block_hash,
                'tx_from_address', a.tx_from_address,
                'tx_to_address', a.tx_to_address,
                'contract_address', a.contract_address,
                'is_event', a.is_event,
                'log_index', a.log_index,
                'trace_index', a.trace_index,
                'extra_fields', a.extra_fields
            ) ORDER BY a.block_time DESC, a.uniqueness_index
        ) AS action_items,
        jsonb_agg(
            jsonb_build_object(
                'asset_id', am.asset_id,
                'contract_address', am.contract_address,
                'chain_id', am.chain_id,
                'token_id', am.token_id,
                'asset_type', am.asset_type,
                'name', am.name,
                'symbol', am.symbol,
                'decimals', am.decimals,
                'verified', am.verified,
                'creator_address', am.creator_address,
                'created_timestamp', am.created_timestamp,
                'image_url', am.image_url,
                'image_previews', am.image_previews,
                'image_properties', am.image_properties,
                'predominant_color', am.predominant_color,
                'circulating_supply', am2.circulating_supply
            ) ORDER BY a.block_time DESC, a.uniqueness_index
        ) AS nft_asset_items,
        jsonb_agg(
            jsonb_build_object(
                'asset_id', am2.asset_id,
                'contract_address', am2.contract_address,
                'chain_id', am2.chain_id,
                'token_id', am2.token_id,
                'asset_type', am2.asset_type,
                'name', am2.name,
                'symbol', am2.symbol,
                'decimals', am2.decimals,
                'verified', am2.verified,
                'creator_address', am2.creator_address,
                'created_timestamp', am2.created_timestamp,
                'image_url', am2.image_url,
                'image_previews', am2.image_previews,
                'image_properties', am2.image_properties,
                'predominant_color', am2.predominant_color,
                'circulating_supply', am2.circulating_supply
            ) ORDER BY a.block_time DESC, a.uniqueness_index
        ) AS token_buy_side_asset_items,
        jsonb_agg(
            jsonb_build_object(
                'asset_id', am3.asset_id,
                'contract_address', am3.contract_address,
                'chain_id', am3.chain_id,
                'token_id', am3.token_id,
                'asset_type', am3.asset_type,
                'name', am3.name,
                'symbol', am3.symbol,
                'decimals', am3.decimals,
                'verified', am3.verified,
                'creator_address', am3.creator_address,
                'created_timestamp', am3.created_timestamp,
                'image_url', am3.image_url,
                'image_previews', am3.image_previews,
                'image_properties', am3.image_properties,
                'predominant_color', am3.predominant_color,
                'circulating_supply', am3.circulating_supply
            ) ORDER BY a.block_time DESC, a.uniqueness_index
        ) AS token_sell_side_asset_items
    FROM evm_staging.actions AS a
    LEFT JOIN staging.asset_metadata AS am
        ON (a.extra_fields->>'nft_info')::jsonb->>'token_asset_id' = am.asset_id
    LEFT JOIN staging.asset_metadata AS am2
        ON (((a.extra_fields->>'swap_info')::jsonb->>'tokens_bought')::jsonb)[0]->>'token_asset_id' = am2.asset_id
    LEFT JOIN staging.asset_metadata AS am3
        ON (((a.extra_fields->>'swap_info')::jsonb->>'tokens_sold')::jsonb)[0]->>'token_asset_id' = am3.asset_id
    WHERE 1=1
      AND (a.user_address, a.chain_id, a.transaction_hash) = (
          '0x0000000000001ff3684f28c67538d4d072c22734',
          'eip155:8453',
          '0x6a842727a76ffdef123c0a9d3cf7097071a3b0fa2976ac603b99f45c4b445908'
      )
      AND a.label IN ('nft_buy', 'nft_mint', 'nft_sell', 'token_buy', 'token_sell')
    GROUP BY a.user_address, a.chain_id, a.transaction_hash, a.block_time
)
SELECT 
    user_address,
    chain_id,
    transaction_hash,
    block_time,
    action_items,
    nft_asset_items,
    token_buy_side_asset_items,
    token_sell_side_asset_items,
    jsonb_array_length(action_items) AS action_item_length
FROM grouped_actions
ORDER BY block_time DESC, user_address, chain_id, transaction_hash
LIMIT 100;
