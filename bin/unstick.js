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

commands = [];

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

        imap.search(["UNSEEN", ["SINCE", "December 21, 2012"], ["!HEADER", "SUBJECT", "Unstuck Manually"]], this);
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
                var matches = body.match(/command=(.*--client [0-9]+ --campaign [0-9]+)/);
                if(matches) {
                    console.log(msg.headers.subject[0]);
                    console.log(msg.headers.date[0]);
                    console.log(matches[1]);
                    cmd = matches[1];
                    commands.push(cmd);
                }
            });
        });

        fetch.on("end", function() {
            console.log("All done.");
            imap.logout();
            cmds = [];
            for(command in commands) {
                cmd = "./test.sh";
                cmds.push(cmd);
            }
            exec(cmds, function(err, stdout, stderr) {
            });
        });
    }
);
