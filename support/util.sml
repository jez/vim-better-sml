structure Util =
struct
  fun println str = print (str ^ "\n")

  fun printErr str =
    (TextIO.output (TextIO.stdErr, str);
     TextIO.flushOut TextIO.stdErr)

  fun printErrLn str = printErr (str ^ "\n")

  val isUse : string -> bool = String.isPrefix "    "

  val resolve = OS.FileSys.realPath o OS.FileSys.fullPath

  (* Evaluate a simple state transition function.
   * init    - Compute and return the initial state
   * trystep - Transition to SOME other state, or NONE if done transitioning.
   *)
  fun eval
    (init : unit -> 'a)
    (trystep : 'a -> 'a option)
    : 'a =
    let
      fun unfold state =
        case trystep state
          of NONE => state
           | SOME state' => unfold state'
    in
      unfold (init ())
    end
end
