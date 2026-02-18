public class T1 {
    public String selectedValue { get; set; }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Option1', 'Label One'));
        options.add(new SelectOption('Option2', 'Label Two'));
        options.add(new SelectOption('Option3', 'Label Three'));
        return options;
    }
    
    public PageReference processSelection() {
        System.debug('Selected Value: ' + selectedValue);
        return null;
    }
}