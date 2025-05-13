const _baseExcludeEmojisAndUrisPattern = r'(?<!<a?:[^>]*|(?:http|ws)s?:\/\/\S+)';

const _excludeEmojisPatternEnd = r'(?!:\d+>)';

/// A pattern that matches bold tags.
final boldPattern = RegExp(r'\*\*(\*)?', multiLine: true);

/// A pattern that matches bulleted lists.
final bulletedListPattern = RegExp(r'^( *)([*-])( +)', multiLine: true);

/// A pattern that matches code blocks.
final codeBlockPattern = '```';

/// A pattern that matches escape patterns.
final escapePattern = r'\';

/// A pattern that matches footer notes.
final footerPattern = RegExp(r'^(-#)(?=[^#]|$)', multiLine: true);

/// A pattern that matches multiple levels of markdown headings (up to 3).
final headingPattern = RegExp(r'(?<=^|(?<!\S))( {0,2})([*-] )?( *)(#{1,3} )(?!#)', multiLine: true);

/// A pattern that matches inline code.
final inlineCodePattern = RegExp(r'(?<=^|[^\\\\`])``?(?=[^`]|$)', multiLine: true);

/// A pattern that matches italics tags.
// TODO: Make a better pattern, lines that start with `* italic *` are discarded because of bullet lists because of the negative lookahead (?!^\\*\\s+)
final italicPattern =
    RegExp('(?<!\\\\|`)(?!^\\*\\s+)(?<=^|[^*_])$_baseExcludeEmojisAndUrisPattern([*_])$_excludeEmojisPatternEnd([^*_]|(?:__|\\*\\*)|\$)', multiLine: true);

/// A pattern that matches masked links.
final maskedLinkPattern = RegExp(r'\[.+]\(.+\)', multiLine: true);

/// A pattern that matches numbered lists.
final numberedListPattern = RegExp(r'^( *\d+)\.', multiLine: true);

/// A pattern that matches spoiler tags.
final spoilerPattern = '||';

/// A pattern that matches strikethrough.
final strikeThroughPattern = '~~';

/// A pattern that matches underline tags.
final underlinePattern = RegExp('${_baseExcludeEmojisAndUrisPattern}__(_)?$_excludeEmojisPatternEnd', multiLine: true);

/// Escapes bold markdown (`**`) in a string.
String escapeBold(String text) {
  int index = 0;

  return text.replaceAllMapped(boldPattern, (match) {
    String? found = match[1];

    if (found != null) {
      return (++index % 2 == 0 ? '$found\\*\\*' : '\\*\\*$found');
    }

    return r'\*\*';
  });
}

/// Escapes a bulleted list (`*` or `-`) in a string.
String escapeBulletedList(String text) => text.replaceAllMapped(bulletedListPattern, (match) => '${match[1]}\\${match[2]}${match[3]}');

/// Escapes code blocks (`` ``` ``) in a string.
String escapeCodeBlock(String text) => text.replaceAll(codeBlockPattern, r'\`\`\`');

/// Escapes escape characters (`\`) in a string.
String escapeEscape(String text) => text.replaceAll(escapePattern, r'\\');

/// Escapes footer (`-#`) in a string.
String escapeFooter(String text) => text.replaceAllMapped(footerPattern, (match) => '\\${match[0]}');

/// Escapes markdown heading characters (`#{1,3}`) in a string.
String escapeHeading(String text) => text.replaceAllMapped(headingPattern, (m) => '${m.groups([1, 2, 3]).nonNulls.join()}\\${m[4]}');

/// Escapes inline code (`` `Hello World` ``) in a string.
String escapeInlineCode(String text) => text.replaceAllMapped(inlineCodePattern, (match) => match[0]?.length == 2 ? r'\`\`' : r'\`');

/// Escapes italic markdown (`*` or `_`) in a string.
String escapeItalic(String text) {
  int index = 0;

  return text.replaceAllMapped(italicPattern, (match) {
    String? del = match[1];
    String? found = match[2];

    if (found != null && (found == '__' || found == '**')) {
      return (++index % 2 == 0 ? '$found\\$del' : '\\$del$found');
    }

    return '\\$del$found';
  });
}

/// Escapes Discord-flavoured markdown in a string.
/// By default, everything will be escaped, excluding bulleted and numbered lists.
String escapeMarkdown(
  String text, {
  Set<Escaper> escapers = const {
    Escaper.escapes,
    Escaper.bolds,
    Escaper.codeBlocks,
    Escaper.footers,
    Escaper.headings,
    Escaper.inlineCodes,
    Escaper.italics,
    Escaper.maskedLinks,
    Escaper.spoilers,
    Escaper.strikethroughs,
    Escaper.underlines
  },
}) {
  // Escape.escapes is first here, so we dont end up escaping our own escapes, which is not what we want..
  if (escapers.contains(Escaper.escapes) && escapers.first != Escaper.escapes) {
    escapers = {Escaper.escapes, ...escapers};
  }

  for (final escaper in escapers) {
    (switch (escaper) {
      Escaper.escapes => text = escapeEscape(text),
      Escaper.codeBlocks => text = escapeCodeBlock(text),
      Escaper.inlineCodes => text = escapeInlineCode(text),
      Escaper.bolds => text = escapeBold(text),
      Escaper.bulletedList => text = escapeBulletedList(text),
      Escaper.footers => text = escapeFooter(text),
      Escaper.headings => text = escapeHeading(text),
      Escaper.italics => text = escapeItalic(text),
      Escaper.maskedLinks => text = escapeMaskedLink(text),
      Escaper.numberedList => text = escapeNumberedList(text),
      Escaper.spoilers => text = escapeSpoiler(text),
      Escaper.strikethroughs => text = escapeStrikeThrough(text),
      Escaper.underlines => text = escapeUnderline(text),
    });
  }

  return text;
}

/// Escapes a masked link (`[foo](https://bar)`) in a string.
String escapeMaskedLink(String text) => text.replaceAllMapped(maskedLinkPattern, (match) => '\\${match[0]}');

/// Escapes a numbered list (`n.`) in a string.
String escapeNumberedList(String text) => text.replaceAllMapped(numberedListPattern, (match) => '${match[1]}\\.');

/// Escapes spoiler tags (`||`) in a string.
String escapeSpoiler(String text) => text.replaceAll(spoilerPattern, r'\|\|');

/// Escapes strikethrough patterns (`~~`) in a string.
String escapeStrikeThrough(String text) => text.replaceAll(strikeThroughPattern, r'\~\~');

/// Escapes underline markdown (`__`) in a string.
String escapeUnderline(String text) {
  int index = 0;

  return text.replaceAllMapped(underlinePattern, (match) {
    String? found = match[1];

    if (found != null) {
      // We re-add the additional underscore to the string without escaping it.
      return (++index % 2 == 0 ? '$found\\_\\_' : '\\_\\_$found');
    }

    return r'\_\_';
  });
}

/// An enum to modify the behaviour of [escapeMarkdown] depending on which parameter is enabled.
enum Escaper {
  /// Whether to escape masked links.
  maskedLinks,

  /// Whether to escape numbered lists.
  numberedList,

  /// Whether to escape bulleted lists.
  bulletedList,

  /// Whether to escape headings.
  headings,

  /// Wether to escape escape characters.
  escapes,

  /// Whether to escape spoiler tags.
  spoilers,

  /// Whether to escape strike through tags.
  strikethroughs,

  /// Whether to escape underline tags.
  underlines,

  /// Whether to escape bold tags.
  bolds,

  /// Whether to escape italic tags.
  italics,

  /// Whether to escape inline code tags.
  inlineCodes,

  /// Whether to escape code blocks.
  codeBlocks,

  /// Whether to escape footers.
  footers,
}
