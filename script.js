var fs = require('fs')
const { exec } = require('child_process');
const someFile = './config/application.yml'

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

        let dataArray = data.split('\n'); // convert file data in an array
        const searchKeyword = 'HOST_DEV_TELEGRAM';
        let lastIndex = -1; // let say, we have not found the keyword
        for (let index=0; index<dataArray.length; index++) {
            if (dataArray[index].includes(searchKeyword)) { // check if a line contains the 'user1' keyword
                lastIndex = index; // found a line includes a 'HOST_DEV_TELEGRAM' keyword
                break; 
            }
        }
        if (lastIndex == -1) {
            dataArray.push("HOST_DEV_TELEGRAM: '"+ stdout.trim() + "'")
        } else {
            dataArray[lastIndex] = "HOST_DEV_TELEGRAM: '"+ stdout.trim() + "'"
        }
        const result = dataArray.join('\n');
        fs.writeFile(someFile, result, 'utf8', function (err) {
            if (err) return console.log(err);
        });
    });

});