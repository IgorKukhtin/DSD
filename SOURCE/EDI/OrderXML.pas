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
    ['{1D471CDB-0E7B-46BA-BCA7-D99172B413AF}']
    { Property Accessors }
    function Get_DOCUMENTNAME: UnicodeString;
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_DOCUMENTNAME(Value: UnicodeString);
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_DOCTYPE(Value: UnicodeString);
    procedure Set_INFO(Value: UnicodeString);
    { Methods & Properties }
    property DOCUMENTNAME: UnicodeString read Get_DOCUMENTNAME write Set_DOCUMENTNAME;
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property DELIVERYTIME: UnicodeString read Get_DELIVERYTIME write Set_DELIVERYTIME;
    property CURRENCY: UnicodeString read Get_CURRENCY write Set_CURRENCY;
    property DOCTYPE: UnicodeString read Get_DOCTYPE write Set_DOCTYPE;
    property INFO: UnicodeString read Get_INFO write Set_INFO;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{6A62AD41-64CB-4C09-ADDF-2D51EAEC2127}']
    { Property Accessors }
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_INVOICEPARTNER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_INVOICEPARTNER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    { Methods & Properties }
    property SUPPLIER: UnicodeString read Get_SUPPLIER write Set_SUPPLIER;
    property BUYER: UnicodeString read Get_BUYER write Set_BUYER;
    property DELIVERYPLACE: UnicodeString read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property INVOICEPARTNER: UnicodeString read Get_INVOICEPARTNER write Set_INVOICEPARTNER;
    property RECIPIENT: UnicodeString read Get_RECIPIENT write Set_RECIPIENT;
    property SENDER: UnicodeString read Get_SENDER write Set_SENDER;
    property POSITION: IXMLPOSITIONTypeList read Get_POSITION;
  end;

{ IXMLPOSITIONType }

  IXMLPOSITIONType = interface(IXMLNode)
    ['{109A7B76-E1E2-49B7-A6F4-3192640CB34C}']
    { Property Accessors }
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_BUYERPARTNUMBER: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_ORDERUNIT: UnicodeString;
    function Get_ORDERPRICE: UnicodeString;
    function Get_VAT: UnicodeString;
    function Get_CHARACTERISTIC: IXMLCHARACTERISTICType;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_BUYERPARTNUMBER(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
    procedure Set_ORDERUNIT(Value: UnicodeString);
    procedure Set_ORDERPRICE(Value: UnicodeString);
    procedure Set_VAT(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: UnicodeString read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: UnicodeString read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: UnicodeString read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property BUYERPARTNUMBER: UnicodeString read Get_BUYERPARTNUMBER write Set_BUYERPARTNUMBER;
    property ORDEREDQUANTITY: UnicodeString read Get_ORDEREDQUANTITY write Set_ORDEREDQUANTITY;
    property MINIMUMORDERQUANTITY: UnicodeString read Get_MINIMUMORDERQUANTITY write Set_MINIMUMORDERQUANTITY;
    property ORDERUNIT: UnicodeString read Get_ORDERUNIT write Set_ORDERUNIT;
    property ORDERPRICE: UnicodeString read Get_ORDERPRICE write Set_ORDERPRICE;
    property VAT: UnicodeString read Get_VAT write Set_VAT;
    property CHARACTERISTIC: IXMLCHARACTERISTICType read Get_CHARACTERISTIC;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{A97F1B2F-0F08-42E4-90B6-83D123903A7B}']
    { Methods & Properties }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
    property Items[Index: Integer]: IXMLPOSITIONType read Get_Item; default;
  end;

{ IXMLCHARACTERISTICType }

  IXMLCHARACTERISTICType = interface(IXMLNode)
    ['{EC034EE1-3C5E-464D-BFC7-F660E6703FCD}']
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
    function Get_DOCUMENTNAME: UnicodeString;
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_DOCUMENTNAME(Value: UnicodeString);
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
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
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_INVOICEPARTNER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_INVOICEPARTNER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
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
    function Get_BUYERPARTNUMBER: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_ORDERUNIT: UnicodeString;
    function Get_ORDERPRICE: UnicodeString;
    function Get_VAT: UnicodeString;
    function Get_CHARACTERISTIC: IXMLCHARACTERISTICType;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_BUYERPARTNUMBER(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
    procedure Set_ORDERUNIT(Value: UnicodeString);
    procedure Set_ORDERPRICE(Value: UnicodeString);
    procedure Set_VAT(Value: UnicodeString);
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

function GetORDER(Doc: IXMLDocument): IXMLORDERType;
function LoadORDER(const XMLString: string): IXMLORDERType;
function NewORDER: IXMLORDERType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetORDER(Doc: IXMLDocument): IXMLORDERType;
begin
  Result := Doc.GetDocBinding('ORDER', TXMLORDERType, TargetNamespace) as IXMLORDERType;
end;

function LoadORDER(const XMLString: string): IXMLORDERType;
begin
  with NewXMLDocument do begin
    LoadFromXML(XMLString);
    Result := GetDocBinding('ORDER', TXMLORDERType, TargetNamespace) as IXMLORDERType;
  end;
end;

function NewORDER: IXMLORDERType;
begin
  Result := NewXMLDocument.GetDocBinding('ORDER', TXMLORDERType, TargetNamespace) as IXMLORDERType;
end;

{ TXMLORDERType }

procedure TXMLORDERType.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLORDERType.Get_DOCUMENTNAME: UnicodeString;
begin
  Result := ChildNodes['DOCUMENTNAME'].Text;
end;

procedure TXMLORDERType.Set_DOCUMENTNAME(Value: UnicodeString);
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

function TXMLHEADType.Get_SUPPLIER: UnicodeString;
begin
  Result := ChildNodes['SUPPLIER'].Text;
end;

procedure TXMLHEADType.Set_SUPPLIER(Value: UnicodeString);
begin
  ChildNodes['SUPPLIER'].NodeValue := Value;
end;

function TXMLHEADType.Get_BUYER: UnicodeString;
begin
  Result := ChildNodes['BUYER'].Text;
end;

procedure TXMLHEADType.Set_BUYER(Value: UnicodeString);
begin
  ChildNodes['BUYER'].NodeValue := Value;
end;

function TXMLHEADType.Get_DELIVERYPLACE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYPLACE'].Text;
end;

procedure TXMLHEADType.Set_DELIVERYPLACE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYPLACE'].NodeValue := Value;
end;

function TXMLHEADType.Get_INVOICEPARTNER: UnicodeString;
begin
  Result := ChildNodes['INVOICEPARTNER'].Text;
end;

procedure TXMLHEADType.Set_INVOICEPARTNER(Value: UnicodeString);
begin
  ChildNodes['INVOICEPARTNER'].NodeValue := Value;
end;

function TXMLHEADType.Get_RECIPIENT: UnicodeString;
begin
  Result := ChildNodes['RECIPIENT'].Text;
end;

procedure TXMLHEADType.Set_RECIPIENT(Value: UnicodeString);
begin
  ChildNodes['RECIPIENT'].NodeValue := Value;
end;

function TXMLHEADType.Get_SENDER: UnicodeString;
begin
  Result := ChildNodes['SENDER'].Text;
end;

procedure TXMLHEADType.Set_SENDER(Value: UnicodeString);
begin
  ChildNodes['SENDER'].NodeValue := Value;
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

function TXMLPOSITIONType.Get_POSITIONNUMBER: UnicodeString;
begin
  Result := ChildNodes['POSITIONNUMBER'].Text;
end;

procedure TXMLPOSITIONType.Set_POSITIONNUMBER(Value: UnicodeString);
begin
  ChildNodes['POSITIONNUMBER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCT: UnicodeString;
begin
  Result := ChildNodes['PRODUCT'].Text;
end;

procedure TXMLPOSITIONType.Set_PRODUCT(Value: UnicodeString);
begin
  ChildNodes['PRODUCT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCTIDBUYER: UnicodeString;
begin
  Result := ChildNodes['PRODUCTIDBUYER'].Text;
end;

function TXMLPOSITIONType.Get_BUYERPARTNUMBER: UnicodeString;
begin
  Result := ChildNodes['BUYERPARTNUMBER'].Text;
end;

procedure TXMLPOSITIONType.Set_PRODUCTIDBUYER(Value: UnicodeString);
begin
  ChildNodes['PRODUCTIDBUYER'].NodeValue := Value;
end;

procedure TXMLPOSITIONType.Set_BUYERPARTNUMBER(Value: UnicodeString);
begin
  ChildNodes['BUYERPARTNUMBER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ORDEREDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ORDEREDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_MINIMUMORDERQUANTITY: UnicodeString;
begin
  Result := ChildNodes['MINIMUMORDERQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
begin
  ChildNodes['MINIMUMORDERQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDERUNIT: UnicodeString;
begin
  Result := ChildNodes['ORDERUNIT'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDERUNIT(Value: UnicodeString);
begin
  ChildNodes['ORDERUNIT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDERPRICE: UnicodeString;
begin
  Result := ChildNodes['ORDERPRICE'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDERPRICE(Value: UnicodeString);
begin
  ChildNodes['ORDERPRICE'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_VAT: UnicodeString;
begin
  Result := ChildNodes['VAT'].Text;
end;

procedure TXMLPOSITIONType.Set_VAT(Value: UnicodeString);
begin
  ChildNodes['VAT'].NodeValue := Value;
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