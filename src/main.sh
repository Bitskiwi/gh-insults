####################################################
# MODIFIED FROM https://github.com/bitskiwi/ghfetch
####################################################

###### DISCLAIMER: this code is shit, im not a bash master, i fuckin suck 

# get the username via command parameter

declare user=$1

# get the github API json for the user

declare json=$(curl -s "https://api.github.com/users/$user")

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

declare repo_json=$(curl -s "https://api.github.com/users/$user/repos")

while IFS= read -r line; do
	if [[ "$line" == *"\"stargazers_count\":"* ]]
	then
		#echo $line
		star=$(echo "$line" | cut -d':' -f1)
		echo $line 
		#"$line" | grep -o '"stargazers_count":[0-9]*'
		#echo $star
	fi
done <<< "$repo_json"

# print the info

total=100

echo
echo -e "\Uf0004 $name"
echo -e "\uea74 $bio"

# FOLLOWERS

echo -e "\Uf0849 $followers followers"
if [[ $followers -eq 0 ]]
then
	echo "lets be honest have you made anything worth following?"
	total=$(($total - 30))
fi
if [[ $followers -ge 30 ]] && [[ $followers -le 100 ]]
then
	echo "Let me guess you made a discord bot?"
	total=$(($total - 20))
fi
if [[ $followers -gt 100 ]]
then 
	echo "If the fake internet points make you happy who am I to judge?"
	total=$(($total - 5))
fi

# FOLLOWING

echo -e "\Uf1570 $following following"
if [[ $following -ge 30 ]] && [[ $followers -eq 0 ]]
then
	echo "Github's not instagram they aren't gonna follow back"
	total=$(($total - 20))
fi
if [[ $following -ge 100 ]] && [[ $followers -le 10 ]]
then
	echo "this account is just a bot"
	total=$(($total - 50))
fi

# REPOS

echo -e "\uf487 $repos"
if [[ $repos -eq 0 ]]
then
	echo "For fucks sake don't make a github account just to say you have one"
	total=$(($total - 50))
fi
if [[ $repos -le 5 ]] && [[ $repos -gt 0 ]]
then
	echo "do some more projects"
	total=$(($total - 30))
fi
if [[ $repos -le 15 ]] && [[ $repos -gt 5 ]]
then
	echo "not terrible"
	total=$(($total - 20))
fi
if [[ $repos -le 100 ]] && [[ $repos -gt 15 ]]
then
	echo "pretty good"
	total=$(($total - 10))
fi
if [[ $repos -gt 100 ]] 
then 
	echo "let's be honest how repos many are config files?"
	total=$(($total - 20))
fi

echo -e "\Uf00eb $birth"
echo -e "$twitter"

if [[ ! -z $twitter ]]
then
	echo "twitter user"
	total=$(($total - 20))
fi

# TOTAL

if [[ $total -ge 0 ]] && [[ $total -lt 50 ]]
then
	echo "$total (dogshit)"
fi

if [[ $total -ge 50 ]] && [[ $total -lt 60 ]]
then
	echo "oirwgnirwegrehtrehwtjreykjrhte"
fi

echo $stars
