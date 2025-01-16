// SPDX-License-Identifier: MIT
// this will be a library
// in a library all functions must be internal and cannot have any state variables
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{

    function getPrice() internal view returns(uint256) {
        // to interact w a contract, we need 1. address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // and 2. ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,,,) = priceFeed.latestRoundData();
        // price of ETH in terms of USD
        // will look like "200000000000" (there are 8 decimals in this price feed)
        return uint256(answer * 1e10); //this is to convert price to 18 decimals like our msg.value
    }
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        //convert price of eth in terms of USD as uint256
        //convert msg.value in terms of dollars
        // 1 ETH price is ? 3000_000000000000000000
        uint256 ethPrice = getPrice();
        // (3000_000000000000000000 * 1_000000000000000000) / 1e18;
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // always multiply before dividing in solidity bc only whole numbers work with math
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
