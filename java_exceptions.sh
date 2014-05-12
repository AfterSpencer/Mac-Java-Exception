# Sites to be added

sites=(http://nlvm.usu.edu/ https://apps.usiis.org/)

# Users on system

EXISTINGUSERS=`ls /Users | grep -v Shared | grep -v '\.'`

# Main script 

for site in "${sites[@]}"
do

# Add exceptions to user template
mkdir -p /System/Library/User\ Template/English.lproj/Library/Application\ Support/Oracle/Java/Deployment/security
grep -q "$site" "/System/Library/User Template/English.lproj/Library/Application Support/Oracle/Java/Deployment/security/exception.sites" 2> /dev/null || echo "$site" >> /System/Library/User\ Template/English.lproj/Library/Application\ Support/Oracle/Java/Deployment/security/exception.sites

# Set delimiting value used in the below "for" statements to be a new line
OLD_IFS=$IFS
IFS=$'\n'

# Create folder and set permissions on folder for Java settings

find /Users -name "Application Support" -maxdepth 3 -exec mkdir -p {}/Oracle/Java/Deployment/security \;
find /Users -name "Oracle" -maxdepth 4 -exec chmod -R 755 {} \;

JAVAPREF=$( find /Users -type d -name security )

for i in $JAVAPREF
do
grep -q "$site" "$i"/exception.sites 2> /dev/null || cp /System/Library/User\ Template/English.lproj/Library/Application\ Support/Oracle/Java/Deployment/security/exception.sites "$i"/exception.sites
done
done

# Fix ownership on user folders
for i in $EXISTINGUSERS
do
chown -R "$i": /Users/"$i"/Library/Application\ Support/Oracle
done
