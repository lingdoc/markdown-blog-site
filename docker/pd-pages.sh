#! /usr/bin/env bash
export navigation=$(cat navigation.html)

rm -f _sidebar.md

current_year="-"
for name in $(find articles -type f -exec basename {} \; | sort -ur | sed 's/\.md//' | head -n 10); do
  year=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\1/')
  month=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\2/')
  day=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\3/')
  title=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\4/')
  title1=$(sed '/^title: /!d;s///;q' ./articles/$name.md)
  title2=$(echo $title1 | sed -e 's/\"//g')
  MONTHS=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
  monum=$(echo $((10#$month-1)))
  moname=$(echo ${MONTHS[$monum]})
  nt2=$(echo "$(echo ${title:0:1} | tr  '[a-z]' '[A-Z]' )${title:1}" | sed -e 's/-/ /g')
  nice_title=$(echo "$day $moname: $title2")
  if [ $year != $current_year ]; then
    echo -e "\n### $year\n" >> _sidebar.md
  fi
  current_year=$year
  echo "[$nice_title](/blog/$year-$month-$day-$title.html)" >> _sidebar.md
done

echo "" >> _sidebar.md
echo "[more](/blog/index.html)" >> _sidebar.md

pandoc --from markdown-smart+yaml_metadata_block+auto_identifiers "_sidebar.md" \
  -o "_sidebar.html"


for page in $(ls pages); do
  pandoc --from markdown+smart+yaml_metadata_block+auto_identifiers "pages/$page" \
    -o "public/$(basename $page .md).html" \
    --template templates/page.html\
    -V navigation="$(cat navigation.html)" \
    -V footer="$(cat footer.html)" \
    -V sidebar="$(cat _sidebar.html)"
done

rm -f _sidebar.md _sidebar.html
