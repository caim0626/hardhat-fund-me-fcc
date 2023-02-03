// SPDX-License-Identifier: MIT
// Pragma
pragma solidity ^0.8.8;
// Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";
//Error Codes
error FundMe__NotOwner();

// Interfaces, Libraries, Contracts

contract FundMe {
    // Type Declarations

    using PriceConverter for uint256;

    // State Variables
    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address private immutable i_owner;
    //PriceConverter方法转换好了，没必要再*10 ** 18
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    // uint256 public constant MINIMUM_USD = 50;
    uint256 public payUsd;
    uint256 public ethPrice;
    uint256 public ethAmount;
    bool public isBigThanMin;
    AggregatorV3Interface private s_priceFeed;

    constructor(address s_priceFeedAddress) {
        s_priceFeed = AggregatorV3Interface(s_priceFeedAddress);
        i_owner = msg.sender;
    }

    function getEthPrice() public view returns (uint256) {
        return ethPrice;
    }

    function getPayUsd() public view returns (uint256) {
        return payUsd;
    }

    function fund() public payable {
        ethAmount = msg.value;
        (ethPrice, payUsd) = msg.value.getConversionRate(s_priceFeed);
        isBigThanMin = payUsd >= MINIMUM_USD;
        require(isBigThanMin, "You need to spend more ETH!");

        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;

        s_funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // ETH/USD price feed address of Goerli Network.
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");

        require(callSuccess, "Call failed");
    }

    function cheaparWithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        // mapping can't be in memory, sorry!
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return (s_priceFeed);
    }

    function getFunder(uint256 index) public view returns (address) {
        return (s_funders[index]);
    }

    function getAddressToAmountFunded(
        address funder
    ) public view returns (uint256) {
        return (s_addressToAmountFunded[funder]);
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly
