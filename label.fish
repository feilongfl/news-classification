#!/usr/bin/env fish
set labelfile ./data/news.url.label
cp ./data/news.url $labelfile

# label list
set society __label__society
set domestic __label__domestic
set finance __label__finance
set world __label__world
set entertainment __label__entertainment
set technology __label__technology
set sport __label__sport
set education __label__education
set military __label__military
set acg __label__animecomicgame
set health __label__health

# url filter list
cat $labelfile | \
sed -r 's/https?\:\/\/www\.chinanews\.com\/sh\/.*/'$society'/g' | \
sed -r 's/https?\:\/\/www\.chinanews\.com\/gn\/.*/'$domestic'/g' | \
sed -r 's/https?\:\/\/www\.chinanews\.com\/gj\/.*/'$world'/g' | \
sed -r 's/https?\:\/\/www\.chinanews\.com\/cj\/.*/'$finance'/g' | \
sed -r 's/https?\:\/\/www\.chinanews\.com\/ty\/.*/'$sport'/g' | \
sed -r 's/https?\:\/\/finance\.sina\.com\.cn\/.*/'$finance'/g' | \
sed -r 's/https?\:\/\/news\.sina\.com\.cn\/w\/.*/'$world'/g' | \
sed -r 's/https?\:\/\/ent\.sina\.com\.cn\/.*/'$entertainment'/g' | \
sed -r 's/https?\:\/\/tech\.sina\.com\.cn\/.*/'$technology'/g' | \
sed -r 's/https?\:\/\/www\.xinhuanet\.com\/local\/.*/'$domestic'/g' | \
sed -r 's/https?\:\/\/www\.xinhuanet\.com\/world\/.*/'$world'/g' | \
sed -r 's/https?\:\/\/www\.xinhuanet\.com\/tw\/.*/'$world'/g' | \
sed -r 's/https?\:\/\/news\.eastday\.com\/w\/.*/'$world'/g' | \
tee $labelfile

# output
#
echo '##############################################'
#cat $labelfile
paste $labelfile ./data/news.title.pre | grep __label | tee ./data/news.title.label
paste $labelfile ./data/news.title.pre ./data/news.des | grep __label | tee ./data/news.des.label

la ./data/news.title.label
wc ./data/news.title.label
la ./data/news.des.label
wc ./data/news.des.label

