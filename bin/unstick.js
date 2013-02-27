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
                // Get campaign unstick command
                cmd_matches = body.match(/\/campaigns\/src\/ServerApps\/gearman\/UnstickCampaign.php.*--client ([0-9]+) --campaign ([0-9]+)/);
                if(cmd_matches) {
                    // Detect campaign type
                    var type_matches = body.match(/type: ([0-9]+)/);
                    if(type_matches == null) {
                        console.log(body);
                    }
                    var type = parseInt(type_matches[1]);
                    if(type == 0) {
                        type = "standard";
                    } else if(type == 1) {
                        type = "triggered";
                    }
                    message.type = type;

                    message.data = {
                        client_id: cmd_matches[1],
                        campaign_id: cmd_matches[2]
                    };
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
        console.log(message.headers.subject[0] + " " + message.headers.date[0] + ", type: " + message.type);
        command = "/campaigns/php/bin/php /campaigns/src/ServerApps/gearman/UnstickCampaign.php --client " + message.data.client_id + " --campaign " + message.data.campaign_id + " --justdoit"
        console.log(command);

        exec(command, function(err, stdout, stderr) {
            (function(messages) {
                unstick_campaigns(messages);
            })(messages);
        });
    } else {
        console.log("No more campaigns to unstick");
        imap.logout();
    }
}
