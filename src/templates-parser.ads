with Templates.Ast;

package Templates.Parser is

   --  Parse template source into an AST root node.
   --  @param Source template source text
   --  @return root AST node
   function Parse (Source : String) return Templates.Ast.Node_Access;

end Templates.Parser;
