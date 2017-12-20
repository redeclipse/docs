#! /bin/bash

SEMABUILD_PWD=`pwd`
SEMABUILD_DEST="https://${GITHUB_TOKEN}:x-oauth-basic@github.com/red-eclipse/red-eclipse.github.io.git"
SEMABUILD_DESTNAME="www"
SEMABUILD_DESTPWD="${HOME}/${SEMABUILD_DESTNAME}"
SEMABUILD_DESTDOCS="${SEMABUILD_DESTPWD}/docs"
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
            if [ "${i}" != "src" ]; then
                cp -rv "${i}" "${SEMABUILD_DESTDOCS}/"
            fi
        else
            m=`echo "${i}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\1/"`
            n=`echo "${i}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\2/"`
            o=`echo "${m}" | sed -e "s/^\(.\).*$/\1/"`
            if [ "${o}" != "_" ] && [ "${n}" = "md" ]; then
                p=`echo "${m}" | sed -e "s/[-_]/ /g;s/  / /g;s/^ //g;s/ $//g"`
                echo "CONVERT: ${m} (${n}) - ${p} > ${SEMABUILD_DESTDOCS}/${i}"
                echo "---" > "${SEMABUILD_DESTDOCS}/${i}"
                echo "title: ${p}" >> "${SEMABUILD_DESTDOCS}/${i}"
                echo "origtitle: ${m}" >> "${SEMABUILD_DESTDOCS}/${i}"
                echo "layout: docs" >> "${SEMABUILD_DESTDOCS}/${i}"
                echo "---" >> "${SEMABUILD_DESTDOCS}/${i}"
                echo "* TOC" >> "${SEMABUILD_DESTDOCS}/${i}"
                echo "{:toc}" >> "${SEMABUILD_DESTDOCS}/${i}"
                cat "${i}" >> "${SEMABUILD_DESTDOCS}/${i}"
            fi
        fi
    done
    popd || return 1
    return 0
}

semabuild_update() {
    pushd "${SEMABUILD_DESTPWD}" || return 1
    git add * || return 1
    git commit -a -m "Build docs:${SEMAPHORE_BUILD_NUMBER} from ${REVISION}" || return 1
    git pull --rebase || return 1
    git push -u origin master || return 1
    popd || return 1
    return 0
}

semabuild_setup || exit 1
semabuild_process || exit 1
semabuild_update || exit 1

echo "done."
