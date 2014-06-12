unit MSXML_TLB;

{ This file contains pascal declarations imported from a type library.
  This file will be written during each import or refresh of the type
  library editor.  Changes to this file will be discarded during the
  refresh process. }

{ Microsoft XML, version 2.0 }
{ Version 2.0 }

{ Conversion log:
  Warning: 'implementation' is a reserved word. IXMLDOMDocument.implementation changed to implementation_
  Warning: 'type' is a reserved word. Parameter 'type' in IXMLDOMDocument.createNode changed to 'type_'
  Warning: 'type' is a reserved word. IXMLElement.type changed to type_
  Warning: 'type' is a reserved word. IXMLElement2.type changed to type_
 }

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

const
  LIBID_MSXML: TGUID = '{D63E0CE2-A0A2-11D0-9C02-00C04FC99C8E}';

const

{ Constants that define a node's type }

{ tagDOMNodeType }

  NODE_INVALID = 0;
  NODE_ELEMENT = 1;
  NODE_ATTRIBUTE = 2;
  NODE_TEXT = 3;
  NODE_CDATA_SECTION = 4;
  NODE_ENTITY_REFERENCE = 5;
  NODE_ENTITY = 6;
  NODE_PROCESSING_INSTRUCTION = 7;
  NODE_COMMENT = 8;
  NODE_DOCUMENT = 9;
  NODE_DOCUMENT_TYPE = 10;
  NODE_DOCUMENT_FRAGMENT = 11;
  NODE_NOTATION = 12;

{ Constants that define types for IXMLElement. }

{ tagXMLEMEM_TYPE }

  XMLELEMTYPE_ELEMENT = 0;
  XMLELEMTYPE_TEXT = 1;
  XMLELEMTYPE_COMMENT = 2;
  XMLELEMTYPE_DOCUMENT = 3;
  XMLELEMTYPE_DTD = 4;
  XMLELEMTYPE_PI = 5;
  XMLELEMTYPE_OTHER = 6;

const

{ Component class GUIDs }
  Class_DOMDocument: TGUID = '{2933BF90-7B36-11D2-B20E-00C04F983E60}';
  Class_DOMFreeThreadedDocument: TGUID = '{2933BF91-7B36-11D2-B20E-00C04F983E60}';
  Class_XMLHTTPRequest: TGUID = '{ED8C108E-4349-11D2-91A4-00C04F7969E8}';
  Class_XMLDSOControl: TGUID = '{550DDA30-0541-11D2-9CA9-0060B0EC3D39}';
  Class_XMLDocument: TGUID = '{CFC399AF-D876-11D0-9C10-00C04FC99C8E}';

type

{ Forward declarations: Interfaces }
  IXMLDOMImplementation = interface;
  IXMLDOMImplementationDisp = dispinterface;
  IXMLDOMNode = interface;
  IXMLDOMNodeDisp = dispinterface;
  IXMLDOMNodeList = interface;
  IXMLDOMNodeListDisp = dispinterface;
  IXMLDOMNamedNodeMap = interface;
  IXMLDOMNamedNodeMapDisp = dispinterface;
  IXMLDOMDocument = interface;
  IXMLDOMDocumentDisp = dispinterface;
  IXMLDOMDocumentType = interface;
  IXMLDOMDocumentTypeDisp = dispinterface;
  IXMLDOMElement = interface;
  IXMLDOMElementDisp = dispinterface;
  IXMLDOMAttribute = interface;
  IXMLDOMAttributeDisp = dispinterface;
  IXMLDOMDocumentFragment = interface;
  IXMLDOMDocumentFragmentDisp = dispinterface;
  IXMLDOMText = interface;
  IXMLDOMTextDisp = dispinterface;
  IXMLDOMCharacterData = interface;
  IXMLDOMCharacterDataDisp = dispinterface;
  IXMLDOMComment = interface;
  IXMLDOMCommentDisp = dispinterface;
  IXMLDOMCDATASection = interface;
  IXMLDOMCDATASectionDisp = dispinterface;
  IXMLDOMProcessingInstruction = interface;
  IXMLDOMProcessingInstructionDisp = dispinterface;
  IXMLDOMEntityReference = interface;
  IXMLDOMEntityReferenceDisp = dispinterface;
  IXMLDOMParseError = interface;
  IXMLDOMParseErrorDisp = dispinterface;
  IXMLDOMNotation = interface;
  IXMLDOMNotationDisp = dispinterface;
  IXMLDOMEntity = interface;
  IXMLDOMEntityDisp = dispinterface;
  IXTLRuntime = interface;
  IXTLRuntimeDisp = dispinterface;
  XMLDOMDocumentEvents = dispinterface;
  IXMLHttpRequest = interface;
  IXMLHttpRequestDisp = dispinterface;
  IXMLDSOControl = interface;
  IXMLDSOControlDisp = dispinterface;
  IXMLElementCollection = interface;
  IXMLElementCollectionDisp = dispinterface;
  IXMLDocument = interface;
  IXMLDocumentDisp = dispinterface;
  IXMLElement = interface;
  IXMLElementDisp = dispinterface;
  IXMLDocument2 = interface;
  IXMLElement2 = interface;
  IXMLElement2Disp = dispinterface;
  IXMLAttribute = interface;
  IXMLAttributeDisp = dispinterface;
  IXMLError = interface;

{ Forward declarations: CoClasses }
  DOMDocument = IXMLDOMDocument;
  DOMFreeThreadedDocument = IXMLDOMDocument;
  XMLHTTPRequest = IXMLHttpRequest;
  XMLDSOControl = IXMLDSOControl;
  XMLDocument = IXMLDocument2;

{ Forward declarations: Enums }
  tagDOMNodeType = TOleEnum;
  tagXMLEMEM_TYPE = TOleEnum;

{ Constants that define a node's type }

  DOMNodeType = tagDOMNodeType;

  _xml_error = record
    _nLine: SYSUINT;
    _pchBuf: WideString;
    _cchBuf: SYSUINT;
    _ich: SYSUINT;
    _pszFound: WideString;
    _pszExpected: WideString;
    _reserved1: UINT;
    _reserved2: UINT;
  end;

{ Constants that define types for IXMLElement. }

  XMLELEM_TYPE = tagXMLEMEM_TYPE;

  IXMLDOMImplementation = interface(IDispatch)
    ['{2933BF8F-7B36-11D2-B20E-00C04F983E60}']
    function hasFeature(const feature, version: WideString): WordBool; safecall;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMImplementation }

  IXMLDOMImplementationDisp = dispinterface
    ['{2933BF8F-7B36-11D2-B20E-00C04F983E60}']
    function hasFeature(const feature, version: WideString): WordBool; dispid 145;
  end;

{ Core DOM node interface }

  IXMLDOMNode = interface(IDispatch)
    ['{2933BF80-7B36-11D2-B20E-00C04F983E60}']
    function Get_nodeName: WideString; safecall;
    function Get_nodeValue: OleVariant; safecall;
    procedure Set_nodeValue(Value: OleVariant); safecall;
    function Get_nodeType: DOMNodeType; safecall;
    function Get_parentNode: IXMLDOMNode; safecall;
    function Get_childNodes: IXMLDOMNodeList; safecall;
    function Get_firstChild: IXMLDOMNode; safecall;
    function Get_lastChild: IXMLDOMNode; safecall;
    function Get_previousSibling: IXMLDOMNode; safecall;
    function Get_nextSibling: IXMLDOMNode; safecall;
    function Get_attributes: IXMLDOMNamedNodeMap; safecall;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; safecall;
    function replaceChild(const newChild, oldChild: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; safecall;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; safecall;
    function hasChildNodes: WordBool; safecall;
    function Get_ownerDocument: IXMLDOMDocument; safecall;
    function cloneNode(deep: WordBool): IXMLDOMNode; safecall;
    function Get_nodeTypeString: WideString; safecall;
    function Get_text: WideString; safecall;
    procedure Set_text(const Value: WideString); safecall;
    function Get_specified: WordBool; safecall;
    function Get_definition: IXMLDOMNode; safecall;
    function Get_nodeTypedValue: OleVariant; safecall;
    procedure Set_nodeTypedValue(Value: OleVariant); safecall;
    function Get_dataType: OleVariant; safecall;
    procedure Set_dataType(Value: OleVariant); safecall;
    function Get_xml: WideString; safecall;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; safecall;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; safecall;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; safecall;
    function Get_parsed: WordBool; safecall;
    function Get_namespaceURI: WideString; safecall;
    function Get_prefix: WideString; safecall;
    function Get_baseName: WideString; safecall;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); safecall;
    property nodeName: WideString read Get_nodeName;
    property nodeValue: OleVariant read Get_nodeValue write Set_nodeValue;
    property nodeType: DOMNodeType read Get_nodeType;
    property parentNode: IXMLDOMNode read Get_parentNode;
    property childNodes: IXMLDOMNodeList read Get_childNodes;
    property firstChild: IXMLDOMNode read Get_firstChild;
    property lastChild: IXMLDOMNode read Get_lastChild;
    property previousSibling: IXMLDOMNode read Get_previousSibling;
    property nextSibling: IXMLDOMNode read Get_nextSibling;
    property attributes: IXMLDOMNamedNodeMap read Get_attributes;
    property ownerDocument: IXMLDOMDocument read Get_ownerDocument;
    property nodeTypeString: WideString read Get_nodeTypeString;
    property text: WideString read Get_text write Set_text;
    property specified: WordBool read Get_specified;
    property definition: IXMLDOMNode read Get_definition;
    property nodeTypedValue: OleVariant read Get_nodeTypedValue write Set_nodeTypedValue;
    property dataType: OleVariant read Get_dataType write Set_dataType;
    property xml: WideString read Get_xml;
    property parsed: WordBool read Get_parsed;
    property namespaceURI: WideString read Get_namespaceURI;
    property prefix: WideString read Get_prefix;
    property baseName: WideString read Get_baseName;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMNode }

  IXMLDOMNodeDisp = dispinterface
    ['{2933BF80-7B36-11D2-B20E-00C04F983E60}']
    property nodeName: WideString readonly dispid 2;
    property nodeValue: OleVariant dispid 3;
    property nodeType: DOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; refChild: OleVariant): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild, oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    function appendChild(const newChild: IXMLDOMNode): IXMLDOMNode; dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    function cloneNode(deep: WordBool): IXMLDOMNode; dispid 19;
    property nodeTypeString: WideString readonly dispid 21;
    property text: WideString dispid 24;
    property specified: WordBool readonly dispid 22;
    property definition: IXMLDOMNode readonly dispid 23;
    property nodeTypedValue: OleVariant dispid 25;
    property dataType: OleVariant dispid 26;
    property xml: WideString readonly dispid 27;
    function transformNode(const stylesheet: IXMLDOMNode): WideString; dispid 28;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 29;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    property parsed: WordBool readonly dispid 31;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString readonly dispid 33;
    property baseName: WideString readonly dispid 34;
    procedure transformNodeToObject(const stylesheet: IXMLDOMNode; outputObject: OleVariant); dispid 35;
  end;

  IXMLDOMNodeList = interface(IDispatch)
    ['{2933BF82-7B36-11D2-B20E-00C04F983E60}']
    function Get_item(index: Integer): IXMLDOMNode; safecall;
    function Get_length: Integer; safecall;
    function nextNode: IXMLDOMNode; safecall;
    procedure reset; safecall;
    function Get__newEnum: IUnknown; safecall;
    property item[index: Integer]: IXMLDOMNode read Get_item; default;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMNodeList }

  IXMLDOMNodeListDisp = dispinterface
    ['{2933BF82-7B36-11D2-B20E-00C04F983E60}']
    property item[index: Integer]: IXMLDOMNode readonly dispid 0; default;
    property length: Integer readonly dispid 74;
    function nextNode: IXMLDOMNode; dispid 76;
    procedure reset; dispid 77;
  end;

  IXMLDOMNamedNodeMap = interface(IDispatch)
    ['{2933BF83-7B36-11D2-B20E-00C04F983E60}']
    function getNamedItem(const name: WideString): IXMLDOMNode; safecall;
    function setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeNamedItem(const name: WideString): IXMLDOMNode; safecall;
    function Get_item(index: Integer): IXMLDOMNode; safecall;
    function Get_length: Integer; safecall;
    function getQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode; safecall;
    function removeQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode; safecall;
    function nextNode: IXMLDOMNode; safecall;
    procedure reset; safecall;
    function Get__newEnum: IUnknown; safecall;
    property item[index: Integer]: IXMLDOMNode read Get_item; default;
    property length: Integer read Get_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMNamedNodeMap }

  IXMLDOMNamedNodeMapDisp = dispinterface
    ['{2933BF83-7B36-11D2-B20E-00C04F983E60}']
    function getNamedItem(const name: WideString): IXMLDOMNode; dispid 83;
    function setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; dispid 84;
    function removeNamedItem(const name: WideString): IXMLDOMNode; dispid 85;
    property item[index: Integer]: IXMLDOMNode readonly dispid 0; default;
    property length: Integer readonly dispid 74;
    function getQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode; dispid 87;
    function removeQualifiedItem(const baseName, namespaceURI: WideString): IXMLDOMNode; dispid 88;
    function nextNode: IXMLDOMNode; dispid 89;
    procedure reset; dispid 90;
  end;

  IXMLDOMDocument = interface(IXMLDOMNode)
    ['{2933BF81-7B36-11D2-B20E-00C04F983E60}']
    function Get_doctype: IXMLDOMDocumentType; safecall;
    function Get_implementation_: IXMLDOMImplementation; safecall;
    function Get_documentElement: IXMLDOMElement; safecall;
    procedure Set_documentElement(var Value: IXMLDOMElement); safecall;
    function createElement(const tagName: WideString): IXMLDOMElement; safecall;
    function createDocumentFragment: IXMLDOMDocumentFragment; safecall;
    function createTextNode(const data: WideString): IXMLDOMText; safecall;
    function createComment(const data: WideString): IXMLDOMComment; safecall;
    function createCDATASection(const data: WideString): IXMLDOMCDATASection; safecall;
    function createProcessingInstruction(const target, data: WideString): IXMLDOMProcessingInstruction; safecall;
    function createAttribute(const name: WideString): IXMLDOMAttribute; safecall;
    function createEntityReference(const name: WideString): IXMLDOMEntityReference; safecall;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
    function createNode(type_: OleVariant; const name, namespaceURI: WideString): IXMLDOMNode; safecall;
    function nodeFromID(const idString: WideString): IXMLDOMNode; safecall;
    function load(xmlSource: OleVariant): WordBool; safecall;
    function Get_readyState: Integer; safecall;
    function Get_parseError: IXMLDOMParseError; safecall;
    function Get_url: WideString; safecall;
    function Get_async: WordBool; safecall;
    procedure Set_async(Value: WordBool); safecall;
    procedure abort; safecall;
    function loadXML(const bstrXML: WideString): WordBool; safecall;
    procedure save(destination: OleVariant); safecall;
    function Get_validateOnParse: WordBool; safecall;
    procedure Set_validateOnParse(Value: WordBool); safecall;
    function Get_resolveExternals: WordBool; safecall;
    procedure Set_resolveExternals(Value: WordBool); safecall;
    function Get_preserveWhiteSpace: WordBool; safecall;
    procedure Set_preserveWhiteSpace(Value: WordBool); safecall;
    procedure Set_onreadystatechange(Value: OleVariant); safecall;
    procedure Set_ondataavailable(Value: OleVariant); safecall;
    procedure Set_ontransformnode(Value: OleVariant); safecall;
    property doctype: IXMLDOMDocumentType read Get_doctype;
    property implementation_: IXMLDOMImplementation read Get_implementation_;
    property documentElement: IXMLDOMElement read Get_documentElement write Set_documentElement;
    property readyState: Integer read Get_readyState;
    property parseError: IXMLDOMParseError read Get_parseError;
    property url: WideString read Get_url;
    property async: WordBool read Get_async write Set_async;
    property validateOnParse: WordBool read Get_validateOnParse write Set_validateOnParse;
    property resolveExternals: WordBool read Get_resolveExternals write Set_resolveExternals;
    property preserveWhiteSpace: WordBool read Get_preserveWhiteSpace write Set_preserveWhiteSpace;
    property onreadystatechange: OleVariant write Set_onreadystatechange;
    property ondataavailable: OleVariant write Set_ondataavailable;
    property ontransformnode: OleVariant write Set_ontransformnode;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMDocument }

  IXMLDOMDocumentDisp = dispinterface
    ['{2933BF81-7B36-11D2-B20E-00C04F983E60}']
    property doctype: IXMLDOMDocumentType readonly dispid 38;
    property implementation_: IXMLDOMImplementation readonly dispid 39;
    property documentElement: IXMLDOMElement dispid 40;
    function createElement(const tagName: WideString): IXMLDOMElement; dispid 41;
    function createDocumentFragment: IXMLDOMDocumentFragment; dispid 42;
    function createTextNode(const data: WideString): IXMLDOMText; dispid 43;
    function createComment(const data: WideString): IXMLDOMComment; dispid 44;
    function createCDATASection(const data: WideString): IXMLDOMCDATASection; dispid 45;
    function createProcessingInstruction(const target, data: WideString): IXMLDOMProcessingInstruction; dispid 46;
    function createAttribute(const name: WideString): IXMLDOMAttribute; dispid 47;
    function createEntityReference(const name: WideString): IXMLDOMEntityReference; dispid 49;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; dispid 50;
    function createNode(type_: OleVariant; const name, namespaceURI: WideString): IXMLDOMNode; dispid 54;
    function nodeFromID(const idString: WideString): IXMLDOMNode; dispid 56;
    function load(xmlSource: OleVariant): WordBool; dispid 58;
    property readyState: Integer readonly dispid -525;
    property parseError: IXMLDOMParseError readonly dispid 59;
    property url: WideString readonly dispid 60;
    property async: WordBool dispid 61;
    procedure abort; dispid 62;
    function loadXML(const bstrXML: WideString): WordBool; dispid 63;
    procedure save(destination: OleVariant); dispid 64;
    property validateOnParse: WordBool dispid 65;
    property resolveExternals: WordBool dispid 66;
    property preserveWhiteSpace: WordBool dispid 67;
    property onreadystatechange: OleVariant writeonly dispid 68;
    property ondataavailable: OleVariant writeonly dispid 69;
    property ontransformnode: OleVariant writeonly dispid 70;
  end;

  IXMLDOMDocumentType = interface(IXMLDOMNode)
    ['{2933BF8B-7B36-11D2-B20E-00C04F983E60}']
    function Get_name: WideString; safecall;
    function Get_entities: IXMLDOMNamedNodeMap; safecall;
    function Get_notations: IXMLDOMNamedNodeMap; safecall;
    property name: WideString read Get_name;
    property entities: IXMLDOMNamedNodeMap read Get_entities;
    property notations: IXMLDOMNamedNodeMap read Get_notations;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMDocumentType }

  IXMLDOMDocumentTypeDisp = dispinterface
    ['{2933BF8B-7B36-11D2-B20E-00C04F983E60}']
    property name: WideString readonly dispid 131;
    property entities: IXMLDOMNamedNodeMap readonly dispid 132;
    property notations: IXMLDOMNamedNodeMap readonly dispid 133;
  end;

  IXMLDOMElement = interface(IXMLDOMNode)
    ['{2933BF86-7B36-11D2-B20E-00C04F983E60}']
    function Get_tagName: WideString; safecall;
    function getAttribute(const name: WideString): OleVariant; safecall;
    procedure setAttribute(const name: WideString; value: OleVariant); safecall;
    procedure removeAttribute(const name: WideString); safecall;
    function getAttributeNode(const name: WideString): IXMLDOMAttribute; safecall;
    function setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    function removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
    procedure normalize; safecall;
    property tagName: WideString read Get_tagName;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMElement }

  IXMLDOMElementDisp = dispinterface
    ['{2933BF86-7B36-11D2-B20E-00C04F983E60}']
    property tagName: WideString readonly dispid 97;
    function getAttribute(const name: WideString): OleVariant; dispid 99;
    procedure setAttribute(const name: WideString; value: OleVariant); dispid 100;
    procedure removeAttribute(const name: WideString); dispid 101;
    function getAttributeNode(const name: WideString): IXMLDOMAttribute; dispid 102;
    function setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 103;
    function removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 104;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; dispid 105;
    procedure normalize; dispid 106;
  end;

  IXMLDOMAttribute = interface(IXMLDOMNode)
    ['{2933BF85-7B36-11D2-B20E-00C04F983E60}']
    function Get_name: WideString; safecall;
    function Get_value: OleVariant; safecall;
    procedure Set_value(Value: OleVariant); safecall;
    property name: WideString read Get_name;
    property value: OleVariant read Get_value write Set_value;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMAttribute }

  IXMLDOMAttributeDisp = dispinterface
    ['{2933BF85-7B36-11D2-B20E-00C04F983E60}']
    property name: WideString readonly dispid 118;
    property value: OleVariant dispid 120;
  end;

  IXMLDOMDocumentFragment = interface(IXMLDOMNode)
    ['{3EFAA413-272F-11D2-836F-0000F87A7782}']
  end;

{ DispInterface declaration for Dual Interface IXMLDOMDocumentFragment }

  IXMLDOMDocumentFragmentDisp = dispinterface
    ['{3EFAA413-272F-11D2-836F-0000F87A7782}']
  end;

  IXMLDOMCharacterData = interface(IXMLDOMNode)
    ['{2933BF84-7B36-11D2-B20E-00C04F983E60}']
    function Get_data: WideString; safecall;
    procedure Set_data(const Value: WideString); safecall;
    function Get_length: Integer; safecall;
    function substringData(offset, count: Integer): WideString; safecall;
    procedure appendData(const data: WideString); safecall;
    procedure insertData(offset: Integer; const data: WideString); safecall;
    procedure deleteData(offset, count: Integer); safecall;
    procedure replaceData(offset, count: Integer; const data: WideString); safecall;
    property data: WideString read Get_data write Set_data;
    property length: Integer read Get_length;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMCharacterData }

  IXMLDOMCharacterDataDisp = dispinterface
    ['{2933BF84-7B36-11D2-B20E-00C04F983E60}']
    property data: WideString dispid 109;
    property length: Integer readonly dispid 110;
    function substringData(offset, count: Integer): WideString; dispid 111;
    procedure appendData(const data: WideString); dispid 112;
    procedure insertData(offset: Integer; const data: WideString); dispid 113;
    procedure deleteData(offset, count: Integer); dispid 114;
    procedure replaceData(offset, count: Integer; const data: WideString); dispid 115;
  end;

  IXMLDOMText = interface(IXMLDOMCharacterData)
    ['{2933BF87-7B36-11D2-B20E-00C04F983E60}']
    function splitText(offset: Integer): IXMLDOMText; safecall;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMText }

  IXMLDOMTextDisp = dispinterface
    ['{2933BF87-7B36-11D2-B20E-00C04F983E60}']
    function splitText(offset: Integer): IXMLDOMText; dispid 123;
  end;

  IXMLDOMComment = interface(IXMLDOMCharacterData)
    ['{2933BF88-7B36-11D2-B20E-00C04F983E60}']
  end;

{ DispInterface declaration for Dual Interface IXMLDOMComment }

  IXMLDOMCommentDisp = dispinterface
    ['{2933BF88-7B36-11D2-B20E-00C04F983E60}']
  end;

  IXMLDOMCDATASection = interface(IXMLDOMText)
    ['{2933BF8A-7B36-11D2-B20E-00C04F983E60}']
  end;

{ DispInterface declaration for Dual Interface IXMLDOMCDATASection }

  IXMLDOMCDATASectionDisp = dispinterface
    ['{2933BF8A-7B36-11D2-B20E-00C04F983E60}']
  end;

  IXMLDOMProcessingInstruction = interface(IXMLDOMNode)
    ['{2933BF89-7B36-11D2-B20E-00C04F983E60}']
    function Get_target: WideString; safecall;
    function Get_data: WideString; safecall;
    procedure Set_data(const Value: WideString); safecall;
    property target: WideString read Get_target;
    property data: WideString read Get_data write Set_data;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMProcessingInstruction }

  IXMLDOMProcessingInstructionDisp = dispinterface
    ['{2933BF89-7B36-11D2-B20E-00C04F983E60}']
    property target: WideString readonly dispid 127;
    property data: WideString dispid 128;
  end;

  IXMLDOMEntityReference = interface(IXMLDOMNode)
    ['{2933BF8E-7B36-11D2-B20E-00C04F983E60}']
  end;

{ DispInterface declaration for Dual Interface IXMLDOMEntityReference }

  IXMLDOMEntityReferenceDisp = dispinterface
    ['{2933BF8E-7B36-11D2-B20E-00C04F983E60}']
  end;

{ structure for reporting parser errors }

  IXMLDOMParseError = interface(IDispatch)
    ['{3EFAA426-272F-11D2-836F-0000F87A7782}']
    function Get_errorCode: Integer; safecall;
    function Get_url: WideString; safecall;
    function Get_reason: WideString; safecall;
    function Get_srcText: WideString; safecall;
    function Get_line: Integer; safecall;
    function Get_linepos: Integer; safecall;
    function Get_filepos: Integer; safecall;
    property errorCode: Integer read Get_errorCode;
    property url: WideString read Get_url;
    property reason: WideString read Get_reason;
    property srcText: WideString read Get_srcText;
    property line: Integer read Get_line;
    property linepos: Integer read Get_linepos;
    property filepos: Integer read Get_filepos;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMParseError }

  IXMLDOMParseErrorDisp = dispinterface
    ['{3EFAA426-272F-11D2-836F-0000F87A7782}']
    property errorCode: Integer readonly dispid 0;
    property url: WideString readonly dispid 179;
    property reason: WideString readonly dispid 180;
    property srcText: WideString readonly dispid 181;
    property line: Integer readonly dispid 182;
    property linepos: Integer readonly dispid 183;
    property filepos: Integer readonly dispid 184;
  end;

  IXMLDOMNotation = interface(IXMLDOMNode)
    ['{2933BF8C-7B36-11D2-B20E-00C04F983E60}']
    function Get_publicId: OleVariant; safecall;
    function Get_systemId: OleVariant; safecall;
    property publicId: OleVariant read Get_publicId;
    property systemId: OleVariant read Get_systemId;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMNotation }

  IXMLDOMNotationDisp = dispinterface
    ['{2933BF8C-7B36-11D2-B20E-00C04F983E60}']
    property publicId: OleVariant readonly dispid 136;
    property systemId: OleVariant readonly dispid 137;
  end;

  IXMLDOMEntity = interface(IXMLDOMNode)
    ['{2933BF8D-7B36-11D2-B20E-00C04F983E60}']
    function Get_publicId: OleVariant; safecall;
    function Get_systemId: OleVariant; safecall;
    function Get_notationName: WideString; safecall;
    property publicId: OleVariant read Get_publicId;
    property systemId: OleVariant read Get_systemId;
    property notationName: WideString read Get_notationName;
  end;

{ DispInterface declaration for Dual Interface IXMLDOMEntity }

  IXMLDOMEntityDisp = dispinterface
    ['{2933BF8D-7B36-11D2-B20E-00C04F983E60}']
    property publicId: OleVariant readonly dispid 140;
    property systemId: OleVariant readonly dispid 141;
    property notationName: WideString readonly dispid 142;
  end;

{ XTL runtime object }

  IXTLRuntime = interface(IXMLDOMNode)
    ['{3EFAA425-272F-11D2-836F-0000F87A7782}']
    function uniqueID(const pNode: IXMLDOMNode): Integer; safecall;
    function depth(const pNode: IXMLDOMNode): Integer; safecall;
    function childNumber(const pNode: IXMLDOMNode): Integer; safecall;
    function ancestorChildNumber(const bstrNodeName: WideString; const pNode: IXMLDOMNode): Integer; safecall;
    function absoluteChildNumber(const pNode: IXMLDOMNode): Integer; safecall;
    function formatIndex(lIndex: Integer; const bstrFormat: WideString): WideString; safecall;
    function formatNumber(dblNumber: Double; const bstrFormat: WideString): WideString; safecall;
    function formatDate(varDate: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; safecall;
    function formatTime(varTime: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; safecall;
  end;

{ DispInterface declaration for Dual Interface IXTLRuntime }

  IXTLRuntimeDisp = dispinterface
    ['{3EFAA425-272F-11D2-836F-0000F87A7782}']
    function uniqueID(const pNode: IXMLDOMNode): Integer; dispid 187;
    function depth(const pNode: IXMLDOMNode): Integer; dispid 188;
    function childNumber(const pNode: IXMLDOMNode): Integer; dispid 189;
    function ancestorChildNumber(const bstrNodeName: WideString; const pNode: IXMLDOMNode): Integer; dispid 190;
    function absoluteChildNumber(const pNode: IXMLDOMNode): Integer; dispid 191;
    function formatIndex(lIndex: Integer; const bstrFormat: WideString): WideString; dispid 192;
    function formatNumber(dblNumber: Double; const bstrFormat: WideString): WideString; dispid 193;
    function formatDate(varDate: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; dispid 194;
    function formatTime(varTime: OleVariant; const bstrFormat: WideString; varDestLocale: OleVariant): WideString; dispid 195;
  end;

  XMLDOMDocumentEvents = dispinterface
    ['{3EFAA427-272F-11D2-836F-0000F87A7782}']
    procedure ondataavailable; dispid 198;
    procedure onreadystatechange; dispid -609;
  end;

{ IXMLHttpRequest Interface }

  IXMLHttpRequest = interface(IDispatch)
    ['{ED8C108D-4349-11D2-91A4-00C04F7969E8}']
    procedure open(const bstrMethod, bstrUrl: WideString; varAsync, bstrUser, bstrPassword: OleVariant); safecall;
    procedure setRequestHeader(const bstrHeader, bstrValue: WideString); safecall;
    function getResponseHeader(const bstrHeader: WideString): WideString; safecall;
    function getAllResponseHeaders: WideString; safecall;
    procedure send(varBody: OleVariant); safecall;
    procedure abort; safecall;
    function Get_status: Integer; safecall;
    function Get_statusText: WideString; safecall;
    function Get_responseXML: IDispatch; safecall;
    function Get_responseText: WideString; safecall;
    function Get_responseBody: OleVariant; safecall;
    function Get_responseStream: OleVariant; safecall;
    function Get_readyState: Integer; safecall;
    procedure Set_onreadystatechange(Value: IDispatch); safecall;
    property status: Integer read Get_status;
    property statusText: WideString read Get_statusText;
    property responseXML: IDispatch read Get_responseXML;
    property responseText: WideString read Get_responseText;
    property responseBody: OleVariant read Get_responseBody;
    property responseStream: OleVariant read Get_responseStream;
    property readyState: Integer read Get_readyState;
    property onreadystatechange: IDispatch write Set_onreadystatechange;
  end;

{ DispInterface declaration for Dual Interface IXMLHttpRequest }

  IXMLHttpRequestDisp = dispinterface
    ['{ED8C108D-4349-11D2-91A4-00C04F7969E8}']
    procedure open(const bstrMethod, bstrUrl: WideString; varAsync, bstrUser, bstrPassword: OleVariant); dispid 1;
    procedure setRequestHeader(const bstrHeader, bstrValue: WideString); dispid 2;
    function getResponseHeader(const bstrHeader: WideString): WideString; dispid 3;
    function getAllResponseHeaders: WideString; dispid 4;
    procedure send(varBody: OleVariant); dispid 5;
    procedure abort; dispid 6;
    property status: Integer readonly dispid 7;
    property statusText: WideString readonly dispid 8;
    property responseXML: IDispatch readonly dispid 9;
    property responseText: WideString readonly dispid 10;
    property responseBody: OleVariant readonly dispid 11;
    property responseStream: OleVariant readonly dispid 12;
    property readyState: Integer readonly dispid 13;
    property onreadystatechange: IDispatch writeonly dispid 14;
  end;

{ XML DSO Control }

  IXMLDSOControl = interface(IDispatch)
    ['{310AFA62-0575-11D2-9CA9-0060B0EC3D39}']
    function Get_XMLDocument: IXMLDOMDocument; safecall;
    procedure Set_XMLDocument(const Value: IXMLDOMDocument); safecall;
    function Get_JavaDSOCompatible: Integer; safecall;
    procedure Set_JavaDSOCompatible(Value: Integer); safecall;
    function Get_readyState: Integer; safecall;
    property XMLDocument: IXMLDOMDocument read Get_XMLDocument write Set_XMLDocument;
    property JavaDSOCompatible: Integer read Get_JavaDSOCompatible write Set_JavaDSOCompatible;
    property readyState: Integer read Get_readyState;
  end;

{ DispInterface declaration for Dual Interface IXMLDSOControl }

  IXMLDSOControlDisp = dispinterface
    ['{310AFA62-0575-11D2-9CA9-0060B0EC3D39}']
    property XMLDocument: IXMLDOMDocument dispid 65537;
    property JavaDSOCompatible: Integer dispid 65538;
    property readyState: Integer readonly dispid -525;
  end;

{ IXMLElementCollection helps to enumerate through a XML document tree. }

  IXMLElementCollection = interface(IDispatch)
    ['{65725580-9B5D-11D0-9BFE-00C04FC99C8E}']
    procedure Set_length(Value: Integer); safecall;
    function Get_length: Integer; safecall;
    function Get__newEnum: IUnknown; safecall;
    function item(var1, var2: OleVariant): IDispatch; safecall;
    property length: Integer read Get_length write Set_length;
    property _newEnum: IUnknown read Get__newEnum;
  end;

{ DispInterface declaration for Dual Interface IXMLElementCollection }

  IXMLElementCollectionDisp = dispinterface
    ['{65725580-9B5D-11D0-9BFE-00C04FC99C8E}']
    function item(var1, var2: OleVariant): IDispatch; dispid 65539;
  end;

{ IXMLDocument loads and saves XML document. This is obsolete. You should use IDOMDocument or IXMLDOMDocument. }

  IXMLDocument = interface(IDispatch)
    ['{F52E2B61-18A1-11D1-B105-00805F49916B}']
    function Get_root: IXMLElement; safecall;
    function Get_fileSize: WideString; safecall;
    function Get_fileModifiedDate: WideString; safecall;
    function Get_fileUpdatedDate: WideString; safecall;
    function Get_url: WideString; safecall;
    procedure Set_url(const Value: WideString); safecall;
    function Get_mimeType: WideString; safecall;
    function Get_readyState: Integer; safecall;
    function Get_charset: WideString; safecall;
    procedure Set_charset(const Value: WideString); safecall;
    function Get_version: WideString; safecall;
    function Get_doctype: WideString; safecall;
    function Get_dtdURL: WideString; safecall;
    function createElement(vType, var1: OleVariant): IXMLElement; safecall;
    property root: IXMLElement read Get_root;
    property fileSize: WideString read Get_fileSize;
    property fileModifiedDate: WideString read Get_fileModifiedDate;
    property fileUpdatedDate: WideString read Get_fileUpdatedDate;
    property url: WideString read Get_url write Set_url;
    property mimeType: WideString read Get_mimeType;
    property readyState: Integer read Get_readyState;
    property charset: WideString read Get_charset write Set_charset;
    property version: WideString read Get_version;
    property doctype: WideString read Get_doctype;
    property dtdURL: WideString read Get_dtdURL;
  end;

{ DispInterface declaration for Dual Interface IXMLDocument }

  IXMLDocumentDisp = dispinterface
    ['{F52E2B61-18A1-11D1-B105-00805F49916B}']
    property root: IXMLElement readonly dispid 65637;
    property url: WideString dispid 65641;
    property readyState: Integer readonly dispid 65643;
    property charset: WideString dispid 65645;
    property version: WideString readonly dispid 65646;
    property doctype: WideString readonly dispid 65647;
    function createElement(vType, var1: OleVariant): IXMLElement; dispid 65644;
  end;

{ IXMLElement represents an element in the XML document tree. }

  IXMLElement = interface(IDispatch)
    ['{3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}']
    function Get_tagName: WideString; safecall;
    procedure Set_tagName(const Value: WideString); safecall;
    function Get_parent: IXMLElement; safecall;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); safecall;
    function getAttribute(const strPropertyName: WideString): OleVariant; safecall;
    procedure removeAttribute(const strPropertyName: WideString); safecall;
    function Get_children: IXMLElementCollection; safecall;
    function Get_type_: Integer; safecall;
    function Get_text: WideString; safecall;
    procedure Set_text(const Value: WideString); safecall;
    procedure addChild(const pChildElem: IXMLElement; lIndex, lReserved: Integer); safecall;
    procedure removeChild(const pChildElem: IXMLElement); safecall;
    property tagName: WideString read Get_tagName write Set_tagName;
    property parent: IXMLElement read Get_parent;
    property children: IXMLElementCollection read Get_children;
    property type_: Integer read Get_type_;
    property text: WideString read Get_text write Set_text;
  end;

{ DispInterface declaration for Dual Interface IXMLElement }

  IXMLElementDisp = dispinterface
    ['{3F7F31AC-E15F-11D0-9C25-00C04FC99C8E}']
    property tagName: WideString dispid 65737;
    property parent: IXMLElement readonly dispid 65738;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); dispid 65739;
    function getAttribute(const strPropertyName: WideString): OleVariant; dispid 65740;
    procedure removeAttribute(const strPropertyName: WideString); dispid 65741;
    property children: IXMLElementCollection readonly dispid 65742;
    property type_: Integer readonly dispid 65743;
    property text: WideString dispid 65744;
    procedure addChild(const pChildElem: IXMLElement; lIndex, lReserved: Integer); dispid 65745;
    procedure removeChild(const pChildElem: IXMLElement); dispid 65746;
  end;

  IXMLDocument2 = interface(IDispatch)
    ['{2B8DE2FE-8D2D-11D1-B2FC-00C04FD915A9}']
    function Get_root: IXMLElement2; safecall;
    function Get_fileSize: WideString; safecall;
    function Get_fileModifiedDate: WideString; safecall;
    function Get_fileUpdatedDate: WideString; safecall;
    function Get_url: WideString; safecall;
    procedure Set_url(const Value: WideString); safecall;
    function Get_mimeType: WideString; safecall;
    function Get_readyState: Integer; safecall;
    function Get_charset: WideString; safecall;
    procedure Set_charset(const Value: WideString); safecall;
    function Get_version: WideString; safecall;
    function Get_doctype: WideString; safecall;
    function Get_dtdURL: WideString; safecall;
    function createElement(vType, var1: OleVariant): IXMLElement2; safecall;
    function Get_async: WordBool; safecall;
    procedure Set_async(Value: WordBool); safecall;
    property root: IXMLElement2 read Get_root;
    property fileSize: WideString read Get_fileSize;
    property fileModifiedDate: WideString read Get_fileModifiedDate;
    property fileUpdatedDate: WideString read Get_fileUpdatedDate;
    property url: WideString read Get_url write Set_url;
    property mimeType: WideString read Get_mimeType;
    property readyState: Integer read Get_readyState;
    property charset: WideString read Get_charset write Set_charset;
    property version: WideString read Get_version;
    property doctype: WideString read Get_doctype;
    property dtdURL: WideString read Get_dtdURL;
    property async: WordBool read Get_async write Set_async;
  end;

{ IXMLElement2 extends IXMLElement. }

  IXMLElement2 = interface(IDispatch)
    ['{2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}']
    function Get_tagName: WideString; safecall;
    procedure Set_tagName(const Value: WideString); safecall;
    function Get_parent: IXMLElement2; safecall;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); safecall;
    function getAttribute(const strPropertyName: WideString): OleVariant; safecall;
    procedure removeAttribute(const strPropertyName: WideString); safecall;
    function Get_children: IXMLElementCollection; safecall;
    function Get_type_: Integer; safecall;
    function Get_text: WideString; safecall;
    procedure Set_text(const Value: WideString); safecall;
    procedure addChild(const pChildElem: IXMLElement2; lIndex, lReserved: Integer); safecall;
    procedure removeChild(const pChildElem: IXMLElement2); safecall;
    function Get_attributes: IXMLElementCollection; safecall;
    property tagName: WideString read Get_tagName write Set_tagName;
    property parent: IXMLElement2 read Get_parent;
    property children: IXMLElementCollection read Get_children;
    property type_: Integer read Get_type_;
    property text: WideString read Get_text write Set_text;
    property attributes: IXMLElementCollection read Get_attributes;
  end;

{ DispInterface declaration for Dual Interface IXMLElement2 }

  IXMLElement2Disp = dispinterface
    ['{2B8DE2FF-8D2D-11D1-B2FC-00C04FD915A9}']
    property tagName: WideString dispid 65737;
    property parent: IXMLElement2 readonly dispid 65738;
    procedure setAttribute(const strPropertyName: WideString; PropertyValue: OleVariant); dispid 65739;
    function getAttribute(const strPropertyName: WideString): OleVariant; dispid 65740;
    procedure removeAttribute(const strPropertyName: WideString); dispid 65741;
    property children: IXMLElementCollection readonly dispid 65742;
    property type_: Integer readonly dispid 65743;
    property text: WideString dispid 65744;
    procedure addChild(const pChildElem: IXMLElement2; lIndex, lReserved: Integer); dispid 65745;
    procedure removeChild(const pChildElem: IXMLElement2); dispid 65746;
    property attributes: IXMLElementCollection readonly dispid 65747;
  end;

{ IXMLAttribute allows to get attributes of an IXMLElement. }

  IXMLAttribute = interface(IDispatch)
    ['{D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}']
    function Get_name: WideString; safecall;
    function Get_value: WideString; safecall;
    property name: WideString read Get_name;
    property value: WideString read Get_value;
  end;

{ DispInterface declaration for Dual Interface IXMLAttribute }

  IXMLAttributeDisp = dispinterface
    ['{D4D4A0FC-3B73-11D1-B2B4-00C04FB92596}']
    property name: WideString readonly dispid 65937;
    property value: WideString readonly dispid 65938;
  end;

{ Gets error info. }

  IXMLError = interface(IUnknown)
    ['{948C5AD3-C58D-11D0-9C0B-00C04FC99C8E}']
    procedure GetErrorInfo(var pErrorReturn: _xml_error); safecall;
  end;

{ W3C-DOM XML Document }

  CoDOMDocument = class
    class function Create: IXMLDOMDocument;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument;
  end;

{ W3C-DOM XML Document (Apartment) }

  CoDOMFreeThreadedDocument = class
    class function Create: IXMLDOMDocument;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument;
  end;

{ XML HTTP Request class. }

  CoXMLHTTPRequest = class
    class function Create: IXMLHttpRequest;
    class function CreateRemote(const MachineName: string): IXMLHttpRequest;
  end;

{ XML Data Source Object }

  CoXMLDSOControl = class
    class function Create: IXMLDSOControl;
    class function CreateRemote(const MachineName: string): IXMLDSOControl;
  end;

{ XMLDocument extends IXML Document.  It is obsolete.  You should use DOMDocument.  This object should not be confused with the XMLDocument property on the XML data island. }

  CoXMLDocument = class
    class function Create: IXMLDocument2;
    class function CreateRemote(const MachineName: string): IXMLDocument2;
  end;



implementation

uses ComObj;

class function CoDOMDocument.Create: IXMLDOMDocument;
begin
  Result := CreateComObject(Class_DOMDocument) as IXMLDOMDocument;
end;

class function CoDOMDocument.CreateRemote(const MachineName: string): IXMLDOMDocument;
begin
  Result := CreateRemoteComObject(MachineName, Class_DOMDocument) as IXMLDOMDocument;
end;

class function CoDOMFreeThreadedDocument.Create: IXMLDOMDocument;
begin
  Result := CreateComObject(Class_DOMFreeThreadedDocument) as IXMLDOMDocument;
end;

class function CoDOMFreeThreadedDocument.CreateRemote(const MachineName: string): IXMLDOMDocument;
begin
  Result := CreateRemoteComObject(MachineName, Class_DOMFreeThreadedDocument) as IXMLDOMDocument;
end;

class function CoXMLHTTPRequest.Create: IXMLHttpRequest;
begin
  Result := CreateComObject(Class_XMLHTTPRequest) as IXMLHttpRequest;
end;

class function CoXMLHTTPRequest.CreateRemote(const MachineName: string): IXMLHttpRequest;
begin
  Result := CreateRemoteComObject(MachineName, Class_XMLHTTPRequest) as IXMLHttpRequest;
end;

class function CoXMLDSOControl.Create: IXMLDSOControl;
begin
  Result := CreateComObject(Class_XMLDSOControl) as IXMLDSOControl;
end;

class function CoXMLDSOControl.CreateRemote(const MachineName: string): IXMLDSOControl;
begin
  Result := CreateRemoteComObject(MachineName, Class_XMLDSOControl) as IXMLDSOControl;
end;

class function CoXMLDocument.Create: IXMLDocument2;
begin
  Result := CreateComObject(Class_XMLDocument) as IXMLDocument2;
end;

class function CoXMLDocument.CreateRemote(const MachineName: string): IXMLDocument2;
begin
  Result := CreateRemoteComObject(MachineName, Class_XMLDocument) as IXMLDocument2;
end;


end.
