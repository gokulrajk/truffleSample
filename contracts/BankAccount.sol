pragma solidity >=0.5.0<0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/upgrades/contracts/Initializable.sol";

contract BankAccount is Initializable{
  string public name = 'ERCFT';
  string public symbol = 'RTS';
  string public standard = 'ERC FT v1.0';
  uint256 public totalSupply;

  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );

  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;
  address[] public onlyAcct;
  mapping(address => bool) userExists;

  
   struct Accts {
        address addrs;
        uint256 bal;
     
    }
    
    

  function initialize(uint256 _initialSupply) public initializer {
    //  alocate initial supply
    balanceOf[msg.sender] = _initialSupply;
    totalSupply = _initialSupply;
  }

  // Transfer
  function transfer(address _to, uint256 _value) public returns(bool success) {
    // Execption if account doesn't have enough funds
    require(balanceOf[msg.sender] >= _value, "Invalid amount");
    // Transfer the balance
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    // Transfer events
    emit Transfer(msg.sender, _to, _value);
      if(!userExists[msg.sender]){
            onlyAcct.push(msg.sender) -1;
        }
          if(!userExists[_to]){
            onlyAcct.push(_to) -1;
        }
    userExists[msg.sender] = true;
    userExists[_to] = true;
    return true;
  }
  
  //All accounts
     function getAccts() view public returns (address[] memory) {
        return onlyAcct;
    }
    
      function getAcctslen() view public returns (uint) {
        return onlyAcct.length;
    }
    
      function getAcctWithBalance()view  external returns (Accts[] memory) {
     
       
        Accts[] memory accBal = new Accts[](onlyAcct.length);
          for (uint j = 0; j < onlyAcct.length; j++) {
       
            accBal[j] =(Accts(onlyAcct[j],balanceOf[onlyAcct[j]]));
           // s.push(book);
        }
        return accBal;
    }

  function approve(address _spender, uint _value) public returns(bool success) {
    // Set Allowance
    allowance[msg.sender][_spender] = _value;
    // Triggers Aprove event
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  
  function transferFrom(address _from, address _to, uint _value) public returns(bool success) {
    require(_value <= balanceOf[_from], "Value larger than balance");
    require(_value <= allowance[_from][msg.sender], "Value larger than apporved amount");

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;

    allowance[_from][msg.sender] -= _value;

    emit Transfer(_from, _to, _value);

    return true;
  }

  function balances(address tokenOwner) public view returns(uint256) {
 
    return balanceOf[tokenOwner];
  
  }
  
  function balancesupdate(address tokenOwner) public view returns(uint256) {

    return balanceOf[tokenOwner]-3;

  }
  
  

}
