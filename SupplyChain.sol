// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {

    enum State { Created, Shipped, Delivered }

    struct Product { 
        uint id;
        string name;
        address manufacturer;
        address distributor;
        address retailer;
        State state;
    }

    uint public productCount = 0;
    mapping(uint => Product) public products;

    function createProduct(string memory _name) public {
        productCount++;
        products[productCount] = Product(
            productCount,
            _name,
            msg.sender,
            address(0),
            address(0),
            State.Created
        );
    }

    function shipProduct(uint _id, address _distributor) public {
        Product storage p = products[_id];
        require(msg.sender == p.manufacturer);
        p.distributor = _distributor;
        p.state = State.Shipped;
    }

    function deliverProduct(uint _id, address _retailer) public {
        Product storage p = products[_id];
        require(msg.sender == p.distributor);
        p.retailer = _retailer;
        p.state = State.Delivered;
    }

    function getProduct(uint _id) public view returns (
        uint, string memory, address, address, address, State
    ) {
        Product memory p = products[_id];
        return (p.id, p.name, p.manufacturer, p.distributor, p.retailer, p.state);
    }
}