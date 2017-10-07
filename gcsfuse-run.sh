#!/bin/bash

NGINX_HOME=${NGINX_HOME:-/usr/share/nginx/html}
USERID=$(id -u www-data)
GRPID=$(id -g www-data)

if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ] &&  ! [ -z "$MEDIABUCKET" ] ;
 then
	   echo "Credentials $GOOGLE_APPLICATION_CREDENTIALS is present  .. mounting $MEDIABUCKET on pub/media"
fi


/usr/bin/gcsfuse --uid $USERID --gid $GRPID --key-file=/etc/bucketaccess.json --implicit-dirs --dir-mode="777" --file-mode="777" --limit-ops-per-sec -1 --limit-bytes-per-sec -1 --debug_fuse  --debug_gcs --debug_http --debug_invariants -o allow_other -o nonempty  $MEDIABUCKET $NGINX_HOME

 if [ $? -eq 0 ] ;
 then
 	echo "$NGINX_HOME mounted successfully with $MEDIABUCKET"
 else
    echo "Error $NGINX_HOME not mounted !!"
		exit 1;
 fi

if [ $? -eq 0 ];
then
	nginx -g 'daemon off;'
else
	echo "Error in nginx configurations";
	exit 1;
fi
