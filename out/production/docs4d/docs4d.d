module docs4d;

import std.stdio;
import std.file;
import mustache;
import std.algorithm;
import std.array;
import dmarkdown;

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

struct Link
{
  string text;
  string url;
  string active = "";
}

struct Page
{
  string filename;
  string name;
  Link[] links;
  string markdownFile;

  string html(){
    auto markdown = readText(markdownFile);
    return filterMarkdown(markdown);
  }

}

class DocGen
{

  string name;
  string ver;
  Page[] pages;
  Card[] cards;
  Link[] links;
  alias MustacheEngine!(string) Mustache;
  Mustache mustache;
  Mustache.Context context;

  this(string name, string ver){
     this.name = name;
     this.ver = ver;
     this.context = new Mustache.Context;
     mustache.path  = "templates";
     mustache.level = Mustache.CacheLevel.no;
  }

  public DocGen withCards(Card[] cards)
  {
    this.cards = cards;
    return this;
  }

 public DocGen withLinks(Link[] links)
  {
    this.links = links;
    return this;
  }

  public DocGen withPages(Page[] pages)
  {
    this.pages = pages;
    return this;
  }

  public void generate(){
     this.context["name"] = this.name;
     this.context["ver"] = this.ver;

     this.links.each!((link){
        auto subLinks = context.addSubContext("links");
         subLinks["text"]  = link.text;
         subLinks["url"] = link.url;
         subLinks["active"] = link.active;
     });

     foreach (ref card; this.cards) {
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

     // make target dir
     rmdirRecurse("docs");
     mkdir("docs");
     copy("resources/main.js","docs/main.js");
     copy("resources/style.css","docs/style.css");
     mkdir("docs/fonts");
     copy("resources/fonts/glyphicons-halflings-regular.woff2","docs/fonts/glyphicons-halflings-regular.woff2");

     std.file.write("docs/documentation.html",mustache.render("documentation", context));

     foreach(ref page ; pages){
        page.links.each!((link){
               auto subLinks = context.addSubContext("page_links");
                subLinks["text"]  = link.text;
                subLinks["url"] = link.url;
                subLinks["active"] = link.active;
            });
            context["page_html"] = (string str) { return page.html(); };

        std.file.write("docs/" ~ page.filename,mustache.render("page", context));

     }

  }

}

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


