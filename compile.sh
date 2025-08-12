#!/usr/bin/env bash
usage() { echo "Usage: ./compile.sh [-i file-to-compile.c] [-s assembly-code.s] [-o executable-file]"; }

if [ $# = 0 ];
then
    usage
    exit 1
fi

while getopts ":i:s:o:h" arg; do
    case ${arg} in
        i)
            i=${OPTARG}
            ;;
        s)
            s=${OPTARG}
            ;;
        o)
            o=${OPTARG}
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 0
            ;;
    esac
done

dune exec c-compiler ${i} ${s}
cc ${s} -o ${o}
