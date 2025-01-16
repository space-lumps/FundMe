// Get funds from users
// withdraw funds
// set a minimum fundin value in USD

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUsd = 5e18;

    address[] public funders;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        // allow users to send $
        // have a minimum $ sent $5
        // 1. how do we send ETH to this contract?
        
        // require users to send $5; revert message in ""
        require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH"); //1e18 = 1 ETH = 10000000000000000000 (wei) = 1 * 10 ** 18
        // this has 18 decimal places
        // using getConversionRate function to convert this price to dollars
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    // function withdraw() public {}

    function getPrice() public view returns(uint256) {
        // to interact w a contract, we need 1. address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // and 2. ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,,,) = priceFeed.latestRoundData();
        // price of ETH in terms of USD
        // will look like "200000000000" (there are 8 decimals in this price feed)
        return uint256(answer * 1e10); //this is to convert price to 18 decimals like our msg.value
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        //convert price of eth in terms of USD as uint256
        //convert msg.value in terms of dollars
        // 1 ETH price is ? 3000_000000000000000000
        uint256 ethPrice = getPrice();
        // (3000_000000000000000000 * 1_000000000000000000) / 1e18;
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // always multiply before dividing in solidity bc only whole numbers work with math
        return ethAmountInUsd;
    }

    function getVersion() public view returns (uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}
