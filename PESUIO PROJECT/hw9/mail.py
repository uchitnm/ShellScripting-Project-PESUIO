import sys
import smtplib

username = '<Email>'
userpassword = '<password>'

subject = 'Output Result,'

if str(sys.argv[3]):
    body = f'{sys.argv[1]} got {sys.argv[2]} as he/she have {sys.argv[3]} incorrect lines.'
else:
    body = f'{sys.argv[1]} has not turned in his/her Assignmet.'

msg = f'Subject: {subject}\n\n{body}'
with smtplib.SMTP('smtp.gmail.com', 587) as smtp:

    smtp.ehlo()
    smtp.starttls()
    smtp.ehlo()

    smtp.login(username, userpassword)

    smtp.sendmail(username, sys.argv[4], msg)