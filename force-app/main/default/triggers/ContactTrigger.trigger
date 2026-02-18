trigger ContactTrigger on Contact (before insert) {
    for(Contact con : trigger.new) {
        if(String.isBlank(con.Department)) {
            con.Department = 'CEO';
        }
    }
}