#!/bin/bash

if [ -z "$2" ]; then
    echo "args"
    exit 1
fi

FROM=$1
TO=$2

cp conn_CortIntCh${FROM}_to_D1_MSN_syn0.bin conn_CortIntCh${TO}_to_D1_MSN_syn0.bin
cp conn_CortIntCh${FROM}_to_D1_MSN_syn1.bin conn_CortIntCh${TO}_to_D1_MSN_syn1.bin
cp conn_CortIntCh${FROM}_to_D2_MSN_syn0.bin conn_CortIntCh${TO}_to_D2_MSN_syn0.bin
cp conn_CortIntCh${FROM}_to_D2_MSN_syn1.bin conn_CortIntCh${TO}_to_D2_MSN_syn1.bin
cp conn_CortIntCh${FROM}_to_STN_syn0.bin conn_CortIntCh${TO}_to_STN_syn0.bin
cp conn_CortIntCh${FROM}_to_STN_syn1.bin conn_CortIntCh${TO}_to_STN_syn1.bin

exit 0
