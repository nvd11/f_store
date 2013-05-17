#!/bin/sh
if [ $# -lt 2 ]; then
  echo "Usage: ${0} checkouttype(BAU/PRJ) fileList destinationpath"
	exit 9
fi

fun_svn_tag(){
		f1_c=`svn info $1 | grep "URL" | awk -F " " '{print $2,$NF}' | grep $2 | wc -l` 
		return ${f1_c}
}

fileList=$1
svntag=$2

echo ${svntag}
tagname=`echo ${svntag} | awk -F "/" '{printf $NF}'`

outputpath="./svnoutput_"${tagname}
for file in `cat ${fileList}`
do
	thisfile=`echo $file|cut -d@ -f1`
	bname=`basename $thisfile`
	thisdir=`dirname $thisfile`
	svnpath="."${thisdir}
	destpath=${outputpath}${thisdir}

	echo -e "\n\n" 
	echo "##### handling  ${file} #####################################################"
	echo "##### will copy to ${destpath}/${bname}"


	echo "checking  "${svnpath}"/"${bname}
	if [ ! -f ${svnpath}"/"${bname} ]; then
		echo "file not exits,  it will run svn checkout now !!!!"
		echo "svn co ${svntag}${thisdir} ${svnpath}"
		svn co ${svntag}${thisdir} ${svnpath}
	else
		#judge whether path is for the correct svn path 
		echo "the path is already exited"
		fun_svn_tag ${svnpath} "http" 
		if_flag=$?
		if [ ${if_flag} -lt 1 ]; then
			echo "the path is not for this tag "${tagname}", it will be remove and checkout again!!"
			svnpathhead=`echo ${svnpath} | awk -F "/" '{print $2}'`
			echo "rm -rf ${svnpathhead}"
			rm -rf ${svnpathhead}

			#chekout out
			echo "svn co ${svntag}${thisdir} ${svnpath}"
			svn co ${svntag}${thisdir} ${svnpath}
		fi
	fi

	if [ ! -f ${svnpath}"/"${bname} ]; then
		echo "file is not existed at svn !!!!!!!!!!!!!!!!!!!! "
		echo "file "${file}" is fail !!!!!" >> error.log
	else
		echo "cp ${svnpath}"/"${bname} ${destpath}"/"${bname}"
		mkdir -p ${destpath}
		cp ${svnpath}"/"${bname} ${destpath}"/"${bname}
	fi

	echo "##### done!!!!  ${file} #####################################################"
done




