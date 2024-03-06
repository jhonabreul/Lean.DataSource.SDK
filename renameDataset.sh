#!/usr/bin/env bash

# Get {vendorNameDatasetName}
vendorNameDatasetName=${PWD##*.}
vendorNameDatasetNameLowerCase=$(echo "${vendorNameDatasetName}" | tr '[:upper:]' '[:lower:]')

rename_files()
{
    originalString=$1
    newString=$2
    type=$3

    find . -depth -type "$type" -name "*${originalString}*" | \
        while read FILE ; 
        do 
            echo "$FILE"; 
            newFileName="$(echo "${FILE}" | sed -e "s/${originalString}/${newString}/")"; 
            mv "${FILE}" "${newFileName}"; 
        done
}

# Rename all directories to replace "MyCustom" with the new vendor name
rename_files "MyCustom" "${vendorNameDatasetName}" "d"
rename_files "mycustom" "${vendorNameDatasetNameLowerCase}" "d"

# Rename all files to replace "MyCustom" with the new vendor name
rename_files "MyCustom" "${vendorNameDatasetName}" "f"
rename_files "mycustom" "${vendorNameDatasetNameLowerCase}" "f"

# Replace all instances of "MyCustom" with the new vendor name
find . \( -type d -name .git -prune \) \( -type f -name "renameDataset\.sh" -prune \) -o -type f -print0 | xargs -0 sed -i "s/MyCustom/${vendorNameDatasetName}/g"
find . \( -type d -name .git -prune \) \( -type f -name "renameDataset\.sh" -prune \) -o -type f -print0 | xargs -0 sed -i "s/mycustom/${vendorNameDatasetNameLowerCase}/g"
