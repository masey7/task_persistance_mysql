// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of parser;

class Tokenizer extends TokenizerBase {
  /** U+ prefix for unicode characters. */
  final UNICODE_U = 'U'.codeUnitAt(0);
  final UNICODE_LOWER_U = 'u'.codeUnitAt(0);
  final UNICODE_PLUS = '+'.codeUnitAt(0);

  final QUESTION_MARK = '?'.codeUnitAt(0);

  /** CDATA keyword. */
  final List CDATA_NAME = 'CDATA'.codeUnits;

  Tokenizer(File file, String text, bool skipWhitespace,
      [int index = 0])
      : super(file, text, skipWhitespace, index);

  Token next({unicodeRange: false}) {
    // keep track of our starting position
    _startIndex = _index;

    int ch;
    ch = _nextChar();
    switch (ch) {
      case TokenChar.NEWLINE:
      case TokenChar.RETURN:
      case TokenChar.SPACE:
      case TokenChar.TAB:
        return finishWhitespace();
      case TokenChar.END_OF_FILE:
        return _finishToken(TokenKind.END_OF_FILE);
      case TokenChar.AT:
        int peekCh = _peekChar();
        if (TokenizerHelpers.isIdentifierStart(peekCh)) {
          _startIndex = _index;
          ch = _nextChar();
          Token ident = this.finishIdentifier(ch);

          // Is it a directive?
          int tokId = TokenKind.matchDirectives(_text, _startIndex,
              _index - _startIndex);
          if (tokId == -1) {
            // No, is it a margin directive?
            tokId = TokenKind.matchMarginDirectives(_text, _startIndex,
                _index - _startIndex);
          }

          if (tokId != -1) {
            return _finishToken(tokId);
          }
        }
        return _finishToken(TokenKind.AT);
      case TokenChar.DOT:
        int start = _startIndex;             // Start where the dot started.
        if (maybeEatDigit()) {
          // looks like a number dot followed by digit(s).
          Token number = finishNumber();
          if (number.kind == TokenKind.INTEGER) {
            // It's a number but it's preceeded by a dot, so make it a double.
            _startIndex = start;
            return _finishToken(TokenKind.DOUBLE);
          } else {
            // Don't allow dot followed by a double (e.g,  '..1').
            return _errorToken();
          }
        } else {
          // It's really a dot.
          return _finishToken(TokenKind.DOT);
        }
        break;
      case TokenChar.LPAREN:
        return _finishToken(TokenKind.LPAREN);
      case TokenChar.RPAREN:
        return _finishToken(TokenKind.RPAREN);
      case TokenChar.LBRACE:
        return _finishToken(TokenKind.LBRACE);
      case TokenChar.RBRACE:
        return _finishToken(TokenKind.RBRACE);
      case TokenChar.LBRACK:
        return _finishToken(TokenKind.LBRACK);
      case TokenChar.RBRACK:
        if (_maybeEatChar(TokenChar.RBRACK) &&
            _maybeEatChar(TokenChar.GREATER)) {
          // ]]>
          return next();
        } else {
          return _finishToken(TokenKind.RBRACK);
        }
        break;
      case TokenChar.HASH:
        return _finishToken(TokenKind.HASH);
      case TokenChar.PLUS:
        if (maybeEatDigit()) {
          return finishNumber();
        } else {
          return _finishToken(TokenKind.PLUS);
        }
        break;
      case TokenChar.MINUS:
        if (selectorExpression || unicodeRange) {
          // If parsing in pseudo function expression then minus is an operator
          // not part of identifier e.g., interval value range (e.g. U+400-4ff)
          // or minus operator in selector expression.
          return _finishToken(TokenKind.MINUS);
        } else if (maybeEatDigit()) {
          return finishNumber();
        } else if (TokenizerHelpers.isIdentifierStart(ch)) {
          return this.finishIdentifier(ch);
        } else {
          return _finishToken(TokenKind.MINUS);
        }
        break;
      case TokenChar.GREATER:
        return _finishToken(TokenKind.GREATER);
      case TokenChar.TILDE:
        if (_maybeEatChar(TokenChar.EQUALS)) {
          return _finishToken(TokenKind.INCLUDES);          // ~=
        } else {
          return _finishToken(TokenKind.TILDE);
        }
        break;
      case TokenChar.ASTERISK:
        if (_maybeEatChar(TokenChar.EQUALS)) {
          return _finishToken(TokenKind.SUBSTRING_MATCH);   // *=
        } else {
          return _finishToken(TokenKind.ASTERISK);
        }
        break;
      case TokenChar.NAMESPACE:
        return _finishToken(TokenKind.NAMESPACE);
      case TokenChar.COLON:
        return _finishToken(TokenKind.COLON);
      case TokenChar.COMMA:
        return _finishToken(TokenKind.COMMA);
      case TokenChar.SEMICOLON:
        return _finishToken(TokenKind.SEMICOLON);
      case TokenChar.PERCENT:
        return _finishToken(TokenKind.PERCENT);
      case TokenChar.SINGLE_QUOTE:
        return _finishToken(TokenKind.SINGLE_QUOTE);
      case TokenChar.DOUBLE_QUOTE:
        return _finishToken(TokenKind.DOUBLE_QUOTE);
      case TokenChar.SLASH:
        if (_maybeEatChar(TokenChar.ASTERISK)) {
          return finishMultiLineComment();
        } else {
          return _finishToken(TokenKind.SLASH);
        }
        break;
      case  TokenChar.LESS:      // <!--
        if (_maybeEatChar(TokenChar.BANG)) {
          if (_maybeEatChar(TokenChar.MINUS) &&
              _maybeEatChar(TokenChar.MINUS)) {
            return finishMultiLineComment();
          } else if (_maybeEatChar(TokenChar.LBRACK) &&
              _maybeEatChar(CDATA_NAME[0]) &&
              _maybeEatChar(CDATA_NAME[1]) &&
              _maybeEatChar(CDATA_NAME[2]) &&
              _maybeEatChar(CDATA_NAME[3]) &&
              _maybeEatChar(CDATA_NAME[4]) &&
              _maybeEatChar(TokenChar.LBRACK)) {
            // <![CDATA[
            return next();
          }
        } else {
          return _finishToken(TokenKind.LESS);
        }
        break;
      case TokenChar.EQUALS:
        return _finishToken(TokenKind.EQUALS);
      case TokenChar.OR:
        if (_maybeEatChar(TokenChar.EQUALS)) {
          return _finishToken(TokenKind.DASH_MATCH);      // |=
        } else {
          return _finishToken(TokenKind.OR);
        }
        break;
      case TokenChar.CARET:
        if (_maybeEatChar(TokenChar.EQUALS)) {
          return _finishToken(TokenKind.PREFIX_MATCH);    // ^=
        } else {
          return _finishToken(TokenKind.CARET);
        }
        break;
      case TokenChar.DOLLAR:
        if (_maybeEatChar(TokenChar.EQUALS)) {
          return _finishToken(TokenKind.SUFFIX_MATCH);    // $=
        } else {
          return _finishToken(TokenKind.DOLLAR);
        }
        break;
      case TokenChar.BANG:
        Token tok = finishIdentifier(ch);
        return (tok == null) ? _finishToken(TokenKind.BANG) : tok;
      default:
        if (unicodeRange) {
          // Three types of unicode ranges:
          //   - single code point (e.g. U+416)
          //   - interval value range (e.g. U+400-4ff)
          //   - range where trailing ‘?’ characters imply ‘any digit value’
          //   (e.g. U+4??)
          if (maybeEatHexDigit()) {
            var t = finishHexNumber();
            // Any question marks then it's a HEX_RANGE not HEX_NUMBER.
            if (maybeEatQuestionMark()) finishUnicodeRange();
            return t;
          } else if (maybeEatQuestionMark()) {
            // HEX_RANGE U+N???
            return finishUnicodeRange();
          } else {
            return _errorToken();
          }
        } else if ((ch == UNICODE_U || ch == UNICODE_LOWER_U) &&
            (_peekChar() == UNICODE_PLUS)) {
          // Unicode range: U+uNumber[-U+uNumber]
          //   uNumber = 0..10FFFF
          _nextChar();                                // Skip +
          _startIndex = _index;                       // Starts at the number
          return _finishToken(TokenKind.UNICODE_RANGE);
        } else if (TokenizerHelpers.isIdentifierStart(ch)) {
          return finishIdentifier(ch);
        } else if (TokenizerHelpers.isDigit(ch)) {
          return finishNumber();
        } else {
          return _errorToken();
        }
        break;
    }
  }

  Token _errorToken([String message = null]) {
    return _finishToken(TokenKind.ERROR);
  }

  int getIdentifierKind() {
    // Is the identifier a unit type?
    int tokId = TokenKind.matchUnits(_text, _startIndex, _index - _startIndex);
    if (tokId == -1) {
      tokId = (_text.substring(_startIndex, _index) == '!important') ?
          TokenKind.IMPORTANT : -1;
    }

    return tokId >= 0 ? tokId : TokenKind.IDENTIFIER;
  }

  // Need to override so CSS version of isIdentifierPart is used.
  Token finishIdentifier(int ch) {
    while (_index < _text.length) {
      // If parsing in pseudo function expression then minus is an operator
      // not part of identifier.
      var isIdentifier = selectorExpression
          ? TokenizerHelpers.isIdentifierPartExpr(_text.codeUnitAt(_index))
          : TokenizerHelpers.isIdentifierPart(_text.codeUnitAt(_index));
      if (!isIdentifier) {
          break;
      } else {
        _index += 1;
      }
    }

    int kind = getIdentifierKind();
    if (kind == TokenKind.IDENTIFIER) {
      return _finishToken(TokenKind.IDENTIFIER);
    } else {
      return _finishToken(kind);
    }
  }

  Token finishImportant() {

  }

  Token finishNumber() {
    eatDigits();

    if (_peekChar() == 46/*.*/) {
      // Handle the case of 1.toString().
      _nextChar();
      if (TokenizerHelpers.isDigit(_peekChar())) {
        eatDigits();
        return _finishToken(TokenKind.DOUBLE);
      } else {
        _index -= 1;
      }
    }

    return _finishToken(TokenKind.INTEGER);
  }

  bool maybeEatDigit() {
    if (_index < _text.length
        && TokenizerHelpers.isDigit(_text.codeUnitAt(_index))) {
      _index += 1;
      return true;
    }
    return false;
  }

  Token finishHexNumber() {
    eatHexDigits();
    return _finishToken(TokenKind.HEX_INTEGER);
  }

  void eatHexDigits() {
    while (_index < _text.length) {
     if (TokenizerHelpers.isHexDigit(_text.codeUnitAt(_index))) {
       _index += 1;
     } else {
       return;
     }
    }
  }

  bool maybeEatHexDigit() {
    if (_index < _text.length
        && TokenizerHelpers.isHexDigit(_text.codeUnitAt(_index))) {
      _index += 1;
      return true;
    }
    return false;
  }

  bool maybeEatQuestionMark() {
    if (_index < _text.length &&
        _text.codeUnitAt(_index) == QUESTION_MARK) {
      _index += 1;
      return true;
    }
    return false;
  }

  void eatQuestionMarks() {
    while (_index < _text.length) {
     if (_text.codeUnitAt(_index) == QUESTION_MARK) {
       _index += 1;
     } else {
       return;
     }
    }
  }

  Token finishUnicodeRange() {
    eatQuestionMarks();
    return _finishToken(TokenKind.HEX_RANGE);
  }

  Token finishMultiLineComment() {
    while (true) {
      int ch = _nextChar();
      if (ch == 0) {
        return _finishToken(TokenKind.INCOMPLETE_COMMENT);
      } else if (ch == 42/*'*'*/) {
        if (_maybeEatChar(47/*'/'*/)) {
          if (_skipWhitespace) {
            return next();
          } else {
            return _finishToken(TokenKind.COMMENT);
          }
        }
      } else if (ch == TokenChar.MINUS) {
        /* Check if close part of Comment Definition --> (CDC). */
        if (_maybeEatChar(TokenChar.MINUS)) {
          if (_maybeEatChar(TokenChar.GREATER)) {
            if (_skipWhitespace) {
              return next();
            } else {
              return _finishToken(TokenKind.HTML_COMMENT);
            }
          }
        }
      }
    }
    return _errorToken();
  }

}

/** Static helper methods. */
class TokenizerHelpers {
  static bool isIdentifierStart(int c) {
    return isIdentifierStartExpr(c) || c == 45 /*-*/;
  }

  static bool isDigit(int c) {
    return (c >= 48/*0*/ && c <= 57/*9*/);
  }

  static bool isHexDigit(int c) {
    return (isDigit(c) || (c >= 97/*a*/ && c <= 102/*f*/)
        || (c >= 65/*A*/ && c <= 70/*F*/));
  }

  static bool isIdentifierPart(int c) {
    return isIdentifierPartExpr(c) || c == 45 /*-*/;
  }

  /** Pseudo function expressions identifiers can't have a minus sign. */
  static bool isIdentifierStartExpr(int c) {
    return ((c >= 97/*a*/ && c <= 122/*z*/) || (c >= 65/*A*/ && c <= 90/*Z*/) ||
        c == 95/*_*/);
  }

  /** Pseudo function expressions identifiers can't have a minus sign. */
  static bool isIdentifierPartExpr(int c) {
    return (isIdentifierStartExpr(c) || isDigit(c));
  }
}
