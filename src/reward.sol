// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Reward {


    address owner;

    struct rewarddetails {
        uint256 rate;
        address tokenaddress;
    }

    mapping (string => rewarddetails) Rewards;
    mapping (address => clientdetails) userdetails;
    address[] clients;

    struct clientdetails {
        address rewardaddress;
        uint clientdeposit;
        string _rewardname;
    }
    bool startlauch;



    constructor(address rewardaddr, string memory rewardname) {
        owner = msg.sender;
        AddReward(rewardaddr, 5, rewardname);
    }

    modifier onlyOwner {
        require(msg.sender == owner);

        _;
    }


   function AddReward(address _tokenaddr, uint rate, string memory reward_name) public onlyOwner returns  (bool _tokenAdded) {
    require(_tokenaddr != address(0), "address must be valid");
    Rewards[reward_name] = rewarddetails(rate, _tokenaddr);
    return true;
}

    function calcreward(uint amount, address _reward, string memory rewardName) view public  returns (int duereward) {
         rewarddetails storage reward = Rewards[rewardName];
         require(reward.tokenaddress != address(0));
         uint rate = reward.rate;
        uint rewardAmount = amount * rate;
        duereward = int(rewardAmount);
        
    }

   function participate(string memory _rewardname) payable public {
    require(startlauch, "launch not started");
    address rewardaddr = Rewards[_rewardname].tokenaddress;
    require(rewardaddr !=address(0), "reward does not exist");
    require(msg.value > 0, "Please send some Ether");
    uint amount = msg.value;
    clients.push(msg.sender);
    userdetails[msg.sender].clientdeposit = msg.value;
    userdetails[msg.sender]._rewardname = _rewardname;
    
    }

    function endlaunch() public onlyOwner {

        for (uint i = 0; i < clients.length; i++) {
            address eachaddress = clients[i];
            clientdetails storage eachclient = userdetails[eachaddress];
            uint clientamount = eachclient.clientdeposit;
            address rewardaddr = eachclient.rewardaddress;
            string memory _rewardname = eachclient._rewardname;
           int eachreward =  calcreward(clientamount, rewardaddr, _rewardname);
           transferERC20Token(rewardaddr, uint(eachreward), eachaddress);
        }
        startlauch = false;




    }

    function transferERC20Token(address rewardaddr, uint amount, address _to) internal{
        IERC20(rewardaddr).transferFrom(address(this), _to, amount);
        
    }

    function withdraweth(uint256 _value) internal returns (bool success){
        require(address(this).balance >= _value, "insufficient balance");
        address payable reciepient = payable(msg.sender);
        success = reciepient.send(_value);
        require(success, "withdrawal failed");
    }

}