# -----------------------------------------------------------------------------------------------------------------------------------
# |                                                                    PESUIO SLOT 14                                               |
# |                                                                                                                                 |
# |                                  Course name  : "How to be a command line hacker : Shell Scripting"                             |
# |                                                                                                                                 |
# |                                  Programed by : Team 5                                                                          |
# |                                                  - Uchit N M                                                                    |
# |                                                  - Aryan Anand                                                                  |
# |                                                                                                                                 |
# |                                                                                                                                 |
# |                                  Mentor       :  Kavya Jain                                                                     |
# |                                                                                                                                 |
# |                          Problem statement    : https://courses.cs.washington.edu/courses/cse391/21wi/homework/hw9/             |
# -----------------------------------------------------------------------------------------------------------------------------------

#!/bin/bash

MaxMark=${1} # taking the first argument. ie maxmium marks

# checking if marks is provided or not.

if [ ! ${MaxMark} ]; then
    echo "No Maxmimum marks is given. Syntax - ./autograder.sh 50"
    exit
fi

echo "Maximum marks evaluated for is : " ${MaxMark}
echo ""

# extracring lsit of dirs od the students.

dir_cont=$(ls students/)

# itterating over the dirs

for i in ${dir_cont}; do

    # extracting the task file.
    stud_file=$(ls students/${i}/ | grep -i task1.sh)

    # file not fount move to else.

    if [ ! ${stud_file} == "" ]; then
        echo "Evaluating ${i} ..." | lolcat
        # changing the permission of the task file

        chmod +x students/${i}/${stud_file}

        # executeing the file and redirecting the o/p to file named temp.txt

        ./students/${i}/${stud_file} >students/${i}/temp.txt

        # getting no of incorrect/delta lines
        tmp_no=$(diff -u expected.txt students/${i}/temp.txt | grep ^'+' | wc -l)
        final_no=$((${tmp_no} - 1))

        # if incorrect lines is 0 nove to else.

        if [ ${final_no} != -1 ]; then
            # calculating the marks of the student.
            stud_mark=$((${final_no} * 5))
            stud_mark=$((${MaxMark} - ${stud_mark}))

            if [[ ${stud_mark}  < 0 ]]; then
                stud_mark=0
            fi
            echo "${i} has incorrect output (${final_no} lines are not matching)."

        else
            final_no=0
            echo "${i} has Correct output."

        fi
        echo "${i} has earned a score of ${stud_mark} / ${MaxMark}"
        python3 mail.py ${i} ${stud_mark} ${final_no} <email># send the mail to the student using python3
        echo ""
        echo "----------------------------------------------------"
        rm students/${i}/temp.txt

    else
        # student who has not returend his assignment.
        echo ${i} "have no turened in Assignment."
        python3 mail.py ${i} '' '' <email> # send the mail to the student using python3
        echo ""
        echo "----------------------------------------------------"
    fi

done
