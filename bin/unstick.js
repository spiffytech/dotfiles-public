var step = require("step");

var util = require("util");
var ImapConnection = require("imap").ImapConnection;
var imap = new ImapConnection({
    username: "brian@contactology.com",
    password: "Re6UFdYshuDx",
    host: "imap.gmail.com",
    port: 993,
    secure: true
});

var MailParser = require("mailparser").MailParser;
var mp = new MailParser();


step(
    function() {
        imap.connect(this);
    },
    function(err) {
        if(err) die(err);
        imap.openBox("stuck_campaigns", false, this);
    },
    function(err, mailbox) {
        if(err) ide(err);

        imap.search(["UNSEEN", ["SINCE", "December 18, 2012"], ["!HEADER", "SUBJECT", "Unstuck Manually"]], this);
    },
    function(err, results) {
        var fetch = imap.fetch(results, {
            request: {
                headers: ["from", "to", "subject", "date"],
                body: true
            }
        });
        fetch.on("message", function(msg) {
            var body = "";

            msg.on("data", function(chunk) {
                body += chunk.toString("utf8");
            });

            msg.on("end", function() {
                console.log(msg.headers.subject);
                console.log(msg.headers.date);
                //console.log(msg);
                console.log(body.slice(0, 50));
            });
        });
        fetch.on("end", function() {
            console.log("All done.");
            imap.logout();
        });
    }
);
