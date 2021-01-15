# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

inkling "2.0"

using Math
using Goal

# thresholds
const MaxDeviation = 5.0

# This is the state received from the simulator after each iteration.
type SimState {
    Tset: number<60 .. 86>,
    Troom1: number,
    Troom2: number,
    Troom3: number,
    n_rooms: number,
    Toutdoor: number,
    total_cost: number,
    step_cost: number,
}

# This is the subset of the simulator state that is observable by the AI.
type ObservableState {
    Tset: number,
    Troom_avg: number,
    Toutdoor: number,
    total_cost: number
}

# This is the action that is sent to the simulator.
type SimAction {
    command: number<cool=1.0, heat=2.0, off=3.0,>
}

type SimConfig {
    # Average outdoor temperature for the day
    input_Toutdoor: number<25.0 .. 100.0>,
    
    # Number of rooms in building
    input_nRooms: number,
    
    # Number of windows in building
    input_nWindowsRoom1: number,
    input_nWindowsRoom2: number,
    input_nWindowsRoom3: number,
}

# This returns the average of all active rooms (TroomX is 0F if room is nonexistent)
function TransformState(State: SimState): ObservableState {
    return {
        Tset: State.Tset,
        Troom_avg: (State.Troom1 + State.Troom2 + State.Troom3) / State.n_rooms,
        Toutdoor: State.Toutdoor,
        total_cost: State.total_cost,
    }
}

function TempDiff(Tin:number, Tset:number) {
    return Math.Abs(Tin - Tset)
}

graph (input: ObservableState): SimAction {
    concept adjust(input): SimAction {
        curriculum {
            source simulator (action: SimAction, config: SimConfig): SimState {
            }

            state TransformState

            training {
                # Limit episodes to 288 iterations, which is 1 day (24 hours).
                EpisodeIterationLimit: 288,
                NoProgressIterationLimit: 500000
            }

            goal (State: SimState) {
                minimize `Temp Deviation`:
                    TempDiff(TransformState(State).Troom_avg, TransformState(State).Tset) in Goal.RangeBelow(MaxDeviation)
            }

            lesson adjust {
                scenario {
                    input_Toutdoor: number<25.0 .. 100.0>,
                    input_nRooms: number<1, 2, 3>,
                    input_nWindowsRoom1: number<1 .. 12>,
                    input_nWindowsRoom2: number<1 .. 12>,
                    input_nWindowsRoom3: number<1 .. 12>,
                }
            }

        }
    }
    output adjust
}
