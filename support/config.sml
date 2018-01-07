(*
 * Parses a named file as JSON, and extracts a value from it using a path.
 *
 * - The JSON file must be an object at the top level
 * - You can extract values from nested objects with 'foo.bar.qux'
 *
 * Example usage:
 *
 *     $ vbs-util config test/sml.json cm.make/onSave
 *     development.cm
 *)

structure Config =
struct
  structure JU = JSONUtil
  open Util

  fun failWith message value =
    (printErrLn message;
     JSONPrinter.print (TextIO.stdErr, value);
     printErrLn "";
     OS.Process.failure)

  fun get [configFileName, pathString] =
    (let
      val config = JSONParser.parseFile configFileName

      fun isDot c = c = #"."
      val path = map JU.SEL (String.tokens isDot pathString)
    in
      println (JU.asString (JU.get (config, path)));
      OS.Process.success
    end
    handle (JU.NotString v) => failWith "expecting string; found:" v
      | (JU.NotObject v) => failWith "expecting object; found:" v
      | (JU.FieldNotFound (v, msg)) => failWith (msg^"; found:") v)
    | get _ = OS.Process.failure
end
