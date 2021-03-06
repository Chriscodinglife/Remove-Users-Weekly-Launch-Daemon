#!/bin/bash

# Christian Orellana
# Delete User Script


## UNINSTALL ALL FILES FIRST
sudo launchctl unload -w /Library/LaunchDaemons/com.pratt.Chris.iDontWantYouHere.plist

## DELETE THE PLIST FILE
rm /Library/LaunchDaemons/com.pratt.Chris.iDontWantYouHere.plist

## DELETE THE BASH SCRIPT AND FOLDER
rm -rf /Library/Scripts/iDontWantYouHere

## DELETE THE deletedusers.log
rm /Library/Logs/deletedusers.log


## INSTALL ALL FILES

### CREATE THE BASH SCRIPT FILE
mkdir /Library/Scripts/iDontWantYouHere

touch /Library/Scripts/iDontWantYouHere/iDontWantYouHere.sh

cat << 'EOF' >> /Library/Scripts/iDontWantYouHere/iDontWantYouHere.sh
#!/bin/bash

## iDont Want You Here Bash Script

## Christian Orellana
## October 2018

#########

## DESCRIPTION

# Delete your AD/OD User account Home Folders under the /Users directory.
# This script was designed for Pratt Institute Manhattan Campus Mac Environment

#########

## REFERENCES

# https://www.tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_02.html
# https://stackabuse.com/array-loops-in-bash/
# https://www.tldp.org/LDP/abs/html/loopcontrol.html
# https://support.apple.com/de-at/HT2420
# http://www.grivet-tools.com/blog/2014/launchdaemons-vs-launchagents/

#########

## NOTES

#########

## VARIABLES && ARRAYS

date=$(/bin/date +"%d_%m_%Y")

keep1="admin"
keep2="Shared"

userList=`/usr/bin/find /Users -type d -maxdepth 1 -mmin +$((60*24)) -not -name "*.*" | cut -d"/" -f3`

#########

## FUNCTIONS

# Delete the User in the User Folder
deleteUser() {

	# Check is the list has admin or Shared
	for user in $userList; do

		# The list will not have logged in users being passed through
		[[ "$user" == "$keep1" ]] && continue #skip the admin
		[[ "$user" == "$keep2" ]] && continue #skip the Shared Folder

		# Delete the user folder in the /Users directory
		/bin/rm -Rf /Users/$user

		# Delete the user account
		/usr/bin/dscl . -delete $user

		# Create a log file
		/bin/echo "$user was delete on $date" >> /Library/Logs/deletedusers.log

	done

}

#########

## RUNABLE CODE

deleteUser

exit 0
EOF

## SET BASH SCRIPT PERMISSIONS

chown root:wheel /Library/Scripts/iDontWantYouHere/iDontWantYouHere.sh
chmod 644 /Library/Scripts/iDontWantYouHere/iDontWantYouHere.sh
chmod +x /Library/Scripts/iDontWantYouHere/iDontWantYouHere.sh

## CREATE THE PLIST FILE

touch /Library/LaunchDaemons/com.pratt.Chris.iDontWantYouHere.plist

cat << 'EOF' >> /Library/LaunchDaemons/com.pratt.Chris.iDontWantYouHere.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
	<dict>
		<key>Label</key>
		<string>com.pratt.Chris.iDontWantYouHere</string>
		<key>Program</key>
		<string>/Library/Scripts/iDontWantYouHere/iDontWantYouHere.sh</string>
		<key>RunAtLoad</key>
		<true/>
	</dict>
</plist>
EOF

## SET PLIST PERMISSIONS

chown root:wheel /Library/LaunchDaemons/com.pratt.Chris.iDontWantYouHere.plist
chmod 644 /Library/LaunchDaemons/com.pratt.Chris.iDontWantYouHere.plist

# LOAD THE PLIST FILE 

launchctl load -w /Library/LaunchDaemons/com.pratt.Chris.iDontWantYouHere.plist
