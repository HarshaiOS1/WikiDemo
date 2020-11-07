import 'dart:convert';

SearchModel emptyFromJson(String str) => SearchModel.fromJson(json.decode(str));

String emptyToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  SearchModel({
    this.batchcomplete,
    this.purpleContinue,
    this.query,
  });

  bool batchcomplete;
  Continue purpleContinue;
  Query query;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    batchcomplete: json["batchcomplete"],
    purpleContinue: Continue.fromJson(json["continue"]),
    query: Query.fromJson(json["query"]),
  );

  Map<String, dynamic> toJson() => {
    "batchcomplete": batchcomplete,
    "continue": purpleContinue.toJson(),
    "query": query.toJson(),
  };
}

class Continue {
  Continue({
    this.gpsoffset,
    this.continueContinue,
  });

  int gpsoffset;
  String continueContinue;

  factory Continue.fromJson(Map<String, dynamic> json) => Continue(
    gpsoffset: json["gpsoffset"],
    continueContinue: json["continue"],
  );

  Map<String, dynamic> toJson() => {
    "gpsoffset": gpsoffset,
    "continue": continueContinue,
  };
}

class Query {
  Query({
    this.pages,
  });

  List<Page> pages;

  factory Query.fromJson(Map<String, dynamic> json) => Query(
    pages: List<Page>.from(json["pages"].map((x) => Page.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pages": List<dynamic>.from(pages.map((x) => x.toJson())),
  };
}

class Page {
  Page({
    this.pageid,
    this.ns,
    this.title,
    this.index,
    this.thumbnail,
    this.terms,
  });

  int pageid;
  int ns;
  String title;
  int index;
  Thumbnail thumbnail;
  Terms terms;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    pageid: json["pageid"],
    ns: json["ns"],
    title: json["title"],
    index: json["index"],
    thumbnail: json["thumbnail"] == null ? null : Thumbnail.fromJson(json["thumbnail"]),
    terms: Terms.fromJson(json["terms"]),
  );

  Map<String, dynamic> toJson() => {
    "pageid": pageid,
    "ns": ns,
    "title": title,
    "index": index,
    "thumbnail": thumbnail == null ? null : thumbnail.toJson(),
    "terms": terms.toJson(),
  };
}

class Terms {
  Terms({
    this.description,
  });

  List<String> description;

  factory Terms.fromJson(Map<String, dynamic> json) => Terms(
    description: List<String>.from(json["description"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": List<dynamic>.from(description.map((x) => x)),
  };
}

class Thumbnail {
  Thumbnail({
    this.source,
    this.width,
    this.height,
  });

  String source;
  int width;
  int height;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
    source: json["source"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "source": source,
    "width": width,
    "height": height,
  };
}
