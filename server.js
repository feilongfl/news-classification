var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var nodejieba = require("nodejieba");
var cheerio = require("cheerio");
//var WebSocketClient = require('websocket').client;
const { execSync  } = require('child_process');

nodejieba.load();

var urlencodedParser = bodyParser.urlencoded({ extended: false  })
//var client = new WebSocketClient();

app.use(express.static('public'));

app.get('/', function (req, res) {
    res.sendFile( __dirname + "/" + "index.html"  );
})

function removeHtmlTag(text){
    var $ = cheerio.load(text);
    return $.text()
}

function api(req, res){
    // resolve request
    response = req.body

    fulltext = response.fulltext
    title = response.title
    //check title and text
    titleTag = nodejieba.tag(title);
    textTag = nodejieba.tag(removeHtmlTag(fulltext));
    console.log(title)
    //pre-process text
    tag = []
    for (i in titleTag.concat(textTag)){
        if(textTag[i]){
            if(textTag[i].tag != 'x' &&
                textTag[i].tag != 'uj'){
                tag.push(textTag[i].word)
            }
        }
    }
    var tagText = tag.slice(0,99).join(' ');
    //fasttext
    var command = 'echo ' + tagText + '| fasttext predict-prob ./model/news.model.bin -'
    console.log(command)
    let fastout = execSync(command).toString();
    var result = {
        label: fastout.split(' ')[0].replace(/__label__/,''),
        prob: parseFloat(fastout.split(' ')[1])
    }
    //send data back
    console.log(result)
    res.send(JSON.stringify(result));
}

app.post('/news',urlencodedParser ,api)

var server = app.listen(24000, function () {
    var host = server.address().address
    var port = server.address().port
    console.log("start server at http://%s:%s", host, port)
})
