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
    [-l]        Lesson to knit (w/o ending)
    [-a]        Assignment to knit (w/o ending)
    [-i]        Directory of lesson *.Rmd files
    [-j]        Directory of assignment *.Rmd files
    [-o]        Directory where pdf versions of lessons should go
    [-p]        Directory where pdf versions of assignments should go
    [-s]        Directory where purled scripts files should go
    [-b]        Suffix to go on _config*.yml and _site* directory
    [-c]        Output directory for course assignments, data, lessons, and scripts
    [-v]        Render / build verbosely (optional flag)
    		
 EXAMPLES:
 
 ./kbuild.sh -l all
 ./kbuild.sh -l all -a all
 ./kbuild.sh -l intro -a intro
 ./kbuild.sh -l all -i _posts -b _dev
 ./kbuild.sh -l all -c 

 DEFAULT VALUES:

 i = _lessons
 j = _assignments
 o = lessons
 p = assignments
 s = scripts
 b = <empty string>
 c = ../<dir name>_student
 v = 0 (knit/build quietly)

EOF
}

# defaults
i="_lessons"
j="_assignments"
oi=$i				# leaving output == input right now
oj=$j
o="lessons"
p="assignments"
s="scripts"
b=""
c=0                             # assuming _student for central repo
v=0

knit_q="TRUE"
build_q="--quiet"
student_repo="../${PWD##*/}_student"
pdfs="assets/pdf"

# pandoc
pandoc_opts="-V geometry:margin=1in --highlight-style tango --pdf-engine=xelatex --variable monofont=\"Menlo\" -f markdown-implicit_figures"

# sed
sed_opts_1="s/\/edh7916\/assets/..\/assets/g"
sed_opts_2="s/..\/assets/.\/assets/g; s/<img src=\"\(figures\/.*\.png\)\" width=\"100%\" \/>/\!\[\]\(${i}\/\1\)/g"

while getopts "hl:a:i:j:o:p:s:b:cv" opt;
do
    case $opt in
	h)
	    usage
	    exit 1
	    ;;
	l)
	    l=$OPTARG 
	    ;;
	a)
	    a=$OPTARG
	    ;;
	i)
	    i=$OPTARG
	    ;;
	j)
	    j=$OPTARG
	    ;;
	o)
	    o=$OPTARG
	    ;;
	p)
	    p=$OPTARG
	    ;;
	s)
	    s=$OPTARG
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
# if [[ -z "$l" ]] && [[ -z "$a" ]]; then
#     echo "Must chose lesson or assignment *.Rmd file to knit"
#     exit 1
# fi

# flags for knitting
! [[ -z "$l" ]] && knit_lessons=1 || knit_lessons=0
! [[ -z "$a" ]] && knit_assignments=1 || knit_assignments=0

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

if [[ $l == "all" ]]; then
    which_lessons="all *.Rmd files"
else
    which_lessons="${l}.Rmd"
fi

if [[ $a == "all" ]]; then
    which_assignments="all *.Rmd files"
else
    which_assignments="${a}.Rmd"
fi

if [[ $knit_lessons == 1 ]]; then
    printf "  Knitting: lessons                  = %s\n" "$which_lessons"
    printf "  Lessons *.Rmd input directory      = %s\n" "$i"
    printf "  Lessons *.Rmd output directory     = %s\n" "$o"
fi

if [[ $knit_assignments == 1 ]]; then
    printf "  Knitting: assignments              = %s\n" "$which_assignments"
    printf "  Assignments *.Rmd input directory  = %s\n" "$j"
    printf "  Assignments *.Rmd output directory = %s\n" "$p"
fi

if [[ $knit_assignments == 1 || $knit_lessons == 1 ]]; then
    printf "  *.R script output directory        = %s\n" "$s"
    printf "  Directory of built site            = _site%s\n" "$b"
fi

if [[ $c == 1 ]]; then
    printf "  Student files directory            = %s\n" "$student_repo"
fi

# ==============================================================================
# KNIT
# ==============================================================================

# ------------------
# lessons
# ------------------

if [[ $knit_lessons == 1 ]]; then
    printf "\n[ Knitting and purling lessons... ]\n\n"
    if [[ $l != "all" ]]; then
	printf "  $l.Rmd ==> \n"
	f="$i/$l.Rmd"
	# skip if starts with underscore
	if [[ $l = _* ]]; then
	    printf "     skipping...\n"
	else
	    # knit
	    Rscript -e "knitr::knit('$f', output='$oi/$l.md', quiet = $knit_q)" 2>&1 > /dev/null
	    # fix path for local build
	    sed -i '' "${sed_opts_1}" $oi/$l.md 
	    printf "     $oi/$l.md\n"
	    # md to pdf
	    if [[ -f $oi/$l.md ]]; then
		sed "${sed_opts_2}" $oi/$l.md | pandoc ${pandoc_opts} -o $o/$l.pdf -
		# pandoc ${pandoc_opts} -o $o/$l.pdf $oi/$l.md
		cp $o/$l.pdf $pdfs
	    fi
	    # purl
	    Rscript -e "knitr::purl('$f', documentation = 0, quiet = $knit_q)" 2>&1 > /dev/null
	    printf "     $s/$l.R\n"
	    # more than one line after removing \n? mv to scripts directory : rm
	    [[ $(tr -d '\n' < ${l}.R | wc -c) -ge 1 ]] && mv ${l}.R $s/${l}.R || rm ${l}.R
	fi
    else 
	for file in ${i}/*.Rmd
	do
	    # get file name without ending
	    f=$(basename "${file%.*}")
	    printf "  $f.Rmd ==> \n"
	    # skip if starts with underscore
	    if [[ $f = _* ]]; then printf "     skipping...\n"; continue; fi
	    # knit
	    Rscript -e "knitr::knit('$file', output='$oi/$f.md', quiet = $knit_q)" 2>&1 > /dev/null
	    # fix path for local build
	    sed -i '' "${sed_opts_1}" $oi/$f.md
	    printf "     $oi/$f.md\n"
	    # md to pdf
	    if [[ -f $oi/$f.md ]]; then
		sed "${sed_opts_2}" $oi/$f.md | pandoc ${pandoc_opts} -o $o/$f.pdf -
		# pandoc ${pandoc_opts} -o $o/$f.pdf $oi/$f.md
		cp $o/$f.pdf $pdfs
	    fi
	    # purl
	    Rscript -e "knitr::purl('$file', documentation = 0, quiet = $knit_q)" 2>&1 > /dev/null
	    printf "     $s/$f.R\n"
	    # more than one line after removing \n? mv to scripts directory : rm
	    [[ $(tr -d '\n' < ${f}.R | wc -c) -ge 1 ]] && mv ${f}.R $s/${f}.R || rm ${f}.R
	done
    fi
fi

# ------------------
# assignments
# ------------------

if [[ $knit_assignments == 1 ]]; then
    printf "\n[ Knitting assignments... ]\n\n"
    if [[ $a != "all" ]]; then
	printf "  $a.Rmd ==> \n"
	f="$j/$a.Rmd"
	# skip if starts with underscore
	if [[ $a = _* ]]; then
	    printf "     skipping...\n"
	else
	    # knit
	    Rscript -e "knitr::knit('$f', output='$oi/$l.md', quiet = $knit_q)" 2>&1 > /dev/null
	    printf "     $oj/$a.md\n"
	    # md to pdf
	    if [[ -f $oj/$a.md ]]; then
	        pandoc ${pandoc_opts} -o $p/${a}.pdf $oj/$a.md
		cp $p/${a}.pdf $pdfs
	    fi
	fi
    else
	for file in ${j}/*.Rmd
	do
	    # get file name without ending
	    f=$(basename "${file%.*}")
	    printf "  $f.Rmd ==> \n"
	    # skip if starts with underscore
	    if [[ $f = _* ]]; then
		printf "     skipping...\n"
	    else
		# knit
		Rscript -e "knitr::knit('$file', output='$oi/$l.md', quiet = $knit_q)" 2>&1 > /dev/null
		printf "     $oj/$f.md\n"
		# md to pdf
		if [[ -f $oj/$f.md ]]; then
		    pandoc ${pandoc_opts} -o $p/${f}.pdf $oj/$f.md
		    cp $p/${f}.pdf $pdfs
		fi
	    fi
	done	
    fi
fi

# ==============================================================================
# BUILD
# ==============================================================================

if [[ $knit_lessons == 1 ]] || [[ $knit_assignments == 1 ]]; then
    printf "\n[ Building... ]\n\n"
    
    bundle exec jekyll build $build_q --config ./_config${b}.yml --destination ./_site${b} --verbose 2>/dev/null
    printf "  Built site ==>\n"
    printf "     config file:   _config$b\n"
    printf "     location:      _site$b\n"
    # correct yaml-dropping for RMD files in scripts (want yaml)
    # cp $s/*.Rmd ./_site${b}/$s/
fi

# ==============================================================================
# MOVE FILES TO STUDENT REPO
# ==============================================================================

if [ $c == 1 ]; then
    printf "\n[ Copying files for student repos... ]\n\n"
    # make directory if it doesn't exist
    mkdir -p $student_repo/data $student_repo/lessons $student_repo/working
    # move files
    printf "  - README.md\n"
    cp _student_README.md $student_repo/README.md
    printf "  - .gitignore\n"
    cp .student_gitignore $student_repo/.gitignore
    printf "  - Assignments\n"
    cp -r assignments $student_repo
    rm $student_repo/assignments/index.md
    printf "  - Data\n"
    cp -r data $student_repo
    printf "  - Lessons\n"
    cp lessons/README.md $student_repo/lessons/README.md
    cp lessons/*.pdf $student_repo/lessons
    printf "  - Scripts\n"
    cp -r scripts $student_repo
    printf "  - Working\n"
    cp _working/README.md $student_repo/working/README.md
fi

# ==============================================================================
# FINISH
# ==============================================================================

printf "\n[ Finished! ]\n\n"

# ==============================================================================
