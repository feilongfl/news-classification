#!/usr/bin/env python3
import feedparser
import jieba_fast.posseg as jieba
import re
import os

#reference https://gist.github.com/dervn/859717/15b69ef75a04489f3a517b3d4f70c7e97b39d2ec
def removeXmlTag( htmlstr ):
    re_cdata=re.compile('//<!\[CDATA\[[^>]*//\]\]>',re.I)
    re_script=re.compile('<\s*script[^>]*>[^<]*<\s*/\s*script\s*>',re.I)
    re_style=re.compile('<\s*style[^>]*>[^<]*<\s*/\s*style\s*>',re.I)
    re_br=re.compile('<br\s*?/?>')
    re_h=re.compile('</?\w+[^>]*>')
    re_comment=re.compile('<!--[^>]*-->')
    s=re_cdata.sub('',htmlstr)
    s=re_script.sub('',s)
    s=re_style.sub('',s)
    s=re_br.sub('\n',s)
    s=re_h.sub('',s)
    s=re_comment.sub('',s)
    blank_line=re.compile('\n+')
    s=blank_line.sub('\n',s)
    s=replaceCharEntity(s)
    return s

def replaceCharEntity(htmlstr):
    CHAR_ENTITIES={'nbsp':' ','160':' ',
                'lt':'<','60':'<',
                'gt':'>','62':'>',
                'amp':'&','38':'&',
                'quot':'"','34':'"',}

    re_charEntity=re.compile(r'&#?(?P<name>\w+);')
    sz=re_charEntity.search(htmlstr)
    while sz:
        entity=sz.group()
        key=sz.group('name')
        try:
            htmlstr=re_charEntity.sub(CHAR_ENTITIES[key],htmlstr,1)
            sz=re_charEntity.search(htmlstr)
        except KeyError:
            htmlstr=re_charEntity.sub('',htmlstr,1)
            sz=re_charEntity.search(htmlstr)
    return htmlstr

def repalce(s,re_exp,repl_string):
    return re_exp.sub(repl_string,s)


# feilong code
def recreatedoc( doc , debug = False):
    seg_list = jieba.cut(doc)
    list = []
    if debug:
        print(doc)

    for word, flag in seg_list:
        if flag in ['n','vn','v','ns','nr','nt','j','nz','s','nrfg','b', 'nrt','l','i']:
            list.append(word)

    if debug:
        print(",".join(list))

    return " ".join(list[0:99])

rss_url = 'http://feilong-server.lan:23000/users/1/web_requests/98/news.xml'
#rss_url = 'http://feilong-server.lan:23000/users/1/web_requests/14/news.xml'
#rss_url = './a.xml'
feeds = feedparser.parse(rss_url)

#os.mkdir('./data')
fileNewsTitleOrigin = open('./data/news.title.ori','a')
fileNewsTitlePre = open('./data/news.title.pre','a')
fileNewsURL = open('./data/news.url','a')
fileNewsDes = open('./data/news.des','a')

feedscount = len(feeds.entries)
for post,index in zip(feeds.entries, range(feedscount)):
    print ("[%d/%d] JieBa" % (index, feedscount))
    fileNewsTitleOriginData = (post.title)
    fileNewsTitlePreData = (recreatedoc(post.title,debug=True))
    fileNewsURLData = (post.link)
    fileNewsDesData = (recreatedoc(removeXmlTag(post.description)))
    fileNewsTitleOrigin.write(fileNewsTitleOriginData + '\n')
    fileNewsTitlePre.write(fileNewsTitlePreData + '\n')
    fileNewsURL.write(fileNewsURLData + '\n')
    fileNewsDes.write(fileNewsDesData + '\n')
    #print("[%s](%s){%s}" % (recreatedoc(post.title), post.link, recreatedoc(removeXmlTag(post.description))))
    #print("[%s](%s){%s}" % (fileNewsTitlePreData, fileNewsURLData, fileNewsDesData))

fileNewsTitleOrigin.close()
fileNewsTitlePre.close()
fileNewsURL.close()
fileNewsDes.close()

