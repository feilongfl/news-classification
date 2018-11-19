#!/usr/bin/env fish

set oridata ./data/news.title.label.save
set tempdata /tmp/news.title.label.save
set traindata /tmp/train.data
set testdata /tmp/test.data
set modeldir ./model/news.model

set lineCount (wc -l $oridata | cut -d ' ' -f 1)
set traindatanum (expr 95 \* $lineCount / 100)
set testDataNum (expr $lineCount - $traindatanum)

echo get $lineCount data, $traindatanum for train, $testDataNum for test.

cat $oridata > $tempdata 

head -n $traindatanum $tempdata > $traindata 
tail -n $testDataNum $tempdata > $testdata 

fasttext supervised -input $traindata -output $modeldir -epoch 50 -lr 1.0 -wordNgrams 2
fasttext test $modeldir.bin $testdata


