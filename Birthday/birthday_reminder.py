"""
1. On debian, install notifier:
    apt-get install libnotify-bin

2. Create a *.desktop file in ~/.config/autostart/:

nano ~/.config/autostart/reminder.desktop

[Desktop Entry]
Name=BirthdayReminder
Exec="/home/ls/Git/tikzpic/Birthday/reminder.sh"
Type=Application

"""


import time
import os


birthdayFile = '/home/ls/Git/Documents/Dokumente/birthdayfile.txt'


def checkTodaysBirthdays():
    fileName = open(birthdayFile, 'r')
    today = time.strftime('%d.%m.%Y')
    day, month, year = today.split('.')
    flag = 0
    notifier = 'notify-send "'
    for line in fileName:
        birthday, firstname, surname, sex, email = line.split(' ')
        bday, bmonth, byear = birthday.split('.')
        if bmonth == month:
            if bday == day:
                if flag == 1:
                    notifier += ' - '
                elif flag == 0:
                    notifier += 'Birthdays today: '
                flag = 1
                notifier += firstname + ' ' + surname
                try:
                    age = int(year) - int(byear)
                except:
                    age = None
                if age:
                    notifier += '(' + str(age) + ')'
                if '@' in email:
                    createBirthdayEmail(email, age, firstname, surname, sex)
    if flag == 0:
        notifier += 'No Birthdays Today!"'
    else:
        notifier += '"'
    os.system(notifier)


def createBirthdayEmail(email, age, name, surname, sex='m'):
    body = "Liebe{} {}\nzu deinem {} Geburtstag wuensche ich alles Gute!\n".format(
           'r' if sex == 'm' else '', name, str(age) + '.' if age else '')
    body += "\nHalt die Ohren steif \ndein Lars"
#    body = '<html><body>' + body + '<br></body></html>'
#    print body
    subject = "Viel ist auch immer mehr"
    try:
        os.system(
            "thunderbird -compose to='" + email + "',subject=" + subject +
            ",body='" + body + "'&")
    except OSError:
        os.system(
            "icedove -compose to='" + email + "',subject=" + subject +
            ",body='" + body + "'&")

if __name__ == '__main__':
    checkTodaysBirthdays()
