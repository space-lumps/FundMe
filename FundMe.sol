// SPDX-License-Identifier: MIT

//get funds from users
//withdraw funds
// set a minimum funding value in usd

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; 
import {PriceConverter} from "PriceConverter.sol";

// constant and immutable keywords are stored directly in bytecode of contract instead of in storage
// immutable allows values to be set at runtime/deployment time
// constant allows values to be set at compile time

error NotOwner();
error CallFailed();
error SendFailed();

// 874483 gas
// 854532 gas
// 854520 gas
contract FundMe {

    using PriceConverter for uint256;

    // USE ALL CAPS FOR VARIABLE NAME for constants 
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    // use i_ prefix for immutable variables
    address public  immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {

        // allow users to send $
        // have a minimum $ sent
        // how do we send ETH to this contract?
        // make contract payable
       
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 * 10 ** 8
        

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // using for loop
        // [1,2,3,4]
        //  0,1,2,3
            // for(starting index, ending index, step amount );
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0);
       
        // withdraw the funds

        // transfer
        // msg.sender is an address
        // payable(msg.sender) = pyaable address;
        payable(msg.sender).transfer(address(this).balance);

        // send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send failed"); /*add require statement to make sure tx reverts if it fails*/  
        if(sendSuccess = false) { revert SendFailed(); }
        
        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this). balance}("");
        // require(callSuccess, "Call failed");
        if(callSuccess = false) { revert CallFailed(); }
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner");
        //custom errors are more gas efficient:
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    // what happens if someone sends this contract ETH without calling FundMe?
    
    // receive()
    // fallback()

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
