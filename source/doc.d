import docs4d;

void main()
{

     auto cards = [
       Card("getStatus","some description","Session",[Param("ServerStatus","","The status of the server",ParamType.OUTPUT)]),
       Card("test","some description","Session"),
       Card("oops","some oops description","Session", [
         Param("Server","server","The status of the server",ParamType.INPUT),
         Param("Resp","name","The resp",ParamType.INPUT),
         Param("String","","The return string",ParamType.OUTPUT)
         ],
         [
         Example("auto status = getStatus();"),
         Example("auto name = getName();")
         ])
     ];

     auto links = [
       Link("Home","home.html"),
       Link("Documentation","#","active"),
       Link("Github","https://github.com/kingsleyh/erik")
     ];

     auto pages = [
       Page("home.html","Home",[
                                 Link("Home","home.html","active"),
                                 Link("Documentation","documentation.html"),
                                 Link("Github","https://github.com/kingsleyh/erik")
                               ],"home.md")
     ];

     new DocGen("Erik","v0.01")
     .withLinks(links)
     .withCards(cards)
     .withPages(pages)
     .generate();

}
