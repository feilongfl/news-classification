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
cat ./data/news.title.label ./data/news.title.label.save | sort -n | uniq | tee ./data/news.title.label.save >/dev/null
cat ./data/news.des.label ./data/news.des.label.save | sort -n | uniq | tee ./data/news.des.label.save >/dev/null
cat ./data/news.title.ori ./data/news.title.origin.save | sort -n | uniq | tee ./data/news.title.origin.save >/dev/null
cat ./data/news.url ./data/news.url.save | sort -n | uniq | tee ./data/new.url.save >/dev/null

git add ./data/*.save
git commit -m (date)
git push

echo finish at (date)!
la ./data/news.title.label.save
wc ./data/news.title.label.save
la ./data/news.des.label.save
wc ./data/news.des.label.save

sleep 5m
end

