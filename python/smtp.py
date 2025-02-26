import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Email credentials (no password needed)
sender_email = "your_email@example.com"
receiver_email = "receiver_email@example.com"

# SMTP server details (no password needed)
smtp_server = "smtp.yourserver.com"
smtp_port = 25  # Typically, 25 or 587 for non-authentication

# Create the email content
subject = "Test Email"
body = "This is a test email sent without authentication!"

# Create a MIME message
message = MIMEMultipart()
message["From"] = sender_email
message["To"] = receiver_email
message["Subject"] = subject
message.attach(MIMEText(body, "plain"))

# Establish a connection to the SMTP server
try:
    # Connect to the server (no login required)
    server = smtplib.SMTP(smtp_server, smtp_port)

    # Send the email
    server.sendmail(sender_email, receiver_email, message.as_string())
    print("Email sent successfully!")

except Exception as e:
    print(f"Error: {e}")

finally:
    # Close the connection
    server.quit()
