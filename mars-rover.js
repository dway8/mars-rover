// Link to compiled Elm code main.js
const Elm = require('./main').Elm;
const main = Elm.Main.init();

// Get data from the command line
const args = process.argv.slice(2);

if (args.length === 0) {
    console.error("[Error] Expecting one argument");
    return;
}

// Send data to the worker
main.ports.transformInput.send(args[0]);

// Get data from the worker
main.ports.sendResult.subscribe(function (data) {
    console.log(data);
});
