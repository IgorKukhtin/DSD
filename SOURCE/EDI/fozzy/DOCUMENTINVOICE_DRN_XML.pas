
{*****************************************************************************}
{                                                                             }
{                              XML Data Binding                               }
{                                                                             }
{         Generated on: 09.01.2024 18:07:20                                   }
{       Generated from: C:\Users\Oleg\Downloads\DOCUMENTINVOICE_example.xml   }
{   Settings stored in: C:\Users\Oleg\Downloads\DOCUMENTINVOICE_example.xdb   }
{                                                                             }
{*****************************************************************************}

unit DOCUMENTINVOICE_DRN_XML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDocumentInvoiceType = interface;
  IXMLInvoiceHeaderType = interface;
  IXMLInvoiceReferenceType = interface;
  IXMLOrderType = interface;
  IXMLTaxInvoiceType = interface;
  IXMLInvoicePartiesType = interface;
  IXMLBuyerType = interface;
  IXMLSellerType = interface;
  IXMLDeliveryPointType = interface;
  IXMLInvoiceLinesType = interface;
  IXMLLineType = interface;
  IXMLLineItemType = interface;
  IXMLInvoiceSummaryType = interface;

{ IXMLDocumentInvoiceType }

  IXMLDocumentInvoiceType = interface(IXMLNode)
    ['{F460D15B-1472-4388-BE31-3DC91F0AEF9D}']
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
    ['{EF9DB67D-3B5A-4346-BEB7-BF7AF674FDDC}']
    { Property Accessors }
    function Get_InvoiceNumber: UnicodeString;
    function Get_InvoiceDate: UnicodeString;
    function Get_DocumentFunctionCode: UnicodeString;
    function Get_ContractNumber: UnicodeString;
    function Get_ContractDate: UnicodeString;
    procedure Set_InvoiceNumber(Value: UnicodeString);
    procedure Set_InvoiceDate(Value: UnicodeString);
    procedure Set_DocumentFunctionCode(Value: UnicodeString);
    procedure Set_ContractNumber(Value: UnicodeString);
    procedure Set_ContractDate(Value: UnicodeString);
    { Methods & Properties }
    property InvoiceNumber: UnicodeString read Get_InvoiceNumber write Set_InvoiceNumber;
    property InvoiceDate: UnicodeString read Get_InvoiceDate write Set_InvoiceDate;
    property DocumentFunctionCode: UnicodeString read Get_DocumentFunctionCode write Set_DocumentFunctionCode;
    property ContractNumber: UnicodeString read Get_ContractNumber write Set_ContractNumber;
    property ContractDate: UnicodeString read Get_ContractDate write Set_ContractDate;
  end;

{ IXMLInvoiceReferenceType }

  IXMLInvoiceReferenceType = interface(IXMLNode)
    ['{5055A27A-32AF-469F-AFA6-C803945419FD}']
    { Property Accessors }
    function Get_Order: IXMLOrderType;
    function Get_TaxInvoice: IXMLTaxInvoiceType;
    { Methods & Properties }
    property Order: IXMLOrderType read Get_Order;
    property TaxInvoice: IXMLTaxInvoiceType read Get_TaxInvoice;
  end;

{ IXMLOrderType }

  IXMLOrderType = interface(IXMLNode)
    ['{82C6EADD-3EF0-44BE-B615-B835CF5F5311}']
    { Property Accessors }
    function Get_BuyerOrderNumber: UnicodeString;
    function Get_BuyerOrderDate: UnicodeString;
    procedure Set_BuyerOrderNumber(Value: UnicodeString);
    procedure Set_BuyerOrderDate(Value: UnicodeString);
    { Methods & Properties }
    property BuyerOrderNumber: UnicodeString read Get_BuyerOrderNumber write Set_BuyerOrderNumber;
    property BuyerOrderDate: UnicodeString read Get_BuyerOrderDate write Set_BuyerOrderDate;
  end;

{ IXMLTaxInvoiceType }

  IXMLTaxInvoiceType = interface(IXMLNode)
    ['{88D22723-87C3-4BC2-B2AA-177169F5162A}']
    { Property Accessors }
    function Get_TaxInvoiceDate: UnicodeString;
    procedure Set_TaxInvoiceDate(Value: UnicodeString);
    { Methods & Properties }
    property TaxInvoiceDate: UnicodeString read Get_TaxInvoiceDate write Set_TaxInvoiceDate;
  end;

{ IXMLInvoicePartiesType }

  IXMLInvoicePartiesType = interface(IXMLNode)
    ['{3D1F09E6-8AF2-496C-A87D-C3A49410DE17}']
    { Property Accessors }
    function Get_Buyer: IXMLBuyerType;
    function Get_Seller: IXMLSellerType;
    function Get_DeliveryPoint: IXMLDeliveryPointType;
    { Methods & Properties }
    property Buyer: IXMLBuyerType read Get_Buyer;
    property Seller: IXMLSellerType read Get_Seller;
    property DeliveryPoint: IXMLDeliveryPointType read Get_DeliveryPoint;
  end;

{ IXMLBuyerType }

  IXMLBuyerType = interface(IXMLNode)
    ['{A2C17255-818D-4D4A-82D4-369AB9C1C7D8}']
    { Property Accessors }
    function Get_ILN: UnicodeString;
    function Get_TaxID: UnicodeString;
    function Get_UtilizationRegisterNumber: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    { Methods & Properties }
    property ILN: UnicodeString read Get_ILN write Set_ILN;
    property TaxID: UnicodeString read Get_TaxID write Set_TaxID;
    property UtilizationRegisterNumber: UnicodeString read Get_UtilizationRegisterNumber write Set_UtilizationRegisterNumber;
    property Name: UnicodeString read Get_Name write Set_Name;
    property StreetAndNumber: UnicodeString read Get_StreetAndNumber write Set_StreetAndNumber;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property PostalCode: UnicodeString read Get_PostalCode write Set_PostalCode;
    property PhoneNumber: UnicodeString read Get_PhoneNumber write Set_PhoneNumber;
  end;

{ IXMLSellerType }

  IXMLSellerType = interface(IXMLNode)
    ['{CE89B40B-F12E-4FA1-92B8-529ED86DB740}']
    { Property Accessors }
    function Get_ILN: UnicodeString;
    function Get_TaxID: UnicodeString;
    function Get_CodeByBuyer: Integer;
    function Get_UtilizationRegisterNumber: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_CodeByBuyer(Value: Integer);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    { Methods & Properties }
    property ILN: UnicodeString read Get_ILN write Set_ILN;
    property TaxID: UnicodeString read Get_TaxID write Set_TaxID;
    property CodeByBuyer: Integer read Get_CodeByBuyer write Set_CodeByBuyer;
    property UtilizationRegisterNumber: UnicodeString read Get_UtilizationRegisterNumber write Set_UtilizationRegisterNumber;
    property Name: UnicodeString read Get_Name write Set_Name;
    property StreetAndNumber: UnicodeString read Get_StreetAndNumber write Set_StreetAndNumber;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property PostalCode: UnicodeString read Get_PostalCode write Set_PostalCode;
    property PhoneNumber: UnicodeString read Get_PhoneNumber write Set_PhoneNumber;
  end;

{ IXMLDeliveryPointType }

  IXMLDeliveryPointType = interface(IXMLNode)
    ['{CC320603-CBF1-41B1-86A3-1E2EBDA0903F}']
    { Property Accessors }
    function Get_ILN: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    { Methods & Properties }
    property ILN: UnicodeString read Get_ILN write Set_ILN;
    property Name: UnicodeString read Get_Name write Set_Name;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property StreetAndNumber: UnicodeString read Get_StreetAndNumber write Set_StreetAndNumber;
    property PostalCode: UnicodeString read Get_PostalCode write Set_PostalCode;
  end;

{ IXMLInvoiceLinesType }

  IXMLInvoiceLinesType = interface(IXMLNode)
    ['{46590CF3-17D5-4858-927A-62C331EA78A3}']
    { Property Accessors }
    function Get_Line(Index: Integer): IXMLLineType;
    { Methods & Properties }
    function Add: IXMLLineType;
    function Insert(const Index: Integer): IXMLLineType;
    property Line[Index: Integer]: IXMLLineType read Get_Line; default;
  end;

{ IXMLLineType }

  IXMLLineType = interface(IXMLNode)
    ['{62EBA1FA-93CF-46F4-BC31-B8014DFDE8A9}']
    { Property Accessors }
    function Get_LineItem: IXMLLineItemType;
    { Methods & Properties }
    property LineItem: IXMLLineItemType read Get_LineItem;
  end;

{ IXMLLineItemType }

  IXMLLineItemType = interface(IXMLNode)
    ['{55B60522-885E-4356-8CC6-A2E653F8676D}']
    { Property Accessors }
    function Get_LineNumber: Integer;
    function Get_EAN: UnicodeString;
    function Get_BuyerItemCode: UnicodeString;
    function Get_ExternalItemCode: UnicodeString;
    function Get_ItemDescription: UnicodeString;
    function Get_InvoiceQuantity: Double;
    function Get_BuyerUnitOfMeasure: UnicodeString;
    function Get_InvoiceUnitGrossPrice: Double;
    function Get_InvoiceUnitNetPrice: Double;
    function Get_TaxRate: Integer;
    function Get_TaxCategoryCode: UnicodeString;
    function Get_GrossAmount: Double;
    function Get_TaxAmount: Double;
    function Get_NetAmount: Double;
    procedure Set_LineNumber(Value: Integer);
    procedure Set_EAN(Value: UnicodeString);
    procedure Set_BuyerItemCode(Value: UnicodeString);
    procedure Set_ExternalItemCode(Value: UnicodeString);
    procedure Set_ItemDescription(Value: UnicodeString);
    procedure Set_InvoiceQuantity(Value: Double);
    procedure Set_BuyerUnitOfMeasure(Value: UnicodeString);
    procedure Set_InvoiceUnitGrossPrice(Value: Double);
    procedure Set_InvoiceUnitNetPrice(Value: Double);
    procedure Set_TaxRate(Value: Integer);
    procedure Set_TaxCategoryCode(Value: UnicodeString);
    procedure Set_GrossAmount(Value: Double);
    procedure Set_TaxAmount(Value: Double);
    procedure Set_NetAmount(Value: Double);
    { Methods & Properties }
    property LineNumber: Integer read Get_LineNumber write Set_LineNumber;
    property EAN: UnicodeString read Get_EAN write Set_EAN;
    property BuyerItemCode: UnicodeString read Get_BuyerItemCode write Set_BuyerItemCode;
    property ExternalItemCode: UnicodeString read Get_ExternalItemCode write Set_ExternalItemCode;
    property ItemDescription: UnicodeString read Get_ItemDescription write Set_ItemDescription;
    property InvoiceQuantity: Double read Get_InvoiceQuantity write Set_InvoiceQuantity;
    property BuyerUnitOfMeasure: UnicodeString read Get_BuyerUnitOfMeasure write Set_BuyerUnitOfMeasure;
    property InvoiceUnitGrossPrice: Double read Get_InvoiceUnitGrossPrice write Set_InvoiceUnitGrossPrice;
    property InvoiceUnitNetPrice: Double read Get_InvoiceUnitNetPrice write Set_InvoiceUnitNetPrice;
    property TaxRate: Integer read Get_TaxRate write Set_TaxRate;
    property TaxCategoryCode: UnicodeString read Get_TaxCategoryCode write Set_TaxCategoryCode;
    property GrossAmount: Double read Get_GrossAmount write Set_GrossAmount;
    property TaxAmount: Double read Get_TaxAmount write Set_TaxAmount;
    property NetAmount: Double read Get_NetAmount write Set_NetAmount;
  end;

{ IXMLInvoiceSummaryType }

  IXMLInvoiceSummaryType = interface(IXMLNode)
    ['{B4C981C3-8732-470E-B3B1-F7FD422019B7}']
    { Property Accessors }
    function Get_TotalLines: Integer;
    function Get_TotalNetAmount: Double;
    function Get_TotalTaxAmount: Double;
    function Get_TotalGrossAmount: Double;
    procedure Set_TotalLines(Value: Integer);
    procedure Set_TotalNetAmount(Value: Double);
    procedure Set_TotalTaxAmount(Value: Double);
    procedure Set_TotalGrossAmount(Value: Double);
    { Methods & Properties }
    property TotalLines: Integer read Get_TotalLines write Set_TotalLines;
    property TotalNetAmount: Double read Get_TotalNetAmount write Set_TotalNetAmount;
    property TotalTaxAmount: Double read Get_TotalTaxAmount write Set_TotalTaxAmount;
    property TotalGrossAmount: Double read Get_TotalGrossAmount write Set_TotalGrossAmount;
  end;

{ Forward Decls }

  TXMLDocumentInvoiceType = class;
  TXMLInvoiceHeaderType = class;
  TXMLInvoiceReferenceType = class;
  TXMLOrderType = class;
  TXMLTaxInvoiceType = class;
  TXMLInvoicePartiesType = class;
  TXMLBuyerType = class;
  TXMLSellerType = class;
  TXMLDeliveryPointType = class;
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
    function Get_ContractNumber: UnicodeString;
    function Get_ContractDate: UnicodeString;
    procedure Set_InvoiceNumber(Value: UnicodeString);
    procedure Set_InvoiceDate(Value: UnicodeString);
    procedure Set_DocumentFunctionCode(Value: UnicodeString);
    procedure Set_ContractNumber(Value: UnicodeString);
    procedure Set_ContractDate(Value: UnicodeString);
  end;

{ TXMLInvoiceReferenceType }

  TXMLInvoiceReferenceType = class(TXMLNode, IXMLInvoiceReferenceType)
  protected
    { IXMLInvoiceReferenceType }
    function Get_Order: IXMLOrderType;
    function Get_TaxInvoice: IXMLTaxInvoiceType;
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

{ TXMLTaxInvoiceType }

  TXMLTaxInvoiceType = class(TXMLNode, IXMLTaxInvoiceType)
  protected
    { IXMLTaxInvoiceType }
    function Get_TaxInvoiceDate: UnicodeString;
    procedure Set_TaxInvoiceDate(Value: UnicodeString);
  end;

{ TXMLInvoicePartiesType }

  TXMLInvoicePartiesType = class(TXMLNode, IXMLInvoicePartiesType)
  protected
    { IXMLInvoicePartiesType }
    function Get_Buyer: IXMLBuyerType;
    function Get_Seller: IXMLSellerType;
    function Get_DeliveryPoint: IXMLDeliveryPointType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBuyerType }

  TXMLBuyerType = class(TXMLNode, IXMLBuyerType)
  protected
    { IXMLBuyerType }
    function Get_ILN: UnicodeString;
    function Get_TaxID: UnicodeString;
    function Get_UtilizationRegisterNumber: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
  end;

{ TXMLSellerType }

  TXMLSellerType = class(TXMLNode, IXMLSellerType)
  protected
    { IXMLSellerType }
    function Get_ILN: UnicodeString;
    function Get_TaxID: UnicodeString;
    function Get_CodeByBuyer: Integer;
    function Get_UtilizationRegisterNumber: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_CodeByBuyer(Value: Integer);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
  end;

{ TXMLDeliveryPointType }

  TXMLDeliveryPointType = class(TXMLNode, IXMLDeliveryPointType)
  protected
    { IXMLDeliveryPointType }
    function Get_ILN: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
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
    function Get_EAN: UnicodeString;
    function Get_BuyerItemCode: UnicodeString;
    function Get_ExternalItemCode: UnicodeString;
    function Get_ItemDescription: UnicodeString;
    function Get_InvoiceQuantity: Double;
    function Get_BuyerUnitOfMeasure: UnicodeString;
    function Get_InvoiceUnitGrossPrice: Double;
    function Get_InvoiceUnitNetPrice: Double;
    function Get_TaxRate: Integer;
    function Get_TaxCategoryCode: UnicodeString;
    function Get_GrossAmount: Double;
    function Get_TaxAmount: Double;
    function Get_NetAmount: Double;
    procedure Set_LineNumber(Value: Integer);
    procedure Set_EAN(Value: UnicodeString);
    procedure Set_BuyerItemCode(Value: UnicodeString);
    procedure Set_ExternalItemCode(Value: UnicodeString);
    procedure Set_ItemDescription(Value: UnicodeString);
    procedure Set_InvoiceQuantity(Value: Double);
    procedure Set_BuyerUnitOfMeasure(Value: UnicodeString);
    procedure Set_InvoiceUnitGrossPrice(Value: Double);
    procedure Set_InvoiceUnitNetPrice(Value: Double);
    procedure Set_TaxRate(Value: Integer);
    procedure Set_TaxCategoryCode(Value: UnicodeString);
    procedure Set_GrossAmount(Value: Double);
    procedure Set_TaxAmount(Value: Double);
    procedure Set_NetAmount(Value: Double);
  end;

{ TXMLInvoiceSummaryType }

  TXMLInvoiceSummaryType = class(TXMLNode, IXMLInvoiceSummaryType)
  protected
    { IXMLInvoiceSummaryType }
    function Get_TotalLines: Integer;
    function Get_TotalNetAmount: Double;
    function Get_TotalTaxAmount: Double;
    function Get_TotalGrossAmount: Double;
    procedure Set_TotalLines(Value: Integer);
    procedure Set_TotalNetAmount(Value: Double);
    procedure Set_TotalTaxAmount(Value: Double);
    procedure Set_TotalGrossAmount(Value: Double);
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

function TXMLInvoiceHeaderType.Get_ContractNumber: UnicodeString;
begin
  Result := ChildNodes['ContractNumber'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_ContractNumber(Value: UnicodeString);
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
  RegisterChildNode('TaxInvoice', TXMLTaxInvoiceType);
  inherited;
end;

function TXMLInvoiceReferenceType.Get_Order: IXMLOrderType;
begin
  Result := ChildNodes['Order'] as IXMLOrderType;
end;

function TXMLInvoiceReferenceType.Get_TaxInvoice: IXMLTaxInvoiceType;
begin
  Result := ChildNodes['TaxInvoice'] as IXMLTaxInvoiceType;
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

{ TXMLTaxInvoiceType }

function TXMLTaxInvoiceType.Get_TaxInvoiceDate: UnicodeString;
begin
  Result := ChildNodes['TaxInvoiceDate'].Text;
end;

procedure TXMLTaxInvoiceType.Set_TaxInvoiceDate(Value: UnicodeString);
begin
  ChildNodes['TaxInvoiceDate'].NodeValue := Value;
end;

{ TXMLInvoicePartiesType }

procedure TXMLInvoicePartiesType.AfterConstruction;
begin
  RegisterChildNode('Buyer', TXMLBuyerType);
  RegisterChildNode('Seller', TXMLSellerType);
  RegisterChildNode('DeliveryPoint', TXMLDeliveryPointType);
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

{ TXMLBuyerType }

function TXMLBuyerType.Get_ILN: UnicodeString;
begin
  Result := ChildNodes['ILN'].Text;
end;

procedure TXMLBuyerType.Set_ILN(Value: UnicodeString);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLBuyerType.Get_TaxID: UnicodeString;
begin
  Result := ChildNodes['TaxID'].Text;
end;

procedure TXMLBuyerType.Set_TaxID(Value: UnicodeString);
begin
  ChildNodes['TaxID'].NodeValue := Value;
end;

function TXMLBuyerType.Get_UtilizationRegisterNumber: UnicodeString;
begin
  Result := ChildNodes['UtilizationRegisterNumber'].Text;
end;

procedure TXMLBuyerType.Set_UtilizationRegisterNumber(Value: UnicodeString);
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

function TXMLBuyerType.Get_StreetAndNumber: UnicodeString;
begin
  Result := ChildNodes['StreetAndNumber'].Text;
end;

procedure TXMLBuyerType.Set_StreetAndNumber(Value: UnicodeString);
begin
  ChildNodes['StreetAndNumber'].NodeValue := Value;
end;

function TXMLBuyerType.Get_CityName: UnicodeString;
begin
  Result := ChildNodes['CityName'].Text;
end;

procedure TXMLBuyerType.Set_CityName(Value: UnicodeString);
begin
  ChildNodes['CityName'].NodeValue := Value;
end;

function TXMLBuyerType.Get_PostalCode: UnicodeString;
begin
  Result := ChildNodes['PostalCode'].Text;
end;

procedure TXMLBuyerType.Set_PostalCode(Value: UnicodeString);
begin
  ChildNodes['PostalCode'].NodeValue := Value;
end;

function TXMLBuyerType.Get_PhoneNumber: UnicodeString;
begin
  Result := ChildNodes['PhoneNumber'].Text;
end;

procedure TXMLBuyerType.Set_PhoneNumber(Value: UnicodeString);
begin
  ChildNodes['PhoneNumber'].NodeValue := Value;
end;

{ TXMLSellerType }

function TXMLSellerType.Get_ILN: UnicodeString;
begin
  Result := ChildNodes['ILN'].Text;
end;

procedure TXMLSellerType.Set_ILN(Value: UnicodeString);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLSellerType.Get_TaxID: UnicodeString;
begin
  Result := ChildNodes['TaxID'].Text;
end;

procedure TXMLSellerType.Set_TaxID(Value: UnicodeString);
begin
  ChildNodes['TaxID'].NodeValue := Value;
end;

function TXMLSellerType.Get_CodeByBuyer: Integer;
begin
  Result := ChildNodes['CodeByBuyer'].NodeValue;
end;

procedure TXMLSellerType.Set_CodeByBuyer(Value: Integer);
begin
  ChildNodes['CodeByBuyer'].NodeValue := Value;
end;

function TXMLSellerType.Get_UtilizationRegisterNumber: UnicodeString;
begin
  Result := ChildNodes['UtilizationRegisterNumber'].Text;
end;

procedure TXMLSellerType.Set_UtilizationRegisterNumber(Value: UnicodeString);
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

function TXMLSellerType.Get_StreetAndNumber: UnicodeString;
begin
  Result := ChildNodes['StreetAndNumber'].Text;
end;

procedure TXMLSellerType.Set_StreetAndNumber(Value: UnicodeString);
begin
  ChildNodes['StreetAndNumber'].NodeValue := Value;
end;

function TXMLSellerType.Get_CityName: UnicodeString;
begin
  Result := ChildNodes['CityName'].Text;
end;

procedure TXMLSellerType.Set_CityName(Value: UnicodeString);
begin
  ChildNodes['CityName'].NodeValue := Value;
end;

function TXMLSellerType.Get_PostalCode: UnicodeString;
begin
  Result := ChildNodes['PostalCode'].Text;
end;

procedure TXMLSellerType.Set_PostalCode(Value: UnicodeString);
begin
  ChildNodes['PostalCode'].NodeValue := Value;
end;

function TXMLSellerType.Get_PhoneNumber: UnicodeString;
begin
  Result := ChildNodes['PhoneNumber'].Text;
end;

procedure TXMLSellerType.Set_PhoneNumber(Value: UnicodeString);
begin
  ChildNodes['PhoneNumber'].NodeValue := Value;
end;

{ TXMLDeliveryPointType }

function TXMLDeliveryPointType.Get_ILN: UnicodeString;
begin
  Result := ChildNodes['ILN'].Text;
end;

procedure TXMLDeliveryPointType.Set_ILN(Value: UnicodeString);
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

function TXMLDeliveryPointType.Get_PostalCode: UnicodeString;
begin
  Result := ChildNodes['PostalCode'].Text;
end;

procedure TXMLDeliveryPointType.Set_PostalCode(Value: UnicodeString);
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

function TXMLLineItemType.Get_EAN: UnicodeString;
begin
  Result := ChildNodes['EAN'].Text;
end;

procedure TXMLLineItemType.Set_EAN(Value: UnicodeString);
begin
  ChildNodes['EAN'].NodeValue := Value;
end;

function TXMLLineItemType.Get_BuyerItemCode: UnicodeString;
begin
  Result := ChildNodes['BuyerItemCode'].Text;
end;

procedure TXMLLineItemType.Set_BuyerItemCode(Value: UnicodeString);
begin
  ChildNodes['BuyerItemCode'].NodeValue := Value;
end;

function TXMLLineItemType.Get_ExternalItemCode: UnicodeString;
begin
  Result := ChildNodes['ExternalItemCode'].Text;
end;

procedure TXMLLineItemType.Set_ExternalItemCode(Value: UnicodeString);
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

function TXMLLineItemType.Get_InvoiceQuantity: Double;
begin
  Result := ChildNodes['InvoiceQuantity'].NodeValue;
end;

procedure TXMLLineItemType.Set_InvoiceQuantity(Value: Double);
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

function TXMLLineItemType.Get_InvoiceUnitGrossPrice: Double;
begin
  Result := ChildNodes['InvoiceUnitGrossPrice'].NodeValue;
end;

procedure TXMLLineItemType.Set_InvoiceUnitGrossPrice(Value: Double);
begin
  ChildNodes['InvoiceUnitGrossPrice'].NodeValue := Value;
end;

function TXMLLineItemType.Get_InvoiceUnitNetPrice: Double;
begin
  Result := ChildNodes['InvoiceUnitNetPrice'].NodeValue;
end;

procedure TXMLLineItemType.Set_InvoiceUnitNetPrice(Value: Double);
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

function TXMLLineItemType.Get_TaxCategoryCode: UnicodeString;
begin
  Result := ChildNodes['TaxCategoryCode'].Text;
end;

procedure TXMLLineItemType.Set_TaxCategoryCode(Value: UnicodeString);
begin
  ChildNodes['TaxCategoryCode'].NodeValue := Value;
end;

function TXMLLineItemType.Get_GrossAmount: Double;
begin
  Result := ChildNodes['GrossAmount'].NodeValue;
end;

procedure TXMLLineItemType.Set_GrossAmount(Value: Double);
begin
  ChildNodes['GrossAmount'].NodeValue := Value;
end;

function TXMLLineItemType.Get_TaxAmount: Double;
begin
  Result := ChildNodes['TaxAmount'].NodeValue;
end;

procedure TXMLLineItemType.Set_TaxAmount(Value: Double);
begin
  ChildNodes['TaxAmount'].NodeValue := Value;
end;

function TXMLLineItemType.Get_NetAmount: Double;
begin
  Result := ChildNodes['NetAmount'].NodeValue;
end;

procedure TXMLLineItemType.Set_NetAmount(Value: Double);
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

function TXMLInvoiceSummaryType.Get_TotalNetAmount: Double;
begin
  Result := ChildNodes['TotalNetAmount'].NodeValue;
end;

procedure TXMLInvoiceSummaryType.Set_TotalNetAmount(Value: Double);
begin
  ChildNodes['TotalNetAmount'].NodeValue := Value;
end;

function TXMLInvoiceSummaryType.Get_TotalTaxAmount: Double;
begin
  Result := ChildNodes['TotalTaxAmount'].NodeValue;
end;

procedure TXMLInvoiceSummaryType.Set_TotalTaxAmount(Value: Double);
begin
  ChildNodes['TotalTaxAmount'].NodeValue := Value;
end;

function TXMLInvoiceSummaryType.Get_TotalGrossAmount: Double;
begin
  Result := ChildNodes['TotalGrossAmount'].NodeValue;
end;

procedure TXMLInvoiceSummaryType.Set_TotalGrossAmount(Value: Double);
begin
  ChildNodes['TotalGrossAmount'].NodeValue := Value;
end;

end.