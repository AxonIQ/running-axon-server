#!/bin/bash

for i in node-1 node-2 node-3 ; do
    rm -rf ${i}/{data,log,security} ${i}/*.{pid,log,crt,csr,key,p12} 
done
rm -f rootCA.*
