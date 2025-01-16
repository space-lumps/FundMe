// Get funds from users
// withdraw funds
// set a minimum fundin value in USD

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        // allow users to send $
        // have a minimum $ sent $5
        // 1. how do we send ETH to this contract?
        
        // require users to send $5; revert message in ""
            // require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH"); //1e18 = 1 ETH = 10000000000000000000 (wei) = 1 * 10 ** 18
        // this has 18 decimal places
            //msg.value.getConversionRate();
            require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH");
        // using getConversionRate function to convert this price to dollars
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        // += means add msg.value to addressToAmountFunded[msg.sender]
    }

    function withdraw() public {
        // for loop
        // [1, 2, 3, 4] elements
        //  0, 1, 3, 4 indices
        //for(/* starting index, ending index, step amount */)
        // 0, 10, 1
        // 0 , 1, 2, 3, 4
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            // ++ means the variable plus one
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        

        }
    }
