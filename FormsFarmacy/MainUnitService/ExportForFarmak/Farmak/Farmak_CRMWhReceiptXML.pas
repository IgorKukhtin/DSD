
{****************************************************************************}
{                                                                            }
{                              XML Data Binding                              }
{                                                                            }
{         Generated on: 07.03.2021 00:08:16                                  }
{       Generated from: D:\Work\Temp\FARMAK\CRM\Farmak_CRMWhReceiptXML.xml   }
{   Settings stored in: D:\Work\Temp\FARMAK\CRM\Farmak_CRMWhReceiptXML.xdb   }
{                                                                            }
{****************************************************************************}

unit Farmak_CRMWhReceiptXML;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLCRMWhReceiptType = interface;
  IXMLSchemeType = interface;
  IXMLDataType = interface;
  IXMLSType = interface;
  IXMLDType = interface;
  IXMLFType = interface;
  IXMLFTypeList = interface;
  IXMLRType = interface;
  IXMLRTypeList = interface;
  IXMLOType = interface;
  IXMLString_List = interface;

{ IXMLCRMWhReceiptType }

  IXMLCRMWhReceiptType = interface(IXMLNode)
    ['{C38DA625-9611-4A78-A048-1CBBE5EE0E1B}']
    { Property Accessors }
    function Get_User: Integer;
    function Get_Scheme: IXMLSchemeType;
    procedure Set_User(Value: Integer);
    { Methods & Properties }
    property User: Integer read Get_User write Set_User;
    property Scheme: IXMLSchemeType read Get_Scheme;
  end;

{ IXMLSchemeType }

  IXMLSchemeType = interface(IXMLNode)
    ['{8C8C4120-F10D-4753-971A-2C6CB77860CA}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Request: UnicodeString;
    function Get_Data: IXMLDataType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Request(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Request: UnicodeString read Get_Request write Set_Request;
    property Data: IXMLDataType read Get_Data;
  end;

{ IXMLDataType }

  IXMLDataType = interface(IXMLNode)
    ['{6D721C69-46E5-45FD-98FD-476A08A61F35}']
    { Property Accessors }
    function Get_S: IXMLSType;
    function Get_O: IXMLOType;
    { Methods & Properties }
    property S: IXMLSType read Get_S;
    property O: IXMLOType read Get_O;
  end;

{ IXMLSType }

  IXMLSType = interface(IXMLNode)
    ['{F9E12AE5-A4AE-4B0B-9E9E-A4305397D663}']
    { Property Accessors }
    function Get_D: IXMLDType;
    { Methods & Properties }
    property D: IXMLDType read Get_D;
  end;

{ IXMLDType }

  IXMLDType = interface(IXMLNode)
    ['{CF048845-D8F7-4C41-A3F8-F3F9E2665039}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_F: IXMLFTypeList;
    function Get_D: IXMLDType;
    function Get_R: IXMLRTypeList;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property F: IXMLFTypeList read Get_F;
    property D: IXMLDType read Get_D;
    property R: IXMLRTypeList read Get_R;
  end;

{ IXMLFType }

  IXMLFType = interface(IXMLNode)
    ['{F0F18C78-DECB-45FC-BB20-4A33EEC1F4FF}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
  end;

{ IXMLFTypeList }

  IXMLFTypeList = interface(IXMLNodeCollection)
    ['{DB57D95E-94C5-4B03-AC88-5EEFEC6C733D}']
    { Methods & Properties }
    function Add: IXMLFType;
    function Insert(const Index: Integer): IXMLFType;

    function Get_Item(Index: Integer): IXMLFType;
    property Items[Index: Integer]: IXMLFType read Get_Item; default;
  end;

{ IXMLRType }

  IXMLRType = interface(IXMLNode)
    ['{52638F8D-31E0-45D9-A4AE-5E25BAF86D80}']
    { Property Accessors }
    function Get_F: IXMLString_List;
    function Get_D: IXMLDType;
    { Methods & Properties }
    property F: IXMLString_List read Get_F;
    property D: IXMLDType read Get_D;
  end;

{ IXMLRTypeList }

  IXMLRTypeList = interface(IXMLNodeCollection)
    ['{008CA0EC-9B0F-4A01-A225-5E4B667D1886}']
    { Methods & Properties }
    function Add: IXMLRType;
    function Insert(const Index: Integer): IXMLRType;

    function Get_Item(Index: Integer): IXMLRType;
    property Items[Index: Integer]: IXMLRType read Get_Item; default;
  end;

{ IXMLOType }

  IXMLOType = interface(IXMLNodeCollection)
    ['{8D1E0F5E-3370-40B3-B8F6-2E684DF7E8F1}']
    { Property Accessors }
    function Get_D(Index: Integer): IXMLDType;
    { Methods & Properties }
    function Add: IXMLDType;
    function Insert(const Index: Integer): IXMLDType;
    property D[Index: Integer]: IXMLDType read Get_D; default;
  end;

{ IXMLString_List }

  IXMLString_List = interface(IXMLNodeCollection)
    ['{B73BEC27-8574-4B80-9057-89ED800CD9E0}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ Forward Decls }

  TXMLCRMWhReceiptType = class;
  TXMLSchemeType = class;
  TXMLDataType = class;
  TXMLSType = class;
  TXMLDType = class;
  TXMLFType = class;
  TXMLFTypeList = class;
  TXMLRType = class;
  TXMLRTypeList = class;
  TXMLOType = class;
  TXMLString_List = class;

{ TXMLCRMWhReceiptType }

  TXMLCRMWhReceiptType = class(TXMLNode, IXMLCRMWhReceiptType)
  protected
    { IXMLCRMWhReceiptType }
    function Get_User: Integer;
    function Get_Scheme: IXMLSchemeType;
    procedure Set_User(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSchemeType }

  TXMLSchemeType = class(TXMLNode, IXMLSchemeType)
  protected
    { IXMLSchemeType }
    function Get_Name: UnicodeString;
    function Get_Request: UnicodeString;
    function Get_Data: IXMLDataType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Request(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDataType }

  TXMLDataType = class(TXMLNode, IXMLDataType)
  protected
    { IXMLDataType }
    function Get_S: IXMLSType;
    function Get_O: IXMLOType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSType }

  TXMLSType = class(TXMLNode, IXMLSType)
  protected
    { IXMLSType }
    function Get_D: IXMLDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDType }

  TXMLDType = class(TXMLNode, IXMLDType)
  private
    FF: IXMLFTypeList;
    FR: IXMLRTypeList;
  protected
    { IXMLDType }
    function Get_Name: UnicodeString;
    function Get_F: IXMLFTypeList;
    function Get_D: IXMLDType;
    function Get_R: IXMLRTypeList;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFType }

  TXMLFType = class(TXMLNode, IXMLFType)
  protected
    { IXMLFType }
    function Get_Name: UnicodeString;
    function Get_Type_: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
  end;

{ TXMLFTypeList }

  TXMLFTypeList = class(TXMLNodeCollection, IXMLFTypeList)
  protected
    { IXMLFTypeList }
    function Add: IXMLFType;
    function Insert(const Index: Integer): IXMLFType;

    function Get_Item(Index: Integer): IXMLFType;
  end;

{ TXMLRType }

  TXMLRType = class(TXMLNode, IXMLRType)
  private
    FF: IXMLString_List;
  protected
    { IXMLRType }
    function Get_F: IXMLString_List;
    function Get_D: IXMLDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRTypeList }

  TXMLRTypeList = class(TXMLNodeCollection, IXMLRTypeList)
  protected
    { IXMLRTypeList }
    function Add: IXMLRType;
    function Insert(const Index: Integer): IXMLRType;

    function Get_Item(Index: Integer): IXMLRType;
  end;

{ TXMLOType }

  TXMLOType = class(TXMLNodeCollection, IXMLOType)
  protected
    { IXMLOType }
    function Get_D(Index: Integer): IXMLDType;
    function Add: IXMLDType;
    function Insert(const Index: Integer): IXMLDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLString_List }

  TXMLString_List = class(TXMLNodeCollection, IXMLString_List)
  protected
    { IXMLString_List }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ Global Functions }

function GetCRMWhReceipt(Doc: IXMLDocument): IXMLCRMWhReceiptType;
function LoadCRMWhReceipt(const FileName: string): IXMLCRMWhReceiptType;
function NewCRMWhReceipt: IXMLCRMWhReceiptType;

const
  TargetNamespace = '';

implementation

uses Xml.xmlutil;

{ Global Functions }

function GetCRMWhReceipt(Doc: IXMLDocument): IXMLCRMWhReceiptType;
begin
  Result := Doc.GetDocBinding('extdata', TXMLCRMWhReceiptType, TargetNamespace) as IXMLCRMWhReceiptType;
end;

function LoadCRMWhReceipt(const FileName: string): IXMLCRMWhReceiptType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('extdata', TXMLCRMWhReceiptType, TargetNamespace) as IXMLCRMWhReceiptType;
end;

function NewCRMWhReceipt: IXMLCRMWhReceiptType;
begin
  Result := NewXMLDocument.GetDocBinding('extdata', TXMLCRMWhReceiptType, TargetNamespace) as IXMLCRMWhReceiptType;
end;

{ TXMLCRMWhReceiptType }

procedure TXMLCRMWhReceiptType.AfterConstruction;
begin
  RegisterChildNode('scheme', TXMLSchemeType);
  inherited;
end;

function TXMLCRMWhReceiptType.Get_User: Integer;
begin
  Result := AttributeNodes['user'].NodeValue;
end;

procedure TXMLCRMWhReceiptType.Set_User(Value: Integer);
begin
  SetAttribute('user', Value);
end;

function TXMLCRMWhReceiptType.Get_Scheme: IXMLSchemeType;
begin
  Result := ChildNodes['scheme'] as IXMLSchemeType;
end;

{ TXMLSchemeType }

procedure TXMLSchemeType.AfterConstruction;
begin
  RegisterChildNode('data', TXMLDataType);
  inherited;
end;

function TXMLSchemeType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLSchemeType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLSchemeType.Get_Request: UnicodeString;
begin
  Result := AttributeNodes['request'].Text;
end;

procedure TXMLSchemeType.Set_Request(Value: UnicodeString);
begin
  SetAttribute('request', Value);
end;

function TXMLSchemeType.Get_Data: IXMLDataType;
begin
  Result := ChildNodes['data'] as IXMLDataType;
end;

{ TXMLDataType }

procedure TXMLDataType.AfterConstruction;
begin
  RegisterChildNode('s', TXMLSType);
  RegisterChildNode('o', TXMLOType);
  inherited;
end;

function TXMLDataType.Get_S: IXMLSType;
begin
  Result := ChildNodes[WideString('s')] as IXMLSType;
end;

function TXMLDataType.Get_O: IXMLOType;
begin
  Result := ChildNodes[WideString('o')] as IXMLOType;
end;

{ TXMLSType }

procedure TXMLSType.AfterConstruction;
begin
  RegisterChildNode('d', TXMLDType);
  inherited;
end;

function TXMLSType.Get_D: IXMLDType;
begin
  Result := ChildNodes[WideString('d')] as IXMLDType;
end;

{ TXMLDType }

procedure TXMLDType.AfterConstruction;
begin
  RegisterChildNode('f', TXMLFType);
  RegisterChildNode('d', TXMLDType);
  RegisterChildNode('r', TXMLRType);
  FF := CreateCollection(TXMLFTypeList, IXMLFType, 'f') as IXMLFTypeList;
  FR := CreateCollection(TXMLRTypeList, IXMLRType, 'r') as IXMLRTypeList;
  inherited;
end;

function TXMLDType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLDType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLDType.Get_F: IXMLFTypeList;
begin
  Result := FF;
end;

function TXMLDType.Get_D: IXMLDType;
begin
  Result := ChildNodes[WideString('d')] as IXMLDType;
end;

function TXMLDType.Get_R: IXMLRTypeList;
begin
  Result := FR;
end;

{ TXMLFType }

function TXMLFType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLFType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLFType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['type'].Text;
end;

procedure TXMLFType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('type', Value);
end;

{ TXMLFTypeList }

function TXMLFTypeList.Add: IXMLFType;
begin
  Result := AddItem(-1) as IXMLFType;
end;

function TXMLFTypeList.Insert(const Index: Integer): IXMLFType;
begin
  Result := AddItem(Index) as IXMLFType;
end;

function TXMLFTypeList.Get_Item(Index: Integer): IXMLFType;
begin
  Result := List[Index] as IXMLFType;
end;

{ TXMLRType }

procedure TXMLRType.AfterConstruction;
begin
  RegisterChildNode('d', TXMLDType);
  FF := CreateCollection(TXMLString_List, IXMLNode, 'f') as IXMLString_List;
  inherited;
end;

function TXMLRType.Get_F: IXMLString_List;
begin
  Result := FF;
end;

function TXMLRType.Get_D: IXMLDType;
begin
  Result := ChildNodes[WideString('d')] as IXMLDType;
end;

{ TXMLRTypeList }

function TXMLRTypeList.Add: IXMLRType;
begin
  Result := AddItem(-1) as IXMLRType;
end;

function TXMLRTypeList.Insert(const Index: Integer): IXMLRType;
begin
  Result := AddItem(Index) as IXMLRType;
end;

function TXMLRTypeList.Get_Item(Index: Integer): IXMLRType;
begin
  Result := List[Index] as IXMLRType;
end;

{ TXMLOType }

procedure TXMLOType.AfterConstruction;
begin
  RegisterChildNode('d', TXMLDType);
  ItemTag := 'd';
  ItemInterface := IXMLDType;
  inherited;
end;

function TXMLOType.Get_D(Index: Integer): IXMLDType;
begin
  Result := List[Index] as IXMLDType;
end;

function TXMLOType.Add: IXMLDType;
begin
  Result := AddItem(-1) as IXMLDType;
end;

function TXMLOType.Insert(const Index: Integer): IXMLDType;
begin
  Result := AddItem(Index) as IXMLDType;
end;

{ TXMLString_List }

function TXMLString_List.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLString_List.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLString_List.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

end.