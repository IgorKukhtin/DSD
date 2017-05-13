{********************************************************************}
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 2014 - 2015                                 }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The complete source code remains property of the author and may    }
{ not be distributed, published, given or sold in any form as such.  }
{ No parts of the source code can be included in any other component }
{ or application without written authorization of the author.        }
{********************************************************************}

unit FMX.TMSWebGMapsWebBrowser.Win;

interface

{$I TMSDEFS.INC}

{$IFNDEF CHROMIUMOFF}
{$DEFINE USECHROMIUM}
{$ELSE}
{$IF DEFINED(MSWINDOWS) AND DEFINED(DELPHIXE8_LVL)}
{$DEFINE USEFMXWEBBROWSER}
{$ENDIF}
{$ENDIF}

procedure RegisterWebBrowserService;
procedure UnRegisterWebBrowserService;

implementation

uses
  {$IFDEF USEFMXWEBBROWSER}
  Windows, FMX.Forms, FMX.Platform.Win, Variants, SysUtils, ShellApi,
  {$ENDIF}
  Classes, FMX.Types, FMX.Platform, FMX.TMSWebGMapsWebBrowser
  {$IFDEF USECHROMIUM}
  ,ceflib, ceffmx
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  ,FMX.WebBrowser, System.Win.InternetExplorer, System.Win.ComObj, System.Win.IEInterfaces, ActiveX
  {$ENDIF}
  ;

type
  {$IFDEF USEFMXWEBBROWSER}
  IHTMLStyle = interface(IDispatch)
    ['{3050F25E-98B5-11CF-BB82-00AA00BDCE0B}']
    procedure Set_fontFamily(const p: WideString); safecall;
    function Get_fontFamily: WideString; safecall;
    procedure Set_fontStyle(const p: WideString); safecall;
    function Get_fontStyle: WideString; safecall;
    procedure Set_fontVariant(const p: WideString); safecall;
    function Get_fontVariant: WideString; safecall;
    procedure Set_fontWeight(const p: WideString); safecall;
    function Get_fontWeight: WideString; safecall;
    procedure Set_fontSize(p: OleVariant); safecall;
    function Get_fontSize: OleVariant; safecall;
    procedure Set_font(const p: WideString); safecall;
    function Get_font: WideString; safecall;
    procedure Set_color(p: OleVariant); safecall;
    function Get_color: OleVariant; safecall;
    procedure Set_background(const p: WideString); safecall;
    function Get_background: WideString; safecall;
    procedure Set_backgroundColor(p: OleVariant); safecall;
    function Get_backgroundColor: OleVariant; safecall;
    procedure Set_backgroundImage(const p: WideString); safecall;
    function Get_backgroundImage: WideString; safecall;
    procedure Set_backgroundRepeat(const p: WideString); safecall;
    function Get_backgroundRepeat: WideString; safecall;
    procedure Set_backgroundAttachment(const p: WideString); safecall;
    function Get_backgroundAttachment: WideString; safecall;
    procedure Set_backgroundPosition(const p: WideString); safecall;
    function Get_backgroundPosition: WideString; safecall;
    procedure Set_backgroundPositionX(p: OleVariant); safecall;
    function Get_backgroundPositionX: OleVariant; safecall;
    procedure Set_backgroundPositionY(p: OleVariant); safecall;
    function Get_backgroundPositionY: OleVariant; safecall;
    procedure Set_wordSpacing(p: OleVariant); safecall;
    function Get_wordSpacing: OleVariant; safecall;
    procedure Set_letterSpacing(p: OleVariant); safecall;
    function Get_letterSpacing: OleVariant; safecall;
    procedure Set_textDecoration(const p: WideString); safecall;
    function Get_textDecoration: WideString; safecall;
    procedure Set_textDecorationNone(p: WordBool); safecall;
    function Get_textDecorationNone: WordBool; safecall;
    procedure Set_textDecorationUnderline(p: WordBool); safecall;
    function Get_textDecorationUnderline: WordBool; safecall;
    procedure Set_textDecorationOverline(p: WordBool); safecall;
    function Get_textDecorationOverline: WordBool; safecall;
    procedure Set_textDecorationLineThrough(p: WordBool); safecall;
    function Get_textDecorationLineThrough: WordBool; safecall;
    procedure Set_textDecorationBlink(p: WordBool); safecall;
    function Get_textDecorationBlink: WordBool; safecall;
    procedure Set_verticalAlign(p: OleVariant); safecall;
    function Get_verticalAlign: OleVariant; safecall;
    procedure Set_textTransform(const p: WideString); safecall;
    function Get_textTransform: WideString; safecall;
    procedure Set_textAlign(const p: WideString); safecall;
    function Get_textAlign: WideString; safecall;
    procedure Set_textIndent(p: OleVariant); safecall;
    function Get_textIndent: OleVariant; safecall;
    procedure Set_lineHeight(p: OleVariant); safecall;
    function Get_lineHeight: OleVariant; safecall;
    procedure Set_marginTop(p: OleVariant); safecall;
    function Get_marginTop: OleVariant; safecall;
    procedure Set_marginRight(p: OleVariant); safecall;
    function Get_marginRight: OleVariant; safecall;
    procedure Set_marginBottom(p: OleVariant); safecall;
    function Get_marginBottom: OleVariant; safecall;
    procedure Set_marginLeft(p: OleVariant); safecall;
    function Get_marginLeft: OleVariant; safecall;
    procedure Set_margin(const p: WideString); safecall;
    function Get_margin: WideString; safecall;
    procedure Set_paddingTop(p: OleVariant); safecall;
    function Get_paddingTop: OleVariant; safecall;
    procedure Set_paddingRight(p: OleVariant); safecall;
    function Get_paddingRight: OleVariant; safecall;
    procedure Set_paddingBottom(p: OleVariant); safecall;
    function Get_paddingBottom: OleVariant; safecall;
    procedure Set_paddingLeft(p: OleVariant); safecall;
    function Get_paddingLeft: OleVariant; safecall;
    procedure Set_padding(const p: WideString); safecall;
    function Get_padding: WideString; safecall;
    procedure Set_border(const p: WideString); safecall;
    function Get_border: WideString; safecall;
    procedure Set_borderTop(const p: WideString); safecall;
    function Get_borderTop: WideString; safecall;
    procedure Set_borderRight(const p: WideString); safecall;
    function Get_borderRight: WideString; safecall;
    procedure Set_borderBottom(const p: WideString); safecall;
    function Get_borderBottom: WideString; safecall;
    procedure Set_borderLeft(const p: WideString); safecall;
    function Get_borderLeft: WideString; safecall;
    procedure Set_borderColor(const p: WideString); safecall;
    function Get_borderColor: WideString; safecall;
    procedure Set_borderTopColor(p: OleVariant); safecall;
    function Get_borderTopColor: OleVariant; safecall;
    procedure Set_borderRightColor(p: OleVariant); safecall;
    function Get_borderRightColor: OleVariant; safecall;
    procedure Set_borderBottomColor(p: OleVariant); safecall;
    function Get_borderBottomColor: OleVariant; safecall;
    procedure Set_borderLeftColor(p: OleVariant); safecall;
    function Get_borderLeftColor: OleVariant; safecall;
    procedure Set_borderWidth(const p: WideString); safecall;
    function Get_borderWidth: WideString; safecall;
    procedure Set_borderTopWidth(p: OleVariant); safecall;
    function Get_borderTopWidth: OleVariant; safecall;
    procedure Set_borderRightWidth(p: OleVariant); safecall;
    function Get_borderRightWidth: OleVariant; safecall;
    procedure Set_borderBottomWidth(p: OleVariant); safecall;
    function Get_borderBottomWidth: OleVariant; safecall;
    procedure Set_borderLeftWidth(p: OleVariant); safecall;
    function Get_borderLeftWidth: OleVariant; safecall;
    procedure Set_borderStyle(const p: WideString); safecall;
    function Get_borderStyle: WideString; safecall;
    procedure Set_borderTopStyle(const p: WideString); safecall;
    function Get_borderTopStyle: WideString; safecall;
    procedure Set_borderRightStyle(const p: WideString); safecall;
    function Get_borderRightStyle: WideString; safecall;
    procedure Set_borderBottomStyle(const p: WideString); safecall;
    function Get_borderBottomStyle: WideString; safecall;
    procedure Set_borderLeftStyle(const p: WideString); safecall;
    function Get_borderLeftStyle: WideString; safecall;
    procedure Set_width(p: OleVariant); safecall;
    function Get_width: OleVariant; safecall;
    procedure Set_height(p: OleVariant); safecall;
    function Get_height: OleVariant; safecall;
    procedure Set_styleFloat(const p: WideString); safecall;
    function Get_styleFloat: WideString; safecall;
    procedure Set_clear(const p: WideString); safecall;
    function Get_clear: WideString; safecall;
    procedure Set_display(const p: WideString); safecall;
    function Get_display: WideString; safecall;
    procedure Set_visibility(const p: WideString); safecall;
    function Get_visibility: WideString; safecall;
    procedure Set_listStyleType(const p: WideString); safecall;
    function Get_listStyleType: WideString; safecall;
    procedure Set_listStylePosition(const p: WideString); safecall;
    function Get_listStylePosition: WideString; safecall;
    procedure Set_listStyleImage(const p: WideString); safecall;
    function Get_listStyleImage: WideString; safecall;
    procedure Set_listStyle(const p: WideString); safecall;
    function Get_listStyle: WideString; safecall;
    procedure Set_whiteSpace(const p: WideString); safecall;
    function Get_whiteSpace: WideString; safecall;
    procedure Set_top(p: OleVariant); safecall;
    function Get_top: OleVariant; safecall;
    procedure Set_left(p: OleVariant); safecall;
    function Get_left: OleVariant; safecall;
    function Get_position: WideString; safecall;
    procedure Set_zIndex(p: OleVariant); safecall;
    function Get_zIndex: OleVariant; safecall;
    procedure Set_overflow(const p: WideString); safecall;
    function Get_overflow: WideString; safecall;
    procedure Set_pageBreakBefore(const p: WideString); safecall;
    function Get_pageBreakBefore: WideString; safecall;
    procedure Set_pageBreakAfter(const p: WideString); safecall;
    function Get_pageBreakAfter: WideString; safecall;
    procedure Set_cssText(const p: WideString); safecall;
    function Get_cssText: WideString; safecall;
    procedure Set_pixelTop(p: Integer); safecall;
    function Get_pixelTop: Integer; safecall;
    procedure Set_pixelLeft(p: Integer); safecall;
    function Get_pixelLeft: Integer; safecall;
    procedure Set_pixelWidth(p: Integer); safecall;
    function Get_pixelWidth: Integer; safecall;
    procedure Set_pixelHeight(p: Integer); safecall;
    function Get_pixelHeight: Integer; safecall;
    procedure Set_posTop(p: Single); safecall;
    function Get_posTop: Single; safecall;
    procedure Set_posLeft(p: Single); safecall;
    function Get_posLeft: Single; safecall;
    procedure Set_posWidth(p: Single); safecall;
    function Get_posWidth: Single; safecall;
    procedure Set_posHeight(p: Single); safecall;
    function Get_posHeight: Single; safecall;
    procedure Set_cursor(const p: WideString); safecall;
    function Get_cursor: WideString; safecall;
    procedure Set_clip(const p: WideString); safecall;
    function Get_clip: WideString; safecall;
    procedure Set_filter(const p: WideString); safecall;
    function Get_filter: WideString; safecall;
    procedure setAttribute(const strAttributeName: WideString; AttributeValue: OleVariant;
                           lFlags: Integer); safecall;
    function getAttribute(const strAttributeName: WideString; lFlags: Integer): OleVariant; safecall;
    function removeAttribute(const strAttributeName: WideString; lFlags: Integer): WordBool; safecall;
    function toString: WideString; safecall;
    property fontFamily: WideString read Get_fontFamily write Set_fontFamily;
    property fontStyle: WideString read Get_fontStyle write Set_fontStyle;
    property fontVariant: WideString read Get_fontVariant write Set_fontVariant;
    property fontWeight: WideString read Get_fontWeight write Set_fontWeight;
    property fontSize: OleVariant read Get_fontSize write Set_fontSize;
    property font: WideString read Get_font write Set_font;
    property color: OleVariant read Get_color write Set_color;
    property background: WideString read Get_background write Set_background;
    property backgroundColor: OleVariant read Get_backgroundColor write Set_backgroundColor;
    property backgroundImage: WideString read Get_backgroundImage write Set_backgroundImage;
    property backgroundRepeat: WideString read Get_backgroundRepeat write Set_backgroundRepeat;
    property backgroundAttachment: WideString read Get_backgroundAttachment write Set_backgroundAttachment;
    property backgroundPosition: WideString read Get_backgroundPosition write Set_backgroundPosition;
    property backgroundPositionX: OleVariant read Get_backgroundPositionX write Set_backgroundPositionX;
    property backgroundPositionY: OleVariant read Get_backgroundPositionY write Set_backgroundPositionY;
    property wordSpacing: OleVariant read Get_wordSpacing write Set_wordSpacing;
    property letterSpacing: OleVariant read Get_letterSpacing write Set_letterSpacing;
    property textDecoration: WideString read Get_textDecoration write Set_textDecoration;
    property textDecorationNone: WordBool read Get_textDecorationNone write Set_textDecorationNone;
    property textDecorationUnderline: WordBool read Get_textDecorationUnderline write Set_textDecorationUnderline;
    property textDecorationOverline: WordBool read Get_textDecorationOverline write Set_textDecorationOverline;
    property textDecorationLineThrough: WordBool read Get_textDecorationLineThrough write Set_textDecorationLineThrough;
    property textDecorationBlink: WordBool read Get_textDecorationBlink write Set_textDecorationBlink;
    property verticalAlign: OleVariant read Get_verticalAlign write Set_verticalAlign;
    property textTransform: WideString read Get_textTransform write Set_textTransform;
    property textAlign: WideString read Get_textAlign write Set_textAlign;
    property textIndent: OleVariant read Get_textIndent write Set_textIndent;
    property lineHeight: OleVariant read Get_lineHeight write Set_lineHeight;
    property marginTop: OleVariant read Get_marginTop write Set_marginTop;
    property marginRight: OleVariant read Get_marginRight write Set_marginRight;
    property marginBottom: OleVariant read Get_marginBottom write Set_marginBottom;
    property marginLeft: OleVariant read Get_marginLeft write Set_marginLeft;
    property margin: WideString read Get_margin write Set_margin;
    property paddingTop: OleVariant read Get_paddingTop write Set_paddingTop;
    property paddingRight: OleVariant read Get_paddingRight write Set_paddingRight;
    property paddingBottom: OleVariant read Get_paddingBottom write Set_paddingBottom;
    property paddingLeft: OleVariant read Get_paddingLeft write Set_paddingLeft;
    property padding: WideString read Get_padding write Set_padding;
    property border: WideString read Get_border write Set_border;
    property borderTop: WideString read Get_borderTop write Set_borderTop;
    property borderRight: WideString read Get_borderRight write Set_borderRight;
    property borderBottom: WideString read Get_borderBottom write Set_borderBottom;
    property borderLeft: WideString read Get_borderLeft write Set_borderLeft;
    property borderColor: WideString read Get_borderColor write Set_borderColor;
    property borderTopColor: OleVariant read Get_borderTopColor write Set_borderTopColor;
    property borderRightColor: OleVariant read Get_borderRightColor write Set_borderRightColor;
    property borderBottomColor: OleVariant read Get_borderBottomColor write Set_borderBottomColor;
    property borderLeftColor: OleVariant read Get_borderLeftColor write Set_borderLeftColor;
    property borderWidth: WideString read Get_borderWidth write Set_borderWidth;
    property borderTopWidth: OleVariant read Get_borderTopWidth write Set_borderTopWidth;
    property borderRightWidth: OleVariant read Get_borderRightWidth write Set_borderRightWidth;
    property borderBottomWidth: OleVariant read Get_borderBottomWidth write Set_borderBottomWidth;
    property borderLeftWidth: OleVariant read Get_borderLeftWidth write Set_borderLeftWidth;
    property borderStyle: WideString read Get_borderStyle write Set_borderStyle;
    property borderTopStyle: WideString read Get_borderTopStyle write Set_borderTopStyle;
    property borderRightStyle: WideString read Get_borderRightStyle write Set_borderRightStyle;
    property borderBottomStyle: WideString read Get_borderBottomStyle write Set_borderBottomStyle;
    property borderLeftStyle: WideString read Get_borderLeftStyle write Set_borderLeftStyle;
    property width: OleVariant read Get_width write Set_width;
    property height: OleVariant read Get_height write Set_height;
    property styleFloat: WideString read Get_styleFloat write Set_styleFloat;
    property clear: WideString read Get_clear write Set_clear;
    property display: WideString read Get_display write Set_display;
    property visibility: WideString read Get_visibility write Set_visibility;
    property listStyleType: WideString read Get_listStyleType write Set_listStyleType;
    property listStylePosition: WideString read Get_listStylePosition write Set_listStylePosition;
    property listStyleImage: WideString read Get_listStyleImage write Set_listStyleImage;
    property listStyle: WideString read Get_listStyle write Set_listStyle;
    property whiteSpace: WideString read Get_whiteSpace write Set_whiteSpace;
    property top: OleVariant read Get_top write Set_top;
    property left: OleVariant read Get_left write Set_left;
    property position: WideString read Get_position;
    property zIndex: OleVariant read Get_zIndex write Set_zIndex;
    property overflow: WideString read Get_overflow write Set_overflow;
    property pageBreakBefore: WideString read Get_pageBreakBefore write Set_pageBreakBefore;
    property pageBreakAfter: WideString read Get_pageBreakAfter write Set_pageBreakAfter;
    property cssText: WideString read Get_cssText write Set_cssText;
    property pixelTop: Integer read Get_pixelTop write Set_pixelTop;
    property pixelLeft: Integer read Get_pixelLeft write Set_pixelLeft;
    property pixelWidth: Integer read Get_pixelWidth write Set_pixelWidth;
    property pixelHeight: Integer read Get_pixelHeight write Set_pixelHeight;
    property posTop: Single read Get_posTop write Set_posTop;
    property posLeft: Single read Get_posLeft write Set_posLeft;
    property posWidth: Single read Get_posWidth write Set_posWidth;
    property posHeight: Single read Get_posHeight write Set_posHeight;
    property cursor: WideString read Get_cursor write Set_cursor;
    property clip: WideString read Get_clip write Set_clip;
    property filter: WideString read Get_filter write Set_filter;
  end;

  IHTMLFiltersCollection = interface(IDispatch)
    ['{3050F3EE-98B5-11CF-BB82-00AA00BDCE0B}']
    function Get_length: Integer; safecall;
    function Get__newEnum: IUnknown; safecall;
    function item(const pvarIndex: OleVariant): OleVariant; safecall;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

  IHTMLElement = interface(IDispatch)
    ['{3050F1FF-98B5-11CF-BB82-00AA00BDCE0B}']
    procedure setAttribute(const strAttributeName: WideString; AttributeValue: OleVariant;
                           lFlags: Integer); safecall;
    function getAttribute(const strAttributeName: WideString; lFlags: Integer): OleVariant; safecall;
    function removeAttribute(const strAttributeName: WideString; lFlags: Integer): WordBool; safecall;
    procedure Set__className(const p: WideString); safecall;
    function Get__className: WideString; safecall;
    procedure Set_id(const p: WideString); safecall;
    function Get_id: WideString; safecall;
    function Get_tagName: WideString; safecall;
    function Get_parentElement: IHTMLElement; safecall;
    function Get_style: IHTMLStyle; safecall;
    procedure Set_onhelp(p: OleVariant); safecall;
    function Get_onhelp: OleVariant; safecall;
    procedure Set_onclick(p: OleVariant); safecall;
    function Get_onclick: OleVariant; safecall;
    procedure Set_ondblclick(p: OleVariant); safecall;
    function Get_ondblclick: OleVariant; safecall;
    procedure Set_onkeydown(p: OleVariant); safecall;
    function Get_onkeydown: OleVariant; safecall;
    procedure Set_onkeyup(p: OleVariant); safecall;
    function Get_onkeyup: OleVariant; safecall;
    procedure Set_onkeypress(p: OleVariant); safecall;
    function Get_onkeypress: OleVariant; safecall;
    procedure Set_onmouseout(p: OleVariant); safecall;
    function Get_onmouseout: OleVariant; safecall;
    procedure Set_onmouseover(p: OleVariant); safecall;
    function Get_onmouseover: OleVariant; safecall;
    procedure Set_onmousemove(p: OleVariant); safecall;
    function Get_onmousemove: OleVariant; safecall;
    procedure Set_onmousedown(p: OleVariant); safecall;
    function Get_onmousedown: OleVariant; safecall;
    procedure Set_onmouseup(p: OleVariant); safecall;
    function Get_onmouseup: OleVariant; safecall;
    function Get_document: IDispatch; safecall;
    procedure Set_title(const p: WideString); safecall;
    function Get_title: WideString; safecall;
    procedure Set_language(const p: WideString); safecall;
    function Get_language: WideString; safecall;
    procedure Set_onselectstart(p: OleVariant); safecall;
    function Get_onselectstart: OleVariant; safecall;
    procedure scrollIntoView(varargStart: OleVariant); safecall;
    function contains(const pChild: IHTMLElement): WordBool; safecall;
    function Get_sourceIndex: Integer; safecall;
    function Get_recordNumber: OleVariant; safecall;
    procedure Set_lang(const p: WideString); safecall;
    function Get_lang: WideString; safecall;
    function Get_offsetLeft: Integer; safecall;
    function Get_offsetTop: Integer; safecall;
    function Get_offsetWidth: Integer; safecall;
    function Get_offsetHeight: Integer; safecall;
    function Get_offsetParent: IHTMLElement; safecall;
    procedure Set_innerHTML(const p: WideString); safecall;
    function Get_innerHTML: WideString; safecall;
    procedure Set_innerText(const p: WideString); safecall;
    function Get_innerText: WideString; safecall;
    procedure Set_outerHTML(const p: WideString); safecall;
    function Get_outerHTML: WideString; safecall;
    procedure Set_outerText(const p: WideString); safecall;
    function Get_outerText: WideString; safecall;
    procedure insertAdjacentHTML(const where: WideString; const html: WideString); safecall;
    procedure insertAdjacentText(const where: WideString; const text: WideString); safecall;
    function Get_parentTextEdit: IHTMLElement; safecall;
    function Get_isTextEdit: WordBool; safecall;
    procedure click; safecall;
    function Get_filters: IHTMLFiltersCollection; safecall;
    procedure Set_ondragstart(p: OleVariant); safecall;
    function Get_ondragstart: OleVariant; safecall;
    function toString: WideString; safecall;
    procedure Set_onbeforeupdate(p: OleVariant); safecall;
    function Get_onbeforeupdate: OleVariant; safecall;
    procedure Set_onafterupdate(p: OleVariant); safecall;
    function Get_onafterupdate: OleVariant; safecall;
    procedure Set_onerrorupdate(p: OleVariant); safecall;
    function Get_onerrorupdate: OleVariant; safecall;
    procedure Set_onrowexit(p: OleVariant); safecall;
    function Get_onrowexit: OleVariant; safecall;
    procedure Set_onrowenter(p: OleVariant); safecall;
    function Get_onrowenter: OleVariant; safecall;
    procedure Set_ondatasetchanged(p: OleVariant); safecall;
    function Get_ondatasetchanged: OleVariant; safecall;
    procedure Set_ondataavailable(p: OleVariant); safecall;
    function Get_ondataavailable: OleVariant; safecall;
    procedure Set_ondatasetcomplete(p: OleVariant); safecall;
    function Get_ondatasetcomplete: OleVariant; safecall;
    procedure Set_onfilterchange(p: OleVariant); safecall;
    function Get_onfilterchange: OleVariant; safecall;
    function Get_children: IDispatch; safecall;
    function Get_all: IDispatch; safecall;
    property _className: WideString read Get__className write Set__className;
    property id: WideString read Get_id write Set_id;
    property tagName: WideString read Get_tagName;
    property parentElement: IHTMLElement read Get_parentElement;
    property style: IHTMLStyle read Get_style;
    property onhelp: OleVariant read Get_onhelp write Set_onhelp;
    property onclick: OleVariant read Get_onclick write Set_onclick;
    property ondblclick: OleVariant read Get_ondblclick write Set_ondblclick;
    property onkeydown: OleVariant read Get_onkeydown write Set_onkeydown;
    property onkeyup: OleVariant read Get_onkeyup write Set_onkeyup;
    property onkeypress: OleVariant read Get_onkeypress write Set_onkeypress;
    property onmouseout: OleVariant read Get_onmouseout write Set_onmouseout;
    property onmouseover: OleVariant read Get_onmouseover write Set_onmouseover;
    property onmousemove: OleVariant read Get_onmousemove write Set_onmousemove;
    property onmousedown: OleVariant read Get_onmousedown write Set_onmousedown;
    property onmouseup: OleVariant read Get_onmouseup write Set_onmouseup;
    property document: IDispatch read Get_document;
    property title: WideString read Get_title write Set_title;
    property language: WideString read Get_language write Set_language;
    property onselectstart: OleVariant read Get_onselectstart write Set_onselectstart;
    property sourceIndex: Integer read Get_sourceIndex;
    property recordNumber: OleVariant read Get_recordNumber;
    property lang: WideString read Get_lang write Set_lang;
    property offsetLeft: Integer read Get_offsetLeft;
    property offsetTop: Integer read Get_offsetTop;
    property offsetWidth: Integer read Get_offsetWidth;
    property offsetHeight: Integer read Get_offsetHeight;
    property offsetParent: IHTMLElement read Get_offsetParent;
    property innerHTML: WideString read Get_innerHTML write Set_innerHTML;
    property innerText: WideString read Get_innerText write Set_innerText;
    property outerHTML: WideString read Get_outerHTML write Set_outerHTML;
    property outerText: WideString read Get_outerText write Set_outerText;
    property parentTextEdit: IHTMLElement read Get_parentTextEdit;
    property isTextEdit: WordBool read Get_isTextEdit;
    property filters: IHTMLFiltersCollection read Get_filters;
    property ondragstart: OleVariant read Get_ondragstart write Set_ondragstart;
    property onbeforeupdate: OleVariant read Get_onbeforeupdate write Set_onbeforeupdate;
    property onafterupdate: OleVariant read Get_onafterupdate write Set_onafterupdate;
    property onerrorupdate: OleVariant read Get_onerrorupdate write Set_onerrorupdate;
    property onrowexit: OleVariant read Get_onrowexit write Set_onrowexit;
    property onrowenter: OleVariant read Get_onrowenter write Set_onrowenter;
    property ondatasetchanged: OleVariant read Get_ondatasetchanged write Set_ondatasetchanged;
    property ondataavailable: OleVariant read Get_ondataavailable write Set_ondataavailable;
    property ondatasetcomplete: OleVariant read Get_ondatasetcomplete write Set_ondatasetcomplete;
    property onfilterchange: OleVariant read Get_onfilterchange write Set_onfilterchange;
    property children: IDispatch read Get_children;
    property all: IDispatch read Get_all;
  end;

  IHTMLDocument2 = interface(IHTMLDocument)
    ['{332C4425-26CB-11D0-B483-00C04FD90119}']
    function Get_all: IHTMLElementCollection; safecall;
    function Get_body: IHTMLElement; safecall;
    function Get_activeElement: IHTMLElement; safecall;
    function Get_images: IHTMLElementCollection; safecall;
    function Get_applets: IHTMLElementCollection; safecall;
    function Get_links: IHTMLElementCollection; safecall;
    function Get_forms: IHTMLElementCollection; safecall;
    function Get_anchors: IHTMLElementCollection; safecall;
    procedure Set_title(const p: WideString); safecall;
    function Get_title: WideString; safecall;
    function Get_scripts: IHTMLElementCollection; safecall;
    procedure Set_designMode(const p: WideString); safecall;
    function Get_designMode: WideString; safecall;
    function Get_selection: IHTMLSelectionObject; safecall;
    function Get_readyState: WideString; safecall;
    function Get_frames: IHTMLFramesCollection2; safecall;
    function Get_embeds: IHTMLElementCollection; safecall;
    function Get_plugins: IHTMLElementCollection; safecall;
    procedure Set_alinkColor(p: OleVariant); safecall;
    function Get_alinkColor: OleVariant; safecall;
    procedure Set_bgColor(p: OleVariant); safecall;
    function Get_bgColor: OleVariant; safecall;
    procedure Set_fgColor(p: OleVariant); safecall;
    function Get_fgColor: OleVariant; safecall;
    procedure Set_linkColor(p: OleVariant); safecall;
    function Get_linkColor: OleVariant; safecall;
    procedure Set_vlinkColor(p: OleVariant); safecall;
    function Get_vlinkColor: OleVariant; safecall;
    function Get_referrer: WideString; safecall;
    function Get_location: IHTMLLocation; safecall;
    function Get_lastModified: WideString; safecall;
    procedure Set_url(const p: WideString); safecall;
    function Get_url: WideString; safecall;
    procedure Set_domain(const p: WideString); safecall;
    function Get_domain: WideString; safecall;
    procedure Set_cookie(const p: WideString); safecall;
    function Get_cookie: WideString; safecall;
    procedure Set_expando(p: WordBool); safecall;
    function Get_expando: WordBool; safecall;
    procedure Set_charset(const p: WideString); safecall;
    function Get_charset: WideString; safecall;
    procedure Set_defaultCharset(const p: WideString); safecall;
    function Get_defaultCharset: WideString; safecall;
    function Get_mimeType: WideString; safecall;
    function Get_fileSize: WideString; safecall;
    function Get_fileCreatedDate: WideString; safecall;
    function Get_fileModifiedDate: WideString; safecall;
    function Get_fileUpdatedDate: WideString; safecall;
    function Get_security: WideString; safecall;
    function Get_protocol: WideString; safecall;
    function Get_nameProp: WideString; safecall;
    procedure write(psarray: PSafeArray); safecall;
    procedure writeln(psarray: PSafeArray); safecall;
    function open(const url: WideString; name: OleVariant; features: OleVariant; replace: OleVariant): IDispatch; safecall;
    procedure close; safecall;
    procedure clear; safecall;
    function queryCommandSupported(const cmdID: WideString): WordBool; safecall;
    function queryCommandEnabled(const cmdID: WideString): WordBool; safecall;
    function queryCommandState(const cmdID: WideString): WordBool; safecall;
    function queryCommandIndeterm(const cmdID: WideString): WordBool; safecall;
    function queryCommandText(const cmdID: WideString): WideString; safecall;
    function queryCommandValue(const cmdID: WideString): OleVariant; safecall;
    function execCommand(const cmdID: WideString; showUI: WordBool; value: OleVariant): WordBool; safecall;
    function execCommandShowHelp(const cmdID: WideString): WordBool; safecall;
    function createElement(const eTag: WideString): IHTMLElement; safecall;
    procedure Set_onhelp(p: OleVariant); safecall;
    function Get_onhelp: OleVariant; safecall;
    procedure Set_onclick(p: OleVariant); safecall;
    function Get_onclick: OleVariant; safecall;
    procedure Set_ondblclick(p: OleVariant); safecall;
    function Get_ondblclick: OleVariant; safecall;
    procedure Set_onkeyup(p: OleVariant); safecall;
    function Get_onkeyup: OleVariant; safecall;
    procedure Set_onkeydown(p: OleVariant); safecall;
    function Get_onkeydown: OleVariant; safecall;
    procedure Set_onkeypress(p: OleVariant); safecall;
    function Get_onkeypress: OleVariant; safecall;
    procedure Set_onmouseup(p: OleVariant); safecall;
    function Get_onmouseup: OleVariant; safecall;
    procedure Set_onmousedown(p: OleVariant); safecall;
    function Get_onmousedown: OleVariant; safecall;
    procedure Set_onmousemove(p: OleVariant); safecall;
    function Get_onmousemove: OleVariant; safecall;
    procedure Set_onmouseout(p: OleVariant); safecall;
    function Get_onmouseout: OleVariant; safecall;
    procedure Set_onmouseover(p: OleVariant); safecall;
    function Get_onmouseover: OleVariant; safecall;
    procedure Set_onreadystatechange(p: OleVariant); safecall;
    function Get_onreadystatechange: OleVariant; safecall;
    procedure Set_onafterupdate(p: OleVariant); safecall;
    function Get_onafterupdate: OleVariant; safecall;
    procedure Set_onrowexit(p: OleVariant); safecall;
    function Get_onrowexit: OleVariant; safecall;
    procedure Set_onrowenter(p: OleVariant); safecall;
    function Get_onrowenter: OleVariant; safecall;
    procedure Set_ondragstart(p: OleVariant); safecall;
    function Get_ondragstart: OleVariant; safecall;
    procedure Set_onselectstart(p: OleVariant); safecall;
    function Get_onselectstart: OleVariant; safecall;
    function elementFromPoint(x: Integer; y: Integer): IHTMLElement; safecall;
    function Get_parentWindow: IHTMLWindow2; safecall;
    function Get_styleSheets: IHTMLStyleSheetsCollection; safecall;
    procedure Set_onbeforeupdate(p: OleVariant); safecall;
    function Get_onbeforeupdate: OleVariant; safecall;
    procedure Set_onerrorupdate(p: OleVariant); safecall;
    function Get_onerrorupdate: OleVariant; safecall;
    function toString: WideString; safecall;
    function createStyleSheet(const bstrHref: WideString; lIndex: Integer): IHTMLStyleSheet; safecall;
    property all: IHTMLElementCollection read Get_all;
    property body: IHTMLElement read Get_body;
    property activeElement: IHTMLElement read Get_activeElement;
    property images: IHTMLElementCollection read Get_images;
    property applets: IHTMLElementCollection read Get_applets;
    property links: IHTMLElementCollection read Get_links;
    property forms: IHTMLElementCollection read Get_forms;
    property anchors: IHTMLElementCollection read Get_anchors;
    property title: WideString read Get_title write Set_title;
    property scripts: IHTMLElementCollection read Get_scripts;
    property designMode: WideString read Get_designMode write Set_designMode;
    property selection: IHTMLSelectionObject read Get_selection;
    property readyState: WideString read Get_readyState;
    property frames: IHTMLFramesCollection2 read Get_frames;
    property embeds: IHTMLElementCollection read Get_embeds;
    property plugins: IHTMLElementCollection read Get_plugins;
    property alinkColor: OleVariant read Get_alinkColor write Set_alinkColor;
    property bgColor: OleVariant read Get_bgColor write Set_bgColor;
    property fgColor: OleVariant read Get_fgColor write Set_fgColor;
    property linkColor: OleVariant read Get_linkColor write Set_linkColor;
    property vlinkColor: OleVariant read Get_vlinkColor write Set_vlinkColor;
    property referrer: WideString read Get_referrer;
    property location: IHTMLLocation read Get_location;
    property lastModified: WideString read Get_lastModified;
    property url: WideString read Get_url write Set_url;
    property domain: WideString read Get_domain write Set_domain;
    property cookie: WideString read Get_cookie write Set_cookie;
    property expando: WordBool read Get_expando write Set_expando;
    property charset: WideString read Get_charset write Set_charset;
    property defaultCharset: WideString read Get_defaultCharset write Set_defaultCharset;
    property mimeType: WideString read Get_mimeType;
    property fileSize: WideString read Get_fileSize;
    property fileCreatedDate: WideString read Get_fileCreatedDate;
    property fileModifiedDate: WideString read Get_fileModifiedDate;
    property fileUpdatedDate: WideString read Get_fileUpdatedDate;
    property security: WideString read Get_security;
    property protocol: WideString read Get_protocol;
    property nameProp: WideString read Get_nameProp;
    property onhelp: OleVariant read Get_onhelp write Set_onhelp;
    property onclick: OleVariant read Get_onclick write Set_onclick;
    property ondblclick: OleVariant read Get_ondblclick write Set_ondblclick;
    property onkeyup: OleVariant read Get_onkeyup write Set_onkeyup;
    property onkeydown: OleVariant read Get_onkeydown write Set_onkeydown;
    property onkeypress: OleVariant read Get_onkeypress write Set_onkeypress;
    property onmouseup: OleVariant read Get_onmouseup write Set_onmouseup;
    property onmousedown: OleVariant read Get_onmousedown write Set_onmousedown;
    property onmousemove: OleVariant read Get_onmousemove write Set_onmousemove;
    property onmouseout: OleVariant read Get_onmouseout write Set_onmouseout;
    property onmouseover: OleVariant read Get_onmouseover write Set_onmouseover;
    property onreadystatechange: OleVariant read Get_onreadystatechange write Set_onreadystatechange;
    property onafterupdate: OleVariant read Get_onafterupdate write Set_onafterupdate;
    property onrowexit: OleVariant read Get_onrowexit write Set_onrowexit;
    property onrowenter: OleVariant read Get_onrowenter write Set_onrowenter;
    property ondragstart: OleVariant read Get_ondragstart write Set_ondragstart;
    property onselectstart: OleVariant read Get_onselectstart write Set_onselectstart;
    property parentWindow: IHTMLWindow2 read Get_parentWindow;
    property styleSheets: IHTMLStyleSheetsCollection read Get_styleSheets;
    property onbeforeupdate: OleVariant read Get_onbeforeupdate write Set_onbeforeupdate;
    property onerrorupdate: OleVariant read Get_onerrorupdate write Set_onerrorupdate;
  end;

  {$ENDIF}

  TTMSFMXWinWebGMapsWebBrowserService = class;

  TTMSFMXWinWebGMapsWebBrowserService = class(TTMSFMXWebGMapsWebBrowserFactoryService)
  protected
    function DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser; override;
    procedure DeleteCookies; override;
  end;

  {$IFDEF USECHROMIUM}
  TChromiumFMXProtected = class(TChromiumFMX);
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}

  _DOCHOSTUIINFO = record
    cbSize: UINT;
    dwFlags: UINT;
    dwDoubleClick: UINT;
    pchHostCss: POLESTR;
    pchHostNS: POLESTR;
  end;

  PtagPOINT = ^tagPOINT;
  tagPOINT = TPoint;

  PtagRECT = ^tagRECT;
  tagRECT = TRect;

  IDocHostUIHandler = interface(IUnknown)
    ['{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}']
    function ShowContextMenu(dwID: UINT; ppt: PtagPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HResult; stdcall;
    function GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult; stdcall;
    function ShowUI(dwID: UINT; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HResult; stdcall;
    function HideUI: HResult; stdcall;
    function UpdateUI: HResult; stdcall;
    function EnableModeless(fEnable: Integer): HResult; stdcall;
    function OnDocWindowActivate(fActivate: Integer): HResult; stdcall;
    function OnFrameWindowActivate(fActivate: Integer): HResult; stdcall;
    function ResizeBorder(var prcBorder: tagRECT; const pUIWindow: IOleInPlaceUIWindow; fRameWindow: Integer): HResult; stdcall;
    function TranslateAccelerator(var lpmsg: tagMSG; var pguidCmdGroup: TGUID; nCmdID: UINT): HResult; stdcall;
    function GetOptionKeyPath(out pchKey: PWideChar; dw: UINT): HResult; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
    function TranslateUrl(dwTranslate: UINT; pchURLIn: PWideChar; out ppchURLOut: PWideChar): HResult; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult; stdcall;
  end;

  ICustomDoc = interface(IUnknown)
    ['{3050f3f0-98b5-11cf-bb82-00aa00bdce0b}']
    function SetUIHandler(const pUIHandler: IDocHostUIHandler): HResult; stdcall;
  end;

  TDocHostUIHandler = class(TComponent, IDocHostUIHandler)
  private
    FWebBrowser: TTMSFMXWebGMapsCustomWebBrowser;
  protected
    function ShowContextMenu(dwID: UINT; ppt: PtagPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HResult; stdcall;
    function GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult; stdcall;
    function ShowUI(dwID: UINT; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HResult; stdcall;
    function HideUI: HResult; stdcall;
    function UpdateUI: HResult; stdcall;
    function EnableModeless(fEnable: Integer): HResult; stdcall;
    function OnDocWindowActivate(fActivate: Integer): HResult; stdcall;
    function OnFrameWindowActivate(fActivate: Integer): HResult; stdcall;
    function ResizeBorder(var prcBorder: tagRECT; const pUIWindow: IOleInPlaceUIWindow; fRameWindow: Integer): HResult; stdcall;
    function TranslateAccelerator(var lpmsg: tagMSG; var pguidCmdGroup: TGUID; nCmdID: UINT): HResult; stdcall;
    function GetOptionKeyPath(out pchKey: PWideChar; dw: UINT): HResult; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
    function TranslateUrl(dwTranslate: UINT; pchURLIn: PWideChar; out ppchURLOut: PWideChar): HResult; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult; stdcall;
  public
    constructor Create(AWebBrowser: TTMSFMXWebGMapsCustomWebBrowser); reintroduce;
  end;

  TTMSFMXWebGMapsWebBrowserEvents = class;
  {$ENDIF}

  TTMSFMXWebGMapsCustomWebBrowserProtected = class(TTMSFMXWebGMapsCustomWebBrowser);

  TTMSFMXWinWebGMapsWebBrowser = class(TInterfacedObject, ITMSFMXWebGMapsCustomWebBrowser)
  private
    {$IFDEF USECHROMIUM}
    FWebBrowser: TChromiumFMX;
    {$ENDIF}
    {$IFDEF USEFMXWEBBROWSER}
    FDockHost: TDocHostUIHandler;
    FBlockEvents: Boolean;
    FWebBrowserInstance: IWebBrowser2;
    FWebBrowser: TWebBrowser;
    FWebBrowserEvents: TTMSFMXWebGMapsWebBrowserEvents;
    {$ENDIF}
    FExternalBrowser: Boolean;
    FURL: string;
    FWebControl: TTMSFMXWebGMapsCustomWebBrowser;
  protected
    {$IFDEF USECHROMIUM}
    procedure BeforeBrowse(Sender: TObject; const browser: ICefBrowser; const frame: ICefFrame;
    const request: ICefRequest; navType: TCefHandlerNavtype;
    isRedirect: boolean; out Result: Boolean);
    procedure LoadEnd(Sender: TObject; const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean);
    {$ENDIF}
    {$IFDEF USEFMXWEBBROWSER}
    procedure WaitForInitialization;
    procedure Connect;
    procedure ConnectToDockHostUI;
    procedure InternalLoadDocumentFromStream(const Stream: TStream);
    procedure DidFinishLoading(Sender: TObject);
    procedure BeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant; var Flags: OleVariant; var TargetFrameName: OleVariant;
      var PostData: OleVariant; var Headers: OleVariant; var Cancel: WordBool);
    procedure NavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    {$ENDIF}
    procedure SetURL(const AValue: string);
    procedure SetExternalBrowser(const AValue: Boolean);
    procedure Navigate(const AURL: string); overload;
    procedure Navigate; overload;
    procedure LoadHTML(AHTML: String);
    procedure LoadFile(AFile: String);
    procedure GoForward;
    procedure GoBack;
    procedure Close;
    procedure Reload;
    procedure StopLoading;
    procedure UpdateVisible;
    procedure UpdateEnabled;
    procedure UpdateBounds;
    procedure Initialize;
    procedure DeInitialize;
    function GetExternalBrowser: Boolean;
    function GetURL: string;
    function ExecuteJavascript(AScript: String): String;
    function BodyInnerHTML: string;
    function NativeBrowser: Pointer;
    function GetBrowserInstance: IInterface;
    function NativeDialog: Pointer;
    function IsFMXBrowser: Boolean;
    function CanGoBack: Boolean;
    function CanGoForward: Boolean;
  public
    constructor Create(const AWebControl: TTMSFMXWebGMapsCustomWebBrowser);
  end
  {$IF DEFINED(DELPHIXE8_LVL) AND DEFINED(USECHROMIUM)}
  deprecated'The Chromium implementation is deprecated starting from XE8, please use the TTMSFMXWebGMapsWebBrowser without modifying the tmsdefs.inc file'
  {$ENDIF}
  ;

  {$IFDEF USEFMXWEBBROWSER}
  TIEBeforeNavigate2Event = procedure(Sender: TObject; const pDisp: IDispatch;
    var URL: OleVariant; var Flags: OleVariant; var TargetFrameName: OleVariant;
    var PostData: OleVariant; var Headers: OleVariant; var Cancel: WordBool) of object;
  TIENavigateComplete2Event = procedure(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant) of object;

  TTMSFMXWebGMapsWebBrowserEvents = class(TComponent, IUnknown, IDispatch)
  private
     // Private declarations
    FConnected: Boolean;
    FCookie: Integer;
    FCP: IConnectionPoint;
    FSinkIID: TGuid;
    FSource: IWebBrowser2;
    FBeforeNavigate2: TIEBeforeNavigate2Event;
    FNavigateComplete2: TIENavigateComplete2Event;
  protected
     // Protected declaratios for IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; override;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
     // Protected declaratios for IDispatch
    function GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount, LocaleID:
      Integer; DispIDs: Pointer): HResult; virtual; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; virtual; stdcall;
    function GetTypeInfoCount(out Count: Integer): HResult; virtual; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; virtual; stdcall;
     // Protected declarations
    procedure DoBeforeNavigate2(const pDisp: IDispatch; var URL: OleVariant;
      var Flags: OleVariant; var TargetFrameName: OleVariant; var PostData: OleVariant;
      var Headers: OleVariant; var Cancel: WordBool); safecall;
    procedure DoNavigateComplete2(const pDisp: IDispatch; var URL: OleVariant); safecall;
  public
     // Public declarations
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConnectTo(Source: IWebBrowser2);
    procedure Disconnect;
    property SinkIID: TGuid read FSinkIID;
    property Source: IWebBrowser2 read FSource;
  published
     // Published declarations
    property WebObj: IWebBrowser2 read FSource;
    property Connected: Boolean read FConnected;
    property BeforeNavigate2: TIEBeforeNavigate2Event read FBeforeNavigate2 write FBeforeNavigate2;
    property NavigateComplete2: TIENavigateComplete2Event read FNavigateComplete2 write FNavigateComplete2;
  end;

  TObjectFromLResult = function(LResult: lResult; const IID: TIID; WPARAM: wParam; out pObject): HResult; stdcall;

const
  DOCHOSTUIFLAG_DIALOG                      = $1;
  DOCHOSTUIFLAG_DISABLE_HELP_MENU           = $2;
  DOCHOSTUIFLAG_NO3DBORDER                  = $4;
  DOCHOSTUIFLAG_SCROLL_NO                   = $8;
  DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE     = $10;
  DOCHOSTUIFLAG_OPENNEWWIN                  = $20;
  DOCHOSTUIFLAG_DISABLE_OFFSCREEN           = $40;
  DOCHOSTUIFLAG_FLAT_SCROLLBAR              = $80;
  DOCHOSTUIFLAG_DIV_BLOCKDEFAULT            = $100;
  DOCHOSTUIFLAG_ACTIVATE_CLIENTHIT_ONLY     = $200;
  DOCHOSTUIFLAG_OVERRIDEBEHAVIORFACTORY     = $400;
  DOCHOSTUIFLAG_CODEPAGELINKEDFONTS         = $800;
  DOCHOSTUIFLAG_URL_ENCODING_DISABLE_UTF8   = $1000;
  DOCHOSTUIFLAG_URL_ENCODING_ENABLE_UTF8    = $2000;
  DOCHOSTUIFLAG_ENABLE_FORMS_AUTOCOMPLETE   = $4000;
  DOCHOSTUIFLAG_ENABLE_INPLACE_NAVIGATION   = $10000;
  DOCHOSTUIFLAG_IME_ENABLE_RECONVERSION     = $20000;
  DOCHOSTUIFLAG_THEME                       = $40000;
  DOCHOSTUIFLAG_NOTHEME                     = $80000;
  DOCHOSTUIFLAG_NOPICS                      = $100000;
  DOCHOSTUIFLAG_NO3DOUTERBORDER             = $200000;
  DOCHOSTUIFLAG_DISABLE_EDIT_NS_FIXUP       = $400000;
  DOCHOSTUIFLAG_LOCAL_MACHINE_ACCESS_CHECK	= $800000;
  DOCHOSTUIFLAG_DISABLE_UNTRUSTEDPROTOCOL	  = $1000000;
  DOCHOSTUIFLAG_ENABLE_ACTIVEX_BLOCK_MODE   = $2000000;
  DOCHOSTUIFLAG_ENABLE_ACTIVEX_PROMPT_MODE  = $4000000;
  DOCHOSTUIFLAG_ENABLE_ACTIVEX_DEFAULT_MODE = $8000000;

  Class_DocHostUIHandler: TGUID = '{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}';

  {$ENDIF}

var
  WebBrowserService: ITMSFMXWebGMapsWebBrowserService;

procedure RegisterWebBrowserService;
begin
  if not TPlatformServices.Current.SupportsPlatformService(ITMSFMXWebGMapsWebBrowserService, IInterface(WebBrowserService)) then
  begin
    WebBrowserService := TTMSFMXWinWebGMapsWebBrowserService.Create;
    TPlatformServices.Current.AddPlatformService(ITMSFMXWebGMapsWebBrowserService, WebBrowserService);
  end;
end;

procedure UnregisterWebBrowserService;
begin
  TPlatformServices.Current.RemovePlatformService(ITMSFMXWebGMapsWebBrowserService);
end;

function TTMSFMXWinWebGMapsWebBrowser.GetBrowserInstance: IInterface;
begin
  {$IFDEF USECHROMIUM}
  Result := nil;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  Result := FWebBrowserInstance;
  {$ENDIF}
end;

function TTMSFMXWinWebGMapsWebBrowser.GetExternalBrowser: Boolean;
begin
  Result := FExternalBrowser;
end;

function TTMSFMXWinWebGMapsWebBrowser.GetURL: string;
begin
  Result := FURL;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.GoBack;
begin
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) then
    FWebBrowser.Browser.GoBack;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
    FWebBrowser.GoBack;
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.GoForward;
begin
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) then
    FWebBrowser.Browser.GoForward;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
    FWebBrowser.GoForward;
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.Initialize;
begin
  {$IFDEF DELPHIXE9_LVL}
  {$IF DEFINED(USECHROMIUM) or DEFINED(USEFMXWEBBROWSER)}
  FWebBrowser.Parent := FWebControl;
  {$IFDEF DELPHIXE6_LVL}
  FWebBrowser.Align := TAlignLayout.Client;
  {$ELSE}
  FWebBrowser.Align := TAlignLayout.alClient;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and not Assigned(FWebBrowser.Browser) then
  begin
    FWebBrowser.DefaultUrl := GetURL;
    TChromiumFMXProtected(FWebBrowser).Loaded;
  end;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if not FExternalBrowser then
    Navigate('about:blank');
  {$ENDIF}
end;

function TTMSFMXWinWebGMapsWebBrowser.BodyInnerHTML: string;
{$IFDEF USEFMXWEBBROWSER}
var
  pDoc: IHTMLDocument2;
{$ENDIF}
begin
  Result := '';
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) and Assigned(FWebBrowserInstance) and Assigned(FWebBrowserInstance.Document) then
  begin
    pDoc := FWebBrowserInstance.Document as IHtmlDocument2;
    if Assigned(pDoc.body) then
      Result := pDoc.body.innerHTML;
  end;
  {$ENDIF}
end;

function TTMSFMXWinWebGMapsWebBrowser.IsFMXBrowser: Boolean;
begin
  {$IF DEFINED(USECHROMIUM) OR DEFINED(USEFMXWEBBROWSER)}
  {$IFDEF USEFMXWEBBROWSER}
  Result := True;
  {$ELSE}
  Result := False;
  {$ENDIF}
  {$ELSE}
  Result := False;
  {$ENDIF}
end;

{$IFDEF USECHROMIUM}
procedure TTMSFMXWinWebGMapsWebBrowser.LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer;
  out Result: Boolean);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams;
begin
  Params.URL := browser.MainFrame.Url;
  if Assigned(FWebControl) then
  begin
    FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).NavigateComplete(Params);
  end;
end;
{$ENDIF}
{$IFDEF USEFMXWEBBROWSER}
procedure TTMSFMXWinWebGMapsWebBrowser.NavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserNavigateCompleteParams;
begin
  if FBlockEvents then
  begin
    FBlockEvents := False;
    Exit;
  end;

  Params.URL := Url;
  if Assigned(FWebControl) then
  begin
    FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).NavigateComplete(Params);
  end;
end;
{$ENDIF}

procedure TTMSFMXWinWebGMapsWebBrowser.LoadFile(AFile: String);
{$IFDEF USEFMXWEBBROWSER}
var
  FileStream: TFileStream;
{$ENDIF}
begin
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) and Assigned(FWebBrowser.Browser.MainFrame) then
    FWebBrowser.Browser.MainFrame.LoadFile(AFile, AFile);
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  WaitForInitialization;
  FileStream := TFileStream.Create(AFile, fmOpenRead or fmShareDenyNone);
  try
    InternalLoadDocumentFromStream(FileStream);
  finally
    FileStream.Free;
  end;
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.LoadHTML(AHTML: String);
begin
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) and Assigned(FWebBrowser.Browser.MainFrame) then
    FWebBrowser.Browser.MainFrame.LoadString(AHTML, 'about:blank');
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
     FWebBrowser.LoadFromStrings(AHTML, 'about:blank');
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.Navigate(const AURL: string);
begin
  {$IFDEF USEFMXWEBBROWSER}
  if FExternalBrowser then
  begin
    ShellExecute(0,'open', PChar(AURL),nil,nil,SW_NORMAL)
  end
  else
  {$ENDIF}
  begin
    {$IFDEF USECHROMIUM}
    if Assigned(FWebBrowser) then
      FWebBrowser.Load(AURL);
    {$ENDIF}
    {$IFDEF USEFMXWEBBROWSER}
    if Assigned(FWebBrowser) then
    begin
      FWebBrowser.Navigate('');
      FWebBrowser.Navigate(AURL);
    end;
    {$ENDIF}
  end;
end;

function TTMSFMXWinWebGMapsWebBrowser.NativeBrowser: Pointer;
begin
  {$IF DEFINED(USECHROMIUM) OR DEFINED(USEFMXWEBBROWSER)}
  Result := FWebBrowser;
  {$ELSE}
  Result := nil;
  {$ENDIF}
end;

function TTMSFMXWinWebGMapsWebBrowser.NativeDialog: Pointer;
begin
  Result := nil;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.Navigate;
begin
  Navigate(FURL);
end;

procedure TTMSFMXWinWebGMapsWebBrowser.Reload;
begin
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) then
    FWebBrowser.Browser.Reload;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
    FWebBrowser.Reload;
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.SetExternalBrowser(const AValue: Boolean);
begin
  FExternalBrowser := AValue;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.SetURL(const AValue: string);
begin
  FURL := AValue;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.StopLoading;
begin
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) then
    FWebBrowser.Browser.StopLoad;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
    FWebBrowser.Stop;
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.UpdateBounds;
begin
end;

procedure TTMSFMXWinWebGMapsWebBrowser.UpdateEnabled;
begin
end;

procedure TTMSFMXWinWebGMapsWebBrowser.UpdateVisible;
begin
  {$IFDEF USEFMXWEBBROWSER}
  Connect;
  {$ENDIF}
end;

{$IFDEF USECHROMIUM}
procedure TTMSFMXWinWebGMapsWebBrowser.BeforeBrowse(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; navType: TCefHandlerNavtype; isRedirect: boolean;
  out Result: Boolean);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams;
begin
  Params.URL := request.Url;
  Params.Cancel := Result;
  if Assigned(FWebControl) then
  begin
    FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).BeforeNavigate(Params);
  end;
  Result := Params.Cancel;
end;
{$ENDIF}

{$IFDEF USEFMXWEBBROWSER}
procedure TTMSFMXWinWebGMapsWebBrowser.InternalLoadDocumentFromStream(const Stream: TStream);
var
  PersistStreamInit: IPersistStreamInit;
  StreamAdapter: IStream;
begin
  if not Assigned(FWebBrowserInstance) then
    Exit;

  if not Assigned(FWebBrowserInstance.Document) then
    Exit;

  if FWebBrowserInstance.Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
  begin
    if PersistStreamInit.InitNew = S_OK then
    begin
      StreamAdapter := TStreamAdapter.Create(Stream);
      PersistStreamInit.Load(StreamAdapter);
    end;
  end;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.ConnectToDockHostUI;
var
  hr: HRESULT;
  cd: ICustomDoc;
begin
  hr := FWebBrowserInstance.Document.QueryInterface(ICustomDoc, cd);
  if hr = S_OK then
    cd.SetUIHandler(FDockHost);
end;

procedure TTMSFMXWinWebGMapsWebBrowser.WaitForInitialization;
var
  i: Integer;
begin
  i := 0;
  while not Assigned(FWebBrowserInstance) and (i <= 60000) do
  begin
    Application.ProcessMessages;
    Sleep(1);
    Inc(i);
  end;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.Connect;
var
  frm: TCommonCustomForm;
  Wnd, WndChild: HWND;
  function GetIEFromHWND(WHandle: HWND; var IE: IWebbrowser2): HRESULT;
  var
    hInst: HWND;
    lRes: DWORD;
    MSG: Integer;
    pDoc: IHTMLDocument2;
    ObjectFromLresult: TObjectFromLresult;
  begin
    Result := S_FALSE;
    hInst := LoadLibrary('Oleacc.dll');
    @ObjectFromLresult := GetProcAddress(hInst, 'ObjectFromLresult');
    if @ObjectFromLresult <> nil then
    begin
      try
        MSG := RegisterWindowMessage('WM_HTML_GETOBJECT');
        SendMessageTimeOut(WHandle, MSG, 0, 0, SMTO_ABORTIFHUNG, 1000, @lRes);
        Result := ObjectFromLresult(lRes, IHTMLDocument2, 0, pDoc);
        if Result = S_OK then
          (pDoc.parentWindow as IServiceprovider).QueryService(IWebbrowserApp, IWebbrowser2, IE);
      finally
        FreeLibrary(hInst);
      end;
    end;
  end;
begin
  if Assigned(FWebControl) then
  begin
    if not Assigned(FWebBrowserInstance) then
    begin
      frm := nil;
      if (FWebControl.Root <> nil) and (FWebControl.Root.GetObject is TCommonCustomForm) then
        frm := TCommonCustomForm(FWebControl.Root.GetObject);
      if Assigned(frm) then
      begin
        Wnd := WindowHandleToPlatform(frm.Handle).Wnd;
        if Wnd <> 0 then
        begin
          Wnd := FindWindowEX(Wnd, 0, 'Shell Embedding', nil);
          WndChild := FindWindowEX(Wnd, 0, 'Shell DocObject View', nil);
          if WndChild <> 0 then
          begin
            WndChild := FindWindowEX(WndChild, 0, 'Internet Explorer_Server', nil);
            if WndChild <> 0 then
              GetIEFromHWnd(WndChild, FWebBrowserInstance);
          end;
        end;
        if Assigned(FWebBrowserInstance) then
        begin
          FWebBrowserEvents.ConnectTo(FWebBrowserInstance);
          ConnectToDockHostUI;
          TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).Initialized;
        end;
      end;
    end;
  end;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.DidFinishLoading(Sender: TObject);
begin
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.OnDidFinishLoad := nil;
    Connect;
  end;
end;

procedure TTMSFMXWinWebGMapsWebBrowser.BeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant; var Flags: OleVariant; var TargetFrameName: OleVariant;
      var PostData: OleVariant; var Headers: OleVariant; var Cancel: WordBool);
var
  Params: TTMSFMXWebGMapsCustomWebBrowserBeforeNavigateParams;
begin
  if FBlockEvents then
    Exit;
  Params.URL := URL;
  Params.Cancel := Cancel;
  if Assigned(FWebControl) then
  begin
    FURL := Params.URL;
    TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).BeforeNavigate(Params);
  end;
  Cancel := Params.Cancel;
end;
{$ENDIF}

function TTMSFMXWinWebGMapsWebBrowser.CanGoBack: Boolean;
begin
  Result := False;
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) then
    FWebBrowser.Browser.CanGoBack;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CanGoBack;
  {$ENDIF}
end;

function TTMSFMXWinWebGMapsWebBrowser.CanGoForward: Boolean;
begin
  Result := False;
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) then
    FWebBrowser.Browser.CanGoForward;
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
    Result := FWebBrowser.CanGoForward;
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.Close;
begin
  TTMSFMXWebGMapsCustomWebBrowserProtected(FWebControl).DoCloseForm;
end;

constructor TTMSFMXWinWebGMapsWebBrowser.Create(const AWebControl: TTMSFMXWebGMapsCustomWebBrowser);
begin
  FExternalBrowser := False;
  FWebControl := AWebControl;
  {$IFDEF USECHROMIUM}
  FWebBrowser := TChromiumFMX.Create(FWebControl);
  FWebBrowser.OnBeforeBrowse := BeforeBrowse;
  FWebBrowser.OnLoadEnd := LoadEnd;
  {$ENDIF}

  {$IFDEF USEFMXWEBBROWSER}
  FBlockEvents := True;
  FDockHost := TDocHostUIHandler.Create(FWebControl);
  FWebBrowser := TWebBrowser.Create(FWebControl);
  FWebBrowser.OnDidFinishLoad := DidFinishLoading;
  FWebBrowserEvents := TTMSFMXWebGMapsWebBrowserEvents.Create(FWebControl);
  FWebBrowserEvents.BeforeNavigate2 := BeforeNavigate2;
  FWebBrowserEvents.NavigateComplete2 := NavigateComplete2;
  {$ENDIF}

  {$IFNDEF DELPHIXE9_LVL}
  {$IF DEFINED(USECHROMIUM) or DEFINED(USEFMXWEBBROWSER)}
  FWebBrowser.Parent := FWebControl;
  {$IFDEF DELPHIXE6_LVL}
  FWebBrowser.Align := TAlignLayout.Client;
  {$ELSE}
  FWebBrowser.Align := TAlignLayout.alClient;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
end;

procedure TTMSFMXWinWebGMapsWebBrowser.DeInitialize;
begin
  {$IF DEFINED(USECHROMIUM) OR DEFINED(USEFMXWEBBROWSER)}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowserEvents) then
  begin
    FWebBrowserEvents.Free;
    FWebBrowserEvents := nil;
  end;

  FDockHost := nil;
  {$ENDIF}
  if Assigned(FWebBrowser) then
  begin
    FWebBrowser.Free;
    FWebBrowser := nil;
  end;
  {$ENDIF}
end;

function TTMSFMXWinWebGMapsWebBrowser.ExecuteJavascript(AScript: String): String;
begin
  Result := '';
  {$IFDEF USECHROMIUM}
  if Assigned(FWebBrowser) and Assigned(FWebBrowser.Browser) then
    FWebBrowser.Browser.MainFrame.ExecuteJavaScript(AScript, '', -1);
  {$ENDIF}
  {$IFDEF USEFMXWEBBROWSER}
  if Assigned(FWebBrowser) then
    FWebBrowser.EvaluateJavaScript(AScript);
  {$ENDIF}
end;

{ TTMSFMXWinWebGMapsWebBrowserService }

procedure TTMSFMXWinWebGMapsWebBrowserService.DeleteCookies;
{$IFDEF USECHROMIUM}
{$IFNDEF DELPHIXE8_LVL}
var
  CookieManager: ICefCookieManager;
{$ENDIF}
{$ENDIF}
begin
  {$IFDEF USECHROMIUM}
  {$IFNDEF DELPHIXE8_LVL}
  CefLoadLibDefault;
  CookieManager := TCefCookieManagerRef.GetGlobalManager;
  CookieManager.VisitAllCookiesProc(
    function(const name, value, domain, path: ustring; secure, httponly,
      hasExpires: Boolean; const creation, lastAccess, expires: TDateTime;
      count, total: Integer; out deleteCookie: Boolean): Boolean
    begin
      deleteCookie := True;
      Result := True;
    end
  );
  {$ENDIF}
{$ENDIF}
{$IFDEF USEFMXWEBBROWSER}
{$ENDIF}
end;

function TTMSFMXWinWebGMapsWebBrowserService.DoCreateWebBrowser(const AValue: TTMSFMXWebGMapsCustomWebBrowser): ITMSFMXWebGMapsCustomWebBrowser;
begin
  Result := TTMSFMXWinWebGMapsWebBrowser.Create(AValue);
end;

{$IFDEF USEFMXWEBBROWSER}
function TTMSFMXWebGMapsWebBrowserEvents._AddRef: Integer;
begin
  Result := 2;
end;

function TTMSFMXWebGMapsWebBrowserEvents._Release: Integer;
begin
  Result := 1;
end;

function TTMSFMXWebGMapsWebBrowserEvents.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Pointer(Obj) := nil;

  if (GetInterface(IID, Obj)) then
    Result := S_OK
  else if (IsEqualIID(IID, FSinkIID)) then
  begin
    if (GetInterface(IDispatch, Obj)) then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end
  else
    Result := E_NOINTERFACE;
end;

function TTMSFMXWebGMapsWebBrowserEvents.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount,
  LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TTMSFMXWebGMapsWebBrowserEvents.GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
begin
  Pointer(TypeInfo) := nil;
  Result := E_NOTIMPL;
end;

function TTMSFMXWebGMapsWebBrowserEvents.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 0;
  Result := S_OK;
end;

function TTMSFMXWebGMapsWebBrowserEvents.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer; Flags: Word;
  var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
var pdpParams: PDispParams;
  lpDispIDs: array[0..63] of TDispID;
  dwCount: Integer;
begin
  pdpParams := @Params;
  if ((Flags and DISPATCH_METHOD) > 0) then
  begin
    ZeroMemory(@lpDispIDs, SizeOf(lpDispIDs));
    if (pdpParams^.cArgs > 0) then
    begin
      for dwCount := 0 to Pred(pdpParams^.cArgs) do lpDispIDs[dwCount] := Pred(pdpParams^.cArgs) - dwCount;
      if (pdpParams^.cNamedArgs > 0) then
      begin
        for dwCount := 0 to Pred(pdpParams^.cNamedArgs) do
          lpDispIDs[pdpParams^.rgdispidNamedArgs^[dwCount]] := dwCount;
      end;
    end;
    Result := S_OK;
    case DispID of
      250: DoBeforeNavigate2(IDispatch(pdpParams^.rgvarg^[lpDispIds[0]].dispval),
          POleVariant(pdpParams^.rgvarg^[lpDispIds[1]].pvarval)^,
          POleVariant(pdpParams^.rgvarg^[lpDispIds[2]].pvarval)^,
          POleVariant(pdpParams^.rgvarg^[lpDispIds[3]].pvarval)^,
          POleVariant(pdpParams^.rgvarg^[lpDispIds[4]].pvarval)^,
          POleVariant(pdpParams^.rgvarg^[lpDispIds[5]].pvarval)^,
          pdpParams^.rgvarg^[lpDispIds[6]].pbool^);
      252: DoNavigateComplete2(IDispatch(pdpParams^.rgvarg^[lpDispIds[0]].dispval),
          POleVariant(pdpParams^.rgvarg^[lpDispIds[1]].pvarval)^);
      253:
        begin
          Disconnect;
        end;
    else
      Result := DISP_E_MEMBERNOTFOUND;
    end;
  end
  else
    Result := DISP_E_MEMBERNOTFOUND;
end;

constructor TTMSFMXWebGMapsWebBrowserEvents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSinkIID := DWebBrowserEvents2;
end;

destructor TTMSFMXWebGMapsWebBrowserEvents.Destroy;
begin
  Disconnect;
  inherited Destroy;
end;

procedure TTMSFMXWebGMapsWebBrowserEvents.ConnectTo(Source: IWebBrowser2);
var
  pvCPC: IConnectionPointContainer;
begin
  Disconnect;
  OleCheck(Source.QueryInterface(IConnectionPointContainer, pvCPC));
  OleCheck(pvCPC.FindConnectionPoint(FSinkIID, FCP));
  OleCheck(FCP.Advise(Self, FCookie));
  FSource := Source;
  FConnected := True;
  pvCPC := nil;
end;

procedure TTMSFMXWebGMapsWebBrowserEvents.Disconnect;
begin
  if Assigned(FSource) then
  begin
    try
      OleCheck(FCP.Unadvise(FCookie));
      FCP := nil;
      FSource := nil;
    except
      Pointer(FCP) := nil;
      Pointer(FSource) := nil;
    end;
  end;

  FConnected := False;
end;

procedure TTMSFMXWebGMapsWebBrowserEvents.DoBeforeNavigate2(const pDisp: IDispatch; var URL: OleVariant; var Flags:
  OleVariant; var TargetFrameName: OleVariant; var PostData: OleVariant; var Headers: OleVariant; var Cancel: WordBool);
begin
  if Assigned(FBeforeNavigate2) then FBeforeNavigate2(Self, pDisp, URL, Flags, TargetFrameName, PostData, Headers, Cancel);
end;

procedure TTMSFMXWebGMapsWebBrowserEvents.DoNavigateComplete2(const pDisp: IDispatch; var URL: OleVariant);
begin
  if Assigned(FNavigateComplete2) then FNavigateComplete2(Self, pDisp, URL);
end;

{ TDocHostUIHandler }

function TDocHostUIHandler.EnableModeless(fEnable: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.FilterDataObject(const pDO: IDataObject;
  out ppDORet: IDataObject): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.GetDropTarget(const pDropTarget: IDropTarget;
  out ppDropTarget: IDropTarget): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.GetExternal(out ppDispatch: IDispatch): HResult;
begin
  Result := S_OK;
end;

function TDocHostUIHandler.GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult;
begin
  if Assigned(FWebBrowser) then
  begin
    FillChar(pInfo, SizeOf(pInfo), 0);
    pInfo.cbSize        := SizeOf(_DOCHOSTUIINFO);
    pInfo.dwFlags := 0;

    if not TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser).ShowScrollBars then
      pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_SCROLL_NO;

    if not TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser).Show3DBorder then
      pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_NO3DBORDER;

    if TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser).EnableAutoComplete then
      pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_ENABLE_FORMS_AUTOCOMPLETE;

    if TTMSFMXWebGMapsCustomWebBrowserProtected(FWebBrowser).ApplyTheme then
      pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_THEME;

    pInfo.dwDoubleClick := 0;
  end;
  Result              := S_OK;
end;

function TDocHostUIHandler.GetOptionKeyPath(out pchKey: PWideChar; dw: UINT): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.HideUI: HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.OnDocWindowActivate(fActivate: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.OnFrameWindowActivate(fActivate: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.ResizeBorder(var prcBorder: tagRECT;
  const pUIWindow: IOleInPlaceUIWindow; fRameWindow: Integer): HResult;
begin
  Result := S_OK;
end;

function TDocHostUIHandler.ShowContextMenu(dwID: UINT; ppt: PtagPOINT;
  const pcmdtReserved: IInterface; const pdispReserved: IDispatch): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.ShowUI(dwID: UINT;
  const pActiveObject: IOleInPlaceActiveObject;
  const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
  const pDoc: IOleInPlaceUIWindow): HResult;
begin
  Result := S_FALSE;
end;

function TDocHostUIHandler.TranslateAccelerator(var lpmsg: tagMSG;
  var pguidCmdGroup: TGUID; nCmdID: UINT): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDocHostUIHandler.TranslateUrl(dwTranslate: UINT; pchURLIn: PWideChar;
  out ppchURLOut: PWideChar): HResult;
begin
  ppchURLOut := nil;
  Result := S_FALSE;
end;

function TDocHostUIHandler.UpdateUI: HResult;
begin
  Result := S_FALSE;
end;

constructor TDocHostUIHandler.Create(AWebBrowser: TTMSFMXWebGMapsCustomWebBrowser);
begin
  inherited Create(AWebBrowser);
  FWebBrowser := AWebBrowser;
end;

{$ENDIF}

{$IFDEF USECHROMIUM}
initialization
  CefCache := 'cache';
{$ENDIF}

end.
