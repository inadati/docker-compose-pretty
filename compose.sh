#!/bin/zsh

TARGET_ENV=local
DATE_TIME=`echo $(date '+%y/%m/%d %H:%M:%S')`
DOCKER_TAG_SUFFIX=`echo $(date '+%y%m%d%H%M')`
DOCKER_TAG="${TARGET_ENV}-${DOCKER_TAG_SUFFIX}"

if [ $TARGET_ENV = "local" ]; then
    echo "compose.sh はlocal向けのbuild及びpushには対応していません。"
    exit 1
fi

if [ ! -f "./@docker/env/${TARGET_ENV}/compose.env" ]; then
    echo "./@docker/env/${TARGET_ENV}/compose.env が存在しません。"
    exit 1
fi

docker-compose --env-file "./@docker/env/${TARGET_ENV}/compose.env" build
docker-compose --env-file "./@docker/env/${TARGET_ENV}/compose.env" push

echo "[new-build] at ${DATE_TIME} docker tag name is ${DOCKER_TAG}" >> ./@docker/log/build.log

git tag -a "build/${DOCKER_TAG}" -m "${DATE_TIME} ${TARGET_ENV} 向けにコンテナをビルドしレジストリへpush"
git push origin "build/${DOCKER_TAG}"
