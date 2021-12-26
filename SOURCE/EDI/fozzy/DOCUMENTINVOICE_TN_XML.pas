
{**********************************************************************************}
{                                                                                  }
{                                 XML Data Binding                                 }
{                                                                                  }
{         Generated on: 23.12.2021 0:00:33                                         }
{       Generated from: D:\Project-Basis\DATABASE\DOCUMENTINVOICE_TN_example.xml   }
{   Settings stored in: D:\Project-Basis\DATABASE\DOCUMENTINVOICE_TN_example.xdb   }
{                                                                                  }
{**********************************************************************************}

unit DOCUMENTINVOICE_TN_XML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDocumentInvoiceType = interface;
  IXMLInvoiceHeaderType = interface;
  IXMLInvoiceReferenceType = interface;
  IXMLOrderType = interface;
  IXMLInvoicePartiesType = interface;
  IXMLBuyerType = interface;
  IXMLSellerType = interface;
  IXMLDeliveryPointType = interface;
  IXMLPayerType = interface;
  IXMLInvoiceLinesType = interface;
  IXMLLineType = interface;
  IXMLLineItemType = interface;
  IXMLInvoiceSummaryType = interface;

{ IXMLDocumentInvoiceType }

  IXMLDocumentInvoiceType = interface(IXMLNode)
    ['{44638F20-3FBF-4BEC-BCB5-25B1D45CE95C}']
    { Property Accessors }
    function Get_InvoiceHeader: IXMLInvoiceHeaderType;
    function Get_InvoiceReference: IXMLInvoiceReferenceType;
    function Get_InvoiceParties: IXMLInvoicePartiesType;
    function Get_InvoiceLines: IXMLInvoiceLinesType;
    function Get_InvoiceSummary: IXMLInvoiceSummaryType;
    { Methods & Properties }
    property InvoiceHeader: IXMLInvoiceHeaderType read Get_InvoiceHeader;
    property InvoiceReference: IXMLInvoiceReferenceType read Get_InvoiceReference;
    property InvoiceParties: IXMLInvoicePartiesType read Get_InvoiceParties;
    property InvoiceLines: IXMLInvoiceLinesType read Get_InvoiceLines;
    property InvoiceSummary: IXMLInvoiceSummaryType read Get_InvoiceSummary;
  end;

{ IXMLInvoiceHeaderType }

  IXMLInvoiceHeaderType = interface(IXMLNode)
    ['{C6B255CF-348B-4E2A-879B-D6143539E2C9}']
    { Property Accessors }
    function Get_InvoiceNumber: UnicodeString;
    function Get_InvoiceDate: UnicodeString;
    function Get_DocumentFunctionCode: UnicodeString;
    function Get_ContractNumber: Integer;
    function Get_ContractDate: UnicodeString;
    procedure Set_InvoiceNumber(Value: UnicodeString);
    procedure Set_InvoiceDate(Value: UnicodeString);
    procedure Set_DocumentFunctionCode(Value: UnicodeString);
    procedure Set_ContractNumber(Value: Integer);
    procedure Set_ContractDate(Value: UnicodeString);
    { Methods & Properties }
    property InvoiceNumber: UnicodeString read Get_InvoiceNumber write Set_InvoiceNumber;
    property InvoiceDate: UnicodeString read Get_InvoiceDate write Set_InvoiceDate;
    property DocumentFunctionCode: UnicodeString read Get_DocumentFunctionCode write Set_DocumentFunctionCode;
    property ContractNumber: Integer read Get_ContractNumber write Set_ContractNumber;
    property ContractDate: UnicodeString read Get_ContractDate write Set_ContractDate;
  end;

{ IXMLInvoiceReferenceType }

  IXMLInvoiceReferenceType = interface(IXMLNode)
    ['{F74B86BE-2C50-433F-982E-CBDD61373574}']
    { Property Accessors }
    function Get_Order: IXMLOrderType;
    { Methods & Properties }
    property Order: IXMLOrderType read Get_Order;
  end;

{ IXMLOrderType }

  IXMLOrderType = interface(IXMLNode)
    ['{429F6664-9A68-42A2-9912-9465B535A6BE}']
    { Property Accessors }
    function Get_BuyerOrderNumber: UnicodeString;
    function Get_BuyerOrderDate: UnicodeString;
    procedure Set_BuyerOrderNumber(Value: UnicodeString);
    procedure Set_BuyerOrderDate(Value: UnicodeString);
    { Methods & Properties }
    property BuyerOrderNumber: UnicodeString read Get_BuyerOrderNumber write Set_BuyerOrderNumber;
    property BuyerOrderDate: UnicodeString read Get_BuyerOrderDate write Set_BuyerOrderDate;
  end;

{ IXMLInvoicePartiesType }

  IXMLInvoicePartiesType = interface(IXMLNode)
    ['{57E22FCA-1A83-478C-B23D-610FDDBDD9C9}']
    { Property Accessors }
    function Get_Buyer: IXMLBuyerType;
    function Get_Seller: IXMLSellerType;
    function Get_DeliveryPoint: IXMLDeliveryPointType;
    function Get_Payer: IXMLPayerType;
    { Methods & Properties }
    property Buyer: IXMLBuyerType read Get_Buyer;
    property Seller: IXMLSellerType read Get_Seller;
    property DeliveryPoint: IXMLDeliveryPointType read Get_DeliveryPoint;
    property Payer: IXMLPayerType read Get_Payer;
  end;

{ IXMLBuyerType }

  IXMLBuyerType = interface(IXMLNode)
    ['{DCACA9DF-A513-4330-92BF-379EDCFD6044}']
    { Property Accessors }
    function Get_ILN: Integer;
    function Get_TaxID: Integer;
    function Get_UtilizationRegisterNumber: Integer;
    function Get_Name: UnicodeString;
    procedure Set_ILN(Value: Integer);
    procedure Set_TaxID(Value: Integer);
    procedure Set_UtilizationRegisterNumber(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property ILN: Integer read Get_ILN write Set_ILN;
    property TaxID: Integer read Get_TaxID write Set_TaxID;
    property UtilizationRegisterNumber: Integer read Get_UtilizationRegisterNumber write Set_UtilizationRegisterNumber;
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ IXMLSellerType }

  IXMLSellerType = interface(IXMLNode)
    ['{23552CB6-6895-4C8A-B9D4-A4756631A499}']
    { Property Accessors }
    function Get_ILN: Integer;
    function Get_TaxID: Integer;
    function Get_UtilizationRegisterNumber: Integer;
    function Get_Name: UnicodeString;
    procedure Set_ILN(Value: Integer);
    procedure Set_TaxID(Value: Integer);
    procedure Set_UtilizationRegisterNumber(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property ILN: Integer read Get_ILN write Set_ILN;
    property TaxID: Integer read Get_TaxID write Set_TaxID;
    property UtilizationRegisterNumber: Integer read Get_UtilizationRegisterNumber write Set_UtilizationRegisterNumber;
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ IXMLDeliveryPointType }

  IXMLDeliveryPointType = interface(IXMLNode)
    ['{4C05374C-9DDD-4A86-AD7F-DDEF35DD5453}']
    { Property Accessors }
    function Get_ILN: Integer;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: Integer;
    procedure Set_ILN(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: Integer);
    { Methods & Properties }
    property ILN: Integer read Get_ILN write Set_ILN;
    property Name: UnicodeString read Get_Name write Set_Name;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property StreetAndNumber: UnicodeString read Get_StreetAndNumber write Set_StreetAndNumber;
    property PostalCode: Integer read Get_PostalCode write Set_PostalCode;
  end;

{ IXMLPayerType }

  IXMLPayerType = interface(IXMLNode)
    ['{7F5DBEED-FECE-4F10-9DAB-EA43C291707E}']
    { Property Accessors }
    function Get_ILN: Integer;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: Integer;
    procedure Set_ILN(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: Integer);
    { Methods & Properties }
    property ILN: Integer read Get_ILN write Set_ILN;
    property Name: UnicodeString read Get_Name write Set_Name;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property StreetAndNumber: UnicodeString read Get_StreetAndNumber write Set_StreetAndNumber;
    property PostalCode: Integer read Get_PostalCode write Set_PostalCode;
  end;

{ IXMLInvoiceLinesType }

  IXMLInvoiceLinesType = interface(IXMLNodeCollection)
    ['{EA231902-3D86-4FA4-A6D9-285F770CD71A}']
    { Property Accessors }
    function Get_Line(Index: Integer): IXMLLineType;
    { Methods & Properties }
    function Add: IXMLLineType;
    function Insert(const Index: Integer): IXMLLineType;
    property Line[Index: Integer]: IXMLLineType read Get_Line; default;
  end;

{ IXMLLineType }

  IXMLLineType = interface(IXMLNode)
    ['{05460BCB-6661-4D15-8802-3512E2538CD6}']
    { Property Accessors }
    function Get_LineItem: IXMLLineItemType;
    { Methods & Properties }
    property LineItem: IXMLLineItemType read Get_LineItem;
  end;

{ IXMLLineItemType }

  IXMLLineItemType = interface(IXMLNode)
    ['{76F1AEB2-D13E-42FF-9287-1457CDE24BBB}']
    { Property Accessors }
    function Get_LineNumber: Integer;
    function Get_EAN: Integer;
    function Get_BuyerItemCode: Integer;
    function Get_ExternalItemCode: Integer;
    function Get_ItemDescription: UnicodeString;
    function Get_InvoiceQuantity: Integer;
    function Get_BuyerUnitOfMeasure: UnicodeString;
    function Get_InvoiceUnitNetPrice: UnicodeString;
    function Get_TaxRate: Integer;
    function Get_GrossAmount: UnicodeString;
    function Get_TaxAmount: UnicodeString;
    function Get_NetAmount: UnicodeString;
    procedure Set_LineNumber(Value: Integer);
    procedure Set_EAN(Value: Integer);
    procedure Set_BuyerItemCode(Value: Integer);
    procedure Set_ExternalItemCode(Value: Integer);
    procedure Set_ItemDescription(Value: UnicodeString);
    procedure Set_InvoiceQuantity(Value: Integer);
    procedure Set_BuyerUnitOfMeasure(Value: UnicodeString);
    procedure Set_InvoiceUnitNetPrice(Value: UnicodeString);
    procedure Set_TaxRate(Value: Integer);
    procedure Set_GrossAmount(Value: UnicodeString);
    procedure Set_TaxAmount(Value: UnicodeString);
    procedure Set_NetAmount(Value: UnicodeString);
    { Methods & Properties }
    property LineNumber: Integer read Get_LineNumber write Set_LineNumber;
    property EAN: Integer read Get_EAN write Set_EAN;
    property BuyerItemCode: Integer read Get_BuyerItemCode write Set_BuyerItemCode;
    property ExternalItemCode: Integer read Get_ExternalItemCode write Set_ExternalItemCode;
    property ItemDescription: UnicodeString read Get_ItemDescription write Set_ItemDescription;
    property InvoiceQuantity: Integer read Get_InvoiceQuantity write Set_InvoiceQuantity;
    property BuyerUnitOfMeasure: UnicodeString read Get_BuyerUnitOfMeasure write Set_BuyerUnitOfMeasure;
    property InvoiceUnitNetPrice: UnicodeString read Get_InvoiceUnitNetPrice write Set_InvoiceUnitNetPrice;
    property TaxRate: Integer read Get_TaxRate write Set_TaxRate;
    property GrossAmount: UnicodeString read Get_GrossAmount write Set_GrossAmount;
    property TaxAmount: UnicodeString read Get_TaxAmount write Set_TaxAmount;
    property NetAmount: UnicodeString read Get_NetAmount write Set_NetAmount;
  end;

{ IXMLInvoiceSummaryType }

  IXMLInvoiceSummaryType = interface(IXMLNode)
    ['{CAE848BC-B216-491B-B98B-CD769FBBED06}']
    { Property Accessors }
    function Get_TotalLines: Integer;
    function Get_TotalNetAmount: UnicodeString;
    function Get_TotalTaxAmount: UnicodeString;
    function Get_TotalGrossAmount: UnicodeString;
    procedure Set_TotalLines(Value: Integer);
    procedure Set_TotalNetAmount(Value: UnicodeString);
    procedure Set_TotalTaxAmount(Value: UnicodeString);
    procedure Set_TotalGrossAmount(Value: UnicodeString);
    { Methods & Properties }
    property TotalLines: Integer read Get_TotalLines write Set_TotalLines;
    property TotalNetAmount: UnicodeString read Get_TotalNetAmount write Set_TotalNetAmount;
    property TotalTaxAmount: UnicodeString read Get_TotalTaxAmount write Set_TotalTaxAmount;
    property TotalGrossAmount: UnicodeString read Get_TotalGrossAmount write Set_TotalGrossAmount;
  end;

{ Forward Decls }

  TXMLDocumentInvoiceType = class;
  TXMLInvoiceHeaderType = class;
  TXMLInvoiceReferenceType = class;
  TXMLOrderType = class;
  TXMLInvoicePartiesType = class;
  TXMLBuyerType = class;
  TXMLSellerType = class;
  TXMLDeliveryPointType = class;
  TXMLPayerType = class;
  TXMLInvoiceLinesType = class;
  TXMLLineType = class;
  TXMLLineItemType = class;
  TXMLInvoiceSummaryType = class;

{ TXMLDocumentInvoiceType }

  TXMLDocumentInvoiceType = class(TXMLNode, IXMLDocumentInvoiceType)
  protected
    { IXMLDocumentInvoiceType }
    function Get_InvoiceHeader: IXMLInvoiceHeaderType;
    function Get_InvoiceReference: IXMLInvoiceReferenceType;
    function Get_InvoiceParties: IXMLInvoicePartiesType;
    function Get_InvoiceLines: IXMLInvoiceLinesType;
    function Get_InvoiceSummary: IXMLInvoiceSummaryType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLInvoiceHeaderType }

  TXMLInvoiceHeaderType = class(TXMLNode, IXMLInvoiceHeaderType)
  protected
    { IXMLInvoiceHeaderType }
    function Get_InvoiceNumber: UnicodeString;
    function Get_InvoiceDate: UnicodeString;
    function Get_DocumentFunctionCode: UnicodeString;
    function Get_ContractNumber: Integer;
    function Get_ContractDate: UnicodeString;
    procedure Set_InvoiceNumber(Value: UnicodeString);
    procedure Set_InvoiceDate(Value: UnicodeString);
    procedure Set_DocumentFunctionCode(Value: UnicodeString);
    procedure Set_ContractNumber(Value: Integer);
    procedure Set_ContractDate(Value: UnicodeString);
  end;

{ TXMLInvoiceReferenceType }

  TXMLInvoiceReferenceType = class(TXMLNode, IXMLInvoiceReferenceType)
  protected
    { IXMLInvoiceReferenceType }
    function Get_Order: IXMLOrderType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOrderType }

  TXMLOrderType = class(TXMLNode, IXMLOrderType)
  protected
    { IXMLOrderType }
    function Get_BuyerOrderNumber: UnicodeString;
    function Get_BuyerOrderDate: UnicodeString;
    procedure Set_BuyerOrderNumber(Value: UnicodeString);
    procedure Set_BuyerOrderDate(Value: UnicodeString);
  end;

{ TXMLInvoicePartiesType }

  TXMLInvoicePartiesType = class(TXMLNode, IXMLInvoicePartiesType)
  protected
    { IXMLInvoicePartiesType }
    function Get_Buyer: IXMLBuyerType;
    function Get_Seller: IXMLSellerType;
    function Get_DeliveryPoint: IXMLDeliveryPointType;
    function Get_Payer: IXMLPayerType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBuyerType }

  TXMLBuyerType = class(TXMLNode, IXMLBuyerType)
  protected
    { IXMLBuyerType }
    function Get_ILN: Integer;
    function Get_TaxID: Integer;
    function Get_UtilizationRegisterNumber: Integer;
    function Get_Name: UnicodeString;
    procedure Set_ILN(Value: Integer);
    procedure Set_TaxID(Value: Integer);
    procedure Set_UtilizationRegisterNumber(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
  end;

{ TXMLSellerType }

  TXMLSellerType = class(TXMLNode, IXMLSellerType)
  protected
    { IXMLSellerType }
    function Get_ILN: Integer;
    function Get_TaxID: Integer;
    function Get_UtilizationRegisterNumber: Integer;
    function Get_Name: UnicodeString;
    procedure Set_ILN(Value: Integer);
    procedure Set_TaxID(Value: Integer);
    procedure Set_UtilizationRegisterNumber(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
  end;

{ TXMLDeliveryPointType }

  TXMLDeliveryPointType = class(TXMLNode, IXMLDeliveryPointType)
  protected
    { IXMLDeliveryPointType }
    function Get_ILN: Integer;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: Integer;
    procedure Set_ILN(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: Integer);
  end;

{ TXMLPayerType }

  TXMLPayerType = class(TXMLNode, IXMLPayerType)
  protected
    { IXMLPayerType }
    function Get_ILN: Integer;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: Integer;
    procedure Set_ILN(Value: Integer);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: Integer);
  end;

{ TXMLInvoiceLinesType }

  TXMLInvoiceLinesType = class(TXMLNodeCollection, IXMLInvoiceLinesType)
  protected
    { IXMLInvoiceLinesType }
    function Get_Line(Index: Integer): IXMLLineType;
    function Add: IXMLLineType;
    function Insert(const Index: Integer): IXMLLineType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineType }

  TXMLLineType = class(TXMLNode, IXMLLineType)
  protected
    { IXMLLineType }
    function Get_LineItem: IXMLLineItemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineItemType }

  TXMLLineItemType = class(TXMLNode, IXMLLineItemType)
  protected
    { IXMLLineItemType }
    function Get_LineNumber: Integer;
    function Get_EAN: Integer;
    function Get_BuyerItemCode: Integer;
    function Get_ExternalItemCode: Integer;
    function Get_ItemDescription: UnicodeString;
    function Get_InvoiceQuantity: Integer;
    function Get_BuyerUnitOfMeasure: UnicodeString;
    function Get_InvoiceUnitNetPrice: UnicodeString;
    function Get_TaxRate: Integer;
    function Get_GrossAmount: UnicodeString;
    function Get_TaxAmount: UnicodeString;
    function Get_NetAmount: UnicodeString;
    procedure Set_LineNumber(Value: Integer);
    procedure Set_EAN(Value: Integer);
    procedure Set_BuyerItemCode(Value: Integer);
    procedure Set_ExternalItemCode(Value: Integer);
    procedure Set_ItemDescription(Value: UnicodeString);
    procedure Set_InvoiceQuantity(Value: Integer);
    procedure Set_BuyerUnitOfMeasure(Value: UnicodeString);
    procedure Set_InvoiceUnitNetPrice(Value: UnicodeString);
    procedure Set_TaxRate(Value: Integer);
    procedure Set_GrossAmount(Value: UnicodeString);
    procedure Set_TaxAmount(Value: UnicodeString);
    procedure Set_NetAmount(Value: UnicodeString);
  end;

{ TXMLInvoiceSummaryType }

  TXMLInvoiceSummaryType = class(TXMLNode, IXMLInvoiceSummaryType)
  protected
    { IXMLInvoiceSummaryType }
    function Get_TotalLines: Integer;
    function Get_TotalNetAmount: UnicodeString;
    function Get_TotalTaxAmount: UnicodeString;
    function Get_TotalGrossAmount: UnicodeString;
    procedure Set_TotalLines(Value: Integer);
    procedure Set_TotalNetAmount(Value: UnicodeString);
    procedure Set_TotalTaxAmount(Value: UnicodeString);
    procedure Set_TotalGrossAmount(Value: UnicodeString);
  end;

{ Global Functions }

function GetDocumentInvoice(Doc: IXMLDocument): IXMLDocumentInvoiceType;
function LoadDocumentInvoice(const FileName: string): IXMLDocumentInvoiceType;
function NewDocumentInvoice: IXMLDocumentInvoiceType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetDocumentInvoice(Doc: IXMLDocument): IXMLDocumentInvoiceType;
begin
  Result := Doc.GetDocBinding('Document-Invoice', TXMLDocumentInvoiceType, TargetNamespace) as IXMLDocumentInvoiceType;
end;

function LoadDocumentInvoice(const FileName: string): IXMLDocumentInvoiceType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Document-Invoice', TXMLDocumentInvoiceType, TargetNamespace) as IXMLDocumentInvoiceType;
end;

function NewDocumentInvoice: IXMLDocumentInvoiceType;
begin
  Result := NewXMLDocument.GetDocBinding('Document-Invoice', TXMLDocumentInvoiceType, TargetNamespace) as IXMLDocumentInvoiceType;
end;

{ TXMLDocumentInvoiceType }

procedure TXMLDocumentInvoiceType.AfterConstruction;
begin
  RegisterChildNode('Invoice-Header', TXMLInvoiceHeaderType);
  RegisterChildNode('Invoice-Reference', TXMLInvoiceReferenceType);
  RegisterChildNode('Invoice-Parties', TXMLInvoicePartiesType);
  RegisterChildNode('Invoice-Lines', TXMLInvoiceLinesType);
  RegisterChildNode('Invoice-Summary', TXMLInvoiceSummaryType);
  inherited;
end;

function TXMLDocumentInvoiceType.Get_InvoiceHeader: IXMLInvoiceHeaderType;
begin
  Result := ChildNodes['Invoice-Header'] as IXMLInvoiceHeaderType;
end;

function TXMLDocumentInvoiceType.Get_InvoiceReference: IXMLInvoiceReferenceType;
begin
  Result := ChildNodes['Invoice-Reference'] as IXMLInvoiceReferenceType;
end;

function TXMLDocumentInvoiceType.Get_InvoiceParties: IXMLInvoicePartiesType;
begin
  Result := ChildNodes['Invoice-Parties'] as IXMLInvoicePartiesType;
end;

function TXMLDocumentInvoiceType.Get_InvoiceLines: IXMLInvoiceLinesType;
begin
  Result := ChildNodes['Invoice-Lines'] as IXMLInvoiceLinesType;
end;

function TXMLDocumentInvoiceType.Get_InvoiceSummary: IXMLInvoiceSummaryType;
begin
  Result := ChildNodes['Invoice-Summary'] as IXMLInvoiceSummaryType;
end;

{ TXMLInvoiceHeaderType }

function TXMLInvoiceHeaderType.Get_InvoiceNumber: UnicodeString;
begin
  Result := ChildNodes['InvoiceNumber'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_InvoiceNumber(Value: UnicodeString);
begin
  ChildNodes['InvoiceNumber'].NodeValue := Value;
end;

function TXMLInvoiceHeaderType.Get_InvoiceDate: UnicodeString;
begin
  Result := ChildNodes['InvoiceDate'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_InvoiceDate(Value: UnicodeString);
begin
  ChildNodes['InvoiceDate'].NodeValue := Value;
end;

function TXMLInvoiceHeaderType.Get_DocumentFunctionCode: UnicodeString;
begin
  Result := ChildNodes['DocumentFunctionCode'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_DocumentFunctionCode(Value: UnicodeString);
begin
  ChildNodes['DocumentFunctionCode'].NodeValue := Value;
end;

function TXMLInvoiceHeaderType.Get_ContractNumber: Integer;
begin
  Result := ChildNodes['ContractNumber'].NodeValue;
end;

procedure TXMLInvoiceHeaderType.Set_ContractNumber(Value: Integer);
begin
  ChildNodes['ContractNumber'].NodeValue := Value;
end;

function TXMLInvoiceHeaderType.Get_ContractDate: UnicodeString;
begin
  Result := ChildNodes['ContractDate'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_ContractDate(Value: UnicodeString);
begin
  ChildNodes['ContractDate'].NodeValue := Value;
end;

{ TXMLInvoiceReferenceType }

procedure TXMLInvoiceReferenceType.AfterConstruction;
begin
  RegisterChildNode('Order', TXMLOrderType);
  inherited;
end;

function TXMLInvoiceReferenceType.Get_Order: IXMLOrderType;
begin
  Result := ChildNodes['Order'] as IXMLOrderType;
end;

{ TXMLOrderType }

function TXMLOrderType.Get_BuyerOrderNumber: UnicodeString;
begin
  Result := ChildNodes['BuyerOrderNumber'].Text;
end;

procedure TXMLOrderType.Set_BuyerOrderNumber(Value: UnicodeString);
begin
  ChildNodes['BuyerOrderNumber'].NodeValue := Value;
end;

function TXMLOrderType.Get_BuyerOrderDate: UnicodeString;
begin
  Result := ChildNodes['BuyerOrderDate'].Text;
end;

procedure TXMLOrderType.Set_BuyerOrderDate(Value: UnicodeString);
begin
  ChildNodes['BuyerOrderDate'].NodeValue := Value;
end;

{ TXMLInvoicePartiesType }

procedure TXMLInvoicePartiesType.AfterConstruction;
begin
  RegisterChildNode('Buyer', TXMLBuyerType);
  RegisterChildNode('Seller', TXMLSellerType);
  RegisterChildNode('DeliveryPoint', TXMLDeliveryPointType);
  RegisterChildNode('Payer', TXMLPayerType);
  inherited;
end;

function TXMLInvoicePartiesType.Get_Buyer: IXMLBuyerType;
begin
  Result := ChildNodes['Buyer'] as IXMLBuyerType;
end;

function TXMLInvoicePartiesType.Get_Seller: IXMLSellerType;
begin
  Result := ChildNodes['Seller'] as IXMLSellerType;
end;

function TXMLInvoicePartiesType.Get_DeliveryPoint: IXMLDeliveryPointType;
begin
  Result := ChildNodes['DeliveryPoint'] as IXMLDeliveryPointType;
end;

function TXMLInvoicePartiesType.Get_Payer: IXMLPayerType;
begin
  Result := ChildNodes['Payer'] as IXMLPayerType;
end;

{ TXMLBuyerType }

function TXMLBuyerType.Get_ILN: Integer;
begin
  Result := ChildNodes['ILN'].NodeValue;
end;

procedure TXMLBuyerType.Set_ILN(Value: Integer);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLBuyerType.Get_TaxID: Integer;
begin
  Result := ChildNodes['TaxID'].NodeValue;
end;

procedure TXMLBuyerType.Set_TaxID(Value: Integer);
begin
  ChildNodes['TaxID'].NodeValue := Value;
end;

function TXMLBuyerType.Get_UtilizationRegisterNumber: Integer;
begin
  Result := ChildNodes['UtilizationRegisterNumber'].NodeValue;
end;

procedure TXMLBuyerType.Set_UtilizationRegisterNumber(Value: Integer);
begin
  ChildNodes['UtilizationRegisterNumber'].NodeValue := Value;
end;

function TXMLBuyerType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLBuyerType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

{ TXMLSellerType }

function TXMLSellerType.Get_ILN: Integer;
begin
  Result := ChildNodes['ILN'].NodeValue;
end;

procedure TXMLSellerType.Set_ILN(Value: Integer);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLSellerType.Get_TaxID: Integer;
begin
  Result := ChildNodes['TaxID'].NodeValue;
end;

procedure TXMLSellerType.Set_TaxID(Value: Integer);
begin
  ChildNodes['TaxID'].NodeValue := Value;
end;

function TXMLSellerType.Get_UtilizationRegisterNumber: Integer;
begin
  Result := ChildNodes['UtilizationRegisterNumber'].NodeValue;
end;

procedure TXMLSellerType.Set_UtilizationRegisterNumber(Value: Integer);
begin
  ChildNodes['UtilizationRegisterNumber'].NodeValue := Value;
end;

function TXMLSellerType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLSellerType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

{ TXMLDeliveryPointType }

function TXMLDeliveryPointType.Get_ILN: Integer;
begin
  Result := ChildNodes['ILN'].NodeValue;
end;

procedure TXMLDeliveryPointType.Set_ILN(Value: Integer);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLDeliveryPointType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLDeliveryPointType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLDeliveryPointType.Get_CityName: UnicodeString;
begin
  Result := ChildNodes['CityName'].Text;
end;

procedure TXMLDeliveryPointType.Set_CityName(Value: UnicodeString);
begin
  ChildNodes['CityName'].NodeValue := Value;
end;

function TXMLDeliveryPointType.Get_StreetAndNumber: UnicodeString;
begin
  Result := ChildNodes['StreetAndNumber'].Text;
end;

procedure TXMLDeliveryPointType.Set_StreetAndNumber(Value: UnicodeString);
begin
  ChildNodes['StreetAndNumber'].NodeValue := Value;
end;

function TXMLDeliveryPointType.Get_PostalCode: Integer;
begin
  Result := ChildNodes['PostalCode'].NodeValue;
end;

procedure TXMLDeliveryPointType.Set_PostalCode(Value: Integer);
begin
  ChildNodes['PostalCode'].NodeValue := Value;
end;

{ TXMLPayerType }

function TXMLPayerType.Get_ILN: Integer;
begin
  Result := ChildNodes['ILN'].NodeValue;
end;

procedure TXMLPayerType.Set_ILN(Value: Integer);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLPayerType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['Name'].Text;
end;

procedure TXMLPayerType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['Name'].NodeValue := Value;
end;

function TXMLPayerType.Get_CityName: UnicodeString;
begin
  Result := ChildNodes['CityName'].Text;
end;

procedure TXMLPayerType.Set_CityName(Value: UnicodeString);
begin
  ChildNodes['CityName'].NodeValue := Value;
end;

function TXMLPayerType.Get_StreetAndNumber: UnicodeString;
begin
  Result := ChildNodes['StreetAndNumber'].Text;
end;

procedure TXMLPayerType.Set_StreetAndNumber(Value: UnicodeString);
begin
  ChildNodes['StreetAndNumber'].NodeValue := Value;
end;

function TXMLPayerType.Get_PostalCode: Integer;
begin
  Result := ChildNodes['PostalCode'].NodeValue;
end;

procedure TXMLPayerType.Set_PostalCode(Value: Integer);
begin
  ChildNodes['PostalCode'].NodeValue := Value;
end;

{ TXMLInvoiceLinesType }

procedure TXMLInvoiceLinesType.AfterConstruction;
begin
  RegisterChildNode('Line', TXMLLineType);
  ItemTag := 'Line';
  ItemInterface := IXMLLineType;
  inherited;
end;

function TXMLInvoiceLinesType.Get_Line(Index: Integer): IXMLLineType;
begin
  Result := List[Index] as IXMLLineType;
end;

function TXMLInvoiceLinesType.Add: IXMLLineType;
begin
  Result := AddItem(-1) as IXMLLineType;
end;

function TXMLInvoiceLinesType.Insert(const Index: Integer): IXMLLineType;
begin
  Result := AddItem(Index) as IXMLLineType;
end;

{ TXMLLineType }

procedure TXMLLineType.AfterConstruction;
begin
  RegisterChildNode('Line-Item', TXMLLineItemType);
  inherited;
end;

function TXMLLineType.Get_LineItem: IXMLLineItemType;
begin
  Result := ChildNodes['Line-Item'] as IXMLLineItemType;
end;

{ TXMLLineItemType }

function TXMLLineItemType.Get_LineNumber: Integer;
begin
  Result := ChildNodes['LineNumber'].NodeValue;
end;

procedure TXMLLineItemType.Set_LineNumber(Value: Integer);
begin
  ChildNodes['LineNumber'].NodeValue := Value;
end;

function TXMLLineItemType.Get_EAN: Integer;
begin
  Result := ChildNodes['EAN'].NodeValue;
end;

procedure TXMLLineItemType.Set_EAN(Value: Integer);
begin
  ChildNodes['EAN'].NodeValue := Value;
end;

function TXMLLineItemType.Get_BuyerItemCode: Integer;
begin
  Result := ChildNodes['BuyerItemCode'].NodeValue;
end;

procedure TXMLLineItemType.Set_BuyerItemCode(Value: Integer);
begin
  ChildNodes['BuyerItemCode'].NodeValue := Value;
end;

function TXMLLineItemType.Get_ExternalItemCode: Integer;
begin
  Result := ChildNodes['ExternalItemCode'].NodeValue;
end;

procedure TXMLLineItemType.Set_ExternalItemCode(Value: Integer);
begin
  ChildNodes['ExternalItemCode'].NodeValue := Value;
end;

function TXMLLineItemType.Get_ItemDescription: UnicodeString;
begin
  Result := ChildNodes['ItemDescription'].Text;
end;

procedure TXMLLineItemType.Set_ItemDescription(Value: UnicodeString);
begin
  ChildNodes['ItemDescription'].NodeValue := Value;
end;

function TXMLLineItemType.Get_InvoiceQuantity: Integer;
begin
  Result := ChildNodes['InvoiceQuantity'].NodeValue;
end;

procedure TXMLLineItemType.Set_InvoiceQuantity(Value: Integer);
begin
  ChildNodes['InvoiceQuantity'].NodeValue := Value;
end;

function TXMLLineItemType.Get_BuyerUnitOfMeasure: UnicodeString;
begin
  Result := ChildNodes['BuyerUnitOfMeasure'].Text;
end;

procedure TXMLLineItemType.Set_BuyerUnitOfMeasure(Value: UnicodeString);
begin
  ChildNodes['BuyerUnitOfMeasure'].NodeValue := Value;
end;

function TXMLLineItemType.Get_InvoiceUnitNetPrice: UnicodeString;
begin
  Result := ChildNodes['InvoiceUnitNetPrice'].Text;
end;

procedure TXMLLineItemType.Set_InvoiceUnitNetPrice(Value: UnicodeString);
begin
  ChildNodes['InvoiceUnitNetPrice'].NodeValue := Value;
end;

function TXMLLineItemType.Get_TaxRate: Integer;
begin
  Result := ChildNodes['TaxRate'].NodeValue;
end;

procedure TXMLLineItemType.Set_TaxRate(Value: Integer);
begin
  ChildNodes['TaxRate'].NodeValue := Value;
end;

function TXMLLineItemType.Get_GrossAmount: UnicodeString;
begin
  Result := ChildNodes['GrossAmount'].Text;
end;

procedure TXMLLineItemType.Set_GrossAmount(Value: UnicodeString);
begin
  ChildNodes['GrossAmount'].NodeValue := Value;
end;

function TXMLLineItemType.Get_TaxAmount: UnicodeString;
begin
  Result := ChildNodes['TaxAmount'].Text;
end;

procedure TXMLLineItemType.Set_TaxAmount(Value: UnicodeString);
begin
  ChildNodes['TaxAmount'].NodeValue := Value;
end;

function TXMLLineItemType.Get_NetAmount: UnicodeString;
begin
  Result := ChildNodes['NetAmount'].Text;
end;

procedure TXMLLineItemType.Set_NetAmount(Value: UnicodeString);
begin
  ChildNodes['NetAmount'].NodeValue := Value;
end;

{ TXMLInvoiceSummaryType }

function TXMLInvoiceSummaryType.Get_TotalLines: Integer;
begin
  Result := ChildNodes['TotalLines'].NodeValue;
end;

procedure TXMLInvoiceSummaryType.Set_TotalLines(Value: Integer);
begin
  ChildNodes['TotalLines'].NodeValue := Value;
end;

function TXMLInvoiceSummaryType.Get_TotalNetAmount: UnicodeString;
begin
  Result := ChildNodes['TotalNetAmount'].Text;
end;

procedure TXMLInvoiceSummaryType.Set_TotalNetAmount(Value: UnicodeString);
begin
  ChildNodes['TotalNetAmount'].NodeValue := Value;
end;

function TXMLInvoiceSummaryType.Get_TotalTaxAmount: UnicodeString;
begin
  Result := ChildNodes['TotalTaxAmount'].Text;
end;

procedure TXMLInvoiceSummaryType.Set_TotalTaxAmount(Value: UnicodeString);
begin
  ChildNodes['TotalTaxAmount'].NodeValue := Value;
end;

function TXMLInvoiceSummaryType.Get_TotalGrossAmount: UnicodeString;
begin
  Result := ChildNodes['TotalGrossAmount'].Text;
end;

procedure TXMLInvoiceSummaryType.Set_TotalGrossAmount(Value: UnicodeString);
begin
  ChildNodes['TotalGrossAmount'].NodeValue := Value;
end;

end.