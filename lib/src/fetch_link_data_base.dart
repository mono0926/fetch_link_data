import 'dart:convert';

import 'package:euc/euc.dart';
import 'package:fetch_link_data/src/models/link_data.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class FetchLinkData {
  /// this function for getting all the possible URL content
  /// you just pass the [url] and it will return back an object of [LinkData] which contains
  /// all possible data can back from this url
  static Future<LinkData> fetchLinkData(String url) async {
    final LinkData linkData = LinkData();
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parser.parse(
            _encodingForHeaders(response.headers).decode(response.bodyBytes));
        final metaTags = document.getElementsByTagName('meta');
        for (var tag in metaTags) {
          final property = tag.attributes['property'];

          if (property == 'og:title') {
            linkData.title = tag.attributes['content'];
          }

          if (property == 'og:description') {
            linkData.description = tag.attributes['content'];
          }

          if (property == 'og:site_name') {
            linkData.siteName = tag.attributes['content'];
          }

          if (property == 'og:url') {
            linkData.url = tag.attributes['content'];
          }

          if (property == 'og:image') {
            linkData.image = tag.attributes['content'];
          }

          if (property == 'og:image:width') {
            linkData.imageWidth = tag.attributes['content'];
          }

          if (property == 'og:image:height') {
            linkData.imageHeight = tag.attributes['content'];
          }

          if (property == "og:image:alt") {
            linkData.imageAlt = tag.attributes['content'];
          }

          if (property == "og:image:type") {
            linkData.imageType = tag.attributes['content'];
          }

          if (property == "og:type") {
            linkData.type = tag.attributes['content'];
          }

          if (property == "og:locale") {
            linkData.locale = tag.attributes['content'];
          }

          if (property == "article:author") {
            linkData.articleAuthor = tag.attributes['content'];
          }

          if (property == "article:publisher") {
            linkData.articlePublisher = tag.attributes['content'];
          }

          if (property == "og:video:url") {
            linkData.video = tag.attributes['content'];
          }

          if (property == "og:video:type") {
            linkData.videoType = tag.attributes['content'];
          }

          if (property == "og:video:width") {
            linkData.videoWidth = tag.attributes['content'];
          }

          if (property == "og:video:height") {
            linkData.videoHeight = tag.attributes['content'];
          }

          if (property == "og:video:tag") {
            linkData.videoTags.add(tag.attributes['content']);
          }
        }
      }
    } catch (e) {
      rethrow;
    }

    // here we check if the url is belong to tiktok we fetch the image and return it
    if (linkData.siteName?.toLowerCase() == "tiktok") {
      linkData.image = await getTikTokImage(url);
    }

    return linkData;
  }

  /// this function for getting the TikTok Image from the TikTok API
  /// You just provide the [url] of the post it will return the thumbnail URL
  static Future<String?> getTikTokImage(String url) async {
    final result = await http.get(
      Uri.parse(
        "https://www.tiktok.com/oembed?url=$url",
      ),
    );
    return jsonDecode(result.body)['thumbnail_url'];
  }
}

Encoding _encodingForHeaders(Map<String, String> headers) =>
    encodingForCharset(_contentTypeForHeaders(headers).parameters['charset']);

Encoding encodingForCharset(String? charset, [Encoding fallback = latin1]) {
  if (charset == null) return fallback;
  final encoding = Encoding.getByName(charset);
  if (encoding == null) {
    if (charset.toLowerCase() == 'euc-jp') {
      return EucJP();
    }
  }
  return encoding ?? fallback;
}

MediaType _contentTypeForHeaders(Map<String, String> headers) {
  var contentType = headers['content-type'];
  if (contentType != null) return MediaType.parse(contentType);
  return MediaType('application', 'octet-stream');
}
