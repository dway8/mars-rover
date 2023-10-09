const fs = require('fs')

// Link to compiled Elm code main.js
const Elm = require('./main').Elm;

// Get data from the command line
const args = process.argv.slice(2);

if (args.length !== 1) {
    console.error("[Error] Expecting one argument");
    return;
}

const filepath = args[0];

try {
    const content = fs.readFileSync(filepath);
    const input = content.toString();

    // Start worker with input
    const main = Elm.Main.init({flags: {input}});

    // Get data from the worker
    main.ports.sendResult.subscribe(function (data) {
        console.log(data);
    });

} catch (err) {

    console.error(`[Error] Error while reading file '${filepath}': ` + err.message);
    return;
}

