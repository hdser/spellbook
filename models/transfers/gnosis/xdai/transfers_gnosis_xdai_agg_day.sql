{{ config(
        
        alias = 'xdai_agg_day',
        partition_by = ['block_month'],
        materialized ='incremental',
        file_format ='delta',
        incremental_strategy='merge',
        unique_key = ['block_day', 'wallet_address', 'counterparty', 'token_address']
        )
}}

select
    tr.blockchain,
    CAST(date_trunc('day', tr.block_time) as date) as block_day,
    block_month,
    tr.wallet_address,
    tr.counterparty,
    tr.token_address,
    'xDAI' as symbol,
    sum(tr.amount_raw) as amount_raw,
    sum(tr.amount_raw / power(10, 18)) as amount
FROM 
{{ ref('transfers_gnosis_xdai') }} tr
{% if is_incremental() %}
-- this filter will only be applied on an incremental run
WHERE tr.block_time >= date_trunc('day', now() - interval '3' Day)
{% endif %}
GROUP BY 1, 2, 3, 4, 5, 6, 7