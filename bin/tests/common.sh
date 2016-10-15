errors=0
warnings=0
pass=0
total=0

NORMAL="\e[39m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"

update_count()
{
	let total=$total+$2+$3+$4
	let pass=$pass+$2
	let warnings=$warnings+$3
	let errors=$errors+$4
	if [ $2 -gt 0 ]
	then
		echo -e "Test: $1 \t\t\t\t\t [${GREEN}PASS${NORMAL}]"
	else
		echo -e "Test: $1 \t\t\t\t\t [${RED}FAIL${NORMAL}]"
	fi
}

display_total()
{
	if [ $pass -eq $total ]
	then
		echo -e "[${GREEN}$pass${NORMAL}/$total] Tests Passed."
	else
		echo -ne "[${YELLOW}$pass${NORMAL}/$total] Tests Passed. "
		if [ $warnings -ne 0 ]
		then
			echo -ne "${YELLOW}$warnings Warnings.${NORMAL} "
		fi
		if [ $errors -ne 0 ]
		then
			echo -ne "${RED}$errors Errors.${NORMAL}"
		fi
		echo
	fi
}
