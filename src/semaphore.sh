#! /bin/bash

SEMABUILD_PWD=`pwd`
SEMABUILD_DEST="https://${GITHUB_TOKEN}:x-oauth-basic@github.com/red-eclipse/red-eclipse.github.io.git"
SEMABUILD_DESTNAME="www"
SEMABUILD_DESTPWD="${HOME}/www/docs"
SEMABUILD_DEPLOY="false"

semabuild_setup() {
    git config --global user.email "noreply@redeclipse.net" || return 1
    git config --global user.name "Red Eclipse" || return 1
    git config --global credential.helper store || return 1
    echo "https://${GITHUB_TOKEN}:x-oauth-basic@github.com" > "${HOME}/.git-credentials"
    pushd "${HOME}" || return 1
    git clone --depth 1 "${SEMABUILD_DEST}" "${SEMABUILD_DESTNAME}" || return 1
    popd || return 1
    return 0
}

semabuild_process() {
    pushd "${SEMABUILD_PWD}" || return 1
    for i in *; do
        if [ -d "${i}" ]; then
            cp -rv "${i}" "${SEMABUILD_DESTPWD}/"
        else
            m=`echo "${i}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\1/"`
            n=`echo "${i}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\2/"`
            o=`echo "${m}" | sed -e "s/^\(.\).*$/\1/"`
            if [ "${o}" != "_" ] && [ "${n}" = "md" ]; then
                p=`echo "${m}" | sed -e "s/[-_]/ /g;s/  / /g;s/^ //g;s/ $//g"`
                echo "CONVERT: ${i} - ${m} (${n}) - ${p}"
                echo "---" > "${SEMABUILD_DESTPWD}/${i}"
                echo "title: ${p}" >> "${SEMABUILD_DESTPWD}/${i}"
                echo "origtitle: ${m}" >> "${SEMABUILD_DESTPWD}/${i}"
                echo "layout: docs" >> "${SEMABUILD_DESTPWD}/${i}"
                echo "---" >> "${SEMABUILD_DESTPWD}/${i}"
                echo "* TOC" >> "${SEMABUILD_DESTPWD}/${i}"
                echo "{:toc}" >> "${SEMABUILD_DESTPWD}/${i}"
                cat "${i}" >> "${SEMABUILD_DESTPWD}/${i}"
            fi
        fi
    done
    popd || return 1
    return 0
}

semabuild_update() {
    pushd "${SEMABUILD_DESTPWD}" || return 1
    git commit -a -m "Build ${SEMAPHORE_BUILD_NUMBER} from docs:${REVISION}" || return 1
    git pull --rebase || return 1
    git push -u origin master || return 1
    popd || return 1
    return 0
}

semabuild_setup || exit 1
semabuild_process || exit 1
semabuild_update || exit 1

echo "done."
