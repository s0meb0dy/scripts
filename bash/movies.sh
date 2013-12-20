#!/bin/sh
# i run this on monday to email what movies are playing on a particular day at 2 different theaters
# email won't contain showtimes but link will lead to google page that does.
# variable daysahead should be at least 0 to show current day movies.
# it depends on the theater for how many days ahead showtimes are available for.
# i use msmtp for my command line email sending but the email string can be whatever works for you as long as you can cat it as input to the email string.
# if you find a theater you want to use you just need the "tid" variable from the url on the theater page and modify the site url.
# you can comment out the second theater variables and lines 26-29 if you only want one theater
# 
cd /tmp
theater1name="Regency Buenaventura 6"
site1="http://www.google.com/movies?hl=en&tid=a8d163eb84d7c0e3"
theater2name="Regency Janss Marketplace 9"
site2="http://www.google.com/movies?hl=en&tid=f02917d7d00a9069"
daysahead1="3"
daysahead2="2"
siteurl1="$site1""&date=""$daysahead1"
siteurl2="$site2""&date=""$daysahead2"
fromemail=user@example.com
toemail=user@example.com
emailstring="msmtp -a gmail $fromemail"

echo -e "To: $fromemail\nFrom: $toemail\nSubject: This weeks movies\nMIME-Version: 1.0\nContent-Type: text/html\nContent-Disposition: inline\n" > movies.mail
echo "<a href="$site1">$theater1name</a><br>" >> movies.mail
echo "<br>" >> movies.mail
curl -s -L $siteurl1 | sed 's/<div class=name><a href="/\n\&nbsp;\&nbsp;\&nbsp;\&nbsp;<a href="http:\/\/google.com/g' | grep '<a href="http://google.com' | sed 's/[^ ]*<\/a>/&<br><br>\n/' | grep '<a href="http://google.com' >> movies.mail
echo "<br><br>"	>> movies.mail
echo >> movies.mail
echo "<a href="$site2">$theater2name</a><br>" >> movies.mail
echo "<br>" >> movies.mail
curl -s -L $siteurl2 | sed 's/<div class=name><a href="/\n\&nbsp;\&nbsp;\&nbsp;\&nbsp;<a href="http:\/\/google.com/g' | grep '<a href="http://google.com' | sed 's/[^ ]*<\/a>/&<br><br>\n/' | grep '<a href="http://google.com' >> movies.mail
echo >> movies.mail
echo "." >> movies.mail
cat movies.mail | $emailstring
