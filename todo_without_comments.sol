//SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;
contract Todo{
    address owner;
    

    struct task {
        uint id;
        string title;
        bool completed;
    }
  
uint256 public  taskcount; 
mapping(int=>task) public taskk;
  
    constructor () 
    {
      owner =msg.sender;
      taskcount = 0;
    }
    
event taskadded(
        uint id,
        string title 
     );

event taskcompleted(
        uint id,
        bool completed
    );
    

modifier onlyowner
   {
        require (owner == msg.sender);
        _;
        
    }
    
function addTask(string memory _title) public onlyowner{
        taskcount ++;
        taskk[int256(taskcount)] = task(taskcount, _title, false);
        emit taskadded(taskcount, _title);
    }

function total_task() public view returns(uint){
        return taskcount;
    }
    
function gettask(int256 _id) public view
        returns (string memory title_name , uint id ,bool status) {
        title_name=taskk[_id].title;
            id=taskk[_id].id;
            status=taskk[_id].completed;

        }

    function gettaskcompleted(int256 _iid) public {

            taskk[_iid].completed=true;
     }
 
}
