#!/usr/bin/env bash

echo "Removing generated files"
rm -f axonserver*.token axonserver.properties admin.password

echo "Removing ControlDB files"
rm -f data/*.db

echo "Removing plugins"
rm -rf plugins/{bundles,cache}

for ctx in events/* ; do
    if [ -d ${ctx} ] ; then
        echo "- Removing ${ctx}"
        rm -rf ${ctx}
    fi
done
