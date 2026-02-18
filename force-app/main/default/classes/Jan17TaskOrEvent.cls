public class Jan17TaskOrEvent {
    
    public String eventSubject {get; set;}
        
    public String  selectedOption {get; set;}
    
    public Task currTask {get; set;}
    public Event currEvent {get; set;}
    
    public Jan17TaskOrEvent () {
        currTask = new Task();
        currEvent = new Event();
        selectedOption = 'task';
    }
    
    public void saveTaskHandler () {
        if(currTask != null) {
       		 insert currTask;
        }
        currTask = new Task();
    }
    
    public void saveEventHandler () {
        if(currEvent != null) {
            insert currEvent;
        }
        currEvent = new Event();
    }
    
    public void assignHandler() {
        if(selectedOption == 'task') {
            saveTaskHandler();
        } else {
            saveEventHandler();
        }
    }
}