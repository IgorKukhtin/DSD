
{*******************************************************************}
{                                                                   }
{                         XML Data Binding                          }
{                                                                   }
{         Generated on: 12.04.2025 18:11:41                         }
{       Generated from: D:\Project-Basis\invoice_delnote_base.xml   }
{   Settings stored in: D:\Project-Basis\invoice_delnote_base.xdb   }
{                                                                   }
{*******************************************************************}

unit invoice_delnote_base;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLDocumentInvoiceType = interface;
  IXMLInvoiceHeaderType = interface;
  IXMLInvoiceReferenceType = interface;
  IXMLOrderType = interface;
  IXMLDespatchAdviceType = interface;
  IXMLTaxInvoiceType = interface;
  IXMLInvoicePartiesType = interface;
  IXMLBuyerType = interface;
  IXMLSellerType = interface;
  IXMLDeliveryPointType = interface;
  IXMLInvoiceLinesType = interface;
  IXMLLineType = interface;
  IXMLLineItemType = interface;
  IXMLInvoiceSummaryType = interface;
  IXMLTaxSummaryType = interface;
  IXMLTaxSummaryLineType = interface;

{ IXMLDocumentInvoiceType }

  IXMLDocumentInvoiceType = interface(IXMLNode)
    ['{6308AEC6-D7E6-4C31-896B-5200C874B21A}']
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
    ['{11D2FC55-CBD6-4A49-9E34-B9D44B67E5A7}']
    { Property Accessors }
    function Get_InvoiceNumber: UnicodeString;
    function Get_InvoiceDate: UnicodeString;
    function Get_InvoicePostDate: UnicodeString;
    function Get_InvoicePostTime: UnicodeString;
    function Get_DocumentFunctionCode: UnicodeString;
    function Get_ContractNumber: UnicodeString;
    function Get_ContractDate: UnicodeString;
    function Get_Place: UnicodeString;
    procedure Set_InvoiceNumber(Value: UnicodeString);
    procedure Set_InvoiceDate(Value: UnicodeString);
    procedure Set_InvoicePostDate(Value: UnicodeString);
    procedure Set_InvoicePostTime(Value: UnicodeString);
    procedure Set_DocumentFunctionCode(Value: UnicodeString);
    procedure Set_ContractNumber(Value: UnicodeString);
    procedure Set_ContractDate(Value: UnicodeString);
    procedure Set_Place(Value: UnicodeString);
    { Methods & Properties }
    property InvoiceNumber: UnicodeString read Get_InvoiceNumber write Set_InvoiceNumber;
    property InvoiceDate: UnicodeString read Get_InvoiceDate write Set_InvoiceDate;
    property InvoicePostDate: UnicodeString read Get_InvoicePostDate write Set_InvoicePostDate;
    property InvoicePostTime: UnicodeString read Get_InvoicePostTime write Set_InvoicePostTime;
    property DocumentFunctionCode: UnicodeString read Get_DocumentFunctionCode write Set_DocumentFunctionCode;
    property ContractNumber: UnicodeString read Get_ContractNumber write Set_ContractNumber;
    property ContractDate: UnicodeString read Get_ContractDate write Set_ContractDate;
    property Place: UnicodeString read Get_Place write Set_Place;
  end;

{ IXMLInvoiceReferenceType }

  IXMLInvoiceReferenceType = interface(IXMLNode)
    ['{2EC5CC58-EEC0-47A3-9253-41D1C2236728}']
    { Property Accessors }
    function Get_Order: IXMLOrderType;
    function Get_DespatchAdvice: IXMLDespatchAdviceType;
    function Get_TaxInvoice: IXMLTaxInvoiceType;
    { Methods & Properties }
    property Order: IXMLOrderType read Get_Order;
    property DespatchAdvice: IXMLDespatchAdviceType read Get_DespatchAdvice;
    property TaxInvoice: IXMLTaxInvoiceType read Get_TaxInvoice;
  end;

{ IXMLOrderType }

  IXMLOrderType = interface(IXMLNode)
    ['{50BF025E-B8CE-45CE-A6BC-B900A3A9B3EB}']
    { Property Accessors }
    function Get_BuyerOrderNumber: UnicodeString;
    function Get_BuyerOrderDate: UnicodeString;
    procedure Set_BuyerOrderNumber(Value: UnicodeString);
    procedure Set_BuyerOrderDate(Value: UnicodeString);
    { Methods & Properties }
    property BuyerOrderNumber: UnicodeString read Get_BuyerOrderNumber write Set_BuyerOrderNumber;
    property BuyerOrderDate: UnicodeString read Get_BuyerOrderDate write Set_BuyerOrderDate;
  end;

{ IXMLDespatchAdviceType }

  IXMLDespatchAdviceType = interface(IXMLNode)
    ['{010E6DE0-E4FF-4FE1-9530-521398461142}']
    { Property Accessors }
    function Get_DespatchAdviceNumber: UnicodeString;
    procedure Set_DespatchAdviceNumber(Value: UnicodeString);
    { Methods & Properties }
    property DespatchAdviceNumber: UnicodeString read Get_DespatchAdviceNumber write Set_DespatchAdviceNumber;
  end;

{ IXMLTaxInvoiceType }

  IXMLTaxInvoiceType = interface(IXMLNode)
    ['{A0E1F957-8F7C-43A1-AE68-70CAB88D6C2F}']
    { Property Accessors }
    function Get_TaxInvoiceNumber: UnicodeString;
    function Get_TaxInvoiceDate: UnicodeString;
    procedure Set_TaxInvoiceNumber(Value: UnicodeString);
    procedure Set_TaxInvoiceDate(Value: UnicodeString);
    { Methods & Properties }
    property TaxInvoiceNumber: UnicodeString read Get_TaxInvoiceNumber write Set_TaxInvoiceNumber;
    property TaxInvoiceDate: UnicodeString read Get_TaxInvoiceDate write Set_TaxInvoiceDate;
  end;

{ IXMLInvoicePartiesType }

  IXMLInvoicePartiesType = interface(IXMLNode)
    ['{9E5C5A40-C615-48CD-BAF9-D0CE565F8C3B}']
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
    ['{76F71C98-993B-4D41-B9F5-AACA8756FB68}']
    { Property Accessors }
    function Get_ILN: UnicodeString;
    function Get_TaxID: UnicodeString;
    function Get_UtilizationRegisterNumber: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    function Get_Country: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
    { Methods & Properties }
    property ILN: UnicodeString read Get_ILN write Set_ILN;
    property TaxID: UnicodeString read Get_TaxID write Set_TaxID;
    property UtilizationRegisterNumber: UnicodeString read Get_UtilizationRegisterNumber write Set_UtilizationRegisterNumber;
    property Name: UnicodeString read Get_Name write Set_Name;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property StreetAndNumber: UnicodeString read Get_StreetAndNumber write Set_StreetAndNumber;
    property PostalCode: UnicodeString read Get_PostalCode write Set_PostalCode;
    property PhoneNumber: UnicodeString read Get_PhoneNumber write Set_PhoneNumber;
    property Country: UnicodeString read Get_Country write Set_Country;
  end;

{ IXMLSellerType }

  IXMLSellerType = interface(IXMLNode)
    ['{970867C1-ABF7-4F40-950F-FE642B30FA77}']
    { Property Accessors }
    function Get_ILN: UnicodeString;
    function Get_TaxID: UnicodeString;
    function Get_UtilizationRegisterNumber: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    function Get_Country: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
    { Methods & Properties }
    property ILN: UnicodeString read Get_ILN write Set_ILN;
    property TaxID: UnicodeString read Get_TaxID write Set_TaxID;
    property UtilizationRegisterNumber: UnicodeString read Get_UtilizationRegisterNumber write Set_UtilizationRegisterNumber;
    property Name: UnicodeString read Get_Name write Set_Name;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property StreetAndNumber: UnicodeString read Get_StreetAndNumber write Set_StreetAndNumber;
    property PostalCode: UnicodeString read Get_PostalCode write Set_PostalCode;
    property PhoneNumber: UnicodeString read Get_PhoneNumber write Set_PhoneNumber;
    property Country: UnicodeString read Get_Country write Set_Country;
  end;

{ IXMLDeliveryPointType }

  IXMLDeliveryPointType = interface(IXMLNode)
    ['{887792DF-DCDF-4AC7-8DAD-E674B6E80541}']
    { Property Accessors }
    function Get_ILN: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    { Methods & Properties }
    property ILN: UnicodeString read Get_ILN write Set_ILN;
  end;

{ IXMLInvoiceLinesType }

  IXMLInvoiceLinesType = interface(IXMLNodeCollection)
    ['{00F78341-2B1B-42ED-BB6A-6FAA5E9C25B1}']
    { Property Accessors }
    function Get_Line(Index: Integer): IXMLLineType;
    { Methods & Properties }
    function Add: IXMLLineType;
    function Insert(const Index: Integer): IXMLLineType;
    property Line[Index: Integer]: IXMLLineType read Get_Line; default;
  end;

{ IXMLLineType }

  IXMLLineType = interface(IXMLNode)
    ['{4534F6FD-1497-40BE-89E8-5C1359AA721B}']
    { Property Accessors }
    function Get_LineItem: IXMLLineItemType;
    { Methods & Properties }
    property LineItem: IXMLLineItemType read Get_LineItem;
  end;

{ IXMLLineItemType }

  IXMLLineItemType = interface(IXMLNode)
    ['{3EF8664B-9C7D-49DB-88D3-505E109D0C05}']
    { Property Accessors }
    function Get_LineNumber: Integer;
    function Get_BuyerItemCode: UnicodeString;
    function Get_SupplierItemCode: UnicodeString;
    function Get_ExternalItemCode: UnicodeString;
    function Get_ItemDescription: UnicodeString;
    function Get_InvoiceQuantity: Double;
    function Get_UnitOfMeasure: UnicodeString;
    function Get_InvoiceUnitNetPrice: Double;
    function Get_TaxRate: Double;
    function Get_TaxAmount: Double;
    function Get_NetAmount: Double;
    function Get_TaxCategoryCode: UnicodeString;
    function Get_EAN: UnicodeString;
    procedure Set_LineNumber(Value: Integer);
    procedure Set_BuyerItemCode(Value: UnicodeString);
    procedure Set_SupplierItemCode(Value: UnicodeString);
    procedure Set_ExternalItemCode(Value: UnicodeString);
    procedure Set_ItemDescription(Value: UnicodeString);
    procedure Set_InvoiceQuantity(Value: Double);
    procedure Set_UnitOfMeasure(Value: UnicodeString);
    procedure Set_InvoiceUnitNetPrice(Value: Double);
    procedure Set_TaxRate(Value: Double);
    procedure Set_TaxAmount(Value: Double);
    procedure Set_NetAmount(Value: Double);
    procedure Set_TaxCategoryCode(Value: UnicodeString);
    procedure Set_EAN(Value: UnicodeString);
    { Methods & Properties }
    property LineNumber: Integer read Get_LineNumber write Set_LineNumber;
    property BuyerItemCode: UnicodeString read Get_BuyerItemCode write Set_BuyerItemCode;
    property SupplierItemCode: UnicodeString read Get_SupplierItemCode write Set_SupplierItemCode;
    property ExternalItemCode: UnicodeString read Get_ExternalItemCode write Set_ExternalItemCode;
    property ItemDescription: UnicodeString read Get_ItemDescription write Set_ItemDescription;
    property InvoiceQuantity: Double read Get_InvoiceQuantity write Set_InvoiceQuantity;
    property UnitOfMeasure: UnicodeString read Get_UnitOfMeasure write Set_UnitOfMeasure;
    property InvoiceUnitNetPrice: Double read Get_InvoiceUnitNetPrice write Set_InvoiceUnitNetPrice;
    property TaxRate: Double read Get_TaxRate write Set_TaxRate;
    property TaxAmount: Double read Get_TaxAmount write Set_TaxAmount;
    property NetAmount: Double read Get_NetAmount write Set_NetAmount;
    property TaxCategoryCode: UnicodeString read Get_TaxCategoryCode write Set_TaxCategoryCode;
    property EAN: UnicodeString read Get_EAN write Set_EAN;
  end;

{ IXMLInvoiceSummaryType }

  IXMLInvoiceSummaryType = interface(IXMLNode)
    ['{3606602A-CBDF-419F-BDB8-1F41E4FAFBB8}']
    { Property Accessors }
    function Get_TotalLines: Integer;
    function Get_TotalNetAmount: Double;
    function Get_TotalTaxAmount: Double;
    function Get_TotalGrossAmount: Double;
    function Get_TotalGrossAmountText: Double;
    function Get_TaxSummary: IXMLTaxSummaryType;
    procedure Set_TotalLines(Value: Integer);
    procedure Set_TotalNetAmount(Value: Double);
    procedure Set_TotalTaxAmount(Value: Double);
    procedure Set_TotalGrossAmount(Value: Double);
    procedure Set_TotalGrossAmountText(Value: Double);
    { Methods & Properties }
    property TotalLines: Integer read Get_TotalLines write Set_TotalLines;
    property TotalNetAmount: Double read Get_TotalNetAmount write Set_TotalNetAmount;
    property TotalTaxAmount: Double read Get_TotalTaxAmount write Set_TotalTaxAmount;
    property TotalGrossAmount: Double read Get_TotalGrossAmount write Set_TotalGrossAmount;
    property TotalGrossAmountText: Double read Get_TotalGrossAmountText write Set_TotalGrossAmountText;
    property TaxSummary: IXMLTaxSummaryType read Get_TaxSummary;
  end;

{ IXMLTaxSummaryType }

  IXMLTaxSummaryType = interface(IXMLNode)
    ['{D18A3F3C-338A-4322-B4D1-748E0B5839FC}']
    { Property Accessors }
    function Get_TaxSummaryLine: IXMLTaxSummaryLineType;
    { Methods & Properties }
    property TaxSummaryLine: IXMLTaxSummaryLineType read Get_TaxSummaryLine;
  end;

{ IXMLTaxSummaryLineType }

  IXMLTaxSummaryLineType = interface(IXMLNode)
    ['{0F773C01-A5D2-4048-A1E9-DDB1DFFEC0AB}']
    { Property Accessors }
    function Get_TaxRate: Double;
    function Get_TaxCategoryCode: UnicodeString;
    function Get_TaxAmount: Double;
    function Get_TaxableAmount: Double;
    function Get_GrossAmount: Double;
    procedure Set_TaxRate(Value: Double);
    procedure Set_TaxCategoryCode(Value: UnicodeString);
    procedure Set_TaxAmount(Value: Double);
    procedure Set_TaxableAmount(Value: Double);
    procedure Set_GrossAmount(Value: Double);
    { Methods & Properties }
    property TaxRate: Double read Get_TaxRate write Set_TaxRate;
    property TaxCategoryCode: UnicodeString read Get_TaxCategoryCode write Set_TaxCategoryCode;
    property TaxAmount: Double read Get_TaxAmount write Set_TaxAmount;
    property TaxableAmount: Double read Get_TaxableAmount write Set_TaxableAmount;
    property GrossAmount: Double read Get_GrossAmount write Set_GrossAmount;
  end;

{ Forward Decls }

  TXMLDocumentInvoiceType = class;
  TXMLInvoiceHeaderType = class;
  TXMLInvoiceReferenceType = class;
  TXMLOrderType = class;
  TXMLDespatchAdviceType = class;
  TXMLTaxInvoiceType = class;
  TXMLInvoicePartiesType = class;
  TXMLBuyerType = class;
  TXMLSellerType = class;
  TXMLDeliveryPointType = class;
  TXMLInvoiceLinesType = class;
  TXMLLineType = class;
  TXMLLineItemType = class;
  TXMLInvoiceSummaryType = class;
  TXMLTaxSummaryType = class;
  TXMLTaxSummaryLineType = class;

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
    function Get_InvoicePostDate: UnicodeString;
    function Get_InvoicePostTime: UnicodeString;
    function Get_DocumentFunctionCode: UnicodeString;
    function Get_ContractNumber: UnicodeString;
    function Get_ContractDate: UnicodeString;
    function Get_Place: UnicodeString;
    procedure Set_InvoiceNumber(Value: UnicodeString);
    procedure Set_InvoiceDate(Value: UnicodeString);
    procedure Set_InvoicePostDate(Value: UnicodeString);
    procedure Set_InvoicePostTime(Value: UnicodeString);
    procedure Set_DocumentFunctionCode(Value: UnicodeString);
    procedure Set_ContractNumber(Value: UnicodeString);
    procedure Set_ContractDate(Value: UnicodeString);
    procedure Set_Place(Value: UnicodeString);
  end;

{ TXMLInvoiceReferenceType }

  TXMLInvoiceReferenceType = class(TXMLNode, IXMLInvoiceReferenceType)
  protected
    { IXMLInvoiceReferenceType }
    function Get_Order: IXMLOrderType;
    function Get_DespatchAdvice: IXMLDespatchAdviceType;
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

{ TXMLDespatchAdviceType }

  TXMLDespatchAdviceType = class(TXMLNode, IXMLDespatchAdviceType)
  protected
    { IXMLDespatchAdviceType }
    function Get_DespatchAdviceNumber: UnicodeString;
    procedure Set_DespatchAdviceNumber(Value: UnicodeString);
  end;

{ TXMLTaxInvoiceType }

  TXMLTaxInvoiceType = class(TXMLNode, IXMLTaxInvoiceType)
  protected
    { IXMLTaxInvoiceType }
    function Get_TaxInvoiceNumber: UnicodeString;
    function Get_TaxInvoiceDate: UnicodeString;
    procedure Set_TaxInvoiceNumber(Value: UnicodeString);
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
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    function Get_Country: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
  end;

{ TXMLSellerType }

  TXMLSellerType = class(TXMLNode, IXMLSellerType)
  protected
    { IXMLSellerType }
    function Get_ILN: UnicodeString;
    function Get_TaxID: UnicodeString;
    function Get_UtilizationRegisterNumber: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_StreetAndNumber: UnicodeString;
    function Get_PostalCode: UnicodeString;
    function Get_PhoneNumber: UnicodeString;
    function Get_Country: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
    procedure Set_TaxID(Value: UnicodeString);
    procedure Set_UtilizationRegisterNumber(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_StreetAndNumber(Value: UnicodeString);
    procedure Set_PostalCode(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    procedure Set_Country(Value: UnicodeString);
  end;

{ TXMLDeliveryPointType }

  TXMLDeliveryPointType = class(TXMLNode, IXMLDeliveryPointType)
  protected
    { IXMLDeliveryPointType }
    function Get_ILN: UnicodeString;
    procedure Set_ILN(Value: UnicodeString);
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
    function Get_BuyerItemCode: UnicodeString;
    function Get_SupplierItemCode: UnicodeString;
    function Get_ExternalItemCode: UnicodeString;
    function Get_ItemDescription: UnicodeString;
    function Get_InvoiceQuantity: Double;
    function Get_UnitOfMeasure: UnicodeString;
    function Get_InvoiceUnitNetPrice: Double;
    function Get_TaxRate: Double;
    function Get_TaxAmount: Double;
    function Get_NetAmount: Double;
    function Get_TaxCategoryCode: UnicodeString;
    function Get_EAN: UnicodeString;
    procedure Set_LineNumber(Value: Integer);
    procedure Set_BuyerItemCode(Value: UnicodeString);
    procedure Set_SupplierItemCode(Value: UnicodeString);
    procedure Set_ExternalItemCode(Value: UnicodeString);
    procedure Set_ItemDescription(Value: UnicodeString);
    procedure Set_InvoiceQuantity(Value: Double);
    procedure Set_UnitOfMeasure(Value: UnicodeString);
    procedure Set_InvoiceUnitNetPrice(Value: Double);
    procedure Set_TaxRate(Value: Double);
    procedure Set_TaxAmount(Value: Double);
    procedure Set_NetAmount(Value: Double);
    procedure Set_TaxCategoryCode(Value: UnicodeString);
    procedure Set_EAN(Value: UnicodeString);
  end;

{ TXMLInvoiceSummaryType }

  TXMLInvoiceSummaryType = class(TXMLNode, IXMLInvoiceSummaryType)
  protected
    { IXMLInvoiceSummaryType }
    function Get_TotalLines: Integer;
    function Get_TotalNetAmount: Double;
    function Get_TotalTaxAmount: Double;
    function Get_TotalGrossAmount: Double;
    function Get_TotalGrossAmountText: Double;
    function Get_TaxSummary: IXMLTaxSummaryType;
    procedure Set_TotalLines(Value: Integer);
    procedure Set_TotalNetAmount(Value: Double);
    procedure Set_TotalTaxAmount(Value: Double);
    procedure Set_TotalGrossAmount(Value: Double);
    procedure Set_TotalGrossAmountText(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTaxSummaryType }

  TXMLTaxSummaryType = class(TXMLNode, IXMLTaxSummaryType)
  protected
    { IXMLTaxSummaryType }
    function Get_TaxSummaryLine: IXMLTaxSummaryLineType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTaxSummaryLineType }

  TXMLTaxSummaryLineType = class(TXMLNode, IXMLTaxSummaryLineType)
  protected
    { IXMLTaxSummaryLineType }
    function Get_TaxRate: Double;
    function Get_TaxCategoryCode: UnicodeString;
    function Get_TaxAmount: Double;
    function Get_TaxableAmount: Double;
    function Get_GrossAmount: Double;
    procedure Set_TaxRate(Value: Double);
    procedure Set_TaxCategoryCode(Value: UnicodeString);
    procedure Set_TaxAmount(Value: Double);
    procedure Set_TaxableAmount(Value: Double);
    procedure Set_GrossAmount(Value: Double);
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

function TXMLInvoiceHeaderType.Get_InvoicePostDate: UnicodeString;
begin
  Result := ChildNodes['InvoicePostDate'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_InvoicePostDate(Value: UnicodeString);
begin
  ChildNodes['InvoicePostDate'].NodeValue := Value;
end;

function TXMLInvoiceHeaderType.Get_InvoicePostTime: UnicodeString;
begin
  Result := ChildNodes['InvoicePostTime'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_InvoicePostTime(Value: UnicodeString);
begin
  ChildNodes['InvoicePostTime'].NodeValue := Value;
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
  Result := ChildNodes['ContractNumber'].NodeValue;
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

function TXMLInvoiceHeaderType.Get_Place: UnicodeString;
begin
  Result := ChildNodes['Place'].Text;
end;

procedure TXMLInvoiceHeaderType.Set_Place(Value: UnicodeString);
begin
  ChildNodes['Place'].NodeValue := Value;
end;

{ TXMLInvoiceReferenceType }

procedure TXMLInvoiceReferenceType.AfterConstruction;
begin
  RegisterChildNode('Order', TXMLOrderType);
  RegisterChildNode('DespatchAdvice', TXMLDespatchAdviceType);
  RegisterChildNode('TaxInvoice', TXMLTaxInvoiceType);
  inherited;
end;

function TXMLInvoiceReferenceType.Get_Order: IXMLOrderType;
begin
  Result := ChildNodes['Order'] as IXMLOrderType;
end;

function TXMLInvoiceReferenceType.Get_DespatchAdvice: IXMLDespatchAdviceType;
begin
  Result := ChildNodes['DespatchAdvice'] as IXMLDespatchAdviceType;
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

{ TXMLDespatchAdviceType }

function TXMLDespatchAdviceType.Get_DespatchAdviceNumber: UnicodeString;
begin
  Result := ChildNodes['DespatchAdviceNumber'].Text;
end;

procedure TXMLDespatchAdviceType.Set_DespatchAdviceNumber(Value: UnicodeString);
begin
  ChildNodes['DespatchAdviceNumber'].NodeValue := Value;
end;

{ TXMLTaxInvoiceType }

function TXMLTaxInvoiceType.Get_TaxInvoiceNumber: UnicodeString;
begin
  Result := ChildNodes['TaxInvoiceNumber'].NodeValue;
end;

procedure TXMLTaxInvoiceType.Set_TaxInvoiceNumber(Value: UnicodeString);
begin
  ChildNodes['TaxInvoiceNumber'].NodeValue := Value;
end;

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
  Result := ChildNodes['ILN'].NodeValue;
end;

procedure TXMLBuyerType.Set_ILN(Value: UnicodeString);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLBuyerType.Get_TaxID: UnicodeString;
begin
  Result := ChildNodes['TaxID'].NodeValue;
end;

procedure TXMLBuyerType.Set_TaxID(Value: UnicodeString);
begin
  ChildNodes['TaxID'].NodeValue := Value;
end;

function TXMLBuyerType.Get_UtilizationRegisterNumber: UnicodeString;
begin
  Result := ChildNodes['UtilizationRegisterNumber'].NodeValue;
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

function TXMLBuyerType.Get_CityName: UnicodeString;
begin
  Result := ChildNodes['CityName'].Text;
end;

procedure TXMLBuyerType.Set_CityName(Value: UnicodeString);
begin
  ChildNodes['CityName'].NodeValue := Value;
end;

function TXMLBuyerType.Get_StreetAndNumber: UnicodeString;
begin
  Result := ChildNodes['StreetAndNumber'].Text;
end;

procedure TXMLBuyerType.Set_StreetAndNumber(Value: UnicodeString);
begin
  ChildNodes['StreetAndNumber'].NodeValue := Value;
end;

function TXMLBuyerType.Get_PostalCode: UnicodeString;
begin
  Result := ChildNodes['PostalCode'].NodeValue;
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

function TXMLBuyerType.Get_Country: UnicodeString;
begin
  Result := ChildNodes['Country'].Text;
end;

procedure TXMLBuyerType.Set_Country(Value: UnicodeString);
begin
  ChildNodes['Country'].NodeValue := Value;
end;

{ TXMLSellerType }

function TXMLSellerType.Get_ILN: UnicodeString;
begin
  Result := ChildNodes['ILN'].NodeValue;
end;

procedure TXMLSellerType.Set_ILN(Value: UnicodeString);
begin
  ChildNodes['ILN'].NodeValue := Value;
end;

function TXMLSellerType.Get_TaxID: UnicodeString;
begin
  Result := ChildNodes['TaxID'].NodeValue;
end;

procedure TXMLSellerType.Set_TaxID(Value: UnicodeString);
begin
  ChildNodes['TaxID'].NodeValue := Value;
end;

function TXMLSellerType.Get_UtilizationRegisterNumber: UnicodeString;
begin
  Result := ChildNodes['UtilizationRegisterNumber'].NodeValue;
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

function TXMLSellerType.Get_CityName: UnicodeString;
begin
  Result := ChildNodes['CityName'].Text;
end;

procedure TXMLSellerType.Set_CityName(Value: UnicodeString);
begin
  ChildNodes['CityName'].NodeValue := Value;
end;

function TXMLSellerType.Get_StreetAndNumber: UnicodeString;
begin
  Result := ChildNodes['StreetAndNumber'].Text;
end;

procedure TXMLSellerType.Set_StreetAndNumber(Value: UnicodeString);
begin
  ChildNodes['StreetAndNumber'].NodeValue := Value;
end;

function TXMLSellerType.Get_PostalCode: UnicodeString;
begin
  Result := ChildNodes['PostalCode'].NodeValue;
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

function TXMLSellerType.Get_Country: UnicodeString;
begin
  Result := ChildNodes['Country'].Text;
end;

procedure TXMLSellerType.Set_Country(Value: UnicodeString);
begin
  ChildNodes['Country'].NodeValue := Value;
end;

{ TXMLDeliveryPointType }

function TXMLDeliveryPointType.Get_ILN: UnicodeString;
begin
  Result := ChildNodes['ILN'].NodeValue;
end;

procedure TXMLDeliveryPointType.Set_ILN(Value: UnicodeString);
begin
  ChildNodes['ILN'].NodeValue := Value;
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

function TXMLLineItemType.Get_BuyerItemCode: UnicodeString;
begin
  Result := ChildNodes['BuyerItemCode'].NodeValue;
end;

procedure TXMLLineItemType.Set_BuyerItemCode(Value: UnicodeString);
begin
  ChildNodes['BuyerItemCode'].NodeValue := Value;
end;

function TXMLLineItemType.Get_SupplierItemCode: UnicodeString;
begin
  Result := ChildNodes['SupplierItemCode'].NodeValue;
end;

procedure TXMLLineItemType.Set_SupplierItemCode(Value: UnicodeString);
begin
  ChildNodes['SupplierItemCode'].NodeValue := Value;
end;

function TXMLLineItemType.Get_ExternalItemCode: UnicodeString;
begin
  Result := ChildNodes['ExternalItemCode'].NodeValue;
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

function TXMLLineItemType.Get_UnitOfMeasure: UnicodeString;
begin
  Result := ChildNodes['UnitOfMeasure'].Text;
end;

procedure TXMLLineItemType.Set_UnitOfMeasure(Value: UnicodeString);
begin
  ChildNodes['UnitOfMeasure'].NodeValue := Value;
end;

function TXMLLineItemType.Get_InvoiceUnitNetPrice: Double;
begin
  Result := ChildNodes['InvoiceUnitNetPrice'].NodeValue;
end;

procedure TXMLLineItemType.Set_InvoiceUnitNetPrice(Value: Double);
begin
  ChildNodes['InvoiceUnitNetPrice'].NodeValue := Value;
end;

function TXMLLineItemType.Get_TaxRate: Double;
begin
  Result := ChildNodes['TaxRate'].NodeValue;
end;

procedure TXMLLineItemType.Set_TaxRate(Value: Double);
begin
  ChildNodes['TaxRate'].NodeValue := Value;
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

function TXMLLineItemType.Get_TaxCategoryCode: UnicodeString;
begin
  Result := ChildNodes['TaxCategoryCode'].Text;
end;

procedure TXMLLineItemType.Set_TaxCategoryCode(Value: UnicodeString);
begin
  ChildNodes['TaxCategoryCode'].NodeValue := Value;
end;

function TXMLLineItemType.Get_EAN: UnicodeString;
begin
  Result := ChildNodes['EAN'].NodeValue;
end;

procedure TXMLLineItemType.Set_EAN(Value: UnicodeString);
begin
  ChildNodes['EAN'].NodeValue := Value;
end;

{ TXMLInvoiceSummaryType }

procedure TXMLInvoiceSummaryType.AfterConstruction;
begin
  RegisterChildNode('Tax-Summary', TXMLTaxSummaryType);
  inherited;
end;

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

function TXMLInvoiceSummaryType.Get_TotalGrossAmountText: Double;
begin
  Result := ChildNodes['TotalGrossAmountText'].NodeValue;
end;

procedure TXMLInvoiceSummaryType.Set_TotalGrossAmountText(Value: Double);
begin
  ChildNodes['TotalGrossAmountText'].NodeValue := Value;
end;

function TXMLInvoiceSummaryType.Get_TaxSummary: IXMLTaxSummaryType;
begin
  Result := ChildNodes['Tax-Summary'] as IXMLTaxSummaryType;
end;

{ TXMLTaxSummaryType }

procedure TXMLTaxSummaryType.AfterConstruction;
begin
  RegisterChildNode('Tax-Summary-Line', TXMLTaxSummaryLineType);
  inherited;
end;

function TXMLTaxSummaryType.Get_TaxSummaryLine: IXMLTaxSummaryLineType;
begin
  Result := ChildNodes['Tax-Summary-Line'] as IXMLTaxSummaryLineType;
end;

{ TXMLTaxSummaryLineType }

function TXMLTaxSummaryLineType.Get_TaxRate: Double;
begin
  Result := ChildNodes['TaxRate'].NodeValue;
end;

procedure TXMLTaxSummaryLineType.Set_TaxRate(Value: Double);
begin
  ChildNodes['TaxRate'].NodeValue := Value;
end;

function TXMLTaxSummaryLineType.Get_TaxCategoryCode: UnicodeString;
begin
  Result := ChildNodes['TaxCategoryCode'].Text;
end;

procedure TXMLTaxSummaryLineType.Set_TaxCategoryCode(Value: UnicodeString);
begin
  ChildNodes['TaxCategoryCode'].NodeValue := Value;
end;

function TXMLTaxSummaryLineType.Get_TaxAmount: Double;
begin
  Result := ChildNodes['TaxAmount'].NodeValue;
end;

procedure TXMLTaxSummaryLineType.Set_TaxAmount(Value: Double);
begin
  ChildNodes['TaxAmount'].NodeValue := Value;
end;

function TXMLTaxSummaryLineType.Get_TaxableAmount: Double;
begin
  Result := ChildNodes['TaxableAmount'].NodeValue;
end;

procedure TXMLTaxSummaryLineType.Set_TaxableAmount(Value: Double);
begin
  ChildNodes['TaxableAmount'].NodeValue := Value;
end;

function TXMLTaxSummaryLineType.Get_GrossAmount: Double;
begin
  Result := ChildNodes['GrossAmount'].NodeValue;
end;

procedure TXMLTaxSummaryLineType.Set_GrossAmount(Value: Double);
begin
  ChildNodes['GrossAmount'].NodeValue := Value;
end;

end.