
import sys
import gen.aslLexer
import gen.aslParser
import antlr4
from antlr4.tree.Trees import Trees

if __name__ == "__main__":
    filename = r"C:\Users\terzi\OneDrive\Documents\asli\examples\constant_declarations"

    #filename = r"C:\Users\terzi\OneDrive\Documents\asli\examples\operations"
    #filename = r"C:\Users\terzi\OneDrive\Documents\asli\examples\enumerations.asl"

    file_stream = antlr4.FileStream(filename)
    lexer = gen.aslLexer.aslLexer(file_stream)
    stream = antlr4.CommonTokenStream(lexer)

    parser = gen.aslParser.aslParser(stream)

    tree = parser.rulelist()
    print(Trees.toStringTree(tree, None, parser))

            #htmlChat = HtmlChatListener(output)
            #walker = ParseTreeWalker()
            #walker.walk(htmlChat, tree)


    # import your parser & lexer here

    # setup your lexer, stream, parser and tree like normal

