#! /usr/bin/env bash
rm -f _index.md

export HEADER=$(cat index-header.md)

echo "$HEADER" > _index.md

current_year="-"
for name in $(find articles -type f -exec basename {} \; | sort -ur | sed 's/\.md//'); do
  year=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\1/')
  month=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\2/')
  day=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\3/')
  title=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\4/')
  lines=$(sed -n '/---/h;//!H;$!d;x;//p' ./articles/$name.md | tail -n+2)
  header=$(sed -n '2,/^---$/ {/^---$/d; p}' ./articles/$name.md)
  title2=$(sed '/^title: /!d;s///;q' ./articles/$name.md)
  contentn=$(echo $lines | tr '\n' ' ' | sed 's/\!\{0,1\}\]([^)]*)//g' | sed -e 's/\[//g')
  content=$(sed -z 's/.//201g' <<< $contentn)
  MONTHS=(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
  monum=$(echo $((10#$month-1)))
  moname=$(echo ${MONTHS[$monum]})
  nt2=$(echo "$(echo ${title:0:1} | tr  '[a-z]' '[A-Z]' )${title:1}" | sed -e 's/-/-/g')
  nice_title=$(echo "$day $moname: $(echo $title2 | sed -e 's/"//g')")
  if [ $year != $current_year ]; then
    echo -e "\n## $year\n" >> _index.md
  fi
  current_year=$year
  echo "<h4>[$nice_title](/blog/$year-$month-$day-$title.html)</h4>" >> _index.md
  echo "<div style="text-align:left">$content.. [(more)](/blog/$year-$month-$day-$title.html)</div>" >> _index.md

done

pandoc --from markdown+smart+yaml_metadata_block+auto_identifiers "_index.md" \
  -o "public/blog/index.html" \
  --template templates/article.html \
  -V navigation="$(cat navigation.html)" \
  -V footer="$(cat footer.html)"\
  -V year="$(date +%Y)"

# cp _index.md generatedindex.md
rm -f _index.md
