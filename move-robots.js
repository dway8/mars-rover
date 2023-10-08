const fs = require('fs')

// Link to compiled Elm code main.js
const Elm = require('./main').Elm;
const main = Elm.Main.init();

// Get data from the command line
const args = process.argv.slice(2);

if (args.length !== 1) {
    console.error("[Error] Expecting one argument");
    return;
}

const filepath = args[0];
fs.readFile(filepath, (err, data) => {
    if (err) {
        console.error(`[Error] Error while reading file '${filepath}': `+ err.message);
        return;
    }
    const input = data.toString();

    // Send data to the worker
    main.ports.transformInput.send(input);
})


// Get data from the worker
main.ports.sendResult.subscribe(function (data) {
    console.log(data);
});
