global class XMLParser implements Messaging.InboundEmailHandler {
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		  Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          Messaging.InboundEmail.TextAttachment xmlFile = email.TextAttachments[0];
          System.debug(xmlFile);
          String xmlString = xmlFile.body;
          Dom.Document doc = new Dom.Document();
          doc.load(xmlString);
          Dom.XmlNode rootNode = doc.getRootElement();
          List<Contact> contacts = new List<Contact>();
          Map<String, Schema.SobjectField> fields = Schema.Contact.SObjectType.getDescribe().fields.getMap(); 
          for(Dom.XmlNode n : rootNode.getChildElements()){
              Contact con = new Contact();
              for(Dom.XmlNode m : n.getChildElements()){
                  String fieldName = m.getName();
                  String value = m.getText();
                  Schema.DisplayType fieldType = fields.get(fieldName).getDescribe().getType();
                  if(fieldType == Schema.DisplayType.INTEGER){
                      con.put(fieldName, Integer.valueOf(value));
                  }else if(fieldType == Schema.DisplayType.DOUBLE){
                      con.put(fieldName, Double.valueOf(value));
                  }else if(fieldType == Schema.DisplayType.BOOLEAN){
                      con.put(fieldName, Boolean.valueOf(value));
                  }else if(fieldType == Schema.DisplayType.Date){
                      con.put(fieldName, Date.parse(value));
                  }else if(fieldType == Schema.DisplayType.DateTime){
                      con.put(fieldName, DateTime.parse(value));
                  }else{
                      con.put(fieldName, value);
                  }
                      
              }
              contacts.add(con);
          }
          System.debug(Contacts);
          insert contacts;
          return result;
      }
  }