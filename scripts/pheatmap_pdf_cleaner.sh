DIR=$1
FILE=$2

/home/xfu/Downloads/sejda-console-2.8.12/bin/sejda-console extractpages -s 2 -f $DIR/$FILE -o /tmp -j overwrite
mv /tmp/$FILE $DIR/$FILE 