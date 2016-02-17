import docs4d;

void main()
{

     auto cards = [
       Card("new","creates a new instance of the DocGen class","DocGen",[
         Param("string","name","(project name)",ParamType.INPUT),
         Param("string","version","(project version)",ParamType.INPUT),
         Param("DocGen","","",ParamType.OUTPUT)
         ],[
           Example(
           "new DocGen(\"Docs4d\",\"v0.0.1\")\n"
           "     .withLinks(links)       \n"
           "     .withCards(cards)       \n"
           "     .withPages(pages)       \n"
           "     .generate();            \n"
           )
         ]),
       Card("withLinks","sets the links on the top navbar","DocGen", [
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
         )
         ]),
          Card("withCards","specifies the documentation for each item","DocGen", [
            Param("Card[]","cards","(an array of Card structs)",ParamType.INPUT),
            Param("DocGen","","",ParamType.OUTPUT)
            ],
            [
            Example(
              "auto cards = [                                                                 \n"
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
              "new DocGen(\"Docs4d\",\"v0.0.1\").withCards(cards);                             \n"
            )
            ]),
            Card("withPages","specifies additional pages","DocGen", [
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
              ])
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

     new DocGen("Docs4d","v0.0.1")
     .withLinks(links)
     .withCards(cards)
     .withPages(pages)
     .generate();

}
