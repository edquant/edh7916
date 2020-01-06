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
    [-i]        Directory of lesson *.Rmd files
    [-p]        Directory of assignment *.Rmd files
    [-s]        Directory where purled scripts files should go
    [-l]        Directory where pdf versions of lessons should go
    [-w]        Directory where pdf versions of assignments (work) should go
    [-b]        Suffix to go on _config*.yml and _site* directory
    [-c]        Output directory for course assignments, data, lessons, and scripts
    [-v]        Render / build verbosely (optional flag)
    		
 EXAMPLES:
 
 ./kbuild.sh -a
 ./kbuild.sh -k intro
 ./kbuild.sh -a -i _posts -b _dev
 ./kbuild.sh -a -c 

 DEFAULT VALUES:

 a = 0 (do not knit all) 
 i = _lessons
 p = _assignments
 s = scripts
 l = lessons
 w = assignments
 b = <empty string>
 c = ../<dir name>_student
 v = 0 (knit/build quietly)

EOF
}

# defaults
a=0
i="_lessons"
p="_assignments"
om=$i				# leaving output == input right now
op=$p
s="scripts"
l="lessons"
w="assignments"
b=""
c=0                             # assuming _student for central repo
v=0

knit_q="TRUE"
build_q="--quiet"
student_repo="../${PWD##*/}_student"
pdfs="assets/pdf"

# pandoc
pandoc_opts="-V geometry:margin=1in --highlight-style tango"

while getopts "hk:ai:p:s:l:b:cv" opt;
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
	p)
	    p=$OPTARG
	    ;;
	s)
	    s=$OPTARG
	    ;;
	l)
	    l=$OPTARG
	    ;;
	b)
	    b=$OPTARG
	    ;;
	c)
	    c=1
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
    pp="all *.Rmd files"
else
    pp="${k}.Rmd"
fi
       
printf "  Knitting                          = %s\n" "$pp"
printf "  Lessons *.Rmd input directory     = %s\n" "$pp"
printf "  Assignments *.Rmd input directory = %s\n" "$pp"
printf "  *.R script output directory       = %s\n" "$s"
printf "  Directory of built site           = _site%s\n" "$b"
if [ $c == 1 ]; then
    printf "  Student files directory           = %s\n" "$student_repo"
fi

# ==============================================================================
# KNIT
# ==============================================================================

printf "\n[ Knitting and purling lessons... ]\n\n"

# loop through all Rmd files
if [ $a == 0 ]; then
    printf "  $k.Rmd ==> \n"
    f="$i/$k.Rmd"
    # skip if starts with underscore
    if [[ $f = _* ]]; then printf "     skipping...\n"; continue; fi
    # knit
    Rscript -e "rmarkdown::render('$f', output_dir='$om', quiet = $knit_q)"
    printf "     $o/$k.md\n"
    # md to pdf
    if [[ -f $om/$k.md ]]; then
	# pandoc ${pandoc_opts} -o $l/$k.pdf $om/$k.md
	sed "s/\/assets/.\/assets/g" $om/$k.md | pandoc ${pandoc_opts} -o $l/$k.pdf -
	cp $l/$k.pdf $pdfs
    fi
    # purl
    Rscript -e "knitr::purl('$f', documentation = 0, quiet = $knit_q)" > /dev/null
    printf "     $s/$k.R\n"
    # more than one line after removing \n? mv to scripts directory : rm
    [[ $(tr -d '\n' < ${k}.R | wc -l) -ge 2 ]] && mv ${k}.R $s/${k}.R || rm ${k}.R
else
    for file in ${i}/*.Rmd
    do
	# get file name without ending
	f=$(basename "${file%.*}")
	printf "  $f.Rmd ==> \n"
	# skip if starts with underscore
	if [[ $f = _* ]]; then printf "     skipping...\n"; continue; fi
	# knit
	Rscript -e "rmarkdown::render('$file', output_dir='$om', quiet = $knit_q)"
	printf "     $om/$f.md\n"
	# md to pdf
	if [[ -f $om/$f.md ]]; then
	    # pandoc ${pandoc_opts} -o $l/$f.pdf $om/$f.md
	    sed "s/\/assets/.\/assets/g" $om/$f.md | pandoc ${pandoc_opts} -o $l/$f.pdf -
	    cp $l/$f.pdf $pdfs
	fi
	# purl
	Rscript -e "knitr::purl('$file', documentation = 0, quiet = $knit_q)" > /dev/null
	printf "     $s/$f.R\n"
	# more than one line after removing \n? mv to scripts directory : rm
	[[ $(tr -d '\n' < ${f}.R | wc -c) -ge 1 ]] && mv ${f}.R $s/${f}.R || rm ${f}.R
    done
fi

printf "\n[ Knitting assignments... ]\n\n"

for file in ${p}/*.Rmd
do
    # get file name without ending
    f=$(basename "${file%.*}")
    printf "  $f.Rmd ==> \n"
    # skip if starts with underscore
    if [[ $f = _* ]]; then printf "     skipping...\n"; continue; fi
    # knit
    Rscript -e "rmarkdown::render('$file', output_dir='$op', quiet = $knit_q)"
    printf "     $op/$f.md\n"
    # md to pdf
    [[ -f $op/$f.md ]] && pandoc ${pandoc_opts} -o $w/$f.pdf $op/$f.md 
done

# ==============================================================================
# BUILD
# ==============================================================================

printf "\n[ Building... ]\n\n"

bundle exec jekyll build $build_q --config ./_config${b}.yml --destination ./_site${b} --verbose
printf "  Built site ==>\n"
printf "     config file:   _config$b\n"
printf "     location:      _site$b\n"

# ==============================================================================
# MOVE FILES TO STUDENT REPO
# ==============================================================================

if [ $c == 1 ]; then
    printf "\n[ Copying files for student repos... ]\n\n"
    # make directory if it doesn't exist
    mkdir -p $student_repo/data
    # move files
    printf "  - README.md\n"
    cp _student_README.md $student_repo/README.md
    printf "  - .gitignore\n"
    cp .student_gitignore $student_repo/.gitignore
    printf "  - Assignments\n"
    cp -r assignments $student_repo
    rm $student_repo/assignments/index.md
    printf "  - Data\n"
    cp data/README.md $student_repo/data/README.md
    printf "  - Lessons\n"
    cp lessons/README.md $student_repo/lessons/README.md
    cp lessons/*.pdf $student_repo/lessons
    printf "  - Scripts\n"
    cp -r scripts $student_repo
fi

# ==============================================================================
# FINISH
# ==============================================================================

printf "\n[ Finished! ]\n\n"

# ==============================================================================
