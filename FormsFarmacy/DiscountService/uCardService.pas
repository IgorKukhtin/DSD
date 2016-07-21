// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://exim.demo.mdmworld.com/CardService.asmx?WSDL
//  >Import : http://exim.demo.mdmworld.com/CardService.asmx?WSDL>0
// Encoding : utf-8
// Version  : 1.0
// (15.07.2016 10:21:46 - - $Rev: 56641 $)
// ************************************************************************ //

unit uCardService;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_UNBD = $0002;
  IS_NLBL = $0004;
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:double          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:decimal         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]

  CardCheckItem        = class;                 { "http://tempuri.org/"[GblCplx] }
  CardCheckResultItem  = class;                 { "http://tempuri.org/"[GblCplx] }
  SynevoResult         = class;                 { "http://tempuri.org/"[GblCplx] }
  OrderRequest         = class;                 { "http://tempuri.org/"[GblCplx] }
  OrderResult          = class;                 { "http://tempuri.org/"[GblCplx] }
  OrderRequestItem     = class;                 { "http://tempuri.org/"[GblCplx] }
  CardSaleResultItem   = class;                 { "http://tempuri.org/"[GblCplx] }
  CardSaleRequestItem  = class;                 { "http://tempuri.org/"[GblCplx] }
  CardSaleRequest      = class;                 { "http://tempuri.org/"[GblCplx] }
  CardSaleResult       = class;                 { "http://tempuri.org/"[GblCplx] }

  ArrayOfSynevoResult = array of SynevoResult;   { "http://tempuri.org/"[GblCplx] }
  ArrayOfCardCheckResultItem = array of CardCheckResultItem;   { "http://tempuri.org/"[GblCplx] }
  ArrayOfCardCheckItem = array of CardCheckItem;   { "http://tempuri.org/"[GblCplx] }


  // ************************************************************************ //
  // XML       : CardCheckItem, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  CardCheckItem = class(TRemotable)
  private
    FMdmCode: string;
    FMdmCode_Specified: boolean;
    FProductFormCode: string;
    FProductFormCode_Specified: boolean;
    FSaleType: string;
    FSaleType_Specified: boolean;
    FRequestedPrice: TXSDecimal;
    FRequestedQuantity: TXSDecimal;
    FRequestedAmount: TXSDecimal;
    procedure SetMdmCode(Index: Integer; const Astring: string);
    function  MdmCode_Specified(Index: Integer): boolean;
    procedure SetProductFormCode(Index: Integer; const Astring: string);
    function  ProductFormCode_Specified(Index: Integer): boolean;
    procedure SetSaleType(Index: Integer; const Astring: string);
    function  SaleType_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property MdmCode:           string      Index (IS_OPTN) read FMdmCode write SetMdmCode stored MdmCode_Specified;
    property ProductFormCode:   string      Index (IS_OPTN) read FProductFormCode write SetProductFormCode stored ProductFormCode_Specified;
    property SaleType:          string      Index (IS_OPTN) read FSaleType write SetSaleType stored SaleType_Specified;
    property RequestedPrice:    TXSDecimal  read FRequestedPrice write FRequestedPrice;
    property RequestedQuantity: TXSDecimal  read FRequestedQuantity write FRequestedQuantity;
    property RequestedAmount:   TXSDecimal  read FRequestedAmount write FRequestedAmount;
  end;



  // ************************************************************************ //
  // XML       : CardCheckResultItem, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  CardCheckResultItem = class(TRemotable)
  private
    FMdmCode: string;
    FMdmCode_Specified: boolean;
    FProductFormCode: string;
    FProductFormCode_Specified: boolean;
    FSaleType: string;
    FSaleType_Specified: boolean;
    FRequestedPrice: TXSDecimal;
    FRequestedQuantity: TXSDecimal;
    FRequestedAmount: TXSDecimal;
    FResultStatus: string;
    FResultStatus_Specified: boolean;
    FResultDescription: string;
    FResultDescription_Specified: boolean;
    FResultDiscountPercent: Double;
    FResultDiscountAmount: Double;
    FResultPromoPrice: Double;
    procedure SetMdmCode(Index: Integer; const Astring: string);
    function  MdmCode_Specified(Index: Integer): boolean;
    procedure SetProductFormCode(Index: Integer; const Astring: string);
    function  ProductFormCode_Specified(Index: Integer): boolean;
    procedure SetSaleType(Index: Integer; const Astring: string);
    function  SaleType_Specified(Index: Integer): boolean;
    procedure SetResultStatus(Index: Integer; const Astring: string);
    function  ResultStatus_Specified(Index: Integer): boolean;
    procedure SetResultDescription(Index: Integer; const Astring: string);
    function  ResultDescription_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property MdmCode:               string      Index (IS_OPTN) read FMdmCode write SetMdmCode stored MdmCode_Specified;
    property ProductFormCode:       string      Index (IS_OPTN) read FProductFormCode write SetProductFormCode stored ProductFormCode_Specified;
    property SaleType:              string      Index (IS_OPTN) read FSaleType write SetSaleType stored SaleType_Specified;
    property RequestedPrice:        TXSDecimal  read FRequestedPrice write FRequestedPrice;
    property RequestedQuantity:     TXSDecimal  read FRequestedQuantity write FRequestedQuantity;
    property RequestedAmount:       TXSDecimal  read FRequestedAmount write FRequestedAmount;
    property ResultStatus:          string      Index (IS_OPTN) read FResultStatus write SetResultStatus stored ResultStatus_Specified;
    property ResultDescription:     string      Index (IS_OPTN) read FResultDescription write SetResultDescription stored ResultDescription_Specified;
    property ResultDiscountPercent: Double      read FResultDiscountPercent write FResultDiscountPercent;
    property ResultDiscountAmount:  Double      read FResultDiscountAmount write FResultDiscountAmount;
    property ResultPromoPrice:      Double      read FResultPromoPrice write FResultPromoPrice;
  end;

  ArrayOfString = array of string;              { "http://tempuri.org/"[GblCplx] }


  // ************************************************************************ //
  // XML       : SynevoResult, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  SynevoResult = class(TRemotable)
  private
    FCode: string;
    FCode_Specified: boolean;
    FAnalysisDate: TXSDateTime;
    FValue: TXSDecimal;
    procedure SetCode(Index: Integer; const Astring: string);
    function  Code_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property Code:         string       Index (IS_OPTN) read FCode write SetCode stored Code_Specified;
    property AnalysisDate: TXSDateTime  read FAnalysisDate write FAnalysisDate;
    property Value:        TXSDecimal   read FValue write FValue;
  end;

  ArrayOfOrderRequestItem = array of OrderRequestItem;   { "http://tempuri.org/"[GblCplx] }


  // ************************************************************************ //
  // XML       : OrderRequest, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  OrderRequest = class(TRemotable)
  private
    FOrderId: string;
    FOrderId_Specified: boolean;
    FOrderCode: string;
    FOrderCode_Specified: boolean;
    FOrderDate: TXSDateTime;
    FOrderType: string;
    FOrderType_Specified: boolean;
    FOrganizationFromCode: string;
    FOrganizationFromCode_Specified: boolean;
    FOrganizationFromName: string;
    FOrganizationFromName_Specified: boolean;
    FOrganizationToCode: string;
    FOrganizationToCode_Specified: boolean;
    FOrganizationToName: string;
    FOrganizationToName_Specified: boolean;
    FItems: ArrayOfOrderRequestItem;
    FItems_Specified: boolean;
    procedure SetOrderId(Index: Integer; const Astring: string);
    function  OrderId_Specified(Index: Integer): boolean;
    procedure SetOrderCode(Index: Integer; const Astring: string);
    function  OrderCode_Specified(Index: Integer): boolean;
    procedure SetOrderType(Index: Integer; const Astring: string);
    function  OrderType_Specified(Index: Integer): boolean;
    procedure SetOrganizationFromCode(Index: Integer; const Astring: string);
    function  OrganizationFromCode_Specified(Index: Integer): boolean;
    procedure SetOrganizationFromName(Index: Integer; const Astring: string);
    function  OrganizationFromName_Specified(Index: Integer): boolean;
    procedure SetOrganizationToCode(Index: Integer; const Astring: string);
    function  OrganizationToCode_Specified(Index: Integer): boolean;
    procedure SetOrganizationToName(Index: Integer; const Astring: string);
    function  OrganizationToName_Specified(Index: Integer): boolean;
    procedure SetItems(Index: Integer; const AArrayOfOrderRequestItem: ArrayOfOrderRequestItem);
    function  Items_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property OrderId:              string                   Index (IS_OPTN) read FOrderId write SetOrderId stored OrderId_Specified;
    property OrderCode:            string                   Index (IS_OPTN) read FOrderCode write SetOrderCode stored OrderCode_Specified;
    property OrderDate:            TXSDateTime              read FOrderDate write FOrderDate;
    property OrderType:            string                   Index (IS_OPTN) read FOrderType write SetOrderType stored OrderType_Specified;
    property OrganizationFromCode: string                   Index (IS_OPTN) read FOrganizationFromCode write SetOrganizationFromCode stored OrganizationFromCode_Specified;
    property OrganizationFromName: string                   Index (IS_OPTN) read FOrganizationFromName write SetOrganizationFromName stored OrganizationFromName_Specified;
    property OrganizationToCode:   string                   Index (IS_OPTN) read FOrganizationToCode write SetOrganizationToCode stored OrganizationToCode_Specified;
    property OrganizationToName:   string                   Index (IS_OPTN) read FOrganizationToName write SetOrganizationToName stored OrganizationToName_Specified;
    property Items:                ArrayOfOrderRequestItem  Index (IS_OPTN) read FItems write SetItems stored Items_Specified;
  end;



  // ************************************************************************ //
  // XML       : OrderResult, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  OrderResult = class(TRemotable)
  private
    FResultStatus: string;
    FResultStatus_Specified: boolean;
    FResultDescription: string;
    FResultDescription_Specified: boolean;
    procedure SetResultStatus(Index: Integer; const Astring: string);
    function  ResultStatus_Specified(Index: Integer): boolean;
    procedure SetResultDescription(Index: Integer; const Astring: string);
    function  ResultDescription_Specified(Index: Integer): boolean;
  published
    property ResultStatus:      string  Index (IS_OPTN) read FResultStatus write SetResultStatus stored ResultStatus_Specified;
    property ResultDescription: string  Index (IS_OPTN) read FResultDescription write SetResultDescription stored ResultDescription_Specified;
  end;



  // ************************************************************************ //
  // XML       : OrderRequestItem, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  OrderRequestItem = class(TRemotable)
  private
    FProductFormCode: string;
    FProductFormCode_Specified: boolean;
    FSaleType: string;
    FSaleType_Specified: boolean;
    FQuantity: TXSDecimal;
    procedure SetProductFormCode(Index: Integer; const Astring: string);
    function  ProductFormCode_Specified(Index: Integer): boolean;
    procedure SetSaleType(Index: Integer; const Astring: string);
    function  SaleType_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ProductFormCode: string      Index (IS_OPTN) read FProductFormCode write SetProductFormCode stored ProductFormCode_Specified;
    property SaleType:        string      Index (IS_OPTN) read FSaleType write SetSaleType stored SaleType_Specified;
    property Quantity:        TXSDecimal  read FQuantity write FQuantity;
  end;



  // ************************************************************************ //
  // XML       : CardSaleResultItem, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  CardSaleResultItem = class(TRemotable)
  private
    FPrimaryPrice: TXSDecimal;
    FPrimaryAmount: TXSDecimal;
    FRequestedPrice: TXSDecimal;
    FRequestedAmount: TXSDecimal;
    FRequestedQuantity: TXSDecimal;
    FProductFormCode: string;
    FProductFormCode_Specified: boolean;
    FResultTransactionId: string;
    FResultTransactionId_Specified: boolean;
    FResultStatus: string;
    FResultStatus_Specified: boolean;
    FResultDescription: string;
    FResultDescription_Specified: boolean;
    FMedicineSaleId: string;
    FMedicineSaleId_Specified: boolean;
    FResultDiscountPercent: Double;
    FResultDiscountAmount: Double;
    FResultPromoPrice: Double;
    procedure SetProductFormCode(Index: Integer; const Astring: string);
    function  ProductFormCode_Specified(Index: Integer): boolean;
    procedure SetResultTransactionId(Index: Integer; const Astring: string);
    function  ResultTransactionId_Specified(Index: Integer): boolean;
    procedure SetResultStatus(Index: Integer; const Astring: string);
    function  ResultStatus_Specified(Index: Integer): boolean;
    procedure SetResultDescription(Index: Integer; const Astring: string);
    function  ResultDescription_Specified(Index: Integer): boolean;
    procedure SetMedicineSaleId(Index: Integer; const Astring: string);
    function  MedicineSaleId_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property PrimaryPrice:          TXSDecimal  read FPrimaryPrice write FPrimaryPrice;
    property PrimaryAmount:         TXSDecimal  read FPrimaryAmount write FPrimaryAmount;
    property RequestedPrice:        TXSDecimal  read FRequestedPrice write FRequestedPrice;
    property RequestedAmount:       TXSDecimal  read FRequestedAmount write FRequestedAmount;
    property RequestedQuantity:     TXSDecimal  read FRequestedQuantity write FRequestedQuantity;
    property ProductFormCode:       string      Index (IS_OPTN) read FProductFormCode write SetProductFormCode stored ProductFormCode_Specified;
    property ResultTransactionId:   string      Index (IS_OPTN) read FResultTransactionId write SetResultTransactionId stored ResultTransactionId_Specified;
    property ResultStatus:          string      Index (IS_OPTN) read FResultStatus write SetResultStatus stored ResultStatus_Specified;
    property ResultDescription:     string      Index (IS_OPTN) read FResultDescription write SetResultDescription stored ResultDescription_Specified;
    property MedicineSaleId:        string      Index (IS_OPTN) read FMedicineSaleId write SetMedicineSaleId stored MedicineSaleId_Specified;
    property ResultDiscountPercent: Double      read FResultDiscountPercent write FResultDiscountPercent;
    property ResultDiscountAmount:  Double      read FResultDiscountAmount write FResultDiscountAmount;
    property ResultPromoPrice:      Double      read FResultPromoPrice write FResultPromoPrice;
  end;



  // ************************************************************************ //
  // XML       : CardSaleRequestItem, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  CardSaleRequestItem = class(TRemotable)
  private
    FItemId: string;
    FItemId_Specified: boolean;
    FMdmCode: string;
    FMdmCode_Specified: boolean;
    FSaleType: string;
    FSaleType_Specified: boolean;
    FPrimaryPrice: TXSDecimal;
    FPrimaryAmount: TXSDecimal;
    FRequestedPrice: TXSDecimal;
    FRequestedAmount: TXSDecimal;
    FRequestedQuantity: TXSDecimal;
    FProductFormCode: string;
    FProductFormCode_Specified: boolean;
    procedure SetItemId(Index: Integer; const Astring: string);
    function  ItemId_Specified(Index: Integer): boolean;
    procedure SetMdmCode(Index: Integer; const Astring: string);
    function  MdmCode_Specified(Index: Integer): boolean;
    procedure SetSaleType(Index: Integer; const Astring: string);
    function  SaleType_Specified(Index: Integer): boolean;
    procedure SetProductFormCode(Index: Integer; const Astring: string);
    function  ProductFormCode_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property ItemId:            string      Index (IS_OPTN) read FItemId write SetItemId stored ItemId_Specified;
    property MdmCode:           string      Index (IS_OPTN) read FMdmCode write SetMdmCode stored MdmCode_Specified;
    property SaleType:          string      Index (IS_OPTN) read FSaleType write SetSaleType stored SaleType_Specified;
    property PrimaryPrice:      TXSDecimal  read FPrimaryPrice write FPrimaryPrice;
    property PrimaryAmount:     TXSDecimal  read FPrimaryAmount write FPrimaryAmount;
    property RequestedPrice:    TXSDecimal  read FRequestedPrice write FRequestedPrice;
    property RequestedAmount:   TXSDecimal  read FRequestedAmount write FRequestedAmount;
    property RequestedQuantity: TXSDecimal  read FRequestedQuantity write FRequestedQuantity;
    property ProductFormCode:   string      Index (IS_OPTN) read FProductFormCode write SetProductFormCode stored ProductFormCode_Specified;
  end;

  ArrayOfCardSaleRequestItem = array of CardSaleRequestItem;   { "http://tempuri.org/"[GblCplx] }


  // ************************************************************************ //
  // XML       : CardSaleRequest, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  CardSaleRequest = class(TRemotable)
  private
    FCheckId: string;
    FCheckId_Specified: boolean;
    FCheckCode: string;
    FCheckCode_Specified: boolean;
    FCheckDate: TXSDateTime;
    FMdmCode: string;
    FMdmCode_Specified: boolean;
    FSaleType: string;
    FSaleType_Specified: boolean;
    FProductFormCode: string;
    FProductFormCode_Specified: boolean;
    FItems: ArrayOfCardSaleRequestItem;
    FItems_Specified: boolean;
    procedure SetCheckId(Index: Integer; const Astring: string);
    function  CheckId_Specified(Index: Integer): boolean;
    procedure SetCheckCode(Index: Integer; const Astring: string);
    function  CheckCode_Specified(Index: Integer): boolean;
    procedure SetMdmCode(Index: Integer; const Astring: string);
    function  MdmCode_Specified(Index: Integer): boolean;
    procedure SetSaleType(Index: Integer; const Astring: string);
    function  SaleType_Specified(Index: Integer): boolean;
    procedure SetProductFormCode(Index: Integer; const Astring: string);
    function  ProductFormCode_Specified(Index: Integer): boolean;
    procedure SetItems(Index: Integer; const AArrayOfCardSaleRequestItem: ArrayOfCardSaleRequestItem);
    function  Items_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property CheckId:         string                      Index (IS_OPTN) read FCheckId write SetCheckId stored CheckId_Specified;
    property CheckCode:       string                      Index (IS_OPTN) read FCheckCode write SetCheckCode stored CheckCode_Specified;
    property CheckDate:       TXSDateTime                 read FCheckDate write FCheckDate;
    property MdmCode:         string                      Index (IS_OPTN) read FMdmCode write SetMdmCode stored MdmCode_Specified;
    property SaleType:        string                      Index (IS_OPTN) read FSaleType write SetSaleType stored SaleType_Specified;
    property ProductFormCode: string                      Index (IS_OPTN) read FProductFormCode write SetProductFormCode stored ProductFormCode_Specified;
    property Items:           ArrayOfCardSaleRequestItem  Index (IS_OPTN) read FItems write SetItems stored Items_Specified;
  end;

  ArrayOfCardSaleResultItem = array of CardSaleResultItem;   { "http://tempuri.org/"[GblCplx] }


  // ************************************************************************ //
  // XML       : CardSaleResult, global, <complexType>
  // Namespace : http://tempuri.org/
  // ************************************************************************ //
  CardSaleResult = class(TRemotable)
  private
    FCheckId: string;
    FCheckId_Specified: boolean;
    FCheckCode: string;
    FCheckCode_Specified: boolean;
    FCheckDate: TXSDateTime;
    FResultStatus: string;
    FResultStatus_Specified: boolean;
    FResultDescription: string;
    FResultDescription_Specified: boolean;
    FResultTransactionId: string;
    FResultTransactionId_Specified: boolean;
    FMdmCode: string;
    FMdmCode_Specified: boolean;
    FProductFormCode: string;
    FProductFormCode_Specified: boolean;
    FSaleType: string;
    FSaleType_Specified: boolean;
    FItems: ArrayOfCardSaleResultItem;
    FItems_Specified: boolean;
    procedure SetCheckId(Index: Integer; const Astring: string);
    function  CheckId_Specified(Index: Integer): boolean;
    procedure SetCheckCode(Index: Integer; const Astring: string);
    function  CheckCode_Specified(Index: Integer): boolean;
    procedure SetResultStatus(Index: Integer; const Astring: string);
    function  ResultStatus_Specified(Index: Integer): boolean;
    procedure SetResultDescription(Index: Integer; const Astring: string);
    function  ResultDescription_Specified(Index: Integer): boolean;
    procedure SetResultTransactionId(Index: Integer; const Astring: string);
    function  ResultTransactionId_Specified(Index: Integer): boolean;
    procedure SetMdmCode(Index: Integer; const Astring: string);
    function  MdmCode_Specified(Index: Integer): boolean;
    procedure SetProductFormCode(Index: Integer; const Astring: string);
    function  ProductFormCode_Specified(Index: Integer): boolean;
    procedure SetSaleType(Index: Integer; const Astring: string);
    function  SaleType_Specified(Index: Integer): boolean;
    procedure SetItems(Index: Integer; const AArrayOfCardSaleResultItem: ArrayOfCardSaleResultItem);
    function  Items_Specified(Index: Integer): boolean;
  public
    destructor Destroy; override;
  published
    property CheckId:             string                     Index (IS_OPTN) read FCheckId write SetCheckId stored CheckId_Specified;
    property CheckCode:           string                     Index (IS_OPTN) read FCheckCode write SetCheckCode stored CheckCode_Specified;
    property CheckDate:           TXSDateTime                read FCheckDate write FCheckDate;
    property ResultStatus:        string                     Index (IS_OPTN) read FResultStatus write SetResultStatus stored ResultStatus_Specified;
    property ResultDescription:   string                     Index (IS_OPTN) read FResultDescription write SetResultDescription stored ResultDescription_Specified;
    property ResultTransactionId: string                     Index (IS_OPTN) read FResultTransactionId write SetResultTransactionId stored ResultTransactionId_Specified;
    property MdmCode:             string                     Index (IS_OPTN) read FMdmCode write SetMdmCode stored MdmCode_Specified;
    property ProductFormCode:     string                     Index (IS_OPTN) read FProductFormCode write SetProductFormCode stored ProductFormCode_Specified;
    property SaleType:            string                     Index (IS_OPTN) read FSaleType write SetSaleType stored SaleType_Specified;
    property Items:               ArrayOfCardSaleResultItem  Index (IS_OPTN) read FItems write SetItems stored Items_Specified;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // soapAction: http://tempuri.org/%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : CardServiceSoap
  // service   : CardService
  // port      : CardServiceSoap
  // URL       : http://exim.demo.mdmworld.com/CardService.asmx
  // ************************************************************************ //
  CardServiceSoap = interface(IInvokable)
  ['{CFEF90BA-B382-AE6D-B035-2FB25A94CECE}']
    function  checkCard(const aMdmCode: string; const aLoginName: string; const aLoginPassword: string): string; stdcall;
    function  checkCardSale(const aSaleList: ArrayOfCardCheckItem; const aLoginName: string; const aLoginPassword: string): ArrayOfCardCheckResultItem; stdcall;
    function  commitCardSale(const aSaleRequest: CardSaleRequest; const aLoginName: string; const aLoginPassword: string): CardSaleResult; stdcall;
    function  commitOrder(const aOrderRequest: OrderRequest; const aLoginName: string; const aLoginPassword: string): OrderResult; stdcall;
    function  checkCardSynevo(const aMdmCode: string; const aLoginName: string; const aLoginPassword: string): ArrayOfString; stdcall;
    function  commitCardSynevo(const aMdmCode: string; const synevoResult: ArrayOfSynevoResult; const aLoginName: string; const aLoginPassword: string): string; stdcall;
    function  commitCardChange(const aMdmCodeOld: string; const aMdmCodeNew: string; const aLoginName: string; const aLoginPassword: string): string; stdcall;
    function  GetErrorInfoStack: string; stdcall;
  end;

function GetCardServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): CardServiceSoap;


implementation
  uses SysUtils;

function GetCardServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): CardServiceSoap;
const
  defWSDL = 'http://exim.demo.mdmworld.com/CardService.asmx?WSDL';
  defURL  = 'http://exim.demo.mdmworld.com/CardService.asmx';
  defSvc  = 'CardService';
  defPrt  = 'CardServiceSoap';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as CardServiceSoap);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


destructor CardCheckItem.Destroy;
begin
  SysUtils.FreeAndNil(FRequestedPrice);
  SysUtils.FreeAndNil(FRequestedQuantity);
  SysUtils.FreeAndNil(FRequestedAmount);
  inherited Destroy;
end;

procedure CardCheckItem.SetMdmCode(Index: Integer; const Astring: string);
begin
  FMdmCode := Astring;
  FMdmCode_Specified := True;
end;

function CardCheckItem.MdmCode_Specified(Index: Integer): boolean;
begin
  Result := FMdmCode_Specified;
end;

procedure CardCheckItem.SetProductFormCode(Index: Integer; const Astring: string);
begin
  FProductFormCode := Astring;
  FProductFormCode_Specified := True;
end;

function CardCheckItem.ProductFormCode_Specified(Index: Integer): boolean;
begin
  Result := FProductFormCode_Specified;
end;

procedure CardCheckItem.SetSaleType(Index: Integer; const Astring: string);
begin
  FSaleType := Astring;
  FSaleType_Specified := True;
end;

function CardCheckItem.SaleType_Specified(Index: Integer): boolean;
begin
  Result := FSaleType_Specified;
end;

destructor CardCheckResultItem.Destroy;
begin
  SysUtils.FreeAndNil(FRequestedPrice);
  SysUtils.FreeAndNil(FRequestedQuantity);
  SysUtils.FreeAndNil(FRequestedAmount);
  inherited Destroy;
end;

procedure CardCheckResultItem.SetMdmCode(Index: Integer; const Astring: string);
begin
  FMdmCode := Astring;
  FMdmCode_Specified := True;
end;

function CardCheckResultItem.MdmCode_Specified(Index: Integer): boolean;
begin
  Result := FMdmCode_Specified;
end;

procedure CardCheckResultItem.SetProductFormCode(Index: Integer; const Astring: string);
begin
  FProductFormCode := Astring;
  FProductFormCode_Specified := True;
end;

function CardCheckResultItem.ProductFormCode_Specified(Index: Integer): boolean;
begin
  Result := FProductFormCode_Specified;
end;

procedure CardCheckResultItem.SetSaleType(Index: Integer; const Astring: string);
begin
  FSaleType := Astring;
  FSaleType_Specified := True;
end;

function CardCheckResultItem.SaleType_Specified(Index: Integer): boolean;
begin
  Result := FSaleType_Specified;
end;

procedure CardCheckResultItem.SetResultStatus(Index: Integer; const Astring: string);
begin
  FResultStatus := Astring;
  FResultStatus_Specified := True;
end;

function CardCheckResultItem.ResultStatus_Specified(Index: Integer): boolean;
begin
  Result := FResultStatus_Specified;
end;

procedure CardCheckResultItem.SetResultDescription(Index: Integer; const Astring: string);
begin
  FResultDescription := Astring;
  FResultDescription_Specified := True;
end;

function CardCheckResultItem.ResultDescription_Specified(Index: Integer): boolean;
begin
  Result := FResultDescription_Specified;
end;

destructor SynevoResult.Destroy;
begin
  SysUtils.FreeAndNil(FAnalysisDate);
  SysUtils.FreeAndNil(FValue);
  inherited Destroy;
end;

procedure SynevoResult.SetCode(Index: Integer; const Astring: string);
begin
  FCode := Astring;
  FCode_Specified := True;
end;

function SynevoResult.Code_Specified(Index: Integer): boolean;
begin
  Result := FCode_Specified;
end;

destructor OrderRequest.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FItems)-1 do
    SysUtils.FreeAndNil(FItems[I]);
  System.SetLength(FItems, 0);
  SysUtils.FreeAndNil(FOrderDate);
  inherited Destroy;
end;

procedure OrderRequest.SetOrderId(Index: Integer; const Astring: string);
begin
  FOrderId := Astring;
  FOrderId_Specified := True;
end;

function OrderRequest.OrderId_Specified(Index: Integer): boolean;
begin
  Result := FOrderId_Specified;
end;

procedure OrderRequest.SetOrderCode(Index: Integer; const Astring: string);
begin
  FOrderCode := Astring;
  FOrderCode_Specified := True;
end;

function OrderRequest.OrderCode_Specified(Index: Integer): boolean;
begin
  Result := FOrderCode_Specified;
end;

procedure OrderRequest.SetOrderType(Index: Integer; const Astring: string);
begin
  FOrderType := Astring;
  FOrderType_Specified := True;
end;

function OrderRequest.OrderType_Specified(Index: Integer): boolean;
begin
  Result := FOrderType_Specified;
end;

procedure OrderRequest.SetOrganizationFromCode(Index: Integer; const Astring: string);
begin
  FOrganizationFromCode := Astring;
  FOrganizationFromCode_Specified := True;
end;

function OrderRequest.OrganizationFromCode_Specified(Index: Integer): boolean;
begin
  Result := FOrganizationFromCode_Specified;
end;

procedure OrderRequest.SetOrganizationFromName(Index: Integer; const Astring: string);
begin
  FOrganizationFromName := Astring;
  FOrganizationFromName_Specified := True;
end;

function OrderRequest.OrganizationFromName_Specified(Index: Integer): boolean;
begin
  Result := FOrganizationFromName_Specified;
end;

procedure OrderRequest.SetOrganizationToCode(Index: Integer; const Astring: string);
begin
  FOrganizationToCode := Astring;
  FOrganizationToCode_Specified := True;
end;

function OrderRequest.OrganizationToCode_Specified(Index: Integer): boolean;
begin
  Result := FOrganizationToCode_Specified;
end;

procedure OrderRequest.SetOrganizationToName(Index: Integer; const Astring: string);
begin
  FOrganizationToName := Astring;
  FOrganizationToName_Specified := True;
end;

function OrderRequest.OrganizationToName_Specified(Index: Integer): boolean;
begin
  Result := FOrganizationToName_Specified;
end;

procedure OrderRequest.SetItems(Index: Integer; const AArrayOfOrderRequestItem: ArrayOfOrderRequestItem);
begin
  FItems := AArrayOfOrderRequestItem;
  FItems_Specified := True;
end;

function OrderRequest.Items_Specified(Index: Integer): boolean;
begin
  Result := FItems_Specified;
end;

procedure OrderResult.SetResultStatus(Index: Integer; const Astring: string);
begin
  FResultStatus := Astring;
  FResultStatus_Specified := True;
end;

function OrderResult.ResultStatus_Specified(Index: Integer): boolean;
begin
  Result := FResultStatus_Specified;
end;

procedure OrderResult.SetResultDescription(Index: Integer; const Astring: string);
begin
  FResultDescription := Astring;
  FResultDescription_Specified := True;
end;

function OrderResult.ResultDescription_Specified(Index: Integer): boolean;
begin
  Result := FResultDescription_Specified;
end;

destructor OrderRequestItem.Destroy;
begin
  SysUtils.FreeAndNil(FQuantity);
  inherited Destroy;
end;

procedure OrderRequestItem.SetProductFormCode(Index: Integer; const Astring: string);
begin
  FProductFormCode := Astring;
  FProductFormCode_Specified := True;
end;

function OrderRequestItem.ProductFormCode_Specified(Index: Integer): boolean;
begin
  Result := FProductFormCode_Specified;
end;

procedure OrderRequestItem.SetSaleType(Index: Integer; const Astring: string);
begin
  FSaleType := Astring;
  FSaleType_Specified := True;
end;

function OrderRequestItem.SaleType_Specified(Index: Integer): boolean;
begin
  Result := FSaleType_Specified;
end;

destructor CardSaleResultItem.Destroy;
begin
  SysUtils.FreeAndNil(FPrimaryPrice);
  SysUtils.FreeAndNil(FPrimaryAmount);
  SysUtils.FreeAndNil(FRequestedPrice);
  SysUtils.FreeAndNil(FRequestedAmount);
  SysUtils.FreeAndNil(FRequestedQuantity);
  inherited Destroy;
end;

procedure CardSaleResultItem.SetProductFormCode(Index: Integer; const Astring: string);
begin
  FProductFormCode := Astring;
  FProductFormCode_Specified := True;
end;

function CardSaleResultItem.ProductFormCode_Specified(Index: Integer): boolean;
begin
  Result := FProductFormCode_Specified;
end;

procedure CardSaleResultItem.SetResultTransactionId(Index: Integer; const Astring: string);
begin
  FResultTransactionId := Astring;
  FResultTransactionId_Specified := True;
end;

function CardSaleResultItem.ResultTransactionId_Specified(Index: Integer): boolean;
begin
  Result := FResultTransactionId_Specified;
end;

procedure CardSaleResultItem.SetResultStatus(Index: Integer; const Astring: string);
begin
  FResultStatus := Astring;
  FResultStatus_Specified := True;
end;

function CardSaleResultItem.ResultStatus_Specified(Index: Integer): boolean;
begin
  Result := FResultStatus_Specified;
end;

procedure CardSaleResultItem.SetResultDescription(Index: Integer; const Astring: string);
begin
  FResultDescription := Astring;
  FResultDescription_Specified := True;
end;

function CardSaleResultItem.ResultDescription_Specified(Index: Integer): boolean;
begin
  Result := FResultDescription_Specified;
end;

procedure CardSaleResultItem.SetMedicineSaleId(Index: Integer; const Astring: string);
begin
  FMedicineSaleId := Astring;
  FMedicineSaleId_Specified := True;
end;

function CardSaleResultItem.MedicineSaleId_Specified(Index: Integer): boolean;
begin
  Result := FMedicineSaleId_Specified;
end;

destructor CardSaleRequestItem.Destroy;
begin
  SysUtils.FreeAndNil(FPrimaryPrice);
  SysUtils.FreeAndNil(FPrimaryAmount);
  SysUtils.FreeAndNil(FRequestedPrice);
  SysUtils.FreeAndNil(FRequestedAmount);
  SysUtils.FreeAndNil(FRequestedQuantity);
  inherited Destroy;
end;

procedure CardSaleRequestItem.SetItemId(Index: Integer; const Astring: string);
begin
  FItemId := Astring;
  FItemId_Specified := True;
end;

function CardSaleRequestItem.ItemId_Specified(Index: Integer): boolean;
begin
  Result := FItemId_Specified;
end;

procedure CardSaleRequestItem.SetMdmCode(Index: Integer; const Astring: string);
begin
  FMdmCode := Astring;
  FMdmCode_Specified := True;
end;

function CardSaleRequestItem.MdmCode_Specified(Index: Integer): boolean;
begin
  Result := FMdmCode_Specified;
end;

procedure CardSaleRequestItem.SetSaleType(Index: Integer; const Astring: string);
begin
  FSaleType := Astring;
  FSaleType_Specified := True;
end;

function CardSaleRequestItem.SaleType_Specified(Index: Integer): boolean;
begin
  Result := FSaleType_Specified;
end;

procedure CardSaleRequestItem.SetProductFormCode(Index: Integer; const Astring: string);
begin
  FProductFormCode := Astring;
  FProductFormCode_Specified := True;
end;

function CardSaleRequestItem.ProductFormCode_Specified(Index: Integer): boolean;
begin
  Result := FProductFormCode_Specified;
end;

destructor CardSaleRequest.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FItems)-1 do
    SysUtils.FreeAndNil(FItems[I]);
  System.SetLength(FItems, 0);
  SysUtils.FreeAndNil(FCheckDate);
  inherited Destroy;
end;

procedure CardSaleRequest.SetCheckId(Index: Integer; const Astring: string);
begin
  FCheckId := Astring;
  FCheckId_Specified := True;
end;

function CardSaleRequest.CheckId_Specified(Index: Integer): boolean;
begin
  Result := FCheckId_Specified;
end;

procedure CardSaleRequest.SetCheckCode(Index: Integer; const Astring: string);
begin
  FCheckCode := Astring;
  FCheckCode_Specified := True;
end;

function CardSaleRequest.CheckCode_Specified(Index: Integer): boolean;
begin
  Result := FCheckCode_Specified;
end;

procedure CardSaleRequest.SetMdmCode(Index: Integer; const Astring: string);
begin
  FMdmCode := Astring;
  FMdmCode_Specified := True;
end;

function CardSaleRequest.MdmCode_Specified(Index: Integer): boolean;
begin
  Result := FMdmCode_Specified;
end;

procedure CardSaleRequest.SetSaleType(Index: Integer; const Astring: string);
begin
  FSaleType := Astring;
  FSaleType_Specified := True;
end;

function CardSaleRequest.SaleType_Specified(Index: Integer): boolean;
begin
  Result := FSaleType_Specified;
end;

procedure CardSaleRequest.SetProductFormCode(Index: Integer; const Astring: string);
begin
  FProductFormCode := Astring;
  FProductFormCode_Specified := True;
end;

function CardSaleRequest.ProductFormCode_Specified(Index: Integer): boolean;
begin
  Result := FProductFormCode_Specified;
end;

procedure CardSaleRequest.SetItems(Index: Integer; const AArrayOfCardSaleRequestItem: ArrayOfCardSaleRequestItem);
begin
  FItems := AArrayOfCardSaleRequestItem;
  FItems_Specified := True;
end;

function CardSaleRequest.Items_Specified(Index: Integer): boolean;
begin
  Result := FItems_Specified;
end;

destructor CardSaleResult.Destroy;
var
  I: Integer;
begin
  for I := 0 to System.Length(FItems)-1 do
    SysUtils.FreeAndNil(FItems[I]);
  System.SetLength(FItems, 0);
  SysUtils.FreeAndNil(FCheckDate);
  inherited Destroy;
end;

procedure CardSaleResult.SetCheckId(Index: Integer; const Astring: string);
begin
  FCheckId := Astring;
  FCheckId_Specified := True;
end;

function CardSaleResult.CheckId_Specified(Index: Integer): boolean;
begin
  Result := FCheckId_Specified;
end;

procedure CardSaleResult.SetCheckCode(Index: Integer; const Astring: string);
begin
  FCheckCode := Astring;
  FCheckCode_Specified := True;
end;

function CardSaleResult.CheckCode_Specified(Index: Integer): boolean;
begin
  Result := FCheckCode_Specified;
end;

procedure CardSaleResult.SetResultStatus(Index: Integer; const Astring: string);
begin
  FResultStatus := Astring;
  FResultStatus_Specified := True;
end;

function CardSaleResult.ResultStatus_Specified(Index: Integer): boolean;
begin
  Result := FResultStatus_Specified;
end;

procedure CardSaleResult.SetResultDescription(Index: Integer; const Astring: string);
begin
  FResultDescription := Astring;
  FResultDescription_Specified := True;
end;

function CardSaleResult.ResultDescription_Specified(Index: Integer): boolean;
begin
  Result := FResultDescription_Specified;
end;

procedure CardSaleResult.SetResultTransactionId(Index: Integer; const Astring: string);
begin
  FResultTransactionId := Astring;
  FResultTransactionId_Specified := True;
end;

function CardSaleResult.ResultTransactionId_Specified(Index: Integer): boolean;
begin
  Result := FResultTransactionId_Specified;
end;

procedure CardSaleResult.SetMdmCode(Index: Integer; const Astring: string);
begin
  FMdmCode := Astring;
  FMdmCode_Specified := True;
end;

function CardSaleResult.MdmCode_Specified(Index: Integer): boolean;
begin
  Result := FMdmCode_Specified;
end;

procedure CardSaleResult.SetProductFormCode(Index: Integer; const Astring: string);
begin
  FProductFormCode := Astring;
  FProductFormCode_Specified := True;
end;

function CardSaleResult.ProductFormCode_Specified(Index: Integer): boolean;
begin
  Result := FProductFormCode_Specified;
end;

procedure CardSaleResult.SetSaleType(Index: Integer; const Astring: string);
begin
  FSaleType := Astring;
  FSaleType_Specified := True;
end;

function CardSaleResult.SaleType_Specified(Index: Integer): boolean;
begin
  Result := FSaleType_Specified;
end;

procedure CardSaleResult.SetItems(Index: Integer; const AArrayOfCardSaleResultItem: ArrayOfCardSaleResultItem);
begin
  FItems := AArrayOfCardSaleResultItem;
  FItems_Specified := True;
end;

function CardSaleResult.Items_Specified(Index: Integer): boolean;
begin
  Result := FItems_Specified;
end;

initialization
  { CardServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(CardServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(CardServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(CardServiceSoap), ioDocument);
  { CardServiceSoap.checkCard }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'checkCard', '',
                                 '[ReturnName="checkCardResult"]', IS_OPTN);
  { CardServiceSoap.checkCardSale }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'checkCardSale', '',
                                 '[ReturnName="checkCardSaleResult"]', IS_OPTN);
  InvRegistry.RegisterParamInfo(TypeInfo(CardServiceSoap), 'checkCardSale', 'aSaleList', '',
                                '[ArrayItemName="CardCheckItem"]');
  InvRegistry.RegisterParamInfo(TypeInfo(CardServiceSoap), 'checkCardSale', 'checkCardSaleResult', '',
                                '[ArrayItemName="CardCheckResultItem"]');
  { CardServiceSoap.commitCardSale }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'commitCardSale', '',
                                 '[ReturnName="commitCardSaleResult"]', IS_OPTN);
  { CardServiceSoap.commitOrder }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'commitOrder', '',
                                 '[ReturnName="commitOrderResult"]', IS_OPTN);
  { CardServiceSoap.checkCardSynevo }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'checkCardSynevo', '',
                                 '[ReturnName="checkCardSynevoResult"]', IS_OPTN);
  InvRegistry.RegisterParamInfo(TypeInfo(CardServiceSoap), 'checkCardSynevo', 'checkCardSynevoResult', '',
                                '[ArrayItemName="string"]');
  { CardServiceSoap.commitCardSynevo }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'commitCardSynevo', '',
                                 '[ReturnName="commitCardSynevoResult"]', IS_OPTN);
  InvRegistry.RegisterParamInfo(TypeInfo(CardServiceSoap), 'commitCardSynevo', 'synevoResult', '',
                                '[ArrayItemName="SynevoResult"]');
  { CardServiceSoap.commitCardChange }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'commitCardChange', '',
                                 '[ReturnName="commitCardChangeResult"]', IS_OPTN);
  { CardServiceSoap.GetErrorInfoStack }
  InvRegistry.RegisterMethodInfo(TypeInfo(CardServiceSoap), 'GetErrorInfoStack', '',
                                 '[ReturnName="GetErrorInfoStackResult"]', IS_OPTN);
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfSynevoResult), 'http://tempuri.org/', 'ArrayOfSynevoResult');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfCardCheckResultItem), 'http://tempuri.org/', 'ArrayOfCardCheckResultItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfCardCheckItem), 'http://tempuri.org/', 'ArrayOfCardCheckItem');
  RemClassRegistry.RegisterXSClass(CardCheckItem, 'http://tempuri.org/', 'CardCheckItem');
  RemClassRegistry.RegisterXSClass(CardCheckResultItem, 'http://tempuri.org/', 'CardCheckResultItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfString), 'http://tempuri.org/', 'ArrayOfString');
  RemClassRegistry.RegisterXSClass(SynevoResult, 'http://tempuri.org/', 'SynevoResult');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfOrderRequestItem), 'http://tempuri.org/', 'ArrayOfOrderRequestItem');
  RemClassRegistry.RegisterXSClass(OrderRequest, 'http://tempuri.org/', 'OrderRequest');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(OrderRequest), 'Items', '[ArrayItemName="OrderRequestItem"]');
  RemClassRegistry.RegisterXSClass(OrderResult, 'http://tempuri.org/', 'OrderResult');
  RemClassRegistry.RegisterXSClass(OrderRequestItem, 'http://tempuri.org/', 'OrderRequestItem');
  RemClassRegistry.RegisterXSClass(CardSaleResultItem, 'http://tempuri.org/', 'CardSaleResultItem');
  RemClassRegistry.RegisterXSClass(CardSaleRequestItem, 'http://tempuri.org/', 'CardSaleRequestItem');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfCardSaleRequestItem), 'http://tempuri.org/', 'ArrayOfCardSaleRequestItem');
  RemClassRegistry.RegisterXSClass(CardSaleRequest, 'http://tempuri.org/', 'CardSaleRequest');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(CardSaleRequest), 'Items', '[ArrayItemName="CardSaleRequestItem"]');
  RemClassRegistry.RegisterXSInfo(TypeInfo(ArrayOfCardSaleResultItem), 'http://tempuri.org/', 'ArrayOfCardSaleResultItem');
  RemClassRegistry.RegisterXSClass(CardSaleResult, 'http://tempuri.org/', 'CardSaleResult');
  RemClassRegistry.RegisterExternalPropName(TypeInfo(CardSaleResult), 'Items', '[ArrayItemName="CardSaleResultItem"]');

end.