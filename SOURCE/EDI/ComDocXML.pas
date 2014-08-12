unit ComDocXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLЕлектроннийДокументType = interface;
  IXMLЗаголовокType = interface;
  IXMLДокПідставаType = interface;
  IXMLСторониType = interface;
  IXMLКонтрагентType = interface;
  IXMLПараметриType = interface;
  IXMLПараметрType = interface;
  IXMLТаблицяType = interface;
  IXMLРядокType = interface;
  IXMLШтрихкодType = interface;
  IXMLВсьогоПоРядкуType = interface;
  IXMLДоПоверненняType = interface;
  IXMLВсьогоПоДокументуType = interface;

{ IXMLЕлектроннийДокументType }

  IXMLЕлектроннийДокументType = interface(IXMLNode)
    ['{9DF9164B-0E86-4F6D-8CD9-619754D2EE0D}']
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
    ['{F16C56EC-DCFC-43CC-AC73-34EF74218B6F}']
    { Property Accessors }
    function Get_НомерДокументу: UnicodeString;
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: UnicodeString;
    function Get_ДатаДокументу: UnicodeString;
    function Get_НомерЗамовлення: UnicodeString;
    function Get_ДатаЗамовлення: UnicodeString;
    function Get_МісцеСкладання: UnicodeString;
    function Get_ДокПідстава: IXMLДокПідставаType;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: UnicodeString);
    procedure Set_ДатаДокументу(Value: UnicodeString);
    procedure Set_НомерЗамовлення(Value: UnicodeString);
    procedure Set_ДатаЗамовлення(Value: UnicodeString);
    procedure Set_МісцеСкладання(Value: UnicodeString);
    { Methods & Properties }
    property НомерДокументу: UnicodeString read Get_НомерДокументу write Set_НомерДокументу;
    property ТипДокументу: UnicodeString read Get_ТипДокументу write Set_ТипДокументу;
    property КодТипуДокументу: UnicodeString read Get_КодТипуДокументу write Set_КодТипуДокументу;
    property ДатаДокументу: UnicodeString read Get_ДатаДокументу write Set_ДатаДокументу;
    property НомерЗамовлення: UnicodeString read Get_НомерЗамовлення write Set_НомерЗамовлення;
    property ДатаЗамовлення: UnicodeString read Get_ДатаЗамовлення write Set_ДатаЗамовлення;
    property МісцеСкладання: UnicodeString read Get_МісцеСкладання write Set_МісцеСкладання;
    property ДокПідстава: IXMLДокПідставаType read Get_ДокПідстава;
end;

{ IXMLДокПідставаType }

  IXMLДокПідставаType = interface(IXMLNode)
    ['{A0FE8FAB-308F-463F-A37D-889038B51506}']
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
    ['{78F798DC-7528-46E5-A61F-8870C8D581DB}']
    { Property Accessors }
    function Get_Контрагент(Index: Integer): IXMLКонтрагентType;
    { Methods & Properties }
    function Add: IXMLКонтрагентType;
    function Insert(const Index: Integer): IXMLКонтрагентType;
    property Контрагент[Index: Integer]: IXMLКонтрагентType read Get_Контрагент; default;
  end;

{ IXMLКонтрагентType }

  IXMLКонтрагентType = interface(IXMLNode)
    ['{81D5009D-3F3C-4B99-83A7-3FFDD7D94B22}']
    { Property Accessors }
    function Get_СтатусКонтрагента: UnicodeString;
    function Get_ВидОсоби: UnicodeString;
    function Get_НазваКонтрагента: UnicodeString;
    function Get_КодКонтрагента: UnicodeString;
    function Get_ІПН: UnicodeString;
    function Get_СвідоцтвоПДВ: UnicodeString;
    function Get_GLN: UnicodeString;
    procedure Set_СтатусКонтрагента(Value: UnicodeString);
    procedure Set_ВидОсоби(Value: UnicodeString);
    procedure Set_НазваКонтрагента(Value: UnicodeString);
    procedure Set_КодКонтрагента(Value: UnicodeString);
    procedure Set_ІПН(Value: UnicodeString);
    procedure Set_СвідоцтвоПДВ(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
    { Methods & Properties }
    property СтатусКонтрагента: UnicodeString read Get_СтатусКонтрагента write Set_СтатусКонтрагента;
    property ВидОсоби: UnicodeString read Get_ВидОсоби write Set_ВидОсоби;
    property НазваКонтрагента: UnicodeString read Get_НазваКонтрагента write Set_НазваКонтрагента;
    property КодКонтрагента: UnicodeString read Get_КодКонтрагента write Set_КодКонтрагента;
    property ІПН: UnicodeString read Get_ІПН write Set_ІПН;
    property СвідоцтвоПДВ: UnicodeString read Get_СвідоцтвоПДВ write Set_СвідоцтвоПДВ;
    property GLN: UnicodeString read Get_GLN write Set_GLN;
  end;

{ IXMLПараметриType }

  IXMLПараметриType = interface(IXMLNodeCollection)
    ['{CAB95EA0-C902-4858-A1C1-E79BFEA3C4AC}']
    { Property Accessors }
    function Get_Параметр(Index: Integer): IXMLПараметрType;
    { Methods & Properties }
    function Add: IXMLПараметрType;
    function Insert(const Index: Integer): IXMLПараметрType;
    function ParamByName(const Name: string): IXMLПараметрType;
    property Параметр[Index: Integer]: IXMLПараметрType read Get_Параметр; default;
  end;

{ IXMLПараметрType }

  IXMLПараметрType = interface(IXMLNode)
    ['{723FAA54-9338-4FBF-9322-B33B970FB1B5}']
    { Property Accessors }
    function Get_ІД: Integer;
    function Get_назва: UnicodeString;
    procedure Set_ІД(Value: Integer);
    procedure Set_назва(Value: UnicodeString);
    { Methods & Properties }
    property ІД: Integer read Get_ІД write Set_ІД;
    property назва: UnicodeString read Get_назва write Set_назва;
  end;

{ IXMLТаблицяType }

  IXMLТаблицяType = interface(IXMLNodeCollection)
    ['{A0D86ABA-62BC-45A2-BCAF-678C7E2CD5F7}']
    { Property Accessors }
    function Get_Рядок(Index: Integer): IXMLРядокType;
    { Methods & Properties }
    function Add: IXMLРядокType;
    function Insert(const Index: Integer): IXMLРядокType;
    property Рядок[Index: Integer]: IXMLРядокType read Get_Рядок; default;
  end;

{ IXMLРядокType }

  IXMLРядокType = interface(IXMLNode)
    ['{3D10A9C3-3154-4E4C-90A4-2EE03B21F874}']
    { Property Accessors }
    function Get_ІД: Integer;
    function Get_НомПоз: Integer;
    function Get_Штрихкод: IXMLШтрихкодType;
    function Get_АртикулПокупця: UnicodeString;
    function Get_Найменування: UnicodeString;
    function Get_ПрийнятаКількість: UnicodeString;
    function Get_ОдиницяВиміру: UnicodeString;
    function Get_БазоваЦіна: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Ціна: UnicodeString;
    function Get_ВсьогоПоРядку: IXMLВсьогоПоРядкуType;
    function Get_ДоПовернення: IXMLДоПоверненняType;
    procedure Set_ІД(Value: Integer);
    procedure Set_НомПоз(Value: Integer);
    procedure Set_АртикулПокупця(Value: UnicodeString);
    procedure Set_Найменування(Value: UnicodeString);
    procedure Set_ПрийнятаКількість(Value: UnicodeString);
    procedure Set_ОдиницяВиміру(Value: UnicodeString);
    procedure Set_БазоваЦіна(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Ціна(Value: UnicodeString);
    { Methods & Properties }
    property ІД: Integer read Get_ІД write Set_ІД;
    property НомПоз: Integer read Get_НомПоз write Set_НомПоз;
    property Штрихкод: IXMLШтрихкодType read Get_Штрихкод;
    property АртикулПокупця: UnicodeString read Get_АртикулПокупця write Set_АртикулПокупця;
    property Найменування: UnicodeString read Get_Найменування write Set_Найменування;
    property ПрийнятаКількість: UnicodeString read Get_ПрийнятаКількість write Set_ПрийнятаКількість;
    property ОдиницяВиміру: UnicodeString read Get_ОдиницяВиміру write Set_ОдиницяВиміру;
    property БазоваЦіна: UnicodeString read Get_БазоваЦіна write Set_БазоваЦіна;
    property ПДВ: UnicodeString read Get_ПДВ write Set_ПДВ;
    property Ціна: UnicodeString read Get_Ціна write Set_Ціна;
    property ВсьогоПоРядку: IXMLВсьогоПоРядкуType read Get_ВсьогоПоРядку;
    property ДоПовернення: IXMLДоПоверненняType read Get_ДоПовернення;
  end;

{ IXMLШтрихкодType }

  IXMLШтрихкодType = interface(IXMLNode)
    ['{6DFC1F15-000E-457C-A077-7691E96CB61B}']
    { Property Accessors }
    function Get_ІД: Integer;
    procedure Set_ІД(Value: Integer);
    { Methods & Properties }
    property ІД: Integer read Get_ІД write Set_ІД;
  end;

{ IXMLДоПоверненняType }

  IXMLДоПоверненняType = interface(IXMLNode)
    ['{6C154905-794B-4E10-AFCB-C903BAA9B3F2}']
    { Property Accessors }
    function Get_Кількість: UnicodeString;
    procedure Set_Кількість(Value: UnicodeString);
    { Methods & Properties }
    property Кількість: UnicodeString read Get_Кількість write Set_Кількість;
  end;

{ IXMLВсьогоПоРядкуType }

  IXMLВсьогоПоРядкуType = interface(IXMLNode)
    ['{AC5D2A22-9C35-42EF-B828-299499F3AD9B}']
    { Property Accessors }
    function Get_СумаБезПДВ: UnicodeString;
    function Get_СумаПДВ: UnicodeString;
    function Get_Сума: UnicodeString;
    procedure Set_СумаБезПДВ(Value: UnicodeString);
    procedure Set_СумаПДВ(Value: UnicodeString);
    procedure Set_Сума(Value: UnicodeString);
    { Methods & Properties }
    property СумаБезПДВ: UnicodeString read Get_СумаБезПДВ write Set_СумаБезПДВ;
    property СумаПДВ: UnicodeString read Get_СумаПДВ write Set_СумаПДВ;
    property Сума: UnicodeString read Get_Сума write Set_Сума;
  end;

{ IXMLВсьогоПоДокументуType }

  IXMLВсьогоПоДокументуType = interface(IXMLNode)
    ['{40706B07-08C3-4D78-826F-3C8785E06FF6}']
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
  TXMLПараметриType = class;
  TXMLПараметрType = class;
  TXMLТаблицяType = class;
  TXMLРядокType = class;
  TXMLШтрихкодType = class;
  TXMLВсьогоПоРядкуType = class;
  TXMLДоПоверненняType = class;
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
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: UnicodeString;
    function Get_ДатаДокументу: UnicodeString;
    function Get_НомерЗамовлення: UnicodeString;
    function Get_ДатаЗамовлення: UnicodeString;
    function Get_МісцеСкладання: UnicodeString;
    function Get_ДокПідстава: IXMLДокПідставаType;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: UnicodeString);
    procedure Set_ДатаДокументу(Value: UnicodeString);
    procedure Set_НомерЗамовлення(Value: UnicodeString);
    procedure Set_ДатаЗамовлення(Value: UnicodeString);
    procedure Set_МісцеСкладання(Value: UnicodeString);
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
    function Get_ВидОсоби: UnicodeString;
    function Get_НазваКонтрагента: UnicodeString;
    function Get_КодКонтрагента: UnicodeString;
    function Get_ІПН: UnicodeString;
    function Get_СвідоцтвоПДВ: UnicodeString;
    function Get_GLN: UnicodeString;
    procedure Set_СтатусКонтрагента(Value: UnicodeString);
    procedure Set_ВидОсоби(Value: UnicodeString);
    procedure Set_НазваКонтрагента(Value: UnicodeString);
    procedure Set_КодКонтрагента(Value: UnicodeString);
    procedure Set_ІПН(Value: UnicodeString);
    procedure Set_СвідоцтвоПДВ(Value: UnicodeString);
    procedure Set_GLN(Value: UnicodeString);
  end;

{ TXMLПараметриType }

  TXMLПараметриType = class(TXMLNodeCollection, IXMLПараметриType)
  protected
    { IXMLПараметриType }
    function Get_Параметр(Index: Integer): IXMLПараметрType;
    function Add: IXMLПараметрType;
    function Insert(const Index: Integer): IXMLПараметрType;
    function ParamByName(const Name: string): IXMLПараметрType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLПараметрType }

  TXMLПараметрType = class(TXMLNode, IXMLПараметрType)
  protected
    { IXMLПараметрType }
    function Get_ІД: Integer;
    function Get_назва: UnicodeString;
    procedure Set_ІД(Value: Integer);
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
    function Get_ІД: Integer;
    function Get_НомПоз: Integer;
    function Get_Штрихкод: IXMLШтрихкодType;
    function Get_АртикулПокупця: UnicodeString;
    function Get_Найменування: UnicodeString;
    function Get_ПрийнятаКількість: UnicodeString;
    function Get_ОдиницяВиміру: UnicodeString;
    function Get_БазоваЦіна: UnicodeString;
    function Get_ПДВ: UnicodeString;
    function Get_Ціна: UnicodeString;
    function Get_ВсьогоПоРядку: IXMLВсьогоПоРядкуType;
    function Get_ДоПовернення: IXMLДоПоверненняType;
    procedure Set_ІД(Value: Integer);
    procedure Set_НомПоз(Value: Integer);
    procedure Set_АртикулПокупця(Value: UnicodeString);
    procedure Set_Найменування(Value: UnicodeString);
    procedure Set_ПрийнятаКількість(Value: UnicodeString);
    procedure Set_ОдиницяВиміру(Value: UnicodeString);
    procedure Set_БазоваЦіна(Value: UnicodeString);
    procedure Set_ПДВ(Value: UnicodeString);
    procedure Set_Ціна(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLШтрихкодType }

  TXMLШтрихкодType = class(TXMLNode, IXMLШтрихкодType)
  protected
    { IXMLШтрихкодType }
    function Get_ІД: Integer;
    procedure Set_ІД(Value: Integer);
  end;

{ TXMLВсьогоПоРядкуType }

  TXMLВсьогоПоРядкуType = class(TXMLNode, IXMLВсьогоПоРядкуType)
  protected
    { IXMLВсьогоПоРядкуType }
    function Get_СумаБезПДВ: UnicodeString;
    function Get_СумаПДВ: UnicodeString;
    function Get_Сума: UnicodeString;
    procedure Set_СумаБезПДВ(Value: UnicodeString);
    procedure Set_СумаПДВ(Value: UnicodeString);
    procedure Set_Сума(Value: UnicodeString);
  end;

{ TXMLДоПоверненняType }

  TXMLДоПоверненняType = class(TXMLNode, IXMLДоПоверненняType)
  protected
    { IXMLДоПоверненняType }
    function Get_Кількість: UnicodeString;
    procedure Set_Кількість(Value: UnicodeString);
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
function LoadЕлектроннийДокумент(const XMLString: string): IXMLЕлектроннийДокументType;
function NewЕлектроннийДокумент: IXMLЕлектроннийДокументType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetЕлектроннийДокумент(Doc: IXMLDocument): IXMLЕлектроннийДокументType;
begin
  Result := Doc.GetDocBinding('ЕлектроннийДокумент', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
end;

function LoadЕлектроннийДокумент(const XMLString: string): IXMLЕлектроннийДокументType;
begin
  with NewXMLDocument do begin
    LoadFromXML(XMLString);
    Result := GetDocBinding('ЕлектроннийДокумент', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
  end;
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
  Result := ChildNodes['НомерДокументу'].Text;
end;

procedure TXMLЗаголовокType.Set_НомерДокументу(Value: UnicodeString);
begin
  ChildNodes['НомерДокументу'].NodeValue := Value;
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
  Result := ChildNodes['КодТипуДокументу'].Text;
end;

procedure TXMLЗаголовокType.Set_КодТипуДокументу(Value: UnicodeString);
begin
  ChildNodes['КодТипуДокументу'].NodeValue := Value;
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

function TXMLЗаголовокType.Get_ДокПідстава: IXMLДокПідставаType;
begin
  Result := ChildNodes['ДокПідстава'] as IXMLДокПідставаType;
end;

procedure TXMLЗаголовокType.Set_ДатаЗамовлення(Value: UnicodeString);
begin
  ChildNodes['ДатаЗамовлення'].NodeValue := Value;
end;

function TXMLЗаголовокType.Get_МісцеСкладання: UnicodeString;
begin
  Result := ChildNodes['МісцеСкладання'].Text;
end;

procedure TXMLЗаголовокType.Set_МісцеСкладання(Value: UnicodeString);
begin
  ChildNodes['МісцеСкладання'].NodeValue := Value;
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
  Result := ChildNodes['КодТипуДокументу'].Text;
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

function TXMLКонтрагентType.Get_СтатусКонтрагента: UnicodeString;
begin
  Result := ChildNodes['СтатусКонтрагента'].Text;
end;

procedure TXMLКонтрагентType.Set_СтатусКонтрагента(Value: UnicodeString);
begin
  ChildNodes['СтатусКонтрагента'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_ВидОсоби: UnicodeString;
begin
  Result := ChildNodes['ВидОсоби'].Text;
end;

procedure TXMLКонтрагентType.Set_ВидОсоби(Value: UnicodeString);
begin
  ChildNodes['ВидОсоби'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_НазваКонтрагента: UnicodeString;
begin
  Result := ChildNodes['НазваКонтрагента'].Text;
end;

procedure TXMLКонтрагентType.Set_НазваКонтрагента(Value: UnicodeString);
begin
  ChildNodes['НазваКонтрагента'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_КодКонтрагента: UnicodeString;
begin
  Result := ChildNodes['КодКонтрагента'].Text;
end;

procedure TXMLКонтрагентType.Set_КодКонтрагента(Value: UnicodeString);
begin
  ChildNodes['КодКонтрагента'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_ІПН: UnicodeString;
begin
  Result := ChildNodes['ІПН'].Text;
end;

procedure TXMLКонтрагентType.Set_ІПН(Value: UnicodeString);
begin
  ChildNodes['ІПН'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_СвідоцтвоПДВ: UnicodeString;
begin
  Result := ChildNodes['СвідоцтвоПДВ'].Text;
end;

procedure TXMLКонтрагентType.Set_СвідоцтвоПДВ(Value: UnicodeString);
begin
  ChildNodes['СвідоцтвоПДВ'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_GLN: UnicodeString;
begin
  Result := ChildNodes['GLN'].Text;
end;

procedure TXMLКонтрагентType.Set_GLN(Value: UnicodeString);
begin
  ChildNodes['GLN'].NodeValue := Value;
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

function TXMLПараметриType.ParamByName(
  const Name: string): IXMLПараметрType;
var i: integer;
begin
  result := nil;
  for i := 0 to GetCount - 1 do
      if Get_Параметр(i).назва = Name then begin
         result := Get_Параметр(i);
         break
      end;
end;

{ TXMLПараметрType }

function TXMLПараметрType.Get_ІД: Integer;
begin
  Result := AttributeNodes['ІД'].NodeValue;
end;

procedure TXMLПараметрType.Set_ІД(Value: Integer);
begin
  SetAttribute('ІД', Value);
end;

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
  RegisterChildNode('Штрихкод', TXMLШтрихкодType);
  RegisterChildNode('ВсьогоПоРядку', TXMLВсьогоПоРядкуType);
  RegisterChildNode('ДоПовернення', TXMLДоПоверненняType);
  inherited;
end;

function TXMLРядокType.Get_ІД: Integer;
begin
  Result := AttributeNodes['ІД'].NodeValue;
end;

procedure TXMLРядокType.Set_ІД(Value: Integer);
begin
  SetAttribute('ІД', Value);
end;

function TXMLРядокType.Get_НомПоз: Integer;
begin
  Result := ChildNodes['НомПоз'].NodeValue;
end;

procedure TXMLРядокType.Set_НомПоз(Value: Integer);
begin
  ChildNodes['НомПоз'].NodeValue := Value;
end;

function TXMLРядокType.Get_Штрихкод: IXMLШтрихкодType;
begin
  Result := ChildNodes['Штрихкод'] as IXMLШтрихкодType;
end;

function TXMLРядокType.Get_АртикулПокупця: UnicodeString;
begin
  Result := ChildNodes['АртикулПокупця'].Text;
end;

procedure TXMLРядокType.Set_АртикулПокупця(Value: UnicodeString);
begin
  ChildNodes['АртикулПокупця'].NodeValue := Value;
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

function TXMLРядокType.Get_ОдиницяВиміру: UnicodeString;
begin
  Result := ChildNodes['ОдиницяВиміру'].Text;
end;

procedure TXMLРядокType.Set_ОдиницяВиміру(Value: UnicodeString);
begin
  ChildNodes['ОдиницяВиміру'].NodeValue := Value;
end;

function TXMLРядокType.Get_БазоваЦіна: UnicodeString;
begin
  Result := ChildNodes['БазоваЦіна'].Text;
end;

procedure TXMLРядокType.Set_БазоваЦіна(Value: UnicodeString);
begin
  ChildNodes['БазоваЦіна'].NodeValue := Value;
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

function TXMLРядокType.Get_ДоПовернення: IXMLДоПоверненняType;
begin
  Result := ChildNodes['ДоПовернення'] as IXMLДоПоверненняType;
end;

{ TXMLШтрихкодType }

function TXMLШтрихкодType.Get_ІД: Integer;
begin
  Result := AttributeNodes['ІД'].NodeValue;
end;

procedure TXMLШтрихкодType.Set_ІД(Value: Integer);
begin
  SetAttribute('ІД', Value);
end;

{ TXMLДоПоверненняType }

function TXMLДоПоверненняType.Get_Кількість: UnicodeString;
begin
  Result := ChildNodes['Кількість'].Text;
end;

procedure TXMLДоПоверненняType.Set_Кількість(Value: UnicodeString);
begin
  ChildNodes['Кількість'].NodeValue := Value;
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

function TXMLВсьогоПоРядкуType.Get_СумаПДВ: UnicodeString;
begin
  Result := ChildNodes['СумаПДВ'].Text;
end;

procedure TXMLВсьогоПоРядкуType.Set_СумаПДВ(Value: UnicodeString);
begin
  ChildNodes['СумаПДВ'].NodeValue := Value;
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
