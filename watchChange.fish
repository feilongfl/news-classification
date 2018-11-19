#!/usr/bin/env fish
#

eval (ssh-agent -c)
ssh-add ~/.ssh/id_rsa

while true
#run rss get
#
#
echo rss get ...
./newspre.py > /dev/null
#run label
#
#
echo label ...
./label.fish > /dev/null
#dedup
#
#
echo dedu ...
cat ./data/news.title.label ./data/news.title.label.save | sort -n | uniq | tee ./data/news.title.label.save.tmp >/dev/null
cat ./data/news.des.label ./data/news.des.label.save | sort -n | uniq | tee ./data/news.des.label.save.tmp >/dev/null
cat ./data/news.title.ori ./data/news.title.origin.save | sort -n | uniq | tee ./data/news.title.origin.save.tmp >/dev/null
cat ./data/news.url ./data/news.url.save | sort -n | uniq | tee ./data/news.url.save.tmp >/dev/null

cp ./data/news.title.label.save.tmp ./data/news.title.label.save
cp ./data/news.des.label.save.tmp ./data/news.des.label.save
cp ./data/news.title.origin.save.tmp ./data/news.title.origin.save
cp ./data/news.url.save.tmp ./data/news.url.save

git add ./data/*.save
git commit -m (date)
git push

echo finish at (date)!
la ./data/*.save
wc ./data/*.save

sleep 5m
end

