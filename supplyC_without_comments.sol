// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
address owner;
uint skuCount;

mapping(uint => Item) public items;
enum State { ForSale, Sold, Shipped, Received }

struct Item {
      string name;
      uint sku;
      uint price;
      State state;
      address payable seller;
      address payable buyer;
  }

event LogForSale(uint sku);
event LogSold(uint sku);
event LogShipped(uint sku);
event LogReceived(uint sku);

modifier verifyCaller (address _address) { require (msg.sender == _address); _;}
modifier paidEnough(uint _price) { require(msg.value >= _price); _;}
modifier checkValue(uint _sku) { 
   _;

    uint _price = items[_sku].price;
    uint amountToRefund = msg.value - _price;
    items[_sku].buyer.transfer(amountToRefund);
  }

  ///// modifiers :====>>

  modifier forSale(uint _sku) { 
    require( items[_sku].state == State.ForSale);
    _;
  }
  modifier sold(uint _sku) { 
    require( items[_sku].state == State.Sold);
    _;
  }
  modifier shipped(uint _sku) { 
    require( items[_sku].state == State.Shipped);
    _;
  }
  modifier received(uint _sku) { 
    require( items[_sku].state == State.Received);
    _;
  }

  constructor() {
  
       owner = msg.sender;
       skuCount = 0;
  }

  function addItem(string memory _name, uint _price) public returns(bool){
    emit LogForSale(skuCount);
    items[skuCount] = Item({name: _name, sku: skuCount, price: _price, state: State.ForSale, seller: payable(msg.sender), buyer: payable(address(0))});
    skuCount = skuCount + 1;
    return true;
  }


  function buyItem(uint _sku) public payable
    forSale(_sku)
    paidEnough(items[_sku].price)
    checkValue(_sku)
  { 
    items[_sku].seller.transfer(items[_sku].price);
    items[_sku].buyer = payable(msg.sender);
    items[_sku].state = State.Sold;
    emit LogSold(_sku);
  }
    
  function shipItem(uint _sku)public
    sold(_sku) 
    verifyCaller(items[_sku].seller)
  {
    items[_sku].state = State.Shipped;
    emit LogShipped(_sku);
  }

 function receiveItem(uint _sku) public 
  shipped(_sku) 
  verifyCaller(items[_sku].buyer) 
  {
    items[_sku].state = State.Received;
    emit LogReceived(_sku);
  }

  function fetchItem(uint _sku) public view returns (string memory name, uint sku, uint price, uint state, address seller, address buyer) {
    name = items[_sku].name;
    sku = items[_sku].sku;
    price = items[_sku].price;
    state = uint(items[_sku].state);
    seller = items[_sku].seller;
    buyer = items[_sku].buyer;
    return (name, sku, price, state, seller, buyer);
  }

}