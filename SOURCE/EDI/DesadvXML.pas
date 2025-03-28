unit DesadvXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDESADVType = interface;
  IXMLHEADType = interface;
  IXMLPACKINGSEQUENCEType = interface;
  IXMLPOSITIONType = interface;
  IXMLPOSITIONTypeList = interface;

{ IXMLDESADVType }

  IXMLDESADVType = interface(IXMLNode)
    ['{EA7ACAE7-6373-4AD4-8A7A-CB63E274B42C}']
    { Property Accessors }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: UnicodeString;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: UnicodeString);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_INFO(Value: UnicodeString);
   { Methods & Properties }
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property ORDERNUMBER: UnicodeString read Get_ORDERNUMBER write Set_ORDERNUMBER;
    property ORDERDATE: UnicodeString read Get_ORDERDATE write Set_ORDERDATE;
    property DELIVERYNOTENUMBER: UnicodeString read Get_DELIVERYNOTENUMBER write Set_DELIVERYNOTENUMBER;
    property DELIVERYNOTEDATE: UnicodeString read Get_DELIVERYNOTEDATE write Set_DELIVERYNOTEDATE;
    property INFO: UnicodeString read Get_INFO write Set_INFO;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{2ABDCAA3-CDD2-42D6-8FF2-413828FD2056}']
    { Property Accessors }
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
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
    property PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType read Get_PACKINGSEQUENCE;
  end;

{ IXMLPACKINGSEQUENCEType }

  IXMLPACKINGSEQUENCEType = interface(IXMLNode)
    ['{978C88A1-1BB4-4B84-A6FC-144058A422C0}']
    { Property Accessors }
    function Get_HIERARCHICALID: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_HIERARCHICALID(Value: UnicodeString);
    { Methods & Properties }
    property HIERARCHICALID: UnicodeString read Get_HIERARCHICALID write Set_HIERARCHICALID;
    property POSITION: IXMLPOSITIONTypeList read Get_POSITION;
  end;

{ IXMLPOSITIONType }

  IXMLPOSITIONType = interface(IXMLNode)
    ['{E3A0FC8A-A180-4BD2-B7AB-C5C5241E54EC}']
    { Property Accessors }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDSUPPLIER: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_DELIVEREDQUANTITY: UnicodeString;
    function Get_DELIVEREDUNIT: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_BOXESQUANTITY: UnicodeString;
    function Get_COUNTRYORIGIN: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_TAXRATE: UnicodeString;

    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDSUPPLIER(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_DELIVEREDQUANTITY(Value: UnicodeString);
    procedure Set_DELIVEREDUNIT(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_BOXESQUANTITY(Value: UnicodeString);
    procedure Set_COUNTRYORIGIN(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_TAXRATE(Value: UnicodeString);

    { Methods & Properties }
    property POSITIONNUMBER: Integer read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: UnicodeString read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDSUPPLIER: UnicodeString read Get_PRODUCTIDSUPPLIER write Set_PRODUCTIDSUPPLIER;
    property PRODUCTIDBUYER: UnicodeString read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property DESCRIPTION: UnicodeString read Get_DESCRIPTION write Set_DESCRIPTION;
    property DELIVEREDQUANTITY: UnicodeString read Get_DELIVEREDQUANTITY write Set_DELIVEREDQUANTITY;
    property DELIVEREDUNIT: UnicodeString read Get_DELIVEREDUNIT write Set_DELIVEREDUNIT;
    property ORDEREDQUANTITY: UnicodeString read Get_ORDEREDQUANTITY write Set_ORDEREDQUANTITY;
    property BOXESQUANTITY: UnicodeString read Get_BOXESQUANTITY write Set_BOXESQUANTITY;
    property COUNTRYORIGIN: UnicodeString read Get_COUNTRYORIGIN write Set_COUNTRYORIGIN;
    property PRICE: UnicodeString read Get_PRICE write Set_PRICE;
    property PRICEWITHVAT: UnicodeString read Get_PRICEWITHVAT write Set_PRICEWITHVAT;
    property TAXRATE: UnicodeString read Get_TAXRATE write Set_TAXRATE;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{CE5BA136-B2EA-43CA-A3F2-1B773822EE8C}']
    { Methods & Properties }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
    property Items[Index: Integer]: IXMLPOSITIONType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLDESADVType = class;
  TXMLHEADType = class;
  TXMLPACKINGSEQUENCEType = class;
  TXMLPOSITIONType = class;
  TXMLPOSITIONTypeList = class;

{ TXMLDESADVType }

  TXMLDESADVType = class(TXMLNode, IXMLDESADVType)
  protected
    { IXMLDESADVType }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: UnicodeString;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: UnicodeString);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_INFO(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHEADType }

  TXMLHEADType = class(TXMLNode, IXMLHEADType)
  protected
    { IXMLHEADType }
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPACKINGSEQUENCEType }

  TXMLPACKINGSEQUENCEType = class(TXMLNode, IXMLPACKINGSEQUENCEType)
  private
    FPOSITION: IXMLPOSITIONTypeList;
  protected
    { IXMLPACKINGSEQUENCEType }
    function Get_HIERARCHICALID: UnicodeString;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_HIERARCHICALID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPOSITIONType }

  TXMLPOSITIONType = class(TXMLNode, IXMLPOSITIONType)
  protected
    { IXMLPOSITIONType }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDSUPPLIER: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_DELIVEREDQUANTITY: UnicodeString;
    function Get_DELIVEREDUNIT: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_BOXESQUANTITY: UnicodeString;
    function Get_COUNTRYORIGIN: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_TAXRATE: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDSUPPLIER(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_DELIVEREDQUANTITY(Value: UnicodeString);
    procedure Set_DELIVEREDUNIT(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_BOXESQUANTITY(Value: UnicodeString);
    procedure Set_COUNTRYORIGIN(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_TAXRATE(Value: UnicodeString);
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

function GetDESADV(Doc: IXMLDocument): IXMLDESADVType;
function LoadDESADV(XMLString: string): IXMLDESADVType;
function NewDESADV: IXMLDESADVType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDESADV(Doc: IXMLDocument): IXMLDESADVType;
begin
  Result := Doc.GetDocBinding('DESADV', TXMLDESADVType, TargetNamespace) as IXMLDESADVType;
end;

function LoadDESADV(XMLString: string): IXMLDESADVType;
begin
  with NewXMLDocument do begin
    LoadFromXML(XMLString);
    Result := GetDocBinding('DESADV', TXMLDESADVType, TargetNamespace) as IXMLDESADVType;
  end;
end;

function NewDESADV: IXMLDESADVType;
begin
  Result := NewXMLDocument.GetDocBinding('DESADV', TXMLDESADVType, TargetNamespace) as IXMLDESADVType;
end;

{ TXMLDESADVType }

procedure TXMLDESADVType.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLDESADVType.Get_NUMBER: UnicodeString;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

procedure TXMLDESADVType.Set_NUMBER(Value: UnicodeString);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLDESADVType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLDESADVType.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLDESADVType.Get_DELIVERYDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYDATE'].Text;
end;

procedure TXMLDESADVType.Set_DELIVERYDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYDATE'].NodeValue := Value;
end;

function TXMLDESADVType.Get_ORDERNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDERNUMBER'].Text;
end;

procedure TXMLDESADVType.Set_ORDERNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDERNUMBER'].NodeValue := Value;
end;

function TXMLDESADVType.Get_ORDERDATE: UnicodeString;
begin
  Result := ChildNodes['ORDERDATE'].Text;
end;

procedure TXMLDESADVType.Set_ORDERDATE(Value: UnicodeString);
begin
  ChildNodes['ORDERDATE'].NodeValue := Value;
end;

function TXMLDESADVType.Get_DELIVERYNOTENUMBER: UnicodeString;
begin
  Result := ChildNodes['DELIVERYNOTENUMBER'].Text;
end;

procedure TXMLDESADVType.Set_DELIVERYNOTENUMBER(Value: UnicodeString);
begin
  ChildNodes['DELIVERYNOTENUMBER'].NodeValue := Value;
end;

function TXMLDESADVType.Get_DELIVERYNOTEDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYNOTEDATE'].Text;
end;

procedure TXMLDESADVType.Set_DELIVERYNOTEDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYNOTEDATE'].NodeValue := Value;
end;

function TXMLDESADVType.Get_INFO: UnicodeString;
begin
  Result := ChildNodes['INFO'].Text;
end;

procedure TXMLDESADVType.Set_INFO(Value: UnicodeString);
begin
  ChildNodes['INFO'].NodeValue := Value;
end;

function TXMLDESADVType.Get_HEAD: IXMLHEADType;
begin
  Result := ChildNodes['HEAD'] as IXMLHEADType;
end;

{ TXMLHEADType }

procedure TXMLHEADType.AfterConstruction;
begin
  RegisterChildNode('PACKINGSEQUENCE', TXMLPACKINGSEQUENCEType);
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

function TXMLHEADType.Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
begin
  Result := ChildNodes['PACKINGSEQUENCE'] as IXMLPACKINGSEQUENCEType;
end;

{ TXMLPACKINGSEQUENCEType }

procedure TXMLPACKINGSEQUENCEType.AfterConstruction;
begin
  RegisterChildNode('POSITION', TXMLPOSITIONType);
  FPOSITION := CreateCollection(TXMLPOSITIONTypeList, IXMLPOSITIONType, 'POSITION') as IXMLPOSITIONTypeList;
  inherited;
end;

function TXMLPACKINGSEQUENCEType.Get_HIERARCHICALID: UnicodeString;
begin
  Result := ChildNodes['HIERARCHICALID'].Text;
end;

procedure TXMLPACKINGSEQUENCEType.Set_HIERARCHICALID(Value: UnicodeString);
begin
  ChildNodes['HIERARCHICALID'].NodeValue := Value;
end;

function TXMLPACKINGSEQUENCEType.Get_POSITION: IXMLPOSITIONTypeList;
begin
  Result := FPOSITION;
end;

{ TXMLPOSITIONType }

function TXMLPOSITIONType.Get_POSITIONNUMBER: Integer;
begin
  Result := ChildNodes['POSITIONNUMBER'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_POSITIONNUMBER(Value: Integer);
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

function TXMLPOSITIONType.Get_PRODUCTIDSUPPLIER: UnicodeString;
begin
  Result := ChildNodes['PRODUCTIDSUPPLIER'].Text;
end;

procedure TXMLPOSITIONType.Set_PRODUCTIDSUPPLIER(Value: UnicodeString);
begin
  ChildNodes['PRODUCTIDSUPPLIER'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRODUCTIDBUYER: UnicodeString;
begin
  Result := ChildNodes['PRODUCTIDBUYER'].Text;
end;

procedure TXMLPOSITIONType.Set_PRODUCTIDBUYER(Value: UnicodeString);
begin
  ChildNodes['PRODUCTIDBUYER'].NodeValue := Value;
end;

procedure TXMLPOSITIONType.Set_DESCRIPTION(Value: UnicodeString);
begin
  ChildNodes['DESCRIPTION'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_DESCRIPTION: UnicodeString;
begin
  Result := ChildNodes['DESCRIPTION'].Text;
end;


function TXMLPOSITIONType.Get_DELIVEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['DELIVEREDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_DELIVEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['DELIVEREDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_DELIVEREDUNIT: UnicodeString;
begin
  Result := ChildNodes['DELIVEREDUNIT'].Text;
end;

procedure TXMLPOSITIONType.Set_DELIVEREDUNIT(Value: UnicodeString);
begin
  ChildNodes['DELIVEREDUNIT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ORDEREDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ORDEREDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_BOXESQUANTITY: UnicodeString;
begin
  Result := ChildNodes['BOXESQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_BOXESQUANTITY(Value: UnicodeString);
begin
  ChildNodes['BOXESQUANTITY'].NodeValue := Value;
end;


function TXMLPOSITIONType.Get_COUNTRYORIGIN: UnicodeString;
begin
  Result := ChildNodes['COUNTRYORIGIN'].Text;
end;

procedure TXMLPOSITIONType.Set_COUNTRYORIGIN(Value: UnicodeString);
begin
  ChildNodes['COUNTRYORIGIN'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRICE: UnicodeString;
begin
  Result := ChildNodes['PRICE'].Text;
end;
function TXMLPOSITIONType.Get_PRICEWITHVAT: UnicodeString;
begin
  Result := ChildNodes['PRICEWITHVAT'].Text;
end;
function TXMLPOSITIONType.Get_TAXRATE: UnicodeString;
begin
  Result := ChildNodes['TAXRATE'].Text;
end;

procedure TXMLPOSITIONType.Set_PRICE(Value: UnicodeString);
begin
  ChildNodes['PRICE'].NodeValue := Value;
end;

procedure TXMLPOSITIONType.Set_PRICEWITHVAT(Value: UnicodeString);
begin
  ChildNodes['PRICEWITHVAT'].NodeValue := Value;
end;

procedure TXMLPOSITIONType.Set_TAXRATE(Value: UnicodeString);
begin
  ChildNodes['TAXRATE'].NodeValue := Value;
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