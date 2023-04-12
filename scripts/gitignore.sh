#! /bin/bash

if [ $# -eq 0 ]; then
	echo "Error: No languages specified"
	echo "Usage: $0 [language1] [language2] ..."
	exit 1
fi

languages=""

for var in "$@"
do
	languages="${languages},${var}"
done

languages="${languages#,}"

url="https://www.toptal.com/developers/gitignore/api/${languages}"
echo "Downloading Gitignore file from $url"

curl "$url" -o .gitignore

echo "Gitignore file downloaded successfully"
