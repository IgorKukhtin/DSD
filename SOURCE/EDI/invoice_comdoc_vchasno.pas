{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}

{************************************************************************}
{                                                                        }
{                            XML Data Binding                            }
{                                                                        }
{         Generated on: 12.04.2025 18:14:58                              }
{       Generated from: D:\Project-Basis\invoice_comdoc006_convert.xml   }
{   Settings stored in: D:\Project-Basis\invoice_comdoc006_convert.xdb   }
{                                                                        }
{************************************************************************}

unit invoice_comdoc_vchasno;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLЕлектроннийДокументType = interface;
  IXMLЗаголовокType = interface;
  IXMLДокПідставаType = interface;
  IXMLСторониType = interface;
  IXMLКонтрагентType = interface;
  IXMLЮрАдресаType = interface;
  IXMLПараметриType = interface;
  IXMLПараметрType = interface;
  IXMLТаблицяType = interface;
  IXMLРядокType = interface;
  IXMLВсьогоПоРядкуType = interface;
  IXMLВсьогоПоДокументуType = interface;

{ IXMLЕлектроннийДокументType }

  IXMLЕлектроннийДокументType = interface(IXMLNode)
    ['{18F1EEBC-915B-48F9-A198-4CA187C6C7A0}']
    { Property Accessors }
    function Get_Заголовок: IXMLЗаголовокType;
    function Get_Сторони: IXMLСторониType;
    function Get_Параметри: IXMLПараметриType;
    function Get_Таблиця: IXMLТаблицяType;
    function Get_ВсьогоПоДокументу: IXMLВсьогоПоДокументуType;
    { Methods & Properties }
    property Заголовок: IXMLЗаголовокType read Get_Заголовок;
    property Сторони: IXMLСторониType read Get_Сторони;
    property Параметри: IXMLПараметриType read Get_Параметри;
    property Таблиця: IXMLТаблицяType read Get_Таблиця;
    property ВсьогоПоДокументу: IXMLВсьогоПоДокументуType read Get_ВсьогоПоДокументу;
  end;

{ IXMLЗаголовокType }

  IXMLЗаголовокType = interface(IXMLNode)
    ['{B044C344-C5D5-43D4-B641-4BCD62E3FE10}']
    { Property Accessors }
    function Get_НомерДокументу: UnicodeString;
    function Get_ДатаДокументу: UnicodeString;
    function Get_НомерЗамовлення: UnicodeString;
    function Get_ДатаЗамовлення: UnicodeString;
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: UnicodeString;
    function Get_ДокПідстава: IXMLДокПідставаType;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ДатаДокументу(Value: UnicodeString);
    procedure Set_НомерЗамовлення(Value: UnicodeString);
    procedure Set_ДатаЗамовлення(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: UnicodeString);
    { Methods & Properties }
    property НомерДокументу: UnicodeString read Get_НомерДокументу write Set_НомерДокументу;
    property ДатаДокументу: UnicodeString read Get_ДатаДокументу write Set_ДатаДокументу;
    property НомерЗамовлення: UnicodeString read Get_НомерЗамовлення write Set_НомерЗамовлення;
    property ДатаЗамовлення: UnicodeString read Get_ДатаЗамовлення write Set_ДатаЗамовлення;
    property ТипДокументу: UnicodeString read Get_ТипДокументу write Set_ТипДокументу;
    property КодТипуДокументу: UnicodeString read Get_КодТипуДокументу write Set_КодТипуДокументу;
    property ДокПідстава: IXMLДокПідставаType read Get_ДокПідстава;
  end;

{ IXMLДокПідставаType }

  IXMLДокПідставаType = interface(IXMLNode)
    ['{2DCEB174-D027-4B39-8F14-AACB53327A38}']
    { Property Accessors }
    function Get_НомерДокументу: UnicodeString;
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: UnicodeString;
    function Get_ДатаДокументу: UnicodeString;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: UnicodeString);
    procedure Set_ДатаДокументу(Value: UnicodeString);
    { Methods & Properties }
    property НомерДокументу: UnicodeString read Get_НомерДокументу write Set_НомерДокументу;
    property ТипДокументу: UnicodeString read Get_ТипДокументу write Set_ТипДокументу;
    property КодТипуДокументу: UnicodeString read Get_КодТипуДокументу write Set_КодТипуДокументу;
    property ДатаДокументу: UnicodeString read Get_ДатаДокументу write Set_ДатаДокументу;
  end;

{ IXMLСторониType }

  IXMLСторониType = interface(IXMLNodeCollection)
    ['{C9C30B26-BB65-4535-9AC8-10DB59B32F53}']
    { Property Accessors }
    function Get_Контрагент(Index: Integer): IXMLКонтрагентType;
    { Methods & Properties }
    function Add: IXMLКонтрагентType;
    function Insert(const Index: Integer): IXMLКонтрагентType;
    property Контрагент[Index: Integer]: IXMLКонтрагентType read Get_Контрагент; default;
  end;

{ IXMLКонтрагентType }

  IXMLКонтрагентType = interface(IXMLNode)
    ['{9BC77A2D-E415-4AF5-9615-480EAC06238A}']
    { Property Accessors }
    function Get_СтатусКонтрагента: UnicodeString;
    function Get_GLN: UnicodeString;
    function Get_ІПН: UnicodeString;
    function Get_КодКонтрагента: UnicodeString;
    function Get_НазваКонтрагента: UnicodeString;
    function Get_Телефон: UnicodeString;
    function Get_ЮрАдреса: IXMLЮрАдресаType;
    procedure Set_СтатусКонтрагента(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
    procedure Set_ІПН(Value: UnicodeString);
    procedure Set_КодКонтрагента(Value: UnicodeString);
    procedure Set_НазваКонтрагента(Value: UnicodeString);
    procedure Set_Телефон(Value: UnicodeString);
    { Methods & Properties }
    property СтатусКонтрагента: UnicodeString read Get_СтатусКонтрагента write Set_СтатусКонтрагента;
    property GLN: UnicodeString read Get_GLN write Set_GLN;
    property ІПН: UnicodeString read Get_ІПН write Set_ІПН;
    property КодКонтрагента: UnicodeString read Get_КодКонтрагента write Set_КодКонтрагента;
    property НазваКонтрагента: UnicodeString read Get_НазваКонтрагента write Set_НазваКонтрагента;
    property Телефон: UnicodeString read Get_Телефон write Set_Телефон;
    property ЮрАдреса: IXMLЮрАдресаType read Get_ЮрАдреса;
  end;

{ IXMLЮрАдресаType }

  IXMLЮрАдресаType = interface(IXMLNode)
    ['{5969F388-88BE-4C5F-8CC7-68205EFFD5F6}']
    { Property Accessors }
    function Get_Індекс: Integer;
    function Get_Місто: UnicodeString;
    function Get_Вулиця: UnicodeString;
    procedure Set_Індекс(Value: Integer);
    procedure Set_Місто(Value: UnicodeString);
    procedure Set_Вулиця(Value: UnicodeString);
    { Methods & Properties }
    property Індекс: Integer read Get_Індекс write Set_Індекс;
    property Місто: UnicodeString read Get_Місто write Set_Місто;
    property Вулиця: UnicodeString read Get_Вулиця write Set_Вулиця;
  end;

{ IXMLПараметриType }

  IXMLПараметриType = interface(IXMLNodeCollection)
    ['{A45AE493-4F64-40E3-BF92-2699FE1BD3B8}']
    { Property Accessors }
    function Get_Параметр(Index: Integer): IXMLПараметрType;
    { Methods & Properties }
    function Add: IXMLПараметрType;
    function Insert(const Index: Integer): IXMLПараметрType;
    property Параметр[Index: Integer]: IXMLПараметрType read Get_Параметр; default;
  end;

{ IXMLПараметрType }

  IXMLПараметрType = interface(IXMLNode)
    ['{95FDA727-9636-4B75-9DC5-5E77A37271DC}']
    { Property Accessors }
    function Get_назва: UnicodeString;
    procedure Set_назва(Value: UnicodeString);
    { Methods & Properties }
    property назва: UnicodeString read Get_назва write Set_назва;
  end;

{ IXMLТаблицяType }

  IXMLТаблицяType = interface(IXMLNodeCollection)
    ['{D3F8755B-77C0-4B9E-9C69-144545FDB9F3}']
    { Property Accessors }
    function Get_Рядок(Index: Integer): IXMLРядокType;
    { Methods & Properties }
    function Add: IXMLРядокType;
    function Insert(const Index: Integer): IXMLРядокType;
    property Рядок[Index: Integer]: IXMLРядокType read Get_Рядок; default;
  end;

{ IXMLРядокType }

  IXMLРядокType = interface(IXMLNode)
    ['{11B8872A-7572-49A8-BC98-F22C46A9CCE3}']
    { Property Accessors }
    function Get_НомПоз: Integer;
    function Get_Штрихкод: UnicodeString;
    function Get_АртикулПокупця: UnicodeString;
    function Get_АртикулПродавця: UnicodeString;
    function Get_Найменування: UnicodeString;
    function Get_ПрийнятаКількість: UnicodeString;
    function Get_БазоваЦіна: UnicodeString;
    function Get_ОдиницяВиміру: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Ціна: UnicodeString;
    function Get_ВсьогоПоРядку: IXMLВсьогоПоРядкуType;
    procedure Set_НомПоз(Value: Integer);
    procedure Set_Штрихкод(Value: UnicodeString);
    procedure Set_АртикулПокупця(Value: UnicodeString);
    procedure Set_АртикулПродавця(Value: UnicodeString);
    procedure Set_Найменування(Value: UnicodeString);
    procedure Set_ПрийнятаКількість(Value: UnicodeString);
    procedure Set_БазоваЦіна(Value: UnicodeString);
    procedure Set_ОдиницяВиміру(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Ціна(Value: UnicodeString);
    { Methods & Properties }
    property НомПоз: Integer read Get_НомПоз write Set_НомПоз;
    property Штрихкод: UnicodeString read Get_Штрихкод write Set_Штрихкод;
    property АртикулПокупця: UnicodeString read Get_АртикулПокупця write Set_АртикулПокупця;
    property АртикулПродавця: UnicodeString read Get_АртикулПродавця write Set_АртикулПродавця;
    property Найменування: UnicodeString read Get_Найменування write Set_Найменування;
    property ПрийнятаКількість: UnicodeString read Get_ПрийнятаКількість write Set_ПрийнятаКількість;
    property БазоваЦіна: UnicodeString read Get_БазоваЦіна write Set_БазоваЦіна;
    property ОдиницяВиміру: UnicodeString read Get_ОдиницяВиміру write Set_ОдиницяВиміру;
    property ПДВ: UnicodeString read Get_ПДВ write Set_ПДВ;
    property Ціна: UnicodeString read Get_Ціна write Set_Ціна;
    property ВсьогоПоРядку: IXMLВсьогоПоРядкуType read Get_ВсьогоПоРядку;
  end;

{ IXMLВсьогоПоРядкуType }

  IXMLВсьогоПоРядкуType = interface(IXMLNode)
    ['{15859B78-4118-428C-8267-D688818DC064}']
    { Property Accessors }
    function Get_СумаБезПДВ: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Сума: UnicodeString;
    procedure Set_СумаБезПДВ(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Сума(Value: UnicodeString);
    { Methods & Properties }
    property СумаБезПДВ: UnicodeString read Get_СумаБезПДВ write Set_СумаБезПДВ;
    property ПДВ: UnicodeString read Get_ПДВ write Set_ПДВ;
    property Сума: UnicodeString read Get_Сума write Set_Сума;
  end;

{ IXMLВсьогоПоДокументуType }

  IXMLВсьогоПоДокументуType = interface(IXMLNode)
    ['{3D846C35-5869-4913-BF62-BFF8D42AD221}']
    { Property Accessors }
    function Get_СумаБезПДВ: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Сума: UnicodeString;
    procedure Set_СумаБезПДВ(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Сума(Value: UnicodeString);
    { Methods & Properties }
    property СумаБезПДВ: UnicodeString read Get_СумаБезПДВ write Set_СумаБезПДВ;
    property ПДВ: UnicodeString read Get_ПДВ write Set_ПДВ;
    property Сума: UnicodeString read Get_Сума write Set_Сума;
  end;

{ Forward Decls }

  TXMLЕлектроннийДокументType = class;
  TXMLЗаголовокType = class;
  TXMLДокПідставаType = class;
  TXMLСторониType = class;
  TXMLКонтрагентType = class;
  TXMLЮрАдресаType = class;
  TXMLПараметриType = class;
  TXMLПараметрType = class;
  TXMLТаблицяType = class;
  TXMLРядокType = class;
  TXMLВсьогоПоРядкуType = class;
  TXMLВсьогоПоДокументуType = class;

{ TXMLЕлектроннийДокументType }

  TXMLЕлектроннийДокументType = class(TXMLNode, IXMLЕлектроннийДокументType)
  protected
    { IXMLЕлектроннийДокументType }
    function Get_Заголовок: IXMLЗаголовокType;
    function Get_Сторони: IXMLСторониType;
    function Get_Параметри: IXMLПараметриType;
    function Get_Таблиця: IXMLТаблицяType;
    function Get_ВсьогоПоДокументу: IXMLВсьогоПоДокументуType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLЗаголовокType }

  TXMLЗаголовокType = class(TXMLNode, IXMLЗаголовокType)
  protected
    { IXMLЗаголовокType }
    function Get_НомерДокументу: UnicodeString;
    function Get_ДатаДокументу: UnicodeString;
    function Get_НомерЗамовлення: UnicodeString;
    function Get_ДатаЗамовлення: UnicodeString;
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: UnicodeString;
    function Get_ДокПідстава: IXMLДокПідставаType;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ДатаДокументу(Value: UnicodeString);
    procedure Set_НомерЗамовлення(Value: UnicodeString);
    procedure Set_ДатаЗамовлення(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLДокПідставаType }

  TXMLДокПідставаType = class(TXMLNode, IXMLДокПідставаType)
  protected
    { IXMLДокПідставаType }
    function Get_НомерДокументу: UnicodeString;
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: UnicodeString;
    function Get_ДатаДокументу: UnicodeString;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: UnicodeString);
    procedure Set_ДатаДокументу(Value: UnicodeString);
  end;

{ TXMLСторониType }

  TXMLСторониType = class(TXMLNodeCollection, IXMLСторониType)
  protected
    { IXMLСторониType }
    function Get_Контрагент(Index: Integer): IXMLКонтрагентType;
    function Add: IXMLКонтрагентType;
    function Insert(const Index: Integer): IXMLКонтрагентType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLКонтрагентType }

  TXMLКонтрагентType = class(TXMLNode, IXMLКонтрагентType)
  protected
    { IXMLКонтрагентType }
    function Get_СтатусКонтрагента: UnicodeString;
    function Get_GLN: UnicodeString;
    function Get_ІПН: UnicodeString;
    function Get_КодКонтрагента: UnicodeString;
    function Get_НазваКонтрагента: UnicodeString;
    function Get_Телефон: UnicodeString;
    function Get_ЮрАдреса: IXMLЮрАдресаType;
    procedure Set_СтатусКонтрагента(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
    procedure Set_ІПН(Value: UnicodeString);
    procedure Set_КодКонтрагента(Value: UnicodeString);
    procedure Set_НазваКонтрагента(Value: UnicodeString);
    procedure Set_Телефон(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLЮрАдресаType }

  TXMLЮрАдресаType = class(TXMLNode, IXMLЮрАдресаType)
  protected
    { IXMLЮрАдресаType }
    function Get_Індекс: Integer;
    function Get_Місто: UnicodeString;
    function Get_Вулиця: UnicodeString;
    procedure Set_Індекс(Value: Integer);
    procedure Set_Місто(Value: UnicodeString);
    procedure Set_Вулиця(Value: UnicodeString);
  end;

{ TXMLПараметриType }

  TXMLПараметриType = class(TXMLNodeCollection, IXMLПараметриType)
  protected
    { IXMLПараметриType }
    function Get_Параметр(Index: Integer): IXMLПараметрType;
    function Add: IXMLПараметрType;
    function Insert(const Index: Integer): IXMLПараметрType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLПараметрType }

  TXMLПараметрType = class(TXMLNode, IXMLПараметрType)
  protected
    { IXMLПараметрType }
    function Get_назва: UnicodeString;
    procedure Set_назва(Value: UnicodeString);
  end;

{ TXMLТаблицяType }

  TXMLТаблицяType = class(TXMLNodeCollection, IXMLТаблицяType)
  protected
    { IXMLТаблицяType }
    function Get_Рядок(Index: Integer): IXMLРядокType;
    function Add: IXMLРядокType;
    function Insert(const Index: Integer): IXMLРядокType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLРядокType }

  TXMLРядокType = class(TXMLNode, IXMLРядокType)
  protected
    { IXMLРядокType }
    function Get_НомПоз: Integer;
    function Get_Штрихкод: UnicodeString;
    function Get_АртикулПокупця: UnicodeString;
    function Get_АртикулПродавця: UnicodeString;
    function Get_Найменування: UnicodeString;
    function Get_ПрийнятаКількість: UnicodeString;
    function Get_БазоваЦіна: UnicodeString;
    function Get_ОдиницяВиміру: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Ціна: UnicodeString;
    function Get_ВсьогоПоРядку: IXMLВсьогоПоРядкуType;
    procedure Set_НомПоз(Value: Integer);
    procedure Set_Штрихкод(Value: UnicodeString);
    procedure Set_АртикулПокупця(Value: UnicodeString);
    procedure Set_АртикулПродавця(Value: UnicodeString);
    procedure Set_Найменування(Value: UnicodeString);
    procedure Set_ПрийнятаКількість(Value: UnicodeString);
    procedure Set_БазоваЦіна(Value: UnicodeString);
    procedure Set_ОдиницяВиміру(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Ціна(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLВсьогоПоРядкуType }

  TXMLВсьогоПоРядкуType = class(TXMLNode, IXMLВсьогоПоРядкуType)
  protected
    { IXMLВсьогоПоРядкуType }
    function Get_СумаБезПДВ: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Сума: UnicodeString;
    procedure Set_СумаБезПДВ(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Сума(Value: UnicodeString);
  end;

{ TXMLВсьогоПоДокументуType }

  TXMLВсьогоПоДокументуType = class(TXMLNode, IXMLВсьогоПоДокументуType)
  protected
    { IXMLВсьогоПоДокументуType }
    function Get_СумаБезПДВ: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Сума: UnicodeString;
    procedure Set_СумаБезПДВ(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Сума(Value: UnicodeString);
  end;

{ Global Functions }

function GetЕлектроннийДокумент(Doc: IXMLDocument): IXMLЕлектроннийДокументType;
function LoadЕлектроннийДокумент(const FileName: string): IXMLЕлектроннийДокументType;
function NewЕлектроннийДокумент: IXMLЕлектроннийДокументType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetЕлектроннийДокумент(Doc: IXMLDocument): IXMLЕлектроннийДокументType;
begin
  Result := Doc.GetDocBinding('ЕлектроннийДокумент', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
end;

function LoadЕлектроннийДокумент(const FileName: string): IXMLЕлектроннийДокументType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ЕлектроннийДокумент', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
end;

function NewЕлектроннийДокумент: IXMLЕлектроннийДокументType;
begin
  Result := NewXMLDocument.GetDocBinding('ЕлектроннийДокумент', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
end;

{ TXMLЕлектроннийДокументType }

procedure TXMLЕлектроннийДокументType.AfterConstruction;
begin
  RegisterChildNode('Заголовок', TXMLЗаголовокType);
  RegisterChildNode('Сторони', TXMLСторониType);
  RegisterChildNode('Параметри', TXMLПараметриType);
  RegisterChildNode('Таблиця', TXMLТаблицяType);
  RegisterChildNode('ВсьогоПоДокументу', TXMLВсьогоПоДокументуType);
  inherited;
end;

function TXMLЕлектроннийДокументType.Get_Заголовок: IXMLЗаголовокType;
begin
  Result := ChildNodes['Заголовок'] as IXMLЗаголовокType;
end;

function TXMLЕлектроннийДокументType.Get_Сторони: IXMLСторониType;
begin
  Result := ChildNodes['Сторони'] as IXMLСторониType;
end;

function TXMLЕлектроннийДокументType.Get_Параметри: IXMLПараметриType;
begin
  Result := ChildNodes['Параметри'] as IXMLПараметриType;
end;

function TXMLЕлектроннийДокументType.Get_Таблиця: IXMLТаблицяType;
begin
  Result := ChildNodes['Таблиця'] as IXMLТаблицяType;
end;

function TXMLЕлектроннийДокументType.Get_ВсьогоПоДокументу: IXMLВсьогоПоДокументуType;
begin
  Result := ChildNodes['ВсьогоПоДокументу'] as IXMLВсьогоПоДокументуType;
end;

{ TXMLЗаголовокType }

procedure TXMLЗаголовокType.AfterConstruction;
begin
  RegisterChildNode('ДокПідстава', TXMLДокПідставаType);
  inherited;
end;

function TXMLЗаголовокType.Get_НомерДокументу: UnicodeString;
begin
  Result := ChildNodes['НомерДокументу'].NodeValue;
end;

procedure TXMLЗаголовокType.Set_НомерДокументу(Value: UnicodeString);
begin
  ChildNodes['НомерДокументу'].NodeValue := Value;
end;

function TXMLЗаголовокType.Get_ДатаДокументу: UnicodeString;
begin
  Result := ChildNodes['ДатаДокументу'].Text;
end;

procedure TXMLЗаголовокType.Set_ДатаДокументу(Value: UnicodeString);
begin
  ChildNodes['ДатаДокументу'].NodeValue := Value;
end;


function TXMLЗаголовокType.Get_НомерЗамовлення: UnicodeString;
begin
  Result := ChildNodes['НомерЗамовлення'].Text;
end;

procedure TXMLЗаголовокType.Set_НомерЗамовлення(Value: UnicodeString);
begin
  ChildNodes['НомерЗамовлення'].NodeValue := Value;
end;

function TXMLЗаголовокType.Get_ДатаЗамовлення: UnicodeString;
begin
  Result := ChildNodes['ДатаЗамовлення'].Text;
end;

procedure TXMLЗаголовокType.Set_ДатаЗамовлення(Value: UnicodeString);
begin
  ChildNodes['ДатаЗамовлення'].NodeValue := Value;
end;

function TXMLЗаголовокType.Get_ТипДокументу: UnicodeString;
begin
  Result := ChildNodes['ТипДокументу'].Text;
end;

procedure TXMLЗаголовокType.Set_ТипДокументу(Value: UnicodeString);
begin
  ChildNodes['ТипДокументу'].NodeValue := Value;
end;

function TXMLЗаголовокType.Get_КодТипуДокументу: UnicodeString;
begin
  Result := ChildNodes['КодТипуДокументу'].NodeValue;
end;

procedure TXMLЗаголовокType.Set_КодТипуДокументу(Value: UnicodeString);
begin
  ChildNodes['КодТипуДокументу'].NodeValue := Value;
end;

function TXMLЗаголовокType.Get_ДокПідстава: IXMLДокПідставаType;
begin
  Result := ChildNodes['ДокПідстава'] as IXMLДокПідставаType;
end;

{ TXMLДокПідставаType }

function TXMLДокПідставаType.Get_НомерДокументу: UnicodeString;
begin
  Result := ChildNodes['НомерДокументу'].Text;
end;

procedure TXMLДокПідставаType.Set_НомерДокументу(Value: UnicodeString);
begin
  ChildNodes['НомерДокументу'].NodeValue := Value;
end;

function TXMLДокПідставаType.Get_ТипДокументу: UnicodeString;
begin
  Result := ChildNodes['ТипДокументу'].Text;
end;

procedure TXMLДокПідставаType.Set_ТипДокументу(Value: UnicodeString);
begin
  ChildNodes['ТипДокументу'].NodeValue := Value;
end;

function TXMLДокПідставаType.Get_КодТипуДокументу: UnicodeString;
begin
  Result := ChildNodes['КодТипуДокументу'].NodeValue;
end;

procedure TXMLДокПідставаType.Set_КодТипуДокументу(Value: UnicodeString);
begin
  ChildNodes['КодТипуДокументу'].NodeValue := Value;
end;

function TXMLДокПідставаType.Get_ДатаДокументу: UnicodeString;
begin
  Result := ChildNodes['ДатаДокументу'].Text;
end;

procedure TXMLДокПідставаType.Set_ДатаДокументу(Value: UnicodeString);
begin
  ChildNodes['ДатаДокументу'].NodeValue := Value;
end;

{ TXMLСторониType }

procedure TXMLСторониType.AfterConstruction;
begin
  RegisterChildNode('Контрагент', TXMLКонтрагентType);
  ItemTag := 'Контрагент';
  ItemInterface := IXMLКонтрагентType;
  inherited;
end;

function TXMLСторониType.Get_Контрагент(Index: Integer): IXMLКонтрагентType;
begin
  Result := List[Index] as IXMLКонтрагентType;
end;

function TXMLСторониType.Add: IXMLКонтрагентType;
begin
  Result := AddItem(-1) as IXMLКонтрагентType;
end;

function TXMLСторониType.Insert(const Index: Integer): IXMLКонтрагентType;
begin
  Result := AddItem(Index) as IXMLКонтрагентType;
end;

{ TXMLКонтрагентType }

procedure TXMLКонтрагентType.AfterConstruction;
begin
  RegisterChildNode('ЮрАдреса', TXMLЮрАдресаType);
  inherited;
end;

function TXMLКонтрагентType.Get_СтатусКонтрагента: UnicodeString;
begin
  Result := ChildNodes['СтатусКонтрагента'].Text;
end;

procedure TXMLКонтрагентType.Set_СтатусКонтрагента(Value: UnicodeString);
begin
  ChildNodes['СтатусКонтрагента'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_GLN: UnicodeString;
begin
  Result := ChildNodes['GLN'].NodeValue;
end;

procedure TXMLКонтрагентType.Set_GLN(Value: UnicodeString);
begin
  ChildNodes['GLN'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_ІПН: UnicodeString;
begin
  Result := ChildNodes['ІПН'].NodeValue;
end;

procedure TXMLКонтрагентType.Set_ІПН(Value: UnicodeString);
begin
  ChildNodes['ІПН'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_КодКонтрагента: UnicodeString;
begin
  Result := ChildNodes['КодКонтрагента'].NodeValue;
end;

procedure TXMLКонтрагентType.Set_КодКонтрагента(Value: UnicodeString);
begin
  ChildNodes['КодКонтрагента'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_НазваКонтрагента: UnicodeString;
begin
  Result := ChildNodes['НазваКонтрагента'].Text;
end;

procedure TXMLКонтрагентType.Set_НазваКонтрагента(Value: UnicodeString);
begin
  ChildNodes['НазваКонтрагента'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_Телефон: UnicodeString;
begin
  Result := ChildNodes['Телефон'].Text;
end;

procedure TXMLКонтрагентType.Set_Телефон(Value: UnicodeString);
begin
  ChildNodes['Телефон'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_ЮрАдреса: IXMLЮрАдресаType;
begin
  Result := ChildNodes['ЮрАдреса'] as IXMLЮрАдресаType;
end;

{ TXMLЮрАдресаType }

function TXMLЮрАдресаType.Get_Індекс: Integer;
begin
  Result := ChildNodes['Індекс'].NodeValue;
end;

procedure TXMLЮрАдресаType.Set_Індекс(Value: Integer);
begin
  ChildNodes['Індекс'].NodeValue := Value;
end;

function TXMLЮрАдресаType.Get_Місто: UnicodeString;
begin
  Result := ChildNodes['Місто'].Text;
end;

procedure TXMLЮрАдресаType.Set_Місто(Value: UnicodeString);
begin
  ChildNodes['Місто'].NodeValue := Value;
end;

function TXMLЮрАдресаType.Get_Вулиця: UnicodeString;
begin
  Result := ChildNodes['Вулиця'].Text;
end;

procedure TXMLЮрАдресаType.Set_Вулиця(Value: UnicodeString);
begin
  ChildNodes['Вулиця'].NodeValue := Value;
end;

{ TXMLПараметриType }

procedure TXMLПараметриType.AfterConstruction;
begin
  RegisterChildNode('Параметр', TXMLПараметрType);
  ItemTag := 'Параметр';
  ItemInterface := IXMLПараметрType;
  inherited;
end;

function TXMLПараметриType.Get_Параметр(Index: Integer): IXMLПараметрType;
begin
  Result := List[Index] as IXMLПараметрType;
end;

function TXMLПараметриType.Add: IXMLПараметрType;
begin
  Result := AddItem(-1) as IXMLПараметрType;
end;

function TXMLПараметриType.Insert(const Index: Integer): IXMLПараметрType;
begin
  Result := AddItem(Index) as IXMLПараметрType;
end;

{ TXMLПараметрType }

function TXMLПараметрType.Get_назва: UnicodeString;
begin
  Result := AttributeNodes['назва'].Text;
end;

procedure TXMLПараметрType.Set_назва(Value: UnicodeString);
begin
  SetAttribute('назва', Value);
end;

{ TXMLТаблицяType }

procedure TXMLТаблицяType.AfterConstruction;
begin
  RegisterChildNode('Рядок', TXMLРядокType);
  ItemTag := 'Рядок';
  ItemInterface := IXMLРядокType;
  inherited;
end;

function TXMLТаблицяType.Get_Рядок(Index: Integer): IXMLРядокType;
begin
  Result := List[Index] as IXMLРядокType;
end;

function TXMLТаблицяType.Add: IXMLРядокType;
begin
  Result := AddItem(-1) as IXMLРядокType;
end;

function TXMLТаблицяType.Insert(const Index: Integer): IXMLРядокType;
begin
  Result := AddItem(Index) as IXMLРядокType;
end;

{ TXMLРядокType }

procedure TXMLРядокType.AfterConstruction;
begin
  RegisterChildNode('ВсьогоПоРядку', TXMLВсьогоПоРядкуType);
  inherited;
end;

function TXMLРядокType.Get_НомПоз: Integer;
begin
  Result := ChildNodes['НомПоз'].NodeValue;
end;

procedure TXMLРядокType.Set_НомПоз(Value: Integer);
begin
  ChildNodes['НомПоз'].NodeValue := Value;
end;

function TXMLРядокType.Get_Штрихкод: UnicodeString;
begin
  Result := ChildNodes['Штрихкод'].NodeValue;
end;

procedure TXMLРядокType.Set_Штрихкод(Value: UnicodeString);
begin
  ChildNodes['Штрихкод'].NodeValue := Value;
end;

function TXMLРядокType.Get_АртикулПокупця: UnicodeString;
begin
  Result := ChildNodes['АртикулПокупця'].NodeValue;
end;

procedure TXMLРядокType.Set_АртикулПокупця(Value: UnicodeString);
begin
  ChildNodes['АртикулПокупця'].NodeValue := Value;
end;

function TXMLРядокType.Get_АртикулПродавця: UnicodeString;
begin
  Result := ChildNodes['АртикулПродавця'].NodeValue;
end;

procedure TXMLРядокType.Set_АртикулПродавця(Value: UnicodeString);
begin
  ChildNodes['АртикулПродавця'].NodeValue := Value;
end;

function TXMLРядокType.Get_Найменування: UnicodeString;
begin
  Result := ChildNodes['Найменування'].Text;
end;

procedure TXMLРядокType.Set_Найменування(Value: UnicodeString);
begin
  ChildNodes['Найменування'].NodeValue := Value;
end;

function TXMLРядокType.Get_ПрийнятаКількість: UnicodeString;
begin
  Result := ChildNodes['ПрийнятаКількість'].Text;
end;

procedure TXMLРядокType.Set_ПрийнятаКількість(Value: UnicodeString);
begin
  ChildNodes['ПрийнятаКількість'].NodeValue := Value;
end;

function TXMLРядокType.Get_БазоваЦіна: UnicodeString;
begin
  Result := ChildNodes['БазоваЦіна'].Text;
end;

procedure TXMLРядокType.Set_БазоваЦіна(Value: UnicodeString);
begin
  ChildNodes['БазоваЦіна'].NodeValue := Value;
end;

function TXMLРядокType.Get_ОдиницяВиміру: UnicodeString;
begin
  Result := ChildNodes['ОдиницяВиміру'].Text;
end;

procedure TXMLРядокType.Set_ОдиницяВиміру(Value: UnicodeString);
begin
  ChildNodes['ОдиницяВиміру'].NodeValue := Value;
end;

function TXMLРядокType.Get_ПДВ: UnicodeString;
begin
  Result := ChildNodes['ПДВ'].Text;
end;

procedure TXMLРядокType.Set_ПДВ(Value: UnicodeString);
begin
  ChildNodes['ПДВ'].NodeValue := Value;
end;

function TXMLРядокType.Get_Ціна: UnicodeString;
begin
  Result := ChildNodes['Ціна'].Text;
end;

procedure TXMLРядокType.Set_Ціна(Value: UnicodeString);
begin
  ChildNodes['Ціна'].NodeValue := Value;
end;

function TXMLРядокType.Get_ВсьогоПоРядку: IXMLВсьогоПоРядкуType;
begin
  Result := ChildNodes['ВсьогоПоРядку'] as IXMLВсьогоПоРядкуType;
end;

{ TXMLВсьогоПоРядкуType }

function TXMLВсьогоПоРядкуType.Get_СумаБезПДВ: UnicodeString;
begin
  Result := ChildNodes['СумаБезПДВ'].Text;
end;

procedure TXMLВсьогоПоРядкуType.Set_СумаБезПДВ(Value: UnicodeString);
begin
  ChildNodes['СумаБезПДВ'].NodeValue := Value;
end;

function TXMLВсьогоПоРядкуType.Get_ПДВ: UnicodeString;
begin
  Result := ChildNodes['ПДВ'].Text;
end;

procedure TXMLВсьогоПоРядкуType.Set_ПДВ(Value: UnicodeString);
begin
  ChildNodes['ПДВ'].NodeValue := Value;
end;

function TXMLВсьогоПоРядкуType.Get_Сума: UnicodeString;
begin
  Result := ChildNodes['Сума'].Text;
end;

procedure TXMLВсьогоПоРядкуType.Set_Сума(Value: UnicodeString);
begin
  ChildNodes['Сума'].NodeValue := Value;
end;

{ TXMLВсьогоПоДокументуType }

function TXMLВсьогоПоДокументуType.Get_СумаБезПДВ: UnicodeString;
begin
  Result := ChildNodes['СумаБезПДВ'].Text;
end;

procedure TXMLВсьогоПоДокументуType.Set_СумаБезПДВ(Value: UnicodeString);
begin
  ChildNodes['СумаБезПДВ'].NodeValue := Value;
end;

function TXMLВсьогоПоДокументуType.Get_ПДВ: UnicodeString;
begin
  Result := ChildNodes['ПДВ'].Text;
end;

procedure TXMLВсьогоПоДокументуType.Set_ПДВ(Value: UnicodeString);
begin
  ChildNodes['ПДВ'].NodeValue := Value;
end;

function TXMLВсьогоПоДокументуType.Get_Сума: UnicodeString;
begin
  Result := ChildNodes['Сума'].Text;
end;

procedure TXMLВсьогоПоДокументуType.Set_Сума(Value: UnicodeString);
begin
  ChildNodes['Сума'].NodeValue := Value;
end;

end.