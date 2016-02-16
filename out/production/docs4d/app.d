import std.stdio;
import std.file;
import mustache;
import std.algorithm;
import std.array;

struct Card
{
  string name;
  string description;
  string category;
  Param[] params;
  Example[] examples;
}

struct Param
{
  string type;
  string id;
  string description;
  ParamType paramType;
}

struct Example
{
  string code;
}

enum ParamType
{
  INPUT,OUTPUT
}

void main()
{

     alias MustacheEngine!(string) Mustache;
     Mustache mustache;
     auto context = new Mustache.Context;

     context["title"] = "Erik Documentation";

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

     foreach (ref card; cards) {
       auto sub = context.addSubContext("cards");
       sub["name"]        = card.name;
       sub["category"]    = card.category;
       sub["description"] = card.description;

       if(card.params.length > 0){
         sub["signature"] = card.params.map!(p => p.type).join(" → ");
         sub.useSection("has_params");

         foreach(ref param ; card.params){
           if(param.paramType == ParamType.INPUT){
           auto sub2 = sub.addSubContext("input_params");
             sub2["type"] = param.type;
             sub2["id"] = param.id;
             sub2["desc"] = param.description;
           } else {
           auto sub3 = sub.addSubContext("return_value");
              sub.useSection("has_return");
              sub3["type"] = param.type;
              sub3["desc"] = param.description;
           }
         }

       }

       if(card.examples.length > 0){
         sub.useSection("has_examples");
         foreach(ref example ; card.examples){
           auto sub4 = sub.addSubContext("examples");
           sub4["code"] = example.code;
         }
       }

     }

//
//     auto categories = [
//     ]
//
//          foreach (ref category; categories) {
//              auto sub = context.addSubContext("projects");
//              sub["name"]        = project.name;
//              sub["url"]         = project.url;
//              sub["description"] = project.description;
//          }


     mustache.path  = "templates";
     mustache.level = Mustache.CacheLevel.no;

     // make target dir
     rmdirRecurse("docs");
     mkdir("docs");
     copy("resources/main.js","docs/main.js");
     copy("resources/style.css","docs/style.css");
     mkdir("docs/fonts");
     copy("resources/fonts/glyphicons-halflings-regular.woff2","docs/fonts/glyphicons-halflings-regular.woff2");

     std.file.write("docs/index.html",mustache.render("documentation", context));

}
