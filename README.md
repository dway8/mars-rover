# Mars Rover

## 📝 Overview
The Mars Rover app takes in a grid size & some robots input, and moves the robots around Mars 🤖🛸\
\
It works as follows:
- the JS script `move-robots.js` takes a filepath as an argument
- it reads the file content and initializes the Elm worker _(headless Elm program)_ with the input in the [flags](https://guide.elm-lang.org/interop/flags)
- the Elm worker parses the input, moves the robots & sends back the final states of the robots via an [outgoing port](https://guide.elm-lang.org/interop/ports.html)
- the JS script receives the result and prints it to the console.

## ⚙️ Installation
Before being able to run the script, you'll need to run `yarn build`.\
It will compile the Elm application to a `main.js` file that the `move-robots.js` script can make use of. 

## 🤖 Usage
`node move-robots.js <filepath>`

The filepath should refer to a file containing 2 things:
- a grid of size `m x n` (columns x rows)  
- one line per robot, with its initial position, orientation, and the list of commands.

Example of an input:
```
4 8
(2, 3, E) LFRFF
(0, 2, N) FFLFRF
```
For this particular example, the result printed out in the console should be:
```
(4, 4, E)
(0, 4, W) LOST
```
\
Some examples are included in the `examples/` folder, you can run them like this:\
`node move-robots.js examples/example1.txt`\
`node move-robots.js examples/example2.txt`\
`node move-robots.js examples/wrong.txt`

## ✅ Tests
`yarn test` will execute the Elm tests located in the `tests/` folder.\
Some low-level functions have been written in TDD to easily handle edge cases; other high-level functions like `Main.elm/transform` are tested mainly to validate everything is properly connected.

## 🚀 Next steps
### 🐞 Error messages
The program is printing `ERROR` if an error occurs while parsing the input.\
It could be useful to output a more verbose error, to easily spot where the mistake is located.\
\
Examples of what could be wrong in the input:
- no grid given
- a grid with a # of rows/columns < 1  (TODO not handled yet)
- no robots given
- an unknown initial orientation of a robot
- an unknown command in a robot's commands
- a robot with an initial state outside the grid (TODO not handled yet)

### 💥 Collisions
The robots are moving one after another, each one waiting for the previous one to be done before executing its commands.\
What if we need them to all move simultaneously because they don't have enough battery🪫 to wait for their turn?\
We should compute the next position for _every_ robot each turn, and then we have 2 alternatives if 2 or more robots want to go to the same position: 
- set the robots to a new variant `Crashed { crashPosition : Position }`
- make polite robots that let the previous one pass before moving forward

