pragma solidity ^0.5.0;

contract Escrow
{
    //uint public value;
    //address public seller;
    //address public buyer;
    enum State { Created, Locked, Completed, Aborted }
    //State public state;
    
    uint256 public conID;

    struct Contract {
        uint value;
        address seller;
        address buyer;
        State state;
    }
    mapping (uint => Contract) public contracts;
    uint[] public myContract;

    
    function Purchase(address sellerAddress, uint256 _conID) public payable{
        contracts[_conID] = Contract(
            {
                buyer : msg.sender,
                value : msg.value,
                state : State.Created,
                seller: sellerAddress
            }
        );
        myContract.push(_conID) -1;
        conID = _conID; // contract ID
        //buyer = "0x13A08dDcD940b8602f147FF228f4c08720456aA3";
        //seller= "0xd7d90BBB0Fe833d482315c97bE4E527B550Fb37B" ;
        
    }
    
    modifier require(bool _condition)
    {
        if (!_condition) revert();
        _;
    }
    modifier onlyBuyer()
    {
        if (msg.sender != contracts[conID].buyer) revert();
        _;
    }
    modifier onlySeller()
    {
        if (msg.sender != contracts[conID].seller) revert();
        _;
    }
    modifier inState(State _state)
    {
        if (contracts[conID].state != _state) revert();
        _;
    }
    
    event aborted();
    event purchaseConfirmed();
    event itemReceived();

    // Abort the purchase and reclaim the ether.
    //Can only be called by the seller before
    // the contract is locked.
    function abort () public payable
    {
        emit aborted();
        address payable to = address(uint160(contracts[conID].buyer));
        to.transfer(msg.value);
        contracts[conID].state = State.Aborted;
    }
    // Confirm the purchase as seller.
    // The ether will be locked until confirmReceived
    // is called.
    function confirmPurchase() public
        onlySeller
        inState(State.Created)
    {
        emit purchaseConfirmed();
        contracts[conID].state = State.Locked;
    }
    // Confirm that you (the buyer) received the item.
    // This will release the locked ether.
    function confirmReceived() public payable 
        inState(State.Locked)
    {
        emit itemReceived();
        //buyer.send(value); We ignore the return value on purpose
        address payable to = address(uint160(contracts[conID].seller));
        to.transfer(contracts[conID].value);
        contracts[conID].state = State.Completed;
    }
    //function() { throw; }
}