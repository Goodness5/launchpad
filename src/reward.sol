// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
// import "../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract Launcher {


    address owner;

    struct rewarddetails {
        uint256 rate;
        address tokenaddress;
        bool startlauch;
        uint duration;
        uint totalReward;
        uint total_sale;
        address owner;
    }

    mapping (string => rewarddetails) Rewards;
    string[] rewardnames;


    mapping (address => clientdetails) userdetails;
    address[] clients;

    struct clientdetails {
        address rewardaddress;
        uint clientdeposit;
        string _rewardname;
    }



    constructor() {
        owner = msg.sender;
        // AddReward(rewardaddr, 5, total_reward, duration);
    }

    modifier onlyOwner {
        require(msg.sender == owner);

        _;
    }


   function AddReward(address _tokenaddr, uint rate, uint total_reward, uint duration, address _rewardowner) public onlyOwner returns  (bool _tokenAdded) {
    require(_tokenaddr != address(0), "address must be valid");
    string memory reward_name = IERC20Metadata(_tokenaddr).name();
    Rewards[reward_name].rate = rate;
    Rewards[reward_name].tokenaddress = _tokenaddr;
    Rewards[reward_name].owner = _rewardowner;
    Rewards[reward_name].startlauch = true;
    Rewards[reward_name].duration = duration;
    Rewards[reward_name].totalReward = total_reward;
    rewardnames.push(reward_name);
    // if(duration >= block.timestamp){
    //     Rewards[reward_name].startlauch = false;
    // }
    IERC20(_tokenaddr).approve(address(this), total_reward);
    IERC20(_tokenaddr).transferFrom(_tokenaddr, address(this), total_reward);
    return true;
}

    function getRewardNames() public view returns (string[] memory) {
        return rewardnames;
    }
    function getlaunchStatus(string memory launchname) public view returns (bool active) {
       return Rewards[launchname].startlauch;
    }


    function calcreward(uint amount, string memory rewardName) view public  returns (int duereward) {
         rewarddetails storage reward = Rewards[rewardName];
         require(reward.tokenaddress != address(0));
         uint rate = reward.rate;
        uint rewardAmount = amount * rate;
        duereward = int(rewardAmount);
        
    }

   function participate(string memory _rewardname) payable public {
    rewarddetails storage rewarddet = Rewards[_rewardname];
    require(rewarddet.startlauch, "launch not started");
    address rewardaddr = Rewards[_rewardname].tokenaddress;
    require(rewardaddr !=address(0), "reward does not exist");
    require(msg.value > 0, "Please send some Ether");
    uint amount = msg.value;
    clients.push(msg.sender);
    userdetails[msg.sender].clientdeposit = amount;
    userdetails[msg.sender]._rewardname = _rewardname;
    rewarddet.total_sale += amount;
    
    }

function endlaunch(string memory _rewardname) public onlyOwner {
        rewarddetails storage rewarddet = Rewards[_rewardname];
        require(rewarddet.startlauch == true, "Reward not active");
        for (uint i = 0; i < clients.length; i++) {
            address eachaddress = clients[i];
            clientdetails storage eachclient = userdetails[eachaddress];
            uint clientamount = eachclient.clientdeposit;
            address rewardaddr = eachclient.rewardaddress;
            string memory _eachrewardnames = eachclient._rewardname;
            int eachreward = calcreward(clientamount, _eachrewardnames);
            transferERC20Token(rewardaddr, uint(eachreward), eachaddress);
        }
        rewarddet.startlauch = false;
        address payable rewardOwner = payable(rewarddet.owner);
        uint profit = rewarddet.total_sale;
        uint result = ((20 * profit) / 100);
        uint totalSale = profit - result;
        (bool success, ) = rewardOwner.call{value: totalSale}("");
        require(success, "Failed to send Ether to reward owner");
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