#!/bin/bash
set -e
###############################################################################
### Simple bash script to download binary (or source codes) of the software ###
### required to run Zanardi options.                                        ###
### History: Feb 2015 - Ezequiel L. Nicolazzi: Original version             ###
###                                                                         ###
### For bug report/comments: ezequiel.nicolazzi@tecnoparco.org              ###
#######################################################ELN#####################

### Variables passed by Zanardi
SYS=$1       # This is the OS
WHERE=$2     # This is the path where to download the files
SOURCE=$3    # This is the path where Zanardi and its param file are
DWNL=${@:3}  # This is the list of software to download

####################################################################################
###                            List of download links                            ###
####################################################################################
method=wget
opt=-O
PLINK=https://www.cog-genomics.org/static/bin/plink150903/plink_linux_x86_64.zip
FCGENE=http://sourceforge.net/projects/fcgene/files/latest/download
BEAGLE3=https://faculty.washington.edu/browning/beagle/beagle.jar
BEAGLE4=http://faculty.washington.edu/browning/beagle/beagle.r1399.jar
ADMIXTURE=https://www.genetics.ucla.edu/software/admixture/binaries/admixture_linux-1.23.tar.gz
FIMPUTE=http://www.aps.uoguelph.ca/~msargol/fimpute/FImpute_Linux.zip
####################################################################################

#### Routine for mac system (own programs)
for pgm in $DWNL  
do
    if [ $pgm == 'plink' ]; then
	pgm_folder=$WHERE/PLINK 
	echo;echo " ==> Downloading PLINK in $WHERE/PLINK from $PLINK using $method";echo
	mkdir -p $pgm_folder && $method $PLINK $opt $pgm_folder/plink.zip ||  exit
	echo;echo " ==> Uncompressing the file .zip";echo
	#cd $pgm_folder && unzip -o plink.zip || exit && dirplink=$pgm_folder/`ls -d */`     #plink1.07
	cd $pgm_folder && unzip -o plink.zip || exit && dirplink=$pgm_folder #/`ls *`        #plink1.9
	#chmod 755 $dirplink/plink    #plink1.07
	chmod -R 755 $dirplink        #plink1.9
	changepath=`grep PGM_PLINK $SOURCE/PARAMFILE.txt`
	sed -i -e "s#$changepath#PGM_PLINK=$dirplink#" $SOURCE/PARAMFILE.txt
	echo;echo " ==> PLINK downloaded and uncompressed successfully, path updated in PARAMETER.txt" 
    elif [ $pgm == 'fcgene' ]; then
	pgm_folder=$WHERE/FCGENE
	echo;echo " ==> Downloading fcGENE in $WHERE/FCGENE from $FCGENE using $method";echo
 	mkdir -p $pgm_folder && $method $FCGENE $opt $pgm_folder/fcgene.tar.gz || exit
	echo;echo " ==> Uncompressing the file .tar.gz";echo
	cd $pgm_folder && tar -zxvf fcgene.tar.gz  && dirfcgene=$pgm_folder/`ls -d */`
	chmod 755 $dirfcgene/fcgene
	changepath=`grep PGM_FCGENE $SOURCE/PARAMFILE.txt`
	sed -i -e "s#$changepath#PGM_FCGENE=$dirfcgene#" $SOURCE/PARAMFILE.txt
	echo;echo " ==> FCGENE downloaded and uncompressed successfully, path updated in PARAMETER.txt" 
    elif [ $pgm == 'beagle3' ]; then
	pgm_folder=$WHERE/BEAGLE
	echo;echo " ==> Downloading BEAGLE v.3 in $WHERE/BEAGLE from $BEAGLE using $method";echo
	mkdir -p $pgm_folder && $method $BEAGLE3 $opt $pgm_folder/beagle3.jar || exit
	chmod 755 $pgm_folder/beagle3.jar
	changepath=`grep PGM_BEAGLE3 $SOURCE/PARAMFILE.txt`
	echo $changepath
	echo $pgm_folder
	sed -i -e "s#$changepath#PGM_BEAGLE3=$pgm_folder#" $SOURCE/PARAMFILE.txt
	echo;echo " ==> BEAGLE v.3 downloaded successfully, path updated in PARAMETER.txt" 
    elif [ $pgm == 'beagle4' ]; then
	pgm_folder=$WHERE/BEAGLE
	echo;echo " ==> Downloading BEAGLE v.4 in $WHERE/BEAGLE from $BEAGLE using $method";echo
	mkdir -p $pgm_folder && $method $BEAGLE4 $opt $pgm_folder/beagle4.jar || exit
	chmod 755 $pgm_folder/beagle4.jar
	echo $SOURCE
	echo $SOURCE/PARAMFILE.txt
	changepath=`grep PGM_BEAGLE4 $SOURCE/PARAMFILE.txt`
	sed -i -e "s#$changepath#PGM_BEAGLE4=$pgm_folder#" $SOURCE/PARAMFILE.txt
	echo;echo " ==> BEAGLE v.4 downloaded successfully, path updated in PARAMETER.txt" 
    elif [ $pgm == 'admixture' ]; then
	pgm_folder=$WHERE/ADMIXTURE
	echo;echo " ==> Downloading ADMIXTURE in $WHERE/ADMIXTURE from $ADMIXTURE using $method";echo
	mkdir -p $pgm_folder && $method $ADMIXTURE $opt $pgm_folder/admixture.tar || exit
	echo;echo " ==> Uncompressing the file .tar";echo
	cd $pgm_folder && tar -xvf admixture.tar  && diradmixture=$pgm_folder/`ls -d */`
	chmod -R 755 $diradmixture
	echo $diradmixture
	echo $SOURCE
	changepath=`grep PGM_ADMIXTURE $SOURCE/PARAMFILE.txt`
	sed -i -e "s#$changepath#PGM_ADMIXTURE=$diradmixture#" $SOURCE/PARAMFILE.txt
	echo;echo " ==> ADMIXTURE downloaded successfully, path updated in PARAMETER.txt" 


    elif [ $pgm == 'fimpute' ]; then
	pgm_folder=$WHERE/FIMPUTE
	echo;echo " ==> Downloading FIMPUTE in $WHERE/FIMPUTE from $FIMPUTE using $method";echo
	mkdir -p $pgm_folder && $method $FIMPUTE $opt $pgm_folder/fimpute.zip ||  exit
	echo;echo " ==> Uncompressing the file .zip";echo
	cd $pgm_folder && unzip -o fimpute.zip || exit && dirfimpute=$pgm_folder/FImpute_Linux ##EZE CONTROLLARE QUESTO
	chmod -R 755 $dirfimpute        
	changepath=`grep PGM_FIMPUTE $SOURCE/PARAMFILE.txt`
	sed -i -e "s#$changepath#PGM_FIMPUTE=$dirfimpute#" $SOURCE/PARAMFILE.txt
	echo;echo " ==> FImpute downloaded and uncompressed successfully, path updated in PARAMETER.txt" 


    fi
done
rm -f $SOURCE/PARAMFILE.txt-e
echo "BAZINGA"
