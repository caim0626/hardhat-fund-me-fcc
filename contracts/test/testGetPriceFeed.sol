// SPDX-License-Identifier: MIT
// Pragma
pragma solidity ^0.8.8;
// Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "../PriceConverter.sol";

contract testGetPriceFeed {
    AggregatorV3Interface private s_priceFeed;

    constructor(address s_priceFeedAddress) {
        s_priceFeed = AggregatorV3Interface(s_priceFeedAddress);
    }

    function getit() public view returns (int256) {
        (, int256 answer, , , ) = s_priceFeed.latestRoundData();
        return answer;
    }
}
