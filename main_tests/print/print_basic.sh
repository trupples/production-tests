#!/bin/bash

SCRIPT_DIR="$(readlink -f $(dirname $0))"

populate_label_fields()
{
    SERIAL=$1
    DATE=$(date +"%Y-%m-%d" )
    MODEL="AD-SYNCHRONA14-EBZ"
    MAC1=$(ifconfig | grep ether | awk 'NR==1 {print $2}')
    MAC2=$(ifconfig | grep ether | awk 'NR==2 {print $2}')

    rm -rf /tmp/csvfile.csv #remove previous data

    echo $MODEL,$SERIAL,$MAC1,$MAC2,$DATE > /tmp/csvfile.csv
}


print_label()
{
    rm -rf /tmp/back.pdf

    glabels-3-batch -o /tmp/back.pdf -i /tmp/csvfile.csv $SCRIPT_DIR/print/synchrona_back.glabels
    cancel -a -x
    PRINTER=$(lpstat -t | grep "printer LabelWriter" | awk '{print $2}')
    lpr -P$PRINTER /tmp/back.pdf
}

