pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns; 
    
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
        
    }
    
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

 
contract Campaign {
    struct Request {
        string description; 
        uint value;
        address recipient;
        bool complete; 
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    Request [] public requests;
    address public manager;
    uint public minimumContribution; 
    // address[] public approvers;
    mapping (address => bool) public approvers;
    uint public approversCount;
    
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
        
    }
    
    
    function Campaign(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
        
        
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        
        // approvers.push(msg.sender);
        approvers[msg.sender] = true; 
        approversCount++;
    }
    
    
    function createRequest(string description, uint value, address recipient) public restricted {
        // require(approvers[msg.sender]);
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request = requests[index];
         require(approvers[msg.sender]);
         require(!request.approvals[msg.sender]);
         
         request.approvals[msg.sender] = true; 
         request.approvalCount++;
    }
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        // Makes sure majority of people have approved to request 
        require(request.approvalCount > (approversCount / 2));
        
        // Makes sure the approval hasn't already been approved. 
        require(!requests[index].complete);
        
        
        
        request.recipient.transfer(request.value);
        request.complete = true;
    }
    
}