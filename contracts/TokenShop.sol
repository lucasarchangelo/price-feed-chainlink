//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface TokenInterface {
    function mint(address account, uint256 amount) external;
    function decimals() external view returns(uint8);
}

contract TokenShop is Ownable {
    AggregatorV3Interface internal priceFeed;
    TokenInterface public minter;
    uint256 tokenPrice;

    constructor(address _tokenAddress, address _aggregatorAddress, uint256 _tokenPrice) {
        /**
         * Network: Goerli
         * Aggregator: ETH/USD
         * Address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
         */
        priceFeed = AggregatorV3Interface(_aggregatorAddress);
        minter = TokenInterface(_tokenAddress);
        /**
            Price must be in wei. 
        */
        tokenPrice = _tokenPrice;
    }

    receive() external payable {
        uint256 amountToken = tokenAmount(msg.value);
        minter.mint(msg.sender, amountToken);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int256) {
        (
            ,
            /*uint80 roundID*/
            int256 price,
            ,
            ,

        ) = /*uint startedAt*/
            /*uint timeStamp*/
            /*uint80 answeredInRound*/
            priceFeed.latestRoundData();
        return price;
    }

    function tokenAmount(uint256 amountETH) public view returns (uint256) {
        uint256 fixedAmount = (convertEthToUsd(amountETH) * 10 ** minter.decimals());
        return fixedAmount / tokenPrice;
    }

    // function convertUsdToEth(uint256 usdAmount) public view returns (uint256) {
    //     uint256 amount = usdAmount * 10 ** (18 + priceFeed.decimals());
    //     return amount / uint256(getLatestPrice());
    // }

    function convertEthToUsd(uint256 ethAmount) public view returns (uint256) {
        uint256 result = ethAmount * uint256(getLatestPrice());
        return result / (1 * 10 ** priceFeed.decimals());
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function setTokenPrice(uint256 _tokenPrice) external onlyOwner {
        tokenPrice = _tokenPrice;
    }
}
