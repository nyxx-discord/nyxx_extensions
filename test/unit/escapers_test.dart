import 'package:nyxx_extensions/src/utils/escapers.dart';
import 'package:test/test.dart';

void main() {
  group('Escape content', () {
    test('Bulleted List', () {
      const bulletedListContent = '''
- aa
- bb

* cc
* dd

- mixed
* list
''';

      const bulletedListExpectedContent = r'''
\- aa
\- bb

\* cc
\* dd

\- mixed
\* list
''';

      expect(escapeBulletedList(bulletedListContent), equals(bulletedListExpectedContent));
    });

    test('Code Block', () {
      const codeBlockContent = '''
```dart
import 'package:nyxx/nyxx.dart';

void main() => print('Hello');
```
''';

      const codeBlockExpectedContent = r'''
\`\`\`dart
import 'package:nyxx/nyxx.dart';

void main() => print('Hello');
\`\`\`
''';

      expect(escapeCodeBlock(codeBlockContent), equals(codeBlockExpectedContent));
    });

    test('Escape', () {
      const escapeContent = r'\';

      const escapeExpectedContent = r'\\';

      expect(escapeEscape(escapeContent), equals(escapeExpectedContent));
    });

    test('Footer', () {
      const footerContent = '-# hello, this is a footer, try to nest me -# get rekt bozo';
      const expectedFooterContent = r'\-# hello, this is a footer, try to nest me -# get rekt bozo';

      expect(escapeFooter(footerContent), equals(expectedFooterContent));
    });

    test('Heading', () {
      const headingContent = '# H1\n## H2\n### H3\n#### Discord only supports 3 heading layers';

      const headingExpectedContent = '\\# H1\n\\## H2\n\\### H3\n#### Discord only supports 3 heading layers';

      expect(escapeHeading(headingContent), equals(headingExpectedContent));
    });

    test('Inline Code', () {
      const inlineCodeContent = 'Hello `World`, this inline code is `` ` nested ` ``';

      const inlineCodeExpectedContent = r'Hello \`World\`, this inline code is \`\` \` nested \` \`\`';

      expect(escapeInlineCode(inlineCodeContent), equals(inlineCodeExpectedContent));
    });

    test('Escape Italic', () {
      const italicContent =
          'This is a *test* with _emojis_ <:Frost_ed_Wreath:1053399941210443826> and ***bold and italic text*** and with ___underlined and italic text___. Also look at this beautiful url!! https://lexedia.moe/are_you_for_real?';
      const italicExpectedContent =
          r'This is a \*test\* with \_emojis\_ <:Frost_ed_Wreath:1053399941210443826> and \***bold and italic text**\* and with \___underlined and italic text__\_. Also look at this beautiful url!! https://lexedia.moe/are_you_for_real?';

      expect(escapeItalic(italicContent), equals(italicExpectedContent));
    });

    test('Masked Link', () {
      const maskedLinkContent = "If you're homeless, just.. buy a [house](https://sigma.org)?";

      const maskedLinkExpectedContent = r"If you're homeless, just.. buy a \[house](https://sigma.org)?";

      expect(escapeMaskedLink(maskedLinkContent), equals(maskedLinkExpectedContent));
    });

    test('Numbered List', () {
      const numberedListContent = '''
1. Are
2. You
3. gay?
''';

      const numberedListExpectedContent = r'''
1\. Are
2\. You
3\. gay?
''';

      expect(escapeNumberedList(numberedListContent), equals(numberedListExpectedContent));
    });

    test('Spoiler', () {
      const spoilerContent = 'Ayo, imagine ||spoiling|| someone';
      const spoilerExpectedContent = r'Ayo, imagine \|\|spoiling\|\| someone';

      expect(escapeSpoiler(spoilerContent), equals(spoilerExpectedContent));
    });

    test('Strikethrough', () {
      const strikeThroughContent = 'Man im getting ~~tired~~';
      const strikeThroughExpectedContent = r'Man im getting \~\~tired\~\~';

      expect(escapeStrikeThrough(strikeThroughContent), equals(strikeThroughExpectedContent));
    });

    test('Underline', () {
      const underlineContent = 'Please __get me out__ of here.';
      const underlineExpectedContent = r'Please \_\_get me out\_\_ of here.';

      expect(escapeUnderline(underlineContent), equals(underlineExpectedContent));
    });
  });

  group('Escape all Markdown', () {
    const content = '''
# Hey!
This is a __huge__ chunk of `string`s to test if the ``escapeMarkdown`` can properly **escape things**.

## Escape
Yes, while we're talking, did you know you can use italics with `*` or `_`? Look: *with star*, _with underscore_

### Codeblock
Yeah so, here's a code block
```dart
import 'package:nyxx/nyxx.dart';

void main(List<String> args) async {
  const dontMindMe = "I'm just `chiling`";
}
```
Also [masked links](<https://lexedia.moe/why_everyone_put_underscores_in_their_urls> "Skibidi toilet") are here

1. Numbered list
2. For real
3. hehe

- bullet list
* You should listen to Empire Fall btw
- exactly what she said ^

-# footer because yah
''';

    test('Escape Markdown (base)', () {
      const expectedContent = r'''
\# Hey!
This is a \_\_huge\_\_ chunk of \`string\`s to test if the \`\`escapeMarkdown\`\` can properly \*\*escape things\*\*.

\## Escape
Yes, while we're talking, did you know you can use italics with \`*\` or \`_\`? Look: \*with star\*, \_with underscore\_

\### Codeblock
Yeah so, here's a code block
\`\`\`dart
import 'package:nyxx/nyxx.dart';

void main(List<String> args) async {
  const dontMindMe = "I'm just \`chiling\`";
}
\`\`\`
Also \[masked links](<https://lexedia.moe/why_everyone_put_underscores_in_their_urls> "Skibidi toilet") are here

1. Numbered list
2. For real
3. hehe

- bullet list
* You should listen to Empire Fall btw
- exactly what she said ^

\-# footer because yah
''';

      expect(escapeMarkdown(content), equals(expectedContent));
    });
  });
}
