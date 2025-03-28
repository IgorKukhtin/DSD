
{*******************************************************************************}
{                                                                               }
{                               XML Data Binding                                }
{                                                                               }
{         Generated on: 21.11.2019 13:36:25                                     }
{       Generated from: D:\Work\Project\XML\desadv_201911211034_546761854.xml   }
{   Settings stored in: D:\Work\Project\XML\desadv_201911211034_546761854.xdb   }
{                                                                               }
{*******************************************************************************}

unit DesadvFozzXML;

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
    ['{1620D1BA-E11E-4233-90D6-FFB1096A49AC}']
    { Property Accessors }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_ORDRSPNUMBER: UnicodeString;
    function Get_ORDRSPDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: Integer;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_TRANSPORTTYPE: Integer;
    function Get_TRANSPORTERTYPE: Integer;
    function Get_TRANSPORTID: Integer;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_TRANSPORTQUANTITY: Integer;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_ORDRSPNUMBER(Value: UnicodeString);
    procedure Set_ORDRSPDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: Integer);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_TRANSPORTTYPE(Value: Integer);
    procedure Set_TRANSPORTERTYPE(Value: Integer);
    procedure Set_TRANSPORTID(Value: Integer);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_TRANSPORTQUANTITY(Value: Integer);
    { Methods & Properties }
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property DELIVERYTIME: UnicodeString read Get_DELIVERYTIME write Set_DELIVERYTIME;
    property ORDERNUMBER: UnicodeString read Get_ORDERNUMBER write Set_ORDERNUMBER;
    property ORDERDATE: UnicodeString read Get_ORDERDATE write Set_ORDERDATE;
    property ORDRSPNUMBER: UnicodeString read Get_ORDRSPNUMBER write Set_ORDRSPNUMBER;
    property ORDRSPDATE: UnicodeString read Get_ORDRSPDATE write Set_ORDRSPDATE;
    property DELIVERYNOTENUMBER: Integer read Get_DELIVERYNOTENUMBER write Set_DELIVERYNOTENUMBER;
    property DELIVERYNOTEDATE: UnicodeString read Get_DELIVERYNOTEDATE write Set_DELIVERYNOTEDATE;
    property TRANSPORTTYPE: Integer read Get_TRANSPORTTYPE write Set_TRANSPORTTYPE;
    property TRANSPORTERTYPE: Integer read Get_TRANSPORTERTYPE write Set_TRANSPORTERTYPE;
    property TRANSPORTID: Integer read Get_TRANSPORTID write Set_TRANSPORTID;
    property CAMPAIGNNUMBER: UnicodeString read Get_CAMPAIGNNUMBER write Set_CAMPAIGNNUMBER;
    property TRANSPORTQUANTITY: Integer read Get_TRANSPORTQUANTITY write Set_TRANSPORTQUANTITY;
    property HEAD: IXMLHEADType read Get_HEAD;
  end;

{ IXMLHEADType }

  IXMLHEADType = interface(IXMLNode)
    ['{8CC98F81-FA57-4C63-9776-4FA16F2512F9}']
    { Property Accessors }
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_FINALRECIPIENT: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_FINALRECIPIENT(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    procedure Set_EDIINTERCHANGEID(Value: UnicodeString);
    { Methods & Properties }
    property SUPPLIER: UnicodeString read Get_SUPPLIER write Set_SUPPLIER;
    property BUYER: UnicodeString read Get_BUYER write Set_BUYER;
    property DELIVERYPLACE: UnicodeString read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property FINALRECIPIENT: UnicodeString read Get_FINALRECIPIENT write Set_FINALRECIPIENT;
    property SENDER: UnicodeString read Get_SENDER write Set_SENDER;
    property RECIPIENT: UnicodeString read Get_RECIPIENT write Set_RECIPIENT;
    property EDIINTERCHANGEID: UnicodeString read Get_EDIINTERCHANGEID write Set_EDIINTERCHANGEID;
    property PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType read Get_PACKINGSEQUENCE;
  end;

{ IXMLPACKINGSEQUENCEType }

  IXMLPACKINGSEQUENCEType = interface(IXMLNode)
    ['{77BAB696-C28D-4A2E-9DA0-CD821CF561AF}']
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
    ['{466F8D68-223D-484C-9A36-FA2BD87E8157}']
    { Property Accessors }
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_DELIVEREDQUANTITY: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_BOXESQUANTITY: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_TAXRATE: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_DELIVEREDQUANTITY(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_BOXESQUANTITY(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
    procedure Set_TAXRATE(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: UnicodeString read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: UnicodeString read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: UnicodeString read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property DELIVEREDQUANTITY: UnicodeString read Get_DELIVEREDQUANTITY write Set_DELIVEREDQUANTITY;
    property ORDEREDQUANTITY: UnicodeString read Get_ORDEREDQUANTITY write Set_ORDEREDQUANTITY;
    property BOXESQUANTITY: UnicodeString read Get_BOXESQUANTITY write Set_BOXESQUANTITY;
    property AMOUNT: UnicodeString read Get_AMOUNT write Set_AMOUNT;
    property PRICE: UnicodeString read Get_PRICE write Set_PRICE;
    property TAXRATE: UnicodeString read Get_TAXRATE write Set_TAXRATE;
  end;

{ IXMLPOSITIONTypeList }

  IXMLPOSITIONTypeList = interface(IXMLNodeCollection)
    ['{5087E6A5-3B2F-450E-94B3-7FBC07AAB58B}']
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
    function Get_DELIVERYTIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_ORDRSPNUMBER: UnicodeString;
    function Get_ORDRSPDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: Integer;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_TRANSPORTTYPE: Integer;
    function Get_TRANSPORTERTYPE: Integer;
    function Get_TRANSPORTID: Integer;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_TRANSPORTQUANTITY: Integer;
    function Get_HEAD: IXMLHEADType;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_ORDRSPNUMBER(Value: UnicodeString);
    procedure Set_ORDRSPDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: Integer);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_TRANSPORTTYPE(Value: Integer);
    procedure Set_TRANSPORTERTYPE(Value: Integer);
    procedure Set_TRANSPORTID(Value: Integer);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_TRANSPORTQUANTITY(Value: Integer);
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
    function Get_FINALRECIPIENT: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLPACKINGSEQUENCEType;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_FINALRECIPIENT(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
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
    function Get_POSITIONNUMBER: UnicodeString;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_DELIVEREDQUANTITY: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_BOXESQUANTITY: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_TAXRATE: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: UnicodeString);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_DELIVEREDQUANTITY(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_BOXESQUANTITY(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
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

function GetDesadv(Doc: IXMLDocument): IXMLDESADVType;
function LoadDesadv(const FileName: string): IXMLDESADVType;
function NewDesadv: IXMLDESADVType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDesadv(Doc: IXMLDocument): IXMLDESADVType;
begin
  Result := Doc.GetDocBinding('DESADV', TXMLDESADVType, TargetNamespace) as IXMLDESADVType;
end;

function LoadDesadv(const FileName: string): IXMLDESADVType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('DESADV', TXMLDESADVType, TargetNamespace) as IXMLDESADVType;
end;

function NewDesadv: IXMLDESADVType;
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

function TXMLDESADVType.Get_DELIVERYTIME: UnicodeString;
begin
  Result := ChildNodes['DELIVERYTIME'].Text;
end;

procedure TXMLDESADVType.Set_DELIVERYTIME(Value: UnicodeString);
begin
  ChildNodes['DELIVERYTIME'].NodeValue := Value;
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

function TXMLDESADVType.Get_ORDRSPNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDRSPNUMBER'].Text;
end;

procedure TXMLDESADVType.Set_ORDRSPNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDRSPNUMBER'].NodeValue := Value;
end;

function TXMLDESADVType.Get_ORDRSPDATE: UnicodeString;
begin
  Result := ChildNodes['ORDRSPDATE'].Text;
end;

procedure TXMLDESADVType.Set_ORDRSPDATE(Value: UnicodeString);
begin
  ChildNodes['ORDRSPDATE'].NodeValue := Value;
end;

function TXMLDESADVType.Get_DELIVERYNOTENUMBER: Integer;
begin
  Result := ChildNodes['DELIVERYNOTENUMBER'].NodeValue;
end;

procedure TXMLDESADVType.Set_DELIVERYNOTENUMBER(Value: Integer);
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

function TXMLDESADVType.Get_TRANSPORTTYPE: Integer;
begin
  Result := ChildNodes['TRANSPORTTYPE'].NodeValue;
end;

procedure TXMLDESADVType.Set_TRANSPORTTYPE(Value: Integer);
begin
  ChildNodes['TRANSPORTTYPE'].NodeValue := Value;
end;

function TXMLDESADVType.Get_TRANSPORTERTYPE: Integer;
begin
  Result := ChildNodes['TRANSPORTERTYPE'].NodeValue;
end;

procedure TXMLDESADVType.Set_TRANSPORTERTYPE(Value: Integer);
begin
  ChildNodes['TRANSPORTERTYPE'].NodeValue := Value;
end;

function TXMLDESADVType.Get_TRANSPORTID: Integer;
begin
  Result := ChildNodes['TRANSPORTID'].NodeValue;
end;

procedure TXMLDESADVType.Set_TRANSPORTID(Value: Integer);
begin
  ChildNodes['TRANSPORTID'].NodeValue := Value;
end;

function TXMLDESADVType.Get_CAMPAIGNNUMBER: UnicodeString;
begin
  Result := ChildNodes['CAMPAIGNNUMBER'].Text;
end;

procedure TXMLDESADVType.Set_CAMPAIGNNUMBER(Value: UnicodeString);
begin
  ChildNodes['CAMPAIGNNUMBER'].NodeValue := Value;
end;

function TXMLDESADVType.Get_TRANSPORTQUANTITY: Integer;
begin
  Result := ChildNodes['TRANSPORTQUANTITY'].NodeValue;
end;

procedure TXMLDESADVType.Set_TRANSPORTQUANTITY(Value: Integer);
begin
  ChildNodes['TRANSPORTQUANTITY'].NodeValue := Value;
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
  Result := ChildNodes['SUPPLIER'].NodeValue;
end;

procedure TXMLHEADType.Set_SUPPLIER(Value: UnicodeString);
begin
  ChildNodes['SUPPLIER'].NodeValue := Value;
end;

function TXMLHEADType.Get_BUYER: UnicodeString;
begin
  Result := ChildNodes['BUYER'].NodeValue;
end;

procedure TXMLHEADType.Set_BUYER(Value: UnicodeString);
begin
  ChildNodes['BUYER'].NodeValue := Value;
end;

function TXMLHEADType.Get_DELIVERYPLACE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYPLACE'].NodeValue;
end;

procedure TXMLHEADType.Set_DELIVERYPLACE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYPLACE'].NodeValue := Value;
end;

function TXMLHEADType.Get_FINALRECIPIENT: UnicodeString;
begin
  Result := ChildNodes['FINALRECIPIENT'].NodeValue;
end;

procedure TXMLHEADType.Set_FINALRECIPIENT(Value: UnicodeString);
begin
  ChildNodes['FINALRECIPIENT'].NodeValue := Value;
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

function TXMLPOSITIONType.Get_DELIVEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['DELIVEREDQUANTITY'].NodeValue;
end;

procedure TXMLPOSITIONType.Set_DELIVEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['DELIVEREDQUANTITY'].NodeValue := Value;
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


function TXMLPOSITIONType.Get_AMOUNT: UnicodeString;
begin
  Result := ChildNodes['AMOUNT'].Text;
end;

procedure TXMLPOSITIONType.Set_AMOUNT(Value: UnicodeString);
begin
  ChildNodes['AMOUNT'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_PRICE: UnicodeString;
begin
  Result := ChildNodes['PRICE'].Text;
end;

procedure TXMLPOSITIONType.Set_PRICE(Value: UnicodeString);
begin
  ChildNodes['PRICE'].NodeValue := Value;
end;

function TXMLPOSITIONType.Get_TAXRATE: UnicodeString;
begin
  Result := ChildNodes['TAXRATE'].NodeValue;
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