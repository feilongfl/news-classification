#!/usr/bin/env fish

set lineCount (wc -l ./data/news.des.label.save)
set traindatanum (expr 0.9 * $lineCount)
set testDataNum (expr $lineCount - $traindatanum)

set oridata ./data/news.title.label.save
set traindata /tmp/train.data
set testdata /tmp/test.data
set modeldir ./model/news.model

echo get $lineCount data, $traindatanum for train, $testDataNum for test.

head -n $traindatanum $oridata > $traindata 
tail -n $testDataNum $oridata > $testdata 

fasttext supervised -input $traindata -output $modeldir -epoch 50 -lr 1.0 -wordNgrams 2
fasttext test $modeldir.bin $testdata


