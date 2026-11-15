#! /bin/bash

SEMABUILD_GIT="${HOME}/${SEMAPHORE_GIT_DIR}"
SEMABUILD_DEST="https://${GITHUB_TOKEN}:x-oauth-basic@github.com/redeclipse/redeclipse.github.io.git"
SEMABUILD_DESTNAME="www"
SEMABUILD_DESTPWD="${HOME}/${SEMABUILD_DESTNAME}"
SEMABUILD_DESTDOCS="${SEMABUILD_DESTPWD}/docs"

semabuild_setup() {
    echo "setting up ${SEMAPHORE_GIT_BRANCH}.."

    git config --global user.email "noreply@redeclipse.net" || return 1
    git config --global user.name "Red Eclipse" || return 1
    git config --global credential.helper store || return 1
    echo "https://${GITHUB_TOKEN}:x-oauth-basic@github.com" > "${HOME}/.git-credentials"

    pushd "${HOME}" || return 1
    git clone --depth 1 "${SEMABUILD_DEST}" "${SEMABUILD_DESTNAME}" || return 1
    popd || return 1

    return 0
}

# the addresses a page named ${2} is served at besides its permalink, written to ${1}; with ${3} as 1 its own name too
semabuild_redirect() {
    local a b
    a=`echo "${2}" | sed -e "s/[_]/-/g;s/--/-/g;s/^-//g;s/-$//g"`
    b=`echo "${a}" | sed -e "s/-/_/g"`
    if [ "${3}" = "1" ]; then
        echo "  - /docs/${a}/" >> "${1}"
    fi
    if [ "${2}" != "${a}" ]; then
        echo "  - /docs/${2}/" >> "${1}"
    fi
    if [ "${a}" != "${b}" ]; then
        echo "  - /docs/${b}/" >> "${1}"
    fi
    echo "  - /wiki/${b}/" >> "${1}"
}

semabuild_build() {
    m=`echo "${2}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\1/"`
    n=`echo "${2}" | sed -e "s/^\(.*\)\.\([^.]*\)$/\2/"`
    o=`echo "${m}" | sed -e "s/^\(.\).*$/\1/"`

    if [ "${o}" != "_" ] && [ "${n}" = "md" ]; then
        if [ "$(head -n 1 "${3}")" = "---" ]; then
            echo "ERROR: ${2} starts with front matter; it looks like a built page copied back from the website"
            return 1
        fi
        p=`echo "${m}" | sed -e "s/[-_]/ /g;s/  / /g;s/^ //g;s/ $//g"`
        q=`echo "${m}" | sed -e "s/[_]/-/g;s/--/-/g;s/^-//g;s/-$//g"`
        r=`echo "${q}" | sed -e "s/-/_/g"`
        # a page is titled <Subsection> - <Name>, every word of the folder capitalised, and an Index.md by its folder alone
        d=`dirname "${m}"`
        t=`basename "${m}" | sed -e "s/[-_]/ /g;s/  / /g;s/^ //g;s/ $//g"`
        if [ "${d}" != "." ]; then
            s=`echo "${d}" | sed -e "s/[-_]/ /g;s/  / /g;s/^ //g;s/ $//g;s/\(^\| \|\/\)\(.\)/\1\u\2/g;s/\// - /g"`
            if [ "$(basename "${m}")" = "Index" ]; then
                t="${s}"
            else
                t="${s} - ${t}"
            fi
        fi
        u=`echo "${m}" | cut -d"/" -f2-`

        echo "CONVERT: ${m} (${n}) - ${p} (${q}) > ${1}"
        echo "---" > "${1}"
        echo "title: ${t}" >> "${1}"
        echo "layout: docs" >> "${1}"
        echo "origfile: ${2}" >> "${1}"
        echo "origtitle: ${u}" >> "${1}"
        # an Index.md is served at its folder, and the top-level one at /docs/
        if [ "$(basename "${m}")" = "Index" ]; then
            if [ "${d}" = "." ]; then
                echo "permalink: /docs/" >> "${1}"
            else
                echo "permalink: /docs/${q%/Index}/" >> "${1}"
            fi
        else
            echo "permalink: /docs/${q}" >> "${1}"
        fi

        # the names a page had before it was renamed, and older addresses still linked from elsewhere
        case "${m}" in
            Index) w="Home"; x="/docs/Main_Page/ /wiki/ /wiki/Main_Page/" ;;
            variables/Index) w="variables/Variables variables/Variables-home"; x="" ;;
            gameplay/Index) w="gameplay/Gameplay-Guide"; x="" ;;
            maps/Index) w="Official-Maps"; x="" ;;
            server-how-to/Index) w="server-how-to/Server-Setup"; x="" ;;
            gameplay/Speedrun) w=""; x="/docs/gameplay/Race/ /docs/gameplay/race/ /wiki/gameplay_Race/ /wiki/race/" ;;
            *) w=""; x="" ;;
        esac

        echo "redirect_from:" >> "${1}"
        if [ "$(basename "${m}")" = "Index" ]; then
            semabuild_redirect "${1}" "${m}" 1
        else
            semabuild_redirect "${1}" "${m}" 0
        fi
        for g in ${w}; do
            semabuild_redirect "${1}" "${g}" 1
        done
        for g in ${x}; do
            echo "  - ${g}" >> "${1}"
        done
        echo "---" >> "${1}"

        echo "* TOC" >> "${1}"
        echo "{:toc}" >> "${1}"

        c=`cat "${3}"`
        f=`echo "${c}" | sed -e "s/)/)\n/g" | grep "\[.*\]\([^:]*.md\)" | sed -e "s/.*\[\([^]]*\)\](\([^):]*\))$/\2/;s/^\([^#]*\)#.*$/\1/" | sort | uniq`
        for d in ${f}; do
            echo -n "LINK CHECK: ${d} .. "
            if [ -n "${d}" ] && [ ! -e "${d}" ]; then
                e="${d//\//\\\/}"
                c=`echo "${c}" | sed -e "s/\[\([^]]*\)\](${e})/~~\[\1\](${e})~~/g"`
                echo "NOT FOUND!"
            else
                echo "found."
            fi
        done

        # a link to an Index.md goes to its folder, where the page is served
        echo "${c}" | sed -e "s/\](Index\.md)/](.\/)/g;s/\](Index\.md#\([^)]*\))/](.\/#\L\1)/g;s/\](\([^)#]*\/\)Index\.md)/](\1)/g;s/\](\([^)#]*\/\)Index\.md#\([^)]*\))/](\1#\L\2)/g;s/\](\([^)]*\)\.md)/](\1)/g;s/\](\([^#)]*\)\.md#\([^)]*\))/](\1#\L\2)/g;s/](https\?:\/\/\(www\.\)\?redeclipse\.net/](/g" >> "${1}"
    fi
}

semabuild_process() {
    pushd "${SEMABUILD_GIT}" || return 1
    for i in *; do
        if [ -d "${i}" ]; then
            if [ "${i}" = "images" ]; then
                cp -rv "${i}" "${SEMABUILD_DESTDOCS}/"
            else
                pushd "${i}" || return 1
                mkdir -pv "${SEMABUILD_DESTDOCS}/${i}"
                for j in *; do
                    if [ ! -d "${j}" ]; then
                        semabuild_build "${SEMABUILD_DESTDOCS}/${i}/${j}" "${i}/${j}" "${j}" || return 1
                    fi
                done
                popd || return 1
            fi
        else
            semabuild_build "${SEMABUILD_DESTDOCS}/${i}" "${i}" "${i}" || return 1
        fi
    done
    popd || return 1

    # Remove every published file, at any depth, whose source no longer exists.
    pushd "${SEMABUILD_DESTDOCS}" || return 1
    find . -type f | sort | while IFS= read -r i; do
        i="${i#./}"
        if [ ! -e "${SEMABUILD_GIT}/${i}" ]; then
            echo "REMOVE: ${i}"
            git rm -q -- "${i}" || exit 1
        fi
    done || return 1
    popd || return 1

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

    git commit -a -m "Build docs:${SEMAPHORE_WORKFLOW_NUMBER} from ${SEMAPHORE_GIT_SHA}" || return 1
    git pull --rebase || return 1
    git push -u origin master || return 1

    popd || return 1

    return 0
}

semabuild_setup || exit 1
semabuild_process || exit 1
semabuild_update || exit 1

echo "done."
