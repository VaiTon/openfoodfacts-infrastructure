#!/bin/bash

# Don't forget chmod +x proplatform.sh

path="/home/off/mirabelle/"
db="off-stats.db"
year=`date +"%Y"`
month=`date +"%m"`
day=`date +"%d"`

# Total number of products sent via the pro platform in some countries at a certain day.
table="products_from_owners"

# Fill the countries for which we want stats

# Do not use Open Food Facts' API, there are too much apps errors.

# TODO: retry while products.db hasn't been updated today
# TODO: test if values has been entered before

for country in austria belgium switz germany spain france ireland italy netherland poland portugal united-kingdom united-states
do
count=$(sqlite3 products.db "select count(code) from [all] where countries_en like '%country%' and owner != ''")
echo "insert into $table values ('$year','$month','$day','$country',$nb);"
#sqlite3 ${path}${db} "insert into $table values ('$year','$month','$day','$country',$nb) ON CONFLICT (year, month, day, country, nb) UPDATE SET nb = $nb;"

done

#sudo systemctl restart datasette.service
