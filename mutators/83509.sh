#shebang line
#!/bin/bash

# If the number of arguments is not equal to 2 then exit and print error message
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <seed>"
    exit 1
fi

#bash script

sed -E 's/extern[[:space:]]*"C"/static/g' "$1" > "$2"
