
{**************************************************************************************}
{                                                                                      }
{                                   XML Data Binding                                   }
{                                                                                      }
{         Generated on: 13.11.2019 19:47:30                                            }
{       Generated from: D:\Work\Project\XML\ORDERS_+_ORDRSP_+_DESADV_+_IFTMIN_1_.xml   }
{   Settings stored in: D:\Work\Project\XML\ORDERS_+_ORDRSP_+_DESADV_+_IFTMIN_1_.xdb   }
{                                                                                      }
{**************************************************************************************}

unit EdiFozzyXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDocumentType = interface;
  IXMLMetaType = interface;
  IXMLDocumentstatisticType = interface;
  IXMLSettingsType = interface;
  IXMLConfigitemsetType = interface;
  IXMLConfigitemType = interface;
  IXMLConfigitemTypeList = interface;
  IXMLConfigitemmapindexedType = interface;
  IXMLConfigitemmapentryType = interface;
  IXMLScriptsType = interface;
  IXMLScriptType = interface;
  IXMLLibrariesType = interface;
  IXMLFontfacedeclsType = interface;
  IXMLFontfaceType = interface;
  IXMLStylesType = interface;
  IXMLDefaultstyleType = interface;
  IXMLParagraphpropertiesType = interface;
  IXMLTextpropertiesType = interface;
  IXMLNumberstyleType = interface;
  IXMLNumberType = interface;
  IXMLStyleType = interface;
  IXMLStyleTypeList = interface;
  IXMLTablecellpropertiesType = interface;
  IXMLTablecolumnpropertiesType = interface;
  IXMLTablerowpropertiesType = interface;
  IXMLTablepropertiesType = interface;
  IXMLAutomaticstylesType = interface;
  IXMLTextstyleType = interface;
  IXMLPagelayoutType = interface;
  IXMLPagelayoutTypeList = interface;
  IXMLPagelayoutpropertiesType = interface;
  IXMLHeaderstyleType = interface;
  IXMLHeaderfooterpropertiesType = interface;
  IXMLFooterstyleType = interface;
  IXMLMasterstylesType = interface;
  IXMLMasterpageType = interface;
  IXMLHeaderType = interface;
  IXMLPType = interface;
  IXMLDateType = interface;
  IXMLTimeType = interface;
  IXMLRegionleftType = interface;
  IXMLRegionrightType = interface;
  IXMLHeaderleftType = interface;
  IXMLFooterType = interface;
  IXMLFooterleftType = interface;
  IXMLBodyType = interface;
  IXMLSpreadsheetType = interface;
  IXMLCalculationsettingsType = interface;
  IXMLTableType = interface;
  IXMLTablecolumnType = interface;
  IXMLTablecolumnTypeList = interface;
  IXMLTablerowType = interface;
  IXMLTablerowTypeList = interface;
  IXMLTablecellType = interface;
  IXMLTablecellTypeList = interface;
  IXMLCoveredtablecellType = interface;
  IXMLStyleType2 = interface;
  IXMLHeaderfooterpropertiesType2 = interface;
  IXMLTablecellType2 = interface;

{ IXMLDocumentType }

  IXMLDocumentType = interface(IXMLNode)
    ['{3F7C0DDA-583D-42F7-9314-A117B03C937F}']
    { Property Accessors }
    function Get_Version: UnicodeString;
    function Get_Mimetype: UnicodeString;
    function Get_Meta: IXMLMetaType;
    function Get_Settings: IXMLSettingsType;
    function Get_Scripts: IXMLScriptsType;
    function Get_Fontfacedecls: IXMLFontfacedeclsType;
    function Get_Styles: IXMLStylesType;
    function Get_Automaticstyles: IXMLAutomaticstylesType;
    function Get_Masterstyles: IXMLMasterstylesType;
    function Get_Body: IXMLBodyType;
    procedure Set_Version(Value: UnicodeString);
    procedure Set_Mimetype(Value: UnicodeString);
    { Methods & Properties }
    property Version: UnicodeString read Get_Version write Set_Version;
    property Mimetype: UnicodeString read Get_Mimetype write Set_Mimetype;
    property Meta: IXMLMetaType read Get_Meta;
    property Settings: IXMLSettingsType read Get_Settings;
    property Scripts: IXMLScriptsType read Get_Scripts;
    property Fontfacedecls: IXMLFontfacedeclsType read Get_Fontfacedecls;
    property Styles: IXMLStylesType read Get_Styles;
    property Automaticstyles: IXMLAutomaticstylesType read Get_Automaticstyles;
    property Masterstyles: IXMLMasterstylesType read Get_Masterstyles;
    property Body: IXMLBodyType read Get_Body;
  end;

{ IXMLMetaType }

  IXMLMetaType = interface(IXMLNode)
    ['{62D1DBC1-CC4D-4B09-B59C-7AC54F30AB90}']
    { Property Accessors }
    function Get_Creationdate: UnicodeString;
    function Get_Date: UnicodeString;
    function Get_Editingduration: UnicodeString;
    function Get_Editingcycles: Integer;
    function Get_Generator: UnicodeString;
    function Get_Documentstatistic: IXMLDocumentstatisticType;
    procedure Set_Creationdate(Value: UnicodeString);
    procedure Set_Date(Value: UnicodeString);
    procedure Set_Editingduration(Value: UnicodeString);
    procedure Set_Editingcycles(Value: Integer);
    procedure Set_Generator(Value: UnicodeString);
    { Methods & Properties }
    property Creationdate: UnicodeString read Get_Creationdate write Set_Creationdate;
    property Date: UnicodeString read Get_Date write Set_Date;
    property Editingduration: UnicodeString read Get_Editingduration write Set_Editingduration;
    property Editingcycles: Integer read Get_Editingcycles write Set_Editingcycles;
    property Generator: UnicodeString read Get_Generator write Set_Generator;
    property Documentstatistic: IXMLDocumentstatisticType read Get_Documentstatistic;
  end;

{ IXMLDocumentstatisticType }

  IXMLDocumentstatisticType = interface(IXMLNode)
    ['{B946B23D-03E7-4F77-9AEB-7BB87497AD5A}']
    { Property Accessors }
    function Get_Tablecount: Integer;
    function Get_Cellcount: Integer;
    function Get_Objectcount: Integer;
    procedure Set_Tablecount(Value: Integer);
    procedure Set_Cellcount(Value: Integer);
    procedure Set_Objectcount(Value: Integer);
    { Methods & Properties }
    property Tablecount: Integer read Get_Tablecount write Set_Tablecount;
    property Cellcount: Integer read Get_Cellcount write Set_Cellcount;
    property Objectcount: Integer read Get_Objectcount write Set_Objectcount;
  end;

{ IXMLSettingsType }

  IXMLSettingsType = interface(IXMLNodeCollection)
    ['{1AB0C7EC-CE27-40D6-B510-DFF90DDD65AF}']
    { Property Accessors }
    function Get_Configitemset(Index: Integer): IXMLConfigitemsetType;
    { Methods & Properties }
    function Add: IXMLConfigitemsetType;
    function Insert(const Index: Integer): IXMLConfigitemsetType;
    property Configitemset[Index: Integer]: IXMLConfigitemsetType read Get_Configitemset; default;
  end;

{ IXMLConfigitemsetType }

  IXMLConfigitemsetType = interface(IXMLNode)
    ['{686576B6-D793-4FE0-B99C-8B03824CF1FD}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Configitem: IXMLConfigitemTypeList;
    function Get_Configitemmapindexed: IXMLConfigitemmapindexedType;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Configitem: IXMLConfigitemTypeList read Get_Configitem;
    property Configitemmapindexed: IXMLConfigitemmapindexedType read Get_Configitemmapindexed;
  end;

{ IXMLConfigitemType }

  IXMLConfigitemType = interface(IXMLNode)
    ['{2E69B035-2F19-460E-8CD6-1BA7DDDD51B2}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
  end;

{ IXMLConfigitemTypeList }

  IXMLConfigitemTypeList = interface(IXMLNodeCollection)
    ['{C7F56D81-5CF5-4549-BDE7-82ED2A599309}']
    { Methods & Properties }
    function Add: IXMLConfigitemType;
    function Insert(const Index: Integer): IXMLConfigitemType;

    function Get_Item(Index: Integer): IXMLConfigitemType;
    property Items[Index: Integer]: IXMLConfigitemType read Get_Item; default;
  end;

{ IXMLConfigitemmapindexedType }

  IXMLConfigitemmapindexedType = interface(IXMLNode)
    ['{8ADAC894-5AE9-41A9-87FC-A18BF0167F6A}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Configitemmapentry: IXMLConfigitemmapentryType;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Configitemmapentry: IXMLConfigitemmapentryType read Get_Configitemmapentry;
  end;

{ IXMLConfigitemmapentryType }

  IXMLConfigitemmapentryType = interface(IXMLNodeCollection)
    ['{1ECE9B09-94FE-4F25-A6FD-21F90A35FDFA}']
    { Property Accessors }
    function Get_Configitem(Index: Integer): IXMLConfigitemType;
    { Methods & Properties }
    function Add: IXMLConfigitemType;
    function Insert(const Index: Integer): IXMLConfigitemType;
    property Configitem[Index: Integer]: IXMLConfigitemType read Get_Configitem; default;
  end;

{ IXMLScriptsType }

  IXMLScriptsType = interface(IXMLNode)
    ['{6DA5A21B-D986-4500-89E8-E9A567DDC39F}']
    { Property Accessors }
    function Get_Script: IXMLScriptType;
    { Methods & Properties }
    property Script: IXMLScriptType read Get_Script;
  end;

{ IXMLScriptType }

  IXMLScriptType = interface(IXMLNode)
    ['{CB213DAC-B850-4C4E-93F4-B67EBCAB5CDB}']
    { Property Accessors }
    function Get_Language: UnicodeString;
    function Get_Libraries: IXMLLibrariesType;
    procedure Set_Language(Value: UnicodeString);
    { Methods & Properties }
    property Language: UnicodeString read Get_Language write Set_Language;
    property Libraries: IXMLLibrariesType read Get_Libraries;
  end;

{ IXMLLibrariesType }

  IXMLLibrariesType = interface(IXMLNode)
    ['{01227AD4-99E7-4C33-8C41-99A53FF98ADA}']
  end;

{ IXMLFontfacedeclsType }

  IXMLFontfacedeclsType = interface(IXMLNodeCollection)
    ['{0E63568F-76E2-449D-913F-5F04ACE7913C}']
    { Property Accessors }
    function Get_Fontface(Index: Integer): IXMLFontfaceType;
    { Methods & Properties }
    function Add: IXMLFontfaceType;
    function Insert(const Index: Integer): IXMLFontfaceType;
    property Fontface[Index: Integer]: IXMLFontfaceType read Get_Fontface; default;
  end;

{ IXMLFontfaceType }

  IXMLFontfaceType = interface(IXMLNode)
    ['{9ED38899-E3DA-442E-84F5-E4C45EA238CE}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Fontfamily: UnicodeString;
    function Get_Fontfamilygeneric: UnicodeString;
    function Get_Fontpitch: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Fontfamily(Value: UnicodeString);
    procedure Set_Fontfamilygeneric(Value: UnicodeString);
    procedure Set_Fontpitch(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Fontfamily: UnicodeString read Get_Fontfamily write Set_Fontfamily;
    property Fontfamilygeneric: UnicodeString read Get_Fontfamilygeneric write Set_Fontfamilygeneric;
    property Fontpitch: UnicodeString read Get_Fontpitch write Set_Fontpitch;
  end;

{ IXMLStylesType }

  IXMLStylesType = interface(IXMLNode)
    ['{2B018964-785C-4D69-8B37-7627A9980080}']
    { Property Accessors }
    function Get_Defaultstyle: IXMLDefaultstyleType;
    function Get_Numberstyle: IXMLNumberstyleType;
    function Get_Style: IXMLStyleTypeList;
    { Methods & Properties }
    property Defaultstyle: IXMLDefaultstyleType read Get_Defaultstyle;
    property Numberstyle: IXMLNumberstyleType read Get_Numberstyle;
    property Style: IXMLStyleTypeList read Get_Style;
  end;

{ IXMLDefaultstyleType }

  IXMLDefaultstyleType = interface(IXMLNode)
    ['{279C7642-6326-4E1A-B87C-CDF0C24910EB}']
    { Property Accessors }
    function Get_Family: UnicodeString;
    function Get_Paragraphproperties: IXMLParagraphpropertiesType;
    function Get_Textproperties: IXMLTextpropertiesType;
    procedure Set_Family(Value: UnicodeString);
    { Methods & Properties }
    property Family: UnicodeString read Get_Family write Set_Family;
    property Paragraphproperties: IXMLParagraphpropertiesType read Get_Paragraphproperties;
    property Textproperties: IXMLTextpropertiesType read Get_Textproperties;
  end;

{ IXMLParagraphpropertiesType }

  IXMLParagraphpropertiesType = interface(IXMLNode)
    ['{5B10AB1C-B518-41E1-B28D-9C6529EAC591}']
    { Property Accessors }
    function Get_Tabstopdistance: UnicodeString;
    function Get_Textalign: UnicodeString;
    function Get_Marginleft: UnicodeString;
    procedure Set_Tabstopdistance(Value: UnicodeString);
    procedure Set_Textalign(Value: UnicodeString);
    procedure Set_Marginleft(Value: UnicodeString);
    { Methods & Properties }
    property Tabstopdistance: UnicodeString read Get_Tabstopdistance write Set_Tabstopdistance;
    property Textalign: UnicodeString read Get_Textalign write Set_Textalign;
    property Marginleft: UnicodeString read Get_Marginleft write Set_Marginleft;
  end;

{ IXMLTextpropertiesType }

  IXMLTextpropertiesType = interface(IXMLNode)
    ['{789E7728-86A9-4318-AD8C-360593D2741F}']
    { Property Accessors }
    function Get_Fontname: UnicodeString;
    function Get_Language: UnicodeString;
    function Get_Country: UnicodeString;
    function Get_Fontnameasian: UnicodeString;
    function Get_Languageasian: UnicodeString;
    function Get_Countryasian: UnicodeString;
    function Get_Fontnamecomplex: UnicodeString;
    function Get_Languagecomplex: UnicodeString;
    function Get_Countrycomplex: UnicodeString;
    function Get_Fontfamilyasian: UnicodeString;
    function Get_Fontfamilygenericasian: UnicodeString;
    function Get_Fontpitchasian: UnicodeString;
    function Get_Fontfamilycomplex: UnicodeString;
    function Get_Fontfamilygenericcomplex: UnicodeString;
    function Get_Fontpitchcomplex: UnicodeString;
    function Get_Color: UnicodeString;
    function Get_Fontsize: UnicodeString;
    function Get_Fontstyle: UnicodeString;
    function Get_Fontweight: UnicodeString;
    function Get_Textunderlinestyle: UnicodeString;
    function Get_Textunderlinewidth: UnicodeString;
    function Get_Textunderlinecolor: UnicodeString;
    function Get_Usewindowfontcolor: UnicodeString;
    function Get_Textoutline: UnicodeString;
    function Get_Textlinethroughstyle: UnicodeString;
    function Get_Textlinethroughtype: UnicodeString;
    function Get_Textshadow: UnicodeString;
    function Get_Textunderlinemode: UnicodeString;
    function Get_Textoverlinemode: UnicodeString;
    function Get_Textlinethroughmode: UnicodeString;
    function Get_Fontsizeasian: UnicodeString;
    function Get_Fontstyleasian: UnicodeString;
    function Get_Fontweightasian: UnicodeString;
    function Get_Fontsizecomplex: UnicodeString;
    function Get_Fontstylecomplex: UnicodeString;
    function Get_Fontweightcomplex: UnicodeString;
    function Get_Textemphasize: UnicodeString;
    function Get_Fontrelief: UnicodeString;
    function Get_Textoverlinestyle: UnicodeString;
    function Get_Textoverlinecolor: UnicodeString;
    procedure Set_Fontname(Value: UnicodeString);
    procedure Set_Language(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
    procedure Set_Fontnameasian(Value: UnicodeString);
    procedure Set_Languageasian(Value: UnicodeString);
    procedure Set_Countryasian(Value: UnicodeString);
    procedure Set_Fontnamecomplex(Value: UnicodeString);
    procedure Set_Languagecomplex(Value: UnicodeString);
    procedure Set_Countrycomplex(Value: UnicodeString);
    procedure Set_Fontfamilyasian(Value: UnicodeString);
    procedure Set_Fontfamilygenericasian(Value: UnicodeString);
    procedure Set_Fontpitchasian(Value: UnicodeString);
    procedure Set_Fontfamilycomplex(Value: UnicodeString);
    procedure Set_Fontfamilygenericcomplex(Value: UnicodeString);
    procedure Set_Fontpitchcomplex(Value: UnicodeString);
    procedure Set_Color(Value: UnicodeString);
    procedure Set_Fontsize(Value: UnicodeString);
    procedure Set_Fontstyle(Value: UnicodeString);
    procedure Set_Fontweight(Value: UnicodeString);
    procedure Set_Textunderlinestyle(Value: UnicodeString);
    procedure Set_Textunderlinewidth(Value: UnicodeString);
    procedure Set_Textunderlinecolor(Value: UnicodeString);
    procedure Set_Usewindowfontcolor(Value: UnicodeString);
    procedure Set_Textoutline(Value: UnicodeString);
    procedure Set_Textlinethroughstyle(Value: UnicodeString);
    procedure Set_Textlinethroughtype(Value: UnicodeString);
    procedure Set_Textshadow(Value: UnicodeString);
    procedure Set_Textunderlinemode(Value: UnicodeString);
    procedure Set_Textoverlinemode(Value: UnicodeString);
    procedure Set_Textlinethroughmode(Value: UnicodeString);
    procedure Set_Fontsizeasian(Value: UnicodeString);
    procedure Set_Fontstyleasian(Value: UnicodeString);
    procedure Set_Fontweightasian(Value: UnicodeString);
    procedure Set_Fontsizecomplex(Value: UnicodeString);
    procedure Set_Fontstylecomplex(Value: UnicodeString);
    procedure Set_Fontweightcomplex(Value: UnicodeString);
    procedure Set_Textemphasize(Value: UnicodeString);
    procedure Set_Fontrelief(Value: UnicodeString);
    procedure Set_Textoverlinestyle(Value: UnicodeString);
    procedure Set_Textoverlinecolor(Value: UnicodeString);
    { Methods & Properties }
    property Fontname: UnicodeString read Get_Fontname write Set_Fontname;
    property Language: UnicodeString read Get_Language write Set_Language;
    property Country: UnicodeString read Get_Country write Set_Country;
    property Fontnameasian: UnicodeString read Get_Fontnameasian write Set_Fontnameasian;
    property Languageasian: UnicodeString read Get_Languageasian write Set_Languageasian;
    property Countryasian: UnicodeString read Get_Countryasian write Set_Countryasian;
    property Fontnamecomplex: UnicodeString read Get_Fontnamecomplex write Set_Fontnamecomplex;
    property Languagecomplex: UnicodeString read Get_Languagecomplex write Set_Languagecomplex;
    property Countrycomplex: UnicodeString read Get_Countrycomplex write Set_Countrycomplex;
    property Fontfamilyasian: UnicodeString read Get_Fontfamilyasian write Set_Fontfamilyasian;
    property Fontfamilygenericasian: UnicodeString read Get_Fontfamilygenericasian write Set_Fontfamilygenericasian;
    property Fontpitchasian: UnicodeString read Get_Fontpitchasian write Set_Fontpitchasian;
    property Fontfamilycomplex: UnicodeString read Get_Fontfamilycomplex write Set_Fontfamilycomplex;
    property Fontfamilygenericcomplex: UnicodeString read Get_Fontfamilygenericcomplex write Set_Fontfamilygenericcomplex;
    property Fontpitchcomplex: UnicodeString read Get_Fontpitchcomplex write Set_Fontpitchcomplex;
    property Color: UnicodeString read Get_Color write Set_Color;
    property Fontsize: UnicodeString read Get_Fontsize write Set_Fontsize;
    property Fontstyle: UnicodeString read Get_Fontstyle write Set_Fontstyle;
    property Fontweight: UnicodeString read Get_Fontweight write Set_Fontweight;
    property Textunderlinestyle: UnicodeString read Get_Textunderlinestyle write Set_Textunderlinestyle;
    property Textunderlinewidth: UnicodeString read Get_Textunderlinewidth write Set_Textunderlinewidth;
    property Textunderlinecolor: UnicodeString read Get_Textunderlinecolor write Set_Textunderlinecolor;
    property Usewindowfontcolor: UnicodeString read Get_Usewindowfontcolor write Set_Usewindowfontcolor;
    property Textoutline: UnicodeString read Get_Textoutline write Set_Textoutline;
    property Textlinethroughstyle: UnicodeString read Get_Textlinethroughstyle write Set_Textlinethroughstyle;
    property Textlinethroughtype: UnicodeString read Get_Textlinethroughtype write Set_Textlinethroughtype;
    property Textshadow: UnicodeString read Get_Textshadow write Set_Textshadow;
    property Textunderlinemode: UnicodeString read Get_Textunderlinemode write Set_Textunderlinemode;
    property Textoverlinemode: UnicodeString read Get_Textoverlinemode write Set_Textoverlinemode;
    property Textlinethroughmode: UnicodeString read Get_Textlinethroughmode write Set_Textlinethroughmode;
    property Fontsizeasian: UnicodeString read Get_Fontsizeasian write Set_Fontsizeasian;
    property Fontstyleasian: UnicodeString read Get_Fontstyleasian write Set_Fontstyleasian;
    property Fontweightasian: UnicodeString read Get_Fontweightasian write Set_Fontweightasian;
    property Fontsizecomplex: UnicodeString read Get_Fontsizecomplex write Set_Fontsizecomplex;
    property Fontstylecomplex: UnicodeString read Get_Fontstylecomplex write Set_Fontstylecomplex;
    property Fontweightcomplex: UnicodeString read Get_Fontweightcomplex write Set_Fontweightcomplex;
    property Textemphasize: UnicodeString read Get_Textemphasize write Set_Textemphasize;
    property Fontrelief: UnicodeString read Get_Fontrelief write Set_Fontrelief;
    property Textoverlinestyle: UnicodeString read Get_Textoverlinestyle write Set_Textoverlinestyle;
    property Textoverlinecolor: UnicodeString read Get_Textoverlinecolor write Set_Textoverlinecolor;
  end;

{ IXMLNumberstyleType }

  IXMLNumberstyleType = interface(IXMLNode)
    ['{11BFD7FE-F677-4201-90CF-AB982B9C5B14}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Number: IXMLNumberType;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Number: IXMLNumberType read Get_Number;
  end;

{ IXMLNumberType }

  IXMLNumberType = interface(IXMLNode)
    ['{6352E384-994B-4B0F-83FE-9DDC087D263A}']
    { Property Accessors }
    function Get_Minintegerdigits: Integer;
    procedure Set_Minintegerdigits(Value: Integer);
    { Methods & Properties }
    property Minintegerdigits: Integer read Get_Minintegerdigits write Set_Minintegerdigits;
  end;

{ IXMLStyleType }

  IXMLStyleType = interface(IXMLNode)
    ['{8E4AB4DA-3766-4A1A-9332-16D35EE217F7}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Family: UnicodeString;
    function Get_Parentstylename: UnicodeString;
    function Get_Displayname: UnicodeString;
    function Get_Masterpagename: UnicodeString;
    function Get_Datastylename: UnicodeString;
    function Get_Textproperties: IXMLTextpropertiesType;
    function Get_Tablecellproperties: IXMLTablecellpropertiesType;
    function Get_Tablecolumnproperties: IXMLTablecolumnpropertiesType;
    function Get_Tablerowproperties: IXMLTablerowpropertiesType;
    function Get_Tableproperties: IXMLTablepropertiesType;
    function Get_Paragraphproperties: IXMLParagraphpropertiesType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Family(Value: UnicodeString);
    procedure Set_Parentstylename(Value: UnicodeString);
    procedure Set_Displayname(Value: UnicodeString);
    procedure Set_Masterpagename(Value: UnicodeString);
    procedure Set_Datastylename(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Family: UnicodeString read Get_Family write Set_Family;
    property Parentstylename: UnicodeString read Get_Parentstylename write Set_Parentstylename;
    property Displayname: UnicodeString read Get_Displayname write Set_Displayname;
    property Masterpagename: UnicodeString read Get_Masterpagename write Set_Masterpagename;
    property Datastylename: UnicodeString read Get_Datastylename write Set_Datastylename;
    property Textproperties: IXMLTextpropertiesType read Get_Textproperties;
    property Tablecellproperties: IXMLTablecellpropertiesType read Get_Tablecellproperties;
    property Tablecolumnproperties: IXMLTablecolumnpropertiesType read Get_Tablecolumnproperties;
    property Tablerowproperties: IXMLTablerowpropertiesType read Get_Tablerowproperties;
    property Tableproperties: IXMLTablepropertiesType read Get_Tableproperties;
    property Paragraphproperties: IXMLParagraphpropertiesType read Get_Paragraphproperties;
  end;

{ IXMLStyleTypeList }

  IXMLStyleTypeList = interface(IXMLNodeCollection)
    ['{78FC7B68-821F-4254-BDD4-69CEA20FA227}']
    { Methods & Properties }
    function Add: IXMLStyleType;
    function Insert(const Index: Integer): IXMLStyleType;

    function Get_Item(Index: Integer): IXMLStyleType;
    property Items[Index: Integer]: IXMLStyleType read Get_Item; default;
  end;

{ IXMLTablecellpropertiesType }

  IXMLTablecellpropertiesType = interface(IXMLNode)
    ['{821A1198-1307-492F-A41B-CB932B6B6392}']
    { Property Accessors }
    function Get_Backgroundcolor: UnicodeString;
    function Get_Diagonalbltr: UnicodeString;
    function Get_Diagonaltlbr: UnicodeString;
    function Get_Border: UnicodeString;
    function Get_Textalignsource: UnicodeString;
    function Get_Repeatcontent: UnicodeString;
    function Get_Wrapoption: UnicodeString;
    function Get_Verticalalign: UnicodeString;
    procedure Set_Backgroundcolor(Value: UnicodeString);
    procedure Set_Diagonalbltr(Value: UnicodeString);
    procedure Set_Diagonaltlbr(Value: UnicodeString);
    procedure Set_Border(Value: UnicodeString);
    procedure Set_Textalignsource(Value: UnicodeString);
    procedure Set_Repeatcontent(Value: UnicodeString);
    procedure Set_Wrapoption(Value: UnicodeString);
    procedure Set_Verticalalign(Value: UnicodeString);
    { Methods & Properties }
    property Backgroundcolor: UnicodeString read Get_Backgroundcolor write Set_Backgroundcolor;
    property Diagonalbltr: UnicodeString read Get_Diagonalbltr write Set_Diagonalbltr;
    property Diagonaltlbr: UnicodeString read Get_Diagonaltlbr write Set_Diagonaltlbr;
    property Border: UnicodeString read Get_Border write Set_Border;
    property Textalignsource: UnicodeString read Get_Textalignsource write Set_Textalignsource;
    property Repeatcontent: UnicodeString read Get_Repeatcontent write Set_Repeatcontent;
    property Wrapoption: UnicodeString read Get_Wrapoption write Set_Wrapoption;
    property Verticalalign: UnicodeString read Get_Verticalalign write Set_Verticalalign;
  end;

{ IXMLTablecolumnpropertiesType }

  IXMLTablecolumnpropertiesType = interface(IXMLNode)
    ['{A8BF1EBA-D28F-4258-91DC-D9938C8176F9}']
    { Property Accessors }
    function Get_Breakbefore: UnicodeString;
    function Get_Columnwidth: UnicodeString;
    procedure Set_Breakbefore(Value: UnicodeString);
    procedure Set_Columnwidth(Value: UnicodeString);
    { Methods & Properties }
    property Breakbefore: UnicodeString read Get_Breakbefore write Set_Breakbefore;
    property Columnwidth: UnicodeString read Get_Columnwidth write Set_Columnwidth;
  end;

{ IXMLTablerowpropertiesType }

  IXMLTablerowpropertiesType = interface(IXMLNode)
    ['{9F4F1FF5-E773-492B-876D-68F84A0C97E2}']
    { Property Accessors }
    function Get_Rowheight: UnicodeString;
    function Get_Breakbefore: UnicodeString;
    function Get_Useoptimalrowheight: UnicodeString;
    procedure Set_Rowheight(Value: UnicodeString);
    procedure Set_Breakbefore(Value: UnicodeString);
    procedure Set_Useoptimalrowheight(Value: UnicodeString);
    { Methods & Properties }
    property Rowheight: UnicodeString read Get_Rowheight write Set_Rowheight;
    property Breakbefore: UnicodeString read Get_Breakbefore write Set_Breakbefore;
    property Useoptimalrowheight: UnicodeString read Get_Useoptimalrowheight write Set_Useoptimalrowheight;
  end;

{ IXMLTablepropertiesType }

  IXMLTablepropertiesType = interface(IXMLNode)
    ['{AB298461-EEEA-4D4D-9F9C-D981A739B0C5}']
    { Property Accessors }
    function Get_Display: UnicodeString;
    function Get_Writingmode: UnicodeString;
    procedure Set_Display(Value: UnicodeString);
    procedure Set_Writingmode(Value: UnicodeString);
    { Methods & Properties }
    property Display: UnicodeString read Get_Display write Set_Display;
    property Writingmode: UnicodeString read Get_Writingmode write Set_Writingmode;
  end;

{ IXMLAutomaticstylesType }

  IXMLAutomaticstylesType = interface(IXMLNode)
    ['{FABAC5E4-F093-4005-97B2-3AD33C2BB2FB}']
    { Property Accessors }
    function Get_Style: IXMLStyleTypeList;
    function Get_Textstyle: IXMLTextstyleType;
    function Get_Pagelayout: IXMLPagelayoutTypeList;
    { Methods & Properties }
    property Style: IXMLStyleTypeList read Get_Style;
    property Textstyle: IXMLTextstyleType read Get_Textstyle;
    property Pagelayout: IXMLPagelayoutTypeList read Get_Pagelayout;
  end;

{ IXMLTextstyleType }

  IXMLTextstyleType = interface(IXMLNode)
    ['{9DF1045D-E756-4A8E-8737-91F6FF488B7F}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Textcontent: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Textcontent(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Textcontent: UnicodeString read Get_Textcontent write Set_Textcontent;
  end;

{ IXMLPagelayoutType }

  IXMLPagelayoutType = interface(IXMLNode)
    ['{7E5D69A8-A6EB-4184-B252-A1609CB45581}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Pagelayoutproperties: IXMLPagelayoutpropertiesType;
    function Get_Headerstyle: IXMLHeaderstyleType;
    function Get_Footerstyle: IXMLFooterstyleType;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Pagelayoutproperties: IXMLPagelayoutpropertiesType read Get_Pagelayoutproperties;
    property Headerstyle: IXMLHeaderstyleType read Get_Headerstyle;
    property Footerstyle: IXMLFooterstyleType read Get_Footerstyle;
  end;

{ IXMLPagelayoutTypeList }

  IXMLPagelayoutTypeList = interface(IXMLNodeCollection)
    ['{7EA4B3EE-77BB-4219-872F-DF047B708DD9}']
    { Methods & Properties }
    function Add: IXMLPagelayoutType;
    function Insert(const Index: Integer): IXMLPagelayoutType;

    function Get_Item(Index: Integer): IXMLPagelayoutType;
    property Items[Index: Integer]: IXMLPagelayoutType read Get_Item; default;
  end;

{ IXMLPagelayoutpropertiesType }

  IXMLPagelayoutpropertiesType = interface(IXMLNode)
    ['{BCC607D4-EAB4-4E84-AFBC-34C931AF3A26}']
    { Property Accessors }
    function Get_Writingmode: UnicodeString;
    procedure Set_Writingmode(Value: UnicodeString);
    { Methods & Properties }
    property Writingmode: UnicodeString read Get_Writingmode write Set_Writingmode;
  end;

{ IXMLHeaderstyleType }

  IXMLHeaderstyleType = interface(IXMLNode)
    ['{64C1C552-25E0-4720-A3F2-8464296A3AF4}']
    { Property Accessors }
    function Get_Headerfooterproperties: IXMLHeaderfooterpropertiesType;
    { Methods & Properties }
    property Headerfooterproperties: IXMLHeaderfooterpropertiesType read Get_Headerfooterproperties;
  end;

{ IXMLHeaderfooterpropertiesType }

  IXMLHeaderfooterpropertiesType = interface(IXMLNode)
    ['{A3E6FD50-BAE8-483C-B91F-D445EC993D9E}']
    { Property Accessors }
    function Get_Minheight: UnicodeString;
    function Get_Marginleft: UnicodeString;
    function Get_Marginright: UnicodeString;
    function Get_Marginbottom: UnicodeString;
    function Get_Margintop: UnicodeString;
    procedure Set_Minheight(Value: UnicodeString);
    procedure Set_Marginleft(Value: UnicodeString);
    procedure Set_Marginright(Value: UnicodeString);
    procedure Set_Marginbottom(Value: UnicodeString);
    procedure Set_Margintop(Value: UnicodeString);
    { Methods & Properties }
    property Minheight: UnicodeString read Get_Minheight write Set_Minheight;
    property Marginleft: UnicodeString read Get_Marginleft write Set_Marginleft;
    property Marginright: UnicodeString read Get_Marginright write Set_Marginright;
    property Marginbottom: UnicodeString read Get_Marginbottom write Set_Marginbottom;
    property Margintop: UnicodeString read Get_Margintop write Set_Margintop;
  end;

{ IXMLFooterstyleType }

  IXMLFooterstyleType = interface(IXMLNode)
    ['{AE7CA907-8EB4-4F4A-A083-6A9EA8AFFFD9}']
    { Property Accessors }
    function Get_Headerfooterproperties: IXMLHeaderfooterpropertiesType;
    { Methods & Properties }
    property Headerfooterproperties: IXMLHeaderfooterpropertiesType read Get_Headerfooterproperties;
  end;

{ IXMLMasterstylesType }

  IXMLMasterstylesType = interface(IXMLNodeCollection)
    ['{0F5C07FE-2ED8-4942-A52B-066D71868420}']
    { Property Accessors }
    function Get_Masterpage(Index: Integer): IXMLMasterpageType;
    { Methods & Properties }
    function Add: IXMLMasterpageType;
    function Insert(const Index: Integer): IXMLMasterpageType;
    property Masterpage[Index: Integer]: IXMLMasterpageType read Get_Masterpage; default;
  end;

{ IXMLMasterpageType }

  IXMLMasterpageType = interface(IXMLNode)
    ['{1C6A5472-39AF-49C8-8165-A0856210FBE7}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Pagelayoutname: UnicodeString;
    function Get_Header: IXMLHeaderType;
    function Get_Headerleft: IXMLHeaderleftType;
    function Get_Footer: IXMLFooterType;
    function Get_Footerleft: IXMLFooterleftType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Pagelayoutname(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Pagelayoutname: UnicodeString read Get_Pagelayoutname write Set_Pagelayoutname;
    property Header: IXMLHeaderType read Get_Header;
    property Headerleft: IXMLHeaderleftType read Get_Headerleft;
    property Footer: IXMLFooterType read Get_Footer;
    property Footerleft: IXMLFooterleftType read Get_Footerleft;
  end;

{ IXMLHeaderType }

  IXMLHeaderType = interface(IXMLNode)
    ['{3CB8FD42-5E6E-4BC7-8B57-FD8449F1EC1B}']
    { Property Accessors }
    function Get_P: IXMLPType;
    function Get_Regionleft: IXMLRegionleftType;
    function Get_Regionright: IXMLRegionrightType;
    { Methods & Properties }
    property P: IXMLPType read Get_P;
    property Regionleft: IXMLRegionleftType read Get_Regionleft;
    property Regionright: IXMLRegionrightType read Get_Regionright;
  end;

{ IXMLPType }

  IXMLPType = interface(IXMLNode)
    ['{DF6FB13B-66F7-4059-ACC1-DF160CF8F467}']
    { Property Accessors }
    function Get_Sheetname: UnicodeString;
    function Get_Pagenumber: Integer;
    function Get_S: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Date: IXMLDateType;
    function Get_Time: IXMLTimeType;
    function Get_Pagecount: Integer;
    procedure Set_Sheetname(Value: UnicodeString);
    procedure Set_Pagenumber(Value: Integer);
    procedure Set_S(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Pagecount(Value: Integer);
    { Methods & Properties }
    property Sheetname: UnicodeString read Get_Sheetname write Set_Sheetname;
    property Pagenumber: Integer read Get_Pagenumber write Set_Pagenumber;
    property S: UnicodeString read Get_S write Set_S;
    property Title: UnicodeString read Get_Title write Set_Title;
    property Date: IXMLDateType read Get_Date;
    property Time: IXMLTimeType read Get_Time;
    property Pagecount: Integer read Get_Pagecount write Set_Pagecount;
  end;

{ IXMLDateType }

  IXMLDateType = interface(IXMLNode)
    ['{31524BC0-BF6F-45EE-8605-C99A1B00DA62}']
    { Property Accessors }
    function Get_Datastylename: UnicodeString;
    function Get_Datevalue: UnicodeString;
    procedure Set_Datastylename(Value: UnicodeString);
    procedure Set_Datevalue(Value: UnicodeString);
    { Methods & Properties }
    property Datastylename: UnicodeString read Get_Datastylename write Set_Datastylename;
    property Datevalue: UnicodeString read Get_Datevalue write Set_Datevalue;
  end;

{ IXMLTimeType }

  IXMLTimeType = interface(IXMLNode)
    ['{1D130FBF-7551-4394-A9AD-2E1602704114}']
    { Property Accessors }
    function Get_Datastylename: UnicodeString;
    function Get_Timevalue: UnicodeString;
    procedure Set_Datastylename(Value: UnicodeString);
    procedure Set_Timevalue(Value: UnicodeString);
    { Methods & Properties }
    property Datastylename: UnicodeString read Get_Datastylename write Set_Datastylename;
    property Timevalue: UnicodeString read Get_Timevalue write Set_Timevalue;
  end;

{ IXMLRegionleftType }

  IXMLRegionleftType = interface(IXMLNode)
    ['{1853C09A-4906-4E98-89B0-ACDCB915637B}']
    { Property Accessors }
    function Get_P: IXMLPType;
    { Methods & Properties }
    property P: IXMLPType read Get_P;
  end;

{ IXMLRegionrightType }

  IXMLRegionrightType = interface(IXMLNode)
    ['{DF8A31E2-819B-476F-BA11-BF9C60904018}']
    { Property Accessors }
    function Get_P: IXMLPType;
    { Methods & Properties }
    property P: IXMLPType read Get_P;
  end;

{ IXMLHeaderleftType }

  IXMLHeaderleftType = interface(IXMLNode)
    ['{473F69DD-B8FD-4CD1-B871-F214961A1E9E}']
    { Property Accessors }
    function Get_Display: UnicodeString;
    procedure Set_Display(Value: UnicodeString);
    { Methods & Properties }
    property Display: UnicodeString read Get_Display write Set_Display;
  end;

{ IXMLFooterType }

  IXMLFooterType = interface(IXMLNode)
    ['{4792B548-1516-4625-8BB8-DC67ED03F700}']
    { Property Accessors }
    function Get_P: IXMLPType;
    { Methods & Properties }
    property P: IXMLPType read Get_P;
  end;

{ IXMLFooterleftType }

  IXMLFooterleftType = interface(IXMLNode)
    ['{09C941CD-BCC3-4B7D-AF1E-F1142AADDBA3}']
    { Property Accessors }
    function Get_Display: UnicodeString;
    procedure Set_Display(Value: UnicodeString);
    { Methods & Properties }
    property Display: UnicodeString read Get_Display write Set_Display;
  end;

{ IXMLBodyType }

  IXMLBodyType = interface(IXMLNode)
    ['{9B3CACFA-2DEA-4454-A149-F50679EA2287}']
    { Property Accessors }
    function Get_Spreadsheet: IXMLSpreadsheetType;
    { Methods & Properties }
    property Spreadsheet: IXMLSpreadsheetType read Get_Spreadsheet;
  end;

{ IXMLSpreadsheetType }

  IXMLSpreadsheetType = interface(IXMLNode)
    ['{F1489530-C313-4D61-81C9-92FD45A5A1B4}']
    { Property Accessors }
    function Get_Calculationsettings: IXMLCalculationsettingsType;
    function Get_Table: IXMLTableType;
    function Get_Namedexpressions: UnicodeString;
    procedure Set_Namedexpressions(Value: UnicodeString);
    { Methods & Properties }
    property Calculationsettings: IXMLCalculationsettingsType read Get_Calculationsettings;
    property Table: IXMLTableType read Get_Table;
    property Namedexpressions: UnicodeString read Get_Namedexpressions write Set_Namedexpressions;
  end;

{ IXMLCalculationsettingsType }

  IXMLCalculationsettingsType = interface(IXMLNode)
    ['{1B4B8DCA-4650-43B9-B68D-D395E7444C48}']
    { Property Accessors }
    function Get_Automaticfindlabels: UnicodeString;
    function Get_Useregularexpressions: UnicodeString;
    function Get_Usewildcards: UnicodeString;
    procedure Set_Automaticfindlabels(Value: UnicodeString);
    procedure Set_Useregularexpressions(Value: UnicodeString);
    procedure Set_Usewildcards(Value: UnicodeString);
    { Methods & Properties }
    property Automaticfindlabels: UnicodeString read Get_Automaticfindlabels write Set_Automaticfindlabels;
    property Useregularexpressions: UnicodeString read Get_Useregularexpressions write Set_Useregularexpressions;
    property Usewildcards: UnicodeString read Get_Usewildcards write Set_Usewildcards;
  end;

{ IXMLTableType }

  IXMLTableType = interface(IXMLNode)
    ['{67057A2C-B5B0-459A-A287-43198532C73C}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Stylename: UnicodeString;
    function Get_Tablecolumn: IXMLTablecolumnTypeList;
    function Get_Tablerow: IXMLTablerowTypeList;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Stylename(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Stylename: UnicodeString read Get_Stylename write Set_Stylename;
    property Tablecolumn: IXMLTablecolumnTypeList read Get_Tablecolumn;
    property Tablerow: IXMLTablerowTypeList read Get_Tablerow;
  end;

{ IXMLTablecolumnType }

  IXMLTablecolumnType = interface(IXMLNode)
    ['{7A97DE15-4F4C-4C20-859F-577AC1DB7986}']
    { Property Accessors }
    function Get_Stylename: UnicodeString;
    function Get_Defaultcellstylename: UnicodeString;
    function Get_Numbercolumnsrepeated: Integer;
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Defaultcellstylename(Value: UnicodeString);
    procedure Set_Numbercolumnsrepeated(Value: Integer);
    { Methods & Properties }
    property Stylename: UnicodeString read Get_Stylename write Set_Stylename;
    property Defaultcellstylename: UnicodeString read Get_Defaultcellstylename write Set_Defaultcellstylename;
    property Numbercolumnsrepeated: Integer read Get_Numbercolumnsrepeated write Set_Numbercolumnsrepeated;
  end;

{ IXMLTablecolumnTypeList }

  IXMLTablecolumnTypeList = interface(IXMLNodeCollection)
    ['{F331FF8B-7CA4-4E87-B7CA-1680365D26B0}']
    { Methods & Properties }
    function Add: IXMLTablecolumnType;
    function Insert(const Index: Integer): IXMLTablecolumnType;

    function Get_Item(Index: Integer): IXMLTablecolumnType;
    property Items[Index: Integer]: IXMLTablecolumnType read Get_Item; default;
  end;

{ IXMLTablerowType }

  IXMLTablerowType = interface(IXMLNode)
    ['{6BDBB02E-1F46-4FC9-9B27-AB3F9A525D2B}']
    { Property Accessors }
    function Get_Stylename: UnicodeString;
    function Get_Numberrowsrepeated: Integer;
    function Get_Tablecell: IXMLTablecellTypeList;
    function Get_Coveredtablecell: IXMLCoveredtablecellType;
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Numberrowsrepeated(Value: Integer);
    { Methods & Properties }
    property Stylename: UnicodeString read Get_Stylename write Set_Stylename;
    property Numberrowsrepeated: Integer read Get_Numberrowsrepeated write Set_Numberrowsrepeated;
    property Tablecell: IXMLTablecellTypeList read Get_Tablecell;
    property Coveredtablecell: IXMLCoveredtablecellType read Get_Coveredtablecell;
  end;

{ IXMLTablerowTypeList }

  IXMLTablerowTypeList = interface(IXMLNodeCollection)
    ['{D39F05DA-03C8-4B0F-943C-09451C0045F0}']
    { Methods & Properties }
    function Add: IXMLTablerowType;
    function Insert(const Index: Integer): IXMLTablerowType;

    function Get_Item(Index: Integer): IXMLTablerowType;
    property Items[Index: Integer]: IXMLTablerowType read Get_Item; default;
  end;

{ IXMLTablecellType }

  IXMLTablecellType = interface(IXMLNodeCollection)
    ['{46F23FCF-AE66-488E-A2A2-17C31353518F}']
    { Property Accessors }
    function Get_Stylename: UnicodeString;
    function Get_Valuetype: UnicodeString;
    function Get_P(Index: Integer): UnicodeString;
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Valuetype(Value: UnicodeString);
    { Methods & Properties }
    function Add(const P: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const P: UnicodeString): IXMLNode;
    property Stylename: UnicodeString read Get_Stylename write Set_Stylename;
    property Valuetype: UnicodeString read Get_Valuetype write Set_Valuetype;
    property P[Index: Integer]: UnicodeString read Get_P; default;
  end;

{ IXMLTablecellTypeList }

  IXMLTablecellTypeList = interface(IXMLNodeCollection)
    ['{7C56C3B1-1F32-4D36-B399-B05E8CD36DF2}']
    { Methods & Properties }
    function Add: IXMLTablecellType;
    function Insert(const Index: Integer): IXMLTablecellType;

    function Get_Item(Index: Integer): IXMLTablecellType;
    property Items[Index: Integer]: IXMLTablecellType read Get_Item; default;
  end;

{ IXMLCoveredtablecellType }

  IXMLCoveredtablecellType = interface(IXMLNode)
    ['{1C7E16D8-9F31-4583-A449-3C1E34A7FD9E}']
    { Property Accessors }
    function Get_Numbercolumnsrepeated: Integer;
    function Get_Stylename: UnicodeString;
    procedure Set_Numbercolumnsrepeated(Value: Integer);
    procedure Set_Stylename(Value: UnicodeString);
    { Methods & Properties }
    property Numbercolumnsrepeated: Integer read Get_Numbercolumnsrepeated write Set_Numbercolumnsrepeated;
    property Stylename: UnicodeString read Get_Stylename write Set_Stylename;
  end;

{ IXMLStyleType2 }

  IXMLStyleType2 = interface(IXMLNode)
    ['{19D48A99-C0E8-4781-83B9-8099393217A9}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Family: UnicodeString;
    function Get_Parentstylename: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Family(Value: UnicodeString);
    procedure Set_Parentstylename(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Family: UnicodeString read Get_Family write Set_Family;
    property Parentstylename: UnicodeString read Get_Parentstylename write Set_Parentstylename;
  end;

{ IXMLHeaderfooterpropertiesType2 }

  IXMLHeaderfooterpropertiesType2 = interface(IXMLNode)
    ['{8A96062D-3222-4FDC-9CE6-35BFAD5C3DCD}']
    { Property Accessors }
    function Get_Minheight: UnicodeString;
    function Get_Marginleft: UnicodeString;
    function Get_Marginright: UnicodeString;
    function Get_Marginbottom: UnicodeString;
    function Get_Border: UnicodeString;
    function Get_Padding: UnicodeString;
    function Get_Backgroundcolor: UnicodeString;
    function Get_Margintop: UnicodeString;
    function Get_Backgroundimage: UnicodeString;
    procedure Set_Minheight(Value: UnicodeString);
    procedure Set_Marginleft(Value: UnicodeString);
    procedure Set_Marginright(Value: UnicodeString);
    procedure Set_Marginbottom(Value: UnicodeString);
    procedure Set_Border(Value: UnicodeString);
    procedure Set_Padding(Value: UnicodeString);
    procedure Set_Backgroundcolor(Value: UnicodeString);
    procedure Set_Margintop(Value: UnicodeString);
    procedure Set_Backgroundimage(Value: UnicodeString);
    { Methods & Properties }
    property Minheight: UnicodeString read Get_Minheight write Set_Minheight;
    property Marginleft: UnicodeString read Get_Marginleft write Set_Marginleft;
    property Marginright: UnicodeString read Get_Marginright write Set_Marginright;
    property Marginbottom: UnicodeString read Get_Marginbottom write Set_Marginbottom;
    property Border: UnicodeString read Get_Border write Set_Border;
    property Padding: UnicodeString read Get_Padding write Set_Padding;
    property Backgroundcolor: UnicodeString read Get_Backgroundcolor write Set_Backgroundcolor;
    property Margintop: UnicodeString read Get_Margintop write Set_Margintop;
    property Backgroundimage: UnicodeString read Get_Backgroundimage write Set_Backgroundimage;
  end;

{ IXMLTablecellType2 }

  IXMLTablecellType2 = interface(IXMLNode)
    ['{A53C9AA4-6AE1-4AC5-83C5-9D95F384D2EB}']
    { Property Accessors }
    function Get_Numbercolumnsrepeated: Integer;
    function Get_Stylename: UnicodeString;
    function Get_Numbercolumnsspanned: Integer;
    function Get_Numberrowsspanned: Integer;
    procedure Set_Numbercolumnsrepeated(Value: Integer);
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Numbercolumnsspanned(Value: Integer);
    procedure Set_Numberrowsspanned(Value: Integer);
    { Methods & Properties }
    property Numbercolumnsrepeated: Integer read Get_Numbercolumnsrepeated write Set_Numbercolumnsrepeated;
    property Stylename: UnicodeString read Get_Stylename write Set_Stylename;
    property Numbercolumnsspanned: Integer read Get_Numbercolumnsspanned write Set_Numbercolumnsspanned;
    property Numberrowsspanned: Integer read Get_Numberrowsspanned write Set_Numberrowsspanned;
  end;

{ Forward Decls }

  TXMLDocumentType = class;
  TXMLMetaType = class;
  TXMLDocumentstatisticType = class;
  TXMLSettingsType = class;
  TXMLConfigitemsetType = class;
  TXMLConfigitemType = class;
  TXMLConfigitemTypeList = class;
  TXMLConfigitemmapindexedType = class;
  TXMLConfigitemmapentryType = class;
  TXMLScriptsType = class;
  TXMLScriptType = class;
  TXMLLibrariesType = class;
  TXMLFontfacedeclsType = class;
  TXMLFontfaceType = class;
  TXMLStylesType = class;
  TXMLDefaultstyleType = class;
  TXMLParagraphpropertiesType = class;
  TXMLTextpropertiesType = class;
  TXMLNumberstyleType = class;
  TXMLNumberType = class;
  TXMLStyleType = class;
  TXMLStyleTypeList = class;
  TXMLTablecellpropertiesType = class;
  TXMLTablecolumnpropertiesType = class;
  TXMLTablerowpropertiesType = class;
  TXMLTablepropertiesType = class;
  TXMLAutomaticstylesType = class;
  TXMLTextstyleType = class;
  TXMLPagelayoutType = class;
  TXMLPagelayoutTypeList = class;
  TXMLPagelayoutpropertiesType = class;
  TXMLHeaderstyleType = class;
  TXMLHeaderfooterpropertiesType = class;
  TXMLFooterstyleType = class;
  TXMLMasterstylesType = class;
  TXMLMasterpageType = class;
  TXMLHeaderType = class;
  TXMLPType = class;
  TXMLDateType = class;
  TXMLTimeType = class;
  TXMLRegionleftType = class;
  TXMLRegionrightType = class;
  TXMLHeaderleftType = class;
  TXMLFooterType = class;
  TXMLFooterleftType = class;
  TXMLBodyType = class;
  TXMLSpreadsheetType = class;
  TXMLCalculationsettingsType = class;
  TXMLTableType = class;
  TXMLTablecolumnType = class;
  TXMLTablecolumnTypeList = class;
  TXMLTablerowType = class;
  TXMLTablerowTypeList = class;
  TXMLTablecellType = class;
  TXMLTablecellTypeList = class;
  TXMLCoveredtablecellType = class;
  TXMLStyleType2 = class;
  TXMLHeaderfooterpropertiesType2 = class;
  TXMLTablecellType2 = class;

{ TXMLDocumentType }

  TXMLDocumentType = class(TXMLNode, IXMLDocumentType)
  protected
    { IXMLDocumentType }
    function Get_Version: UnicodeString;
    function Get_Mimetype: UnicodeString;
    function Get_Meta: IXMLMetaType;
    function Get_Settings: IXMLSettingsType;
    function Get_Scripts: IXMLScriptsType;
    function Get_Fontfacedecls: IXMLFontfacedeclsType;
    function Get_Styles: IXMLStylesType;
    function Get_Automaticstyles: IXMLAutomaticstylesType;
    function Get_Masterstyles: IXMLMasterstylesType;
    function Get_Body: IXMLBodyType;
    procedure Set_Version(Value: UnicodeString);
    procedure Set_Mimetype(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMetaType }

  TXMLMetaType = class(TXMLNode, IXMLMetaType)
  protected
    { IXMLMetaType }
    function Get_Creationdate: UnicodeString;
    function Get_Date: UnicodeString;
    function Get_Editingduration: UnicodeString;
    function Get_Editingcycles: Integer;
    function Get_Generator: UnicodeString;
    function Get_Documentstatistic: IXMLDocumentstatisticType;
    procedure Set_Creationdate(Value: UnicodeString);
    procedure Set_Date(Value: UnicodeString);
    procedure Set_Editingduration(Value: UnicodeString);
    procedure Set_Editingcycles(Value: Integer);
    procedure Set_Generator(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDocumentstatisticType }

  TXMLDocumentstatisticType = class(TXMLNode, IXMLDocumentstatisticType)
  protected
    { IXMLDocumentstatisticType }
    function Get_Tablecount: Integer;
    function Get_Cellcount: Integer;
    function Get_Objectcount: Integer;
    procedure Set_Tablecount(Value: Integer);
    procedure Set_Cellcount(Value: Integer);
    procedure Set_Objectcount(Value: Integer);
  end;

{ TXMLSettingsType }

  TXMLSettingsType = class(TXMLNodeCollection, IXMLSettingsType)
  protected
    { IXMLSettingsType }
    function Get_Configitemset(Index: Integer): IXMLConfigitemsetType;
    function Add: IXMLConfigitemsetType;
    function Insert(const Index: Integer): IXMLConfigitemsetType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConfigitemsetType }

  TXMLConfigitemsetType = class(TXMLNode, IXMLConfigitemsetType)
  private
    FConfigitem: IXMLConfigitemTypeList;
  protected
    { IXMLConfigitemsetType }
    function Get_Name: UnicodeString;
    function Get_Configitem: IXMLConfigitemTypeList;
    function Get_Configitemmapindexed: IXMLConfigitemmapindexedType;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConfigitemType }

  TXMLConfigitemType = class(TXMLNode, IXMLConfigitemType)
  protected
    { IXMLConfigitemType }
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
  end;

{ TXMLConfigitemTypeList }

  TXMLConfigitemTypeList = class(TXMLNodeCollection, IXMLConfigitemTypeList)
  protected
    { IXMLConfigitemTypeList }
    function Add: IXMLConfigitemType;
    function Insert(const Index: Integer): IXMLConfigitemType;

    function Get_Item(Index: Integer): IXMLConfigitemType;
  end;

{ TXMLConfigitemmapindexedType }

  TXMLConfigitemmapindexedType = class(TXMLNode, IXMLConfigitemmapindexedType)
  protected
    { IXMLConfigitemmapindexedType }
    function Get_Name: UnicodeString;
    function Get_Configitemmapentry: IXMLConfigitemmapentryType;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConfigitemmapentryType }

  TXMLConfigitemmapentryType = class(TXMLNodeCollection, IXMLConfigitemmapentryType)
  protected
    { IXMLConfigitemmapentryType }
    function Get_Configitem(Index: Integer): IXMLConfigitemType;
    function Add: IXMLConfigitemType;
    function Insert(const Index: Integer): IXMLConfigitemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLScriptsType }

  TXMLScriptsType = class(TXMLNode, IXMLScriptsType)
  protected
    { IXMLScriptsType }
    function Get_Script: IXMLScriptType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLScriptType }

  TXMLScriptType = class(TXMLNode, IXMLScriptType)
  protected
    { IXMLScriptType }
    function Get_Language: UnicodeString;
    function Get_Libraries: IXMLLibrariesType;
    procedure Set_Language(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLibrariesType }

  TXMLLibrariesType = class(TXMLNode, IXMLLibrariesType)
  protected
    { IXMLLibrariesType }
  end;

{ TXMLFontfacedeclsType }

  TXMLFontfacedeclsType = class(TXMLNodeCollection, IXMLFontfacedeclsType)
  protected
    { IXMLFontfacedeclsType }
    function Get_Fontface(Index: Integer): IXMLFontfaceType;
    function Add: IXMLFontfaceType;
    function Insert(const Index: Integer): IXMLFontfaceType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFontfaceType }

  TXMLFontfaceType = class(TXMLNode, IXMLFontfaceType)
  protected
    { IXMLFontfaceType }
    function Get_Name: UnicodeString;
    function Get_Fontfamily: UnicodeString;
    function Get_Fontfamilygeneric: UnicodeString;
    function Get_Fontpitch: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Fontfamily(Value: UnicodeString);
    procedure Set_Fontfamilygeneric(Value: UnicodeString);
    procedure Set_Fontpitch(Value: UnicodeString);
  end;

{ TXMLStylesType }

  TXMLStylesType = class(TXMLNode, IXMLStylesType)
  private
    FStyle: IXMLStyleTypeList;
  protected
    { IXMLStylesType }
    function Get_Defaultstyle: IXMLDefaultstyleType;
    function Get_Numberstyle: IXMLNumberstyleType;
    function Get_Style: IXMLStyleTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDefaultstyleType }

  TXMLDefaultstyleType = class(TXMLNode, IXMLDefaultstyleType)
  protected
    { IXMLDefaultstyleType }
    function Get_Family: UnicodeString;
    function Get_Paragraphproperties: IXMLParagraphpropertiesType;
    function Get_Textproperties: IXMLTextpropertiesType;
    procedure Set_Family(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLParagraphpropertiesType }

  TXMLParagraphpropertiesType = class(TXMLNode, IXMLParagraphpropertiesType)
  protected
    { IXMLParagraphpropertiesType }
    function Get_Tabstopdistance: UnicodeString;
    function Get_Textalign: UnicodeString;
    function Get_Marginleft: UnicodeString;
    procedure Set_Tabstopdistance(Value: UnicodeString);
    procedure Set_Textalign(Value: UnicodeString);
    procedure Set_Marginleft(Value: UnicodeString);
  end;

{ TXMLTextpropertiesType }

  TXMLTextpropertiesType = class(TXMLNode, IXMLTextpropertiesType)
  protected
    { IXMLTextpropertiesType }
    function Get_Fontname: UnicodeString;
    function Get_Language: UnicodeString;
    function Get_Country: UnicodeString;
    function Get_Fontnameasian: UnicodeString;
    function Get_Languageasian: UnicodeString;
    function Get_Countryasian: UnicodeString;
    function Get_Fontnamecomplex: UnicodeString;
    function Get_Languagecomplex: UnicodeString;
    function Get_Countrycomplex: UnicodeString;
    function Get_Fontfamilyasian: UnicodeString;
    function Get_Fontfamilygenericasian: UnicodeString;
    function Get_Fontpitchasian: UnicodeString;
    function Get_Fontfamilycomplex: UnicodeString;
    function Get_Fontfamilygenericcomplex: UnicodeString;
    function Get_Fontpitchcomplex: UnicodeString;
    function Get_Color: UnicodeString;
    function Get_Fontsize: UnicodeString;
    function Get_Fontstyle: UnicodeString;
    function Get_Fontweight: UnicodeString;
    function Get_Textunderlinestyle: UnicodeString;
    function Get_Textunderlinewidth: UnicodeString;
    function Get_Textunderlinecolor: UnicodeString;
    function Get_Usewindowfontcolor: UnicodeString;
    function Get_Textoutline: UnicodeString;
    function Get_Textlinethroughstyle: UnicodeString;
    function Get_Textlinethroughtype: UnicodeString;
    function Get_Textshadow: UnicodeString;
    function Get_Textunderlinemode: UnicodeString;
    function Get_Textoverlinemode: UnicodeString;
    function Get_Textlinethroughmode: UnicodeString;
    function Get_Fontsizeasian: UnicodeString;
    function Get_Fontstyleasian: UnicodeString;
    function Get_Fontweightasian: UnicodeString;
    function Get_Fontsizecomplex: UnicodeString;
    function Get_Fontstylecomplex: UnicodeString;
    function Get_Fontweightcomplex: UnicodeString;
    function Get_Textemphasize: UnicodeString;
    function Get_Fontrelief: UnicodeString;
    function Get_Textoverlinestyle: UnicodeString;
    function Get_Textoverlinecolor: UnicodeString;
    procedure Set_Fontname(Value: UnicodeString);
    procedure Set_Language(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
    procedure Set_Fontnameasian(Value: UnicodeString);
    procedure Set_Languageasian(Value: UnicodeString);
    procedure Set_Countryasian(Value: UnicodeString);
    procedure Set_Fontnamecomplex(Value: UnicodeString);
    procedure Set_Languagecomplex(Value: UnicodeString);
    procedure Set_Countrycomplex(Value: UnicodeString);
    procedure Set_Fontfamilyasian(Value: UnicodeString);
    procedure Set_Fontfamilygenericasian(Value: UnicodeString);
    procedure Set_Fontpitchasian(Value: UnicodeString);
    procedure Set_Fontfamilycomplex(Value: UnicodeString);
    procedure Set_Fontfamilygenericcomplex(Value: UnicodeString);
    procedure Set_Fontpitchcomplex(Value: UnicodeString);
    procedure Set_Color(Value: UnicodeString);
    procedure Set_Fontsize(Value: UnicodeString);
    procedure Set_Fontstyle(Value: UnicodeString);
    procedure Set_Fontweight(Value: UnicodeString);
    procedure Set_Textunderlinestyle(Value: UnicodeString);
    procedure Set_Textunderlinewidth(Value: UnicodeString);
    procedure Set_Textunderlinecolor(Value: UnicodeString);
    procedure Set_Usewindowfontcolor(Value: UnicodeString);
    procedure Set_Textoutline(Value: UnicodeString);
    procedure Set_Textlinethroughstyle(Value: UnicodeString);
    procedure Set_Textlinethroughtype(Value: UnicodeString);
    procedure Set_Textshadow(Value: UnicodeString);
    procedure Set_Textunderlinemode(Value: UnicodeString);
    procedure Set_Textoverlinemode(Value: UnicodeString);
    procedure Set_Textlinethroughmode(Value: UnicodeString);
    procedure Set_Fontsizeasian(Value: UnicodeString);
    procedure Set_Fontstyleasian(Value: UnicodeString);
    procedure Set_Fontweightasian(Value: UnicodeString);
    procedure Set_Fontsizecomplex(Value: UnicodeString);
    procedure Set_Fontstylecomplex(Value: UnicodeString);
    procedure Set_Fontweightcomplex(Value: UnicodeString);
    procedure Set_Textemphasize(Value: UnicodeString);
    procedure Set_Fontrelief(Value: UnicodeString);
    procedure Set_Textoverlinestyle(Value: UnicodeString);
    procedure Set_Textoverlinecolor(Value: UnicodeString);
  end;

{ TXMLNumberstyleType }

  TXMLNumberstyleType = class(TXMLNode, IXMLNumberstyleType)
  protected
    { IXMLNumberstyleType }
    function Get_Name: UnicodeString;
    function Get_Number: IXMLNumberType;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLNumberType }

  TXMLNumberType = class(TXMLNode, IXMLNumberType)
  protected
    { IXMLNumberType }
    function Get_Minintegerdigits: Integer;
    procedure Set_Minintegerdigits(Value: Integer);
  end;

{ TXMLStyleType }

  TXMLStyleType = class(TXMLNode, IXMLStyleType)
  protected
    { IXMLStyleType }
    function Get_Name: UnicodeString;
    function Get_Family: UnicodeString;
    function Get_Parentstylename: UnicodeString;
    function Get_Displayname: UnicodeString;
    function Get_Masterpagename: UnicodeString;
    function Get_Datastylename: UnicodeString;
    function Get_Textproperties: IXMLTextpropertiesType;
    function Get_Tablecellproperties: IXMLTablecellpropertiesType;
    function Get_Tablecolumnproperties: IXMLTablecolumnpropertiesType;
    function Get_Tablerowproperties: IXMLTablerowpropertiesType;
    function Get_Tableproperties: IXMLTablepropertiesType;
    function Get_Paragraphproperties: IXMLParagraphpropertiesType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Family(Value: UnicodeString);
    procedure Set_Parentstylename(Value: UnicodeString);
    procedure Set_Displayname(Value: UnicodeString);
    procedure Set_Masterpagename(Value: UnicodeString);
    procedure Set_Datastylename(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLStyleTypeList }

  TXMLStyleTypeList = class(TXMLNodeCollection, IXMLStyleTypeList)
  protected
    { IXMLStyleTypeList }
    function Add: IXMLStyleType;
    function Insert(const Index: Integer): IXMLStyleType;

    function Get_Item(Index: Integer): IXMLStyleType;
  end;

{ TXMLTablecellpropertiesType }

  TXMLTablecellpropertiesType = class(TXMLNode, IXMLTablecellpropertiesType)
  protected
    { IXMLTablecellpropertiesType }
    function Get_Backgroundcolor: UnicodeString;
    function Get_Diagonalbltr: UnicodeString;
    function Get_Diagonaltlbr: UnicodeString;
    function Get_Border: UnicodeString;
    function Get_Textalignsource: UnicodeString;
    function Get_Repeatcontent: UnicodeString;
    function Get_Wrapoption: UnicodeString;
    function Get_Verticalalign: UnicodeString;
    procedure Set_Backgroundcolor(Value: UnicodeString);
    procedure Set_Diagonalbltr(Value: UnicodeString);
    procedure Set_Diagonaltlbr(Value: UnicodeString);
    procedure Set_Border(Value: UnicodeString);
    procedure Set_Textalignsource(Value: UnicodeString);
    procedure Set_Repeatcontent(Value: UnicodeString);
    procedure Set_Wrapoption(Value: UnicodeString);
    procedure Set_Verticalalign(Value: UnicodeString);
  end;

{ TXMLTablecolumnpropertiesType }

  TXMLTablecolumnpropertiesType = class(TXMLNode, IXMLTablecolumnpropertiesType)
  protected
    { IXMLTablecolumnpropertiesType }
    function Get_Breakbefore: UnicodeString;
    function Get_Columnwidth: UnicodeString;
    procedure Set_Breakbefore(Value: UnicodeString);
    procedure Set_Columnwidth(Value: UnicodeString);
  end;

{ TXMLTablerowpropertiesType }

  TXMLTablerowpropertiesType = class(TXMLNode, IXMLTablerowpropertiesType)
  protected
    { IXMLTablerowpropertiesType }
    function Get_Rowheight: UnicodeString;
    function Get_Breakbefore: UnicodeString;
    function Get_Useoptimalrowheight: UnicodeString;
    procedure Set_Rowheight(Value: UnicodeString);
    procedure Set_Breakbefore(Value: UnicodeString);
    procedure Set_Useoptimalrowheight(Value: UnicodeString);
  end;

{ TXMLTablepropertiesType }

  TXMLTablepropertiesType = class(TXMLNode, IXMLTablepropertiesType)
  protected
    { IXMLTablepropertiesType }
    function Get_Display: UnicodeString;
    function Get_Writingmode: UnicodeString;
    procedure Set_Display(Value: UnicodeString);
    procedure Set_Writingmode(Value: UnicodeString);
  end;

{ TXMLAutomaticstylesType }

  TXMLAutomaticstylesType = class(TXMLNode, IXMLAutomaticstylesType)
  private
    FStyle: IXMLStyleTypeList;
    FPagelayout: IXMLPagelayoutTypeList;
  protected
    { IXMLAutomaticstylesType }
    function Get_Style: IXMLStyleTypeList;
    function Get_Textstyle: IXMLTextstyleType;
    function Get_Pagelayout: IXMLPagelayoutTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTextstyleType }

  TXMLTextstyleType = class(TXMLNode, IXMLTextstyleType)
  protected
    { IXMLTextstyleType }
    function Get_Name: UnicodeString;
    function Get_Textcontent: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Textcontent(Value: UnicodeString);
  end;

{ TXMLPagelayoutType }

  TXMLPagelayoutType = class(TXMLNode, IXMLPagelayoutType)
  protected
    { IXMLPagelayoutType }
    function Get_Name: UnicodeString;
    function Get_Pagelayoutproperties: IXMLPagelayoutpropertiesType;
    function Get_Headerstyle: IXMLHeaderstyleType;
    function Get_Footerstyle: IXMLFooterstyleType;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPagelayoutTypeList }

  TXMLPagelayoutTypeList = class(TXMLNodeCollection, IXMLPagelayoutTypeList)
  protected
    { IXMLPagelayoutTypeList }
    function Add: IXMLPagelayoutType;
    function Insert(const Index: Integer): IXMLPagelayoutType;

    function Get_Item(Index: Integer): IXMLPagelayoutType;
  end;

{ TXMLPagelayoutpropertiesType }

  TXMLPagelayoutpropertiesType = class(TXMLNode, IXMLPagelayoutpropertiesType)
  protected
    { IXMLPagelayoutpropertiesType }
    function Get_Writingmode: UnicodeString;
    procedure Set_Writingmode(Value: UnicodeString);
  end;

{ TXMLHeaderstyleType }

  TXMLHeaderstyleType = class(TXMLNode, IXMLHeaderstyleType)
  protected
    { IXMLHeaderstyleType }
    function Get_Headerfooterproperties: IXMLHeaderfooterpropertiesType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHeaderfooterpropertiesType }

  TXMLHeaderfooterpropertiesType = class(TXMLNode, IXMLHeaderfooterpropertiesType)
  protected
    { IXMLHeaderfooterpropertiesType }
    function Get_Minheight: UnicodeString;
    function Get_Marginleft: UnicodeString;
    function Get_Marginright: UnicodeString;
    function Get_Marginbottom: UnicodeString;
    function Get_Margintop: UnicodeString;
    procedure Set_Minheight(Value: UnicodeString);
    procedure Set_Marginleft(Value: UnicodeString);
    procedure Set_Marginright(Value: UnicodeString);
    procedure Set_Marginbottom(Value: UnicodeString);
    procedure Set_Margintop(Value: UnicodeString);
  end;

{ TXMLFooterstyleType }

  TXMLFooterstyleType = class(TXMLNode, IXMLFooterstyleType)
  protected
    { IXMLFooterstyleType }
    function Get_Headerfooterproperties: IXMLHeaderfooterpropertiesType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMasterstylesType }

  TXMLMasterstylesType = class(TXMLNodeCollection, IXMLMasterstylesType)
  protected
    { IXMLMasterstylesType }
    function Get_Masterpage(Index: Integer): IXMLMasterpageType;
    function Add: IXMLMasterpageType;
    function Insert(const Index: Integer): IXMLMasterpageType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMasterpageType }

  TXMLMasterpageType = class(TXMLNode, IXMLMasterpageType)
  protected
    { IXMLMasterpageType }
    function Get_Name: UnicodeString;
    function Get_Pagelayoutname: UnicodeString;
    function Get_Header: IXMLHeaderType;
    function Get_Headerleft: IXMLHeaderleftType;
    function Get_Footer: IXMLFooterType;
    function Get_Footerleft: IXMLFooterleftType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Pagelayoutname(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHeaderType }

  TXMLHeaderType = class(TXMLNode, IXMLHeaderType)
  protected
    { IXMLHeaderType }
    function Get_P: IXMLPType;
    function Get_Regionleft: IXMLRegionleftType;
    function Get_Regionright: IXMLRegionrightType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPType }

  TXMLPType = class(TXMLNode, IXMLPType)
  protected
    { IXMLPType }
    function Get_Sheetname: UnicodeString;
    function Get_Pagenumber: Integer;
    function Get_S: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Date: IXMLDateType;
    function Get_Time: IXMLTimeType;
    function Get_Pagecount: Integer;
    procedure Set_Sheetname(Value: UnicodeString);
    procedure Set_Pagenumber(Value: Integer);
    procedure Set_S(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Pagecount(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDateType }

  TXMLDateType = class(TXMLNode, IXMLDateType)
  protected
    { IXMLDateType }
    function Get_Datastylename: UnicodeString;
    function Get_Datevalue: UnicodeString;
    procedure Set_Datastylename(Value: UnicodeString);
    procedure Set_Datevalue(Value: UnicodeString);
  end;

{ TXMLTimeType }

  TXMLTimeType = class(TXMLNode, IXMLTimeType)
  protected
    { IXMLTimeType }
    function Get_Datastylename: UnicodeString;
    function Get_Timevalue: UnicodeString;
    procedure Set_Datastylename(Value: UnicodeString);
    procedure Set_Timevalue(Value: UnicodeString);
  end;

{ TXMLRegionleftType }

  TXMLRegionleftType = class(TXMLNode, IXMLRegionleftType)
  protected
    { IXMLRegionleftType }
    function Get_P: IXMLPType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRegionrightType }

  TXMLRegionrightType = class(TXMLNode, IXMLRegionrightType)
  protected
    { IXMLRegionrightType }
    function Get_P: IXMLPType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHeaderleftType }

  TXMLHeaderleftType = class(TXMLNode, IXMLHeaderleftType)
  protected
    { IXMLHeaderleftType }
    function Get_Display: UnicodeString;
    procedure Set_Display(Value: UnicodeString);
  end;

{ TXMLFooterType }

  TXMLFooterType = class(TXMLNode, IXMLFooterType)
  protected
    { IXMLFooterType }
    function Get_P: IXMLPType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFooterleftType }

  TXMLFooterleftType = class(TXMLNode, IXMLFooterleftType)
  protected
    { IXMLFooterleftType }
    function Get_Display: UnicodeString;
    procedure Set_Display(Value: UnicodeString);
  end;

{ TXMLBodyType }

  TXMLBodyType = class(TXMLNode, IXMLBodyType)
  protected
    { IXMLBodyType }
    function Get_Spreadsheet: IXMLSpreadsheetType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSpreadsheetType }

  TXMLSpreadsheetType = class(TXMLNode, IXMLSpreadsheetType)
  protected
    { IXMLSpreadsheetType }
    function Get_Calculationsettings: IXMLCalculationsettingsType;
    function Get_Table: IXMLTableType;
    function Get_Namedexpressions: UnicodeString;
    procedure Set_Namedexpressions(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCalculationsettingsType }

  TXMLCalculationsettingsType = class(TXMLNode, IXMLCalculationsettingsType)
  protected
    { IXMLCalculationsettingsType }
    function Get_Automaticfindlabels: UnicodeString;
    function Get_Useregularexpressions: UnicodeString;
    function Get_Usewildcards: UnicodeString;
    procedure Set_Automaticfindlabels(Value: UnicodeString);
    procedure Set_Useregularexpressions(Value: UnicodeString);
    procedure Set_Usewildcards(Value: UnicodeString);
  end;

{ TXMLTableType }

  TXMLTableType = class(TXMLNode, IXMLTableType)
  private
    FTablecolumn: IXMLTablecolumnTypeList;
    FTablerow: IXMLTablerowTypeList;
  protected
    { IXMLTableType }
    function Get_Name: UnicodeString;
    function Get_Stylename: UnicodeString;
    function Get_Tablecolumn: IXMLTablecolumnTypeList;
    function Get_Tablerow: IXMLTablerowTypeList;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Stylename(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTablecolumnType }

  TXMLTablecolumnType = class(TXMLNode, IXMLTablecolumnType)
  protected
    { IXMLTablecolumnType }
    function Get_Stylename: UnicodeString;
    function Get_Defaultcellstylename: UnicodeString;
    function Get_Numbercolumnsrepeated: Integer;
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Defaultcellstylename(Value: UnicodeString);
    procedure Set_Numbercolumnsrepeated(Value: Integer);
  end;

{ TXMLTablecolumnTypeList }

  TXMLTablecolumnTypeList = class(TXMLNodeCollection, IXMLTablecolumnTypeList)
  protected
    { IXMLTablecolumnTypeList }
    function Add: IXMLTablecolumnType;
    function Insert(const Index: Integer): IXMLTablecolumnType;

    function Get_Item(Index: Integer): IXMLTablecolumnType;
  end;

{ TXMLTablerowType }

  TXMLTablerowType = class(TXMLNode, IXMLTablerowType)
  private
    FTablecell: IXMLTablecellTypeList;
  protected
    { IXMLTablerowType }
    function Get_Stylename: UnicodeString;
    function Get_Numberrowsrepeated: Integer;
    function Get_Tablecell: IXMLTablecellTypeList;
    function Get_Coveredtablecell: IXMLCoveredtablecellType;
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Numberrowsrepeated(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTablerowTypeList }

  TXMLTablerowTypeList = class(TXMLNodeCollection, IXMLTablerowTypeList)
  protected
    { IXMLTablerowTypeList }
    function Add: IXMLTablerowType;
    function Insert(const Index: Integer): IXMLTablerowType;

    function Get_Item(Index: Integer): IXMLTablerowType;
  end;

{ TXMLTablecellType }

  TXMLTablecellType = class(TXMLNodeCollection, IXMLTablecellType)
  protected
    { IXMLTablecellType }
    function Get_Stylename: UnicodeString;
    function Get_Valuetype: UnicodeString;
    function Get_P(Index: Integer): UnicodeString;
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Valuetype(Value: UnicodeString);
    function Add(const P: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const P: UnicodeString): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTablecellTypeList }

  TXMLTablecellTypeList = class(TXMLNodeCollection, IXMLTablecellTypeList)
  protected
    { IXMLTablecellTypeList }
    function Add: IXMLTablecellType;
    function Insert(const Index: Integer): IXMLTablecellType;

    function Get_Item(Index: Integer): IXMLTablecellType;
  end;

{ TXMLCoveredtablecellType }

  TXMLCoveredtablecellType = class(TXMLNode, IXMLCoveredtablecellType)
  protected
    { IXMLCoveredtablecellType }
    function Get_Numbercolumnsrepeated: Integer;
    function Get_Stylename: UnicodeString;
    procedure Set_Numbercolumnsrepeated(Value: Integer);
    procedure Set_Stylename(Value: UnicodeString);
  end;

{ TXMLStyleType2 }

  TXMLStyleType2 = class(TXMLNode, IXMLStyleType2)
  protected
    { IXMLStyleType2 }
    function Get_Name: UnicodeString;
    function Get_Family: UnicodeString;
    function Get_Parentstylename: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Family(Value: UnicodeString);
    procedure Set_Parentstylename(Value: UnicodeString);
  end;

{ TXMLHeaderfooterpropertiesType2 }

  TXMLHeaderfooterpropertiesType2 = class(TXMLNode, IXMLHeaderfooterpropertiesType2)
  protected
    { IXMLHeaderfooterpropertiesType2 }
    function Get_Minheight: UnicodeString;
    function Get_Marginleft: UnicodeString;
    function Get_Marginright: UnicodeString;
    function Get_Marginbottom: UnicodeString;
    function Get_Border: UnicodeString;
    function Get_Padding: UnicodeString;
    function Get_Backgroundcolor: UnicodeString;
    function Get_Margintop: UnicodeString;
    function Get_Backgroundimage: UnicodeString;
    procedure Set_Minheight(Value: UnicodeString);
    procedure Set_Marginleft(Value: UnicodeString);
    procedure Set_Marginright(Value: UnicodeString);
    procedure Set_Marginbottom(Value: UnicodeString);
    procedure Set_Border(Value: UnicodeString);
    procedure Set_Padding(Value: UnicodeString);
    procedure Set_Backgroundcolor(Value: UnicodeString);
    procedure Set_Margintop(Value: UnicodeString);
    procedure Set_Backgroundimage(Value: UnicodeString);
  end;

{ TXMLTablecellType2 }

  TXMLTablecellType2 = class(TXMLNode, IXMLTablecellType2)
  protected
    { IXMLTablecellType2 }
    function Get_Numbercolumnsrepeated: Integer;
    function Get_Stylename: UnicodeString;
    function Get_Numbercolumnsspanned: Integer;
    function Get_Numberrowsspanned: Integer;
    procedure Set_Numbercolumnsrepeated(Value: Integer);
    procedure Set_Stylename(Value: UnicodeString);
    procedure Set_Numbercolumnsspanned(Value: Integer);
    procedure Set_Numberrowsspanned(Value: Integer);
  end;

{ Global Functions }

function GetEdiFozzy(Doc: IXMLDocument): IXMLDocumentType;
function LoadEdiFozzy(const FileName: string): IXMLDocumentType;
function NewEdiFozzy: IXMLDocumentType;

const
  TargetNamespace = 'urn:oasis:names:tc:opendocument:xmlns:office:1.0';

implementation

{ Global Functions }

function GetEdiFozzy(Doc: IXMLDocument): IXMLDocumentType;
begin
  Result := Doc.GetDocBinding('EdiFozzy', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

function LoadEdiFozzy(const FileName: string): IXMLDocumentType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('EdiFozzy', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

function NewEdiFozzy: IXMLDocumentType;
begin
  Result := NewXMLDocument.GetDocBinding('EdiFozzy', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

{ TXMLDocumentType }

procedure TXMLDocumentType.AfterConstruction;
begin
  RegisterChildNode('meta', TXMLMetaType);
  RegisterChildNode('settings', TXMLSettingsType);
  RegisterChildNode('scripts', TXMLScriptsType);
  RegisterChildNode('font-face-decls', TXMLFontfacedeclsType);
  RegisterChildNode('styles', TXMLStylesType);
  RegisterChildNode('automatic-styles', TXMLAutomaticstylesType);
  RegisterChildNode('master-styles', TXMLMasterstylesType);
  RegisterChildNode('body', TXMLBodyType);
  inherited;
end;

function TXMLDocumentType.Get_Version: UnicodeString;
begin
  Result := AttributeNodes['version'].Text;
end;

procedure TXMLDocumentType.Set_Version(Value: UnicodeString);
begin
  SetAttribute('version', Value);
end;

function TXMLDocumentType.Get_Mimetype: UnicodeString;
begin
  Result := AttributeNodes['mimetype'].Text;
end;

procedure TXMLDocumentType.Set_Mimetype(Value: UnicodeString);
begin
  SetAttribute('mimetype', Value);
end;

function TXMLDocumentType.Get_Meta: IXMLMetaType;
begin
  Result := ChildNodes['meta'] as IXMLMetaType;
end;

function TXMLDocumentType.Get_Settings: IXMLSettingsType;
begin
  Result := ChildNodes['settings'] as IXMLSettingsType;
end;

function TXMLDocumentType.Get_Scripts: IXMLScriptsType;
begin
  Result := ChildNodes['scripts'] as IXMLScriptsType;
end;

function TXMLDocumentType.Get_Fontfacedecls: IXMLFontfacedeclsType;
begin
  Result := ChildNodes['font-face-decls'] as IXMLFontfacedeclsType;
end;

function TXMLDocumentType.Get_Styles: IXMLStylesType;
begin
  Result := ChildNodes['styles'] as IXMLStylesType;
end;

function TXMLDocumentType.Get_Automaticstyles: IXMLAutomaticstylesType;
begin
  Result := ChildNodes['automatic-styles'] as IXMLAutomaticstylesType;
end;

function TXMLDocumentType.Get_Masterstyles: IXMLMasterstylesType;
begin
  Result := ChildNodes['master-styles'] as IXMLMasterstylesType;
end;

function TXMLDocumentType.Get_Body: IXMLBodyType;
begin
  Result := ChildNodes['body'] as IXMLBodyType;
end;

{ TXMLMetaType }

procedure TXMLMetaType.AfterConstruction;
begin
  RegisterChildNode('document-statistic', TXMLDocumentstatisticType);
  inherited;
end;

function TXMLMetaType.Get_Creationdate: UnicodeString;
begin
  Result := ChildNodes['creation-date'].Text;
end;

procedure TXMLMetaType.Set_Creationdate(Value: UnicodeString);
begin
  ChildNodes['creation-date'].NodeValue := Value;
end;

function TXMLMetaType.Get_Date: UnicodeString;
begin
  Result := ChildNodes['date'].Text;
end;

procedure TXMLMetaType.Set_Date(Value: UnicodeString);
begin
  ChildNodes['date'].NodeValue := Value;
end;

function TXMLMetaType.Get_Editingduration: UnicodeString;
begin
  Result := ChildNodes['editing-duration'].Text;
end;

procedure TXMLMetaType.Set_Editingduration(Value: UnicodeString);
begin
  ChildNodes['editing-duration'].NodeValue := Value;
end;

function TXMLMetaType.Get_Editingcycles: Integer;
begin
  Result := ChildNodes['editing-cycles'].NodeValue;
end;

procedure TXMLMetaType.Set_Editingcycles(Value: Integer);
begin
  ChildNodes['editing-cycles'].NodeValue := Value;
end;

function TXMLMetaType.Get_Generator: UnicodeString;
begin
  Result := ChildNodes['generator'].Text;
end;

procedure TXMLMetaType.Set_Generator(Value: UnicodeString);
begin
  ChildNodes['generator'].NodeValue := Value;
end;

function TXMLMetaType.Get_Documentstatistic: IXMLDocumentstatisticType;
begin
  Result := ChildNodes['document-statistic'] as IXMLDocumentstatisticType;
end;

{ TXMLDocumentstatisticType }

function TXMLDocumentstatisticType.Get_Tablecount: Integer;
begin
  Result := AttributeNodes['table-count'].NodeValue;
end;

procedure TXMLDocumentstatisticType.Set_Tablecount(Value: Integer);
begin
  SetAttribute('table-count', Value);
end;

function TXMLDocumentstatisticType.Get_Cellcount: Integer;
begin
  Result := AttributeNodes['cell-count'].NodeValue;
end;

procedure TXMLDocumentstatisticType.Set_Cellcount(Value: Integer);
begin
  SetAttribute('cell-count', Value);
end;

function TXMLDocumentstatisticType.Get_Objectcount: Integer;
begin
  Result := AttributeNodes['object-count'].NodeValue;
end;

procedure TXMLDocumentstatisticType.Set_Objectcount(Value: Integer);
begin
  SetAttribute('object-count', Value);
end;

{ TXMLSettingsType }

procedure TXMLSettingsType.AfterConstruction;
begin
  RegisterChildNode('config-item-set', TXMLConfigitemsetType);
  ItemTag := 'config-item-set';
  ItemInterface := IXMLConfigitemsetType;
  inherited;
end;

function TXMLSettingsType.Get_Configitemset(Index: Integer): IXMLConfigitemsetType;
begin
  Result := List[Index] as IXMLConfigitemsetType;
end;

function TXMLSettingsType.Add: IXMLConfigitemsetType;
begin
  Result := AddItem(-1) as IXMLConfigitemsetType;
end;

function TXMLSettingsType.Insert(const Index: Integer): IXMLConfigitemsetType;
begin
  Result := AddItem(Index) as IXMLConfigitemsetType;
end;

{ TXMLConfigitemsetType }

procedure TXMLConfigitemsetType.AfterConstruction;
begin
  RegisterChildNode('config-item', TXMLConfigitemType);
  RegisterChildNode('config-item-map-indexed', TXMLConfigitemmapindexedType);
  FConfigitem := CreateCollection(TXMLConfigitemTypeList, IXMLConfigitemType, 'config-item') as IXMLConfigitemTypeList;
  inherited;
end;

function TXMLConfigitemsetType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLConfigitemsetType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLConfigitemsetType.Get_Configitem: IXMLConfigitemTypeList;
begin
  Result := FConfigitem;
end;

function TXMLConfigitemsetType.Get_Configitemmapindexed: IXMLConfigitemmapindexedType;
begin
  Result := ChildNodes['config-item-map-indexed'] as IXMLConfigitemmapindexedType;
end;

{ TXMLConfigitemType }

function TXMLConfigitemType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLConfigitemType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLConfigitemType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['type'].Text;
end;

procedure TXMLConfigitemType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('type', Value);
end;

{ TXMLConfigitemTypeList }

function TXMLConfigitemTypeList.Add: IXMLConfigitemType;
begin
  Result := AddItem(-1) as IXMLConfigitemType;
end;

function TXMLConfigitemTypeList.Insert(const Index: Integer): IXMLConfigitemType;
begin
  Result := AddItem(Index) as IXMLConfigitemType;
end;

function TXMLConfigitemTypeList.Get_Item(Index: Integer): IXMLConfigitemType;
begin
  Result := List[Index] as IXMLConfigitemType;
end;

{ TXMLConfigitemmapindexedType }

procedure TXMLConfigitemmapindexedType.AfterConstruction;
begin
  RegisterChildNode('config-item-map-entry', TXMLConfigitemmapentryType);
  inherited;
end;

function TXMLConfigitemmapindexedType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLConfigitemmapindexedType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLConfigitemmapindexedType.Get_Configitemmapentry: IXMLConfigitemmapentryType;
begin
  Result := ChildNodes['config-item-map-entry'] as IXMLConfigitemmapentryType;
end;

{ TXMLConfigitemmapentryType }

procedure TXMLConfigitemmapentryType.AfterConstruction;
begin
  RegisterChildNode('config-item', TXMLConfigitemType);
  ItemTag := 'config-item';
  ItemInterface := IXMLConfigitemType;
  inherited;
end;

function TXMLConfigitemmapentryType.Get_Configitem(Index: Integer): IXMLConfigitemType;
begin
  Result := List[Index] as IXMLConfigitemType;
end;

function TXMLConfigitemmapentryType.Add: IXMLConfigitemType;
begin
  Result := AddItem(-1) as IXMLConfigitemType;
end;

function TXMLConfigitemmapentryType.Insert(const Index: Integer): IXMLConfigitemType;
begin
  Result := AddItem(Index) as IXMLConfigitemType;
end;

{ TXMLScriptsType }

procedure TXMLScriptsType.AfterConstruction;
begin
  RegisterChildNode('script', TXMLScriptType);
  inherited;
end;

function TXMLScriptsType.Get_Script: IXMLScriptType;
begin
  Result := ChildNodes['script'] as IXMLScriptType;
end;

{ TXMLScriptType }

procedure TXMLScriptType.AfterConstruction;
begin
  RegisterChildNode('libraries', TXMLLibrariesType);
  inherited;
end;

function TXMLScriptType.Get_Language: UnicodeString;
begin
  Result := AttributeNodes['language'].Text;
end;

procedure TXMLScriptType.Set_Language(Value: UnicodeString);
begin
  SetAttribute('language', Value);
end;

function TXMLScriptType.Get_Libraries: IXMLLibrariesType;
begin
  Result := ChildNodes['libraries'] as IXMLLibrariesType;
end;

{ TXMLLibrariesType }

{ TXMLFontfacedeclsType }

procedure TXMLFontfacedeclsType.AfterConstruction;
begin
  RegisterChildNode('font-face', TXMLFontfaceType);
  ItemTag := 'font-face';
  ItemInterface := IXMLFontfaceType;
  inherited;
end;

function TXMLFontfacedeclsType.Get_Fontface(Index: Integer): IXMLFontfaceType;
begin
  Result := List[Index] as IXMLFontfaceType;
end;

function TXMLFontfacedeclsType.Add: IXMLFontfaceType;
begin
  Result := AddItem(-1) as IXMLFontfaceType;
end;

function TXMLFontfacedeclsType.Insert(const Index: Integer): IXMLFontfaceType;
begin
  Result := AddItem(Index) as IXMLFontfaceType;
end;

{ TXMLFontfaceType }

function TXMLFontfaceType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLFontfaceType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLFontfaceType.Get_Fontfamily: UnicodeString;
begin
  Result := AttributeNodes['font-family'].Text;
end;

procedure TXMLFontfaceType.Set_Fontfamily(Value: UnicodeString);
begin
  SetAttribute('font-family', Value);
end;

function TXMLFontfaceType.Get_Fontfamilygeneric: UnicodeString;
begin
  Result := AttributeNodes['font-family-generic'].Text;
end;

procedure TXMLFontfaceType.Set_Fontfamilygeneric(Value: UnicodeString);
begin
  SetAttribute('font-family-generic', Value);
end;

function TXMLFontfaceType.Get_Fontpitch: UnicodeString;
begin
  Result := AttributeNodes['font-pitch'].Text;
end;

procedure TXMLFontfaceType.Set_Fontpitch(Value: UnicodeString);
begin
  SetAttribute('font-pitch', Value);
end;

{ TXMLStylesType }

procedure TXMLStylesType.AfterConstruction;
begin
  RegisterChildNode('default-style', TXMLDefaultstyleType);
  RegisterChildNode('number-style', TXMLNumberstyleType);
  RegisterChildNode('style', TXMLStyleType);
  FStyle := CreateCollection(TXMLStyleTypeList, IXMLStyleType, 'style') as IXMLStyleTypeList;
  inherited;
end;

function TXMLStylesType.Get_Defaultstyle: IXMLDefaultstyleType;
begin
  Result := ChildNodes['default-style'] as IXMLDefaultstyleType;
end;

function TXMLStylesType.Get_Numberstyle: IXMLNumberstyleType;
begin
  Result := ChildNodes['number-style'] as IXMLNumberstyleType;
end;

function TXMLStylesType.Get_Style: IXMLStyleTypeList;
begin
  Result := FStyle;
end;

{ TXMLDefaultstyleType }

procedure TXMLDefaultstyleType.AfterConstruction;
begin
  RegisterChildNode('paragraph-properties', TXMLParagraphpropertiesType);
  RegisterChildNode('text-properties', TXMLTextpropertiesType);
  inherited;
end;

function TXMLDefaultstyleType.Get_Family: UnicodeString;
begin
  Result := AttributeNodes['family'].Text;
end;

procedure TXMLDefaultstyleType.Set_Family(Value: UnicodeString);
begin
  SetAttribute('family', Value);
end;

function TXMLDefaultstyleType.Get_Paragraphproperties: IXMLParagraphpropertiesType;
begin
  Result := ChildNodes['paragraph-properties'] as IXMLParagraphpropertiesType;
end;

function TXMLDefaultstyleType.Get_Textproperties: IXMLTextpropertiesType;
begin
  Result := ChildNodes['text-properties'] as IXMLTextpropertiesType;
end;

{ TXMLParagraphpropertiesType }

function TXMLParagraphpropertiesType.Get_Tabstopdistance: UnicodeString;
begin
  Result := AttributeNodes['tab-stop-distance'].Text;
end;

procedure TXMLParagraphpropertiesType.Set_Tabstopdistance(Value: UnicodeString);
begin
  SetAttribute('tab-stop-distance', Value);
end;

function TXMLParagraphpropertiesType.Get_Textalign: UnicodeString;
begin
  Result := AttributeNodes['text-align'].Text;
end;

procedure TXMLParagraphpropertiesType.Set_Textalign(Value: UnicodeString);
begin
  SetAttribute('text-align', Value);
end;

function TXMLParagraphpropertiesType.Get_Marginleft: UnicodeString;
begin
  Result := AttributeNodes['margin-left'].Text;
end;

procedure TXMLParagraphpropertiesType.Set_Marginleft(Value: UnicodeString);
begin
  SetAttribute('margin-left', Value);
end;

{ TXMLTextpropertiesType }

function TXMLTextpropertiesType.Get_Fontname: UnicodeString;
begin
  Result := AttributeNodes['font-name'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontname(Value: UnicodeString);
begin
  SetAttribute('font-name', Value);
end;

function TXMLTextpropertiesType.Get_Language: UnicodeString;
begin
  Result := AttributeNodes['language'].Text;
end;

procedure TXMLTextpropertiesType.Set_Language(Value: UnicodeString);
begin
  SetAttribute('language', Value);
end;

function TXMLTextpropertiesType.Get_Country: UnicodeString;
begin
  Result := AttributeNodes['country'].Text;
end;

procedure TXMLTextpropertiesType.Set_Country(Value: UnicodeString);
begin
  SetAttribute('country', Value);
end;

function TXMLTextpropertiesType.Get_Fontnameasian: UnicodeString;
begin
  Result := AttributeNodes['font-name-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontnameasian(Value: UnicodeString);
begin
  SetAttribute('font-name-asian', Value);
end;

function TXMLTextpropertiesType.Get_Languageasian: UnicodeString;
begin
  Result := AttributeNodes['language-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Languageasian(Value: UnicodeString);
begin
  SetAttribute('language-asian', Value);
end;

function TXMLTextpropertiesType.Get_Countryasian: UnicodeString;
begin
  Result := AttributeNodes['country-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Countryasian(Value: UnicodeString);
begin
  SetAttribute('country-asian', Value);
end;

function TXMLTextpropertiesType.Get_Fontnamecomplex: UnicodeString;
begin
  Result := AttributeNodes['font-name-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontnamecomplex(Value: UnicodeString);
begin
  SetAttribute('font-name-complex', Value);
end;

function TXMLTextpropertiesType.Get_Languagecomplex: UnicodeString;
begin
  Result := AttributeNodes['language-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Languagecomplex(Value: UnicodeString);
begin
  SetAttribute('language-complex', Value);
end;

function TXMLTextpropertiesType.Get_Countrycomplex: UnicodeString;
begin
  Result := AttributeNodes['country-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Countrycomplex(Value: UnicodeString);
begin
  SetAttribute('country-complex', Value);
end;

function TXMLTextpropertiesType.Get_Fontfamilyasian: UnicodeString;
begin
  Result := AttributeNodes['font-family-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontfamilyasian(Value: UnicodeString);
begin
  SetAttribute('font-family-asian', Value);
end;

function TXMLTextpropertiesType.Get_Fontfamilygenericasian: UnicodeString;
begin
  Result := AttributeNodes['font-family-generic-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontfamilygenericasian(Value: UnicodeString);
begin
  SetAttribute('font-family-generic-asian', Value);
end;

function TXMLTextpropertiesType.Get_Fontpitchasian: UnicodeString;
begin
  Result := AttributeNodes['font-pitch-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontpitchasian(Value: UnicodeString);
begin
  SetAttribute('font-pitch-asian', Value);
end;

function TXMLTextpropertiesType.Get_Fontfamilycomplex: UnicodeString;
begin
  Result := AttributeNodes['font-family-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontfamilycomplex(Value: UnicodeString);
begin
  SetAttribute('font-family-complex', Value);
end;

function TXMLTextpropertiesType.Get_Fontfamilygenericcomplex: UnicodeString;
begin
  Result := AttributeNodes['font-family-generic-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontfamilygenericcomplex(Value: UnicodeString);
begin
  SetAttribute('font-family-generic-complex', Value);
end;

function TXMLTextpropertiesType.Get_Fontpitchcomplex: UnicodeString;
begin
  Result := AttributeNodes['font-pitch-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontpitchcomplex(Value: UnicodeString);
begin
  SetAttribute('font-pitch-complex', Value);
end;

function TXMLTextpropertiesType.Get_Color: UnicodeString;
begin
  Result := AttributeNodes['color'].Text;
end;

procedure TXMLTextpropertiesType.Set_Color(Value: UnicodeString);
begin
  SetAttribute('color', Value);
end;

function TXMLTextpropertiesType.Get_Fontsize: UnicodeString;
begin
  Result := AttributeNodes['font-size'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontsize(Value: UnicodeString);
begin
  SetAttribute('font-size', Value);
end;

function TXMLTextpropertiesType.Get_Fontstyle: UnicodeString;
begin
  Result := AttributeNodes['font-style'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontstyle(Value: UnicodeString);
begin
  SetAttribute('font-style', Value);
end;

function TXMLTextpropertiesType.Get_Fontweight: UnicodeString;
begin
  Result := AttributeNodes['font-weight'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontweight(Value: UnicodeString);
begin
  SetAttribute('font-weight', Value);
end;

function TXMLTextpropertiesType.Get_Textunderlinestyle: UnicodeString;
begin
  Result := AttributeNodes['text-underline-style'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textunderlinestyle(Value: UnicodeString);
begin
  SetAttribute('text-underline-style', Value);
end;

function TXMLTextpropertiesType.Get_Textunderlinewidth: UnicodeString;
begin
  Result := AttributeNodes['text-underline-width'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textunderlinewidth(Value: UnicodeString);
begin
  SetAttribute('text-underline-width', Value);
end;

function TXMLTextpropertiesType.Get_Textunderlinecolor: UnicodeString;
begin
  Result := AttributeNodes['text-underline-color'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textunderlinecolor(Value: UnicodeString);
begin
  SetAttribute('text-underline-color', Value);
end;

function TXMLTextpropertiesType.Get_Usewindowfontcolor: UnicodeString;
begin
  Result := AttributeNodes['use-window-font-color'].Text;
end;

procedure TXMLTextpropertiesType.Set_Usewindowfontcolor(Value: UnicodeString);
begin
  SetAttribute('use-window-font-color', Value);
end;

function TXMLTextpropertiesType.Get_Textoutline: UnicodeString;
begin
  Result := AttributeNodes['text-outline'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textoutline(Value: UnicodeString);
begin
  SetAttribute('text-outline', Value);
end;

function TXMLTextpropertiesType.Get_Textlinethroughstyle: UnicodeString;
begin
  Result := AttributeNodes['text-line-through-style'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textlinethroughstyle(Value: UnicodeString);
begin
  SetAttribute('text-line-through-style', Value);
end;

function TXMLTextpropertiesType.Get_Textlinethroughtype: UnicodeString;
begin
  Result := AttributeNodes['text-line-through-type'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textlinethroughtype(Value: UnicodeString);
begin
  SetAttribute('text-line-through-type', Value);
end;

function TXMLTextpropertiesType.Get_Textshadow: UnicodeString;
begin
  Result := AttributeNodes['text-shadow'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textshadow(Value: UnicodeString);
begin
  SetAttribute('text-shadow', Value);
end;

function TXMLTextpropertiesType.Get_Textunderlinemode: UnicodeString;
begin
  Result := AttributeNodes['text-underline-mode'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textunderlinemode(Value: UnicodeString);
begin
  SetAttribute('text-underline-mode', Value);
end;

function TXMLTextpropertiesType.Get_Textoverlinemode: UnicodeString;
begin
  Result := AttributeNodes['text-overline-mode'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textoverlinemode(Value: UnicodeString);
begin
  SetAttribute('text-overline-mode', Value);
end;

function TXMLTextpropertiesType.Get_Textlinethroughmode: UnicodeString;
begin
  Result := AttributeNodes['text-line-through-mode'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textlinethroughmode(Value: UnicodeString);
begin
  SetAttribute('text-line-through-mode', Value);
end;

function TXMLTextpropertiesType.Get_Fontsizeasian: UnicodeString;
begin
  Result := AttributeNodes['font-size-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontsizeasian(Value: UnicodeString);
begin
  SetAttribute('font-size-asian', Value);
end;

function TXMLTextpropertiesType.Get_Fontstyleasian: UnicodeString;
begin
  Result := AttributeNodes['font-style-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontstyleasian(Value: UnicodeString);
begin
  SetAttribute('font-style-asian', Value);
end;

function TXMLTextpropertiesType.Get_Fontweightasian: UnicodeString;
begin
  Result := AttributeNodes['font-weight-asian'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontweightasian(Value: UnicodeString);
begin
  SetAttribute('font-weight-asian', Value);
end;

function TXMLTextpropertiesType.Get_Fontsizecomplex: UnicodeString;
begin
  Result := AttributeNodes['font-size-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontsizecomplex(Value: UnicodeString);
begin
  SetAttribute('font-size-complex', Value);
end;

function TXMLTextpropertiesType.Get_Fontstylecomplex: UnicodeString;
begin
  Result := AttributeNodes['font-style-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontstylecomplex(Value: UnicodeString);
begin
  SetAttribute('font-style-complex', Value);
end;

function TXMLTextpropertiesType.Get_Fontweightcomplex: UnicodeString;
begin
  Result := AttributeNodes['font-weight-complex'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontweightcomplex(Value: UnicodeString);
begin
  SetAttribute('font-weight-complex', Value);
end;

function TXMLTextpropertiesType.Get_Textemphasize: UnicodeString;
begin
  Result := AttributeNodes['text-emphasize'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textemphasize(Value: UnicodeString);
begin
  SetAttribute('text-emphasize', Value);
end;

function TXMLTextpropertiesType.Get_Fontrelief: UnicodeString;
begin
  Result := AttributeNodes['font-relief'].Text;
end;

procedure TXMLTextpropertiesType.Set_Fontrelief(Value: UnicodeString);
begin
  SetAttribute('font-relief', Value);
end;

function TXMLTextpropertiesType.Get_Textoverlinestyle: UnicodeString;
begin
  Result := AttributeNodes['text-overline-style'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textoverlinestyle(Value: UnicodeString);
begin
  SetAttribute('text-overline-style', Value);
end;

function TXMLTextpropertiesType.Get_Textoverlinecolor: UnicodeString;
begin
  Result := AttributeNodes['text-overline-color'].Text;
end;

procedure TXMLTextpropertiesType.Set_Textoverlinecolor(Value: UnicodeString);
begin
  SetAttribute('text-overline-color', Value);
end;

{ TXMLNumberstyleType }

procedure TXMLNumberstyleType.AfterConstruction;
begin
  RegisterChildNode('number', TXMLNumberType);
  inherited;
end;

function TXMLNumberstyleType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLNumberstyleType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLNumberstyleType.Get_Number: IXMLNumberType;
begin
  Result := ChildNodes['number'] as IXMLNumberType;
end;

{ TXMLNumberType }

function TXMLNumberType.Get_Minintegerdigits: Integer;
begin
  Result := AttributeNodes['min-integer-digits'].NodeValue;
end;

procedure TXMLNumberType.Set_Minintegerdigits(Value: Integer);
begin
  SetAttribute('min-integer-digits', Value);
end;

{ TXMLStyleType }

procedure TXMLStyleType.AfterConstruction;
begin
  RegisterChildNode('text-properties', TXMLTextpropertiesType);
  RegisterChildNode('table-cell-properties', TXMLTablecellpropertiesType);
  RegisterChildNode('table-column-properties', TXMLTablecolumnpropertiesType);
  RegisterChildNode('table-row-properties', TXMLTablerowpropertiesType);
  RegisterChildNode('table-properties', TXMLTablepropertiesType);
  RegisterChildNode('paragraph-properties', TXMLParagraphpropertiesType);
  inherited;
end;

function TXMLStyleType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLStyleType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLStyleType.Get_Family: UnicodeString;
begin
  Result := AttributeNodes['family'].Text;
end;

procedure TXMLStyleType.Set_Family(Value: UnicodeString);
begin
  SetAttribute('family', Value);
end;

function TXMLStyleType.Get_Parentstylename: UnicodeString;
begin
  Result := AttributeNodes['parent-style-name'].Text;
end;

procedure TXMLStyleType.Set_Parentstylename(Value: UnicodeString);
begin
  SetAttribute('parent-style-name', Value);
end;

function TXMLStyleType.Get_Displayname: UnicodeString;
begin
  Result := AttributeNodes['display-name'].Text;
end;

procedure TXMLStyleType.Set_Displayname(Value: UnicodeString);
begin
  SetAttribute('display-name', Value);
end;

function TXMLStyleType.Get_Masterpagename: UnicodeString;
begin
  Result := AttributeNodes['master-page-name'].Text;
end;

procedure TXMLStyleType.Set_Masterpagename(Value: UnicodeString);
begin
  SetAttribute('master-page-name', Value);
end;

function TXMLStyleType.Get_Datastylename: UnicodeString;
begin
  Result := AttributeNodes['data-style-name'].Text;
end;

procedure TXMLStyleType.Set_Datastylename(Value: UnicodeString);
begin
  SetAttribute('data-style-name', Value);
end;

function TXMLStyleType.Get_Textproperties: IXMLTextpropertiesType;
begin
  Result := ChildNodes['text-properties'] as IXMLTextpropertiesType;
end;

function TXMLStyleType.Get_Tablecellproperties: IXMLTablecellpropertiesType;
begin
  Result := ChildNodes['table-cell-properties'] as IXMLTablecellpropertiesType;
end;

function TXMLStyleType.Get_Tablecolumnproperties: IXMLTablecolumnpropertiesType;
begin
  Result := ChildNodes['table-column-properties'] as IXMLTablecolumnpropertiesType;
end;

function TXMLStyleType.Get_Tablerowproperties: IXMLTablerowpropertiesType;
begin
  Result := ChildNodes['table-row-properties'] as IXMLTablerowpropertiesType;
end;

function TXMLStyleType.Get_Tableproperties: IXMLTablepropertiesType;
begin
  Result := ChildNodes['table-properties'] as IXMLTablepropertiesType;
end;

function TXMLStyleType.Get_Paragraphproperties: IXMLParagraphpropertiesType;
begin
  Result := ChildNodes['paragraph-properties'] as IXMLParagraphpropertiesType;
end;

{ TXMLStyleTypeList }

function TXMLStyleTypeList.Add: IXMLStyleType;
begin
  Result := AddItem(-1) as IXMLStyleType;
end;

function TXMLStyleTypeList.Insert(const Index: Integer): IXMLStyleType;
begin
  Result := AddItem(Index) as IXMLStyleType;
end;

function TXMLStyleTypeList.Get_Item(Index: Integer): IXMLStyleType;
begin
  Result := List[Index] as IXMLStyleType;
end;

{ TXMLTablecellpropertiesType }

function TXMLTablecellpropertiesType.Get_Backgroundcolor: UnicodeString;
begin
  Result := AttributeNodes['background-color'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Backgroundcolor(Value: UnicodeString);
begin
  SetAttribute('background-color', Value);
end;

function TXMLTablecellpropertiesType.Get_Diagonalbltr: UnicodeString;
begin
  Result := AttributeNodes['diagonal-bl-tr'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Diagonalbltr(Value: UnicodeString);
begin
  SetAttribute('diagonal-bl-tr', Value);
end;

function TXMLTablecellpropertiesType.Get_Diagonaltlbr: UnicodeString;
begin
  Result := AttributeNodes['diagonal-tl-br'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Diagonaltlbr(Value: UnicodeString);
begin
  SetAttribute('diagonal-tl-br', Value);
end;

function TXMLTablecellpropertiesType.Get_Border: UnicodeString;
begin
  Result := AttributeNodes['border'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Border(Value: UnicodeString);
begin
  SetAttribute('border', Value);
end;

function TXMLTablecellpropertiesType.Get_Textalignsource: UnicodeString;
begin
  Result := AttributeNodes['text-align-source'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Textalignsource(Value: UnicodeString);
begin
  SetAttribute('text-align-source', Value);
end;

function TXMLTablecellpropertiesType.Get_Repeatcontent: UnicodeString;
begin
  Result := AttributeNodes['repeat-content'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Repeatcontent(Value: UnicodeString);
begin
  SetAttribute('repeat-content', Value);
end;

function TXMLTablecellpropertiesType.Get_Wrapoption: UnicodeString;
begin
  Result := AttributeNodes['wrap-option'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Wrapoption(Value: UnicodeString);
begin
  SetAttribute('wrap-option', Value);
end;

function TXMLTablecellpropertiesType.Get_Verticalalign: UnicodeString;
begin
  Result := AttributeNodes['vertical-align'].Text;
end;

procedure TXMLTablecellpropertiesType.Set_Verticalalign(Value: UnicodeString);
begin
  SetAttribute('vertical-align', Value);
end;

{ TXMLTablecolumnpropertiesType }

function TXMLTablecolumnpropertiesType.Get_Breakbefore: UnicodeString;
begin
  Result := AttributeNodes['break-before'].Text;
end;

procedure TXMLTablecolumnpropertiesType.Set_Breakbefore(Value: UnicodeString);
begin
  SetAttribute('break-before', Value);
end;

function TXMLTablecolumnpropertiesType.Get_Columnwidth: UnicodeString;
begin
  Result := AttributeNodes['column-width'].Text;
end;

procedure TXMLTablecolumnpropertiesType.Set_Columnwidth(Value: UnicodeString);
begin
  SetAttribute('column-width', Value);
end;

{ TXMLTablerowpropertiesType }

function TXMLTablerowpropertiesType.Get_Rowheight: UnicodeString;
begin
  Result := AttributeNodes['row-height'].Text;
end;

procedure TXMLTablerowpropertiesType.Set_Rowheight(Value: UnicodeString);
begin
  SetAttribute('row-height', Value);
end;

function TXMLTablerowpropertiesType.Get_Breakbefore: UnicodeString;
begin
  Result := AttributeNodes['break-before'].Text;
end;

procedure TXMLTablerowpropertiesType.Set_Breakbefore(Value: UnicodeString);
begin
  SetAttribute('break-before', Value);
end;

function TXMLTablerowpropertiesType.Get_Useoptimalrowheight: UnicodeString;
begin
  Result := AttributeNodes['use-optimal-row-height'].Text;
end;

procedure TXMLTablerowpropertiesType.Set_Useoptimalrowheight(Value: UnicodeString);
begin
  SetAttribute('use-optimal-row-height', Value);
end;

{ TXMLTablepropertiesType }

function TXMLTablepropertiesType.Get_Display: UnicodeString;
begin
  Result := AttributeNodes['display'].Text;
end;

procedure TXMLTablepropertiesType.Set_Display(Value: UnicodeString);
begin
  SetAttribute('display', Value);
end;

function TXMLTablepropertiesType.Get_Writingmode: UnicodeString;
begin
  Result := AttributeNodes['writing-mode'].Text;
end;

procedure TXMLTablepropertiesType.Set_Writingmode(Value: UnicodeString);
begin
  SetAttribute('writing-mode', Value);
end;

{ TXMLAutomaticstylesType }

procedure TXMLAutomaticstylesType.AfterConstruction;
begin
  RegisterChildNode('style', TXMLStyleType);
  RegisterChildNode('text-style', TXMLTextstyleType);
  RegisterChildNode('page-layout', TXMLPagelayoutType);
  FStyle := CreateCollection(TXMLStyleTypeList, IXMLStyleType, 'style') as IXMLStyleTypeList;
  FPagelayout := CreateCollection(TXMLPagelayoutTypeList, IXMLPagelayoutType, 'page-layout') as IXMLPagelayoutTypeList;
  inherited;
end;

function TXMLAutomaticstylesType.Get_Style: IXMLStyleTypeList;
begin
  Result := FStyle;
end;

function TXMLAutomaticstylesType.Get_Textstyle: IXMLTextstyleType;
begin
  Result := ChildNodes['text-style'] as IXMLTextstyleType;
end;

function TXMLAutomaticstylesType.Get_Pagelayout: IXMLPagelayoutTypeList;
begin
  Result := FPagelayout;
end;

{ TXMLTextstyleType }

function TXMLTextstyleType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLTextstyleType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLTextstyleType.Get_Textcontent: UnicodeString;
begin
  Result := ChildNodes['text-content'].Text;
end;

procedure TXMLTextstyleType.Set_Textcontent(Value: UnicodeString);
begin
  ChildNodes['text-content'].NodeValue := Value;
end;

{ TXMLPagelayoutType }

procedure TXMLPagelayoutType.AfterConstruction;
begin
  RegisterChildNode('page-layout-properties', TXMLPagelayoutpropertiesType);
  RegisterChildNode('header-style', TXMLHeaderstyleType);
  RegisterChildNode('footer-style', TXMLFooterstyleType);
  inherited;
end;

function TXMLPagelayoutType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLPagelayoutType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLPagelayoutType.Get_Pagelayoutproperties: IXMLPagelayoutpropertiesType;
begin
  Result := ChildNodes['page-layout-properties'] as IXMLPagelayoutpropertiesType;
end;

function TXMLPagelayoutType.Get_Headerstyle: IXMLHeaderstyleType;
begin
  Result := ChildNodes['header-style'] as IXMLHeaderstyleType;
end;

function TXMLPagelayoutType.Get_Footerstyle: IXMLFooterstyleType;
begin
  Result := ChildNodes['footer-style'] as IXMLFooterstyleType;
end;

{ TXMLPagelayoutTypeList }

function TXMLPagelayoutTypeList.Add: IXMLPagelayoutType;
begin
  Result := AddItem(-1) as IXMLPagelayoutType;
end;

function TXMLPagelayoutTypeList.Insert(const Index: Integer): IXMLPagelayoutType;
begin
  Result := AddItem(Index) as IXMLPagelayoutType;
end;

function TXMLPagelayoutTypeList.Get_Item(Index: Integer): IXMLPagelayoutType;
begin
  Result := List[Index] as IXMLPagelayoutType;
end;

{ TXMLPagelayoutpropertiesType }

function TXMLPagelayoutpropertiesType.Get_Writingmode: UnicodeString;
begin
  Result := AttributeNodes['writing-mode'].Text;
end;

procedure TXMLPagelayoutpropertiesType.Set_Writingmode(Value: UnicodeString);
begin
  SetAttribute('writing-mode', Value);
end;

{ TXMLHeaderstyleType }

procedure TXMLHeaderstyleType.AfterConstruction;
begin
  RegisterChildNode('header-footer-properties', TXMLHeaderfooterpropertiesType);
  inherited;
end;

function TXMLHeaderstyleType.Get_Headerfooterproperties: IXMLHeaderfooterpropertiesType;
begin
  Result := ChildNodes['header-footer-properties'] as IXMLHeaderfooterpropertiesType;
end;

{ TXMLHeaderfooterpropertiesType }

function TXMLHeaderfooterpropertiesType.Get_Minheight: UnicodeString;
begin
  Result := AttributeNodes['min-height'].Text;
end;

procedure TXMLHeaderfooterpropertiesType.Set_Minheight(Value: UnicodeString);
begin
  SetAttribute('min-height', Value);
end;

function TXMLHeaderfooterpropertiesType.Get_Marginleft: UnicodeString;
begin
  Result := AttributeNodes['margin-left'].Text;
end;

procedure TXMLHeaderfooterpropertiesType.Set_Marginleft(Value: UnicodeString);
begin
  SetAttribute('margin-left', Value);
end;

function TXMLHeaderfooterpropertiesType.Get_Marginright: UnicodeString;
begin
  Result := AttributeNodes['margin-right'].Text;
end;

procedure TXMLHeaderfooterpropertiesType.Set_Marginright(Value: UnicodeString);
begin
  SetAttribute('margin-right', Value);
end;

function TXMLHeaderfooterpropertiesType.Get_Marginbottom: UnicodeString;
begin
  Result := AttributeNodes['margin-bottom'].Text;
end;

procedure TXMLHeaderfooterpropertiesType.Set_Marginbottom(Value: UnicodeString);
begin
  SetAttribute('margin-bottom', Value);
end;

function TXMLHeaderfooterpropertiesType.Get_Margintop: UnicodeString;
begin
  Result := AttributeNodes['margin-top'].Text;
end;

procedure TXMLHeaderfooterpropertiesType.Set_Margintop(Value: UnicodeString);
begin
  SetAttribute('margin-top', Value);
end;

{ TXMLFooterstyleType }

procedure TXMLFooterstyleType.AfterConstruction;
begin
  RegisterChildNode('header-footer-properties', TXMLHeaderfooterpropertiesType);
  inherited;
end;

function TXMLFooterstyleType.Get_Headerfooterproperties: IXMLHeaderfooterpropertiesType;
begin
  Result := ChildNodes['header-footer-properties'] as IXMLHeaderfooterpropertiesType;
end;

{ TXMLMasterstylesType }

procedure TXMLMasterstylesType.AfterConstruction;
begin
  RegisterChildNode('master-page', TXMLMasterpageType);
  ItemTag := 'master-page';
  ItemInterface := IXMLMasterpageType;
  inherited;
end;

function TXMLMasterstylesType.Get_Masterpage(Index: Integer): IXMLMasterpageType;
begin
  Result := List[Index] as IXMLMasterpageType;
end;

function TXMLMasterstylesType.Add: IXMLMasterpageType;
begin
  Result := AddItem(-1) as IXMLMasterpageType;
end;

function TXMLMasterstylesType.Insert(const Index: Integer): IXMLMasterpageType;
begin
  Result := AddItem(Index) as IXMLMasterpageType;
end;

{ TXMLMasterpageType }

procedure TXMLMasterpageType.AfterConstruction;
begin
  RegisterChildNode('header', TXMLHeaderType);
  RegisterChildNode('header-left', TXMLHeaderleftType);
  RegisterChildNode('footer', TXMLFooterType);
  RegisterChildNode('footer-left', TXMLFooterleftType);
  inherited;
end;

function TXMLMasterpageType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLMasterpageType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLMasterpageType.Get_Pagelayoutname: UnicodeString;
begin
  Result := AttributeNodes['page-layout-name'].Text;
end;

procedure TXMLMasterpageType.Set_Pagelayoutname(Value: UnicodeString);
begin
  SetAttribute('page-layout-name', Value);
end;

function TXMLMasterpageType.Get_Header: IXMLHeaderType;
begin
  Result := ChildNodes['header'] as IXMLHeaderType;
end;

function TXMLMasterpageType.Get_Headerleft: IXMLHeaderleftType;
begin
  Result := ChildNodes['header-left'] as IXMLHeaderleftType;
end;

function TXMLMasterpageType.Get_Footer: IXMLFooterType;
begin
  Result := ChildNodes['footer'] as IXMLFooterType;
end;

function TXMLMasterpageType.Get_Footerleft: IXMLFooterleftType;
begin
  Result := ChildNodes['footer-left'] as IXMLFooterleftType;
end;

{ TXMLHeaderType }

procedure TXMLHeaderType.AfterConstruction;
begin
  RegisterChildNode('p', TXMLPType);
  RegisterChildNode('region-left', TXMLRegionleftType);
  RegisterChildNode('region-right', TXMLRegionrightType);
  inherited;
end;

function TXMLHeaderType.Get_P: IXMLPType;
begin
  Result := ChildNodes[WideString('p')] as IXMLPType;
end;

function TXMLHeaderType.Get_Regionleft: IXMLRegionleftType;
begin
  Result := ChildNodes['region-left'] as IXMLRegionleftType;
end;

function TXMLHeaderType.Get_Regionright: IXMLRegionrightType;
begin
  Result := ChildNodes['region-right'] as IXMLRegionrightType;
end;

{ TXMLPType }

procedure TXMLPType.AfterConstruction;
begin
  RegisterChildNode('date', TXMLDateType);
  RegisterChildNode('time', TXMLTimeType);
  inherited;
end;

function TXMLPType.Get_Sheetname: UnicodeString;
begin
  Result := ChildNodes['sheet-name'].Text;
end;

procedure TXMLPType.Set_Sheetname(Value: UnicodeString);
begin
  ChildNodes['sheet-name'].NodeValue := Value;
end;

function TXMLPType.Get_Pagenumber: Integer;
begin
  Result := ChildNodes['page-number'].NodeValue;
end;

procedure TXMLPType.Set_Pagenumber(Value: Integer);
begin
  ChildNodes['page-number'].NodeValue := Value;
end;

function TXMLPType.Get_S: UnicodeString;
begin
  Result := ChildNodes[WideString('s')].Text;
end;

procedure TXMLPType.Set_S(Value: UnicodeString);
begin
  ChildNodes[WideString('s')].NodeValue := Value;
end;

function TXMLPType.Get_Title: UnicodeString;
begin
  Result := ChildNodes['title'].Text;
end;

procedure TXMLPType.Set_Title(Value: UnicodeString);
begin
  ChildNodes['title'].NodeValue := Value;
end;

function TXMLPType.Get_Date: IXMLDateType;
begin
  Result := ChildNodes['date'] as IXMLDateType;
end;

function TXMLPType.Get_Time: IXMLTimeType;
begin
  Result := ChildNodes['time'] as IXMLTimeType;
end;

function TXMLPType.Get_Pagecount: Integer;
begin
  Result := ChildNodes['page-count'].NodeValue;
end;

procedure TXMLPType.Set_Pagecount(Value: Integer);
begin
  ChildNodes['page-count'].NodeValue := Value;
end;

{ TXMLDateType }

function TXMLDateType.Get_Datastylename: UnicodeString;
begin
  Result := AttributeNodes['data-style-name'].Text;
end;

procedure TXMLDateType.Set_Datastylename(Value: UnicodeString);
begin
  SetAttribute('data-style-name', Value);
end;

function TXMLDateType.Get_Datevalue: UnicodeString;
begin
  Result := AttributeNodes['date-value'].Text;
end;

procedure TXMLDateType.Set_Datevalue(Value: UnicodeString);
begin
  SetAttribute('date-value', Value);
end;

{ TXMLTimeType }

function TXMLTimeType.Get_Datastylename: UnicodeString;
begin
  Result := AttributeNodes['data-style-name'].Text;
end;

procedure TXMLTimeType.Set_Datastylename(Value: UnicodeString);
begin
  SetAttribute('data-style-name', Value);
end;

function TXMLTimeType.Get_Timevalue: UnicodeString;
begin
  Result := AttributeNodes['time-value'].Text;
end;

procedure TXMLTimeType.Set_Timevalue(Value: UnicodeString);
begin
  SetAttribute('time-value', Value);
end;

{ TXMLRegionleftType }

procedure TXMLRegionleftType.AfterConstruction;
begin
  RegisterChildNode('p', TXMLPType);
  inherited;
end;

function TXMLRegionleftType.Get_P: IXMLPType;
begin
  Result := ChildNodes[WideString('p')] as IXMLPType;
end;

{ TXMLRegionrightType }

procedure TXMLRegionrightType.AfterConstruction;
begin
  RegisterChildNode('p', TXMLPType);
  inherited;
end;

function TXMLRegionrightType.Get_P: IXMLPType;
begin
  Result := ChildNodes[WideString('p')] as IXMLPType;
end;

{ TXMLHeaderleftType }

function TXMLHeaderleftType.Get_Display: UnicodeString;
begin
  Result := AttributeNodes['display'].Text;
end;

procedure TXMLHeaderleftType.Set_Display(Value: UnicodeString);
begin
  SetAttribute('display', Value);
end;

{ TXMLFooterType }

procedure TXMLFooterType.AfterConstruction;
begin
  RegisterChildNode('p', TXMLPType);
  inherited;
end;

function TXMLFooterType.Get_P: IXMLPType;
begin
  Result := ChildNodes[WideString('p')] as IXMLPType;
end;

{ TXMLFooterleftType }

function TXMLFooterleftType.Get_Display: UnicodeString;
begin
  Result := AttributeNodes['display'].Text;
end;

procedure TXMLFooterleftType.Set_Display(Value: UnicodeString);
begin
  SetAttribute('display', Value);
end;

{ TXMLBodyType }

procedure TXMLBodyType.AfterConstruction;
begin
  RegisterChildNode('spreadsheet', TXMLSpreadsheetType);
  inherited;
end;

function TXMLBodyType.Get_Spreadsheet: IXMLSpreadsheetType;
begin
  Result := ChildNodes['spreadsheet'] as IXMLSpreadsheetType;
end;

{ TXMLSpreadsheetType }

procedure TXMLSpreadsheetType.AfterConstruction;
begin
  RegisterChildNode('calculation-settings', TXMLCalculationsettingsType);
  RegisterChildNode('table', TXMLTableType);
  inherited;
end;

function TXMLSpreadsheetType.Get_Calculationsettings: IXMLCalculationsettingsType;
begin
  Result := ChildNodes['calculation-settings'] as IXMLCalculationsettingsType;
end;

function TXMLSpreadsheetType.Get_Table: IXMLTableType;
begin
  Result := ChildNodes['table'] as IXMLTableType;
end;

function TXMLSpreadsheetType.Get_Namedexpressions: UnicodeString;
begin
  Result := ChildNodes['named-expressions'].Text;
end;

procedure TXMLSpreadsheetType.Set_Namedexpressions(Value: UnicodeString);
begin
  ChildNodes['named-expressions'].NodeValue := Value;
end;

{ TXMLCalculationsettingsType }

function TXMLCalculationsettingsType.Get_Automaticfindlabels: UnicodeString;
begin
  Result := AttributeNodes['automatic-find-labels'].Text;
end;

procedure TXMLCalculationsettingsType.Set_Automaticfindlabels(Value: UnicodeString);
begin
  SetAttribute('automatic-find-labels', Value);
end;

function TXMLCalculationsettingsType.Get_Useregularexpressions: UnicodeString;
begin
  Result := AttributeNodes['use-regular-expressions'].Text;
end;

procedure TXMLCalculationsettingsType.Set_Useregularexpressions(Value: UnicodeString);
begin
  SetAttribute('use-regular-expressions', Value);
end;

function TXMLCalculationsettingsType.Get_Usewildcards: UnicodeString;
begin
  Result := AttributeNodes['use-wildcards'].Text;
end;

procedure TXMLCalculationsettingsType.Set_Usewildcards(Value: UnicodeString);
begin
  SetAttribute('use-wildcards', Value);
end;

{ TXMLTableType }

procedure TXMLTableType.AfterConstruction;
begin
  RegisterChildNode('table-column', TXMLTablecolumnType);
  RegisterChildNode('table-row', TXMLTablerowType);
  FTablecolumn := CreateCollection(TXMLTablecolumnTypeList, IXMLTablecolumnType, 'table-column') as IXMLTablecolumnTypeList;
  FTablerow := CreateCollection(TXMLTablerowTypeList, IXMLTablerowType, 'table-row') as IXMLTablerowTypeList;
  inherited;
end;

function TXMLTableType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLTableType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLTableType.Get_Stylename: UnicodeString;
begin
  Result := AttributeNodes['style-name'].Text;
end;

procedure TXMLTableType.Set_Stylename(Value: UnicodeString);
begin
  SetAttribute('style-name', Value);
end;

function TXMLTableType.Get_Tablecolumn: IXMLTablecolumnTypeList;
begin
  Result := FTablecolumn;
end;

function TXMLTableType.Get_Tablerow: IXMLTablerowTypeList;
begin
  Result := FTablerow;
end;

{ TXMLTablecolumnType }

function TXMLTablecolumnType.Get_Stylename: UnicodeString;
begin
  Result := AttributeNodes['style-name'].Text;
end;

procedure TXMLTablecolumnType.Set_Stylename(Value: UnicodeString);
begin
  SetAttribute('style-name', Value);
end;

function TXMLTablecolumnType.Get_Defaultcellstylename: UnicodeString;
begin
  Result := AttributeNodes['default-cell-style-name'].Text;
end;

procedure TXMLTablecolumnType.Set_Defaultcellstylename(Value: UnicodeString);
begin
  SetAttribute('default-cell-style-name', Value);
end;

function TXMLTablecolumnType.Get_Numbercolumnsrepeated: Integer;
begin
  Result := AttributeNodes['number-columns-repeated'].NodeValue;
end;

procedure TXMLTablecolumnType.Set_Numbercolumnsrepeated(Value: Integer);
begin
  SetAttribute('number-columns-repeated', Value);
end;

{ TXMLTablecolumnTypeList }

function TXMLTablecolumnTypeList.Add: IXMLTablecolumnType;
begin
  Result := AddItem(-1) as IXMLTablecolumnType;
end;

function TXMLTablecolumnTypeList.Insert(const Index: Integer): IXMLTablecolumnType;
begin
  Result := AddItem(Index) as IXMLTablecolumnType;
end;

function TXMLTablecolumnTypeList.Get_Item(Index: Integer): IXMLTablecolumnType;
begin
  Result := List[Index] as IXMLTablecolumnType;
end;

{ TXMLTablerowType }

procedure TXMLTablerowType.AfterConstruction;
begin
  RegisterChildNode('table-cell', TXMLTablecellType);
  RegisterChildNode('covered-table-cell', TXMLCoveredtablecellType);
  FTablecell := CreateCollection(TXMLTablecellTypeList, IXMLTablecellType, 'table-cell') as IXMLTablecellTypeList;
  inherited;
end;

function TXMLTablerowType.Get_Stylename: UnicodeString;
begin
  Result := AttributeNodes['style-name'].Text;
end;

procedure TXMLTablerowType.Set_Stylename(Value: UnicodeString);
begin
  SetAttribute('style-name', Value);
end;

function TXMLTablerowType.Get_Numberrowsrepeated: Integer;
begin
  Result := AttributeNodes['number-rows-repeated'].NodeValue;
end;

procedure TXMLTablerowType.Set_Numberrowsrepeated(Value: Integer);
begin
  SetAttribute('number-rows-repeated', Value);
end;

function TXMLTablerowType.Get_Tablecell: IXMLTablecellTypeList;
begin
  Result := FTablecell;
end;

function TXMLTablerowType.Get_Coveredtablecell: IXMLCoveredtablecellType;
begin
  Result := ChildNodes['covered-table-cell'] as IXMLCoveredtablecellType;
end;

{ TXMLTablerowTypeList }

function TXMLTablerowTypeList.Add: IXMLTablerowType;
begin
  Result := AddItem(-1) as IXMLTablerowType;
end;

function TXMLTablerowTypeList.Insert(const Index: Integer): IXMLTablerowType;
begin
  Result := AddItem(Index) as IXMLTablerowType;
end;

function TXMLTablerowTypeList.Get_Item(Index: Integer): IXMLTablerowType;
begin
  Result := List[Index] as IXMLTablerowType;
end;

{ TXMLTablecellType }

procedure TXMLTablecellType.AfterConstruction;
begin
  ItemTag := 'p';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLTablecellType.Get_Stylename: UnicodeString;
begin
  Result := AttributeNodes['style-name'].Text;
end;

procedure TXMLTablecellType.Set_Stylename(Value: UnicodeString);
begin
  SetAttribute('style-name', Value);
end;

function TXMLTablecellType.Get_Valuetype: UnicodeString;
begin
  Result := AttributeNodes['value-type'].Text;
end;

procedure TXMLTablecellType.Set_Valuetype(Value: UnicodeString);
begin
  SetAttribute('value-type', Value);
end;

function TXMLTablecellType.Get_P(Index: Integer): UnicodeString;
begin
  Result := List[Index].Text;
end;

function TXMLTablecellType.Add(const P: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := P;
end;

function TXMLTablecellType.Insert(const Index: Integer; const P: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := P;
end;

{ TXMLTablecellTypeList }

function TXMLTablecellTypeList.Add: IXMLTablecellType;
begin
  Result := AddItem(-1) as IXMLTablecellType;
end;

function TXMLTablecellTypeList.Insert(const Index: Integer): IXMLTablecellType;
begin
  Result := AddItem(Index) as IXMLTablecellType;
end;

function TXMLTablecellTypeList.Get_Item(Index: Integer): IXMLTablecellType;
begin
  Result := List[Index] as IXMLTablecellType;
end;

{ TXMLCoveredtablecellType }

function TXMLCoveredtablecellType.Get_Numbercolumnsrepeated: Integer;
begin
  Result := AttributeNodes['number-columns-repeated'].NodeValue;
end;

procedure TXMLCoveredtablecellType.Set_Numbercolumnsrepeated(Value: Integer);
begin
  SetAttribute('number-columns-repeated', Value);
end;

function TXMLCoveredtablecellType.Get_Stylename: UnicodeString;
begin
  Result := AttributeNodes['style-name'].Text;
end;

procedure TXMLCoveredtablecellType.Set_Stylename(Value: UnicodeString);
begin
  SetAttribute('style-name', Value);
end;

{ TXMLStyleType2 }

function TXMLStyleType2.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLStyleType2.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLStyleType2.Get_Family: UnicodeString;
begin
  Result := AttributeNodes['family'].Text;
end;

procedure TXMLStyleType2.Set_Family(Value: UnicodeString);
begin
  SetAttribute('family', Value);
end;

function TXMLStyleType2.Get_Parentstylename: UnicodeString;
begin
  Result := AttributeNodes['parent-style-name'].Text;
end;

procedure TXMLStyleType2.Set_Parentstylename(Value: UnicodeString);
begin
  SetAttribute('parent-style-name', Value);
end;

{ TXMLHeaderfooterpropertiesType2 }

function TXMLHeaderfooterpropertiesType2.Get_Minheight: UnicodeString;
begin
  Result := AttributeNodes['min-height'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Minheight(Value: UnicodeString);
begin
  SetAttribute('min-height', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Marginleft: UnicodeString;
begin
  Result := AttributeNodes['margin-left'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Marginleft(Value: UnicodeString);
begin
  SetAttribute('margin-left', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Marginright: UnicodeString;
begin
  Result := AttributeNodes['margin-right'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Marginright(Value: UnicodeString);
begin
  SetAttribute('margin-right', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Marginbottom: UnicodeString;
begin
  Result := AttributeNodes['margin-bottom'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Marginbottom(Value: UnicodeString);
begin
  SetAttribute('margin-bottom', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Border: UnicodeString;
begin
  Result := AttributeNodes['border'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Border(Value: UnicodeString);
begin
  SetAttribute('border', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Padding: UnicodeString;
begin
  Result := AttributeNodes['padding'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Padding(Value: UnicodeString);
begin
  SetAttribute('padding', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Backgroundcolor: UnicodeString;
begin
  Result := AttributeNodes['background-color'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Backgroundcolor(Value: UnicodeString);
begin
  SetAttribute('background-color', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Margintop: UnicodeString;
begin
  Result := AttributeNodes['margin-top'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Margintop(Value: UnicodeString);
begin
  SetAttribute('margin-top', Value);
end;

function TXMLHeaderfooterpropertiesType2.Get_Backgroundimage: UnicodeString;
begin
  Result := ChildNodes['background-image'].Text;
end;

procedure TXMLHeaderfooterpropertiesType2.Set_Backgroundimage(Value: UnicodeString);
begin
  ChildNodes['background-image'].NodeValue := Value;
end;

{ TXMLTablecellType2 }

function TXMLTablecellType2.Get_Numbercolumnsrepeated: Integer;
begin
  Result := AttributeNodes['number-columns-repeated'].NodeValue;
end;

procedure TXMLTablecellType2.Set_Numbercolumnsrepeated(Value: Integer);
begin
  SetAttribute('number-columns-repeated', Value);
end;

function TXMLTablecellType2.Get_Stylename: UnicodeString;
begin
  Result := AttributeNodes['style-name'].Text;
end;

procedure TXMLTablecellType2.Set_Stylename(Value: UnicodeString);
begin
  SetAttribute('style-name', Value);
end;

function TXMLTablecellType2.Get_Numbercolumnsspanned: Integer;
begin
  Result := AttributeNodes['number-columns-spanned'].NodeValue;
end;

procedure TXMLTablecellType2.Set_Numbercolumnsspanned(Value: Integer);
begin
  SetAttribute('number-columns-spanned', Value);
end;

function TXMLTablecellType2.Get_Numberrowsspanned: Integer;
begin
  Result := AttributeNodes['number-rows-spanned'].NodeValue;
end;

procedure TXMLTablecellType2.Set_Numberrowsspanned(Value: Integer);
begin
  SetAttribute('number-rows-spanned', Value);
end;

end.