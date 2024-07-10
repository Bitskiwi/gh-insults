####################################################
# MODIFIED FROM https://github.com/bitskiwi/ghfetch
####################################################

###### DISCLAIMER: this code is shit, im not a bash master, i fuckin suck 

# get the username via command parameter

declare user=$1

# get the github API json for the user

#declare json=$(curl -s "https://api.github.com/users/$user")
declare json=$(cat bitskiwi.json)

# get information

declare name=$(echo $json | grep -o '"name": *"[^"]*"' | awk -F'"' '{print $4}')
declare bio=$(echo $json | grep -o '"bio": *"[^"]*"' | awk -F'"' '{print $4}')
if [[ $bio == "" ]]
then
	bio="No Info"
fi
declare followers=$(echo $json | grep -o '"followers": *[^,]*' | awk -F': ' '{print $2}')
declare following=$(echo $json | grep -o '"following": *[^,]*' | awk -F': ' '{print $2}')
declare repos=$(echo $json | grep -o '"public_repos": *[^,]*' | awk -F': ' '{print $2}')
declare birth=$(echo $json | grep -o '"created_at": *"[^"]*"' | awk -F'"' '{print $4}')
declare twitter=$(echo $json | grep -o '"twitter_username": *"[^"]*"' | awk -F'"' '{print $4}')

stars=0

#declare repo_json=$(curl -s "https://api.github.com/users/$user/repos")

declare repo_json=$(cat repos.json)

while IFS= read -r line; do
	if [[ "$line" == *"\"stargazers_count\":"* ]]
	then
		#echo $line
		star=$(echo "$line" | cut -d':' -f2)
		star=$(echo "$star" | cut -d',' -f1)
		stars=$((stars + star))
	fi
done <<< "$repo_json"

# print the info

total=100

echo
echo -e "\Uf0004 $name"
echo -e "\uea74 $bio"

# FOLLOWERS

echo -n -e "\Uf0849 $followers followers - "
if [[ $followers -eq 0 ]]; then
	echo "lets be honest have you made anything worth following?"
	total=$(($total - 30))
elif [[ $followers -ge 30 ]] && [[ $followers -le 100 ]]; then
	echo "Let me guess you made a discord bot?"
	total=$(($total - 20))
elif [[ $followers -gt 100 ]]; then
	echo "If the fake internet points make you happy who am I to judge?"
	total=$(($total - 5))
else
	echo ""
fi

# FOLLOWING
 
echo -n -e "\Uf1570 $following following - "
if [[ $following -ge 30 ]] && [[ $followers -eq 0 ]]; then
	echo "Github's not instagram they aren't gonna follow back"
	total=$(($total - 20))
elif [[ $following -ge 100 ]] && [[ $followers -le 10 ]]; then
	echo "this account is just a bot"
	total=$(($total - 50))
else
	echo ""
fi

# REPOS

echo -n -e "\uf487 $repos - "
if [[ $repos -eq 0 ]]; then
	echo "For fucks sake don't make a github account just to say you have one"
	total=$(($total - 50))
elif [[ $repos -le 5 ]] && [[ $repos -gt 0 ]]; then
	echo "do some more projects"
	total=$(($total - 30))
elif [[ $repos -le 15 ]] && [[ $repos -gt 5 ]]; then
	echo "not terrible"
	total=$(($total - 20))
elif [[ $repos -le 100 ]] && [[ $repos -gt 15 ]]; then
	echo "pretty good"
	total=$(($total - 10))
elif [[ $repos -gt 100 ]]; then
	echo "let's be honest how repos many are config files?"
	total=$(($total - 20))
else
	echo ""
fi

# STARS

echo -n -e "\u2605 $stars - "

if [[ $stars -ge 0 ]] && [[ $stars -lt 10 ]]; then
	echo "are your repos all from a CS class?"
	total=$((total - 30))
elif [[ $stars -ge 10 ]] && [[ $stars -lt 30 ]]; then
	echo "yeah... you make minecraft mods, don't you..."
	total=$((total - 30))
elif [[ $stars -ge 30 ]]; then
	echo "you do good projects but have no life"
else
	echo ""
fi

echo -e "\Uf00eb $birth"
echo -n -e "@$twitter - "

if [[ ! -z $twitter ]]; then
	echo "twitter user"
	total=$(($total - 20))
else
	echo "no twitter? good job"
fi

# TOTAL

echo
echo -n "Total: "

if [[ $total -ge 0 ]] && [[ $total -lt 50 ]]; then
	echo "$total (Sad excuse for a github account)"
elif [[ $total -ge 50 ]] && [[ $total -lt 60 ]]; then
	echo "$total (Dogshit)"
elif [[ $total -ge 60 ]] && [[ $total -lt 70 ]]; then
	echo "$total (The Borat of programming)"
elif [[ $total -ge 70 ]] && [[ $total -lt 80 ]]; then
	echo "$total (volevo solo vedere se hai tradotto, comunque vaffanculo)"
elif [[ $total -ge 80 ]] && [[ $total -lt 90 ]]; then
	echo "$total (you kinda good ngl)"
elif [[ $total -ge 90 ]] && [[ $total -lt 100 ]]; then
	echo "$total (you would be rich off your ideas if you hadn't spent all your money on that fursuit)"
fi
echo
