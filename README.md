# docker-gcsfuse

This repo will help you mount your GCP storage buckets to your docker container volumes. The pre-requisites to run this application are as follow:

1. GCP account is mandatory.
2. Docker installed on a linux VM.

PFb the steps to run the code:

1. Login into GCP and create a bucket in "Storage" section. Add the html files which you want to access when you hit the nginx application. 

2. Create a Service account in GCP which will have  "storage admin" role assigned to it. Also download and save the private key of the service account and store it safely and don't share it publicly.

3. Clone the git rep and build the docker image from above code using the following command:
    docker build -t <image_tag> .
    
4. Run the image using the following commnad:

docker run -d --env MEDIABUCKET=<GCP_Bucket> -p 80:80 --privileged --cap-add SYS_ADMIN -v <PATH_OF_PRIVATEKEY_TO_GCP_STORAGE>:/etc/bucketaccess.json <IMAGE_ID>

5. Once the container is up and running you can hit the publicip of the VM on port 80 with the file name i.e. <ipadd>/<file>.html  

6. The command which is used to mount the gcsfuse inside the container is:

/usr/bin/gcsfuse --uid $USERID --gid $GRPID --key-file=/etc/bucketaccess.json --implicit-dirs --dir-mode="777" --file-mode="777" --limit-ops-per-sec -1 --limit-bytes-per-sec -1 --debug_fuse  --debug_gcs --debug_http --debug_invariants -o allow_other -o nonempty  $MEDIABUCKET $NGINX_HOME

You can check the parameters on this link: https://github.com/GoogleCloudPlatform/gcsfuse/

The use-case of such mounting is :

1. This excludes the static content from your application and ruduces the image size as major part of the image is stored on GCP storage.
2. Also using this a single storage bucket can be mounted across various applications. This means if you are using Kubernetes then you can deploy multiple pods which will use the same bucket.
