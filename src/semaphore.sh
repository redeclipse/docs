#! /bin/bash

SEMABUILD_PWD=`pwd`
SEMABUILD_DEST="https://${GITHUB_TOKEN}:x-oauth-basic@github.com/redeclipse/redeclipse.github.io.git"
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

semabuild_build() {
    m=`echo "${2}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\1/"`
    n=`echo "${2}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\2/"`
    o=`echo "${m}" | sed -e "s/^\(.\).*$/\1/"`
    if [ "${o}" != "_" ] && [ "${n}" = "md" ]; then
        p=`echo "${m}" | sed -e "s/[-_]/ /g;s/  / /g;s/^ //g;s/ $//g"`
        q=`echo "${m}" | sed -e "s/[_]/-/g;s/--/-/g;s/^-//g;s/-$//g"`
        r=`echo "${q}" | sed -e "s/-/_/g"`
        s=`echo "${p}" | sed -e "s/\/: /g"`
        t="$(echo "${s:0:1}" | tr '[:lower:]' '[:upper:]')${s:1}"
        u=`echo "${m}" | cut -d"/" -f2-`
        echo "CONVERT: ${m} (${n}) - ${p} (${q}) > ${1}"
        echo "---" > "${1}"
        echo "title: ${t}" >> "${1}"
        echo "layout: docs" >> "${1}"
        echo "origfile: ${2}" >> "${1}"
        echo "origtitle: ${u}" >> "${1}"
        echo "permalink: /docs/${q}" >> "${1}"
        SEMABUILD_REDIRECT="0"
        echo "redirect_from:" >> "${1}"
        if [ "${m}" = "Home" ]; then
            echo "  - /docs/" >> "${1}"
            echo "  - /docs/Main_Page/" >> "${1}"
            echo "  - /wiki/Main_Page/" >> "${1}"
        elif [ "${m}" != "${q}" ]; then
            echo "  - /docs/${m}/" >> "${1}"
        fi
        if [ "${q}" != "${r}" ]; then
            echo "  - /docs/${r}/" >> "${1}"
        fi
        echo "  - /wiki/${r}/" >> "${1}"
        echo "---" >> "${1}"
        echo "* TOC" >> "${1}"
        echo "{:toc}" >> "${1}"
        c=`cat "${3}"`
        f=`echo "${c}" | sed -e "s/)/)\n/g" | grep "\[.*\]\([^:]*.md\)" | sed -e "s/.*\[\([^]]*\)\](\([^):]*\))$/\2/;s/^\([^#]*\)#.*$/\1/" | sort | uniq`
        for d in ${f}; do
            echo -n "LINK CHECK: ${d} .. "
            if [ -n "${d}" ] && [ ! -e "${d}" ]; then
                c=`echo "${c}" | sed -e "s/\[\([^]]*\)\](${d})/~~\[\1\](${d})~~/g"`
                echo "NOT FOUND!"
            else
                echo "found."
            fi
        done
        echo "${c}" | sed -e "s/\](\([^)]*\)\.md)/](\1)/g;s/\](\([^#)]*\)\.md#\([^)]*\))/](\1#\L\2)/g;s/http:\/\/redeclipse\.net//g;s/http:\/\/www.redeclipse\.net//g" >> "${1}"
    fi
}

semabuild_process() {
    pushd "${SEMABUILD_PWD}" || return 1
    for i in *; do
        if [ -d "${i}" ]; then
            if [ "${i}" = "images" ]; then
                cp -rv "${i}" "${SEMABUILD_DESTDOCS}/"
            elif [ "${i}" != "src" ]; then
                pushd "${i}" || return 1
                mkdir -pv "${SEMABUILD_DESTDOCS}/${i}"
                for j in *; do
                    if [ ! -d "${j}" ]; then
                        semabuild_build "${SEMABUILD_DESTDOCS}/${i}/${j}" "${i}/${j}" "${j}"
                    fi
                done
                popd || return 1
            fi
        else
            semabuild_build "${SEMABUILD_DESTDOCS}/${i}" "${i}" "${i}"
        fi
    done
    popd || return 1
    pushd "${SEMABUILD_DESTDOCS}" || return 1
    for i in *; do
        if [ -d "${i}" ]; then
            if [ "${i}" != "src" ] && [ "${i}" != "bits" ]; then
                pushd "${i}" || return 1
                for j in *; do
                    if [ ! -d "${j}" ] &&  [ ! -e "${SEMABUILD_PWD}/${i}/${j}" ]; then
                        git rm "${j}" || return 1
                    fi
                done
                popd || return 1
            fi
        elif [ ! -e "${SEMABUILD_PWD}/${i}" ]; then
            git rm "${i}" || return 1
        fi
    done
    return 0
}

semabuild_update() {
    pushd "${SEMABUILD_DESTPWD}" || return 1
    git add * || return 1
    for i in *; do
        if [ -d "${i}" ] && [ "${i}" != ".git" ] && [ "${i}" != "bits" ]; then
            git add "${i}"/* || return 1
        fi
    done
    git commit -a -m "Build docs:${SEMAPHORE_BUILD_NUMBER} from ${REVISION}"  && git pull --rebase && git push -u origin master
    popd || return 1
    return 0
}

semabuild_setup || exit 1
semabuild_process || exit 1
semabuild_update || exit 1

echo "done."
