module docs4d;

import std.stdio;
import std.file;
import mustache;
import std.algorithm;
import std.array;
import std.string;
import std.regex;
import std.range;
import std.conv;
import dmarkdown;

struct Card
{
  string name;
  string description;
  string category;
  Param[] params;
  Example[] examples;
  Link[] links;
  string fileLocation;
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
  string githubUrl;

  this(string name, string ver, string githubUrl = ""){
     this.name = name;
     this.ver = ver;
     this.githubUrl = githubUrl;
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

     foreach (ref card; this.cards.sort!((a,b)=> a.name.toLower() < b.name.toLower())) {
       auto sub = context.addSubContext("cards");
       sub["name"]        = card.name;
       sub["category"]    = card.category;
       sub["description"] = card.description;

       if(card.params.length > 0){
         sub["signature"] = card.params.map!(p => p.type).join(" &#8594; ");
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

       if(card.links.length > 0){
          sub.useSection("has_see_also");
          foreach(ref link ; card.links){
            auto sub4 = sub.addSubContext("see_also");
            sub4["text"] = link.text;
            sub4["url"] = link.url;
          }
       }

       if(!card.fileLocation.empty){
         sub.useSection("has_gh");
         sub["gh"] = this.githubUrl ~ "/" ~ card.fileLocation;
       }

     }

     // make target dir
     if(exists("Docs")){
       rmdirRecurse("docs");
     }
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
            context["page_html"] = page.html();

        std.file.write("docs/" ~ page.filename,mustache.render("page", context));

     }

  }

}


