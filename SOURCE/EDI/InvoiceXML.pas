unit InvoiceXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLINVOICEType = interface;
  IXMLHEADType = interface;
  IXMLPOSITIONType = interface;
  IXMLPOSITIONTypeList = interface;
  IXMLTAXType = interface;

{ IXMLINVOICEType }

  IXMLINVOICEType = interface(IXMLNode)
    ['{19D5DFF0-6CB5-4D37-A9A8-771EA5B441BD}']
    { Property Accessors }
    function Get_DOCUMENTNAME: UnicodeString;
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: UnicodeString;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_GOODSTOTALAMOUNT: UnicodeString;
    function Get_POSITIONSAMOUNT: UnicodeString;
    function Get_VATSUM: UnicodeString;
    function Get_INVOICETOTALAMOUNT: UnicodeString;
    function Get_TAXABLEAMOUNT: UnicodeString;
    function Get_PAYMENTORDERNUMBER: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_MANAGER: UnicodeString;
    function Get_VAT: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_DOCUMENTNAME(Value: UnicodeString);
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: UnicodeString);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_GOODSTOTALAMOUNT(Value: UnicodeString);
    procedure Set_POSITIONSAMOUNT(Value: UnicodeString);
    procedure Set_VATSUM(Value: UnicodeString);
    procedure Set_INVOICETOTALAMOUNT(Value: UnicodeString);
    procedure Set_TAXABLEAMOUNT(Value: UnicodeString);
    procedure Set_PAYMENTORDERNUMBER(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_MANAGER(Value: UnicodeString);
    procedure Set_VAT(Value: UnicodeString);
    { Methods & Properties }
    property DOCUMENTNAME: UnicodeString read Get_DOCUMENTNAME write Set_DOCUMENTNAME;
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property CURRENCY: UnicodeString read Get_CURRENCY write Set_CURRENCY;
    property ORDERNUMBER: UnicodeString read Get_ORDERNUMBER write Set_ORDERNUMBER;
    property ORDERDATE: UnicodeString read Get_ORDERDATE write Set_ORDERDATE;
    property DELIVERYNOTENUMBER: UnicodeString read Get_DELIVERYNOTENUMBER write Set_DELIVERYNOTENUMBER;
    property DELIVERYNOTEDATE: UnicodeString read Get_DELIVERYNOTEDATE write Set_DELIVERYNOTEDATE;
    property GOODSTOTALAMOUNT: UnicodeString read Get_GOODSTOTALAMOUNT write Set_GOODSTOTALAMOUNT;
    property POSITIONSAMOUNT: UnicodeString read Get_POSITIONSAMOUNT write Set_POSITIONSAMOUNT;
    property VATSUM: UnicodeString read Get_VATSUM write Set_VATSUM;
    property INVOICETOTALAMOUNT: UnicodeString read Get_INVOICETOTALAMOUNT write Set_INVOICETOTALAMOUNT;
    property TAXABLEAMOUNT: UnicodeString read Get_TAXABLEAMOUNT write Set_TAXABLEAMOUNT;
    property PAYMENTORDERNUMBER: UnicodeString read Get_PAYMENTORDERNUMBER write Set_PAYMENTORDERNUMBER;
    property CAMPAIGNNUMBER: UnicodeString read Get_CAMPAIGNNUMBER write Set_CAMPAIGNNUMBER;
    property MANAGER: UnicodeString read Get_MANAGER write Set_MANAGER;
    property VAT: UnicodeString read Get_VAT write Set_VAT;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{C22ACC36-895D-4E99-B1B5-31430F893447}']
    { Property Accessors }
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    { Methods & Properties }
    property SUPPLIER: UnicodeString read Get_SUPPLIER write Set_SUPPLIER;
    property BUYER: UnicodeString read Get_BUYER write Set_BUYER;
    property DELIVERYPLACE: UnicodeString read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property SENDER: UnicodeString read Get_SENDER write Set_SENDER;
    property RECIPIENT: UnicodeString read Get_RECIPIENT write Set_RECIPIENT;
    property POSITION: IXMLPOSITIONTypeList read Get_POSITION;
  end;

{ IXMLPOSITIONType }

  IXMLPOSITIONType = interface(IXMLNode)
    ['{6D6E2A35-5997-4800-A197-245C12526045}']
    { Property Accessors }
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_INVOICEUNIT: UnicodeString;
    function Get_INVOICEDQUANTITY: UnicodeString;
    function Get_UNITPRICE: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_GROSSPRICE: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_AMOUNTTYPE: UnicodeString;
    function Get_TAX: IXMLTAXType;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_INVOICEUNIT(Value: UnicodeString);
    procedure Set_INVOICEDQUANTITY(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_GROSSPRICE(Value: UnicodeString);
    procedure Set_UNITPRICE(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_AMOUNTTYPE(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: UnicodeString read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: UnicodeString read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: UnicodeString read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property INVOICEUNIT: UnicodeString read Get_INVOICEUNIT write Set_INVOICEUNIT;
    property INVOICEDQUANTITY: UnicodeString read Get_INVOICEDQUANTITY write Set_INVOICEDQUANTITY;
    property UNITPRICE: UnicodeString read Get_UNITPRICE write Set_UNITPRICE;
    property PRICEWITHVAT: UnicodeString read Get_PRICEWITHVAT write Set_PRICEWITHVAT;
    property GROSSPRICE: UnicodeString read Get_GROSSPRICE write Set_GROSSPRICE;
    property AMOUNT: UnicodeString read Get_AMOUNT write Set_AMOUNT;
    property DESCRIPTION: UnicodeString read Get_DESCRIPTION write Set_DESCRIPTION;
    property AMOUNTTYPE: UnicodeString read Get_AMOUNTTYPE write Set_AMOUNTTYPE;
    property TAX: IXMLTAXType read Get_TAX;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{817C04E2-DFE2-4A4E-9200-31A7FB442247}']
    { Methods & Properties }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
    property Items[Index: Integer]: IXMLPOSITIONType read Get_Item; default;
  end;

{ IXMLTAXType }

  IXMLTAXType = interface(IXMLNode)
    ['{5D7C545A-7320-48B1-A59F-1E55F18DA7B6}']
    { Property Accessors }
    function Get_FUNCTION_: UnicodeString;
    function Get_TAXTYPECODE: UnicodeString;
    function Get_TAXRATE: UnicodeString;
    function Get_TAXAMOUNT: UnicodeString;
    function Get_CATEGORY: UnicodeString;
    procedure Set_FUNCTION_(Value: UnicodeString);
    procedure Set_TAXTYPECODE(Value: UnicodeString);
    procedure Set_TAXRATE(Value: UnicodeString);
    procedure Set_TAXAMOUNT(Value: UnicodeString);
    procedure Set_CATEGORY(Value: UnicodeString);
    { Methods & Properties }
    property FUNCTION_: UnicodeString read Get_FUNCTION_ write Set_FUNCTION_;
    property TAXTYPECODE: UnicodeString read Get_TAXTYPECODE write Set_TAXTYPECODE;
    property TAXRATE: UnicodeString read Get_TAXRATE write Set_TAXRATE;
    property TAXAMOUNT: UnicodeString read Get_TAXAMOUNT write Set_TAXAMOUNT;
    property CATEGORY: UnicodeString read Get_CATEGORY write Set_CATEGORY;
  end;

{ Forward Decls }

  TXMLINVOICEType = class;
  TXMLHEADType = class;
  TXMLPOSITIONType = class;
  TXMLPOSITIONTypeList = class;
  TXMLTAXType = class;

{ TXMLINVOICEType }

  TXMLINVOICEType = class(TXMLNode, IXMLINVOICEType)
  protected
    { IXMLINVOICEType }
    function Get_DOCUMENTNAME: UnicodeString;
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: UnicodeString;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_GOODSTOTALAMOUNT: UnicodeString;
    function Get_POSITIONSAMOUNT: UnicodeString;
    function Get_VATSUM: UnicodeString;
    function Get_INVOICETOTALAMOUNT: UnicodeString;
    function Get_TAXABLEAMOUNT: UnicodeString;
    function Get_PAYMENTORDERNUMBER: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_MANAGER: UnicodeString;
    function Get_VAT: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_DOCUMENTNAME(Value: UnicodeString);
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: UnicodeString);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_GOODSTOTALAMOUNT(Value: UnicodeString);
    procedure Set_POSITIONSAMOUNT(Value: UnicodeString);
    procedure Set_VATSUM(Value: UnicodeString);
    procedure Set_INVOICETOTALAMOUNT(Value: UnicodeString);
    procedure Set_TAXABLEAMOUNT(Value: UnicodeString);
    procedure Set_PAYMENTORDERNUMBER(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_MANAGER(Value: UnicodeString);
    procedure Set_VAT(Value: UnicodeString);
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
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
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
    function Get_INVOICEUNIT: UnicodeString;
    function Get_INVOICEDQUANTITY: UnicodeString;
    function Get_UNITPRICE: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_GROSSPRICE: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_AMOUNTTYPE: UnicodeString;
    function Get_TAX: IXMLTAXType;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_INVOICEUNIT(Value: UnicodeString);
    procedure Set_INVOICEDQUANTITY(Value: UnicodeString);
    procedure Set_UNITPRICE(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_GROSSPRICE(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_AMOUNTTYPE(Value: UnicodeString);
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

{ TXMLTAXType }

  TXMLTAXType = class(TXMLNode, IXMLTAXType)
  protected
    { IXMLTAXType }
    function Get_FUNCTION_: UnicodeString;
    function Get_TAXTYPECODE: UnicodeString;
    function Get_TAXRATE: UnicodeString;
    function Get_TAXAMOUNT: UnicodeString;
    function Get_CATEGORY: UnicodeString;
    procedure Set_FUNCTION_(Value: UnicodeString);
    procedure Set_TAXTYPECODE(Value: UnicodeString);
    procedure Set_TAXRATE(Value: UnicodeString);
    procedure Set_TAXAMOUNT(Value: UnicodeString);
    procedure Set_CATEGORY(Value: UnicodeString);
  end;

{ Global Functions }

function GetINVOICE(Doc: IXMLDocument): IXMLINVOICEType;
function LoadINVOICE(XMLString: string): IXMLINVOICEType;
function NewINVOICE: IXMLINVOICEType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetINVOICE(Doc: IXMLDocument): IXMLINVOICEType;
begin
  Result := Doc.GetDocBinding('INVOICE', TXMLINVOICEType, TargetNamespace) as IXMLINVOICEType;
end;

function LoadINVOICE(XMLString: string): IXMLINVOICEType;
begin
  with NewXMLDocument do begin
    LoadFromXML(XMLString);
    Result := GetDocBinding('INVOICE', TXMLINVOICEType, TargetNamespace) as IXMLINVOICEType;
  end;
end;

function NewINVOICE: IXMLINVOICEType;
begin
  Result := NewXMLDocument.GetDocBinding('INVOICE', TXMLINVOICEType, TargetNamespace) as IXMLINVOICEType;
end;

{ TXMLINVOICEType }

procedure TXMLINVOICEType.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLINVOICEType.Get_DOCUMENTNAME: UnicodeString;
begin
  Result := ChildNodes['DOCUMENTNAME'].Text;
end;

procedure TXMLINVOICEType.Set_DOCUMENTNAME(Value: UnicodeString);
begin
  ChildNodes['DOCUMENTNAME'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_NUMBER: UnicodeString;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

procedure TXMLINVOICEType.Set_NUMBER(Value: UnicodeString);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLINVOICEType.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_DELIVERYDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYDATE'].Text;
end;

procedure TXMLINVOICEType.Set_DELIVERYDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYDATE'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_CURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLINVOICEType.Set_CURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_ORDERNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDERNUMBER'].Text;
end;

procedure TXMLINVOICEType.Set_ORDERNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDERNUMBER'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_ORDERDATE: UnicodeString;
begin
  Result := ChildNodes['ORDERDATE'].Text;
end;

procedure TXMLINVOICEType.Set_ORDERDATE(Value: UnicodeString);
begin
  ChildNodes['ORDERDATE'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_DELIVERYNOTENUMBER: UnicodeString;
begin
  Result := ChildNodes['DELIVERYNOTENUMBER'].Text;
end;

procedure TXMLINVOICEType.Set_DELIVERYNOTENUMBER(Value: UnicodeString);
begin
  ChildNodes['DELIVERYNOTENUMBER'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_DELIVERYNOTEDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYNOTEDATE'].Text;
end;

procedure TXMLINVOICEType.Set_DELIVERYNOTEDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYNOTEDATE'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_GOODSTOTALAMOUNT: UnicodeString;
begin
  Result := ChildNodes['GOODSTOTALAMOUNT'].Text;
end;

procedure TXMLINVOICEType.Set_GOODSTOTALAMOUNT(Value: UnicodeString);
begin
  ChildNodes['GOODSTOTALAMOUNT'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_POSITIONSAMOUNT: UnicodeString;
begin
  Result := ChildNodes['POSITIONSAMOUNT'].Text;
end;

procedure TXMLINVOICEType.Set_POSITIONSAMOUNT(Value: UnicodeString);
begin
  ChildNodes['POSITIONSAMOUNT'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_VATSUM: UnicodeString;
begin
  Result := ChildNodes['VATSUM'].Text;
end;

procedure TXMLINVOICEType.Set_VATSUM(Value: UnicodeString);
begin
  ChildNodes['VATSUM'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_INVOICETOTALAMOUNT: UnicodeString;
begin
  Result := ChildNodes['INVOICETOTALAMOUNT'].Text;
end;

procedure TXMLINVOICEType.Set_INVOICETOTALAMOUNT(Value: UnicodeString);
begin
  ChildNodes['INVOICETOTALAMOUNT'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_TAXABLEAMOUNT: UnicodeString;
begin
  Result := ChildNodes['TAXABLEAMOUNT'].Text;
end;

procedure TXMLINVOICEType.Set_TAXABLEAMOUNT(Value: UnicodeString);
begin
  ChildNodes['TAXABLEAMOUNT'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_PAYMENTORDERNUMBER: UnicodeString;
begin
  Result := ChildNodes['PAYMENTORDERNUMBER'].Text;
end;

procedure TXMLINVOICEType.Set_PAYMENTORDERNUMBER(Value: UnicodeString);
begin
  ChildNodes['PAYMENTORDERNUMBER'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_CAMPAIGNNUMBER: UnicodeString;
begin
  Result := ChildNodes['CAMPAIGNNUMBER'].Text;
end;

procedure TXMLINVOICEType.Set_CAMPAIGNNUMBER(Value: UnicodeString);
begin
  ChildNodes['CAMPAIGNNUMBER'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_MANAGER: UnicodeString;
begin
  Result := ChildNodes['MANAGER'].Text;
end;

procedure TXMLINVOICEType.Set_MANAGER(Value: UnicodeString);
begin
  ChildNodes['MANAGER'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_VAT: UnicodeString;
begin
  Result := ChildNodes['VAT'].Text;
end;

procedure TXMLINVOICEType.Set_VAT(Value: UnicodeString);
begin
  ChildNodes['VAT'].NodeValue := Value;
end;

function TXMLINVOICEType.Get_HEAD: IXMLHEADType;
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

function TXMLHEADType.Get_SENDER: UnicodeString;
begin
  Result := ChildNodes['SENDER'].Text;
end;

procedure TXMLHEADType.Set_SENDER(Value: UnicodeString);
begin
  ChildNodes['SENDER'].NodeValue := Value;
end;

function TXMLHEADType.Get_RECIPIENT: UnicodeString;
begin
  Result := ChildNodes['RECIPIENT'].Text;
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

procedure TXMLPOSITIONType.AfterConstruction;
begin
  RegisterChildNode('TAX', TXMLTAXType);
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

function TXMLPOSITIONType.Get_INVOICEUNIT: UnicodeString;
begin
  Result := ChildNodes['INVOICEUNIT'].Text;
end;

procedure TXMLPOSITIONType.Set_INVOICEUNIT(Value: UnicodeString);
begin
  ChildNodes['INVOICEUNIT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCTIDBUYER: UnicodeString;
begin
  Result := ChildNodes['PRODUCTIDBUYER'].Text;
end;

procedure TXMLPOSITIONType.Set_PRODUCTIDBUYER(Value: UnicodeString);
begin
  ChildNodes['PRODUCTIDBUYER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_INVOICEDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['INVOICEDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_INVOICEDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['INVOICEDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_UNITPRICE: UnicodeString;
begin
  Result := ChildNodes['UNITPRICE'].Text;
end;

procedure TXMLPOSITIONType.Set_UNITPRICE(Value: UnicodeString);
begin
  ChildNodes['UNITPRICE'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRICEWITHVAT: UnicodeString;
begin
  Result := ChildNodes['PRICEWITHVAT'].Text;
end;

procedure TXMLPOSITIONType.Set_PRICEWITHVAT(Value: UnicodeString);
begin
  ChildNodes['PRICEWITHVAT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_GROSSPRICE: UnicodeString;
begin
  Result := ChildNodes['GROSSPRICE'].Text;
end;

procedure TXMLPOSITIONType.Set_GROSSPRICE(Value: UnicodeString);
begin
  ChildNodes['GROSSPRICE'].NodeValue := Value;
end;


function TXMLPOSITIONType.Get_AMOUNT: UnicodeString;
begin
  Result := ChildNodes['AMOUNT'].Text;
end;

procedure TXMLPOSITIONType.Set_AMOUNT(Value: UnicodeString);
begin
  ChildNodes['AMOUNT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_DESCRIPTION: UnicodeString;
begin
  Result := ChildNodes['DESCRIPTION'].Text;
end;

procedure TXMLPOSITIONType.Set_DESCRIPTION(Value: UnicodeString);
begin
  ChildNodes['DESCRIPTION'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_AMOUNTTYPE: UnicodeString;
begin
  Result := ChildNodes['AMOUNTTYPE'].Text;
end;

procedure TXMLPOSITIONType.Set_AMOUNTTYPE(Value: UnicodeString);
begin
  ChildNodes['AMOUNTTYPE'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_TAX: IXMLTAXType;
begin
  Result := ChildNodes['TAX'] as IXMLTAXType;
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

{ TXMLTAXType }

function TXMLTAXType.Get_FUNCTION_: UnicodeString;
begin
  Result := ChildNodes['FUNCTION'].Text;
end;

procedure TXMLTAXType.Set_FUNCTION_(Value: UnicodeString);
begin
  ChildNodes['FUNCTION'].NodeValue := Value;
end;

function TXMLTAXType.Get_TAXTYPECODE: UnicodeString;
begin
  Result := ChildNodes['TAXTYPECODE'].Text;
end;

procedure TXMLTAXType.Set_TAXTYPECODE(Value: UnicodeString);
begin
  ChildNodes['TAXTYPECODE'].NodeValue := Value;
end;

function TXMLTAXType.Get_TAXRATE: UnicodeString;
begin
  Result := ChildNodes['TAXRATE'].Text;
end;

procedure TXMLTAXType.Set_TAXRATE(Value: UnicodeString);
begin
  ChildNodes['TAXRATE'].NodeValue := Value;
end;

function TXMLTAXType.Get_TAXAMOUNT: UnicodeString;
begin
  Result := ChildNodes['TAXAMOUNT'].Text;
end;

procedure TXMLTAXType.Set_TAXAMOUNT(Value: UnicodeString);
begin
  ChildNodes['TAXAMOUNT'].NodeValue := Value;
end;

function TXMLTAXType.Get_CATEGORY: UnicodeString;
begin
  Result := ChildNodes['CATEGORY'].Text;
end;

procedure TXMLTAXType.Set_CATEGORY(Value: UnicodeString);
begin
  ChildNodes['CATEGORY'].NodeValue := Value;
end;

end.
