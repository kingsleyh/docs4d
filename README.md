## Docs4d

This project generates documentation for code. Rather than using comments embedded in the code Docs4d requires you to write the documentation separately
using it's DSL-like API. I didn't want to litter my code with comments and this is my alternative approach based on a similar idea by the great and powerful [Stacy Curl](https://github.com/stacycurl)

The output templates have been re-purposed from the [Ramdajs](http://ramdajs.com/0.19.1/docs/) project. So really I didn't do much since I took the general idea 
from Stacy and the html/css/javascript from Ramdajs.

### API Documentation

In the general spirit of eating my own - the documentation for this project has been generated using this project itself.

[Documentation](https://rawgit.com/kingsleyh/docs4d/master/docs/documentation.html)

### Example

Here is the code that generated this documentation:

        import docs4d;
        
        void main()
        {
        
             auto cards = [
               Card("new","Creates a new instance of the DocGen class.","DocGen",[
                 Param("string","name","(project name)",ParamType.INPUT),
                 Param("string","version","(project version)",ParamType.INPUT),
                 Param("string","githubUrl","(base url to github branch e.g. master)",ParamType.INPUT),
                 Param("DocGen","","",ParamType.OUTPUT)
                 ],[
                   Example(
                   "new DocGen(\"Docs4d\",\"v0.0.1\")\n"
                   "     .withLinks(links)       \n"
                   "     .withCards(cards)       \n"
                   "     .withPages(pages)       \n"
                   "     .generate();            \n"
                   )
                 ], [],"source/docs4d.d"),
               Card("withLinks","Sets the links on the top navbar.","DocGen", [
                 Param("Link[]","links","(an array of Link structs)",ParamType.INPUT),
                 Param("DocGen","","",ParamType.OUTPUT)
                 ],
                 [
                 Example(
                   "auto links = [                                                 \n"
                   "      Link(\"Home\",\"home.html\"),                            \n"
                   "      Link(\"Documentation\",\"#\",\"active\"),                \n"
                   "      Link(\"Github\",\"https://github.com/kingsleyh/docs4d\") \n"
                   "    ];                                                         \n"
                   "new DocGen(\"Docs4d\",\"v0.0.1\").withLinks(links);            \n"
                 )],
                 [Link("Link","#Link")],"source/docs4d.d"
                 ),
                  Card("withCards","Specifies the documentation for each item.","DocGen", [
                    Param("Card[]","cards","(an array of Card structs)",ParamType.INPUT),
                    Param("DocGen","","",ParamType.OUTPUT)
                    ],
                    [
                    Example(
                      "auto cards = [                                                                 \n"
                      "       Card(\"new\",\"Creates a new instance of the DocGen class.\",\"DocGen\",[ \n"
                      "         Param(\"string\",\"name\",\"(project name)\",ParamType.INPUT),         \n"
                      "         Param(\"string\",\"version\",\"(project version)\",ParamType.INPUT),   \n"
                      "         Param(\"DocGen\",\"\",\"\",ParamType.OUTPUT)                           \n"
                      "         ],[                                                                    \n"
                      "           Example(                                                             \n"
                      "           \"new DocGen(\"Docs4d\",\"v0.0.1\")\\n\"                             \n"
                      "           \"     .withLinks(links)       \\n\"                                 \n"
                      "           \"     .withCards(cards)       \\n\"                                 \n"
                      "           \"     .withPages(pages)       \\n\"                                 \n"
                      "           \"     .generate();            \\n\"                                 \n"
                      "           )                                                                    \n"
                      "         ],[Link(\"Card\",\"#Card\")])];                                        \n"
                      "new DocGen(\"Docs4d\",\"v0.0.1\").withCards(cards);                             \n"
                    )
                    ],[Link("Card","#Card"),Link("Param","#Param"),Link("Example","#Example")],"source/docs4d.d"),
                    Card("withPages","Specifies additional pages.","DocGen", [
                      Param("Page[]","pages","(an array of Page structs)",ParamType.INPUT),
                      Param("DocGen","","",ParamType.OUTPUT)
                      ],
                      [
                      Example(
                      "auto pages = [                                               \n"
                      "  Page(\"home.html\",\"Home\",[                              \n"
                      "    Link(\"Home\",\"home.html\",\"active\"),                 \n"
                      "    Link(\"Documentation\",\"documentation.html\"),          \n"
                      "    Link(\"Github\",\"https://github.com/kingsleyh/docs4d\") \n"
                      "    ],\"README.md\")                                         \n"
                      "];                                                           \n"
                     )
                      ],[Link("Page","#Page"), Link("Link","#Link")],"source/docs4d.d"),
                    Card("generate", "generates the html files", "void",[],[],[],"source/docs4d.d"),
                    Card("Link", "Struct that holds link information.", "Link", [
                      Param("string","text", "", ParamType.INPUT),
                      Param("string","url", "", ParamType.INPUT),
                      Param("string","active", "(leave blank if link is not the active page, otherwise use text 'active')", ParamType.INPUT),
                      Param("Link","","",ParamType.OUTPUT)
                    ],[
                      Example("Link(\"Home\",\"home.html\")")
                    ],[Link("withLinks","#withLinks"), Link("withPages","#withPages"), Link("withCards","#withCards")],"source/docs4d.d"),
                    Card("Card","Struct that holds documentation information.", "Card",[
                      Param("string","name","", ParamType.INPUT),
                      Param("string","description","", ParamType.INPUT),
                      Param("string","category","", ParamType.INPUT),
                      Param("Param[]","params","", ParamType.INPUT),
                      Param("Example[]","examples","", ParamType.INPUT),
                      Param("Card","","",ParamType.OUTPUT)
                    ],[
                      Example(
                      "       Card(\"new\",\"creates a new instance of the DocGen class\",\"DocGen\",[ \n"
                      "         Param(\"string\",\"name\",\"(project name)\",ParamType.INPUT),         \n"
                      "         Param(\"string\",\"version\",\"(project version)\",ParamType.INPUT),   \n"
                      "         Param(\"DocGen\",\"\",\"\",ParamType.OUTPUT)                           \n"
                      "         ],[                                                                    \n"
                      "           Example(                                                             \n"
                      "           \"new DocGen(\"Docs4d\",\"v0.0.1\")\\n\"                             \n"
                      "           \"     .withLinks(links)       \\n\"                                 \n"
                      "           \"     .withCards(cards)       \\n\"                                 \n"
                      "           \"     .withPages(pages)       \\n\"                                 \n"
                      "           \"     .generate();            \\n\"                                 \n"
                      "           )                                                                    \n"
                      "         ])];                                                                   \n"
                      )
                    ],[Link("withCards","#withCards")],"source/docs4d.d"),
                    Card("Param","Struct that holds parameter info.","Param",[
                      Param("string","type","",ParamType.INPUT),
                      Param("string","id","",ParamType.INPUT),
                      Param("string","description","",ParamType.INPUT),
                      Param("ParamType","ParamType","",ParamType.INPUT),
                      Param("Param","","",ParamType.OUTPUT)
                    ],[
                     Example("Param(\"string\",\"name\",\"(project name)\",ParamType.INPUT)")
                    ],[Link("Card","#Card"),Link("ParamType","#ParamType")],"source/docs4d.d"),
                    Card("Example","Struct that holds example info.","Example",[
                      Param("string","code","",ParamType.INPUT),
                      Param("Example","","",ParamType.OUTPUT)
                    ],[
                     Example("Example(\"auto doc = new DocGen(\\\"Docs4d\\\",\\\"v0.0.1\\\")\")")
                    ],[],"source/docs4d.d"),
                    Card("ParamType","Struct that holds parameter type info for params.","ParamType",[
                     Param("ParamType","","(ParamType.INPUT,ParamType.OUTPUT)",ParamType.OUTPUT)
                    ],[Example("Param(\"string\",\"name\",\"(project name)\",ParamType.INPUT)")],[Link("Param","#Param")],"source/docs4d.d")
             ];
        
             auto links = [
               Link("Home","home.html"),
               Link("Documentation","#","active"),
               Link("Github","https://github.com/kingsleyh/docs4d")
             ];
        
             auto pages = [
               Page("home.html","Home",[
                                         Link("Home","home.html","active"),
                                         Link("Documentation","documentation.html"),
                                         Link("Github","https://github.com/kingsleyh/docs4d")
                                       ],"README.md")
             ];
        
             new DocGen("Docs4d","v0.0.1","https://github.com/kingsleyh/docs4d/blob/master")
             .withLinks(links)
             .withCards(cards)
             .withPages(pages)
             .generate();
        
        }

        

