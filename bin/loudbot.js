var fs = require("fs");
var step = require("step");
var Requester = require("requester");
requester = new Requester();

loudurl = "http://isuckatdomains.net:3168/loud.pl"
loudfile = "/home/spiffytech/2.louds";

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
                        fs.appendFile(loudfile, "\n" + body);
                    }
                );
            }

            step(
                function() {
                    requester.get(loudurl, this);
                }, 
                function(body) {
                    console.log(body);
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
