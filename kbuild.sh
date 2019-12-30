#!/usr/local/bin/bash

# ==============================================================================
# SET OPTIONS
# ==============================================================================

usage()
{
    cat <<EOF
 
 PURPOSE:
 This script knits and builds jekyll website.
 
 USAGE: 
 $0 <arguments>
 
 ARGUMENTS:
    [-k]        File to knit (w/o ending)
    [-a]        Knit all files (optional flag)
    [-i]        Directory of *.Rmd files
    [-s]        Directory where purled scripts files should go
    [-b]        Suffix to go on _config*.yml and _site* directory
    [-v]        Render / build verbosely (optional flag)
    		
 EXAMPLES:
 
 ./knit_build.sh -a
 ./knit_build.sh -k intro
 ./knit_build.sh -a -i _posts -b _dev

 DEFAULT VALUES:

 a = 0 (do not knit all) 
 i = _modules
 s = scripts
 b = <empty string>
 v = 0 (knit/build quietly)

EOF
}

# defaults
a=0
i="_modules"
o=$i				# leaving output == input right now
s="scripts"
b=""
v=0

knit_q="TRUE"
build_q="--quiet"

while getopts "hk:ai:s:b:v" opt;
do
    case $opt in
	h)
	    usage
	    exit 1
	    ;;
	a)
	    a=1
	    ;;
	k)
	    k=$OPTARG 
	    ;;
	i)
	    i=$OPTARG
	    ;;
	s)
	    s=$OPTARG
	    ;;
	b)
	    b=$OPTARG
	    ;;
	v)
	    v=1
	    ;;
	\?)
	    usage
	    exit 1
	    ;;
    esac
done

# exit if did not choose either file or all files
if [ -z "$k" ] && [ $a -eq 0 ]; then
    echo "Must chose *.Rmd file to knit if -a flag not used"
    exit 1
fi 

# change quiet options if verbose flag is chosen
if [[ $v == 1 ]]; then
    knit_q="FALSE"
    build_q=""
fi

printf "\nKNIT RMARKDOWN / BUILD JEKYLL SITE\n"
printf -- "----------------------------------\n"

# ==============================================================================
# PRINT OPTIONS
# ==============================================================================

printf "\n[ Options ]\n\n"

if [ $a == 1 ]; then
    p="all *.Rmd files"
else
    p="${k}.Rmd"
fi
       
printf "  Knitting                    = %s\n" "$p"
printf "  *.Rmd input directory       = %s\n" "$i"
printf "  *.R script output directory = %s\n" "$s"
printf "  Directory of built site     = _site%s\n" "$b"

# ==============================================================================
# KNIT
# ==============================================================================

printf "\n[ Knitting and purling... ]\n\n"

# loop through all Rmd files
if [ $a == 0 ]; then
    printf "  $k.Rmd ==> \n"
    f="$i/$k.Rmd"
    ## knit
    Rscript -e "rmarkdown::render('$f', output_dir='$o', quiet = $knit_q)"
    printf "     $o/$k.md\n"
    ## purl
    Rscript -e "knitr::purl('$f', documentation = 0, quiet = $knit_q)" > /dev/null
    printf "     $s/$k.R\n"
    ## more than one line after removing \n? mv to scripts directory : rm
    [[ $(tr -d '\n' < ${k}.R | wc -l) -ge 2 ]] && mv ${k}.R $s/${k}.R || rm ${k}.R
else
    for file in ${i}/*.Rmd
    do
	## get file name without ending
	f=$(basename "${file%.*}")
	printf "  $f.Rmd ==> \n"
	## knit
	Rscript -e "rmarkdown::render('$file', output_dir='$o', quiet = $knit_q)"
	printf "     $o/$f.md\n"
	## purl
	Rscript -e "knitr::purl('$file', documentation = 0, quiet = $knit_q)" > /dev/null
	printf "     $s/$f.R\n"
	## more than one line after removing \n? mv to scripts directory : rm
	[[ $(tr -d '\n' < ${f}.R | wc -l) -ge 2 ]] && mv ${f}.R $s/${f}.R || rm ${f}.R
    done
fi

# ==============================================================================
# BUILD
# ==============================================================================

printf "\n[ Building... ]\n\n"

bundle exec jekyll build $build_q --config ./_config${b}.yml --destination ./_site${b} --verbose
printf "  Built site ==>\n"
printf "     config file:   _config$b\n"
printf "     location:      _site$b\n"

# ==============================================================================
# BUILD
# ==============================================================================

printf "\n[ Finished! ]\n\n"

# ==============================================================================
