public class BidDayScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BidDayBatch(Date.today().addDays(-1)), 2000);
    }
}