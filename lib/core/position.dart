import "package:angular2/angular2.dart";
import "package:node_shims/js.dart";
import 'dart:html';

Document get _document => window.document;

/// Checks if [nativeEl] is statically positioned
bool _isStaticPositioned(Element nativeEl) =>
    or(nativeEl.style.position, "static") == "static";

/// returns the closest, non-statically positioned parentOffset of a given element
/// @param nativeEl
_parentOffsetEl(Element nativeEl) {
  var offsetParent = nativeEl.offsetParent ?? _document;
  while (offsetParent != null
      && offsetParent != _document
      && _isStaticPositioned(offsetParent)) {
    offsetParent = offsetParent.offsetParent;
  }
  return offsetParent ?? _document;
}

/// Provides read-only equivalent of jQuery's position function:
/// http://api.jquery.com/position/
Rectangle _position(Element nativeEl) {
  var elBCR = nativeEl.offset;
  var offsetParentBCR = new Position(top: 0, left: 0);
  var offsetParentEl = _parentOffsetEl(nativeEl);
  if (offsetParentEl != _document) {
    offsetParentBCR = offsetParentEl.offset;
    offsetParentBCR.top += offsetParentEl.clientTop - offsetParentEl.scrollTop;
    offsetParentBCR.left += offsetParentEl.clientLeft - offsetParentEl.scrollLeft;
  }
  var boundingClientRect = nativeEl.getBoundingClientRect();
  return new Rectangle(
      elBCR.left - offsetParentBCR.left,
      elBCR.top - offsetParentBCR.top,
      boundingClientRect.width ?? nativeEl.offsetWidth,
      boundingClientRect.height ?? nativeEl.offsetHeight);
}

/// Provides coordinates for the targetEl in relation to hostEl
Position positionElements(Element hostEl,
    Element targetEl,
    String positionStr,
    bool appendToBody) {
  var positionStrParts = positionStr.split("-");
  var pos0 = positionStrParts[0];
  var pos1 = positionStrParts.length > 1 ? positionStrParts[1] : "center";
  var hostElPos = appendToBody ? hostEl.offset : _position(hostEl);
  var targetElWidth = targetEl.offsetWidth;
  var targetElHeight = targetEl.offsetHeight;
  var shiftWidth = {
    "center" : () => hostElPos.left + hostElPos.width / 2 - targetElWidth / 2,
    "left" : () => hostElPos.left,
    "right" : () => hostElPos.left + hostElPos.width
  };
  var shiftHeight = {
    "center" : () => hostElPos.top + hostElPos.height / 2 - targetElHeight / 2,
    "top" : () => hostElPos.top,
    "bottom" : () => hostElPos.top + hostElPos.height
  };
  Position targetElPos;
  switch (pos0) {
    case "right" :
      targetElPos = new Position(
          top: shiftHeight[pos1](),
          left: shiftWidth[pos0]());
      break;
    case "left" :
      targetElPos = new Position(
          top: shiftHeight[pos1](),
          left: hostElPos.left - targetElWidth);
      break;
    case "bottom" :
      targetElPos = new Position(
          top: shiftHeight[pos0](),
          left: shiftWidth[pos1]());
      break;
    default :
      targetElPos = new Position(
          top: hostElPos.top - targetElHeight,
          left: shiftWidth[pos1]());
  }
  return targetElPos;
}

/// Used to handle the position of the element
class Position {
  num top;
  num left;

  String get topPx => top.toString() + 'px';

  String get leftPx => left.toString() + 'px';

  Position({this.top, this.left});

  toString() => "$topPx, $leftPx";
}