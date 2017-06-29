#!/bin/bash

# Usage message

usage="
\n---USAGE---\n
\n
    Description:\n\n
This script download the Silva database and the taxonomy of Silva release_128. A different database or taxonomy files\n
can be provided by entering the link to them as optional input.\n
\n
    Optional inputs\n
\n
-d Link to reference 16S rRNA database file [fasta]\n
-t Link to SILVA taxonomy\n
\n
    Output:\n
\n
A reference 16S rRNA database in fasta format \n
A taxonomy file customized for NG-Tax\n\n
Example of usage:\n\n
Default -> Silva release_128:\n
$0
Providing links to a different Silva reference 16S database or to a different Silva taxonomy:\n
$0 -d link_to/SILVA_128_SSURef_tax_silva.fasta -t link_to/tax_slv_ssu_128.txt\n\n
output:\n
SILVA_128_SSURef_tax_silva.fasta\n
tax_slv_ssu_128.txt\n\n
--- End of USAGE ---\n
"

# Help option, check number of argument.

if [[ "$1" == "-h" ]]
  then
    echo -e $usage
    exit 0
elif [[ $# -ne 0 && $# -ne 2 && $# -ne 4 ]]
  then
    echo -e "ERROR: Invalid number of args \nTry $0 -h for help"
    exit 1
fi

# Assign arguments to variables, check for invalid arguments.

while getopts d:t:k:p:q:f:r:x:o:e:y:z: opt
  do
  case "$opt" in
    d)
      database_link=${OPTARG}
      ;;
    t)
      taxonomy_link=${OPTARG}
      ;;
    *)
      echo -e "\nERROR: invalid arguments used\n";
      exit 1
      ;;
    esac
done

# Install brew, wget, gzip and clustalw

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install wget
brew install gzip
brew install clustalw

# Download Silva databases

mkdir SILVA_db
cd SILVA_db

if [[ "$database_link" != "" ]]

	then
    wget $database_link
    bname_db=$(basename "$database_link")
    gunpzip bname_db
  else
    wget https://www.arb-silva.de/fileadmin/silva_databases/release_128/Exports/SILVA_128_SSURef_tax_silva.fasta.gz
    gunpzip SILVA_128_SSURef_tax_silva.fasta.gz
fi

if [[ "$database_link" != "" ]]

	then
    wget $taxonomy_link
  else
    wget https://www.arb-silva.de/fileadmin/silva_databases/release_128/Exports/taxonomy/tax_slv_ssu_128.txt
fi

# Add bin folder to PATH

cd ../bin

path_to_NG_tax=$(pwd)
echo -e "\n#Added by NG-Tax installer" >>  ~/.bashrc
echo -e 'export PATH="$PATH:'$path_to_NG_tax'"\n' >>  ~/.bashrc
source  ~/.bashrc

cd ../test_set

# Update changes

bash