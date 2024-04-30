#!/bin/bash

code=
data=()
pointer=0
loopstart=0

# Populate data array with 32k zeros.
for (( i=0; i<32000; i++ )); do data[i]=0; done

# Gets code from user.
function get_code() {
  printf "🧠 "
  read code
}

# Interpret Brainf**k code.
function interpret() {
  # Commands.
  if [ "$code" = "exit" ]; then exit 0;
  elif [ "$code" = "clear" ]; then clear;
  elif [ "$code" = "help" ]
  then
    echo "clear - Clear terminal."
    echo "exit  - Exit interpreter."
    echo "help  - Display this message."
  fi

  # Iterate over each character.
  i=0
  while [ $i -lt ${#code} ]; do
    c=${code:$i:1} # Individual character.

    if [ "$c" = ">" ]
    then
      if ! [ "$pointer" -eq 32000 ]
      then
        (( pointer++ )) # Increment pointer.
      fi

    elif [ "$c" = "<" ]
    then
      if ! [ "$pointer" -eq 0 ]
      then
        (( pointer-- )) # Decrement pointer if it's > 0.
      fi

    elif [ "$c" = "+" ]
    then (( data[$pointer]++ ))

    elif [ "$c" = "-" ]
    then (( data[$pointer]-- ))

    elif [ "$c" = "." ]; then
      value=${data[$pointer]}
      printf "$(printf '\\x%x' $value)\n"  # Print ASCII value given number.

    elif [ "$c" = "," ]
    then
      while true; do
        printf "#️⃣ "
        read number

        if [[ "$number" =~ ^[0-9]+$ ]]
        then
          (( data[$pointer]=$number ))
          break

        else continue
        fi
      done

    elif [ "$c" = "[" ]
    then (( loopstart = $i ))

    elif [ "$c" = "]" ]
    then
      if ! [ "${data[$pointer]}" -eq 0 ]; then (( i = $loopstart )); fi
    fi

    (( i++ ))
  done
}

# :)
echo "Type 'exit' to exit, 'help' for more commands."

# Get code from user, interpret it, repeat.
while true; do
get_code
interpret
done
