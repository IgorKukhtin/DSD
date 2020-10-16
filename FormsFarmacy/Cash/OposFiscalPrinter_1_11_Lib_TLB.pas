unit OposFiscalPrinter_1_11_Lib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 98336 $
// File generated on 14.10.2020 23:47:21 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\SysWow64\OPOSFiscalPrinter.ocx (1)
// LIBID: {CCB90070-B81E-11D2-AB74-0040054C3719}
// LCID: 0
// Helpfile: 
// HelpString: OPOS FiscalPrinter Control 1.11.000 [Public, by CRM/RCS-Dayton]
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleCtrls, Vcl.OleServer, Winapi.ActiveX;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  OposFiscalPrinter_1_11_LibMajorVersion = 1;
  OposFiscalPrinter_1_11_LibMinorVersion = 0;

  LIBID_OposFiscalPrinter_1_11_Lib: TGUID = '{CCB90070-B81E-11D2-AB74-0040054C3719}';

  DIID__IOPOSFiscalPrinterEvents: TGUID = '{CCB90073-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter: TGUID = '{CCB95071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter14: TGUID = '{CCB90071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter15: TGUID = '{CCB91071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter16: TGUID = '{CCB92071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter18: TGUID = '{CCB93071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter19: TGUID = '{CCB94071-B81E-11D2-AB74-0040054C3719}';
  CLASS_OPOSFiscalPrinter: TGUID = '{CCB90072-B81E-11D2-AB74-0040054C3719}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IOPOSFiscalPrinterEvents = dispinterface;
  IOPOSFiscalPrinter = interface;
  IOPOSFiscalPrinterDisp = dispinterface;
  IOPOSFiscalPrinter14 = interface;
  IOPOSFiscalPrinter14Disp = dispinterface;
  IOPOSFiscalPrinter15 = interface;
  IOPOSFiscalPrinter15Disp = dispinterface;
  IOPOSFiscalPrinter16 = interface;
  IOPOSFiscalPrinter16Disp = dispinterface;
  IOPOSFiscalPrinter18 = interface;
  IOPOSFiscalPrinter18Disp = dispinterface;
  IOPOSFiscalPrinter19 = interface;
  IOPOSFiscalPrinter19Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  OPOSFiscalPrinter = IOPOSFiscalPrinter;


// *********************************************************************//
// DispIntf:  _IOPOSFiscalPrinterEvents
// Flags:     (4096) Dispatchable
// GUID:      {CCB90073-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  _IOPOSFiscalPrinterEvents = dispinterface
    ['{CCB90073-B81E-11D2-AB74-0040054C3719}']
    procedure DirectIOEvent(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure ErrorEvent(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                         var pErrorResponse: Integer); dispid 3;
    procedure OutputCompleteEvent(OutputID: Integer); dispid 4;
    procedure StatusUpdateEvent(Data: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB95071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter = interface(IDispatch)
    ['{CCB95071-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); safecall;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); safecall;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); safecall;
    procedure SOOutputComplete(OutputID: Integer); safecall;
    procedure SOStatusUpdate(Data: Integer); safecall;
    function SOProcessID: Integer; safecall;
    function Get_OpenResult: Integer; safecall;
    function Get_BinaryConversion: Integer; safecall;
    procedure Set_BinaryConversion(pBinaryConversion: Integer); safecall;
    function Get_CapPowerReporting: Integer; safecall;
    function Get_CheckHealthText: WideString; safecall;
    function Get_Claimed: WordBool; safecall;
    function Get_DeviceEnabled: WordBool; safecall;
    procedure Set_DeviceEnabled(pDeviceEnabled: WordBool); safecall;
    function Get_FreezeEvents: WordBool; safecall;
    procedure Set_FreezeEvents(pFreezeEvents: WordBool); safecall;
    function Get_OutputID: Integer; safecall;
    function Get_PowerNotify: Integer; safecall;
    procedure Set_PowerNotify(pPowerNotify: Integer); safecall;
    function Get_PowerState: Integer; safecall;
    function Get_ResultCode: Integer; safecall;
    function Get_ResultCodeExtended: Integer; safecall;
    function Get_State: Integer; safecall;
    function Get_ControlObjectDescription: WideString; safecall;
    function Get_ControlObjectVersion: Integer; safecall;
    function Get_ServiceObjectDescription: WideString; safecall;
    function Get_ServiceObjectVersion: Integer; safecall;
    function Get_DeviceDescription: WideString; safecall;
    function Get_DeviceName: WideString; safecall;
    function CheckHealth(Level: Integer): Integer; safecall;
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function ClearOutput: Integer; safecall;
    function Close: Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function Open(const DeviceName: WideString): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function Get_AmountDecimalPlaces: Integer; safecall;
    function Get_AsyncMode: WordBool; safecall;
    procedure Set_AsyncMode(pAsyncMode: WordBool); safecall;
    function Get_CapAdditionalLines: WordBool; safecall;
    function Get_CapAmountAdjustment: WordBool; safecall;
    function Get_CapAmountNotPaid: WordBool; safecall;
    function Get_CapCheckTotal: WordBool; safecall;
    function Get_CapCoverSensor: WordBool; safecall;
    function Get_CapDoubleWidth: WordBool; safecall;
    function Get_CapDuplicateReceipt: WordBool; safecall;
    function Get_CapFixedOutput: WordBool; safecall;
    function Get_CapHasVatTable: WordBool; safecall;
    function Get_CapIndependentHeader: WordBool; safecall;
    function Get_CapItemList: WordBool; safecall;
    function Get_CapJrnEmptySensor: WordBool; safecall;
    function Get_CapJrnNearEndSensor: WordBool; safecall;
    function Get_CapJrnPresent: WordBool; safecall;
    function Get_CapNonFiscalMode: WordBool; safecall;
    function Get_CapOrderAdjustmentFirst: WordBool; safecall;
    function Get_CapPercentAdjustment: WordBool; safecall;
    function Get_CapPositiveAdjustment: WordBool; safecall;
    function Get_CapPowerLossReport: WordBool; safecall;
    function Get_CapPredefinedPaymentLines: WordBool; safecall;
    function Get_CapReceiptNotPaid: WordBool; safecall;
    function Get_CapRecEmptySensor: WordBool; safecall;
    function Get_CapRecNearEndSensor: WordBool; safecall;
    function Get_CapRecPresent: WordBool; safecall;
    function Get_CapRemainingFiscalMemory: WordBool; safecall;
    function Get_CapReservedWord: WordBool; safecall;
    function Get_CapSetHeader: WordBool; safecall;
    function Get_CapSetPOSID: WordBool; safecall;
    function Get_CapSetStoreFiscalID: WordBool; safecall;
    function Get_CapSetTrailer: WordBool; safecall;
    function Get_CapSetVatTable: WordBool; safecall;
    function Get_CapSlpEmptySensor: WordBool; safecall;
    function Get_CapSlpFiscalDocument: WordBool; safecall;
    function Get_CapSlpFullSlip: WordBool; safecall;
    function Get_CapSlpNearEndSensor: WordBool; safecall;
    function Get_CapSlpPresent: WordBool; safecall;
    function Get_CapSlpValidation: WordBool; safecall;
    function Get_CapSubAmountAdjustment: WordBool; safecall;
    function Get_CapSubPercentAdjustment: WordBool; safecall;
    function Get_CapSubtotal: WordBool; safecall;
    function Get_CapTrainingMode: WordBool; safecall;
    function Get_CapValidateJournal: WordBool; safecall;
    function Get_CapXReport: WordBool; safecall;
    function Get_CheckTotal: WordBool; safecall;
    procedure Set_CheckTotal(pCheckTotal: WordBool); safecall;
    function Get_CountryCode: Integer; safecall;
    function Get_CoverOpen: WordBool; safecall;
    function Get_DayOpened: WordBool; safecall;
    function Get_DescriptionLength: Integer; safecall;
    function Get_DuplicateReceipt: WordBool; safecall;
    procedure Set_DuplicateReceipt(pDuplicateReceipt: WordBool); safecall;
    function Get_ErrorLevel: Integer; safecall;
    function Get_ErrorOutID: Integer; safecall;
    function Get_ErrorState: Integer; safecall;
    function Get_ErrorStation: Integer; safecall;
    function Get_ErrorString: WideString; safecall;
    function Get_FlagWhenIdle: WordBool; safecall;
    procedure Set_FlagWhenIdle(pFlagWhenIdle: WordBool); safecall;
    function Get_JrnEmpty: WordBool; safecall;
    function Get_JrnNearEnd: WordBool; safecall;
    function Get_MessageLength: Integer; safecall;
    function Get_NumHeaderLines: Integer; safecall;
    function Get_NumTrailerLines: Integer; safecall;
    function Get_NumVatRates: Integer; safecall;
    function Get_PredefinedPaymentLines: WideString; safecall;
    function Get_PrinterState: Integer; safecall;
    function Get_QuantityDecimalPlaces: Integer; safecall;
    function Get_QuantityLength: Integer; safecall;
    function Get_RecEmpty: WordBool; safecall;
    function Get_RecNearEnd: WordBool; safecall;
    function Get_RemainingFiscalMemory: Integer; safecall;
    function Get_ReservedWord: WideString; safecall;
    function Get_SlipSelection: Integer; safecall;
    procedure Set_SlipSelection(pSlipSelection: Integer); safecall;
    function Get_SlpEmpty: WordBool; safecall;
    function Get_SlpNearEnd: WordBool; safecall;
    function Get_TrainingModeActive: WordBool; safecall;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; safecall;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; safecall;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; safecall;
    function BeginInsertion(Timeout: Integer): Integer; safecall;
    function BeginItemList(VatID: Integer): Integer; safecall;
    function BeginNonFiscal: Integer; safecall;
    function BeginRemoval(Timeout: Integer): Integer; safecall;
    function BeginTraining: Integer; safecall;
    function ClearError: Integer; safecall;
    function EndFiscalDocument: Integer; safecall;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; safecall;
    function EndFixedOutput: Integer; safecall;
    function EndInsertion: Integer; safecall;
    function EndItemList: Integer; safecall;
    function EndNonFiscal: Integer; safecall;
    function EndRemoval: Integer; safecall;
    function EndTraining: Integer; safecall;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; safecall;
    function GetDate(out Date: WideString): Integer; safecall;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; safecall;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; safecall;
    function PrintDuplicateReceipt: Integer; safecall;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; safecall;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; safecall;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; safecall;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; safecall;
    function PrintPowerLossReport: Integer; safecall;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; safecall;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecMessage(const Message: WideString): Integer; safecall;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; safecall;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecSubtotal(Amount: Currency): Integer; safecall;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; safecall;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; safecall;
    function PrintRecVoid(const Description: WideString): Integer; safecall;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; safecall;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; safecall;
    function PrintXReport: Integer; safecall;
    function PrintZReport: Integer; safecall;
    function ResetPrinter: Integer; safecall;
    function SetDate(const Date: WideString): Integer; safecall;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; safecall;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; safecall;
    function SetStoreFiscalID(const ID: WideString): Integer; safecall;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; safecall;
    function SetVatTable: Integer; safecall;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; safecall;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; safecall;
    function Get_ActualCurrency: Integer; safecall;
    function Get_AdditionalHeader: WideString; safecall;
    procedure Set_AdditionalHeader(const pAdditionalHeader: WideString); safecall;
    function Get_AdditionalTrailer: WideString; safecall;
    procedure Set_AdditionalTrailer(const pAdditionalTrailer: WideString); safecall;
    function Get_CapAdditionalHeader: WordBool; safecall;
    function Get_CapAdditionalTrailer: WordBool; safecall;
    function Get_CapChangeDue: WordBool; safecall;
    function Get_CapEmptyReceiptIsVoidable: WordBool; safecall;
    function Get_CapFiscalReceiptStation: WordBool; safecall;
    function Get_CapFiscalReceiptType: WordBool; safecall;
    function Get_CapMultiContractor: WordBool; safecall;
    function Get_CapOnlyVoidLastItem: WordBool; safecall;
    function Get_CapPackageAdjustment: WordBool; safecall;
    function Get_CapPostPreLine: WordBool; safecall;
    function Get_CapSetCurrency: WordBool; safecall;
    function Get_CapTotalizerType: WordBool; safecall;
    function Get_ChangeDue: WideString; safecall;
    procedure Set_ChangeDue(const pChangeDue: WideString); safecall;
    function Get_ContractorId: Integer; safecall;
    procedure Set_ContractorId(pContractorId: Integer); safecall;
    function Get_DateType: Integer; safecall;
    procedure Set_DateType(pDateType: Integer); safecall;
    function Get_FiscalReceiptStation: Integer; safecall;
    procedure Set_FiscalReceiptStation(pFiscalReceiptStation: Integer); safecall;
    function Get_FiscalReceiptType: Integer; safecall;
    procedure Set_FiscalReceiptType(pFiscalReceiptType: Integer); safecall;
    function Get_MessageType: Integer; safecall;
    procedure Set_MessageType(pMessageType: Integer); safecall;
    function Get_PostLine: WideString; safecall;
    procedure Set_PostLine(const pPostLine: WideString); safecall;
    function Get_PreLine: WideString; safecall;
    procedure Set_PreLine(const pPreLine: WideString); safecall;
    function Get_TotalizerType: Integer; safecall;
    procedure Set_TotalizerType(pTotalizerType: Integer); safecall;
    function PrintRecCash(Amount: Currency): Integer; safecall;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; safecall;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; safecall;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; safecall;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; safecall;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; safecall;
    function PrintRecTaxID(const TaxID: WideString): Integer; safecall;
    function SetCurrency(NewCurrency: Integer): Integer; safecall;
    function Get_CapStatisticsReporting: WordBool; safecall;
    function Get_CapUpdateStatistics: WordBool; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function Get_CapCompareFirmwareVersion: WordBool; safecall;
    function Get_CapUpdateFirmware: WordBool; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    function Get_CapPositiveSubtotalAdjustment: WordBool; safecall;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; safecall;
    property OpenResult: Integer read Get_OpenResult;
    property BinaryConversion: Integer read Get_BinaryConversion write Set_BinaryConversion;
    property CapPowerReporting: Integer read Get_CapPowerReporting;
    property CheckHealthText: WideString read Get_CheckHealthText;
    property Claimed: WordBool read Get_Claimed;
    property DeviceEnabled: WordBool read Get_DeviceEnabled write Set_DeviceEnabled;
    property FreezeEvents: WordBool read Get_FreezeEvents write Set_FreezeEvents;
    property OutputID: Integer read Get_OutputID;
    property PowerNotify: Integer read Get_PowerNotify write Set_PowerNotify;
    property PowerState: Integer read Get_PowerState;
    property ResultCode: Integer read Get_ResultCode;
    property ResultCodeExtended: Integer read Get_ResultCodeExtended;
    property State: Integer read Get_State;
    property ControlObjectDescription: WideString read Get_ControlObjectDescription;
    property ControlObjectVersion: Integer read Get_ControlObjectVersion;
    property ServiceObjectDescription: WideString read Get_ServiceObjectDescription;
    property ServiceObjectVersion: Integer read Get_ServiceObjectVersion;
    property DeviceDescription: WideString read Get_DeviceDescription;
    property DeviceName: WideString read Get_DeviceName;
    property AmountDecimalPlaces: Integer read Get_AmountDecimalPlaces;
    property AsyncMode: WordBool read Get_AsyncMode write Set_AsyncMode;
    property CapAdditionalLines: WordBool read Get_CapAdditionalLines;
    property CapAmountAdjustment: WordBool read Get_CapAmountAdjustment;
    property CapAmountNotPaid: WordBool read Get_CapAmountNotPaid;
    property CapCheckTotal: WordBool read Get_CapCheckTotal;
    property CapCoverSensor: WordBool read Get_CapCoverSensor;
    property CapDoubleWidth: WordBool read Get_CapDoubleWidth;
    property CapDuplicateReceipt: WordBool read Get_CapDuplicateReceipt;
    property CapFixedOutput: WordBool read Get_CapFixedOutput;
    property CapHasVatTable: WordBool read Get_CapHasVatTable;
    property CapIndependentHeader: WordBool read Get_CapIndependentHeader;
    property CapItemList: WordBool read Get_CapItemList;
    property CapJrnEmptySensor: WordBool read Get_CapJrnEmptySensor;
    property CapJrnNearEndSensor: WordBool read Get_CapJrnNearEndSensor;
    property CapJrnPresent: WordBool read Get_CapJrnPresent;
    property CapNonFiscalMode: WordBool read Get_CapNonFiscalMode;
    property CapOrderAdjustmentFirst: WordBool read Get_CapOrderAdjustmentFirst;
    property CapPercentAdjustment: WordBool read Get_CapPercentAdjustment;
    property CapPositiveAdjustment: WordBool read Get_CapPositiveAdjustment;
    property CapPowerLossReport: WordBool read Get_CapPowerLossReport;
    property CapPredefinedPaymentLines: WordBool read Get_CapPredefinedPaymentLines;
    property CapReceiptNotPaid: WordBool read Get_CapReceiptNotPaid;
    property CapRecEmptySensor: WordBool read Get_CapRecEmptySensor;
    property CapRecNearEndSensor: WordBool read Get_CapRecNearEndSensor;
    property CapRecPresent: WordBool read Get_CapRecPresent;
    property CapRemainingFiscalMemory: WordBool read Get_CapRemainingFiscalMemory;
    property CapReservedWord: WordBool read Get_CapReservedWord;
    property CapSetHeader: WordBool read Get_CapSetHeader;
    property CapSetPOSID: WordBool read Get_CapSetPOSID;
    property CapSetStoreFiscalID: WordBool read Get_CapSetStoreFiscalID;
    property CapSetTrailer: WordBool read Get_CapSetTrailer;
    property CapSetVatTable: WordBool read Get_CapSetVatTable;
    property CapSlpEmptySensor: WordBool read Get_CapSlpEmptySensor;
    property CapSlpFiscalDocument: WordBool read Get_CapSlpFiscalDocument;
    property CapSlpFullSlip: WordBool read Get_CapSlpFullSlip;
    property CapSlpNearEndSensor: WordBool read Get_CapSlpNearEndSensor;
    property CapSlpPresent: WordBool read Get_CapSlpPresent;
    property CapSlpValidation: WordBool read Get_CapSlpValidation;
    property CapSubAmountAdjustment: WordBool read Get_CapSubAmountAdjustment;
    property CapSubPercentAdjustment: WordBool read Get_CapSubPercentAdjustment;
    property CapSubtotal: WordBool read Get_CapSubtotal;
    property CapTrainingMode: WordBool read Get_CapTrainingMode;
    property CapValidateJournal: WordBool read Get_CapValidateJournal;
    property CapXReport: WordBool read Get_CapXReport;
    property CheckTotal: WordBool read Get_CheckTotal write Set_CheckTotal;
    property CountryCode: Integer read Get_CountryCode;
    property CoverOpen: WordBool read Get_CoverOpen;
    property DayOpened: WordBool read Get_DayOpened;
    property DescriptionLength: Integer read Get_DescriptionLength;
    property DuplicateReceipt: WordBool read Get_DuplicateReceipt write Set_DuplicateReceipt;
    property ErrorLevel: Integer read Get_ErrorLevel;
    property ErrorOutID: Integer read Get_ErrorOutID;
    property ErrorState: Integer read Get_ErrorState;
    property ErrorStation: Integer read Get_ErrorStation;
    property ErrorString: WideString read Get_ErrorString;
    property FlagWhenIdle: WordBool read Get_FlagWhenIdle write Set_FlagWhenIdle;
    property JrnEmpty: WordBool read Get_JrnEmpty;
    property JrnNearEnd: WordBool read Get_JrnNearEnd;
    property MessageLength: Integer read Get_MessageLength;
    property NumHeaderLines: Integer read Get_NumHeaderLines;
    property NumTrailerLines: Integer read Get_NumTrailerLines;
    property NumVatRates: Integer read Get_NumVatRates;
    property PredefinedPaymentLines: WideString read Get_PredefinedPaymentLines;
    property PrinterState: Integer read Get_PrinterState;
    property QuantityDecimalPlaces: Integer read Get_QuantityDecimalPlaces;
    property QuantityLength: Integer read Get_QuantityLength;
    property RecEmpty: WordBool read Get_RecEmpty;
    property RecNearEnd: WordBool read Get_RecNearEnd;
    property RemainingFiscalMemory: Integer read Get_RemainingFiscalMemory;
    property ReservedWord: WideString read Get_ReservedWord;
    property SlipSelection: Integer read Get_SlipSelection write Set_SlipSelection;
    property SlpEmpty: WordBool read Get_SlpEmpty;
    property SlpNearEnd: WordBool read Get_SlpNearEnd;
    property TrainingModeActive: WordBool read Get_TrainingModeActive;
    property ActualCurrency: Integer read Get_ActualCurrency;
    property AdditionalHeader: WideString read Get_AdditionalHeader write Set_AdditionalHeader;
    property AdditionalTrailer: WideString read Get_AdditionalTrailer write Set_AdditionalTrailer;
    property CapAdditionalHeader: WordBool read Get_CapAdditionalHeader;
    property CapAdditionalTrailer: WordBool read Get_CapAdditionalTrailer;
    property CapChangeDue: WordBool read Get_CapChangeDue;
    property CapEmptyReceiptIsVoidable: WordBool read Get_CapEmptyReceiptIsVoidable;
    property CapFiscalReceiptStation: WordBool read Get_CapFiscalReceiptStation;
    property CapFiscalReceiptType: WordBool read Get_CapFiscalReceiptType;
    property CapMultiContractor: WordBool read Get_CapMultiContractor;
    property CapOnlyVoidLastItem: WordBool read Get_CapOnlyVoidLastItem;
    property CapPackageAdjustment: WordBool read Get_CapPackageAdjustment;
    property CapPostPreLine: WordBool read Get_CapPostPreLine;
    property CapSetCurrency: WordBool read Get_CapSetCurrency;
    property CapTotalizerType: WordBool read Get_CapTotalizerType;
    property ChangeDue: WideString read Get_ChangeDue write Set_ChangeDue;
    property ContractorId: Integer read Get_ContractorId write Set_ContractorId;
    property DateType: Integer read Get_DateType write Set_DateType;
    property FiscalReceiptStation: Integer read Get_FiscalReceiptStation write Set_FiscalReceiptStation;
    property FiscalReceiptType: Integer read Get_FiscalReceiptType write Set_FiscalReceiptType;
    property MessageType: Integer read Get_MessageType write Set_MessageType;
    property PostLine: WideString read Get_PostLine write Set_PostLine;
    property PreLine: WideString read Get_PreLine write Set_PreLine;
    property TotalizerType: Integer read Get_TotalizerType write Set_TotalizerType;
    property CapStatisticsReporting: WordBool read Get_CapStatisticsReporting;
    property CapUpdateStatistics: WordBool read Get_CapUpdateStatistics;
    property CapCompareFirmwareVersion: WordBool read Get_CapCompareFirmwareVersion;
    property CapUpdateFirmware: WordBool read Get_CapUpdateFirmware;
    property CapPositiveSubtotalAdjustment: WordBool read Get_CapPositiveSubtotalAdjustment;
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB95071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinterDisp = dispinterface
    ['{CCB95071-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AmountDecimalPlaces: Integer readonly dispid 50;
    property AsyncMode: WordBool dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    property CheckTotal: WordBool dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    property DuplicateReceipt: WordBool dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    property SlipSelection: Integer dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    property AdditionalHeader: WideString dispid 211;
    property AdditionalTrailer: WideString dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    property ChangeDue: WideString dispid 225;
    property ContractorId: Integer dispid 226;
    property DateType: Integer dispid 227;
    property FiscalReceiptStation: Integer dispid 228;
    property FiscalReceiptType: Integer dispid 229;
    property MessageType: Integer dispid 230;
    property PostLine: WideString dispid 231;
    property PreLine: WideString dispid 232;
    property TotalizerType: Integer dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter14
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB90071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter14 = interface(IOPOSFiscalPrinter)
    ['{CCB90071-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinter14Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB90071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter14Disp = dispinterface
    ['{CCB90071-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AmountDecimalPlaces: Integer readonly dispid 50;
    property AsyncMode: WordBool dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    property CheckTotal: WordBool dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    property DuplicateReceipt: WordBool dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    property SlipSelection: Integer dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    property AdditionalHeader: WideString dispid 211;
    property AdditionalTrailer: WideString dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    property ChangeDue: WideString dispid 225;
    property ContractorId: Integer dispid 226;
    property DateType: Integer dispid 227;
    property FiscalReceiptStation: Integer dispid 228;
    property FiscalReceiptType: Integer dispid 229;
    property MessageType: Integer dispid 230;
    property PostLine: WideString dispid 231;
    property PreLine: WideString dispid 232;
    property TotalizerType: Integer dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter15
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter15 = interface(IOPOSFiscalPrinter)
    ['{CCB91071-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinter15Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter15Disp = dispinterface
    ['{CCB91071-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AmountDecimalPlaces: Integer readonly dispid 50;
    property AsyncMode: WordBool dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    property CheckTotal: WordBool dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    property DuplicateReceipt: WordBool dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    property SlipSelection: Integer dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    property AdditionalHeader: WideString dispid 211;
    property AdditionalTrailer: WideString dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    property ChangeDue: WideString dispid 225;
    property ContractorId: Integer dispid 226;
    property DateType: Integer dispid 227;
    property FiscalReceiptStation: Integer dispid 228;
    property FiscalReceiptType: Integer dispid 229;
    property MessageType: Integer dispid 230;
    property PostLine: WideString dispid 231;
    property PreLine: WideString dispid 232;
    property TotalizerType: Integer dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter16
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter16 = interface(IOPOSFiscalPrinter)
    ['{CCB92071-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinter16Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter16Disp = dispinterface
    ['{CCB92071-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AmountDecimalPlaces: Integer readonly dispid 50;
    property AsyncMode: WordBool dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    property CheckTotal: WordBool dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    property DuplicateReceipt: WordBool dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    property SlipSelection: Integer dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    property AdditionalHeader: WideString dispid 211;
    property AdditionalTrailer: WideString dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    property ChangeDue: WideString dispid 225;
    property ContractorId: Integer dispid 226;
    property DateType: Integer dispid 227;
    property FiscalReceiptStation: Integer dispid 228;
    property FiscalReceiptType: Integer dispid 229;
    property MessageType: Integer dispid 230;
    property PostLine: WideString dispid 231;
    property PreLine: WideString dispid 232;
    property TotalizerType: Integer dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter18
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter18 = interface(IOPOSFiscalPrinter)
    ['{CCB93071-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinter18Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter18Disp = dispinterface
    ['{CCB93071-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AmountDecimalPlaces: Integer readonly dispid 50;
    property AsyncMode: WordBool dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    property CheckTotal: WordBool dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    property DuplicateReceipt: WordBool dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    property SlipSelection: Integer dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    property AdditionalHeader: WideString dispid 211;
    property AdditionalTrailer: WideString dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    property ChangeDue: WideString dispid 225;
    property ContractorId: Integer dispid 226;
    property DateType: Integer dispid 227;
    property FiscalReceiptStation: Integer dispid 228;
    property FiscalReceiptType: Integer dispid 229;
    property MessageType: Integer dispid 230;
    property PostLine: WideString dispid 231;
    property PreLine: WideString dispid 232;
    property TotalizerType: Integer dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter19
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter19 = interface(IOPOSFiscalPrinter)
    ['{CCB94071-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinter19Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter19Disp = dispinterface
    ['{CCB94071-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AmountDecimalPlaces: Integer readonly dispid 50;
    property AsyncMode: WordBool dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    property CheckTotal: WordBool dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    property DuplicateReceipt: WordBool dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    property SlipSelection: Integer dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    property AdditionalHeader: WideString dispid 211;
    property AdditionalTrailer: WideString dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    property ChangeDue: WideString dispid 225;
    property ContractorId: Integer dispid 226;
    property DateType: Integer dispid 227;
    property FiscalReceiptStation: Integer dispid 228;
    property FiscalReceiptType: Integer dispid 229;
    property MessageType: Integer dispid 230;
    property PostLine: WideString dispid 231;
    property PreLine: WideString dispid 232;
    property TotalizerType: Integer dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TOPOSFiscalPrinter
// Help String      : OPOS FiscalPrinter Control 1.11.000 [Public, by CRM/RCS-Dayton]
// Default Interface: IOPOSFiscalPrinter
// Def. Intf. DISP? : No
// Event   Interface: _IOPOSFiscalPrinterEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TOPOSFiscalPrinterDirectIOEvent = procedure(ASender: TObject; EventNumber: Integer; 
                                                                var pData: Integer; 
                                                                var pString: WideString) of object;
  TOPOSFiscalPrinterErrorEvent = procedure(ASender: TObject; ResultCode: Integer; 
                                                             ResultCodeExtended: Integer; 
                                                             ErrorLocus: Integer; 
                                                             var pErrorResponse: Integer) of object;
  TOPOSFiscalPrinterOutputCompleteEvent = procedure(ASender: TObject; OutputID: Integer) of object;
  TOPOSFiscalPrinterStatusUpdateEvent = procedure(ASender: TObject; Data: Integer) of object;

  TOPOSFiscalPrinter = class(TOleControl)
  private
    FOnDirectIOEvent: TOPOSFiscalPrinterDirectIOEvent;
    FOnErrorEvent: TOPOSFiscalPrinterErrorEvent;
    FOnOutputCompleteEvent: TOPOSFiscalPrinterOutputCompleteEvent;
    FOnStatusUpdateEvent: TOPOSFiscalPrinterStatusUpdateEvent;
    FIntf: IOPOSFiscalPrinter;
    function  GetControlInterface: IOPOSFiscalPrinter;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure SODataDummy(Status: Integer);
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString);
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer);
    procedure SOOutputComplete(OutputID: Integer);
    procedure SOStatusUpdate(Data: Integer);
    function SOProcessID: Integer;
    function CheckHealth(Level: Integer): Integer;
    function ClaimDevice(Timeout: Integer): Integer;
    function ClearOutput: Integer;
    function Close: Integer;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
    function Open(const DeviceName: WideString): Integer;
    function ReleaseDevice: Integer;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer;
    function BeginInsertion(Timeout: Integer): Integer;
    function BeginItemList(VatID: Integer): Integer;
    function BeginNonFiscal: Integer;
    function BeginRemoval(Timeout: Integer): Integer;
    function BeginTraining: Integer;
    function ClearError: Integer;
    function EndFiscalDocument: Integer;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer;
    function EndFixedOutput: Integer;
    function EndInsertion: Integer;
    function EndItemList: Integer;
    function EndNonFiscal: Integer;
    function EndRemoval: Integer;
    function EndTraining: Integer;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer;
    function GetDate(out Date: WideString): Integer;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer;
    function PrintDuplicateReceipt: Integer;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer;
    function PrintNormal(Station: Integer; const Data: WideString): Integer;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer;
    function PrintPowerLossReport: Integer;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer;
    function PrintRecMessage(const Message: WideString): Integer;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer;
    function PrintRecSubtotal(Amount: Currency): Integer;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer;
    function PrintRecVoid(const Description: WideString): Integer;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer;
    function PrintXReport: Integer;
    function PrintZReport: Integer;
    function ResetPrinter: Integer;
    function SetDate(const Date: WideString): Integer;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer;
    function SetStoreFiscalID(const ID: WideString): Integer;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer;
    function SetVatTable: Integer;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer;
    function PrintRecCash(Amount: Currency): Integer;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer;
    function PrintRecTaxID(const TaxID: WideString): Integer;
    function SetCurrency(NewCurrency: Integer): Integer;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer;
    property  ControlInterface: IOPOSFiscalPrinter read GetControlInterface;
    property  DefaultInterface: IOPOSFiscalPrinter read GetControlInterface;
    property OpenResult: Integer index 49 read GetIntegerProp;
    property CapPowerReporting: Integer index 12 read GetIntegerProp;
    property CheckHealthText: WideString index 13 read GetWideStringProp;
    property Claimed: WordBool index 14 read GetWordBoolProp;
    property OutputID: Integer index 19 read GetIntegerProp;
    property PowerState: Integer index 21 read GetIntegerProp;
    property ResultCode: Integer index 22 read GetIntegerProp;
    property ResultCodeExtended: Integer index 23 read GetIntegerProp;
    property State: Integer index 24 read GetIntegerProp;
    property ControlObjectDescription: WideString index 25 read GetWideStringProp;
    property ControlObjectVersion: Integer index 26 read GetIntegerProp;
    property ServiceObjectDescription: WideString index 27 read GetWideStringProp;
    property ServiceObjectVersion: Integer index 28 read GetIntegerProp;
    property DeviceDescription: WideString index 29 read GetWideStringProp;
    property DeviceName: WideString index 30 read GetWideStringProp;
    property AmountDecimalPlaces: Integer index 50 read GetIntegerProp;
    property CapAdditionalLines: WordBool index 52 read GetWordBoolProp;
    property CapAmountAdjustment: WordBool index 53 read GetWordBoolProp;
    property CapAmountNotPaid: WordBool index 54 read GetWordBoolProp;
    property CapCheckTotal: WordBool index 55 read GetWordBoolProp;
    property CapCoverSensor: WordBool index 56 read GetWordBoolProp;
    property CapDoubleWidth: WordBool index 57 read GetWordBoolProp;
    property CapDuplicateReceipt: WordBool index 58 read GetWordBoolProp;
    property CapFixedOutput: WordBool index 59 read GetWordBoolProp;
    property CapHasVatTable: WordBool index 60 read GetWordBoolProp;
    property CapIndependentHeader: WordBool index 61 read GetWordBoolProp;
    property CapItemList: WordBool index 62 read GetWordBoolProp;
    property CapJrnEmptySensor: WordBool index 63 read GetWordBoolProp;
    property CapJrnNearEndSensor: WordBool index 64 read GetWordBoolProp;
    property CapJrnPresent: WordBool index 65 read GetWordBoolProp;
    property CapNonFiscalMode: WordBool index 66 read GetWordBoolProp;
    property CapOrderAdjustmentFirst: WordBool index 67 read GetWordBoolProp;
    property CapPercentAdjustment: WordBool index 68 read GetWordBoolProp;
    property CapPositiveAdjustment: WordBool index 69 read GetWordBoolProp;
    property CapPowerLossReport: WordBool index 70 read GetWordBoolProp;
    property CapPredefinedPaymentLines: WordBool index 71 read GetWordBoolProp;
    property CapReceiptNotPaid: WordBool index 72 read GetWordBoolProp;
    property CapRecEmptySensor: WordBool index 73 read GetWordBoolProp;
    property CapRecNearEndSensor: WordBool index 74 read GetWordBoolProp;
    property CapRecPresent: WordBool index 75 read GetWordBoolProp;
    property CapRemainingFiscalMemory: WordBool index 76 read GetWordBoolProp;
    property CapReservedWord: WordBool index 77 read GetWordBoolProp;
    property CapSetHeader: WordBool index 78 read GetWordBoolProp;
    property CapSetPOSID: WordBool index 79 read GetWordBoolProp;
    property CapSetStoreFiscalID: WordBool index 80 read GetWordBoolProp;
    property CapSetTrailer: WordBool index 81 read GetWordBoolProp;
    property CapSetVatTable: WordBool index 82 read GetWordBoolProp;
    property CapSlpEmptySensor: WordBool index 83 read GetWordBoolProp;
    property CapSlpFiscalDocument: WordBool index 84 read GetWordBoolProp;
    property CapSlpFullSlip: WordBool index 85 read GetWordBoolProp;
    property CapSlpNearEndSensor: WordBool index 86 read GetWordBoolProp;
    property CapSlpPresent: WordBool index 87 read GetWordBoolProp;
    property CapSlpValidation: WordBool index 88 read GetWordBoolProp;
    property CapSubAmountAdjustment: WordBool index 89 read GetWordBoolProp;
    property CapSubPercentAdjustment: WordBool index 90 read GetWordBoolProp;
    property CapSubtotal: WordBool index 91 read GetWordBoolProp;
    property CapTrainingMode: WordBool index 92 read GetWordBoolProp;
    property CapValidateJournal: WordBool index 93 read GetWordBoolProp;
    property CapXReport: WordBool index 94 read GetWordBoolProp;
    property CountryCode: Integer index 96 read GetIntegerProp;
    property CoverOpen: WordBool index 97 read GetWordBoolProp;
    property DayOpened: WordBool index 98 read GetWordBoolProp;
    property DescriptionLength: Integer index 99 read GetIntegerProp;
    property ErrorLevel: Integer index 101 read GetIntegerProp;
    property ErrorOutID: Integer index 102 read GetIntegerProp;
    property ErrorState: Integer index 103 read GetIntegerProp;
    property ErrorStation: Integer index 104 read GetIntegerProp;
    property ErrorString: WideString index 105 read GetWideStringProp;
    property JrnEmpty: WordBool index 107 read GetWordBoolProp;
    property JrnNearEnd: WordBool index 108 read GetWordBoolProp;
    property MessageLength: Integer index 109 read GetIntegerProp;
    property NumHeaderLines: Integer index 110 read GetIntegerProp;
    property NumTrailerLines: Integer index 111 read GetIntegerProp;
    property NumVatRates: Integer index 112 read GetIntegerProp;
    property PredefinedPaymentLines: WideString index 113 read GetWideStringProp;
    property PrinterState: Integer index 114 read GetIntegerProp;
    property QuantityDecimalPlaces: Integer index 115 read GetIntegerProp;
    property QuantityLength: Integer index 116 read GetIntegerProp;
    property RecEmpty: WordBool index 117 read GetWordBoolProp;
    property RecNearEnd: WordBool index 118 read GetWordBoolProp;
    property RemainingFiscalMemory: Integer index 119 read GetIntegerProp;
    property ReservedWord: WideString index 120 read GetWideStringProp;
    property SlpEmpty: WordBool index 122 read GetWordBoolProp;
    property SlpNearEnd: WordBool index 123 read GetWordBoolProp;
    property TrainingModeActive: WordBool index 124 read GetWordBoolProp;
    property ActualCurrency: Integer index 210 read GetIntegerProp;
    property CapAdditionalHeader: WordBool index 213 read GetWordBoolProp;
    property CapAdditionalTrailer: WordBool index 214 read GetWordBoolProp;
    property CapChangeDue: WordBool index 215 read GetWordBoolProp;
    property CapEmptyReceiptIsVoidable: WordBool index 216 read GetWordBoolProp;
    property CapFiscalReceiptStation: WordBool index 217 read GetWordBoolProp;
    property CapFiscalReceiptType: WordBool index 218 read GetWordBoolProp;
    property CapMultiContractor: WordBool index 219 read GetWordBoolProp;
    property CapOnlyVoidLastItem: WordBool index 220 read GetWordBoolProp;
    property CapPackageAdjustment: WordBool index 221 read GetWordBoolProp;
    property CapPostPreLine: WordBool index 222 read GetWordBoolProp;
    property CapSetCurrency: WordBool index 223 read GetWordBoolProp;
    property CapTotalizerType: WordBool index 224 read GetWordBoolProp;
    property CapStatisticsReporting: WordBool index 39 read GetWordBoolProp;
    property CapUpdateStatistics: WordBool index 40 read GetWordBoolProp;
    property CapCompareFirmwareVersion: WordBool index 44 read GetWordBoolProp;
    property CapUpdateFirmware: WordBool index 45 read GetWordBoolProp;
    property CapPositiveSubtotalAdjustment: WordBool index 234 read GetWordBoolProp;
  published
    property Anchors;
    property BinaryConversion: Integer index 11 read GetIntegerProp write SetIntegerProp stored False;
    property DeviceEnabled: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property FreezeEvents: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property PowerNotify: Integer index 20 read GetIntegerProp write SetIntegerProp stored False;
    property AsyncMode: WordBool index 51 read GetWordBoolProp write SetWordBoolProp stored False;
    property CheckTotal: WordBool index 95 read GetWordBoolProp write SetWordBoolProp stored False;
    property DuplicateReceipt: WordBool index 100 read GetWordBoolProp write SetWordBoolProp stored False;
    property FlagWhenIdle: WordBool index 106 read GetWordBoolProp write SetWordBoolProp stored False;
    property SlipSelection: Integer index 121 read GetIntegerProp write SetIntegerProp stored False;
    property AdditionalHeader: WideString index 211 read GetWideStringProp write SetWideStringProp stored False;
    property AdditionalTrailer: WideString index 212 read GetWideStringProp write SetWideStringProp stored False;
    property ChangeDue: WideString index 225 read GetWideStringProp write SetWideStringProp stored False;
    property ContractorId: Integer index 226 read GetIntegerProp write SetIntegerProp stored False;
    property DateType: Integer index 227 read GetIntegerProp write SetIntegerProp stored False;
    property FiscalReceiptStation: Integer index 228 read GetIntegerProp write SetIntegerProp stored False;
    property FiscalReceiptType: Integer index 229 read GetIntegerProp write SetIntegerProp stored False;
    property MessageType: Integer index 230 read GetIntegerProp write SetIntegerProp stored False;
    property PostLine: WideString index 231 read GetWideStringProp write SetWideStringProp stored False;
    property PreLine: WideString index 232 read GetWideStringProp write SetWideStringProp stored False;
    property TotalizerType: Integer index 233 read GetIntegerProp write SetIntegerProp stored False;
    property OnDirectIOEvent: TOPOSFiscalPrinterDirectIOEvent read FOnDirectIOEvent write FOnDirectIOEvent;
    property OnErrorEvent: TOPOSFiscalPrinterErrorEvent read FOnErrorEvent write FOnErrorEvent;
    property OnOutputCompleteEvent: TOPOSFiscalPrinterOutputCompleteEvent read FOnOutputCompleteEvent write FOnOutputCompleteEvent;
    property OnStatusUpdateEvent: TOPOSFiscalPrinterStatusUpdateEvent read FOnStatusUpdateEvent write FOnStatusUpdateEvent;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

procedure TOPOSFiscalPrinter.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $00000002, $00000003, $00000004, $00000005);
  CControlData: TControlData2 = (
    ClassID:      '{CCB90072-B81E-11D2-AB74-0040054C3719}';
    EventIID:     '{CCB90073-B81E-11D2-AB74-0040054C3719}';
    EventCount:   4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey:   nil (*HR:$80004002*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := UIntPtr(@@FOnDirectIOEvent) - UIntPtr(Self);
end;

procedure TOPOSFiscalPrinter.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IOPOSFiscalPrinter;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TOPOSFiscalPrinter.GetControlInterface: IOPOSFiscalPrinter;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TOPOSFiscalPrinter.SODataDummy(Status: Integer);
begin
  DefaultInterface.SODataDummy(Status);
end;

procedure TOPOSFiscalPrinter.SODirectIO(EventNumber: Integer; var pData: Integer; 
                                        var pString: WideString);
begin
  DefaultInterface.SODirectIO(EventNumber, pData, pString);
end;

procedure TOPOSFiscalPrinter.SOError(ResultCode: Integer; ResultCodeExtended: Integer; 
                                     ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  DefaultInterface.SOError(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

procedure TOPOSFiscalPrinter.SOOutputComplete(OutputID: Integer);
begin
  DefaultInterface.SOOutputComplete(OutputID);
end;

procedure TOPOSFiscalPrinter.SOStatusUpdate(Data: Integer);
begin
  DefaultInterface.SOStatusUpdate(Data);
end;

function TOPOSFiscalPrinter.SOProcessID: Integer;
begin
  Result := DefaultInterface.SOProcessID;
end;

function TOPOSFiscalPrinter.CheckHealth(Level: Integer): Integer;
begin
  Result := DefaultInterface.CheckHealth(Level);
end;

function TOPOSFiscalPrinter.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.ClaimDevice(Timeout);
end;

function TOPOSFiscalPrinter.ClearOutput: Integer;
begin
  Result := DefaultInterface.ClearOutput;
end;

function TOPOSFiscalPrinter.Close: Integer;
begin
  Result := DefaultInterface.Close;
end;

function TOPOSFiscalPrinter.DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
begin
  Result := DefaultInterface.DirectIO(Command, pData, pString);
end;

function TOPOSFiscalPrinter.Open(const DeviceName: WideString): Integer;
begin
  Result := DefaultInterface.Open(DeviceName);
end;

function TOPOSFiscalPrinter.ReleaseDevice: Integer;
begin
  Result := DefaultInterface.ReleaseDevice;
end;

function TOPOSFiscalPrinter.BeginFiscalDocument(DocumentAmount: Integer): Integer;
begin
  Result := DefaultInterface.BeginFiscalDocument(DocumentAmount);
end;

function TOPOSFiscalPrinter.BeginFiscalReceipt(PrintHeader: WordBool): Integer;
begin
  Result := DefaultInterface.BeginFiscalReceipt(PrintHeader);
end;

function TOPOSFiscalPrinter.BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer;
begin
  Result := DefaultInterface.BeginFixedOutput(Station, DocumentType);
end;

function TOPOSFiscalPrinter.BeginInsertion(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.BeginInsertion(Timeout);
end;

function TOPOSFiscalPrinter.BeginItemList(VatID: Integer): Integer;
begin
  Result := DefaultInterface.BeginItemList(VatID);
end;

function TOPOSFiscalPrinter.BeginNonFiscal: Integer;
begin
  Result := DefaultInterface.BeginNonFiscal;
end;

function TOPOSFiscalPrinter.BeginRemoval(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.BeginRemoval(Timeout);
end;

function TOPOSFiscalPrinter.BeginTraining: Integer;
begin
  Result := DefaultInterface.BeginTraining;
end;

function TOPOSFiscalPrinter.ClearError: Integer;
begin
  Result := DefaultInterface.ClearError;
end;

function TOPOSFiscalPrinter.EndFiscalDocument: Integer;
begin
  Result := DefaultInterface.EndFiscalDocument;
end;

function TOPOSFiscalPrinter.EndFiscalReceipt(PrintHeader: WordBool): Integer;
begin
  Result := DefaultInterface.EndFiscalReceipt(PrintHeader);
end;

function TOPOSFiscalPrinter.EndFixedOutput: Integer;
begin
  Result := DefaultInterface.EndFixedOutput;
end;

function TOPOSFiscalPrinter.EndInsertion: Integer;
begin
  Result := DefaultInterface.EndInsertion;
end;

function TOPOSFiscalPrinter.EndItemList: Integer;
begin
  Result := DefaultInterface.EndItemList;
end;

function TOPOSFiscalPrinter.EndNonFiscal: Integer;
begin
  Result := DefaultInterface.EndNonFiscal;
end;

function TOPOSFiscalPrinter.EndRemoval: Integer;
begin
  Result := DefaultInterface.EndRemoval;
end;

function TOPOSFiscalPrinter.EndTraining: Integer;
begin
  Result := DefaultInterface.EndTraining;
end;

function TOPOSFiscalPrinter.GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer;
begin
  Result := DefaultInterface.GetData(DataItem, OptArgs, Data);
end;

function TOPOSFiscalPrinter.GetDate(out Date: WideString): Integer;
begin
  Result := DefaultInterface.GetDate(Date);
end;

function TOPOSFiscalPrinter.GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer;
begin
  Result := DefaultInterface.GetTotalizer(VatID, OptArgs, Data);
end;

function TOPOSFiscalPrinter.GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer;
begin
  Result := DefaultInterface.GetVatEntry(VatID, OptArgs, VatRate);
end;

function TOPOSFiscalPrinter.PrintDuplicateReceipt: Integer;
begin
  Result := DefaultInterface.PrintDuplicateReceipt;
end;

function TOPOSFiscalPrinter.PrintFiscalDocumentLine(const DocumentLine: WideString): Integer;
begin
  Result := DefaultInterface.PrintFiscalDocumentLine(DocumentLine);
end;

function TOPOSFiscalPrinter.PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; 
                                             const Data: WideString): Integer;
begin
  Result := DefaultInterface.PrintFixedOutput(DocumentType, LineNumber, Data);
end;

function TOPOSFiscalPrinter.PrintNormal(Station: Integer; const Data: WideString): Integer;
begin
  Result := DefaultInterface.PrintNormal(Station, Data);
end;

function TOPOSFiscalPrinter.PrintPeriodicTotalsReport(const Date1: WideString; 
                                                      const Date2: WideString): Integer;
begin
  Result := DefaultInterface.PrintPeriodicTotalsReport(Date1, Date2);
end;

function TOPOSFiscalPrinter.PrintPowerLossReport: Integer;
begin
  Result := DefaultInterface.PrintPowerLossReport;
end;

function TOPOSFiscalPrinter.PrintRecItem(const Description: WideString; Price: Currency; 
                                         Quantity: Integer; VatInfo: Integer; UnitPrice: Currency; 
                                         const UnitName: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecItem(Description, Price, Quantity, VatInfo, UnitPrice, UnitName);
end;

function TOPOSFiscalPrinter.PrintRecItemAdjustment(AdjustmentType: Integer; 
                                                   const Description: WideString; Amount: Currency; 
                                                   VatInfo: Integer): Integer;
begin
  Result := DefaultInterface.PrintRecItemAdjustment(AdjustmentType, Description, Amount, VatInfo);
end;

function TOPOSFiscalPrinter.PrintRecMessage(const Message: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecMessage(Message);
end;

function TOPOSFiscalPrinter.PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer;
begin
  Result := DefaultInterface.PrintRecNotPaid(Description, Amount);
end;

function TOPOSFiscalPrinter.PrintRecRefund(const Description: WideString; Amount: Currency; 
                                           VatInfo: Integer): Integer;
begin
  Result := DefaultInterface.PrintRecRefund(Description, Amount, VatInfo);
end;

function TOPOSFiscalPrinter.PrintRecSubtotal(Amount: Currency): Integer;
begin
  Result := DefaultInterface.PrintRecSubtotal(Amount);
end;

function TOPOSFiscalPrinter.PrintRecSubtotalAdjustment(AdjustmentType: Integer; 
                                                       const Description: WideString; 
                                                       Amount: Currency): Integer;
begin
  Result := DefaultInterface.PrintRecSubtotalAdjustment(AdjustmentType, Description, Amount);
end;

function TOPOSFiscalPrinter.PrintRecTotal(Total: Currency; Payment: Currency; 
                                          const Description: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecTotal(Total, Payment, Description);
end;

function TOPOSFiscalPrinter.PrintRecVoid(const Description: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecVoid(Description);
end;

function TOPOSFiscalPrinter.PrintRecVoidItem(const Description: WideString; Amount: Currency; 
                                             Quantity: Integer; AdjustmentType: Integer; 
                                             Adjustment: Currency; VatInfo: Integer): Integer;
begin
  Result := DefaultInterface.PrintRecVoidItem(Description, Amount, Quantity, AdjustmentType, 
                                              Adjustment, VatInfo);
end;

function TOPOSFiscalPrinter.PrintReport(ReportType: Integer; const StartNum: WideString; 
                                        const EndNum: WideString): Integer;
begin
  Result := DefaultInterface.PrintReport(ReportType, StartNum, EndNum);
end;

function TOPOSFiscalPrinter.PrintXReport: Integer;
begin
  Result := DefaultInterface.PrintXReport;
end;

function TOPOSFiscalPrinter.PrintZReport: Integer;
begin
  Result := DefaultInterface.PrintZReport;
end;

function TOPOSFiscalPrinter.ResetPrinter: Integer;
begin
  Result := DefaultInterface.ResetPrinter;
end;

function TOPOSFiscalPrinter.SetDate(const Date: WideString): Integer;
begin
  Result := DefaultInterface.SetDate(Date);
end;

function TOPOSFiscalPrinter.SetHeaderLine(LineNumber: Integer; const Text: WideString; 
                                          DoubleWidth: WordBool): Integer;
begin
  Result := DefaultInterface.SetHeaderLine(LineNumber, Text, DoubleWidth);
end;

function TOPOSFiscalPrinter.SetPOSID(const POSID: WideString; const CashierID: WideString): Integer;
begin
  Result := DefaultInterface.SetPOSID(POSID, CashierID);
end;

function TOPOSFiscalPrinter.SetStoreFiscalID(const ID: WideString): Integer;
begin
  Result := DefaultInterface.SetStoreFiscalID(ID);
end;

function TOPOSFiscalPrinter.SetTrailerLine(LineNumber: Integer; const Text: WideString; 
                                           DoubleWidth: WordBool): Integer;
begin
  Result := DefaultInterface.SetTrailerLine(LineNumber, Text, DoubleWidth);
end;

function TOPOSFiscalPrinter.SetVatTable: Integer;
begin
  Result := DefaultInterface.SetVatTable;
end;

function TOPOSFiscalPrinter.SetVatValue(VatID: Integer; const VatValue: WideString): Integer;
begin
  Result := DefaultInterface.SetVatValue(VatID, VatValue);
end;

function TOPOSFiscalPrinter.VerifyItem(const ItemName: WideString; VatID: Integer): Integer;
begin
  Result := DefaultInterface.VerifyItem(ItemName, VatID);
end;

function TOPOSFiscalPrinter.PrintRecCash(Amount: Currency): Integer;
begin
  Result := DefaultInterface.PrintRecCash(Amount);
end;

function TOPOSFiscalPrinter.PrintRecItemFuel(const Description: WideString; Price: Currency; 
                                             Quantity: Integer; VatInfo: Integer; 
                                             UnitPrice: Currency; const UnitName: WideString; 
                                             SpecialTax: Currency; const SpecialTaxName: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecItemFuel(Description, Price, Quantity, VatInfo, UnitPrice, 
                                              UnitName, SpecialTax, SpecialTaxName);
end;

function TOPOSFiscalPrinter.PrintRecItemFuelVoid(const Description: WideString; Price: Currency; 
                                                 VatInfo: Integer; SpecialTax: Currency): Integer;
begin
  Result := DefaultInterface.PrintRecItemFuelVoid(Description, Price, VatInfo, SpecialTax);
end;

function TOPOSFiscalPrinter.PrintRecPackageAdjustment(AdjustmentType: Integer; 
                                                      const Description: WideString; 
                                                      const VatAdjustment: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecPackageAdjustment(AdjustmentType, Description, VatAdjustment);
end;

function TOPOSFiscalPrinter.PrintRecPackageAdjustVoid(AdjustmentType: Integer; 
                                                      const VatAdjustment: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecPackageAdjustVoid(AdjustmentType, VatAdjustment);
end;

function TOPOSFiscalPrinter.PrintRecRefundVoid(const Description: WideString; Amount: Currency; 
                                               VatInfo: Integer): Integer;
begin
  Result := DefaultInterface.PrintRecRefundVoid(Description, Amount, VatInfo);
end;

function TOPOSFiscalPrinter.PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer;
begin
  Result := DefaultInterface.PrintRecSubtotalAdjustVoid(AdjustmentType, Amount);
end;

function TOPOSFiscalPrinter.PrintRecTaxID(const TaxID: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecTaxID(TaxID);
end;

function TOPOSFiscalPrinter.SetCurrency(NewCurrency: Integer): Integer;
begin
  Result := DefaultInterface.SetCurrency(NewCurrency);
end;

function TOPOSFiscalPrinter.ResetStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.ResetStatistics(StatisticsBuffer);
end;

function TOPOSFiscalPrinter.RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.RetrieveStatistics(pStatisticsBuffer);
end;

function TOPOSFiscalPrinter.UpdateStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.UpdateStatistics(StatisticsBuffer);
end;

function TOPOSFiscalPrinter.CompareFirmwareVersion(const FirmwareFileName: WideString; 
                                                   out pResult: Integer): Integer;
begin
  Result := DefaultInterface.CompareFirmwareVersion(FirmwareFileName, pResult);
end;

function TOPOSFiscalPrinter.UpdateFirmware(const FirmwareFileName: WideString): Integer;
begin
  Result := DefaultInterface.UpdateFirmware(FirmwareFileName);
end;

function TOPOSFiscalPrinter.PrintRecItemAdjustmentVoid(AdjustmentType: Integer; 
                                                       const Description: WideString; 
                                                       Amount: Currency; VatInfo: Integer): Integer;
begin
  Result := DefaultInterface.PrintRecItemAdjustmentVoid(AdjustmentType, Description, Amount, VatInfo);
end;

function TOPOSFiscalPrinter.PrintRecItemVoid(const Description: WideString; Price: Currency; 
                                             Quantity: Integer; VatInfo: Integer; 
                                             UnitPrice: Currency; const UnitName: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecItemVoid(Description, Price, Quantity, VatInfo, UnitPrice, 
                                              UnitName);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TOPOSFiscalPrinter]);
end;

end.
