public class SObjectDescribe {
    public static List<String> getAllSObjects(){
        return new List<String>(Schema.getGlobalDescribe().keySet());
    }

}