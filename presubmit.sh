#! /bin/bash
# vim: set ts=4 sw=4 et :

set -e

if [ -x "$(command -v asciidoctor)" ]; then
    find . -regextype egrep -iregex '.*\.adoc' -print0 | \
        xargs -0rt -n1 asciidoctor -o /dev/null -v --failure-level WARN
else
    echo "Warning: Not checking *.adoc files... no asciidoctor"
fi

if [ -x "$(command -v mdl)" ]; then
    find . -regextype egrep -iregex '.*\.md' -print0 | \
        xargs -0rt mdl
else
    echo "Warning: Not checking *.md files... no mdl (markdownlint)"
fi

if [ -x "$(command -v shellcheck)" ]; then
    find . -regextype egrep -iregex '.*\.(ba)?sh' -print0 | \
        xargs -0rt shellcheck
else
    echo "Warning: Not checking .sh/.bash files... no shellcheck"
fi

if [ -x "$(command -v yamllint)" ]; then
    find . -regextype egrep -iregex '.*\.ya?ml' -print0 | \
        xargs -0rt yamllint -s
else
    echo "Warning: Not checking yaml files... no yamllint"
fi

echo "ALL OK."
