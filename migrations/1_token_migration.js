const SafraToken = artifacts.require("SafraToken");

module.exports = async function (deployer, _network, accounts) {
    await deployer.deploy(
        SafraToken,
    );
};