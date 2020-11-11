//pragma solidity ^0.4.8;
pragma experimental ABIEncoderV2 ;
contract Auction {
    // static
    address public owner;
    uint public startBlock;
    uint public endBlock;
    uint public numberWorkers; 
    string public ipfsHash;
    address [] winners;

    mapping(address => uint256) public bidsbyWorker;
    mapping(address => uint256) public fundsByBidder;

    // includes the worker address and rank (bid/sqrt(m))
    struct BIDS { // available bids
        uint worker;
        uint rank;
    }
    
    BIDS [] public bids;

    // include all the worker's information
    struct Workers{ 
         // worker, QoI, tasks bidding for
        address worker; // worker address
        uint256 QoI; // submitted qoi as their bid
        bool allocated; // allocated or not
        uint [] tasks; // tasks bidding for
        uint256 numTasks; // number of tasks 
        uint256 rank; 
    }
    
    // list of workers who submitted
    Workers [] public workers;
    // includes the ID of all tasks being bid for
    uint [] public allTasks; // list of all tasks
   
    // state
    bool public canceled;
    uint public highestBindingBid;
    address public highestBidder;
    bool ownerHasWithdrawn;

    event LogBid(address bidder, uint bid, address highestBidder, uint highestBid, uint highestBindingBid);
    event LogBid2(address bidder, uint bid, uint rank, uint [] tasks);

    event LogWithdrawal(address withdrawer, address withdrawalAccount, uint amount);
    event Winner(address winner);
    event LogCanceled();
    event TaskChecked(uint ctask);
    event AllTasks(uint [] tasks);
    uint256 [] task;

    event Intersecting(bool intersection);
    event Payment(uint8 user, uint payment);
    // to initialize the contract parameters
    constructor() public{
      //  if (_startBlock >= _endBlock) revert();
        //if (_startBlock < block.number) revert();
        owner = msg.sender; // task issuer
        startBlock = 1;
        endBlock = 40;
        numberWorkers=5;
        task.push(1);//[0]=1;
        task.push(2);
        task.push(4);
        placeBid(356,task,5,1);
        delete task ;
        
        task.push(1);//[0]=1;
        task.push(2);
        task.push(5);
        placeBid(200,task,1,2);
        delete task ;
        
        task.push(3);//[0]=1;
        placeBid(250,task,4,3);
        delete task ;

        task.push(4);//[0]=1;
        task.push(6);
        task.push(7);
        placeBid(460,task,4,4);
        delete task ;
    }
    
    // allows the worker to submit a bid 
    
    function placeBid(uint256 _q, uint [] memory t, uint256 num, uint user) public
        payable
        onlyAfterStart
        //onlyBeforeEnd
        onlyNotCanceled
    {
        //calculates the rank of a worker as bid/sqrt(m)
        uint rank = _q/sqrt(num);
        num = t.length;
        // push a worker's information
        workers.push(Workers(msg.sender,_q,false,t,num,rank));
        
        // save a worker and their rank 
        bids.push(BIDS(user,rank));

        emit LogBid2(msg.sender, _q, rank,t);
    }
    
    ///////////////// Task Functions ///////////////////
    // check if task already is added to allTasks
    function checkTask(uint t) public returns (bool){
        for (uint8 i = 0; i < allTasks.length; i++){
            if(allTasks[i]==t)
                return false;
        }        
        return true;
    }
    //populates a list of tasks issued by workers 
    function getTasks() public {
        for (uint8 i = 0; i < workers.length; i++){
            for (uint8 j = 0; j < workers[i].tasks.length; j++){
                if(checkTask(workers[i].tasks[j]))
                    allTasks.push(workers[i].tasks[j]);
            }   
        }

    }
    
    // update available tasks
    function updateTasks(uint _winner) public onlyOwner{
        uint alltasks_length=allTasks.length;
        for (uint8 t = 0; t < workers[_winner].tasks.length; t++){
            for (uint at = 0; at < alltasks_length; at++ ){
                if (allTasks[at]==workers[_winner].tasks[t]){
                    allTasks[at]=0;
                }
            }
        }
        
    }

    ////// Worker Functions ////////
    // sorts the list of workers    
    function sort()public {
        emit sortedData(bids);
        if (workers.length == 0)
            return;
        quickSort(workers, 0, workers.length - 1);
        
        emit sortedData(bids);
    }
    
    event sortedData(BIDS [] b);
    // existing function for quick sort
    function quickSort(Workers[] storage arr, uint left, uint right) internal {
        uint i = left;
        uint j = right;
        uint pivot = arr[left + (right - left) / 2].rank;
        while (i <= j) {
            while (arr[i].rank < pivot) i++;
            while (pivot < arr[j].rank) j--;
            if (i <= j) {
                (arr[i].rank, arr[j].rank) = (arr[j].rank, arr[i].rank);
                (arr[i].worker, arr[j].worker) = (arr[j].worker, arr[i].worker);
                (arr[i].QoI, arr[j].QoI) = (arr[j].QoI, arr[i].QoI);
                (arr[i].tasks, arr[j].tasks) = (arr[j].tasks, arr[i].tasks);
                (arr[i].numTasks, arr[j].numTasks) = (arr[j].numTasks, arr[i].numTasks);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }
   
   // check if the current worker is a feasible winner or not
    function feasibileWinner(uint _workerBeingChecked) public onlyOwner returns (uint){
        uint alltasks_length=allTasks.length;
        uint feasibility=0;
        for (uint8 t = 0; t < workers[_workerBeingChecked].tasks.length; t++){
                for (uint at = 0; at < alltasks_length; at++ ){
                    if (allTasks[at]==workers[_workerBeingChecked].tasks[t])
                        feasibility=feasibility+1;
                }
        }
        if (feasibility!=workers[_workerBeingChecked].numTasks)
            feasibility=0;
        return (feasibility);//,workers[_workerBeingChecked].numTasks);
    
    } 
    
    function determineWinner() public{
      
    }
    // check whether 2 sets intersect or not
    function checkIntersectingTasks(uint [] memory one, uint [] memory two) public returns (bool){
        for (uint i= 0; i < one.length;i++){
            for (uint j=0; j < two.length ; j++){
                if(one[i]==two[j])   {
                    emit Intersecting(true);
                    return true;
                }
            }
        }
        emit Intersecting(false);

        return false;
    }
    
    // check the payment of a winner
    function checkWinner(uint8 w) public onlyOwner returns (uint8){
        // get the list of tasks for the winner
        uint [] memory winnertasks= workers[w].tasks;
        bool inter;
        uint8 accepted_winner=0;
        // check winner against lower ranked worker
        for (uint8 checking = w-1; checking > 0 ; checking-- ){
                // check if they intersect to know if lower worker can take the task
                inter=checkIntersectingTasks(winnertasks,workers[checking].tasks);
                emit Intersecting(inter);
                if(inter){
                    bool inter_winners;
                    // if they intersect check new winner against all other winner
                    for (uint8 checking2 = checking-1; checking2 > 0 ; checking2-- ){
                        // if a lower worker than new winner is a winner
                        if(workers[checking2].allocated){
                            // check if they intersect
                           inter_winners=checkIntersectingTasks(workers[checking2].tasks,workers[checking2].tasks);
                            if(inter_winners)
                                break;
                        }
                    }
                    accepted_winner=checking;
                    return(accepted_winner);
                }
            }
    }
    function determinePayment() public {
         // optimal sqrt(m) pay for each allocated worker
         uint pay=0;
         uint8 competitor;
         uint8 i;
        for (i = uint8(workers.length-1) ; i >0 ; i--){
            // if worker is a winner
            if(workers[i].allocated){
                // find next best 
                competitor=checkWinner(i);
                if(competitor!=0){
                    pay = (workers[i].QoI/workers[i].rank)*workers[competitor].rank;
                    emit Payment(i,pay);
                    break;
                }
               
            }
        }
    
    }

   
    function min(uint a, uint b)
        private
        returns (uint)
    {
        if (a < b) return a;
        return b;
    }
    function setMax(uint a, uint b)
        private
        returns (uint)
    {
        if (a < b) return a;
        return b;
    }
    function cancelAuction() public
        onlyOwner
        //onlyBeforeEnd
        onlyNotCanceled
        returns (bool success)
    {
        canceled = true;
        emit LogCanceled();
        return true;
    }

 

    function withdraw() public
        onlyEndedOrCanceled
        returns (bool success)
    {
        address withdrawalAccount;
        uint withdrawalAmount;

        if (canceled) {
            // if the auction was canceled, everyone should simply be allowed to withdraw their funds
            withdrawalAccount = msg.sender;
            withdrawalAmount = fundsByBidder[withdrawalAccount];

        } else {
            // the auction finished without being canceled

            if (msg.sender == owner) {
                // the auction's owner should be allowed to withdraw the highestBindingBid
                withdrawalAccount = highestBidder;
                withdrawalAmount = highestBindingBid;
                ownerHasWithdrawn = true;

            } else if (msg.sender == highestBidder) {
                // the highest bidder should only be allowed to withdraw the difference between their
                // highest bid and the highestBindingBid
                withdrawalAccount = highestBidder;
                if (ownerHasWithdrawn) {
                    withdrawalAmount = fundsByBidder[highestBidder];
                } else {
                    withdrawalAmount = fundsByBidder[highestBidder] - highestBindingBid;
                }

            } else {
                // anyone who participated but did not win the auction should be allowed to withdraw
                // the full amount of their funds
                withdrawalAccount = msg.sender;
                withdrawalAmount = fundsByBidder[withdrawalAccount];
            }
        }

        if (withdrawalAmount == 0) revert();

        fundsByBidder[withdrawalAccount] -= withdrawalAmount;

        // send the funds
        if (!msg.sender.send(withdrawalAmount)) revert();

        emit LogWithdrawal(msg.sender, withdrawalAccount, withdrawalAmount);

        return true;
    }

    modifier onlyOwner {
        if (msg.sender != owner) revert("only owner");
        _;
    }

    modifier onlyNotOwner {
        if (msg.sender == owner) revert("only not owner");
        _;
    }

    modifier onlyAfterStart {
        if (block.number < startBlock) revert("start");
        _;
    }

    modifier onlyBeforeEnd {
        if (block.number > endBlock) revert("end");
        _;
    }

    modifier onlyNotCanceled {
        if (canceled) revert();
        _;
    }

    modifier onlyEndedOrCanceled {
        if (block.number < endBlock && !canceled) revert();
        _;
    }
    
    function sqrt(uint x) public returns (uint y) {
    uint z = (x + 1) / 2;
    y = x;
    while (z < y) {
        y = z;
        z = (x / z + z) / 2;
    }
}
}

