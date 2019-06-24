import System.Environment (lookupEnv)
import Utils
    ( Network(..)
    , generateRandomSynapses
    , getIterations
    , getLayerWidth
    , sigmoid
    , sigmoidDerivative
    , train
    )

main = do
    envIterations <- lookupEnv "ITERATIONS"
    let iterations = getIterations 100000 envIterations

    let x = [[0, 0, 1], [0, 1, 1], [1, 0, 1], [1, 1, 1]]
    let y = [[0], [1], [1], [0]]

    let hiddenWidth = 4
    let widths = [getLayerWidth x, hiddenWidth, getLayerWidth y]
    let initialSynapses = generateRandomSynapses 1337 widths
    let initialState = Network y [x] initialSynapses

    let finalState = train sigmoid sigmoidDerivative iterations initialState

    print "Output after training:"
    print $ last $ layers finalState
