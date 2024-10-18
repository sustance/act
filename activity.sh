#!/bin/sh

if [ -d /home/i/identity ]; then
    o="/home/i/identity/public_html/a.txt"
else
    o="/home/${USER:-$(whoami)}/public_html/a.txt"
fi

# Append ping to file only if it's a number
#case $pingn in
#    ''|*[!0-9.]*) ;;  # not a number, do nothing
#    *) echo "$pingn" >> "${HOME}/.local/ping.txt" ;;
#esac

# Calculate ping averages Use awk 
overall_avg=$(awk '
    BEGIN { sum = 0; count = 0 }
    $1 ~ /^[0-9]+(\.[0-9]+)?$/ { sum += $1; count++ }
    END {
        if (count > 0)
            printf "%.2f", sum / count
        else
            print "NA"
    }
' "${HOME}/.local/ping.txt")
#echo "Overall average: $overall_avg"

# Generate output, C_ID is set with command as a label 
{
printf "\n<pre>"
printf "   <u>%-15.15s %-3s %-5s %-5s %-5s %-4s</u> \n" \
	   "Hostname" "OS" "Tilde" "Lua" "Php" "r-Sh"
           
printf "]%s %-15.15s %s %-5s %-5s %-5s %-8s \n" \
       "${C_ID:-N}" \
       "${HOSTNAME} $(cat /proc/sys/kernel/hostname)" \
       "$(uname | cut -c -3 )" \
       "$(tilde -V 2>/dev/null | grep "Tilde v" | sed 's/Tilde version //' || echo "<s>tilde</s>")" \
       "$(lua -v 2>/dev/null | awk 'NR==1 {print $2}' | cut -d. -f1,2 || echo "<s>lua</s>")" \
       "$(php --version 2>/dev/null | awk 'NR==1 {print $2}' | cut -d. -f1,2 || echo "<s>php</s>")" \
       "$(basename "$SHELL") $(0)"
       
       # D, P ok $HOSTNAME.... C, E, J, O, T, S  OK cat /proc....

printf "|%s %s %s %s %s %s\n" \
	"${C_ID:-N}" \
 	"$(command -v crontab >/dev/null 2>&1 && echo "cron"  || echo "<s>cron</s>")" \
	"$(command -v w3m     >/dev/null 2>&1 && echo "w3m"   || echo "<s>w3m</s>")" \
	"$(command -v lynx    >/dev/null 2>&1 && echo "lynx"  || echo "<s>lynx</s>")" \
	"$(command -v links   >/dev/null 2>&1 && echo "links" || echo "<s>links</s>")" \
	"$(command -v curl    >/dev/null 2>&1 && echo "curl"  || echo "<s>curl</s>")" 
 
	#"$(command -v finger >/dev/null 2>&1 && echo "finger"|| echo "<s>finger</s>")"
	#"$(command -v irssi  >/dev/null 2>&1 && echo "irssi" || echo "<s>irssi</s>")"

printf "|%s %s %s %s\n" \
        "${C_ID:-N}" \
	"$(command -v ruby    >/dev/null 2>&1 && echo "ruby"  || echo "<s>ruby</s>")" \
	"$(command -v newsboat >/dev/null 2>&1 && echo "newsboat"|| echo "<s>newsboat</s>")" \
 	"$(command -v weechat >/dev/null 2>&1 && echo "weechat"|| echo "<s>weechat</s>")" 
 
printf "[%s %s\n" \
	   "${C_ID:-N}" \
	   "$(grep "^$(whoami):" /etc/passwd | \
	   sed 's/identit//g; s/id2/d2/g; s/aaa/aa/g; s/in//; s/sr//; s/ome//; s/nfo//; s/kg//; s/ocal//; s/,,,//; s/User \&// ; s/:100:/: 100:/')" 

printf "   <u>%-8s %-8s|%-3s %-3s %-3s %-3s</u>\n" \
       "@H.K." "@Site" "dns" "h.k" "ave" "Ping"	

printf "   %-8s %-8s %-3s %-3s %-3s %-3s\n" \
       "$(TZ=UTC-8 date +'%H:%M/%d' 2>/dev/null || date +'%H:%M/%d')" \
       "$(date +'%H:%M/%d')" \
       "$(ping -c 1 -w 1 8.8.8.8 >/dev/null 2>&1 && ping -c 3 8.8.8.8 2>/dev/null \
       		| awk -F'/' 'END {printf "%.0f\n", $5}' || echo "NA")" \
        "$(ping -c 1 -w 1 123.255.88.1 >/dev/null 2>&1 && ping -c 3 123.255.88.1 2>/dev/null \
        	| awk -F'/' 'END {printf "%.0f\n", $5}' || echo "NA")" \
       "$overall_avg" \
       "$total_count"
       #123.255.91.198 an alternate 203.104.103.86 Japan Net Info Ctr (JPNIC)
    	
    if [ -d /home/i/identity ]; then
        printf "<span style='color:red;'>no last access info</span>\n"
    elif [ -d /home/aaa/store ]; then
    	printf "<span style='color:red;'>access list off for aaa</span>\n"
    else
		# Get the date 4 days ago in YYYY-MM-DD format
		# Try Linux, then fall back to current date
		four_days_ago=$(date -d '-4 days' +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)
		# Get the current user
		current_user=${USER:-$(whoami)}
		# Fetch login times for the current user in the last 4 days
		last_access=$(last -t "$four_days_ago" "$current_user" 2>/dev/null |
              awk -F'[()]' '{print $2}' |  # Extract timestamps
              tr '\n' ' ' |                # Join lines
              sed 's/00:0[0-9]//g; s/00//g; s/ 0/ /g')  # Remove leading zeros
		# Print the result in red
		printf "</pre>\n\n<p style='color:red;'>%s</p>" "$last_access"
    fi 

} > "$o"

cat "$o"


#ps -p $$ – Display your current shell name reliably.
#echo "$SHELL" – Print the shell for the current user but not necessarily the shell that is running at the movement.
#echo $0 – Another reliable and simple method to get the current shell interpreter name on Linux or Unix-like systems.
#readlink /proc/$$/exe – Another option to get the current shell name reliably on Linux operating systems.
#cat /etc/shells – List pathnames of valid login shells currently installed
#NO RESULT grep "^$USER" /etc/passwd – Print the default shell name. The default shell runs when you open a terminal window.

