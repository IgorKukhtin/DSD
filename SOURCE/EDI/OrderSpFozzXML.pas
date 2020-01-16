{*******************************************************************************}
{                                                                               }
{                               XML Data Binding                                }
{                                                                               }
{         Generated on: 21.11.2019 13:39:41                                     }
{       Generated from: D:\Work\Project\XML\ordrsp_201911211034_545969674.xml   }
{   Settings stored in: D:\Work\Project\XML\ordrsp_201911211034_545969674.xdb   }
{                                                                               }
{*******************************************************************************}

unit OrderSpFozzXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLORDRSPType = interface;
  IXMLHEADType = interface;
  IXMLPOSITIONType = interface;
  IXMLPOSITIONTypeList = interface;

{ IXMLORDRSPType }

  IXMLORDRSPType = interface(IXMLNode)
    ['{D6824C34-5D5C-4D4A-8541-526D150DEDBC}']
    { Property Accessors }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_TIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_ACTION: Integer;
    function Get_INFO: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_TIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_ACTION(Value: Integer);
    procedure Set_INFO(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    { Methods & Properties }
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property TIME: UnicodeString read Get_TIME write Set_TIME;
    property ORDERNUMBER: UnicodeString read Get_ORDERNUMBER write Set_ORDERNUMBER;
    property ORDERDATE: UnicodeString read Get_ORDERDATE write Set_ORDERDATE;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property DELIVERYTIME: UnicodeString read Get_DELIVERYTIME write Set_DELIVERYTIME;
    property CURRENCY: UnicodeString read Get_CURRENCY write Set_CURRENCY;
    property ACTION: Integer read Get_ACTION write Set_ACTION;
    property INFO: UnicodeString read Get_INFO write Set_INFO;
    property CAMPAIGNNUMBER: UnicodeString read Get_CAMPAIGNNUMBER write Set_CAMPAIGNNUMBER;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{519331F2-DB29-468C-AB55-78ABC7CA7AD3}']
    { Property Accessors }
    function Get_BUYER: UnicodeString;
    function Get_SUPPLIER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_INVOICEPARTNER: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_INVOICEPARTNER(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    { Methods & Properties }
    property BUYER: UnicodeString read Get_BUYER write Set_BUYER;
    property SUPPLIER: UnicodeString read Get_SUPPLIER write Set_SUPPLIER;
    property DELIVERYPLACE: UnicodeString read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property INVOICEPARTNER: UnicodeString read Get_INVOICEPARTNER write Set_INVOICEPARTNER;
    property SENDER: UnicodeString read Get_SENDER write Set_SENDER;
    property RECIPIENT: UnicodeString read Get_RECIPIENT write Set_RECIPIENT;
    property POSITION: IXMLPOSITIONTypeList read Get_POSITION;
  end;

{ IXMLPOSITIONType }

  IXMLPOSITIONType = interface(IXMLNode)
    ['{882D1F65-9C03-4813-B11F-7E0EEFD39AB8}']
    { Property Accessors }
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_PRODUCTTYPE: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_ACCEPTEDQUANTITY: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_PRODUCTTYPE(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_ACCEPTEDQUANTITY(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: UnicodeString read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: UnicodeString read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: UnicodeString read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property MINIMUMORDERQUANTITY: UnicodeString read Get_MINIMUMORDERQUANTITY write Set_MINIMUMORDERQUANTITY;
    property DESCRIPTION: UnicodeString read Get_DESCRIPTION write Set_DESCRIPTION;
    property PRODUCTTYPE: UnicodeString read Get_PRODUCTTYPE write Set_PRODUCTTYPE;
    property ORDEREDQUANTITY: UnicodeString read Get_ORDEREDQUANTITY write Set_ORDEREDQUANTITY;
    property ACCEPTEDQUANTITY: UnicodeString read Get_ACCEPTEDQUANTITY write Set_ACCEPTEDQUANTITY;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{B0E1FB05-09B2-4436-9893-8239989723D1}']
    { Methods & Properties }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
    property Items[Index: Integer]: IXMLPOSITIONType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLORDRSPType = class;
  TXMLHEADType = class;
  TXMLPOSITIONType = class;
  TXMLPOSITIONTypeList = class;

{ TXMLORDRSPType }

  TXMLORDRSPType = class(TXMLNode, IXMLORDRSPType)
  protected
    { IXMLORDRSPType }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_TIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_ACTION: Integer;
    function Get_INFO: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_TIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_ACTION(Value: Integer);
    procedure Set_INFO(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHEADType }

  TXMLHEADType = class(TXMLNode, IXMLHEADType)
  private
    FPOSITION: IXMLPOSITIONTypeList;
  protected
    { IXMLHEADType }
    function Get_BUYER: UnicodeString;
    function Get_SUPPLIER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_INVOICEPARTNER: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_INVOICEPARTNER(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONType }

  TXMLPOSITIONType = class(TXMLNode, IXMLPOSITIONType)
  protected
    { IXMLPOSITIONType }
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_PRODUCTTYPE: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_ACCEPTEDQUANTITY: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_PRODUCTTYPE(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_ACCEPTEDQUANTITY(Value: UnicodeString);
  end;

{ TXMLPOSITIONTypeList }

  TXMLPOSITIONTypeList = class(TXMLNodeCollection, IXMLPOSITIONTypeList)
  protected
    { IXMLPOSITIONTypeList }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
  end;

{ Global Functions }

function GetOrderSp(Doc: IXMLDocument): IXMLORDRSPType;
function LoadOrderSp(const FileName: string): IXMLORDRSPType;
function NewOrderSp: IXMLORDRSPType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetOrderSp(Doc: IXMLDocument): IXMLORDRSPType;
begin
  Result := Doc.GetDocBinding('ORDRSP', TXMLORDRSPType, TargetNamespace) as IXMLORDRSPType;
end;

function LoadOrderSp(const FileName: string): IXMLORDRSPType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ORDRSP', TXMLORDRSPType, TargetNamespace) as IXMLORDRSPType;
end;

function NewOrderSp: IXMLORDRSPType;
begin
  Result := NewXMLDocument.GetDocBinding('ORDRSP', TXMLORDRSPType, TargetNamespace) as IXMLORDRSPType;
end;

{ TXMLORDRSPType }

procedure TXMLORDRSPType.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLORDRSPType.Get_NUMBER: UnicodeString;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

procedure TXMLORDRSPType.Set_NUMBER(Value: UnicodeString);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLORDRSPType.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_TIME: UnicodeString;
begin
  Result := ChildNodes['TIME'].Text;
end;

procedure TXMLORDRSPType.Set_TIME(Value: UnicodeString);
begin
  ChildNodes['TIME'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_ORDERNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDERNUMBER'].Text;
end;

procedure TXMLORDRSPType.Set_ORDERNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDERNUMBER'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_ORDERDATE: UnicodeString;
begin
  Result := ChildNodes['ORDERDATE'].Text;
end;

procedure TXMLORDRSPType.Set_ORDERDATE(Value: UnicodeString);
begin
  ChildNodes['ORDERDATE'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_DELIVERYDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYDATE'].Text;
end;

procedure TXMLORDRSPType.Set_DELIVERYDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYDATE'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_DELIVERYTIME: UnicodeString;
begin
  Result := ChildNodes['DELIVERYTIME'].Text;
end;

procedure TXMLORDRSPType.Set_DELIVERYTIME(Value: UnicodeString);
begin
  ChildNodes['DELIVERYTIME'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_CURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLORDRSPType.Set_CURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_ACTION: Integer;
begin
  Result := ChildNodes['ACTION'].NodeValue;
end;

procedure TXMLORDRSPType.Set_ACTION(Value: Integer);
begin
  ChildNodes['ACTION'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_INFO: UnicodeString;
begin
  Result := ChildNodes['INFO'].Text;
end;

procedure TXMLORDRSPType.Set_INFO(Value: UnicodeString);
begin
  ChildNodes['INFO'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_CAMPAIGNNUMBER: UnicodeString;
begin
  Result := ChildNodes['CAMPAIGNNUMBER'].Text;
end;

procedure TXMLORDRSPType.Set_CAMPAIGNNUMBER(Value: UnicodeString);
begin
  ChildNodes['CAMPAIGNNUMBER'].NodeValue := Value;
end;

function TXMLORDRSPType.Get_HEAD: IXMLHEADType;
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

function TXMLHEADType.Get_BUYER: UnicodeString;
begin
  Result := ChildNodes['BUYER'].NodeValue;
end;

procedure TXMLHEADType.Set_BUYER(Value: UnicodeString);
begin
  ChildNodes['BUYER'].NodeValue := Value;
end;

function TXMLHEADType.Get_SUPPLIER: UnicodeString;
begin
  Result := ChildNodes['SUPPLIER'].NodeValue;
end;

procedure TXMLHEADType.Set_SUPPLIER(Value: UnicodeString);
begin
  ChildNodes['SUPPLIER'].NodeValue := Value;
end;

function TXMLHEADType.Get_DELIVERYPLACE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYPLACE'].NodeValue;
end;

procedure TXMLHEADType.Set_DELIVERYPLACE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYPLACE'].NodeValue := Value;
end;

function TXMLHEADType.Get_INVOICEPARTNER: UnicodeString;
begin
  Result := ChildNodes['INVOICEPARTNER'].NodeValue;
end;

procedure TXMLHEADType.Set_INVOICEPARTNER(Value: UnicodeString);
begin
  ChildNodes['INVOICEPARTNER'].NodeValue := Value;
end;

function TXMLHEADType.Get_SENDER: UnicodeString;
begin
  Result := ChildNodes['SENDER'].NodeValue;
end;

procedure TXMLHEADType.Set_SENDER(Value: UnicodeString);
begin
  ChildNodes['SENDER'].NodeValue := Value;
end;

function TXMLHEADType.Get_RECIPIENT: UnicodeString;
begin
  Result := ChildNodes['RECIPIENT'].NodeValue;
end;

procedure TXMLHEADType.Set_RECIPIENT(Value: UnicodeString);
begin
  ChildNodes['RECIPIENT'].NodeValue := Value;
end;

function TXMLHEADType.Get_POSITION: IXMLPOSITIONTypeList;
begin
  Result := FPOSITION;
end;

{ TXMLPOSITIONType }

function TXMLPOSITIONType.Get_POSITIONNUMBER: UnicodeString;
begin
  Result := ChildNodes['POSITIONNUMBER'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_POSITIONNUMBER(Value: UnicodeString);
begin
  ChildNodes['POSITIONNUMBER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCT: UnicodeString;
begin
  Result := ChildNodes['PRODUCT'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_PRODUCT(Value: UnicodeString);
begin
  ChildNodes['PRODUCT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCTIDBUYER: UnicodeString;
begin
  Result := ChildNodes['PRODUCTIDBUYER'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_PRODUCTIDBUYER(Value: UnicodeString);
begin
  ChildNodes['PRODUCTIDBUYER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_MINIMUMORDERQUANTITY: UnicodeString;
begin
  Result := ChildNodes['MINIMUMORDERQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
begin
  ChildNodes['MINIMUMORDERQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_DESCRIPTION: UnicodeString;
begin
  Result := ChildNodes['DESCRIPTION'].Text;
end;

procedure TXMLPOSITIONType.Set_DESCRIPTION(Value: UnicodeString);
begin
  ChildNodes['DESCRIPTION'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCTTYPE: UnicodeString;
begin
  Result := ChildNodes['PRODUCTTYPE'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_PRODUCTTYPE(Value: UnicodeString);
begin
  ChildNodes['PRODUCTTYPE'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ORDEREDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ORDEREDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ACCEPTEDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ACCEPTEDQUANTITY'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_ACCEPTEDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ACCEPTEDQUANTITY'].NodeValue := Value;
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

end.