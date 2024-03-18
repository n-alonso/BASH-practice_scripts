#!/usr/bin/env bash

# Setup
RANDOM=4096
points=0
responses=("Perfect!" "Awesome!" "You are a genius!" "Wow!" "Wonderful!")
responses_length="${#responses[@]}"

# Login
curl -so ID_card.txt http://127.0.0.1:8000/download/file.txt
username=$(cat ID_card.txt | jq '.username')
password=$(cat ID_card.txt | jq '.password')
curl -so cookie.txt --cookie-jar cookie -u "${username}:${password}" http://127.0.0.1:8000/login

print_menu() {
    echo '0. Exit'
    echo '1. Play a game'
    echo '2. Display scores'
    echo '3. Reset scores'
    echo 'Enter an option:'
}

play_game() {
    if ! [ -e scores.txt ]; then
        touch scores.txt
    fi
    
    echo 'What is your name?'
    read name

    while [ true ];do
        game=`curl --cookie cookie http://127.0.0.1:8000/game`
        question=$($game | jq '.question')
        answer=$($game | jq '.answer')
    
        echo "$question"
        echo 'True or False?'
        read user_answer
    
        if [ "$user_answer" = "$answer" ]; then
            $points=$(($points + 10))
            random_index=$(($RANDOM % $array_length))
            echo "${responses[$random_index]}"
        else
            echo "User: $name, Score: $points, Date: $(date)" >> scores.txt
            echo 'Wrong answer, sorry!'
            echo "$name you have $(($points / 10)) correct answer(s)."
            echo "Your score is $points points."
            break
        fi
    done
}

print_scores() {
    if [ -e scores.txt ]; then
        echo 'Player scores'
        cat scores.txt
    else
        echo 'File not found or no scores in it!'
    fi
}

reset_scores() {
    if ! [ -e scores.txt ] || ! [ -s scores.txt ]; then
        echo 'File not found or no scores in it!'
    else
        rm -f scores.txt
        echo 'File deleted successfully!'
    fi
}

echo 'Welcome to the True or False Game!'
while [ true ]; do
    print_menu
    read option
    
    case $option in
        1 )
            play_game;;
        2 )
            print_scores;;
        3 )
            reset_scores;;
        0 )
            echo 'See you later!'
            break;;
        * )
            echo 'Invalid option!';;
    esac
done
