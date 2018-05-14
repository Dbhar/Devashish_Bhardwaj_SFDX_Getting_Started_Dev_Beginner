public class DateUtil {
    //Given two Dates returns the number of days between them
    public static Integer daysBetween(Date startDate, Date endDate){
        DateTime currentDate = DateTime.newInstance(startDate.addDays(1), Time.newInstance(14, 0, 0, 0));
        DateTime finalDate = DateTime.newInstance(endDate.addDays(-1), Time.newInstance(14, 0, 0, 0));
        Integer daysBetween = 0;
        while(currentDate <= finalDate){
            if(!(currentDate.format('EEE') == 'Sun' || currentDate.format('EEE') == 'Sat')){
                daysBetween++;
            }
            currentDate = currentDate.addDays(1);
        }
        return daysBetween;
    }
}