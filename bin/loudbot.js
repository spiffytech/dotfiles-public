var fs = require("fs");
var step = require("step");
var Requester = require("requester");
requester = new Requester({
    timeout: 1500,
    retries: 0
});

loudurl = "http://iank.org/loudbot/loud"
loudfile = process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME'] + "/.louds";

step(
    function() {
        fs.readFile(loudfile, this);
    },
    function(err, data) {
        if(data !== undefined) {
            num_entries = data.toString().split("\n").length;
        } else {
            num_entries = 0;
        }
        if(num_entries < 5) {
            for(var i=num_entries; i<15; i++) {
                step(
                    function() {
                        requester.get(loudurl, this);
                    }, 
                    function(body) {
                        if(body !== null) {
                            fs.appendFile(loudfile, "\n" + JSON.parse(body)["loud"]);
                        } else {
                            throw "Not louding";
                        }
                    }
                );
            }

            step(
                function() {
                    requester.get(loudurl, this);
                }, 
                function(body) {
                    if(body !== null) {
                        console.log(JSON.parse(body)["loud"]);
                    }
                }
            );
        } else{
            step(
                function() {
                    fs.readFile(loudfile, this);
                },
                function(err, data) {
                    datas = data.toString().split("\n");
                    console.log(datas[0]);
                    fs.writeFile(loudfile, datas.slice(1).join("\n"));
                }
            );
        }
    }
);
