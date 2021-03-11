
{************************************************************************}
{                                                                        }
{                            XML Data Binding                            }
{                                                                        }
{         Generated on: 02.03.2021 14:53:34                              }
{       Generated from: D:\Work\Temp\FARMAK\CRM\Farmak_CRMPharmacy.xml   }
{   Settings stored in: D:\Work\Temp\FARMAK\CRM\Farmak_CRMPharmacy.xdb   }
{                                                                        }
{************************************************************************}

unit Farmak_CRMPharmacyXML;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLCRMPharmacyType = interface;
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

{ IXMLCRMPharmacyType }

  IXMLCRMPharmacyType = interface(IXMLNode)
    ['{03C59DF5-0BF3-482D-9CAF-F1A0DCD2612A}']
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
    ['{A50178CC-7FA5-4A78-9695-953B8E8ABEEB}']
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
    ['{B301965B-3AFB-456A-9A8A-77D7E52F21FB}']
    { Property Accessors }
    function Get_S: IXMLSType;
    function Get_O: IXMLOType;
    { Methods & Properties }
    property S: IXMLSType read Get_S;
    property O: IXMLOType read Get_O;
  end;

{ IXMLSType }

  IXMLSType = interface(IXMLNode)
    ['{2F4E670E-C566-4254-B587-B8C3FADEC062}']
    { Property Accessors }
    function Get_D: IXMLDType;
    { Methods & Properties }
    property D: IXMLDType read Get_D;
  end;

{ IXMLDType }

  IXMLDType = interface(IXMLNode)
    ['{97470166-FFD7-4BD1-8226-13CFAD038476}']
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
    ['{E973A19F-2192-4593-AB72-387DC0D44443}']
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
    ['{51D90AEA-FB25-4B84-BC5B-648C9CFAF496}']
    { Methods & Properties }
    function Add: IXMLFType;
    function Insert(const Index: Integer): IXMLFType;

    function Get_Item(Index: Integer): IXMLFType;
    property Items[Index: Integer]: IXMLFType read Get_Item; default;
  end;

{ IXMLRType }

  IXMLRType = interface(IXMLNode)
    ['{E579F9F5-35E6-451F-9E72-C270C357DFA8}']
    { Property Accessors }
    function Get_F: IXMLString_List;
    function Get_D: IXMLDType;
    { Methods & Properties }
    property F: IXMLString_List read Get_F;
    property D: IXMLDType read Get_D;
  end;

{ IXMLRTypeList }

  IXMLRTypeList = interface(IXMLNodeCollection)
    ['{BC0B6DF7-12DA-4E5B-8C8C-4A7207AF0697}']
    { Methods & Properties }
    function Add: IXMLRType;
    function Insert(const Index: Integer): IXMLRType;

    function Get_Item(Index: Integer): IXMLRType;
    property Items[Index: Integer]: IXMLRType read Get_Item; default;
  end;

{ IXMLOType }

  IXMLOType = interface(IXMLNodeCollection)
    ['{AD59D7F8-4105-46C1-B536-347F70B77E4E}']
    { Property Accessors }
    function Get_D(Index: Integer): IXMLDType;
    { Methods & Properties }
    function Add: IXMLDType;
    function Insert(const Index: Integer): IXMLDType;
    property D[Index: Integer]: IXMLDType read Get_D; default;
  end;

{ IXMLString_List }

  IXMLString_List = interface(IXMLNodeCollection)
    ['{5DA5C19F-E44C-4C2C-A7EC-125FD4B8135F}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ Forward Decls }

  TXMLCRMPharmacyType = class;
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

{ TXMLCRMPharmacyType }

  TXMLCRMPharmacyType = class(TXMLNode, IXMLCRMPharmacyType)
  protected
    { IXMLCRMPharmacyType }
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

function GetCRMPharmacy(Doc: IXMLDocument): IXMLCRMPharmacyType;
function LoadCRMPharmacy(const FileName: string): IXMLCRMPharmacyType;
function NewCRMPharmacy: IXMLCRMPharmacyType;

const
  TargetNamespace = '';

implementation

uses Xml.xmlutil;

{ Global Functions }

function GetCRMPharmacy(Doc: IXMLDocument): IXMLCRMPharmacyType;
begin
  Result := Doc.GetDocBinding('extdata', TXMLCRMPharmacyType, TargetNamespace) as IXMLCRMPharmacyType;
end;

function LoadCRMPharmacy(const FileName: string): IXMLCRMPharmacyType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('extdata', TXMLCRMPharmacyType, TargetNamespace) as IXMLCRMPharmacyType;
end;

function NewCRMPharmacy: IXMLCRMPharmacyType;
begin
  Result := NewXMLDocument.GetDocBinding('extdata', TXMLCRMPharmacyType, TargetNamespace) as IXMLCRMPharmacyType;
end;

{ TXMLCRMPharmacyType }

procedure TXMLCRMPharmacyType.AfterConstruction;
begin
  RegisterChildNode('scheme', TXMLSchemeType);
  inherited;
end;

function TXMLCRMPharmacyType.Get_User: Integer;
begin
  Result := AttributeNodes['user'].NodeValue;
end;

procedure TXMLCRMPharmacyType.Set_User(Value: Integer);
begin
  SetAttribute('user', Value);
end;

function TXMLCRMPharmacyType.Get_Scheme: IXMLSchemeType;
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