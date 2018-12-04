module Env exposing (Env, create, navKey)

import Browser.Navigation as Nav


type Env
    = Env Internals


type alias Internals =
    { key : Nav.Key
    }


create : Nav.Key -> Env
create key =
    Env (Internals key)


navKey : Env -> Nav.Key
navKey (Env internals) =
    internals.key
