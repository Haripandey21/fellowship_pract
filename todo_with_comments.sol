//SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;
contract Todo{
    address owner;
    /*
    Create struct called task 
    The struct has 3 fields : id,title,Completed
    Choose the appropriate variable type for each field.
    */

    struct task {
        uint id;
        string title;
        bool completed;
    }
  
    ///Create a counter to keep track of added tasks
     uint256 public  taskcount; 


    /*
    create a mapping that maps the counter created above with the struct taskcount
    key should of type integer
    */
    mapping(int=>task) public taskk;
  
   
    /*
    Define a constructor
    the constructor takes no arguments
    Set the owner to the creator of the contract
    Set the counter to  zero
    */
    constructor () 
    {
      owner =msg.sender;
      taskcount = 0;
    }
    
    /*
    Define 2 events
    taskadded should provide information about the title of the task and the id of the task
    taskcompleted should provide information about task status and the id of the task
    */ 
     event taskadded(
        uint id,
        string title 
     );

    event taskcompleted(
        uint id,
        bool completed
    );
    
 /*
        Create a modifier that throws an error if the msg.sender is not the owner.
    */
     modifier onlyowner {
        require (owner == msg.sender); 
        _;
        
    }
    

    /*
    Define a function called addTask()
    This function allows anyone to add task
    This function takes one argument , title of the task
    Be sure to check :
    taskadded event is emitted
     */
      function addTask(string memory _title) public onlyowner{
        taskcount ++;
        taskk[int256(taskcount)] = task(taskcount, _title, false);
        emit taskadded(taskcount, _title);
    }

    

    /*Define a function  to get total number of task added in this contract*/
    function total_task() public view returns(uint){
        return taskcount;
    }
    

    /**
    Define a function gettask()
    This function takes 1 argument ,task id and 
    returns the task name ,task id and status of the task
     */

     function gettask(int256 _id) public view
        returns (string memory title_name , uint id ,bool status) {
        title_name=taskk[_id].title;
            id=taskk[_id].id;
            status=taskk[_id].completed;

        }

    
    /**Define a function marktaskcompleted()
    This function takes 1 argument , task id and 
    set the status of the task to completed 
    Be sure to check:
    taskcompleted event is emitted
     */

     function gettaskcompleted(int256 _iid) public {

            taskk[_iid].completed=true;
     }

    
}
