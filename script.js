var fs = require('fs')
const { exec } = require('child_process');
const someFile = './config/environments/development.rb'

exec(`curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\\1/p'`, (err, stdout, stderr) => {
    if (err) {
        // node couldn't execute the command
        console.log('error curl')
        return;
    }
    fs.readFile( someFile, 'utf8', function (err,data) {
        if (err) {
            return console.log(err);
        }
        var result = data.replace(/[a-z0-9]+\.ngrok\.io/g, stdout.trim());

        fs.writeFile(someFile, result, 'utf8', function (err) {
            if (err) return console.log(err);
        });
    });

});