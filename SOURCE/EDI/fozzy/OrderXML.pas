
{******************************************************************************}
{                                                                              }
{                               XML Data Binding                               }
{                                                                              }
{         Generated on: 21.11.2019 13:38:17                                    }
{       Generated from: D:\Work\Project\XML\order_201911211034_545637022.xml   }
{   Settings stored in: D:\Work\Project\XML\order_201911211034_545637022.xdb   }
{                                                                              }
{******************************************************************************}

unit OrderXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLORDERType = interface;
  IXMLHEADType = interface;
  IXMLPOSITIONType = interface;
  IXMLPOSITIONTypeList = interface;
  IXMLCHARACTERISTICType = interface;

{ IXMLORDERType }

  IXMLORDERType = interface(IXMLNode)
    ['{F47D343F-C768-47DB-9D5F-C9918594D97D}']
    { Property Accessors }
    function Get_DOCUMENTNAME: Integer;
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_DOCUMENTNAME(Value: Integer);
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_DOCTYPE(Value: UnicodeString);
    procedure Set_INFO(Value: UnicodeString);
    { Methods & Properties }
    property DOCUMENTNAME: Integer read Get_DOCUMENTNAME write Set_DOCUMENTNAME;
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property DELIVERYTIME: UnicodeString read Get_DELIVERYTIME write Set_DELIVERYTIME;
    property CAMPAIGNNUMBER: UnicodeString read Get_CAMPAIGNNUMBER write Set_CAMPAIGNNUMBER;
    property CURRENCY: UnicodeString read Get_CURRENCY write Set_CURRENCY;
    property DOCTYPE: UnicodeString read Get_DOCTYPE write Set_DOCTYPE;
    property INFO: UnicodeString read Get_INFO write Set_INFO;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{2A753337-BA77-4A22-99FB-B99DDF48953F}']
    { Property Accessors }
    function Get_SUPPLIER: Integer;
    function Get_BUYER: Integer;
    function Get_DELIVERYPLACE: Integer;
    function Get_INVOICEPARTNER: Integer;
    function Get_SENDER: Integer;
    function Get_RECIPIENT: Integer;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_SUPPLIER(Value: Integer);
    procedure Set_BUYER(Value: Integer);
    procedure Set_DELIVERYPLACE(Value: Integer);
    procedure Set_INVOICEPARTNER(Value: Integer);
    procedure Set_SENDER(Value: Integer);
    procedure Set_RECIPIENT(Value: Integer);
    procedure Set_EDIINTERCHANGEID(Value: UnicodeString);
    { Methods & Properties }
    property SUPPLIER: Integer read Get_SUPPLIER write Set_SUPPLIER;
    property BUYER: Integer read Get_BUYER write Set_BUYER;
    property DELIVERYPLACE: Integer read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property INVOICEPARTNER: Integer read Get_INVOICEPARTNER write Set_INVOICEPARTNER;
    property SENDER: Integer read Get_SENDER write Set_SENDER;
    property RECIPIENT: Integer read Get_RECIPIENT write Set_RECIPIENT;
    property EDIINTERCHANGEID: UnicodeString read Get_EDIINTERCHANGEID write Set_EDIINTERCHANGEID;
    property POSITION: IXMLPOSITIONTypeList read Get_POSITION;
  end;

{ IXMLPOSITIONType }

  IXMLPOSITIONType = interface(IXMLNode)
    ['{6044D634-85FC-43FD-B120-875D3D8E3985}']
    { Property Accessors }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: Integer;
    function Get_PRODUCTIDBUYER: Integer;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_ORDERUNIT: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_CHARACTERISTIC: IXMLCHARACTERISTICType;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: Integer);
    procedure Set_PRODUCTIDBUYER(Value: Integer);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_ORDERUNIT(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: Integer read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: Integer read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: Integer read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property ORDEREDQUANTITY: UnicodeString read Get_ORDEREDQUANTITY write Set_ORDEREDQUANTITY;
    property ORDERUNIT: UnicodeString read Get_ORDERUNIT write Set_ORDERUNIT;
    property MINIMUMORDERQUANTITY: UnicodeString read Get_MINIMUMORDERQUANTITY write Set_MINIMUMORDERQUANTITY;
    property CHARACTERISTIC: IXMLCHARACTERISTICType read Get_CHARACTERISTIC;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{640E5D95-C999-4F54-BA1B-488C8AAB71E7}']
    { Methods & Properties }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
    property Items[Index: Integer]: IXMLPOSITIONType read Get_Item; default;
  end;

{ IXMLCHARACTERISTICType }

  IXMLCHARACTERISTICType = interface(IXMLNode)
    ['{0A2FA409-78DB-4795-A731-C9B8715F5E88}']
    { Property Accessors }
    function Get_DESCRIPTION: UnicodeString;
    procedure Set_DESCRIPTION(Value: UnicodeString);
    { Methods & Properties }
    property DESCRIPTION: UnicodeString read Get_DESCRIPTION write Set_DESCRIPTION;
  end;

{ Forward Decls }

  TXMLORDERType = class;
  TXMLHEADType = class;
  TXMLPOSITIONType = class;
  TXMLPOSITIONTypeList = class;
  TXMLCHARACTERISTICType = class;

{ TXMLORDERType }

  TXMLORDERType = class(TXMLNode, IXMLORDERType)
  protected
    { IXMLORDERType }
    function Get_DOCUMENTNAME: Integer;
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_DOCUMENTNAME(Value: Integer);
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_DOCTYPE(Value: UnicodeString);
    procedure Set_INFO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHEADType }

  TXMLHEADType = class(TXMLNode, IXMLHEADType)
  private
    FPOSITION: IXMLPOSITIONTypeList;
  protected
    { IXMLHEADType }
    function Get_SUPPLIER: Integer;
    function Get_BUYER: Integer;
    function Get_DELIVERYPLACE: Integer;
    function Get_INVOICEPARTNER: Integer;
    function Get_SENDER: Integer;
    function Get_RECIPIENT: Integer;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_SUPPLIER(Value: Integer);
    procedure Set_BUYER(Value: Integer);
    procedure Set_DELIVERYPLACE(Value: Integer);
    procedure Set_INVOICEPARTNER(Value: Integer);
    procedure Set_SENDER(Value: Integer);
    procedure Set_RECIPIENT(Value: Integer);
    procedure Set_EDIINTERCHANGEID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONType }

  TXMLPOSITIONType = class(TXMLNode, IXMLPOSITIONType)
  protected
    { IXMLPOSITIONType }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: Integer;
    function Get_PRODUCTIDBUYER: Integer;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_ORDERUNIT: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_CHARACTERISTIC: IXMLCHARACTERISTICType;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: Integer);
    procedure Set_PRODUCTIDBUYER(Value: Integer);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_ORDERUNIT(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONTypeList }

  TXMLPOSITIONTypeList = class(TXMLNodeCollection, IXMLPOSITIONTypeList)
  protected
    { IXMLPOSITIONTypeList }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
  end;

{ TXMLCHARACTERISTICType }

  TXMLCHARACTERISTICType = class(TXMLNode, IXMLCHARACTERISTICType)
  protected
    { IXMLCHARACTERISTICType }
    function Get_DESCRIPTION: UnicodeString;
    procedure Set_DESCRIPTION(Value: UnicodeString);
  end;

{ Global Functions }

function GetOrder(Doc: IXMLDocument): IXMLORDERType;
function LoadOrder(const FileName: string): IXMLORDERType;
function NewOrder: IXMLORDERType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetOrder(Doc: IXMLDocument): IXMLORDERType;
begin
  Result := Doc.GetDocBinding('Order', TXMLORDERType, TargetNamespace) as IXMLORDERType;
end;

function LoadOrder(const FileName: string): IXMLORDERType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Order', TXMLORDERType, TargetNamespace) as IXMLORDERType;
end;

function NewOrder: IXMLORDERType;
begin
  Result := NewXMLDocument.GetDocBinding('Order', TXMLORDERType, TargetNamespace) as IXMLORDERType;
end;

{ TXMLORDERType }

procedure TXMLORDERType.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLORDERType.Get_DOCUMENTNAME: Integer;
begin
  Result := ChildNodes['DOCUMENTNAME'].NodeValue;
end;

procedure TXMLORDERType.Set_DOCUMENTNAME(Value: Integer);
begin
  ChildNodes['DOCUMENTNAME'].NodeValue := Value;
end;

function TXMLORDERType.Get_NUMBER: UnicodeString;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

procedure TXMLORDERType.Set_NUMBER(Value: UnicodeString);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLORDERType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLORDERType.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLORDERType.Get_DELIVERYDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYDATE'].Text;
end;

procedure TXMLORDERType.Set_DELIVERYDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYDATE'].NodeValue := Value;
end;

function TXMLORDERType.Get_DELIVERYTIME: UnicodeString;
begin
  Result := ChildNodes['DELIVERYTIME'].Text;
end;

procedure TXMLORDERType.Set_DELIVERYTIME(Value: UnicodeString);
begin
  ChildNodes['DELIVERYTIME'].NodeValue := Value;
end;

function TXMLORDERType.Get_CAMPAIGNNUMBER: UnicodeString;
begin
  Result := ChildNodes['CAMPAIGNNUMBER'].Text;
end;

procedure TXMLORDERType.Set_CAMPAIGNNUMBER(Value: UnicodeString);
begin
  ChildNodes['CAMPAIGNNUMBER'].NodeValue := Value;
end;

function TXMLORDERType.Get_CURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLORDERType.Set_CURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLORDERType.Get_DOCTYPE: UnicodeString;
begin
  Result := ChildNodes['DOCTYPE'].Text;
end;

procedure TXMLORDERType.Set_DOCTYPE(Value: UnicodeString);
begin
  ChildNodes['DOCTYPE'].NodeValue := Value;
end;

function TXMLORDERType.Get_INFO: UnicodeString;
begin
  Result := ChildNodes['INFO'].Text;
end;

procedure TXMLORDERType.Set_INFO(Value: UnicodeString);
begin
  ChildNodes['INFO'].NodeValue := Value;
end;

function TXMLORDERType.Get_HEAD: IXMLHEADType;
begin
  Result := ChildNodes['HEAD'] as IXMLHEADType;
end;

{ TXMLHEADType }

procedure TXMLHEADType.AfterConstruction;
begin
  RegisterChildNode('POSITION', TXMLPOSITIONType);
  FPOSITION := CreateCollection(TXMLPOSITIONTypeList, IXMLPOSITIONType, 'POSITION') as IXMLPOSITIONTypeList;
  inherited;
end;

function TXMLHEADType.Get_SUPPLIER: Integer;
begin
  Result := ChildNodes['SUPPLIER'].NodeValue;
end;

procedure TXMLHEADType.Set_SUPPLIER(Value: Integer);
begin
  ChildNodes['SUPPLIER'].NodeValue := Value;
end;

function TXMLHEADType.Get_BUYER: Integer;
begin
  Result := ChildNodes['BUYER'].NodeValue;
end;

procedure TXMLHEADType.Set_BUYER(Value: Integer);
begin
  ChildNodes['BUYER'].NodeValue := Value;
end;

function TXMLHEADType.Get_DELIVERYPLACE: Integer;
begin
  Result := ChildNodes['DELIVERYPLACE'].NodeValue;
end;

procedure TXMLHEADType.Set_DELIVERYPLACE(Value: Integer);
begin
  ChildNodes['DELIVERYPLACE'].NodeValue := Value;
end;

function TXMLHEADType.Get_INVOICEPARTNER: Integer;
begin
  Result := ChildNodes['INVOICEPARTNER'].NodeValue;
end;

procedure TXMLHEADType.Set_INVOICEPARTNER(Value: Integer);
begin
  ChildNodes['INVOICEPARTNER'].NodeValue := Value;
end;

function TXMLHEADType.Get_SENDER: Integer;
begin
  Result := ChildNodes['SENDER'].NodeValue;
end;

procedure TXMLHEADType.Set_SENDER(Value: Integer);
begin
  ChildNodes['SENDER'].NodeValue := Value;
end;

function TXMLHEADType.Get_RECIPIENT: Integer;
begin
  Result := ChildNodes['RECIPIENT'].NodeValue;
end;

procedure TXMLHEADType.Set_RECIPIENT(Value: Integer);
begin
  ChildNodes['RECIPIENT'].NodeValue := Value;
end;

function TXMLHEADType.Get_EDIINTERCHANGEID: UnicodeString;
begin
  Result := ChildNodes['EDIINTERCHANGEID'].Text;
end;

procedure TXMLHEADType.Set_EDIINTERCHANGEID(Value: UnicodeString);
begin
  ChildNodes['EDIINTERCHANGEID'].NodeValue := Value;
end;

function TXMLHEADType.Get_POSITION: IXMLPOSITIONTypeList;
begin
  Result := FPOSITION;
end;

{ TXMLPOSITIONType }

procedure TXMLPOSITIONType.AfterConstruction;
begin
  RegisterChildNode('CHARACTERISTIC', TXMLCHARACTERISTICType);
  inherited;
end;

function TXMLPOSITIONType.Get_POSITIONNUMBER: Integer;
begin
  Result := ChildNodes['POSITIONNUMBER'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_POSITIONNUMBER(Value: Integer);
begin
  ChildNodes['POSITIONNUMBER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCT: Integer;
begin
  Result := ChildNodes['PRODUCT'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_PRODUCT(Value: Integer);
begin
  ChildNodes['PRODUCT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCTIDBUYER: Integer;
begin
  Result := ChildNodes['PRODUCTIDBUYER'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_PRODUCTIDBUYER(Value: Integer);
begin
  ChildNodes['PRODUCTIDBUYER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ORDEREDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ORDEREDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDERUNIT: UnicodeString;
begin
  Result := ChildNodes['ORDERUNIT'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDERUNIT(Value: UnicodeString);
begin
  ChildNodes['ORDERUNIT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_MINIMUMORDERQUANTITY: UnicodeString;
begin
  Result := ChildNodes['MINIMUMORDERQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
begin
  ChildNodes['MINIMUMORDERQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_CHARACTERISTIC: IXMLCHARACTERISTICType;
begin
  Result := ChildNodes['CHARACTERISTIC'] as IXMLCHARACTERISTICType;
end;

{ TXMLPOSITIONTypeList }

function TXMLPOSITIONTypeList.Add: IXMLPOSITIONType;
begin
  Result := AddItem(-1) as IXMLPOSITIONType;
end;

function TXMLPOSITIONTypeList.Insert(const Index: Integer): IXMLPOSITIONType;
begin
  Result := AddItem(Index) as IXMLPOSITIONType;
end;

function TXMLPOSITIONTypeList.Get_Item(Index: Integer): IXMLPOSITIONType;
begin
  Result := List[Index] as IXMLPOSITIONType;
end;

{ TXMLCHARACTERISTICType }

function TXMLCHARACTERISTICType.Get_DESCRIPTION: UnicodeString;
begin
  Result := ChildNodes['DESCRIPTION'].Text;
end;

procedure TXMLCHARACTERISTICType.Set_DESCRIPTION(Value: UnicodeString);
begin
  ChildNodes['DESCRIPTION'].NodeValue := Value;
end;

end.