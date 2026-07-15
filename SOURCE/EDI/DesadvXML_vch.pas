
{**********************************************************************************}
{                                                                                  }
{                                 XML Data Binding                                 }
{                                                                                  }
{         Generated on: 14.07.2026 15:25:13                                        }
{       Generated from: D:\Project-Basis\DOC\Вспомогательные\VCH\DESADV full.xsd   }
{   Settings stored in: D:\Project-Basis\DOC\Вспомогательные\VCH\DESADV full.xdb   }
{                                                                                  }
{**********************************************************************************}

unit DesadvXML_vch;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDESADV = interface;
  IXMLDESADV_HEAD = interface;
  IXMLDESADV_HEAD_PACKINGSEQUENCE = interface;
  IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION = interface;
  IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList = interface;
  IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES = interface;
  IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList = interface;

{ IXMLDESADV }

  IXMLDESADV = interface(IXMLNode)
    ['{888B9B4E-6FAC-4F0A-B7CD-E6FB8BA2CFC4}']
    { Property Accessors }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_TIME: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_ORDRSPNUMBER: UnicodeString;
    function Get_ORDRSPDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: UnicodeString;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_RECIPIENTCODE: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_TAXID: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_CAMPAIGNNUMBERDATE: UnicodeString;
    function Get_TRANSPORTQUANTITY: Integer;
    function Get_TRANSPORTID: Integer;
    function Get_TRANSPORTNUMBER: UnicodeString;
    function Get_TRANSPORTERNAME: UnicodeString;
    function Get_PACKAGEWIGHT: UnicodeString;
    function Get_HEAD: IXMLDESADV_HEAD;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_TIME(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_ORDRSPNUMBER(Value: UnicodeString);
    procedure Set_ORDRSPDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: UnicodeString);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_RECIPIENTCODE(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_INFO(Value: UnicodeString);
    procedure Set_TAXID(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBERDATE(Value: UnicodeString);
    procedure Set_TRANSPORTQUANTITY(Value: Integer);
    procedure Set_TRANSPORTID(Value: Integer);
    procedure Set_TRANSPORTNUMBER(Value: UnicodeString);
    procedure Set_TRANSPORTERNAME(Value: UnicodeString);
    procedure Set_PACKAGEWIGHT(Value: UnicodeString);
    { Methods & Properties }
    property NUMBER: UnicodeString read Get_NUMBER write Set_NUMBER;
    property DATE: UnicodeString read Get_DATE write Set_DATE;
    property TIME: UnicodeString read Get_TIME write Set_TIME;
    property DELIVERYDATE: UnicodeString read Get_DELIVERYDATE write Set_DELIVERYDATE;
    property DELIVERYTIME: UnicodeString read Get_DELIVERYTIME write Set_DELIVERYTIME;
    property ORDERNUMBER: UnicodeString read Get_ORDERNUMBER write Set_ORDERNUMBER;
    property ORDERDATE: UnicodeString read Get_ORDERDATE write Set_ORDERDATE;
    property ORDRSPNUMBER: UnicodeString read Get_ORDRSPNUMBER write Set_ORDRSPNUMBER;
    property ORDRSPDATE: UnicodeString read Get_ORDRSPDATE write Set_ORDRSPDATE;
    property DELIVERYNOTENUMBER: UnicodeString read Get_DELIVERYNOTENUMBER write Set_DELIVERYNOTENUMBER;
    property DELIVERYNOTEDATE: UnicodeString read Get_DELIVERYNOTEDATE write Set_DELIVERYNOTEDATE;
    property RECIPIENTCODE: UnicodeString read Get_RECIPIENTCODE write Set_RECIPIENTCODE;
    property CURRENCY: UnicodeString read Get_CURRENCY write Set_CURRENCY;
    property INFO: UnicodeString read Get_INFO write Set_INFO;
    property TAXID: UnicodeString read Get_TAXID write Set_TAXID;
    property CAMPAIGNNUMBER: UnicodeString read Get_CAMPAIGNNUMBER write Set_CAMPAIGNNUMBER;
    property CAMPAIGNNUMBERDATE: UnicodeString read Get_CAMPAIGNNUMBERDATE write Set_CAMPAIGNNUMBERDATE;
    property TRANSPORTQUANTITY: Integer read Get_TRANSPORTQUANTITY write Set_TRANSPORTQUANTITY;
    property TRANSPORTID: Integer read Get_TRANSPORTID write Set_TRANSPORTID;
    property TRANSPORTNUMBER: UnicodeString read Get_TRANSPORTNUMBER write Set_TRANSPORTNUMBER;
    property TRANSPORTERNAME: UnicodeString read Get_TRANSPORTERNAME write Set_TRANSPORTERNAME;
    property PACKAGEWIGHT: UnicodeString read Get_PACKAGEWIGHT write Set_PACKAGEWIGHT;
    property HEAD: IXMLDESADV_HEAD read Get_HEAD;
  end;

{ IXMLDESADV_HEAD }

  IXMLDESADV_HEAD = interface(IXMLNode)
    ['{2B38E8A1-088C-4E2B-BB0D-635CE92D2907}']
    { Property Accessors }
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_BUYERCODE: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_FINALRECIPIENT: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLDESADV_HEAD_PACKINGSEQUENCE;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_BUYERCODE(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_FINALRECIPIENT(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    procedure Set_EDIINTERCHANGEID(Value: UnicodeString);
    { Methods & Properties }
    property SUPPLIER: UnicodeString read Get_SUPPLIER write Set_SUPPLIER;
    property BUYER: UnicodeString read Get_BUYER write Set_BUYER;
    property BUYERCODE: UnicodeString read Get_BUYERCODE write Set_BUYERCODE;
    property DELIVERYPLACE: UnicodeString read Get_DELIVERYPLACE write Set_DELIVERYPLACE;
    property FINALRECIPIENT: UnicodeString read Get_FINALRECIPIENT write Set_FINALRECIPIENT;
    property SENDER: UnicodeString read Get_SENDER write Set_SENDER;
    property RECIPIENT: UnicodeString read Get_RECIPIENT write Set_RECIPIENT;
    property EDIINTERCHANGEID: UnicodeString read Get_EDIINTERCHANGEID write Set_EDIINTERCHANGEID;
    property PACKINGSEQUENCE: IXMLDESADV_HEAD_PACKINGSEQUENCE read Get_PACKINGSEQUENCE;
  end;

{ IXMLDESADV_HEAD_PACKINGSEQUENCE }

  IXMLDESADV_HEAD_PACKINGSEQUENCE = interface(IXMLNode)
    ['{B6C530FA-5367-444E-9F14-D0C0F4157843}']
    { Property Accessors }
    function Get_POSITION: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList;
    function Get_CERTIFICATES: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList;
    { Methods & Properties }
    property POSITION: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList read Get_POSITION;
    property CERTIFICATES: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList read Get_CERTIFICATES;
  end;

{ IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION }

  IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION = interface(IXMLNode)
    ['{BC0FE4E3-0993-4F38-A470-D4DB4C53EEB8}']
    { Property Accessors }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_PRODUCTIDSUPPLIER: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_DELIVEREDUNIT: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_DELIVEREDQUANTITY: UnicodeString;
    function Get_AMOUNTWITHVAT: UnicodeString;
    function Get_CUSTOMSTARIFFNUMBER: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_TAXRATE: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_PRODUCTTYPE: UnicodeString;
    function Get_BATCHNUMBER: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_PRODUCTIDSUPPLIER(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_DELIVEREDUNIT(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_DELIVEREDQUANTITY(Value: UnicodeString);
    procedure Set_AMOUNTWITHVAT(Value: UnicodeString);
    procedure Set_CUSTOMSTARIFFNUMBER(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
    procedure Set_TAXRATE(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
    procedure Set_PRODUCTTYPE(Value: UnicodeString);
    procedure Set_BATCHNUMBER(Value: UnicodeString);
    { Methods & Properties }
    property POSITIONNUMBER: Integer read Get_POSITIONNUMBER write Set_POSITIONNUMBER;
    property PRODUCT: UnicodeString read Get_PRODUCT write Set_PRODUCT;
    property PRODUCTIDBUYER: UnicodeString read Get_PRODUCTIDBUYER write Set_PRODUCTIDBUYER;
    property PRODUCTIDSUPPLIER: UnicodeString read Get_PRODUCTIDSUPPLIER write Set_PRODUCTIDSUPPLIER;
    property PRICEWITHVAT: UnicodeString read Get_PRICEWITHVAT write Set_PRICEWITHVAT;
    property DELIVEREDUNIT: UnicodeString read Get_DELIVEREDUNIT write Set_DELIVEREDUNIT;
    property ORDEREDQUANTITY: UnicodeString read Get_ORDEREDQUANTITY write Set_ORDEREDQUANTITY;
    property AMOUNT: UnicodeString read Get_AMOUNT write Set_AMOUNT;
    property DELIVEREDQUANTITY: UnicodeString read Get_DELIVEREDQUANTITY write Set_DELIVEREDQUANTITY;
    property AMOUNTWITHVAT: UnicodeString read Get_AMOUNTWITHVAT write Set_AMOUNTWITHVAT;
    property CUSTOMSTARIFFNUMBER: UnicodeString read Get_CUSTOMSTARIFFNUMBER write Set_CUSTOMSTARIFFNUMBER;
    property PRICE: UnicodeString read Get_PRICE write Set_PRICE;
    property TAXRATE: UnicodeString read Get_TAXRATE write Set_TAXRATE;
    property DESCRIPTION: UnicodeString read Get_DESCRIPTION write Set_DESCRIPTION;
    property MINIMUMORDERQUANTITY: UnicodeString read Get_MINIMUMORDERQUANTITY write Set_MINIMUMORDERQUANTITY;
    property PRODUCTTYPE: UnicodeString read Get_PRODUCTTYPE write Set_PRODUCTTYPE;
    property BATCHNUMBER: UnicodeString read Get_BATCHNUMBER write Set_BATCHNUMBER;
  end;

{ IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList }

  IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList = interface(IXMLNodeCollection)
    ['{8247985C-2111-42DF-B58C-C0F2BB3E430E}']
    { Methods & Properties }
    function Add: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
    function Insert(const Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;

    function Get_Item(Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
    property Items[Index: Integer]: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION read Get_Item; default;
  end;

{ IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES }

  IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES = interface(IXMLNode)
    ['{9D8B6EFC-F075-4F0C-A1BD-40B0E9B20989}']
    { Property Accessors }
    function Get_BATCHNUMBER: UnicodeString;
    procedure Set_BATCHNUMBER(Value: UnicodeString);
    { Methods & Properties }
    property BATCHNUMBER: UnicodeString read Get_BATCHNUMBER write Set_BATCHNUMBER;
  end;

{ IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList }

  IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList = interface(IXMLNodeCollection)
    ['{16CE888D-9BCA-4AEA-8045-02F0A8E71931}']
    { Methods & Properties }
    function Add: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
    function Insert(const Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;

    function Get_Item(Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
    property Items[Index: Integer]: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES read Get_Item; default;
  end;

{ Forward Decls }

  TXMLDESADV = class;
  TXMLDESADV_HEAD = class;
  TXMLDESADV_HEAD_PACKINGSEQUENCE = class;
  TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION = class;
  TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList = class;
  TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES = class;
  TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList = class;

{ TXMLDESADV }

  TXMLDESADV = class(TXMLNode, IXMLDESADV)
  protected
    { IXMLDESADV }
    function Get_NUMBER: UnicodeString;
    function Get_DATE: UnicodeString;
    function Get_TIME: UnicodeString;
    function Get_DELIVERYDATE: UnicodeString;
    function Get_DELIVERYTIME: UnicodeString;
    function Get_ORDERNUMBER: UnicodeString;
    function Get_ORDERDATE: UnicodeString;
    function Get_ORDRSPNUMBER: UnicodeString;
    function Get_ORDRSPDATE: UnicodeString;
    function Get_DELIVERYNOTENUMBER: UnicodeString;
    function Get_DELIVERYNOTEDATE: UnicodeString;
    function Get_RECIPIENTCODE: UnicodeString;
    function Get_CURRENCY: UnicodeString;
    function Get_INFO: UnicodeString;
    function Get_TAXID: UnicodeString;
    function Get_CAMPAIGNNUMBER: UnicodeString;
    function Get_CAMPAIGNNUMBERDATE: UnicodeString;
    function Get_TRANSPORTQUANTITY: Integer;
    function Get_TRANSPORTID: Integer;
    function Get_TRANSPORTNUMBER: UnicodeString;
    function Get_TRANSPORTERNAME: UnicodeString;
    function Get_PACKAGEWIGHT: UnicodeString;
    function Get_HEAD: IXMLDESADV_HEAD;
    procedure Set_NUMBER(Value: UnicodeString);
    procedure Set_DATE(Value: UnicodeString);
    procedure Set_TIME(Value: UnicodeString);
    procedure Set_DELIVERYDATE(Value: UnicodeString);
    procedure Set_DELIVERYTIME(Value: UnicodeString);
    procedure Set_ORDERNUMBER(Value: UnicodeString);
    procedure Set_ORDERDATE(Value: UnicodeString);
    procedure Set_ORDRSPNUMBER(Value: UnicodeString);
    procedure Set_ORDRSPDATE(Value: UnicodeString);
    procedure Set_DELIVERYNOTENUMBER(Value: UnicodeString);
    procedure Set_DELIVERYNOTEDATE(Value: UnicodeString);
    procedure Set_RECIPIENTCODE(Value: UnicodeString);
    procedure Set_CURRENCY(Value: UnicodeString);
    procedure Set_INFO(Value: UnicodeString);
    procedure Set_TAXID(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBER(Value: UnicodeString);
    procedure Set_CAMPAIGNNUMBERDATE(Value: UnicodeString);
    procedure Set_TRANSPORTQUANTITY(Value: Integer);
    procedure Set_TRANSPORTID(Value: Integer);
    procedure Set_TRANSPORTNUMBER(Value: UnicodeString);
    procedure Set_TRANSPORTERNAME(Value: UnicodeString);
    procedure Set_PACKAGEWIGHT(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDESADV_HEAD }

  TXMLDESADV_HEAD = class(TXMLNode, IXMLDESADV_HEAD)
  protected
    { IXMLDESADV_HEAD }
    function Get_SUPPLIER: UnicodeString;
    function Get_BUYER: UnicodeString;
    function Get_BUYERCODE: UnicodeString;
    function Get_DELIVERYPLACE: UnicodeString;
    function Get_FINALRECIPIENT: UnicodeString;
    function Get_SENDER: UnicodeString;
    function Get_RECIPIENT: UnicodeString;
    function Get_EDIINTERCHANGEID: UnicodeString;
    function Get_PACKINGSEQUENCE: IXMLDESADV_HEAD_PACKINGSEQUENCE;
    procedure Set_SUPPLIER(Value: UnicodeString);
    procedure Set_BUYER(Value: UnicodeString);
    procedure Set_BUYERCODE(Value: UnicodeString);
    procedure Set_DELIVERYPLACE(Value: UnicodeString);
    procedure Set_FINALRECIPIENT(Value: UnicodeString);
    procedure Set_SENDER(Value: UnicodeString);
    procedure Set_RECIPIENT(Value: UnicodeString);
    procedure Set_EDIINTERCHANGEID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE }

  TXMLDESADV_HEAD_PACKINGSEQUENCE = class(TXMLNode, IXMLDESADV_HEAD_PACKINGSEQUENCE)
  private
    FPOSITION: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList;
    FCERTIFICATES: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList;
  protected
    { IXMLDESADV_HEAD_PACKINGSEQUENCE }
    function Get_POSITION: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList;
    function Get_CERTIFICATES: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION }

  TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION = class(TXMLNode, IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION)
  protected
    { IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION }
    function Get_POSITIONNUMBER: Integer;
    function Get_PRODUCT: UnicodeString;
    function Get_PRODUCTIDBUYER: UnicodeString;
    function Get_PRODUCTIDSUPPLIER: UnicodeString;
    function Get_PRICEWITHVAT: UnicodeString;
    function Get_DELIVEREDUNIT: UnicodeString;
    function Get_ORDEREDQUANTITY: UnicodeString;
    function Get_AMOUNT: UnicodeString;
    function Get_DELIVEREDQUANTITY: UnicodeString;
    function Get_AMOUNTWITHVAT: UnicodeString;
    function Get_CUSTOMSTARIFFNUMBER: UnicodeString;
    function Get_PRICE: UnicodeString;
    function Get_TAXRATE: UnicodeString;
    function Get_DESCRIPTION: UnicodeString;
    function Get_MINIMUMORDERQUANTITY: UnicodeString;
    function Get_PRODUCTTYPE: UnicodeString;
    function Get_BATCHNUMBER: UnicodeString;
    procedure Set_POSITIONNUMBER(Value: Integer);
    procedure Set_PRODUCT(Value: UnicodeString);
    procedure Set_PRODUCTIDBUYER(Value: UnicodeString);
    procedure Set_PRODUCTIDSUPPLIER(Value: UnicodeString);
    procedure Set_PRICEWITHVAT(Value: UnicodeString);
    procedure Set_DELIVEREDUNIT(Value: UnicodeString);
    procedure Set_ORDEREDQUANTITY(Value: UnicodeString);
    procedure Set_AMOUNT(Value: UnicodeString);
    procedure Set_DELIVEREDQUANTITY(Value: UnicodeString);
    procedure Set_AMOUNTWITHVAT(Value: UnicodeString);
    procedure Set_CUSTOMSTARIFFNUMBER(Value: UnicodeString);
    procedure Set_PRICE(Value: UnicodeString);
    procedure Set_TAXRATE(Value: UnicodeString);
    procedure Set_DESCRIPTION(Value: UnicodeString);
    procedure Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
    procedure Set_PRODUCTTYPE(Value: UnicodeString);
    procedure Set_BATCHNUMBER(Value: UnicodeString);
  end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList }

  TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList = class(TXMLNodeCollection, IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList)
  protected
    { IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList }
    function Add: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
    function Insert(const Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;

    function Get_Item(Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
  end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES }

  TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES = class(TXMLNode, IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES)
  protected
    { IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES }
    function Get_BATCHNUMBER: UnicodeString;
    procedure Set_BATCHNUMBER(Value: UnicodeString);
  end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList }

  TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList = class(TXMLNodeCollection, IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList)
  protected
    { IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList }
    function Add: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
    function Insert(const Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;

    function Get_Item(Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
  end;

{ Global Functions }

function GetDESADV(Doc: IXMLDocument): IXMLDESADV;
function LoadDESADV(const FileName: string): IXMLDESADV;
function NewDESADV: IXMLDESADV;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDESADV(Doc: IXMLDocument): IXMLDESADV;
begin
  Result := Doc.GetDocBinding('DESADV', TXMLDESADV, TargetNamespace) as IXMLDESADV;
end;

function LoadDESADV(const FileName: string): IXMLDESADV;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('DESADV', TXMLDESADV, TargetNamespace) as IXMLDESADV;
end;

function NewDESADV: IXMLDESADV;
begin
  Result := NewXMLDocument.GetDocBinding('DESADV', TXMLDESADV, TargetNamespace) as IXMLDESADV;
end;

{ TXMLDESADV }

procedure TXMLDESADV.AfterConstruction;
begin
  RegisterChildNode('HEAD', TXMLDESADV_HEAD);
  inherited;
end;

function TXMLDESADV.Get_NUMBER: UnicodeString;
begin
  Result := ChildNodes['NUMBER'].Text;
end;

procedure TXMLDESADV.Set_NUMBER(Value: UnicodeString);
begin
  ChildNodes['NUMBER'].NodeValue := Value;
end;

function TXMLDESADV.Get_DATE: UnicodeString;
begin
  Result := ChildNodes['DATE'].Text;
end;

procedure TXMLDESADV.Set_DATE(Value: UnicodeString);
begin
  ChildNodes['DATE'].NodeValue := Value;
end;

function TXMLDESADV.Get_TIME: UnicodeString;
begin
  Result := ChildNodes['TIME'].Text;
end;

procedure TXMLDESADV.Set_TIME(Value: UnicodeString);
begin
  ChildNodes['TIME'].NodeValue := Value;
end;

function TXMLDESADV.Get_DELIVERYDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYDATE'].Text;
end;

procedure TXMLDESADV.Set_DELIVERYDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYDATE'].NodeValue := Value;
end;

function TXMLDESADV.Get_DELIVERYTIME: UnicodeString;
begin
  Result := ChildNodes['DELIVERYTIME'].Text;
end;

procedure TXMLDESADV.Set_DELIVERYTIME(Value: UnicodeString);
begin
  ChildNodes['DELIVERYTIME'].NodeValue := Value;
end;

function TXMLDESADV.Get_ORDERNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDERNUMBER'].Text;
end;

procedure TXMLDESADV.Set_ORDERNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDERNUMBER'].NodeValue := Value;
end;

function TXMLDESADV.Get_ORDERDATE: UnicodeString;
begin
  Result := ChildNodes['ORDERDATE'].Text;
end;

procedure TXMLDESADV.Set_ORDERDATE(Value: UnicodeString);
begin
  ChildNodes['ORDERDATE'].NodeValue := Value;
end;

function TXMLDESADV.Get_ORDRSPNUMBER: UnicodeString;
begin
  Result := ChildNodes['ORDRSPNUMBER'].Text;
end;

procedure TXMLDESADV.Set_ORDRSPNUMBER(Value: UnicodeString);
begin
  ChildNodes['ORDRSPNUMBER'].NodeValue := Value;
end;

function TXMLDESADV.Get_ORDRSPDATE: UnicodeString;
begin
  Result := ChildNodes['ORDRSPDATE'].Text;
end;

procedure TXMLDESADV.Set_ORDRSPDATE(Value: UnicodeString);
begin
  ChildNodes['ORDRSPDATE'].NodeValue := Value;
end;

function TXMLDESADV.Get_DELIVERYNOTENUMBER: UnicodeString;
begin
  Result := ChildNodes['DELIVERYNOTENUMBER'].Text;
end;

procedure TXMLDESADV.Set_DELIVERYNOTENUMBER(Value: UnicodeString);
begin
  ChildNodes['DELIVERYNOTENUMBER'].NodeValue := Value;
end;

function TXMLDESADV.Get_DELIVERYNOTEDATE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYNOTEDATE'].Text;
end;

procedure TXMLDESADV.Set_DELIVERYNOTEDATE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYNOTEDATE'].NodeValue := Value;
end;

function TXMLDESADV.Get_RECIPIENTCODE: UnicodeString;
begin
  Result := ChildNodes['RECIPIENTCODE'].Text;
end;

procedure TXMLDESADV.Set_RECIPIENTCODE(Value: UnicodeString);
begin
  ChildNodes['RECIPIENTCODE'].NodeValue := Value;
end;

function TXMLDESADV.Get_CURRENCY: UnicodeString;
begin
  Result := ChildNodes['CURRENCY'].Text;
end;

procedure TXMLDESADV.Set_CURRENCY(Value: UnicodeString);
begin
  ChildNodes['CURRENCY'].NodeValue := Value;
end;

function TXMLDESADV.Get_INFO: UnicodeString;
begin
  Result := ChildNodes['INFO'].Text;
end;

procedure TXMLDESADV.Set_INFO(Value: UnicodeString);
begin
  ChildNodes['INFO'].NodeValue := Value;
end;

function TXMLDESADV.Get_TAXID: UnicodeString;
begin
  Result := ChildNodes['TAXID'].Text;
end;

procedure TXMLDESADV.Set_TAXID(Value: UnicodeString);
begin
  ChildNodes['TAXID'].NodeValue := Value;
end;

function TXMLDESADV.Get_CAMPAIGNNUMBER: UnicodeString;
begin
  Result := ChildNodes['CAMPAIGNNUMBER'].Text;
end;

procedure TXMLDESADV.Set_CAMPAIGNNUMBER(Value: UnicodeString);
begin
  ChildNodes['CAMPAIGNNUMBER'].NodeValue := Value;
end;

function TXMLDESADV.Get_CAMPAIGNNUMBERDATE: UnicodeString;
begin
  Result := ChildNodes['CAMPAIGNNUMBERDATE'].Text;
end;

procedure TXMLDESADV.Set_CAMPAIGNNUMBERDATE(Value: UnicodeString);
begin
  ChildNodes['CAMPAIGNNUMBERDATE'].NodeValue := Value;
end;

function TXMLDESADV.Get_TRANSPORTQUANTITY: Integer;
begin
  Result := ChildNodes['TRANSPORTQUANTITY'].NodeValue;
end;

procedure TXMLDESADV.Set_TRANSPORTQUANTITY(Value: Integer);
begin
  ChildNodes['TRANSPORTQUANTITY'].NodeValue := Value;
end;

function TXMLDESADV.Get_TRANSPORTID: Integer;
begin
  Result := ChildNodes['TRANSPORTID'].NodeValue;
end;

procedure TXMLDESADV.Set_TRANSPORTID(Value: Integer);
begin
  ChildNodes['TRANSPORTID'].NodeValue := Value;
end;

function TXMLDESADV.Get_TRANSPORTNUMBER: UnicodeString;
begin
  Result := ChildNodes['TRANSPORTNUMBER'].Text;
end;

procedure TXMLDESADV.Set_TRANSPORTNUMBER(Value: UnicodeString);
begin
  ChildNodes['TRANSPORTNUMBER'].NodeValue := Value;
end;

function TXMLDESADV.Get_TRANSPORTERNAME: UnicodeString;
begin
  Result := ChildNodes['TRANSPORTERNAME'].Text;
end;

procedure TXMLDESADV.Set_TRANSPORTERNAME(Value: UnicodeString);
begin
  ChildNodes['TRANSPORTERNAME'].NodeValue := Value;
end;

function TXMLDESADV.Get_PACKAGEWIGHT: UnicodeString;
begin
  Result := ChildNodes['PACKAGEWIGHT'].Text;
end;

procedure TXMLDESADV.Set_PACKAGEWIGHT(Value: UnicodeString);
begin
  ChildNodes['PACKAGEWIGHT'].NodeValue := Value;
end;

function TXMLDESADV.Get_HEAD: IXMLDESADV_HEAD;
begin
  Result := ChildNodes['HEAD'] as IXMLDESADV_HEAD;
end;

{ TXMLDESADV_HEAD }

procedure TXMLDESADV_HEAD.AfterConstruction;
begin
  RegisterChildNode('PACKINGSEQUENCE', TXMLDESADV_HEAD_PACKINGSEQUENCE);
  inherited;
end;

function TXMLDESADV_HEAD.Get_SUPPLIER: UnicodeString;
begin
  Result := ChildNodes['SUPPLIER'].Text;
end;

procedure TXMLDESADV_HEAD.Set_SUPPLIER(Value: UnicodeString);
begin
  ChildNodes['SUPPLIER'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_BUYER: UnicodeString;
begin
  Result := ChildNodes['BUYER'].Text;
end;

procedure TXMLDESADV_HEAD.Set_BUYER(Value: UnicodeString);
begin
  ChildNodes['BUYER'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_BUYERCODE: UnicodeString;
begin
  Result := ChildNodes['BUYERCODE'].Text;
end;

procedure TXMLDESADV_HEAD.Set_BUYERCODE(Value: UnicodeString);
begin
  ChildNodes['BUYERCODE'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_DELIVERYPLACE: UnicodeString;
begin
  Result := ChildNodes['DELIVERYPLACE'].Text;
end;

procedure TXMLDESADV_HEAD.Set_DELIVERYPLACE(Value: UnicodeString);
begin
  ChildNodes['DELIVERYPLACE'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_FINALRECIPIENT: UnicodeString;
begin
  Result := ChildNodes['FINALRECIPIENT'].Text;
end;

procedure TXMLDESADV_HEAD.Set_FINALRECIPIENT(Value: UnicodeString);
begin
  ChildNodes['FINALRECIPIENT'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_SENDER: UnicodeString;
begin
  Result := ChildNodes['SENDER'].Text;
end;

procedure TXMLDESADV_HEAD.Set_SENDER(Value: UnicodeString);
begin
  ChildNodes['SENDER'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_RECIPIENT: UnicodeString;
begin
  Result := ChildNodes['RECIPIENT'].Text;
end;

procedure TXMLDESADV_HEAD.Set_RECIPIENT(Value: UnicodeString);
begin
  ChildNodes['RECIPIENT'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_EDIINTERCHANGEID: UnicodeString;
begin
  Result := ChildNodes['EDIINTERCHANGEID'].Text;
end;

procedure TXMLDESADV_HEAD.Set_EDIINTERCHANGEID(Value: UnicodeString);
begin
  ChildNodes['EDIINTERCHANGEID'].NodeValue := Value;
end;

function TXMLDESADV_HEAD.Get_PACKINGSEQUENCE: IXMLDESADV_HEAD_PACKINGSEQUENCE;
begin
  Result := ChildNodes['PACKINGSEQUENCE'] as IXMLDESADV_HEAD_PACKINGSEQUENCE;
end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE }

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE.AfterConstruction;
begin
  RegisterChildNode('POSITION', TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION);
  RegisterChildNode('CERTIFICATES', TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES);
  FPOSITION := CreateCollection(TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList, IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION, 'POSITION') as IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList;
  FCERTIFICATES := CreateCollection(TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList, IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES, 'CERTIFICATES') as IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList;
  inherited;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE.Get_POSITION: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList;
begin
  Result := FPOSITION;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE.Get_CERTIFICATES: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList;
begin
  Result := FCERTIFICATES;
end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION }

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_POSITIONNUMBER: Integer;
begin
  Result := ChildNodes['POSITIONNUMBER'].NodeValue;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_POSITIONNUMBER(Value: Integer);
begin
  ChildNodes['POSITIONNUMBER'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_PRODUCT: UnicodeString;
begin
  Result := ChildNodes['PRODUCT'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_PRODUCT(Value: UnicodeString);
begin
  ChildNodes['PRODUCT'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_PRODUCTIDBUYER: UnicodeString;
begin
  Result := ChildNodes['PRODUCTIDBUYER'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_PRODUCTIDBUYER(Value: UnicodeString);
begin
  ChildNodes['PRODUCTIDBUYER'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_PRODUCTIDSUPPLIER: UnicodeString;
begin
  Result := ChildNodes['PRODUCTIDSUPPLIER'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_PRODUCTIDSUPPLIER(Value: UnicodeString);
begin
  ChildNodes['PRODUCTIDSUPPLIER'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_PRICEWITHVAT: UnicodeString;
begin
  Result := ChildNodes['PRICEWITHVAT'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_PRICEWITHVAT(Value: UnicodeString);
begin
  ChildNodes['PRICEWITHVAT'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_DELIVEREDUNIT: UnicodeString;
begin
  Result := ChildNodes['DELIVEREDUNIT'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_DELIVEREDUNIT(Value: UnicodeString);
begin
  ChildNodes['DELIVEREDUNIT'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_ORDEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['ORDEREDQUANTITY'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_ORDEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['ORDEREDQUANTITY'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_AMOUNT: UnicodeString;
begin
  Result := ChildNodes['AMOUNT'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_AMOUNT(Value: UnicodeString);
begin
  ChildNodes['AMOUNT'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_DELIVEREDQUANTITY: UnicodeString;
begin
  Result := ChildNodes['DELIVEREDQUANTITY'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_DELIVEREDQUANTITY(Value: UnicodeString);
begin
  ChildNodes['DELIVEREDQUANTITY'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_AMOUNTWITHVAT: UnicodeString;
begin
  Result := ChildNodes['AMOUNTWITHVAT'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_AMOUNTWITHVAT(Value: UnicodeString);
begin
  ChildNodes['AMOUNTWITHVAT'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_CUSTOMSTARIFFNUMBER: UnicodeString;
begin
  Result := ChildNodes['CUSTOMSTARIFFNUMBER'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_CUSTOMSTARIFFNUMBER(Value: UnicodeString);
begin
  ChildNodes['CUSTOMSTARIFFNUMBER'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_PRICE: UnicodeString;
begin
  Result := ChildNodes['PRICE'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_PRICE(Value: UnicodeString);
begin
  ChildNodes['PRICE'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_TAXRATE: UnicodeString;
begin
  Result := ChildNodes['TAXRATE'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_TAXRATE(Value: UnicodeString);
begin
  ChildNodes['TAXRATE'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_DESCRIPTION: UnicodeString;
begin
  Result := ChildNodes['DESCRIPTION'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_DESCRIPTION(Value: UnicodeString);
begin
  ChildNodes['DESCRIPTION'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_MINIMUMORDERQUANTITY: UnicodeString;
begin
  Result := ChildNodes['MINIMUMORDERQUANTITY'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_MINIMUMORDERQUANTITY(Value: UnicodeString);
begin
  ChildNodes['MINIMUMORDERQUANTITY'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_PRODUCTTYPE: UnicodeString;
begin
  Result := ChildNodes['PRODUCTTYPE'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_PRODUCTTYPE(Value: UnicodeString);
begin
  ChildNodes['PRODUCTTYPE'].NodeValue := Value;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Get_BATCHNUMBER: UnicodeString;
begin
  Result := ChildNodes['BATCHNUMBER'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION.Set_BATCHNUMBER(Value: UnicodeString);
begin
  ChildNodes['BATCHNUMBER'].NodeValue := Value;
end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList }

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList.Add: IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
begin
  Result := AddItem(-1) as IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList.Insert(const Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
begin
  Result := AddItem(Index) as IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_POSITIONList.Get_Item(Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
begin
  Result := List[Index] as IXMLDESADV_HEAD_PACKINGSEQUENCE_POSITION;
end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES }

function TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES.Get_BATCHNUMBER: UnicodeString;
begin
  Result := ChildNodes['BATCHNUMBER'].Text;
end;

procedure TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES.Set_BATCHNUMBER(Value: UnicodeString);
begin
  ChildNodes['BATCHNUMBER'].NodeValue := Value;
end;

{ TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList }

function TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList.Add: IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
begin
  Result := AddItem(-1) as IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList.Insert(const Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
begin
  Result := AddItem(Index) as IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
end;

function TXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATESList.Get_Item(Index: Integer): IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
begin
  Result := List[Index] as IXMLDESADV_HEAD_PACKINGSEQUENCE_CERTIFICATES;
end;

end.