(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *)

class Main inherits IO {

   stack : String <- "";

   prompt() : String {
      {
         out_string(">");
         in_string();
      }
   };

   enqueue(c: String) : Object {
      stack <- c.concat(stack)
   };

   main() : Object {
      {
         let command : String <- prompt() in
         while (not command = "x") loop 
            {
               if command = "e" then
                  stack <- (new EvalStackCommand).eval(stack)
               else 
                  if command = "d" then
                     (new DisplayStackCommand).display(stack)
                  else
                     enqueue(command)
                  fi
               fi;
               command <- prompt();
            }
         pool;
      }
   };

};

(*
   StackCommand - The base class for all stack commands
*)
class StackCommand inherits IO {
   
};

(*
   DisplayStackCommand - The corresponding stack command for input "d"
*)
class DisplayStackCommand inherits StackCommand {
   
   (*
      Iterate through the stack string and print all items
      Params:
         s (String) - the stack 
      Return:
         (String)
   *)
   display(s: String) : Object {
      
      {let i : Int in 
         while (i < s.length()) loop
            {
               out_string(s.substr(i,1).concat("\n"));
               i <- i+1;
            }
         pool;
      }
   };

};

(*
   AddStackCommand - The corresponding stack command for input "+"
*)
class AddStackCommand inherits StackCommand {
   
   (*
      Add the first two items (assumed integers)
      and push the result to the stack.
      Params:
         s (String) - the stack 
      Return:
         (String)
   *)
   add(s: String) : String {
      {let 
         x: Int <- (new A2I).c2i(s.substr(0,1)),
         y: Int <- (new A2I).c2i(s.substr(1,1))
      in 
         (new A2I).i2c(x+y).concat(s.substr(2, s.length()-2));
      }
   };
};

(*
   SwapStackCommand - The corresponding stack command for input "s"
*)
class SwapStackCommand inherits StackCommand {

   (*
      Swap the first two items on the stack.
      Params:
         s (String) - the stack 
      Return:
         (String)
   *)
   swap(s: String) : String {
      s.substr(1,1).concat(s.substr(0,1)).concat(s.substr(2,s.length()-2))
   };
};

(*
   EvalStackCommand - The corresponding stack command for input "e"
*)
class EvalStackCommand inherits StackCommand {

   (*
      Evaluate the command conveyed by the top of the stack.
      Params:
         s (String) - the stack 
      Return:
         (String)
   *)
   eval(s: String) : String {
      if s.length() = 0 then
         s
      else
         {let top : String <- s.substr(0, 1) in
            if top = "s" then
               {
                  s <- s.substr(1, s.length() - 1);
                  (new SwapStackCommand).swap(s);
               }
            else
               if top = "+" then
               {
                  s <- s.substr(1, s.length() - 1);
                  (new AddStackCommand).add(s);
               }
               else
                  s
               fi
            fi;
         }
      fi
   };
};
