@isTest
private class DateUtilTest {
    private static testMethod void testDaysBetween(){
        Date startDate = Date.newInstance(2018, 5, 18);
        Date endDate = Date.newInstance(2018, 5, 27);
        Integer daysBetween = DateUtil.daysBetween(startDate, endDate);
        System.assertEquals(5, daysBetween);
    }
}