@isTest
private class XMLParserTest {
    public static testMethod void test(){
        Messaging.InboundEmail mail = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.TextAttachment xmlFile = new Messaging.InboundEmail.TextAttachment();
        xmlFile.fileName = 'contacts.xml';
        xmlFile.body = '<contacts>\n' +
                        '\t<contact>\n' +
                        '\t\t<firstname>Tim</firstname>\n' + 
                        '\t\t<lastname>Lot</lastname>\n' + 
                        '\t\t<subjects__c>Science;English</subjects__c>\n' + 
                        '\t\t<experience__c>6</experience__c>\n' +
                        '\t</contact>\n' +
            			 '\t<contact>\n' +
                        '\t\t<firstname>Tim</firstname>\n' + 
                        '\t\t<lastname>Lot2</lastname>\n' + 
                        '\t\t<subjects__c>Science;English</subjects__c>\n' + 
                        '\t\t<experience__c>6</experience__c>\n' +
                        '\t</contact>\n'+
            			'\t<contact>\n' +
                        '\t\t<firstname>Tim</firstname>\n' + 
                        '\t\t<lastname>Lot3</lastname>\n' + 
                        '\t\t<subjects__c>Science;English</subjects__c>\n' + 
                        '\t\t<experience__c>6</experience__c>\n' +
                        '\t</contact>\n' +
                        '</contacts>';
        xmlFile.mimeTypeSubType = 'text/xml';
        mail.textAttachments = new List<Messaging.InboundEmail.TextAttachment>{xmlFile};
        XmlParser parser = new XmlParser();
        parser.handleInboundEmail(mail, env);
        System.assertEquals(3, [SELECT COUNT() FROM Contact]);
            
    }

}