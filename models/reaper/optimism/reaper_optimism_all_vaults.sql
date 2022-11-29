{{config(alias='all_vaults', materialized='table', file_format = 'delta', tags=['static'])}}
SELECT LOWER(contract_address) AS contract_address, symbol, decimals
FROM
(
  VALUES 
  ('0x39FdE572a18448F8139b7788099F0a0740f51205','OATH', 18)
  ,('0x1891A76d191d5A24bcd06DeA4ACadF4b8aE4b583','rf-soUSDC', 18)   
  ,('0xD84D315f22565399ABFCb2b9C836955401C01A47','rf-soUSDT', 18)
  ,('0xC66b447BE01Ae5FEadBd6DC76D228c5143af9A3C', 'rf-soDAI', 18)
  ,('0x89AC9ceFC4E69B484fb46602964B38380FD19fb5', 'rf-soSUSD', 18)
  ,('0x932b30B2bC3f00B77AFFce8D0FF70B536F658462', 'rf-soWETH', 18)
  ,('0x42Cbc398f63855f89aFE225f5F90151B00D6C73C', 'rf-soOP', 18)
  ,('0x7ecc9D0eE071C7b86d0Ae2101231A3615564009e', 'rf-a-USDC', 18)
  ,('0x61cbcb4278D737471EE54dc689de50E4455978D8', 'rf-a-USDT', 18)
  ,('0x75441c125890612F95b5FBf3f73DB0C25F5573Cd', 'rf-a-DAI', 18)
  ,('0xdf2D2c477078D2cD563648abbb913dA3Db247c00', 'rf-a-WETH', 18)
  ,('0x43cB769D5647CC56F5c1E8Df72aB9097DAB59cCe', 'rf-a-WBTC', 18)
  ,('0xaA3b2F7c6FfaD072Ab65d144b349ed44558F1d80', 'rf-aWETH', 18)
  ,('0x6fED42D8BF5010E5710927FE0DE15f91f916204d', 'rf-aWETH', 18)
  ,('0x4f086A048c33f3BF9011dd2265861ce812624f2c', 'rf-aUSDC', 18)
  ,('0xefcBf2bD622CE716d3344C09E77e7A74071E6CE2', 'rf-aDAI', 18)
  ,('0x229ecbB1D76463E761535dD0e591C34317396131', 'rf-grain-OP', 18)
  ,('0x21f95cfF4aa2E1DD8F43c6B581F246E5aA67Fc9c', 'rf-grain-BAL', 18)   
  ,('0xfb86E03bF6F73DAb782B36B62EE3Ef235b2bE4d0', 'rf-bb-wstETH', 18)
  ,('0x7e66050192E5D74f311DEf92471394A2232a90f9', 'rf-bb-HAPPY', 18)
  ,('0x6536dfFd07C1CD3773f896F0e46962dF7C14A833', 'rf-bb-rf-aUSD', 18)   
  ,('0x1820f9d0BA5cC038B9983660885eD09E59231aD6', 'rf-bb-rfaUSD-MAI', 18)    
  ,('0x5a8d1919647C4de929664bCB442afbF94279B913', 'rf-bb-YELLOW', 18)
  ,('0xea28051EeF9BA3A23f5f5Cc2708481a392d7C0c4', 'rfvAMM-OATH-USDC', 18)    
  ,('0x6cD2852371Fb10bB606c1c65930926c47a62f8CD', 'rf-bb-WONDER', 18)
  ,('0x01EAFb9d744a652e71f554cd8946bFbCd38f5b96', 'rfsAMM-USDC-USD+', 18)    
  ,('0xc99c96e761afEb6454f3Bf3163668d599110305a', 'rf-rETH-ETH', 18)
  ,('0x2B33fAc8C11619eB15bBE193Ec2675E505e2829e', 'rf-sAMM-USD+-LUSD', 18)   
  ,('0x111A9B77f95B1E024DF162b42DeC0A2B1C51A00E', 'rfvAMM-VELO-USDC', 18)   
  ,('0x6Cb0cF0518bc8f87B751F178EF264B248d1A2128', 'rfsAMM-USDC-MAI', 18)
  ,('0x1B4Fd39128B9caDfdfe62fb8C519061D5227D4b9', 'rf-vAMM-OP-L2DAO', 18)  
  ,('0x02E3eFeD80972ea6B4c53c742e10488D1efC0Fe2', 'rfsAMM-USDC-DAI', 18)
  ,('0x0766AED42E9B48aa8F3E6bCAE925c6CF82B517eF', 'rf-sAMM-USDC-SUSD', 18)  
  ,('0x2B2CE9Ea2a8428CE4c4Dcd0c19a931968D2F1e7b', 'rf-vAMM-OP-USDC', 18)
  ,('0xFE24e5c6bd0721b5b69e10Da687796Ba63F3BF81', 'rfvAMM-ETH-USDC', 18)
  ,('0x50d1666f8048F88bAE6B23CC0d09fCC259065441', 'rfsAMM-FRAX-USDC', 18)  
  ,('0xc72C4437824866eF48A0e8455831c21022a12592', 'rfsAMM-USDC-LUSD', 18)
  ,('0xD4f64A36d0E9f00E499c35A5f8b90183D8ab3305', 'rfsAMM-WETH-sETH', 18)  
  ,('0x7d3063f7693D8de76E4Ed0B615Eb3A36cA1a6C25', 'rfsAMM-USDC-alUSD', 18) 
  ,('0x75f29A89107ff590f3b65759e8e6F9943149c27a', 'rfsAMM-USDC-DOLA', 18)
  ,('0x132F3f42A55F037680f557a1441C4e8e42A41a41', 'rfvAMM-WETH-AELIN', 18)
  ,('0xD268887B2171c4b7595DeeBD0CB589c560682629', 'rfsAMM-WETH-alETH', 18)
  ,('0x83Cf5e8B98Ff3bbF2237fe7411e6B03C57c7a0EC', 'rfvAMM-FRAX-USDC', 18)
  ,('0x9B27db3cc52dA7F6Ca16740a977a349AA09547EF', 'rfvAMM-USDC-agEUR', 18) 
  ,('0x1047Afc683Abc40314B29DFD686BB178ebEB4F44', 'rfvAMM-WETH-OP', 18)
  ,('0xC7C84d12E350cC9cd81EaB405aAE2d600308C711', 'rfvAMM-LYRA-USDC', 18)   
  ,('0xbf12FD5e22fcDB0fFB5c62005fEC4f9B90339580', 'rfvAMM-VELO-OP', 18)
  ,('0xc5666f7c50dBb9BFafDE29d5ED190A31FFCa8370', 'rfvAMM-WETH-DOLA', 18)   
  ,('0x53B788691D66ee50c8F36d153921b37f85432FAc', 'rfvAMM-PERP-USDC', 18)
  ,('0x15fbF2F74FaA5400c1CCb9cFB0aC8294Be3A0272', 'rfvAMM-TAROT-USDC', 18) 
  ,('0x1e19F9B2F87Ff30FFB061d07c77a57d59d267F97', 'rfvAMM-OP-DAI', 18)
  ,('0x557b10781DFAe44Ad008EA1c7A281C230F4E4C1d', 'rfsAMM-sUSD-DAI', 18)
  ,('0x01e4D996240F677a057b19DB300060BD20a8F7a9', 'rfsAMM-USDC-USX', 18)
  ,('0xec7C00cE4d63f06D4C2bb7D63E032911996E70Ef', 'rfsAMM-LUSD-MAI', 18)
  ,('0xFA43948C857a201386a99CBc07A099C56fe04580', 'rfvAMM-HND-USDC', 18)
  ,('0xDc015935dd936450b9d116C3Fa66CA3Ad3afc109', 'rfsAMM-sUSD-LUSD', 18)
  ,('0xA4226E6833e5C6F83628c25922a383495c3d2259', 'rfsAMM-USDC-TUSD', 18)
  ,('0xC7670686529791d9C62eAa4D3B4745BB84a3a1CE', 'rfsAMM-jEUR-agEUR', 18)
  ,('0x56756c847B027a27703aaD58c732C041f4e5f033', 'rfvAMM-SONNE-USDC', 18)
  ,('0x6045E787688C7550bCc3dec551c54c57f13E6204', 'rfvAMM-BOND-WETH', 18)
) AS temp_table (contract_address, symbol, decimals)
;