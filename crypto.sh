#!/usr/bin/env bash

IS_VALID_MESSAGE='^[A-Z ]*$'
IS_VALID_FILE_NAME='^[a-zA-Z.]*$'

print_menu() {
    echo '0. Exit'
    echo '1. Create a file'
    echo '2. Read a file'
    echo '3. Encrypt a file'
    echo '4. Decrypt a file'
    echo 'Enter an option:'
}

create_file() {
    echo 'Enter the filename:'
    read file_name

    if [[ "$file_name" =~ $IS_VALID_FILE_NAME ]]; then
        echo 'Enter a message:'
        read message
        
        if [[ "$message" =~ $IS_VALID_MESSAGE ]]; then
            if ! [ -e "$file_name" ]; then
                touch "$file_name"
            fi
            
            echo "$message" > "$file_name"
            echo 'The file was created successfully!'
            continue
        else
            echo 'This is not a valid message!'
            continue
        fi
    else
        echo 'File name can contain letters and dots only!'
        continue
    fi
}

read_file() {
    echo 'Enter the filename:'
    read file_name

    if [ -e "./${file_name}" ]; then
        echo 'File content:'
        cat "./${file_name}"
        continue
    else
        echo 'File not found!'
        continue
    fi
}

encrypt_file() {
    echo 'Enter the filename:'
    read file_name

    if [ -e "$file_name" ]; then
        echo 'Enter password:'
        read password
    
        openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$file_name" -out "${file_name}.enc" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            rm -f "$file_name"
            echo "Success"
        else
            echo "Fail"
        fi
        
        continue
    else
        echo 'File not found!'
        continue
    fi
}

decrypt_file() {
    echo 'Enter the filename:'
    read file_name

    if [ -e "$file_name" ]; then
        echo 'Enter password:'
        read password
    
        openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$file_name" -out "${file_name%.enc}" -pass pass:"$password" &>/dev/null
        exit_code=$?
        if [[ $exit_code -eq 0 ]]; then
            rm -f "$file_name"
            echo "Success"
        else
            echo "Fail"
        fi
        
        continue
    else
        echo 'File not found!'
        continue
    fi
}

echo -e "Welcome to the Enigma!\n"
while [ true ]; do
    print_menu

    read option
    if [ -z "$option" ]; then
        echo 'Invalid option!'
        continue
    fi
    
    case "$option" in
        1 )
            create_file;;
        2 )
            read_file;;
        0 )
            echo 'See you later!'
            break;;
        3 )
            encrypt_file;;
        4 )
            decrypt_file;;
        * )
            echo 'Invalid option!';;
    esac
done
