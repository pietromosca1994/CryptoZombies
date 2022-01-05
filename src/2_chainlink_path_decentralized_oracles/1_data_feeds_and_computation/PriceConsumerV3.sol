pragma solidity ^0.6.7; // not compile earlier than 0.6.7 and not compile from version 0.7.0. version 0.6.7 is used to match the chainlink version imported

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 { // version of chainlink is V3
  AggregatorV3Interface public priceFeed;

  constructor() public {
    priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
  }

  function getLatestPrice() public view returns(int) {
      (,int price,,,) = priceFeed.latestRoundData();
      return price;
  }
}