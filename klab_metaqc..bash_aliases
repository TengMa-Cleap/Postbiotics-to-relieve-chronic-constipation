#!/usr/bin/sh
# 20200410
# Version 0.1 ; This is a beta version.

<<log
2019.4.13加入top功能啦，嘿嘿
2020.3.13加入knet
log

# Author Jinhao klab

help_message () {
    echo -e "Usage: klab_metaqc [module]"
        echo "Options:"
        echo "This is a beta version."
    echo "    list       | get sample list for qc module."
    # echo "    qc         | a pipeline for metagenomic data quality and remove host contamination."
    echo "    superqc    | a snakemake pipeline same as klab qc, but more preferable."
    echo "    help       | help show this help message."
    echo "    version    | show version."
    echo "Designed by jinhao"
    echo "Last update: 2020.4.10"
}


key_script=/ddnstor/imau_sunzhihong/mnt1/script/klab_script

if [ "$1" = list ]; then
    sh ${key_script}/get_sample_list.sh ${@:2}
    exit 0
elif [ "$1" = superqc ]; then
    sh ${key_script}/qc.sh ${@:2}
    exit 0
# elif [ "$1" = sudoqc ]; then
#     echo "Hollo!"
#     sh ${key_script}/sudoqc.sh ${@:2}
#     exit 0
elif [ "$1" = "help" ]; then
    help_message
    exit 0
    #sh ${key_script}/sudoqc.sh ${@:2}
    exit 0
elif [ "$1" = "version" ]; then
        echo ""
    echo "Klab_metaqc version=beta 0.1, 20200410, by jinhao."
    echo ""
    exit 0
else 
    echo "Please select a module of klab_metaqc"
    help_message
        exit 1
fi