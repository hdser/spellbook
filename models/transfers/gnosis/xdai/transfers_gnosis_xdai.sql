{{ config(
    
    materialized = 'incremental',
    partition_by = ['block_month'],
    file_format = 'delta',
    incremental_strategy = 'merge',
    unique_key = ['transfer_type', 'tx_hash', 'trace_address', 'wallet_address', 'block_time'], 
    alias = 'xdai_v2',
    post_hook='{{ expose_spells(\'["gnosis"]\',
                                    "sector",
                                    "transfers",
                                    \'["hdser"]\') }}') }}

WITH 

xdai_transfers  as (
        SELECT 
            'receive' as transfer_type, 
            tx_hash,
            trace_address, 
            block_time,
            COALESCE(to,address) as wallet_address, 
            0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee as token_address,
            TRY_CAST(value as INT256) as amount_raw
        FROM 
        {{ source('gnosis', 'traces') }}
        WHERE (call_type NOT IN ('delegatecall', 'callcode', 'staticcall') OR call_type IS NULL )
        AND success
        AND TRY_CAST(value as INT256) > 0
       -- AND to IS NOT NULL 
       -- AND to != 0x0000000000000000000000000000000000000000 -- Issues in tests with tx_hash NULL, exclude address
        {% if is_incremental() %}
            AND block_time >= date_trunc('day', now() - interval '3' Day)
        {% endif %}

        UNION ALL 

        SELECT 
            'send' as transfer_type, 
            tx_hash,
            trace_address, 
            block_time,
            "from" as wallet_address, 
            0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee as token_address,
            -TRY_CAST(value as INT256) as amount_raw
        FROM 
            {{ source('gnosis', 'traces') }} 
        WHERE (call_type NOT IN ('delegatecall', 'callcode', 'staticcall') OR call_type IS NULL)
        AND success
        AND TRY_CAST(value as INT256) > 0
        AND tx_hash IS NOT NULL
       -- AND "from" IS NOT NULL 
       -- AND "from" != 0x0000000000000000000000000000000000000000 -- Issues in tests with tx_hash NULL, exclude address
        {% if is_incremental() %}
            AND t1.block_time >= date_trunc('day', now() - interval '3' Day)
        {% endif %}
),

gas_fee as (
    SELECT 
        'gas_fee' as transfer_type,
        hash as tx_hash, 
        array[index] as trace_address, 
        block_time, 
        "from" as wallet_address, 
        0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee as token_address, 
        -(CASE 
            WHEN TRY_CAST(gas_price as INT256) = 0 THEN 0
            ELSE (TRY_CAST(gas_used as INT256) * TRY_CAST(gas_price as INT256))
        END) as amount_raw
    FROM 
    {{ source('gnosis', 'transactions') }}
    {% if is_incremental() %}
        WHERE block_time >= date_trunc('day', now() - interval '3' Day)
    {% endif %}
),

block_reward AS (
    SELECT 
        'block_reward' as transfer_type,
        evt_tx_hash AS tx_hash, 
        array[evt_index] as trace_address, 
        evt_block_time AS block_time, 
        receiver AS wallet_address,
        0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee as token_address, 
        TRY_CAST(amount as INT256) as amount_raw
    FROM 
        {{ source('xdai_gnosis', 'RewardByBlock_evt_AddedReceiver') }}
    {% if is_incremental() %}
    WHERE evt_block_time >= date_trunc('day', now() - interval '3' Day)
    {% endif %}

    UNION ALL

    SELECT 
        'block_reward' as transfer_type,
        evt_tx_hash AS tx_hash, 
        array[evt_index] as trace_address, 
        evt_block_time AS block_time, 
        receiver AS wallet_address,
        0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee as token_address, 
        TRY_CAST(amount as INT256) as amount_raw
    FROM 
        {{ source('xdai_gnosis', 'BlockRewardAuRa_evt_AddedReceiver') }}
    {% if is_incremental() %}
    WHERE evt_block_time >= date_trunc('day', now() - interval '3' Day)
    {% endif %}

),

bridged AS (
    SELECT 
        'bridged' as transfer_type,
        evt_tx_hash AS tx_hash, 
        array[evt_index] as trace_address, 
        evt_block_time AS block_time, 
        recipient AS wallet_address,
        0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee as token_address, 
        TRY_CAST(value as INT256) as amount_raw
    FROM 
        {{ source('xdai_bridge_gnosis', 'HomeBridgeErcToNative_evt_UserRequestForSignature') }}
    {% if is_incremental() %}
        WHERE block_time >= date_trunc('day', now() - interval '3' Day)
    {% endif %}

)

SELECT
    'gnosis' as blockchain, 
    transfer_type,
    tx_hash, 
    trace_address,
    block_time,
    CAST(date_trunc('month', block_time) as date) as block_month,
    wallet_address, 
    token_address, 
    amount_raw
FROM 
xdai_transfers

UNION ALL 

SELECT 
    'gnosis' as blockchain, 
    transfer_type,
    tx_hash, 
    trace_address,
    block_time,
    CAST(date_trunc('month', block_time) as date) as block_month,
    wallet_address, 
    token_address, 
    amount_raw
FROM 
gas_fee

UNION ALL 

SELECT 
    'gnosis' as blockchain, 
    transfer_type,
    tx_hash, 
    trace_address,
    block_time,
    CAST(date_trunc('month', block_time) as date) as block_month,
    wallet_address, 
    token_address, 
    amount_raw
FROM 
block_reward

/*
UNION ALL 

SELECT 
    'gnosis' as blockchain, 
    transfer_type,
    tx_hash, 
    trace_address,
    block_time,
    CAST(date_trunc('month', block_time) as date) as block_month,
    wallet_address, 
    token_address, 
    amount_raw
FROM 
bridged
*/