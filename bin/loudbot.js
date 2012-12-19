var fs = require("fs");
var step = require("step");
var Requester = require("requester");
requester = new Requester();

step(
    function() {
        requester.get("http://isuckatdomains.net:3168/loud.pl", this);
    },
    function(body) {
        this.body = body;
        fs.readFile("~/.louds", this);
    },
    function(err, data) {
        console.log(err);
        console.log(data);
        console.log(this.body);
    }
)
