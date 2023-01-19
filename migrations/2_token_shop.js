const TokenShop = artifacts.require("TokenShop");
const SafraToken = artifacts.require("SafraToken");

module.exports = async function (deployer, _network, accounts) {

    const MINT_ROLE = "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6";
    const _aggregator = "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e";
    const _tokenUsdPrice = "20000000000000000000";
    const _tokenInstance = await SafraToken.deployed();
    
    await deployer.deploy(
        TokenShop,
        _tokenInstance.address,
        _aggregator,
        _tokenUsdPrice
    );

    const _tokenShopInstance = await TokenShop.deployed();
    await _tokenInstance.grantRole(MINT_ROLE, _tokenShopInstance.address);
};