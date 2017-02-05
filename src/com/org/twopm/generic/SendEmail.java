package com.org.twopm.generic;

import java.util.LinkedHashMap;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class SendEmail {
   public static void main(String[] args) {
   }
   
   public void send(LinkedHashMap<String, String> paramMap){
	   
	   try {
	   
	   	  // Recipient's email ID needs to be mentioned.
	   		String to = paramMap.get(Constants.TO);
	   		
	   		to = "kadav.kiran@gmail.com";
	   	
	   		InternetAddress[] toAddresses = InternetAddress.parse(to);

	      // Sender's email ID needs to be mentioned
	      String from =  paramMap.containsKey(Constants.FROM) ? paramMap.get(Constants.FROM) : ConfigLookup.getValue(Constants.FROM);
	      
	      final String username = paramMap.containsKey(Constants.USER_NAME) ? paramMap.get(Constants.USER_NAME) : ConfigLookup.getValue(Constants.USER_NAME);
	      
	      final String password = paramMap.containsKey(Constants.PASSWORD) ? paramMap.get(Constants.PASSWORD) : ConfigLookup.getValue(Constants.PASSWORD);

	      // SMTP host address
	      //String host = "smtp.gmail.com";

	      String smtpHost = paramMap.containsKey(Constants.SMTP_HOST) ? paramMap.get(Constants.SMTP_HOST) : ConfigLookup.getValue(Constants.SMTP_HOST);	      
	      String smtpPort = paramMap.containsKey(Constants.SMTP_PORT) ? paramMap.get(Constants.SMTP_PORT) : ConfigLookup.getValue(Constants.SMTP_PORT);

	      Properties props = new Properties();
	      props.put("mail.smtp.auth", "true");
	      props.put("mail.smtp.starttls.enable", "true");
	      props.put("mail.smtp.host", smtpHost);
	      props.put("mail.smtp.port", smtpPort);
	      
	      String subject = paramMap.get(Constants.SUBJECT);
	      String content = paramMap.get(Constants.MESSAGE);
	      
	      Multipart contentMultipart = new MimeMultipart();

	      // Get the Session object.
	      Session session = Session.getInstance(props,
	         new javax.mail.Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	               return new PasswordAuthentication(username, password);
	            }
		});
	            // Create a default MimeMessage object.
	            Message message = new MimeMessage(session);

	   	   // Set From: header field of the header.
		   message.setFrom(new InternetAddress(from));

		   // Set To: header field of the header.
		   message.setRecipients(Message.RecipientType.TO,
				   toAddresses);

		   // Set Subject: header field
		   message.setSubject(subject);
		   
		   MimeBodyPart htmlPart = new MimeBodyPart();
		   htmlPart.setContent(content, "text/html");
		   contentMultipart.addBodyPart(htmlPart);

		   // Send the actual HTML message, as big as you like
		   message.setContent(contentMultipart);

		   // Send message
		   Transport.send(message);

		   //System.out.println("Sent message successfully....");

	      } catch (Exception e) {
		   e.printStackTrace();
	      }
   }
}

