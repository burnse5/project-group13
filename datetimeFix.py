# convert Microsoft SQL datetime to postgreSQL timestamp
#
# John DeGood
# degoodj@tcnj.edu
# March 2024
#
# usage: python datetimeFix.py in_filename out_filename datetime_index ...
#
# examples:
# python datetimeFix.py Animal.csv Animal.out 8 17 23 24 26 30 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 54
# python datetimeFix.py Note.csv Note.out 1
# python datetimeFix.py SessionAnimalActivity.csv SessionAnimalActivity.out 3
# python datetimeFix.py SessionAnimalTrait.csv SessionAnimalTrait.out 5

from sys import argv, exit
from time import gmtime, strftime

if len(argv) < 4:
    print('usage: python datetimeFix.py in_filename out_filename datetime_index ...')
    exit(1)

in_name  = argv[1]  # input filename
out_name = argv[2]  # output filename

# convert Microsoft SQL datetime to PostgreSQL timestamp
# Microsoft SQL extended datetime is an integer representing 0.1 microsecond ticks since year 1
# PostgreSQL timestamp is an ISO 8601 string, e.g., '2016-01-08 04:05:06.789'
# references:
# https://support.microsoft.com/en-gb/office/using-the-date-time-extended-data-type-708c32da-a052-4cc2-9850-9851042e0024
# https://www.postgresql.org/docs/current/datatype-datetime.html
# https://www.postgresql.org/docs/current/datetime-input-rules.html
def datetimeConvert(datetime):
    '''
    # can't convert zero fields
    if int(datetime) == 0:
        return datetime
    '''

    # convert to msec by stripping last 4 digits
    datetime = datetime[:-4]
    # save msec
    msec = datetime[-3:]
    # strip msec to get int sec
    sec = int(datetime[:-3])
    # difference in seconds between Microsoft epoch of Jan 1, 0001 and Python epoch of Jan 1, 1970
    epochDiffSeconds = 62135596800 # from https://www.gigacalculator.com/calculators/date-time-duration-calculator.php
    # convert sec to Python epoch
    sec = sec - epochDiffSeconds
    # convert to an ISO 8601 string from a Python time struct
    result = strftime("%Y-%m-%d %H:%M:%S", gmtime(sec))
    # append msec fraction
    return result + '.' + msec

# translate Microsoft datetime attribute to ISO 8601 string
with open(in_name, mode='r', newline='') as in_file:
    with open(out_name, mode='w', newline='') as out_file:
        count = 0
        # process in_file
        for row in in_file:
            row = row.strip().split(',')
            # don't change the header row
            if count > 0:
                # convert the Microsoft datetime field(s) to an ISO 8601 string
                for i in range(3,len(argv)):
                    arg = int(argv[i])
                    # convert datetime of 0 to empty string because timestamp of 0 is illegal
                    if len(row[arg]) == 0 or int(row[arg]) == 0:
                        row[arg] = ''
                    else:
                        row[arg] = datetimeConvert(row[arg])
            count += 1
            # write corrected row to out_file
            row = ','.join(row)
            out_file.write(row + '\n')
print("processed", count, "rows")
