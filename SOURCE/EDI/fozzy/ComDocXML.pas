
{*******************************************************************************}
{                                                                               }
{                               XML Data Binding                                }
{                                                                               }
{         Generated on: 21.11.2019 13:33:04                                     }
{       Generated from: D:\Work\Project\XML\comdoc_201911211036_545329106.xml   }
{   Settings stored in: D:\Work\Project\XML\comdoc_201911211036_545329106.xdb   }
{                                                                               }
{*******************************************************************************}

unit ComDocXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLЕлектроннийДокументType = interface;
  IXMLЗаголовокType = interface;
  IXMLСторониType = interface;
  IXMLКонтрагентType = interface;
  IXMLПараметриType = interface;
  IXMLПараметрType = interface;
  IXMLТаблицяType = interface;
  IXMLРядокType = interface;
  IXMLШтрихкодType = interface;

{ IXMLЕлектроннийДокументType }

  IXMLЕлектроннийДокументType = interface(IXMLNode)
    ['{7F3227B1-247B-4C01-8768-5DAAD0C14E57}']
    { Property Accessors }
    function Get_Заголовок: IXMLЗаголовокType;
    function Get_Сторони: IXMLСторониType;
    function Get_Параметри: IXMLПараметриType;
    function Get_Таблиця: IXMLТаблицяType;
    { Methods & Properties }
    property Заголовок: IXMLЗаголовокType read Get_Заголовок;
    property Сторони: IXMLСторониType read Get_Сторони;
    property Параметри: IXMLПараметриType read Get_Параметри;
    property Таблиця: IXMLТаблицяType read Get_Таблиця;
  end;

{ IXMLЗаголовокType }

  IXMLЗаголовокType = interface(IXMLNode)
    ['{FD932D61-ACD9-42B4-BCF8-C3C8956D5305}']
    { Property Accessors }
    function Get_НомерДокументу: UnicodeString;
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: Integer;
    function Get_ДатаДокументу: UnicodeString;
    function Get_НомерЗамовлення: UnicodeString;
    function Get_ДатаЗамовлення: UnicodeString;
    function Get_МісцеСкладання: UnicodeString;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: Integer);
    procedure Set_ДатаДокументу(Value: UnicodeString);
    procedure Set_НомерЗамовлення(Value: UnicodeString);
    procedure Set_ДатаЗамовлення(Value: UnicodeString);
    procedure Set_МісцеСкладання(Value: UnicodeString);
    { Methods & Properties }
    property НомерДокументу: UnicodeString read Get_НомерДокументу write Set_НомерДокументу;
    property ТипДокументу: UnicodeString read Get_ТипДокументу write Set_ТипДокументу;
    property КодТипуДокументу: Integer read Get_КодТипуДокументу write Set_КодТипуДокументу;
    property ДатаДокументу: UnicodeString read Get_ДатаДокументу write Set_ДатаДокументу;
    property НомерЗамовлення: UnicodeString read Get_НомерЗамовлення write Set_НомерЗамовлення;
    property ДатаЗамовлення: UnicodeString read Get_ДатаЗамовлення write Set_ДатаЗамовлення;
    property МісцеСкладання: UnicodeString read Get_МісцеСкладання write Set_МісцеСкладання;
  end;

{ IXMLСторониType }

  IXMLСторониType = interface(IXMLNodeCollection)
    ['{16514CB9-A1E3-4E7A-A171-15D6A4D5E7DB}']
    { Property Accessors }
    function Get_Контрагент(Index: Integer): IXMLКонтрагентType;
    { Methods & Properties }
    function Add: IXMLКонтрагентType;
    function Insert(const Index: Integer): IXMLКонтрагентType;
    property Контрагент[Index: Integer]: IXMLКонтрагентType read Get_Контрагент; default;
  end;

{ IXMLКонтрагентType }

  IXMLКонтрагентType = interface(IXMLNode)
    ['{C5C33254-CCB9-4146-A8D9-61E5517152B5}']
    { Property Accessors }
    function Get_СтатусКонтрагента: UnicodeString;
    function Get_ВидОсоби: UnicodeString;
    function Get_НазваКонтрагента: UnicodeString;
    function Get_КодКонтрагента: Integer;
    function Get_ІПН: Integer;
    function Get_GLN: Integer;
    procedure Set_СтатусКонтрагента(Value: UnicodeString);
    procedure Set_ВидОсоби(Value: UnicodeString);
    procedure Set_НазваКонтрагента(Value: UnicodeString);
    procedure Set_КодКонтрагента(Value: Integer);
    procedure Set_ІПН(Value: Integer);
    procedure Set_GLN(Value: Integer);
    { Methods & Properties }
    property СтатусКонтрагента: UnicodeString read Get_СтатусКонтрагента write Set_СтатусКонтрагента;
    property ВидОсоби: UnicodeString read Get_ВидОсоби write Set_ВидОсоби;
    property НазваКонтрагента: UnicodeString read Get_НазваКонтрагента write Set_НазваКонтрагента;
    property КодКонтрагента: Integer read Get_КодКонтрагента write Set_КодКонтрагента;
    property ІПН: Integer read Get_ІПН write Set_ІПН;
    property GLN: Integer read Get_GLN write Set_GLN;
  end;

{ IXMLПараметриType }

  IXMLПараметриType = interface(IXMLNodeCollection)
    ['{795A5564-999E-49AA-94AF-454870ABD0BE}']
    { Property Accessors }
    function Get_Параметр(Index: Integer): IXMLПараметрType;
    { Methods & Properties }
    function Add: IXMLПараметрType;
    function Insert(const Index: Integer): IXMLПараметрType;
    property Параметр[Index: Integer]: IXMLПараметрType read Get_Параметр; default;
  end;

{ IXMLПараметрType }

  IXMLПараметрType = interface(IXMLNode)
    ['{19AEFD74-3B85-414C-B2B0-1AEC98ECCDF9}']
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

  IXMLТаблицяType = interface(IXMLNode)
    ['{BF01A3DA-1E2D-4DD6-B4B2-F1D6248D32A3}']
    { Property Accessors }
    function Get_Рядок: IXMLРядокType;
    { Methods & Properties }
    property Рядок: IXMLРядокType read Get_Рядок;
  end;

{ IXMLРядокType }

  IXMLРядокType = interface(IXMLNode)
    ['{2829D0E2-328A-4431-A5C2-5507075B63F0}']
    { Property Accessors }
    function Get_ІД: Integer;
    function Get_НомПоз: Integer;
    function Get_Штрихкод: IXMLШтрихкодType;
    function Get_АртикулПокупця: Integer;
    function Get_Найменування: UnicodeString;
    function Get_ЗаявленаКількість: UnicodeString;
    function Get_ПрийнятаКількість: UnicodeString;
    function Get_ОдиницяВиміру: UnicodeString;
    function Get_БазоваЦіна: UnicodeString;
    function Get_Текст: Integer;
    procedure Set_ІД(Value: Integer);
    procedure Set_НомПоз(Value: Integer);
    procedure Set_АртикулПокупця(Value: Integer);
    procedure Set_Найменування(Value: UnicodeString);
    procedure Set_ЗаявленаКількість(Value: UnicodeString);
    procedure Set_ПрийнятаКількість(Value: UnicodeString);
    procedure Set_ОдиницяВиміру(Value: UnicodeString);
    procedure Set_БазоваЦіна(Value: UnicodeString);
    procedure Set_Текст(Value: Integer);
    { Methods & Properties }
    property ІД: Integer read Get_ІД write Set_ІД;
    property НомПоз: Integer read Get_НомПоз write Set_НомПоз;
    property Штрихкод: IXMLШтрихкодType read Get_Штрихкод;
    property АртикулПокупця: Integer read Get_АртикулПокупця write Set_АртикулПокупця;
    property Найменування: UnicodeString read Get_Найменування write Set_Найменування;
    property ЗаявленаКількість: UnicodeString read Get_ЗаявленаКількість write Set_ЗаявленаКількість;
    property ПрийнятаКількість: UnicodeString read Get_ПрийнятаКількість write Set_ПрийнятаКількість;
    property ОдиницяВиміру: UnicodeString read Get_ОдиницяВиміру write Set_ОдиницяВиміру;
    property БазоваЦіна: UnicodeString read Get_БазоваЦіна write Set_БазоваЦіна;
    property Текст: Integer read Get_Текст write Set_Текст;
  end;

{ IXMLШтрихкодType }

  IXMLШтрихкодType = interface(IXMLNode)
    ['{E871A5B1-9556-4710-96BC-C925FDACBC32}']
    { Property Accessors }
    function Get_ІД: Integer;
    procedure Set_ІД(Value: Integer);
    { Methods & Properties }
    property ІД: Integer read Get_ІД write Set_ІД;
  end;

{ Forward Decls }

  TXMLЕлектроннийДокументType = class;
  TXMLЗаголовокType = class;
  TXMLСторониType = class;
  TXMLКонтрагентType = class;
  TXMLПараметриType = class;
  TXMLПараметрType = class;
  TXMLТаблицяType = class;
  TXMLРядокType = class;
  TXMLШтрихкодType = class;

{ TXMLЕлектроннийДокументType }

  TXMLЕлектроннийДокументType = class(TXMLNode, IXMLЕлектроннийДокументType)
  protected
    { IXMLЕлектроннийДокументType }
    function Get_Заголовок: IXMLЗаголовокType;
    function Get_Сторони: IXMLСторониType;
    function Get_Параметри: IXMLПараметриType;
    function Get_Таблиця: IXMLТаблицяType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLЗаголовокType }

  TXMLЗаголовокType = class(TXMLNode, IXMLЗаголовокType)
  protected
    { IXMLЗаголовокType }
    function Get_НомерДокументу: UnicodeString;
    function Get_ТипДокументу: UnicodeString;
    function Get_КодТипуДокументу: Integer;
    function Get_ДатаДокументу: UnicodeString;
    function Get_НомерЗамовлення: UnicodeString;
    function Get_ДатаЗамовлення: UnicodeString;
    function Get_МісцеСкладання: UnicodeString;
    procedure Set_НомерДокументу(Value: UnicodeString);
    procedure Set_ТипДокументу(Value: UnicodeString);
    procedure Set_КодТипуДокументу(Value: Integer);
    procedure Set_ДатаДокументу(Value: UnicodeString);
    procedure Set_НомерЗамовлення(Value: UnicodeString);
    procedure Set_ДатаЗамовлення(Value: UnicodeString);
    procedure Set_МісцеСкладання(Value: UnicodeString);
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
    function Get_КодКонтрагента: Integer;
    function Get_ІПН: Integer;
    function Get_GLN: Integer;
    procedure Set_СтатусКонтрагента(Value: UnicodeString);
    procedure Set_ВидОсоби(Value: UnicodeString);
    procedure Set_НазваКонтрагента(Value: UnicodeString);
    procedure Set_КодКонтрагента(Value: Integer);
    procedure Set_ІПН(Value: Integer);
    procedure Set_GLN(Value: Integer);
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
    function Get_ІД: Integer;
    function Get_назва: UnicodeString;
    procedure Set_ІД(Value: Integer);
    procedure Set_назва(Value: UnicodeString);
  end;

{ TXMLТаблицяType }

  TXMLТаблицяType = class(TXMLNode, IXMLТаблицяType)
  protected
    { IXMLТаблицяType }
    function Get_Рядок: IXMLРядокType;
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
    function Get_АртикулПокупця: Integer;
    function Get_Найменування: UnicodeString;
    function Get_ЗаявленаКількість: UnicodeString;
    function Get_ПрийнятаКількість: UnicodeString;
    function Get_ОдиницяВиміру: UnicodeString;
    function Get_БазоваЦіна: UnicodeString;
    function Get_Текст: Integer;
    procedure Set_ІД(Value: Integer);
    procedure Set_НомПоз(Value: Integer);
    procedure Set_АртикулПокупця(Value: Integer);
    procedure Set_Найменування(Value: UnicodeString);
    procedure Set_ЗаявленаКількість(Value: UnicodeString);
    procedure Set_ПрийнятаКількість(Value: UnicodeString);
    procedure Set_ОдиницяВиміру(Value: UnicodeString);
    procedure Set_БазоваЦіна(Value: UnicodeString);
    procedure Set_Текст(Value: Integer);
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

{ Global Functions }

function GetComDoc(Doc: IXMLDocument): IXMLЕлектроннийДокументType;
function LoadComDoc(const FileName: string): IXMLЕлектроннийДокументType;
function NewComDoc: IXMLЕлектроннийДокументType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetComDoc(Doc: IXMLDocument): IXMLЕлектроннийДокументType;
begin
  Result := Doc.GetDocBinding('ComDoc', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
end;

function LoadComDoc(const FileName: string): IXMLЕлектроннийДокументType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ComDoc', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
end;

function NewComDoc: IXMLЕлектроннийДокументType;
begin
  Result := NewXMLDocument.GetDocBinding('ComDoc', TXMLЕлектроннийДокументType, TargetNamespace) as IXMLЕлектроннийДокументType;
end;

{ TXMLЕлектроннийДокументType }

procedure TXMLЕлектроннийДокументType.AfterConstruction;
begin
  RegisterChildNode('Заголовок', TXMLЗаголовокType);
  RegisterChildNode('Сторони', TXMLСторониType);
  RegisterChildNode('Параметри', TXMLПараметриType);
  RegisterChildNode('Таблиця', TXMLТаблицяType);
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

{ TXMLЗаголовокType }

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

function TXMLЗаголовокType.Get_КодТипуДокументу: Integer;
begin
  Result := ChildNodes['КодТипуДокументу'].NodeValue;
end;

procedure TXMLЗаголовокType.Set_КодТипуДокументу(Value: Integer);
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

function TXMLКонтрагентType.Get_КодКонтрагента: Integer;
begin
  Result := ChildNodes['КодКонтрагента'].NodeValue;
end;

procedure TXMLКонтрагентType.Set_КодКонтрагента(Value: Integer);
begin
  ChildNodes['КодКонтрагента'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_ІПН: Integer;
begin
  Result := ChildNodes['ІПН'].NodeValue;
end;

procedure TXMLКонтрагентType.Set_ІПН(Value: Integer);
begin
  ChildNodes['ІПН'].NodeValue := Value;
end;

function TXMLКонтрагентType.Get_GLN: Integer;
begin
  Result := ChildNodes['GLN'].NodeValue;
end;

procedure TXMLКонтрагентType.Set_GLN(Value: Integer);
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
  inherited;
end;

function TXMLТаблицяType.Get_Рядок: IXMLРядокType;
begin
  Result := ChildNodes['Рядок'] as IXMLРядокType;
end;

{ TXMLРядокType }

procedure TXMLРядокType.AfterConstruction;
begin
  RegisterChildNode('Штрихкод', TXMLШтрихкодType);
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

function TXMLРядокType.Get_АртикулПокупця: Integer;
begin
  Result := ChildNodes['АртикулПокупця'].NodeValue;
end;

procedure TXMLРядокType.Set_АртикулПокупця(Value: Integer);
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

function TXMLРядокType.Get_ЗаявленаКількість: UnicodeString;
begin
  Result := ChildNodes['ЗаявленаКількість'].Text;
end;

procedure TXMLРядокType.Set_ЗаявленаКількість(Value: UnicodeString);
begin
  ChildNodes['ЗаявленаКількість'].NodeValue := Value;
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

function TXMLРядокType.Get_Текст: Integer;
begin
  Result := ChildNodes['Текст'].NodeValue;
end;

procedure TXMLРядокType.Set_Текст(Value: Integer);
begin
  ChildNodes['Текст'].NodeValue := Value;
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

end.