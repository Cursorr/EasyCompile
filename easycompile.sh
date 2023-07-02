#!/bin/bash

displayRed() {
    echo -e "\e[31m$1 \e[0m"
}

displayGreen() {
    echo -e "\e[32m$1 \e[0m"
}

compileHeader() {
    headerFile=$1
    if ! [[ -f "$headerFile" ]]; then
        displayRed "The header file $headerFile does not exist in your directory."
        exit
    fi

    displayGreen "Compiling the header file $headerFile"
    gcc -Wall -Wextra -std=c99 -Wpedantic -g -fsanitize=address,undefined -c "$headerFile" -o "${headerFile%.h}.o"

    if ! [ $? -eq 0 ]; then
        displayRed "Failed to compile the header file $headerFile"
        exit
    fi

    displayGreen "Compilation of the header file $headerFile completed"
}

compileSource() {
    sourceFile=$1
    if ! [[ -f "$sourceFile" ]]; then
        displayRed "The source file $sourceFile does not exist in your directory."
        exit
    fi

    displayGreen "Compiling the source file $sourceFile"
    gcc -Wall -Wextra -std=c99 -Wpedantic -g -fsanitize=address,undefined -c "$sourceFile" -o "${sourceFile%.c}.o"

    if ! [ $? -eq 0 ]; then
        displayRed "Failed to compile the source file $sourceFile"
        exit
    fi

    displayGreen "Compilation of the source file $sourceFile completed"
}

if [ $# -eq 0 ]; then
    displayRed "You must enter at least one filename as a command argument."
    exit
fi

for file in "$@"; do
    if [[ $file == *.h ]]; then
        compileHeader "$file"
    elif [[ $file == *.c ]]; then
        compileSource "$file"
    else
        displayRed "The file $file is neither a header file (.h) nor a source file (.c). Ignored."
    fi
done

displayGreen "All compilations completed successfully."
