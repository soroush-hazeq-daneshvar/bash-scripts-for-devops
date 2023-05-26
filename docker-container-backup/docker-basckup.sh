#!/bin/bash
DOCKER_USER=$(sed -n '1{p;q}' .env)
DOCKER_PASSWORD=$(sed -n '2{p;q}' .env)
NOWDATE=$(date +'%Y-%m-%d_%H-%M')
LOG=log-file-$NOWDATE.txt
for i in $(docker ps --format "{{.Names}}"); do
    docker commit -p $i $i-backup-$NOWDATE >> $LOG
    docker save -o ~/Desktop/$i-backup-$NOWDATE.tar $i-backup-$NOWDATE >> $LOG
    #docker login --username $DOCKER_USER --password-stdin $DOCKER_PASSWORD
    docker tag $i-backup-$NOWDATE soroushmanhd/mainp:$i-backup-$NOWDATE >> $LOG
    docker push soroushmanhd/mainp:$i-backup-$NOWDATE >> $LOG
    docker rmi $i-backup-$NOWDATE soroushmanhd/mainp:$i-backup-$NOWDATE >> $LOG
done
