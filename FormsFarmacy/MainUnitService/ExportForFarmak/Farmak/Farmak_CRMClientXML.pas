
{*************************************************************************}
{                                                                         }
{                            XML Data Binding                             }
{                                                                         }
{         Generated on: 10.03.2021 16:15:35                               }
{       Generated from: D:\Work\Temp\FARMAK\CRM\Farmak_CRMClientXML.xml   }
{   Settings stored in: D:\Work\Temp\FARMAK\CRM\Farmak_CRMClientXML.xdb   }
{                                                                         }
{*************************************************************************}

unit Farmak_CRMClientXML;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLCRMClientType = interface;
  IXMLSchemeType = interface;
  IXMLDataType = interface;
  IXMLSType = interface;
  IXMLDType = interface;
  IXMLFType = interface;
  IXMLFTypeList = interface;
  IXMLRType = interface;
  IXMLRTypeList = interface;
  IXMLOType = interface;

{ IXMLCRMClientType }

  IXMLCRMClientType = interface(IXMLNode)
    ['{FE84A50F-DFE1-40CC-AC28-7997E33CD7B0}']
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
    ['{61BBB934-2A4F-4A9F-8C34-0C2F5BC9A8BA}']
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
    ['{5EB9E4C1-CFB9-4DD1-8414-FD02AFB00CB3}']
    { Property Accessors }
    function Get_S: IXMLSType;
    function Get_O: IXMLOType;
    { Methods & Properties }
    property S: IXMLSType read Get_S;
    property O: IXMLOType read Get_O;
  end;

{ IXMLSType }

  IXMLSType = interface(IXMLNode)
    ['{CF546049-A542-4C04-A635-67B82883FC91}']
    { Property Accessors }
    function Get_D: IXMLDType;
    { Methods & Properties }
    property D: IXMLDType read Get_D;
  end;

{ IXMLDType }

  IXMLDType = interface(IXMLNode)
    ['{BD3AD1BC-37E6-4E83-BA20-0DCBAB0E3559}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_F: IXMLFTypeList;
    function Get_R: IXMLRTypeList;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property F: IXMLFTypeList read Get_F;
    property R: IXMLRTypeList read Get_R;
  end;

{ IXMLFType }

  IXMLFType = interface(IXMLNode)
    ['{9B342E5B-EC71-46F4-9BFE-C545871FEC09}']
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
    ['{5DD31DB7-1E02-4937-8147-1EA228E5AB30}']
    { Methods & Properties }
    function Add: IXMLFType;
    function Insert(const Index: Integer): IXMLFType;

    function Get_Item(Index: Integer): IXMLFType;
    property Items[Index: Integer]: IXMLFType read Get_Item; default;
  end;

{ IXMLRType }

  IXMLRType = interface(IXMLNodeCollection)
    ['{78E4F77A-0601-477C-8821-2C67E9D1D225}']
    { Property Accessors }
    function Get_F(Index: Integer): UnicodeString;
    { Methods & Properties }
    function Add(const F: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const F: UnicodeString): IXMLNode;
    property F[Index: Integer]: UnicodeString read Get_F; default;
  end;

{ IXMLRTypeList }

  IXMLRTypeList = interface(IXMLNodeCollection)
    ['{DBF76B88-CF0F-4C64-9BD7-6112925D1D7D}']
    { Methods & Properties }
    function Add: IXMLRType;
    function Insert(const Index: Integer): IXMLRType;

    function Get_Item(Index: Integer): IXMLRType;
    property Items[Index: Integer]: IXMLRType read Get_Item; default;
  end;

{ IXMLOType }

  IXMLOType = interface(IXMLNode)
    ['{19FC31E6-27A4-42E9-B242-B998E555B22B}']
    { Property Accessors }
    function Get_D: IXMLDType;
    { Methods & Properties }
    property D: IXMLDType read Get_D;
  end;

{ Forward Decls }

  TXMLCRMClientType = class;
  TXMLSchemeType = class;
  TXMLDataType = class;
  TXMLSType = class;
  TXMLDType = class;
  TXMLFType = class;
  TXMLFTypeList = class;
  TXMLRType = class;
  TXMLRTypeList = class;
  TXMLOType = class;

{ TXMLCRMClientType }

  TXMLCRMClientType = class(TXMLNode, IXMLCRMClientType)
  protected
    { IXMLCRMClientType }
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

  TXMLRType = class(TXMLNodeCollection, IXMLRType)
  protected
    { IXMLRType }
    function Get_F(Index: Integer): UnicodeString;
    function Add(const F: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const F: UnicodeString): IXMLNode;
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

  TXMLOType = class(TXMLNode, IXMLOType)
  protected
    { IXMLOType }
    function Get_D: IXMLDType;
  public
    procedure AfterConstruction; override;
  end;

{ Global Functions }

function GetCRMClient(Doc: IXMLDocument): IXMLCRMClientType;
function LoadCRMClient(const FileName: string): IXMLCRMClientType;
function NewCRMClient: IXMLCRMClientType;

const
  TargetNamespace = '';

implementation

uses Xml.xmlutil;

{ Global Functions }

function GetCRMClient(Doc: IXMLDocument): IXMLCRMClientType;
begin
  Result := Doc.GetDocBinding('extdata', TXMLCRMClientType, TargetNamespace) as IXMLCRMClientType;
end;

function LoadCRMClient(const FileName: string): IXMLCRMClientType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('extdata', TXMLCRMClientType, TargetNamespace) as IXMLCRMClientType;
end;

function NewCRMClient: IXMLCRMClientType;
begin
  Result := NewXMLDocument.GetDocBinding('extdata', TXMLCRMClientType, TargetNamespace) as IXMLCRMClientType;
end;

{ TXMLCRMClientType }

procedure TXMLCRMClientType.AfterConstruction;
begin
  RegisterChildNode('scheme', TXMLSchemeType);
  inherited;
end;

function TXMLCRMClientType.Get_User: Integer;
begin
  Result := AttributeNodes['user'].NodeValue;
end;

procedure TXMLCRMClientType.Set_User(Value: Integer);
begin
  SetAttribute('user', Value);
end;

function TXMLCRMClientType.Get_Scheme: IXMLSchemeType;
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
  ItemTag := 'f';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLRType.Get_F(Index: Integer): UnicodeString;
begin
  Result := List[Index].Text;
end;

function TXMLRType.Add(const F: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := F;
end;

function TXMLRType.Insert(const Index: Integer; const F: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := F;
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
  inherited;
end;

function TXMLOType.Get_D: IXMLDType;
begin
  Result := ChildNodes[WideString('d')] as IXMLDType;
end;

end.