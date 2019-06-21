import System.Environment (lookupEnv)
import Utils
    ( Network (..)
    , calculateDelta
    , calculateError
    , forwardPropagate
    , generateRandomSynapses
    , getIterations
    , getLayerWidth
    , sigmoid
    , sigmoidDerivative
    , train
    , updateSynapse
    )

trainOnce :: Network -> Network
trainOnce (Network expectedOutput (layer0:_) (synapse0:_)) =
    let
        layer1 = forwardPropagate sigmoid layer0 synapse0
        layer1Error = calculateError expectedOutput layer1
        layer1Delta = calculateDelta sigmoidDerivative layer1 layer1Error
        updatedSynapse = updateSynapse layer0 layer1Delta synapse0
    in
        Network expectedOutput [layer0, layer1] [updatedSynapse]

main = do
    envIterations <- lookupEnv "ITERATIONS"
    let iterations = getIterations 100000 envIterations

    let x = [[0,0,1], [0,1,1], [1,0,1], [1,1,1]]
    let y =[[0], [0], [1], [1]]

    let widths = [getLayerWidth x, getLayerWidth y]
    let initialSynapses = generateRandomSynapses 1337 widths
    let initialState = Network y [x] initialSynapses

    let finalState = train trainOnce iterations initialState

    print "Output after training:"
    print $ last $ layers finalState

-- E.g.
-- [[3.0174488e-3],[2.460981e-3],[0.9979919],[0.9975376]]
--
-- Time: 1.003s (built with ghc -O)
-- Time: 4.267s (runghc)
