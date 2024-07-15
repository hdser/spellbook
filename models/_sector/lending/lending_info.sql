{{ config(
        tags = [ 'static'],
        schema='lending',
        alias = 'info',
        post_hook='{{ expose_spells(\'["arbitrum", "avalanche_c", "base", "bnb", "celo", "ethereum", "fantom", "gnosis", "optimism", "polygon", "scroll", "zksync"]\',
                                    "sector",
                                    "lending",
                                    \'["hildobby"]\') }}')
}}

SELECT project, name, has_flashloans, x_username
FROM (VALUES
        ('euler', 'Euler', TRUE, 'eulerfinance')
    , ('synapse', 'Synapse', TRUE, 'SynapseProtocol')
    , ('fiat_dao', 'Fiat DAO', TRUE, 'fiatdao')
    , ('dydx', 'dYdX', TRUE, 'dYdX')
    , ('maker', 'Maker', TRUE, 'MakerDAO')
    , ('aave', 'Aave', TRUE, 'AaveAave')
    , ('balancer', 'Balancer', TRUE, 'Balancer')
    , ('uwulend', 'UwU Lend', TRUE, 'UwU_Lend')
    , ('agave', 'Agave', TRUE, 'Agave_lending')
    , ('granary', 'Granary Finance', TRUE, 'GranaryFinance')
    , ('spark', 'Spark', TRUE, 'sparkdotfi')
    , ('radiant', 'Radiant Capital', TRUE, 'RDNTCapital')
    , ('moola', 'Moola Market', TRUE, 'moola_market')
    , ('morpho', 'Morpho', TRUE, 'MorphoLabs')
    , ('compound', 'Compound', TRUE, 'compoundfinance')
    ) AS temp_table (project, name, has_flashloans, x_username)
