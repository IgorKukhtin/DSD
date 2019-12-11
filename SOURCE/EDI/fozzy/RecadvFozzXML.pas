
{*******************************************************************************}
{                                                                               }
{                               XML Data Binding                                }
{                                                                               }
{         Generated on: 21.11.2019 13:40:33                                     }
{       Generated from: D:\Work\Project\XML\recadv_201911211034_547514528.xml   }
{   Settings stored in: D:\Work\Project\XML\recadv_201911211034_547514528.xdb   }
{                                                                               }
{*******************************************************************************}

unit RecadvFozzXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLRECADVType = interface;
  IXMLHEADType = interface;
  IXMLPACKINGSEQUENCEType = interface;
  IXMLPOSITIONType = interface;
  IXMLPOSITIONTypeList = interface;

{ IXMLRECADVType }

  IXMLRECADVType = interface(IXMLNode)
    ['{E0D41678-AD95-46C3-A9C4-24B267CBBB92}']
    { Property Accessors }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_RECEPTIONDATE: UnicodeString;
    function Get_RECEPTIONTIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DESADVNUMBER: Integer;
    function Get_DESADVDATE: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_RECEPTIONDATE(Value: UnicodeString);
    procedure Set_RECEPTIONTIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DESADVNUMBER(Value: Integer);
    procedure Set_DESADVDATE(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_DOCTYPE(Value: UnicodeString);
    { Methods & Properties }
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property RECEPTIONDATE: UnicodeString read Get_RECEPTIONDATE write Set_RECEPTIONDATE;
    property RECEPTIONTIME: UnicodeString read Get_RECEPTIONTIME write Set_RECEPTIONTIME;
    property ORDERNUMBER: UnicodeString read Get_ORDERNUMBER write Set_ORDERNUMBER;
    property ORDERDATE: UnicodeString read Get_ORDERDATE write Set_ORDERDATE;
    property DESADVNUMBER: Integer read Get_DESADVNUMBER write Set_DESADVNUMBER;
    property DESADVDATE: UnicodeString read Get_DESADVDATE write Set_DESADVDATE;
    property CAMPAIGNNUMBER: UnicodeString read Get_CAMPAIGNNUMBER write Set_CAMPAIGNNUMBER;
    property DOCTYPE: UnicodeString read Get_DOCTYPE write Set_DOCTYPE;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{F8832FCF-1A23-426B-B2EE-7C09F3FD94C9}']
    { Property Accessors }
    function Get_SUPPLIER: Integer;
    function Get_BUYER: Integer;
    function Get_DELIVERYPLACE: Integer;
    function Get_SENDER: Integer;
    function Get_RECIPIENT: Integer;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
    procedure Set_SUPPLIER(Value: Integer);
    procedure Set_BUYER(Value: Integer);
    procedure Set_DELIVERYPLACE(Value: Integer);
    procedure Set_SENDER(Value: Integer);
    procedure Set_RECIPIENT(Value: Integer);
    procedure Set_EDIINTERCHANGEID(Value: UnicodeString);
    { Methods & Properties }
    property SUPPLIER: Integer read Get_SUPPLIER write Set_SUPPLIER;
    property BUYER: Integer read Get_BUYER write Set_BUYER;
    property DELIVERYPLACE: Integer read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property SENDER: Integer read Get_SENDER write Set_SENDER;
    property RECIPIENT: Integer read Get_RECIPIENT write Set_RECIPIENT;
    property EDIINTERCHANGEID: UnicodeString read Get_EDIINTERCHANGEID write Set_EDIINTERCHANGEID;
    property PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType read Get_PACKINGSEQUENCE;
  end;

{ IXMLPACKINGSEQUENCEType }

  IXMLPACKINGSEQUENCEType = interface(IXMLNode)
    ['{32A3C7C4-6C79-4670-A1E2-F94AE25CD9A4}']
    { Property Accessors }
    function Get_HIERARCHICALID: Integer;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_HIERARCHICALID(Value: Integer);
    { Methods & Properties }
    property HIERARCHICALID: Integer read Get_HIERARCHICALID write Set_HIERARCHICALID;
    property POSITION: IXMLPOSITIONTypeList read Get_POSITION;
  end;

{ IXMLPOSITIONType }

  IXMLPOSITIONType = interface(IXMLNode)
    ['{6A45C151-CBC5-47F8-A52C-AA7D38540FC3}']
    { Property Accessors }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: Integer;
    function Get_PRODUCTIDBUYER: Integer;
    function Get_ACCEPTEDQUANTITY: UnicodeString;
    function Get_ACCEPTEDUNIT: UnicodeString;
    function Get_ORDERQUANTITY: UnicodeString;
    function Get_DELIVERQUANTITY: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_AMOUNTWITHVAT: UnicodeString;
    function Get_VAT: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: Integer);
    procedure Set_PRODUCTIDBUYER(Value: Integer);
    procedure Set_ACCEPTEDQUANTITY(Value: UnicodeString);
    procedure Set_ACCEPTEDUNIT(Value: UnicodeString);
    procedure Set_ORDERQUANTITY(Value: UnicodeString);
    procedure Set_DELIVERQUANTITY(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_AMOUNTWITHVAT(Value: UnicodeString);
    procedure Set_VAT(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: Integer read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: Integer read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: Integer read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property ACCEPTEDQUANTITY: UnicodeString read Get_ACCEPTEDQUANTITY write Set_ACCEPTEDQUANTITY;
    property ACCEPTEDUNIT: UnicodeString read Get_ACCEPTEDUNIT write Set_ACCEPTEDUNIT;
    property ORDERQUANTITY: UnicodeString read Get_ORDERQUANTITY write Set_ORDERQUANTITY;
    property DELIVERQUANTITY: UnicodeString read Get_DELIVERQUANTITY write Set_DELIVERQUANTITY;
    property PRICE: UnicodeString read Get_PRICE write Set_PRICE;
    property PRICEWITHVAT: UnicodeString read Get_PRICEWITHVAT write Set_PRICEWITHVAT;
    property AMOUNT: UnicodeString read Get_AMOUNT write Set_AMOUNT;
    property AMOUNTWITHVAT: UnicodeString read Get_AMOUNTWITHVAT write Set_AMOUNTWITHVAT;
    property VAT: UnicodeString read Get_VAT write Set_VAT;
    property DESCRIPTION: UnicodeString read Get_DESCRIPTION write Set_DESCRIPTION;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{041B500E-1F13-4A91-AB98-C613CE86D40D}']
    { Methods & Properties }
    function Add: IXMLPOSITIONType;
    function Insert(const Index: Integer): IXMLPOSITIONType;

    function Get_Item(Index: Integer): IXMLPOSITIONType;
    property Items[Index: Integer]: IXMLPOSITIONType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLRECADVType = class;
  TXMLHEADType = class;
  TXMLPACKINGSEQUENCEType = class;
  TXMLPOSITIONType = class;
  TXMLPOSITIONTypeList = class;

{ TXMLRECADVType }

  TXMLRECADVType = class(TXMLNode, IXMLRECADVType)
  protected
    { IXMLRECADVType }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_RECEPTIONDATE: UnicodeString;
    function Get_RECEPTIONTIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_DESADVNUMBER: Integer;
    function Get_DESADVDATE: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_DOCTYPE: UnicodeString;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_RECEPTIONDATE(Value: UnicodeString);
    procedure Set_RECEPTIONTIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_DESADVNUMBER(Value: Integer);
    procedure Set_DESADVDATE(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_DOCTYPE(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLHEADType }

  TXMLHEADType = class(TXMLNode, IXMLHEADType)
  protected
    { IXMLHEADType }
    function Get_SUPPLIER: Integer;
    function Get_BUYER: Integer;
    function Get_DELIVERYPLACE: Integer;
    function Get_SENDER: Integer;
    function Get_RECIPIENT: Integer;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
    procedure Set_SUPPLIER(Value: Integer);
    procedure Set_BUYER(Value: Integer);
    procedure Set_DELIVERYPLACE(Value: Integer);
    procedure Set_SENDER(Value: Integer);
    procedure Set_RECIPIENT(Value: Integer);
    procedure Set_EDIINTERCHANGEID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPACKINGSEQUENCEType }

  TXMLPACKINGSEQUENCEType = class(TXMLNode, IXMLPACKINGSEQUENCEType)
  private
    FPOSITION: IXMLPOSITIONTypeList;
  protected
    { IXMLPACKINGSEQUENCEType }
    function Get_HIERARCHICALID: Integer;
    function Get_POSITION: IXMLPOSITIONTypeList;
    procedure Set_HIERARCHICALID(Value: Integer);
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
    function Get_ACCEPTEDQUANTITY: UnicodeString;
    function Get_ACCEPTEDUNIT: UnicodeString;
    function Get_ORDERQUANTITY: UnicodeString;
    function Get_DELIVERQUANTITY: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_AMOUNTWITHVAT: UnicodeString;
    function Get_VAT: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: Integer);
    procedure Set_PRODUCTIDBUYER(Value: Integer);
    procedure Set_ACCEPTEDQUANTITY(Value: UnicodeString);
    procedure Set_ACCEPTEDUNIT(Value: UnicodeString);
    procedure Set_ORDERQUANTITY(Value: UnicodeString);
    procedure Set_DELIVERQUANTITY(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_AMOUNTWITHVAT(Value: UnicodeString);
    procedure Set_VAT(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
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

function GetRecadv(Doc: IXMLDocument): IXMLRECADVType;
function LoadRecadv(const FileName: string): IXMLRECADVType;
function NewRecadv: IXMLRECADVType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetRecadv(Doc: IXMLDocument): IXMLRECADVType;
begin
  Result := Doc.GetDocBinding('Recadv', TXMLRECADVType, TargetNamespace) as IXMLRECADVType;
end;

function LoadRecadv(const FileName: string): IXMLRECADVType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Recadv', TXMLRECADVType, TargetNamespace) as IXMLRECADVType;
end;

function NewRecadv: IXMLRECADVType;
begin
  Result := NewXMLDocument.GetDocBinding('Recadv', TXMLRECADVType, TargetNamespace) as IXMLRECADVType;
end;

{ TXMLRECADVType }

procedure TXMLRECADVType.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLHEADType);
  inherited;
end;

function TXMLRECADVType.Get_NUMBER: UnicodeString;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

procedure TXMLRECADVType.Set_NUMBER(Value: UnicodeString);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLRECADVType.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLRECADVType.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLRECADVType.Get_RECEPTIONDATE: UnicodeString;
begin
  Result := ChildNodes['RECEPTIONDATE'].Text;
end;

procedure TXMLRECADVType.Set_RECEPTIONDATE(Value: UnicodeString);
begin
  ChildNodes['RECEPTIONDATE'].NodeValue := Value;
end;

function TXMLRECADVType.Get_RECEPTIONTIME: UnicodeString;
begin
  Result := ChildNodes['RECEPTIONTIME'].Text;
end;

procedure TXMLRECADVType.Set_RECEPTIONTIME(Value: UnicodeString);
begin
  ChildNodes['RECEPTIONTIME'].NodeValue := Value;
end;

function TXMLRECADVType.Get_ORDERNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDERNUMBER'].Text;
end;

procedure TXMLRECADVType.Set_ORDERNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDERNUMBER'].NodeValue := Value;
end;

function TXMLRECADVType.Get_ORDERDATE: UnicodeString;
begin
  Result := ChildNodes['ORDERDATE'].Text;
end;

procedure TXMLRECADVType.Set_ORDERDATE(Value: UnicodeString);
begin
  ChildNodes['ORDERDATE'].NodeValue := Value;
end;

function TXMLRECADVType.Get_DESADVNUMBER: Integer;
begin
  Result := ChildNodes['DESADVNUMBER'].NodeValue;
end;

procedure TXMLRECADVType.Set_DESADVNUMBER(Value: Integer);
begin
  ChildNodes['DESADVNUMBER'].NodeValue := Value;
end;

function TXMLRECADVType.Get_DESADVDATE: UnicodeString;
begin
  Result := ChildNodes['DESADVDATE'].Text;
end;

procedure TXMLRECADVType.Set_DESADVDATE(Value: UnicodeString);
begin
  ChildNodes['DESADVDATE'].NodeValue := Value;
end;

function TXMLRECADVType.Get_CAMPAIGNNUMBER: UnicodeString;
begin
  Result := ChildNodes['CAMPAIGNNUMBER'].Text;
end;

procedure TXMLRECADVType.Set_CAMPAIGNNUMBER(Value: UnicodeString);
begin
  ChildNodes['CAMPAIGNNUMBER'].NodeValue := Value;
end;

function TXMLRECADVType.Get_DOCTYPE: UnicodeString;
begin
  Result := ChildNodes['DOCTYPE'].Text;
end;

procedure TXMLRECADVType.Set_DOCTYPE(Value: UnicodeString);
begin
  ChildNodes['DOCTYPE'].NodeValue := Value;
end;

function TXMLRECADVType.Get_HEAD: IXMLHEADType;
begin
  Result := ChildNodes['HEAD'] as IXMLHEADType;
end;

{ TXMLHEADType }

procedure TXMLHEADType.AfterConstruction;
begin
  RegisterChildNode('PACKINGSEQUENCE', TXMLPACKINGSEQUENCEType);
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

function TXMLPACKINGSEQUENCEType.Get_HIERARCHICALID: Integer;
begin
  Result := ChildNodes['HIERARCHICALID'].NodeValue;
end;

procedure TXMLPACKINGSEQUENCEType.Set_HIERARCHICALID(Value: Integer);
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

function TXMLPOSITIONType.Get_ACCEPTEDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ACCEPTEDQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_ACCEPTEDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ACCEPTEDQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ACCEPTEDUNIT: UnicodeString;
begin
  Result := ChildNodes['ACCEPTEDUNIT'].Text;
end;

procedure TXMLPOSITIONType.Set_ACCEPTEDUNIT(Value: UnicodeString);
begin
  ChildNodes['ACCEPTEDUNIT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_ORDERQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ORDERQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_ORDERQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ORDERQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_DELIVERQUANTITY: UnicodeString;
begin
  Result := ChildNodes['DELIVERQUANTITY'].Text;
end;

procedure TXMLPOSITIONType.Set_DELIVERQUANTITY(Value: UnicodeString);
begin
  ChildNodes['DELIVERQUANTITY'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRICE: UnicodeString;
begin
  Result := ChildNodes['PRICE'].Text;
end;

procedure TXMLPOSITIONType.Set_PRICE(Value: UnicodeString);
begin
  ChildNodes['PRICE'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRICEWITHVAT: UnicodeString;
begin
  Result := ChildNodes['PRICEWITHVAT'].Text;
end;

procedure TXMLPOSITIONType.Set_PRICEWITHVAT(Value: UnicodeString);
begin
  ChildNodes['PRICEWITHVAT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_AMOUNT: UnicodeString;
begin
  Result := ChildNodes['AMOUNT'].Text;
end;

procedure TXMLPOSITIONType.Set_AMOUNT(Value: UnicodeString);
begin
  ChildNodes['AMOUNT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_AMOUNTWITHVAT: UnicodeString;
begin
  Result := ChildNodes['AMOUNTWITHVAT'].Text;
end;

procedure TXMLPOSITIONType.Set_AMOUNTWITHVAT(Value: UnicodeString);
begin
  ChildNodes['AMOUNTWITHVAT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_VAT: UnicodeString;
begin
  Result := ChildNodes['VAT'].Text;
end;

procedure TXMLPOSITIONType.Set_VAT(Value: UnicodeString);
begin
  ChildNodes['VAT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_DESCRIPTION: UnicodeString;
begin
  Result := ChildNodes['DESCRIPTION'].Text;
end;

procedure TXMLPOSITIONType.Set_DESCRIPTION(Value: UnicodeString);
begin
  ChildNodes['DESCRIPTION'].NodeValue := Value;
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