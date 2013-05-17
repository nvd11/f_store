#!/bin/sh
if [ $# -lt 4 ]; then
  echo "Usage: ${0} fileList svntagpath inputpath commit_comment"
	exit 9
fi

fun_svn_tag(){
		f1_c=`svn info $1 | grep "URL" | awk -F " " '{print $2,$NF}' | grep $2 | wc -l` 
		return ${f1_c}
}

fileList=$1
svntag=$2
inputpath=$3
comment=$4

if [ ${inputpath}"x" == ".x" ]; then
	echo "the inputpath cannot be "."!!!! exit(1)"
	exit 1;
fi

echo ${svntag}
tagname=`echo ${svntag} | awk -F "/" '{printf $NF}'`

for file in `cat ${fileList}`
do
	thisfile=`echo $file|cut -d@ -f1`
	bname=`basename $thisfile`
	thisdir=`dirname $thisfile`
	svnpath="."${thisdir}
	destpath=${inputpath}"/"${thisdir}

	echo -e "\n\n" 
	echo "##### handling  ${file} #####################################################"
	echo "##### will copy from to ${destpath}/${bname}"

	echo "checking  "${destpath}"/"${bname}
	if [ ! -f ${destpath}"/"${bname} ]; then
		echo "the file "${destpath}"/"${bname}" is not exitsed !!!!, this file will be ignore"
		echo "file "${file}" is not exitsed !!!!!" >> error.log
		continue
	fi

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
		echo "file is not existed at svn ! it will be execute svn add"
		echo "cp ${destpath}"/"${bname} ${svnpath}"/"${bname}"
		cp ${destpath}"/"${bname} ${svnpath}"/"${bname}

		echo "svn add ${svnpath}"/"${bname}" 
		echo ${file} >> addlist.txt
		svn add ${svnpath}"/"${bname} 
		if [ $? != 0 ]; then
			echo "file "${file}" is fail !!!!!" >> error.log
		fi
	else
		echo "the file is existed in svn alreary, it will be performed svn update"
		echo "svn update "${svnpath}"/"${bname}
		svn update ${svnpath}"/"${bname} 

		echo "cp ${destpath}"/"${bname} ${svnpath}"/"${bname}"
		cp ${destpath}"/"${bname} ${svnpath}"/"${bname}
	fi

	echo "svn commit -m "${comment}" "${svnpath}"/"${bname} 
	svn commit -m ${comment} ${svnpath}"/"${bname} 

	echo ${file} >> committed.txt
	if [ $? != 0 ]; then
		echo "file "${file}" is fail !!!!!" >> error.log
	fi

	echo "##### done!!!!  ${file} #####################################################"
done

