select 
circulating_supply, *
from staging.asset_metadata 
where circulating_supply is not null 
and circulating_supply < 1
--and chain_id != 'solana:101'
--limit 10
;
SELECT
  user_address || '-solana%3A101-' || transaction_hash AS formatted_string
FROM
  svm_staging.actions
WHERE
  chain_id = 'solana:101';
;

