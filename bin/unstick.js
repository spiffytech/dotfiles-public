conf = require("./unstick_conf.json");

var step = require("step");

var exec = require("executive");
var tty = require("tty");

var util = require("util");
var ImapConnection = require("imap").ImapConnection;
var imap = new ImapConnection({
    username: conf.username,
    password: conf.password,
    host: "imap.gmail.com",
    port: 993,
    secure: true
});

var MailParser = require("mailparser").MailParser;
var mp = new MailParser();

messages = [];

step(
    function() {
        imap.connect(this);
    },
    function(err) {
        if(err) die(err);
        imap.openBox(conf.stucks_folder, false, this);
    },
    function(err, mailbox) {
        if(err) ide(err);

        imap.search(["UNSEEN", ["SINCE", "December 21, 2012"], ["!HEADER", "SUBJECT", "Unstuck Manually"]], this);
    },
    function(err, results) {
        if(results.length == 0) {
            console.log("No campaigns to unstick");
            imap.logout();
            return;
        }

        var fetch = imap.fetch(results, {
            request: {
                headers: ["from", "to", "subject", "date"],
                body: true
            },
            markSeen: true
        });

        fetch.on("message", function(message) {
            var body = "";

            message.on("data", function(chunk) {
                body += chunk.toString("utf8");
            });

            message.on("end", function() {
                var matches = body.match(/command=(.*--client [0-9]+ --campaign [0-9]+)/);
                if(matches) {
                    cmd = matches[1];
                    message.command = cmd;
                    messages.push(message);
                }
            });
        });

        fetch.on("end", function() {
            console.log("Unsticking " + messages.length + " stuck messages");
            unstick_campaigns(messages);
        });
    }
);

var unstick_campaigns = function(messages) {
    if(messages.length > 0) {
        message = messages[0];
        messages.shift();

        console.log("");
        console.log(message.headers.subject[0] + " " + message.headers.date[0]);
        console.log(message.command);

        exec(message.command + " --justdoit", function(err, stdout, stderr) {
            (function(messages) {
                unstick_campaigns(messages);
            })(messages);
        });
    } else {
        console.log("No more campaigns to unstick");
        imap.logout();
    }
}
