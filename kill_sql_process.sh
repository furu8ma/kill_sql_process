#!/bin/sh

export LANG=c;

HOME="./";

DB_HOST="hogehoge_host01";
DB_USER="db_user";
DB_PASS="db_password"
GREP_STR="SELECT";
TIME_OUT="180";

MYSQL="mysql -h $DB_HOST -u $DB_USER -p$DB_PASS"
SHOW="show full processlist;"
TMP1="$HOME/tmp.txt";


NOW=`date +"%Y%m%d_%p_%I%M%S"`
TODAY=`date +"%Y%m%d";`
KILL_TARGET_FILE="$HOME/kill_$NOW.txt";
LOG_FILE="$HOME/kill_$TODAY.log";

echo $SHOW | $MYSQL | grep "$GREP_STR" > $TMP1

echo "--- $NOW ---" >> $LOG_FILE;

while read  line;
do
    pid=`echo ${line} | cut -d " " -f 1`
    time=`echo ${line} | cut -d " " -f 6`

    echo "pid=$pid,time=$time";

    if [ $time -gt $TIME_OUT ];
    then
        echo "kill $pid;" >> $KILL_TARGET_FILE;
        echo "$line" >> $LOG_FILE;
        $MYSQL < $KILL_TARGET_FILE;
        rm $KILL_TARGET_FILE;
        rm $TMP1;
    fi;

done < $TMP1;

