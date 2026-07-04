with Templates.Ast;
with Templates.Values;

package Templates.Renderer is

   --  Render an AST root against a context value.
   --  @param Root parsed AST root
   --  @param Context active rendering context
   --  @return rendered HTML
   function Render
     (Root    : Templates.Ast.Node_Access;
      Context : Templates.Values.Value)
      return String;

end Templates.Renderer;
