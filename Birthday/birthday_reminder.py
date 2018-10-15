"""
1. Firstly, we have to create an executable file for our reminder.py script
2. This can be done by typing the following command in the terminal
    sudo chmod +x reminder.py
3. Now we have to transfer this file to the path where Linux searches for its
   default files:
    sudo cp /path/to/our/reminder.py /usr/bin
4. In global search, search for Startup Applications
5. Click on Add and Give a desired Name for your process
6. Type in the command. For example, our file name is reminder.py then type
   reminder.py in the command field and Select Add
7. On debian, install notifier:
    apt-get install libnotify-bin

"""


import time
import os


birthdayFile = 'birthdayfile.txt'


def checkTodaysBirthdays():
    fileName = open(birthdayFile, 'r')
    today = time.strftime('%d.%m.%Y')
    day, month, year = today.split('.')
    flag = 0
    notifier = 'notify-send "Birthdays Today: '
    for line in fileName:
        birthday, firstname, surname, sex, email = line.split(' ')
        bday, bmonth, byear = birthday.split('.')
        if bmonth == month:
            if bday == day:
                if flag == 1:
                    notifier += ' - '
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
    body = "Liebe{} {} \nzu deinem {} Geburtstag wuensche ich alles Gute!\n".format(
           'r' if sex == 'm' else '', name, str(age) + '.' if age else '')
    body += "\nHalt die Ohren steif \ndein Lars"
#    body = '<html><body>' + body + '<br></body></html>'
#    print body
    subject = "Die Geometrie der Wolken"
    os.system("thunderbird -compose to='" + email + "',subject=" + subject +
              ",body='" + body + "'")


if __name__ == '__main__':
    checkTodaysBirthdays()
