// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;

    // special functions receive(), fallback(), constructor() do not require function keywords
    // if data is sent w a tx, the tx will default to the fallback() function
    // if data is empty, and receive() is called, receive() will run

    // constant and immutable keywords cause variables to be unchangeable
    // constant runs at compile time, immutable runs at runtime

    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}
