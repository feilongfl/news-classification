#!/usr/bin/env fish
websocketd -port 24001 fasttext predict-prob ./model/news.model.bin -
