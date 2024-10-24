﻿unit NeoFiscalPrinterDriver_TLB;

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

// $Rev: 45604 $
// File generated on 07.02.2019 11:56:42 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files (x86)\ICS-Market\NeoFiscalPrinterDriver(x86)\Win32\NeoFiscalPrinterDriver.dll (1)
// LIBID: {5E45EB45-52F2-4BCA-BCEB-46580A814108}
// LCID: 0
// Helpfile: C:\Program Files (x86)\ICS-Market\NeoFiscalPrinterDriver(x86)\Win32\NeoFiscalPrinterDriver.hlp 
// HelpString: Драйвер для одностанционных фискальных принтеров IKC с КЛЭФ
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Error creating palette bitmap of (TICS_EP_08) : Registry key CLSID\{929C8C31-D325-4AF5-9097-AA9DACBD62B6}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_EP_09) : Registry key CLSID\{6FAF49AE-F551-4D37-8666-6F8645DCBC4B}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_EP_11) : Registry key CLSID\{9199EB5C-C165-4434-A6BB-9657BC640E38}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_MZ_09) : Registry key CLSID\{797961A8-DBE6-4C39-BB0C-34A91A133A82}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_MZ_11) : Registry key CLSID\{45F5B9D0-D6D5-45EF-86E6-520A07D394A4}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_MF_09) : Registry key CLSID\{E2428CCC-64C1-4ABE-AED7-FE6D8092854B}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_MF_11) : Registry key CLSID\{FF5A7BBE-CEE6-48FD-A3D2-6255851B3BFE}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_Modem) : Registry key CLSID\{40923073-DFC8-492C-A178-3DC5AEC1BCCE}\ToolboxBitmap32 not found
//   Error creating palette bitmap of (TICS_Modem_08) : Registry key CLSID\{CBAA4B5F-A9C3-4C59-91CD-BEAA5B65E3F8}\ToolboxBitmap32 not found
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
  NeoFiscalPrinterDriverMajorVersion = 1;
  NeoFiscalPrinterDriverMinorVersion = 0;

  LIBID_NeoFiscalPrinterDriver: TGUID = '{5E45EB45-52F2-4BCA-BCEB-46580A814108}';

  IID_IICS_EP_08: TGUID = '{42003CF2-1366-4180-96B8-4D10C7CD6D01}';
  CLASS_ICS_EP_08: TGUID = '{929C8C31-D325-4AF5-9097-AA9DACBD62B6}';
  IID_IICS_EP_09: TGUID = '{EF8A85E4-3A5B-4921-A2D9-2612F50EE281}';
  CLASS_ICS_EP_09: TGUID = '{6FAF49AE-F551-4D37-8666-6F8645DCBC4B}';
  IID_IICS_EP_11: TGUID = '{C6064DD9-12C6-455C-83CB-B4EEB46337FE}';
  CLASS_ICS_EP_11: TGUID = '{9199EB5C-C165-4434-A6BB-9657BC640E38}';
  IID_IICS_MZ_09: TGUID = '{2EE9B207-1A8A-46AD-9CE0-1D0469EE700A}';
  CLASS_ICS_MZ_09: TGUID = '{797961A8-DBE6-4C39-BB0C-34A91A133A82}';
  IID_IICS_MZ_11: TGUID = '{B2B43776-59B3-4C3B-8998-5314752D4BD5}';
  CLASS_ICS_MZ_11: TGUID = '{45F5B9D0-D6D5-45EF-86E6-520A07D394A4}';
  IID_IICS_MF_09: TGUID = '{00356DEF-AC8B-46A1-B477-4883345AC8CF}';
  CLASS_ICS_MF_09: TGUID = '{E2428CCC-64C1-4ABE-AED7-FE6D8092854B}';
  IID_IICS_MF_11: TGUID = '{2CCFE5E2-19DF-428F-9E82-BE55E7AEB567}';
  CLASS_ICS_MF_11: TGUID = '{FF5A7BBE-CEE6-48FD-A3D2-6255851B3BFE}';
  IID_IICS_Modem: TGUID = '{6D045EBD-5B24-4099-A7B5-7B0813D1741A}';
  CLASS_ICS_Modem: TGUID = '{40923073-DFC8-492C-A178-3DC5AEC1BCCE}';
  CLASS_ICS_Modem_08: TGUID = '{CBAA4B5F-A9C3-4C59-91CD-BEAA5B65E3F8}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IICS_EP_08 = interface;
  IICS_EP_08Disp = dispinterface;
  IICS_EP_09 = interface;
  IICS_EP_09Disp = dispinterface;
  IICS_EP_11 = interface;
  IICS_EP_11Disp = dispinterface;
  IICS_MZ_09 = interface;
  IICS_MZ_09Disp = dispinterface;
  IICS_MZ_11 = interface;
  IICS_MZ_11Disp = dispinterface;
  IICS_MF_09 = interface;
  IICS_MF_09Disp = dispinterface;
  IICS_MF_11 = interface;
  IICS_MF_11Disp = dispinterface;
  IICS_Modem = interface;
  IICS_ModemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ICS_EP_08 = IICS_EP_08;
  ICS_EP_09 = IICS_EP_09;
  ICS_EP_11 = IICS_EP_11;
  ICS_MZ_09 = IICS_MZ_09;
  ICS_MZ_11 = IICS_MZ_11;
  ICS_MF_09 = IICS_MF_09;
  ICS_MF_11 = IICS_MF_11;
  ICS_Modem = IICS_Modem;
  ICS_Modem_08 = IICS_Modem;


// *********************************************************************//
// Interface: IICS_EP_08
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {42003CF2-1366-4180-96B8-4D10C7CD6D01}
// *********************************************************************//
  IICS_EP_08 = interface(IDispatch)
    ['{42003CF2-1366-4180-96B8-4D10C7CD6D01}']
    function FPInitialize: Integer; safecall;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; safecall;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; safecall;
    function FPClose: WordBool; safecall;
    function FPClaimUSBDevice: WordBool; safecall;
    function FPReleaseUSBDevice: WordBool; safecall;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; safecall;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; safecall;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; safecall;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; safecall;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; safecall;
    function FPPrintZeroReceipt: WordBool; safecall;
    function FPLineFeed: WordBool; safecall;
    function FPAnnulReceipt: WordBool; safecall;
    function FPCashIn(CashSum: SYSUINT): WordBool; safecall;
    function FPCashOut(CashSum: SYSUINT): WordBool; safecall;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; safecall;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; safecall;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; safecall;
    function FPGetCurrentDate: WordBool; safecall;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; safecall;
    function FPGetCurrentTime: WordBool; safecall;
    function FPOpenCashDrawer(Duration: Word): WordBool; safecall;
    function FPPrintHardwareVersion: WordBool; safecall;
    function FPPrintLastKsefPacket: WordBool; safecall;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool; safecall;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; safecall;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; safecall;
    function FPOnlineModeSwitch: WordBool; safecall;
    function FPCustomerDisplayModeSwitch: WordBool; safecall;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; safecall;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; safecall;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; safecall;
    function FPCloseServiceReport: WordBool; safecall;
    function FPEnableLogo(ProgPassword: Word): WordBool; safecall;
    function FPDisableLogo(ProgPassword: Word): WordBool; safecall;
    function FPSetTaxRates(ProgPassword: Word): WordBool; safecall;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; safecall;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; safecall;
    function FPMakeXReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeZReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; safecall;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; safecall;
    function FPCutterModeSwitch: WordBool; safecall;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; safecall;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; safecall;
    function FPGetPaymentFormNames: WordBool; safecall;
    function FPGetCurrentStatus: WordBool; safecall;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; safecall;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; safecall;
    function FPGetCashDrawerSum: WordBool; safecall;
    function FPGetDayReportProperties: WordBool; safecall;
    function FPGetTaxRates: WordBool; safecall;
    function FPGetItemData(ItemCode: Int64): WordBool; safecall;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; safecall;
    function FPGetDayReportData: WordBool; safecall;
    function FPGetCurrentReceiptData: WordBool; safecall;
    function FPGetDayCorrectionsData: WordBool; safecall;
    function FPGetDaySumOfAddTaxes: WordBool; safecall;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; safecall;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; safecall;
    function FPPrintModemStatus: WordBool; safecall;
    function FPGetUserPassword(UserID: Byte): WordBool; safecall;
    function FPGetRevizionID: WordBool; safecall;
    function Get_glTapeAnalizer: WordBool; safecall;
    procedure Set_glTapeAnalizer(Value: WordBool); safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_glVirtualPortOpened: WordBool; safecall;
    function Get_glUseVirtualPort: WordBool; safecall;
    procedure Set_glUseVirtualPort(Value: WordBool); safecall;
    function Get_stUseAdditionalTax: WordBool; safecall;
    function Get_stUseAdditionalFee: WordBool; safecall;
    function Get_stUseFontB: WordBool; safecall;
    function Get_stUseTradeLogo: WordBool; safecall;
    function Get_stUseCutter: WordBool; safecall;
    function Get_stRefundReceiptMode: WordBool; safecall;
    function Get_stPaymentMode: WordBool; safecall;
    function Get_stFiscalMode: WordBool; safecall;
    function Get_stServiceReceiptMode: WordBool; safecall;
    function Get_stOnlinePrintMode: WordBool; safecall;
    function Get_stFailureLastCommand: WordBool; safecall;
    function Get_stFiscalDayIsOpened: WordBool; safecall;
    function Get_stReceiptIsOpened: WordBool; safecall;
    function Get_stCashDrawerIsOpened: WordBool; safecall;
    function Get_stDisplayShowSumMode: WordBool; safecall;
    function Get_prItemCost: Int64; safecall;
    function Get_prSumDiscount: Int64; safecall;
    function Get_prSumMarkup: Int64; safecall;
    function Get_prSumTotal: Int64; safecall;
    function Get_prSumBalance: Int64; safecall;
    function Get_prKSEFPacket: LongWord; safecall;
    function Get_prKSEFPacketStr: WideString; safecall;
    function Get_prModemError: Byte; safecall;
    function Get_prCurrentDate: TDateTime; safecall;
    function Get_prCurrentDateStr: WideString; safecall;
    function Get_prCurrentTime: TDateTime; safecall;
    function Get_prCurrentTimeStr: WideString; safecall;
    function Get_prTaxRatesCount: Byte; safecall;
    procedure Set_prTaxRatesCount(Value: Byte); safecall;
    function Get_prTaxRatesDate: TDateTime; safecall;
    function Get_prTaxRatesDateStr: WideString; safecall;
    function Get_prAddTaxType: WordBool; safecall;
    procedure Set_prAddTaxType(Value: WordBool); safecall;
    function Get_prTaxRate1: SYSINT; safecall;
    procedure Set_prTaxRate1(Value: SYSINT); safecall;
    function Get_prTaxRate2: SYSINT; safecall;
    procedure Set_prTaxRate2(Value: SYSINT); safecall;
    function Get_prTaxRate3: SYSINT; safecall;
    procedure Set_prTaxRate3(Value: SYSINT); safecall;
    function Get_prTaxRate4: SYSINT; safecall;
    procedure Set_prTaxRate4(Value: SYSINT); safecall;
    function Get_prTaxRate5: SYSINT; safecall;
    procedure Set_prTaxRate5(Value: SYSINT); safecall;
    function Get_prTaxRate6: SYSINT; safecall;
    function Get_prUsedAdditionalFee: WordBool; safecall;
    procedure Set_prUsedAdditionalFee(Value: WordBool); safecall;
    function Get_prAddFeeRate1: SYSINT; safecall;
    procedure Set_prAddFeeRate1(Value: SYSINT); safecall;
    function Get_prAddFeeRate2: SYSINT; safecall;
    procedure Set_prAddFeeRate2(Value: SYSINT); safecall;
    function Get_prAddFeeRate3: SYSINT; safecall;
    procedure Set_prAddFeeRate3(Value: SYSINT); safecall;
    function Get_prAddFeeRate4: SYSINT; safecall;
    procedure Set_prAddFeeRate4(Value: SYSINT); safecall;
    function Get_prAddFeeRate5: SYSINT; safecall;
    procedure Set_prAddFeeRate5(Value: SYSINT); safecall;
    function Get_prAddFeeRate6: SYSINT; safecall;
    procedure Set_prAddFeeRate6(Value: SYSINT); safecall;
    function Get_prTaxOnAddFee1: WordBool; safecall;
    procedure Set_prTaxOnAddFee1(Value: WordBool); safecall;
    function Get_prTaxOnAddFee2: WordBool; safecall;
    procedure Set_prTaxOnAddFee2(Value: WordBool); safecall;
    function Get_prTaxOnAddFee3: WordBool; safecall;
    procedure Set_prTaxOnAddFee3(Value: WordBool); safecall;
    function Get_prTaxOnAddFee4: WordBool; safecall;
    procedure Set_prTaxOnAddFee4(Value: WordBool); safecall;
    function Get_prTaxOnAddFee5: WordBool; safecall;
    procedure Set_prTaxOnAddFee5(Value: WordBool); safecall;
    function Get_prTaxOnAddFee6: WordBool; safecall;
    procedure Set_prTaxOnAddFee6(Value: WordBool); safecall;
    function Get_prNamePaymentForm1: WideString; safecall;
    function Get_prNamePaymentForm2: WideString; safecall;
    function Get_prNamePaymentForm3: WideString; safecall;
    function Get_prNamePaymentForm4: WideString; safecall;
    function Get_prNamePaymentForm5: WideString; safecall;
    function Get_prNamePaymentForm6: WideString; safecall;
    function Get_prNamePaymentForm7: WideString; safecall;
    function Get_prNamePaymentForm8: WideString; safecall;
    function Get_prNamePaymentForm9: WideString; safecall;
    function Get_prNamePaymentForm10: WideString; safecall;
    function Get_prSerialNumber: WideString; safecall;
    function Get_prFiscalNumber: WideString; safecall;
    function Get_prTaxNumber: WideString; safecall;
    function Get_prDateFiscalization: TDateTime; safecall;
    function Get_prDateFiscalizationStr: WideString; safecall;
    function Get_prTimeFiscalization: TDateTime; safecall;
    function Get_prTimeFiscalizationStr: WideString; safecall;
    function Get_prHeadLine1: WideString; safecall;
    function Get_prHeadLine2: WideString; safecall;
    function Get_prHeadLine3: WideString; safecall;
    function Get_prHardwareVersion: WideString; safecall;
    function Get_prItemName: WideString; safecall;
    function Get_prItemPrice: SYSINT; safecall;
    function Get_prItemSaleQuantity: SYSINT; safecall;
    function Get_prItemSaleQtyPrecision: Byte; safecall;
    function Get_prItemTax: Byte; safecall;
    function Get_prItemSaleSum: Int64; safecall;
    function Get_prItemSaleSumStr: WideString; safecall;
    function Get_prItemRefundQuantity: SYSINT; safecall;
    function Get_prItemRefundQtyPrecision: Byte; safecall;
    function Get_prItemRefundSum: Int64; safecall;
    function Get_prItemRefundSumStr: WideString; safecall;
    function Get_prItemCostStr: WideString; safecall;
    function Get_prSumDiscountStr: WideString; safecall;
    function Get_prSumMarkupStr: WideString; safecall;
    function Get_prSumTotalStr: WideString; safecall;
    function Get_prSumBalanceStr: WideString; safecall;
    function Get_prCurReceiptTax1Sum: LongWord; safecall;
    function Get_prCurReceiptTax2Sum: LongWord; safecall;
    function Get_prCurReceiptTax3Sum: LongWord; safecall;
    function Get_prCurReceiptTax4Sum: LongWord; safecall;
    function Get_prCurReceiptTax5Sum: LongWord; safecall;
    function Get_prCurReceiptTax6Sum: LongWord; safecall;
    function Get_prCurReceiptTax1SumStr: WideString; safecall;
    function Get_prCurReceiptTax2SumStr: WideString; safecall;
    function Get_prCurReceiptTax3SumStr: WideString; safecall;
    function Get_prCurReceiptTax4SumStr: WideString; safecall;
    function Get_prCurReceiptTax5SumStr: WideString; safecall;
    function Get_prCurReceiptTax6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm1Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm2Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm3Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm4Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm5Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm6Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm7Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm8Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm9Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm10Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm1SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm2SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm3SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm4SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm5SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm7SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm8SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm9SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm10SumStr: WideString; safecall;
    function Get_prPrinterError: WordBool; safecall;
    function Get_prTapeNearEnd: WordBool; safecall;
    function Get_prTapeEnded: WordBool; safecall;
    function Get_prDaySaleReceiptsCount: Word; safecall;
    function Get_prDaySaleReceiptsCountStr: WideString; safecall;
    function Get_prDayRefundReceiptsCount: Word; safecall;
    function Get_prDayRefundReceiptsCountStr: WideString; safecall;
    function Get_prDaySaleSumOnTax1: LongWord; safecall;
    function Get_prDaySaleSumOnTax2: LongWord; safecall;
    function Get_prDaySaleSumOnTax3: LongWord; safecall;
    function Get_prDaySaleSumOnTax4: LongWord; safecall;
    function Get_prDaySaleSumOnTax5: LongWord; safecall;
    function Get_prDaySaleSumOnTax6: LongWord; safecall;
    function Get_prDaySaleSumOnTax1Str: WideString; safecall;
    function Get_prDaySaleSumOnTax2Str: WideString; safecall;
    function Get_prDaySaleSumOnTax3Str: WideString; safecall;
    function Get_prDaySaleSumOnTax4Str: WideString; safecall;
    function Get_prDaySaleSumOnTax5Str: WideString; safecall;
    function Get_prDaySaleSumOnTax6Str: WideString; safecall;
    function Get_prDayRefundSumOnTax1: LongWord; safecall;
    function Get_prDayRefundSumOnTax2: LongWord; safecall;
    function Get_prDayRefundSumOnTax3: LongWord; safecall;
    function Get_prDayRefundSumOnTax4: LongWord; safecall;
    function Get_prDayRefundSumOnTax5: LongWord; safecall;
    function Get_prDayRefundSumOnTax6: LongWord; safecall;
    function Get_prDayRefundSumOnTax1Str: WideString; safecall;
    function Get_prDayRefundSumOnTax2Str: WideString; safecall;
    function Get_prDayRefundSumOnTax3Str: WideString; safecall;
    function Get_prDayRefundSumOnTax4Str: WideString; safecall;
    function Get_prDayRefundSumOnTax5Str: WideString; safecall;
    function Get_prDayRefundSumOnTax6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm1: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm2: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm3: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm4: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm5: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm6: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm7: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm8: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm9: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm10: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm1Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm2Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm3Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm4Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm5Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm7Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm8Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm9Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm10Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm1: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm2: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm3: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm4: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm5: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm6: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm7: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm8: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm9: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm10: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm1Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm2Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm3Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm4Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm5Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm6Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm7Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm8Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm9Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm10Str: WideString; safecall;
    function Get_prDayDiscountSumOnSales: LongWord; safecall;
    function Get_prDayDiscountSumOnSalesStr: WideString; safecall;
    function Get_prDayMarkupSumOnSales: LongWord; safecall;
    function Get_prDayMarkupSumOnSalesStr: WideString; safecall;
    function Get_prDayDiscountSumOnRefunds: LongWord; safecall;
    function Get_prDayDiscountSumOnRefundsStr: WideString; safecall;
    function Get_prDayMarkupSumOnRefunds: LongWord; safecall;
    function Get_prDayMarkupSumOnRefundsStr: WideString; safecall;
    function Get_prDayCashInSum: LongWord; safecall;
    function Get_prDayCashInSumStr: WideString; safecall;
    function Get_prDayCashOutSum: LongWord; safecall;
    function Get_prDayCashOutSumStr: WideString; safecall;
    function Get_prCurrentZReport: Word; safecall;
    function Get_prCurrentZReportStr: WideString; safecall;
    function Get_prDayEndDate: TDateTime; safecall;
    function Get_prDayEndDateStr: WideString; safecall;
    function Get_prDayEndTime: TDateTime; safecall;
    function Get_prDayEndTimeStr: WideString; safecall;
    function Get_prLastZReportDate: TDateTime; safecall;
    function Get_prLastZReportDateStr: WideString; safecall;
    function Get_prItemsCount: Word; safecall;
    function Get_prItemsCountStr: WideString; safecall;
    function Get_prDaySumAddTaxOfSale1: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale2: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale3: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale4: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale5: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale6: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale6Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund1: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund2: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund3: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund4: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund5: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund6: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund6Str: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsCount: Word; safecall;
    function Get_prDayAnnuledSaleReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsCount: Word; safecall;
    function Get_prDayAnnuledRefundReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledSaleReceiptsSumStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledRefundReceiptsSumStr: WideString; safecall;
    function Get_prDaySaleCancelingsCount: Word; safecall;
    function Get_prDaySaleCancelingsCountStr: WideString; safecall;
    function Get_prDayRefundCancelingsCount: Word; safecall;
    function Get_prDayRefundCancelingsCountStr: WideString; safecall;
    function Get_prDaySaleCancelingsSum: LongWord; safecall;
    function Get_prDaySaleCancelingsSumStr: WideString; safecall;
    function Get_prDayRefundCancelingsSum: LongWord; safecall;
    function Get_prDayRefundCancelingsSumStr: WideString; safecall;
    function Get_prCashDrawerSum: Int64; safecall;
    function Get_prCashDrawerSumStr: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prGetStatusByte: Byte; safecall;
    function Get_prGetResultByte: Byte; safecall;
    function Get_prGetReserveByte: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prCurReceiptItemCount: Byte; safecall;
    function Get_prUserPassword: Word; safecall;
    function Get_prUserPasswordStr: WideString; safecall;
    function Get_prRevizionID: Byte; safecall;
    function Get_prFPDriverMajorVersion: Byte; safecall;
    function Get_prFPDriverMinorVersion: Byte; safecall;
    function Get_prFPDriverReleaseVersion: Byte; safecall;
    function Get_prFPDriverBuildVersion: Byte; safecall;
    property glTapeAnalizer: WordBool read Get_glTapeAnalizer write Set_glTapeAnalizer;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property glVirtualPortOpened: WordBool read Get_glVirtualPortOpened;
    property glUseVirtualPort: WordBool read Get_glUseVirtualPort write Set_glUseVirtualPort;
    property stUseAdditionalTax: WordBool read Get_stUseAdditionalTax;
    property stUseAdditionalFee: WordBool read Get_stUseAdditionalFee;
    property stUseFontB: WordBool read Get_stUseFontB;
    property stUseTradeLogo: WordBool read Get_stUseTradeLogo;
    property stUseCutter: WordBool read Get_stUseCutter;
    property stRefundReceiptMode: WordBool read Get_stRefundReceiptMode;
    property stPaymentMode: WordBool read Get_stPaymentMode;
    property stFiscalMode: WordBool read Get_stFiscalMode;
    property stServiceReceiptMode: WordBool read Get_stServiceReceiptMode;
    property stOnlinePrintMode: WordBool read Get_stOnlinePrintMode;
    property stFailureLastCommand: WordBool read Get_stFailureLastCommand;
    property stFiscalDayIsOpened: WordBool read Get_stFiscalDayIsOpened;
    property stReceiptIsOpened: WordBool read Get_stReceiptIsOpened;
    property stCashDrawerIsOpened: WordBool read Get_stCashDrawerIsOpened;
    property stDisplayShowSumMode: WordBool read Get_stDisplayShowSumMode;
    property prItemCost: Int64 read Get_prItemCost;
    property prSumDiscount: Int64 read Get_prSumDiscount;
    property prSumMarkup: Int64 read Get_prSumMarkup;
    property prSumTotal: Int64 read Get_prSumTotal;
    property prSumBalance: Int64 read Get_prSumBalance;
    property prKSEFPacket: LongWord read Get_prKSEFPacket;
    property prKSEFPacketStr: WideString read Get_prKSEFPacketStr;
    property prModemError: Byte read Get_prModemError;
    property prCurrentDate: TDateTime read Get_prCurrentDate;
    property prCurrentDateStr: WideString read Get_prCurrentDateStr;
    property prCurrentTime: TDateTime read Get_prCurrentTime;
    property prCurrentTimeStr: WideString read Get_prCurrentTimeStr;
    property prTaxRatesCount: Byte read Get_prTaxRatesCount write Set_prTaxRatesCount;
    property prTaxRatesDate: TDateTime read Get_prTaxRatesDate;
    property prTaxRatesDateStr: WideString read Get_prTaxRatesDateStr;
    property prAddTaxType: WordBool read Get_prAddTaxType write Set_prAddTaxType;
    property prTaxRate1: SYSINT read Get_prTaxRate1 write Set_prTaxRate1;
    property prTaxRate2: SYSINT read Get_prTaxRate2 write Set_prTaxRate2;
    property prTaxRate3: SYSINT read Get_prTaxRate3 write Set_prTaxRate3;
    property prTaxRate4: SYSINT read Get_prTaxRate4 write Set_prTaxRate4;
    property prTaxRate5: SYSINT read Get_prTaxRate5 write Set_prTaxRate5;
    property prTaxRate6: SYSINT read Get_prTaxRate6;
    property prUsedAdditionalFee: WordBool read Get_prUsedAdditionalFee write Set_prUsedAdditionalFee;
    property prAddFeeRate1: SYSINT read Get_prAddFeeRate1 write Set_prAddFeeRate1;
    property prAddFeeRate2: SYSINT read Get_prAddFeeRate2 write Set_prAddFeeRate2;
    property prAddFeeRate3: SYSINT read Get_prAddFeeRate3 write Set_prAddFeeRate3;
    property prAddFeeRate4: SYSINT read Get_prAddFeeRate4 write Set_prAddFeeRate4;
    property prAddFeeRate5: SYSINT read Get_prAddFeeRate5 write Set_prAddFeeRate5;
    property prAddFeeRate6: SYSINT read Get_prAddFeeRate6 write Set_prAddFeeRate6;
    property prTaxOnAddFee1: WordBool read Get_prTaxOnAddFee1 write Set_prTaxOnAddFee1;
    property prTaxOnAddFee2: WordBool read Get_prTaxOnAddFee2 write Set_prTaxOnAddFee2;
    property prTaxOnAddFee3: WordBool read Get_prTaxOnAddFee3 write Set_prTaxOnAddFee3;
    property prTaxOnAddFee4: WordBool read Get_prTaxOnAddFee4 write Set_prTaxOnAddFee4;
    property prTaxOnAddFee5: WordBool read Get_prTaxOnAddFee5 write Set_prTaxOnAddFee5;
    property prTaxOnAddFee6: WordBool read Get_prTaxOnAddFee6 write Set_prTaxOnAddFee6;
    property prNamePaymentForm1: WideString read Get_prNamePaymentForm1;
    property prNamePaymentForm2: WideString read Get_prNamePaymentForm2;
    property prNamePaymentForm3: WideString read Get_prNamePaymentForm3;
    property prNamePaymentForm4: WideString read Get_prNamePaymentForm4;
    property prNamePaymentForm5: WideString read Get_prNamePaymentForm5;
    property prNamePaymentForm6: WideString read Get_prNamePaymentForm6;
    property prNamePaymentForm7: WideString read Get_prNamePaymentForm7;
    property prNamePaymentForm8: WideString read Get_prNamePaymentForm8;
    property prNamePaymentForm9: WideString read Get_prNamePaymentForm9;
    property prNamePaymentForm10: WideString read Get_prNamePaymentForm10;
    property prSerialNumber: WideString read Get_prSerialNumber;
    property prFiscalNumber: WideString read Get_prFiscalNumber;
    property prTaxNumber: WideString read Get_prTaxNumber;
    property prDateFiscalization: TDateTime read Get_prDateFiscalization;
    property prDateFiscalizationStr: WideString read Get_prDateFiscalizationStr;
    property prTimeFiscalization: TDateTime read Get_prTimeFiscalization;
    property prTimeFiscalizationStr: WideString read Get_prTimeFiscalizationStr;
    property prHeadLine1: WideString read Get_prHeadLine1;
    property prHeadLine2: WideString read Get_prHeadLine2;
    property prHeadLine3: WideString read Get_prHeadLine3;
    property prHardwareVersion: WideString read Get_prHardwareVersion;
    property prItemName: WideString read Get_prItemName;
    property prItemPrice: SYSINT read Get_prItemPrice;
    property prItemSaleQuantity: SYSINT read Get_prItemSaleQuantity;
    property prItemSaleQtyPrecision: Byte read Get_prItemSaleQtyPrecision;
    property prItemTax: Byte read Get_prItemTax;
    property prItemSaleSum: Int64 read Get_prItemSaleSum;
    property prItemSaleSumStr: WideString read Get_prItemSaleSumStr;
    property prItemRefundQuantity: SYSINT read Get_prItemRefundQuantity;
    property prItemRefundQtyPrecision: Byte read Get_prItemRefundQtyPrecision;
    property prItemRefundSum: Int64 read Get_prItemRefundSum;
    property prItemRefundSumStr: WideString read Get_prItemRefundSumStr;
    property prItemCostStr: WideString read Get_prItemCostStr;
    property prSumDiscountStr: WideString read Get_prSumDiscountStr;
    property prSumMarkupStr: WideString read Get_prSumMarkupStr;
    property prSumTotalStr: WideString read Get_prSumTotalStr;
    property prSumBalanceStr: WideString read Get_prSumBalanceStr;
    property prCurReceiptTax1Sum: LongWord read Get_prCurReceiptTax1Sum;
    property prCurReceiptTax2Sum: LongWord read Get_prCurReceiptTax2Sum;
    property prCurReceiptTax3Sum: LongWord read Get_prCurReceiptTax3Sum;
    property prCurReceiptTax4Sum: LongWord read Get_prCurReceiptTax4Sum;
    property prCurReceiptTax5Sum: LongWord read Get_prCurReceiptTax5Sum;
    property prCurReceiptTax6Sum: LongWord read Get_prCurReceiptTax6Sum;
    property prCurReceiptTax1SumStr: WideString read Get_prCurReceiptTax1SumStr;
    property prCurReceiptTax2SumStr: WideString read Get_prCurReceiptTax2SumStr;
    property prCurReceiptTax3SumStr: WideString read Get_prCurReceiptTax3SumStr;
    property prCurReceiptTax4SumStr: WideString read Get_prCurReceiptTax4SumStr;
    property prCurReceiptTax5SumStr: WideString read Get_prCurReceiptTax5SumStr;
    property prCurReceiptTax6SumStr: WideString read Get_prCurReceiptTax6SumStr;
    property prCurReceiptPayForm1Sum: LongWord read Get_prCurReceiptPayForm1Sum;
    property prCurReceiptPayForm2Sum: LongWord read Get_prCurReceiptPayForm2Sum;
    property prCurReceiptPayForm3Sum: LongWord read Get_prCurReceiptPayForm3Sum;
    property prCurReceiptPayForm4Sum: LongWord read Get_prCurReceiptPayForm4Sum;
    property prCurReceiptPayForm5Sum: LongWord read Get_prCurReceiptPayForm5Sum;
    property prCurReceiptPayForm6Sum: LongWord read Get_prCurReceiptPayForm6Sum;
    property prCurReceiptPayForm7Sum: LongWord read Get_prCurReceiptPayForm7Sum;
    property prCurReceiptPayForm8Sum: LongWord read Get_prCurReceiptPayForm8Sum;
    property prCurReceiptPayForm9Sum: LongWord read Get_prCurReceiptPayForm9Sum;
    property prCurReceiptPayForm10Sum: LongWord read Get_prCurReceiptPayForm10Sum;
    property prCurReceiptPayForm1SumStr: WideString read Get_prCurReceiptPayForm1SumStr;
    property prCurReceiptPayForm2SumStr: WideString read Get_prCurReceiptPayForm2SumStr;
    property prCurReceiptPayForm3SumStr: WideString read Get_prCurReceiptPayForm3SumStr;
    property prCurReceiptPayForm4SumStr: WideString read Get_prCurReceiptPayForm4SumStr;
    property prCurReceiptPayForm5SumStr: WideString read Get_prCurReceiptPayForm5SumStr;
    property prCurReceiptPayForm6SumStr: WideString read Get_prCurReceiptPayForm6SumStr;
    property prCurReceiptPayForm7SumStr: WideString read Get_prCurReceiptPayForm7SumStr;
    property prCurReceiptPayForm8SumStr: WideString read Get_prCurReceiptPayForm8SumStr;
    property prCurReceiptPayForm9SumStr: WideString read Get_prCurReceiptPayForm9SumStr;
    property prCurReceiptPayForm10SumStr: WideString read Get_prCurReceiptPayForm10SumStr;
    property prPrinterError: WordBool read Get_prPrinterError;
    property prTapeNearEnd: WordBool read Get_prTapeNearEnd;
    property prTapeEnded: WordBool read Get_prTapeEnded;
    property prDaySaleReceiptsCount: Word read Get_prDaySaleReceiptsCount;
    property prDaySaleReceiptsCountStr: WideString read Get_prDaySaleReceiptsCountStr;
    property prDayRefundReceiptsCount: Word read Get_prDayRefundReceiptsCount;
    property prDayRefundReceiptsCountStr: WideString read Get_prDayRefundReceiptsCountStr;
    property prDaySaleSumOnTax1: LongWord read Get_prDaySaleSumOnTax1;
    property prDaySaleSumOnTax2: LongWord read Get_prDaySaleSumOnTax2;
    property prDaySaleSumOnTax3: LongWord read Get_prDaySaleSumOnTax3;
    property prDaySaleSumOnTax4: LongWord read Get_prDaySaleSumOnTax4;
    property prDaySaleSumOnTax5: LongWord read Get_prDaySaleSumOnTax5;
    property prDaySaleSumOnTax6: LongWord read Get_prDaySaleSumOnTax6;
    property prDaySaleSumOnTax1Str: WideString read Get_prDaySaleSumOnTax1Str;
    property prDaySaleSumOnTax2Str: WideString read Get_prDaySaleSumOnTax2Str;
    property prDaySaleSumOnTax3Str: WideString read Get_prDaySaleSumOnTax3Str;
    property prDaySaleSumOnTax4Str: WideString read Get_prDaySaleSumOnTax4Str;
    property prDaySaleSumOnTax5Str: WideString read Get_prDaySaleSumOnTax5Str;
    property prDaySaleSumOnTax6Str: WideString read Get_prDaySaleSumOnTax6Str;
    property prDayRefundSumOnTax1: LongWord read Get_prDayRefundSumOnTax1;
    property prDayRefundSumOnTax2: LongWord read Get_prDayRefundSumOnTax2;
    property prDayRefundSumOnTax3: LongWord read Get_prDayRefundSumOnTax3;
    property prDayRefundSumOnTax4: LongWord read Get_prDayRefundSumOnTax4;
    property prDayRefundSumOnTax5: LongWord read Get_prDayRefundSumOnTax5;
    property prDayRefundSumOnTax6: LongWord read Get_prDayRefundSumOnTax6;
    property prDayRefundSumOnTax1Str: WideString read Get_prDayRefundSumOnTax1Str;
    property prDayRefundSumOnTax2Str: WideString read Get_prDayRefundSumOnTax2Str;
    property prDayRefundSumOnTax3Str: WideString read Get_prDayRefundSumOnTax3Str;
    property prDayRefundSumOnTax4Str: WideString read Get_prDayRefundSumOnTax4Str;
    property prDayRefundSumOnTax5Str: WideString read Get_prDayRefundSumOnTax5Str;
    property prDayRefundSumOnTax6Str: WideString read Get_prDayRefundSumOnTax6Str;
    property prDaySaleSumOnPayForm1: LongWord read Get_prDaySaleSumOnPayForm1;
    property prDaySaleSumOnPayForm2: LongWord read Get_prDaySaleSumOnPayForm2;
    property prDaySaleSumOnPayForm3: LongWord read Get_prDaySaleSumOnPayForm3;
    property prDaySaleSumOnPayForm4: LongWord read Get_prDaySaleSumOnPayForm4;
    property prDaySaleSumOnPayForm5: LongWord read Get_prDaySaleSumOnPayForm5;
    property prDaySaleSumOnPayForm6: LongWord read Get_prDaySaleSumOnPayForm6;
    property prDaySaleSumOnPayForm7: LongWord read Get_prDaySaleSumOnPayForm7;
    property prDaySaleSumOnPayForm8: LongWord read Get_prDaySaleSumOnPayForm8;
    property prDaySaleSumOnPayForm9: LongWord read Get_prDaySaleSumOnPayForm9;
    property prDaySaleSumOnPayForm10: LongWord read Get_prDaySaleSumOnPayForm10;
    property prDaySaleSumOnPayForm1Str: WideString read Get_prDaySaleSumOnPayForm1Str;
    property prDaySaleSumOnPayForm2Str: WideString read Get_prDaySaleSumOnPayForm2Str;
    property prDaySaleSumOnPayForm3Str: WideString read Get_prDaySaleSumOnPayForm3Str;
    property prDaySaleSumOnPayForm4Str: WideString read Get_prDaySaleSumOnPayForm4Str;
    property prDaySaleSumOnPayForm5Str: WideString read Get_prDaySaleSumOnPayForm5Str;
    property prDaySaleSumOnPayForm6Str: WideString read Get_prDaySaleSumOnPayForm6Str;
    property prDaySaleSumOnPayForm7Str: WideString read Get_prDaySaleSumOnPayForm7Str;
    property prDaySaleSumOnPayForm8Str: WideString read Get_prDaySaleSumOnPayForm8Str;
    property prDaySaleSumOnPayForm9Str: WideString read Get_prDaySaleSumOnPayForm9Str;
    property prDaySaleSumOnPayForm10Str: WideString read Get_prDaySaleSumOnPayForm10Str;
    property prDayRefundSumOnPayForm1: LongWord read Get_prDayRefundSumOnPayForm1;
    property prDayRefundSumOnPayForm2: LongWord read Get_prDayRefundSumOnPayForm2;
    property prDayRefundSumOnPayForm3: LongWord read Get_prDayRefundSumOnPayForm3;
    property prDayRefundSumOnPayForm4: LongWord read Get_prDayRefundSumOnPayForm4;
    property prDayRefundSumOnPayForm5: LongWord read Get_prDayRefundSumOnPayForm5;
    property prDayRefundSumOnPayForm6: LongWord read Get_prDayRefundSumOnPayForm6;
    property prDayRefundSumOnPayForm7: LongWord read Get_prDayRefundSumOnPayForm7;
    property prDayRefundSumOnPayForm8: LongWord read Get_prDayRefundSumOnPayForm8;
    property prDayRefundSumOnPayForm9: LongWord read Get_prDayRefundSumOnPayForm9;
    property prDayRefundSumOnPayForm10: LongWord read Get_prDayRefundSumOnPayForm10;
    property prDayRefundSumOnPayForm1Str: WideString read Get_prDayRefundSumOnPayForm1Str;
    property prDayRefundSumOnPayForm2Str: WideString read Get_prDayRefundSumOnPayForm2Str;
    property prDayRefundSumOnPayForm3Str: WideString read Get_prDayRefundSumOnPayForm3Str;
    property prDayRefundSumOnPayForm4Str: WideString read Get_prDayRefundSumOnPayForm4Str;
    property prDayRefundSumOnPayForm5Str: WideString read Get_prDayRefundSumOnPayForm5Str;
    property prDayRefundSumOnPayForm6Str: WideString read Get_prDayRefundSumOnPayForm6Str;
    property prDayRefundSumOnPayForm7Str: WideString read Get_prDayRefundSumOnPayForm7Str;
    property prDayRefundSumOnPayForm8Str: WideString read Get_prDayRefundSumOnPayForm8Str;
    property prDayRefundSumOnPayForm9Str: WideString read Get_prDayRefundSumOnPayForm9Str;
    property prDayRefundSumOnPayForm10Str: WideString read Get_prDayRefundSumOnPayForm10Str;
    property prDayDiscountSumOnSales: LongWord read Get_prDayDiscountSumOnSales;
    property prDayDiscountSumOnSalesStr: WideString read Get_prDayDiscountSumOnSalesStr;
    property prDayMarkupSumOnSales: LongWord read Get_prDayMarkupSumOnSales;
    property prDayMarkupSumOnSalesStr: WideString read Get_prDayMarkupSumOnSalesStr;
    property prDayDiscountSumOnRefunds: LongWord read Get_prDayDiscountSumOnRefunds;
    property prDayDiscountSumOnRefundsStr: WideString read Get_prDayDiscountSumOnRefundsStr;
    property prDayMarkupSumOnRefunds: LongWord read Get_prDayMarkupSumOnRefunds;
    property prDayMarkupSumOnRefundsStr: WideString read Get_prDayMarkupSumOnRefundsStr;
    property prDayCashInSum: LongWord read Get_prDayCashInSum;
    property prDayCashInSumStr: WideString read Get_prDayCashInSumStr;
    property prDayCashOutSum: LongWord read Get_prDayCashOutSum;
    property prDayCashOutSumStr: WideString read Get_prDayCashOutSumStr;
    property prCurrentZReport: Word read Get_prCurrentZReport;
    property prCurrentZReportStr: WideString read Get_prCurrentZReportStr;
    property prDayEndDate: TDateTime read Get_prDayEndDate;
    property prDayEndDateStr: WideString read Get_prDayEndDateStr;
    property prDayEndTime: TDateTime read Get_prDayEndTime;
    property prDayEndTimeStr: WideString read Get_prDayEndTimeStr;
    property prLastZReportDate: TDateTime read Get_prLastZReportDate;
    property prLastZReportDateStr: WideString read Get_prLastZReportDateStr;
    property prItemsCount: Word read Get_prItemsCount;
    property prItemsCountStr: WideString read Get_prItemsCountStr;
    property prDaySumAddTaxOfSale1: LongWord read Get_prDaySumAddTaxOfSale1;
    property prDaySumAddTaxOfSale2: LongWord read Get_prDaySumAddTaxOfSale2;
    property prDaySumAddTaxOfSale3: LongWord read Get_prDaySumAddTaxOfSale3;
    property prDaySumAddTaxOfSale4: LongWord read Get_prDaySumAddTaxOfSale4;
    property prDaySumAddTaxOfSale5: LongWord read Get_prDaySumAddTaxOfSale5;
    property prDaySumAddTaxOfSale6: LongWord read Get_prDaySumAddTaxOfSale6;
    property prDaySumAddTaxOfSale1Str: WideString read Get_prDaySumAddTaxOfSale1Str;
    property prDaySumAddTaxOfSale2Str: WideString read Get_prDaySumAddTaxOfSale2Str;
    property prDaySumAddTaxOfSale3Str: WideString read Get_prDaySumAddTaxOfSale3Str;
    property prDaySumAddTaxOfSale4Str: WideString read Get_prDaySumAddTaxOfSale4Str;
    property prDaySumAddTaxOfSale5Str: WideString read Get_prDaySumAddTaxOfSale5Str;
    property prDaySumAddTaxOfSale6Str: WideString read Get_prDaySumAddTaxOfSale6Str;
    property prDaySumAddTaxOfRefund1: LongWord read Get_prDaySumAddTaxOfRefund1;
    property prDaySumAddTaxOfRefund2: LongWord read Get_prDaySumAddTaxOfRefund2;
    property prDaySumAddTaxOfRefund3: LongWord read Get_prDaySumAddTaxOfRefund3;
    property prDaySumAddTaxOfRefund4: LongWord read Get_prDaySumAddTaxOfRefund4;
    property prDaySumAddTaxOfRefund5: LongWord read Get_prDaySumAddTaxOfRefund5;
    property prDaySumAddTaxOfRefund6: LongWord read Get_prDaySumAddTaxOfRefund6;
    property prDaySumAddTaxOfRefund1Str: WideString read Get_prDaySumAddTaxOfRefund1Str;
    property prDaySumAddTaxOfRefund2Str: WideString read Get_prDaySumAddTaxOfRefund2Str;
    property prDaySumAddTaxOfRefund3Str: WideString read Get_prDaySumAddTaxOfRefund3Str;
    property prDaySumAddTaxOfRefund4Str: WideString read Get_prDaySumAddTaxOfRefund4Str;
    property prDaySumAddTaxOfRefund5Str: WideString read Get_prDaySumAddTaxOfRefund5Str;
    property prDaySumAddTaxOfRefund6Str: WideString read Get_prDaySumAddTaxOfRefund6Str;
    property prDayAnnuledSaleReceiptsCount: Word read Get_prDayAnnuledSaleReceiptsCount;
    property prDayAnnuledSaleReceiptsCountStr: WideString read Get_prDayAnnuledSaleReceiptsCountStr;
    property prDayAnnuledRefundReceiptsCount: Word read Get_prDayAnnuledRefundReceiptsCount;
    property prDayAnnuledRefundReceiptsCountStr: WideString read Get_prDayAnnuledRefundReceiptsCountStr;
    property prDayAnnuledSaleReceiptsSum: LongWord read Get_prDayAnnuledSaleReceiptsSum;
    property prDayAnnuledSaleReceiptsSumStr: WideString read Get_prDayAnnuledSaleReceiptsSumStr;
    property prDayAnnuledRefundReceiptsSum: LongWord read Get_prDayAnnuledRefundReceiptsSum;
    property prDayAnnuledRefundReceiptsSumStr: WideString read Get_prDayAnnuledRefundReceiptsSumStr;
    property prDaySaleCancelingsCount: Word read Get_prDaySaleCancelingsCount;
    property prDaySaleCancelingsCountStr: WideString read Get_prDaySaleCancelingsCountStr;
    property prDayRefundCancelingsCount: Word read Get_prDayRefundCancelingsCount;
    property prDayRefundCancelingsCountStr: WideString read Get_prDayRefundCancelingsCountStr;
    property prDaySaleCancelingsSum: LongWord read Get_prDaySaleCancelingsSum;
    property prDaySaleCancelingsSumStr: WideString read Get_prDaySaleCancelingsSumStr;
    property prDayRefundCancelingsSum: LongWord read Get_prDayRefundCancelingsSum;
    property prDayRefundCancelingsSumStr: WideString read Get_prDayRefundCancelingsSumStr;
    property prCashDrawerSum: Int64 read Get_prCashDrawerSum;
    property prCashDrawerSumStr: WideString read Get_prCashDrawerSumStr;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prGetStatusByte: Byte read Get_prGetStatusByte;
    property prGetResultByte: Byte read Get_prGetResultByte;
    property prGetReserveByte: Byte read Get_prGetReserveByte;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prCurReceiptItemCount: Byte read Get_prCurReceiptItemCount;
    property prUserPassword: Word read Get_prUserPassword;
    property prUserPasswordStr: WideString read Get_prUserPasswordStr;
    property prRevizionID: Byte read Get_prRevizionID;
    property prFPDriverMajorVersion: Byte read Get_prFPDriverMajorVersion;
    property prFPDriverMinorVersion: Byte read Get_prFPDriverMinorVersion;
    property prFPDriverReleaseVersion: Byte read Get_prFPDriverReleaseVersion;
    property prFPDriverBuildVersion: Byte read Get_prFPDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_EP_08Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {42003CF2-1366-4180-96B8-4D10C7CD6D01}
// *********************************************************************//
  IICS_EP_08Disp = dispinterface
    ['{42003CF2-1366-4180-96B8-4D10C7CD6D01}']
    function FPInitialize: Integer; dispid 433;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; dispid 201;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; dispid 202;
    function FPClose: WordBool; dispid 203;
    function FPClaimUSBDevice: WordBool; dispid 548;
    function FPReleaseUSBDevice: WordBool; dispid 549;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; dispid 204;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; dispid 205;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 206;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; dispid 207;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 208;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; dispid 209;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; dispid 210;
    function FPPrintZeroReceipt: WordBool; dispid 211;
    function FPLineFeed: WordBool; dispid 212;
    function FPAnnulReceipt: WordBool; dispid 213;
    function FPCashIn(CashSum: SYSUINT): WordBool; dispid 214;
    function FPCashOut(CashSum: SYSUINT): WordBool; dispid 215;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; dispid 216;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; dispid 217;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; dispid 218;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; dispid 219;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; dispid 220;
    function FPGetCurrentDate: WordBool; dispid 221;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; dispid 222;
    function FPGetCurrentTime: WordBool; dispid 223;
    function FPOpenCashDrawer(Duration: Word): WordBool; dispid 224;
    function FPPrintHardwareVersion: WordBool; dispid 225;
    function FPPrintLastKsefPacket: WordBool; dispid 226;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool; dispid 227;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; dispid 228;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; dispid 229;
    function FPOnlineModeSwitch: WordBool; dispid 230;
    function FPCustomerDisplayModeSwitch: WordBool; dispid 231;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; dispid 232;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; dispid 233;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; dispid 234;
    function FPCloseServiceReport: WordBool; dispid 235;
    function FPEnableLogo(ProgPassword: Word): WordBool; dispid 236;
    function FPDisableLogo(ProgPassword: Word): WordBool; dispid 237;
    function FPSetTaxRates(ProgPassword: Word): WordBool; dispid 238;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; dispid 239;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; dispid 240;
    function FPMakeXReport(ReportPassword: Word): WordBool; dispid 241;
    function FPMakeZReport(ReportPassword: Word): WordBool; dispid 242;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; dispid 243;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; dispid 244;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; dispid 245;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; dispid 246;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; dispid 247;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; dispid 248;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; dispid 249;
    function FPCutterModeSwitch: WordBool; dispid 250;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; dispid 251;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; dispid 539;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; dispid 252;
    function FPGetPaymentFormNames: WordBool; dispid 435;
    function FPGetCurrentStatus: WordBool; dispid 440;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; dispid 442;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; dispid 443;
    function FPGetCashDrawerSum: WordBool; dispid 444;
    function FPGetDayReportProperties: WordBool; dispid 445;
    function FPGetTaxRates: WordBool; dispid 446;
    function FPGetItemData(ItemCode: Int64): WordBool; dispid 447;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; dispid 448;
    function FPGetDayReportData: WordBool; dispid 449;
    function FPGetCurrentReceiptData: WordBool; dispid 450;
    function FPGetDayCorrectionsData: WordBool; dispid 452;
    function FPGetDaySumOfAddTaxes: WordBool; dispid 453;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; dispid 454;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; dispid 455;
    function FPPrintModemStatus: WordBool; dispid 456;
    function FPGetUserPassword(UserID: Byte): WordBool; dispid 535;
    function FPGetRevizionID: WordBool; dispid 540;
    property glTapeAnalizer: WordBool dispid 253;
    property glPropertiesAutoUpdateMode: WordBool dispid 254;
    property glCodepageOEM: WordBool dispid 255;
    property glLangID: Byte dispid 256;
    property glVirtualPortOpened: WordBool readonly dispid 546;
    property glUseVirtualPort: WordBool dispid 547;
    property stUseAdditionalTax: WordBool readonly dispid 415;
    property stUseAdditionalFee: WordBool readonly dispid 416;
    property stUseFontB: WordBool readonly dispid 417;
    property stUseTradeLogo: WordBool readonly dispid 418;
    property stUseCutter: WordBool readonly dispid 419;
    property stRefundReceiptMode: WordBool readonly dispid 420;
    property stPaymentMode: WordBool readonly dispid 421;
    property stFiscalMode: WordBool readonly dispid 422;
    property stServiceReceiptMode: WordBool readonly dispid 423;
    property stOnlinePrintMode: WordBool readonly dispid 424;
    property stFailureLastCommand: WordBool readonly dispid 425;
    property stFiscalDayIsOpened: WordBool readonly dispid 426;
    property stReceiptIsOpened: WordBool readonly dispid 427;
    property stCashDrawerIsOpened: WordBool readonly dispid 428;
    property stDisplayShowSumMode: WordBool readonly dispid 441;
    property prItemCost: Int64 readonly dispid 257;
    property prSumDiscount: Int64 readonly dispid 258;
    property prSumMarkup: Int64 readonly dispid 259;
    property prSumTotal: Int64 readonly dispid 260;
    property prSumBalance: Int64 readonly dispid 261;
    property prKSEFPacket: LongWord readonly dispid 262;
    property prKSEFPacketStr: WideString readonly dispid 538;
    property prModemError: Byte readonly dispid 263;
    property prCurrentDate: TDateTime readonly dispid 264;
    property prCurrentDateStr: WideString readonly dispid 265;
    property prCurrentTime: TDateTime readonly dispid 266;
    property prCurrentTimeStr: WideString readonly dispid 267;
    property prTaxRatesCount: Byte dispid 268;
    property prTaxRatesDate: TDateTime readonly dispid 269;
    property prTaxRatesDateStr: WideString readonly dispid 270;
    property prAddTaxType: WordBool dispid 271;
    property prTaxRate1: SYSINT dispid 272;
    property prTaxRate2: SYSINT dispid 273;
    property prTaxRate3: SYSINT dispid 274;
    property prTaxRate4: SYSINT dispid 275;
    property prTaxRate5: SYSINT dispid 276;
    property prTaxRate6: SYSINT readonly dispid 277;
    property prUsedAdditionalFee: WordBool dispid 278;
    property prAddFeeRate1: SYSINT dispid 279;
    property prAddFeeRate2: SYSINT dispid 280;
    property prAddFeeRate3: SYSINT dispid 281;
    property prAddFeeRate4: SYSINT dispid 282;
    property prAddFeeRate5: SYSINT dispid 283;
    property prAddFeeRate6: SYSINT dispid 284;
    property prTaxOnAddFee1: WordBool dispid 285;
    property prTaxOnAddFee2: WordBool dispid 286;
    property prTaxOnAddFee3: WordBool dispid 287;
    property prTaxOnAddFee4: WordBool dispid 288;
    property prTaxOnAddFee5: WordBool dispid 289;
    property prTaxOnAddFee6: WordBool dispid 290;
    property prNamePaymentForm1: WideString readonly dispid 291;
    property prNamePaymentForm2: WideString readonly dispid 292;
    property prNamePaymentForm3: WideString readonly dispid 293;
    property prNamePaymentForm4: WideString readonly dispid 294;
    property prNamePaymentForm5: WideString readonly dispid 295;
    property prNamePaymentForm6: WideString readonly dispid 296;
    property prNamePaymentForm7: WideString readonly dispid 297;
    property prNamePaymentForm8: WideString readonly dispid 298;
    property prNamePaymentForm9: WideString readonly dispid 299;
    property prNamePaymentForm10: WideString readonly dispid 300;
    property prSerialNumber: WideString readonly dispid 301;
    property prFiscalNumber: WideString readonly dispid 302;
    property prTaxNumber: WideString readonly dispid 303;
    property prDateFiscalization: TDateTime readonly dispid 304;
    property prDateFiscalizationStr: WideString readonly dispid 305;
    property prTimeFiscalization: TDateTime readonly dispid 306;
    property prTimeFiscalizationStr: WideString readonly dispid 307;
    property prHeadLine1: WideString readonly dispid 308;
    property prHeadLine2: WideString readonly dispid 309;
    property prHeadLine3: WideString readonly dispid 310;
    property prHardwareVersion: WideString readonly dispid 311;
    property prItemName: WideString readonly dispid 312;
    property prItemPrice: SYSINT readonly dispid 313;
    property prItemSaleQuantity: SYSINT readonly dispid 314;
    property prItemSaleQtyPrecision: Byte readonly dispid 315;
    property prItemTax: Byte readonly dispid 316;
    property prItemSaleSum: Int64 readonly dispid 317;
    property prItemSaleSumStr: WideString readonly dispid 318;
    property prItemRefundQuantity: SYSINT readonly dispid 319;
    property prItemRefundQtyPrecision: Byte readonly dispid 320;
    property prItemRefundSum: Int64 readonly dispid 321;
    property prItemRefundSumStr: WideString readonly dispid 322;
    property prItemCostStr: WideString readonly dispid 323;
    property prSumDiscountStr: WideString readonly dispid 324;
    property prSumMarkupStr: WideString readonly dispid 325;
    property prSumTotalStr: WideString readonly dispid 326;
    property prSumBalanceStr: WideString readonly dispid 327;
    property prCurReceiptTax1Sum: LongWord readonly dispid 328;
    property prCurReceiptTax2Sum: LongWord readonly dispid 329;
    property prCurReceiptTax3Sum: LongWord readonly dispid 330;
    property prCurReceiptTax4Sum: LongWord readonly dispid 331;
    property prCurReceiptTax5Sum: LongWord readonly dispid 332;
    property prCurReceiptTax6Sum: LongWord readonly dispid 333;
    property prCurReceiptTax1SumStr: WideString readonly dispid 457;
    property prCurReceiptTax2SumStr: WideString readonly dispid 458;
    property prCurReceiptTax3SumStr: WideString readonly dispid 459;
    property prCurReceiptTax4SumStr: WideString readonly dispid 460;
    property prCurReceiptTax5SumStr: WideString readonly dispid 461;
    property prCurReceiptTax6SumStr: WideString readonly dispid 462;
    property prCurReceiptPayForm1Sum: LongWord readonly dispid 334;
    property prCurReceiptPayForm2Sum: LongWord readonly dispid 335;
    property prCurReceiptPayForm3Sum: LongWord readonly dispid 336;
    property prCurReceiptPayForm4Sum: LongWord readonly dispid 337;
    property prCurReceiptPayForm5Sum: LongWord readonly dispid 338;
    property prCurReceiptPayForm6Sum: LongWord readonly dispid 339;
    property prCurReceiptPayForm7Sum: LongWord readonly dispid 340;
    property prCurReceiptPayForm8Sum: LongWord readonly dispid 341;
    property prCurReceiptPayForm9Sum: LongWord readonly dispid 342;
    property prCurReceiptPayForm10Sum: LongWord readonly dispid 343;
    property prCurReceiptPayForm1SumStr: WideString readonly dispid 463;
    property prCurReceiptPayForm2SumStr: WideString readonly dispid 464;
    property prCurReceiptPayForm3SumStr: WideString readonly dispid 465;
    property prCurReceiptPayForm4SumStr: WideString readonly dispid 466;
    property prCurReceiptPayForm5SumStr: WideString readonly dispid 467;
    property prCurReceiptPayForm6SumStr: WideString readonly dispid 468;
    property prCurReceiptPayForm7SumStr: WideString readonly dispid 469;
    property prCurReceiptPayForm8SumStr: WideString readonly dispid 470;
    property prCurReceiptPayForm9SumStr: WideString readonly dispid 471;
    property prCurReceiptPayForm10SumStr: WideString readonly dispid 472;
    property prPrinterError: WordBool readonly dispid 344;
    property prTapeNearEnd: WordBool readonly dispid 345;
    property prTapeEnded: WordBool readonly dispid 346;
    property prDaySaleReceiptsCount: Word readonly dispid 347;
    property prDaySaleReceiptsCountStr: WideString readonly dispid 473;
    property prDayRefundReceiptsCount: Word readonly dispid 348;
    property prDayRefundReceiptsCountStr: WideString readonly dispid 474;
    property prDaySaleSumOnTax1: LongWord readonly dispid 349;
    property prDaySaleSumOnTax2: LongWord readonly dispid 350;
    property prDaySaleSumOnTax3: LongWord readonly dispid 351;
    property prDaySaleSumOnTax4: LongWord readonly dispid 352;
    property prDaySaleSumOnTax5: LongWord readonly dispid 353;
    property prDaySaleSumOnTax6: LongWord readonly dispid 354;
    property prDaySaleSumOnTax1Str: WideString readonly dispid 475;
    property prDaySaleSumOnTax2Str: WideString readonly dispid 476;
    property prDaySaleSumOnTax3Str: WideString readonly dispid 477;
    property prDaySaleSumOnTax4Str: WideString readonly dispid 478;
    property prDaySaleSumOnTax5Str: WideString readonly dispid 479;
    property prDaySaleSumOnTax6Str: WideString readonly dispid 480;
    property prDayRefundSumOnTax1: LongWord readonly dispid 355;
    property prDayRefundSumOnTax2: LongWord readonly dispid 356;
    property prDayRefundSumOnTax3: LongWord readonly dispid 357;
    property prDayRefundSumOnTax4: LongWord readonly dispid 358;
    property prDayRefundSumOnTax5: LongWord readonly dispid 359;
    property prDayRefundSumOnTax6: LongWord readonly dispid 360;
    property prDayRefundSumOnTax1Str: WideString readonly dispid 481;
    property prDayRefundSumOnTax2Str: WideString readonly dispid 482;
    property prDayRefundSumOnTax3Str: WideString readonly dispid 483;
    property prDayRefundSumOnTax4Str: WideString readonly dispid 484;
    property prDayRefundSumOnTax5Str: WideString readonly dispid 485;
    property prDayRefundSumOnTax6Str: WideString readonly dispid 486;
    property prDaySaleSumOnPayForm1: LongWord readonly dispid 361;
    property prDaySaleSumOnPayForm2: LongWord readonly dispid 362;
    property prDaySaleSumOnPayForm3: LongWord readonly dispid 363;
    property prDaySaleSumOnPayForm4: LongWord readonly dispid 364;
    property prDaySaleSumOnPayForm5: LongWord readonly dispid 365;
    property prDaySaleSumOnPayForm6: LongWord readonly dispid 366;
    property prDaySaleSumOnPayForm7: LongWord readonly dispid 367;
    property prDaySaleSumOnPayForm8: LongWord readonly dispid 368;
    property prDaySaleSumOnPayForm9: LongWord readonly dispid 369;
    property prDaySaleSumOnPayForm10: LongWord readonly dispid 370;
    property prDaySaleSumOnPayForm1Str: WideString readonly dispid 487;
    property prDaySaleSumOnPayForm2Str: WideString readonly dispid 488;
    property prDaySaleSumOnPayForm3Str: WideString readonly dispid 489;
    property prDaySaleSumOnPayForm4Str: WideString readonly dispid 490;
    property prDaySaleSumOnPayForm5Str: WideString readonly dispid 491;
    property prDaySaleSumOnPayForm6Str: WideString readonly dispid 492;
    property prDaySaleSumOnPayForm7Str: WideString readonly dispid 493;
    property prDaySaleSumOnPayForm8Str: WideString readonly dispid 494;
    property prDaySaleSumOnPayForm9Str: WideString readonly dispid 495;
    property prDaySaleSumOnPayForm10Str: WideString readonly dispid 496;
    property prDayRefundSumOnPayForm1: LongWord readonly dispid 371;
    property prDayRefundSumOnPayForm2: LongWord readonly dispid 372;
    property prDayRefundSumOnPayForm3: LongWord readonly dispid 373;
    property prDayRefundSumOnPayForm4: LongWord readonly dispid 374;
    property prDayRefundSumOnPayForm5: LongWord readonly dispid 375;
    property prDayRefundSumOnPayForm6: LongWord readonly dispid 376;
    property prDayRefundSumOnPayForm7: LongWord readonly dispid 377;
    property prDayRefundSumOnPayForm8: LongWord readonly dispid 378;
    property prDayRefundSumOnPayForm9: LongWord readonly dispid 379;
    property prDayRefundSumOnPayForm10: LongWord readonly dispid 380;
    property prDayRefundSumOnPayForm1Str: WideString readonly dispid 497;
    property prDayRefundSumOnPayForm2Str: WideString readonly dispid 498;
    property prDayRefundSumOnPayForm3Str: WideString readonly dispid 499;
    property prDayRefundSumOnPayForm4Str: WideString readonly dispid 500;
    property prDayRefundSumOnPayForm5Str: WideString readonly dispid 501;
    property prDayRefundSumOnPayForm6Str: WideString readonly dispid 502;
    property prDayRefundSumOnPayForm7Str: WideString readonly dispid 503;
    property prDayRefundSumOnPayForm8Str: WideString readonly dispid 504;
    property prDayRefundSumOnPayForm9Str: WideString readonly dispid 505;
    property prDayRefundSumOnPayForm10Str: WideString readonly dispid 506;
    property prDayDiscountSumOnSales: LongWord readonly dispid 381;
    property prDayDiscountSumOnSalesStr: WideString readonly dispid 507;
    property prDayMarkupSumOnSales: LongWord readonly dispid 382;
    property prDayMarkupSumOnSalesStr: WideString readonly dispid 508;
    property prDayDiscountSumOnRefunds: LongWord readonly dispid 383;
    property prDayDiscountSumOnRefundsStr: WideString readonly dispid 509;
    property prDayMarkupSumOnRefunds: LongWord readonly dispid 384;
    property prDayMarkupSumOnRefundsStr: WideString readonly dispid 510;
    property prDayCashInSum: LongWord readonly dispid 385;
    property prDayCashInSumStr: WideString readonly dispid 511;
    property prDayCashOutSum: LongWord readonly dispid 386;
    property prDayCashOutSumStr: WideString readonly dispid 512;
    property prCurrentZReport: Word readonly dispid 387;
    property prCurrentZReportStr: WideString readonly dispid 513;
    property prDayEndDate: TDateTime readonly dispid 388;
    property prDayEndDateStr: WideString readonly dispid 389;
    property prDayEndTime: TDateTime readonly dispid 390;
    property prDayEndTimeStr: WideString readonly dispid 391;
    property prLastZReportDate: TDateTime readonly dispid 392;
    property prLastZReportDateStr: WideString readonly dispid 393;
    property prItemsCount: Word readonly dispid 394;
    property prItemsCountStr: WideString readonly dispid 514;
    property prDaySumAddTaxOfSale1: LongWord readonly dispid 395;
    property prDaySumAddTaxOfSale2: LongWord readonly dispid 396;
    property prDaySumAddTaxOfSale3: LongWord readonly dispid 397;
    property prDaySumAddTaxOfSale4: LongWord readonly dispid 398;
    property prDaySumAddTaxOfSale5: LongWord readonly dispid 399;
    property prDaySumAddTaxOfSale6: LongWord readonly dispid 400;
    property prDaySumAddTaxOfSale1Str: WideString readonly dispid 515;
    property prDaySumAddTaxOfSale2Str: WideString readonly dispid 516;
    property prDaySumAddTaxOfSale3Str: WideString readonly dispid 517;
    property prDaySumAddTaxOfSale4Str: WideString readonly dispid 518;
    property prDaySumAddTaxOfSale5Str: WideString readonly dispid 519;
    property prDaySumAddTaxOfSale6Str: WideString readonly dispid 520;
    property prDaySumAddTaxOfRefund1: LongWord readonly dispid 401;
    property prDaySumAddTaxOfRefund2: LongWord readonly dispid 402;
    property prDaySumAddTaxOfRefund3: LongWord readonly dispid 403;
    property prDaySumAddTaxOfRefund4: LongWord readonly dispid 404;
    property prDaySumAddTaxOfRefund5: LongWord readonly dispid 405;
    property prDaySumAddTaxOfRefund6: LongWord readonly dispid 406;
    property prDaySumAddTaxOfRefund1Str: WideString readonly dispid 521;
    property prDaySumAddTaxOfRefund2Str: WideString readonly dispid 522;
    property prDaySumAddTaxOfRefund3Str: WideString readonly dispid 523;
    property prDaySumAddTaxOfRefund4Str: WideString readonly dispid 524;
    property prDaySumAddTaxOfRefund5Str: WideString readonly dispid 525;
    property prDaySumAddTaxOfRefund6Str: WideString readonly dispid 526;
    property prDayAnnuledSaleReceiptsCount: Word readonly dispid 407;
    property prDayAnnuledSaleReceiptsCountStr: WideString readonly dispid 527;
    property prDayAnnuledRefundReceiptsCount: Word readonly dispid 408;
    property prDayAnnuledRefundReceiptsCountStr: WideString readonly dispid 528;
    property prDayAnnuledSaleReceiptsSum: LongWord readonly dispid 409;
    property prDayAnnuledSaleReceiptsSumStr: WideString readonly dispid 529;
    property prDayAnnuledRefundReceiptsSum: LongWord readonly dispid 410;
    property prDayAnnuledRefundReceiptsSumStr: WideString readonly dispid 530;
    property prDaySaleCancelingsCount: Word readonly dispid 411;
    property prDaySaleCancelingsCountStr: WideString readonly dispid 531;
    property prDayRefundCancelingsCount: Word readonly dispid 412;
    property prDayRefundCancelingsCountStr: WideString readonly dispid 532;
    property prDaySaleCancelingsSum: LongWord readonly dispid 413;
    property prDaySaleCancelingsSumStr: WideString readonly dispid 533;
    property prDayRefundCancelingsSum: LongWord readonly dispid 414;
    property prDayRefundCancelingsSumStr: WideString readonly dispid 534;
    property prCashDrawerSum: Int64 readonly dispid 429;
    property prCashDrawerSumStr: WideString readonly dispid 430;
    property prRepeatCount: Byte dispid 431;
    property prLogRecording: WordBool dispid 432;
    property prAnswerWaiting: Byte dispid 434;
    property prGetStatusByte: Byte readonly dispid 436;
    property prGetResultByte: Byte readonly dispid 437;
    property prGetReserveByte: Byte readonly dispid 438;
    property prGetErrorText: WideString readonly dispid 439;
    property prCurReceiptItemCount: Byte readonly dispid 451;
    property prUserPassword: Word readonly dispid 536;
    property prUserPasswordStr: WideString readonly dispid 537;
    property prRevizionID: Byte readonly dispid 541;
    property prFPDriverMajorVersion: Byte readonly dispid 542;
    property prFPDriverMinorVersion: Byte readonly dispid 543;
    property prFPDriverReleaseVersion: Byte readonly dispid 544;
    property prFPDriverBuildVersion: Byte readonly dispid 545;
  end;

// *********************************************************************//
// Interface: IICS_EP_09
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF8A85E4-3A5B-4921-A2D9-2612F50EE281}
// *********************************************************************//
  IICS_EP_09 = interface(IDispatch)
    ['{EF8A85E4-3A5B-4921-A2D9-2612F50EE281}']
    function FPInitialize: Integer; safecall;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; safecall;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; safecall;
    function FPClose: WordBool; safecall;
    function FPClaimUSBDevice: WordBool; safecall;
    function FPReleaseUSBDevice: WordBool; safecall;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; safecall;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; safecall;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; safecall;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; safecall;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; safecall;
    function FPPrintZeroReceipt: WordBool; safecall;
    function FPLineFeed: WordBool; safecall;
    function FPAnnulReceipt: WordBool; safecall;
    function FPCashIn(CashSum: SYSUINT): WordBool; safecall;
    function FPCashOut(CashSum: SYSUINT): WordBool; safecall;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; safecall;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; safecall;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; safecall;
    function FPGetCurrentDate: WordBool; safecall;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; safecall;
    function FPGetCurrentTime: WordBool; safecall;
    function FPOpenCashDrawer(Duration: Word): WordBool; safecall;
    function FPPrintHardwareVersion: WordBool; safecall;
    function FPPrintLastKsefPacket: WordBool; safecall;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool; safecall;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; safecall;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; safecall;
    function FPOnlineModeSwitch: WordBool; safecall;
    function FPCustomerDisplayModeSwitch: WordBool; safecall;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; safecall;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; safecall;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; safecall;
    function FPCloseServiceReport: WordBool; safecall;
    function FPEnableLogo(ProgPassword: Word): WordBool; safecall;
    function FPDisableLogo(ProgPassword: Word): WordBool; safecall;
    function FPSetTaxRates(ProgPassword: Word): WordBool; safecall;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; safecall;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; safecall;
    function FPMakeXReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeZReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; safecall;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; safecall;
    function FPCutterModeSwitch: WordBool; safecall;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; safecall;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; safecall;
    function FPGetPaymentFormNames: WordBool; safecall;
    function FPGetCurrentStatus: WordBool; safecall;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; safecall;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; safecall;
    function FPGetCashDrawerSum: WordBool; safecall;
    function FPGetDayReportProperties: WordBool; safecall;
    function FPGetTaxRates: WordBool; safecall;
    function FPGetItemData(ItemCode: Int64): WordBool; safecall;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; safecall;
    function FPGetDayReportData: WordBool; safecall;
    function FPGetCurrentReceiptData: WordBool; safecall;
    function FPGetDayCorrectionsData: WordBool; safecall;
    function FPGetDaySumOfAddTaxes: WordBool; safecall;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; safecall;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; safecall;
    function FPPrintModemStatus: WordBool; safecall;
    function FPGetUserPassword(UserID: Byte): WordBool; safecall;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; safecall;
    function FPGetRevizionID: WordBool; safecall;
    function Get_glTapeAnalizer: WordBool; safecall;
    procedure Set_glTapeAnalizer(Value: WordBool); safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_glVirtualPortOpened: WordBool; safecall;
    function Get_glUseVirtualPort: WordBool; safecall;
    procedure Set_glUseVirtualPort(Value: WordBool); safecall;
    function Get_stUseAdditionalTax: WordBool; safecall;
    function Get_stUseAdditionalFee: WordBool; safecall;
    function Get_stUseFontB: WordBool; safecall;
    function Get_stUseTradeLogo: WordBool; safecall;
    function Get_stUseCutter: WordBool; safecall;
    function Get_stRefundReceiptMode: WordBool; safecall;
    function Get_stPaymentMode: WordBool; safecall;
    function Get_stFiscalMode: WordBool; safecall;
    function Get_stServiceReceiptMode: WordBool; safecall;
    function Get_stOnlinePrintMode: WordBool; safecall;
    function Get_stFailureLastCommand: WordBool; safecall;
    function Get_stFiscalDayIsOpened: WordBool; safecall;
    function Get_stReceiptIsOpened: WordBool; safecall;
    function Get_stCashDrawerIsOpened: WordBool; safecall;
    function Get_stDisplayShowSumMode: WordBool; safecall;
    function Get_prItemCost: Int64; safecall;
    function Get_prSumDiscount: Int64; safecall;
    function Get_prSumMarkup: Int64; safecall;
    function Get_prSumTotal: Int64; safecall;
    function Get_prSumBalance: Int64; safecall;
    function Get_prKSEFPacket: LongWord; safecall;
    function Get_prKSEFPacketStr: WideString; safecall;
    function Get_prModemError: Byte; safecall;
    function Get_prCurrentDate: TDateTime; safecall;
    function Get_prCurrentDateStr: WideString; safecall;
    function Get_prCurrentTime: TDateTime; safecall;
    function Get_prCurrentTimeStr: WideString; safecall;
    function Get_prTaxRatesCount: Byte; safecall;
    procedure Set_prTaxRatesCount(Value: Byte); safecall;
    function Get_prTaxRatesDate: TDateTime; safecall;
    function Get_prTaxRatesDateStr: WideString; safecall;
    function Get_prAddTaxType: WordBool; safecall;
    procedure Set_prAddTaxType(Value: WordBool); safecall;
    function Get_prTaxRate1: SYSINT; safecall;
    procedure Set_prTaxRate1(Value: SYSINT); safecall;
    function Get_prTaxRate2: SYSINT; safecall;
    procedure Set_prTaxRate2(Value: SYSINT); safecall;
    function Get_prTaxRate3: SYSINT; safecall;
    procedure Set_prTaxRate3(Value: SYSINT); safecall;
    function Get_prTaxRate4: SYSINT; safecall;
    procedure Set_prTaxRate4(Value: SYSINT); safecall;
    function Get_prTaxRate5: SYSINT; safecall;
    procedure Set_prTaxRate5(Value: SYSINT); safecall;
    function Get_prTaxRate6: SYSINT; safecall;
    function Get_prUsedAdditionalFee: WordBool; safecall;
    procedure Set_prUsedAdditionalFee(Value: WordBool); safecall;
    function Get_prAddFeeRate1: SYSINT; safecall;
    procedure Set_prAddFeeRate1(Value: SYSINT); safecall;
    function Get_prAddFeeRate2: SYSINT; safecall;
    procedure Set_prAddFeeRate2(Value: SYSINT); safecall;
    function Get_prAddFeeRate3: SYSINT; safecall;
    procedure Set_prAddFeeRate3(Value: SYSINT); safecall;
    function Get_prAddFeeRate4: SYSINT; safecall;
    procedure Set_prAddFeeRate4(Value: SYSINT); safecall;
    function Get_prAddFeeRate5: SYSINT; safecall;
    procedure Set_prAddFeeRate5(Value: SYSINT); safecall;
    function Get_prAddFeeRate6: SYSINT; safecall;
    procedure Set_prAddFeeRate6(Value: SYSINT); safecall;
    function Get_prTaxOnAddFee1: WordBool; safecall;
    procedure Set_prTaxOnAddFee1(Value: WordBool); safecall;
    function Get_prTaxOnAddFee2: WordBool; safecall;
    procedure Set_prTaxOnAddFee2(Value: WordBool); safecall;
    function Get_prTaxOnAddFee3: WordBool; safecall;
    procedure Set_prTaxOnAddFee3(Value: WordBool); safecall;
    function Get_prTaxOnAddFee4: WordBool; safecall;
    procedure Set_prTaxOnAddFee4(Value: WordBool); safecall;
    function Get_prTaxOnAddFee5: WordBool; safecall;
    procedure Set_prTaxOnAddFee5(Value: WordBool); safecall;
    function Get_prTaxOnAddFee6: WordBool; safecall;
    procedure Set_prTaxOnAddFee6(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice1: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice1(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice2: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice2(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice3: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice3(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice4: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice4(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice5: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice5(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice6: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice6(Value: WordBool); safecall;
    function Get_prNamePaymentForm1: WideString; safecall;
    function Get_prNamePaymentForm2: WideString; safecall;
    function Get_prNamePaymentForm3: WideString; safecall;
    function Get_prNamePaymentForm4: WideString; safecall;
    function Get_prNamePaymentForm5: WideString; safecall;
    function Get_prNamePaymentForm6: WideString; safecall;
    function Get_prNamePaymentForm7: WideString; safecall;
    function Get_prNamePaymentForm8: WideString; safecall;
    function Get_prNamePaymentForm9: WideString; safecall;
    function Get_prNamePaymentForm10: WideString; safecall;
    function Get_prSerialNumber: WideString; safecall;
    function Get_prFiscalNumber: WideString; safecall;
    function Get_prTaxNumber: WideString; safecall;
    function Get_prDateFiscalization: TDateTime; safecall;
    function Get_prDateFiscalizationStr: WideString; safecall;
    function Get_prTimeFiscalization: TDateTime; safecall;
    function Get_prTimeFiscalizationStr: WideString; safecall;
    function Get_prHeadLine1: WideString; safecall;
    function Get_prHeadLine2: WideString; safecall;
    function Get_prHeadLine3: WideString; safecall;
    function Get_prHardwareVersion: WideString; safecall;
    function Get_prItemName: WideString; safecall;
    function Get_prItemPrice: SYSINT; safecall;
    function Get_prItemSaleQuantity: SYSINT; safecall;
    function Get_prItemSaleQtyPrecision: Byte; safecall;
    function Get_prItemTax: Byte; safecall;
    function Get_prItemSaleSum: Int64; safecall;
    function Get_prItemSaleSumStr: WideString; safecall;
    function Get_prItemRefundQuantity: SYSINT; safecall;
    function Get_prItemRefundQtyPrecision: Byte; safecall;
    function Get_prItemRefundSum: Int64; safecall;
    function Get_prItemRefundSumStr: WideString; safecall;
    function Get_prItemCostStr: WideString; safecall;
    function Get_prSumDiscountStr: WideString; safecall;
    function Get_prSumMarkupStr: WideString; safecall;
    function Get_prSumTotalStr: WideString; safecall;
    function Get_prSumBalanceStr: WideString; safecall;
    function Get_prCurReceiptTax1Sum: LongWord; safecall;
    function Get_prCurReceiptTax2Sum: LongWord; safecall;
    function Get_prCurReceiptTax3Sum: LongWord; safecall;
    function Get_prCurReceiptTax4Sum: LongWord; safecall;
    function Get_prCurReceiptTax5Sum: LongWord; safecall;
    function Get_prCurReceiptTax6Sum: LongWord; safecall;
    function Get_prCurReceiptTax1SumStr: WideString; safecall;
    function Get_prCurReceiptTax2SumStr: WideString; safecall;
    function Get_prCurReceiptTax3SumStr: WideString; safecall;
    function Get_prCurReceiptTax4SumStr: WideString; safecall;
    function Get_prCurReceiptTax5SumStr: WideString; safecall;
    function Get_prCurReceiptTax6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm1Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm2Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm3Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm4Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm5Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm6Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm7Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm8Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm9Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm10Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm1SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm2SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm3SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm4SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm5SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm7SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm8SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm9SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm10SumStr: WideString; safecall;
    function Get_prPrinterError: WordBool; safecall;
    function Get_prTapeNearEnd: WordBool; safecall;
    function Get_prTapeEnded: WordBool; safecall;
    function Get_prDaySaleReceiptsCount: Word; safecall;
    function Get_prDaySaleReceiptsCountStr: WideString; safecall;
    function Get_prDayRefundReceiptsCount: Word; safecall;
    function Get_prDayRefundReceiptsCountStr: WideString; safecall;
    function Get_prDaySaleSumOnTax1: LongWord; safecall;
    function Get_prDaySaleSumOnTax2: LongWord; safecall;
    function Get_prDaySaleSumOnTax3: LongWord; safecall;
    function Get_prDaySaleSumOnTax4: LongWord; safecall;
    function Get_prDaySaleSumOnTax5: LongWord; safecall;
    function Get_prDaySaleSumOnTax6: LongWord; safecall;
    function Get_prDaySaleSumOnTax1Str: WideString; safecall;
    function Get_prDaySaleSumOnTax2Str: WideString; safecall;
    function Get_prDaySaleSumOnTax3Str: WideString; safecall;
    function Get_prDaySaleSumOnTax4Str: WideString; safecall;
    function Get_prDaySaleSumOnTax5Str: WideString; safecall;
    function Get_prDaySaleSumOnTax6Str: WideString; safecall;
    function Get_prDayRefundSumOnTax1: LongWord; safecall;
    function Get_prDayRefundSumOnTax2: LongWord; safecall;
    function Get_prDayRefundSumOnTax3: LongWord; safecall;
    function Get_prDayRefundSumOnTax4: LongWord; safecall;
    function Get_prDayRefundSumOnTax5: LongWord; safecall;
    function Get_prDayRefundSumOnTax6: LongWord; safecall;
    function Get_prDayRefundSumOnTax1Str: WideString; safecall;
    function Get_prDayRefundSumOnTax2Str: WideString; safecall;
    function Get_prDayRefundSumOnTax3Str: WideString; safecall;
    function Get_prDayRefundSumOnTax4Str: WideString; safecall;
    function Get_prDayRefundSumOnTax5Str: WideString; safecall;
    function Get_prDayRefundSumOnTax6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm1: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm2: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm3: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm4: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm5: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm6: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm7: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm8: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm9: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm10: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm1Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm2Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm3Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm4Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm5Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm7Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm8Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm9Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm10Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm1: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm2: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm3: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm4: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm5: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm6: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm7: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm8: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm9: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm10: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm1Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm2Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm3Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm4Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm5Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm6Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm7Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm8Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm9Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm10Str: WideString; safecall;
    function Get_prDayDiscountSumOnSales: LongWord; safecall;
    function Get_prDayDiscountSumOnSalesStr: WideString; safecall;
    function Get_prDayMarkupSumOnSales: LongWord; safecall;
    function Get_prDayMarkupSumOnSalesStr: WideString; safecall;
    function Get_prDayDiscountSumOnRefunds: LongWord; safecall;
    function Get_prDayDiscountSumOnRefundsStr: WideString; safecall;
    function Get_prDayMarkupSumOnRefunds: LongWord; safecall;
    function Get_prDayMarkupSumOnRefundsStr: WideString; safecall;
    function Get_prDayCashInSum: LongWord; safecall;
    function Get_prDayCashInSumStr: WideString; safecall;
    function Get_prDayCashOutSum: LongWord; safecall;
    function Get_prDayCashOutSumStr: WideString; safecall;
    function Get_prCurrentZReport: Word; safecall;
    function Get_prCurrentZReportStr: WideString; safecall;
    function Get_prDayEndDate: TDateTime; safecall;
    function Get_prDayEndDateStr: WideString; safecall;
    function Get_prDayEndTime: TDateTime; safecall;
    function Get_prDayEndTimeStr: WideString; safecall;
    function Get_prLastZReportDate: TDateTime; safecall;
    function Get_prLastZReportDateStr: WideString; safecall;
    function Get_prItemsCount: Word; safecall;
    function Get_prItemsCountStr: WideString; safecall;
    function Get_prDaySumAddTaxOfSale1: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale2: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale3: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale4: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale5: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale6: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale6Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund1: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund2: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund3: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund4: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund5: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund6: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund6Str: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsCount: Word; safecall;
    function Get_prDayAnnuledSaleReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsCount: Word; safecall;
    function Get_prDayAnnuledRefundReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledSaleReceiptsSumStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledRefundReceiptsSumStr: WideString; safecall;
    function Get_prDaySaleCancelingsCount: Word; safecall;
    function Get_prDaySaleCancelingsCountStr: WideString; safecall;
    function Get_prDayRefundCancelingsCount: Word; safecall;
    function Get_prDayRefundCancelingsCountStr: WideString; safecall;
    function Get_prDaySaleCancelingsSum: LongWord; safecall;
    function Get_prDaySaleCancelingsSumStr: WideString; safecall;
    function Get_prDayRefundCancelingsSum: LongWord; safecall;
    function Get_prDayRefundCancelingsSumStr: WideString; safecall;
    function Get_prCashDrawerSum: Int64; safecall;
    function Get_prCashDrawerSumStr: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prGetStatusByte: Byte; safecall;
    function Get_prGetResultByte: Byte; safecall;
    function Get_prGetReserveByte: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prCurReceiptItemCount: Byte; safecall;
    function Get_prUserPassword: Word; safecall;
    function Get_prUserPasswordStr: WideString; safecall;
    function Get_prRevizionID: Byte; safecall;
    function Get_prFPDriverMajorVersion: Byte; safecall;
    function Get_prFPDriverMinorVersion: Byte; safecall;
    function Get_prFPDriverReleaseVersion: Byte; safecall;
    function Get_prFPDriverBuildVersion: Byte; safecall;
    property glTapeAnalizer: WordBool read Get_glTapeAnalizer write Set_glTapeAnalizer;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property glVirtualPortOpened: WordBool read Get_glVirtualPortOpened;
    property glUseVirtualPort: WordBool read Get_glUseVirtualPort write Set_glUseVirtualPort;
    property stUseAdditionalTax: WordBool read Get_stUseAdditionalTax;
    property stUseAdditionalFee: WordBool read Get_stUseAdditionalFee;
    property stUseFontB: WordBool read Get_stUseFontB;
    property stUseTradeLogo: WordBool read Get_stUseTradeLogo;
    property stUseCutter: WordBool read Get_stUseCutter;
    property stRefundReceiptMode: WordBool read Get_stRefundReceiptMode;
    property stPaymentMode: WordBool read Get_stPaymentMode;
    property stFiscalMode: WordBool read Get_stFiscalMode;
    property stServiceReceiptMode: WordBool read Get_stServiceReceiptMode;
    property stOnlinePrintMode: WordBool read Get_stOnlinePrintMode;
    property stFailureLastCommand: WordBool read Get_stFailureLastCommand;
    property stFiscalDayIsOpened: WordBool read Get_stFiscalDayIsOpened;
    property stReceiptIsOpened: WordBool read Get_stReceiptIsOpened;
    property stCashDrawerIsOpened: WordBool read Get_stCashDrawerIsOpened;
    property stDisplayShowSumMode: WordBool read Get_stDisplayShowSumMode;
    property prItemCost: Int64 read Get_prItemCost;
    property prSumDiscount: Int64 read Get_prSumDiscount;
    property prSumMarkup: Int64 read Get_prSumMarkup;
    property prSumTotal: Int64 read Get_prSumTotal;
    property prSumBalance: Int64 read Get_prSumBalance;
    property prKSEFPacket: LongWord read Get_prKSEFPacket;
    property prKSEFPacketStr: WideString read Get_prKSEFPacketStr;
    property prModemError: Byte read Get_prModemError;
    property prCurrentDate: TDateTime read Get_prCurrentDate;
    property prCurrentDateStr: WideString read Get_prCurrentDateStr;
    property prCurrentTime: TDateTime read Get_prCurrentTime;
    property prCurrentTimeStr: WideString read Get_prCurrentTimeStr;
    property prTaxRatesCount: Byte read Get_prTaxRatesCount write Set_prTaxRatesCount;
    property prTaxRatesDate: TDateTime read Get_prTaxRatesDate;
    property prTaxRatesDateStr: WideString read Get_prTaxRatesDateStr;
    property prAddTaxType: WordBool read Get_prAddTaxType write Set_prAddTaxType;
    property prTaxRate1: SYSINT read Get_prTaxRate1 write Set_prTaxRate1;
    property prTaxRate2: SYSINT read Get_prTaxRate2 write Set_prTaxRate2;
    property prTaxRate3: SYSINT read Get_prTaxRate3 write Set_prTaxRate3;
    property prTaxRate4: SYSINT read Get_prTaxRate4 write Set_prTaxRate4;
    property prTaxRate5: SYSINT read Get_prTaxRate5 write Set_prTaxRate5;
    property prTaxRate6: SYSINT read Get_prTaxRate6;
    property prUsedAdditionalFee: WordBool read Get_prUsedAdditionalFee write Set_prUsedAdditionalFee;
    property prAddFeeRate1: SYSINT read Get_prAddFeeRate1 write Set_prAddFeeRate1;
    property prAddFeeRate2: SYSINT read Get_prAddFeeRate2 write Set_prAddFeeRate2;
    property prAddFeeRate3: SYSINT read Get_prAddFeeRate3 write Set_prAddFeeRate3;
    property prAddFeeRate4: SYSINT read Get_prAddFeeRate4 write Set_prAddFeeRate4;
    property prAddFeeRate5: SYSINT read Get_prAddFeeRate5 write Set_prAddFeeRate5;
    property prAddFeeRate6: SYSINT read Get_prAddFeeRate6 write Set_prAddFeeRate6;
    property prTaxOnAddFee1: WordBool read Get_prTaxOnAddFee1 write Set_prTaxOnAddFee1;
    property prTaxOnAddFee2: WordBool read Get_prTaxOnAddFee2 write Set_prTaxOnAddFee2;
    property prTaxOnAddFee3: WordBool read Get_prTaxOnAddFee3 write Set_prTaxOnAddFee3;
    property prTaxOnAddFee4: WordBool read Get_prTaxOnAddFee4 write Set_prTaxOnAddFee4;
    property prTaxOnAddFee5: WordBool read Get_prTaxOnAddFee5 write Set_prTaxOnAddFee5;
    property prTaxOnAddFee6: WordBool read Get_prTaxOnAddFee6 write Set_prTaxOnAddFee6;
    property prAddFeeOnRetailPrice1: WordBool read Get_prAddFeeOnRetailPrice1 write Set_prAddFeeOnRetailPrice1;
    property prAddFeeOnRetailPrice2: WordBool read Get_prAddFeeOnRetailPrice2 write Set_prAddFeeOnRetailPrice2;
    property prAddFeeOnRetailPrice3: WordBool read Get_prAddFeeOnRetailPrice3 write Set_prAddFeeOnRetailPrice3;
    property prAddFeeOnRetailPrice4: WordBool read Get_prAddFeeOnRetailPrice4 write Set_prAddFeeOnRetailPrice4;
    property prAddFeeOnRetailPrice5: WordBool read Get_prAddFeeOnRetailPrice5 write Set_prAddFeeOnRetailPrice5;
    property prAddFeeOnRetailPrice6: WordBool read Get_prAddFeeOnRetailPrice6 write Set_prAddFeeOnRetailPrice6;
    property prNamePaymentForm1: WideString read Get_prNamePaymentForm1;
    property prNamePaymentForm2: WideString read Get_prNamePaymentForm2;
    property prNamePaymentForm3: WideString read Get_prNamePaymentForm3;
    property prNamePaymentForm4: WideString read Get_prNamePaymentForm4;
    property prNamePaymentForm5: WideString read Get_prNamePaymentForm5;
    property prNamePaymentForm6: WideString read Get_prNamePaymentForm6;
    property prNamePaymentForm7: WideString read Get_prNamePaymentForm7;
    property prNamePaymentForm8: WideString read Get_prNamePaymentForm8;
    property prNamePaymentForm9: WideString read Get_prNamePaymentForm9;
    property prNamePaymentForm10: WideString read Get_prNamePaymentForm10;
    property prSerialNumber: WideString read Get_prSerialNumber;
    property prFiscalNumber: WideString read Get_prFiscalNumber;
    property prTaxNumber: WideString read Get_prTaxNumber;
    property prDateFiscalization: TDateTime read Get_prDateFiscalization;
    property prDateFiscalizationStr: WideString read Get_prDateFiscalizationStr;
    property prTimeFiscalization: TDateTime read Get_prTimeFiscalization;
    property prTimeFiscalizationStr: WideString read Get_prTimeFiscalizationStr;
    property prHeadLine1: WideString read Get_prHeadLine1;
    property prHeadLine2: WideString read Get_prHeadLine2;
    property prHeadLine3: WideString read Get_prHeadLine3;
    property prHardwareVersion: WideString read Get_prHardwareVersion;
    property prItemName: WideString read Get_prItemName;
    property prItemPrice: SYSINT read Get_prItemPrice;
    property prItemSaleQuantity: SYSINT read Get_prItemSaleQuantity;
    property prItemSaleQtyPrecision: Byte read Get_prItemSaleQtyPrecision;
    property prItemTax: Byte read Get_prItemTax;
    property prItemSaleSum: Int64 read Get_prItemSaleSum;
    property prItemSaleSumStr: WideString read Get_prItemSaleSumStr;
    property prItemRefundQuantity: SYSINT read Get_prItemRefundQuantity;
    property prItemRefundQtyPrecision: Byte read Get_prItemRefundQtyPrecision;
    property prItemRefundSum: Int64 read Get_prItemRefundSum;
    property prItemRefundSumStr: WideString read Get_prItemRefundSumStr;
    property prItemCostStr: WideString read Get_prItemCostStr;
    property prSumDiscountStr: WideString read Get_prSumDiscountStr;
    property prSumMarkupStr: WideString read Get_prSumMarkupStr;
    property prSumTotalStr: WideString read Get_prSumTotalStr;
    property prSumBalanceStr: WideString read Get_prSumBalanceStr;
    property prCurReceiptTax1Sum: LongWord read Get_prCurReceiptTax1Sum;
    property prCurReceiptTax2Sum: LongWord read Get_prCurReceiptTax2Sum;
    property prCurReceiptTax3Sum: LongWord read Get_prCurReceiptTax3Sum;
    property prCurReceiptTax4Sum: LongWord read Get_prCurReceiptTax4Sum;
    property prCurReceiptTax5Sum: LongWord read Get_prCurReceiptTax5Sum;
    property prCurReceiptTax6Sum: LongWord read Get_prCurReceiptTax6Sum;
    property prCurReceiptTax1SumStr: WideString read Get_prCurReceiptTax1SumStr;
    property prCurReceiptTax2SumStr: WideString read Get_prCurReceiptTax2SumStr;
    property prCurReceiptTax3SumStr: WideString read Get_prCurReceiptTax3SumStr;
    property prCurReceiptTax4SumStr: WideString read Get_prCurReceiptTax4SumStr;
    property prCurReceiptTax5SumStr: WideString read Get_prCurReceiptTax5SumStr;
    property prCurReceiptTax6SumStr: WideString read Get_prCurReceiptTax6SumStr;
    property prCurReceiptPayForm1Sum: LongWord read Get_prCurReceiptPayForm1Sum;
    property prCurReceiptPayForm2Sum: LongWord read Get_prCurReceiptPayForm2Sum;
    property prCurReceiptPayForm3Sum: LongWord read Get_prCurReceiptPayForm3Sum;
    property prCurReceiptPayForm4Sum: LongWord read Get_prCurReceiptPayForm4Sum;
    property prCurReceiptPayForm5Sum: LongWord read Get_prCurReceiptPayForm5Sum;
    property prCurReceiptPayForm6Sum: LongWord read Get_prCurReceiptPayForm6Sum;
    property prCurReceiptPayForm7Sum: LongWord read Get_prCurReceiptPayForm7Sum;
    property prCurReceiptPayForm8Sum: LongWord read Get_prCurReceiptPayForm8Sum;
    property prCurReceiptPayForm9Sum: LongWord read Get_prCurReceiptPayForm9Sum;
    property prCurReceiptPayForm10Sum: LongWord read Get_prCurReceiptPayForm10Sum;
    property prCurReceiptPayForm1SumStr: WideString read Get_prCurReceiptPayForm1SumStr;
    property prCurReceiptPayForm2SumStr: WideString read Get_prCurReceiptPayForm2SumStr;
    property prCurReceiptPayForm3SumStr: WideString read Get_prCurReceiptPayForm3SumStr;
    property prCurReceiptPayForm4SumStr: WideString read Get_prCurReceiptPayForm4SumStr;
    property prCurReceiptPayForm5SumStr: WideString read Get_prCurReceiptPayForm5SumStr;
    property prCurReceiptPayForm6SumStr: WideString read Get_prCurReceiptPayForm6SumStr;
    property prCurReceiptPayForm7SumStr: WideString read Get_prCurReceiptPayForm7SumStr;
    property prCurReceiptPayForm8SumStr: WideString read Get_prCurReceiptPayForm8SumStr;
    property prCurReceiptPayForm9SumStr: WideString read Get_prCurReceiptPayForm9SumStr;
    property prCurReceiptPayForm10SumStr: WideString read Get_prCurReceiptPayForm10SumStr;
    property prPrinterError: WordBool read Get_prPrinterError;
    property prTapeNearEnd: WordBool read Get_prTapeNearEnd;
    property prTapeEnded: WordBool read Get_prTapeEnded;
    property prDaySaleReceiptsCount: Word read Get_prDaySaleReceiptsCount;
    property prDaySaleReceiptsCountStr: WideString read Get_prDaySaleReceiptsCountStr;
    property prDayRefundReceiptsCount: Word read Get_prDayRefundReceiptsCount;
    property prDayRefundReceiptsCountStr: WideString read Get_prDayRefundReceiptsCountStr;
    property prDaySaleSumOnTax1: LongWord read Get_prDaySaleSumOnTax1;
    property prDaySaleSumOnTax2: LongWord read Get_prDaySaleSumOnTax2;
    property prDaySaleSumOnTax3: LongWord read Get_prDaySaleSumOnTax3;
    property prDaySaleSumOnTax4: LongWord read Get_prDaySaleSumOnTax4;
    property prDaySaleSumOnTax5: LongWord read Get_prDaySaleSumOnTax5;
    property prDaySaleSumOnTax6: LongWord read Get_prDaySaleSumOnTax6;
    property prDaySaleSumOnTax1Str: WideString read Get_prDaySaleSumOnTax1Str;
    property prDaySaleSumOnTax2Str: WideString read Get_prDaySaleSumOnTax2Str;
    property prDaySaleSumOnTax3Str: WideString read Get_prDaySaleSumOnTax3Str;
    property prDaySaleSumOnTax4Str: WideString read Get_prDaySaleSumOnTax4Str;
    property prDaySaleSumOnTax5Str: WideString read Get_prDaySaleSumOnTax5Str;
    property prDaySaleSumOnTax6Str: WideString read Get_prDaySaleSumOnTax6Str;
    property prDayRefundSumOnTax1: LongWord read Get_prDayRefundSumOnTax1;
    property prDayRefundSumOnTax2: LongWord read Get_prDayRefundSumOnTax2;
    property prDayRefundSumOnTax3: LongWord read Get_prDayRefundSumOnTax3;
    property prDayRefundSumOnTax4: LongWord read Get_prDayRefundSumOnTax4;
    property prDayRefundSumOnTax5: LongWord read Get_prDayRefundSumOnTax5;
    property prDayRefundSumOnTax6: LongWord read Get_prDayRefundSumOnTax6;
    property prDayRefundSumOnTax1Str: WideString read Get_prDayRefundSumOnTax1Str;
    property prDayRefundSumOnTax2Str: WideString read Get_prDayRefundSumOnTax2Str;
    property prDayRefundSumOnTax3Str: WideString read Get_prDayRefundSumOnTax3Str;
    property prDayRefundSumOnTax4Str: WideString read Get_prDayRefundSumOnTax4Str;
    property prDayRefundSumOnTax5Str: WideString read Get_prDayRefundSumOnTax5Str;
    property prDayRefundSumOnTax6Str: WideString read Get_prDayRefundSumOnTax6Str;
    property prDaySaleSumOnPayForm1: LongWord read Get_prDaySaleSumOnPayForm1;
    property prDaySaleSumOnPayForm2: LongWord read Get_prDaySaleSumOnPayForm2;
    property prDaySaleSumOnPayForm3: LongWord read Get_prDaySaleSumOnPayForm3;
    property prDaySaleSumOnPayForm4: LongWord read Get_prDaySaleSumOnPayForm4;
    property prDaySaleSumOnPayForm5: LongWord read Get_prDaySaleSumOnPayForm5;
    property prDaySaleSumOnPayForm6: LongWord read Get_prDaySaleSumOnPayForm6;
    property prDaySaleSumOnPayForm7: LongWord read Get_prDaySaleSumOnPayForm7;
    property prDaySaleSumOnPayForm8: LongWord read Get_prDaySaleSumOnPayForm8;
    property prDaySaleSumOnPayForm9: LongWord read Get_prDaySaleSumOnPayForm9;
    property prDaySaleSumOnPayForm10: LongWord read Get_prDaySaleSumOnPayForm10;
    property prDaySaleSumOnPayForm1Str: WideString read Get_prDaySaleSumOnPayForm1Str;
    property prDaySaleSumOnPayForm2Str: WideString read Get_prDaySaleSumOnPayForm2Str;
    property prDaySaleSumOnPayForm3Str: WideString read Get_prDaySaleSumOnPayForm3Str;
    property prDaySaleSumOnPayForm4Str: WideString read Get_prDaySaleSumOnPayForm4Str;
    property prDaySaleSumOnPayForm5Str: WideString read Get_prDaySaleSumOnPayForm5Str;
    property prDaySaleSumOnPayForm6Str: WideString read Get_prDaySaleSumOnPayForm6Str;
    property prDaySaleSumOnPayForm7Str: WideString read Get_prDaySaleSumOnPayForm7Str;
    property prDaySaleSumOnPayForm8Str: WideString read Get_prDaySaleSumOnPayForm8Str;
    property prDaySaleSumOnPayForm9Str: WideString read Get_prDaySaleSumOnPayForm9Str;
    property prDaySaleSumOnPayForm10Str: WideString read Get_prDaySaleSumOnPayForm10Str;
    property prDayRefundSumOnPayForm1: LongWord read Get_prDayRefundSumOnPayForm1;
    property prDayRefundSumOnPayForm2: LongWord read Get_prDayRefundSumOnPayForm2;
    property prDayRefundSumOnPayForm3: LongWord read Get_prDayRefundSumOnPayForm3;
    property prDayRefundSumOnPayForm4: LongWord read Get_prDayRefundSumOnPayForm4;
    property prDayRefundSumOnPayForm5: LongWord read Get_prDayRefundSumOnPayForm5;
    property prDayRefundSumOnPayForm6: LongWord read Get_prDayRefundSumOnPayForm6;
    property prDayRefundSumOnPayForm7: LongWord read Get_prDayRefundSumOnPayForm7;
    property prDayRefundSumOnPayForm8: LongWord read Get_prDayRefundSumOnPayForm8;
    property prDayRefundSumOnPayForm9: LongWord read Get_prDayRefundSumOnPayForm9;
    property prDayRefundSumOnPayForm10: LongWord read Get_prDayRefundSumOnPayForm10;
    property prDayRefundSumOnPayForm1Str: WideString read Get_prDayRefundSumOnPayForm1Str;
    property prDayRefundSumOnPayForm2Str: WideString read Get_prDayRefundSumOnPayForm2Str;
    property prDayRefundSumOnPayForm3Str: WideString read Get_prDayRefundSumOnPayForm3Str;
    property prDayRefundSumOnPayForm4Str: WideString read Get_prDayRefundSumOnPayForm4Str;
    property prDayRefundSumOnPayForm5Str: WideString read Get_prDayRefundSumOnPayForm5Str;
    property prDayRefundSumOnPayForm6Str: WideString read Get_prDayRefundSumOnPayForm6Str;
    property prDayRefundSumOnPayForm7Str: WideString read Get_prDayRefundSumOnPayForm7Str;
    property prDayRefundSumOnPayForm8Str: WideString read Get_prDayRefundSumOnPayForm8Str;
    property prDayRefundSumOnPayForm9Str: WideString read Get_prDayRefundSumOnPayForm9Str;
    property prDayRefundSumOnPayForm10Str: WideString read Get_prDayRefundSumOnPayForm10Str;
    property prDayDiscountSumOnSales: LongWord read Get_prDayDiscountSumOnSales;
    property prDayDiscountSumOnSalesStr: WideString read Get_prDayDiscountSumOnSalesStr;
    property prDayMarkupSumOnSales: LongWord read Get_prDayMarkupSumOnSales;
    property prDayMarkupSumOnSalesStr: WideString read Get_prDayMarkupSumOnSalesStr;
    property prDayDiscountSumOnRefunds: LongWord read Get_prDayDiscountSumOnRefunds;
    property prDayDiscountSumOnRefundsStr: WideString read Get_prDayDiscountSumOnRefundsStr;
    property prDayMarkupSumOnRefunds: LongWord read Get_prDayMarkupSumOnRefunds;
    property prDayMarkupSumOnRefundsStr: WideString read Get_prDayMarkupSumOnRefundsStr;
    property prDayCashInSum: LongWord read Get_prDayCashInSum;
    property prDayCashInSumStr: WideString read Get_prDayCashInSumStr;
    property prDayCashOutSum: LongWord read Get_prDayCashOutSum;
    property prDayCashOutSumStr: WideString read Get_prDayCashOutSumStr;
    property prCurrentZReport: Word read Get_prCurrentZReport;
    property prCurrentZReportStr: WideString read Get_prCurrentZReportStr;
    property prDayEndDate: TDateTime read Get_prDayEndDate;
    property prDayEndDateStr: WideString read Get_prDayEndDateStr;
    property prDayEndTime: TDateTime read Get_prDayEndTime;
    property prDayEndTimeStr: WideString read Get_prDayEndTimeStr;
    property prLastZReportDate: TDateTime read Get_prLastZReportDate;
    property prLastZReportDateStr: WideString read Get_prLastZReportDateStr;
    property prItemsCount: Word read Get_prItemsCount;
    property prItemsCountStr: WideString read Get_prItemsCountStr;
    property prDaySumAddTaxOfSale1: LongWord read Get_prDaySumAddTaxOfSale1;
    property prDaySumAddTaxOfSale2: LongWord read Get_prDaySumAddTaxOfSale2;
    property prDaySumAddTaxOfSale3: LongWord read Get_prDaySumAddTaxOfSale3;
    property prDaySumAddTaxOfSale4: LongWord read Get_prDaySumAddTaxOfSale4;
    property prDaySumAddTaxOfSale5: LongWord read Get_prDaySumAddTaxOfSale5;
    property prDaySumAddTaxOfSale6: LongWord read Get_prDaySumAddTaxOfSale6;
    property prDaySumAddTaxOfSale1Str: WideString read Get_prDaySumAddTaxOfSale1Str;
    property prDaySumAddTaxOfSale2Str: WideString read Get_prDaySumAddTaxOfSale2Str;
    property prDaySumAddTaxOfSale3Str: WideString read Get_prDaySumAddTaxOfSale3Str;
    property prDaySumAddTaxOfSale4Str: WideString read Get_prDaySumAddTaxOfSale4Str;
    property prDaySumAddTaxOfSale5Str: WideString read Get_prDaySumAddTaxOfSale5Str;
    property prDaySumAddTaxOfSale6Str: WideString read Get_prDaySumAddTaxOfSale6Str;
    property prDaySumAddTaxOfRefund1: LongWord read Get_prDaySumAddTaxOfRefund1;
    property prDaySumAddTaxOfRefund2: LongWord read Get_prDaySumAddTaxOfRefund2;
    property prDaySumAddTaxOfRefund3: LongWord read Get_prDaySumAddTaxOfRefund3;
    property prDaySumAddTaxOfRefund4: LongWord read Get_prDaySumAddTaxOfRefund4;
    property prDaySumAddTaxOfRefund5: LongWord read Get_prDaySumAddTaxOfRefund5;
    property prDaySumAddTaxOfRefund6: LongWord read Get_prDaySumAddTaxOfRefund6;
    property prDaySumAddTaxOfRefund1Str: WideString read Get_prDaySumAddTaxOfRefund1Str;
    property prDaySumAddTaxOfRefund2Str: WideString read Get_prDaySumAddTaxOfRefund2Str;
    property prDaySumAddTaxOfRefund3Str: WideString read Get_prDaySumAddTaxOfRefund3Str;
    property prDaySumAddTaxOfRefund4Str: WideString read Get_prDaySumAddTaxOfRefund4Str;
    property prDaySumAddTaxOfRefund5Str: WideString read Get_prDaySumAddTaxOfRefund5Str;
    property prDaySumAddTaxOfRefund6Str: WideString read Get_prDaySumAddTaxOfRefund6Str;
    property prDayAnnuledSaleReceiptsCount: Word read Get_prDayAnnuledSaleReceiptsCount;
    property prDayAnnuledSaleReceiptsCountStr: WideString read Get_prDayAnnuledSaleReceiptsCountStr;
    property prDayAnnuledRefundReceiptsCount: Word read Get_prDayAnnuledRefundReceiptsCount;
    property prDayAnnuledRefundReceiptsCountStr: WideString read Get_prDayAnnuledRefundReceiptsCountStr;
    property prDayAnnuledSaleReceiptsSum: LongWord read Get_prDayAnnuledSaleReceiptsSum;
    property prDayAnnuledSaleReceiptsSumStr: WideString read Get_prDayAnnuledSaleReceiptsSumStr;
    property prDayAnnuledRefundReceiptsSum: LongWord read Get_prDayAnnuledRefundReceiptsSum;
    property prDayAnnuledRefundReceiptsSumStr: WideString read Get_prDayAnnuledRefundReceiptsSumStr;
    property prDaySaleCancelingsCount: Word read Get_prDaySaleCancelingsCount;
    property prDaySaleCancelingsCountStr: WideString read Get_prDaySaleCancelingsCountStr;
    property prDayRefundCancelingsCount: Word read Get_prDayRefundCancelingsCount;
    property prDayRefundCancelingsCountStr: WideString read Get_prDayRefundCancelingsCountStr;
    property prDaySaleCancelingsSum: LongWord read Get_prDaySaleCancelingsSum;
    property prDaySaleCancelingsSumStr: WideString read Get_prDaySaleCancelingsSumStr;
    property prDayRefundCancelingsSum: LongWord read Get_prDayRefundCancelingsSum;
    property prDayRefundCancelingsSumStr: WideString read Get_prDayRefundCancelingsSumStr;
    property prCashDrawerSum: Int64 read Get_prCashDrawerSum;
    property prCashDrawerSumStr: WideString read Get_prCashDrawerSumStr;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prGetStatusByte: Byte read Get_prGetStatusByte;
    property prGetResultByte: Byte read Get_prGetResultByte;
    property prGetReserveByte: Byte read Get_prGetReserveByte;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prCurReceiptItemCount: Byte read Get_prCurReceiptItemCount;
    property prUserPassword: Word read Get_prUserPassword;
    property prUserPasswordStr: WideString read Get_prUserPasswordStr;
    property prRevizionID: Byte read Get_prRevizionID;
    property prFPDriverMajorVersion: Byte read Get_prFPDriverMajorVersion;
    property prFPDriverMinorVersion: Byte read Get_prFPDriverMinorVersion;
    property prFPDriverReleaseVersion: Byte read Get_prFPDriverReleaseVersion;
    property prFPDriverBuildVersion: Byte read Get_prFPDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_EP_09Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EF8A85E4-3A5B-4921-A2D9-2612F50EE281}
// *********************************************************************//
  IICS_EP_09Disp = dispinterface
    ['{EF8A85E4-3A5B-4921-A2D9-2612F50EE281}']
    function FPInitialize: Integer; dispid 433;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; dispid 201;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; dispid 202;
    function FPClose: WordBool; dispid 203;
    function FPClaimUSBDevice: WordBool; dispid 556;
    function FPReleaseUSBDevice: WordBool; dispid 557;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; dispid 204;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; dispid 205;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 206;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; dispid 207;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 208;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; dispid 209;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; dispid 210;
    function FPPrintZeroReceipt: WordBool; dispid 211;
    function FPLineFeed: WordBool; dispid 212;
    function FPAnnulReceipt: WordBool; dispid 213;
    function FPCashIn(CashSum: SYSUINT): WordBool; dispid 214;
    function FPCashOut(CashSum: SYSUINT): WordBool; dispid 215;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; dispid 216;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; dispid 217;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; dispid 218;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; dispid 219;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; dispid 220;
    function FPGetCurrentDate: WordBool; dispid 221;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; dispid 222;
    function FPGetCurrentTime: WordBool; dispid 223;
    function FPOpenCashDrawer(Duration: Word): WordBool; dispid 224;
    function FPPrintHardwareVersion: WordBool; dispid 225;
    function FPPrintLastKsefPacket: WordBool; dispid 226;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool; dispid 227;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; dispid 228;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; dispid 229;
    function FPOnlineModeSwitch: WordBool; dispid 230;
    function FPCustomerDisplayModeSwitch: WordBool; dispid 231;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; dispid 232;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; dispid 233;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; dispid 234;
    function FPCloseServiceReport: WordBool; dispid 235;
    function FPEnableLogo(ProgPassword: Word): WordBool; dispid 236;
    function FPDisableLogo(ProgPassword: Word): WordBool; dispid 237;
    function FPSetTaxRates(ProgPassword: Word): WordBool; dispid 238;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; dispid 239;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; dispid 240;
    function FPMakeXReport(ReportPassword: Word): WordBool; dispid 241;
    function FPMakeZReport(ReportPassword: Word): WordBool; dispid 242;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; dispid 243;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; dispid 244;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; dispid 245;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; dispid 246;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; dispid 247;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word;
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; dispid 248;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; dispid 249;
    function FPCutterModeSwitch: WordBool; dispid 250;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; dispid 251;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; dispid 539;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; dispid 252;
    function FPGetPaymentFormNames: WordBool; dispid 435;
    function FPGetCurrentStatus: WordBool; dispid 440;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; dispid 442;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; dispid 443;
    function FPGetCashDrawerSum: WordBool; dispid 444;
    function FPGetDayReportProperties: WordBool; dispid 445;
    function FPGetTaxRates: WordBool; dispid 446;
    function FPGetItemData(ItemCode: Int64): WordBool; dispid 447;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; dispid 448;
    function FPGetDayReportData: WordBool; dispid 449;
    function FPGetCurrentReceiptData: WordBool; dispid 450;
    function FPGetDayCorrectionsData: WordBool; dispid 452;
    function FPGetDaySumOfAddTaxes: WordBool; dispid 453;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; dispid 454;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; dispid 455;
    function FPPrintModemStatus: WordBool; dispid 456;
    function FPGetUserPassword(UserID: Byte): WordBool; dispid 535;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; dispid 548;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; dispid 549;
    function FPGetRevizionID: WordBool; dispid 540;
    property glTapeAnalizer: WordBool dispid 253;
    property glPropertiesAutoUpdateMode: WordBool dispid 254;
    property glCodepageOEM: WordBool dispid 255;
    property glLangID: Byte dispid 256;
    property glVirtualPortOpened: WordBool readonly dispid 554;
    property glUseVirtualPort: WordBool dispid 555;
    property stUseAdditionalTax: WordBool readonly dispid 415;
    property stUseAdditionalFee: WordBool readonly dispid 416;
    property stUseFontB: WordBool readonly dispid 417;
    property stUseTradeLogo: WordBool readonly dispid 418;
    property stUseCutter: WordBool readonly dispid 419;
    property stRefundReceiptMode: WordBool readonly dispid 420;
    property stPaymentMode: WordBool readonly dispid 421;
    property stFiscalMode: WordBool readonly dispid 422;
    property stServiceReceiptMode: WordBool readonly dispid 423;
    property stOnlinePrintMode: WordBool readonly dispid 424;
    property stFailureLastCommand: WordBool readonly dispid 425;
    property stFiscalDayIsOpened: WordBool readonly dispid 426;
    property stReceiptIsOpened: WordBool readonly dispid 427;
    property stCashDrawerIsOpened: WordBool readonly dispid 428;
    property stDisplayShowSumMode: WordBool readonly dispid 441;
    property prItemCost: Int64 readonly dispid 257;
    property prSumDiscount: Int64 readonly dispid 258;
    property prSumMarkup: Int64 readonly dispid 259;
    property prSumTotal: Int64 readonly dispid 260;
    property prSumBalance: Int64 readonly dispid 261;
    property prKSEFPacket: LongWord readonly dispid 262;
    property prKSEFPacketStr: WideString readonly dispid 538;
    property prModemError: Byte readonly dispid 263;
    property prCurrentDate: TDateTime readonly dispid 264;
    property prCurrentDateStr: WideString readonly dispid 265;
    property prCurrentTime: TDateTime readonly dispid 266;
    property prCurrentTimeStr: WideString readonly dispid 267;
    property prTaxRatesCount: Byte dispid 268;
    property prTaxRatesDate: TDateTime readonly dispid 269;
    property prTaxRatesDateStr: WideString readonly dispid 270;
    property prAddTaxType: WordBool dispid 271;
    property prTaxRate1: SYSINT dispid 272;
    property prTaxRate2: SYSINT dispid 273;
    property prTaxRate3: SYSINT dispid 274;
    property prTaxRate4: SYSINT dispid 275;
    property prTaxRate5: SYSINT dispid 276;
    property prTaxRate6: SYSINT readonly dispid 277;
    property prUsedAdditionalFee: WordBool dispid 278;
    property prAddFeeRate1: SYSINT dispid 279;
    property prAddFeeRate2: SYSINT dispid 280;
    property prAddFeeRate3: SYSINT dispid 281;
    property prAddFeeRate4: SYSINT dispid 282;
    property prAddFeeRate5: SYSINT dispid 283;
    property prAddFeeRate6: SYSINT dispid 284;
    property prTaxOnAddFee1: WordBool dispid 285;
    property prTaxOnAddFee2: WordBool dispid 286;
    property prTaxOnAddFee3: WordBool dispid 287;
    property prTaxOnAddFee4: WordBool dispid 288;
    property prTaxOnAddFee5: WordBool dispid 289;
    property prTaxOnAddFee6: WordBool dispid 290;
    property prAddFeeOnRetailPrice1: WordBool dispid 546;
    property prAddFeeOnRetailPrice2: WordBool dispid 547;
    property prAddFeeOnRetailPrice3: WordBool dispid 550;
    property prAddFeeOnRetailPrice4: WordBool dispid 551;
    property prAddFeeOnRetailPrice5: WordBool dispid 552;
    property prAddFeeOnRetailPrice6: WordBool dispid 553;
    property prNamePaymentForm1: WideString readonly dispid 291;
    property prNamePaymentForm2: WideString readonly dispid 292;
    property prNamePaymentForm3: WideString readonly dispid 293;
    property prNamePaymentForm4: WideString readonly dispid 294;
    property prNamePaymentForm5: WideString readonly dispid 295;
    property prNamePaymentForm6: WideString readonly dispid 296;
    property prNamePaymentForm7: WideString readonly dispid 297;
    property prNamePaymentForm8: WideString readonly dispid 298;
    property prNamePaymentForm9: WideString readonly dispid 299;
    property prNamePaymentForm10: WideString readonly dispid 300;
    property prSerialNumber: WideString readonly dispid 301;
    property prFiscalNumber: WideString readonly dispid 302;
    property prTaxNumber: WideString readonly dispid 303;
    property prDateFiscalization: TDateTime readonly dispid 304;
    property prDateFiscalizationStr: WideString readonly dispid 305;
    property prTimeFiscalization: TDateTime readonly dispid 306;
    property prTimeFiscalizationStr: WideString readonly dispid 307;
    property prHeadLine1: WideString readonly dispid 308;
    property prHeadLine2: WideString readonly dispid 309;
    property prHeadLine3: WideString readonly dispid 310;
    property prHardwareVersion: WideString readonly dispid 311;
    property prItemName: WideString readonly dispid 312;
    property prItemPrice: SYSINT readonly dispid 313;
    property prItemSaleQuantity: SYSINT readonly dispid 314;
    property prItemSaleQtyPrecision: Byte readonly dispid 315;
    property prItemTax: Byte readonly dispid 316;
    property prItemSaleSum: Int64 readonly dispid 317;
    property prItemSaleSumStr: WideString readonly dispid 318;
    property prItemRefundQuantity: SYSINT readonly dispid 319;
    property prItemRefundQtyPrecision: Byte readonly dispid 320;
    property prItemRefundSum: Int64 readonly dispid 321;
    property prItemRefundSumStr: WideString readonly dispid 322;
    property prItemCostStr: WideString readonly dispid 323;
    property prSumDiscountStr: WideString readonly dispid 324;
    property prSumMarkupStr: WideString readonly dispid 325;
    property prSumTotalStr: WideString readonly dispid 326;
    property prSumBalanceStr: WideString readonly dispid 327;
    property prCurReceiptTax1Sum: LongWord readonly dispid 328;
    property prCurReceiptTax2Sum: LongWord readonly dispid 329;
    property prCurReceiptTax3Sum: LongWord readonly dispid 330;
    property prCurReceiptTax4Sum: LongWord readonly dispid 331;
    property prCurReceiptTax5Sum: LongWord readonly dispid 332;
    property prCurReceiptTax6Sum: LongWord readonly dispid 333;
    property prCurReceiptTax1SumStr: WideString readonly dispid 457;
    property prCurReceiptTax2SumStr: WideString readonly dispid 458;
    property prCurReceiptTax3SumStr: WideString readonly dispid 459;
    property prCurReceiptTax4SumStr: WideString readonly dispid 460;
    property prCurReceiptTax5SumStr: WideString readonly dispid 461;
    property prCurReceiptTax6SumStr: WideString readonly dispid 462;
    property prCurReceiptPayForm1Sum: LongWord readonly dispid 334;
    property prCurReceiptPayForm2Sum: LongWord readonly dispid 335;
    property prCurReceiptPayForm3Sum: LongWord readonly dispid 336;
    property prCurReceiptPayForm4Sum: LongWord readonly dispid 337;
    property prCurReceiptPayForm5Sum: LongWord readonly dispid 338;
    property prCurReceiptPayForm6Sum: LongWord readonly dispid 339;
    property prCurReceiptPayForm7Sum: LongWord readonly dispid 340;
    property prCurReceiptPayForm8Sum: LongWord readonly dispid 341;
    property prCurReceiptPayForm9Sum: LongWord readonly dispid 342;
    property prCurReceiptPayForm10Sum: LongWord readonly dispid 343;
    property prCurReceiptPayForm1SumStr: WideString readonly dispid 463;
    property prCurReceiptPayForm2SumStr: WideString readonly dispid 464;
    property prCurReceiptPayForm3SumStr: WideString readonly dispid 465;
    property prCurReceiptPayForm4SumStr: WideString readonly dispid 466;
    property prCurReceiptPayForm5SumStr: WideString readonly dispid 467;
    property prCurReceiptPayForm6SumStr: WideString readonly dispid 468;
    property prCurReceiptPayForm7SumStr: WideString readonly dispid 469;
    property prCurReceiptPayForm8SumStr: WideString readonly dispid 470;
    property prCurReceiptPayForm9SumStr: WideString readonly dispid 471;
    property prCurReceiptPayForm10SumStr: WideString readonly dispid 472;
    property prPrinterError: WordBool readonly dispid 344;
    property prTapeNearEnd: WordBool readonly dispid 345;
    property prTapeEnded: WordBool readonly dispid 346;
    property prDaySaleReceiptsCount: Word readonly dispid 347;
    property prDaySaleReceiptsCountStr: WideString readonly dispid 473;
    property prDayRefundReceiptsCount: Word readonly dispid 348;
    property prDayRefundReceiptsCountStr: WideString readonly dispid 474;
    property prDaySaleSumOnTax1: LongWord readonly dispid 349;
    property prDaySaleSumOnTax2: LongWord readonly dispid 350;
    property prDaySaleSumOnTax3: LongWord readonly dispid 351;
    property prDaySaleSumOnTax4: LongWord readonly dispid 352;
    property prDaySaleSumOnTax5: LongWord readonly dispid 353;
    property prDaySaleSumOnTax6: LongWord readonly dispid 354;
    property prDaySaleSumOnTax1Str: WideString readonly dispid 475;
    property prDaySaleSumOnTax2Str: WideString readonly dispid 476;
    property prDaySaleSumOnTax3Str: WideString readonly dispid 477;
    property prDaySaleSumOnTax4Str: WideString readonly dispid 478;
    property prDaySaleSumOnTax5Str: WideString readonly dispid 479;
    property prDaySaleSumOnTax6Str: WideString readonly dispid 480;
    property prDayRefundSumOnTax1: LongWord readonly dispid 355;
    property prDayRefundSumOnTax2: LongWord readonly dispid 356;
    property prDayRefundSumOnTax3: LongWord readonly dispid 357;
    property prDayRefundSumOnTax4: LongWord readonly dispid 358;
    property prDayRefundSumOnTax5: LongWord readonly dispid 359;
    property prDayRefundSumOnTax6: LongWord readonly dispid 360;
    property prDayRefundSumOnTax1Str: WideString readonly dispid 481;
    property prDayRefundSumOnTax2Str: WideString readonly dispid 482;
    property prDayRefundSumOnTax3Str: WideString readonly dispid 483;
    property prDayRefundSumOnTax4Str: WideString readonly dispid 484;
    property prDayRefundSumOnTax5Str: WideString readonly dispid 485;
    property prDayRefundSumOnTax6Str: WideString readonly dispid 486;
    property prDaySaleSumOnPayForm1: LongWord readonly dispid 361;
    property prDaySaleSumOnPayForm2: LongWord readonly dispid 362;
    property prDaySaleSumOnPayForm3: LongWord readonly dispid 363;
    property prDaySaleSumOnPayForm4: LongWord readonly dispid 364;
    property prDaySaleSumOnPayForm5: LongWord readonly dispid 365;
    property prDaySaleSumOnPayForm6: LongWord readonly dispid 366;
    property prDaySaleSumOnPayForm7: LongWord readonly dispid 367;
    property prDaySaleSumOnPayForm8: LongWord readonly dispid 368;
    property prDaySaleSumOnPayForm9: LongWord readonly dispid 369;
    property prDaySaleSumOnPayForm10: LongWord readonly dispid 370;
    property prDaySaleSumOnPayForm1Str: WideString readonly dispid 487;
    property prDaySaleSumOnPayForm2Str: WideString readonly dispid 488;
    property prDaySaleSumOnPayForm3Str: WideString readonly dispid 489;
    property prDaySaleSumOnPayForm4Str: WideString readonly dispid 490;
    property prDaySaleSumOnPayForm5Str: WideString readonly dispid 491;
    property prDaySaleSumOnPayForm6Str: WideString readonly dispid 492;
    property prDaySaleSumOnPayForm7Str: WideString readonly dispid 493;
    property prDaySaleSumOnPayForm8Str: WideString readonly dispid 494;
    property prDaySaleSumOnPayForm9Str: WideString readonly dispid 495;
    property prDaySaleSumOnPayForm10Str: WideString readonly dispid 496;
    property prDayRefundSumOnPayForm1: LongWord readonly dispid 371;
    property prDayRefundSumOnPayForm2: LongWord readonly dispid 372;
    property prDayRefundSumOnPayForm3: LongWord readonly dispid 373;
    property prDayRefundSumOnPayForm4: LongWord readonly dispid 374;
    property prDayRefundSumOnPayForm5: LongWord readonly dispid 375;
    property prDayRefundSumOnPayForm6: LongWord readonly dispid 376;
    property prDayRefundSumOnPayForm7: LongWord readonly dispid 377;
    property prDayRefundSumOnPayForm8: LongWord readonly dispid 378;
    property prDayRefundSumOnPayForm9: LongWord readonly dispid 379;
    property prDayRefundSumOnPayForm10: LongWord readonly dispid 380;
    property prDayRefundSumOnPayForm1Str: WideString readonly dispid 497;
    property prDayRefundSumOnPayForm2Str: WideString readonly dispid 498;
    property prDayRefundSumOnPayForm3Str: WideString readonly dispid 499;
    property prDayRefundSumOnPayForm4Str: WideString readonly dispid 500;
    property prDayRefundSumOnPayForm5Str: WideString readonly dispid 501;
    property prDayRefundSumOnPayForm6Str: WideString readonly dispid 502;
    property prDayRefundSumOnPayForm7Str: WideString readonly dispid 503;
    property prDayRefundSumOnPayForm8Str: WideString readonly dispid 504;
    property prDayRefundSumOnPayForm9Str: WideString readonly dispid 505;
    property prDayRefundSumOnPayForm10Str: WideString readonly dispid 506;
    property prDayDiscountSumOnSales: LongWord readonly dispid 381;
    property prDayDiscountSumOnSalesStr: WideString readonly dispid 507;
    property prDayMarkupSumOnSales: LongWord readonly dispid 382;
    property prDayMarkupSumOnSalesStr: WideString readonly dispid 508;
    property prDayDiscountSumOnRefunds: LongWord readonly dispid 383;
    property prDayDiscountSumOnRefundsStr: WideString readonly dispid 509;
    property prDayMarkupSumOnRefunds: LongWord readonly dispid 384;
    property prDayMarkupSumOnRefundsStr: WideString readonly dispid 510;
    property prDayCashInSum: LongWord readonly dispid 385;
    property prDayCashInSumStr: WideString readonly dispid 511;
    property prDayCashOutSum: LongWord readonly dispid 386;
    property prDayCashOutSumStr: WideString readonly dispid 512;
    property prCurrentZReport: Word readonly dispid 387;
    property prCurrentZReportStr: WideString readonly dispid 513;
    property prDayEndDate: TDateTime readonly dispid 388;
    property prDayEndDateStr: WideString readonly dispid 389;
    property prDayEndTime: TDateTime readonly dispid 390;
    property prDayEndTimeStr: WideString readonly dispid 391;
    property prLastZReportDate: TDateTime readonly dispid 392;
    property prLastZReportDateStr: WideString readonly dispid 393;
    property prItemsCount: Word readonly dispid 394;
    property prItemsCountStr: WideString readonly dispid 514;
    property prDaySumAddTaxOfSale1: LongWord readonly dispid 395;
    property prDaySumAddTaxOfSale2: LongWord readonly dispid 396;
    property prDaySumAddTaxOfSale3: LongWord readonly dispid 397;
    property prDaySumAddTaxOfSale4: LongWord readonly dispid 398;
    property prDaySumAddTaxOfSale5: LongWord readonly dispid 399;
    property prDaySumAddTaxOfSale6: LongWord readonly dispid 400;
    property prDaySumAddTaxOfSale1Str: WideString readonly dispid 515;
    property prDaySumAddTaxOfSale2Str: WideString readonly dispid 516;
    property prDaySumAddTaxOfSale3Str: WideString readonly dispid 517;
    property prDaySumAddTaxOfSale4Str: WideString readonly dispid 518;
    property prDaySumAddTaxOfSale5Str: WideString readonly dispid 519;
    property prDaySumAddTaxOfSale6Str: WideString readonly dispid 520;
    property prDaySumAddTaxOfRefund1: LongWord readonly dispid 401;
    property prDaySumAddTaxOfRefund2: LongWord readonly dispid 402;
    property prDaySumAddTaxOfRefund3: LongWord readonly dispid 403;
    property prDaySumAddTaxOfRefund4: LongWord readonly dispid 404;
    property prDaySumAddTaxOfRefund5: LongWord readonly dispid 405;
    property prDaySumAddTaxOfRefund6: LongWord readonly dispid 406;
    property prDaySumAddTaxOfRefund1Str: WideString readonly dispid 521;
    property prDaySumAddTaxOfRefund2Str: WideString readonly dispid 522;
    property prDaySumAddTaxOfRefund3Str: WideString readonly dispid 523;
    property prDaySumAddTaxOfRefund4Str: WideString readonly dispid 524;
    property prDaySumAddTaxOfRefund5Str: WideString readonly dispid 525;
    property prDaySumAddTaxOfRefund6Str: WideString readonly dispid 526;
    property prDayAnnuledSaleReceiptsCount: Word readonly dispid 407;
    property prDayAnnuledSaleReceiptsCountStr: WideString readonly dispid 527;
    property prDayAnnuledRefundReceiptsCount: Word readonly dispid 408;
    property prDayAnnuledRefundReceiptsCountStr: WideString readonly dispid 528;
    property prDayAnnuledSaleReceiptsSum: LongWord readonly dispid 409;
    property prDayAnnuledSaleReceiptsSumStr: WideString readonly dispid 529;
    property prDayAnnuledRefundReceiptsSum: LongWord readonly dispid 410;
    property prDayAnnuledRefundReceiptsSumStr: WideString readonly dispid 530;
    property prDaySaleCancelingsCount: Word readonly dispid 411;
    property prDaySaleCancelingsCountStr: WideString readonly dispid 531;
    property prDayRefundCancelingsCount: Word readonly dispid 412;
    property prDayRefundCancelingsCountStr: WideString readonly dispid 532;
    property prDaySaleCancelingsSum: LongWord readonly dispid 413;
    property prDaySaleCancelingsSumStr: WideString readonly dispid 533;
    property prDayRefundCancelingsSum: LongWord readonly dispid 414;
    property prDayRefundCancelingsSumStr: WideString readonly dispid 534;
    property prCashDrawerSum: Int64 readonly dispid 429;
    property prCashDrawerSumStr: WideString readonly dispid 430;
    property prRepeatCount: Byte dispid 431;
    property prLogRecording: WordBool dispid 432;
    property prAnswerWaiting: Byte dispid 434;
    property prGetStatusByte: Byte readonly dispid 436;
    property prGetResultByte: Byte readonly dispid 437;
    property prGetReserveByte: Byte readonly dispid 438;
    property prGetErrorText: WideString readonly dispid 439;
    property prCurReceiptItemCount: Byte readonly dispid 451;
    property prUserPassword: Word readonly dispid 536;
    property prUserPasswordStr: WideString readonly dispid 537;
    property prRevizionID: Byte readonly dispid 541;
    property prFPDriverMajorVersion: Byte readonly dispid 542;
    property prFPDriverMinorVersion: Byte readonly dispid 543;
    property prFPDriverReleaseVersion: Byte readonly dispid 544;
    property prFPDriverBuildVersion: Byte readonly dispid 545;
  end;

// *********************************************************************//
// Interface: IICS_EP_11
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6064DD9-12C6-455C-83CB-B4EEB46337FE}
// *********************************************************************//
  IICS_EP_11 = interface(IDispatch)
    ['{C6064DD9-12C6-455C-83CB-B4EEB46337FE}']
    function FPInitialize: Integer; safecall;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; safecall;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; safecall;
    function FPClose: WordBool; safecall;
    function FPClaimUSBDevice: WordBool; safecall;
    function FPReleaseUSBDevice: WordBool; safecall;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; safecall;
    function FPTCPClose: WordBool; safecall;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; safecall;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; safecall;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; safecall;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool;
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; safecall;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; safecall;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; safecall;
    function FPPrintZeroReceipt: WordBool; safecall;
    function FPLineFeed: WordBool; safecall;
    function FPAnnulReceipt: WordBool; safecall;
    function FPCashIn(CashSum: SYSUINT): WordBool; safecall;
    function FPCashOut(CashSum: SYSUINT): WordBool; safecall;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; safecall;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; safecall;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; safecall;
    function FPGetCurrentDate: WordBool; safecall;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; safecall;
    function FPGetCurrentTime: WordBool; safecall;
    function FPOpenCashDrawer(Duration: Word): WordBool; safecall;
    function FPPrintHardwareVersion: WordBool; safecall;
    function FPPrintLastKsefPacket: WordBool; safecall;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool; safecall;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; safecall;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; safecall;
    function FPOnlineModeSwitch: WordBool; safecall;
    function FPCustomerDisplayModeSwitch: WordBool; safecall;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; safecall;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; safecall;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; safecall;
    function FPCloseServiceReport: WordBool; safecall;
    function FPEnableLogo(ProgPassword: Word): WordBool; safecall;
    function FPDisableLogo(ProgPassword: Word): WordBool; safecall;
    function FPSetTaxRates(ProgPassword: Word): WordBool; safecall;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; safecall;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; safecall;
    function FPMakeXReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeZReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; safecall;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; safecall;
    function FPCutterModeSwitch: WordBool; safecall;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; safecall;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; safecall;
    function FPGetPaymentFormNames: WordBool; safecall;
    function FPGetCurrentStatus: WordBool; safecall;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; safecall;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; safecall;
    function FPGetCashDrawerSum: WordBool; safecall;
    function FPGetDayReportProperties: WordBool; safecall;
    function FPGetTaxRates: WordBool; safecall;
    function FPGetItemData(ItemCode: Int64): WordBool; safecall;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; safecall;
    function FPGetDayReportData: WordBool; safecall;
    function FPGetCurrentReceiptData: WordBool; safecall;
    function FPGetDayCorrectionsData: WordBool; safecall;
    function FPGetDayPacketData: WordBool; safecall;
    function FPGetDaySumOfAddTaxes: WordBool; safecall;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; safecall;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString;
                             const AuthCode: WideString): WordBool; safecall;
    function FPPrintModemStatus: WordBool; safecall;
    function FPGetUserPassword(UserID: Byte): WordBool; safecall;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; safecall;
    function FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool; safecall;
    function FPClearGraphicPattern: WordBool; safecall;
    function FPUploadStaticGraphicData: WordBool; safecall;
    function FPUploadGraphicDoc: WordBool; safecall;
    function FPPrintGraphicDoc: WordBool; safecall;
    function FPDeleteGraphicBitmaps: WordBool; safecall;
    function FPGetGraphicFreeMemorySize: WordBool; safecall;
    function FPUploadImagesFromPattern(InvertColors: WordBool): WordBool; safecall;
    function FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool; safecall;
    function FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool; safecall;
    function FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool; safecall;
    function FPGetGraphicObjectsList: WordBool; safecall;
    function FPDeleteBitmapObject(ObjIndex: Byte): WordBool; safecall;
    function FPFullEraseGraphicMemory: WordBool; safecall;
    function FPEraseLogo: WordBool; safecall;
    function FPGetRevizionID: WordBool; safecall;
    function Get_glTapeAnalizer: WordBool; safecall;
    procedure Set_glTapeAnalizer(Value: WordBool); safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_glVirtualPortOpened: WordBool; safecall;
    function Get_glUseVirtualPort: WordBool; safecall;
    procedure Set_glUseVirtualPort(Value: WordBool); safecall;
    function Get_stUseAdditionalTax: WordBool; safecall;
    function Get_stUseAdditionalFee: WordBool; safecall;
    function Get_stUseFontB: WordBool; safecall;
    function Get_stUseTradeLogo: WordBool; safecall;
    function Get_stUseCutter: WordBool; safecall;
    function Get_stRefundReceiptMode: WordBool; safecall;
    function Get_stPaymentMode: WordBool; safecall;
    function Get_stFiscalMode: WordBool; safecall;
    function Get_stServiceReceiptMode: WordBool; safecall;
    function Get_stOnlinePrintMode: WordBool; safecall;
    function Get_stFailureLastCommand: WordBool; safecall;
    function Get_stFiscalDayIsOpened: WordBool; safecall;
    function Get_stReceiptIsOpened: WordBool; safecall;
    function Get_stCashDrawerIsOpened: WordBool; safecall;
    function Get_stDisplayShowSumMode: WordBool; safecall;
    function Get_prItemCost: Int64; safecall;
    function Get_prSumDiscount: Int64; safecall;
    function Get_prSumMarkup: Int64; safecall;
    function Get_prSumTotal: Int64; safecall;
    function Get_prSumBalance: Int64; safecall;
    function Get_prKSEFPacket: LongWord; safecall;
    function Get_prKSEFPacketStr: WideString; safecall;
    function Get_prModemError: Byte; safecall;
    function Get_prCurrentDate: TDateTime; safecall;
    function Get_prCurrentDateStr: WideString; safecall;
    function Get_prCurrentTime: TDateTime; safecall;
    function Get_prCurrentTimeStr: WideString; safecall;
    function Get_prTaxRatesCount: Byte; safecall;
    procedure Set_prTaxRatesCount(Value: Byte); safecall;
    function Get_prTaxRatesDate: TDateTime; safecall;
    function Get_prTaxRatesDateStr: WideString; safecall;
    function Get_prAddTaxType: WordBool; safecall;
    procedure Set_prAddTaxType(Value: WordBool); safecall;
    function Get_prTaxRate1: SYSINT; safecall;
    procedure Set_prTaxRate1(Value: SYSINT); safecall;
    function Get_prTaxRate2: SYSINT; safecall;
    procedure Set_prTaxRate2(Value: SYSINT); safecall;
    function Get_prTaxRate3: SYSINT; safecall;
    procedure Set_prTaxRate3(Value: SYSINT); safecall;
    function Get_prTaxRate4: SYSINT; safecall;
    procedure Set_prTaxRate4(Value: SYSINT); safecall;
    function Get_prTaxRate5: SYSINT; safecall;
    procedure Set_prTaxRate5(Value: SYSINT); safecall;
    function Get_prTaxRate6: SYSINT; safecall;
    function Get_prUsedAdditionalFee: WordBool; safecall;
    procedure Set_prUsedAdditionalFee(Value: WordBool); safecall;
    function Get_prAddFeeRate1: SYSINT; safecall;
    procedure Set_prAddFeeRate1(Value: SYSINT); safecall;
    function Get_prAddFeeRate2: SYSINT; safecall;
    procedure Set_prAddFeeRate2(Value: SYSINT); safecall;
    function Get_prAddFeeRate3: SYSINT; safecall;
    procedure Set_prAddFeeRate3(Value: SYSINT); safecall;
    function Get_prAddFeeRate4: SYSINT; safecall;
    procedure Set_prAddFeeRate4(Value: SYSINT); safecall;
    function Get_prAddFeeRate5: SYSINT; safecall;
    procedure Set_prAddFeeRate5(Value: SYSINT); safecall;
    function Get_prAddFeeRate6: SYSINT; safecall;
    procedure Set_prAddFeeRate6(Value: SYSINT); safecall;
    function Get_prTaxOnAddFee1: WordBool; safecall;
    procedure Set_prTaxOnAddFee1(Value: WordBool); safecall;
    function Get_prTaxOnAddFee2: WordBool; safecall;
    procedure Set_prTaxOnAddFee2(Value: WordBool); safecall;
    function Get_prTaxOnAddFee3: WordBool; safecall;
    procedure Set_prTaxOnAddFee3(Value: WordBool); safecall;
    function Get_prTaxOnAddFee4: WordBool; safecall;
    procedure Set_prTaxOnAddFee4(Value: WordBool); safecall;
    function Get_prTaxOnAddFee5: WordBool; safecall;
    procedure Set_prTaxOnAddFee5(Value: WordBool); safecall;
    function Get_prTaxOnAddFee6: WordBool; safecall;
    procedure Set_prTaxOnAddFee6(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice1: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice1(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice2: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice2(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice3: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice3(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice4: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice4(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice5: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice5(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice6: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice6(Value: WordBool); safecall;
    function Get_prNamePaymentForm1: WideString; safecall;
    function Get_prNamePaymentForm2: WideString; safecall;
    function Get_prNamePaymentForm3: WideString; safecall;
    function Get_prNamePaymentForm4: WideString; safecall;
    function Get_prNamePaymentForm5: WideString; safecall;
    function Get_prNamePaymentForm6: WideString; safecall;
    function Get_prNamePaymentForm7: WideString; safecall;
    function Get_prNamePaymentForm8: WideString; safecall;
    function Get_prNamePaymentForm9: WideString; safecall;
    function Get_prNamePaymentForm10: WideString; safecall;
    function Get_prSerialNumber: WideString; safecall;
    function Get_prFiscalNumber: WideString; safecall;
    function Get_prTaxNumber: WideString; safecall;
    function Get_prDateFiscalization: TDateTime; safecall;
    function Get_prDateFiscalizationStr: WideString; safecall;
    function Get_prTimeFiscalization: TDateTime; safecall;
    function Get_prTimeFiscalizationStr: WideString; safecall;
    function Get_prHeadLine1: WideString; safecall;
    function Get_prHeadLine2: WideString; safecall;
    function Get_prHeadLine3: WideString; safecall;
    function Get_prHardwareVersion: WideString; safecall;
    function Get_prItemName: WideString; safecall;
    function Get_prItemPrice: SYSINT; safecall;
    function Get_prItemSaleQuantity: SYSINT; safecall;
    function Get_prItemSaleQtyPrecision: Byte; safecall;
    function Get_prItemTax: Byte; safecall;
    function Get_prItemSaleSum: Int64; safecall;
    function Get_prItemSaleSumStr: WideString; safecall;
    function Get_prItemRefundQuantity: SYSINT; safecall;
    function Get_prItemRefundQtyPrecision: Byte; safecall;
    function Get_prItemRefundSum: Int64; safecall;
    function Get_prItemRefundSumStr: WideString; safecall;
    function Get_prItemCostStr: WideString; safecall;
    function Get_prSumDiscountStr: WideString; safecall;
    function Get_prSumMarkupStr: WideString; safecall;
    function Get_prSumTotalStr: WideString; safecall;
    function Get_prSumBalanceStr: WideString; safecall;
    function Get_prCurReceiptTax1Sum: LongWord; safecall;
    function Get_prCurReceiptTax2Sum: LongWord; safecall;
    function Get_prCurReceiptTax3Sum: LongWord; safecall;
    function Get_prCurReceiptTax4Sum: LongWord; safecall;
    function Get_prCurReceiptTax5Sum: LongWord; safecall;
    function Get_prCurReceiptTax6Sum: LongWord; safecall;
    function Get_prCurReceiptTax1SumStr: WideString; safecall;
    function Get_prCurReceiptTax2SumStr: WideString; safecall;
    function Get_prCurReceiptTax3SumStr: WideString; safecall;
    function Get_prCurReceiptTax4SumStr: WideString; safecall;
    function Get_prCurReceiptTax5SumStr: WideString; safecall;
    function Get_prCurReceiptTax6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm1Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm2Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm3Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm4Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm5Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm6Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm7Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm8Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm9Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm10Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm1SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm2SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm3SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm4SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm5SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm7SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm8SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm9SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm10SumStr: WideString; safecall;
    function Get_prPrinterError: WordBool; safecall;
    function Get_prTapeNearEnd: WordBool; safecall;
    function Get_prTapeEnded: WordBool; safecall;
    function Get_prDaySaleReceiptsCount: Word; safecall;
    function Get_prDaySaleReceiptsCountStr: WideString; safecall;
    function Get_prDayRefundReceiptsCount: Word; safecall;
    function Get_prDayRefundReceiptsCountStr: WideString; safecall;
    function Get_prDaySaleSumOnTax1: LongWord; safecall;
    function Get_prDaySaleSumOnTax2: LongWord; safecall;
    function Get_prDaySaleSumOnTax3: LongWord; safecall;
    function Get_prDaySaleSumOnTax4: LongWord; safecall;
    function Get_prDaySaleSumOnTax5: LongWord; safecall;
    function Get_prDaySaleSumOnTax6: LongWord; safecall;
    function Get_prDaySaleSumOnTax1Str: WideString; safecall;
    function Get_prDaySaleSumOnTax2Str: WideString; safecall;
    function Get_prDaySaleSumOnTax3Str: WideString; safecall;
    function Get_prDaySaleSumOnTax4Str: WideString; safecall;
    function Get_prDaySaleSumOnTax5Str: WideString; safecall;
    function Get_prDaySaleSumOnTax6Str: WideString; safecall;
    function Get_prDayRefundSumOnTax1: LongWord; safecall;
    function Get_prDayRefundSumOnTax2: LongWord; safecall;
    function Get_prDayRefundSumOnTax3: LongWord; safecall;
    function Get_prDayRefundSumOnTax4: LongWord; safecall;
    function Get_prDayRefundSumOnTax5: LongWord; safecall;
    function Get_prDayRefundSumOnTax6: LongWord; safecall;
    function Get_prDayRefundSumOnTax1Str: WideString; safecall;
    function Get_prDayRefundSumOnTax2Str: WideString; safecall;
    function Get_prDayRefundSumOnTax3Str: WideString; safecall;
    function Get_prDayRefundSumOnTax4Str: WideString; safecall;
    function Get_prDayRefundSumOnTax5Str: WideString; safecall;
    function Get_prDayRefundSumOnTax6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm1: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm2: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm3: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm4: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm5: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm6: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm7: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm8: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm9: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm10: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm1Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm2Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm3Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm4Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm5Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm7Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm8Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm9Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm10Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm1: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm2: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm3: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm4: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm5: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm6: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm7: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm8: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm9: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm10: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm1Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm2Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm3Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm4Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm5Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm6Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm7Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm8Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm9Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm10Str: WideString; safecall;
    function Get_prDayDiscountSumOnSales: LongWord; safecall;
    function Get_prDayDiscountSumOnSalesStr: WideString; safecall;
    function Get_prDayMarkupSumOnSales: LongWord; safecall;
    function Get_prDayMarkupSumOnSalesStr: WideString; safecall;
    function Get_prDayDiscountSumOnRefunds: LongWord; safecall;
    function Get_prDayDiscountSumOnRefundsStr: WideString; safecall;
    function Get_prDayMarkupSumOnRefunds: LongWord; safecall;
    function Get_prDayMarkupSumOnRefundsStr: WideString; safecall;
    function Get_prDayCashInSum: LongWord; safecall;
    function Get_prDayCashInSumStr: WideString; safecall;
    function Get_prDayCashOutSum: LongWord; safecall;
    function Get_prDayCashOutSumStr: WideString; safecall;
    function Get_prCurrentZReport: Word; safecall;
    function Get_prCurrentZReportStr: WideString; safecall;
    function Get_prDayEndDate: TDateTime; safecall;
    function Get_prDayEndDateStr: WideString; safecall;
    function Get_prDayEndTime: TDateTime; safecall;
    function Get_prDayEndTimeStr: WideString; safecall;
    function Get_prLastZReportDate: TDateTime; safecall;
    function Get_prLastZReportDateStr: WideString; safecall;
    function Get_prItemsCount: Word; safecall;
    function Get_prItemsCountStr: WideString; safecall;
    function Get_prDaySumAddTaxOfSale1: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale2: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale3: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale4: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale5: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale6: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale6Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund1: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund2: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund3: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund4: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund5: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund6: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund6Str: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsCount: Word; safecall;
    function Get_prDayAnnuledSaleReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsCount: Word; safecall;
    function Get_prDayAnnuledRefundReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledSaleReceiptsSumStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledRefundReceiptsSumStr: WideString; safecall;
    function Get_prDaySaleCancelingsCount: Word; safecall;
    function Get_prDaySaleCancelingsCountStr: WideString; safecall;
    function Get_prDayRefundCancelingsCount: Word; safecall;
    function Get_prDayRefundCancelingsCountStr: WideString; safecall;
    function Get_prDaySaleCancelingsSum: LongWord; safecall;
    function Get_prDaySaleCancelingsSumStr: WideString; safecall;
    function Get_prDayRefundCancelingsSum: LongWord; safecall;
    function Get_prDayRefundCancelingsSumStr: WideString; safecall;
    function Get_prDayFirstFreePacket: LongWord; safecall;
    function Get_prDayLastSentPacket: LongWord; safecall;
    function Get_prDayLastSignedPacket: LongWord; safecall;
    function Get_prDayFirstFreePacketStr: WideString; safecall;
    function Get_prDayLastSentPacketStr: WideString; safecall;
    function Get_prDayLastSignedPacketStr: WideString; safecall;
    function Get_prCashDrawerSum: Int64; safecall;
    function Get_prCashDrawerSumStr: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prGetStatusByte: Byte; safecall;
    function Get_prGetResultByte: Byte; safecall;
    function Get_prGetReserveByte: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prCurReceiptItemCount: Byte; safecall;
    function Get_prUserPassword: Word; safecall;
    function Get_prUserPasswordStr: WideString; safecall;
    function Get_prProgPassword: Word; safecall;
    procedure Set_prProgPassword(Value: Word); safecall;
    function Get_prProgPasswordStr: WideString; safecall;
    procedure Set_prProgPasswordStr(const Value: WideString); safecall;
    function Get_prGetGraphicFreeMemorySize: LongWord; safecall;
    function Get_prGetGraphicFreeMemorySizeStr: WideString; safecall;
    function Get_prBitmapObjectsCount: Byte; safecall;
    function Get_prGetBitmapIndex(id: Byte): Byte; safecall;
    function Get_prUDPDeviceListSize: Byte; safecall;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString; safecall;
    function Get_prUDPDeviceMAC(id: Byte): WideString; safecall;
    function Get_prUDPDeviceIP(id: Byte): WideString; safecall;
    function Get_prUDPDeviceTCPport(id: Byte): Word; safecall;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString; safecall;
    function Get_prRevizionID: Byte; safecall;
    function Get_prFPDriverMajorVersion: Byte; safecall;
    function Get_prFPDriverMinorVersion: Byte; safecall;
    function Get_prFPDriverReleaseVersion: Byte; safecall;
    function Get_prFPDriverBuildVersion: Byte; safecall;
    property glTapeAnalizer: WordBool read Get_glTapeAnalizer write Set_glTapeAnalizer;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property glVirtualPortOpened: WordBool read Get_glVirtualPortOpened;
    property glUseVirtualPort: WordBool read Get_glUseVirtualPort write Set_glUseVirtualPort;
    property stUseAdditionalTax: WordBool read Get_stUseAdditionalTax;
    property stUseAdditionalFee: WordBool read Get_stUseAdditionalFee;
    property stUseFontB: WordBool read Get_stUseFontB;
    property stUseTradeLogo: WordBool read Get_stUseTradeLogo;
    property stUseCutter: WordBool read Get_stUseCutter;
    property stRefundReceiptMode: WordBool read Get_stRefundReceiptMode;
    property stPaymentMode: WordBool read Get_stPaymentMode;
    property stFiscalMode: WordBool read Get_stFiscalMode;
    property stServiceReceiptMode: WordBool read Get_stServiceReceiptMode;
    property stOnlinePrintMode: WordBool read Get_stOnlinePrintMode;
    property stFailureLastCommand: WordBool read Get_stFailureLastCommand;
    property stFiscalDayIsOpened: WordBool read Get_stFiscalDayIsOpened;
    property stReceiptIsOpened: WordBool read Get_stReceiptIsOpened;
    property stCashDrawerIsOpened: WordBool read Get_stCashDrawerIsOpened;
    property stDisplayShowSumMode: WordBool read Get_stDisplayShowSumMode;
    property prItemCost: Int64 read Get_prItemCost;
    property prSumDiscount: Int64 read Get_prSumDiscount;
    property prSumMarkup: Int64 read Get_prSumMarkup;
    property prSumTotal: Int64 read Get_prSumTotal;
    property prSumBalance: Int64 read Get_prSumBalance;
    property prKSEFPacket: LongWord read Get_prKSEFPacket;
    property prKSEFPacketStr: WideString read Get_prKSEFPacketStr;
    property prModemError: Byte read Get_prModemError;
    property prCurrentDate: TDateTime read Get_prCurrentDate;
    property prCurrentDateStr: WideString read Get_prCurrentDateStr;
    property prCurrentTime: TDateTime read Get_prCurrentTime;
    property prCurrentTimeStr: WideString read Get_prCurrentTimeStr;
    property prTaxRatesCount: Byte read Get_prTaxRatesCount write Set_prTaxRatesCount;
    property prTaxRatesDate: TDateTime read Get_prTaxRatesDate;
    property prTaxRatesDateStr: WideString read Get_prTaxRatesDateStr;
    property prAddTaxType: WordBool read Get_prAddTaxType write Set_prAddTaxType;
    property prTaxRate1: SYSINT read Get_prTaxRate1 write Set_prTaxRate1;
    property prTaxRate2: SYSINT read Get_prTaxRate2 write Set_prTaxRate2;
    property prTaxRate3: SYSINT read Get_prTaxRate3 write Set_prTaxRate3;
    property prTaxRate4: SYSINT read Get_prTaxRate4 write Set_prTaxRate4;
    property prTaxRate5: SYSINT read Get_prTaxRate5 write Set_prTaxRate5;
    property prTaxRate6: SYSINT read Get_prTaxRate6;
    property prUsedAdditionalFee: WordBool read Get_prUsedAdditionalFee write Set_prUsedAdditionalFee;
    property prAddFeeRate1: SYSINT read Get_prAddFeeRate1 write Set_prAddFeeRate1;
    property prAddFeeRate2: SYSINT read Get_prAddFeeRate2 write Set_prAddFeeRate2;
    property prAddFeeRate3: SYSINT read Get_prAddFeeRate3 write Set_prAddFeeRate3;
    property prAddFeeRate4: SYSINT read Get_prAddFeeRate4 write Set_prAddFeeRate4;
    property prAddFeeRate5: SYSINT read Get_prAddFeeRate5 write Set_prAddFeeRate5;
    property prAddFeeRate6: SYSINT read Get_prAddFeeRate6 write Set_prAddFeeRate6;
    property prTaxOnAddFee1: WordBool read Get_prTaxOnAddFee1 write Set_prTaxOnAddFee1;
    property prTaxOnAddFee2: WordBool read Get_prTaxOnAddFee2 write Set_prTaxOnAddFee2;
    property prTaxOnAddFee3: WordBool read Get_prTaxOnAddFee3 write Set_prTaxOnAddFee3;
    property prTaxOnAddFee4: WordBool read Get_prTaxOnAddFee4 write Set_prTaxOnAddFee4;
    property prTaxOnAddFee5: WordBool read Get_prTaxOnAddFee5 write Set_prTaxOnAddFee5;
    property prTaxOnAddFee6: WordBool read Get_prTaxOnAddFee6 write Set_prTaxOnAddFee6;
    property prAddFeeOnRetailPrice1: WordBool read Get_prAddFeeOnRetailPrice1 write Set_prAddFeeOnRetailPrice1;
    property prAddFeeOnRetailPrice2: WordBool read Get_prAddFeeOnRetailPrice2 write Set_prAddFeeOnRetailPrice2;
    property prAddFeeOnRetailPrice3: WordBool read Get_prAddFeeOnRetailPrice3 write Set_prAddFeeOnRetailPrice3;
    property prAddFeeOnRetailPrice4: WordBool read Get_prAddFeeOnRetailPrice4 write Set_prAddFeeOnRetailPrice4;
    property prAddFeeOnRetailPrice5: WordBool read Get_prAddFeeOnRetailPrice5 write Set_prAddFeeOnRetailPrice5;
    property prAddFeeOnRetailPrice6: WordBool read Get_prAddFeeOnRetailPrice6 write Set_prAddFeeOnRetailPrice6;
    property prNamePaymentForm1: WideString read Get_prNamePaymentForm1;
    property prNamePaymentForm2: WideString read Get_prNamePaymentForm2;
    property prNamePaymentForm3: WideString read Get_prNamePaymentForm3;
    property prNamePaymentForm4: WideString read Get_prNamePaymentForm4;
    property prNamePaymentForm5: WideString read Get_prNamePaymentForm5;
    property prNamePaymentForm6: WideString read Get_prNamePaymentForm6;
    property prNamePaymentForm7: WideString read Get_prNamePaymentForm7;
    property prNamePaymentForm8: WideString read Get_prNamePaymentForm8;
    property prNamePaymentForm9: WideString read Get_prNamePaymentForm9;
    property prNamePaymentForm10: WideString read Get_prNamePaymentForm10;
    property prSerialNumber: WideString read Get_prSerialNumber;
    property prFiscalNumber: WideString read Get_prFiscalNumber;
    property prTaxNumber: WideString read Get_prTaxNumber;
    property prDateFiscalization: TDateTime read Get_prDateFiscalization;
    property prDateFiscalizationStr: WideString read Get_prDateFiscalizationStr;
    property prTimeFiscalization: TDateTime read Get_prTimeFiscalization;
    property prTimeFiscalizationStr: WideString read Get_prTimeFiscalizationStr;
    property prHeadLine1: WideString read Get_prHeadLine1;
    property prHeadLine2: WideString read Get_prHeadLine2;
    property prHeadLine3: WideString read Get_prHeadLine3;
    property prHardwareVersion: WideString read Get_prHardwareVersion;
    property prItemName: WideString read Get_prItemName;
    property prItemPrice: SYSINT read Get_prItemPrice;
    property prItemSaleQuantity: SYSINT read Get_prItemSaleQuantity;
    property prItemSaleQtyPrecision: Byte read Get_prItemSaleQtyPrecision;
    property prItemTax: Byte read Get_prItemTax;
    property prItemSaleSum: Int64 read Get_prItemSaleSum;
    property prItemSaleSumStr: WideString read Get_prItemSaleSumStr;
    property prItemRefundQuantity: SYSINT read Get_prItemRefundQuantity;
    property prItemRefundQtyPrecision: Byte read Get_prItemRefundQtyPrecision;
    property prItemRefundSum: Int64 read Get_prItemRefundSum;
    property prItemRefundSumStr: WideString read Get_prItemRefundSumStr;
    property prItemCostStr: WideString read Get_prItemCostStr;
    property prSumDiscountStr: WideString read Get_prSumDiscountStr;
    property prSumMarkupStr: WideString read Get_prSumMarkupStr;
    property prSumTotalStr: WideString read Get_prSumTotalStr;
    property prSumBalanceStr: WideString read Get_prSumBalanceStr;
    property prCurReceiptTax1Sum: LongWord read Get_prCurReceiptTax1Sum;
    property prCurReceiptTax2Sum: LongWord read Get_prCurReceiptTax2Sum;
    property prCurReceiptTax3Sum: LongWord read Get_prCurReceiptTax3Sum;
    property prCurReceiptTax4Sum: LongWord read Get_prCurReceiptTax4Sum;
    property prCurReceiptTax5Sum: LongWord read Get_prCurReceiptTax5Sum;
    property prCurReceiptTax6Sum: LongWord read Get_prCurReceiptTax6Sum;
    property prCurReceiptTax1SumStr: WideString read Get_prCurReceiptTax1SumStr;
    property prCurReceiptTax2SumStr: WideString read Get_prCurReceiptTax2SumStr;
    property prCurReceiptTax3SumStr: WideString read Get_prCurReceiptTax3SumStr;
    property prCurReceiptTax4SumStr: WideString read Get_prCurReceiptTax4SumStr;
    property prCurReceiptTax5SumStr: WideString read Get_prCurReceiptTax5SumStr;
    property prCurReceiptTax6SumStr: WideString read Get_prCurReceiptTax6SumStr;
    property prCurReceiptPayForm1Sum: LongWord read Get_prCurReceiptPayForm1Sum;
    property prCurReceiptPayForm2Sum: LongWord read Get_prCurReceiptPayForm2Sum;
    property prCurReceiptPayForm3Sum: LongWord read Get_prCurReceiptPayForm3Sum;
    property prCurReceiptPayForm4Sum: LongWord read Get_prCurReceiptPayForm4Sum;
    property prCurReceiptPayForm5Sum: LongWord read Get_prCurReceiptPayForm5Sum;
    property prCurReceiptPayForm6Sum: LongWord read Get_prCurReceiptPayForm6Sum;
    property prCurReceiptPayForm7Sum: LongWord read Get_prCurReceiptPayForm7Sum;
    property prCurReceiptPayForm8Sum: LongWord read Get_prCurReceiptPayForm8Sum;
    property prCurReceiptPayForm9Sum: LongWord read Get_prCurReceiptPayForm9Sum;
    property prCurReceiptPayForm10Sum: LongWord read Get_prCurReceiptPayForm10Sum;
    property prCurReceiptPayForm1SumStr: WideString read Get_prCurReceiptPayForm1SumStr;
    property prCurReceiptPayForm2SumStr: WideString read Get_prCurReceiptPayForm2SumStr;
    property prCurReceiptPayForm3SumStr: WideString read Get_prCurReceiptPayForm3SumStr;
    property prCurReceiptPayForm4SumStr: WideString read Get_prCurReceiptPayForm4SumStr;
    property prCurReceiptPayForm5SumStr: WideString read Get_prCurReceiptPayForm5SumStr;
    property prCurReceiptPayForm6SumStr: WideString read Get_prCurReceiptPayForm6SumStr;
    property prCurReceiptPayForm7SumStr: WideString read Get_prCurReceiptPayForm7SumStr;
    property prCurReceiptPayForm8SumStr: WideString read Get_prCurReceiptPayForm8SumStr;
    property prCurReceiptPayForm9SumStr: WideString read Get_prCurReceiptPayForm9SumStr;
    property prCurReceiptPayForm10SumStr: WideString read Get_prCurReceiptPayForm10SumStr;
    property prPrinterError: WordBool read Get_prPrinterError;
    property prTapeNearEnd: WordBool read Get_prTapeNearEnd;
    property prTapeEnded: WordBool read Get_prTapeEnded;
    property prDaySaleReceiptsCount: Word read Get_prDaySaleReceiptsCount;
    property prDaySaleReceiptsCountStr: WideString read Get_prDaySaleReceiptsCountStr;
    property prDayRefundReceiptsCount: Word read Get_prDayRefundReceiptsCount;
    property prDayRefundReceiptsCountStr: WideString read Get_prDayRefundReceiptsCountStr;
    property prDaySaleSumOnTax1: LongWord read Get_prDaySaleSumOnTax1;
    property prDaySaleSumOnTax2: LongWord read Get_prDaySaleSumOnTax2;
    property prDaySaleSumOnTax3: LongWord read Get_prDaySaleSumOnTax3;
    property prDaySaleSumOnTax4: LongWord read Get_prDaySaleSumOnTax4;
    property prDaySaleSumOnTax5: LongWord read Get_prDaySaleSumOnTax5;
    property prDaySaleSumOnTax6: LongWord read Get_prDaySaleSumOnTax6;
    property prDaySaleSumOnTax1Str: WideString read Get_prDaySaleSumOnTax1Str;
    property prDaySaleSumOnTax2Str: WideString read Get_prDaySaleSumOnTax2Str;
    property prDaySaleSumOnTax3Str: WideString read Get_prDaySaleSumOnTax3Str;
    property prDaySaleSumOnTax4Str: WideString read Get_prDaySaleSumOnTax4Str;
    property prDaySaleSumOnTax5Str: WideString read Get_prDaySaleSumOnTax5Str;
    property prDaySaleSumOnTax6Str: WideString read Get_prDaySaleSumOnTax6Str;
    property prDayRefundSumOnTax1: LongWord read Get_prDayRefundSumOnTax1;
    property prDayRefundSumOnTax2: LongWord read Get_prDayRefundSumOnTax2;
    property prDayRefundSumOnTax3: LongWord read Get_prDayRefundSumOnTax3;
    property prDayRefundSumOnTax4: LongWord read Get_prDayRefundSumOnTax4;
    property prDayRefundSumOnTax5: LongWord read Get_prDayRefundSumOnTax5;
    property prDayRefundSumOnTax6: LongWord read Get_prDayRefundSumOnTax6;
    property prDayRefundSumOnTax1Str: WideString read Get_prDayRefundSumOnTax1Str;
    property prDayRefundSumOnTax2Str: WideString read Get_prDayRefundSumOnTax2Str;
    property prDayRefundSumOnTax3Str: WideString read Get_prDayRefundSumOnTax3Str;
    property prDayRefundSumOnTax4Str: WideString read Get_prDayRefundSumOnTax4Str;
    property prDayRefundSumOnTax5Str: WideString read Get_prDayRefundSumOnTax5Str;
    property prDayRefundSumOnTax6Str: WideString read Get_prDayRefundSumOnTax6Str;
    property prDaySaleSumOnPayForm1: LongWord read Get_prDaySaleSumOnPayForm1;
    property prDaySaleSumOnPayForm2: LongWord read Get_prDaySaleSumOnPayForm2;
    property prDaySaleSumOnPayForm3: LongWord read Get_prDaySaleSumOnPayForm3;
    property prDaySaleSumOnPayForm4: LongWord read Get_prDaySaleSumOnPayForm4;
    property prDaySaleSumOnPayForm5: LongWord read Get_prDaySaleSumOnPayForm5;
    property prDaySaleSumOnPayForm6: LongWord read Get_prDaySaleSumOnPayForm6;
    property prDaySaleSumOnPayForm7: LongWord read Get_prDaySaleSumOnPayForm7;
    property prDaySaleSumOnPayForm8: LongWord read Get_prDaySaleSumOnPayForm8;
    property prDaySaleSumOnPayForm9: LongWord read Get_prDaySaleSumOnPayForm9;
    property prDaySaleSumOnPayForm10: LongWord read Get_prDaySaleSumOnPayForm10;
    property prDaySaleSumOnPayForm1Str: WideString read Get_prDaySaleSumOnPayForm1Str;
    property prDaySaleSumOnPayForm2Str: WideString read Get_prDaySaleSumOnPayForm2Str;
    property prDaySaleSumOnPayForm3Str: WideString read Get_prDaySaleSumOnPayForm3Str;
    property prDaySaleSumOnPayForm4Str: WideString read Get_prDaySaleSumOnPayForm4Str;
    property prDaySaleSumOnPayForm5Str: WideString read Get_prDaySaleSumOnPayForm5Str;
    property prDaySaleSumOnPayForm6Str: WideString read Get_prDaySaleSumOnPayForm6Str;
    property prDaySaleSumOnPayForm7Str: WideString read Get_prDaySaleSumOnPayForm7Str;
    property prDaySaleSumOnPayForm8Str: WideString read Get_prDaySaleSumOnPayForm8Str;
    property prDaySaleSumOnPayForm9Str: WideString read Get_prDaySaleSumOnPayForm9Str;
    property prDaySaleSumOnPayForm10Str: WideString read Get_prDaySaleSumOnPayForm10Str;
    property prDayRefundSumOnPayForm1: LongWord read Get_prDayRefundSumOnPayForm1;
    property prDayRefundSumOnPayForm2: LongWord read Get_prDayRefundSumOnPayForm2;
    property prDayRefundSumOnPayForm3: LongWord read Get_prDayRefundSumOnPayForm3;
    property prDayRefundSumOnPayForm4: LongWord read Get_prDayRefundSumOnPayForm4;
    property prDayRefundSumOnPayForm5: LongWord read Get_prDayRefundSumOnPayForm5;
    property prDayRefundSumOnPayForm6: LongWord read Get_prDayRefundSumOnPayForm6;
    property prDayRefundSumOnPayForm7: LongWord read Get_prDayRefundSumOnPayForm7;
    property prDayRefundSumOnPayForm8: LongWord read Get_prDayRefundSumOnPayForm8;
    property prDayRefundSumOnPayForm9: LongWord read Get_prDayRefundSumOnPayForm9;
    property prDayRefundSumOnPayForm10: LongWord read Get_prDayRefundSumOnPayForm10;
    property prDayRefundSumOnPayForm1Str: WideString read Get_prDayRefundSumOnPayForm1Str;
    property prDayRefundSumOnPayForm2Str: WideString read Get_prDayRefundSumOnPayForm2Str;
    property prDayRefundSumOnPayForm3Str: WideString read Get_prDayRefundSumOnPayForm3Str;
    property prDayRefundSumOnPayForm4Str: WideString read Get_prDayRefundSumOnPayForm4Str;
    property prDayRefundSumOnPayForm5Str: WideString read Get_prDayRefundSumOnPayForm5Str;
    property prDayRefundSumOnPayForm6Str: WideString read Get_prDayRefundSumOnPayForm6Str;
    property prDayRefundSumOnPayForm7Str: WideString read Get_prDayRefundSumOnPayForm7Str;
    property prDayRefundSumOnPayForm8Str: WideString read Get_prDayRefundSumOnPayForm8Str;
    property prDayRefundSumOnPayForm9Str: WideString read Get_prDayRefundSumOnPayForm9Str;
    property prDayRefundSumOnPayForm10Str: WideString read Get_prDayRefundSumOnPayForm10Str;
    property prDayDiscountSumOnSales: LongWord read Get_prDayDiscountSumOnSales;
    property prDayDiscountSumOnSalesStr: WideString read Get_prDayDiscountSumOnSalesStr;
    property prDayMarkupSumOnSales: LongWord read Get_prDayMarkupSumOnSales;
    property prDayMarkupSumOnSalesStr: WideString read Get_prDayMarkupSumOnSalesStr;
    property prDayDiscountSumOnRefunds: LongWord read Get_prDayDiscountSumOnRefunds;
    property prDayDiscountSumOnRefundsStr: WideString read Get_prDayDiscountSumOnRefundsStr;
    property prDayMarkupSumOnRefunds: LongWord read Get_prDayMarkupSumOnRefunds;
    property prDayMarkupSumOnRefundsStr: WideString read Get_prDayMarkupSumOnRefundsStr;
    property prDayCashInSum: LongWord read Get_prDayCashInSum;
    property prDayCashInSumStr: WideString read Get_prDayCashInSumStr;
    property prDayCashOutSum: LongWord read Get_prDayCashOutSum;
    property prDayCashOutSumStr: WideString read Get_prDayCashOutSumStr;
    property prCurrentZReport: Word read Get_prCurrentZReport;
    property prCurrentZReportStr: WideString read Get_prCurrentZReportStr;
    property prDayEndDate: TDateTime read Get_prDayEndDate;
    property prDayEndDateStr: WideString read Get_prDayEndDateStr;
    property prDayEndTime: TDateTime read Get_prDayEndTime;
    property prDayEndTimeStr: WideString read Get_prDayEndTimeStr;
    property prLastZReportDate: TDateTime read Get_prLastZReportDate;
    property prLastZReportDateStr: WideString read Get_prLastZReportDateStr;
    property prItemsCount: Word read Get_prItemsCount;
    property prItemsCountStr: WideString read Get_prItemsCountStr;
    property prDaySumAddTaxOfSale1: LongWord read Get_prDaySumAddTaxOfSale1;
    property prDaySumAddTaxOfSale2: LongWord read Get_prDaySumAddTaxOfSale2;
    property prDaySumAddTaxOfSale3: LongWord read Get_prDaySumAddTaxOfSale3;
    property prDaySumAddTaxOfSale4: LongWord read Get_prDaySumAddTaxOfSale4;
    property prDaySumAddTaxOfSale5: LongWord read Get_prDaySumAddTaxOfSale5;
    property prDaySumAddTaxOfSale6: LongWord read Get_prDaySumAddTaxOfSale6;
    property prDaySumAddTaxOfSale1Str: WideString read Get_prDaySumAddTaxOfSale1Str;
    property prDaySumAddTaxOfSale2Str: WideString read Get_prDaySumAddTaxOfSale2Str;
    property prDaySumAddTaxOfSale3Str: WideString read Get_prDaySumAddTaxOfSale3Str;
    property prDaySumAddTaxOfSale4Str: WideString read Get_prDaySumAddTaxOfSale4Str;
    property prDaySumAddTaxOfSale5Str: WideString read Get_prDaySumAddTaxOfSale5Str;
    property prDaySumAddTaxOfSale6Str: WideString read Get_prDaySumAddTaxOfSale6Str;
    property prDaySumAddTaxOfRefund1: LongWord read Get_prDaySumAddTaxOfRefund1;
    property prDaySumAddTaxOfRefund2: LongWord read Get_prDaySumAddTaxOfRefund2;
    property prDaySumAddTaxOfRefund3: LongWord read Get_prDaySumAddTaxOfRefund3;
    property prDaySumAddTaxOfRefund4: LongWord read Get_prDaySumAddTaxOfRefund4;
    property prDaySumAddTaxOfRefund5: LongWord read Get_prDaySumAddTaxOfRefund5;
    property prDaySumAddTaxOfRefund6: LongWord read Get_prDaySumAddTaxOfRefund6;
    property prDaySumAddTaxOfRefund1Str: WideString read Get_prDaySumAddTaxOfRefund1Str;
    property prDaySumAddTaxOfRefund2Str: WideString read Get_prDaySumAddTaxOfRefund2Str;
    property prDaySumAddTaxOfRefund3Str: WideString read Get_prDaySumAddTaxOfRefund3Str;
    property prDaySumAddTaxOfRefund4Str: WideString read Get_prDaySumAddTaxOfRefund4Str;
    property prDaySumAddTaxOfRefund5Str: WideString read Get_prDaySumAddTaxOfRefund5Str;
    property prDaySumAddTaxOfRefund6Str: WideString read Get_prDaySumAddTaxOfRefund6Str;
    property prDayAnnuledSaleReceiptsCount: Word read Get_prDayAnnuledSaleReceiptsCount;
    property prDayAnnuledSaleReceiptsCountStr: WideString read Get_prDayAnnuledSaleReceiptsCountStr;
    property prDayAnnuledRefundReceiptsCount: Word read Get_prDayAnnuledRefundReceiptsCount;
    property prDayAnnuledRefundReceiptsCountStr: WideString read Get_prDayAnnuledRefundReceiptsCountStr;
    property prDayAnnuledSaleReceiptsSum: LongWord read Get_prDayAnnuledSaleReceiptsSum;
    property prDayAnnuledSaleReceiptsSumStr: WideString read Get_prDayAnnuledSaleReceiptsSumStr;
    property prDayAnnuledRefundReceiptsSum: LongWord read Get_prDayAnnuledRefundReceiptsSum;
    property prDayAnnuledRefundReceiptsSumStr: WideString read Get_prDayAnnuledRefundReceiptsSumStr;
    property prDaySaleCancelingsCount: Word read Get_prDaySaleCancelingsCount;
    property prDaySaleCancelingsCountStr: WideString read Get_prDaySaleCancelingsCountStr;
    property prDayRefundCancelingsCount: Word read Get_prDayRefundCancelingsCount;
    property prDayRefundCancelingsCountStr: WideString read Get_prDayRefundCancelingsCountStr;
    property prDaySaleCancelingsSum: LongWord read Get_prDaySaleCancelingsSum;
    property prDaySaleCancelingsSumStr: WideString read Get_prDaySaleCancelingsSumStr;
    property prDayRefundCancelingsSum: LongWord read Get_prDayRefundCancelingsSum;
    property prDayRefundCancelingsSumStr: WideString read Get_prDayRefundCancelingsSumStr;
    property prDayFirstFreePacket: LongWord read Get_prDayFirstFreePacket;
    property prDayLastSentPacket: LongWord read Get_prDayLastSentPacket;
    property prDayLastSignedPacket: LongWord read Get_prDayLastSignedPacket;
    property prDayFirstFreePacketStr: WideString read Get_prDayFirstFreePacketStr;
    property prDayLastSentPacketStr: WideString read Get_prDayLastSentPacketStr;
    property prDayLastSignedPacketStr: WideString read Get_prDayLastSignedPacketStr;
    property prCashDrawerSum: Int64 read Get_prCashDrawerSum;
    property prCashDrawerSumStr: WideString read Get_prCashDrawerSumStr;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prGetStatusByte: Byte read Get_prGetStatusByte;
    property prGetResultByte: Byte read Get_prGetResultByte;
    property prGetReserveByte: Byte read Get_prGetReserveByte;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prCurReceiptItemCount: Byte read Get_prCurReceiptItemCount;
    property prUserPassword: Word read Get_prUserPassword;
    property prUserPasswordStr: WideString read Get_prUserPasswordStr;
    property prProgPassword: Word read Get_prProgPassword write Set_prProgPassword;
    property prProgPasswordStr: WideString read Get_prProgPasswordStr write Set_prProgPasswordStr;
    property prGetGraphicFreeMemorySize: LongWord read Get_prGetGraphicFreeMemorySize;
    property prGetGraphicFreeMemorySizeStr: WideString read Get_prGetGraphicFreeMemorySizeStr;
    property prBitmapObjectsCount: Byte read Get_prBitmapObjectsCount;
    property prGetBitmapIndex[id: Byte]: Byte read Get_prGetBitmapIndex;
    property prUDPDeviceListSize: Byte read Get_prUDPDeviceListSize;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte read Get_prRevizionID;
    property prFPDriverMajorVersion: Byte read Get_prFPDriverMajorVersion;
    property prFPDriverMinorVersion: Byte read Get_prFPDriverMinorVersion;
    property prFPDriverReleaseVersion: Byte read Get_prFPDriverReleaseVersion;
    property prFPDriverBuildVersion: Byte read Get_prFPDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_EP_11Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6064DD9-12C6-455C-83CB-B4EEB46337FE}
// *********************************************************************//
  IICS_EP_11Disp = dispinterface
    ['{C6064DD9-12C6-455C-83CB-B4EEB46337FE}']
    function FPInitialize: Integer; dispid 433;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; dispid 201;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; dispid 202;
    function FPClose: WordBool; dispid 203;
    function FPClaimUSBDevice: WordBool; dispid 578;
    function FPReleaseUSBDevice: WordBool; dispid 579;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; dispid 580;
    function FPTCPClose: WordBool; dispid 581;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; dispid 593;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; dispid 204;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; dispid 205;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 206;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; dispid 207;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 208;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; dispid 209;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; dispid 210;
    function FPPrintZeroReceipt: WordBool; dispid 211;
    function FPLineFeed: WordBool; dispid 212;
    function FPAnnulReceipt: WordBool; dispid 213;
    function FPCashIn(CashSum: SYSUINT): WordBool; dispid 214;
    function FPCashOut(CashSum: SYSUINT): WordBool; dispid 215;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; dispid 216;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; dispid 217;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; dispid 218;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; dispid 219;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; dispid 220;
    function FPGetCurrentDate: WordBool; dispid 221;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; dispid 222;
    function FPGetCurrentTime: WordBool; dispid 223;
    function FPOpenCashDrawer(Duration: Word): WordBool; dispid 224;
    function FPPrintHardwareVersion: WordBool; dispid 225;
    function FPPrintLastKsefPacket: WordBool; dispid 226;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool; dispid 227;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; dispid 228;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; dispid 229;
    function FPOnlineModeSwitch: WordBool; dispid 230;
    function FPCustomerDisplayModeSwitch: WordBool; dispid 231;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; dispid 232;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; dispid 233;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; dispid 234;
    function FPCloseServiceReport: WordBool; dispid 235;
    function FPEnableLogo(ProgPassword: Word): WordBool; dispid 236;
    function FPDisableLogo(ProgPassword: Word): WordBool; dispid 237;
    function FPSetTaxRates(ProgPassword: Word): WordBool; dispid 238;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; dispid 239;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; dispid 240;
    function FPMakeXReport(ReportPassword: Word): WordBool; dispid 241;
    function FPMakeZReport(ReportPassword: Word): WordBool; dispid 242;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; dispid 243;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; dispid 244;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; dispid 245;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; dispid 246;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; dispid 247;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; dispid 248;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; dispid 249;
    function FPCutterModeSwitch: WordBool; dispid 250;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; dispid 251;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; dispid 539;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; dispid 252;
    function FPGetPaymentFormNames: WordBool; dispid 435;
    function FPGetCurrentStatus: WordBool; dispid 440;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; dispid 442;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; dispid 443;
    function FPGetCashDrawerSum: WordBool; dispid 444;
    function FPGetDayReportProperties: WordBool; dispid 445;
    function FPGetTaxRates: WordBool; dispid 446;
    function FPGetItemData(ItemCode: Int64): WordBool; dispid 447;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; dispid 448;
    function FPGetDayReportData: WordBool; dispid 449;
    function FPGetCurrentReceiptData: WordBool; dispid 450;
    function FPGetDayCorrectionsData: WordBool; dispid 452;
    function FPGetDayPacketData: WordBool; dispid 554;
    function FPGetDaySumOfAddTaxes: WordBool; dispid 453;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; dispid 454;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; dispid 455;
    function FPPrintModemStatus: WordBool; dispid 456;
    function FPGetUserPassword(UserID: Byte): WordBool; dispid 535;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; dispid 548;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; dispid 549;
    function FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool; dispid 561;
    function FPClearGraphicPattern: WordBool; dispid 562;
    function FPUploadStaticGraphicData: WordBool; dispid 563;
    function FPUploadGraphicDoc: WordBool; dispid 575;
    function FPPrintGraphicDoc: WordBool; dispid 564;
    function FPDeleteGraphicBitmaps: WordBool; dispid 565;
    function FPGetGraphicFreeMemorySize: WordBool; dispid 568;
    function FPUploadImagesFromPattern(InvertColors: WordBool): WordBool; dispid 571;
    function FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool; dispid 572;
    function FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool; dispid 573;
    function FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool; dispid 574;
    function FPGetGraphicObjectsList: WordBool; dispid 582;
    function FPDeleteBitmapObject(ObjIndex: Byte): WordBool; dispid 583;
    function FPFullEraseGraphicMemory: WordBool; dispid 584;
    function FPEraseLogo: WordBool; dispid 585;
    function FPGetRevizionID: WordBool; dispid 540;
    property glTapeAnalizer: WordBool dispid 253;
    property glPropertiesAutoUpdateMode: WordBool dispid 254;
    property glCodepageOEM: WordBool dispid 255;
    property glLangID: Byte dispid 256;
    property glVirtualPortOpened: WordBool readonly dispid 576;
    property glUseVirtualPort: WordBool dispid 577;
    property stUseAdditionalTax: WordBool readonly dispid 415;
    property stUseAdditionalFee: WordBool readonly dispid 416;
    property stUseFontB: WordBool readonly dispid 417;
    property stUseTradeLogo: WordBool readonly dispid 418;
    property stUseCutter: WordBool readonly dispid 419;
    property stRefundReceiptMode: WordBool readonly dispid 420;
    property stPaymentMode: WordBool readonly dispid 421;
    property stFiscalMode: WordBool readonly dispid 422;
    property stServiceReceiptMode: WordBool readonly dispid 423;
    property stOnlinePrintMode: WordBool readonly dispid 424;
    property stFailureLastCommand: WordBool readonly dispid 425;
    property stFiscalDayIsOpened: WordBool readonly dispid 426;
    property stReceiptIsOpened: WordBool readonly dispid 427;
    property stCashDrawerIsOpened: WordBool readonly dispid 428;
    property stDisplayShowSumMode: WordBool readonly dispid 441;
    property prItemCost: Int64 readonly dispid 257;
    property prSumDiscount: Int64 readonly dispid 258;
    property prSumMarkup: Int64 readonly dispid 259;
    property prSumTotal: Int64 readonly dispid 260;
    property prSumBalance: Int64 readonly dispid 261;
    property prKSEFPacket: LongWord readonly dispid 262;
    property prKSEFPacketStr: WideString readonly dispid 538;
    property prModemError: Byte readonly dispid 263;
    property prCurrentDate: TDateTime readonly dispid 264;
    property prCurrentDateStr: WideString readonly dispid 265;
    property prCurrentTime: TDateTime readonly dispid 266;
    property prCurrentTimeStr: WideString readonly dispid 267;
    property prTaxRatesCount: Byte dispid 268;
    property prTaxRatesDate: TDateTime readonly dispid 269;
    property prTaxRatesDateStr: WideString readonly dispid 270;
    property prAddTaxType: WordBool dispid 271;
    property prTaxRate1: SYSINT dispid 272;
    property prTaxRate2: SYSINT dispid 273;
    property prTaxRate3: SYSINT dispid 274;
    property prTaxRate4: SYSINT dispid 275;
    property prTaxRate5: SYSINT dispid 276;
    property prTaxRate6: SYSINT readonly dispid 277;
    property prUsedAdditionalFee: WordBool dispid 278;
    property prAddFeeRate1: SYSINT dispid 279;
    property prAddFeeRate2: SYSINT dispid 280;
    property prAddFeeRate3: SYSINT dispid 281;
    property prAddFeeRate4: SYSINT dispid 282;
    property prAddFeeRate5: SYSINT dispid 283;
    property prAddFeeRate6: SYSINT dispid 284;
    property prTaxOnAddFee1: WordBool dispid 285;
    property prTaxOnAddFee2: WordBool dispid 286;
    property prTaxOnAddFee3: WordBool dispid 287;
    property prTaxOnAddFee4: WordBool dispid 288;
    property prTaxOnAddFee5: WordBool dispid 289;
    property prTaxOnAddFee6: WordBool dispid 290;
    property prAddFeeOnRetailPrice1: WordBool dispid 546;
    property prAddFeeOnRetailPrice2: WordBool dispid 547;
    property prAddFeeOnRetailPrice3: WordBool dispid 550;
    property prAddFeeOnRetailPrice4: WordBool dispid 551;
    property prAddFeeOnRetailPrice5: WordBool dispid 552;
    property prAddFeeOnRetailPrice6: WordBool dispid 553;
    property prNamePaymentForm1: WideString readonly dispid 291;
    property prNamePaymentForm2: WideString readonly dispid 292;
    property prNamePaymentForm3: WideString readonly dispid 293;
    property prNamePaymentForm4: WideString readonly dispid 294;
    property prNamePaymentForm5: WideString readonly dispid 295;
    property prNamePaymentForm6: WideString readonly dispid 296;
    property prNamePaymentForm7: WideString readonly dispid 297;
    property prNamePaymentForm8: WideString readonly dispid 298;
    property prNamePaymentForm9: WideString readonly dispid 299;
    property prNamePaymentForm10: WideString readonly dispid 300;
    property prSerialNumber: WideString readonly dispid 301;
    property prFiscalNumber: WideString readonly dispid 302;
    property prTaxNumber: WideString readonly dispid 303;
    property prDateFiscalization: TDateTime readonly dispid 304;
    property prDateFiscalizationStr: WideString readonly dispid 305;
    property prTimeFiscalization: TDateTime readonly dispid 306;
    property prTimeFiscalizationStr: WideString readonly dispid 307;
    property prHeadLine1: WideString readonly dispid 308;
    property prHeadLine2: WideString readonly dispid 309;
    property prHeadLine3: WideString readonly dispid 310;
    property prHardwareVersion: WideString readonly dispid 311;
    property prItemName: WideString readonly dispid 312;
    property prItemPrice: SYSINT readonly dispid 313;
    property prItemSaleQuantity: SYSINT readonly dispid 314;
    property prItemSaleQtyPrecision: Byte readonly dispid 315;
    property prItemTax: Byte readonly dispid 316;
    property prItemSaleSum: Int64 readonly dispid 317;
    property prItemSaleSumStr: WideString readonly dispid 318;
    property prItemRefundQuantity: SYSINT readonly dispid 319;
    property prItemRefundQtyPrecision: Byte readonly dispid 320;
    property prItemRefundSum: Int64 readonly dispid 321;
    property prItemRefundSumStr: WideString readonly dispid 322;
    property prItemCostStr: WideString readonly dispid 323;
    property prSumDiscountStr: WideString readonly dispid 324;
    property prSumMarkupStr: WideString readonly dispid 325;
    property prSumTotalStr: WideString readonly dispid 326;
    property prSumBalanceStr: WideString readonly dispid 327;
    property prCurReceiptTax1Sum: LongWord readonly dispid 328;
    property prCurReceiptTax2Sum: LongWord readonly dispid 329;
    property prCurReceiptTax3Sum: LongWord readonly dispid 330;
    property prCurReceiptTax4Sum: LongWord readonly dispid 331;
    property prCurReceiptTax5Sum: LongWord readonly dispid 332;
    property prCurReceiptTax6Sum: LongWord readonly dispid 333;
    property prCurReceiptTax1SumStr: WideString readonly dispid 457;
    property prCurReceiptTax2SumStr: WideString readonly dispid 458;
    property prCurReceiptTax3SumStr: WideString readonly dispid 459;
    property prCurReceiptTax4SumStr: WideString readonly dispid 460;
    property prCurReceiptTax5SumStr: WideString readonly dispid 461;
    property prCurReceiptTax6SumStr: WideString readonly dispid 462;
    property prCurReceiptPayForm1Sum: LongWord readonly dispid 334;
    property prCurReceiptPayForm2Sum: LongWord readonly dispid 335;
    property prCurReceiptPayForm3Sum: LongWord readonly dispid 336;
    property prCurReceiptPayForm4Sum: LongWord readonly dispid 337;
    property prCurReceiptPayForm5Sum: LongWord readonly dispid 338;
    property prCurReceiptPayForm6Sum: LongWord readonly dispid 339;
    property prCurReceiptPayForm7Sum: LongWord readonly dispid 340;
    property prCurReceiptPayForm8Sum: LongWord readonly dispid 341;
    property prCurReceiptPayForm9Sum: LongWord readonly dispid 342;
    property prCurReceiptPayForm10Sum: LongWord readonly dispid 343;
    property prCurReceiptPayForm1SumStr: WideString readonly dispid 463;
    property prCurReceiptPayForm2SumStr: WideString readonly dispid 464;
    property prCurReceiptPayForm3SumStr: WideString readonly dispid 465;
    property prCurReceiptPayForm4SumStr: WideString readonly dispid 466;
    property prCurReceiptPayForm5SumStr: WideString readonly dispid 467;
    property prCurReceiptPayForm6SumStr: WideString readonly dispid 468;
    property prCurReceiptPayForm7SumStr: WideString readonly dispid 469;
    property prCurReceiptPayForm8SumStr: WideString readonly dispid 470;
    property prCurReceiptPayForm9SumStr: WideString readonly dispid 471;
    property prCurReceiptPayForm10SumStr: WideString readonly dispid 472;
    property prPrinterError: WordBool readonly dispid 344;
    property prTapeNearEnd: WordBool readonly dispid 345;
    property prTapeEnded: WordBool readonly dispid 346;
    property prDaySaleReceiptsCount: Word readonly dispid 347;
    property prDaySaleReceiptsCountStr: WideString readonly dispid 473;
    property prDayRefundReceiptsCount: Word readonly dispid 348;
    property prDayRefundReceiptsCountStr: WideString readonly dispid 474;
    property prDaySaleSumOnTax1: LongWord readonly dispid 349;
    property prDaySaleSumOnTax2: LongWord readonly dispid 350;
    property prDaySaleSumOnTax3: LongWord readonly dispid 351;
    property prDaySaleSumOnTax4: LongWord readonly dispid 352;
    property prDaySaleSumOnTax5: LongWord readonly dispid 353;
    property prDaySaleSumOnTax6: LongWord readonly dispid 354;
    property prDaySaleSumOnTax1Str: WideString readonly dispid 475;
    property prDaySaleSumOnTax2Str: WideString readonly dispid 476;
    property prDaySaleSumOnTax3Str: WideString readonly dispid 477;
    property prDaySaleSumOnTax4Str: WideString readonly dispid 478;
    property prDaySaleSumOnTax5Str: WideString readonly dispid 479;
    property prDaySaleSumOnTax6Str: WideString readonly dispid 480;
    property prDayRefundSumOnTax1: LongWord readonly dispid 355;
    property prDayRefundSumOnTax2: LongWord readonly dispid 356;
    property prDayRefundSumOnTax3: LongWord readonly dispid 357;
    property prDayRefundSumOnTax4: LongWord readonly dispid 358;
    property prDayRefundSumOnTax5: LongWord readonly dispid 359;
    property prDayRefundSumOnTax6: LongWord readonly dispid 360;
    property prDayRefundSumOnTax1Str: WideString readonly dispid 481;
    property prDayRefundSumOnTax2Str: WideString readonly dispid 482;
    property prDayRefundSumOnTax3Str: WideString readonly dispid 483;
    property prDayRefundSumOnTax4Str: WideString readonly dispid 484;
    property prDayRefundSumOnTax5Str: WideString readonly dispid 485;
    property prDayRefundSumOnTax6Str: WideString readonly dispid 486;
    property prDaySaleSumOnPayForm1: LongWord readonly dispid 361;
    property prDaySaleSumOnPayForm2: LongWord readonly dispid 362;
    property prDaySaleSumOnPayForm3: LongWord readonly dispid 363;
    property prDaySaleSumOnPayForm4: LongWord readonly dispid 364;
    property prDaySaleSumOnPayForm5: LongWord readonly dispid 365;
    property prDaySaleSumOnPayForm6: LongWord readonly dispid 366;
    property prDaySaleSumOnPayForm7: LongWord readonly dispid 367;
    property prDaySaleSumOnPayForm8: LongWord readonly dispid 368;
    property prDaySaleSumOnPayForm9: LongWord readonly dispid 369;
    property prDaySaleSumOnPayForm10: LongWord readonly dispid 370;
    property prDaySaleSumOnPayForm1Str: WideString readonly dispid 487;
    property prDaySaleSumOnPayForm2Str: WideString readonly dispid 488;
    property prDaySaleSumOnPayForm3Str: WideString readonly dispid 489;
    property prDaySaleSumOnPayForm4Str: WideString readonly dispid 490;
    property prDaySaleSumOnPayForm5Str: WideString readonly dispid 491;
    property prDaySaleSumOnPayForm6Str: WideString readonly dispid 492;
    property prDaySaleSumOnPayForm7Str: WideString readonly dispid 493;
    property prDaySaleSumOnPayForm8Str: WideString readonly dispid 494;
    property prDaySaleSumOnPayForm9Str: WideString readonly dispid 495;
    property prDaySaleSumOnPayForm10Str: WideString readonly dispid 496;
    property prDayRefundSumOnPayForm1: LongWord readonly dispid 371;
    property prDayRefundSumOnPayForm2: LongWord readonly dispid 372;
    property prDayRefundSumOnPayForm3: LongWord readonly dispid 373;
    property prDayRefundSumOnPayForm4: LongWord readonly dispid 374;
    property prDayRefundSumOnPayForm5: LongWord readonly dispid 375;
    property prDayRefundSumOnPayForm6: LongWord readonly dispid 376;
    property prDayRefundSumOnPayForm7: LongWord readonly dispid 377;
    property prDayRefundSumOnPayForm8: LongWord readonly dispid 378;
    property prDayRefundSumOnPayForm9: LongWord readonly dispid 379;
    property prDayRefundSumOnPayForm10: LongWord readonly dispid 380;
    property prDayRefundSumOnPayForm1Str: WideString readonly dispid 497;
    property prDayRefundSumOnPayForm2Str: WideString readonly dispid 498;
    property prDayRefundSumOnPayForm3Str: WideString readonly dispid 499;
    property prDayRefundSumOnPayForm4Str: WideString readonly dispid 500;
    property prDayRefundSumOnPayForm5Str: WideString readonly dispid 501;
    property prDayRefundSumOnPayForm6Str: WideString readonly dispid 502;
    property prDayRefundSumOnPayForm7Str: WideString readonly dispid 503;
    property prDayRefundSumOnPayForm8Str: WideString readonly dispid 504;
    property prDayRefundSumOnPayForm9Str: WideString readonly dispid 505;
    property prDayRefundSumOnPayForm10Str: WideString readonly dispid 506;
    property prDayDiscountSumOnSales: LongWord readonly dispid 381;
    property prDayDiscountSumOnSalesStr: WideString readonly dispid 507;
    property prDayMarkupSumOnSales: LongWord readonly dispid 382;
    property prDayMarkupSumOnSalesStr: WideString readonly dispid 508;
    property prDayDiscountSumOnRefunds: LongWord readonly dispid 383;
    property prDayDiscountSumOnRefundsStr: WideString readonly dispid 509;
    property prDayMarkupSumOnRefunds: LongWord readonly dispid 384;
    property prDayMarkupSumOnRefundsStr: WideString readonly dispid 510;
    property prDayCashInSum: LongWord readonly dispid 385;
    property prDayCashInSumStr: WideString readonly dispid 511;
    property prDayCashOutSum: LongWord readonly dispid 386;
    property prDayCashOutSumStr: WideString readonly dispid 512;
    property prCurrentZReport: Word readonly dispid 387;
    property prCurrentZReportStr: WideString readonly dispid 513;
    property prDayEndDate: TDateTime readonly dispid 388;
    property prDayEndDateStr: WideString readonly dispid 389;
    property prDayEndTime: TDateTime readonly dispid 390;
    property prDayEndTimeStr: WideString readonly dispid 391;
    property prLastZReportDate: TDateTime readonly dispid 392;
    property prLastZReportDateStr: WideString readonly dispid 393;
    property prItemsCount: Word readonly dispid 394;
    property prItemsCountStr: WideString readonly dispid 514;
    property prDaySumAddTaxOfSale1: LongWord readonly dispid 395;
    property prDaySumAddTaxOfSale2: LongWord readonly dispid 396;
    property prDaySumAddTaxOfSale3: LongWord readonly dispid 397;
    property prDaySumAddTaxOfSale4: LongWord readonly dispid 398;
    property prDaySumAddTaxOfSale5: LongWord readonly dispid 399;
    property prDaySumAddTaxOfSale6: LongWord readonly dispid 400;
    property prDaySumAddTaxOfSale1Str: WideString readonly dispid 515;
    property prDaySumAddTaxOfSale2Str: WideString readonly dispid 516;
    property prDaySumAddTaxOfSale3Str: WideString readonly dispid 517;
    property prDaySumAddTaxOfSale4Str: WideString readonly dispid 518;
    property prDaySumAddTaxOfSale5Str: WideString readonly dispid 519;
    property prDaySumAddTaxOfSale6Str: WideString readonly dispid 520;
    property prDaySumAddTaxOfRefund1: LongWord readonly dispid 401;
    property prDaySumAddTaxOfRefund2: LongWord readonly dispid 402;
    property prDaySumAddTaxOfRefund3: LongWord readonly dispid 403;
    property prDaySumAddTaxOfRefund4: LongWord readonly dispid 404;
    property prDaySumAddTaxOfRefund5: LongWord readonly dispid 405;
    property prDaySumAddTaxOfRefund6: LongWord readonly dispid 406;
    property prDaySumAddTaxOfRefund1Str: WideString readonly dispid 521;
    property prDaySumAddTaxOfRefund2Str: WideString readonly dispid 522;
    property prDaySumAddTaxOfRefund3Str: WideString readonly dispid 523;
    property prDaySumAddTaxOfRefund4Str: WideString readonly dispid 524;
    property prDaySumAddTaxOfRefund5Str: WideString readonly dispid 525;
    property prDaySumAddTaxOfRefund6Str: WideString readonly dispid 526;
    property prDayAnnuledSaleReceiptsCount: Word readonly dispid 407;
    property prDayAnnuledSaleReceiptsCountStr: WideString readonly dispid 527;
    property prDayAnnuledRefundReceiptsCount: Word readonly dispid 408;
    property prDayAnnuledRefundReceiptsCountStr: WideString readonly dispid 528;
    property prDayAnnuledSaleReceiptsSum: LongWord readonly dispid 409;
    property prDayAnnuledSaleReceiptsSumStr: WideString readonly dispid 529;
    property prDayAnnuledRefundReceiptsSum: LongWord readonly dispid 410;
    property prDayAnnuledRefundReceiptsSumStr: WideString readonly dispid 530;
    property prDaySaleCancelingsCount: Word readonly dispid 411;
    property prDaySaleCancelingsCountStr: WideString readonly dispid 531;
    property prDayRefundCancelingsCount: Word readonly dispid 412;
    property prDayRefundCancelingsCountStr: WideString readonly dispid 532;
    property prDaySaleCancelingsSum: LongWord readonly dispid 413;
    property prDaySaleCancelingsSumStr: WideString readonly dispid 533;
    property prDayRefundCancelingsSum: LongWord readonly dispid 414;
    property prDayRefundCancelingsSumStr: WideString readonly dispid 534;
    property prDayFirstFreePacket: LongWord readonly dispid 555;
    property prDayLastSentPacket: LongWord readonly dispid 556;
    property prDayLastSignedPacket: LongWord readonly dispid 557;
    property prDayFirstFreePacketStr: WideString readonly dispid 558;
    property prDayLastSentPacketStr: WideString readonly dispid 559;
    property prDayLastSignedPacketStr: WideString readonly dispid 560;
    property prCashDrawerSum: Int64 readonly dispid 429;
    property prCashDrawerSumStr: WideString readonly dispid 430;
    property prRepeatCount: Byte dispid 431;
    property prLogRecording: WordBool dispid 432;
    property prAnswerWaiting: Byte dispid 434;
    property prGetStatusByte: Byte readonly dispid 436;
    property prGetResultByte: Byte readonly dispid 437;
    property prGetReserveByte: Byte readonly dispid 438;
    property prGetErrorText: WideString readonly dispid 439;
    property prCurReceiptItemCount: Byte readonly dispid 451;
    property prUserPassword: Word readonly dispid 536;
    property prUserPasswordStr: WideString readonly dispid 537;
    property prProgPassword: Word dispid 566;
    property prProgPasswordStr: WideString dispid 567;
    property prGetGraphicFreeMemorySize: LongWord readonly dispid 569;
    property prGetGraphicFreeMemorySizeStr: WideString readonly dispid 570;
    property prBitmapObjectsCount: Byte readonly dispid 586;
    property prGetBitmapIndex[id: Byte]: Byte readonly dispid 587;
    property prUDPDeviceListSize: Byte readonly dispid 588;
    property prUDPDeviceSerialNumber[id: Byte]: WideString readonly dispid 589;
    property prUDPDeviceMAC[id: Byte]: WideString readonly dispid 590;
    property prUDPDeviceIP[id: Byte]: WideString readonly dispid 591;
    property prUDPDeviceTCPport[id: Byte]: Word readonly dispid 592;
    property prUDPDeviceTCPportStr[id: Byte]: WideString readonly dispid 594;
    property prRevizionID: Byte readonly dispid 541;
    property prFPDriverMajorVersion: Byte readonly dispid 542;
    property prFPDriverMinorVersion: Byte readonly dispid 543;
    property prFPDriverReleaseVersion: Byte readonly dispid 544;
    property prFPDriverBuildVersion: Byte readonly dispid 545;
  end;

// *********************************************************************//
// Interface: IICS_MZ_09
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2EE9B207-1A8A-46AD-9CE0-1D0469EE700A}
// *********************************************************************//
  IICS_MZ_09 = interface(IDispatch)
    ['{2EE9B207-1A8A-46AD-9CE0-1D0469EE700A}']
    function FPInitialize: Integer; safecall;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; safecall;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; safecall;
    function FPClose: WordBool; safecall;
    function FPClaimUSBDevice: WordBool; safecall;
    function FPReleaseUSBDevice: WordBool; safecall;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; safecall;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; safecall;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; safecall;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; safecall;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; safecall;
    function FPPrintZeroReceipt: WordBool; safecall;
    function FPLineFeed: WordBool; safecall;
    function FPAnnulReceipt: WordBool; safecall;
    function FPCashIn(CashSum: SYSUINT): WordBool; safecall;
    function FPCashOut(CashSum: SYSUINT): WordBool; safecall;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; safecall;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; safecall;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; safecall;
    function FPGetCurrentDate: WordBool; safecall;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; safecall;
    function FPGetCurrentTime: WordBool; safecall;
    function FPOpenCashDrawer(Duration: Word): WordBool; safecall;
    function FPPrintHardwareVersion: WordBool; safecall;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; safecall;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; safecall;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; safecall;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; safecall;
    function FPOnlineModeSwitch: WordBool; safecall;
    function FPCustomerDisplayModeSwitch: WordBool; safecall;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; safecall;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; safecall;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; safecall;
    function FPCloseServiceReport: WordBool; safecall;
    function FPEnableLogo(ProgPassword: Word): WordBool; safecall;
    function FPDisableLogo(ProgPassword: Word): WordBool; safecall;
    function FPSetTaxRates(ProgPassword: Word): WordBool; safecall;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; safecall;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; safecall;
    function FPMakeXReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeZReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; safecall;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; safecall;
    function FPCutterModeSwitch: WordBool; safecall;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; safecall;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; safecall;
    function FPGetPaymentFormNames: WordBool; safecall;
    function FPGetCurrentStatus: WordBool; safecall;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; safecall;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; safecall;
    function FPGetCashDrawerSum: WordBool; safecall;
    function FPGetDayReportProperties: WordBool; safecall;
    function FPGetTaxRates: WordBool; safecall;
    function FPGetItemData(ItemCode: Int64): WordBool; safecall;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; safecall;
    function FPGetDayReportData: WordBool; safecall;
    function FPGetCurrentReceiptData: WordBool; safecall;
    function FPGetDayCorrectionsData: WordBool; safecall;
    function FPGetDaySumOfAddTaxes: WordBool; safecall;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; safecall;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; safecall;
    function FPPrintModemStatus: WordBool; safecall;
    function FPGetUserPassword(UserID: Byte): WordBool; safecall;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; safecall;
    function FPSetContrast(Value: Byte): WordBool; safecall;
    function FPGetContrast: WordBool; safecall;
    function FPGetRevizionID: WordBool; safecall;
    function Get_glTapeAnalizer: WordBool; safecall;
    procedure Set_glTapeAnalizer(Value: WordBool); safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_glVirtualPortOpened: WordBool; safecall;
    function Get_glUseVirtualPort: WordBool; safecall;
    procedure Set_glUseVirtualPort(Value: WordBool); safecall;
    function Get_stUseAdditionalTax: WordBool; safecall;
    function Get_stUseAdditionalFee: WordBool; safecall;
    function Get_stUseFontB: WordBool; safecall;
    function Get_stUseTradeLogo: WordBool; safecall;
    function Get_stUseCutter: WordBool; safecall;
    function Get_stRefundReceiptMode: WordBool; safecall;
    function Get_stPaymentMode: WordBool; safecall;
    function Get_stFiscalMode: WordBool; safecall;
    function Get_stServiceReceiptMode: WordBool; safecall;
    function Get_stOnlinePrintMode: WordBool; safecall;
    function Get_stFailureLastCommand: WordBool; safecall;
    function Get_stFiscalDayIsOpened: WordBool; safecall;
    function Get_stReceiptIsOpened: WordBool; safecall;
    function Get_stCashDrawerIsOpened: WordBool; safecall;
    function Get_stDisplayShowSumMode: WordBool; safecall;
    function Get_prItemCost: Int64; safecall;
    function Get_prSumDiscount: Int64; safecall;
    function Get_prSumMarkup: Int64; safecall;
    function Get_prSumTotal: Int64; safecall;
    function Get_prSumBalance: Int64; safecall;
    function Get_prKSEFPacket: LongWord; safecall;
    function Get_prKSEFPacketStr: WideString; safecall;
    function Get_prModemError: Byte; safecall;
    function Get_prCurrentDate: TDateTime; safecall;
    function Get_prCurrentDateStr: WideString; safecall;
    function Get_prCurrentTime: TDateTime; safecall;
    function Get_prCurrentTimeStr: WideString; safecall;
    function Get_prTaxRatesCount: Byte; safecall;
    procedure Set_prTaxRatesCount(Value: Byte); safecall;
    function Get_prTaxRatesDate: TDateTime; safecall;
    function Get_prTaxRatesDateStr: WideString; safecall;
    function Get_prAddTaxType: WordBool; safecall;
    procedure Set_prAddTaxType(Value: WordBool); safecall;
    function Get_prTaxRate1: SYSINT; safecall;
    procedure Set_prTaxRate1(Value: SYSINT); safecall;
    function Get_prTaxRate2: SYSINT; safecall;
    procedure Set_prTaxRate2(Value: SYSINT); safecall;
    function Get_prTaxRate3: SYSINT; safecall;
    procedure Set_prTaxRate3(Value: SYSINT); safecall;
    function Get_prTaxRate4: SYSINT; safecall;
    procedure Set_prTaxRate4(Value: SYSINT); safecall;
    function Get_prTaxRate5: SYSINT; safecall;
    procedure Set_prTaxRate5(Value: SYSINT); safecall;
    function Get_prTaxRate6: SYSINT; safecall;
    function Get_prUsedAdditionalFee: WordBool; safecall;
    procedure Set_prUsedAdditionalFee(Value: WordBool); safecall;
    function Get_prAddFeeRate1: SYSINT; safecall;
    procedure Set_prAddFeeRate1(Value: SYSINT); safecall;
    function Get_prAddFeeRate2: SYSINT; safecall;
    procedure Set_prAddFeeRate2(Value: SYSINT); safecall;
    function Get_prAddFeeRate3: SYSINT; safecall;
    procedure Set_prAddFeeRate3(Value: SYSINT); safecall;
    function Get_prAddFeeRate4: SYSINT; safecall;
    procedure Set_prAddFeeRate4(Value: SYSINT); safecall;
    function Get_prAddFeeRate5: SYSINT; safecall;
    procedure Set_prAddFeeRate5(Value: SYSINT); safecall;
    function Get_prAddFeeRate6: SYSINT; safecall;
    procedure Set_prAddFeeRate6(Value: SYSINT); safecall;
    function Get_prTaxOnAddFee1: WordBool; safecall;
    procedure Set_prTaxOnAddFee1(Value: WordBool); safecall;
    function Get_prTaxOnAddFee2: WordBool; safecall;
    procedure Set_prTaxOnAddFee2(Value: WordBool); safecall;
    function Get_prTaxOnAddFee3: WordBool; safecall;
    procedure Set_prTaxOnAddFee3(Value: WordBool); safecall;
    function Get_prTaxOnAddFee4: WordBool; safecall;
    procedure Set_prTaxOnAddFee4(Value: WordBool); safecall;
    function Get_prTaxOnAddFee5: WordBool; safecall;
    procedure Set_prTaxOnAddFee5(Value: WordBool); safecall;
    function Get_prTaxOnAddFee6: WordBool; safecall;
    procedure Set_prTaxOnAddFee6(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice1: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice1(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice2: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice2(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice3: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice3(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice4: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice4(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice5: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice5(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice6: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice6(Value: WordBool); safecall;
    function Get_prNamePaymentForm1: WideString; safecall;
    function Get_prNamePaymentForm2: WideString; safecall;
    function Get_prNamePaymentForm3: WideString; safecall;
    function Get_prNamePaymentForm4: WideString; safecall;
    function Get_prNamePaymentForm5: WideString; safecall;
    function Get_prNamePaymentForm6: WideString; safecall;
    function Get_prNamePaymentForm7: WideString; safecall;
    function Get_prNamePaymentForm8: WideString; safecall;
    function Get_prNamePaymentForm9: WideString; safecall;
    function Get_prNamePaymentForm10: WideString; safecall;
    function Get_prSerialNumber: WideString; safecall;
    function Get_prFiscalNumber: WideString; safecall;
    function Get_prTaxNumber: WideString; safecall;
    function Get_prDateFiscalization: TDateTime; safecall;
    function Get_prDateFiscalizationStr: WideString; safecall;
    function Get_prTimeFiscalization: TDateTime; safecall;
    function Get_prTimeFiscalizationStr: WideString; safecall;
    function Get_prHeadLine1: WideString; safecall;
    function Get_prHeadLine2: WideString; safecall;
    function Get_prHeadLine3: WideString; safecall;
    function Get_prHardwareVersion: WideString; safecall;
    function Get_prItemName: WideString; safecall;
    function Get_prItemPrice: SYSINT; safecall;
    function Get_prItemSaleQuantity: SYSINT; safecall;
    function Get_prItemSaleQtyPrecision: Byte; safecall;
    function Get_prItemTax: Byte; safecall;
    function Get_prItemSaleSum: Int64; safecall;
    function Get_prItemSaleSumStr: WideString; safecall;
    function Get_prItemRefundQuantity: SYSINT; safecall;
    function Get_prItemRefundQtyPrecision: Byte; safecall;
    function Get_prItemRefundSum: Int64; safecall;
    function Get_prItemRefundSumStr: WideString; safecall;
    function Get_prItemCostStr: WideString; safecall;
    function Get_prSumDiscountStr: WideString; safecall;
    function Get_prSumMarkupStr: WideString; safecall;
    function Get_prSumTotalStr: WideString; safecall;
    function Get_prSumBalanceStr: WideString; safecall;
    function Get_prCurReceiptTax1Sum: LongWord; safecall;
    function Get_prCurReceiptTax2Sum: LongWord; safecall;
    function Get_prCurReceiptTax3Sum: LongWord; safecall;
    function Get_prCurReceiptTax4Sum: LongWord; safecall;
    function Get_prCurReceiptTax5Sum: LongWord; safecall;
    function Get_prCurReceiptTax6Sum: LongWord; safecall;
    function Get_prCurReceiptTax1SumStr: WideString; safecall;
    function Get_prCurReceiptTax2SumStr: WideString; safecall;
    function Get_prCurReceiptTax3SumStr: WideString; safecall;
    function Get_prCurReceiptTax4SumStr: WideString; safecall;
    function Get_prCurReceiptTax5SumStr: WideString; safecall;
    function Get_prCurReceiptTax6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm1Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm2Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm3Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm4Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm5Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm6Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm7Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm8Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm9Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm10Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm1SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm2SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm3SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm4SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm5SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm7SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm8SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm9SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm10SumStr: WideString; safecall;
    function Get_prPrinterError: WordBool; safecall;
    function Get_prTapeNearEnd: WordBool; safecall;
    function Get_prTapeEnded: WordBool; safecall;
    function Get_prDaySaleReceiptsCount: Word; safecall;
    function Get_prDaySaleReceiptsCountStr: WideString; safecall;
    function Get_prDayRefundReceiptsCount: Word; safecall;
    function Get_prDayRefundReceiptsCountStr: WideString; safecall;
    function Get_prDaySaleSumOnTax1: LongWord; safecall;
    function Get_prDaySaleSumOnTax2: LongWord; safecall;
    function Get_prDaySaleSumOnTax3: LongWord; safecall;
    function Get_prDaySaleSumOnTax4: LongWord; safecall;
    function Get_prDaySaleSumOnTax5: LongWord; safecall;
    function Get_prDaySaleSumOnTax6: LongWord; safecall;
    function Get_prDaySaleSumOnTax1Str: WideString; safecall;
    function Get_prDaySaleSumOnTax2Str: WideString; safecall;
    function Get_prDaySaleSumOnTax3Str: WideString; safecall;
    function Get_prDaySaleSumOnTax4Str: WideString; safecall;
    function Get_prDaySaleSumOnTax5Str: WideString; safecall;
    function Get_prDaySaleSumOnTax6Str: WideString; safecall;
    function Get_prDayRefundSumOnTax1: LongWord; safecall;
    function Get_prDayRefundSumOnTax2: LongWord; safecall;
    function Get_prDayRefundSumOnTax3: LongWord; safecall;
    function Get_prDayRefundSumOnTax4: LongWord; safecall;
    function Get_prDayRefundSumOnTax5: LongWord; safecall;
    function Get_prDayRefundSumOnTax6: LongWord; safecall;
    function Get_prDayRefundSumOnTax1Str: WideString; safecall;
    function Get_prDayRefundSumOnTax2Str: WideString; safecall;
    function Get_prDayRefundSumOnTax3Str: WideString; safecall;
    function Get_prDayRefundSumOnTax4Str: WideString; safecall;
    function Get_prDayRefundSumOnTax5Str: WideString; safecall;
    function Get_prDayRefundSumOnTax6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm1: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm2: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm3: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm4: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm5: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm6: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm7: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm8: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm9: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm10: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm1Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm2Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm3Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm4Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm5Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm7Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm8Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm9Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm10Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm1: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm2: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm3: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm4: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm5: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm6: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm7: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm8: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm9: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm10: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm1Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm2Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm3Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm4Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm5Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm6Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm7Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm8Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm9Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm10Str: WideString; safecall;
    function Get_prDayDiscountSumOnSales: LongWord; safecall;
    function Get_prDayDiscountSumOnSalesStr: WideString; safecall;
    function Get_prDayMarkupSumOnSales: LongWord; safecall;
    function Get_prDayMarkupSumOnSalesStr: WideString; safecall;
    function Get_prDayDiscountSumOnRefunds: LongWord; safecall;
    function Get_prDayDiscountSumOnRefundsStr: WideString; safecall;
    function Get_prDayMarkupSumOnRefunds: LongWord; safecall;
    function Get_prDayMarkupSumOnRefundsStr: WideString; safecall;
    function Get_prDayCashInSum: LongWord; safecall;
    function Get_prDayCashInSumStr: WideString; safecall;
    function Get_prDayCashOutSum: LongWord; safecall;
    function Get_prDayCashOutSumStr: WideString; safecall;
    function Get_prCurrentZReport: Word; safecall;
    function Get_prCurrentZReportStr: WideString; safecall;
    function Get_prDayEndDate: TDateTime; safecall;
    function Get_prDayEndDateStr: WideString; safecall;
    function Get_prDayEndTime: TDateTime; safecall;
    function Get_prDayEndTimeStr: WideString; safecall;
    function Get_prLastZReportDate: TDateTime; safecall;
    function Get_prLastZReportDateStr: WideString; safecall;
    function Get_prItemsCount: Word; safecall;
    function Get_prItemsCountStr: WideString; safecall;
    function Get_prDaySumAddTaxOfSale1: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale2: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale3: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale4: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale5: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale6: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale6Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund1: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund2: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund3: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund4: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund5: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund6: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund6Str: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsCount: Word; safecall;
    function Get_prDayAnnuledSaleReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsCount: Word; safecall;
    function Get_prDayAnnuledRefundReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledSaleReceiptsSumStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledRefundReceiptsSumStr: WideString; safecall;
    function Get_prDaySaleCancelingsCount: Word; safecall;
    function Get_prDaySaleCancelingsCountStr: WideString; safecall;
    function Get_prDayRefundCancelingsCount: Word; safecall;
    function Get_prDayRefundCancelingsCountStr: WideString; safecall;
    function Get_prDaySaleCancelingsSum: LongWord; safecall;
    function Get_prDaySaleCancelingsSumStr: WideString; safecall;
    function Get_prDayRefundCancelingsSum: LongWord; safecall;
    function Get_prDayRefundCancelingsSumStr: WideString; safecall;
    function Get_prCashDrawerSum: Int64; safecall;
    function Get_prCashDrawerSumStr: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prGetStatusByte: Byte; safecall;
    function Get_prGetResultByte: Byte; safecall;
    function Get_prGetReserveByte: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prCurReceiptItemCount: Byte; safecall;
    function Get_prUserPassword: Word; safecall;
    function Get_prUserPasswordStr: WideString; safecall;
    function Get_prPrintContrast: Byte; safecall;
    function Get_prFont9x17: WordBool; safecall;
    procedure Set_prFont9x17(Value: WordBool); safecall;
    function Get_prFontBold: WordBool; safecall;
    procedure Set_prFontBold(Value: WordBool); safecall;
    function Get_prFontSmall: WordBool; safecall;
    procedure Set_prFontSmall(Value: WordBool); safecall;
    function Get_prFontDoubleHeight: WordBool; safecall;
    procedure Set_prFontDoubleHeight(Value: WordBool); safecall;
    function Get_prFontDoubleWidth: WordBool; safecall;
    procedure Set_prFontDoubleWidth(Value: WordBool); safecall;
    function Get_prRevizionID: Byte; safecall;
    function Get_prFPDriverMajorVersion: Byte; safecall;
    function Get_prFPDriverMinorVersion: Byte; safecall;
    function Get_prFPDriverReleaseVersion: Byte; safecall;
    function Get_prFPDriverBuildVersion: Byte; safecall;
    property glTapeAnalizer: WordBool read Get_glTapeAnalizer write Set_glTapeAnalizer;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property glVirtualPortOpened: WordBool read Get_glVirtualPortOpened;
    property glUseVirtualPort: WordBool read Get_glUseVirtualPort write Set_glUseVirtualPort;
    property stUseAdditionalTax: WordBool read Get_stUseAdditionalTax;
    property stUseAdditionalFee: WordBool read Get_stUseAdditionalFee;
    property stUseFontB: WordBool read Get_stUseFontB;
    property stUseTradeLogo: WordBool read Get_stUseTradeLogo;
    property stUseCutter: WordBool read Get_stUseCutter;
    property stRefundReceiptMode: WordBool read Get_stRefundReceiptMode;
    property stPaymentMode: WordBool read Get_stPaymentMode;
    property stFiscalMode: WordBool read Get_stFiscalMode;
    property stServiceReceiptMode: WordBool read Get_stServiceReceiptMode;
    property stOnlinePrintMode: WordBool read Get_stOnlinePrintMode;
    property stFailureLastCommand: WordBool read Get_stFailureLastCommand;
    property stFiscalDayIsOpened: WordBool read Get_stFiscalDayIsOpened;
    property stReceiptIsOpened: WordBool read Get_stReceiptIsOpened;
    property stCashDrawerIsOpened: WordBool read Get_stCashDrawerIsOpened;
    property stDisplayShowSumMode: WordBool read Get_stDisplayShowSumMode;
    property prItemCost: Int64 read Get_prItemCost;
    property prSumDiscount: Int64 read Get_prSumDiscount;
    property prSumMarkup: Int64 read Get_prSumMarkup;
    property prSumTotal: Int64 read Get_prSumTotal;
    property prSumBalance: Int64 read Get_prSumBalance;
    property prKSEFPacket: LongWord read Get_prKSEFPacket;
    property prKSEFPacketStr: WideString read Get_prKSEFPacketStr;
    property prModemError: Byte read Get_prModemError;
    property prCurrentDate: TDateTime read Get_prCurrentDate;
    property prCurrentDateStr: WideString read Get_prCurrentDateStr;
    property prCurrentTime: TDateTime read Get_prCurrentTime;
    property prCurrentTimeStr: WideString read Get_prCurrentTimeStr;
    property prTaxRatesCount: Byte read Get_prTaxRatesCount write Set_prTaxRatesCount;
    property prTaxRatesDate: TDateTime read Get_prTaxRatesDate;
    property prTaxRatesDateStr: WideString read Get_prTaxRatesDateStr;
    property prAddTaxType: WordBool read Get_prAddTaxType write Set_prAddTaxType;
    property prTaxRate1: SYSINT read Get_prTaxRate1 write Set_prTaxRate1;
    property prTaxRate2: SYSINT read Get_prTaxRate2 write Set_prTaxRate2;
    property prTaxRate3: SYSINT read Get_prTaxRate3 write Set_prTaxRate3;
    property prTaxRate4: SYSINT read Get_prTaxRate4 write Set_prTaxRate4;
    property prTaxRate5: SYSINT read Get_prTaxRate5 write Set_prTaxRate5;
    property prTaxRate6: SYSINT read Get_prTaxRate6;
    property prUsedAdditionalFee: WordBool read Get_prUsedAdditionalFee write Set_prUsedAdditionalFee;
    property prAddFeeRate1: SYSINT read Get_prAddFeeRate1 write Set_prAddFeeRate1;
    property prAddFeeRate2: SYSINT read Get_prAddFeeRate2 write Set_prAddFeeRate2;
    property prAddFeeRate3: SYSINT read Get_prAddFeeRate3 write Set_prAddFeeRate3;
    property prAddFeeRate4: SYSINT read Get_prAddFeeRate4 write Set_prAddFeeRate4;
    property prAddFeeRate5: SYSINT read Get_prAddFeeRate5 write Set_prAddFeeRate5;
    property prAddFeeRate6: SYSINT read Get_prAddFeeRate6 write Set_prAddFeeRate6;
    property prTaxOnAddFee1: WordBool read Get_prTaxOnAddFee1 write Set_prTaxOnAddFee1;
    property prTaxOnAddFee2: WordBool read Get_prTaxOnAddFee2 write Set_prTaxOnAddFee2;
    property prTaxOnAddFee3: WordBool read Get_prTaxOnAddFee3 write Set_prTaxOnAddFee3;
    property prTaxOnAddFee4: WordBool read Get_prTaxOnAddFee4 write Set_prTaxOnAddFee4;
    property prTaxOnAddFee5: WordBool read Get_prTaxOnAddFee5 write Set_prTaxOnAddFee5;
    property prTaxOnAddFee6: WordBool read Get_prTaxOnAddFee6 write Set_prTaxOnAddFee6;
    property prAddFeeOnRetailPrice1: WordBool read Get_prAddFeeOnRetailPrice1 write Set_prAddFeeOnRetailPrice1;
    property prAddFeeOnRetailPrice2: WordBool read Get_prAddFeeOnRetailPrice2 write Set_prAddFeeOnRetailPrice2;
    property prAddFeeOnRetailPrice3: WordBool read Get_prAddFeeOnRetailPrice3 write Set_prAddFeeOnRetailPrice3;
    property prAddFeeOnRetailPrice4: WordBool read Get_prAddFeeOnRetailPrice4 write Set_prAddFeeOnRetailPrice4;
    property prAddFeeOnRetailPrice5: WordBool read Get_prAddFeeOnRetailPrice5 write Set_prAddFeeOnRetailPrice5;
    property prAddFeeOnRetailPrice6: WordBool read Get_prAddFeeOnRetailPrice6 write Set_prAddFeeOnRetailPrice6;
    property prNamePaymentForm1: WideString read Get_prNamePaymentForm1;
    property prNamePaymentForm2: WideString read Get_prNamePaymentForm2;
    property prNamePaymentForm3: WideString read Get_prNamePaymentForm3;
    property prNamePaymentForm4: WideString read Get_prNamePaymentForm4;
    property prNamePaymentForm5: WideString read Get_prNamePaymentForm5;
    property prNamePaymentForm6: WideString read Get_prNamePaymentForm6;
    property prNamePaymentForm7: WideString read Get_prNamePaymentForm7;
    property prNamePaymentForm8: WideString read Get_prNamePaymentForm8;
    property prNamePaymentForm9: WideString read Get_prNamePaymentForm9;
    property prNamePaymentForm10: WideString read Get_prNamePaymentForm10;
    property prSerialNumber: WideString read Get_prSerialNumber;
    property prFiscalNumber: WideString read Get_prFiscalNumber;
    property prTaxNumber: WideString read Get_prTaxNumber;
    property prDateFiscalization: TDateTime read Get_prDateFiscalization;
    property prDateFiscalizationStr: WideString read Get_prDateFiscalizationStr;
    property prTimeFiscalization: TDateTime read Get_prTimeFiscalization;
    property prTimeFiscalizationStr: WideString read Get_prTimeFiscalizationStr;
    property prHeadLine1: WideString read Get_prHeadLine1;
    property prHeadLine2: WideString read Get_prHeadLine2;
    property prHeadLine3: WideString read Get_prHeadLine3;
    property prHardwareVersion: WideString read Get_prHardwareVersion;
    property prItemName: WideString read Get_prItemName;
    property prItemPrice: SYSINT read Get_prItemPrice;
    property prItemSaleQuantity: SYSINT read Get_prItemSaleQuantity;
    property prItemSaleQtyPrecision: Byte read Get_prItemSaleQtyPrecision;
    property prItemTax: Byte read Get_prItemTax;
    property prItemSaleSum: Int64 read Get_prItemSaleSum;
    property prItemSaleSumStr: WideString read Get_prItemSaleSumStr;
    property prItemRefundQuantity: SYSINT read Get_prItemRefundQuantity;
    property prItemRefundQtyPrecision: Byte read Get_prItemRefundQtyPrecision;
    property prItemRefundSum: Int64 read Get_prItemRefundSum;
    property prItemRefundSumStr: WideString read Get_prItemRefundSumStr;
    property prItemCostStr: WideString read Get_prItemCostStr;
    property prSumDiscountStr: WideString read Get_prSumDiscountStr;
    property prSumMarkupStr: WideString read Get_prSumMarkupStr;
    property prSumTotalStr: WideString read Get_prSumTotalStr;
    property prSumBalanceStr: WideString read Get_prSumBalanceStr;
    property prCurReceiptTax1Sum: LongWord read Get_prCurReceiptTax1Sum;
    property prCurReceiptTax2Sum: LongWord read Get_prCurReceiptTax2Sum;
    property prCurReceiptTax3Sum: LongWord read Get_prCurReceiptTax3Sum;
    property prCurReceiptTax4Sum: LongWord read Get_prCurReceiptTax4Sum;
    property prCurReceiptTax5Sum: LongWord read Get_prCurReceiptTax5Sum;
    property prCurReceiptTax6Sum: LongWord read Get_prCurReceiptTax6Sum;
    property prCurReceiptTax1SumStr: WideString read Get_prCurReceiptTax1SumStr;
    property prCurReceiptTax2SumStr: WideString read Get_prCurReceiptTax2SumStr;
    property prCurReceiptTax3SumStr: WideString read Get_prCurReceiptTax3SumStr;
    property prCurReceiptTax4SumStr: WideString read Get_prCurReceiptTax4SumStr;
    property prCurReceiptTax5SumStr: WideString read Get_prCurReceiptTax5SumStr;
    property prCurReceiptTax6SumStr: WideString read Get_prCurReceiptTax6SumStr;
    property prCurReceiptPayForm1Sum: LongWord read Get_prCurReceiptPayForm1Sum;
    property prCurReceiptPayForm2Sum: LongWord read Get_prCurReceiptPayForm2Sum;
    property prCurReceiptPayForm3Sum: LongWord read Get_prCurReceiptPayForm3Sum;
    property prCurReceiptPayForm4Sum: LongWord read Get_prCurReceiptPayForm4Sum;
    property prCurReceiptPayForm5Sum: LongWord read Get_prCurReceiptPayForm5Sum;
    property prCurReceiptPayForm6Sum: LongWord read Get_prCurReceiptPayForm6Sum;
    property prCurReceiptPayForm7Sum: LongWord read Get_prCurReceiptPayForm7Sum;
    property prCurReceiptPayForm8Sum: LongWord read Get_prCurReceiptPayForm8Sum;
    property prCurReceiptPayForm9Sum: LongWord read Get_prCurReceiptPayForm9Sum;
    property prCurReceiptPayForm10Sum: LongWord read Get_prCurReceiptPayForm10Sum;
    property prCurReceiptPayForm1SumStr: WideString read Get_prCurReceiptPayForm1SumStr;
    property prCurReceiptPayForm2SumStr: WideString read Get_prCurReceiptPayForm2SumStr;
    property prCurReceiptPayForm3SumStr: WideString read Get_prCurReceiptPayForm3SumStr;
    property prCurReceiptPayForm4SumStr: WideString read Get_prCurReceiptPayForm4SumStr;
    property prCurReceiptPayForm5SumStr: WideString read Get_prCurReceiptPayForm5SumStr;
    property prCurReceiptPayForm6SumStr: WideString read Get_prCurReceiptPayForm6SumStr;
    property prCurReceiptPayForm7SumStr: WideString read Get_prCurReceiptPayForm7SumStr;
    property prCurReceiptPayForm8SumStr: WideString read Get_prCurReceiptPayForm8SumStr;
    property prCurReceiptPayForm9SumStr: WideString read Get_prCurReceiptPayForm9SumStr;
    property prCurReceiptPayForm10SumStr: WideString read Get_prCurReceiptPayForm10SumStr;
    property prPrinterError: WordBool read Get_prPrinterError;
    property prTapeNearEnd: WordBool read Get_prTapeNearEnd;
    property prTapeEnded: WordBool read Get_prTapeEnded;
    property prDaySaleReceiptsCount: Word read Get_prDaySaleReceiptsCount;
    property prDaySaleReceiptsCountStr: WideString read Get_prDaySaleReceiptsCountStr;
    property prDayRefundReceiptsCount: Word read Get_prDayRefundReceiptsCount;
    property prDayRefundReceiptsCountStr: WideString read Get_prDayRefundReceiptsCountStr;
    property prDaySaleSumOnTax1: LongWord read Get_prDaySaleSumOnTax1;
    property prDaySaleSumOnTax2: LongWord read Get_prDaySaleSumOnTax2;
    property prDaySaleSumOnTax3: LongWord read Get_prDaySaleSumOnTax3;
    property prDaySaleSumOnTax4: LongWord read Get_prDaySaleSumOnTax4;
    property prDaySaleSumOnTax5: LongWord read Get_prDaySaleSumOnTax5;
    property prDaySaleSumOnTax6: LongWord read Get_prDaySaleSumOnTax6;
    property prDaySaleSumOnTax1Str: WideString read Get_prDaySaleSumOnTax1Str;
    property prDaySaleSumOnTax2Str: WideString read Get_prDaySaleSumOnTax2Str;
    property prDaySaleSumOnTax3Str: WideString read Get_prDaySaleSumOnTax3Str;
    property prDaySaleSumOnTax4Str: WideString read Get_prDaySaleSumOnTax4Str;
    property prDaySaleSumOnTax5Str: WideString read Get_prDaySaleSumOnTax5Str;
    property prDaySaleSumOnTax6Str: WideString read Get_prDaySaleSumOnTax6Str;
    property prDayRefundSumOnTax1: LongWord read Get_prDayRefundSumOnTax1;
    property prDayRefundSumOnTax2: LongWord read Get_prDayRefundSumOnTax2;
    property prDayRefundSumOnTax3: LongWord read Get_prDayRefundSumOnTax3;
    property prDayRefundSumOnTax4: LongWord read Get_prDayRefundSumOnTax4;
    property prDayRefundSumOnTax5: LongWord read Get_prDayRefundSumOnTax5;
    property prDayRefundSumOnTax6: LongWord read Get_prDayRefundSumOnTax6;
    property prDayRefundSumOnTax1Str: WideString read Get_prDayRefundSumOnTax1Str;
    property prDayRefundSumOnTax2Str: WideString read Get_prDayRefundSumOnTax2Str;
    property prDayRefundSumOnTax3Str: WideString read Get_prDayRefundSumOnTax3Str;
    property prDayRefundSumOnTax4Str: WideString read Get_prDayRefundSumOnTax4Str;
    property prDayRefundSumOnTax5Str: WideString read Get_prDayRefundSumOnTax5Str;
    property prDayRefundSumOnTax6Str: WideString read Get_prDayRefundSumOnTax6Str;
    property prDaySaleSumOnPayForm1: LongWord read Get_prDaySaleSumOnPayForm1;
    property prDaySaleSumOnPayForm2: LongWord read Get_prDaySaleSumOnPayForm2;
    property prDaySaleSumOnPayForm3: LongWord read Get_prDaySaleSumOnPayForm3;
    property prDaySaleSumOnPayForm4: LongWord read Get_prDaySaleSumOnPayForm4;
    property prDaySaleSumOnPayForm5: LongWord read Get_prDaySaleSumOnPayForm5;
    property prDaySaleSumOnPayForm6: LongWord read Get_prDaySaleSumOnPayForm6;
    property prDaySaleSumOnPayForm7: LongWord read Get_prDaySaleSumOnPayForm7;
    property prDaySaleSumOnPayForm8: LongWord read Get_prDaySaleSumOnPayForm8;
    property prDaySaleSumOnPayForm9: LongWord read Get_prDaySaleSumOnPayForm9;
    property prDaySaleSumOnPayForm10: LongWord read Get_prDaySaleSumOnPayForm10;
    property prDaySaleSumOnPayForm1Str: WideString read Get_prDaySaleSumOnPayForm1Str;
    property prDaySaleSumOnPayForm2Str: WideString read Get_prDaySaleSumOnPayForm2Str;
    property prDaySaleSumOnPayForm3Str: WideString read Get_prDaySaleSumOnPayForm3Str;
    property prDaySaleSumOnPayForm4Str: WideString read Get_prDaySaleSumOnPayForm4Str;
    property prDaySaleSumOnPayForm5Str: WideString read Get_prDaySaleSumOnPayForm5Str;
    property prDaySaleSumOnPayForm6Str: WideString read Get_prDaySaleSumOnPayForm6Str;
    property prDaySaleSumOnPayForm7Str: WideString read Get_prDaySaleSumOnPayForm7Str;
    property prDaySaleSumOnPayForm8Str: WideString read Get_prDaySaleSumOnPayForm8Str;
    property prDaySaleSumOnPayForm9Str: WideString read Get_prDaySaleSumOnPayForm9Str;
    property prDaySaleSumOnPayForm10Str: WideString read Get_prDaySaleSumOnPayForm10Str;
    property prDayRefundSumOnPayForm1: LongWord read Get_prDayRefundSumOnPayForm1;
    property prDayRefundSumOnPayForm2: LongWord read Get_prDayRefundSumOnPayForm2;
    property prDayRefundSumOnPayForm3: LongWord read Get_prDayRefundSumOnPayForm3;
    property prDayRefundSumOnPayForm4: LongWord read Get_prDayRefundSumOnPayForm4;
    property prDayRefundSumOnPayForm5: LongWord read Get_prDayRefundSumOnPayForm5;
    property prDayRefundSumOnPayForm6: LongWord read Get_prDayRefundSumOnPayForm6;
    property prDayRefundSumOnPayForm7: LongWord read Get_prDayRefundSumOnPayForm7;
    property prDayRefundSumOnPayForm8: LongWord read Get_prDayRefundSumOnPayForm8;
    property prDayRefundSumOnPayForm9: LongWord read Get_prDayRefundSumOnPayForm9;
    property prDayRefundSumOnPayForm10: LongWord read Get_prDayRefundSumOnPayForm10;
    property prDayRefundSumOnPayForm1Str: WideString read Get_prDayRefundSumOnPayForm1Str;
    property prDayRefundSumOnPayForm2Str: WideString read Get_prDayRefundSumOnPayForm2Str;
    property prDayRefundSumOnPayForm3Str: WideString read Get_prDayRefundSumOnPayForm3Str;
    property prDayRefundSumOnPayForm4Str: WideString read Get_prDayRefundSumOnPayForm4Str;
    property prDayRefundSumOnPayForm5Str: WideString read Get_prDayRefundSumOnPayForm5Str;
    property prDayRefundSumOnPayForm6Str: WideString read Get_prDayRefundSumOnPayForm6Str;
    property prDayRefundSumOnPayForm7Str: WideString read Get_prDayRefundSumOnPayForm7Str;
    property prDayRefundSumOnPayForm8Str: WideString read Get_prDayRefundSumOnPayForm8Str;
    property prDayRefundSumOnPayForm9Str: WideString read Get_prDayRefundSumOnPayForm9Str;
    property prDayRefundSumOnPayForm10Str: WideString read Get_prDayRefundSumOnPayForm10Str;
    property prDayDiscountSumOnSales: LongWord read Get_prDayDiscountSumOnSales;
    property prDayDiscountSumOnSalesStr: WideString read Get_prDayDiscountSumOnSalesStr;
    property prDayMarkupSumOnSales: LongWord read Get_prDayMarkupSumOnSales;
    property prDayMarkupSumOnSalesStr: WideString read Get_prDayMarkupSumOnSalesStr;
    property prDayDiscountSumOnRefunds: LongWord read Get_prDayDiscountSumOnRefunds;
    property prDayDiscountSumOnRefundsStr: WideString read Get_prDayDiscountSumOnRefundsStr;
    property prDayMarkupSumOnRefunds: LongWord read Get_prDayMarkupSumOnRefunds;
    property prDayMarkupSumOnRefundsStr: WideString read Get_prDayMarkupSumOnRefundsStr;
    property prDayCashInSum: LongWord read Get_prDayCashInSum;
    property prDayCashInSumStr: WideString read Get_prDayCashInSumStr;
    property prDayCashOutSum: LongWord read Get_prDayCashOutSum;
    property prDayCashOutSumStr: WideString read Get_prDayCashOutSumStr;
    property prCurrentZReport: Word read Get_prCurrentZReport;
    property prCurrentZReportStr: WideString read Get_prCurrentZReportStr;
    property prDayEndDate: TDateTime read Get_prDayEndDate;
    property prDayEndDateStr: WideString read Get_prDayEndDateStr;
    property prDayEndTime: TDateTime read Get_prDayEndTime;
    property prDayEndTimeStr: WideString read Get_prDayEndTimeStr;
    property prLastZReportDate: TDateTime read Get_prLastZReportDate;
    property prLastZReportDateStr: WideString read Get_prLastZReportDateStr;
    property prItemsCount: Word read Get_prItemsCount;
    property prItemsCountStr: WideString read Get_prItemsCountStr;
    property prDaySumAddTaxOfSale1: LongWord read Get_prDaySumAddTaxOfSale1;
    property prDaySumAddTaxOfSale2: LongWord read Get_prDaySumAddTaxOfSale2;
    property prDaySumAddTaxOfSale3: LongWord read Get_prDaySumAddTaxOfSale3;
    property prDaySumAddTaxOfSale4: LongWord read Get_prDaySumAddTaxOfSale4;
    property prDaySumAddTaxOfSale5: LongWord read Get_prDaySumAddTaxOfSale5;
    property prDaySumAddTaxOfSale6: LongWord read Get_prDaySumAddTaxOfSale6;
    property prDaySumAddTaxOfSale1Str: WideString read Get_prDaySumAddTaxOfSale1Str;
    property prDaySumAddTaxOfSale2Str: WideString read Get_prDaySumAddTaxOfSale2Str;
    property prDaySumAddTaxOfSale3Str: WideString read Get_prDaySumAddTaxOfSale3Str;
    property prDaySumAddTaxOfSale4Str: WideString read Get_prDaySumAddTaxOfSale4Str;
    property prDaySumAddTaxOfSale5Str: WideString read Get_prDaySumAddTaxOfSale5Str;
    property prDaySumAddTaxOfSale6Str: WideString read Get_prDaySumAddTaxOfSale6Str;
    property prDaySumAddTaxOfRefund1: LongWord read Get_prDaySumAddTaxOfRefund1;
    property prDaySumAddTaxOfRefund2: LongWord read Get_prDaySumAddTaxOfRefund2;
    property prDaySumAddTaxOfRefund3: LongWord read Get_prDaySumAddTaxOfRefund3;
    property prDaySumAddTaxOfRefund4: LongWord read Get_prDaySumAddTaxOfRefund4;
    property prDaySumAddTaxOfRefund5: LongWord read Get_prDaySumAddTaxOfRefund5;
    property prDaySumAddTaxOfRefund6: LongWord read Get_prDaySumAddTaxOfRefund6;
    property prDaySumAddTaxOfRefund1Str: WideString read Get_prDaySumAddTaxOfRefund1Str;
    property prDaySumAddTaxOfRefund2Str: WideString read Get_prDaySumAddTaxOfRefund2Str;
    property prDaySumAddTaxOfRefund3Str: WideString read Get_prDaySumAddTaxOfRefund3Str;
    property prDaySumAddTaxOfRefund4Str: WideString read Get_prDaySumAddTaxOfRefund4Str;
    property prDaySumAddTaxOfRefund5Str: WideString read Get_prDaySumAddTaxOfRefund5Str;
    property prDaySumAddTaxOfRefund6Str: WideString read Get_prDaySumAddTaxOfRefund6Str;
    property prDayAnnuledSaleReceiptsCount: Word read Get_prDayAnnuledSaleReceiptsCount;
    property prDayAnnuledSaleReceiptsCountStr: WideString read Get_prDayAnnuledSaleReceiptsCountStr;
    property prDayAnnuledRefundReceiptsCount: Word read Get_prDayAnnuledRefundReceiptsCount;
    property prDayAnnuledRefundReceiptsCountStr: WideString read Get_prDayAnnuledRefundReceiptsCountStr;
    property prDayAnnuledSaleReceiptsSum: LongWord read Get_prDayAnnuledSaleReceiptsSum;
    property prDayAnnuledSaleReceiptsSumStr: WideString read Get_prDayAnnuledSaleReceiptsSumStr;
    property prDayAnnuledRefundReceiptsSum: LongWord read Get_prDayAnnuledRefundReceiptsSum;
    property prDayAnnuledRefundReceiptsSumStr: WideString read Get_prDayAnnuledRefundReceiptsSumStr;
    property prDaySaleCancelingsCount: Word read Get_prDaySaleCancelingsCount;
    property prDaySaleCancelingsCountStr: WideString read Get_prDaySaleCancelingsCountStr;
    property prDayRefundCancelingsCount: Word read Get_prDayRefundCancelingsCount;
    property prDayRefundCancelingsCountStr: WideString read Get_prDayRefundCancelingsCountStr;
    property prDaySaleCancelingsSum: LongWord read Get_prDaySaleCancelingsSum;
    property prDaySaleCancelingsSumStr: WideString read Get_prDaySaleCancelingsSumStr;
    property prDayRefundCancelingsSum: LongWord read Get_prDayRefundCancelingsSum;
    property prDayRefundCancelingsSumStr: WideString read Get_prDayRefundCancelingsSumStr;
    property prCashDrawerSum: Int64 read Get_prCashDrawerSum;
    property prCashDrawerSumStr: WideString read Get_prCashDrawerSumStr;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prGetStatusByte: Byte read Get_prGetStatusByte;
    property prGetResultByte: Byte read Get_prGetResultByte;
    property prGetReserveByte: Byte read Get_prGetReserveByte;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prCurReceiptItemCount: Byte read Get_prCurReceiptItemCount;
    property prUserPassword: Word read Get_prUserPassword;
    property prUserPasswordStr: WideString read Get_prUserPasswordStr;
    property prPrintContrast: Byte read Get_prPrintContrast;
    property prFont9x17: WordBool read Get_prFont9x17 write Set_prFont9x17;
    property prFontBold: WordBool read Get_prFontBold write Set_prFontBold;
    property prFontSmall: WordBool read Get_prFontSmall write Set_prFontSmall;
    property prFontDoubleHeight: WordBool read Get_prFontDoubleHeight write Set_prFontDoubleHeight;
    property prFontDoubleWidth: WordBool read Get_prFontDoubleWidth write Set_prFontDoubleWidth;
    property prRevizionID: Byte read Get_prRevizionID;
    property prFPDriverMajorVersion: Byte read Get_prFPDriverMajorVersion;
    property prFPDriverMinorVersion: Byte read Get_prFPDriverMinorVersion;
    property prFPDriverReleaseVersion: Byte read Get_prFPDriverReleaseVersion;
    property prFPDriverBuildVersion: Byte read Get_prFPDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_MZ_09Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2EE9B207-1A8A-46AD-9CE0-1D0469EE700A}
// *********************************************************************//
  IICS_MZ_09Disp = dispinterface
    ['{2EE9B207-1A8A-46AD-9CE0-1D0469EE700A}']
    function FPInitialize: Integer; dispid 433;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; dispid 201;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; dispid 202;
    function FPClose: WordBool; dispid 203;
    function FPClaimUSBDevice: WordBool; dispid 564;
    function FPReleaseUSBDevice: WordBool; dispid 565;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; dispid 204;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; dispid 205;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 206;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; dispid 207;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 208;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; dispid 209;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; dispid 210;
    function FPPrintZeroReceipt: WordBool; dispid 211;
    function FPLineFeed: WordBool; dispid 212;
    function FPAnnulReceipt: WordBool; dispid 213;
    function FPCashIn(CashSum: SYSUINT): WordBool; dispid 214;
    function FPCashOut(CashSum: SYSUINT): WordBool; dispid 215;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; dispid 216;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; dispid 217;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; dispid 218;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; dispid 219;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; dispid 220;
    function FPGetCurrentDate: WordBool; dispid 221;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; dispid 222;
    function FPGetCurrentTime: WordBool; dispid 223;
    function FPOpenCashDrawer(Duration: Word): WordBool; dispid 224;
    function FPPrintHardwareVersion: WordBool; dispid 225;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; dispid 226;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; dispid 227;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; dispid 228;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; dispid 229;
    function FPOnlineModeSwitch: WordBool; dispid 230;
    function FPCustomerDisplayModeSwitch: WordBool; dispid 231;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; dispid 232;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; dispid 233;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; dispid 234;
    function FPCloseServiceReport: WordBool; dispid 235;
    function FPEnableLogo(ProgPassword: Word): WordBool; dispid 236;
    function FPDisableLogo(ProgPassword: Word): WordBool; dispid 237;
    function FPSetTaxRates(ProgPassword: Word): WordBool; dispid 238;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; dispid 239;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; dispid 240;
    function FPMakeXReport(ReportPassword: Word): WordBool; dispid 241;
    function FPMakeZReport(ReportPassword: Word): WordBool; dispid 242;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; dispid 243;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; dispid 244;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; dispid 245;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; dispid 246;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; dispid 247;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; dispid 248;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; dispid 249;
    function FPCutterModeSwitch: WordBool; dispid 250;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; dispid 251;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; dispid 539;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; dispid 252;
    function FPGetPaymentFormNames: WordBool; dispid 435;
    function FPGetCurrentStatus: WordBool; dispid 440;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; dispid 442;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; dispid 443;
    function FPGetCashDrawerSum: WordBool; dispid 444;
    function FPGetDayReportProperties: WordBool; dispid 445;
    function FPGetTaxRates: WordBool; dispid 446;
    function FPGetItemData(ItemCode: Int64): WordBool; dispid 447;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; dispid 448;
    function FPGetDayReportData: WordBool; dispid 449;
    function FPGetCurrentReceiptData: WordBool; dispid 450;
    function FPGetDayCorrectionsData: WordBool; dispid 452;
    function FPGetDaySumOfAddTaxes: WordBool; dispid 453;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; dispid 454;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; dispid 455;
    function FPPrintModemStatus: WordBool; dispid 456;
    function FPGetUserPassword(UserID: Byte): WordBool; dispid 535;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; dispid 548;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; dispid 549;
    function FPSetContrast(Value: Byte): WordBool; dispid 540;
    function FPGetContrast: WordBool; dispid 541;
    function FPGetRevizionID: WordBool; dispid 550;
    property glTapeAnalizer: WordBool dispid 253;
    property glPropertiesAutoUpdateMode: WordBool dispid 254;
    property glCodepageOEM: WordBool dispid 255;
    property glLangID: Byte dispid 256;
    property glVirtualPortOpened: WordBool readonly dispid 562;
    property glUseVirtualPort: WordBool dispid 563;
    property stUseAdditionalTax: WordBool readonly dispid 415;
    property stUseAdditionalFee: WordBool readonly dispid 416;
    property stUseFontB: WordBool readonly dispid 417;
    property stUseTradeLogo: WordBool readonly dispid 418;
    property stUseCutter: WordBool readonly dispid 419;
    property stRefundReceiptMode: WordBool readonly dispid 420;
    property stPaymentMode: WordBool readonly dispid 421;
    property stFiscalMode: WordBool readonly dispid 422;
    property stServiceReceiptMode: WordBool readonly dispid 423;
    property stOnlinePrintMode: WordBool readonly dispid 424;
    property stFailureLastCommand: WordBool readonly dispid 425;
    property stFiscalDayIsOpened: WordBool readonly dispid 426;
    property stReceiptIsOpened: WordBool readonly dispid 427;
    property stCashDrawerIsOpened: WordBool readonly dispid 428;
    property stDisplayShowSumMode: WordBool readonly dispid 441;
    property prItemCost: Int64 readonly dispid 257;
    property prSumDiscount: Int64 readonly dispid 258;
    property prSumMarkup: Int64 readonly dispid 259;
    property prSumTotal: Int64 readonly dispid 260;
    property prSumBalance: Int64 readonly dispid 261;
    property prKSEFPacket: LongWord readonly dispid 262;
    property prKSEFPacketStr: WideString readonly dispid 538;
    property prModemError: Byte readonly dispid 263;
    property prCurrentDate: TDateTime readonly dispid 264;
    property prCurrentDateStr: WideString readonly dispid 265;
    property prCurrentTime: TDateTime readonly dispid 266;
    property prCurrentTimeStr: WideString readonly dispid 267;
    property prTaxRatesCount: Byte dispid 268;
    property prTaxRatesDate: TDateTime readonly dispid 269;
    property prTaxRatesDateStr: WideString readonly dispid 270;
    property prAddTaxType: WordBool dispid 271;
    property prTaxRate1: SYSINT dispid 272;
    property prTaxRate2: SYSINT dispid 273;
    property prTaxRate3: SYSINT dispid 274;
    property prTaxRate4: SYSINT dispid 275;
    property prTaxRate5: SYSINT dispid 276;
    property prTaxRate6: SYSINT readonly dispid 277;
    property prUsedAdditionalFee: WordBool dispid 278;
    property prAddFeeRate1: SYSINT dispid 279;
    property prAddFeeRate2: SYSINT dispid 280;
    property prAddFeeRate3: SYSINT dispid 281;
    property prAddFeeRate4: SYSINT dispid 282;
    property prAddFeeRate5: SYSINT dispid 283;
    property prAddFeeRate6: SYSINT dispid 284;
    property prTaxOnAddFee1: WordBool dispid 285;
    property prTaxOnAddFee2: WordBool dispid 286;
    property prTaxOnAddFee3: WordBool dispid 287;
    property prTaxOnAddFee4: WordBool dispid 288;
    property prTaxOnAddFee5: WordBool dispid 289;
    property prTaxOnAddFee6: WordBool dispid 290;
    property prAddFeeOnRetailPrice1: WordBool dispid 556;
    property prAddFeeOnRetailPrice2: WordBool dispid 557;
    property prAddFeeOnRetailPrice3: WordBool dispid 558;
    property prAddFeeOnRetailPrice4: WordBool dispid 559;
    property prAddFeeOnRetailPrice5: WordBool dispid 560;
    property prAddFeeOnRetailPrice6: WordBool dispid 561;
    property prNamePaymentForm1: WideString readonly dispid 291;
    property prNamePaymentForm2: WideString readonly dispid 292;
    property prNamePaymentForm3: WideString readonly dispid 293;
    property prNamePaymentForm4: WideString readonly dispid 294;
    property prNamePaymentForm5: WideString readonly dispid 295;
    property prNamePaymentForm6: WideString readonly dispid 296;
    property prNamePaymentForm7: WideString readonly dispid 297;
    property prNamePaymentForm8: WideString readonly dispid 298;
    property prNamePaymentForm9: WideString readonly dispid 299;
    property prNamePaymentForm10: WideString readonly dispid 300;
    property prSerialNumber: WideString readonly dispid 301;
    property prFiscalNumber: WideString readonly dispid 302;
    property prTaxNumber: WideString readonly dispid 303;
    property prDateFiscalization: TDateTime readonly dispid 304;
    property prDateFiscalizationStr: WideString readonly dispid 305;
    property prTimeFiscalization: TDateTime readonly dispid 306;
    property prTimeFiscalizationStr: WideString readonly dispid 307;
    property prHeadLine1: WideString readonly dispid 308;
    property prHeadLine2: WideString readonly dispid 309;
    property prHeadLine3: WideString readonly dispid 310;
    property prHardwareVersion: WideString readonly dispid 311;
    property prItemName: WideString readonly dispid 312;
    property prItemPrice: SYSINT readonly dispid 313;
    property prItemSaleQuantity: SYSINT readonly dispid 314;
    property prItemSaleQtyPrecision: Byte readonly dispid 315;
    property prItemTax: Byte readonly dispid 316;
    property prItemSaleSum: Int64 readonly dispid 317;
    property prItemSaleSumStr: WideString readonly dispid 318;
    property prItemRefundQuantity: SYSINT readonly dispid 319;
    property prItemRefundQtyPrecision: Byte readonly dispid 320;
    property prItemRefundSum: Int64 readonly dispid 321;
    property prItemRefundSumStr: WideString readonly dispid 322;
    property prItemCostStr: WideString readonly dispid 323;
    property prSumDiscountStr: WideString readonly dispid 324;
    property prSumMarkupStr: WideString readonly dispid 325;
    property prSumTotalStr: WideString readonly dispid 326;
    property prSumBalanceStr: WideString readonly dispid 327;
    property prCurReceiptTax1Sum: LongWord readonly dispid 328;
    property prCurReceiptTax2Sum: LongWord readonly dispid 329;
    property prCurReceiptTax3Sum: LongWord readonly dispid 330;
    property prCurReceiptTax4Sum: LongWord readonly dispid 331;
    property prCurReceiptTax5Sum: LongWord readonly dispid 332;
    property prCurReceiptTax6Sum: LongWord readonly dispid 333;
    property prCurReceiptTax1SumStr: WideString readonly dispid 457;
    property prCurReceiptTax2SumStr: WideString readonly dispid 458;
    property prCurReceiptTax3SumStr: WideString readonly dispid 459;
    property prCurReceiptTax4SumStr: WideString readonly dispid 460;
    property prCurReceiptTax5SumStr: WideString readonly dispid 461;
    property prCurReceiptTax6SumStr: WideString readonly dispid 462;
    property prCurReceiptPayForm1Sum: LongWord readonly dispid 334;
    property prCurReceiptPayForm2Sum: LongWord readonly dispid 335;
    property prCurReceiptPayForm3Sum: LongWord readonly dispid 336;
    property prCurReceiptPayForm4Sum: LongWord readonly dispid 337;
    property prCurReceiptPayForm5Sum: LongWord readonly dispid 338;
    property prCurReceiptPayForm6Sum: LongWord readonly dispid 339;
    property prCurReceiptPayForm7Sum: LongWord readonly dispid 340;
    property prCurReceiptPayForm8Sum: LongWord readonly dispid 341;
    property prCurReceiptPayForm9Sum: LongWord readonly dispid 342;
    property prCurReceiptPayForm10Sum: LongWord readonly dispid 343;
    property prCurReceiptPayForm1SumStr: WideString readonly dispid 463;
    property prCurReceiptPayForm2SumStr: WideString readonly dispid 464;
    property prCurReceiptPayForm3SumStr: WideString readonly dispid 465;
    property prCurReceiptPayForm4SumStr: WideString readonly dispid 466;
    property prCurReceiptPayForm5SumStr: WideString readonly dispid 467;
    property prCurReceiptPayForm6SumStr: WideString readonly dispid 468;
    property prCurReceiptPayForm7SumStr: WideString readonly dispid 469;
    property prCurReceiptPayForm8SumStr: WideString readonly dispid 470;
    property prCurReceiptPayForm9SumStr: WideString readonly dispid 471;
    property prCurReceiptPayForm10SumStr: WideString readonly dispid 472;
    property prPrinterError: WordBool readonly dispid 344;
    property prTapeNearEnd: WordBool readonly dispid 345;
    property prTapeEnded: WordBool readonly dispid 346;
    property prDaySaleReceiptsCount: Word readonly dispid 347;
    property prDaySaleReceiptsCountStr: WideString readonly dispid 473;
    property prDayRefundReceiptsCount: Word readonly dispid 348;
    property prDayRefundReceiptsCountStr: WideString readonly dispid 474;
    property prDaySaleSumOnTax1: LongWord readonly dispid 349;
    property prDaySaleSumOnTax2: LongWord readonly dispid 350;
    property prDaySaleSumOnTax3: LongWord readonly dispid 351;
    property prDaySaleSumOnTax4: LongWord readonly dispid 352;
    property prDaySaleSumOnTax5: LongWord readonly dispid 353;
    property prDaySaleSumOnTax6: LongWord readonly dispid 354;
    property prDaySaleSumOnTax1Str: WideString readonly dispid 475;
    property prDaySaleSumOnTax2Str: WideString readonly dispid 476;
    property prDaySaleSumOnTax3Str: WideString readonly dispid 477;
    property prDaySaleSumOnTax4Str: WideString readonly dispid 478;
    property prDaySaleSumOnTax5Str: WideString readonly dispid 479;
    property prDaySaleSumOnTax6Str: WideString readonly dispid 480;
    property prDayRefundSumOnTax1: LongWord readonly dispid 355;
    property prDayRefundSumOnTax2: LongWord readonly dispid 356;
    property prDayRefundSumOnTax3: LongWord readonly dispid 357;
    property prDayRefundSumOnTax4: LongWord readonly dispid 358;
    property prDayRefundSumOnTax5: LongWord readonly dispid 359;
    property prDayRefundSumOnTax6: LongWord readonly dispid 360;
    property prDayRefundSumOnTax1Str: WideString readonly dispid 481;
    property prDayRefundSumOnTax2Str: WideString readonly dispid 482;
    property prDayRefundSumOnTax3Str: WideString readonly dispid 483;
    property prDayRefundSumOnTax4Str: WideString readonly dispid 484;
    property prDayRefundSumOnTax5Str: WideString readonly dispid 485;
    property prDayRefundSumOnTax6Str: WideString readonly dispid 486;
    property prDaySaleSumOnPayForm1: LongWord readonly dispid 361;
    property prDaySaleSumOnPayForm2: LongWord readonly dispid 362;
    property prDaySaleSumOnPayForm3: LongWord readonly dispid 363;
    property prDaySaleSumOnPayForm4: LongWord readonly dispid 364;
    property prDaySaleSumOnPayForm5: LongWord readonly dispid 365;
    property prDaySaleSumOnPayForm6: LongWord readonly dispid 366;
    property prDaySaleSumOnPayForm7: LongWord readonly dispid 367;
    property prDaySaleSumOnPayForm8: LongWord readonly dispid 368;
    property prDaySaleSumOnPayForm9: LongWord readonly dispid 369;
    property prDaySaleSumOnPayForm10: LongWord readonly dispid 370;
    property prDaySaleSumOnPayForm1Str: WideString readonly dispid 487;
    property prDaySaleSumOnPayForm2Str: WideString readonly dispid 488;
    property prDaySaleSumOnPayForm3Str: WideString readonly dispid 489;
    property prDaySaleSumOnPayForm4Str: WideString readonly dispid 490;
    property prDaySaleSumOnPayForm5Str: WideString readonly dispid 491;
    property prDaySaleSumOnPayForm6Str: WideString readonly dispid 492;
    property prDaySaleSumOnPayForm7Str: WideString readonly dispid 493;
    property prDaySaleSumOnPayForm8Str: WideString readonly dispid 494;
    property prDaySaleSumOnPayForm9Str: WideString readonly dispid 495;
    property prDaySaleSumOnPayForm10Str: WideString readonly dispid 496;
    property prDayRefundSumOnPayForm1: LongWord readonly dispid 371;
    property prDayRefundSumOnPayForm2: LongWord readonly dispid 372;
    property prDayRefundSumOnPayForm3: LongWord readonly dispid 373;
    property prDayRefundSumOnPayForm4: LongWord readonly dispid 374;
    property prDayRefundSumOnPayForm5: LongWord readonly dispid 375;
    property prDayRefundSumOnPayForm6: LongWord readonly dispid 376;
    property prDayRefundSumOnPayForm7: LongWord readonly dispid 377;
    property prDayRefundSumOnPayForm8: LongWord readonly dispid 378;
    property prDayRefundSumOnPayForm9: LongWord readonly dispid 379;
    property prDayRefundSumOnPayForm10: LongWord readonly dispid 380;
    property prDayRefundSumOnPayForm1Str: WideString readonly dispid 497;
    property prDayRefundSumOnPayForm2Str: WideString readonly dispid 498;
    property prDayRefundSumOnPayForm3Str: WideString readonly dispid 499;
    property prDayRefundSumOnPayForm4Str: WideString readonly dispid 500;
    property prDayRefundSumOnPayForm5Str: WideString readonly dispid 501;
    property prDayRefundSumOnPayForm6Str: WideString readonly dispid 502;
    property prDayRefundSumOnPayForm7Str: WideString readonly dispid 503;
    property prDayRefundSumOnPayForm8Str: WideString readonly dispid 504;
    property prDayRefundSumOnPayForm9Str: WideString readonly dispid 505;
    property prDayRefundSumOnPayForm10Str: WideString readonly dispid 506;
    property prDayDiscountSumOnSales: LongWord readonly dispid 381;
    property prDayDiscountSumOnSalesStr: WideString readonly dispid 507;
    property prDayMarkupSumOnSales: LongWord readonly dispid 382;
    property prDayMarkupSumOnSalesStr: WideString readonly dispid 508;
    property prDayDiscountSumOnRefunds: LongWord readonly dispid 383;
    property prDayDiscountSumOnRefundsStr: WideString readonly dispid 509;
    property prDayMarkupSumOnRefunds: LongWord readonly dispid 384;
    property prDayMarkupSumOnRefundsStr: WideString readonly dispid 510;
    property prDayCashInSum: LongWord readonly dispid 385;
    property prDayCashInSumStr: WideString readonly dispid 511;
    property prDayCashOutSum: LongWord readonly dispid 386;
    property prDayCashOutSumStr: WideString readonly dispid 512;
    property prCurrentZReport: Word readonly dispid 387;
    property prCurrentZReportStr: WideString readonly dispid 513;
    property prDayEndDate: TDateTime readonly dispid 388;
    property prDayEndDateStr: WideString readonly dispid 389;
    property prDayEndTime: TDateTime readonly dispid 390;
    property prDayEndTimeStr: WideString readonly dispid 391;
    property prLastZReportDate: TDateTime readonly dispid 392;
    property prLastZReportDateStr: WideString readonly dispid 393;
    property prItemsCount: Word readonly dispid 394;
    property prItemsCountStr: WideString readonly dispid 514;
    property prDaySumAddTaxOfSale1: LongWord readonly dispid 395;
    property prDaySumAddTaxOfSale2: LongWord readonly dispid 396;
    property prDaySumAddTaxOfSale3: LongWord readonly dispid 397;
    property prDaySumAddTaxOfSale4: LongWord readonly dispid 398;
    property prDaySumAddTaxOfSale5: LongWord readonly dispid 399;
    property prDaySumAddTaxOfSale6: LongWord readonly dispid 400;
    property prDaySumAddTaxOfSale1Str: WideString readonly dispid 515;
    property prDaySumAddTaxOfSale2Str: WideString readonly dispid 516;
    property prDaySumAddTaxOfSale3Str: WideString readonly dispid 517;
    property prDaySumAddTaxOfSale4Str: WideString readonly dispid 518;
    property prDaySumAddTaxOfSale5Str: WideString readonly dispid 519;
    property prDaySumAddTaxOfSale6Str: WideString readonly dispid 520;
    property prDaySumAddTaxOfRefund1: LongWord readonly dispid 401;
    property prDaySumAddTaxOfRefund2: LongWord readonly dispid 402;
    property prDaySumAddTaxOfRefund3: LongWord readonly dispid 403;
    property prDaySumAddTaxOfRefund4: LongWord readonly dispid 404;
    property prDaySumAddTaxOfRefund5: LongWord readonly dispid 405;
    property prDaySumAddTaxOfRefund6: LongWord readonly dispid 406;
    property prDaySumAddTaxOfRefund1Str: WideString readonly dispid 521;
    property prDaySumAddTaxOfRefund2Str: WideString readonly dispid 522;
    property prDaySumAddTaxOfRefund3Str: WideString readonly dispid 523;
    property prDaySumAddTaxOfRefund4Str: WideString readonly dispid 524;
    property prDaySumAddTaxOfRefund5Str: WideString readonly dispid 525;
    property prDaySumAddTaxOfRefund6Str: WideString readonly dispid 526;
    property prDayAnnuledSaleReceiptsCount: Word readonly dispid 407;
    property prDayAnnuledSaleReceiptsCountStr: WideString readonly dispid 527;
    property prDayAnnuledRefundReceiptsCount: Word readonly dispid 408;
    property prDayAnnuledRefundReceiptsCountStr: WideString readonly dispid 528;
    property prDayAnnuledSaleReceiptsSum: LongWord readonly dispid 409;
    property prDayAnnuledSaleReceiptsSumStr: WideString readonly dispid 529;
    property prDayAnnuledRefundReceiptsSum: LongWord readonly dispid 410;
    property prDayAnnuledRefundReceiptsSumStr: WideString readonly dispid 530;
    property prDaySaleCancelingsCount: Word readonly dispid 411;
    property prDaySaleCancelingsCountStr: WideString readonly dispid 531;
    property prDayRefundCancelingsCount: Word readonly dispid 412;
    property prDayRefundCancelingsCountStr: WideString readonly dispid 532;
    property prDaySaleCancelingsSum: LongWord readonly dispid 413;
    property prDaySaleCancelingsSumStr: WideString readonly dispid 533;
    property prDayRefundCancelingsSum: LongWord readonly dispid 414;
    property prDayRefundCancelingsSumStr: WideString readonly dispid 534;
    property prCashDrawerSum: Int64 readonly dispid 429;
    property prCashDrawerSumStr: WideString readonly dispid 430;
    property prRepeatCount: Byte dispid 431;
    property prLogRecording: WordBool dispid 432;
    property prAnswerWaiting: Byte dispid 434;
    property prGetStatusByte: Byte readonly dispid 436;
    property prGetResultByte: Byte readonly dispid 437;
    property prGetReserveByte: Byte readonly dispid 438;
    property prGetErrorText: WideString readonly dispid 439;
    property prCurReceiptItemCount: Byte readonly dispid 451;
    property prUserPassword: Word readonly dispid 536;
    property prUserPasswordStr: WideString readonly dispid 537;
    property prPrintContrast: Byte readonly dispid 542;
    property prFont9x17: WordBool dispid 543;
    property prFontBold: WordBool dispid 544;
    property prFontSmall: WordBool dispid 545;
    property prFontDoubleHeight: WordBool dispid 546;
    property prFontDoubleWidth: WordBool dispid 547;
    property prRevizionID: Byte readonly dispid 551;
    property prFPDriverMajorVersion: Byte readonly dispid 552;
    property prFPDriverMinorVersion: Byte readonly dispid 553;
    property prFPDriverReleaseVersion: Byte readonly dispid 554;
    property prFPDriverBuildVersion: Byte readonly dispid 555;
  end;

// *********************************************************************//
// Interface: IICS_MZ_11
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B2B43776-59B3-4C3B-8998-5314752D4BD5}
// *********************************************************************//
  IICS_MZ_11 = interface(IDispatch)
    ['{B2B43776-59B3-4C3B-8998-5314752D4BD5}']
    function FPInitialize: Integer; safecall;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; safecall;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; safecall;
    function FPClose: WordBool; safecall;
    function FPClaimUSBDevice: WordBool; safecall;
    function FPReleaseUSBDevice: WordBool; safecall;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; safecall;
    function FPTCPClose: WordBool; safecall;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; safecall;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; safecall;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; safecall;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; safecall;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; safecall;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; safecall;
    function FPPrintZeroReceipt: WordBool; safecall;
    function FPLineFeed: WordBool; safecall;
    function FPAnnulReceipt: WordBool; safecall;
    function FPCashIn(CashSum: SYSUINT): WordBool; safecall;
    function FPCashOut(CashSum: SYSUINT): WordBool; safecall;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; safecall;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; safecall;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; safecall;
    function FPGetCurrentDate: WordBool; safecall;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; safecall;
    function FPGetCurrentTime: WordBool; safecall;
    function FPOpenCashDrawer(Duration: Word): WordBool; safecall;
    function FPPrintHardwareVersion: WordBool; safecall;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; safecall;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; safecall;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; safecall;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; safecall;
    function FPOnlineModeSwitch: WordBool; safecall;
    function FPCustomerDisplayModeSwitch: WordBool; safecall;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; safecall;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; safecall;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; safecall;
    function FPCloseServiceReport: WordBool; safecall;
    function FPEnableLogo(ProgPassword: Word): WordBool; safecall;
    function FPDisableLogo(ProgPassword: Word): WordBool; safecall;
    function FPSetTaxRates(ProgPassword: Word): WordBool; safecall;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; safecall;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; safecall;
    function FPMakeXReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeZReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; safecall;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; safecall;
    function FPCutterModeSwitch: WordBool; safecall;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; safecall;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; safecall;
    function FPGetPaymentFormNames: WordBool; safecall;
    function FPGetCurrentStatus: WordBool; safecall;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; safecall;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; safecall;
    function FPGetCashDrawerSum: WordBool; safecall;
    function FPGetDayReportProperties: WordBool; safecall;
    function FPGetTaxRates: WordBool; safecall;
    function FPGetItemData(ItemCode: Int64): WordBool; safecall;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; safecall;
    function FPGetDayReportData: WordBool; safecall;
    function FPGetCurrentReceiptData: WordBool; safecall;
    function FPGetDayCorrectionsData: WordBool; safecall;
    function FPGetDayPacketData: WordBool; safecall;
    function FPGetDaySumOfAddTaxes: WordBool; safecall;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; safecall;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; safecall;
    function FPPrintModemStatus: WordBool; safecall;
    function FPGetUserPassword(UserID: Byte): WordBool; safecall;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; safecall;
    function FPSetContrast(Value: Byte): WordBool; safecall;
    function FPGetContrast: WordBool; safecall;
    function FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool; safecall;
    function FPClearGraphicPattern: WordBool; safecall;
    function FPUploadStaticGraphicData: WordBool; safecall;
    function FPUploadGraphicDoc: WordBool; safecall;
    function FPPrintGraphicDoc: WordBool; safecall;
    function FPDeleteGraphicBitmaps: WordBool; safecall;
    function FPGetGraphicFreeMemorySize: WordBool; safecall;
    function FPUploadImagesFromPattern(InvertColors: WordBool): WordBool; safecall;
    function FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool; safecall;
    function FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool; safecall;
    function FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool; safecall;
    function FPGetGraphicObjectsList: WordBool; safecall;
    function FPDeleteBitmapObject(ObjIndex: Byte): WordBool; safecall;
    function FPFullEraseGraphicMemory: WordBool; safecall;
    function FPEraseLogo: WordBool; safecall;
    function FPGetRevizionID: WordBool; safecall;
    function Get_glTapeAnalizer: WordBool; safecall;
    procedure Set_glTapeAnalizer(Value: WordBool); safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_glVirtualPortOpened: WordBool; safecall;
    function Get_glUseVirtualPort: WordBool; safecall;
    procedure Set_glUseVirtualPort(Value: WordBool); safecall;
    function Get_stUseAdditionalTax: WordBool; safecall;
    function Get_stUseAdditionalFee: WordBool; safecall;
    function Get_stUseFontB: WordBool; safecall;
    function Get_stUseTradeLogo: WordBool; safecall;
    function Get_stUseCutter: WordBool; safecall;
    function Get_stRefundReceiptMode: WordBool; safecall;
    function Get_stPaymentMode: WordBool; safecall;
    function Get_stFiscalMode: WordBool; safecall;
    function Get_stServiceReceiptMode: WordBool; safecall;
    function Get_stOnlinePrintMode: WordBool; safecall;
    function Get_stFailureLastCommand: WordBool; safecall;
    function Get_stFiscalDayIsOpened: WordBool; safecall;
    function Get_stReceiptIsOpened: WordBool; safecall;
    function Get_stCashDrawerIsOpened: WordBool; safecall;
    function Get_stDisplayShowSumMode: WordBool; safecall;
    function Get_prItemCost: Int64; safecall;
    function Get_prSumDiscount: Int64; safecall;
    function Get_prSumMarkup: Int64; safecall;
    function Get_prSumTotal: Int64; safecall;
    function Get_prSumBalance: Int64; safecall;
    function Get_prKSEFPacket: LongWord; safecall;
    function Get_prKSEFPacketStr: WideString; safecall;
    function Get_prModemError: Byte; safecall;
    function Get_prCurrentDate: TDateTime; safecall;
    function Get_prCurrentDateStr: WideString; safecall;
    function Get_prCurrentTime: TDateTime; safecall;
    function Get_prCurrentTimeStr: WideString; safecall;
    function Get_prTaxRatesCount: Byte; safecall;
    procedure Set_prTaxRatesCount(Value: Byte); safecall;
    function Get_prTaxRatesDate: TDateTime; safecall;
    function Get_prTaxRatesDateStr: WideString; safecall;
    function Get_prAddTaxType: WordBool; safecall;
    procedure Set_prAddTaxType(Value: WordBool); safecall;
    function Get_prTaxRate1: SYSINT; safecall;
    procedure Set_prTaxRate1(Value: SYSINT); safecall;
    function Get_prTaxRate2: SYSINT; safecall;
    procedure Set_prTaxRate2(Value: SYSINT); safecall;
    function Get_prTaxRate3: SYSINT; safecall;
    procedure Set_prTaxRate3(Value: SYSINT); safecall;
    function Get_prTaxRate4: SYSINT; safecall;
    procedure Set_prTaxRate4(Value: SYSINT); safecall;
    function Get_prTaxRate5: SYSINT; safecall;
    procedure Set_prTaxRate5(Value: SYSINT); safecall;
    function Get_prTaxRate6: SYSINT; safecall;
    function Get_prUsedAdditionalFee: WordBool; safecall;
    procedure Set_prUsedAdditionalFee(Value: WordBool); safecall;
    function Get_prAddFeeRate1: SYSINT; safecall;
    procedure Set_prAddFeeRate1(Value: SYSINT); safecall;
    function Get_prAddFeeRate2: SYSINT; safecall;
    procedure Set_prAddFeeRate2(Value: SYSINT); safecall;
    function Get_prAddFeeRate3: SYSINT; safecall;
    procedure Set_prAddFeeRate3(Value: SYSINT); safecall;
    function Get_prAddFeeRate4: SYSINT; safecall;
    procedure Set_prAddFeeRate4(Value: SYSINT); safecall;
    function Get_prAddFeeRate5: SYSINT; safecall;
    procedure Set_prAddFeeRate5(Value: SYSINT); safecall;
    function Get_prAddFeeRate6: SYSINT; safecall;
    procedure Set_prAddFeeRate6(Value: SYSINT); safecall;
    function Get_prTaxOnAddFee1: WordBool; safecall;
    procedure Set_prTaxOnAddFee1(Value: WordBool); safecall;
    function Get_prTaxOnAddFee2: WordBool; safecall;
    procedure Set_prTaxOnAddFee2(Value: WordBool); safecall;
    function Get_prTaxOnAddFee3: WordBool; safecall;
    procedure Set_prTaxOnAddFee3(Value: WordBool); safecall;
    function Get_prTaxOnAddFee4: WordBool; safecall;
    procedure Set_prTaxOnAddFee4(Value: WordBool); safecall;
    function Get_prTaxOnAddFee5: WordBool; safecall;
    procedure Set_prTaxOnAddFee5(Value: WordBool); safecall;
    function Get_prTaxOnAddFee6: WordBool; safecall;
    procedure Set_prTaxOnAddFee6(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice1: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice1(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice2: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice2(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice3: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice3(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice4: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice4(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice5: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice5(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice6: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice6(Value: WordBool); safecall;
    function Get_prNamePaymentForm1: WideString; safecall;
    function Get_prNamePaymentForm2: WideString; safecall;
    function Get_prNamePaymentForm3: WideString; safecall;
    function Get_prNamePaymentForm4: WideString; safecall;
    function Get_prNamePaymentForm5: WideString; safecall;
    function Get_prNamePaymentForm6: WideString; safecall;
    function Get_prNamePaymentForm7: WideString; safecall;
    function Get_prNamePaymentForm8: WideString; safecall;
    function Get_prNamePaymentForm9: WideString; safecall;
    function Get_prNamePaymentForm10: WideString; safecall;
    function Get_prSerialNumber: WideString; safecall;
    function Get_prFiscalNumber: WideString; safecall;
    function Get_prTaxNumber: WideString; safecall;
    function Get_prDateFiscalization: TDateTime; safecall;
    function Get_prDateFiscalizationStr: WideString; safecall;
    function Get_prTimeFiscalization: TDateTime; safecall;
    function Get_prTimeFiscalizationStr: WideString; safecall;
    function Get_prHeadLine1: WideString; safecall;
    function Get_prHeadLine2: WideString; safecall;
    function Get_prHeadLine3: WideString; safecall;
    function Get_prHardwareVersion: WideString; safecall;
    function Get_prItemName: WideString; safecall;
    function Get_prItemPrice: SYSINT; safecall;
    function Get_prItemSaleQuantity: SYSINT; safecall;
    function Get_prItemSaleQtyPrecision: Byte; safecall;
    function Get_prItemTax: Byte; safecall;
    function Get_prItemSaleSum: Int64; safecall;
    function Get_prItemSaleSumStr: WideString; safecall;
    function Get_prItemRefundQuantity: SYSINT; safecall;
    function Get_prItemRefundQtyPrecision: Byte; safecall;
    function Get_prItemRefundSum: Int64; safecall;
    function Get_prItemRefundSumStr: WideString; safecall;
    function Get_prItemCostStr: WideString; safecall;
    function Get_prSumDiscountStr: WideString; safecall;
    function Get_prSumMarkupStr: WideString; safecall;
    function Get_prSumTotalStr: WideString; safecall;
    function Get_prSumBalanceStr: WideString; safecall;
    function Get_prCurReceiptTax1Sum: LongWord; safecall;
    function Get_prCurReceiptTax2Sum: LongWord; safecall;
    function Get_prCurReceiptTax3Sum: LongWord; safecall;
    function Get_prCurReceiptTax4Sum: LongWord; safecall;
    function Get_prCurReceiptTax5Sum: LongWord; safecall;
    function Get_prCurReceiptTax6Sum: LongWord; safecall;
    function Get_prCurReceiptTax1SumStr: WideString; safecall;
    function Get_prCurReceiptTax2SumStr: WideString; safecall;
    function Get_prCurReceiptTax3SumStr: WideString; safecall;
    function Get_prCurReceiptTax4SumStr: WideString; safecall;
    function Get_prCurReceiptTax5SumStr: WideString; safecall;
    function Get_prCurReceiptTax6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm1Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm2Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm3Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm4Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm5Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm6Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm7Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm8Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm9Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm10Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm1SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm2SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm3SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm4SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm5SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm7SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm8SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm9SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm10SumStr: WideString; safecall;
    function Get_prPrinterError: WordBool; safecall;
    function Get_prTapeNearEnd: WordBool; safecall;
    function Get_prTapeEnded: WordBool; safecall;
    function Get_prDaySaleReceiptsCount: Word; safecall;
    function Get_prDaySaleReceiptsCountStr: WideString; safecall;
    function Get_prDayRefundReceiptsCount: Word; safecall;
    function Get_prDayRefundReceiptsCountStr: WideString; safecall;
    function Get_prDaySaleSumOnTax1: LongWord; safecall;
    function Get_prDaySaleSumOnTax2: LongWord; safecall;
    function Get_prDaySaleSumOnTax3: LongWord; safecall;
    function Get_prDaySaleSumOnTax4: LongWord; safecall;
    function Get_prDaySaleSumOnTax5: LongWord; safecall;
    function Get_prDaySaleSumOnTax6: LongWord; safecall;
    function Get_prDaySaleSumOnTax1Str: WideString; safecall;
    function Get_prDaySaleSumOnTax2Str: WideString; safecall;
    function Get_prDaySaleSumOnTax3Str: WideString; safecall;
    function Get_prDaySaleSumOnTax4Str: WideString; safecall;
    function Get_prDaySaleSumOnTax5Str: WideString; safecall;
    function Get_prDaySaleSumOnTax6Str: WideString; safecall;
    function Get_prDayRefundSumOnTax1: LongWord; safecall;
    function Get_prDayRefundSumOnTax2: LongWord; safecall;
    function Get_prDayRefundSumOnTax3: LongWord; safecall;
    function Get_prDayRefundSumOnTax4: LongWord; safecall;
    function Get_prDayRefundSumOnTax5: LongWord; safecall;
    function Get_prDayRefundSumOnTax6: LongWord; safecall;
    function Get_prDayRefundSumOnTax1Str: WideString; safecall;
    function Get_prDayRefundSumOnTax2Str: WideString; safecall;
    function Get_prDayRefundSumOnTax3Str: WideString; safecall;
    function Get_prDayRefundSumOnTax4Str: WideString; safecall;
    function Get_prDayRefundSumOnTax5Str: WideString; safecall;
    function Get_prDayRefundSumOnTax6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm1: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm2: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm3: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm4: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm5: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm6: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm7: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm8: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm9: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm10: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm1Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm2Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm3Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm4Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm5Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm7Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm8Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm9Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm10Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm1: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm2: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm3: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm4: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm5: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm6: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm7: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm8: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm9: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm10: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm1Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm2Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm3Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm4Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm5Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm6Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm7Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm8Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm9Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm10Str: WideString; safecall;
    function Get_prDayDiscountSumOnSales: LongWord; safecall;
    function Get_prDayDiscountSumOnSalesStr: WideString; safecall;
    function Get_prDayMarkupSumOnSales: LongWord; safecall;
    function Get_prDayMarkupSumOnSalesStr: WideString; safecall;
    function Get_prDayDiscountSumOnRefunds: LongWord; safecall;
    function Get_prDayDiscountSumOnRefundsStr: WideString; safecall;
    function Get_prDayMarkupSumOnRefunds: LongWord; safecall;
    function Get_prDayMarkupSumOnRefundsStr: WideString; safecall;
    function Get_prDayCashInSum: LongWord; safecall;
    function Get_prDayCashInSumStr: WideString; safecall;
    function Get_prDayCashOutSum: LongWord; safecall;
    function Get_prDayCashOutSumStr: WideString; safecall;
    function Get_prCurrentZReport: Word; safecall;
    function Get_prCurrentZReportStr: WideString; safecall;
    function Get_prDayEndDate: TDateTime; safecall;
    function Get_prDayEndDateStr: WideString; safecall;
    function Get_prDayEndTime: TDateTime; safecall;
    function Get_prDayEndTimeStr: WideString; safecall;
    function Get_prLastZReportDate: TDateTime; safecall;
    function Get_prLastZReportDateStr: WideString; safecall;
    function Get_prItemsCount: Word; safecall;
    function Get_prItemsCountStr: WideString; safecall;
    function Get_prDaySumAddTaxOfSale1: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale2: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale3: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale4: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale5: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale6: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale6Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund1: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund2: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund3: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund4: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund5: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund6: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund6Str: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsCount: Word; safecall;
    function Get_prDayAnnuledSaleReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsCount: Word; safecall;
    function Get_prDayAnnuledRefundReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledSaleReceiptsSumStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledRefundReceiptsSumStr: WideString; safecall;
    function Get_prDaySaleCancelingsCount: Word; safecall;
    function Get_prDaySaleCancelingsCountStr: WideString; safecall;
    function Get_prDayRefundCancelingsCount: Word; safecall;
    function Get_prDayRefundCancelingsCountStr: WideString; safecall;
    function Get_prDaySaleCancelingsSum: LongWord; safecall;
    function Get_prDaySaleCancelingsSumStr: WideString; safecall;
    function Get_prDayRefundCancelingsSum: LongWord; safecall;
    function Get_prDayRefundCancelingsSumStr: WideString; safecall;
    function Get_prDayFirstFreePacket: LongWord; safecall;
    function Get_prDayLastSentPacket: LongWord; safecall;
    function Get_prDayLastSignedPacket: LongWord; safecall;
    function Get_prDayFirstFreePacketStr: WideString; safecall;
    function Get_prDayLastSentPacketStr: WideString; safecall;
    function Get_prDayLastSignedPacketStr: WideString; safecall;
    function Get_prCashDrawerSum: Int64; safecall;
    function Get_prCashDrawerSumStr: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prGetStatusByte: Byte; safecall;
    function Get_prGetResultByte: Byte; safecall;
    function Get_prGetReserveByte: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prCurReceiptItemCount: Byte; safecall;
    function Get_prUserPassword: Word; safecall;
    function Get_prUserPasswordStr: WideString; safecall;
    function Get_prPrintContrast: Byte; safecall;
    function Get_prFont9x17: WordBool; safecall;
    procedure Set_prFont9x17(Value: WordBool); safecall;
    function Get_prFontBold: WordBool; safecall;
    procedure Set_prFontBold(Value: WordBool); safecall;
    function Get_prFontSmall: WordBool; safecall;
    procedure Set_prFontSmall(Value: WordBool); safecall;
    function Get_prFontDoubleHeight: WordBool; safecall;
    procedure Set_prFontDoubleHeight(Value: WordBool); safecall;
    function Get_prFontDoubleWidth: WordBool; safecall;
    procedure Set_prFontDoubleWidth(Value: WordBool); safecall;
    function Get_prProgPassword: Word; safecall;
    procedure Set_prProgPassword(Value: Word); safecall;
    function Get_prProgPasswordStr: WideString; safecall;
    procedure Set_prProgPasswordStr(const Value: WideString); safecall;
    function Get_prGetGraphicFreeMemorySize: LongWord; safecall;
    function Get_prGetGraphicFreeMemorySizeStr: WideString; safecall;
    function Get_prBitmapObjectsCount: Byte; safecall;
    function Get_prGetBitmapIndex(id: Byte): Byte; safecall;
    function Get_prUDPDeviceListSize: Byte; safecall;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString; safecall;
    function Get_prUDPDeviceMAC(id: Byte): WideString; safecall;
    function Get_prUDPDeviceIP(id: Byte): WideString; safecall;
    function Get_prUDPDeviceTCPport(id: Byte): Word; safecall;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString; safecall;
    function Get_prRevizionID: Byte; safecall;
    function Get_prFPDriverMajorVersion: Byte; safecall;
    function Get_prFPDriverMinorVersion: Byte; safecall;
    function Get_prFPDriverReleaseVersion: Byte; safecall;
    function Get_prFPDriverBuildVersion: Byte; safecall;
    property glTapeAnalizer: WordBool read Get_glTapeAnalizer write Set_glTapeAnalizer;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property glVirtualPortOpened: WordBool read Get_glVirtualPortOpened;
    property glUseVirtualPort: WordBool read Get_glUseVirtualPort write Set_glUseVirtualPort;
    property stUseAdditionalTax: WordBool read Get_stUseAdditionalTax;
    property stUseAdditionalFee: WordBool read Get_stUseAdditionalFee;
    property stUseFontB: WordBool read Get_stUseFontB;
    property stUseTradeLogo: WordBool read Get_stUseTradeLogo;
    property stUseCutter: WordBool read Get_stUseCutter;
    property stRefundReceiptMode: WordBool read Get_stRefundReceiptMode;
    property stPaymentMode: WordBool read Get_stPaymentMode;
    property stFiscalMode: WordBool read Get_stFiscalMode;
    property stServiceReceiptMode: WordBool read Get_stServiceReceiptMode;
    property stOnlinePrintMode: WordBool read Get_stOnlinePrintMode;
    property stFailureLastCommand: WordBool read Get_stFailureLastCommand;
    property stFiscalDayIsOpened: WordBool read Get_stFiscalDayIsOpened;
    property stReceiptIsOpened: WordBool read Get_stReceiptIsOpened;
    property stCashDrawerIsOpened: WordBool read Get_stCashDrawerIsOpened;
    property stDisplayShowSumMode: WordBool read Get_stDisplayShowSumMode;
    property prItemCost: Int64 read Get_prItemCost;
    property prSumDiscount: Int64 read Get_prSumDiscount;
    property prSumMarkup: Int64 read Get_prSumMarkup;
    property prSumTotal: Int64 read Get_prSumTotal;
    property prSumBalance: Int64 read Get_prSumBalance;
    property prKSEFPacket: LongWord read Get_prKSEFPacket;
    property prKSEFPacketStr: WideString read Get_prKSEFPacketStr;
    property prModemError: Byte read Get_prModemError;
    property prCurrentDate: TDateTime read Get_prCurrentDate;
    property prCurrentDateStr: WideString read Get_prCurrentDateStr;
    property prCurrentTime: TDateTime read Get_prCurrentTime;
    property prCurrentTimeStr: WideString read Get_prCurrentTimeStr;
    property prTaxRatesCount: Byte read Get_prTaxRatesCount write Set_prTaxRatesCount;
    property prTaxRatesDate: TDateTime read Get_prTaxRatesDate;
    property prTaxRatesDateStr: WideString read Get_prTaxRatesDateStr;
    property prAddTaxType: WordBool read Get_prAddTaxType write Set_prAddTaxType;
    property prTaxRate1: SYSINT read Get_prTaxRate1 write Set_prTaxRate1;
    property prTaxRate2: SYSINT read Get_prTaxRate2 write Set_prTaxRate2;
    property prTaxRate3: SYSINT read Get_prTaxRate3 write Set_prTaxRate3;
    property prTaxRate4: SYSINT read Get_prTaxRate4 write Set_prTaxRate4;
    property prTaxRate5: SYSINT read Get_prTaxRate5 write Set_prTaxRate5;
    property prTaxRate6: SYSINT read Get_prTaxRate6;
    property prUsedAdditionalFee: WordBool read Get_prUsedAdditionalFee write Set_prUsedAdditionalFee;
    property prAddFeeRate1: SYSINT read Get_prAddFeeRate1 write Set_prAddFeeRate1;
    property prAddFeeRate2: SYSINT read Get_prAddFeeRate2 write Set_prAddFeeRate2;
    property prAddFeeRate3: SYSINT read Get_prAddFeeRate3 write Set_prAddFeeRate3;
    property prAddFeeRate4: SYSINT read Get_prAddFeeRate4 write Set_prAddFeeRate4;
    property prAddFeeRate5: SYSINT read Get_prAddFeeRate5 write Set_prAddFeeRate5;
    property prAddFeeRate6: SYSINT read Get_prAddFeeRate6 write Set_prAddFeeRate6;
    property prTaxOnAddFee1: WordBool read Get_prTaxOnAddFee1 write Set_prTaxOnAddFee1;
    property prTaxOnAddFee2: WordBool read Get_prTaxOnAddFee2 write Set_prTaxOnAddFee2;
    property prTaxOnAddFee3: WordBool read Get_prTaxOnAddFee3 write Set_prTaxOnAddFee3;
    property prTaxOnAddFee4: WordBool read Get_prTaxOnAddFee4 write Set_prTaxOnAddFee4;
    property prTaxOnAddFee5: WordBool read Get_prTaxOnAddFee5 write Set_prTaxOnAddFee5;
    property prTaxOnAddFee6: WordBool read Get_prTaxOnAddFee6 write Set_prTaxOnAddFee6;
    property prAddFeeOnRetailPrice1: WordBool read Get_prAddFeeOnRetailPrice1 write Set_prAddFeeOnRetailPrice1;
    property prAddFeeOnRetailPrice2: WordBool read Get_prAddFeeOnRetailPrice2 write Set_prAddFeeOnRetailPrice2;
    property prAddFeeOnRetailPrice3: WordBool read Get_prAddFeeOnRetailPrice3 write Set_prAddFeeOnRetailPrice3;
    property prAddFeeOnRetailPrice4: WordBool read Get_prAddFeeOnRetailPrice4 write Set_prAddFeeOnRetailPrice4;
    property prAddFeeOnRetailPrice5: WordBool read Get_prAddFeeOnRetailPrice5 write Set_prAddFeeOnRetailPrice5;
    property prAddFeeOnRetailPrice6: WordBool read Get_prAddFeeOnRetailPrice6 write Set_prAddFeeOnRetailPrice6;
    property prNamePaymentForm1: WideString read Get_prNamePaymentForm1;
    property prNamePaymentForm2: WideString read Get_prNamePaymentForm2;
    property prNamePaymentForm3: WideString read Get_prNamePaymentForm3;
    property prNamePaymentForm4: WideString read Get_prNamePaymentForm4;
    property prNamePaymentForm5: WideString read Get_prNamePaymentForm5;
    property prNamePaymentForm6: WideString read Get_prNamePaymentForm6;
    property prNamePaymentForm7: WideString read Get_prNamePaymentForm7;
    property prNamePaymentForm8: WideString read Get_prNamePaymentForm8;
    property prNamePaymentForm9: WideString read Get_prNamePaymentForm9;
    property prNamePaymentForm10: WideString read Get_prNamePaymentForm10;
    property prSerialNumber: WideString read Get_prSerialNumber;
    property prFiscalNumber: WideString read Get_prFiscalNumber;
    property prTaxNumber: WideString read Get_prTaxNumber;
    property prDateFiscalization: TDateTime read Get_prDateFiscalization;
    property prDateFiscalizationStr: WideString read Get_prDateFiscalizationStr;
    property prTimeFiscalization: TDateTime read Get_prTimeFiscalization;
    property prTimeFiscalizationStr: WideString read Get_prTimeFiscalizationStr;
    property prHeadLine1: WideString read Get_prHeadLine1;
    property prHeadLine2: WideString read Get_prHeadLine2;
    property prHeadLine3: WideString read Get_prHeadLine3;
    property prHardwareVersion: WideString read Get_prHardwareVersion;
    property prItemName: WideString read Get_prItemName;
    property prItemPrice: SYSINT read Get_prItemPrice;
    property prItemSaleQuantity: SYSINT read Get_prItemSaleQuantity;
    property prItemSaleQtyPrecision: Byte read Get_prItemSaleQtyPrecision;
    property prItemTax: Byte read Get_prItemTax;
    property prItemSaleSum: Int64 read Get_prItemSaleSum;
    property prItemSaleSumStr: WideString read Get_prItemSaleSumStr;
    property prItemRefundQuantity: SYSINT read Get_prItemRefundQuantity;
    property prItemRefundQtyPrecision: Byte read Get_prItemRefundQtyPrecision;
    property prItemRefundSum: Int64 read Get_prItemRefundSum;
    property prItemRefundSumStr: WideString read Get_prItemRefundSumStr;
    property prItemCostStr: WideString read Get_prItemCostStr;
    property prSumDiscountStr: WideString read Get_prSumDiscountStr;
    property prSumMarkupStr: WideString read Get_prSumMarkupStr;
    property prSumTotalStr: WideString read Get_prSumTotalStr;
    property prSumBalanceStr: WideString read Get_prSumBalanceStr;
    property prCurReceiptTax1Sum: LongWord read Get_prCurReceiptTax1Sum;
    property prCurReceiptTax2Sum: LongWord read Get_prCurReceiptTax2Sum;
    property prCurReceiptTax3Sum: LongWord read Get_prCurReceiptTax3Sum;
    property prCurReceiptTax4Sum: LongWord read Get_prCurReceiptTax4Sum;
    property prCurReceiptTax5Sum: LongWord read Get_prCurReceiptTax5Sum;
    property prCurReceiptTax6Sum: LongWord read Get_prCurReceiptTax6Sum;
    property prCurReceiptTax1SumStr: WideString read Get_prCurReceiptTax1SumStr;
    property prCurReceiptTax2SumStr: WideString read Get_prCurReceiptTax2SumStr;
    property prCurReceiptTax3SumStr: WideString read Get_prCurReceiptTax3SumStr;
    property prCurReceiptTax4SumStr: WideString read Get_prCurReceiptTax4SumStr;
    property prCurReceiptTax5SumStr: WideString read Get_prCurReceiptTax5SumStr;
    property prCurReceiptTax6SumStr: WideString read Get_prCurReceiptTax6SumStr;
    property prCurReceiptPayForm1Sum: LongWord read Get_prCurReceiptPayForm1Sum;
    property prCurReceiptPayForm2Sum: LongWord read Get_prCurReceiptPayForm2Sum;
    property prCurReceiptPayForm3Sum: LongWord read Get_prCurReceiptPayForm3Sum;
    property prCurReceiptPayForm4Sum: LongWord read Get_prCurReceiptPayForm4Sum;
    property prCurReceiptPayForm5Sum: LongWord read Get_prCurReceiptPayForm5Sum;
    property prCurReceiptPayForm6Sum: LongWord read Get_prCurReceiptPayForm6Sum;
    property prCurReceiptPayForm7Sum: LongWord read Get_prCurReceiptPayForm7Sum;
    property prCurReceiptPayForm8Sum: LongWord read Get_prCurReceiptPayForm8Sum;
    property prCurReceiptPayForm9Sum: LongWord read Get_prCurReceiptPayForm9Sum;
    property prCurReceiptPayForm10Sum: LongWord read Get_prCurReceiptPayForm10Sum;
    property prCurReceiptPayForm1SumStr: WideString read Get_prCurReceiptPayForm1SumStr;
    property prCurReceiptPayForm2SumStr: WideString read Get_prCurReceiptPayForm2SumStr;
    property prCurReceiptPayForm3SumStr: WideString read Get_prCurReceiptPayForm3SumStr;
    property prCurReceiptPayForm4SumStr: WideString read Get_prCurReceiptPayForm4SumStr;
    property prCurReceiptPayForm5SumStr: WideString read Get_prCurReceiptPayForm5SumStr;
    property prCurReceiptPayForm6SumStr: WideString read Get_prCurReceiptPayForm6SumStr;
    property prCurReceiptPayForm7SumStr: WideString read Get_prCurReceiptPayForm7SumStr;
    property prCurReceiptPayForm8SumStr: WideString read Get_prCurReceiptPayForm8SumStr;
    property prCurReceiptPayForm9SumStr: WideString read Get_prCurReceiptPayForm9SumStr;
    property prCurReceiptPayForm10SumStr: WideString read Get_prCurReceiptPayForm10SumStr;
    property prPrinterError: WordBool read Get_prPrinterError;
    property prTapeNearEnd: WordBool read Get_prTapeNearEnd;
    property prTapeEnded: WordBool read Get_prTapeEnded;
    property prDaySaleReceiptsCount: Word read Get_prDaySaleReceiptsCount;
    property prDaySaleReceiptsCountStr: WideString read Get_prDaySaleReceiptsCountStr;
    property prDayRefundReceiptsCount: Word read Get_prDayRefundReceiptsCount;
    property prDayRefundReceiptsCountStr: WideString read Get_prDayRefundReceiptsCountStr;
    property prDaySaleSumOnTax1: LongWord read Get_prDaySaleSumOnTax1;
    property prDaySaleSumOnTax2: LongWord read Get_prDaySaleSumOnTax2;
    property prDaySaleSumOnTax3: LongWord read Get_prDaySaleSumOnTax3;
    property prDaySaleSumOnTax4: LongWord read Get_prDaySaleSumOnTax4;
    property prDaySaleSumOnTax5: LongWord read Get_prDaySaleSumOnTax5;
    property prDaySaleSumOnTax6: LongWord read Get_prDaySaleSumOnTax6;
    property prDaySaleSumOnTax1Str: WideString read Get_prDaySaleSumOnTax1Str;
    property prDaySaleSumOnTax2Str: WideString read Get_prDaySaleSumOnTax2Str;
    property prDaySaleSumOnTax3Str: WideString read Get_prDaySaleSumOnTax3Str;
    property prDaySaleSumOnTax4Str: WideString read Get_prDaySaleSumOnTax4Str;
    property prDaySaleSumOnTax5Str: WideString read Get_prDaySaleSumOnTax5Str;
    property prDaySaleSumOnTax6Str: WideString read Get_prDaySaleSumOnTax6Str;
    property prDayRefundSumOnTax1: LongWord read Get_prDayRefundSumOnTax1;
    property prDayRefundSumOnTax2: LongWord read Get_prDayRefundSumOnTax2;
    property prDayRefundSumOnTax3: LongWord read Get_prDayRefundSumOnTax3;
    property prDayRefundSumOnTax4: LongWord read Get_prDayRefundSumOnTax4;
    property prDayRefundSumOnTax5: LongWord read Get_prDayRefundSumOnTax5;
    property prDayRefundSumOnTax6: LongWord read Get_prDayRefundSumOnTax6;
    property prDayRefundSumOnTax1Str: WideString read Get_prDayRefundSumOnTax1Str;
    property prDayRefundSumOnTax2Str: WideString read Get_prDayRefundSumOnTax2Str;
    property prDayRefundSumOnTax3Str: WideString read Get_prDayRefundSumOnTax3Str;
    property prDayRefundSumOnTax4Str: WideString read Get_prDayRefundSumOnTax4Str;
    property prDayRefundSumOnTax5Str: WideString read Get_prDayRefundSumOnTax5Str;
    property prDayRefundSumOnTax6Str: WideString read Get_prDayRefundSumOnTax6Str;
    property prDaySaleSumOnPayForm1: LongWord read Get_prDaySaleSumOnPayForm1;
    property prDaySaleSumOnPayForm2: LongWord read Get_prDaySaleSumOnPayForm2;
    property prDaySaleSumOnPayForm3: LongWord read Get_prDaySaleSumOnPayForm3;
    property prDaySaleSumOnPayForm4: LongWord read Get_prDaySaleSumOnPayForm4;
    property prDaySaleSumOnPayForm5: LongWord read Get_prDaySaleSumOnPayForm5;
    property prDaySaleSumOnPayForm6: LongWord read Get_prDaySaleSumOnPayForm6;
    property prDaySaleSumOnPayForm7: LongWord read Get_prDaySaleSumOnPayForm7;
    property prDaySaleSumOnPayForm8: LongWord read Get_prDaySaleSumOnPayForm8;
    property prDaySaleSumOnPayForm9: LongWord read Get_prDaySaleSumOnPayForm9;
    property prDaySaleSumOnPayForm10: LongWord read Get_prDaySaleSumOnPayForm10;
    property prDaySaleSumOnPayForm1Str: WideString read Get_prDaySaleSumOnPayForm1Str;
    property prDaySaleSumOnPayForm2Str: WideString read Get_prDaySaleSumOnPayForm2Str;
    property prDaySaleSumOnPayForm3Str: WideString read Get_prDaySaleSumOnPayForm3Str;
    property prDaySaleSumOnPayForm4Str: WideString read Get_prDaySaleSumOnPayForm4Str;
    property prDaySaleSumOnPayForm5Str: WideString read Get_prDaySaleSumOnPayForm5Str;
    property prDaySaleSumOnPayForm6Str: WideString read Get_prDaySaleSumOnPayForm6Str;
    property prDaySaleSumOnPayForm7Str: WideString read Get_prDaySaleSumOnPayForm7Str;
    property prDaySaleSumOnPayForm8Str: WideString read Get_prDaySaleSumOnPayForm8Str;
    property prDaySaleSumOnPayForm9Str: WideString read Get_prDaySaleSumOnPayForm9Str;
    property prDaySaleSumOnPayForm10Str: WideString read Get_prDaySaleSumOnPayForm10Str;
    property prDayRefundSumOnPayForm1: LongWord read Get_prDayRefundSumOnPayForm1;
    property prDayRefundSumOnPayForm2: LongWord read Get_prDayRefundSumOnPayForm2;
    property prDayRefundSumOnPayForm3: LongWord read Get_prDayRefundSumOnPayForm3;
    property prDayRefundSumOnPayForm4: LongWord read Get_prDayRefundSumOnPayForm4;
    property prDayRefundSumOnPayForm5: LongWord read Get_prDayRefundSumOnPayForm5;
    property prDayRefundSumOnPayForm6: LongWord read Get_prDayRefundSumOnPayForm6;
    property prDayRefundSumOnPayForm7: LongWord read Get_prDayRefundSumOnPayForm7;
    property prDayRefundSumOnPayForm8: LongWord read Get_prDayRefundSumOnPayForm8;
    property prDayRefundSumOnPayForm9: LongWord read Get_prDayRefundSumOnPayForm9;
    property prDayRefundSumOnPayForm10: LongWord read Get_prDayRefundSumOnPayForm10;
    property prDayRefundSumOnPayForm1Str: WideString read Get_prDayRefundSumOnPayForm1Str;
    property prDayRefundSumOnPayForm2Str: WideString read Get_prDayRefundSumOnPayForm2Str;
    property prDayRefundSumOnPayForm3Str: WideString read Get_prDayRefundSumOnPayForm3Str;
    property prDayRefundSumOnPayForm4Str: WideString read Get_prDayRefundSumOnPayForm4Str;
    property prDayRefundSumOnPayForm5Str: WideString read Get_prDayRefundSumOnPayForm5Str;
    property prDayRefundSumOnPayForm6Str: WideString read Get_prDayRefundSumOnPayForm6Str;
    property prDayRefundSumOnPayForm7Str: WideString read Get_prDayRefundSumOnPayForm7Str;
    property prDayRefundSumOnPayForm8Str: WideString read Get_prDayRefundSumOnPayForm8Str;
    property prDayRefundSumOnPayForm9Str: WideString read Get_prDayRefundSumOnPayForm9Str;
    property prDayRefundSumOnPayForm10Str: WideString read Get_prDayRefundSumOnPayForm10Str;
    property prDayDiscountSumOnSales: LongWord read Get_prDayDiscountSumOnSales;
    property prDayDiscountSumOnSalesStr: WideString read Get_prDayDiscountSumOnSalesStr;
    property prDayMarkupSumOnSales: LongWord read Get_prDayMarkupSumOnSales;
    property prDayMarkupSumOnSalesStr: WideString read Get_prDayMarkupSumOnSalesStr;
    property prDayDiscountSumOnRefunds: LongWord read Get_prDayDiscountSumOnRefunds;
    property prDayDiscountSumOnRefundsStr: WideString read Get_prDayDiscountSumOnRefundsStr;
    property prDayMarkupSumOnRefunds: LongWord read Get_prDayMarkupSumOnRefunds;
    property prDayMarkupSumOnRefundsStr: WideString read Get_prDayMarkupSumOnRefundsStr;
    property prDayCashInSum: LongWord read Get_prDayCashInSum;
    property prDayCashInSumStr: WideString read Get_prDayCashInSumStr;
    property prDayCashOutSum: LongWord read Get_prDayCashOutSum;
    property prDayCashOutSumStr: WideString read Get_prDayCashOutSumStr;
    property prCurrentZReport: Word read Get_prCurrentZReport;
    property prCurrentZReportStr: WideString read Get_prCurrentZReportStr;
    property prDayEndDate: TDateTime read Get_prDayEndDate;
    property prDayEndDateStr: WideString read Get_prDayEndDateStr;
    property prDayEndTime: TDateTime read Get_prDayEndTime;
    property prDayEndTimeStr: WideString read Get_prDayEndTimeStr;
    property prLastZReportDate: TDateTime read Get_prLastZReportDate;
    property prLastZReportDateStr: WideString read Get_prLastZReportDateStr;
    property prItemsCount: Word read Get_prItemsCount;
    property prItemsCountStr: WideString read Get_prItemsCountStr;
    property prDaySumAddTaxOfSale1: LongWord read Get_prDaySumAddTaxOfSale1;
    property prDaySumAddTaxOfSale2: LongWord read Get_prDaySumAddTaxOfSale2;
    property prDaySumAddTaxOfSale3: LongWord read Get_prDaySumAddTaxOfSale3;
    property prDaySumAddTaxOfSale4: LongWord read Get_prDaySumAddTaxOfSale4;
    property prDaySumAddTaxOfSale5: LongWord read Get_prDaySumAddTaxOfSale5;
    property prDaySumAddTaxOfSale6: LongWord read Get_prDaySumAddTaxOfSale6;
    property prDaySumAddTaxOfSale1Str: WideString read Get_prDaySumAddTaxOfSale1Str;
    property prDaySumAddTaxOfSale2Str: WideString read Get_prDaySumAddTaxOfSale2Str;
    property prDaySumAddTaxOfSale3Str: WideString read Get_prDaySumAddTaxOfSale3Str;
    property prDaySumAddTaxOfSale4Str: WideString read Get_prDaySumAddTaxOfSale4Str;
    property prDaySumAddTaxOfSale5Str: WideString read Get_prDaySumAddTaxOfSale5Str;
    property prDaySumAddTaxOfSale6Str: WideString read Get_prDaySumAddTaxOfSale6Str;
    property prDaySumAddTaxOfRefund1: LongWord read Get_prDaySumAddTaxOfRefund1;
    property prDaySumAddTaxOfRefund2: LongWord read Get_prDaySumAddTaxOfRefund2;
    property prDaySumAddTaxOfRefund3: LongWord read Get_prDaySumAddTaxOfRefund3;
    property prDaySumAddTaxOfRefund4: LongWord read Get_prDaySumAddTaxOfRefund4;
    property prDaySumAddTaxOfRefund5: LongWord read Get_prDaySumAddTaxOfRefund5;
    property prDaySumAddTaxOfRefund6: LongWord read Get_prDaySumAddTaxOfRefund6;
    property prDaySumAddTaxOfRefund1Str: WideString read Get_prDaySumAddTaxOfRefund1Str;
    property prDaySumAddTaxOfRefund2Str: WideString read Get_prDaySumAddTaxOfRefund2Str;
    property prDaySumAddTaxOfRefund3Str: WideString read Get_prDaySumAddTaxOfRefund3Str;
    property prDaySumAddTaxOfRefund4Str: WideString read Get_prDaySumAddTaxOfRefund4Str;
    property prDaySumAddTaxOfRefund5Str: WideString read Get_prDaySumAddTaxOfRefund5Str;
    property prDaySumAddTaxOfRefund6Str: WideString read Get_prDaySumAddTaxOfRefund6Str;
    property prDayAnnuledSaleReceiptsCount: Word read Get_prDayAnnuledSaleReceiptsCount;
    property prDayAnnuledSaleReceiptsCountStr: WideString read Get_prDayAnnuledSaleReceiptsCountStr;
    property prDayAnnuledRefundReceiptsCount: Word read Get_prDayAnnuledRefundReceiptsCount;
    property prDayAnnuledRefundReceiptsCountStr: WideString read Get_prDayAnnuledRefundReceiptsCountStr;
    property prDayAnnuledSaleReceiptsSum: LongWord read Get_prDayAnnuledSaleReceiptsSum;
    property prDayAnnuledSaleReceiptsSumStr: WideString read Get_prDayAnnuledSaleReceiptsSumStr;
    property prDayAnnuledRefundReceiptsSum: LongWord read Get_prDayAnnuledRefundReceiptsSum;
    property prDayAnnuledRefundReceiptsSumStr: WideString read Get_prDayAnnuledRefundReceiptsSumStr;
    property prDaySaleCancelingsCount: Word read Get_prDaySaleCancelingsCount;
    property prDaySaleCancelingsCountStr: WideString read Get_prDaySaleCancelingsCountStr;
    property prDayRefundCancelingsCount: Word read Get_prDayRefundCancelingsCount;
    property prDayRefundCancelingsCountStr: WideString read Get_prDayRefundCancelingsCountStr;
    property prDaySaleCancelingsSum: LongWord read Get_prDaySaleCancelingsSum;
    property prDaySaleCancelingsSumStr: WideString read Get_prDaySaleCancelingsSumStr;
    property prDayRefundCancelingsSum: LongWord read Get_prDayRefundCancelingsSum;
    property prDayRefundCancelingsSumStr: WideString read Get_prDayRefundCancelingsSumStr;
    property prDayFirstFreePacket: LongWord read Get_prDayFirstFreePacket;
    property prDayLastSentPacket: LongWord read Get_prDayLastSentPacket;
    property prDayLastSignedPacket: LongWord read Get_prDayLastSignedPacket;
    property prDayFirstFreePacketStr: WideString read Get_prDayFirstFreePacketStr;
    property prDayLastSentPacketStr: WideString read Get_prDayLastSentPacketStr;
    property prDayLastSignedPacketStr: WideString read Get_prDayLastSignedPacketStr;
    property prCashDrawerSum: Int64 read Get_prCashDrawerSum;
    property prCashDrawerSumStr: WideString read Get_prCashDrawerSumStr;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prGetStatusByte: Byte read Get_prGetStatusByte;
    property prGetResultByte: Byte read Get_prGetResultByte;
    property prGetReserveByte: Byte read Get_prGetReserveByte;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prCurReceiptItemCount: Byte read Get_prCurReceiptItemCount;
    property prUserPassword: Word read Get_prUserPassword;
    property prUserPasswordStr: WideString read Get_prUserPasswordStr;
    property prPrintContrast: Byte read Get_prPrintContrast;
    property prFont9x17: WordBool read Get_prFont9x17 write Set_prFont9x17;
    property prFontBold: WordBool read Get_prFontBold write Set_prFontBold;
    property prFontSmall: WordBool read Get_prFontSmall write Set_prFontSmall;
    property prFontDoubleHeight: WordBool read Get_prFontDoubleHeight write Set_prFontDoubleHeight;
    property prFontDoubleWidth: WordBool read Get_prFontDoubleWidth write Set_prFontDoubleWidth;
    property prProgPassword: Word read Get_prProgPassword write Set_prProgPassword;
    property prProgPasswordStr: WideString read Get_prProgPasswordStr write Set_prProgPasswordStr;
    property prGetGraphicFreeMemorySize: LongWord read Get_prGetGraphicFreeMemorySize;
    property prGetGraphicFreeMemorySizeStr: WideString read Get_prGetGraphicFreeMemorySizeStr;
    property prBitmapObjectsCount: Byte read Get_prBitmapObjectsCount;
    property prGetBitmapIndex[id: Byte]: Byte read Get_prGetBitmapIndex;
    property prUDPDeviceListSize: Byte read Get_prUDPDeviceListSize;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte read Get_prRevizionID;
    property prFPDriverMajorVersion: Byte read Get_prFPDriverMajorVersion;
    property prFPDriverMinorVersion: Byte read Get_prFPDriverMinorVersion;
    property prFPDriverReleaseVersion: Byte read Get_prFPDriverReleaseVersion;
    property prFPDriverBuildVersion: Byte read Get_prFPDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_MZ_11Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B2B43776-59B3-4C3B-8998-5314752D4BD5}
// *********************************************************************//
  IICS_MZ_11Disp = dispinterface
    ['{B2B43776-59B3-4C3B-8998-5314752D4BD5}']
    function FPInitialize: Integer; dispid 433;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; dispid 201;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; dispid 202;
    function FPClose: WordBool; dispid 203;
    function FPClaimUSBDevice: WordBool; dispid 586;
    function FPReleaseUSBDevice: WordBool; dispid 587;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; dispid 588;
    function FPTCPClose: WordBool; dispid 589;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; dispid 601;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; dispid 204;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; dispid 205;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 206;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString;
                             const ItemCodeStr: WideString): WordBool; dispid 207;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 208;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; dispid 209;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; dispid 210;
    function FPPrintZeroReceipt: WordBool; dispid 211;
    function FPLineFeed: WordBool; dispid 212;
    function FPAnnulReceipt: WordBool; dispid 213;
    function FPCashIn(CashSum: SYSUINT): WordBool; dispid 214;
    function FPCashOut(CashSum: SYSUINT): WordBool; dispid 215;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; dispid 216;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; dispid 217;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; dispid 218;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; dispid 219;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; dispid 220;
    function FPGetCurrentDate: WordBool; dispid 221;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; dispid 222;
    function FPGetCurrentTime: WordBool; dispid 223;
    function FPOpenCashDrawer(Duration: Word): WordBool; dispid 224;
    function FPPrintHardwareVersion: WordBool; dispid 225;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; dispid 226;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; dispid 227;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; dispid 228;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; dispid 229;
    function FPOnlineModeSwitch: WordBool; dispid 230;
    function FPCustomerDisplayModeSwitch: WordBool; dispid 231;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; dispid 232;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; dispid 233;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; dispid 234;
    function FPCloseServiceReport: WordBool; dispid 235;
    function FPEnableLogo(ProgPassword: Word): WordBool; dispid 236;
    function FPDisableLogo(ProgPassword: Word): WordBool; dispid 237;
    function FPSetTaxRates(ProgPassword: Word): WordBool; dispid 238;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool;
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; dispid 239;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; dispid 240;
    function FPMakeXReport(ReportPassword: Word): WordBool; dispid 241;
    function FPMakeZReport(ReportPassword: Word): WordBool; dispid 242;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; dispid 243;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; dispid 244;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; dispid 245;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; dispid 246;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; dispid 247;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; dispid 248;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; dispid 249;
    function FPCutterModeSwitch: WordBool; dispid 250;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; dispid 251;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; dispid 539;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; dispid 252;
    function FPGetPaymentFormNames: WordBool; dispid 435;
    function FPGetCurrentStatus: WordBool; dispid 440;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; dispid 442;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; dispid 443;
    function FPGetCashDrawerSum: WordBool; dispid 444;
    function FPGetDayReportProperties: WordBool; dispid 445;
    function FPGetTaxRates: WordBool; dispid 446;
    function FPGetItemData(ItemCode: Int64): WordBool; dispid 447;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; dispid 448;
    function FPGetDayReportData: WordBool; dispid 449;
    function FPGetCurrentReceiptData: WordBool; dispid 450;
    function FPGetDayCorrectionsData: WordBool; dispid 452;
    function FPGetDayPacketData: WordBool; dispid 562;
    function FPGetDaySumOfAddTaxes: WordBool; dispid 453;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; dispid 454;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; dispid 455;
    function FPPrintModemStatus: WordBool; dispid 456;
    function FPGetUserPassword(UserID: Byte): WordBool; dispid 535;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; dispid 548;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; dispid 549;
    function FPSetContrast(Value: Byte): WordBool; dispid 540;
    function FPGetContrast: WordBool; dispid 541;
    function FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool; dispid 574;
    function FPClearGraphicPattern: WordBool; dispid 575;
    function FPUploadStaticGraphicData: WordBool; dispid 576;
    function FPUploadGraphicDoc: WordBool; dispid 577;
    function FPPrintGraphicDoc: WordBool; dispid 578;
    function FPDeleteGraphicBitmaps: WordBool; dispid 579;
    function FPGetGraphicFreeMemorySize: WordBool; dispid 580;
    function FPUploadImagesFromPattern(InvertColors: WordBool): WordBool; dispid 581;
    function FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool; dispid 582;
    function FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool; dispid 583;
    function FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool; dispid 584;
    function FPGetGraphicObjectsList: WordBool; dispid 590;
    function FPDeleteBitmapObject(ObjIndex: Byte): WordBool; dispid 591;
    function FPFullEraseGraphicMemory: WordBool; dispid 592;
    function FPEraseLogo: WordBool; dispid 593;
    function FPGetRevizionID: WordBool; dispid 550;
    property glTapeAnalizer: WordBool dispid 253;
    property glPropertiesAutoUpdateMode: WordBool dispid 254;
    property glCodepageOEM: WordBool dispid 255;
    property glLangID: Byte dispid 256;
    property glVirtualPortOpened: WordBool readonly dispid 573;
    property glUseVirtualPort: WordBool dispid 585;
    property stUseAdditionalTax: WordBool readonly dispid 415;
    property stUseAdditionalFee: WordBool readonly dispid 416;
    property stUseFontB: WordBool readonly dispid 417;
    property stUseTradeLogo: WordBool readonly dispid 418;
    property stUseCutter: WordBool readonly dispid 419;
    property stRefundReceiptMode: WordBool readonly dispid 420;
    property stPaymentMode: WordBool readonly dispid 421;
    property stFiscalMode: WordBool readonly dispid 422;
    property stServiceReceiptMode: WordBool readonly dispid 423;
    property stOnlinePrintMode: WordBool readonly dispid 424;
    property stFailureLastCommand: WordBool readonly dispid 425;
    property stFiscalDayIsOpened: WordBool readonly dispid 426;
    property stReceiptIsOpened: WordBool readonly dispid 427;
    property stCashDrawerIsOpened: WordBool readonly dispid 428;
    property stDisplayShowSumMode: WordBool readonly dispid 441;
    property prItemCost: Int64 readonly dispid 257;
    property prSumDiscount: Int64 readonly dispid 258;
    property prSumMarkup: Int64 readonly dispid 259;
    property prSumTotal: Int64 readonly dispid 260;
    property prSumBalance: Int64 readonly dispid 261;
    property prKSEFPacket: LongWord readonly dispid 262;
    property prKSEFPacketStr: WideString readonly dispid 538;
    property prModemError: Byte readonly dispid 263;
    property prCurrentDate: TDateTime readonly dispid 264;
    property prCurrentDateStr: WideString readonly dispid 265;
    property prCurrentTime: TDateTime readonly dispid 266;
    property prCurrentTimeStr: WideString readonly dispid 267;
    property prTaxRatesCount: Byte dispid 268;
    property prTaxRatesDate: TDateTime readonly dispid 269;
    property prTaxRatesDateStr: WideString readonly dispid 270;
    property prAddTaxType: WordBool dispid 271;
    property prTaxRate1: SYSINT dispid 272;
    property prTaxRate2: SYSINT dispid 273;
    property prTaxRate3: SYSINT dispid 274;
    property prTaxRate4: SYSINT dispid 275;
    property prTaxRate5: SYSINT dispid 276;
    property prTaxRate6: SYSINT readonly dispid 277;
    property prUsedAdditionalFee: WordBool dispid 278;
    property prAddFeeRate1: SYSINT dispid 279;
    property prAddFeeRate2: SYSINT dispid 280;
    property prAddFeeRate3: SYSINT dispid 281;
    property prAddFeeRate4: SYSINT dispid 282;
    property prAddFeeRate5: SYSINT dispid 283;
    property prAddFeeRate6: SYSINT dispid 284;
    property prTaxOnAddFee1: WordBool dispid 285;
    property prTaxOnAddFee2: WordBool dispid 286;
    property prTaxOnAddFee3: WordBool dispid 287;
    property prTaxOnAddFee4: WordBool dispid 288;
    property prTaxOnAddFee5: WordBool dispid 289;
    property prTaxOnAddFee6: WordBool dispid 290;
    property prAddFeeOnRetailPrice1: WordBool dispid 556;
    property prAddFeeOnRetailPrice2: WordBool dispid 557;
    property prAddFeeOnRetailPrice3: WordBool dispid 558;
    property prAddFeeOnRetailPrice4: WordBool dispid 559;
    property prAddFeeOnRetailPrice5: WordBool dispid 560;
    property prAddFeeOnRetailPrice6: WordBool dispid 561;
    property prNamePaymentForm1: WideString readonly dispid 291;
    property prNamePaymentForm2: WideString readonly dispid 292;
    property prNamePaymentForm3: WideString readonly dispid 293;
    property prNamePaymentForm4: WideString readonly dispid 294;
    property prNamePaymentForm5: WideString readonly dispid 295;
    property prNamePaymentForm6: WideString readonly dispid 296;
    property prNamePaymentForm7: WideString readonly dispid 297;
    property prNamePaymentForm8: WideString readonly dispid 298;
    property prNamePaymentForm9: WideString readonly dispid 299;
    property prNamePaymentForm10: WideString readonly dispid 300;
    property prSerialNumber: WideString readonly dispid 301;
    property prFiscalNumber: WideString readonly dispid 302;
    property prTaxNumber: WideString readonly dispid 303;
    property prDateFiscalization: TDateTime readonly dispid 304;
    property prDateFiscalizationStr: WideString readonly dispid 305;
    property prTimeFiscalization: TDateTime readonly dispid 306;
    property prTimeFiscalizationStr: WideString readonly dispid 307;
    property prHeadLine1: WideString readonly dispid 308;
    property prHeadLine2: WideString readonly dispid 309;
    property prHeadLine3: WideString readonly dispid 310;
    property prHardwareVersion: WideString readonly dispid 311;
    property prItemName: WideString readonly dispid 312;
    property prItemPrice: SYSINT readonly dispid 313;
    property prItemSaleQuantity: SYSINT readonly dispid 314;
    property prItemSaleQtyPrecision: Byte readonly dispid 315;
    property prItemTax: Byte readonly dispid 316;
    property prItemSaleSum: Int64 readonly dispid 317;
    property prItemSaleSumStr: WideString readonly dispid 318;
    property prItemRefundQuantity: SYSINT readonly dispid 319;
    property prItemRefundQtyPrecision: Byte readonly dispid 320;
    property prItemRefundSum: Int64 readonly dispid 321;
    property prItemRefundSumStr: WideString readonly dispid 322;
    property prItemCostStr: WideString readonly dispid 323;
    property prSumDiscountStr: WideString readonly dispid 324;
    property prSumMarkupStr: WideString readonly dispid 325;
    property prSumTotalStr: WideString readonly dispid 326;
    property prSumBalanceStr: WideString readonly dispid 327;
    property prCurReceiptTax1Sum: LongWord readonly dispid 328;
    property prCurReceiptTax2Sum: LongWord readonly dispid 329;
    property prCurReceiptTax3Sum: LongWord readonly dispid 330;
    property prCurReceiptTax4Sum: LongWord readonly dispid 331;
    property prCurReceiptTax5Sum: LongWord readonly dispid 332;
    property prCurReceiptTax6Sum: LongWord readonly dispid 333;
    property prCurReceiptTax1SumStr: WideString readonly dispid 457;
    property prCurReceiptTax2SumStr: WideString readonly dispid 458;
    property prCurReceiptTax3SumStr: WideString readonly dispid 459;
    property prCurReceiptTax4SumStr: WideString readonly dispid 460;
    property prCurReceiptTax5SumStr: WideString readonly dispid 461;
    property prCurReceiptTax6SumStr: WideString readonly dispid 462;
    property prCurReceiptPayForm1Sum: LongWord readonly dispid 334;
    property prCurReceiptPayForm2Sum: LongWord readonly dispid 335;
    property prCurReceiptPayForm3Sum: LongWord readonly dispid 336;
    property prCurReceiptPayForm4Sum: LongWord readonly dispid 337;
    property prCurReceiptPayForm5Sum: LongWord readonly dispid 338;
    property prCurReceiptPayForm6Sum: LongWord readonly dispid 339;
    property prCurReceiptPayForm7Sum: LongWord readonly dispid 340;
    property prCurReceiptPayForm8Sum: LongWord readonly dispid 341;
    property prCurReceiptPayForm9Sum: LongWord readonly dispid 342;
    property prCurReceiptPayForm10Sum: LongWord readonly dispid 343;
    property prCurReceiptPayForm1SumStr: WideString readonly dispid 463;
    property prCurReceiptPayForm2SumStr: WideString readonly dispid 464;
    property prCurReceiptPayForm3SumStr: WideString readonly dispid 465;
    property prCurReceiptPayForm4SumStr: WideString readonly dispid 466;
    property prCurReceiptPayForm5SumStr: WideString readonly dispid 467;
    property prCurReceiptPayForm6SumStr: WideString readonly dispid 468;
    property prCurReceiptPayForm7SumStr: WideString readonly dispid 469;
    property prCurReceiptPayForm8SumStr: WideString readonly dispid 470;
    property prCurReceiptPayForm9SumStr: WideString readonly dispid 471;
    property prCurReceiptPayForm10SumStr: WideString readonly dispid 472;
    property prPrinterError: WordBool readonly dispid 344;
    property prTapeNearEnd: WordBool readonly dispid 345;
    property prTapeEnded: WordBool readonly dispid 346;
    property prDaySaleReceiptsCount: Word readonly dispid 347;
    property prDaySaleReceiptsCountStr: WideString readonly dispid 473;
    property prDayRefundReceiptsCount: Word readonly dispid 348;
    property prDayRefundReceiptsCountStr: WideString readonly dispid 474;
    property prDaySaleSumOnTax1: LongWord readonly dispid 349;
    property prDaySaleSumOnTax2: LongWord readonly dispid 350;
    property prDaySaleSumOnTax3: LongWord readonly dispid 351;
    property prDaySaleSumOnTax4: LongWord readonly dispid 352;
    property prDaySaleSumOnTax5: LongWord readonly dispid 353;
    property prDaySaleSumOnTax6: LongWord readonly dispid 354;
    property prDaySaleSumOnTax1Str: WideString readonly dispid 475;
    property prDaySaleSumOnTax2Str: WideString readonly dispid 476;
    property prDaySaleSumOnTax3Str: WideString readonly dispid 477;
    property prDaySaleSumOnTax4Str: WideString readonly dispid 478;
    property prDaySaleSumOnTax5Str: WideString readonly dispid 479;
    property prDaySaleSumOnTax6Str: WideString readonly dispid 480;
    property prDayRefundSumOnTax1: LongWord readonly dispid 355;
    property prDayRefundSumOnTax2: LongWord readonly dispid 356;
    property prDayRefundSumOnTax3: LongWord readonly dispid 357;
    property prDayRefundSumOnTax4: LongWord readonly dispid 358;
    property prDayRefundSumOnTax5: LongWord readonly dispid 359;
    property prDayRefundSumOnTax6: LongWord readonly dispid 360;
    property prDayRefundSumOnTax1Str: WideString readonly dispid 481;
    property prDayRefundSumOnTax2Str: WideString readonly dispid 482;
    property prDayRefundSumOnTax3Str: WideString readonly dispid 483;
    property prDayRefundSumOnTax4Str: WideString readonly dispid 484;
    property prDayRefundSumOnTax5Str: WideString readonly dispid 485;
    property prDayRefundSumOnTax6Str: WideString readonly dispid 486;
    property prDaySaleSumOnPayForm1: LongWord readonly dispid 361;
    property prDaySaleSumOnPayForm2: LongWord readonly dispid 362;
    property prDaySaleSumOnPayForm3: LongWord readonly dispid 363;
    property prDaySaleSumOnPayForm4: LongWord readonly dispid 364;
    property prDaySaleSumOnPayForm5: LongWord readonly dispid 365;
    property prDaySaleSumOnPayForm6: LongWord readonly dispid 366;
    property prDaySaleSumOnPayForm7: LongWord readonly dispid 367;
    property prDaySaleSumOnPayForm8: LongWord readonly dispid 368;
    property prDaySaleSumOnPayForm9: LongWord readonly dispid 369;
    property prDaySaleSumOnPayForm10: LongWord readonly dispid 370;
    property prDaySaleSumOnPayForm1Str: WideString readonly dispid 487;
    property prDaySaleSumOnPayForm2Str: WideString readonly dispid 488;
    property prDaySaleSumOnPayForm3Str: WideString readonly dispid 489;
    property prDaySaleSumOnPayForm4Str: WideString readonly dispid 490;
    property prDaySaleSumOnPayForm5Str: WideString readonly dispid 491;
    property prDaySaleSumOnPayForm6Str: WideString readonly dispid 492;
    property prDaySaleSumOnPayForm7Str: WideString readonly dispid 493;
    property prDaySaleSumOnPayForm8Str: WideString readonly dispid 494;
    property prDaySaleSumOnPayForm9Str: WideString readonly dispid 495;
    property prDaySaleSumOnPayForm10Str: WideString readonly dispid 496;
    property prDayRefundSumOnPayForm1: LongWord readonly dispid 371;
    property prDayRefundSumOnPayForm2: LongWord readonly dispid 372;
    property prDayRefundSumOnPayForm3: LongWord readonly dispid 373;
    property prDayRefundSumOnPayForm4: LongWord readonly dispid 374;
    property prDayRefundSumOnPayForm5: LongWord readonly dispid 375;
    property prDayRefundSumOnPayForm6: LongWord readonly dispid 376;
    property prDayRefundSumOnPayForm7: LongWord readonly dispid 377;
    property prDayRefundSumOnPayForm8: LongWord readonly dispid 378;
    property prDayRefundSumOnPayForm9: LongWord readonly dispid 379;
    property prDayRefundSumOnPayForm10: LongWord readonly dispid 380;
    property prDayRefundSumOnPayForm1Str: WideString readonly dispid 497;
    property prDayRefundSumOnPayForm2Str: WideString readonly dispid 498;
    property prDayRefundSumOnPayForm3Str: WideString readonly dispid 499;
    property prDayRefundSumOnPayForm4Str: WideString readonly dispid 500;
    property prDayRefundSumOnPayForm5Str: WideString readonly dispid 501;
    property prDayRefundSumOnPayForm6Str: WideString readonly dispid 502;
    property prDayRefundSumOnPayForm7Str: WideString readonly dispid 503;
    property prDayRefundSumOnPayForm8Str: WideString readonly dispid 504;
    property prDayRefundSumOnPayForm9Str: WideString readonly dispid 505;
    property prDayRefundSumOnPayForm10Str: WideString readonly dispid 506;
    property prDayDiscountSumOnSales: LongWord readonly dispid 381;
    property prDayDiscountSumOnSalesStr: WideString readonly dispid 507;
    property prDayMarkupSumOnSales: LongWord readonly dispid 382;
    property prDayMarkupSumOnSalesStr: WideString readonly dispid 508;
    property prDayDiscountSumOnRefunds: LongWord readonly dispid 383;
    property prDayDiscountSumOnRefundsStr: WideString readonly dispid 509;
    property prDayMarkupSumOnRefunds: LongWord readonly dispid 384;
    property prDayMarkupSumOnRefundsStr: WideString readonly dispid 510;
    property prDayCashInSum: LongWord readonly dispid 385;
    property prDayCashInSumStr: WideString readonly dispid 511;
    property prDayCashOutSum: LongWord readonly dispid 386;
    property prDayCashOutSumStr: WideString readonly dispid 512;
    property prCurrentZReport: Word readonly dispid 387;
    property prCurrentZReportStr: WideString readonly dispid 513;
    property prDayEndDate: TDateTime readonly dispid 388;
    property prDayEndDateStr: WideString readonly dispid 389;
    property prDayEndTime: TDateTime readonly dispid 390;
    property prDayEndTimeStr: WideString readonly dispid 391;
    property prLastZReportDate: TDateTime readonly dispid 392;
    property prLastZReportDateStr: WideString readonly dispid 393;
    property prItemsCount: Word readonly dispid 394;
    property prItemsCountStr: WideString readonly dispid 514;
    property prDaySumAddTaxOfSale1: LongWord readonly dispid 395;
    property prDaySumAddTaxOfSale2: LongWord readonly dispid 396;
    property prDaySumAddTaxOfSale3: LongWord readonly dispid 397;
    property prDaySumAddTaxOfSale4: LongWord readonly dispid 398;
    property prDaySumAddTaxOfSale5: LongWord readonly dispid 399;
    property prDaySumAddTaxOfSale6: LongWord readonly dispid 400;
    property prDaySumAddTaxOfSale1Str: WideString readonly dispid 515;
    property prDaySumAddTaxOfSale2Str: WideString readonly dispid 516;
    property prDaySumAddTaxOfSale3Str: WideString readonly dispid 517;
    property prDaySumAddTaxOfSale4Str: WideString readonly dispid 518;
    property prDaySumAddTaxOfSale5Str: WideString readonly dispid 519;
    property prDaySumAddTaxOfSale6Str: WideString readonly dispid 520;
    property prDaySumAddTaxOfRefund1: LongWord readonly dispid 401;
    property prDaySumAddTaxOfRefund2: LongWord readonly dispid 402;
    property prDaySumAddTaxOfRefund3: LongWord readonly dispid 403;
    property prDaySumAddTaxOfRefund4: LongWord readonly dispid 404;
    property prDaySumAddTaxOfRefund5: LongWord readonly dispid 405;
    property prDaySumAddTaxOfRefund6: LongWord readonly dispid 406;
    property prDaySumAddTaxOfRefund1Str: WideString readonly dispid 521;
    property prDaySumAddTaxOfRefund2Str: WideString readonly dispid 522;
    property prDaySumAddTaxOfRefund3Str: WideString readonly dispid 523;
    property prDaySumAddTaxOfRefund4Str: WideString readonly dispid 524;
    property prDaySumAddTaxOfRefund5Str: WideString readonly dispid 525;
    property prDaySumAddTaxOfRefund6Str: WideString readonly dispid 526;
    property prDayAnnuledSaleReceiptsCount: Word readonly dispid 407;
    property prDayAnnuledSaleReceiptsCountStr: WideString readonly dispid 527;
    property prDayAnnuledRefundReceiptsCount: Word readonly dispid 408;
    property prDayAnnuledRefundReceiptsCountStr: WideString readonly dispid 528;
    property prDayAnnuledSaleReceiptsSum: LongWord readonly dispid 409;
    property prDayAnnuledSaleReceiptsSumStr: WideString readonly dispid 529;
    property prDayAnnuledRefundReceiptsSum: LongWord readonly dispid 410;
    property prDayAnnuledRefundReceiptsSumStr: WideString readonly dispid 530;
    property prDaySaleCancelingsCount: Word readonly dispid 411;
    property prDaySaleCancelingsCountStr: WideString readonly dispid 531;
    property prDayRefundCancelingsCount: Word readonly dispid 412;
    property prDayRefundCancelingsCountStr: WideString readonly dispid 532;
    property prDaySaleCancelingsSum: LongWord readonly dispid 413;
    property prDaySaleCancelingsSumStr: WideString readonly dispid 533;
    property prDayRefundCancelingsSum: LongWord readonly dispid 414;
    property prDayRefundCancelingsSumStr: WideString readonly dispid 534;
    property prDayFirstFreePacket: LongWord readonly dispid 563;
    property prDayLastSentPacket: LongWord readonly dispid 564;
    property prDayLastSignedPacket: LongWord readonly dispid 565;
    property prDayFirstFreePacketStr: WideString readonly dispid 566;
    property prDayLastSentPacketStr: WideString readonly dispid 567;
    property prDayLastSignedPacketStr: WideString readonly dispid 568;
    property prCashDrawerSum: Int64 readonly dispid 429;
    property prCashDrawerSumStr: WideString readonly dispid 430;
    property prRepeatCount: Byte dispid 431;
    property prLogRecording: WordBool dispid 432;
    property prAnswerWaiting: Byte dispid 434;
    property prGetStatusByte: Byte readonly dispid 436;
    property prGetResultByte: Byte readonly dispid 437;
    property prGetReserveByte: Byte readonly dispid 438;
    property prGetErrorText: WideString readonly dispid 439;
    property prCurReceiptItemCount: Byte readonly dispid 451;
    property prUserPassword: Word readonly dispid 536;
    property prUserPasswordStr: WideString readonly dispid 537;
    property prPrintContrast: Byte readonly dispid 542;
    property prFont9x17: WordBool dispid 543;
    property prFontBold: WordBool dispid 544;
    property prFontSmall: WordBool dispid 545;
    property prFontDoubleHeight: WordBool dispid 546;
    property prFontDoubleWidth: WordBool dispid 547;
    property prProgPassword: Word dispid 569;
    property prProgPasswordStr: WideString dispid 570;
    property prGetGraphicFreeMemorySize: LongWord readonly dispid 571;
    property prGetGraphicFreeMemorySizeStr: WideString readonly dispid 572;
    property prBitmapObjectsCount: Byte readonly dispid 594;
    property prGetBitmapIndex[id: Byte]: Byte readonly dispid 595;
    property prUDPDeviceListSize: Byte readonly dispid 596;
    property prUDPDeviceSerialNumber[id: Byte]: WideString readonly dispid 597;
    property prUDPDeviceMAC[id: Byte]: WideString readonly dispid 598;
    property prUDPDeviceIP[id: Byte]: WideString readonly dispid 599;
    property prUDPDeviceTCPport[id: Byte]: Word readonly dispid 600;
    property prUDPDeviceTCPportStr[id: Byte]: WideString readonly dispid 602;
    property prRevizionID: Byte readonly dispid 551;
    property prFPDriverMajorVersion: Byte readonly dispid 552;
    property prFPDriverMinorVersion: Byte readonly dispid 553;
    property prFPDriverReleaseVersion: Byte readonly dispid 554;
    property prFPDriverBuildVersion: Byte readonly dispid 555;
  end;

// *********************************************************************//
// Interface: IICS_MF_09
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {00356DEF-AC8B-46A1-B477-4883345AC8CF}
// *********************************************************************//
  IICS_MF_09 = interface(IDispatch)
    ['{00356DEF-AC8B-46A1-B477-4883345AC8CF}']
    function FPInitialize: Integer; safecall;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; safecall;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; safecall;
    function FPClose: WordBool; safecall;
    function FPClaimUSBDevice: WordBool; safecall;
    function FPReleaseUSBDevice: WordBool; safecall;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; safecall;
    function FPTCPClose: WordBool; safecall;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; safecall;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; safecall;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; safecall;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; safecall;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; safecall;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; safecall;
    function FPPrintZeroReceipt: WordBool; safecall;
    function FPLineFeed: WordBool; safecall;
    function FPAnnulReceipt: WordBool; safecall;
    function FPCashIn(CashSum: SYSUINT): WordBool; safecall;
    function FPCashOut(CashSum: SYSUINT): WordBool; safecall;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; safecall;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; safecall;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; safecall;
    function FPGetCurrentDate: WordBool; safecall;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; safecall;
    function FPGetCurrentTime: WordBool; safecall;
    function FPOpenCashDrawer(Duration: Word): WordBool; safecall;
    function FPPrintHardwareVersion: WordBool; safecall;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; safecall;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; safecall;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; safecall;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; safecall;
    function FPOnlineModeSwitch: WordBool; safecall;
    function FPCustomerDisplayModeSwitch: WordBool; safecall;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; safecall;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; safecall;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; safecall;
    function FPCloseServiceReport: WordBool; safecall;
    function FPEnableLogo(ProgPassword: Word): WordBool; safecall;
    function FPDisableLogo(ProgPassword: Word): WordBool; safecall;
    function FPSetTaxRates(ProgPassword: Word): WordBool; safecall;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; safecall;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; safecall;
    function FPMakeXReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeZReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; safecall;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; safecall;
    function FPCutterModeSwitch: WordBool; safecall;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; safecall;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; safecall;
    function FPGetPaymentFormNames: WordBool; safecall;
    function FPGetCurrentStatus: WordBool; safecall;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; safecall;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; safecall;
    function FPGetCashDrawerSum: WordBool; safecall;
    function FPGetDayReportProperties: WordBool; safecall;
    function FPGetTaxRates: WordBool; safecall;
    function FPGetItemData(ItemCode: Int64): WordBool; safecall;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; safecall;
    function FPGetDayReportData: WordBool; safecall;
    function FPGetCurrentReceiptData: WordBool; safecall;
    function FPGetDayCorrectionsData: WordBool; safecall;
    function FPGetDaySumOfAddTaxes: WordBool; safecall;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; safecall;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; safecall;
    function FPPrintModemStatus: WordBool; safecall;
    function FPGetUserPassword(UserID: Byte): WordBool; safecall;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; safecall;
    function FPSetContrast(Value: Byte): WordBool; safecall;
    function FPGetContrast: WordBool; safecall;
    function FPGetRevizionID: WordBool; safecall;
    function Get_glTapeAnalizer: WordBool; safecall;
    procedure Set_glTapeAnalizer(Value: WordBool); safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_glVirtualPortOpened: WordBool; safecall;
    function Get_glUseVirtualPort: WordBool; safecall;
    procedure Set_glUseVirtualPort(Value: WordBool); safecall;
    function Get_stUseAdditionalTax: WordBool; safecall;
    function Get_stUseAdditionalFee: WordBool; safecall;
    function Get_stUseFontB: WordBool; safecall;
    function Get_stUseTradeLogo: WordBool; safecall;
    function Get_stUseCutter: WordBool; safecall;
    function Get_stRefundReceiptMode: WordBool; safecall;
    function Get_stPaymentMode: WordBool; safecall;
    function Get_stFiscalMode: WordBool; safecall;
    function Get_stServiceReceiptMode: WordBool; safecall;
    function Get_stOnlinePrintMode: WordBool; safecall;
    function Get_stFailureLastCommand: WordBool; safecall;
    function Get_stFiscalDayIsOpened: WordBool; safecall;
    function Get_stReceiptIsOpened: WordBool; safecall;
    function Get_stCashDrawerIsOpened: WordBool; safecall;
    function Get_stDisplayShowSumMode: WordBool; safecall;
    function Get_prItemCost: Int64; safecall;
    function Get_prSumDiscount: Int64; safecall;
    function Get_prSumMarkup: Int64; safecall;
    function Get_prSumTotal: Int64; safecall;
    function Get_prSumBalance: Int64; safecall;
    function Get_prKSEFPacket: LongWord; safecall;
    function Get_prKSEFPacketStr: WideString; safecall;
    function Get_prModemError: Byte; safecall;
    function Get_prCurrentDate: TDateTime; safecall;
    function Get_prCurrentDateStr: WideString; safecall;
    function Get_prCurrentTime: TDateTime; safecall;
    function Get_prCurrentTimeStr: WideString; safecall;
    function Get_prTaxRatesCount: Byte; safecall;
    procedure Set_prTaxRatesCount(Value: Byte); safecall;
    function Get_prTaxRatesDate: TDateTime; safecall;
    function Get_prTaxRatesDateStr: WideString; safecall;
    function Get_prAddTaxType: WordBool; safecall;
    procedure Set_prAddTaxType(Value: WordBool); safecall;
    function Get_prTaxRate1: SYSINT; safecall;
    procedure Set_prTaxRate1(Value: SYSINT); safecall;
    function Get_prTaxRate2: SYSINT; safecall;
    procedure Set_prTaxRate2(Value: SYSINT); safecall;
    function Get_prTaxRate3: SYSINT; safecall;
    procedure Set_prTaxRate3(Value: SYSINT); safecall;
    function Get_prTaxRate4: SYSINT; safecall;
    procedure Set_prTaxRate4(Value: SYSINT); safecall;
    function Get_prTaxRate5: SYSINT; safecall;
    procedure Set_prTaxRate5(Value: SYSINT); safecall;
    function Get_prTaxRate6: SYSINT; safecall;
    function Get_prUsedAdditionalFee: WordBool; safecall;
    procedure Set_prUsedAdditionalFee(Value: WordBool); safecall;
    function Get_prAddFeeRate1: SYSINT; safecall;
    procedure Set_prAddFeeRate1(Value: SYSINT); safecall;
    function Get_prAddFeeRate2: SYSINT; safecall;
    procedure Set_prAddFeeRate2(Value: SYSINT); safecall;
    function Get_prAddFeeRate3: SYSINT; safecall;
    procedure Set_prAddFeeRate3(Value: SYSINT); safecall;
    function Get_prAddFeeRate4: SYSINT; safecall;
    procedure Set_prAddFeeRate4(Value: SYSINT); safecall;
    function Get_prAddFeeRate5: SYSINT; safecall;
    procedure Set_prAddFeeRate5(Value: SYSINT); safecall;
    function Get_prAddFeeRate6: SYSINT; safecall;
    procedure Set_prAddFeeRate6(Value: SYSINT); safecall;
    function Get_prTaxOnAddFee1: WordBool; safecall;
    procedure Set_prTaxOnAddFee1(Value: WordBool); safecall;
    function Get_prTaxOnAddFee2: WordBool; safecall;
    procedure Set_prTaxOnAddFee2(Value: WordBool); safecall;
    function Get_prTaxOnAddFee3: WordBool; safecall;
    procedure Set_prTaxOnAddFee3(Value: WordBool); safecall;
    function Get_prTaxOnAddFee4: WordBool; safecall;
    procedure Set_prTaxOnAddFee4(Value: WordBool); safecall;
    function Get_prTaxOnAddFee5: WordBool; safecall;
    procedure Set_prTaxOnAddFee5(Value: WordBool); safecall;
    function Get_prTaxOnAddFee6: WordBool; safecall;
    procedure Set_prTaxOnAddFee6(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice1: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice1(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice2: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice2(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice3: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice3(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice4: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice4(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice5: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice5(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice6: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice6(Value: WordBool); safecall;
    function Get_prNamePaymentForm1: WideString; safecall;
    function Get_prNamePaymentForm2: WideString; safecall;
    function Get_prNamePaymentForm3: WideString; safecall;
    function Get_prNamePaymentForm4: WideString; safecall;
    function Get_prNamePaymentForm5: WideString; safecall;
    function Get_prNamePaymentForm6: WideString; safecall;
    function Get_prNamePaymentForm7: WideString; safecall;
    function Get_prNamePaymentForm8: WideString; safecall;
    function Get_prNamePaymentForm9: WideString; safecall;
    function Get_prNamePaymentForm10: WideString; safecall;
    function Get_prSerialNumber: WideString; safecall;
    function Get_prFiscalNumber: WideString; safecall;
    function Get_prTaxNumber: WideString; safecall;
    function Get_prDateFiscalization: TDateTime; safecall;
    function Get_prDateFiscalizationStr: WideString; safecall;
    function Get_prTimeFiscalization: TDateTime; safecall;
    function Get_prTimeFiscalizationStr: WideString; safecall;
    function Get_prHeadLine1: WideString; safecall;
    function Get_prHeadLine2: WideString; safecall;
    function Get_prHeadLine3: WideString; safecall;
    function Get_prHardwareVersion: WideString; safecall;
    function Get_prItemName: WideString; safecall;
    function Get_prItemPrice: SYSINT; safecall;
    function Get_prItemSaleQuantity: SYSINT; safecall;
    function Get_prItemSaleQtyPrecision: Byte; safecall;
    function Get_prItemTax: Byte; safecall;
    function Get_prItemSaleSum: Int64; safecall;
    function Get_prItemSaleSumStr: WideString; safecall;
    function Get_prItemRefundQuantity: SYSINT; safecall;
    function Get_prItemRefundQtyPrecision: Byte; safecall;
    function Get_prItemRefundSum: Int64; safecall;
    function Get_prItemRefundSumStr: WideString; safecall;
    function Get_prItemCostStr: WideString; safecall;
    function Get_prSumDiscountStr: WideString; safecall;
    function Get_prSumMarkupStr: WideString; safecall;
    function Get_prSumTotalStr: WideString; safecall;
    function Get_prSumBalanceStr: WideString; safecall;
    function Get_prCurReceiptTax1Sum: LongWord; safecall;
    function Get_prCurReceiptTax2Sum: LongWord; safecall;
    function Get_prCurReceiptTax3Sum: LongWord; safecall;
    function Get_prCurReceiptTax4Sum: LongWord; safecall;
    function Get_prCurReceiptTax5Sum: LongWord; safecall;
    function Get_prCurReceiptTax6Sum: LongWord; safecall;
    function Get_prCurReceiptTax1SumStr: WideString; safecall;
    function Get_prCurReceiptTax2SumStr: WideString; safecall;
    function Get_prCurReceiptTax3SumStr: WideString; safecall;
    function Get_prCurReceiptTax4SumStr: WideString; safecall;
    function Get_prCurReceiptTax5SumStr: WideString; safecall;
    function Get_prCurReceiptTax6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm1Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm2Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm3Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm4Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm5Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm6Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm7Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm8Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm9Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm10Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm1SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm2SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm3SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm4SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm5SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm7SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm8SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm9SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm10SumStr: WideString; safecall;
    function Get_prPrinterError: WordBool; safecall;
    function Get_prTapeNearEnd: WordBool; safecall;
    function Get_prTapeEnded: WordBool; safecall;
    function Get_prDaySaleReceiptsCount: Word; safecall;
    function Get_prDaySaleReceiptsCountStr: WideString; safecall;
    function Get_prDayRefundReceiptsCount: Word; safecall;
    function Get_prDayRefundReceiptsCountStr: WideString; safecall;
    function Get_prDaySaleSumOnTax1: LongWord; safecall;
    function Get_prDaySaleSumOnTax2: LongWord; safecall;
    function Get_prDaySaleSumOnTax3: LongWord; safecall;
    function Get_prDaySaleSumOnTax4: LongWord; safecall;
    function Get_prDaySaleSumOnTax5: LongWord; safecall;
    function Get_prDaySaleSumOnTax6: LongWord; safecall;
    function Get_prDaySaleSumOnTax1Str: WideString; safecall;
    function Get_prDaySaleSumOnTax2Str: WideString; safecall;
    function Get_prDaySaleSumOnTax3Str: WideString; safecall;
    function Get_prDaySaleSumOnTax4Str: WideString; safecall;
    function Get_prDaySaleSumOnTax5Str: WideString; safecall;
    function Get_prDaySaleSumOnTax6Str: WideString; safecall;
    function Get_prDayRefundSumOnTax1: LongWord; safecall;
    function Get_prDayRefundSumOnTax2: LongWord; safecall;
    function Get_prDayRefundSumOnTax3: LongWord; safecall;
    function Get_prDayRefundSumOnTax4: LongWord; safecall;
    function Get_prDayRefundSumOnTax5: LongWord; safecall;
    function Get_prDayRefundSumOnTax6: LongWord; safecall;
    function Get_prDayRefundSumOnTax1Str: WideString; safecall;
    function Get_prDayRefundSumOnTax2Str: WideString; safecall;
    function Get_prDayRefundSumOnTax3Str: WideString; safecall;
    function Get_prDayRefundSumOnTax4Str: WideString; safecall;
    function Get_prDayRefundSumOnTax5Str: WideString; safecall;
    function Get_prDayRefundSumOnTax6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm1: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm2: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm3: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm4: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm5: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm6: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm7: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm8: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm9: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm10: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm1Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm2Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm3Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm4Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm5Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm7Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm8Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm9Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm10Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm1: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm2: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm3: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm4: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm5: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm6: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm7: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm8: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm9: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm10: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm1Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm2Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm3Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm4Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm5Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm6Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm7Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm8Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm9Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm10Str: WideString; safecall;
    function Get_prDayDiscountSumOnSales: LongWord; safecall;
    function Get_prDayDiscountSumOnSalesStr: WideString; safecall;
    function Get_prDayMarkupSumOnSales: LongWord; safecall;
    function Get_prDayMarkupSumOnSalesStr: WideString; safecall;
    function Get_prDayDiscountSumOnRefunds: LongWord; safecall;
    function Get_prDayDiscountSumOnRefundsStr: WideString; safecall;
    function Get_prDayMarkupSumOnRefunds: LongWord; safecall;
    function Get_prDayMarkupSumOnRefundsStr: WideString; safecall;
    function Get_prDayCashInSum: LongWord; safecall;
    function Get_prDayCashInSumStr: WideString; safecall;
    function Get_prDayCashOutSum: LongWord; safecall;
    function Get_prDayCashOutSumStr: WideString; safecall;
    function Get_prCurrentZReport: Word; safecall;
    function Get_prCurrentZReportStr: WideString; safecall;
    function Get_prDayEndDate: TDateTime; safecall;
    function Get_prDayEndDateStr: WideString; safecall;
    function Get_prDayEndTime: TDateTime; safecall;
    function Get_prDayEndTimeStr: WideString; safecall;
    function Get_prLastZReportDate: TDateTime; safecall;
    function Get_prLastZReportDateStr: WideString; safecall;
    function Get_prItemsCount: Word; safecall;
    function Get_prItemsCountStr: WideString; safecall;
    function Get_prDaySumAddTaxOfSale1: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale2: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale3: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale4: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale5: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale6: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale6Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund1: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund2: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund3: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund4: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund5: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund6: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund6Str: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsCount: Word; safecall;
    function Get_prDayAnnuledSaleReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsCount: Word; safecall;
    function Get_prDayAnnuledRefundReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledSaleReceiptsSumStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledRefundReceiptsSumStr: WideString; safecall;
    function Get_prDaySaleCancelingsCount: Word; safecall;
    function Get_prDaySaleCancelingsCountStr: WideString; safecall;
    function Get_prDayRefundCancelingsCount: Word; safecall;
    function Get_prDayRefundCancelingsCountStr: WideString; safecall;
    function Get_prDaySaleCancelingsSum: LongWord; safecall;
    function Get_prDaySaleCancelingsSumStr: WideString; safecall;
    function Get_prDayRefundCancelingsSum: LongWord; safecall;
    function Get_prDayRefundCancelingsSumStr: WideString; safecall;
    function Get_prCashDrawerSum: Int64; safecall;
    function Get_prCashDrawerSumStr: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prGetStatusByte: Byte; safecall;
    function Get_prGetResultByte: Byte; safecall;
    function Get_prGetReserveByte: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prCurReceiptItemCount: Byte; safecall;
    function Get_prUserPassword: Word; safecall;
    function Get_prUserPasswordStr: WideString; safecall;
    function Get_prPrintContrast: Byte; safecall;
    function Get_prFont9x17: WordBool; safecall;
    procedure Set_prFont9x17(Value: WordBool); safecall;
    function Get_prFontBold: WordBool; safecall;
    procedure Set_prFontBold(Value: WordBool); safecall;
    function Get_prFontSmall: WordBool; safecall;
    procedure Set_prFontSmall(Value: WordBool); safecall;
    function Get_prFontDoubleHeight: WordBool; safecall;
    procedure Set_prFontDoubleHeight(Value: WordBool); safecall;
    function Get_prFontDoubleWidth: WordBool; safecall;
    procedure Set_prFontDoubleWidth(Value: WordBool); safecall;
    function Get_prUDPDeviceListSize: Byte; safecall;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString; safecall;
    function Get_prUDPDeviceMAC(id: Byte): WideString; safecall;
    function Get_prUDPDeviceIP(id: Byte): WideString; safecall;
    function Get_prUDPDeviceTCPport(id: Byte): Word; safecall;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString; safecall;
    function Get_prRevizionID: Byte; safecall;
    function Get_prFPDriverMajorVersion: Byte; safecall;
    function Get_prFPDriverMinorVersion: Byte; safecall;
    function Get_prFPDriverReleaseVersion: Byte; safecall;
    function Get_prFPDriverBuildVersion: Byte; safecall;
    property glTapeAnalizer: WordBool read Get_glTapeAnalizer write Set_glTapeAnalizer;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property glVirtualPortOpened: WordBool read Get_glVirtualPortOpened;
    property glUseVirtualPort: WordBool read Get_glUseVirtualPort write Set_glUseVirtualPort;
    property stUseAdditionalTax: WordBool read Get_stUseAdditionalTax;
    property stUseAdditionalFee: WordBool read Get_stUseAdditionalFee;
    property stUseFontB: WordBool read Get_stUseFontB;
    property stUseTradeLogo: WordBool read Get_stUseTradeLogo;
    property stUseCutter: WordBool read Get_stUseCutter;
    property stRefundReceiptMode: WordBool read Get_stRefundReceiptMode;
    property stPaymentMode: WordBool read Get_stPaymentMode;
    property stFiscalMode: WordBool read Get_stFiscalMode;
    property stServiceReceiptMode: WordBool read Get_stServiceReceiptMode;
    property stOnlinePrintMode: WordBool read Get_stOnlinePrintMode;
    property stFailureLastCommand: WordBool read Get_stFailureLastCommand;
    property stFiscalDayIsOpened: WordBool read Get_stFiscalDayIsOpened;
    property stReceiptIsOpened: WordBool read Get_stReceiptIsOpened;
    property stCashDrawerIsOpened: WordBool read Get_stCashDrawerIsOpened;
    property stDisplayShowSumMode: WordBool read Get_stDisplayShowSumMode;
    property prItemCost: Int64 read Get_prItemCost;
    property prSumDiscount: Int64 read Get_prSumDiscount;
    property prSumMarkup: Int64 read Get_prSumMarkup;
    property prSumTotal: Int64 read Get_prSumTotal;
    property prSumBalance: Int64 read Get_prSumBalance;
    property prKSEFPacket: LongWord read Get_prKSEFPacket;
    property prKSEFPacketStr: WideString read Get_prKSEFPacketStr;
    property prModemError: Byte read Get_prModemError;
    property prCurrentDate: TDateTime read Get_prCurrentDate;
    property prCurrentDateStr: WideString read Get_prCurrentDateStr;
    property prCurrentTime: TDateTime read Get_prCurrentTime;
    property prCurrentTimeStr: WideString read Get_prCurrentTimeStr;
    property prTaxRatesCount: Byte read Get_prTaxRatesCount write Set_prTaxRatesCount;
    property prTaxRatesDate: TDateTime read Get_prTaxRatesDate;
    property prTaxRatesDateStr: WideString read Get_prTaxRatesDateStr;
    property prAddTaxType: WordBool read Get_prAddTaxType write Set_prAddTaxType;
    property prTaxRate1: SYSINT read Get_prTaxRate1 write Set_prTaxRate1;
    property prTaxRate2: SYSINT read Get_prTaxRate2 write Set_prTaxRate2;
    property prTaxRate3: SYSINT read Get_prTaxRate3 write Set_prTaxRate3;
    property prTaxRate4: SYSINT read Get_prTaxRate4 write Set_prTaxRate4;
    property prTaxRate5: SYSINT read Get_prTaxRate5 write Set_prTaxRate5;
    property prTaxRate6: SYSINT read Get_prTaxRate6;
    property prUsedAdditionalFee: WordBool read Get_prUsedAdditionalFee write Set_prUsedAdditionalFee;
    property prAddFeeRate1: SYSINT read Get_prAddFeeRate1 write Set_prAddFeeRate1;
    property prAddFeeRate2: SYSINT read Get_prAddFeeRate2 write Set_prAddFeeRate2;
    property prAddFeeRate3: SYSINT read Get_prAddFeeRate3 write Set_prAddFeeRate3;
    property prAddFeeRate4: SYSINT read Get_prAddFeeRate4 write Set_prAddFeeRate4;
    property prAddFeeRate5: SYSINT read Get_prAddFeeRate5 write Set_prAddFeeRate5;
    property prAddFeeRate6: SYSINT read Get_prAddFeeRate6 write Set_prAddFeeRate6;
    property prTaxOnAddFee1: WordBool read Get_prTaxOnAddFee1 write Set_prTaxOnAddFee1;
    property prTaxOnAddFee2: WordBool read Get_prTaxOnAddFee2 write Set_prTaxOnAddFee2;
    property prTaxOnAddFee3: WordBool read Get_prTaxOnAddFee3 write Set_prTaxOnAddFee3;
    property prTaxOnAddFee4: WordBool read Get_prTaxOnAddFee4 write Set_prTaxOnAddFee4;
    property prTaxOnAddFee5: WordBool read Get_prTaxOnAddFee5 write Set_prTaxOnAddFee5;
    property prTaxOnAddFee6: WordBool read Get_prTaxOnAddFee6 write Set_prTaxOnAddFee6;
    property prAddFeeOnRetailPrice1: WordBool read Get_prAddFeeOnRetailPrice1 write Set_prAddFeeOnRetailPrice1;
    property prAddFeeOnRetailPrice2: WordBool read Get_prAddFeeOnRetailPrice2 write Set_prAddFeeOnRetailPrice2;
    property prAddFeeOnRetailPrice3: WordBool read Get_prAddFeeOnRetailPrice3 write Set_prAddFeeOnRetailPrice3;
    property prAddFeeOnRetailPrice4: WordBool read Get_prAddFeeOnRetailPrice4 write Set_prAddFeeOnRetailPrice4;
    property prAddFeeOnRetailPrice5: WordBool read Get_prAddFeeOnRetailPrice5 write Set_prAddFeeOnRetailPrice5;
    property prAddFeeOnRetailPrice6: WordBool read Get_prAddFeeOnRetailPrice6 write Set_prAddFeeOnRetailPrice6;
    property prNamePaymentForm1: WideString read Get_prNamePaymentForm1;
    property prNamePaymentForm2: WideString read Get_prNamePaymentForm2;
    property prNamePaymentForm3: WideString read Get_prNamePaymentForm3;
    property prNamePaymentForm4: WideString read Get_prNamePaymentForm4;
    property prNamePaymentForm5: WideString read Get_prNamePaymentForm5;
    property prNamePaymentForm6: WideString read Get_prNamePaymentForm6;
    property prNamePaymentForm7: WideString read Get_prNamePaymentForm7;
    property prNamePaymentForm8: WideString read Get_prNamePaymentForm8;
    property prNamePaymentForm9: WideString read Get_prNamePaymentForm9;
    property prNamePaymentForm10: WideString read Get_prNamePaymentForm10;
    property prSerialNumber: WideString read Get_prSerialNumber;
    property prFiscalNumber: WideString read Get_prFiscalNumber;
    property prTaxNumber: WideString read Get_prTaxNumber;
    property prDateFiscalization: TDateTime read Get_prDateFiscalization;
    property prDateFiscalizationStr: WideString read Get_prDateFiscalizationStr;
    property prTimeFiscalization: TDateTime read Get_prTimeFiscalization;
    property prTimeFiscalizationStr: WideString read Get_prTimeFiscalizationStr;
    property prHeadLine1: WideString read Get_prHeadLine1;
    property prHeadLine2: WideString read Get_prHeadLine2;
    property prHeadLine3: WideString read Get_prHeadLine3;
    property prHardwareVersion: WideString read Get_prHardwareVersion;
    property prItemName: WideString read Get_prItemName;
    property prItemPrice: SYSINT read Get_prItemPrice;
    property prItemSaleQuantity: SYSINT read Get_prItemSaleQuantity;
    property prItemSaleQtyPrecision: Byte read Get_prItemSaleQtyPrecision;
    property prItemTax: Byte read Get_prItemTax;
    property prItemSaleSum: Int64 read Get_prItemSaleSum;
    property prItemSaleSumStr: WideString read Get_prItemSaleSumStr;
    property prItemRefundQuantity: SYSINT read Get_prItemRefundQuantity;
    property prItemRefundQtyPrecision: Byte read Get_prItemRefundQtyPrecision;
    property prItemRefundSum: Int64 read Get_prItemRefundSum;
    property prItemRefundSumStr: WideString read Get_prItemRefundSumStr;
    property prItemCostStr: WideString read Get_prItemCostStr;
    property prSumDiscountStr: WideString read Get_prSumDiscountStr;
    property prSumMarkupStr: WideString read Get_prSumMarkupStr;
    property prSumTotalStr: WideString read Get_prSumTotalStr;
    property prSumBalanceStr: WideString read Get_prSumBalanceStr;
    property prCurReceiptTax1Sum: LongWord read Get_prCurReceiptTax1Sum;
    property prCurReceiptTax2Sum: LongWord read Get_prCurReceiptTax2Sum;
    property prCurReceiptTax3Sum: LongWord read Get_prCurReceiptTax3Sum;
    property prCurReceiptTax4Sum: LongWord read Get_prCurReceiptTax4Sum;
    property prCurReceiptTax5Sum: LongWord read Get_prCurReceiptTax5Sum;
    property prCurReceiptTax6Sum: LongWord read Get_prCurReceiptTax6Sum;
    property prCurReceiptTax1SumStr: WideString read Get_prCurReceiptTax1SumStr;
    property prCurReceiptTax2SumStr: WideString read Get_prCurReceiptTax2SumStr;
    property prCurReceiptTax3SumStr: WideString read Get_prCurReceiptTax3SumStr;
    property prCurReceiptTax4SumStr: WideString read Get_prCurReceiptTax4SumStr;
    property prCurReceiptTax5SumStr: WideString read Get_prCurReceiptTax5SumStr;
    property prCurReceiptTax6SumStr: WideString read Get_prCurReceiptTax6SumStr;
    property prCurReceiptPayForm1Sum: LongWord read Get_prCurReceiptPayForm1Sum;
    property prCurReceiptPayForm2Sum: LongWord read Get_prCurReceiptPayForm2Sum;
    property prCurReceiptPayForm3Sum: LongWord read Get_prCurReceiptPayForm3Sum;
    property prCurReceiptPayForm4Sum: LongWord read Get_prCurReceiptPayForm4Sum;
    property prCurReceiptPayForm5Sum: LongWord read Get_prCurReceiptPayForm5Sum;
    property prCurReceiptPayForm6Sum: LongWord read Get_prCurReceiptPayForm6Sum;
    property prCurReceiptPayForm7Sum: LongWord read Get_prCurReceiptPayForm7Sum;
    property prCurReceiptPayForm8Sum: LongWord read Get_prCurReceiptPayForm8Sum;
    property prCurReceiptPayForm9Sum: LongWord read Get_prCurReceiptPayForm9Sum;
    property prCurReceiptPayForm10Sum: LongWord read Get_prCurReceiptPayForm10Sum;
    property prCurReceiptPayForm1SumStr: WideString read Get_prCurReceiptPayForm1SumStr;
    property prCurReceiptPayForm2SumStr: WideString read Get_prCurReceiptPayForm2SumStr;
    property prCurReceiptPayForm3SumStr: WideString read Get_prCurReceiptPayForm3SumStr;
    property prCurReceiptPayForm4SumStr: WideString read Get_prCurReceiptPayForm4SumStr;
    property prCurReceiptPayForm5SumStr: WideString read Get_prCurReceiptPayForm5SumStr;
    property prCurReceiptPayForm6SumStr: WideString read Get_prCurReceiptPayForm6SumStr;
    property prCurReceiptPayForm7SumStr: WideString read Get_prCurReceiptPayForm7SumStr;
    property prCurReceiptPayForm8SumStr: WideString read Get_prCurReceiptPayForm8SumStr;
    property prCurReceiptPayForm9SumStr: WideString read Get_prCurReceiptPayForm9SumStr;
    property prCurReceiptPayForm10SumStr: WideString read Get_prCurReceiptPayForm10SumStr;
    property prPrinterError: WordBool read Get_prPrinterError;
    property prTapeNearEnd: WordBool read Get_prTapeNearEnd;
    property prTapeEnded: WordBool read Get_prTapeEnded;
    property prDaySaleReceiptsCount: Word read Get_prDaySaleReceiptsCount;
    property prDaySaleReceiptsCountStr: WideString read Get_prDaySaleReceiptsCountStr;
    property prDayRefundReceiptsCount: Word read Get_prDayRefundReceiptsCount;
    property prDayRefundReceiptsCountStr: WideString read Get_prDayRefundReceiptsCountStr;
    property prDaySaleSumOnTax1: LongWord read Get_prDaySaleSumOnTax1;
    property prDaySaleSumOnTax2: LongWord read Get_prDaySaleSumOnTax2;
    property prDaySaleSumOnTax3: LongWord read Get_prDaySaleSumOnTax3;
    property prDaySaleSumOnTax4: LongWord read Get_prDaySaleSumOnTax4;
    property prDaySaleSumOnTax5: LongWord read Get_prDaySaleSumOnTax5;
    property prDaySaleSumOnTax6: LongWord read Get_prDaySaleSumOnTax6;
    property prDaySaleSumOnTax1Str: WideString read Get_prDaySaleSumOnTax1Str;
    property prDaySaleSumOnTax2Str: WideString read Get_prDaySaleSumOnTax2Str;
    property prDaySaleSumOnTax3Str: WideString read Get_prDaySaleSumOnTax3Str;
    property prDaySaleSumOnTax4Str: WideString read Get_prDaySaleSumOnTax4Str;
    property prDaySaleSumOnTax5Str: WideString read Get_prDaySaleSumOnTax5Str;
    property prDaySaleSumOnTax6Str: WideString read Get_prDaySaleSumOnTax6Str;
    property prDayRefundSumOnTax1: LongWord read Get_prDayRefundSumOnTax1;
    property prDayRefundSumOnTax2: LongWord read Get_prDayRefundSumOnTax2;
    property prDayRefundSumOnTax3: LongWord read Get_prDayRefundSumOnTax3;
    property prDayRefundSumOnTax4: LongWord read Get_prDayRefundSumOnTax4;
    property prDayRefundSumOnTax5: LongWord read Get_prDayRefundSumOnTax5;
    property prDayRefundSumOnTax6: LongWord read Get_prDayRefundSumOnTax6;
    property prDayRefundSumOnTax1Str: WideString read Get_prDayRefundSumOnTax1Str;
    property prDayRefundSumOnTax2Str: WideString read Get_prDayRefundSumOnTax2Str;
    property prDayRefundSumOnTax3Str: WideString read Get_prDayRefundSumOnTax3Str;
    property prDayRefundSumOnTax4Str: WideString read Get_prDayRefundSumOnTax4Str;
    property prDayRefundSumOnTax5Str: WideString read Get_prDayRefundSumOnTax5Str;
    property prDayRefundSumOnTax6Str: WideString read Get_prDayRefundSumOnTax6Str;
    property prDaySaleSumOnPayForm1: LongWord read Get_prDaySaleSumOnPayForm1;
    property prDaySaleSumOnPayForm2: LongWord read Get_prDaySaleSumOnPayForm2;
    property prDaySaleSumOnPayForm3: LongWord read Get_prDaySaleSumOnPayForm3;
    property prDaySaleSumOnPayForm4: LongWord read Get_prDaySaleSumOnPayForm4;
    property prDaySaleSumOnPayForm5: LongWord read Get_prDaySaleSumOnPayForm5;
    property prDaySaleSumOnPayForm6: LongWord read Get_prDaySaleSumOnPayForm6;
    property prDaySaleSumOnPayForm7: LongWord read Get_prDaySaleSumOnPayForm7;
    property prDaySaleSumOnPayForm8: LongWord read Get_prDaySaleSumOnPayForm8;
    property prDaySaleSumOnPayForm9: LongWord read Get_prDaySaleSumOnPayForm9;
    property prDaySaleSumOnPayForm10: LongWord read Get_prDaySaleSumOnPayForm10;
    property prDaySaleSumOnPayForm1Str: WideString read Get_prDaySaleSumOnPayForm1Str;
    property prDaySaleSumOnPayForm2Str: WideString read Get_prDaySaleSumOnPayForm2Str;
    property prDaySaleSumOnPayForm3Str: WideString read Get_prDaySaleSumOnPayForm3Str;
    property prDaySaleSumOnPayForm4Str: WideString read Get_prDaySaleSumOnPayForm4Str;
    property prDaySaleSumOnPayForm5Str: WideString read Get_prDaySaleSumOnPayForm5Str;
    property prDaySaleSumOnPayForm6Str: WideString read Get_prDaySaleSumOnPayForm6Str;
    property prDaySaleSumOnPayForm7Str: WideString read Get_prDaySaleSumOnPayForm7Str;
    property prDaySaleSumOnPayForm8Str: WideString read Get_prDaySaleSumOnPayForm8Str;
    property prDaySaleSumOnPayForm9Str: WideString read Get_prDaySaleSumOnPayForm9Str;
    property prDaySaleSumOnPayForm10Str: WideString read Get_prDaySaleSumOnPayForm10Str;
    property prDayRefundSumOnPayForm1: LongWord read Get_prDayRefundSumOnPayForm1;
    property prDayRefundSumOnPayForm2: LongWord read Get_prDayRefundSumOnPayForm2;
    property prDayRefundSumOnPayForm3: LongWord read Get_prDayRefundSumOnPayForm3;
    property prDayRefundSumOnPayForm4: LongWord read Get_prDayRefundSumOnPayForm4;
    property prDayRefundSumOnPayForm5: LongWord read Get_prDayRefundSumOnPayForm5;
    property prDayRefundSumOnPayForm6: LongWord read Get_prDayRefundSumOnPayForm6;
    property prDayRefundSumOnPayForm7: LongWord read Get_prDayRefundSumOnPayForm7;
    property prDayRefundSumOnPayForm8: LongWord read Get_prDayRefundSumOnPayForm8;
    property prDayRefundSumOnPayForm9: LongWord read Get_prDayRefundSumOnPayForm9;
    property prDayRefundSumOnPayForm10: LongWord read Get_prDayRefundSumOnPayForm10;
    property prDayRefundSumOnPayForm1Str: WideString read Get_prDayRefundSumOnPayForm1Str;
    property prDayRefundSumOnPayForm2Str: WideString read Get_prDayRefundSumOnPayForm2Str;
    property prDayRefundSumOnPayForm3Str: WideString read Get_prDayRefundSumOnPayForm3Str;
    property prDayRefundSumOnPayForm4Str: WideString read Get_prDayRefundSumOnPayForm4Str;
    property prDayRefundSumOnPayForm5Str: WideString read Get_prDayRefundSumOnPayForm5Str;
    property prDayRefundSumOnPayForm6Str: WideString read Get_prDayRefundSumOnPayForm6Str;
    property prDayRefundSumOnPayForm7Str: WideString read Get_prDayRefundSumOnPayForm7Str;
    property prDayRefundSumOnPayForm8Str: WideString read Get_prDayRefundSumOnPayForm8Str;
    property prDayRefundSumOnPayForm9Str: WideString read Get_prDayRefundSumOnPayForm9Str;
    property prDayRefundSumOnPayForm10Str: WideString read Get_prDayRefundSumOnPayForm10Str;
    property prDayDiscountSumOnSales: LongWord read Get_prDayDiscountSumOnSales;
    property prDayDiscountSumOnSalesStr: WideString read Get_prDayDiscountSumOnSalesStr;
    property prDayMarkupSumOnSales: LongWord read Get_prDayMarkupSumOnSales;
    property prDayMarkupSumOnSalesStr: WideString read Get_prDayMarkupSumOnSalesStr;
    property prDayDiscountSumOnRefunds: LongWord read Get_prDayDiscountSumOnRefunds;
    property prDayDiscountSumOnRefundsStr: WideString read Get_prDayDiscountSumOnRefundsStr;
    property prDayMarkupSumOnRefunds: LongWord read Get_prDayMarkupSumOnRefunds;
    property prDayMarkupSumOnRefundsStr: WideString read Get_prDayMarkupSumOnRefundsStr;
    property prDayCashInSum: LongWord read Get_prDayCashInSum;
    property prDayCashInSumStr: WideString read Get_prDayCashInSumStr;
    property prDayCashOutSum: LongWord read Get_prDayCashOutSum;
    property prDayCashOutSumStr: WideString read Get_prDayCashOutSumStr;
    property prCurrentZReport: Word read Get_prCurrentZReport;
    property prCurrentZReportStr: WideString read Get_prCurrentZReportStr;
    property prDayEndDate: TDateTime read Get_prDayEndDate;
    property prDayEndDateStr: WideString read Get_prDayEndDateStr;
    property prDayEndTime: TDateTime read Get_prDayEndTime;
    property prDayEndTimeStr: WideString read Get_prDayEndTimeStr;
    property prLastZReportDate: TDateTime read Get_prLastZReportDate;
    property prLastZReportDateStr: WideString read Get_prLastZReportDateStr;
    property prItemsCount: Word read Get_prItemsCount;
    property prItemsCountStr: WideString read Get_prItemsCountStr;
    property prDaySumAddTaxOfSale1: LongWord read Get_prDaySumAddTaxOfSale1;
    property prDaySumAddTaxOfSale2: LongWord read Get_prDaySumAddTaxOfSale2;
    property prDaySumAddTaxOfSale3: LongWord read Get_prDaySumAddTaxOfSale3;
    property prDaySumAddTaxOfSale4: LongWord read Get_prDaySumAddTaxOfSale4;
    property prDaySumAddTaxOfSale5: LongWord read Get_prDaySumAddTaxOfSale5;
    property prDaySumAddTaxOfSale6: LongWord read Get_prDaySumAddTaxOfSale6;
    property prDaySumAddTaxOfSale1Str: WideString read Get_prDaySumAddTaxOfSale1Str;
    property prDaySumAddTaxOfSale2Str: WideString read Get_prDaySumAddTaxOfSale2Str;
    property prDaySumAddTaxOfSale3Str: WideString read Get_prDaySumAddTaxOfSale3Str;
    property prDaySumAddTaxOfSale4Str: WideString read Get_prDaySumAddTaxOfSale4Str;
    property prDaySumAddTaxOfSale5Str: WideString read Get_prDaySumAddTaxOfSale5Str;
    property prDaySumAddTaxOfSale6Str: WideString read Get_prDaySumAddTaxOfSale6Str;
    property prDaySumAddTaxOfRefund1: LongWord read Get_prDaySumAddTaxOfRefund1;
    property prDaySumAddTaxOfRefund2: LongWord read Get_prDaySumAddTaxOfRefund2;
    property prDaySumAddTaxOfRefund3: LongWord read Get_prDaySumAddTaxOfRefund3;
    property prDaySumAddTaxOfRefund4: LongWord read Get_prDaySumAddTaxOfRefund4;
    property prDaySumAddTaxOfRefund5: LongWord read Get_prDaySumAddTaxOfRefund5;
    property prDaySumAddTaxOfRefund6: LongWord read Get_prDaySumAddTaxOfRefund6;
    property prDaySumAddTaxOfRefund1Str: WideString read Get_prDaySumAddTaxOfRefund1Str;
    property prDaySumAddTaxOfRefund2Str: WideString read Get_prDaySumAddTaxOfRefund2Str;
    property prDaySumAddTaxOfRefund3Str: WideString read Get_prDaySumAddTaxOfRefund3Str;
    property prDaySumAddTaxOfRefund4Str: WideString read Get_prDaySumAddTaxOfRefund4Str;
    property prDaySumAddTaxOfRefund5Str: WideString read Get_prDaySumAddTaxOfRefund5Str;
    property prDaySumAddTaxOfRefund6Str: WideString read Get_prDaySumAddTaxOfRefund6Str;
    property prDayAnnuledSaleReceiptsCount: Word read Get_prDayAnnuledSaleReceiptsCount;
    property prDayAnnuledSaleReceiptsCountStr: WideString read Get_prDayAnnuledSaleReceiptsCountStr;
    property prDayAnnuledRefundReceiptsCount: Word read Get_prDayAnnuledRefundReceiptsCount;
    property prDayAnnuledRefundReceiptsCountStr: WideString read Get_prDayAnnuledRefundReceiptsCountStr;
    property prDayAnnuledSaleReceiptsSum: LongWord read Get_prDayAnnuledSaleReceiptsSum;
    property prDayAnnuledSaleReceiptsSumStr: WideString read Get_prDayAnnuledSaleReceiptsSumStr;
    property prDayAnnuledRefundReceiptsSum: LongWord read Get_prDayAnnuledRefundReceiptsSum;
    property prDayAnnuledRefundReceiptsSumStr: WideString read Get_prDayAnnuledRefundReceiptsSumStr;
    property prDaySaleCancelingsCount: Word read Get_prDaySaleCancelingsCount;
    property prDaySaleCancelingsCountStr: WideString read Get_prDaySaleCancelingsCountStr;
    property prDayRefundCancelingsCount: Word read Get_prDayRefundCancelingsCount;
    property prDayRefundCancelingsCountStr: WideString read Get_prDayRefundCancelingsCountStr;
    property prDaySaleCancelingsSum: LongWord read Get_prDaySaleCancelingsSum;
    property prDaySaleCancelingsSumStr: WideString read Get_prDaySaleCancelingsSumStr;
    property prDayRefundCancelingsSum: LongWord read Get_prDayRefundCancelingsSum;
    property prDayRefundCancelingsSumStr: WideString read Get_prDayRefundCancelingsSumStr;
    property prCashDrawerSum: Int64 read Get_prCashDrawerSum;
    property prCashDrawerSumStr: WideString read Get_prCashDrawerSumStr;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prGetStatusByte: Byte read Get_prGetStatusByte;
    property prGetResultByte: Byte read Get_prGetResultByte;
    property prGetReserveByte: Byte read Get_prGetReserveByte;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prCurReceiptItemCount: Byte read Get_prCurReceiptItemCount;
    property prUserPassword: Word read Get_prUserPassword;
    property prUserPasswordStr: WideString read Get_prUserPasswordStr;
    property prPrintContrast: Byte read Get_prPrintContrast;
    property prFont9x17: WordBool read Get_prFont9x17 write Set_prFont9x17;
    property prFontBold: WordBool read Get_prFontBold write Set_prFontBold;
    property prFontSmall: WordBool read Get_prFontSmall write Set_prFontSmall;
    property prFontDoubleHeight: WordBool read Get_prFontDoubleHeight write Set_prFontDoubleHeight;
    property prFontDoubleWidth: WordBool read Get_prFontDoubleWidth write Set_prFontDoubleWidth;
    property prUDPDeviceListSize: Byte read Get_prUDPDeviceListSize;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte read Get_prRevizionID;
    property prFPDriverMajorVersion: Byte read Get_prFPDriverMajorVersion;
    property prFPDriverMinorVersion: Byte read Get_prFPDriverMinorVersion;
    property prFPDriverReleaseVersion: Byte read Get_prFPDriverReleaseVersion;
    property prFPDriverBuildVersion: Byte read Get_prFPDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_MF_09Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {00356DEF-AC8B-46A1-B477-4883345AC8CF}
// *********************************************************************//
  IICS_MF_09Disp = dispinterface
    ['{00356DEF-AC8B-46A1-B477-4883345AC8CF}']
    function FPInitialize: Integer; dispid 433;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; dispid 201;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; dispid 202;
    function FPClose: WordBool; dispid 203;
    function FPClaimUSBDevice: WordBool; dispid 564;
    function FPReleaseUSBDevice: WordBool; dispid 565;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; dispid 566;
    function FPTCPClose: WordBool; dispid 567;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; dispid 573;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; dispid 204;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; dispid 205;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT;
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 206;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; dispid 207;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 208;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; dispid 209;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; dispid 210;
    function FPPrintZeroReceipt: WordBool; dispid 211;
    function FPLineFeed: WordBool; dispid 212;
    function FPAnnulReceipt: WordBool; dispid 213;
    function FPCashIn(CashSum: SYSUINT): WordBool; dispid 214;
    function FPCashOut(CashSum: SYSUINT): WordBool; dispid 215;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; dispid 216;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; dispid 217;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; dispid 218;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; dispid 219;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; dispid 220;
    function FPGetCurrentDate: WordBool; dispid 221;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; dispid 222;
    function FPGetCurrentTime: WordBool; dispid 223;
    function FPOpenCashDrawer(Duration: Word): WordBool; dispid 224;
    function FPPrintHardwareVersion: WordBool; dispid 225;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; dispid 226;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; dispid 227;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; dispid 228;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; dispid 229;
    function FPOnlineModeSwitch: WordBool; dispid 230;
    function FPCustomerDisplayModeSwitch: WordBool; dispid 231;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; dispid 232;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; dispid 233;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; dispid 234;
    function FPCloseServiceReport: WordBool; dispid 235;
    function FPEnableLogo(ProgPassword: Word): WordBool; dispid 236;
    function FPDisableLogo(ProgPassword: Word): WordBool; dispid 237;
    function FPSetTaxRates(ProgPassword: Word): WordBool; dispid 238;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; dispid 239;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; dispid 240;
    function FPMakeXReport(ReportPassword: Word): WordBool; dispid 241;
    function FPMakeZReport(ReportPassword: Word): WordBool; dispid 242;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; dispid 243;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; dispid 244;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; dispid 245;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; dispid 246;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; dispid 247;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; dispid 248;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; dispid 249;
    function FPCutterModeSwitch: WordBool; dispid 250;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; dispid 251;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; dispid 539;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; dispid 252;
    function FPGetPaymentFormNames: WordBool; dispid 435;
    function FPGetCurrentStatus: WordBool; dispid 440;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; dispid 442;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; dispid 443;
    function FPGetCashDrawerSum: WordBool; dispid 444;
    function FPGetDayReportProperties: WordBool; dispid 445;
    function FPGetTaxRates: WordBool; dispid 446;
    function FPGetItemData(ItemCode: Int64): WordBool; dispid 447;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; dispid 448;
    function FPGetDayReportData: WordBool; dispid 449;
    function FPGetCurrentReceiptData: WordBool; dispid 450;
    function FPGetDayCorrectionsData: WordBool; dispid 452;
    function FPGetDaySumOfAddTaxes: WordBool; dispid 453;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; dispid 454;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; dispid 455;
    function FPPrintModemStatus: WordBool; dispid 456;
    function FPGetUserPassword(UserID: Byte): WordBool; dispid 535;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; dispid 548;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; dispid 549;
    function FPSetContrast(Value: Byte): WordBool; dispid 540;
    function FPGetContrast: WordBool; dispid 541;
    function FPGetRevizionID: WordBool; dispid 550;
    property glTapeAnalizer: WordBool dispid 253;
    property glPropertiesAutoUpdateMode: WordBool dispid 254;
    property glCodepageOEM: WordBool dispid 255;
    property glLangID: Byte dispid 256;
    property glVirtualPortOpened: WordBool readonly dispid 562;
    property glUseVirtualPort: WordBool dispid 563;
    property stUseAdditionalTax: WordBool readonly dispid 415;
    property stUseAdditionalFee: WordBool readonly dispid 416;
    property stUseFontB: WordBool readonly dispid 417;
    property stUseTradeLogo: WordBool readonly dispid 418;
    property stUseCutter: WordBool readonly dispid 419;
    property stRefundReceiptMode: WordBool readonly dispid 420;
    property stPaymentMode: WordBool readonly dispid 421;
    property stFiscalMode: WordBool readonly dispid 422;
    property stServiceReceiptMode: WordBool readonly dispid 423;
    property stOnlinePrintMode: WordBool readonly dispid 424;
    property stFailureLastCommand: WordBool readonly dispid 425;
    property stFiscalDayIsOpened: WordBool readonly dispid 426;
    property stReceiptIsOpened: WordBool readonly dispid 427;
    property stCashDrawerIsOpened: WordBool readonly dispid 428;
    property stDisplayShowSumMode: WordBool readonly dispid 441;
    property prItemCost: Int64 readonly dispid 257;
    property prSumDiscount: Int64 readonly dispid 258;
    property prSumMarkup: Int64 readonly dispid 259;
    property prSumTotal: Int64 readonly dispid 260;
    property prSumBalance: Int64 readonly dispid 261;
    property prKSEFPacket: LongWord readonly dispid 262;
    property prKSEFPacketStr: WideString readonly dispid 538;
    property prModemError: Byte readonly dispid 263;
    property prCurrentDate: TDateTime readonly dispid 264;
    property prCurrentDateStr: WideString readonly dispid 265;
    property prCurrentTime: TDateTime readonly dispid 266;
    property prCurrentTimeStr: WideString readonly dispid 267;
    property prTaxRatesCount: Byte dispid 268;
    property prTaxRatesDate: TDateTime readonly dispid 269;
    property prTaxRatesDateStr: WideString readonly dispid 270;
    property prAddTaxType: WordBool dispid 271;
    property prTaxRate1: SYSINT dispid 272;
    property prTaxRate2: SYSINT dispid 273;
    property prTaxRate3: SYSINT dispid 274;
    property prTaxRate4: SYSINT dispid 275;
    property prTaxRate5: SYSINT dispid 276;
    property prTaxRate6: SYSINT readonly dispid 277;
    property prUsedAdditionalFee: WordBool dispid 278;
    property prAddFeeRate1: SYSINT dispid 279;
    property prAddFeeRate2: SYSINT dispid 280;
    property prAddFeeRate3: SYSINT dispid 281;
    property prAddFeeRate4: SYSINT dispid 282;
    property prAddFeeRate5: SYSINT dispid 283;
    property prAddFeeRate6: SYSINT dispid 284;
    property prTaxOnAddFee1: WordBool dispid 285;
    property prTaxOnAddFee2: WordBool dispid 286;
    property prTaxOnAddFee3: WordBool dispid 287;
    property prTaxOnAddFee4: WordBool dispid 288;
    property prTaxOnAddFee5: WordBool dispid 289;
    property prTaxOnAddFee6: WordBool dispid 290;
    property prAddFeeOnRetailPrice1: WordBool dispid 556;
    property prAddFeeOnRetailPrice2: WordBool dispid 557;
    property prAddFeeOnRetailPrice3: WordBool dispid 558;
    property prAddFeeOnRetailPrice4: WordBool dispid 559;
    property prAddFeeOnRetailPrice5: WordBool dispid 560;
    property prAddFeeOnRetailPrice6: WordBool dispid 561;
    property prNamePaymentForm1: WideString readonly dispid 291;
    property prNamePaymentForm2: WideString readonly dispid 292;
    property prNamePaymentForm3: WideString readonly dispid 293;
    property prNamePaymentForm4: WideString readonly dispid 294;
    property prNamePaymentForm5: WideString readonly dispid 295;
    property prNamePaymentForm6: WideString readonly dispid 296;
    property prNamePaymentForm7: WideString readonly dispid 297;
    property prNamePaymentForm8: WideString readonly dispid 298;
    property prNamePaymentForm9: WideString readonly dispid 299;
    property prNamePaymentForm10: WideString readonly dispid 300;
    property prSerialNumber: WideString readonly dispid 301;
    property prFiscalNumber: WideString readonly dispid 302;
    property prTaxNumber: WideString readonly dispid 303;
    property prDateFiscalization: TDateTime readonly dispid 304;
    property prDateFiscalizationStr: WideString readonly dispid 305;
    property prTimeFiscalization: TDateTime readonly dispid 306;
    property prTimeFiscalizationStr: WideString readonly dispid 307;
    property prHeadLine1: WideString readonly dispid 308;
    property prHeadLine2: WideString readonly dispid 309;
    property prHeadLine3: WideString readonly dispid 310;
    property prHardwareVersion: WideString readonly dispid 311;
    property prItemName: WideString readonly dispid 312;
    property prItemPrice: SYSINT readonly dispid 313;
    property prItemSaleQuantity: SYSINT readonly dispid 314;
    property prItemSaleQtyPrecision: Byte readonly dispid 315;
    property prItemTax: Byte readonly dispid 316;
    property prItemSaleSum: Int64 readonly dispid 317;
    property prItemSaleSumStr: WideString readonly dispid 318;
    property prItemRefundQuantity: SYSINT readonly dispid 319;
    property prItemRefundQtyPrecision: Byte readonly dispid 320;
    property prItemRefundSum: Int64 readonly dispid 321;
    property prItemRefundSumStr: WideString readonly dispid 322;
    property prItemCostStr: WideString readonly dispid 323;
    property prSumDiscountStr: WideString readonly dispid 324;
    property prSumMarkupStr: WideString readonly dispid 325;
    property prSumTotalStr: WideString readonly dispid 326;
    property prSumBalanceStr: WideString readonly dispid 327;
    property prCurReceiptTax1Sum: LongWord readonly dispid 328;
    property prCurReceiptTax2Sum: LongWord readonly dispid 329;
    property prCurReceiptTax3Sum: LongWord readonly dispid 330;
    property prCurReceiptTax4Sum: LongWord readonly dispid 331;
    property prCurReceiptTax5Sum: LongWord readonly dispid 332;
    property prCurReceiptTax6Sum: LongWord readonly dispid 333;
    property prCurReceiptTax1SumStr: WideString readonly dispid 457;
    property prCurReceiptTax2SumStr: WideString readonly dispid 458;
    property prCurReceiptTax3SumStr: WideString readonly dispid 459;
    property prCurReceiptTax4SumStr: WideString readonly dispid 460;
    property prCurReceiptTax5SumStr: WideString readonly dispid 461;
    property prCurReceiptTax6SumStr: WideString readonly dispid 462;
    property prCurReceiptPayForm1Sum: LongWord readonly dispid 334;
    property prCurReceiptPayForm2Sum: LongWord readonly dispid 335;
    property prCurReceiptPayForm3Sum: LongWord readonly dispid 336;
    property prCurReceiptPayForm4Sum: LongWord readonly dispid 337;
    property prCurReceiptPayForm5Sum: LongWord readonly dispid 338;
    property prCurReceiptPayForm6Sum: LongWord readonly dispid 339;
    property prCurReceiptPayForm7Sum: LongWord readonly dispid 340;
    property prCurReceiptPayForm8Sum: LongWord readonly dispid 341;
    property prCurReceiptPayForm9Sum: LongWord readonly dispid 342;
    property prCurReceiptPayForm10Sum: LongWord readonly dispid 343;
    property prCurReceiptPayForm1SumStr: WideString readonly dispid 463;
    property prCurReceiptPayForm2SumStr: WideString readonly dispid 464;
    property prCurReceiptPayForm3SumStr: WideString readonly dispid 465;
    property prCurReceiptPayForm4SumStr: WideString readonly dispid 466;
    property prCurReceiptPayForm5SumStr: WideString readonly dispid 467;
    property prCurReceiptPayForm6SumStr: WideString readonly dispid 468;
    property prCurReceiptPayForm7SumStr: WideString readonly dispid 469;
    property prCurReceiptPayForm8SumStr: WideString readonly dispid 470;
    property prCurReceiptPayForm9SumStr: WideString readonly dispid 471;
    property prCurReceiptPayForm10SumStr: WideString readonly dispid 472;
    property prPrinterError: WordBool readonly dispid 344;
    property prTapeNearEnd: WordBool readonly dispid 345;
    property prTapeEnded: WordBool readonly dispid 346;
    property prDaySaleReceiptsCount: Word readonly dispid 347;
    property prDaySaleReceiptsCountStr: WideString readonly dispid 473;
    property prDayRefundReceiptsCount: Word readonly dispid 348;
    property prDayRefundReceiptsCountStr: WideString readonly dispid 474;
    property prDaySaleSumOnTax1: LongWord readonly dispid 349;
    property prDaySaleSumOnTax2: LongWord readonly dispid 350;
    property prDaySaleSumOnTax3: LongWord readonly dispid 351;
    property prDaySaleSumOnTax4: LongWord readonly dispid 352;
    property prDaySaleSumOnTax5: LongWord readonly dispid 353;
    property prDaySaleSumOnTax6: LongWord readonly dispid 354;
    property prDaySaleSumOnTax1Str: WideString readonly dispid 475;
    property prDaySaleSumOnTax2Str: WideString readonly dispid 476;
    property prDaySaleSumOnTax3Str: WideString readonly dispid 477;
    property prDaySaleSumOnTax4Str: WideString readonly dispid 478;
    property prDaySaleSumOnTax5Str: WideString readonly dispid 479;
    property prDaySaleSumOnTax6Str: WideString readonly dispid 480;
    property prDayRefundSumOnTax1: LongWord readonly dispid 355;
    property prDayRefundSumOnTax2: LongWord readonly dispid 356;
    property prDayRefundSumOnTax3: LongWord readonly dispid 357;
    property prDayRefundSumOnTax4: LongWord readonly dispid 358;
    property prDayRefundSumOnTax5: LongWord readonly dispid 359;
    property prDayRefundSumOnTax6: LongWord readonly dispid 360;
    property prDayRefundSumOnTax1Str: WideString readonly dispid 481;
    property prDayRefundSumOnTax2Str: WideString readonly dispid 482;
    property prDayRefundSumOnTax3Str: WideString readonly dispid 483;
    property prDayRefundSumOnTax4Str: WideString readonly dispid 484;
    property prDayRefundSumOnTax5Str: WideString readonly dispid 485;
    property prDayRefundSumOnTax6Str: WideString readonly dispid 486;
    property prDaySaleSumOnPayForm1: LongWord readonly dispid 361;
    property prDaySaleSumOnPayForm2: LongWord readonly dispid 362;
    property prDaySaleSumOnPayForm3: LongWord readonly dispid 363;
    property prDaySaleSumOnPayForm4: LongWord readonly dispid 364;
    property prDaySaleSumOnPayForm5: LongWord readonly dispid 365;
    property prDaySaleSumOnPayForm6: LongWord readonly dispid 366;
    property prDaySaleSumOnPayForm7: LongWord readonly dispid 367;
    property prDaySaleSumOnPayForm8: LongWord readonly dispid 368;
    property prDaySaleSumOnPayForm9: LongWord readonly dispid 369;
    property prDaySaleSumOnPayForm10: LongWord readonly dispid 370;
    property prDaySaleSumOnPayForm1Str: WideString readonly dispid 487;
    property prDaySaleSumOnPayForm2Str: WideString readonly dispid 488;
    property prDaySaleSumOnPayForm3Str: WideString readonly dispid 489;
    property prDaySaleSumOnPayForm4Str: WideString readonly dispid 490;
    property prDaySaleSumOnPayForm5Str: WideString readonly dispid 491;
    property prDaySaleSumOnPayForm6Str: WideString readonly dispid 492;
    property prDaySaleSumOnPayForm7Str: WideString readonly dispid 493;
    property prDaySaleSumOnPayForm8Str: WideString readonly dispid 494;
    property prDaySaleSumOnPayForm9Str: WideString readonly dispid 495;
    property prDaySaleSumOnPayForm10Str: WideString readonly dispid 496;
    property prDayRefundSumOnPayForm1: LongWord readonly dispid 371;
    property prDayRefundSumOnPayForm2: LongWord readonly dispid 372;
    property prDayRefundSumOnPayForm3: LongWord readonly dispid 373;
    property prDayRefundSumOnPayForm4: LongWord readonly dispid 374;
    property prDayRefundSumOnPayForm5: LongWord readonly dispid 375;
    property prDayRefundSumOnPayForm6: LongWord readonly dispid 376;
    property prDayRefundSumOnPayForm7: LongWord readonly dispid 377;
    property prDayRefundSumOnPayForm8: LongWord readonly dispid 378;
    property prDayRefundSumOnPayForm9: LongWord readonly dispid 379;
    property prDayRefundSumOnPayForm10: LongWord readonly dispid 380;
    property prDayRefundSumOnPayForm1Str: WideString readonly dispid 497;
    property prDayRefundSumOnPayForm2Str: WideString readonly dispid 498;
    property prDayRefundSumOnPayForm3Str: WideString readonly dispid 499;
    property prDayRefundSumOnPayForm4Str: WideString readonly dispid 500;
    property prDayRefundSumOnPayForm5Str: WideString readonly dispid 501;
    property prDayRefundSumOnPayForm6Str: WideString readonly dispid 502;
    property prDayRefundSumOnPayForm7Str: WideString readonly dispid 503;
    property prDayRefundSumOnPayForm8Str: WideString readonly dispid 504;
    property prDayRefundSumOnPayForm9Str: WideString readonly dispid 505;
    property prDayRefundSumOnPayForm10Str: WideString readonly dispid 506;
    property prDayDiscountSumOnSales: LongWord readonly dispid 381;
    property prDayDiscountSumOnSalesStr: WideString readonly dispid 507;
    property prDayMarkupSumOnSales: LongWord readonly dispid 382;
    property prDayMarkupSumOnSalesStr: WideString readonly dispid 508;
    property prDayDiscountSumOnRefunds: LongWord readonly dispid 383;
    property prDayDiscountSumOnRefundsStr: WideString readonly dispid 509;
    property prDayMarkupSumOnRefunds: LongWord readonly dispid 384;
    property prDayMarkupSumOnRefundsStr: WideString readonly dispid 510;
    property prDayCashInSum: LongWord readonly dispid 385;
    property prDayCashInSumStr: WideString readonly dispid 511;
    property prDayCashOutSum: LongWord readonly dispid 386;
    property prDayCashOutSumStr: WideString readonly dispid 512;
    property prCurrentZReport: Word readonly dispid 387;
    property prCurrentZReportStr: WideString readonly dispid 513;
    property prDayEndDate: TDateTime readonly dispid 388;
    property prDayEndDateStr: WideString readonly dispid 389;
    property prDayEndTime: TDateTime readonly dispid 390;
    property prDayEndTimeStr: WideString readonly dispid 391;
    property prLastZReportDate: TDateTime readonly dispid 392;
    property prLastZReportDateStr: WideString readonly dispid 393;
    property prItemsCount: Word readonly dispid 394;
    property prItemsCountStr: WideString readonly dispid 514;
    property prDaySumAddTaxOfSale1: LongWord readonly dispid 395;
    property prDaySumAddTaxOfSale2: LongWord readonly dispid 396;
    property prDaySumAddTaxOfSale3: LongWord readonly dispid 397;
    property prDaySumAddTaxOfSale4: LongWord readonly dispid 398;
    property prDaySumAddTaxOfSale5: LongWord readonly dispid 399;
    property prDaySumAddTaxOfSale6: LongWord readonly dispid 400;
    property prDaySumAddTaxOfSale1Str: WideString readonly dispid 515;
    property prDaySumAddTaxOfSale2Str: WideString readonly dispid 516;
    property prDaySumAddTaxOfSale3Str: WideString readonly dispid 517;
    property prDaySumAddTaxOfSale4Str: WideString readonly dispid 518;
    property prDaySumAddTaxOfSale5Str: WideString readonly dispid 519;
    property prDaySumAddTaxOfSale6Str: WideString readonly dispid 520;
    property prDaySumAddTaxOfRefund1: LongWord readonly dispid 401;
    property prDaySumAddTaxOfRefund2: LongWord readonly dispid 402;
    property prDaySumAddTaxOfRefund3: LongWord readonly dispid 403;
    property prDaySumAddTaxOfRefund4: LongWord readonly dispid 404;
    property prDaySumAddTaxOfRefund5: LongWord readonly dispid 405;
    property prDaySumAddTaxOfRefund6: LongWord readonly dispid 406;
    property prDaySumAddTaxOfRefund1Str: WideString readonly dispid 521;
    property prDaySumAddTaxOfRefund2Str: WideString readonly dispid 522;
    property prDaySumAddTaxOfRefund3Str: WideString readonly dispid 523;
    property prDaySumAddTaxOfRefund4Str: WideString readonly dispid 524;
    property prDaySumAddTaxOfRefund5Str: WideString readonly dispid 525;
    property prDaySumAddTaxOfRefund6Str: WideString readonly dispid 526;
    property prDayAnnuledSaleReceiptsCount: Word readonly dispid 407;
    property prDayAnnuledSaleReceiptsCountStr: WideString readonly dispid 527;
    property prDayAnnuledRefundReceiptsCount: Word readonly dispid 408;
    property prDayAnnuledRefundReceiptsCountStr: WideString readonly dispid 528;
    property prDayAnnuledSaleReceiptsSum: LongWord readonly dispid 409;
    property prDayAnnuledSaleReceiptsSumStr: WideString readonly dispid 529;
    property prDayAnnuledRefundReceiptsSum: LongWord readonly dispid 410;
    property prDayAnnuledRefundReceiptsSumStr: WideString readonly dispid 530;
    property prDaySaleCancelingsCount: Word readonly dispid 411;
    property prDaySaleCancelingsCountStr: WideString readonly dispid 531;
    property prDayRefundCancelingsCount: Word readonly dispid 412;
    property prDayRefundCancelingsCountStr: WideString readonly dispid 532;
    property prDaySaleCancelingsSum: LongWord readonly dispid 413;
    property prDaySaleCancelingsSumStr: WideString readonly dispid 533;
    property prDayRefundCancelingsSum: LongWord readonly dispid 414;
    property prDayRefundCancelingsSumStr: WideString readonly dispid 534;
    property prCashDrawerSum: Int64 readonly dispid 429;
    property prCashDrawerSumStr: WideString readonly dispid 430;
    property prRepeatCount: Byte dispid 431;
    property prLogRecording: WordBool dispid 432;
    property prAnswerWaiting: Byte dispid 434;
    property prGetStatusByte: Byte readonly dispid 436;
    property prGetResultByte: Byte readonly dispid 437;
    property prGetReserveByte: Byte readonly dispid 438;
    property prGetErrorText: WideString readonly dispid 439;
    property prCurReceiptItemCount: Byte readonly dispid 451;
    property prUserPassword: Word readonly dispid 536;
    property prUserPasswordStr: WideString readonly dispid 537;
    property prPrintContrast: Byte readonly dispid 542;
    property prFont9x17: WordBool dispid 543;
    property prFontBold: WordBool dispid 544;
    property prFontSmall: WordBool dispid 545;
    property prFontDoubleHeight: WordBool dispid 546;
    property prFontDoubleWidth: WordBool dispid 547;
    property prUDPDeviceListSize: Byte readonly dispid 568;
    property prUDPDeviceSerialNumber[id: Byte]: WideString readonly dispid 569;
    property prUDPDeviceMAC[id: Byte]: WideString readonly dispid 570;
    property prUDPDeviceIP[id: Byte]: WideString readonly dispid 571;
    property prUDPDeviceTCPport[id: Byte]: Word readonly dispid 572;
    property prUDPDeviceTCPportStr[id: Byte]: WideString readonly dispid 574;
    property prRevizionID: Byte readonly dispid 551;
    property prFPDriverMajorVersion: Byte readonly dispid 552;
    property prFPDriverMinorVersion: Byte readonly dispid 553;
    property prFPDriverReleaseVersion: Byte readonly dispid 554;
    property prFPDriverBuildVersion: Byte readonly dispid 555;
  end;

// *********************************************************************//
// Interface: IICS_MF_11
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2CCFE5E2-19DF-428F-9E82-BE55E7AEB567}
// *********************************************************************//
  IICS_MF_11 = interface(IDispatch)
    ['{2CCFE5E2-19DF-428F-9E82-BE55E7AEB567}']
    function FPInitialize: Integer; safecall;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; safecall;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; safecall;
    function FPClose: WordBool; safecall;
    function FPClaimUSBDevice: WordBool; safecall;
    function FPReleaseUSBDevice: WordBool; safecall;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; safecall;
    function FPTCPClose: WordBool; safecall;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; safecall;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; safecall;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; safecall;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; safecall;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; safecall;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT;
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; safecall;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; safecall;
    function FPPrintZeroReceipt: WordBool; safecall;
    function FPLineFeed: WordBool; safecall;
    function FPAnnulReceipt: WordBool; safecall;
    function FPCashIn(CashSum: SYSUINT): WordBool; safecall;
    function FPCashOut(CashSum: SYSUINT): WordBool; safecall;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; safecall;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; safecall;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; safecall;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; safecall;
    function FPGetCurrentDate: WordBool; safecall;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; safecall;
    function FPGetCurrentTime: WordBool; safecall;
    function FPOpenCashDrawer(Duration: Word): WordBool; safecall;
    function FPPrintHardwareVersion: WordBool; safecall;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; safecall;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; safecall;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; safecall;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; safecall;
    function FPOnlineModeSwitch: WordBool; safecall;
    function FPCustomerDisplayModeSwitch: WordBool; safecall;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; safecall;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; safecall;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; safecall;
    function FPCloseServiceReport: WordBool; safecall;
    function FPEnableLogo(ProgPassword: Word): WordBool; safecall;
    function FPDisableLogo(ProgPassword: Word): WordBool; safecall;
    function FPSetTaxRates(ProgPassword: Word): WordBool; safecall;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; safecall;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; safecall;
    function FPMakeXReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeZReport(ReportPassword: Word): WordBool; safecall;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; safecall;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; safecall;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; safecall;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; safecall;
    function FPCutterModeSwitch: WordBool; safecall;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; safecall;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; safecall;
    function FPGetPaymentFormNames: WordBool; safecall;
    function FPGetCurrentStatus: WordBool; safecall;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; safecall;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; safecall;
    function FPGetCashDrawerSum: WordBool; safecall;
    function FPGetDayReportProperties: WordBool; safecall;
    function FPGetTaxRates: WordBool; safecall;
    function FPGetItemData(ItemCode: Int64): WordBool; safecall;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; safecall;
    function FPGetDayReportData: WordBool; safecall;
    function FPGetCurrentReceiptData: WordBool; safecall;
    function FPGetDayCorrectionsData: WordBool; safecall;
    function FPGetDayPacketData: WordBool; safecall;
    function FPGetDaySumOfAddTaxes: WordBool; safecall;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; safecall;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; safecall;
    function FPPrintModemStatus: WordBool; safecall;
    function FPGetUserPassword(UserID: Byte): WordBool; safecall;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; safecall;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; safecall;
    function FPSetContrast(Value: Byte): WordBool; safecall;
    function FPGetContrast: WordBool; safecall;
    function FPGetRevizionID: WordBool; safecall;
    function Get_glTapeAnalizer: WordBool; safecall;
    procedure Set_glTapeAnalizer(Value: WordBool); safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_glVirtualPortOpened: WordBool; safecall;
    function Get_glUseVirtualPort: WordBool; safecall;
    procedure Set_glUseVirtualPort(Value: WordBool); safecall;
    function Get_stUseAdditionalTax: WordBool; safecall;
    function Get_stUseAdditionalFee: WordBool; safecall;
    function Get_stUseFontB: WordBool; safecall;
    function Get_stUseTradeLogo: WordBool; safecall;
    function Get_stUseCutter: WordBool; safecall;
    function Get_stRefundReceiptMode: WordBool; safecall;
    function Get_stPaymentMode: WordBool; safecall;
    function Get_stFiscalMode: WordBool; safecall;
    function Get_stServiceReceiptMode: WordBool; safecall;
    function Get_stOnlinePrintMode: WordBool; safecall;
    function Get_stFailureLastCommand: WordBool; safecall;
    function Get_stFiscalDayIsOpened: WordBool; safecall;
    function Get_stReceiptIsOpened: WordBool; safecall;
    function Get_stCashDrawerIsOpened: WordBool; safecall;
    function Get_stDisplayShowSumMode: WordBool; safecall;
    function Get_prItemCost: Int64; safecall;
    function Get_prSumDiscount: Int64; safecall;
    function Get_prSumMarkup: Int64; safecall;
    function Get_prSumTotal: Int64; safecall;
    function Get_prSumBalance: Int64; safecall;
    function Get_prKSEFPacket: LongWord; safecall;
    function Get_prKSEFPacketStr: WideString; safecall;
    function Get_prModemError: Byte; safecall;
    function Get_prCurrentDate: TDateTime; safecall;
    function Get_prCurrentDateStr: WideString; safecall;
    function Get_prCurrentTime: TDateTime; safecall;
    function Get_prCurrentTimeStr: WideString; safecall;
    function Get_prTaxRatesCount: Byte; safecall;
    procedure Set_prTaxRatesCount(Value: Byte); safecall;
    function Get_prTaxRatesDate: TDateTime; safecall;
    function Get_prTaxRatesDateStr: WideString; safecall;
    function Get_prAddTaxType: WordBool; safecall;
    procedure Set_prAddTaxType(Value: WordBool); safecall;
    function Get_prTaxRate1: SYSINT; safecall;
    procedure Set_prTaxRate1(Value: SYSINT); safecall;
    function Get_prTaxRate2: SYSINT; safecall;
    procedure Set_prTaxRate2(Value: SYSINT); safecall;
    function Get_prTaxRate3: SYSINT; safecall;
    procedure Set_prTaxRate3(Value: SYSINT); safecall;
    function Get_prTaxRate4: SYSINT; safecall;
    procedure Set_prTaxRate4(Value: SYSINT); safecall;
    function Get_prTaxRate5: SYSINT; safecall;
    procedure Set_prTaxRate5(Value: SYSINT); safecall;
    function Get_prTaxRate6: SYSINT; safecall;
    function Get_prUsedAdditionalFee: WordBool; safecall;
    procedure Set_prUsedAdditionalFee(Value: WordBool); safecall;
    function Get_prAddFeeRate1: SYSINT; safecall;
    procedure Set_prAddFeeRate1(Value: SYSINT); safecall;
    function Get_prAddFeeRate2: SYSINT; safecall;
    procedure Set_prAddFeeRate2(Value: SYSINT); safecall;
    function Get_prAddFeeRate3: SYSINT; safecall;
    procedure Set_prAddFeeRate3(Value: SYSINT); safecall;
    function Get_prAddFeeRate4: SYSINT; safecall;
    procedure Set_prAddFeeRate4(Value: SYSINT); safecall;
    function Get_prAddFeeRate5: SYSINT; safecall;
    procedure Set_prAddFeeRate5(Value: SYSINT); safecall;
    function Get_prAddFeeRate6: SYSINT; safecall;
    procedure Set_prAddFeeRate6(Value: SYSINT); safecall;
    function Get_prTaxOnAddFee1: WordBool; safecall;
    procedure Set_prTaxOnAddFee1(Value: WordBool); safecall;
    function Get_prTaxOnAddFee2: WordBool; safecall;
    procedure Set_prTaxOnAddFee2(Value: WordBool); safecall;
    function Get_prTaxOnAddFee3: WordBool; safecall;
    procedure Set_prTaxOnAddFee3(Value: WordBool); safecall;
    function Get_prTaxOnAddFee4: WordBool; safecall;
    procedure Set_prTaxOnAddFee4(Value: WordBool); safecall;
    function Get_prTaxOnAddFee5: WordBool; safecall;
    procedure Set_prTaxOnAddFee5(Value: WordBool); safecall;
    function Get_prTaxOnAddFee6: WordBool; safecall;
    procedure Set_prTaxOnAddFee6(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice1: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice1(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice2: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice2(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice3: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice3(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice4: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice4(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice5: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice5(Value: WordBool); safecall;
    function Get_prAddFeeOnRetailPrice6: WordBool; safecall;
    procedure Set_prAddFeeOnRetailPrice6(Value: WordBool); safecall;
    function Get_prNamePaymentForm1: WideString; safecall;
    function Get_prNamePaymentForm2: WideString; safecall;
    function Get_prNamePaymentForm3: WideString; safecall;
    function Get_prNamePaymentForm4: WideString; safecall;
    function Get_prNamePaymentForm5: WideString; safecall;
    function Get_prNamePaymentForm6: WideString; safecall;
    function Get_prNamePaymentForm7: WideString; safecall;
    function Get_prNamePaymentForm8: WideString; safecall;
    function Get_prNamePaymentForm9: WideString; safecall;
    function Get_prNamePaymentForm10: WideString; safecall;
    function Get_prSerialNumber: WideString; safecall;
    function Get_prFiscalNumber: WideString; safecall;
    function Get_prTaxNumber: WideString; safecall;
    function Get_prDateFiscalization: TDateTime; safecall;
    function Get_prDateFiscalizationStr: WideString; safecall;
    function Get_prTimeFiscalization: TDateTime; safecall;
    function Get_prTimeFiscalizationStr: WideString; safecall;
    function Get_prHeadLine1: WideString; safecall;
    function Get_prHeadLine2: WideString; safecall;
    function Get_prHeadLine3: WideString; safecall;
    function Get_prHardwareVersion: WideString; safecall;
    function Get_prItemName: WideString; safecall;
    function Get_prItemPrice: SYSINT; safecall;
    function Get_prItemSaleQuantity: SYSINT; safecall;
    function Get_prItemSaleQtyPrecision: Byte; safecall;
    function Get_prItemTax: Byte; safecall;
    function Get_prItemSaleSum: Int64; safecall;
    function Get_prItemSaleSumStr: WideString; safecall;
    function Get_prItemRefundQuantity: SYSINT; safecall;
    function Get_prItemRefundQtyPrecision: Byte; safecall;
    function Get_prItemRefundSum: Int64; safecall;
    function Get_prItemRefundSumStr: WideString; safecall;
    function Get_prItemCostStr: WideString; safecall;
    function Get_prSumDiscountStr: WideString; safecall;
    function Get_prSumMarkupStr: WideString; safecall;
    function Get_prSumTotalStr: WideString; safecall;
    function Get_prSumBalanceStr: WideString; safecall;
    function Get_prCurReceiptTax1Sum: LongWord; safecall;
    function Get_prCurReceiptTax2Sum: LongWord; safecall;
    function Get_prCurReceiptTax3Sum: LongWord; safecall;
    function Get_prCurReceiptTax4Sum: LongWord; safecall;
    function Get_prCurReceiptTax5Sum: LongWord; safecall;
    function Get_prCurReceiptTax6Sum: LongWord; safecall;
    function Get_prCurReceiptTax1SumStr: WideString; safecall;
    function Get_prCurReceiptTax2SumStr: WideString; safecall;
    function Get_prCurReceiptTax3SumStr: WideString; safecall;
    function Get_prCurReceiptTax4SumStr: WideString; safecall;
    function Get_prCurReceiptTax5SumStr: WideString; safecall;
    function Get_prCurReceiptTax6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm1Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm2Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm3Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm4Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm5Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm6Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm7Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm8Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm9Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm10Sum: LongWord; safecall;
    function Get_prCurReceiptPayForm1SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm2SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm3SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm4SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm5SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm6SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm7SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm8SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm9SumStr: WideString; safecall;
    function Get_prCurReceiptPayForm10SumStr: WideString; safecall;
    function Get_prPrinterError: WordBool; safecall;
    function Get_prTapeNearEnd: WordBool; safecall;
    function Get_prTapeEnded: WordBool; safecall;
    function Get_prDaySaleReceiptsCount: Word; safecall;
    function Get_prDaySaleReceiptsCountStr: WideString; safecall;
    function Get_prDayRefundReceiptsCount: Word; safecall;
    function Get_prDayRefundReceiptsCountStr: WideString; safecall;
    function Get_prDaySaleSumOnTax1: LongWord; safecall;
    function Get_prDaySaleSumOnTax2: LongWord; safecall;
    function Get_prDaySaleSumOnTax3: LongWord; safecall;
    function Get_prDaySaleSumOnTax4: LongWord; safecall;
    function Get_prDaySaleSumOnTax5: LongWord; safecall;
    function Get_prDaySaleSumOnTax6: LongWord; safecall;
    function Get_prDaySaleSumOnTax1Str: WideString; safecall;
    function Get_prDaySaleSumOnTax2Str: WideString; safecall;
    function Get_prDaySaleSumOnTax3Str: WideString; safecall;
    function Get_prDaySaleSumOnTax4Str: WideString; safecall;
    function Get_prDaySaleSumOnTax5Str: WideString; safecall;
    function Get_prDaySaleSumOnTax6Str: WideString; safecall;
    function Get_prDayRefundSumOnTax1: LongWord; safecall;
    function Get_prDayRefundSumOnTax2: LongWord; safecall;
    function Get_prDayRefundSumOnTax3: LongWord; safecall;
    function Get_prDayRefundSumOnTax4: LongWord; safecall;
    function Get_prDayRefundSumOnTax5: LongWord; safecall;
    function Get_prDayRefundSumOnTax6: LongWord; safecall;
    function Get_prDayRefundSumOnTax1Str: WideString; safecall;
    function Get_prDayRefundSumOnTax2Str: WideString; safecall;
    function Get_prDayRefundSumOnTax3Str: WideString; safecall;
    function Get_prDayRefundSumOnTax4Str: WideString; safecall;
    function Get_prDayRefundSumOnTax5Str: WideString; safecall;
    function Get_prDayRefundSumOnTax6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm1: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm2: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm3: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm4: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm5: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm6: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm7: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm8: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm9: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm10: LongWord; safecall;
    function Get_prDaySaleSumOnPayForm1Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm2Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm3Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm4Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm5Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm6Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm7Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm8Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm9Str: WideString; safecall;
    function Get_prDaySaleSumOnPayForm10Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm1: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm2: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm3: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm4: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm5: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm6: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm7: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm8: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm9: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm10: LongWord; safecall;
    function Get_prDayRefundSumOnPayForm1Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm2Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm3Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm4Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm5Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm6Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm7Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm8Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm9Str: WideString; safecall;
    function Get_prDayRefundSumOnPayForm10Str: WideString; safecall;
    function Get_prDayDiscountSumOnSales: LongWord; safecall;
    function Get_prDayDiscountSumOnSalesStr: WideString; safecall;
    function Get_prDayMarkupSumOnSales: LongWord; safecall;
    function Get_prDayMarkupSumOnSalesStr: WideString; safecall;
    function Get_prDayDiscountSumOnRefunds: LongWord; safecall;
    function Get_prDayDiscountSumOnRefundsStr: WideString; safecall;
    function Get_prDayMarkupSumOnRefunds: LongWord; safecall;
    function Get_prDayMarkupSumOnRefundsStr: WideString; safecall;
    function Get_prDayCashInSum: LongWord; safecall;
    function Get_prDayCashInSumStr: WideString; safecall;
    function Get_prDayCashOutSum: LongWord; safecall;
    function Get_prDayCashOutSumStr: WideString; safecall;
    function Get_prCurrentZReport: Word; safecall;
    function Get_prCurrentZReportStr: WideString; safecall;
    function Get_prDayEndDate: TDateTime; safecall;
    function Get_prDayEndDateStr: WideString; safecall;
    function Get_prDayEndTime: TDateTime; safecall;
    function Get_prDayEndTimeStr: WideString; safecall;
    function Get_prLastZReportDate: TDateTime; safecall;
    function Get_prLastZReportDateStr: WideString; safecall;
    function Get_prItemsCount: Word; safecall;
    function Get_prItemsCountStr: WideString; safecall;
    function Get_prDaySumAddTaxOfSale1: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale2: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale3: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale4: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale5: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale6: LongWord; safecall;
    function Get_prDaySumAddTaxOfSale1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfSale6Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund1: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund2: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund3: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund4: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund5: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund6: LongWord; safecall;
    function Get_prDaySumAddTaxOfRefund1Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund2Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund3Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund4Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund5Str: WideString; safecall;
    function Get_prDaySumAddTaxOfRefund6Str: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsCount: Word; safecall;
    function Get_prDayAnnuledSaleReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsCount: Word; safecall;
    function Get_prDayAnnuledRefundReceiptsCountStr: WideString; safecall;
    function Get_prDayAnnuledSaleReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledSaleReceiptsSumStr: WideString; safecall;
    function Get_prDayAnnuledRefundReceiptsSum: LongWord; safecall;
    function Get_prDayAnnuledRefundReceiptsSumStr: WideString; safecall;
    function Get_prDaySaleCancelingsCount: Word; safecall;
    function Get_prDaySaleCancelingsCountStr: WideString; safecall;
    function Get_prDayRefundCancelingsCount: Word; safecall;
    function Get_prDayRefundCancelingsCountStr: WideString; safecall;
    function Get_prDaySaleCancelingsSum: LongWord; safecall;
    function Get_prDaySaleCancelingsSumStr: WideString; safecall;
    function Get_prDayRefundCancelingsSum: LongWord; safecall;
    function Get_prDayRefundCancelingsSumStr: WideString; safecall;
    function Get_prDayFirstFreePacket: LongWord; safecall;
    function Get_prDayLastSentPacket: LongWord; safecall;
    function Get_prDayLastSignedPacket: LongWord; safecall;
    function Get_prDayFirstFreePacketStr: WideString; safecall;
    function Get_prDayLastSentPacketStr: WideString; safecall;
    function Get_prDayLastSignedPacketStr: WideString; safecall;
    function Get_prCashDrawerSum: Int64; safecall;
    function Get_prCashDrawerSumStr: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prGetStatusByte: Byte; safecall;
    function Get_prGetResultByte: Byte; safecall;
    function Get_prGetReserveByte: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prCurReceiptItemCount: Byte; safecall;
    function Get_prUserPassword: Word; safecall;
    function Get_prUserPasswordStr: WideString; safecall;
    function Get_prPrintContrast: Byte; safecall;
    function Get_prFont9x17: WordBool; safecall;
    procedure Set_prFont9x17(Value: WordBool); safecall;
    function Get_prFontBold: WordBool; safecall;
    procedure Set_prFontBold(Value: WordBool); safecall;
    function Get_prFontSmall: WordBool; safecall;
    procedure Set_prFontSmall(Value: WordBool); safecall;
    function Get_prFontDoubleHeight: WordBool; safecall;
    procedure Set_prFontDoubleHeight(Value: WordBool); safecall;
    function Get_prFontDoubleWidth: WordBool; safecall;
    procedure Set_prFontDoubleWidth(Value: WordBool); safecall;
    function Get_prUDPDeviceListSize: Byte; safecall;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString; safecall;
    function Get_prUDPDeviceMAC(id: Byte): WideString; safecall;
    function Get_prUDPDeviceIP(id: Byte): WideString; safecall;
    function Get_prUDPDeviceTCPport(id: Byte): Word; safecall;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString; safecall;
    function Get_prRevizionID: Byte; safecall;
    function Get_prFPDriverMajorVersion: Byte; safecall;
    function Get_prFPDriverMinorVersion: Byte; safecall;
    function Get_prFPDriverReleaseVersion: Byte; safecall;
    function Get_prFPDriverBuildVersion: Byte; safecall;
    property glTapeAnalizer: WordBool read Get_glTapeAnalizer write Set_glTapeAnalizer;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property glVirtualPortOpened: WordBool read Get_glVirtualPortOpened;
    property glUseVirtualPort: WordBool read Get_glUseVirtualPort write Set_glUseVirtualPort;
    property stUseAdditionalTax: WordBool read Get_stUseAdditionalTax;
    property stUseAdditionalFee: WordBool read Get_stUseAdditionalFee;
    property stUseFontB: WordBool read Get_stUseFontB;
    property stUseTradeLogo: WordBool read Get_stUseTradeLogo;
    property stUseCutter: WordBool read Get_stUseCutter;
    property stRefundReceiptMode: WordBool read Get_stRefundReceiptMode;
    property stPaymentMode: WordBool read Get_stPaymentMode;
    property stFiscalMode: WordBool read Get_stFiscalMode;
    property stServiceReceiptMode: WordBool read Get_stServiceReceiptMode;
    property stOnlinePrintMode: WordBool read Get_stOnlinePrintMode;
    property stFailureLastCommand: WordBool read Get_stFailureLastCommand;
    property stFiscalDayIsOpened: WordBool read Get_stFiscalDayIsOpened;
    property stReceiptIsOpened: WordBool read Get_stReceiptIsOpened;
    property stCashDrawerIsOpened: WordBool read Get_stCashDrawerIsOpened;
    property stDisplayShowSumMode: WordBool read Get_stDisplayShowSumMode;
    property prItemCost: Int64 read Get_prItemCost;
    property prSumDiscount: Int64 read Get_prSumDiscount;
    property prSumMarkup: Int64 read Get_prSumMarkup;
    property prSumTotal: Int64 read Get_prSumTotal;
    property prSumBalance: Int64 read Get_prSumBalance;
    property prKSEFPacket: LongWord read Get_prKSEFPacket;
    property prKSEFPacketStr: WideString read Get_prKSEFPacketStr;
    property prModemError: Byte read Get_prModemError;
    property prCurrentDate: TDateTime read Get_prCurrentDate;
    property prCurrentDateStr: WideString read Get_prCurrentDateStr;
    property prCurrentTime: TDateTime read Get_prCurrentTime;
    property prCurrentTimeStr: WideString read Get_prCurrentTimeStr;
    property prTaxRatesCount: Byte read Get_prTaxRatesCount write Set_prTaxRatesCount;
    property prTaxRatesDate: TDateTime read Get_prTaxRatesDate;
    property prTaxRatesDateStr: WideString read Get_prTaxRatesDateStr;
    property prAddTaxType: WordBool read Get_prAddTaxType write Set_prAddTaxType;
    property prTaxRate1: SYSINT read Get_prTaxRate1 write Set_prTaxRate1;
    property prTaxRate2: SYSINT read Get_prTaxRate2 write Set_prTaxRate2;
    property prTaxRate3: SYSINT read Get_prTaxRate3 write Set_prTaxRate3;
    property prTaxRate4: SYSINT read Get_prTaxRate4 write Set_prTaxRate4;
    property prTaxRate5: SYSINT read Get_prTaxRate5 write Set_prTaxRate5;
    property prTaxRate6: SYSINT read Get_prTaxRate6;
    property prUsedAdditionalFee: WordBool read Get_prUsedAdditionalFee write Set_prUsedAdditionalFee;
    property prAddFeeRate1: SYSINT read Get_prAddFeeRate1 write Set_prAddFeeRate1;
    property prAddFeeRate2: SYSINT read Get_prAddFeeRate2 write Set_prAddFeeRate2;
    property prAddFeeRate3: SYSINT read Get_prAddFeeRate3 write Set_prAddFeeRate3;
    property prAddFeeRate4: SYSINT read Get_prAddFeeRate4 write Set_prAddFeeRate4;
    property prAddFeeRate5: SYSINT read Get_prAddFeeRate5 write Set_prAddFeeRate5;
    property prAddFeeRate6: SYSINT read Get_prAddFeeRate6 write Set_prAddFeeRate6;
    property prTaxOnAddFee1: WordBool read Get_prTaxOnAddFee1 write Set_prTaxOnAddFee1;
    property prTaxOnAddFee2: WordBool read Get_prTaxOnAddFee2 write Set_prTaxOnAddFee2;
    property prTaxOnAddFee3: WordBool read Get_prTaxOnAddFee3 write Set_prTaxOnAddFee3;
    property prTaxOnAddFee4: WordBool read Get_prTaxOnAddFee4 write Set_prTaxOnAddFee4;
    property prTaxOnAddFee5: WordBool read Get_prTaxOnAddFee5 write Set_prTaxOnAddFee5;
    property prTaxOnAddFee6: WordBool read Get_prTaxOnAddFee6 write Set_prTaxOnAddFee6;
    property prAddFeeOnRetailPrice1: WordBool read Get_prAddFeeOnRetailPrice1 write Set_prAddFeeOnRetailPrice1;
    property prAddFeeOnRetailPrice2: WordBool read Get_prAddFeeOnRetailPrice2 write Set_prAddFeeOnRetailPrice2;
    property prAddFeeOnRetailPrice3: WordBool read Get_prAddFeeOnRetailPrice3 write Set_prAddFeeOnRetailPrice3;
    property prAddFeeOnRetailPrice4: WordBool read Get_prAddFeeOnRetailPrice4 write Set_prAddFeeOnRetailPrice4;
    property prAddFeeOnRetailPrice5: WordBool read Get_prAddFeeOnRetailPrice5 write Set_prAddFeeOnRetailPrice5;
    property prAddFeeOnRetailPrice6: WordBool read Get_prAddFeeOnRetailPrice6 write Set_prAddFeeOnRetailPrice6;
    property prNamePaymentForm1: WideString read Get_prNamePaymentForm1;
    property prNamePaymentForm2: WideString read Get_prNamePaymentForm2;
    property prNamePaymentForm3: WideString read Get_prNamePaymentForm3;
    property prNamePaymentForm4: WideString read Get_prNamePaymentForm4;
    property prNamePaymentForm5: WideString read Get_prNamePaymentForm5;
    property prNamePaymentForm6: WideString read Get_prNamePaymentForm6;
    property prNamePaymentForm7: WideString read Get_prNamePaymentForm7;
    property prNamePaymentForm8: WideString read Get_prNamePaymentForm8;
    property prNamePaymentForm9: WideString read Get_prNamePaymentForm9;
    property prNamePaymentForm10: WideString read Get_prNamePaymentForm10;
    property prSerialNumber: WideString read Get_prSerialNumber;
    property prFiscalNumber: WideString read Get_prFiscalNumber;
    property prTaxNumber: WideString read Get_prTaxNumber;
    property prDateFiscalization: TDateTime read Get_prDateFiscalization;
    property prDateFiscalizationStr: WideString read Get_prDateFiscalizationStr;
    property prTimeFiscalization: TDateTime read Get_prTimeFiscalization;
    property prTimeFiscalizationStr: WideString read Get_prTimeFiscalizationStr;
    property prHeadLine1: WideString read Get_prHeadLine1;
    property prHeadLine2: WideString read Get_prHeadLine2;
    property prHeadLine3: WideString read Get_prHeadLine3;
    property prHardwareVersion: WideString read Get_prHardwareVersion;
    property prItemName: WideString read Get_prItemName;
    property prItemPrice: SYSINT read Get_prItemPrice;
    property prItemSaleQuantity: SYSINT read Get_prItemSaleQuantity;
    property prItemSaleQtyPrecision: Byte read Get_prItemSaleQtyPrecision;
    property prItemTax: Byte read Get_prItemTax;
    property prItemSaleSum: Int64 read Get_prItemSaleSum;
    property prItemSaleSumStr: WideString read Get_prItemSaleSumStr;
    property prItemRefundQuantity: SYSINT read Get_prItemRefundQuantity;
    property prItemRefundQtyPrecision: Byte read Get_prItemRefundQtyPrecision;
    property prItemRefundSum: Int64 read Get_prItemRefundSum;
    property prItemRefundSumStr: WideString read Get_prItemRefundSumStr;
    property prItemCostStr: WideString read Get_prItemCostStr;
    property prSumDiscountStr: WideString read Get_prSumDiscountStr;
    property prSumMarkupStr: WideString read Get_prSumMarkupStr;
    property prSumTotalStr: WideString read Get_prSumTotalStr;
    property prSumBalanceStr: WideString read Get_prSumBalanceStr;
    property prCurReceiptTax1Sum: LongWord read Get_prCurReceiptTax1Sum;
    property prCurReceiptTax2Sum: LongWord read Get_prCurReceiptTax2Sum;
    property prCurReceiptTax3Sum: LongWord read Get_prCurReceiptTax3Sum;
    property prCurReceiptTax4Sum: LongWord read Get_prCurReceiptTax4Sum;
    property prCurReceiptTax5Sum: LongWord read Get_prCurReceiptTax5Sum;
    property prCurReceiptTax6Sum: LongWord read Get_prCurReceiptTax6Sum;
    property prCurReceiptTax1SumStr: WideString read Get_prCurReceiptTax1SumStr;
    property prCurReceiptTax2SumStr: WideString read Get_prCurReceiptTax2SumStr;
    property prCurReceiptTax3SumStr: WideString read Get_prCurReceiptTax3SumStr;
    property prCurReceiptTax4SumStr: WideString read Get_prCurReceiptTax4SumStr;
    property prCurReceiptTax5SumStr: WideString read Get_prCurReceiptTax5SumStr;
    property prCurReceiptTax6SumStr: WideString read Get_prCurReceiptTax6SumStr;
    property prCurReceiptPayForm1Sum: LongWord read Get_prCurReceiptPayForm1Sum;
    property prCurReceiptPayForm2Sum: LongWord read Get_prCurReceiptPayForm2Sum;
    property prCurReceiptPayForm3Sum: LongWord read Get_prCurReceiptPayForm3Sum;
    property prCurReceiptPayForm4Sum: LongWord read Get_prCurReceiptPayForm4Sum;
    property prCurReceiptPayForm5Sum: LongWord read Get_prCurReceiptPayForm5Sum;
    property prCurReceiptPayForm6Sum: LongWord read Get_prCurReceiptPayForm6Sum;
    property prCurReceiptPayForm7Sum: LongWord read Get_prCurReceiptPayForm7Sum;
    property prCurReceiptPayForm8Sum: LongWord read Get_prCurReceiptPayForm8Sum;
    property prCurReceiptPayForm9Sum: LongWord read Get_prCurReceiptPayForm9Sum;
    property prCurReceiptPayForm10Sum: LongWord read Get_prCurReceiptPayForm10Sum;
    property prCurReceiptPayForm1SumStr: WideString read Get_prCurReceiptPayForm1SumStr;
    property prCurReceiptPayForm2SumStr: WideString read Get_prCurReceiptPayForm2SumStr;
    property prCurReceiptPayForm3SumStr: WideString read Get_prCurReceiptPayForm3SumStr;
    property prCurReceiptPayForm4SumStr: WideString read Get_prCurReceiptPayForm4SumStr;
    property prCurReceiptPayForm5SumStr: WideString read Get_prCurReceiptPayForm5SumStr;
    property prCurReceiptPayForm6SumStr: WideString read Get_prCurReceiptPayForm6SumStr;
    property prCurReceiptPayForm7SumStr: WideString read Get_prCurReceiptPayForm7SumStr;
    property prCurReceiptPayForm8SumStr: WideString read Get_prCurReceiptPayForm8SumStr;
    property prCurReceiptPayForm9SumStr: WideString read Get_prCurReceiptPayForm9SumStr;
    property prCurReceiptPayForm10SumStr: WideString read Get_prCurReceiptPayForm10SumStr;
    property prPrinterError: WordBool read Get_prPrinterError;
    property prTapeNearEnd: WordBool read Get_prTapeNearEnd;
    property prTapeEnded: WordBool read Get_prTapeEnded;
    property prDaySaleReceiptsCount: Word read Get_prDaySaleReceiptsCount;
    property prDaySaleReceiptsCountStr: WideString read Get_prDaySaleReceiptsCountStr;
    property prDayRefundReceiptsCount: Word read Get_prDayRefundReceiptsCount;
    property prDayRefundReceiptsCountStr: WideString read Get_prDayRefundReceiptsCountStr;
    property prDaySaleSumOnTax1: LongWord read Get_prDaySaleSumOnTax1;
    property prDaySaleSumOnTax2: LongWord read Get_prDaySaleSumOnTax2;
    property prDaySaleSumOnTax3: LongWord read Get_prDaySaleSumOnTax3;
    property prDaySaleSumOnTax4: LongWord read Get_prDaySaleSumOnTax4;
    property prDaySaleSumOnTax5: LongWord read Get_prDaySaleSumOnTax5;
    property prDaySaleSumOnTax6: LongWord read Get_prDaySaleSumOnTax6;
    property prDaySaleSumOnTax1Str: WideString read Get_prDaySaleSumOnTax1Str;
    property prDaySaleSumOnTax2Str: WideString read Get_prDaySaleSumOnTax2Str;
    property prDaySaleSumOnTax3Str: WideString read Get_prDaySaleSumOnTax3Str;
    property prDaySaleSumOnTax4Str: WideString read Get_prDaySaleSumOnTax4Str;
    property prDaySaleSumOnTax5Str: WideString read Get_prDaySaleSumOnTax5Str;
    property prDaySaleSumOnTax6Str: WideString read Get_prDaySaleSumOnTax6Str;
    property prDayRefundSumOnTax1: LongWord read Get_prDayRefundSumOnTax1;
    property prDayRefundSumOnTax2: LongWord read Get_prDayRefundSumOnTax2;
    property prDayRefundSumOnTax3: LongWord read Get_prDayRefundSumOnTax3;
    property prDayRefundSumOnTax4: LongWord read Get_prDayRefundSumOnTax4;
    property prDayRefundSumOnTax5: LongWord read Get_prDayRefundSumOnTax5;
    property prDayRefundSumOnTax6: LongWord read Get_prDayRefundSumOnTax6;
    property prDayRefundSumOnTax1Str: WideString read Get_prDayRefundSumOnTax1Str;
    property prDayRefundSumOnTax2Str: WideString read Get_prDayRefundSumOnTax2Str;
    property prDayRefundSumOnTax3Str: WideString read Get_prDayRefundSumOnTax3Str;
    property prDayRefundSumOnTax4Str: WideString read Get_prDayRefundSumOnTax4Str;
    property prDayRefundSumOnTax5Str: WideString read Get_prDayRefundSumOnTax5Str;
    property prDayRefundSumOnTax6Str: WideString read Get_prDayRefundSumOnTax6Str;
    property prDaySaleSumOnPayForm1: LongWord read Get_prDaySaleSumOnPayForm1;
    property prDaySaleSumOnPayForm2: LongWord read Get_prDaySaleSumOnPayForm2;
    property prDaySaleSumOnPayForm3: LongWord read Get_prDaySaleSumOnPayForm3;
    property prDaySaleSumOnPayForm4: LongWord read Get_prDaySaleSumOnPayForm4;
    property prDaySaleSumOnPayForm5: LongWord read Get_prDaySaleSumOnPayForm5;
    property prDaySaleSumOnPayForm6: LongWord read Get_prDaySaleSumOnPayForm6;
    property prDaySaleSumOnPayForm7: LongWord read Get_prDaySaleSumOnPayForm7;
    property prDaySaleSumOnPayForm8: LongWord read Get_prDaySaleSumOnPayForm8;
    property prDaySaleSumOnPayForm9: LongWord read Get_prDaySaleSumOnPayForm9;
    property prDaySaleSumOnPayForm10: LongWord read Get_prDaySaleSumOnPayForm10;
    property prDaySaleSumOnPayForm1Str: WideString read Get_prDaySaleSumOnPayForm1Str;
    property prDaySaleSumOnPayForm2Str: WideString read Get_prDaySaleSumOnPayForm2Str;
    property prDaySaleSumOnPayForm3Str: WideString read Get_prDaySaleSumOnPayForm3Str;
    property prDaySaleSumOnPayForm4Str: WideString read Get_prDaySaleSumOnPayForm4Str;
    property prDaySaleSumOnPayForm5Str: WideString read Get_prDaySaleSumOnPayForm5Str;
    property prDaySaleSumOnPayForm6Str: WideString read Get_prDaySaleSumOnPayForm6Str;
    property prDaySaleSumOnPayForm7Str: WideString read Get_prDaySaleSumOnPayForm7Str;
    property prDaySaleSumOnPayForm8Str: WideString read Get_prDaySaleSumOnPayForm8Str;
    property prDaySaleSumOnPayForm9Str: WideString read Get_prDaySaleSumOnPayForm9Str;
    property prDaySaleSumOnPayForm10Str: WideString read Get_prDaySaleSumOnPayForm10Str;
    property prDayRefundSumOnPayForm1: LongWord read Get_prDayRefundSumOnPayForm1;
    property prDayRefundSumOnPayForm2: LongWord read Get_prDayRefundSumOnPayForm2;
    property prDayRefundSumOnPayForm3: LongWord read Get_prDayRefundSumOnPayForm3;
    property prDayRefundSumOnPayForm4: LongWord read Get_prDayRefundSumOnPayForm4;
    property prDayRefundSumOnPayForm5: LongWord read Get_prDayRefundSumOnPayForm5;
    property prDayRefundSumOnPayForm6: LongWord read Get_prDayRefundSumOnPayForm6;
    property prDayRefundSumOnPayForm7: LongWord read Get_prDayRefundSumOnPayForm7;
    property prDayRefundSumOnPayForm8: LongWord read Get_prDayRefundSumOnPayForm8;
    property prDayRefundSumOnPayForm9: LongWord read Get_prDayRefundSumOnPayForm9;
    property prDayRefundSumOnPayForm10: LongWord read Get_prDayRefundSumOnPayForm10;
    property prDayRefundSumOnPayForm1Str: WideString read Get_prDayRefundSumOnPayForm1Str;
    property prDayRefundSumOnPayForm2Str: WideString read Get_prDayRefundSumOnPayForm2Str;
    property prDayRefundSumOnPayForm3Str: WideString read Get_prDayRefundSumOnPayForm3Str;
    property prDayRefundSumOnPayForm4Str: WideString read Get_prDayRefundSumOnPayForm4Str;
    property prDayRefundSumOnPayForm5Str: WideString read Get_prDayRefundSumOnPayForm5Str;
    property prDayRefundSumOnPayForm6Str: WideString read Get_prDayRefundSumOnPayForm6Str;
    property prDayRefundSumOnPayForm7Str: WideString read Get_prDayRefundSumOnPayForm7Str;
    property prDayRefundSumOnPayForm8Str: WideString read Get_prDayRefundSumOnPayForm8Str;
    property prDayRefundSumOnPayForm9Str: WideString read Get_prDayRefundSumOnPayForm9Str;
    property prDayRefundSumOnPayForm10Str: WideString read Get_prDayRefundSumOnPayForm10Str;
    property prDayDiscountSumOnSales: LongWord read Get_prDayDiscountSumOnSales;
    property prDayDiscountSumOnSalesStr: WideString read Get_prDayDiscountSumOnSalesStr;
    property prDayMarkupSumOnSales: LongWord read Get_prDayMarkupSumOnSales;
    property prDayMarkupSumOnSalesStr: WideString read Get_prDayMarkupSumOnSalesStr;
    property prDayDiscountSumOnRefunds: LongWord read Get_prDayDiscountSumOnRefunds;
    property prDayDiscountSumOnRefundsStr: WideString read Get_prDayDiscountSumOnRefundsStr;
    property prDayMarkupSumOnRefunds: LongWord read Get_prDayMarkupSumOnRefunds;
    property prDayMarkupSumOnRefundsStr: WideString read Get_prDayMarkupSumOnRefundsStr;
    property prDayCashInSum: LongWord read Get_prDayCashInSum;
    property prDayCashInSumStr: WideString read Get_prDayCashInSumStr;
    property prDayCashOutSum: LongWord read Get_prDayCashOutSum;
    property prDayCashOutSumStr: WideString read Get_prDayCashOutSumStr;
    property prCurrentZReport: Word read Get_prCurrentZReport;
    property prCurrentZReportStr: WideString read Get_prCurrentZReportStr;
    property prDayEndDate: TDateTime read Get_prDayEndDate;
    property prDayEndDateStr: WideString read Get_prDayEndDateStr;
    property prDayEndTime: TDateTime read Get_prDayEndTime;
    property prDayEndTimeStr: WideString read Get_prDayEndTimeStr;
    property prLastZReportDate: TDateTime read Get_prLastZReportDate;
    property prLastZReportDateStr: WideString read Get_prLastZReportDateStr;
    property prItemsCount: Word read Get_prItemsCount;
    property prItemsCountStr: WideString read Get_prItemsCountStr;
    property prDaySumAddTaxOfSale1: LongWord read Get_prDaySumAddTaxOfSale1;
    property prDaySumAddTaxOfSale2: LongWord read Get_prDaySumAddTaxOfSale2;
    property prDaySumAddTaxOfSale3: LongWord read Get_prDaySumAddTaxOfSale3;
    property prDaySumAddTaxOfSale4: LongWord read Get_prDaySumAddTaxOfSale4;
    property prDaySumAddTaxOfSale5: LongWord read Get_prDaySumAddTaxOfSale5;
    property prDaySumAddTaxOfSale6: LongWord read Get_prDaySumAddTaxOfSale6;
    property prDaySumAddTaxOfSale1Str: WideString read Get_prDaySumAddTaxOfSale1Str;
    property prDaySumAddTaxOfSale2Str: WideString read Get_prDaySumAddTaxOfSale2Str;
    property prDaySumAddTaxOfSale3Str: WideString read Get_prDaySumAddTaxOfSale3Str;
    property prDaySumAddTaxOfSale4Str: WideString read Get_prDaySumAddTaxOfSale4Str;
    property prDaySumAddTaxOfSale5Str: WideString read Get_prDaySumAddTaxOfSale5Str;
    property prDaySumAddTaxOfSale6Str: WideString read Get_prDaySumAddTaxOfSale6Str;
    property prDaySumAddTaxOfRefund1: LongWord read Get_prDaySumAddTaxOfRefund1;
    property prDaySumAddTaxOfRefund2: LongWord read Get_prDaySumAddTaxOfRefund2;
    property prDaySumAddTaxOfRefund3: LongWord read Get_prDaySumAddTaxOfRefund3;
    property prDaySumAddTaxOfRefund4: LongWord read Get_prDaySumAddTaxOfRefund4;
    property prDaySumAddTaxOfRefund5: LongWord read Get_prDaySumAddTaxOfRefund5;
    property prDaySumAddTaxOfRefund6: LongWord read Get_prDaySumAddTaxOfRefund6;
    property prDaySumAddTaxOfRefund1Str: WideString read Get_prDaySumAddTaxOfRefund1Str;
    property prDaySumAddTaxOfRefund2Str: WideString read Get_prDaySumAddTaxOfRefund2Str;
    property prDaySumAddTaxOfRefund3Str: WideString read Get_prDaySumAddTaxOfRefund3Str;
    property prDaySumAddTaxOfRefund4Str: WideString read Get_prDaySumAddTaxOfRefund4Str;
    property prDaySumAddTaxOfRefund5Str: WideString read Get_prDaySumAddTaxOfRefund5Str;
    property prDaySumAddTaxOfRefund6Str: WideString read Get_prDaySumAddTaxOfRefund6Str;
    property prDayAnnuledSaleReceiptsCount: Word read Get_prDayAnnuledSaleReceiptsCount;
    property prDayAnnuledSaleReceiptsCountStr: WideString read Get_prDayAnnuledSaleReceiptsCountStr;
    property prDayAnnuledRefundReceiptsCount: Word read Get_prDayAnnuledRefundReceiptsCount;
    property prDayAnnuledRefundReceiptsCountStr: WideString read Get_prDayAnnuledRefundReceiptsCountStr;
    property prDayAnnuledSaleReceiptsSum: LongWord read Get_prDayAnnuledSaleReceiptsSum;
    property prDayAnnuledSaleReceiptsSumStr: WideString read Get_prDayAnnuledSaleReceiptsSumStr;
    property prDayAnnuledRefundReceiptsSum: LongWord read Get_prDayAnnuledRefundReceiptsSum;
    property prDayAnnuledRefundReceiptsSumStr: WideString read Get_prDayAnnuledRefundReceiptsSumStr;
    property prDaySaleCancelingsCount: Word read Get_prDaySaleCancelingsCount;
    property prDaySaleCancelingsCountStr: WideString read Get_prDaySaleCancelingsCountStr;
    property prDayRefundCancelingsCount: Word read Get_prDayRefundCancelingsCount;
    property prDayRefundCancelingsCountStr: WideString read Get_prDayRefundCancelingsCountStr;
    property prDaySaleCancelingsSum: LongWord read Get_prDaySaleCancelingsSum;
    property prDaySaleCancelingsSumStr: WideString read Get_prDaySaleCancelingsSumStr;
    property prDayRefundCancelingsSum: LongWord read Get_prDayRefundCancelingsSum;
    property prDayRefundCancelingsSumStr: WideString read Get_prDayRefundCancelingsSumStr;
    property prDayFirstFreePacket: LongWord read Get_prDayFirstFreePacket;
    property prDayLastSentPacket: LongWord read Get_prDayLastSentPacket;
    property prDayLastSignedPacket: LongWord read Get_prDayLastSignedPacket;
    property prDayFirstFreePacketStr: WideString read Get_prDayFirstFreePacketStr;
    property prDayLastSentPacketStr: WideString read Get_prDayLastSentPacketStr;
    property prDayLastSignedPacketStr: WideString read Get_prDayLastSignedPacketStr;
    property prCashDrawerSum: Int64 read Get_prCashDrawerSum;
    property prCashDrawerSumStr: WideString read Get_prCashDrawerSumStr;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prGetStatusByte: Byte read Get_prGetStatusByte;
    property prGetResultByte: Byte read Get_prGetResultByte;
    property prGetReserveByte: Byte read Get_prGetReserveByte;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prCurReceiptItemCount: Byte read Get_prCurReceiptItemCount;
    property prUserPassword: Word read Get_prUserPassword;
    property prUserPasswordStr: WideString read Get_prUserPasswordStr;
    property prPrintContrast: Byte read Get_prPrintContrast;
    property prFont9x17: WordBool read Get_prFont9x17 write Set_prFont9x17;
    property prFontBold: WordBool read Get_prFontBold write Set_prFontBold;
    property prFontSmall: WordBool read Get_prFontSmall write Set_prFontSmall;
    property prFontDoubleHeight: WordBool read Get_prFontDoubleHeight write Set_prFontDoubleHeight;
    property prFontDoubleWidth: WordBool read Get_prFontDoubleWidth write Set_prFontDoubleWidth;
    property prUDPDeviceListSize: Byte read Get_prUDPDeviceListSize;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte read Get_prRevizionID;
    property prFPDriverMajorVersion: Byte read Get_prFPDriverMajorVersion;
    property prFPDriverMinorVersion: Byte read Get_prFPDriverMinorVersion;
    property prFPDriverReleaseVersion: Byte read Get_prFPDriverReleaseVersion;
    property prFPDriverBuildVersion: Byte read Get_prFPDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_MF_11Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2CCFE5E2-19DF-428F-9E82-BE55E7AEB567}
// *********************************************************************//
  IICS_MF_11Disp = dispinterface
    ['{2CCFE5E2-19DF-428F-9E82-BE55E7AEB567}']
    function FPInitialize: Integer; dispid 433;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool; dispid 201;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool; dispid 202;
    function FPClose: WordBool; dispid 203;
    function FPClaimUSBDevice: WordBool; dispid 571;
    function FPReleaseUSBDevice: WordBool; dispid 572;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool; dispid 573;
    function FPTCPClose: WordBool; dispid 574;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool; dispid 580;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool; dispid 204;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool; dispid 205;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 206;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool; dispid 207;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool; dispid 208;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool; dispid 209;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool; dispid 210;
    function FPPrintZeroReceipt: WordBool; dispid 211;
    function FPLineFeed: WordBool; dispid 212;
    function FPAnnulReceipt: WordBool; dispid 213;
    function FPCashIn(CashSum: SYSUINT): WordBool; dispid 214;
    function FPCashOut(CashSum: SYSUINT): WordBool; dispid 215;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool; dispid 216;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool; dispid 217;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool; dispid 218;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool; dispid 219;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool; dispid 220;
    function FPGetCurrentDate: WordBool; dispid 221;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool; dispid 222;
    function FPGetCurrentTime: WordBool; dispid 223;
    function FPOpenCashDrawer(Duration: Word): WordBool; dispid 224;
    function FPPrintHardwareVersion: WordBool; dispid 225;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool; dispid 226;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool; dispid 227;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool; dispid 228;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool; dispid 229;
    function FPOnlineModeSwitch: WordBool; dispid 230;
    function FPCustomerDisplayModeSwitch: WordBool; dispid 231;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool; dispid 232;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool; dispid 233;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool; dispid 234;
    function FPCloseServiceReport: WordBool; dispid 235;
    function FPEnableLogo(ProgPassword: Word): WordBool; dispid 236;
    function FPDisableLogo(ProgPassword: Word): WordBool; dispid 237;
    function FPSetTaxRates(ProgPassword: Word): WordBool; dispid 238;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool; dispid 239;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool; dispid 240;
    function FPMakeXReport(ReportPassword: Word): WordBool; dispid 241;
    function FPMakeZReport(ReportPassword: Word): WordBool; dispid 242;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool; dispid 243;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool; dispid 244;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool; dispid 245;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool; dispid 246;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool; dispid 247;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool; dispid 248;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool; dispid 249;
    function FPCutterModeSwitch: WordBool; dispid 250;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool; dispid 251;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool; dispid 539;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool; dispid 252;
    function FPGetPaymentFormNames: WordBool; dispid 435;
    function FPGetCurrentStatus: WordBool; dispid 440;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool; dispid 442;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool; dispid 443;
    function FPGetCashDrawerSum: WordBool; dispid 444;
    function FPGetDayReportProperties: WordBool; dispid 445;
    function FPGetTaxRates: WordBool; dispid 446;
    function FPGetItemData(ItemCode: Int64): WordBool; dispid 447;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool; dispid 448;
    function FPGetDayReportData: WordBool; dispid 449;
    function FPGetCurrentReceiptData: WordBool; dispid 450;
    function FPGetDayCorrectionsData: WordBool; dispid 452;
    function FPGetDayPacketData: WordBool; dispid 562;
    function FPGetDaySumOfAddTaxes: WordBool; dispid 453;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool; dispid 454;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool; dispid 455;
    function FPPrintModemStatus: WordBool; dispid 456;
    function FPGetUserPassword(UserID: Byte): WordBool; dispid 535;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool; dispid 548;
    function FPPrintQRCode(const SerialQR: WideString): WordBool; dispid 549;
    function FPSetContrast(Value: Byte): WordBool; dispid 540;
    function FPGetContrast: WordBool; dispid 541;
    function FPGetRevizionID: WordBool; dispid 550;
    property glTapeAnalizer: WordBool dispid 253;
    property glPropertiesAutoUpdateMode: WordBool dispid 254;
    property glCodepageOEM: WordBool dispid 255;
    property glLangID: Byte dispid 256;
    property glVirtualPortOpened: WordBool readonly dispid 569;
    property glUseVirtualPort: WordBool dispid 570;
    property stUseAdditionalTax: WordBool readonly dispid 415;
    property stUseAdditionalFee: WordBool readonly dispid 416;
    property stUseFontB: WordBool readonly dispid 417;
    property stUseTradeLogo: WordBool readonly dispid 418;
    property stUseCutter: WordBool readonly dispid 419;
    property stRefundReceiptMode: WordBool readonly dispid 420;
    property stPaymentMode: WordBool readonly dispid 421;
    property stFiscalMode: WordBool readonly dispid 422;
    property stServiceReceiptMode: WordBool readonly dispid 423;
    property stOnlinePrintMode: WordBool readonly dispid 424;
    property stFailureLastCommand: WordBool readonly dispid 425;
    property stFiscalDayIsOpened: WordBool readonly dispid 426;
    property stReceiptIsOpened: WordBool readonly dispid 427;
    property stCashDrawerIsOpened: WordBool readonly dispid 428;
    property stDisplayShowSumMode: WordBool readonly dispid 441;
    property prItemCost: Int64 readonly dispid 257;
    property prSumDiscount: Int64 readonly dispid 258;
    property prSumMarkup: Int64 readonly dispid 259;
    property prSumTotal: Int64 readonly dispid 260;
    property prSumBalance: Int64 readonly dispid 261;
    property prKSEFPacket: LongWord readonly dispid 262;
    property prKSEFPacketStr: WideString readonly dispid 538;
    property prModemError: Byte readonly dispid 263;
    property prCurrentDate: TDateTime readonly dispid 264;
    property prCurrentDateStr: WideString readonly dispid 265;
    property prCurrentTime: TDateTime readonly dispid 266;
    property prCurrentTimeStr: WideString readonly dispid 267;
    property prTaxRatesCount: Byte dispid 268;
    property prTaxRatesDate: TDateTime readonly dispid 269;
    property prTaxRatesDateStr: WideString readonly dispid 270;
    property prAddTaxType: WordBool dispid 271;
    property prTaxRate1: SYSINT dispid 272;
    property prTaxRate2: SYSINT dispid 273;
    property prTaxRate3: SYSINT dispid 274;
    property prTaxRate4: SYSINT dispid 275;
    property prTaxRate5: SYSINT dispid 276;
    property prTaxRate6: SYSINT readonly dispid 277;
    property prUsedAdditionalFee: WordBool dispid 278;
    property prAddFeeRate1: SYSINT dispid 279;
    property prAddFeeRate2: SYSINT dispid 280;
    property prAddFeeRate3: SYSINT dispid 281;
    property prAddFeeRate4: SYSINT dispid 282;
    property prAddFeeRate5: SYSINT dispid 283;
    property prAddFeeRate6: SYSINT dispid 284;
    property prTaxOnAddFee1: WordBool dispid 285;
    property prTaxOnAddFee2: WordBool dispid 286;
    property prTaxOnAddFee3: WordBool dispid 287;
    property prTaxOnAddFee4: WordBool dispid 288;
    property prTaxOnAddFee5: WordBool dispid 289;
    property prTaxOnAddFee6: WordBool dispid 290;
    property prAddFeeOnRetailPrice1: WordBool dispid 556;
    property prAddFeeOnRetailPrice2: WordBool dispid 557;
    property prAddFeeOnRetailPrice3: WordBool dispid 558;
    property prAddFeeOnRetailPrice4: WordBool dispid 559;
    property prAddFeeOnRetailPrice5: WordBool dispid 560;
    property prAddFeeOnRetailPrice6: WordBool dispid 561;
    property prNamePaymentForm1: WideString readonly dispid 291;
    property prNamePaymentForm2: WideString readonly dispid 292;
    property prNamePaymentForm3: WideString readonly dispid 293;
    property prNamePaymentForm4: WideString readonly dispid 294;
    property prNamePaymentForm5: WideString readonly dispid 295;
    property prNamePaymentForm6: WideString readonly dispid 296;
    property prNamePaymentForm7: WideString readonly dispid 297;
    property prNamePaymentForm8: WideString readonly dispid 298;
    property prNamePaymentForm9: WideString readonly dispid 299;
    property prNamePaymentForm10: WideString readonly dispid 300;
    property prSerialNumber: WideString readonly dispid 301;
    property prFiscalNumber: WideString readonly dispid 302;
    property prTaxNumber: WideString readonly dispid 303;
    property prDateFiscalization: TDateTime readonly dispid 304;
    property prDateFiscalizationStr: WideString readonly dispid 305;
    property prTimeFiscalization: TDateTime readonly dispid 306;
    property prTimeFiscalizationStr: WideString readonly dispid 307;
    property prHeadLine1: WideString readonly dispid 308;
    property prHeadLine2: WideString readonly dispid 309;
    property prHeadLine3: WideString readonly dispid 310;
    property prHardwareVersion: WideString readonly dispid 311;
    property prItemName: WideString readonly dispid 312;
    property prItemPrice: SYSINT readonly dispid 313;
    property prItemSaleQuantity: SYSINT readonly dispid 314;
    property prItemSaleQtyPrecision: Byte readonly dispid 315;
    property prItemTax: Byte readonly dispid 316;
    property prItemSaleSum: Int64 readonly dispid 317;
    property prItemSaleSumStr: WideString readonly dispid 318;
    property prItemRefundQuantity: SYSINT readonly dispid 319;
    property prItemRefundQtyPrecision: Byte readonly dispid 320;
    property prItemRefundSum: Int64 readonly dispid 321;
    property prItemRefundSumStr: WideString readonly dispid 322;
    property prItemCostStr: WideString readonly dispid 323;
    property prSumDiscountStr: WideString readonly dispid 324;
    property prSumMarkupStr: WideString readonly dispid 325;
    property prSumTotalStr: WideString readonly dispid 326;
    property prSumBalanceStr: WideString readonly dispid 327;
    property prCurReceiptTax1Sum: LongWord readonly dispid 328;
    property prCurReceiptTax2Sum: LongWord readonly dispid 329;
    property prCurReceiptTax3Sum: LongWord readonly dispid 330;
    property prCurReceiptTax4Sum: LongWord readonly dispid 331;
    property prCurReceiptTax5Sum: LongWord readonly dispid 332;
    property prCurReceiptTax6Sum: LongWord readonly dispid 333;
    property prCurReceiptTax1SumStr: WideString readonly dispid 457;
    property prCurReceiptTax2SumStr: WideString readonly dispid 458;
    property prCurReceiptTax3SumStr: WideString readonly dispid 459;
    property prCurReceiptTax4SumStr: WideString readonly dispid 460;
    property prCurReceiptTax5SumStr: WideString readonly dispid 461;
    property prCurReceiptTax6SumStr: WideString readonly dispid 462;
    property prCurReceiptPayForm1Sum: LongWord readonly dispid 334;
    property prCurReceiptPayForm2Sum: LongWord readonly dispid 335;
    property prCurReceiptPayForm3Sum: LongWord readonly dispid 336;
    property prCurReceiptPayForm4Sum: LongWord readonly dispid 337;
    property prCurReceiptPayForm5Sum: LongWord readonly dispid 338;
    property prCurReceiptPayForm6Sum: LongWord readonly dispid 339;
    property prCurReceiptPayForm7Sum: LongWord readonly dispid 340;
    property prCurReceiptPayForm8Sum: LongWord readonly dispid 341;
    property prCurReceiptPayForm9Sum: LongWord readonly dispid 342;
    property prCurReceiptPayForm10Sum: LongWord readonly dispid 343;
    property prCurReceiptPayForm1SumStr: WideString readonly dispid 463;
    property prCurReceiptPayForm2SumStr: WideString readonly dispid 464;
    property prCurReceiptPayForm3SumStr: WideString readonly dispid 465;
    property prCurReceiptPayForm4SumStr: WideString readonly dispid 466;
    property prCurReceiptPayForm5SumStr: WideString readonly dispid 467;
    property prCurReceiptPayForm6SumStr: WideString readonly dispid 468;
    property prCurReceiptPayForm7SumStr: WideString readonly dispid 469;
    property prCurReceiptPayForm8SumStr: WideString readonly dispid 470;
    property prCurReceiptPayForm9SumStr: WideString readonly dispid 471;
    property prCurReceiptPayForm10SumStr: WideString readonly dispid 472;
    property prPrinterError: WordBool readonly dispid 344;
    property prTapeNearEnd: WordBool readonly dispid 345;
    property prTapeEnded: WordBool readonly dispid 346;
    property prDaySaleReceiptsCount: Word readonly dispid 347;
    property prDaySaleReceiptsCountStr: WideString readonly dispid 473;
    property prDayRefundReceiptsCount: Word readonly dispid 348;
    property prDayRefundReceiptsCountStr: WideString readonly dispid 474;
    property prDaySaleSumOnTax1: LongWord readonly dispid 349;
    property prDaySaleSumOnTax2: LongWord readonly dispid 350;
    property prDaySaleSumOnTax3: LongWord readonly dispid 351;
    property prDaySaleSumOnTax4: LongWord readonly dispid 352;
    property prDaySaleSumOnTax5: LongWord readonly dispid 353;
    property prDaySaleSumOnTax6: LongWord readonly dispid 354;
    property prDaySaleSumOnTax1Str: WideString readonly dispid 475;
    property prDaySaleSumOnTax2Str: WideString readonly dispid 476;
    property prDaySaleSumOnTax3Str: WideString readonly dispid 477;
    property prDaySaleSumOnTax4Str: WideString readonly dispid 478;
    property prDaySaleSumOnTax5Str: WideString readonly dispid 479;
    property prDaySaleSumOnTax6Str: WideString readonly dispid 480;
    property prDayRefundSumOnTax1: LongWord readonly dispid 355;
    property prDayRefundSumOnTax2: LongWord readonly dispid 356;
    property prDayRefundSumOnTax3: LongWord readonly dispid 357;
    property prDayRefundSumOnTax4: LongWord readonly dispid 358;
    property prDayRefundSumOnTax5: LongWord readonly dispid 359;
    property prDayRefundSumOnTax6: LongWord readonly dispid 360;
    property prDayRefundSumOnTax1Str: WideString readonly dispid 481;
    property prDayRefundSumOnTax2Str: WideString readonly dispid 482;
    property prDayRefundSumOnTax3Str: WideString readonly dispid 483;
    property prDayRefundSumOnTax4Str: WideString readonly dispid 484;
    property prDayRefundSumOnTax5Str: WideString readonly dispid 485;
    property prDayRefundSumOnTax6Str: WideString readonly dispid 486;
    property prDaySaleSumOnPayForm1: LongWord readonly dispid 361;
    property prDaySaleSumOnPayForm2: LongWord readonly dispid 362;
    property prDaySaleSumOnPayForm3: LongWord readonly dispid 363;
    property prDaySaleSumOnPayForm4: LongWord readonly dispid 364;
    property prDaySaleSumOnPayForm5: LongWord readonly dispid 365;
    property prDaySaleSumOnPayForm6: LongWord readonly dispid 366;
    property prDaySaleSumOnPayForm7: LongWord readonly dispid 367;
    property prDaySaleSumOnPayForm8: LongWord readonly dispid 368;
    property prDaySaleSumOnPayForm9: LongWord readonly dispid 369;
    property prDaySaleSumOnPayForm10: LongWord readonly dispid 370;
    property prDaySaleSumOnPayForm1Str: WideString readonly dispid 487;
    property prDaySaleSumOnPayForm2Str: WideString readonly dispid 488;
    property prDaySaleSumOnPayForm3Str: WideString readonly dispid 489;
    property prDaySaleSumOnPayForm4Str: WideString readonly dispid 490;
    property prDaySaleSumOnPayForm5Str: WideString readonly dispid 491;
    property prDaySaleSumOnPayForm6Str: WideString readonly dispid 492;
    property prDaySaleSumOnPayForm7Str: WideString readonly dispid 493;
    property prDaySaleSumOnPayForm8Str: WideString readonly dispid 494;
    property prDaySaleSumOnPayForm9Str: WideString readonly dispid 495;
    property prDaySaleSumOnPayForm10Str: WideString readonly dispid 496;
    property prDayRefundSumOnPayForm1: LongWord readonly dispid 371;
    property prDayRefundSumOnPayForm2: LongWord readonly dispid 372;
    property prDayRefundSumOnPayForm3: LongWord readonly dispid 373;
    property prDayRefundSumOnPayForm4: LongWord readonly dispid 374;
    property prDayRefundSumOnPayForm5: LongWord readonly dispid 375;
    property prDayRefundSumOnPayForm6: LongWord readonly dispid 376;
    property prDayRefundSumOnPayForm7: LongWord readonly dispid 377;
    property prDayRefundSumOnPayForm8: LongWord readonly dispid 378;
    property prDayRefundSumOnPayForm9: LongWord readonly dispid 379;
    property prDayRefundSumOnPayForm10: LongWord readonly dispid 380;
    property prDayRefundSumOnPayForm1Str: WideString readonly dispid 497;
    property prDayRefundSumOnPayForm2Str: WideString readonly dispid 498;
    property prDayRefundSumOnPayForm3Str: WideString readonly dispid 499;
    property prDayRefundSumOnPayForm4Str: WideString readonly dispid 500;
    property prDayRefundSumOnPayForm5Str: WideString readonly dispid 501;
    property prDayRefundSumOnPayForm6Str: WideString readonly dispid 502;
    property prDayRefundSumOnPayForm7Str: WideString readonly dispid 503;
    property prDayRefundSumOnPayForm8Str: WideString readonly dispid 504;
    property prDayRefundSumOnPayForm9Str: WideString readonly dispid 505;
    property prDayRefundSumOnPayForm10Str: WideString readonly dispid 506;
    property prDayDiscountSumOnSales: LongWord readonly dispid 381;
    property prDayDiscountSumOnSalesStr: WideString readonly dispid 507;
    property prDayMarkupSumOnSales: LongWord readonly dispid 382;
    property prDayMarkupSumOnSalesStr: WideString readonly dispid 508;
    property prDayDiscountSumOnRefunds: LongWord readonly dispid 383;
    property prDayDiscountSumOnRefundsStr: WideString readonly dispid 509;
    property prDayMarkupSumOnRefunds: LongWord readonly dispid 384;
    property prDayMarkupSumOnRefundsStr: WideString readonly dispid 510;
    property prDayCashInSum: LongWord readonly dispid 385;
    property prDayCashInSumStr: WideString readonly dispid 511;
    property prDayCashOutSum: LongWord readonly dispid 386;
    property prDayCashOutSumStr: WideString readonly dispid 512;
    property prCurrentZReport: Word readonly dispid 387;
    property prCurrentZReportStr: WideString readonly dispid 513;
    property prDayEndDate: TDateTime readonly dispid 388;
    property prDayEndDateStr: WideString readonly dispid 389;
    property prDayEndTime: TDateTime readonly dispid 390;
    property prDayEndTimeStr: WideString readonly dispid 391;
    property prLastZReportDate: TDateTime readonly dispid 392;
    property prLastZReportDateStr: WideString readonly dispid 393;
    property prItemsCount: Word readonly dispid 394;
    property prItemsCountStr: WideString readonly dispid 514;
    property prDaySumAddTaxOfSale1: LongWord readonly dispid 395;
    property prDaySumAddTaxOfSale2: LongWord readonly dispid 396;
    property prDaySumAddTaxOfSale3: LongWord readonly dispid 397;
    property prDaySumAddTaxOfSale4: LongWord readonly dispid 398;
    property prDaySumAddTaxOfSale5: LongWord readonly dispid 399;
    property prDaySumAddTaxOfSale6: LongWord readonly dispid 400;
    property prDaySumAddTaxOfSale1Str: WideString readonly dispid 515;
    property prDaySumAddTaxOfSale2Str: WideString readonly dispid 516;
    property prDaySumAddTaxOfSale3Str: WideString readonly dispid 517;
    property prDaySumAddTaxOfSale4Str: WideString readonly dispid 518;
    property prDaySumAddTaxOfSale5Str: WideString readonly dispid 519;
    property prDaySumAddTaxOfSale6Str: WideString readonly dispid 520;
    property prDaySumAddTaxOfRefund1: LongWord readonly dispid 401;
    property prDaySumAddTaxOfRefund2: LongWord readonly dispid 402;
    property prDaySumAddTaxOfRefund3: LongWord readonly dispid 403;
    property prDaySumAddTaxOfRefund4: LongWord readonly dispid 404;
    property prDaySumAddTaxOfRefund5: LongWord readonly dispid 405;
    property prDaySumAddTaxOfRefund6: LongWord readonly dispid 406;
    property prDaySumAddTaxOfRefund1Str: WideString readonly dispid 521;
    property prDaySumAddTaxOfRefund2Str: WideString readonly dispid 522;
    property prDaySumAddTaxOfRefund3Str: WideString readonly dispid 523;
    property prDaySumAddTaxOfRefund4Str: WideString readonly dispid 524;
    property prDaySumAddTaxOfRefund5Str: WideString readonly dispid 525;
    property prDaySumAddTaxOfRefund6Str: WideString readonly dispid 526;
    property prDayAnnuledSaleReceiptsCount: Word readonly dispid 407;
    property prDayAnnuledSaleReceiptsCountStr: WideString readonly dispid 527;
    property prDayAnnuledRefundReceiptsCount: Word readonly dispid 408;
    property prDayAnnuledRefundReceiptsCountStr: WideString readonly dispid 528;
    property prDayAnnuledSaleReceiptsSum: LongWord readonly dispid 409;
    property prDayAnnuledSaleReceiptsSumStr: WideString readonly dispid 529;
    property prDayAnnuledRefundReceiptsSum: LongWord readonly dispid 410;
    property prDayAnnuledRefundReceiptsSumStr: WideString readonly dispid 530;
    property prDaySaleCancelingsCount: Word readonly dispid 411;
    property prDaySaleCancelingsCountStr: WideString readonly dispid 531;
    property prDayRefundCancelingsCount: Word readonly dispid 412;
    property prDayRefundCancelingsCountStr: WideString readonly dispid 532;
    property prDaySaleCancelingsSum: LongWord readonly dispid 413;
    property prDaySaleCancelingsSumStr: WideString readonly dispid 533;
    property prDayRefundCancelingsSum: LongWord readonly dispid 414;
    property prDayRefundCancelingsSumStr: WideString readonly dispid 534;
    property prDayFirstFreePacket: LongWord readonly dispid 563;
    property prDayLastSentPacket: LongWord readonly dispid 564;
    property prDayLastSignedPacket: LongWord readonly dispid 565;
    property prDayFirstFreePacketStr: WideString readonly dispid 566;
    property prDayLastSentPacketStr: WideString readonly dispid 567;
    property prDayLastSignedPacketStr: WideString readonly dispid 568;
    property prCashDrawerSum: Int64 readonly dispid 429;
    property prCashDrawerSumStr: WideString readonly dispid 430;
    property prRepeatCount: Byte dispid 431;
    property prLogRecording: WordBool dispid 432;
    property prAnswerWaiting: Byte dispid 434;
    property prGetStatusByte: Byte readonly dispid 436;
    property prGetResultByte: Byte readonly dispid 437;
    property prGetReserveByte: Byte readonly dispid 438;
    property prGetErrorText: WideString readonly dispid 439;
    property prCurReceiptItemCount: Byte readonly dispid 451;
    property prUserPassword: Word readonly dispid 536;
    property prUserPasswordStr: WideString readonly dispid 537;
    property prPrintContrast: Byte readonly dispid 542;
    property prFont9x17: WordBool dispid 543;
    property prFontBold: WordBool dispid 544;
    property prFontSmall: WordBool dispid 545;
    property prFontDoubleHeight: WordBool dispid 546;
    property prFontDoubleWidth: WordBool dispid 547;
    property prUDPDeviceListSize: Byte readonly dispid 575;
    property prUDPDeviceSerialNumber[id: Byte]: WideString readonly dispid 576;
    property prUDPDeviceMAC[id: Byte]: WideString readonly dispid 577;
    property prUDPDeviceIP[id: Byte]: WideString readonly dispid 578;
    property prUDPDeviceTCPport[id: Byte]: Word readonly dispid 579;
    property prUDPDeviceTCPportStr[id: Byte]: WideString readonly dispid 581;
    property prRevizionID: Byte readonly dispid 551;
    property prFPDriverMajorVersion: Byte readonly dispid 552;
    property prFPDriverMinorVersion: Byte readonly dispid 553;
    property prFPDriverReleaseVersion: Byte readonly dispid 554;
    property prFPDriverBuildVersion: Byte readonly dispid 555;
  end;

// *********************************************************************//
// Interface: IICS_Modem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D045EBD-5B24-4099-A7B5-7B0813D1741A}
// *********************************************************************//
  IICS_Modem = interface(IDispatch)
    ['{6D045EBD-5B24-4099-A7B5-7B0813D1741A}']
    function ModemInitialize(const portName: WideString): Integer; safecall;
    function ModemAckuirerConnect: WordBool; safecall;
    function ModemAckuirerUnconditionalConnect: WordBool; safecall;
    function ModemUpdateStatus: WordBool; safecall;
    function ModemVerifyPacket(PacketID: SYSUINT): WordBool; safecall;
    function ModemFindPacket(DayReport: Word; ReceiptNumber: Word; ReceiptType: Byte): WordBool; safecall;
    function ModemFindPacketByDateTime(FindDateTime: TDateTime; FindForward: WordBool): WordBool; safecall;
    function ModemFindPacketByDateTimeStr(const FindDateTimeStr: WideString; FindForward: WordBool): WordBool; safecall;
    function ModemReadKsefPacket(PacketID: LongWord): WordBool; safecall;
    function ModemReadKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; safecall;
    function ModemReadKsefByZReport(ZReport: Word): WordBool; safecall;
    function ModemGetCurrentTask: WordBool; safecall;
    function ModemSaveKsefRangeToBin(const Dir: WideString; const FileName: WideString; 
                                     FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; safecall;
    function ModemSaveKsefByZreportToBin(const Dir: WideString; const FileName: WideString; 
                                         ZReport: Word): WordBool; safecall;
    function Get_glPropertiesAutoUpdateMode: WordBool; safecall;
    procedure Set_glPropertiesAutoUpdateMode(Value: WordBool); safecall;
    function Get_glCodepageOEM: WordBool; safecall;
    procedure Set_glCodepageOEM(Value: WordBool); safecall;
    function Get_glLangID: Byte; safecall;
    procedure Set_glLangID(Value: Byte); safecall;
    function Get_stWorkSecondCount: Integer; safecall;
    function Get_stFPExchangeSecondCount: Integer; safecall;
    function Get_stFirstUnsendPIDDateTime: TDateTime; safecall;
    function Get_stFirstUnsendPIDDateTimeStr: WideString; safecall;
    function Get_stPID_Unused: Integer; safecall;
    function Get_stPID_CurPers: Integer; safecall;
    function Get_stPID_LastWrite: Integer; safecall;
    function Get_stPID_LastSign: Integer; safecall;
    function Get_stPID_LastSend: Integer; safecall;
    function Get_stSerialNumber: Integer; safecall;
    function Get_stID_DEV: Integer; safecall;
    function Get_stID_SAM: Integer; safecall;
    function Get_stNT_SAM: Integer; safecall;
    function Get_stNT_SESSION: Integer; safecall;
    function Get_stFailCode: Byte; safecall;
    function Get_stRes1: Byte; safecall;
    function Get_stBatVoltage: Integer; safecall;
    function Get_stDCVoltage: Integer; safecall;
    function Get_stBatCurrent: Integer; safecall;
    function Get_stTemperature: Integer; safecall;
    function Get_stState1: Byte; safecall;
    function Get_stState2: Byte; safecall;
    function Get_stState3: Byte; safecall;
    function Get_stLanState1: Byte; safecall;
    function Get_stLanState2: Byte; safecall;
    function Get_stFPExchangeResult: Byte; safecall;
    function Get_stACQExchangeResult: Byte; safecall;
    function Get_stRes2: Byte; safecall;
    function Get_stFPExchangeErrorCount: Integer; safecall;
    function Get_stRSSI: Byte; safecall;
    function Get_stRSSI_BER: Byte; safecall;
    function Get_stUSSDResult: WideString; safecall;
    function Get_stOSVer: Integer; safecall;
    function Get_stOSRev: Integer; safecall;
    function Get_stSysTime: TDateTime; safecall;
    function Get_stNETIPAddr: WideString; safecall;
    function Get_stNETGate: WideString; safecall;
    function Get_stNETMask: WideString; safecall;
    function Get_stMODIPAddr: WideString; safecall;
    function Get_stACQIPAddr: WideString; safecall;
    function Get_stACQPort: Integer; safecall;
    function Get_stACQExchangeSecondCount: Integer; safecall;
    function Get_stSysTimeStr: WideString; safecall;
    function Get_prFoundPacket: LongWord; safecall;
    function Get_prFoundPacketStr: WideString; safecall;
    function Get_prCurrentTaskCode: Byte; safecall;
    function Get_prCurrentTaskText: WideString; safecall;
    function Get_prGetErrorCode: Byte; safecall;
    function Get_prGetErrorText: WideString; safecall;
    function Get_prRepeatCount: Byte; safecall;
    procedure Set_prRepeatCount(Value: Byte); safecall;
    function Get_prLogRecording: WordBool; safecall;
    procedure Set_prLogRecording(Value: WordBool); safecall;
    function Get_prAnswerWaiting: Byte; safecall;
    procedure Set_prAnswerWaiting(Value: Byte); safecall;
    function Get_prKsefSavePath: WideString; safecall;
    procedure Set_prKsefSavePath(const Value: WideString); safecall;
    function Get_prModemDriverMajorVersion: Byte; safecall;
    function Get_prModemDriverMinorVersion: Byte; safecall;
    function Get_prModemDriverReleaseVersion: Byte; safecall;
    function Get_prModemDriverBuildVersion: Byte; safecall;
    property glPropertiesAutoUpdateMode: WordBool read Get_glPropertiesAutoUpdateMode write Set_glPropertiesAutoUpdateMode;
    property glCodepageOEM: WordBool read Get_glCodepageOEM write Set_glCodepageOEM;
    property glLangID: Byte read Get_glLangID write Set_glLangID;
    property stWorkSecondCount: Integer read Get_stWorkSecondCount;
    property stFPExchangeSecondCount: Integer read Get_stFPExchangeSecondCount;
    property stFirstUnsendPIDDateTime: TDateTime read Get_stFirstUnsendPIDDateTime;
    property stFirstUnsendPIDDateTimeStr: WideString read Get_stFirstUnsendPIDDateTimeStr;
    property stPID_Unused: Integer read Get_stPID_Unused;
    property stPID_CurPers: Integer read Get_stPID_CurPers;
    property stPID_LastWrite: Integer read Get_stPID_LastWrite;
    property stPID_LastSign: Integer read Get_stPID_LastSign;
    property stPID_LastSend: Integer read Get_stPID_LastSend;
    property stSerialNumber: Integer read Get_stSerialNumber;
    property stID_DEV: Integer read Get_stID_DEV;
    property stID_SAM: Integer read Get_stID_SAM;
    property stNT_SAM: Integer read Get_stNT_SAM;
    property stNT_SESSION: Integer read Get_stNT_SESSION;
    property stFailCode: Byte read Get_stFailCode;
    property stRes1: Byte read Get_stRes1;
    property stBatVoltage: Integer read Get_stBatVoltage;
    property stDCVoltage: Integer read Get_stDCVoltage;
    property stBatCurrent: Integer read Get_stBatCurrent;
    property stTemperature: Integer read Get_stTemperature;
    property stState1: Byte read Get_stState1;
    property stState2: Byte read Get_stState2;
    property stState3: Byte read Get_stState3;
    property stLanState1: Byte read Get_stLanState1;
    property stLanState2: Byte read Get_stLanState2;
    property stFPExchangeResult: Byte read Get_stFPExchangeResult;
    property stACQExchangeResult: Byte read Get_stACQExchangeResult;
    property stRes2: Byte read Get_stRes2;
    property stFPExchangeErrorCount: Integer read Get_stFPExchangeErrorCount;
    property stRSSI: Byte read Get_stRSSI;
    property stRSSI_BER: Byte read Get_stRSSI_BER;
    property stUSSDResult: WideString read Get_stUSSDResult;
    property stOSVer: Integer read Get_stOSVer;
    property stOSRev: Integer read Get_stOSRev;
    property stSysTime: TDateTime read Get_stSysTime;
    property stNETIPAddr: WideString read Get_stNETIPAddr;
    property stNETGate: WideString read Get_stNETGate;
    property stNETMask: WideString read Get_stNETMask;
    property stMODIPAddr: WideString read Get_stMODIPAddr;
    property stACQIPAddr: WideString read Get_stACQIPAddr;
    property stACQPort: Integer read Get_stACQPort;
    property stACQExchangeSecondCount: Integer read Get_stACQExchangeSecondCount;
    property stSysTimeStr: WideString read Get_stSysTimeStr;
    property prFoundPacket: LongWord read Get_prFoundPacket;
    property prFoundPacketStr: WideString read Get_prFoundPacketStr;
    property prCurrentTaskCode: Byte read Get_prCurrentTaskCode;
    property prCurrentTaskText: WideString read Get_prCurrentTaskText;
    property prGetErrorCode: Byte read Get_prGetErrorCode;
    property prGetErrorText: WideString read Get_prGetErrorText;
    property prRepeatCount: Byte read Get_prRepeatCount write Set_prRepeatCount;
    property prLogRecording: WordBool read Get_prLogRecording write Set_prLogRecording;
    property prAnswerWaiting: Byte read Get_prAnswerWaiting write Set_prAnswerWaiting;
    property prKsefSavePath: WideString read Get_prKsefSavePath write Set_prKsefSavePath;
    property prModemDriverMajorVersion: Byte read Get_prModemDriverMajorVersion;
    property prModemDriverMinorVersion: Byte read Get_prModemDriverMinorVersion;
    property prModemDriverReleaseVersion: Byte read Get_prModemDriverReleaseVersion;
    property prModemDriverBuildVersion: Byte read Get_prModemDriverBuildVersion;
  end;

// *********************************************************************//
// DispIntf:  IICS_ModemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6D045EBD-5B24-4099-A7B5-7B0813D1741A}
// *********************************************************************//
  IICS_ModemDisp = dispinterface
    ['{6D045EBD-5B24-4099-A7B5-7B0813D1741A}']
    function ModemInitialize(const portName: WideString): Integer; dispid 213;
    function ModemAckuirerConnect: WordBool; dispid 201;
    function ModemAckuirerUnconditionalConnect: WordBool; dispid 202;
    function ModemUpdateStatus: WordBool; dispid 218;
    function ModemVerifyPacket(PacketID: SYSUINT): WordBool; dispid 203;
    function ModemFindPacket(DayReport: Word; ReceiptNumber: Word; ReceiptType: Byte): WordBool; dispid 204;
    function ModemFindPacketByDateTime(FindDateTime: TDateTime; FindForward: WordBool): WordBool; dispid 267;
    function ModemFindPacketByDateTimeStr(const FindDateTimeStr: WideString; FindForward: WordBool): WordBool; dispid 268;
    function ModemReadKsefPacket(PacketID: LongWord): WordBool; dispid 261;
    function ModemReadKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; dispid 264;
    function ModemReadKsefByZReport(ZReport: Word): WordBool; dispid 265;
    function ModemGetCurrentTask: WordBool; dispid 205;
    function ModemSaveKsefRangeToBin(const Dir: WideString; const FileName: WideString; 
                                     FirstPacketID: LongWord; LastPacketID: LongWord): WordBool; dispid 273;
    function ModemSaveKsefByZreportToBin(const Dir: WideString; const FileName: WideString; 
                                         ZReport: Word): WordBool; dispid 274;
    property glPropertiesAutoUpdateMode: WordBool dispid 212;
    property glCodepageOEM: WordBool dispid 216;
    property glLangID: Byte dispid 217;
    property stWorkSecondCount: Integer readonly dispid 219;
    property stFPExchangeSecondCount: Integer readonly dispid 220;
    property stFirstUnsendPIDDateTime: TDateTime readonly dispid 221;
    property stFirstUnsendPIDDateTimeStr: WideString readonly dispid 222;
    property stPID_Unused: Integer readonly dispid 223;
    property stPID_CurPers: Integer readonly dispid 224;
    property stPID_LastWrite: Integer readonly dispid 225;
    property stPID_LastSign: Integer readonly dispid 226;
    property stPID_LastSend: Integer readonly dispid 227;
    property stSerialNumber: Integer readonly dispid 228;
    property stID_DEV: Integer readonly dispid 229;
    property stID_SAM: Integer readonly dispid 230;
    property stNT_SAM: Integer readonly dispid 231;
    property stNT_SESSION: Integer readonly dispid 232;
    property stFailCode: Byte readonly dispid 233;
    property stRes1: Byte readonly dispid 234;
    property stBatVoltage: Integer readonly dispid 235;
    property stDCVoltage: Integer readonly dispid 236;
    property stBatCurrent: Integer readonly dispid 237;
    property stTemperature: Integer readonly dispid 238;
    property stState1: Byte readonly dispid 239;
    property stState2: Byte readonly dispid 240;
    property stState3: Byte readonly dispid 241;
    property stLanState1: Byte readonly dispid 242;
    property stLanState2: Byte readonly dispid 243;
    property stFPExchangeResult: Byte readonly dispid 244;
    property stACQExchangeResult: Byte readonly dispid 245;
    property stRes2: Byte readonly dispid 246;
    property stFPExchangeErrorCount: Integer readonly dispid 247;
    property stRSSI: Byte readonly dispid 248;
    property stRSSI_BER: Byte readonly dispid 249;
    property stUSSDResult: WideString readonly dispid 250;
    property stOSVer: Integer readonly dispid 251;
    property stOSRev: Integer readonly dispid 252;
    property stSysTime: TDateTime readonly dispid 253;
    property stNETIPAddr: WideString readonly dispid 254;
    property stNETGate: WideString readonly dispid 255;
    property stNETMask: WideString readonly dispid 256;
    property stMODIPAddr: WideString readonly dispid 257;
    property stACQIPAddr: WideString readonly dispid 258;
    property stACQPort: Integer readonly dispid 259;
    property stACQExchangeSecondCount: Integer readonly dispid 260;
    property stSysTimeStr: WideString readonly dispid 263;
    property prFoundPacket: LongWord readonly dispid 209;
    property prFoundPacketStr: WideString readonly dispid 266;
    property prCurrentTaskCode: Byte readonly dispid 210;
    property prCurrentTaskText: WideString readonly dispid 211;
    property prGetErrorCode: Byte readonly dispid 206;
    property prGetErrorText: WideString readonly dispid 207;
    property prRepeatCount: Byte dispid 208;
    property prLogRecording: WordBool dispid 214;
    property prAnswerWaiting: Byte dispid 215;
    property prKsefSavePath: WideString dispid 262;
    property prModemDriverMajorVersion: Byte readonly dispid 269;
    property prModemDriverMinorVersion: Byte readonly dispid 270;
    property prModemDriverReleaseVersion: Byte readonly dispid 271;
    property prModemDriverBuildVersion: Byte readonly dispid 272;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_EP_08
// Help String      : ICS_EP_08 Object
// Default Interface: IICS_EP_08
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_EP_08 = class(TOleControl)
  private
    FIntf: IICS_EP_08;
    function  GetControlInterface: IICS_EP_08;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function FPInitialize: Integer;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool;
    function FPClose: WordBool;
    function FPClaimUSBDevice: WordBool;
    function FPReleaseUSBDevice: WordBool;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
    function FPPrintZeroReceipt: WordBool;
    function FPLineFeed: WordBool;
    function FPAnnulReceipt: WordBool;
    function FPCashIn(CashSum: SYSUINT): WordBool;
    function FPCashOut(CashSum: SYSUINT): WordBool;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
    function FPGetCurrentDate: WordBool;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
    function FPGetCurrentTime: WordBool;
    function FPOpenCashDrawer(Duration: Word): WordBool;
    function FPPrintHardwareVersion: WordBool;
    function FPPrintLastKsefPacket: WordBool;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool;
    function FPOnlineModeSwitch: WordBool;
    function FPCustomerDisplayModeSwitch: WordBool;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
    function FPCloseServiceReport: WordBool;
    function FPEnableLogo(ProgPassword: Word): WordBool;
    function FPDisableLogo(ProgPassword: Word): WordBool;
    function FPSetTaxRates(ProgPassword: Word): WordBool;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool;
    function FPMakeXReport(ReportPassword: Word): WordBool;
    function FPMakeZReport(ReportPassword: Word): WordBool;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool;
    function FPCutterModeSwitch: WordBool;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
    function FPGetPaymentFormNames: WordBool;
    function FPGetCurrentStatus: WordBool;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
    function FPGetCashDrawerSum: WordBool;
    function FPGetDayReportProperties: WordBool;
    function FPGetTaxRates: WordBool;
    function FPGetItemData(ItemCode: Int64): WordBool;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
    function FPGetDayReportData: WordBool;
    function FPGetCurrentReceiptData: WordBool;
    function FPGetDayCorrectionsData: WordBool;
    function FPGetDaySumOfAddTaxes: WordBool;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool;
    function FPPrintModemStatus: WordBool;
    function FPGetUserPassword(UserID: Byte): WordBool;
    function FPGetRevizionID: WordBool;
    property  ControlInterface: IICS_EP_08 read GetControlInterface;
    property  DefaultInterface: IICS_EP_08 read GetControlInterface;
    property glVirtualPortOpened: WordBool index 546 read GetWordBoolProp;
    property stUseAdditionalTax: WordBool index 415 read GetWordBoolProp;
    property stUseAdditionalFee: WordBool index 416 read GetWordBoolProp;
    property stUseFontB: WordBool index 417 read GetWordBoolProp;
    property stUseTradeLogo: WordBool index 418 read GetWordBoolProp;
    property stUseCutter: WordBool index 419 read GetWordBoolProp;
    property stRefundReceiptMode: WordBool index 420 read GetWordBoolProp;
    property stPaymentMode: WordBool index 421 read GetWordBoolProp;
    property stFiscalMode: WordBool index 422 read GetWordBoolProp;
    property stServiceReceiptMode: WordBool index 423 read GetWordBoolProp;
    property stOnlinePrintMode: WordBool index 424 read GetWordBoolProp;
    property stFailureLastCommand: WordBool index 425 read GetWordBoolProp;
    property stFiscalDayIsOpened: WordBool index 426 read GetWordBoolProp;
    property stReceiptIsOpened: WordBool index 427 read GetWordBoolProp;
    property stCashDrawerIsOpened: WordBool index 428 read GetWordBoolProp;
    property stDisplayShowSumMode: WordBool index 441 read GetWordBoolProp;
    property prItemCost: Comp index 257 read GetCompProp;
    property prSumDiscount: Comp index 258 read GetCompProp;
    property prSumMarkup: Comp index 259 read GetCompProp;
    property prSumTotal: Comp index 260 read GetCompProp;
    property prSumBalance: Comp index 261 read GetCompProp;
    property prKSEFPacket: Integer index 262 read GetIntegerProp;
    property prKSEFPacketStr: WideString index 538 read GetWideStringProp;
    property prModemError: Byte index 263 read GetByteProp;
    property prCurrentDate: TDateTime index 264 read GetTDateTimeProp;
    property prCurrentDateStr: WideString index 265 read GetWideStringProp;
    property prCurrentTime: TDateTime index 266 read GetTDateTimeProp;
    property prCurrentTimeStr: WideString index 267 read GetWideStringProp;
    property prTaxRatesDate: TDateTime index 269 read GetTDateTimeProp;
    property prTaxRatesDateStr: WideString index 270 read GetWideStringProp;
    property prTaxRate6: Integer index 277 read GetIntegerProp;
    property prNamePaymentForm1: WideString index 291 read GetWideStringProp;
    property prNamePaymentForm2: WideString index 292 read GetWideStringProp;
    property prNamePaymentForm3: WideString index 293 read GetWideStringProp;
    property prNamePaymentForm4: WideString index 294 read GetWideStringProp;
    property prNamePaymentForm5: WideString index 295 read GetWideStringProp;
    property prNamePaymentForm6: WideString index 296 read GetWideStringProp;
    property prNamePaymentForm7: WideString index 297 read GetWideStringProp;
    property prNamePaymentForm8: WideString index 298 read GetWideStringProp;
    property prNamePaymentForm9: WideString index 299 read GetWideStringProp;
    property prNamePaymentForm10: WideString index 300 read GetWideStringProp;
    property prSerialNumber: WideString index 301 read GetWideStringProp;
    property prFiscalNumber: WideString index 302 read GetWideStringProp;
    property prTaxNumber: WideString index 303 read GetWideStringProp;
    property prDateFiscalization: TDateTime index 304 read GetTDateTimeProp;
    property prDateFiscalizationStr: WideString index 305 read GetWideStringProp;
    property prTimeFiscalization: TDateTime index 306 read GetTDateTimeProp;
    property prTimeFiscalizationStr: WideString index 307 read GetWideStringProp;
    property prHeadLine1: WideString index 308 read GetWideStringProp;
    property prHeadLine2: WideString index 309 read GetWideStringProp;
    property prHeadLine3: WideString index 310 read GetWideStringProp;
    property prHardwareVersion: WideString index 311 read GetWideStringProp;
    property prItemName: WideString index 312 read GetWideStringProp;
    property prItemPrice: Integer index 313 read GetIntegerProp;
    property prItemSaleQuantity: Integer index 314 read GetIntegerProp;
    property prItemSaleQtyPrecision: Byte index 315 read GetByteProp;
    property prItemTax: Byte index 316 read GetByteProp;
    property prItemSaleSum: Comp index 317 read GetCompProp;
    property prItemSaleSumStr: WideString index 318 read GetWideStringProp;
    property prItemRefundQuantity: Integer index 319 read GetIntegerProp;
    property prItemRefundQtyPrecision: Byte index 320 read GetByteProp;
    property prItemRefundSum: Comp index 321 read GetCompProp;
    property prItemRefundSumStr: WideString index 322 read GetWideStringProp;
    property prItemCostStr: WideString index 323 read GetWideStringProp;
    property prSumDiscountStr: WideString index 324 read GetWideStringProp;
    property prSumMarkupStr: WideString index 325 read GetWideStringProp;
    property prSumTotalStr: WideString index 326 read GetWideStringProp;
    property prSumBalanceStr: WideString index 327 read GetWideStringProp;
    property prCurReceiptTax1Sum: Integer index 328 read GetIntegerProp;
    property prCurReceiptTax2Sum: Integer index 329 read GetIntegerProp;
    property prCurReceiptTax3Sum: Integer index 330 read GetIntegerProp;
    property prCurReceiptTax4Sum: Integer index 331 read GetIntegerProp;
    property prCurReceiptTax5Sum: Integer index 332 read GetIntegerProp;
    property prCurReceiptTax6Sum: Integer index 333 read GetIntegerProp;
    property prCurReceiptTax1SumStr: WideString index 457 read GetWideStringProp;
    property prCurReceiptTax2SumStr: WideString index 458 read GetWideStringProp;
    property prCurReceiptTax3SumStr: WideString index 459 read GetWideStringProp;
    property prCurReceiptTax4SumStr: WideString index 460 read GetWideStringProp;
    property prCurReceiptTax5SumStr: WideString index 461 read GetWideStringProp;
    property prCurReceiptTax6SumStr: WideString index 462 read GetWideStringProp;
    property prCurReceiptPayForm1Sum: Integer index 334 read GetIntegerProp;
    property prCurReceiptPayForm2Sum: Integer index 335 read GetIntegerProp;
    property prCurReceiptPayForm3Sum: Integer index 336 read GetIntegerProp;
    property prCurReceiptPayForm4Sum: Integer index 337 read GetIntegerProp;
    property prCurReceiptPayForm5Sum: Integer index 338 read GetIntegerProp;
    property prCurReceiptPayForm6Sum: Integer index 339 read GetIntegerProp;
    property prCurReceiptPayForm7Sum: Integer index 340 read GetIntegerProp;
    property prCurReceiptPayForm8Sum: Integer index 341 read GetIntegerProp;
    property prCurReceiptPayForm9Sum: Integer index 342 read GetIntegerProp;
    property prCurReceiptPayForm10Sum: Integer index 343 read GetIntegerProp;
    property prCurReceiptPayForm1SumStr: WideString index 463 read GetWideStringProp;
    property prCurReceiptPayForm2SumStr: WideString index 464 read GetWideStringProp;
    property prCurReceiptPayForm3SumStr: WideString index 465 read GetWideStringProp;
    property prCurReceiptPayForm4SumStr: WideString index 466 read GetWideStringProp;
    property prCurReceiptPayForm5SumStr: WideString index 467 read GetWideStringProp;
    property prCurReceiptPayForm6SumStr: WideString index 468 read GetWideStringProp;
    property prCurReceiptPayForm7SumStr: WideString index 469 read GetWideStringProp;
    property prCurReceiptPayForm8SumStr: WideString index 470 read GetWideStringProp;
    property prCurReceiptPayForm9SumStr: WideString index 471 read GetWideStringProp;
    property prCurReceiptPayForm10SumStr: WideString index 472 read GetWideStringProp;
    property prPrinterError: WordBool index 344 read GetWordBoolProp;
    property prTapeNearEnd: WordBool index 345 read GetWordBoolProp;
    property prTapeEnded: WordBool index 346 read GetWordBoolProp;
    property prDaySaleReceiptsCount: Word index 347 read GetWordProp;
    property prDaySaleReceiptsCountStr: WideString index 473 read GetWideStringProp;
    property prDayRefundReceiptsCount: Word index 348 read GetWordProp;
    property prDayRefundReceiptsCountStr: WideString index 474 read GetWideStringProp;
    property prDaySaleSumOnTax1: Integer index 349 read GetIntegerProp;
    property prDaySaleSumOnTax2: Integer index 350 read GetIntegerProp;
    property prDaySaleSumOnTax3: Integer index 351 read GetIntegerProp;
    property prDaySaleSumOnTax4: Integer index 352 read GetIntegerProp;
    property prDaySaleSumOnTax5: Integer index 353 read GetIntegerProp;
    property prDaySaleSumOnTax6: Integer index 354 read GetIntegerProp;
    property prDaySaleSumOnTax1Str: WideString index 475 read GetWideStringProp;
    property prDaySaleSumOnTax2Str: WideString index 476 read GetWideStringProp;
    property prDaySaleSumOnTax3Str: WideString index 477 read GetWideStringProp;
    property prDaySaleSumOnTax4Str: WideString index 478 read GetWideStringProp;
    property prDaySaleSumOnTax5Str: WideString index 479 read GetWideStringProp;
    property prDaySaleSumOnTax6Str: WideString index 480 read GetWideStringProp;
    property prDayRefundSumOnTax1: Integer index 355 read GetIntegerProp;
    property prDayRefundSumOnTax2: Integer index 356 read GetIntegerProp;
    property prDayRefundSumOnTax3: Integer index 357 read GetIntegerProp;
    property prDayRefundSumOnTax4: Integer index 358 read GetIntegerProp;
    property prDayRefundSumOnTax5: Integer index 359 read GetIntegerProp;
    property prDayRefundSumOnTax6: Integer index 360 read GetIntegerProp;
    property prDayRefundSumOnTax1Str: WideString index 481 read GetWideStringProp;
    property prDayRefundSumOnTax2Str: WideString index 482 read GetWideStringProp;
    property prDayRefundSumOnTax3Str: WideString index 483 read GetWideStringProp;
    property prDayRefundSumOnTax4Str: WideString index 484 read GetWideStringProp;
    property prDayRefundSumOnTax5Str: WideString index 485 read GetWideStringProp;
    property prDayRefundSumOnTax6Str: WideString index 486 read GetWideStringProp;
    property prDaySaleSumOnPayForm1: Integer index 361 read GetIntegerProp;
    property prDaySaleSumOnPayForm2: Integer index 362 read GetIntegerProp;
    property prDaySaleSumOnPayForm3: Integer index 363 read GetIntegerProp;
    property prDaySaleSumOnPayForm4: Integer index 364 read GetIntegerProp;
    property prDaySaleSumOnPayForm5: Integer index 365 read GetIntegerProp;
    property prDaySaleSumOnPayForm6: Integer index 366 read GetIntegerProp;
    property prDaySaleSumOnPayForm7: Integer index 367 read GetIntegerProp;
    property prDaySaleSumOnPayForm8: Integer index 368 read GetIntegerProp;
    property prDaySaleSumOnPayForm9: Integer index 369 read GetIntegerProp;
    property prDaySaleSumOnPayForm10: Integer index 370 read GetIntegerProp;
    property prDaySaleSumOnPayForm1Str: WideString index 487 read GetWideStringProp;
    property prDaySaleSumOnPayForm2Str: WideString index 488 read GetWideStringProp;
    property prDaySaleSumOnPayForm3Str: WideString index 489 read GetWideStringProp;
    property prDaySaleSumOnPayForm4Str: WideString index 490 read GetWideStringProp;
    property prDaySaleSumOnPayForm5Str: WideString index 491 read GetWideStringProp;
    property prDaySaleSumOnPayForm6Str: WideString index 492 read GetWideStringProp;
    property prDaySaleSumOnPayForm7Str: WideString index 493 read GetWideStringProp;
    property prDaySaleSumOnPayForm8Str: WideString index 494 read GetWideStringProp;
    property prDaySaleSumOnPayForm9Str: WideString index 495 read GetWideStringProp;
    property prDaySaleSumOnPayForm10Str: WideString index 496 read GetWideStringProp;
    property prDayRefundSumOnPayForm1: Integer index 371 read GetIntegerProp;
    property prDayRefundSumOnPayForm2: Integer index 372 read GetIntegerProp;
    property prDayRefundSumOnPayForm3: Integer index 373 read GetIntegerProp;
    property prDayRefundSumOnPayForm4: Integer index 374 read GetIntegerProp;
    property prDayRefundSumOnPayForm5: Integer index 375 read GetIntegerProp;
    property prDayRefundSumOnPayForm6: Integer index 376 read GetIntegerProp;
    property prDayRefundSumOnPayForm7: Integer index 377 read GetIntegerProp;
    property prDayRefundSumOnPayForm8: Integer index 378 read GetIntegerProp;
    property prDayRefundSumOnPayForm9: Integer index 379 read GetIntegerProp;
    property prDayRefundSumOnPayForm10: Integer index 380 read GetIntegerProp;
    property prDayRefundSumOnPayForm1Str: WideString index 497 read GetWideStringProp;
    property prDayRefundSumOnPayForm2Str: WideString index 498 read GetWideStringProp;
    property prDayRefundSumOnPayForm3Str: WideString index 499 read GetWideStringProp;
    property prDayRefundSumOnPayForm4Str: WideString index 500 read GetWideStringProp;
    property prDayRefundSumOnPayForm5Str: WideString index 501 read GetWideStringProp;
    property prDayRefundSumOnPayForm6Str: WideString index 502 read GetWideStringProp;
    property prDayRefundSumOnPayForm7Str: WideString index 503 read GetWideStringProp;
    property prDayRefundSumOnPayForm8Str: WideString index 504 read GetWideStringProp;
    property prDayRefundSumOnPayForm9Str: WideString index 505 read GetWideStringProp;
    property prDayRefundSumOnPayForm10Str: WideString index 506 read GetWideStringProp;
    property prDayDiscountSumOnSales: Integer index 381 read GetIntegerProp;
    property prDayDiscountSumOnSalesStr: WideString index 507 read GetWideStringProp;
    property prDayMarkupSumOnSales: Integer index 382 read GetIntegerProp;
    property prDayMarkupSumOnSalesStr: WideString index 508 read GetWideStringProp;
    property prDayDiscountSumOnRefunds: Integer index 383 read GetIntegerProp;
    property prDayDiscountSumOnRefundsStr: WideString index 509 read GetWideStringProp;
    property prDayMarkupSumOnRefunds: Integer index 384 read GetIntegerProp;
    property prDayMarkupSumOnRefundsStr: WideString index 510 read GetWideStringProp;
    property prDayCashInSum: Integer index 385 read GetIntegerProp;
    property prDayCashInSumStr: WideString index 511 read GetWideStringProp;
    property prDayCashOutSum: Integer index 386 read GetIntegerProp;
    property prDayCashOutSumStr: WideString index 512 read GetWideStringProp;
    property prCurrentZReport: Word index 387 read GetWordProp;
    property prCurrentZReportStr: WideString index 513 read GetWideStringProp;
    property prDayEndDate: TDateTime index 388 read GetTDateTimeProp;
    property prDayEndDateStr: WideString index 389 read GetWideStringProp;
    property prDayEndTime: TDateTime index 390 read GetTDateTimeProp;
    property prDayEndTimeStr: WideString index 391 read GetWideStringProp;
    property prLastZReportDate: TDateTime index 392 read GetTDateTimeProp;
    property prLastZReportDateStr: WideString index 393 read GetWideStringProp;
    property prItemsCount: Word index 394 read GetWordProp;
    property prItemsCountStr: WideString index 514 read GetWideStringProp;
    property prDaySumAddTaxOfSale1: Integer index 395 read GetIntegerProp;
    property prDaySumAddTaxOfSale2: Integer index 396 read GetIntegerProp;
    property prDaySumAddTaxOfSale3: Integer index 397 read GetIntegerProp;
    property prDaySumAddTaxOfSale4: Integer index 398 read GetIntegerProp;
    property prDaySumAddTaxOfSale5: Integer index 399 read GetIntegerProp;
    property prDaySumAddTaxOfSale6: Integer index 400 read GetIntegerProp;
    property prDaySumAddTaxOfSale1Str: WideString index 515 read GetWideStringProp;
    property prDaySumAddTaxOfSale2Str: WideString index 516 read GetWideStringProp;
    property prDaySumAddTaxOfSale3Str: WideString index 517 read GetWideStringProp;
    property prDaySumAddTaxOfSale4Str: WideString index 518 read GetWideStringProp;
    property prDaySumAddTaxOfSale5Str: WideString index 519 read GetWideStringProp;
    property prDaySumAddTaxOfSale6Str: WideString index 520 read GetWideStringProp;
    property prDaySumAddTaxOfRefund1: Integer index 401 read GetIntegerProp;
    property prDaySumAddTaxOfRefund2: Integer index 402 read GetIntegerProp;
    property prDaySumAddTaxOfRefund3: Integer index 403 read GetIntegerProp;
    property prDaySumAddTaxOfRefund4: Integer index 404 read GetIntegerProp;
    property prDaySumAddTaxOfRefund5: Integer index 405 read GetIntegerProp;
    property prDaySumAddTaxOfRefund6: Integer index 406 read GetIntegerProp;
    property prDaySumAddTaxOfRefund1Str: WideString index 521 read GetWideStringProp;
    property prDaySumAddTaxOfRefund2Str: WideString index 522 read GetWideStringProp;
    property prDaySumAddTaxOfRefund3Str: WideString index 523 read GetWideStringProp;
    property prDaySumAddTaxOfRefund4Str: WideString index 524 read GetWideStringProp;
    property prDaySumAddTaxOfRefund5Str: WideString index 525 read GetWideStringProp;
    property prDaySumAddTaxOfRefund6Str: WideString index 526 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsCount: Word index 407 read GetWordProp;
    property prDayAnnuledSaleReceiptsCountStr: WideString index 527 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsCount: Word index 408 read GetWordProp;
    property prDayAnnuledRefundReceiptsCountStr: WideString index 528 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsSum: Integer index 409 read GetIntegerProp;
    property prDayAnnuledSaleReceiptsSumStr: WideString index 529 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsSum: Integer index 410 read GetIntegerProp;
    property prDayAnnuledRefundReceiptsSumStr: WideString index 530 read GetWideStringProp;
    property prDaySaleCancelingsCount: Word index 411 read GetWordProp;
    property prDaySaleCancelingsCountStr: WideString index 531 read GetWideStringProp;
    property prDayRefundCancelingsCount: Word index 412 read GetWordProp;
    property prDayRefundCancelingsCountStr: WideString index 532 read GetWideStringProp;
    property prDaySaleCancelingsSum: Integer index 413 read GetIntegerProp;
    property prDaySaleCancelingsSumStr: WideString index 533 read GetWideStringProp;
    property prDayRefundCancelingsSum: Integer index 414 read GetIntegerProp;
    property prDayRefundCancelingsSumStr: WideString index 534 read GetWideStringProp;
    property prCashDrawerSum: Comp index 429 read GetCompProp;
    property prCashDrawerSumStr: WideString index 430 read GetWideStringProp;
    property prGetStatusByte: Byte index 436 read GetByteProp;
    property prGetResultByte: Byte index 437 read GetByteProp;
    property prGetReserveByte: Byte index 438 read GetByteProp;
    property prGetErrorText: WideString index 439 read GetWideStringProp;
    property prCurReceiptItemCount: Byte index 451 read GetByteProp;
    property prUserPassword: Word index 536 read GetWordProp;
    property prUserPasswordStr: WideString index 537 read GetWideStringProp;
    property prRevizionID: Byte index 541 read GetByteProp;
    property prFPDriverMajorVersion: Byte index 542 read GetByteProp;
    property prFPDriverMinorVersion: Byte index 543 read GetByteProp;
    property prFPDriverReleaseVersion: Byte index 544 read GetByteProp;
    property prFPDriverBuildVersion: Byte index 545 read GetByteProp;
  published
    property Anchors;
    property glTapeAnalizer: WordBool index 253 read GetWordBoolProp write SetWordBoolProp stored False;
    property glPropertiesAutoUpdateMode: WordBool index 254 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 255 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 256 read GetByteProp write SetByteProp stored False;
    property glUseVirtualPort: WordBool index 547 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRatesCount: Byte index 268 read GetByteProp write SetByteProp stored False;
    property prAddTaxType: WordBool index 271 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRate1: Integer index 272 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate2: Integer index 273 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate3: Integer index 274 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate4: Integer index 275 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate5: Integer index 276 read GetIntegerProp write SetIntegerProp stored False;
    property prUsedAdditionalFee: WordBool index 278 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeRate1: Integer index 279 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate2: Integer index 280 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate3: Integer index 281 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate4: Integer index 282 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate5: Integer index 283 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate6: Integer index 284 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxOnAddFee1: WordBool index 285 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee2: WordBool index 286 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee3: WordBool index 287 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee4: WordBool index 288 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee5: WordBool index 289 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee6: WordBool index 290 read GetWordBoolProp write SetWordBoolProp stored False;
    property prRepeatCount: Byte index 431 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 432 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 434 read GetByteProp write SetByteProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_EP_09
// Help String      : ICS_EP_09 Object
// Default Interface: IICS_EP_09
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_EP_09 = class(TOleControl)
  private
    FIntf: IICS_EP_09;
    function  GetControlInterface: IICS_EP_09;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function FPInitialize: Integer;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool;
    function FPClose: WordBool;
    function FPClaimUSBDevice: WordBool;
    function FPReleaseUSBDevice: WordBool;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
    function FPPrintZeroReceipt: WordBool;
    function FPLineFeed: WordBool;
    function FPAnnulReceipt: WordBool;
    function FPCashIn(CashSum: SYSUINT): WordBool;
    function FPCashOut(CashSum: SYSUINT): WordBool;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
    function FPGetCurrentDate: WordBool;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
    function FPGetCurrentTime: WordBool;
    function FPOpenCashDrawer(Duration: Word): WordBool;
    function FPPrintHardwareVersion: WordBool;
    function FPPrintLastKsefPacket: WordBool;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool;
    function FPOnlineModeSwitch: WordBool;
    function FPCustomerDisplayModeSwitch: WordBool;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
    function FPCloseServiceReport: WordBool;
    function FPEnableLogo(ProgPassword: Word): WordBool;
    function FPDisableLogo(ProgPassword: Word): WordBool;
    function FPSetTaxRates(ProgPassword: Word): WordBool;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool;
    function FPMakeXReport(ReportPassword: Word): WordBool;
    function FPMakeZReport(ReportPassword: Word): WordBool;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool;
    function FPCutterModeSwitch: WordBool;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
    function FPGetPaymentFormNames: WordBool;
    function FPGetCurrentStatus: WordBool;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
    function FPGetCashDrawerSum: WordBool;
    function FPGetDayReportProperties: WordBool;
    function FPGetTaxRates: WordBool;
    function FPGetItemData(ItemCode: Int64): WordBool;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
    function FPGetDayReportData: WordBool;
    function FPGetCurrentReceiptData: WordBool;
    function FPGetDayCorrectionsData: WordBool;
    function FPGetDaySumOfAddTaxes: WordBool;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool;
    function FPPrintModemStatus: WordBool;
    function FPGetUserPassword(UserID: Byte): WordBool;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
    function FPPrintQRCode(const SerialQR: WideString): WordBool;
    function FPGetRevizionID: WordBool;
    property  ControlInterface: IICS_EP_09 read GetControlInterface;
    property  DefaultInterface: IICS_EP_09 read GetControlInterface;
    property glVirtualPortOpened: WordBool index 554 read GetWordBoolProp;
    property stUseAdditionalTax: WordBool index 415 read GetWordBoolProp;
    property stUseAdditionalFee: WordBool index 416 read GetWordBoolProp;
    property stUseFontB: WordBool index 417 read GetWordBoolProp;
    property stUseTradeLogo: WordBool index 418 read GetWordBoolProp;
    property stUseCutter: WordBool index 419 read GetWordBoolProp;
    property stRefundReceiptMode: WordBool index 420 read GetWordBoolProp;
    property stPaymentMode: WordBool index 421 read GetWordBoolProp;
    property stFiscalMode: WordBool index 422 read GetWordBoolProp;
    property stServiceReceiptMode: WordBool index 423 read GetWordBoolProp;
    property stOnlinePrintMode: WordBool index 424 read GetWordBoolProp;
    property stFailureLastCommand: WordBool index 425 read GetWordBoolProp;
    property stFiscalDayIsOpened: WordBool index 426 read GetWordBoolProp;
    property stReceiptIsOpened: WordBool index 427 read GetWordBoolProp;
    property stCashDrawerIsOpened: WordBool index 428 read GetWordBoolProp;
    property stDisplayShowSumMode: WordBool index 441 read GetWordBoolProp;
    property prItemCost: Comp index 257 read GetCompProp;
    property prSumDiscount: Comp index 258 read GetCompProp;
    property prSumMarkup: Comp index 259 read GetCompProp;
    property prSumTotal: Comp index 260 read GetCompProp;
    property prSumBalance: Comp index 261 read GetCompProp;
    property prKSEFPacket: Integer index 262 read GetIntegerProp;
    property prKSEFPacketStr: WideString index 538 read GetWideStringProp;
    property prModemError: Byte index 263 read GetByteProp;
    property prCurrentDate: TDateTime index 264 read GetTDateTimeProp;
    property prCurrentDateStr: WideString index 265 read GetWideStringProp;
    property prCurrentTime: TDateTime index 266 read GetTDateTimeProp;
    property prCurrentTimeStr: WideString index 267 read GetWideStringProp;
    property prTaxRatesDate: TDateTime index 269 read GetTDateTimeProp;
    property prTaxRatesDateStr: WideString index 270 read GetWideStringProp;
    property prTaxRate6: Integer index 277 read GetIntegerProp;
    property prNamePaymentForm1: WideString index 291 read GetWideStringProp;
    property prNamePaymentForm2: WideString index 292 read GetWideStringProp;
    property prNamePaymentForm3: WideString index 293 read GetWideStringProp;
    property prNamePaymentForm4: WideString index 294 read GetWideStringProp;
    property prNamePaymentForm5: WideString index 295 read GetWideStringProp;
    property prNamePaymentForm6: WideString index 296 read GetWideStringProp;
    property prNamePaymentForm7: WideString index 297 read GetWideStringProp;
    property prNamePaymentForm8: WideString index 298 read GetWideStringProp;
    property prNamePaymentForm9: WideString index 299 read GetWideStringProp;
    property prNamePaymentForm10: WideString index 300 read GetWideStringProp;
    property prSerialNumber: WideString index 301 read GetWideStringProp;
    property prFiscalNumber: WideString index 302 read GetWideStringProp;
    property prTaxNumber: WideString index 303 read GetWideStringProp;
    property prDateFiscalization: TDateTime index 304 read GetTDateTimeProp;
    property prDateFiscalizationStr: WideString index 305 read GetWideStringProp;
    property prTimeFiscalization: TDateTime index 306 read GetTDateTimeProp;
    property prTimeFiscalizationStr: WideString index 307 read GetWideStringProp;
    property prHeadLine1: WideString index 308 read GetWideStringProp;
    property prHeadLine2: WideString index 309 read GetWideStringProp;
    property prHeadLine3: WideString index 310 read GetWideStringProp;
    property prHardwareVersion: WideString index 311 read GetWideStringProp;
    property prItemName: WideString index 312 read GetWideStringProp;
    property prItemPrice: Integer index 313 read GetIntegerProp;
    property prItemSaleQuantity: Integer index 314 read GetIntegerProp;
    property prItemSaleQtyPrecision: Byte index 315 read GetByteProp;
    property prItemTax: Byte index 316 read GetByteProp;
    property prItemSaleSum: Comp index 317 read GetCompProp;
    property prItemSaleSumStr: WideString index 318 read GetWideStringProp;
    property prItemRefundQuantity: Integer index 319 read GetIntegerProp;
    property prItemRefundQtyPrecision: Byte index 320 read GetByteProp;
    property prItemRefundSum: Comp index 321 read GetCompProp;
    property prItemRefundSumStr: WideString index 322 read GetWideStringProp;
    property prItemCostStr: WideString index 323 read GetWideStringProp;
    property prSumDiscountStr: WideString index 324 read GetWideStringProp;
    property prSumMarkupStr: WideString index 325 read GetWideStringProp;
    property prSumTotalStr: WideString index 326 read GetWideStringProp;
    property prSumBalanceStr: WideString index 327 read GetWideStringProp;
    property prCurReceiptTax1Sum: Integer index 328 read GetIntegerProp;
    property prCurReceiptTax2Sum: Integer index 329 read GetIntegerProp;
    property prCurReceiptTax3Sum: Integer index 330 read GetIntegerProp;
    property prCurReceiptTax4Sum: Integer index 331 read GetIntegerProp;
    property prCurReceiptTax5Sum: Integer index 332 read GetIntegerProp;
    property prCurReceiptTax6Sum: Integer index 333 read GetIntegerProp;
    property prCurReceiptTax1SumStr: WideString index 457 read GetWideStringProp;
    property prCurReceiptTax2SumStr: WideString index 458 read GetWideStringProp;
    property prCurReceiptTax3SumStr: WideString index 459 read GetWideStringProp;
    property prCurReceiptTax4SumStr: WideString index 460 read GetWideStringProp;
    property prCurReceiptTax5SumStr: WideString index 461 read GetWideStringProp;
    property prCurReceiptTax6SumStr: WideString index 462 read GetWideStringProp;
    property prCurReceiptPayForm1Sum: Integer index 334 read GetIntegerProp;
    property prCurReceiptPayForm2Sum: Integer index 335 read GetIntegerProp;
    property prCurReceiptPayForm3Sum: Integer index 336 read GetIntegerProp;
    property prCurReceiptPayForm4Sum: Integer index 337 read GetIntegerProp;
    property prCurReceiptPayForm5Sum: Integer index 338 read GetIntegerProp;
    property prCurReceiptPayForm6Sum: Integer index 339 read GetIntegerProp;
    property prCurReceiptPayForm7Sum: Integer index 340 read GetIntegerProp;
    property prCurReceiptPayForm8Sum: Integer index 341 read GetIntegerProp;
    property prCurReceiptPayForm9Sum: Integer index 342 read GetIntegerProp;
    property prCurReceiptPayForm10Sum: Integer index 343 read GetIntegerProp;
    property prCurReceiptPayForm1SumStr: WideString index 463 read GetWideStringProp;
    property prCurReceiptPayForm2SumStr: WideString index 464 read GetWideStringProp;
    property prCurReceiptPayForm3SumStr: WideString index 465 read GetWideStringProp;
    property prCurReceiptPayForm4SumStr: WideString index 466 read GetWideStringProp;
    property prCurReceiptPayForm5SumStr: WideString index 467 read GetWideStringProp;
    property prCurReceiptPayForm6SumStr: WideString index 468 read GetWideStringProp;
    property prCurReceiptPayForm7SumStr: WideString index 469 read GetWideStringProp;
    property prCurReceiptPayForm8SumStr: WideString index 470 read GetWideStringProp;
    property prCurReceiptPayForm9SumStr: WideString index 471 read GetWideStringProp;
    property prCurReceiptPayForm10SumStr: WideString index 472 read GetWideStringProp;
    property prPrinterError: WordBool index 344 read GetWordBoolProp;
    property prTapeNearEnd: WordBool index 345 read GetWordBoolProp;
    property prTapeEnded: WordBool index 346 read GetWordBoolProp;
    property prDaySaleReceiptsCount: Word index 347 read GetWordProp;
    property prDaySaleReceiptsCountStr: WideString index 473 read GetWideStringProp;
    property prDayRefundReceiptsCount: Word index 348 read GetWordProp;
    property prDayRefundReceiptsCountStr: WideString index 474 read GetWideStringProp;
    property prDaySaleSumOnTax1: Integer index 349 read GetIntegerProp;
    property prDaySaleSumOnTax2: Integer index 350 read GetIntegerProp;
    property prDaySaleSumOnTax3: Integer index 351 read GetIntegerProp;
    property prDaySaleSumOnTax4: Integer index 352 read GetIntegerProp;
    property prDaySaleSumOnTax5: Integer index 353 read GetIntegerProp;
    property prDaySaleSumOnTax6: Integer index 354 read GetIntegerProp;
    property prDaySaleSumOnTax1Str: WideString index 475 read GetWideStringProp;
    property prDaySaleSumOnTax2Str: WideString index 476 read GetWideStringProp;
    property prDaySaleSumOnTax3Str: WideString index 477 read GetWideStringProp;
    property prDaySaleSumOnTax4Str: WideString index 478 read GetWideStringProp;
    property prDaySaleSumOnTax5Str: WideString index 479 read GetWideStringProp;
    property prDaySaleSumOnTax6Str: WideString index 480 read GetWideStringProp;
    property prDayRefundSumOnTax1: Integer index 355 read GetIntegerProp;
    property prDayRefundSumOnTax2: Integer index 356 read GetIntegerProp;
    property prDayRefundSumOnTax3: Integer index 357 read GetIntegerProp;
    property prDayRefundSumOnTax4: Integer index 358 read GetIntegerProp;
    property prDayRefundSumOnTax5: Integer index 359 read GetIntegerProp;
    property prDayRefundSumOnTax6: Integer index 360 read GetIntegerProp;
    property prDayRefundSumOnTax1Str: WideString index 481 read GetWideStringProp;
    property prDayRefundSumOnTax2Str: WideString index 482 read GetWideStringProp;
    property prDayRefundSumOnTax3Str: WideString index 483 read GetWideStringProp;
    property prDayRefundSumOnTax4Str: WideString index 484 read GetWideStringProp;
    property prDayRefundSumOnTax5Str: WideString index 485 read GetWideStringProp;
    property prDayRefundSumOnTax6Str: WideString index 486 read GetWideStringProp;
    property prDaySaleSumOnPayForm1: Integer index 361 read GetIntegerProp;
    property prDaySaleSumOnPayForm2: Integer index 362 read GetIntegerProp;
    property prDaySaleSumOnPayForm3: Integer index 363 read GetIntegerProp;
    property prDaySaleSumOnPayForm4: Integer index 364 read GetIntegerProp;
    property prDaySaleSumOnPayForm5: Integer index 365 read GetIntegerProp;
    property prDaySaleSumOnPayForm6: Integer index 366 read GetIntegerProp;
    property prDaySaleSumOnPayForm7: Integer index 367 read GetIntegerProp;
    property prDaySaleSumOnPayForm8: Integer index 368 read GetIntegerProp;
    property prDaySaleSumOnPayForm9: Integer index 369 read GetIntegerProp;
    property prDaySaleSumOnPayForm10: Integer index 370 read GetIntegerProp;
    property prDaySaleSumOnPayForm1Str: WideString index 487 read GetWideStringProp;
    property prDaySaleSumOnPayForm2Str: WideString index 488 read GetWideStringProp;
    property prDaySaleSumOnPayForm3Str: WideString index 489 read GetWideStringProp;
    property prDaySaleSumOnPayForm4Str: WideString index 490 read GetWideStringProp;
    property prDaySaleSumOnPayForm5Str: WideString index 491 read GetWideStringProp;
    property prDaySaleSumOnPayForm6Str: WideString index 492 read GetWideStringProp;
    property prDaySaleSumOnPayForm7Str: WideString index 493 read GetWideStringProp;
    property prDaySaleSumOnPayForm8Str: WideString index 494 read GetWideStringProp;
    property prDaySaleSumOnPayForm9Str: WideString index 495 read GetWideStringProp;
    property prDaySaleSumOnPayForm10Str: WideString index 496 read GetWideStringProp;
    property prDayRefundSumOnPayForm1: Integer index 371 read GetIntegerProp;
    property prDayRefundSumOnPayForm2: Integer index 372 read GetIntegerProp;
    property prDayRefundSumOnPayForm3: Integer index 373 read GetIntegerProp;
    property prDayRefundSumOnPayForm4: Integer index 374 read GetIntegerProp;
    property prDayRefundSumOnPayForm5: Integer index 375 read GetIntegerProp;
    property prDayRefundSumOnPayForm6: Integer index 376 read GetIntegerProp;
    property prDayRefundSumOnPayForm7: Integer index 377 read GetIntegerProp;
    property prDayRefundSumOnPayForm8: Integer index 378 read GetIntegerProp;
    property prDayRefundSumOnPayForm9: Integer index 379 read GetIntegerProp;
    property prDayRefundSumOnPayForm10: Integer index 380 read GetIntegerProp;
    property prDayRefundSumOnPayForm1Str: WideString index 497 read GetWideStringProp;
    property prDayRefundSumOnPayForm2Str: WideString index 498 read GetWideStringProp;
    property prDayRefundSumOnPayForm3Str: WideString index 499 read GetWideStringProp;
    property prDayRefundSumOnPayForm4Str: WideString index 500 read GetWideStringProp;
    property prDayRefundSumOnPayForm5Str: WideString index 501 read GetWideStringProp;
    property prDayRefundSumOnPayForm6Str: WideString index 502 read GetWideStringProp;
    property prDayRefundSumOnPayForm7Str: WideString index 503 read GetWideStringProp;
    property prDayRefundSumOnPayForm8Str: WideString index 504 read GetWideStringProp;
    property prDayRefundSumOnPayForm9Str: WideString index 505 read GetWideStringProp;
    property prDayRefundSumOnPayForm10Str: WideString index 506 read GetWideStringProp;
    property prDayDiscountSumOnSales: Integer index 381 read GetIntegerProp;
    property prDayDiscountSumOnSalesStr: WideString index 507 read GetWideStringProp;
    property prDayMarkupSumOnSales: Integer index 382 read GetIntegerProp;
    property prDayMarkupSumOnSalesStr: WideString index 508 read GetWideStringProp;
    property prDayDiscountSumOnRefunds: Integer index 383 read GetIntegerProp;
    property prDayDiscountSumOnRefundsStr: WideString index 509 read GetWideStringProp;
    property prDayMarkupSumOnRefunds: Integer index 384 read GetIntegerProp;
    property prDayMarkupSumOnRefundsStr: WideString index 510 read GetWideStringProp;
    property prDayCashInSum: Integer index 385 read GetIntegerProp;
    property prDayCashInSumStr: WideString index 511 read GetWideStringProp;
    property prDayCashOutSum: Integer index 386 read GetIntegerProp;
    property prDayCashOutSumStr: WideString index 512 read GetWideStringProp;
    property prCurrentZReport: Word index 387 read GetWordProp;
    property prCurrentZReportStr: WideString index 513 read GetWideStringProp;
    property prDayEndDate: TDateTime index 388 read GetTDateTimeProp;
    property prDayEndDateStr: WideString index 389 read GetWideStringProp;
    property prDayEndTime: TDateTime index 390 read GetTDateTimeProp;
    property prDayEndTimeStr: WideString index 391 read GetWideStringProp;
    property prLastZReportDate: TDateTime index 392 read GetTDateTimeProp;
    property prLastZReportDateStr: WideString index 393 read GetWideStringProp;
    property prItemsCount: Word index 394 read GetWordProp;
    property prItemsCountStr: WideString index 514 read GetWideStringProp;
    property prDaySumAddTaxOfSale1: Integer index 395 read GetIntegerProp;
    property prDaySumAddTaxOfSale2: Integer index 396 read GetIntegerProp;
    property prDaySumAddTaxOfSale3: Integer index 397 read GetIntegerProp;
    property prDaySumAddTaxOfSale4: Integer index 398 read GetIntegerProp;
    property prDaySumAddTaxOfSale5: Integer index 399 read GetIntegerProp;
    property prDaySumAddTaxOfSale6: Integer index 400 read GetIntegerProp;
    property prDaySumAddTaxOfSale1Str: WideString index 515 read GetWideStringProp;
    property prDaySumAddTaxOfSale2Str: WideString index 516 read GetWideStringProp;
    property prDaySumAddTaxOfSale3Str: WideString index 517 read GetWideStringProp;
    property prDaySumAddTaxOfSale4Str: WideString index 518 read GetWideStringProp;
    property prDaySumAddTaxOfSale5Str: WideString index 519 read GetWideStringProp;
    property prDaySumAddTaxOfSale6Str: WideString index 520 read GetWideStringProp;
    property prDaySumAddTaxOfRefund1: Integer index 401 read GetIntegerProp;
    property prDaySumAddTaxOfRefund2: Integer index 402 read GetIntegerProp;
    property prDaySumAddTaxOfRefund3: Integer index 403 read GetIntegerProp;
    property prDaySumAddTaxOfRefund4: Integer index 404 read GetIntegerProp;
    property prDaySumAddTaxOfRefund5: Integer index 405 read GetIntegerProp;
    property prDaySumAddTaxOfRefund6: Integer index 406 read GetIntegerProp;
    property prDaySumAddTaxOfRefund1Str: WideString index 521 read GetWideStringProp;
    property prDaySumAddTaxOfRefund2Str: WideString index 522 read GetWideStringProp;
    property prDaySumAddTaxOfRefund3Str: WideString index 523 read GetWideStringProp;
    property prDaySumAddTaxOfRefund4Str: WideString index 524 read GetWideStringProp;
    property prDaySumAddTaxOfRefund5Str: WideString index 525 read GetWideStringProp;
    property prDaySumAddTaxOfRefund6Str: WideString index 526 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsCount: Word index 407 read GetWordProp;
    property prDayAnnuledSaleReceiptsCountStr: WideString index 527 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsCount: Word index 408 read GetWordProp;
    property prDayAnnuledRefundReceiptsCountStr: WideString index 528 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsSum: Integer index 409 read GetIntegerProp;
    property prDayAnnuledSaleReceiptsSumStr: WideString index 529 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsSum: Integer index 410 read GetIntegerProp;
    property prDayAnnuledRefundReceiptsSumStr: WideString index 530 read GetWideStringProp;
    property prDaySaleCancelingsCount: Word index 411 read GetWordProp;
    property prDaySaleCancelingsCountStr: WideString index 531 read GetWideStringProp;
    property prDayRefundCancelingsCount: Word index 412 read GetWordProp;
    property prDayRefundCancelingsCountStr: WideString index 532 read GetWideStringProp;
    property prDaySaleCancelingsSum: Integer index 413 read GetIntegerProp;
    property prDaySaleCancelingsSumStr: WideString index 533 read GetWideStringProp;
    property prDayRefundCancelingsSum: Integer index 414 read GetIntegerProp;
    property prDayRefundCancelingsSumStr: WideString index 534 read GetWideStringProp;
    property prCashDrawerSum: Comp index 429 read GetCompProp;
    property prCashDrawerSumStr: WideString index 430 read GetWideStringProp;
    property prGetStatusByte: Byte index 436 read GetByteProp;
    property prGetResultByte: Byte index 437 read GetByteProp;
    property prGetReserveByte: Byte index 438 read GetByteProp;
    property prGetErrorText: WideString index 439 read GetWideStringProp;
    property prCurReceiptItemCount: Byte index 451 read GetByteProp;
    property prUserPassword: Word index 536 read GetWordProp;
    property prUserPasswordStr: WideString index 537 read GetWideStringProp;
    property prRevizionID: Byte index 541 read GetByteProp;
    property prFPDriverMajorVersion: Byte index 542 read GetByteProp;
    property prFPDriverMinorVersion: Byte index 543 read GetByteProp;
    property prFPDriverReleaseVersion: Byte index 544 read GetByteProp;
    property prFPDriverBuildVersion: Byte index 545 read GetByteProp;
  published
    property Anchors;
    property glTapeAnalizer: WordBool index 253 read GetWordBoolProp write SetWordBoolProp stored False;
    property glPropertiesAutoUpdateMode: WordBool index 254 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 255 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 256 read GetByteProp write SetByteProp stored False;
    property glUseVirtualPort: WordBool index 555 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRatesCount: Byte index 268 read GetByteProp write SetByteProp stored False;
    property prAddTaxType: WordBool index 271 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRate1: Integer index 272 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate2: Integer index 273 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate3: Integer index 274 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate4: Integer index 275 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate5: Integer index 276 read GetIntegerProp write SetIntegerProp stored False;
    property prUsedAdditionalFee: WordBool index 278 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeRate1: Integer index 279 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate2: Integer index 280 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate3: Integer index 281 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate4: Integer index 282 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate5: Integer index 283 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate6: Integer index 284 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxOnAddFee1: WordBool index 285 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee2: WordBool index 286 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee3: WordBool index 287 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee4: WordBool index 288 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee5: WordBool index 289 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee6: WordBool index 290 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice1: WordBool index 546 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice2: WordBool index 547 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice3: WordBool index 550 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice4: WordBool index 551 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice5: WordBool index 552 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice6: WordBool index 553 read GetWordBoolProp write SetWordBoolProp stored False;
    property prRepeatCount: Byte index 431 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 432 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 434 read GetByteProp write SetByteProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_EP_11
// Help String      : ICS_EP_11 Object
// Default Interface: IICS_EP_11
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_EP_11 = class(TOleControl)
  private
    FIntf: IICS_EP_11;
    function  GetControlInterface: IICS_EP_11;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_prGetBitmapIndex(id: Byte): Byte;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString;
    function Get_prUDPDeviceMAC(id: Byte): WideString;
    function Get_prUDPDeviceIP(id: Byte): WideString;
    function Get_prUDPDeviceTCPport(id: Byte): Word;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString;
  public
    function FPInitialize: Integer;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool;
    function FPClose: WordBool;
    function FPClaimUSBDevice: WordBool;
    function FPReleaseUSBDevice: WordBool;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
    function FPTCPClose: WordBool;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
    function FPPrintZeroReceipt: WordBool;
    function FPLineFeed: WordBool;
    function FPAnnulReceipt: WordBool;
    function FPCashIn(CashSum: SYSUINT): WordBool;
    function FPCashOut(CashSum: SYSUINT): WordBool;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
    function FPGetCurrentDate: WordBool;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
    function FPGetCurrentTime: WordBool;
    function FPOpenCashDrawer(Duration: Word): WordBool;
    function FPPrintHardwareVersion: WordBool;
    function FPPrintLastKsefPacket: WordBool;
    function FPPrintKsefPacket(PacketID: SYSUINT): WordBool;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool;
    function FPOnlineModeSwitch: WordBool;
    function FPCustomerDisplayModeSwitch: WordBool;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
    function FPCloseServiceReport: WordBool;
    function FPEnableLogo(ProgPassword: Word): WordBool;
    function FPDisableLogo(ProgPassword: Word): WordBool;
    function FPSetTaxRates(ProgPassword: Word): WordBool;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool;
    function FPMakeXReport(ReportPassword: Word): WordBool;
    function FPMakeZReport(ReportPassword: Word): WordBool;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool;
    function FPCutterModeSwitch: WordBool;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
    function FPGetPaymentFormNames: WordBool;
    function FPGetCurrentStatus: WordBool;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
    function FPGetCashDrawerSum: WordBool;
    function FPGetDayReportProperties: WordBool;
    function FPGetTaxRates: WordBool;
    function FPGetItemData(ItemCode: Int64): WordBool;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
    function FPGetDayReportData: WordBool;
    function FPGetCurrentReceiptData: WordBool;
    function FPGetDayCorrectionsData: WordBool;
    function FPGetDayPacketData: WordBool;
    function FPGetDaySumOfAddTaxes: WordBool;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool;
    function FPPrintModemStatus: WordBool;
    function FPGetUserPassword(UserID: Byte): WordBool;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
    function FPPrintQRCode(const SerialQR: WideString): WordBool;
    function FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool;
    function FPClearGraphicPattern: WordBool;
    function FPUploadStaticGraphicData: WordBool;
    function FPUploadGraphicDoc: WordBool;
    function FPPrintGraphicDoc: WordBool;
    function FPDeleteGraphicBitmaps: WordBool;
    function FPGetGraphicFreeMemorySize: WordBool;
    function FPUploadImagesFromPattern(InvertColors: WordBool): WordBool;
    function FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool;
    function FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool;
    function FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool;
    function FPGetGraphicObjectsList: WordBool;
    function FPDeleteBitmapObject(ObjIndex: Byte): WordBool;
    function FPFullEraseGraphicMemory: WordBool;
    function FPEraseLogo: WordBool;
    function FPGetRevizionID: WordBool;
    property  ControlInterface: IICS_EP_11 read GetControlInterface;
    property  DefaultInterface: IICS_EP_11 read GetControlInterface;
    property glVirtualPortOpened: WordBool index 576 read GetWordBoolProp;
    property stUseAdditionalTax: WordBool index 415 read GetWordBoolProp;
    property stUseAdditionalFee: WordBool index 416 read GetWordBoolProp;
    property stUseFontB: WordBool index 417 read GetWordBoolProp;
    property stUseTradeLogo: WordBool index 418 read GetWordBoolProp;
    property stUseCutter: WordBool index 419 read GetWordBoolProp;
    property stRefundReceiptMode: WordBool index 420 read GetWordBoolProp;
    property stPaymentMode: WordBool index 421 read GetWordBoolProp;
    property stFiscalMode: WordBool index 422 read GetWordBoolProp;
    property stServiceReceiptMode: WordBool index 423 read GetWordBoolProp;
    property stOnlinePrintMode: WordBool index 424 read GetWordBoolProp;
    property stFailureLastCommand: WordBool index 425 read GetWordBoolProp;
    property stFiscalDayIsOpened: WordBool index 426 read GetWordBoolProp;
    property stReceiptIsOpened: WordBool index 427 read GetWordBoolProp;
    property stCashDrawerIsOpened: WordBool index 428 read GetWordBoolProp;
    property stDisplayShowSumMode: WordBool index 441 read GetWordBoolProp;
    property prItemCost: Comp index 257 read GetCompProp;
    property prSumDiscount: Comp index 258 read GetCompProp;
    property prSumMarkup: Comp index 259 read GetCompProp;
    property prSumTotal: Comp index 260 read GetCompProp;
    property prSumBalance: Comp index 261 read GetCompProp;
    property prKSEFPacket: Integer index 262 read GetIntegerProp;
    property prKSEFPacketStr: WideString index 538 read GetWideStringProp;
    property prModemError: Byte index 263 read GetByteProp;
    property prCurrentDate: TDateTime index 264 read GetTDateTimeProp;
    property prCurrentDateStr: WideString index 265 read GetWideStringProp;
    property prCurrentTime: TDateTime index 266 read GetTDateTimeProp;
    property prCurrentTimeStr: WideString index 267 read GetWideStringProp;
    property prTaxRatesDate: TDateTime index 269 read GetTDateTimeProp;
    property prTaxRatesDateStr: WideString index 270 read GetWideStringProp;
    property prTaxRate6: Integer index 277 read GetIntegerProp;
    property prNamePaymentForm1: WideString index 291 read GetWideStringProp;
    property prNamePaymentForm2: WideString index 292 read GetWideStringProp;
    property prNamePaymentForm3: WideString index 293 read GetWideStringProp;
    property prNamePaymentForm4: WideString index 294 read GetWideStringProp;
    property prNamePaymentForm5: WideString index 295 read GetWideStringProp;
    property prNamePaymentForm6: WideString index 296 read GetWideStringProp;
    property prNamePaymentForm7: WideString index 297 read GetWideStringProp;
    property prNamePaymentForm8: WideString index 298 read GetWideStringProp;
    property prNamePaymentForm9: WideString index 299 read GetWideStringProp;
    property prNamePaymentForm10: WideString index 300 read GetWideStringProp;
    property prSerialNumber: WideString index 301 read GetWideStringProp;
    property prFiscalNumber: WideString index 302 read GetWideStringProp;
    property prTaxNumber: WideString index 303 read GetWideStringProp;
    property prDateFiscalization: TDateTime index 304 read GetTDateTimeProp;
    property prDateFiscalizationStr: WideString index 305 read GetWideStringProp;
    property prTimeFiscalization: TDateTime index 306 read GetTDateTimeProp;
    property prTimeFiscalizationStr: WideString index 307 read GetWideStringProp;
    property prHeadLine1: WideString index 308 read GetWideStringProp;
    property prHeadLine2: WideString index 309 read GetWideStringProp;
    property prHeadLine3: WideString index 310 read GetWideStringProp;
    property prHardwareVersion: WideString index 311 read GetWideStringProp;
    property prItemName: WideString index 312 read GetWideStringProp;
    property prItemPrice: Integer index 313 read GetIntegerProp;
    property prItemSaleQuantity: Integer index 314 read GetIntegerProp;
    property prItemSaleQtyPrecision: Byte index 315 read GetByteProp;
    property prItemTax: Byte index 316 read GetByteProp;
    property prItemSaleSum: Comp index 317 read GetCompProp;
    property prItemSaleSumStr: WideString index 318 read GetWideStringProp;
    property prItemRefundQuantity: Integer index 319 read GetIntegerProp;
    property prItemRefundQtyPrecision: Byte index 320 read GetByteProp;
    property prItemRefundSum: Comp index 321 read GetCompProp;
    property prItemRefundSumStr: WideString index 322 read GetWideStringProp;
    property prItemCostStr: WideString index 323 read GetWideStringProp;
    property prSumDiscountStr: WideString index 324 read GetWideStringProp;
    property prSumMarkupStr: WideString index 325 read GetWideStringProp;
    property prSumTotalStr: WideString index 326 read GetWideStringProp;
    property prSumBalanceStr: WideString index 327 read GetWideStringProp;
    property prCurReceiptTax1Sum: Integer index 328 read GetIntegerProp;
    property prCurReceiptTax2Sum: Integer index 329 read GetIntegerProp;
    property prCurReceiptTax3Sum: Integer index 330 read GetIntegerProp;
    property prCurReceiptTax4Sum: Integer index 331 read GetIntegerProp;
    property prCurReceiptTax5Sum: Integer index 332 read GetIntegerProp;
    property prCurReceiptTax6Sum: Integer index 333 read GetIntegerProp;
    property prCurReceiptTax1SumStr: WideString index 457 read GetWideStringProp;
    property prCurReceiptTax2SumStr: WideString index 458 read GetWideStringProp;
    property prCurReceiptTax3SumStr: WideString index 459 read GetWideStringProp;
    property prCurReceiptTax4SumStr: WideString index 460 read GetWideStringProp;
    property prCurReceiptTax5SumStr: WideString index 461 read GetWideStringProp;
    property prCurReceiptTax6SumStr: WideString index 462 read GetWideStringProp;
    property prCurReceiptPayForm1Sum: Integer index 334 read GetIntegerProp;
    property prCurReceiptPayForm2Sum: Integer index 335 read GetIntegerProp;
    property prCurReceiptPayForm3Sum: Integer index 336 read GetIntegerProp;
    property prCurReceiptPayForm4Sum: Integer index 337 read GetIntegerProp;
    property prCurReceiptPayForm5Sum: Integer index 338 read GetIntegerProp;
    property prCurReceiptPayForm6Sum: Integer index 339 read GetIntegerProp;
    property prCurReceiptPayForm7Sum: Integer index 340 read GetIntegerProp;
    property prCurReceiptPayForm8Sum: Integer index 341 read GetIntegerProp;
    property prCurReceiptPayForm9Sum: Integer index 342 read GetIntegerProp;
    property prCurReceiptPayForm10Sum: Integer index 343 read GetIntegerProp;
    property prCurReceiptPayForm1SumStr: WideString index 463 read GetWideStringProp;
    property prCurReceiptPayForm2SumStr: WideString index 464 read GetWideStringProp;
    property prCurReceiptPayForm3SumStr: WideString index 465 read GetWideStringProp;
    property prCurReceiptPayForm4SumStr: WideString index 466 read GetWideStringProp;
    property prCurReceiptPayForm5SumStr: WideString index 467 read GetWideStringProp;
    property prCurReceiptPayForm6SumStr: WideString index 468 read GetWideStringProp;
    property prCurReceiptPayForm7SumStr: WideString index 469 read GetWideStringProp;
    property prCurReceiptPayForm8SumStr: WideString index 470 read GetWideStringProp;
    property prCurReceiptPayForm9SumStr: WideString index 471 read GetWideStringProp;
    property prCurReceiptPayForm10SumStr: WideString index 472 read GetWideStringProp;
    property prPrinterError: WordBool index 344 read GetWordBoolProp;
    property prTapeNearEnd: WordBool index 345 read GetWordBoolProp;
    property prTapeEnded: WordBool index 346 read GetWordBoolProp;
    property prDaySaleReceiptsCount: Word index 347 read GetWordProp;
    property prDaySaleReceiptsCountStr: WideString index 473 read GetWideStringProp;
    property prDayRefundReceiptsCount: Word index 348 read GetWordProp;
    property prDayRefundReceiptsCountStr: WideString index 474 read GetWideStringProp;
    property prDaySaleSumOnTax1: Integer index 349 read GetIntegerProp;
    property prDaySaleSumOnTax2: Integer index 350 read GetIntegerProp;
    property prDaySaleSumOnTax3: Integer index 351 read GetIntegerProp;
    property prDaySaleSumOnTax4: Integer index 352 read GetIntegerProp;
    property prDaySaleSumOnTax5: Integer index 353 read GetIntegerProp;
    property prDaySaleSumOnTax6: Integer index 354 read GetIntegerProp;
    property prDaySaleSumOnTax1Str: WideString index 475 read GetWideStringProp;
    property prDaySaleSumOnTax2Str: WideString index 476 read GetWideStringProp;
    property prDaySaleSumOnTax3Str: WideString index 477 read GetWideStringProp;
    property prDaySaleSumOnTax4Str: WideString index 478 read GetWideStringProp;
    property prDaySaleSumOnTax5Str: WideString index 479 read GetWideStringProp;
    property prDaySaleSumOnTax6Str: WideString index 480 read GetWideStringProp;
    property prDayRefundSumOnTax1: Integer index 355 read GetIntegerProp;
    property prDayRefundSumOnTax2: Integer index 356 read GetIntegerProp;
    property prDayRefundSumOnTax3: Integer index 357 read GetIntegerProp;
    property prDayRefundSumOnTax4: Integer index 358 read GetIntegerProp;
    property prDayRefundSumOnTax5: Integer index 359 read GetIntegerProp;
    property prDayRefundSumOnTax6: Integer index 360 read GetIntegerProp;
    property prDayRefundSumOnTax1Str: WideString index 481 read GetWideStringProp;
    property prDayRefundSumOnTax2Str: WideString index 482 read GetWideStringProp;
    property prDayRefundSumOnTax3Str: WideString index 483 read GetWideStringProp;
    property prDayRefundSumOnTax4Str: WideString index 484 read GetWideStringProp;
    property prDayRefundSumOnTax5Str: WideString index 485 read GetWideStringProp;
    property prDayRefundSumOnTax6Str: WideString index 486 read GetWideStringProp;
    property prDaySaleSumOnPayForm1: Integer index 361 read GetIntegerProp;
    property prDaySaleSumOnPayForm2: Integer index 362 read GetIntegerProp;
    property prDaySaleSumOnPayForm3: Integer index 363 read GetIntegerProp;
    property prDaySaleSumOnPayForm4: Integer index 364 read GetIntegerProp;
    property prDaySaleSumOnPayForm5: Integer index 365 read GetIntegerProp;
    property prDaySaleSumOnPayForm6: Integer index 366 read GetIntegerProp;
    property prDaySaleSumOnPayForm7: Integer index 367 read GetIntegerProp;
    property prDaySaleSumOnPayForm8: Integer index 368 read GetIntegerProp;
    property prDaySaleSumOnPayForm9: Integer index 369 read GetIntegerProp;
    property prDaySaleSumOnPayForm10: Integer index 370 read GetIntegerProp;
    property prDaySaleSumOnPayForm1Str: WideString index 487 read GetWideStringProp;
    property prDaySaleSumOnPayForm2Str: WideString index 488 read GetWideStringProp;
    property prDaySaleSumOnPayForm3Str: WideString index 489 read GetWideStringProp;
    property prDaySaleSumOnPayForm4Str: WideString index 490 read GetWideStringProp;
    property prDaySaleSumOnPayForm5Str: WideString index 491 read GetWideStringProp;
    property prDaySaleSumOnPayForm6Str: WideString index 492 read GetWideStringProp;
    property prDaySaleSumOnPayForm7Str: WideString index 493 read GetWideStringProp;
    property prDaySaleSumOnPayForm8Str: WideString index 494 read GetWideStringProp;
    property prDaySaleSumOnPayForm9Str: WideString index 495 read GetWideStringProp;
    property prDaySaleSumOnPayForm10Str: WideString index 496 read GetWideStringProp;
    property prDayRefundSumOnPayForm1: Integer index 371 read GetIntegerProp;
    property prDayRefundSumOnPayForm2: Integer index 372 read GetIntegerProp;
    property prDayRefundSumOnPayForm3: Integer index 373 read GetIntegerProp;
    property prDayRefundSumOnPayForm4: Integer index 374 read GetIntegerProp;
    property prDayRefundSumOnPayForm5: Integer index 375 read GetIntegerProp;
    property prDayRefundSumOnPayForm6: Integer index 376 read GetIntegerProp;
    property prDayRefundSumOnPayForm7: Integer index 377 read GetIntegerProp;
    property prDayRefundSumOnPayForm8: Integer index 378 read GetIntegerProp;
    property prDayRefundSumOnPayForm9: Integer index 379 read GetIntegerProp;
    property prDayRefundSumOnPayForm10: Integer index 380 read GetIntegerProp;
    property prDayRefundSumOnPayForm1Str: WideString index 497 read GetWideStringProp;
    property prDayRefundSumOnPayForm2Str: WideString index 498 read GetWideStringProp;
    property prDayRefundSumOnPayForm3Str: WideString index 499 read GetWideStringProp;
    property prDayRefundSumOnPayForm4Str: WideString index 500 read GetWideStringProp;
    property prDayRefundSumOnPayForm5Str: WideString index 501 read GetWideStringProp;
    property prDayRefundSumOnPayForm6Str: WideString index 502 read GetWideStringProp;
    property prDayRefundSumOnPayForm7Str: WideString index 503 read GetWideStringProp;
    property prDayRefundSumOnPayForm8Str: WideString index 504 read GetWideStringProp;
    property prDayRefundSumOnPayForm9Str: WideString index 505 read GetWideStringProp;
    property prDayRefundSumOnPayForm10Str: WideString index 506 read GetWideStringProp;
    property prDayDiscountSumOnSales: Integer index 381 read GetIntegerProp;
    property prDayDiscountSumOnSalesStr: WideString index 507 read GetWideStringProp;
    property prDayMarkupSumOnSales: Integer index 382 read GetIntegerProp;
    property prDayMarkupSumOnSalesStr: WideString index 508 read GetWideStringProp;
    property prDayDiscountSumOnRefunds: Integer index 383 read GetIntegerProp;
    property prDayDiscountSumOnRefundsStr: WideString index 509 read GetWideStringProp;
    property prDayMarkupSumOnRefunds: Integer index 384 read GetIntegerProp;
    property prDayMarkupSumOnRefundsStr: WideString index 510 read GetWideStringProp;
    property prDayCashInSum: Integer index 385 read GetIntegerProp;
    property prDayCashInSumStr: WideString index 511 read GetWideStringProp;
    property prDayCashOutSum: Integer index 386 read GetIntegerProp;
    property prDayCashOutSumStr: WideString index 512 read GetWideStringProp;
    property prCurrentZReport: Word index 387 read GetWordProp;
    property prCurrentZReportStr: WideString index 513 read GetWideStringProp;
    property prDayEndDate: TDateTime index 388 read GetTDateTimeProp;
    property prDayEndDateStr: WideString index 389 read GetWideStringProp;
    property prDayEndTime: TDateTime index 390 read GetTDateTimeProp;
    property prDayEndTimeStr: WideString index 391 read GetWideStringProp;
    property prLastZReportDate: TDateTime index 392 read GetTDateTimeProp;
    property prLastZReportDateStr: WideString index 393 read GetWideStringProp;
    property prItemsCount: Word index 394 read GetWordProp;
    property prItemsCountStr: WideString index 514 read GetWideStringProp;
    property prDaySumAddTaxOfSale1: Integer index 395 read GetIntegerProp;
    property prDaySumAddTaxOfSale2: Integer index 396 read GetIntegerProp;
    property prDaySumAddTaxOfSale3: Integer index 397 read GetIntegerProp;
    property prDaySumAddTaxOfSale4: Integer index 398 read GetIntegerProp;
    property prDaySumAddTaxOfSale5: Integer index 399 read GetIntegerProp;
    property prDaySumAddTaxOfSale6: Integer index 400 read GetIntegerProp;
    property prDaySumAddTaxOfSale1Str: WideString index 515 read GetWideStringProp;
    property prDaySumAddTaxOfSale2Str: WideString index 516 read GetWideStringProp;
    property prDaySumAddTaxOfSale3Str: WideString index 517 read GetWideStringProp;
    property prDaySumAddTaxOfSale4Str: WideString index 518 read GetWideStringProp;
    property prDaySumAddTaxOfSale5Str: WideString index 519 read GetWideStringProp;
    property prDaySumAddTaxOfSale6Str: WideString index 520 read GetWideStringProp;
    property prDaySumAddTaxOfRefund1: Integer index 401 read GetIntegerProp;
    property prDaySumAddTaxOfRefund2: Integer index 402 read GetIntegerProp;
    property prDaySumAddTaxOfRefund3: Integer index 403 read GetIntegerProp;
    property prDaySumAddTaxOfRefund4: Integer index 404 read GetIntegerProp;
    property prDaySumAddTaxOfRefund5: Integer index 405 read GetIntegerProp;
    property prDaySumAddTaxOfRefund6: Integer index 406 read GetIntegerProp;
    property prDaySumAddTaxOfRefund1Str: WideString index 521 read GetWideStringProp;
    property prDaySumAddTaxOfRefund2Str: WideString index 522 read GetWideStringProp;
    property prDaySumAddTaxOfRefund3Str: WideString index 523 read GetWideStringProp;
    property prDaySumAddTaxOfRefund4Str: WideString index 524 read GetWideStringProp;
    property prDaySumAddTaxOfRefund5Str: WideString index 525 read GetWideStringProp;
    property prDaySumAddTaxOfRefund6Str: WideString index 526 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsCount: Word index 407 read GetWordProp;
    property prDayAnnuledSaleReceiptsCountStr: WideString index 527 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsCount: Word index 408 read GetWordProp;
    property prDayAnnuledRefundReceiptsCountStr: WideString index 528 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsSum: Integer index 409 read GetIntegerProp;
    property prDayAnnuledSaleReceiptsSumStr: WideString index 529 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsSum: Integer index 410 read GetIntegerProp;
    property prDayAnnuledRefundReceiptsSumStr: WideString index 530 read GetWideStringProp;
    property prDaySaleCancelingsCount: Word index 411 read GetWordProp;
    property prDaySaleCancelingsCountStr: WideString index 531 read GetWideStringProp;
    property prDayRefundCancelingsCount: Word index 412 read GetWordProp;
    property prDayRefundCancelingsCountStr: WideString index 532 read GetWideStringProp;
    property prDaySaleCancelingsSum: Integer index 413 read GetIntegerProp;
    property prDaySaleCancelingsSumStr: WideString index 533 read GetWideStringProp;
    property prDayRefundCancelingsSum: Integer index 414 read GetIntegerProp;
    property prDayRefundCancelingsSumStr: WideString index 534 read GetWideStringProp;
    property prDayFirstFreePacket: Integer index 555 read GetIntegerProp;
    property prDayLastSentPacket: Integer index 556 read GetIntegerProp;
    property prDayLastSignedPacket: Integer index 557 read GetIntegerProp;
    property prDayFirstFreePacketStr: WideString index 558 read GetWideStringProp;
    property prDayLastSentPacketStr: WideString index 559 read GetWideStringProp;
    property prDayLastSignedPacketStr: WideString index 560 read GetWideStringProp;
    property prCashDrawerSum: Comp index 429 read GetCompProp;
    property prCashDrawerSumStr: WideString index 430 read GetWideStringProp;
    property prGetStatusByte: Byte index 436 read GetByteProp;
    property prGetResultByte: Byte index 437 read GetByteProp;
    property prGetReserveByte: Byte index 438 read GetByteProp;
    property prGetErrorText: WideString index 439 read GetWideStringProp;
    property prCurReceiptItemCount: Byte index 451 read GetByteProp;
    property prUserPassword: Word index 536 read GetWordProp;
    property prUserPasswordStr: WideString index 537 read GetWideStringProp;
    property prGetGraphicFreeMemorySize: Integer index 569 read GetIntegerProp;
    property prGetGraphicFreeMemorySizeStr: WideString index 570 read GetWideStringProp;
    property prBitmapObjectsCount: Byte index 586 read GetByteProp;
    property prGetBitmapIndex[id: Byte]: Byte read Get_prGetBitmapIndex;
    property prUDPDeviceListSize: Byte index 588 read GetByteProp;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte index 541 read GetByteProp;
    property prFPDriverMajorVersion: Byte index 542 read GetByteProp;
    property prFPDriverMinorVersion: Byte index 543 read GetByteProp;
    property prFPDriverReleaseVersion: Byte index 544 read GetByteProp;
    property prFPDriverBuildVersion: Byte index 545 read GetByteProp;
  published
    property Anchors;
    property glTapeAnalizer: WordBool index 253 read GetWordBoolProp write SetWordBoolProp stored False;
    property glPropertiesAutoUpdateMode: WordBool index 254 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 255 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 256 read GetByteProp write SetByteProp stored False;
    property glUseVirtualPort: WordBool index 577 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRatesCount: Byte index 268 read GetByteProp write SetByteProp stored False;
    property prAddTaxType: WordBool index 271 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRate1: Integer index 272 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate2: Integer index 273 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate3: Integer index 274 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate4: Integer index 275 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate5: Integer index 276 read GetIntegerProp write SetIntegerProp stored False;
    property prUsedAdditionalFee: WordBool index 278 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeRate1: Integer index 279 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate2: Integer index 280 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate3: Integer index 281 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate4: Integer index 282 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate5: Integer index 283 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate6: Integer index 284 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxOnAddFee1: WordBool index 285 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee2: WordBool index 286 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee3: WordBool index 287 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee4: WordBool index 288 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee5: WordBool index 289 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee6: WordBool index 290 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice1: WordBool index 546 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice2: WordBool index 547 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice3: WordBool index 550 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice4: WordBool index 551 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice5: WordBool index 552 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice6: WordBool index 553 read GetWordBoolProp write SetWordBoolProp stored False;
    property prRepeatCount: Byte index 431 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 432 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 434 read GetByteProp write SetByteProp stored False;
    property prProgPassword: Word index 566 read GetWordProp write SetWordProp stored False;
    property prProgPasswordStr: WideString index 567 read GetWideStringProp write SetWideStringProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_MZ_09
// Help String      : ICS_MZ_09 Object
// Default Interface: IICS_MZ_09
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_MZ_09 = class(TOleControl)
  private
    FIntf: IICS_MZ_09;
    function  GetControlInterface: IICS_MZ_09;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function FPInitialize: Integer;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool;
    function FPClose: WordBool;
    function FPClaimUSBDevice: WordBool;
    function FPReleaseUSBDevice: WordBool;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
    function FPPrintZeroReceipt: WordBool;
    function FPLineFeed: WordBool;
    function FPAnnulReceipt: WordBool;
    function FPCashIn(CashSum: SYSUINT): WordBool;
    function FPCashOut(CashSum: SYSUINT): WordBool;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
    function FPGetCurrentDate: WordBool;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
    function FPGetCurrentTime: WordBool;
    function FPOpenCashDrawer(Duration: Word): WordBool;
    function FPPrintHardwareVersion: WordBool;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool;
    function FPOnlineModeSwitch: WordBool;
    function FPCustomerDisplayModeSwitch: WordBool;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
    function FPCloseServiceReport: WordBool;
    function FPEnableLogo(ProgPassword: Word): WordBool;
    function FPDisableLogo(ProgPassword: Word): WordBool;
    function FPSetTaxRates(ProgPassword: Word): WordBool;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool;
    function FPMakeXReport(ReportPassword: Word): WordBool;
    function FPMakeZReport(ReportPassword: Word): WordBool;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool;
    function FPCutterModeSwitch: WordBool;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
    function FPGetPaymentFormNames: WordBool;
    function FPGetCurrentStatus: WordBool;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
    function FPGetCashDrawerSum: WordBool;
    function FPGetDayReportProperties: WordBool;
    function FPGetTaxRates: WordBool;
    function FPGetItemData(ItemCode: Int64): WordBool;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
    function FPGetDayReportData: WordBool;
    function FPGetCurrentReceiptData: WordBool;
    function FPGetDayCorrectionsData: WordBool;
    function FPGetDaySumOfAddTaxes: WordBool;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool;
    function FPPrintModemStatus: WordBool;
    function FPGetUserPassword(UserID: Byte): WordBool;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
    function FPPrintQRCode(const SerialQR: WideString): WordBool;
    function FPSetContrast(Value: Byte): WordBool;
    function FPGetContrast: WordBool;
    function FPGetRevizionID: WordBool;
    property  ControlInterface: IICS_MZ_09 read GetControlInterface;
    property  DefaultInterface: IICS_MZ_09 read GetControlInterface;
    property glVirtualPortOpened: WordBool index 562 read GetWordBoolProp;
    property stUseAdditionalTax: WordBool index 415 read GetWordBoolProp;
    property stUseAdditionalFee: WordBool index 416 read GetWordBoolProp;
    property stUseFontB: WordBool index 417 read GetWordBoolProp;
    property stUseTradeLogo: WordBool index 418 read GetWordBoolProp;
    property stUseCutter: WordBool index 419 read GetWordBoolProp;
    property stRefundReceiptMode: WordBool index 420 read GetWordBoolProp;
    property stPaymentMode: WordBool index 421 read GetWordBoolProp;
    property stFiscalMode: WordBool index 422 read GetWordBoolProp;
    property stServiceReceiptMode: WordBool index 423 read GetWordBoolProp;
    property stOnlinePrintMode: WordBool index 424 read GetWordBoolProp;
    property stFailureLastCommand: WordBool index 425 read GetWordBoolProp;
    property stFiscalDayIsOpened: WordBool index 426 read GetWordBoolProp;
    property stReceiptIsOpened: WordBool index 427 read GetWordBoolProp;
    property stCashDrawerIsOpened: WordBool index 428 read GetWordBoolProp;
    property stDisplayShowSumMode: WordBool index 441 read GetWordBoolProp;
    property prItemCost: Comp index 257 read GetCompProp;
    property prSumDiscount: Comp index 258 read GetCompProp;
    property prSumMarkup: Comp index 259 read GetCompProp;
    property prSumTotal: Comp index 260 read GetCompProp;
    property prSumBalance: Comp index 261 read GetCompProp;
    property prKSEFPacket: Integer index 262 read GetIntegerProp;
    property prKSEFPacketStr: WideString index 538 read GetWideStringProp;
    property prModemError: Byte index 263 read GetByteProp;
    property prCurrentDate: TDateTime index 264 read GetTDateTimeProp;
    property prCurrentDateStr: WideString index 265 read GetWideStringProp;
    property prCurrentTime: TDateTime index 266 read GetTDateTimeProp;
    property prCurrentTimeStr: WideString index 267 read GetWideStringProp;
    property prTaxRatesDate: TDateTime index 269 read GetTDateTimeProp;
    property prTaxRatesDateStr: WideString index 270 read GetWideStringProp;
    property prTaxRate6: Integer index 277 read GetIntegerProp;
    property prNamePaymentForm1: WideString index 291 read GetWideStringProp;
    property prNamePaymentForm2: WideString index 292 read GetWideStringProp;
    property prNamePaymentForm3: WideString index 293 read GetWideStringProp;
    property prNamePaymentForm4: WideString index 294 read GetWideStringProp;
    property prNamePaymentForm5: WideString index 295 read GetWideStringProp;
    property prNamePaymentForm6: WideString index 296 read GetWideStringProp;
    property prNamePaymentForm7: WideString index 297 read GetWideStringProp;
    property prNamePaymentForm8: WideString index 298 read GetWideStringProp;
    property prNamePaymentForm9: WideString index 299 read GetWideStringProp;
    property prNamePaymentForm10: WideString index 300 read GetWideStringProp;
    property prSerialNumber: WideString index 301 read GetWideStringProp;
    property prFiscalNumber: WideString index 302 read GetWideStringProp;
    property prTaxNumber: WideString index 303 read GetWideStringProp;
    property prDateFiscalization: TDateTime index 304 read GetTDateTimeProp;
    property prDateFiscalizationStr: WideString index 305 read GetWideStringProp;
    property prTimeFiscalization: TDateTime index 306 read GetTDateTimeProp;
    property prTimeFiscalizationStr: WideString index 307 read GetWideStringProp;
    property prHeadLine1: WideString index 308 read GetWideStringProp;
    property prHeadLine2: WideString index 309 read GetWideStringProp;
    property prHeadLine3: WideString index 310 read GetWideStringProp;
    property prHardwareVersion: WideString index 311 read GetWideStringProp;
    property prItemName: WideString index 312 read GetWideStringProp;
    property prItemPrice: Integer index 313 read GetIntegerProp;
    property prItemSaleQuantity: Integer index 314 read GetIntegerProp;
    property prItemSaleQtyPrecision: Byte index 315 read GetByteProp;
    property prItemTax: Byte index 316 read GetByteProp;
    property prItemSaleSum: Comp index 317 read GetCompProp;
    property prItemSaleSumStr: WideString index 318 read GetWideStringProp;
    property prItemRefundQuantity: Integer index 319 read GetIntegerProp;
    property prItemRefundQtyPrecision: Byte index 320 read GetByteProp;
    property prItemRefundSum: Comp index 321 read GetCompProp;
    property prItemRefundSumStr: WideString index 322 read GetWideStringProp;
    property prItemCostStr: WideString index 323 read GetWideStringProp;
    property prSumDiscountStr: WideString index 324 read GetWideStringProp;
    property prSumMarkupStr: WideString index 325 read GetWideStringProp;
    property prSumTotalStr: WideString index 326 read GetWideStringProp;
    property prSumBalanceStr: WideString index 327 read GetWideStringProp;
    property prCurReceiptTax1Sum: Integer index 328 read GetIntegerProp;
    property prCurReceiptTax2Sum: Integer index 329 read GetIntegerProp;
    property prCurReceiptTax3Sum: Integer index 330 read GetIntegerProp;
    property prCurReceiptTax4Sum: Integer index 331 read GetIntegerProp;
    property prCurReceiptTax5Sum: Integer index 332 read GetIntegerProp;
    property prCurReceiptTax6Sum: Integer index 333 read GetIntegerProp;
    property prCurReceiptTax1SumStr: WideString index 457 read GetWideStringProp;
    property prCurReceiptTax2SumStr: WideString index 458 read GetWideStringProp;
    property prCurReceiptTax3SumStr: WideString index 459 read GetWideStringProp;
    property prCurReceiptTax4SumStr: WideString index 460 read GetWideStringProp;
    property prCurReceiptTax5SumStr: WideString index 461 read GetWideStringProp;
    property prCurReceiptTax6SumStr: WideString index 462 read GetWideStringProp;
    property prCurReceiptPayForm1Sum: Integer index 334 read GetIntegerProp;
    property prCurReceiptPayForm2Sum: Integer index 335 read GetIntegerProp;
    property prCurReceiptPayForm3Sum: Integer index 336 read GetIntegerProp;
    property prCurReceiptPayForm4Sum: Integer index 337 read GetIntegerProp;
    property prCurReceiptPayForm5Sum: Integer index 338 read GetIntegerProp;
    property prCurReceiptPayForm6Sum: Integer index 339 read GetIntegerProp;
    property prCurReceiptPayForm7Sum: Integer index 340 read GetIntegerProp;
    property prCurReceiptPayForm8Sum: Integer index 341 read GetIntegerProp;
    property prCurReceiptPayForm9Sum: Integer index 342 read GetIntegerProp;
    property prCurReceiptPayForm10Sum: Integer index 343 read GetIntegerProp;
    property prCurReceiptPayForm1SumStr: WideString index 463 read GetWideStringProp;
    property prCurReceiptPayForm2SumStr: WideString index 464 read GetWideStringProp;
    property prCurReceiptPayForm3SumStr: WideString index 465 read GetWideStringProp;
    property prCurReceiptPayForm4SumStr: WideString index 466 read GetWideStringProp;
    property prCurReceiptPayForm5SumStr: WideString index 467 read GetWideStringProp;
    property prCurReceiptPayForm6SumStr: WideString index 468 read GetWideStringProp;
    property prCurReceiptPayForm7SumStr: WideString index 469 read GetWideStringProp;
    property prCurReceiptPayForm8SumStr: WideString index 470 read GetWideStringProp;
    property prCurReceiptPayForm9SumStr: WideString index 471 read GetWideStringProp;
    property prCurReceiptPayForm10SumStr: WideString index 472 read GetWideStringProp;
    property prPrinterError: WordBool index 344 read GetWordBoolProp;
    property prTapeNearEnd: WordBool index 345 read GetWordBoolProp;
    property prTapeEnded: WordBool index 346 read GetWordBoolProp;
    property prDaySaleReceiptsCount: Word index 347 read GetWordProp;
    property prDaySaleReceiptsCountStr: WideString index 473 read GetWideStringProp;
    property prDayRefundReceiptsCount: Word index 348 read GetWordProp;
    property prDayRefundReceiptsCountStr: WideString index 474 read GetWideStringProp;
    property prDaySaleSumOnTax1: Integer index 349 read GetIntegerProp;
    property prDaySaleSumOnTax2: Integer index 350 read GetIntegerProp;
    property prDaySaleSumOnTax3: Integer index 351 read GetIntegerProp;
    property prDaySaleSumOnTax4: Integer index 352 read GetIntegerProp;
    property prDaySaleSumOnTax5: Integer index 353 read GetIntegerProp;
    property prDaySaleSumOnTax6: Integer index 354 read GetIntegerProp;
    property prDaySaleSumOnTax1Str: WideString index 475 read GetWideStringProp;
    property prDaySaleSumOnTax2Str: WideString index 476 read GetWideStringProp;
    property prDaySaleSumOnTax3Str: WideString index 477 read GetWideStringProp;
    property prDaySaleSumOnTax4Str: WideString index 478 read GetWideStringProp;
    property prDaySaleSumOnTax5Str: WideString index 479 read GetWideStringProp;
    property prDaySaleSumOnTax6Str: WideString index 480 read GetWideStringProp;
    property prDayRefundSumOnTax1: Integer index 355 read GetIntegerProp;
    property prDayRefundSumOnTax2: Integer index 356 read GetIntegerProp;
    property prDayRefundSumOnTax3: Integer index 357 read GetIntegerProp;
    property prDayRefundSumOnTax4: Integer index 358 read GetIntegerProp;
    property prDayRefundSumOnTax5: Integer index 359 read GetIntegerProp;
    property prDayRefundSumOnTax6: Integer index 360 read GetIntegerProp;
    property prDayRefundSumOnTax1Str: WideString index 481 read GetWideStringProp;
    property prDayRefundSumOnTax2Str: WideString index 482 read GetWideStringProp;
    property prDayRefundSumOnTax3Str: WideString index 483 read GetWideStringProp;
    property prDayRefundSumOnTax4Str: WideString index 484 read GetWideStringProp;
    property prDayRefundSumOnTax5Str: WideString index 485 read GetWideStringProp;
    property prDayRefundSumOnTax6Str: WideString index 486 read GetWideStringProp;
    property prDaySaleSumOnPayForm1: Integer index 361 read GetIntegerProp;
    property prDaySaleSumOnPayForm2: Integer index 362 read GetIntegerProp;
    property prDaySaleSumOnPayForm3: Integer index 363 read GetIntegerProp;
    property prDaySaleSumOnPayForm4: Integer index 364 read GetIntegerProp;
    property prDaySaleSumOnPayForm5: Integer index 365 read GetIntegerProp;
    property prDaySaleSumOnPayForm6: Integer index 366 read GetIntegerProp;
    property prDaySaleSumOnPayForm7: Integer index 367 read GetIntegerProp;
    property prDaySaleSumOnPayForm8: Integer index 368 read GetIntegerProp;
    property prDaySaleSumOnPayForm9: Integer index 369 read GetIntegerProp;
    property prDaySaleSumOnPayForm10: Integer index 370 read GetIntegerProp;
    property prDaySaleSumOnPayForm1Str: WideString index 487 read GetWideStringProp;
    property prDaySaleSumOnPayForm2Str: WideString index 488 read GetWideStringProp;
    property prDaySaleSumOnPayForm3Str: WideString index 489 read GetWideStringProp;
    property prDaySaleSumOnPayForm4Str: WideString index 490 read GetWideStringProp;
    property prDaySaleSumOnPayForm5Str: WideString index 491 read GetWideStringProp;
    property prDaySaleSumOnPayForm6Str: WideString index 492 read GetWideStringProp;
    property prDaySaleSumOnPayForm7Str: WideString index 493 read GetWideStringProp;
    property prDaySaleSumOnPayForm8Str: WideString index 494 read GetWideStringProp;
    property prDaySaleSumOnPayForm9Str: WideString index 495 read GetWideStringProp;
    property prDaySaleSumOnPayForm10Str: WideString index 496 read GetWideStringProp;
    property prDayRefundSumOnPayForm1: Integer index 371 read GetIntegerProp;
    property prDayRefundSumOnPayForm2: Integer index 372 read GetIntegerProp;
    property prDayRefundSumOnPayForm3: Integer index 373 read GetIntegerProp;
    property prDayRefundSumOnPayForm4: Integer index 374 read GetIntegerProp;
    property prDayRefundSumOnPayForm5: Integer index 375 read GetIntegerProp;
    property prDayRefundSumOnPayForm6: Integer index 376 read GetIntegerProp;
    property prDayRefundSumOnPayForm7: Integer index 377 read GetIntegerProp;
    property prDayRefundSumOnPayForm8: Integer index 378 read GetIntegerProp;
    property prDayRefundSumOnPayForm9: Integer index 379 read GetIntegerProp;
    property prDayRefundSumOnPayForm10: Integer index 380 read GetIntegerProp;
    property prDayRefundSumOnPayForm1Str: WideString index 497 read GetWideStringProp;
    property prDayRefundSumOnPayForm2Str: WideString index 498 read GetWideStringProp;
    property prDayRefundSumOnPayForm3Str: WideString index 499 read GetWideStringProp;
    property prDayRefundSumOnPayForm4Str: WideString index 500 read GetWideStringProp;
    property prDayRefundSumOnPayForm5Str: WideString index 501 read GetWideStringProp;
    property prDayRefundSumOnPayForm6Str: WideString index 502 read GetWideStringProp;
    property prDayRefundSumOnPayForm7Str: WideString index 503 read GetWideStringProp;
    property prDayRefundSumOnPayForm8Str: WideString index 504 read GetWideStringProp;
    property prDayRefundSumOnPayForm9Str: WideString index 505 read GetWideStringProp;
    property prDayRefundSumOnPayForm10Str: WideString index 506 read GetWideStringProp;
    property prDayDiscountSumOnSales: Integer index 381 read GetIntegerProp;
    property prDayDiscountSumOnSalesStr: WideString index 507 read GetWideStringProp;
    property prDayMarkupSumOnSales: Integer index 382 read GetIntegerProp;
    property prDayMarkupSumOnSalesStr: WideString index 508 read GetWideStringProp;
    property prDayDiscountSumOnRefunds: Integer index 383 read GetIntegerProp;
    property prDayDiscountSumOnRefundsStr: WideString index 509 read GetWideStringProp;
    property prDayMarkupSumOnRefunds: Integer index 384 read GetIntegerProp;
    property prDayMarkupSumOnRefundsStr: WideString index 510 read GetWideStringProp;
    property prDayCashInSum: Integer index 385 read GetIntegerProp;
    property prDayCashInSumStr: WideString index 511 read GetWideStringProp;
    property prDayCashOutSum: Integer index 386 read GetIntegerProp;
    property prDayCashOutSumStr: WideString index 512 read GetWideStringProp;
    property prCurrentZReport: Word index 387 read GetWordProp;
    property prCurrentZReportStr: WideString index 513 read GetWideStringProp;
    property prDayEndDate: TDateTime index 388 read GetTDateTimeProp;
    property prDayEndDateStr: WideString index 389 read GetWideStringProp;
    property prDayEndTime: TDateTime index 390 read GetTDateTimeProp;
    property prDayEndTimeStr: WideString index 391 read GetWideStringProp;
    property prLastZReportDate: TDateTime index 392 read GetTDateTimeProp;
    property prLastZReportDateStr: WideString index 393 read GetWideStringProp;
    property prItemsCount: Word index 394 read GetWordProp;
    property prItemsCountStr: WideString index 514 read GetWideStringProp;
    property prDaySumAddTaxOfSale1: Integer index 395 read GetIntegerProp;
    property prDaySumAddTaxOfSale2: Integer index 396 read GetIntegerProp;
    property prDaySumAddTaxOfSale3: Integer index 397 read GetIntegerProp;
    property prDaySumAddTaxOfSale4: Integer index 398 read GetIntegerProp;
    property prDaySumAddTaxOfSale5: Integer index 399 read GetIntegerProp;
    property prDaySumAddTaxOfSale6: Integer index 400 read GetIntegerProp;
    property prDaySumAddTaxOfSale1Str: WideString index 515 read GetWideStringProp;
    property prDaySumAddTaxOfSale2Str: WideString index 516 read GetWideStringProp;
    property prDaySumAddTaxOfSale3Str: WideString index 517 read GetWideStringProp;
    property prDaySumAddTaxOfSale4Str: WideString index 518 read GetWideStringProp;
    property prDaySumAddTaxOfSale5Str: WideString index 519 read GetWideStringProp;
    property prDaySumAddTaxOfSale6Str: WideString index 520 read GetWideStringProp;
    property prDaySumAddTaxOfRefund1: Integer index 401 read GetIntegerProp;
    property prDaySumAddTaxOfRefund2: Integer index 402 read GetIntegerProp;
    property prDaySumAddTaxOfRefund3: Integer index 403 read GetIntegerProp;
    property prDaySumAddTaxOfRefund4: Integer index 404 read GetIntegerProp;
    property prDaySumAddTaxOfRefund5: Integer index 405 read GetIntegerProp;
    property prDaySumAddTaxOfRefund6: Integer index 406 read GetIntegerProp;
    property prDaySumAddTaxOfRefund1Str: WideString index 521 read GetWideStringProp;
    property prDaySumAddTaxOfRefund2Str: WideString index 522 read GetWideStringProp;
    property prDaySumAddTaxOfRefund3Str: WideString index 523 read GetWideStringProp;
    property prDaySumAddTaxOfRefund4Str: WideString index 524 read GetWideStringProp;
    property prDaySumAddTaxOfRefund5Str: WideString index 525 read GetWideStringProp;
    property prDaySumAddTaxOfRefund6Str: WideString index 526 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsCount: Word index 407 read GetWordProp;
    property prDayAnnuledSaleReceiptsCountStr: WideString index 527 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsCount: Word index 408 read GetWordProp;
    property prDayAnnuledRefundReceiptsCountStr: WideString index 528 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsSum: Integer index 409 read GetIntegerProp;
    property prDayAnnuledSaleReceiptsSumStr: WideString index 529 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsSum: Integer index 410 read GetIntegerProp;
    property prDayAnnuledRefundReceiptsSumStr: WideString index 530 read GetWideStringProp;
    property prDaySaleCancelingsCount: Word index 411 read GetWordProp;
    property prDaySaleCancelingsCountStr: WideString index 531 read GetWideStringProp;
    property prDayRefundCancelingsCount: Word index 412 read GetWordProp;
    property prDayRefundCancelingsCountStr: WideString index 532 read GetWideStringProp;
    property prDaySaleCancelingsSum: Integer index 413 read GetIntegerProp;
    property prDaySaleCancelingsSumStr: WideString index 533 read GetWideStringProp;
    property prDayRefundCancelingsSum: Integer index 414 read GetIntegerProp;
    property prDayRefundCancelingsSumStr: WideString index 534 read GetWideStringProp;
    property prCashDrawerSum: Comp index 429 read GetCompProp;
    property prCashDrawerSumStr: WideString index 430 read GetWideStringProp;
    property prGetStatusByte: Byte index 436 read GetByteProp;
    property prGetResultByte: Byte index 437 read GetByteProp;
    property prGetReserveByte: Byte index 438 read GetByteProp;
    property prGetErrorText: WideString index 439 read GetWideStringProp;
    property prCurReceiptItemCount: Byte index 451 read GetByteProp;
    property prUserPassword: Word index 536 read GetWordProp;
    property prUserPasswordStr: WideString index 537 read GetWideStringProp;
    property prPrintContrast: Byte index 542 read GetByteProp;
    property prRevizionID: Byte index 551 read GetByteProp;
    property prFPDriverMajorVersion: Byte index 552 read GetByteProp;
    property prFPDriverMinorVersion: Byte index 553 read GetByteProp;
    property prFPDriverReleaseVersion: Byte index 554 read GetByteProp;
    property prFPDriverBuildVersion: Byte index 555 read GetByteProp;
  published
    property Anchors;
    property glTapeAnalizer: WordBool index 253 read GetWordBoolProp write SetWordBoolProp stored False;
    property glPropertiesAutoUpdateMode: WordBool index 254 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 255 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 256 read GetByteProp write SetByteProp stored False;
    property glUseVirtualPort: WordBool index 563 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRatesCount: Byte index 268 read GetByteProp write SetByteProp stored False;
    property prAddTaxType: WordBool index 271 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRate1: Integer index 272 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate2: Integer index 273 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate3: Integer index 274 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate4: Integer index 275 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate5: Integer index 276 read GetIntegerProp write SetIntegerProp stored False;
    property prUsedAdditionalFee: WordBool index 278 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeRate1: Integer index 279 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate2: Integer index 280 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate3: Integer index 281 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate4: Integer index 282 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate5: Integer index 283 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate6: Integer index 284 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxOnAddFee1: WordBool index 285 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee2: WordBool index 286 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee3: WordBool index 287 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee4: WordBool index 288 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee5: WordBool index 289 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee6: WordBool index 290 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice1: WordBool index 556 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice2: WordBool index 557 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice3: WordBool index 558 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice4: WordBool index 559 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice5: WordBool index 560 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice6: WordBool index 561 read GetWordBoolProp write SetWordBoolProp stored False;
    property prRepeatCount: Byte index 431 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 432 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 434 read GetByteProp write SetByteProp stored False;
    property prFont9x17: WordBool index 543 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontBold: WordBool index 544 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontSmall: WordBool index 545 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleHeight: WordBool index 546 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleWidth: WordBool index 547 read GetWordBoolProp write SetWordBoolProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_MZ_11
// Help String      : ICS_MZ_11 Object
// Default Interface: IICS_MZ_11
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_MZ_11 = class(TOleControl)
  private
    FIntf: IICS_MZ_11;
    function  GetControlInterface: IICS_MZ_11;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_prGetBitmapIndex(id: Byte): Byte;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString;
    function Get_prUDPDeviceMAC(id: Byte): WideString;
    function Get_prUDPDeviceIP(id: Byte): WideString;
    function Get_prUDPDeviceTCPport(id: Byte): Word;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString;
  public
    function FPInitialize: Integer;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool;
    function FPClose: WordBool;
    function FPClaimUSBDevice: WordBool;
    function FPReleaseUSBDevice: WordBool;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
    function FPTCPClose: WordBool;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
    function FPPrintZeroReceipt: WordBool;
    function FPLineFeed: WordBool;
    function FPAnnulReceipt: WordBool;
    function FPCashIn(CashSum: SYSUINT): WordBool;
    function FPCashOut(CashSum: SYSUINT): WordBool;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
    function FPGetCurrentDate: WordBool;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
    function FPGetCurrentTime: WordBool;
    function FPOpenCashDrawer(Duration: Word): WordBool;
    function FPPrintHardwareVersion: WordBool;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool;
    function FPOnlineModeSwitch: WordBool;
    function FPCustomerDisplayModeSwitch: WordBool;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
    function FPCloseServiceReport: WordBool;
    function FPEnableLogo(ProgPassword: Word): WordBool;
    function FPDisableLogo(ProgPassword: Word): WordBool;
    function FPSetTaxRates(ProgPassword: Word): WordBool;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool;
    function FPMakeXReport(ReportPassword: Word): WordBool;
    function FPMakeZReport(ReportPassword: Word): WordBool;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool;
    function FPCutterModeSwitch: WordBool;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
    function FPGetPaymentFormNames: WordBool;
    function FPGetCurrentStatus: WordBool;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
    function FPGetCashDrawerSum: WordBool;
    function FPGetDayReportProperties: WordBool;
    function FPGetTaxRates: WordBool;
    function FPGetItemData(ItemCode: Int64): WordBool;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
    function FPGetDayReportData: WordBool;
    function FPGetCurrentReceiptData: WordBool;
    function FPGetDayCorrectionsData: WordBool;
    function FPGetDayPacketData: WordBool;
    function FPGetDaySumOfAddTaxes: WordBool;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool;
    function FPPrintModemStatus: WordBool;
    function FPGetUserPassword(UserID: Byte): WordBool;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
    function FPPrintQRCode(const SerialQR: WideString): WordBool;
    function FPSetContrast(Value: Byte): WordBool;
    function FPGetContrast: WordBool;
    function FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool;
    function FPClearGraphicPattern: WordBool;
    function FPUploadStaticGraphicData: WordBool;
    function FPUploadGraphicDoc: WordBool;
    function FPPrintGraphicDoc: WordBool;
    function FPDeleteGraphicBitmaps: WordBool;
    function FPGetGraphicFreeMemorySize: WordBool;
    function FPUploadImagesFromPattern(InvertColors: WordBool): WordBool;
    function FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool;
    function FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool;
    function FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool;
    function FPGetGraphicObjectsList: WordBool;
    function FPDeleteBitmapObject(ObjIndex: Byte): WordBool;
    function FPFullEraseGraphicMemory: WordBool;
    function FPEraseLogo: WordBool;
    function FPGetRevizionID: WordBool;
    property  ControlInterface: IICS_MZ_11 read GetControlInterface;
    property  DefaultInterface: IICS_MZ_11 read GetControlInterface;
    property glVirtualPortOpened: WordBool index 573 read GetWordBoolProp;
    property stUseAdditionalTax: WordBool index 415 read GetWordBoolProp;
    property stUseAdditionalFee: WordBool index 416 read GetWordBoolProp;
    property stUseFontB: WordBool index 417 read GetWordBoolProp;
    property stUseTradeLogo: WordBool index 418 read GetWordBoolProp;
    property stUseCutter: WordBool index 419 read GetWordBoolProp;
    property stRefundReceiptMode: WordBool index 420 read GetWordBoolProp;
    property stPaymentMode: WordBool index 421 read GetWordBoolProp;
    property stFiscalMode: WordBool index 422 read GetWordBoolProp;
    property stServiceReceiptMode: WordBool index 423 read GetWordBoolProp;
    property stOnlinePrintMode: WordBool index 424 read GetWordBoolProp;
    property stFailureLastCommand: WordBool index 425 read GetWordBoolProp;
    property stFiscalDayIsOpened: WordBool index 426 read GetWordBoolProp;
    property stReceiptIsOpened: WordBool index 427 read GetWordBoolProp;
    property stCashDrawerIsOpened: WordBool index 428 read GetWordBoolProp;
    property stDisplayShowSumMode: WordBool index 441 read GetWordBoolProp;
    property prItemCost: Comp index 257 read GetCompProp;
    property prSumDiscount: Comp index 258 read GetCompProp;
    property prSumMarkup: Comp index 259 read GetCompProp;
    property prSumTotal: Comp index 260 read GetCompProp;
    property prSumBalance: Comp index 261 read GetCompProp;
    property prKSEFPacket: Integer index 262 read GetIntegerProp;
    property prKSEFPacketStr: WideString index 538 read GetWideStringProp;
    property prModemError: Byte index 263 read GetByteProp;
    property prCurrentDate: TDateTime index 264 read GetTDateTimeProp;
    property prCurrentDateStr: WideString index 265 read GetWideStringProp;
    property prCurrentTime: TDateTime index 266 read GetTDateTimeProp;
    property prCurrentTimeStr: WideString index 267 read GetWideStringProp;
    property prTaxRatesDate: TDateTime index 269 read GetTDateTimeProp;
    property prTaxRatesDateStr: WideString index 270 read GetWideStringProp;
    property prTaxRate6: Integer index 277 read GetIntegerProp;
    property prNamePaymentForm1: WideString index 291 read GetWideStringProp;
    property prNamePaymentForm2: WideString index 292 read GetWideStringProp;
    property prNamePaymentForm3: WideString index 293 read GetWideStringProp;
    property prNamePaymentForm4: WideString index 294 read GetWideStringProp;
    property prNamePaymentForm5: WideString index 295 read GetWideStringProp;
    property prNamePaymentForm6: WideString index 296 read GetWideStringProp;
    property prNamePaymentForm7: WideString index 297 read GetWideStringProp;
    property prNamePaymentForm8: WideString index 298 read GetWideStringProp;
    property prNamePaymentForm9: WideString index 299 read GetWideStringProp;
    property prNamePaymentForm10: WideString index 300 read GetWideStringProp;
    property prSerialNumber: WideString index 301 read GetWideStringProp;
    property prFiscalNumber: WideString index 302 read GetWideStringProp;
    property prTaxNumber: WideString index 303 read GetWideStringProp;
    property prDateFiscalization: TDateTime index 304 read GetTDateTimeProp;
    property prDateFiscalizationStr: WideString index 305 read GetWideStringProp;
    property prTimeFiscalization: TDateTime index 306 read GetTDateTimeProp;
    property prTimeFiscalizationStr: WideString index 307 read GetWideStringProp;
    property prHeadLine1: WideString index 308 read GetWideStringProp;
    property prHeadLine2: WideString index 309 read GetWideStringProp;
    property prHeadLine3: WideString index 310 read GetWideStringProp;
    property prHardwareVersion: WideString index 311 read GetWideStringProp;
    property prItemName: WideString index 312 read GetWideStringProp;
    property prItemPrice: Integer index 313 read GetIntegerProp;
    property prItemSaleQuantity: Integer index 314 read GetIntegerProp;
    property prItemSaleQtyPrecision: Byte index 315 read GetByteProp;
    property prItemTax: Byte index 316 read GetByteProp;
    property prItemSaleSum: Comp index 317 read GetCompProp;
    property prItemSaleSumStr: WideString index 318 read GetWideStringProp;
    property prItemRefundQuantity: Integer index 319 read GetIntegerProp;
    property prItemRefundQtyPrecision: Byte index 320 read GetByteProp;
    property prItemRefundSum: Comp index 321 read GetCompProp;
    property prItemRefundSumStr: WideString index 322 read GetWideStringProp;
    property prItemCostStr: WideString index 323 read GetWideStringProp;
    property prSumDiscountStr: WideString index 324 read GetWideStringProp;
    property prSumMarkupStr: WideString index 325 read GetWideStringProp;
    property prSumTotalStr: WideString index 326 read GetWideStringProp;
    property prSumBalanceStr: WideString index 327 read GetWideStringProp;
    property prCurReceiptTax1Sum: Integer index 328 read GetIntegerProp;
    property prCurReceiptTax2Sum: Integer index 329 read GetIntegerProp;
    property prCurReceiptTax3Sum: Integer index 330 read GetIntegerProp;
    property prCurReceiptTax4Sum: Integer index 331 read GetIntegerProp;
    property prCurReceiptTax5Sum: Integer index 332 read GetIntegerProp;
    property prCurReceiptTax6Sum: Integer index 333 read GetIntegerProp;
    property prCurReceiptTax1SumStr: WideString index 457 read GetWideStringProp;
    property prCurReceiptTax2SumStr: WideString index 458 read GetWideStringProp;
    property prCurReceiptTax3SumStr: WideString index 459 read GetWideStringProp;
    property prCurReceiptTax4SumStr: WideString index 460 read GetWideStringProp;
    property prCurReceiptTax5SumStr: WideString index 461 read GetWideStringProp;
    property prCurReceiptTax6SumStr: WideString index 462 read GetWideStringProp;
    property prCurReceiptPayForm1Sum: Integer index 334 read GetIntegerProp;
    property prCurReceiptPayForm2Sum: Integer index 335 read GetIntegerProp;
    property prCurReceiptPayForm3Sum: Integer index 336 read GetIntegerProp;
    property prCurReceiptPayForm4Sum: Integer index 337 read GetIntegerProp;
    property prCurReceiptPayForm5Sum: Integer index 338 read GetIntegerProp;
    property prCurReceiptPayForm6Sum: Integer index 339 read GetIntegerProp;
    property prCurReceiptPayForm7Sum: Integer index 340 read GetIntegerProp;
    property prCurReceiptPayForm8Sum: Integer index 341 read GetIntegerProp;
    property prCurReceiptPayForm9Sum: Integer index 342 read GetIntegerProp;
    property prCurReceiptPayForm10Sum: Integer index 343 read GetIntegerProp;
    property prCurReceiptPayForm1SumStr: WideString index 463 read GetWideStringProp;
    property prCurReceiptPayForm2SumStr: WideString index 464 read GetWideStringProp;
    property prCurReceiptPayForm3SumStr: WideString index 465 read GetWideStringProp;
    property prCurReceiptPayForm4SumStr: WideString index 466 read GetWideStringProp;
    property prCurReceiptPayForm5SumStr: WideString index 467 read GetWideStringProp;
    property prCurReceiptPayForm6SumStr: WideString index 468 read GetWideStringProp;
    property prCurReceiptPayForm7SumStr: WideString index 469 read GetWideStringProp;
    property prCurReceiptPayForm8SumStr: WideString index 470 read GetWideStringProp;
    property prCurReceiptPayForm9SumStr: WideString index 471 read GetWideStringProp;
    property prCurReceiptPayForm10SumStr: WideString index 472 read GetWideStringProp;
    property prPrinterError: WordBool index 344 read GetWordBoolProp;
    property prTapeNearEnd: WordBool index 345 read GetWordBoolProp;
    property prTapeEnded: WordBool index 346 read GetWordBoolProp;
    property prDaySaleReceiptsCount: Word index 347 read GetWordProp;
    property prDaySaleReceiptsCountStr: WideString index 473 read GetWideStringProp;
    property prDayRefundReceiptsCount: Word index 348 read GetWordProp;
    property prDayRefundReceiptsCountStr: WideString index 474 read GetWideStringProp;
    property prDaySaleSumOnTax1: Integer index 349 read GetIntegerProp;
    property prDaySaleSumOnTax2: Integer index 350 read GetIntegerProp;
    property prDaySaleSumOnTax3: Integer index 351 read GetIntegerProp;
    property prDaySaleSumOnTax4: Integer index 352 read GetIntegerProp;
    property prDaySaleSumOnTax5: Integer index 353 read GetIntegerProp;
    property prDaySaleSumOnTax6: Integer index 354 read GetIntegerProp;
    property prDaySaleSumOnTax1Str: WideString index 475 read GetWideStringProp;
    property prDaySaleSumOnTax2Str: WideString index 476 read GetWideStringProp;
    property prDaySaleSumOnTax3Str: WideString index 477 read GetWideStringProp;
    property prDaySaleSumOnTax4Str: WideString index 478 read GetWideStringProp;
    property prDaySaleSumOnTax5Str: WideString index 479 read GetWideStringProp;
    property prDaySaleSumOnTax6Str: WideString index 480 read GetWideStringProp;
    property prDayRefundSumOnTax1: Integer index 355 read GetIntegerProp;
    property prDayRefundSumOnTax2: Integer index 356 read GetIntegerProp;
    property prDayRefundSumOnTax3: Integer index 357 read GetIntegerProp;
    property prDayRefundSumOnTax4: Integer index 358 read GetIntegerProp;
    property prDayRefundSumOnTax5: Integer index 359 read GetIntegerProp;
    property prDayRefundSumOnTax6: Integer index 360 read GetIntegerProp;
    property prDayRefundSumOnTax1Str: WideString index 481 read GetWideStringProp;
    property prDayRefundSumOnTax2Str: WideString index 482 read GetWideStringProp;
    property prDayRefundSumOnTax3Str: WideString index 483 read GetWideStringProp;
    property prDayRefundSumOnTax4Str: WideString index 484 read GetWideStringProp;
    property prDayRefundSumOnTax5Str: WideString index 485 read GetWideStringProp;
    property prDayRefundSumOnTax6Str: WideString index 486 read GetWideStringProp;
    property prDaySaleSumOnPayForm1: Integer index 361 read GetIntegerProp;
    property prDaySaleSumOnPayForm2: Integer index 362 read GetIntegerProp;
    property prDaySaleSumOnPayForm3: Integer index 363 read GetIntegerProp;
    property prDaySaleSumOnPayForm4: Integer index 364 read GetIntegerProp;
    property prDaySaleSumOnPayForm5: Integer index 365 read GetIntegerProp;
    property prDaySaleSumOnPayForm6: Integer index 366 read GetIntegerProp;
    property prDaySaleSumOnPayForm7: Integer index 367 read GetIntegerProp;
    property prDaySaleSumOnPayForm8: Integer index 368 read GetIntegerProp;
    property prDaySaleSumOnPayForm9: Integer index 369 read GetIntegerProp;
    property prDaySaleSumOnPayForm10: Integer index 370 read GetIntegerProp;
    property prDaySaleSumOnPayForm1Str: WideString index 487 read GetWideStringProp;
    property prDaySaleSumOnPayForm2Str: WideString index 488 read GetWideStringProp;
    property prDaySaleSumOnPayForm3Str: WideString index 489 read GetWideStringProp;
    property prDaySaleSumOnPayForm4Str: WideString index 490 read GetWideStringProp;
    property prDaySaleSumOnPayForm5Str: WideString index 491 read GetWideStringProp;
    property prDaySaleSumOnPayForm6Str: WideString index 492 read GetWideStringProp;
    property prDaySaleSumOnPayForm7Str: WideString index 493 read GetWideStringProp;
    property prDaySaleSumOnPayForm8Str: WideString index 494 read GetWideStringProp;
    property prDaySaleSumOnPayForm9Str: WideString index 495 read GetWideStringProp;
    property prDaySaleSumOnPayForm10Str: WideString index 496 read GetWideStringProp;
    property prDayRefundSumOnPayForm1: Integer index 371 read GetIntegerProp;
    property prDayRefundSumOnPayForm2: Integer index 372 read GetIntegerProp;
    property prDayRefundSumOnPayForm3: Integer index 373 read GetIntegerProp;
    property prDayRefundSumOnPayForm4: Integer index 374 read GetIntegerProp;
    property prDayRefundSumOnPayForm5: Integer index 375 read GetIntegerProp;
    property prDayRefundSumOnPayForm6: Integer index 376 read GetIntegerProp;
    property prDayRefundSumOnPayForm7: Integer index 377 read GetIntegerProp;
    property prDayRefundSumOnPayForm8: Integer index 378 read GetIntegerProp;
    property prDayRefundSumOnPayForm9: Integer index 379 read GetIntegerProp;
    property prDayRefundSumOnPayForm10: Integer index 380 read GetIntegerProp;
    property prDayRefundSumOnPayForm1Str: WideString index 497 read GetWideStringProp;
    property prDayRefundSumOnPayForm2Str: WideString index 498 read GetWideStringProp;
    property prDayRefundSumOnPayForm3Str: WideString index 499 read GetWideStringProp;
    property prDayRefundSumOnPayForm4Str: WideString index 500 read GetWideStringProp;
    property prDayRefundSumOnPayForm5Str: WideString index 501 read GetWideStringProp;
    property prDayRefundSumOnPayForm6Str: WideString index 502 read GetWideStringProp;
    property prDayRefundSumOnPayForm7Str: WideString index 503 read GetWideStringProp;
    property prDayRefundSumOnPayForm8Str: WideString index 504 read GetWideStringProp;
    property prDayRefundSumOnPayForm9Str: WideString index 505 read GetWideStringProp;
    property prDayRefundSumOnPayForm10Str: WideString index 506 read GetWideStringProp;
    property prDayDiscountSumOnSales: Integer index 381 read GetIntegerProp;
    property prDayDiscountSumOnSalesStr: WideString index 507 read GetWideStringProp;
    property prDayMarkupSumOnSales: Integer index 382 read GetIntegerProp;
    property prDayMarkupSumOnSalesStr: WideString index 508 read GetWideStringProp;
    property prDayDiscountSumOnRefunds: Integer index 383 read GetIntegerProp;
    property prDayDiscountSumOnRefundsStr: WideString index 509 read GetWideStringProp;
    property prDayMarkupSumOnRefunds: Integer index 384 read GetIntegerProp;
    property prDayMarkupSumOnRefundsStr: WideString index 510 read GetWideStringProp;
    property prDayCashInSum: Integer index 385 read GetIntegerProp;
    property prDayCashInSumStr: WideString index 511 read GetWideStringProp;
    property prDayCashOutSum: Integer index 386 read GetIntegerProp;
    property prDayCashOutSumStr: WideString index 512 read GetWideStringProp;
    property prCurrentZReport: Word index 387 read GetWordProp;
    property prCurrentZReportStr: WideString index 513 read GetWideStringProp;
    property prDayEndDate: TDateTime index 388 read GetTDateTimeProp;
    property prDayEndDateStr: WideString index 389 read GetWideStringProp;
    property prDayEndTime: TDateTime index 390 read GetTDateTimeProp;
    property prDayEndTimeStr: WideString index 391 read GetWideStringProp;
    property prLastZReportDate: TDateTime index 392 read GetTDateTimeProp;
    property prLastZReportDateStr: WideString index 393 read GetWideStringProp;
    property prItemsCount: Word index 394 read GetWordProp;
    property prItemsCountStr: WideString index 514 read GetWideStringProp;
    property prDaySumAddTaxOfSale1: Integer index 395 read GetIntegerProp;
    property prDaySumAddTaxOfSale2: Integer index 396 read GetIntegerProp;
    property prDaySumAddTaxOfSale3: Integer index 397 read GetIntegerProp;
    property prDaySumAddTaxOfSale4: Integer index 398 read GetIntegerProp;
    property prDaySumAddTaxOfSale5: Integer index 399 read GetIntegerProp;
    property prDaySumAddTaxOfSale6: Integer index 400 read GetIntegerProp;
    property prDaySumAddTaxOfSale1Str: WideString index 515 read GetWideStringProp;
    property prDaySumAddTaxOfSale2Str: WideString index 516 read GetWideStringProp;
    property prDaySumAddTaxOfSale3Str: WideString index 517 read GetWideStringProp;
    property prDaySumAddTaxOfSale4Str: WideString index 518 read GetWideStringProp;
    property prDaySumAddTaxOfSale5Str: WideString index 519 read GetWideStringProp;
    property prDaySumAddTaxOfSale6Str: WideString index 520 read GetWideStringProp;
    property prDaySumAddTaxOfRefund1: Integer index 401 read GetIntegerProp;
    property prDaySumAddTaxOfRefund2: Integer index 402 read GetIntegerProp;
    property prDaySumAddTaxOfRefund3: Integer index 403 read GetIntegerProp;
    property prDaySumAddTaxOfRefund4: Integer index 404 read GetIntegerProp;
    property prDaySumAddTaxOfRefund5: Integer index 405 read GetIntegerProp;
    property prDaySumAddTaxOfRefund6: Integer index 406 read GetIntegerProp;
    property prDaySumAddTaxOfRefund1Str: WideString index 521 read GetWideStringProp;
    property prDaySumAddTaxOfRefund2Str: WideString index 522 read GetWideStringProp;
    property prDaySumAddTaxOfRefund3Str: WideString index 523 read GetWideStringProp;
    property prDaySumAddTaxOfRefund4Str: WideString index 524 read GetWideStringProp;
    property prDaySumAddTaxOfRefund5Str: WideString index 525 read GetWideStringProp;
    property prDaySumAddTaxOfRefund6Str: WideString index 526 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsCount: Word index 407 read GetWordProp;
    property prDayAnnuledSaleReceiptsCountStr: WideString index 527 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsCount: Word index 408 read GetWordProp;
    property prDayAnnuledRefundReceiptsCountStr: WideString index 528 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsSum: Integer index 409 read GetIntegerProp;
    property prDayAnnuledSaleReceiptsSumStr: WideString index 529 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsSum: Integer index 410 read GetIntegerProp;
    property prDayAnnuledRefundReceiptsSumStr: WideString index 530 read GetWideStringProp;
    property prDaySaleCancelingsCount: Word index 411 read GetWordProp;
    property prDaySaleCancelingsCountStr: WideString index 531 read GetWideStringProp;
    property prDayRefundCancelingsCount: Word index 412 read GetWordProp;
    property prDayRefundCancelingsCountStr: WideString index 532 read GetWideStringProp;
    property prDaySaleCancelingsSum: Integer index 413 read GetIntegerProp;
    property prDaySaleCancelingsSumStr: WideString index 533 read GetWideStringProp;
    property prDayRefundCancelingsSum: Integer index 414 read GetIntegerProp;
    property prDayRefundCancelingsSumStr: WideString index 534 read GetWideStringProp;
    property prDayFirstFreePacket: Integer index 563 read GetIntegerProp;
    property prDayLastSentPacket: Integer index 564 read GetIntegerProp;
    property prDayLastSignedPacket: Integer index 565 read GetIntegerProp;
    property prDayFirstFreePacketStr: WideString index 566 read GetWideStringProp;
    property prDayLastSentPacketStr: WideString index 567 read GetWideStringProp;
    property prDayLastSignedPacketStr: WideString index 568 read GetWideStringProp;
    property prCashDrawerSum: Comp index 429 read GetCompProp;
    property prCashDrawerSumStr: WideString index 430 read GetWideStringProp;
    property prGetStatusByte: Byte index 436 read GetByteProp;
    property prGetResultByte: Byte index 437 read GetByteProp;
    property prGetReserveByte: Byte index 438 read GetByteProp;
    property prGetErrorText: WideString index 439 read GetWideStringProp;
    property prCurReceiptItemCount: Byte index 451 read GetByteProp;
    property prUserPassword: Word index 536 read GetWordProp;
    property prUserPasswordStr: WideString index 537 read GetWideStringProp;
    property prPrintContrast: Byte index 542 read GetByteProp;
    property prGetGraphicFreeMemorySize: Integer index 571 read GetIntegerProp;
    property prGetGraphicFreeMemorySizeStr: WideString index 572 read GetWideStringProp;
    property prBitmapObjectsCount: Byte index 594 read GetByteProp;
    property prGetBitmapIndex[id: Byte]: Byte read Get_prGetBitmapIndex;
    property prUDPDeviceListSize: Byte index 596 read GetByteProp;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte index 551 read GetByteProp;
    property prFPDriverMajorVersion: Byte index 552 read GetByteProp;
    property prFPDriverMinorVersion: Byte index 553 read GetByteProp;
    property prFPDriverReleaseVersion: Byte index 554 read GetByteProp;
    property prFPDriverBuildVersion: Byte index 555 read GetByteProp;
  published
    property Anchors;
    property glTapeAnalizer: WordBool index 253 read GetWordBoolProp write SetWordBoolProp stored False;
    property glPropertiesAutoUpdateMode: WordBool index 254 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 255 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 256 read GetByteProp write SetByteProp stored False;
    property glUseVirtualPort: WordBool index 585 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRatesCount: Byte index 268 read GetByteProp write SetByteProp stored False;
    property prAddTaxType: WordBool index 271 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRate1: Integer index 272 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate2: Integer index 273 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate3: Integer index 274 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate4: Integer index 275 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate5: Integer index 276 read GetIntegerProp write SetIntegerProp stored False;
    property prUsedAdditionalFee: WordBool index 278 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeRate1: Integer index 279 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate2: Integer index 280 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate3: Integer index 281 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate4: Integer index 282 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate5: Integer index 283 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate6: Integer index 284 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxOnAddFee1: WordBool index 285 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee2: WordBool index 286 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee3: WordBool index 287 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee4: WordBool index 288 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee5: WordBool index 289 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee6: WordBool index 290 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice1: WordBool index 556 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice2: WordBool index 557 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice3: WordBool index 558 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice4: WordBool index 559 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice5: WordBool index 560 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice6: WordBool index 561 read GetWordBoolProp write SetWordBoolProp stored False;
    property prRepeatCount: Byte index 431 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 432 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 434 read GetByteProp write SetByteProp stored False;
    property prFont9x17: WordBool index 543 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontBold: WordBool index 544 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontSmall: WordBool index 545 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleHeight: WordBool index 546 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleWidth: WordBool index 547 read GetWordBoolProp write SetWordBoolProp stored False;
    property prProgPassword: Word index 569 read GetWordProp write SetWordProp stored False;
    property prProgPasswordStr: WideString index 570 read GetWideStringProp write SetWideStringProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_MF_09
// Help String      : ICS_MF_09 Object
// Default Interface: IICS_MF_09
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_MF_09 = class(TOleControl)
  private
    FIntf: IICS_MF_09;
    function  GetControlInterface: IICS_MF_09;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString;
    function Get_prUDPDeviceMAC(id: Byte): WideString;
    function Get_prUDPDeviceIP(id: Byte): WideString;
    function Get_prUDPDeviceTCPport(id: Byte): Word;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString;
  public
    function FPInitialize: Integer;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool;
    function FPClose: WordBool;
    function FPClaimUSBDevice: WordBool;
    function FPReleaseUSBDevice: WordBool;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
    function FPTCPClose: WordBool;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
    function FPPrintZeroReceipt: WordBool;
    function FPLineFeed: WordBool;
    function FPAnnulReceipt: WordBool;
    function FPCashIn(CashSum: SYSUINT): WordBool;
    function FPCashOut(CashSum: SYSUINT): WordBool;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
    function FPGetCurrentDate: WordBool;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
    function FPGetCurrentTime: WordBool;
    function FPOpenCashDrawer(Duration: Word): WordBool;
    function FPPrintHardwareVersion: WordBool;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool;
    function FPOnlineModeSwitch: WordBool;
    function FPCustomerDisplayModeSwitch: WordBool;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
    function FPCloseServiceReport: WordBool;
    function FPEnableLogo(ProgPassword: Word): WordBool;
    function FPDisableLogo(ProgPassword: Word): WordBool;
    function FPSetTaxRates(ProgPassword: Word): WordBool;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool;
    function FPMakeXReport(ReportPassword: Word): WordBool;
    function FPMakeZReport(ReportPassword: Word): WordBool;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool;
    function FPCutterModeSwitch: WordBool;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
    function FPGetPaymentFormNames: WordBool;
    function FPGetCurrentStatus: WordBool;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
    function FPGetCashDrawerSum: WordBool;
    function FPGetDayReportProperties: WordBool;
    function FPGetTaxRates: WordBool;
    function FPGetItemData(ItemCode: Int64): WordBool;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
    function FPGetDayReportData: WordBool;
    function FPGetCurrentReceiptData: WordBool;
    function FPGetDayCorrectionsData: WordBool;
    function FPGetDaySumOfAddTaxes: WordBool;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool;
    function FPPrintModemStatus: WordBool;
    function FPGetUserPassword(UserID: Byte): WordBool;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
    function FPPrintQRCode(const SerialQR: WideString): WordBool;
    function FPSetContrast(Value: Byte): WordBool;
    function FPGetContrast: WordBool;
    function FPGetRevizionID: WordBool;
    property  ControlInterface: IICS_MF_09 read GetControlInterface;
    property  DefaultInterface: IICS_MF_09 read GetControlInterface;
    property glVirtualPortOpened: WordBool index 562 read GetWordBoolProp;
    property stUseAdditionalTax: WordBool index 415 read GetWordBoolProp;
    property stUseAdditionalFee: WordBool index 416 read GetWordBoolProp;
    property stUseFontB: WordBool index 417 read GetWordBoolProp;
    property stUseTradeLogo: WordBool index 418 read GetWordBoolProp;
    property stUseCutter: WordBool index 419 read GetWordBoolProp;
    property stRefundReceiptMode: WordBool index 420 read GetWordBoolProp;
    property stPaymentMode: WordBool index 421 read GetWordBoolProp;
    property stFiscalMode: WordBool index 422 read GetWordBoolProp;
    property stServiceReceiptMode: WordBool index 423 read GetWordBoolProp;
    property stOnlinePrintMode: WordBool index 424 read GetWordBoolProp;
    property stFailureLastCommand: WordBool index 425 read GetWordBoolProp;
    property stFiscalDayIsOpened: WordBool index 426 read GetWordBoolProp;
    property stReceiptIsOpened: WordBool index 427 read GetWordBoolProp;
    property stCashDrawerIsOpened: WordBool index 428 read GetWordBoolProp;
    property stDisplayShowSumMode: WordBool index 441 read GetWordBoolProp;
    property prItemCost: Comp index 257 read GetCompProp;
    property prSumDiscount: Comp index 258 read GetCompProp;
    property prSumMarkup: Comp index 259 read GetCompProp;
    property prSumTotal: Comp index 260 read GetCompProp;
    property prSumBalance: Comp index 261 read GetCompProp;
    property prKSEFPacket: Integer index 262 read GetIntegerProp;
    property prKSEFPacketStr: WideString index 538 read GetWideStringProp;
    property prModemError: Byte index 263 read GetByteProp;
    property prCurrentDate: TDateTime index 264 read GetTDateTimeProp;
    property prCurrentDateStr: WideString index 265 read GetWideStringProp;
    property prCurrentTime: TDateTime index 266 read GetTDateTimeProp;
    property prCurrentTimeStr: WideString index 267 read GetWideStringProp;
    property prTaxRatesDate: TDateTime index 269 read GetTDateTimeProp;
    property prTaxRatesDateStr: WideString index 270 read GetWideStringProp;
    property prTaxRate6: Integer index 277 read GetIntegerProp;
    property prNamePaymentForm1: WideString index 291 read GetWideStringProp;
    property prNamePaymentForm2: WideString index 292 read GetWideStringProp;
    property prNamePaymentForm3: WideString index 293 read GetWideStringProp;
    property prNamePaymentForm4: WideString index 294 read GetWideStringProp;
    property prNamePaymentForm5: WideString index 295 read GetWideStringProp;
    property prNamePaymentForm6: WideString index 296 read GetWideStringProp;
    property prNamePaymentForm7: WideString index 297 read GetWideStringProp;
    property prNamePaymentForm8: WideString index 298 read GetWideStringProp;
    property prNamePaymentForm9: WideString index 299 read GetWideStringProp;
    property prNamePaymentForm10: WideString index 300 read GetWideStringProp;
    property prSerialNumber: WideString index 301 read GetWideStringProp;
    property prFiscalNumber: WideString index 302 read GetWideStringProp;
    property prTaxNumber: WideString index 303 read GetWideStringProp;
    property prDateFiscalization: TDateTime index 304 read GetTDateTimeProp;
    property prDateFiscalizationStr: WideString index 305 read GetWideStringProp;
    property prTimeFiscalization: TDateTime index 306 read GetTDateTimeProp;
    property prTimeFiscalizationStr: WideString index 307 read GetWideStringProp;
    property prHeadLine1: WideString index 308 read GetWideStringProp;
    property prHeadLine2: WideString index 309 read GetWideStringProp;
    property prHeadLine3: WideString index 310 read GetWideStringProp;
    property prHardwareVersion: WideString index 311 read GetWideStringProp;
    property prItemName: WideString index 312 read GetWideStringProp;
    property prItemPrice: Integer index 313 read GetIntegerProp;
    property prItemSaleQuantity: Integer index 314 read GetIntegerProp;
    property prItemSaleQtyPrecision: Byte index 315 read GetByteProp;
    property prItemTax: Byte index 316 read GetByteProp;
    property prItemSaleSum: Comp index 317 read GetCompProp;
    property prItemSaleSumStr: WideString index 318 read GetWideStringProp;
    property prItemRefundQuantity: Integer index 319 read GetIntegerProp;
    property prItemRefundQtyPrecision: Byte index 320 read GetByteProp;
    property prItemRefundSum: Comp index 321 read GetCompProp;
    property prItemRefundSumStr: WideString index 322 read GetWideStringProp;
    property prItemCostStr: WideString index 323 read GetWideStringProp;
    property prSumDiscountStr: WideString index 324 read GetWideStringProp;
    property prSumMarkupStr: WideString index 325 read GetWideStringProp;
    property prSumTotalStr: WideString index 326 read GetWideStringProp;
    property prSumBalanceStr: WideString index 327 read GetWideStringProp;
    property prCurReceiptTax1Sum: Integer index 328 read GetIntegerProp;
    property prCurReceiptTax2Sum: Integer index 329 read GetIntegerProp;
    property prCurReceiptTax3Sum: Integer index 330 read GetIntegerProp;
    property prCurReceiptTax4Sum: Integer index 331 read GetIntegerProp;
    property prCurReceiptTax5Sum: Integer index 332 read GetIntegerProp;
    property prCurReceiptTax6Sum: Integer index 333 read GetIntegerProp;
    property prCurReceiptTax1SumStr: WideString index 457 read GetWideStringProp;
    property prCurReceiptTax2SumStr: WideString index 458 read GetWideStringProp;
    property prCurReceiptTax3SumStr: WideString index 459 read GetWideStringProp;
    property prCurReceiptTax4SumStr: WideString index 460 read GetWideStringProp;
    property prCurReceiptTax5SumStr: WideString index 461 read GetWideStringProp;
    property prCurReceiptTax6SumStr: WideString index 462 read GetWideStringProp;
    property prCurReceiptPayForm1Sum: Integer index 334 read GetIntegerProp;
    property prCurReceiptPayForm2Sum: Integer index 335 read GetIntegerProp;
    property prCurReceiptPayForm3Sum: Integer index 336 read GetIntegerProp;
    property prCurReceiptPayForm4Sum: Integer index 337 read GetIntegerProp;
    property prCurReceiptPayForm5Sum: Integer index 338 read GetIntegerProp;
    property prCurReceiptPayForm6Sum: Integer index 339 read GetIntegerProp;
    property prCurReceiptPayForm7Sum: Integer index 340 read GetIntegerProp;
    property prCurReceiptPayForm8Sum: Integer index 341 read GetIntegerProp;
    property prCurReceiptPayForm9Sum: Integer index 342 read GetIntegerProp;
    property prCurReceiptPayForm10Sum: Integer index 343 read GetIntegerProp;
    property prCurReceiptPayForm1SumStr: WideString index 463 read GetWideStringProp;
    property prCurReceiptPayForm2SumStr: WideString index 464 read GetWideStringProp;
    property prCurReceiptPayForm3SumStr: WideString index 465 read GetWideStringProp;
    property prCurReceiptPayForm4SumStr: WideString index 466 read GetWideStringProp;
    property prCurReceiptPayForm5SumStr: WideString index 467 read GetWideStringProp;
    property prCurReceiptPayForm6SumStr: WideString index 468 read GetWideStringProp;
    property prCurReceiptPayForm7SumStr: WideString index 469 read GetWideStringProp;
    property prCurReceiptPayForm8SumStr: WideString index 470 read GetWideStringProp;
    property prCurReceiptPayForm9SumStr: WideString index 471 read GetWideStringProp;
    property prCurReceiptPayForm10SumStr: WideString index 472 read GetWideStringProp;
    property prPrinterError: WordBool index 344 read GetWordBoolProp;
    property prTapeNearEnd: WordBool index 345 read GetWordBoolProp;
    property prTapeEnded: WordBool index 346 read GetWordBoolProp;
    property prDaySaleReceiptsCount: Word index 347 read GetWordProp;
    property prDaySaleReceiptsCountStr: WideString index 473 read GetWideStringProp;
    property prDayRefundReceiptsCount: Word index 348 read GetWordProp;
    property prDayRefundReceiptsCountStr: WideString index 474 read GetWideStringProp;
    property prDaySaleSumOnTax1: Integer index 349 read GetIntegerProp;
    property prDaySaleSumOnTax2: Integer index 350 read GetIntegerProp;
    property prDaySaleSumOnTax3: Integer index 351 read GetIntegerProp;
    property prDaySaleSumOnTax4: Integer index 352 read GetIntegerProp;
    property prDaySaleSumOnTax5: Integer index 353 read GetIntegerProp;
    property prDaySaleSumOnTax6: Integer index 354 read GetIntegerProp;
    property prDaySaleSumOnTax1Str: WideString index 475 read GetWideStringProp;
    property prDaySaleSumOnTax2Str: WideString index 476 read GetWideStringProp;
    property prDaySaleSumOnTax3Str: WideString index 477 read GetWideStringProp;
    property prDaySaleSumOnTax4Str: WideString index 478 read GetWideStringProp;
    property prDaySaleSumOnTax5Str: WideString index 479 read GetWideStringProp;
    property prDaySaleSumOnTax6Str: WideString index 480 read GetWideStringProp;
    property prDayRefundSumOnTax1: Integer index 355 read GetIntegerProp;
    property prDayRefundSumOnTax2: Integer index 356 read GetIntegerProp;
    property prDayRefundSumOnTax3: Integer index 357 read GetIntegerProp;
    property prDayRefundSumOnTax4: Integer index 358 read GetIntegerProp;
    property prDayRefundSumOnTax5: Integer index 359 read GetIntegerProp;
    property prDayRefundSumOnTax6: Integer index 360 read GetIntegerProp;
    property prDayRefundSumOnTax1Str: WideString index 481 read GetWideStringProp;
    property prDayRefundSumOnTax2Str: WideString index 482 read GetWideStringProp;
    property prDayRefundSumOnTax3Str: WideString index 483 read GetWideStringProp;
    property prDayRefundSumOnTax4Str: WideString index 484 read GetWideStringProp;
    property prDayRefundSumOnTax5Str: WideString index 485 read GetWideStringProp;
    property prDayRefundSumOnTax6Str: WideString index 486 read GetWideStringProp;
    property prDaySaleSumOnPayForm1: Integer index 361 read GetIntegerProp;
    property prDaySaleSumOnPayForm2: Integer index 362 read GetIntegerProp;
    property prDaySaleSumOnPayForm3: Integer index 363 read GetIntegerProp;
    property prDaySaleSumOnPayForm4: Integer index 364 read GetIntegerProp;
    property prDaySaleSumOnPayForm5: Integer index 365 read GetIntegerProp;
    property prDaySaleSumOnPayForm6: Integer index 366 read GetIntegerProp;
    property prDaySaleSumOnPayForm7: Integer index 367 read GetIntegerProp;
    property prDaySaleSumOnPayForm8: Integer index 368 read GetIntegerProp;
    property prDaySaleSumOnPayForm9: Integer index 369 read GetIntegerProp;
    property prDaySaleSumOnPayForm10: Integer index 370 read GetIntegerProp;
    property prDaySaleSumOnPayForm1Str: WideString index 487 read GetWideStringProp;
    property prDaySaleSumOnPayForm2Str: WideString index 488 read GetWideStringProp;
    property prDaySaleSumOnPayForm3Str: WideString index 489 read GetWideStringProp;
    property prDaySaleSumOnPayForm4Str: WideString index 490 read GetWideStringProp;
    property prDaySaleSumOnPayForm5Str: WideString index 491 read GetWideStringProp;
    property prDaySaleSumOnPayForm6Str: WideString index 492 read GetWideStringProp;
    property prDaySaleSumOnPayForm7Str: WideString index 493 read GetWideStringProp;
    property prDaySaleSumOnPayForm8Str: WideString index 494 read GetWideStringProp;
    property prDaySaleSumOnPayForm9Str: WideString index 495 read GetWideStringProp;
    property prDaySaleSumOnPayForm10Str: WideString index 496 read GetWideStringProp;
    property prDayRefundSumOnPayForm1: Integer index 371 read GetIntegerProp;
    property prDayRefundSumOnPayForm2: Integer index 372 read GetIntegerProp;
    property prDayRefundSumOnPayForm3: Integer index 373 read GetIntegerProp;
    property prDayRefundSumOnPayForm4: Integer index 374 read GetIntegerProp;
    property prDayRefundSumOnPayForm5: Integer index 375 read GetIntegerProp;
    property prDayRefundSumOnPayForm6: Integer index 376 read GetIntegerProp;
    property prDayRefundSumOnPayForm7: Integer index 377 read GetIntegerProp;
    property prDayRefundSumOnPayForm8: Integer index 378 read GetIntegerProp;
    property prDayRefundSumOnPayForm9: Integer index 379 read GetIntegerProp;
    property prDayRefundSumOnPayForm10: Integer index 380 read GetIntegerProp;
    property prDayRefundSumOnPayForm1Str: WideString index 497 read GetWideStringProp;
    property prDayRefundSumOnPayForm2Str: WideString index 498 read GetWideStringProp;
    property prDayRefundSumOnPayForm3Str: WideString index 499 read GetWideStringProp;
    property prDayRefundSumOnPayForm4Str: WideString index 500 read GetWideStringProp;
    property prDayRefundSumOnPayForm5Str: WideString index 501 read GetWideStringProp;
    property prDayRefundSumOnPayForm6Str: WideString index 502 read GetWideStringProp;
    property prDayRefundSumOnPayForm7Str: WideString index 503 read GetWideStringProp;
    property prDayRefundSumOnPayForm8Str: WideString index 504 read GetWideStringProp;
    property prDayRefundSumOnPayForm9Str: WideString index 505 read GetWideStringProp;
    property prDayRefundSumOnPayForm10Str: WideString index 506 read GetWideStringProp;
    property prDayDiscountSumOnSales: Integer index 381 read GetIntegerProp;
    property prDayDiscountSumOnSalesStr: WideString index 507 read GetWideStringProp;
    property prDayMarkupSumOnSales: Integer index 382 read GetIntegerProp;
    property prDayMarkupSumOnSalesStr: WideString index 508 read GetWideStringProp;
    property prDayDiscountSumOnRefunds: Integer index 383 read GetIntegerProp;
    property prDayDiscountSumOnRefundsStr: WideString index 509 read GetWideStringProp;
    property prDayMarkupSumOnRefunds: Integer index 384 read GetIntegerProp;
    property prDayMarkupSumOnRefundsStr: WideString index 510 read GetWideStringProp;
    property prDayCashInSum: Integer index 385 read GetIntegerProp;
    property prDayCashInSumStr: WideString index 511 read GetWideStringProp;
    property prDayCashOutSum: Integer index 386 read GetIntegerProp;
    property prDayCashOutSumStr: WideString index 512 read GetWideStringProp;
    property prCurrentZReport: Word index 387 read GetWordProp;
    property prCurrentZReportStr: WideString index 513 read GetWideStringProp;
    property prDayEndDate: TDateTime index 388 read GetTDateTimeProp;
    property prDayEndDateStr: WideString index 389 read GetWideStringProp;
    property prDayEndTime: TDateTime index 390 read GetTDateTimeProp;
    property prDayEndTimeStr: WideString index 391 read GetWideStringProp;
    property prLastZReportDate: TDateTime index 392 read GetTDateTimeProp;
    property prLastZReportDateStr: WideString index 393 read GetWideStringProp;
    property prItemsCount: Word index 394 read GetWordProp;
    property prItemsCountStr: WideString index 514 read GetWideStringProp;
    property prDaySumAddTaxOfSale1: Integer index 395 read GetIntegerProp;
    property prDaySumAddTaxOfSale2: Integer index 396 read GetIntegerProp;
    property prDaySumAddTaxOfSale3: Integer index 397 read GetIntegerProp;
    property prDaySumAddTaxOfSale4: Integer index 398 read GetIntegerProp;
    property prDaySumAddTaxOfSale5: Integer index 399 read GetIntegerProp;
    property prDaySumAddTaxOfSale6: Integer index 400 read GetIntegerProp;
    property prDaySumAddTaxOfSale1Str: WideString index 515 read GetWideStringProp;
    property prDaySumAddTaxOfSale2Str: WideString index 516 read GetWideStringProp;
    property prDaySumAddTaxOfSale3Str: WideString index 517 read GetWideStringProp;
    property prDaySumAddTaxOfSale4Str: WideString index 518 read GetWideStringProp;
    property prDaySumAddTaxOfSale5Str: WideString index 519 read GetWideStringProp;
    property prDaySumAddTaxOfSale6Str: WideString index 520 read GetWideStringProp;
    property prDaySumAddTaxOfRefund1: Integer index 401 read GetIntegerProp;
    property prDaySumAddTaxOfRefund2: Integer index 402 read GetIntegerProp;
    property prDaySumAddTaxOfRefund3: Integer index 403 read GetIntegerProp;
    property prDaySumAddTaxOfRefund4: Integer index 404 read GetIntegerProp;
    property prDaySumAddTaxOfRefund5: Integer index 405 read GetIntegerProp;
    property prDaySumAddTaxOfRefund6: Integer index 406 read GetIntegerProp;
    property prDaySumAddTaxOfRefund1Str: WideString index 521 read GetWideStringProp;
    property prDaySumAddTaxOfRefund2Str: WideString index 522 read GetWideStringProp;
    property prDaySumAddTaxOfRefund3Str: WideString index 523 read GetWideStringProp;
    property prDaySumAddTaxOfRefund4Str: WideString index 524 read GetWideStringProp;
    property prDaySumAddTaxOfRefund5Str: WideString index 525 read GetWideStringProp;
    property prDaySumAddTaxOfRefund6Str: WideString index 526 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsCount: Word index 407 read GetWordProp;
    property prDayAnnuledSaleReceiptsCountStr: WideString index 527 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsCount: Word index 408 read GetWordProp;
    property prDayAnnuledRefundReceiptsCountStr: WideString index 528 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsSum: Integer index 409 read GetIntegerProp;
    property prDayAnnuledSaleReceiptsSumStr: WideString index 529 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsSum: Integer index 410 read GetIntegerProp;
    property prDayAnnuledRefundReceiptsSumStr: WideString index 530 read GetWideStringProp;
    property prDaySaleCancelingsCount: Word index 411 read GetWordProp;
    property prDaySaleCancelingsCountStr: WideString index 531 read GetWideStringProp;
    property prDayRefundCancelingsCount: Word index 412 read GetWordProp;
    property prDayRefundCancelingsCountStr: WideString index 532 read GetWideStringProp;
    property prDaySaleCancelingsSum: Integer index 413 read GetIntegerProp;
    property prDaySaleCancelingsSumStr: WideString index 533 read GetWideStringProp;
    property prDayRefundCancelingsSum: Integer index 414 read GetIntegerProp;
    property prDayRefundCancelingsSumStr: WideString index 534 read GetWideStringProp;
    property prCashDrawerSum: Comp index 429 read GetCompProp;
    property prCashDrawerSumStr: WideString index 430 read GetWideStringProp;
    property prGetStatusByte: Byte index 436 read GetByteProp;
    property prGetResultByte: Byte index 437 read GetByteProp;
    property prGetReserveByte: Byte index 438 read GetByteProp;
    property prGetErrorText: WideString index 439 read GetWideStringProp;
    property prCurReceiptItemCount: Byte index 451 read GetByteProp;
    property prUserPassword: Word index 536 read GetWordProp;
    property prUserPasswordStr: WideString index 537 read GetWideStringProp;
    property prPrintContrast: Byte index 542 read GetByteProp;
    property prUDPDeviceListSize: Byte index 568 read GetByteProp;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte index 551 read GetByteProp;
    property prFPDriverMajorVersion: Byte index 552 read GetByteProp;
    property prFPDriverMinorVersion: Byte index 553 read GetByteProp;
    property prFPDriverReleaseVersion: Byte index 554 read GetByteProp;
    property prFPDriverBuildVersion: Byte index 555 read GetByteProp;
  published
    property Anchors;
    property glTapeAnalizer: WordBool index 253 read GetWordBoolProp write SetWordBoolProp stored False;
    property glPropertiesAutoUpdateMode: WordBool index 254 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 255 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 256 read GetByteProp write SetByteProp stored False;
    property glUseVirtualPort: WordBool index 563 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRatesCount: Byte index 268 read GetByteProp write SetByteProp stored False;
    property prAddTaxType: WordBool index 271 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRate1: Integer index 272 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate2: Integer index 273 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate3: Integer index 274 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate4: Integer index 275 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate5: Integer index 276 read GetIntegerProp write SetIntegerProp stored False;
    property prUsedAdditionalFee: WordBool index 278 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeRate1: Integer index 279 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate2: Integer index 280 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate3: Integer index 281 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate4: Integer index 282 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate5: Integer index 283 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate6: Integer index 284 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxOnAddFee1: WordBool index 285 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee2: WordBool index 286 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee3: WordBool index 287 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee4: WordBool index 288 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee5: WordBool index 289 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee6: WordBool index 290 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice1: WordBool index 556 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice2: WordBool index 557 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice3: WordBool index 558 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice4: WordBool index 559 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice5: WordBool index 560 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice6: WordBool index 561 read GetWordBoolProp write SetWordBoolProp stored False;
    property prRepeatCount: Byte index 431 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 432 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 434 read GetByteProp write SetByteProp stored False;
    property prFont9x17: WordBool index 543 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontBold: WordBool index 544 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontSmall: WordBool index 545 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleHeight: WordBool index 546 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleWidth: WordBool index 547 read GetWordBoolProp write SetWordBoolProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_MF_11
// Help String      : ICS_MF_11 Object
// Default Interface: IICS_MF_11
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_MF_11 = class(TOleControl)
  private
    FIntf: IICS_MF_11;
    function  GetControlInterface: IICS_MF_11;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_prUDPDeviceSerialNumber(id: Byte): WideString;
    function Get_prUDPDeviceMAC(id: Byte): WideString;
    function Get_prUDPDeviceIP(id: Byte): WideString;
    function Get_prUDPDeviceTCPport(id: Byte): Word;
    function Get_prUDPDeviceTCPportStr(id: Byte): WideString;
  public
    function FPInitialize: Integer;
    function FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
    function FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                       WriteTimeout: Byte): WordBool;
    function FPClose: WordBool;
    function FPClaimUSBDevice: WordBool;
    function FPReleaseUSBDevice: WordBool;
    function FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
    function FPTCPClose: WordBool;
    function FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
    function FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
    function FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
    function FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                          PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                          ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                             PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                             ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                             const ItemCodeStr: WideString): WordBool;
    function FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                        PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                        ItemTax: Byte; const ItemName: WideString; ItemCode: Int64): WordBool;
    function FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                           PrintSingleQty: WordBool; PrintFromMemory: WordBool; ItemPrice: SYSINT; 
                           ItemTax: Byte; const ItemName: WideString; const ItemCodeStr: WideString): WordBool;
    function FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
    function FPPrintZeroReceipt: WordBool;
    function FPLineFeed: WordBool;
    function FPAnnulReceipt: WordBool;
    function FPCashIn(CashSum: SYSUINT): WordBool;
    function FPCashOut(CashSum: SYSUINT): WordBool;
    function FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                       AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
    function FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                isDoubleHeight: WordBool): WordBool;
    function FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; isDoubleWidth: WordBool; 
                                 isDoubleHeight: WordBool): WordBool;
    function FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
    function FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
    function FPGetCurrentDate: WordBool;
    function FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
    function FPGetCurrentTime: WordBool;
    function FPOpenCashDrawer(Duration: Word): WordBool;
    function FPPrintHardwareVersion: WordBool;
    function FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
    function FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
    function FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                            const TextLine: WideString): WordBool;
    function FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                          const TextLine: WideString): WordBool;
    function FPOnlineModeSwitch: WordBool;
    function FPCustomerDisplayModeSwitch: WordBool;
    function FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
    function FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
    function FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
    function FPCloseServiceReport: WordBool;
    function FPEnableLogo(ProgPassword: Word): WordBool;
    function FPDisableLogo(ProgPassword: Word): WordBool;
    function FPSetTaxRates(ProgPassword: Word): WordBool;
    function FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                        ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                        ItemCode: Int64): WordBool;
    function FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                           ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                           const ItemCodeStr: WideString): WordBool;
    function FPMakeXReport(ReportPassword: Word): WordBool;
    function FPMakeZReport(ReportPassword: Word): WordBool;
    function FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; LastItemCode: Int64): WordBool;
    function FPMakeReportOnItemsStr(ReportPassword: Word; const FirstItemCodeStr: WideString; 
                                    const LastItemCodeStr: WideString): WordBool;
    function FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                        LastDate: TDateTime): WordBool;
    function FPMakePeriodicReportOnDateStr(ReportPassword: Word; const FirstDateStr: WideString; 
                                           const LastDateStr: WideString): WordBool;
    function FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                             LastDate: TDateTime): WordBool;
    function FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                const FirstDateStr: WideString; 
                                                const LastDateStr: WideString): WordBool;
    function FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; LastNumber: Word): WordBool;
    function FPCutterModeSwitch: WordBool;
    function FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
    function FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
    function FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
    function FPGetPaymentFormNames: WordBool;
    function FPGetCurrentStatus: WordBool;
    function FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
    function FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
    function FPGetCashDrawerSum: WordBool;
    function FPGetDayReportProperties: WordBool;
    function FPGetTaxRates: WordBool;
    function FPGetItemData(ItemCode: Int64): WordBool;
    function FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
    function FPGetDayReportData: WordBool;
    function FPGetCurrentReceiptData: WordBool;
    function FPGetDayCorrectionsData: WordBool;
    function FPGetDayPacketData: WordBool;
    function FPGetDaySumOfAddTaxes: WordBool;
    function FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; Compressed: WordBool): WordBool;
    function FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                             AsFiscalReceipt: WordBool; const CardInfo: WideString; 
                             const AuthCode: WideString): WordBool;
    function FPPrintModemStatus: WordBool;
    function FPGetUserPassword(UserID: Byte): WordBool;
    function FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
    function FPPrintQRCode(const SerialQR: WideString): WordBool;
    function FPSetContrast(Value: Byte): WordBool;
    function FPGetContrast: WordBool;
    function FPGetRevizionID: WordBool;
    property  ControlInterface: IICS_MF_11 read GetControlInterface;
    property  DefaultInterface: IICS_MF_11 read GetControlInterface;
    property glVirtualPortOpened: WordBool index 569 read GetWordBoolProp;
    property stUseAdditionalTax: WordBool index 415 read GetWordBoolProp;
    property stUseAdditionalFee: WordBool index 416 read GetWordBoolProp;
    property stUseFontB: WordBool index 417 read GetWordBoolProp;
    property stUseTradeLogo: WordBool index 418 read GetWordBoolProp;
    property stUseCutter: WordBool index 419 read GetWordBoolProp;
    property stRefundReceiptMode: WordBool index 420 read GetWordBoolProp;
    property stPaymentMode: WordBool index 421 read GetWordBoolProp;
    property stFiscalMode: WordBool index 422 read GetWordBoolProp;
    property stServiceReceiptMode: WordBool index 423 read GetWordBoolProp;
    property stOnlinePrintMode: WordBool index 424 read GetWordBoolProp;
    property stFailureLastCommand: WordBool index 425 read GetWordBoolProp;
    property stFiscalDayIsOpened: WordBool index 426 read GetWordBoolProp;
    property stReceiptIsOpened: WordBool index 427 read GetWordBoolProp;
    property stCashDrawerIsOpened: WordBool index 428 read GetWordBoolProp;
    property stDisplayShowSumMode: WordBool index 441 read GetWordBoolProp;
    property prItemCost: Comp index 257 read GetCompProp;
    property prSumDiscount: Comp index 258 read GetCompProp;
    property prSumMarkup: Comp index 259 read GetCompProp;
    property prSumTotal: Comp index 260 read GetCompProp;
    property prSumBalance: Comp index 261 read GetCompProp;
    property prKSEFPacket: Integer index 262 read GetIntegerProp;
    property prKSEFPacketStr: WideString index 538 read GetWideStringProp;
    property prModemError: Byte index 263 read GetByteProp;
    property prCurrentDate: TDateTime index 264 read GetTDateTimeProp;
    property prCurrentDateStr: WideString index 265 read GetWideStringProp;
    property prCurrentTime: TDateTime index 266 read GetTDateTimeProp;
    property prCurrentTimeStr: WideString index 267 read GetWideStringProp;
    property prTaxRatesDate: TDateTime index 269 read GetTDateTimeProp;
    property prTaxRatesDateStr: WideString index 270 read GetWideStringProp;
    property prTaxRate6: Integer index 277 read GetIntegerProp;
    property prNamePaymentForm1: WideString index 291 read GetWideStringProp;
    property prNamePaymentForm2: WideString index 292 read GetWideStringProp;
    property prNamePaymentForm3: WideString index 293 read GetWideStringProp;
    property prNamePaymentForm4: WideString index 294 read GetWideStringProp;
    property prNamePaymentForm5: WideString index 295 read GetWideStringProp;
    property prNamePaymentForm6: WideString index 296 read GetWideStringProp;
    property prNamePaymentForm7: WideString index 297 read GetWideStringProp;
    property prNamePaymentForm8: WideString index 298 read GetWideStringProp;
    property prNamePaymentForm9: WideString index 299 read GetWideStringProp;
    property prNamePaymentForm10: WideString index 300 read GetWideStringProp;
    property prSerialNumber: WideString index 301 read GetWideStringProp;
    property prFiscalNumber: WideString index 302 read GetWideStringProp;
    property prTaxNumber: WideString index 303 read GetWideStringProp;
    property prDateFiscalization: TDateTime index 304 read GetTDateTimeProp;
    property prDateFiscalizationStr: WideString index 305 read GetWideStringProp;
    property prTimeFiscalization: TDateTime index 306 read GetTDateTimeProp;
    property prTimeFiscalizationStr: WideString index 307 read GetWideStringProp;
    property prHeadLine1: WideString index 308 read GetWideStringProp;
    property prHeadLine2: WideString index 309 read GetWideStringProp;
    property prHeadLine3: WideString index 310 read GetWideStringProp;
    property prHardwareVersion: WideString index 311 read GetWideStringProp;
    property prItemName: WideString index 312 read GetWideStringProp;
    property prItemPrice: Integer index 313 read GetIntegerProp;
    property prItemSaleQuantity: Integer index 314 read GetIntegerProp;
    property prItemSaleQtyPrecision: Byte index 315 read GetByteProp;
    property prItemTax: Byte index 316 read GetByteProp;
    property prItemSaleSum: Comp index 317 read GetCompProp;
    property prItemSaleSumStr: WideString index 318 read GetWideStringProp;
    property prItemRefundQuantity: Integer index 319 read GetIntegerProp;
    property prItemRefundQtyPrecision: Byte index 320 read GetByteProp;
    property prItemRefundSum: Comp index 321 read GetCompProp;
    property prItemRefundSumStr: WideString index 322 read GetWideStringProp;
    property prItemCostStr: WideString index 323 read GetWideStringProp;
    property prSumDiscountStr: WideString index 324 read GetWideStringProp;
    property prSumMarkupStr: WideString index 325 read GetWideStringProp;
    property prSumTotalStr: WideString index 326 read GetWideStringProp;
    property prSumBalanceStr: WideString index 327 read GetWideStringProp;
    property prCurReceiptTax1Sum: Integer index 328 read GetIntegerProp;
    property prCurReceiptTax2Sum: Integer index 329 read GetIntegerProp;
    property prCurReceiptTax3Sum: Integer index 330 read GetIntegerProp;
    property prCurReceiptTax4Sum: Integer index 331 read GetIntegerProp;
    property prCurReceiptTax5Sum: Integer index 332 read GetIntegerProp;
    property prCurReceiptTax6Sum: Integer index 333 read GetIntegerProp;
    property prCurReceiptTax1SumStr: WideString index 457 read GetWideStringProp;
    property prCurReceiptTax2SumStr: WideString index 458 read GetWideStringProp;
    property prCurReceiptTax3SumStr: WideString index 459 read GetWideStringProp;
    property prCurReceiptTax4SumStr: WideString index 460 read GetWideStringProp;
    property prCurReceiptTax5SumStr: WideString index 461 read GetWideStringProp;
    property prCurReceiptTax6SumStr: WideString index 462 read GetWideStringProp;
    property prCurReceiptPayForm1Sum: Integer index 334 read GetIntegerProp;
    property prCurReceiptPayForm2Sum: Integer index 335 read GetIntegerProp;
    property prCurReceiptPayForm3Sum: Integer index 336 read GetIntegerProp;
    property prCurReceiptPayForm4Sum: Integer index 337 read GetIntegerProp;
    property prCurReceiptPayForm5Sum: Integer index 338 read GetIntegerProp;
    property prCurReceiptPayForm6Sum: Integer index 339 read GetIntegerProp;
    property prCurReceiptPayForm7Sum: Integer index 340 read GetIntegerProp;
    property prCurReceiptPayForm8Sum: Integer index 341 read GetIntegerProp;
    property prCurReceiptPayForm9Sum: Integer index 342 read GetIntegerProp;
    property prCurReceiptPayForm10Sum: Integer index 343 read GetIntegerProp;
    property prCurReceiptPayForm1SumStr: WideString index 463 read GetWideStringProp;
    property prCurReceiptPayForm2SumStr: WideString index 464 read GetWideStringProp;
    property prCurReceiptPayForm3SumStr: WideString index 465 read GetWideStringProp;
    property prCurReceiptPayForm4SumStr: WideString index 466 read GetWideStringProp;
    property prCurReceiptPayForm5SumStr: WideString index 467 read GetWideStringProp;
    property prCurReceiptPayForm6SumStr: WideString index 468 read GetWideStringProp;
    property prCurReceiptPayForm7SumStr: WideString index 469 read GetWideStringProp;
    property prCurReceiptPayForm8SumStr: WideString index 470 read GetWideStringProp;
    property prCurReceiptPayForm9SumStr: WideString index 471 read GetWideStringProp;
    property prCurReceiptPayForm10SumStr: WideString index 472 read GetWideStringProp;
    property prPrinterError: WordBool index 344 read GetWordBoolProp;
    property prTapeNearEnd: WordBool index 345 read GetWordBoolProp;
    property prTapeEnded: WordBool index 346 read GetWordBoolProp;
    property prDaySaleReceiptsCount: Word index 347 read GetWordProp;
    property prDaySaleReceiptsCountStr: WideString index 473 read GetWideStringProp;
    property prDayRefundReceiptsCount: Word index 348 read GetWordProp;
    property prDayRefundReceiptsCountStr: WideString index 474 read GetWideStringProp;
    property prDaySaleSumOnTax1: Integer index 349 read GetIntegerProp;
    property prDaySaleSumOnTax2: Integer index 350 read GetIntegerProp;
    property prDaySaleSumOnTax3: Integer index 351 read GetIntegerProp;
    property prDaySaleSumOnTax4: Integer index 352 read GetIntegerProp;
    property prDaySaleSumOnTax5: Integer index 353 read GetIntegerProp;
    property prDaySaleSumOnTax6: Integer index 354 read GetIntegerProp;
    property prDaySaleSumOnTax1Str: WideString index 475 read GetWideStringProp;
    property prDaySaleSumOnTax2Str: WideString index 476 read GetWideStringProp;
    property prDaySaleSumOnTax3Str: WideString index 477 read GetWideStringProp;
    property prDaySaleSumOnTax4Str: WideString index 478 read GetWideStringProp;
    property prDaySaleSumOnTax5Str: WideString index 479 read GetWideStringProp;
    property prDaySaleSumOnTax6Str: WideString index 480 read GetWideStringProp;
    property prDayRefundSumOnTax1: Integer index 355 read GetIntegerProp;
    property prDayRefundSumOnTax2: Integer index 356 read GetIntegerProp;
    property prDayRefundSumOnTax3: Integer index 357 read GetIntegerProp;
    property prDayRefundSumOnTax4: Integer index 358 read GetIntegerProp;
    property prDayRefundSumOnTax5: Integer index 359 read GetIntegerProp;
    property prDayRefundSumOnTax6: Integer index 360 read GetIntegerProp;
    property prDayRefundSumOnTax1Str: WideString index 481 read GetWideStringProp;
    property prDayRefundSumOnTax2Str: WideString index 482 read GetWideStringProp;
    property prDayRefundSumOnTax3Str: WideString index 483 read GetWideStringProp;
    property prDayRefundSumOnTax4Str: WideString index 484 read GetWideStringProp;
    property prDayRefundSumOnTax5Str: WideString index 485 read GetWideStringProp;
    property prDayRefundSumOnTax6Str: WideString index 486 read GetWideStringProp;
    property prDaySaleSumOnPayForm1: Integer index 361 read GetIntegerProp;
    property prDaySaleSumOnPayForm2: Integer index 362 read GetIntegerProp;
    property prDaySaleSumOnPayForm3: Integer index 363 read GetIntegerProp;
    property prDaySaleSumOnPayForm4: Integer index 364 read GetIntegerProp;
    property prDaySaleSumOnPayForm5: Integer index 365 read GetIntegerProp;
    property prDaySaleSumOnPayForm6: Integer index 366 read GetIntegerProp;
    property prDaySaleSumOnPayForm7: Integer index 367 read GetIntegerProp;
    property prDaySaleSumOnPayForm8: Integer index 368 read GetIntegerProp;
    property prDaySaleSumOnPayForm9: Integer index 369 read GetIntegerProp;
    property prDaySaleSumOnPayForm10: Integer index 370 read GetIntegerProp;
    property prDaySaleSumOnPayForm1Str: WideString index 487 read GetWideStringProp;
    property prDaySaleSumOnPayForm2Str: WideString index 488 read GetWideStringProp;
    property prDaySaleSumOnPayForm3Str: WideString index 489 read GetWideStringProp;
    property prDaySaleSumOnPayForm4Str: WideString index 490 read GetWideStringProp;
    property prDaySaleSumOnPayForm5Str: WideString index 491 read GetWideStringProp;
    property prDaySaleSumOnPayForm6Str: WideString index 492 read GetWideStringProp;
    property prDaySaleSumOnPayForm7Str: WideString index 493 read GetWideStringProp;
    property prDaySaleSumOnPayForm8Str: WideString index 494 read GetWideStringProp;
    property prDaySaleSumOnPayForm9Str: WideString index 495 read GetWideStringProp;
    property prDaySaleSumOnPayForm10Str: WideString index 496 read GetWideStringProp;
    property prDayRefundSumOnPayForm1: Integer index 371 read GetIntegerProp;
    property prDayRefundSumOnPayForm2: Integer index 372 read GetIntegerProp;
    property prDayRefundSumOnPayForm3: Integer index 373 read GetIntegerProp;
    property prDayRefundSumOnPayForm4: Integer index 374 read GetIntegerProp;
    property prDayRefundSumOnPayForm5: Integer index 375 read GetIntegerProp;
    property prDayRefundSumOnPayForm6: Integer index 376 read GetIntegerProp;
    property prDayRefundSumOnPayForm7: Integer index 377 read GetIntegerProp;
    property prDayRefundSumOnPayForm8: Integer index 378 read GetIntegerProp;
    property prDayRefundSumOnPayForm9: Integer index 379 read GetIntegerProp;
    property prDayRefundSumOnPayForm10: Integer index 380 read GetIntegerProp;
    property prDayRefundSumOnPayForm1Str: WideString index 497 read GetWideStringProp;
    property prDayRefundSumOnPayForm2Str: WideString index 498 read GetWideStringProp;
    property prDayRefundSumOnPayForm3Str: WideString index 499 read GetWideStringProp;
    property prDayRefundSumOnPayForm4Str: WideString index 500 read GetWideStringProp;
    property prDayRefundSumOnPayForm5Str: WideString index 501 read GetWideStringProp;
    property prDayRefundSumOnPayForm6Str: WideString index 502 read GetWideStringProp;
    property prDayRefundSumOnPayForm7Str: WideString index 503 read GetWideStringProp;
    property prDayRefundSumOnPayForm8Str: WideString index 504 read GetWideStringProp;
    property prDayRefundSumOnPayForm9Str: WideString index 505 read GetWideStringProp;
    property prDayRefundSumOnPayForm10Str: WideString index 506 read GetWideStringProp;
    property prDayDiscountSumOnSales: Integer index 381 read GetIntegerProp;
    property prDayDiscountSumOnSalesStr: WideString index 507 read GetWideStringProp;
    property prDayMarkupSumOnSales: Integer index 382 read GetIntegerProp;
    property prDayMarkupSumOnSalesStr: WideString index 508 read GetWideStringProp;
    property prDayDiscountSumOnRefunds: Integer index 383 read GetIntegerProp;
    property prDayDiscountSumOnRefundsStr: WideString index 509 read GetWideStringProp;
    property prDayMarkupSumOnRefunds: Integer index 384 read GetIntegerProp;
    property prDayMarkupSumOnRefundsStr: WideString index 510 read GetWideStringProp;
    property prDayCashInSum: Integer index 385 read GetIntegerProp;
    property prDayCashInSumStr: WideString index 511 read GetWideStringProp;
    property prDayCashOutSum: Integer index 386 read GetIntegerProp;
    property prDayCashOutSumStr: WideString index 512 read GetWideStringProp;
    property prCurrentZReport: Word index 387 read GetWordProp;
    property prCurrentZReportStr: WideString index 513 read GetWideStringProp;
    property prDayEndDate: TDateTime index 388 read GetTDateTimeProp;
    property prDayEndDateStr: WideString index 389 read GetWideStringProp;
    property prDayEndTime: TDateTime index 390 read GetTDateTimeProp;
    property prDayEndTimeStr: WideString index 391 read GetWideStringProp;
    property prLastZReportDate: TDateTime index 392 read GetTDateTimeProp;
    property prLastZReportDateStr: WideString index 393 read GetWideStringProp;
    property prItemsCount: Word index 394 read GetWordProp;
    property prItemsCountStr: WideString index 514 read GetWideStringProp;
    property prDaySumAddTaxOfSale1: Integer index 395 read GetIntegerProp;
    property prDaySumAddTaxOfSale2: Integer index 396 read GetIntegerProp;
    property prDaySumAddTaxOfSale3: Integer index 397 read GetIntegerProp;
    property prDaySumAddTaxOfSale4: Integer index 398 read GetIntegerProp;
    property prDaySumAddTaxOfSale5: Integer index 399 read GetIntegerProp;
    property prDaySumAddTaxOfSale6: Integer index 400 read GetIntegerProp;
    property prDaySumAddTaxOfSale1Str: WideString index 515 read GetWideStringProp;
    property prDaySumAddTaxOfSale2Str: WideString index 516 read GetWideStringProp;
    property prDaySumAddTaxOfSale3Str: WideString index 517 read GetWideStringProp;
    property prDaySumAddTaxOfSale4Str: WideString index 518 read GetWideStringProp;
    property prDaySumAddTaxOfSale5Str: WideString index 519 read GetWideStringProp;
    property prDaySumAddTaxOfSale6Str: WideString index 520 read GetWideStringProp;
    property prDaySumAddTaxOfRefund1: Integer index 401 read GetIntegerProp;
    property prDaySumAddTaxOfRefund2: Integer index 402 read GetIntegerProp;
    property prDaySumAddTaxOfRefund3: Integer index 403 read GetIntegerProp;
    property prDaySumAddTaxOfRefund4: Integer index 404 read GetIntegerProp;
    property prDaySumAddTaxOfRefund5: Integer index 405 read GetIntegerProp;
    property prDaySumAddTaxOfRefund6: Integer index 406 read GetIntegerProp;
    property prDaySumAddTaxOfRefund1Str: WideString index 521 read GetWideStringProp;
    property prDaySumAddTaxOfRefund2Str: WideString index 522 read GetWideStringProp;
    property prDaySumAddTaxOfRefund3Str: WideString index 523 read GetWideStringProp;
    property prDaySumAddTaxOfRefund4Str: WideString index 524 read GetWideStringProp;
    property prDaySumAddTaxOfRefund5Str: WideString index 525 read GetWideStringProp;
    property prDaySumAddTaxOfRefund6Str: WideString index 526 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsCount: Word index 407 read GetWordProp;
    property prDayAnnuledSaleReceiptsCountStr: WideString index 527 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsCount: Word index 408 read GetWordProp;
    property prDayAnnuledRefundReceiptsCountStr: WideString index 528 read GetWideStringProp;
    property prDayAnnuledSaleReceiptsSum: Integer index 409 read GetIntegerProp;
    property prDayAnnuledSaleReceiptsSumStr: WideString index 529 read GetWideStringProp;
    property prDayAnnuledRefundReceiptsSum: Integer index 410 read GetIntegerProp;
    property prDayAnnuledRefundReceiptsSumStr: WideString index 530 read GetWideStringProp;
    property prDaySaleCancelingsCount: Word index 411 read GetWordProp;
    property prDaySaleCancelingsCountStr: WideString index 531 read GetWideStringProp;
    property prDayRefundCancelingsCount: Word index 412 read GetWordProp;
    property prDayRefundCancelingsCountStr: WideString index 532 read GetWideStringProp;
    property prDaySaleCancelingsSum: Integer index 413 read GetIntegerProp;
    property prDaySaleCancelingsSumStr: WideString index 533 read GetWideStringProp;
    property prDayRefundCancelingsSum: Integer index 414 read GetIntegerProp;
    property prDayRefundCancelingsSumStr: WideString index 534 read GetWideStringProp;
    property prDayFirstFreePacket: Integer index 563 read GetIntegerProp;
    property prDayLastSentPacket: Integer index 564 read GetIntegerProp;
    property prDayLastSignedPacket: Integer index 565 read GetIntegerProp;
    property prDayFirstFreePacketStr: WideString index 566 read GetWideStringProp;
    property prDayLastSentPacketStr: WideString index 567 read GetWideStringProp;
    property prDayLastSignedPacketStr: WideString index 568 read GetWideStringProp;
    property prCashDrawerSum: Comp index 429 read GetCompProp;
    property prCashDrawerSumStr: WideString index 430 read GetWideStringProp;
    property prGetStatusByte: Byte index 436 read GetByteProp;
    property prGetResultByte: Byte index 437 read GetByteProp;
    property prGetReserveByte: Byte index 438 read GetByteProp;
    property prGetErrorText: WideString index 439 read GetWideStringProp;
    property prCurReceiptItemCount: Byte index 451 read GetByteProp;
    property prUserPassword: Word index 536 read GetWordProp;
    property prUserPasswordStr: WideString index 537 read GetWideStringProp;
    property prPrintContrast: Byte index 542 read GetByteProp;
    property prUDPDeviceListSize: Byte index 575 read GetByteProp;
    property prUDPDeviceSerialNumber[id: Byte]: WideString read Get_prUDPDeviceSerialNumber;
    property prUDPDeviceMAC[id: Byte]: WideString read Get_prUDPDeviceMAC;
    property prUDPDeviceIP[id: Byte]: WideString read Get_prUDPDeviceIP;
    property prUDPDeviceTCPport[id: Byte]: Word read Get_prUDPDeviceTCPport;
    property prUDPDeviceTCPportStr[id: Byte]: WideString read Get_prUDPDeviceTCPportStr;
    property prRevizionID: Byte index 551 read GetByteProp;
    property prFPDriverMajorVersion: Byte index 552 read GetByteProp;
    property prFPDriverMinorVersion: Byte index 553 read GetByteProp;
    property prFPDriverReleaseVersion: Byte index 554 read GetByteProp;
    property prFPDriverBuildVersion: Byte index 555 read GetByteProp;
  published
    property Anchors;
    property glTapeAnalizer: WordBool index 253 read GetWordBoolProp write SetWordBoolProp stored False;
    property glPropertiesAutoUpdateMode: WordBool index 254 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 255 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 256 read GetByteProp write SetByteProp stored False;
    property glUseVirtualPort: WordBool index 570 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRatesCount: Byte index 268 read GetByteProp write SetByteProp stored False;
    property prAddTaxType: WordBool index 271 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxRate1: Integer index 272 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate2: Integer index 273 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate3: Integer index 274 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate4: Integer index 275 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxRate5: Integer index 276 read GetIntegerProp write SetIntegerProp stored False;
    property prUsedAdditionalFee: WordBool index 278 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeRate1: Integer index 279 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate2: Integer index 280 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate3: Integer index 281 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate4: Integer index 282 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate5: Integer index 283 read GetIntegerProp write SetIntegerProp stored False;
    property prAddFeeRate6: Integer index 284 read GetIntegerProp write SetIntegerProp stored False;
    property prTaxOnAddFee1: WordBool index 285 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee2: WordBool index 286 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee3: WordBool index 287 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee4: WordBool index 288 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee5: WordBool index 289 read GetWordBoolProp write SetWordBoolProp stored False;
    property prTaxOnAddFee6: WordBool index 290 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice1: WordBool index 556 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice2: WordBool index 557 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice3: WordBool index 558 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice4: WordBool index 559 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice5: WordBool index 560 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAddFeeOnRetailPrice6: WordBool index 561 read GetWordBoolProp write SetWordBoolProp stored False;
    property prRepeatCount: Byte index 431 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 432 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 434 read GetByteProp write SetByteProp stored False;
    property prFont9x17: WordBool index 543 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontBold: WordBool index 544 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontSmall: WordBool index 545 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleHeight: WordBool index 546 read GetWordBoolProp write SetWordBoolProp stored False;
    property prFontDoubleWidth: WordBool index 547 read GetWordBoolProp write SetWordBoolProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_Modem
// Help String      : ICS_Modem Object
// Default Interface: IICS_Modem
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_Modem = class(TOleControl)
  private
    FIntf: IICS_Modem;
    function  GetControlInterface: IICS_Modem;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function ModemInitialize(const portName: WideString): Integer;
    function ModemAckuirerConnect: WordBool;
    function ModemAckuirerUnconditionalConnect: WordBool;
    function ModemUpdateStatus: WordBool;
    function ModemVerifyPacket(PacketID: SYSUINT): WordBool;
    function ModemFindPacket(DayReport: Word; ReceiptNumber: Word; ReceiptType: Byte): WordBool;
    function ModemFindPacketByDateTime(FindDateTime: TDateTime; FindForward: WordBool): WordBool;
    function ModemFindPacketByDateTimeStr(const FindDateTimeStr: WideString; FindForward: WordBool): WordBool;
    function ModemReadKsefPacket(PacketID: LongWord): WordBool;
    function ModemReadKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
    function ModemReadKsefByZReport(ZReport: Word): WordBool;
    function ModemGetCurrentTask: WordBool;
    function ModemSaveKsefRangeToBin(const Dir: WideString; const FileName: WideString; 
                                     FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
    function ModemSaveKsefByZreportToBin(const Dir: WideString; const FileName: WideString; 
                                         ZReport: Word): WordBool;
    property  ControlInterface: IICS_Modem read GetControlInterface;
    property  DefaultInterface: IICS_Modem read GetControlInterface;
    property stWorkSecondCount: Integer index 219 read GetIntegerProp;
    property stFPExchangeSecondCount: Integer index 220 read GetIntegerProp;
    property stFirstUnsendPIDDateTime: TDateTime index 221 read GetTDateTimeProp;
    property stFirstUnsendPIDDateTimeStr: WideString index 222 read GetWideStringProp;
    property stPID_Unused: Integer index 223 read GetIntegerProp;
    property stPID_CurPers: Integer index 224 read GetIntegerProp;
    property stPID_LastWrite: Integer index 225 read GetIntegerProp;
    property stPID_LastSign: Integer index 226 read GetIntegerProp;
    property stPID_LastSend: Integer index 227 read GetIntegerProp;
    property stSerialNumber: Integer index 228 read GetIntegerProp;
    property stID_DEV: Integer index 229 read GetIntegerProp;
    property stID_SAM: Integer index 230 read GetIntegerProp;
    property stNT_SAM: Integer index 231 read GetIntegerProp;
    property stNT_SESSION: Integer index 232 read GetIntegerProp;
    property stFailCode: Byte index 233 read GetByteProp;
    property stRes1: Byte index 234 read GetByteProp;
    property stBatVoltage: Integer index 235 read GetIntegerProp;
    property stDCVoltage: Integer index 236 read GetIntegerProp;
    property stBatCurrent: Integer index 237 read GetIntegerProp;
    property stTemperature: Integer index 238 read GetIntegerProp;
    property stState1: Byte index 239 read GetByteProp;
    property stState2: Byte index 240 read GetByteProp;
    property stState3: Byte index 241 read GetByteProp;
    property stLanState1: Byte index 242 read GetByteProp;
    property stLanState2: Byte index 243 read GetByteProp;
    property stFPExchangeResult: Byte index 244 read GetByteProp;
    property stACQExchangeResult: Byte index 245 read GetByteProp;
    property stRes2: Byte index 246 read GetByteProp;
    property stFPExchangeErrorCount: Integer index 247 read GetIntegerProp;
    property stRSSI: Byte index 248 read GetByteProp;
    property stRSSI_BER: Byte index 249 read GetByteProp;
    property stUSSDResult: WideString index 250 read GetWideStringProp;
    property stOSVer: Integer index 251 read GetIntegerProp;
    property stOSRev: Integer index 252 read GetIntegerProp;
    property stSysTime: TDateTime index 253 read GetTDateTimeProp;
    property stNETIPAddr: WideString index 254 read GetWideStringProp;
    property stNETGate: WideString index 255 read GetWideStringProp;
    property stNETMask: WideString index 256 read GetWideStringProp;
    property stMODIPAddr: WideString index 257 read GetWideStringProp;
    property stACQIPAddr: WideString index 258 read GetWideStringProp;
    property stACQPort: Integer index 259 read GetIntegerProp;
    property stACQExchangeSecondCount: Integer index 260 read GetIntegerProp;
    property stSysTimeStr: WideString index 263 read GetWideStringProp;
    property prFoundPacket: Integer index 209 read GetIntegerProp;
    property prFoundPacketStr: WideString index 266 read GetWideStringProp;
    property prCurrentTaskCode: Byte index 210 read GetByteProp;
    property prCurrentTaskText: WideString index 211 read GetWideStringProp;
    property prGetErrorCode: Byte index 206 read GetByteProp;
    property prGetErrorText: WideString index 207 read GetWideStringProp;
    property prModemDriverMajorVersion: Byte index 269 read GetByteProp;
    property prModemDriverMinorVersion: Byte index 270 read GetByteProp;
    property prModemDriverReleaseVersion: Byte index 271 read GetByteProp;
    property prModemDriverBuildVersion: Byte index 272 read GetByteProp;
  published
    property Anchors;
    property glPropertiesAutoUpdateMode: WordBool index 212 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 216 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 217 read GetByteProp write SetByteProp stored False;
    property prRepeatCount: Byte index 208 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 214 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 215 read GetByteProp write SetByteProp stored False;
    property prKsefSavePath: WideString index 262 read GetWideStringProp write SetWideStringProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TICS_Modem_08
// Help String      : ICS_Modem Object (deprecated coClass) 
// Default Interface: IICS_Modem
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TICS_Modem_08 = class(TOleControl)
  private
    FIntf: IICS_Modem;
    function  GetControlInterface: IICS_Modem;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function ModemInitialize(const portName: WideString): Integer;
    function ModemAckuirerConnect: WordBool;
    function ModemAckuirerUnconditionalConnect: WordBool;
    function ModemUpdateStatus: WordBool;
    function ModemVerifyPacket(PacketID: SYSUINT): WordBool;
    function ModemFindPacket(DayReport: Word; ReceiptNumber: Word; ReceiptType: Byte): WordBool;
    function ModemFindPacketByDateTime(FindDateTime: TDateTime; FindForward: WordBool): WordBool;
    function ModemFindPacketByDateTimeStr(const FindDateTimeStr: WideString; FindForward: WordBool): WordBool;
    function ModemReadKsefPacket(PacketID: LongWord): WordBool;
    function ModemReadKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
    function ModemReadKsefByZReport(ZReport: Word): WordBool;
    function ModemGetCurrentTask: WordBool;
    function ModemSaveKsefRangeToBin(const Dir: WideString; const FileName: WideString; 
                                     FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
    function ModemSaveKsefByZreportToBin(const Dir: WideString; const FileName: WideString; 
                                         ZReport: Word): WordBool;
    property  ControlInterface: IICS_Modem read GetControlInterface;
    property  DefaultInterface: IICS_Modem read GetControlInterface;
    property stWorkSecondCount: Integer index 219 read GetIntegerProp;
    property stFPExchangeSecondCount: Integer index 220 read GetIntegerProp;
    property stFirstUnsendPIDDateTime: TDateTime index 221 read GetTDateTimeProp;
    property stFirstUnsendPIDDateTimeStr: WideString index 222 read GetWideStringProp;
    property stPID_Unused: Integer index 223 read GetIntegerProp;
    property stPID_CurPers: Integer index 224 read GetIntegerProp;
    property stPID_LastWrite: Integer index 225 read GetIntegerProp;
    property stPID_LastSign: Integer index 226 read GetIntegerProp;
    property stPID_LastSend: Integer index 227 read GetIntegerProp;
    property stSerialNumber: Integer index 228 read GetIntegerProp;
    property stID_DEV: Integer index 229 read GetIntegerProp;
    property stID_SAM: Integer index 230 read GetIntegerProp;
    property stNT_SAM: Integer index 231 read GetIntegerProp;
    property stNT_SESSION: Integer index 232 read GetIntegerProp;
    property stFailCode: Byte index 233 read GetByteProp;
    property stRes1: Byte index 234 read GetByteProp;
    property stBatVoltage: Integer index 235 read GetIntegerProp;
    property stDCVoltage: Integer index 236 read GetIntegerProp;
    property stBatCurrent: Integer index 237 read GetIntegerProp;
    property stTemperature: Integer index 238 read GetIntegerProp;
    property stState1: Byte index 239 read GetByteProp;
    property stState2: Byte index 240 read GetByteProp;
    property stState3: Byte index 241 read GetByteProp;
    property stLanState1: Byte index 242 read GetByteProp;
    property stLanState2: Byte index 243 read GetByteProp;
    property stFPExchangeResult: Byte index 244 read GetByteProp;
    property stACQExchangeResult: Byte index 245 read GetByteProp;
    property stRes2: Byte index 246 read GetByteProp;
    property stFPExchangeErrorCount: Integer index 247 read GetIntegerProp;
    property stRSSI: Byte index 248 read GetByteProp;
    property stRSSI_BER: Byte index 249 read GetByteProp;
    property stUSSDResult: WideString index 250 read GetWideStringProp;
    property stOSVer: Integer index 251 read GetIntegerProp;
    property stOSRev: Integer index 252 read GetIntegerProp;
    property stSysTime: TDateTime index 253 read GetTDateTimeProp;
    property stNETIPAddr: WideString index 254 read GetWideStringProp;
    property stNETGate: WideString index 255 read GetWideStringProp;
    property stNETMask: WideString index 256 read GetWideStringProp;
    property stMODIPAddr: WideString index 257 read GetWideStringProp;
    property stACQIPAddr: WideString index 258 read GetWideStringProp;
    property stACQPort: Integer index 259 read GetIntegerProp;
    property stACQExchangeSecondCount: Integer index 260 read GetIntegerProp;
    property stSysTimeStr: WideString index 263 read GetWideStringProp;
    property prFoundPacket: Integer index 209 read GetIntegerProp;
    property prFoundPacketStr: WideString index 266 read GetWideStringProp;
    property prCurrentTaskCode: Byte index 210 read GetByteProp;
    property prCurrentTaskText: WideString index 211 read GetWideStringProp;
    property prGetErrorCode: Byte index 206 read GetByteProp;
    property prGetErrorText: WideString index 207 read GetWideStringProp;
    property prModemDriverMajorVersion: Byte index 269 read GetByteProp;
    property prModemDriverMinorVersion: Byte index 270 read GetByteProp;
    property prModemDriverReleaseVersion: Byte index 271 read GetByteProp;
    property prModemDriverBuildVersion: Byte index 272 read GetByteProp;
  published
    property Anchors;
    property glPropertiesAutoUpdateMode: WordBool index 212 read GetWordBoolProp write SetWordBoolProp stored False;
    property glCodepageOEM: WordBool index 216 read GetWordBoolProp write SetWordBoolProp stored False;
    property glLangID: Byte index 217 read GetByteProp write SetByteProp stored False;
    property prRepeatCount: Byte index 208 read GetByteProp write SetByteProp stored False;
    property prLogRecording: WordBool index 214 read GetWordBoolProp write SetWordBoolProp stored False;
    property prAnswerWaiting: Byte index 215 read GetByteProp write SetByteProp stored False;
    property prKsefSavePath: WideString index 262 read GetWideStringProp write SetWideStringProp stored False;
  end;

  CoFiscPrn = class
    class function Create_EP_11: IICS_EP_11;
    class function Create_MZ_11: IICS_MZ_11;
    class function CreateModem: IICS_Modem;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;


class function CoFiscPrn.Create_EP_11: IICS_EP_11;
begin
  Result := CreateComObject(CLASS_ICS_EP_11) as IICS_EP_11;
end;

class function CoFiscPrn.Create_MZ_11: IICS_MZ_11;
begin
  Result := CreateComObject(CLASS_ICS_MZ_11) as IICS_MZ_11;
end;

class function CoFiscPrn.CreateModem: IICS_Modem;
begin
  Result := CreateComObject(CLASS_ICS_Modem) as IICS_Modem;
end;


procedure TICS_EP_08.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{929C8C31-D325-4AF5-9097-AA9DACBD62B6}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_EP_08.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_EP_08;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_EP_08.GetControlInterface: IICS_EP_08;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_EP_08.FPInitialize: Integer;
begin
  Result := DefaultInterface.FPInitialize;
end;

function TICS_EP_08.FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpen(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_EP_08.FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                              WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpenStr(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_EP_08.FPClose: WordBool;
begin
  Result := DefaultInterface.FPClose;
end;

function TICS_EP_08.FPClaimUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPClaimUSBDevice;
end;

function TICS_EP_08.FPReleaseUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPReleaseUSBDevice;
end;

function TICS_EP_08.FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetPassword(UserID, OldPassword, NewPassword);
end;

function TICS_EP_08.FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
begin
  Result := DefaultInterface.FPRegisterCashier(CashierID, Name, Password);
end;

function TICS_EP_08.FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                 PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                 ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                 ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPRefundItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                          PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_EP_08.FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                    PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                    ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                    const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPRefundItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                             PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                             ItemCodeStr);
end;

function TICS_EP_08.FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                               PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPSaleItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                        PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_EP_08.FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool;
                                  PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSaleItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                           PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                           ItemCodeStr);
end;

function TICS_EP_08.FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
begin
  Result := DefaultInterface.FPCommentLine(CommentLine, OpenRefundReceipt);
end;

function TICS_EP_08.FPPrintZeroReceipt: WordBool;
begin
  Result := DefaultInterface.FPPrintZeroReceipt;
end;

function TICS_EP_08.FPLineFeed: WordBool;
begin
  Result := DefaultInterface.FPLineFeed;
end;

function TICS_EP_08.FPAnnulReceipt: WordBool;
begin
  Result := DefaultInterface.FPAnnulReceipt;
end;

function TICS_EP_08.FPCashIn(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashIn(CashSum);
end;

function TICS_EP_08.FPCashOut(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashOut(CashSum);
end;

function TICS_EP_08.FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                              AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPayment(PaymentForm, PaymentSum, AutoCloseReceipt, AsFiscalReceipt, 
                                       AuthCode);
end;

function TICS_EP_08.FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; 
                                       isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvHeaderLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_EP_08.FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; 
                                        isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvTrailerLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_EP_08.FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetLineCustomerDisplay(LineID, TextLine);
end;

function TICS_EP_08.FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDateStr(CurrentDateStr);
end;

function TICS_EP_08.FPGetCurrentDate: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentDate;
end;

function TICS_EP_08.FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTimeStr(CurrentTimeStr);
end;

function TICS_EP_08.FPGetCurrentTime: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentTime;
end;

function TICS_EP_08.FPOpenCashDrawer(Duration: Word): WordBool;
begin
  Result := DefaultInterface.FPOpenCashDrawer(Duration);
end;

function TICS_EP_08.FPPrintHardwareVersion: WordBool;
begin
  Result := DefaultInterface.FPPrintHardwareVersion;
end;

function TICS_EP_08.FPPrintLastKsefPacket: WordBool;
begin
  Result := DefaultInterface.FPPrintLastKsefPacket;
end;

function TICS_EP_08.FPPrintKsefPacket(PacketID: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefPacket(PacketID);
end;

function TICS_EP_08.FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                   const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeDiscount(isPercentType, isForItem, Value, TextLine);
end;

function TICS_EP_08.FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                 const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeMarkup(isPercentType, isForItem, Value, TextLine);
end;

function TICS_EP_08.FPOnlineModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPOnlineModeSwitch;
end;

function TICS_EP_08.FPCustomerDisplayModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCustomerDisplayModeSwitch;
end;

function TICS_EP_08.FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPChangeBaudRate(BaudRateIndex);
end;

function TICS_EP_08.FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportByLine(TextLine);
end;

function TICS_EP_08.FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportMultiLine(MultiLineText);
end;

function TICS_EP_08.FPCloseServiceReport: WordBool;
begin
  Result := DefaultInterface.FPCloseServiceReport;
end;

function TICS_EP_08.FPEnableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPEnableLogo(ProgPassword);
end;

function TICS_EP_08.FPDisableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPDisableLogo(ProgPassword);
end;

function TICS_EP_08.FPSetTaxRates(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetTaxRates(ProgPassword);
end;

function TICS_EP_08.FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPProgItem(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                        ItemTax, ItemName, ItemCode);
end;

function TICS_EP_08.FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPProgItemStr(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                           ItemTax, ItemName, ItemCodeStr);
end;

function TICS_EP_08.FPMakeXReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeXReport(ReportPassword);
end;

function TICS_EP_08.FPMakeZReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeZReport(ReportPassword);
end;

function TICS_EP_08.FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; 
                                        LastItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItems(ReportPassword, FirstItemCode, LastItemCode);
end;

function TICS_EP_08.FPMakeReportOnItemsStr(ReportPassword: Word; 
                                           const FirstItemCodeStr: WideString; 
                                           const LastItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItemsStr(ReportPassword, FirstItemCodeStr, 
                                                    LastItemCodeStr);
end;

function TICS_EP_08.FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                               LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_EP_08.FPMakePeriodicReportOnDateStr(ReportPassword: Word; 
                                                  const FirstDateStr: WideString; 
                                                  const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDateStr(ReportPassword, FirstDateStr, LastDateStr);
end;

function TICS_EP_08.FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                                    LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_EP_08.FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                       const FirstDateStr: WideString; 
                                                       const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDateStr(ReportPassword, FirstDateStr, 
                                                                LastDateStr);
end;

function TICS_EP_08.FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; 
                                                 LastNumber: Word): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnNumber(ReportPassword, FirstNumber, LastNumber);
end;

function TICS_EP_08.FPCutterModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCutterModeSwitch;
end;

function TICS_EP_08.FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceipt(SerialCode128B);
end;

function TICS_EP_08.FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceiptNew(SerialCode128C);
end;

function TICS_EP_08.FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnItem(SerialEAN13);
end;

function TICS_EP_08.FPGetPaymentFormNames: WordBool;
begin
  Result := DefaultInterface.FPGetPaymentFormNames;
end;

function TICS_EP_08.FPGetCurrentStatus: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentStatus;
end;

function TICS_EP_08.FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDate(CurrentDate);
end;

function TICS_EP_08.FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTime(CurrentTime);
end;

function TICS_EP_08.FPGetCashDrawerSum: WordBool;
begin
  Result := DefaultInterface.FPGetCashDrawerSum;
end;

function TICS_EP_08.FPGetDayReportProperties: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportProperties;
end;

function TICS_EP_08.FPGetTaxRates: WordBool;
begin
  Result := DefaultInterface.FPGetTaxRates;
end;

function TICS_EP_08.FPGetItemData(ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPGetItemData(ItemCode);
end;

function TICS_EP_08.FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPGetItemDataStr(ItemCodeStr);
end;

function TICS_EP_08.FPGetDayReportData: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportData;
end;

function TICS_EP_08.FPGetCurrentReceiptData: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentReceiptData;
end;

function TICS_EP_08.FPGetDayCorrectionsData: WordBool;
begin
  Result := DefaultInterface.FPGetDayCorrectionsData;
end;

function TICS_EP_08.FPGetDaySumOfAddTaxes: WordBool;
begin
  Result := DefaultInterface.FPGetDaySumOfAddTaxes;
end;

function TICS_EP_08.FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefRange(FirstPacketID, LastPacketID);
end;

function TICS_EP_08.FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; 
                                    AutoCloseReceipt: WordBool; AsFiscalReceipt: WordBool; 
                                    const CardInfo: WideString; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPaymentByCard(PaymentForm, PaymentSum, AutoCloseReceipt, 
                                             AsFiscalReceipt, CardInfo, AuthCode);
end;

function TICS_EP_08.FPPrintModemStatus: WordBool;
begin
  Result := DefaultInterface.FPPrintModemStatus;
end;

function TICS_EP_08.FPGetUserPassword(UserID: Byte): WordBool;
begin
  Result := DefaultInterface.FPGetUserPassword(UserID);
end;

function TICS_EP_08.FPGetRevizionID: WordBool;
begin
  Result := DefaultInterface.FPGetRevizionID;
end;

procedure TICS_EP_09.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{6FAF49AE-F551-4D37-8666-6F8645DCBC4B}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_EP_09.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_EP_09;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_EP_09.GetControlInterface: IICS_EP_09;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_EP_09.FPInitialize: Integer;
begin
  Result := DefaultInterface.FPInitialize;
end;

function TICS_EP_09.FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpen(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_EP_09.FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                              WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpenStr(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_EP_09.FPClose: WordBool;
begin
  Result := DefaultInterface.FPClose;
end;

function TICS_EP_09.FPClaimUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPClaimUSBDevice;
end;

function TICS_EP_09.FPReleaseUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPReleaseUSBDevice;
end;

function TICS_EP_09.FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetPassword(UserID, OldPassword, NewPassword);
end;

function TICS_EP_09.FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
begin
  Result := DefaultInterface.FPRegisterCashier(CashierID, Name, Password);
end;

function TICS_EP_09.FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                 PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                 ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                 ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPRefundItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                          PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_EP_09.FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                    PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                    ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                    const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPRefundItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                             PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                             ItemCodeStr);
end;

function TICS_EP_09.FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                               PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPSaleItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                        PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_EP_09.FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                  PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSaleItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                           PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                           ItemCodeStr);
end;

function TICS_EP_09.FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
begin
  Result := DefaultInterface.FPCommentLine(CommentLine, OpenRefundReceipt);
end;

function TICS_EP_09.FPPrintZeroReceipt: WordBool;
begin
  Result := DefaultInterface.FPPrintZeroReceipt;
end;

function TICS_EP_09.FPLineFeed: WordBool;
begin
  Result := DefaultInterface.FPLineFeed;
end;

function TICS_EP_09.FPAnnulReceipt: WordBool;
begin
  Result := DefaultInterface.FPAnnulReceipt;
end;

function TICS_EP_09.FPCashIn(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashIn(CashSum);
end;

function TICS_EP_09.FPCashOut(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashOut(CashSum);
end;

function TICS_EP_09.FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                              AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPayment(PaymentForm, PaymentSum, AutoCloseReceipt, AsFiscalReceipt, 
                                       AuthCode);
end;

function TICS_EP_09.FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; 
                                       isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvHeaderLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_EP_09.FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; 
                                        isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvTrailerLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_EP_09.FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetLineCustomerDisplay(LineID, TextLine);
end;

function TICS_EP_09.FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDateStr(CurrentDateStr);
end;

function TICS_EP_09.FPGetCurrentDate: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentDate;
end;

function TICS_EP_09.FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTimeStr(CurrentTimeStr);
end;

function TICS_EP_09.FPGetCurrentTime: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentTime;
end;

function TICS_EP_09.FPOpenCashDrawer(Duration: Word): WordBool;
begin
  Result := DefaultInterface.FPOpenCashDrawer(Duration);
end;

function TICS_EP_09.FPPrintHardwareVersion: WordBool;
begin
  Result := DefaultInterface.FPPrintHardwareVersion;
end;

function TICS_EP_09.FPPrintLastKsefPacket: WordBool;
begin
  Result := DefaultInterface.FPPrintLastKsefPacket;
end;

function TICS_EP_09.FPPrintKsefPacket(PacketID: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefPacket(PacketID);
end;

function TICS_EP_09.FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                   const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeDiscount(isPercentType, isForItem, Value, TextLine);
end;

function TICS_EP_09.FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                 const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeMarkup(isPercentType, isForItem, Value, TextLine);
end;

function TICS_EP_09.FPOnlineModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPOnlineModeSwitch;
end;

function TICS_EP_09.FPCustomerDisplayModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCustomerDisplayModeSwitch;
end;

function TICS_EP_09.FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPChangeBaudRate(BaudRateIndex);
end;

function TICS_EP_09.FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportByLine(TextLine);
end;

function TICS_EP_09.FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportMultiLine(MultiLineText);
end;

function TICS_EP_09.FPCloseServiceReport: WordBool;
begin
  Result := DefaultInterface.FPCloseServiceReport;
end;

function TICS_EP_09.FPEnableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPEnableLogo(ProgPassword);
end;

function TICS_EP_09.FPDisableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPDisableLogo(ProgPassword);
end;

function TICS_EP_09.FPSetTaxRates(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetTaxRates(ProgPassword);
end;

function TICS_EP_09.FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPProgItem(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                        ItemTax, ItemName, ItemCode);
end;

function TICS_EP_09.FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPProgItemStr(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                           ItemTax, ItemName, ItemCodeStr);
end;

function TICS_EP_09.FPMakeXReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeXReport(ReportPassword);
end;

function TICS_EP_09.FPMakeZReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeZReport(ReportPassword);
end;

function TICS_EP_09.FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; 
                                        LastItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItems(ReportPassword, FirstItemCode, LastItemCode);
end;

function TICS_EP_09.FPMakeReportOnItemsStr(ReportPassword: Word; 
                                           const FirstItemCodeStr: WideString; 
                                           const LastItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItemsStr(ReportPassword, FirstItemCodeStr, 
                                                    LastItemCodeStr);
end;

function TICS_EP_09.FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                               LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_EP_09.FPMakePeriodicReportOnDateStr(ReportPassword: Word; 
                                                  const FirstDateStr: WideString; 
                                                  const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDateStr(ReportPassword, FirstDateStr, LastDateStr);
end;

function TICS_EP_09.FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                                    LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_EP_09.FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                       const FirstDateStr: WideString; 
                                                       const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDateStr(ReportPassword, FirstDateStr, 
                                                                LastDateStr);
end;

function TICS_EP_09.FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; 
                                                 LastNumber: Word): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnNumber(ReportPassword, FirstNumber, LastNumber);
end;

function TICS_EP_09.FPCutterModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCutterModeSwitch;
end;

function TICS_EP_09.FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceipt(SerialCode128B);
end;

function TICS_EP_09.FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceiptNew(SerialCode128C);
end;

function TICS_EP_09.FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnItem(SerialEAN13);
end;

function TICS_EP_09.FPGetPaymentFormNames: WordBool;
begin
  Result := DefaultInterface.FPGetPaymentFormNames;
end;

function TICS_EP_09.FPGetCurrentStatus: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentStatus;
end;

function TICS_EP_09.FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDate(CurrentDate);
end;

function TICS_EP_09.FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTime(CurrentTime);
end;

function TICS_EP_09.FPGetCashDrawerSum: WordBool;
begin
  Result := DefaultInterface.FPGetCashDrawerSum;
end;

function TICS_EP_09.FPGetDayReportProperties: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportProperties;
end;

function TICS_EP_09.FPGetTaxRates: WordBool;
begin
  Result := DefaultInterface.FPGetTaxRates;
end;

function TICS_EP_09.FPGetItemData(ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPGetItemData(ItemCode);
end;

function TICS_EP_09.FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPGetItemDataStr(ItemCodeStr);
end;

function TICS_EP_09.FPGetDayReportData: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportData;
end;

function TICS_EP_09.FPGetCurrentReceiptData: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentReceiptData;
end;

function TICS_EP_09.FPGetDayCorrectionsData: WordBool;
begin
  Result := DefaultInterface.FPGetDayCorrectionsData;
end;

function TICS_EP_09.FPGetDaySumOfAddTaxes: WordBool;
begin
  Result := DefaultInterface.FPGetDaySumOfAddTaxes;
end;

function TICS_EP_09.FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefRange(FirstPacketID, LastPacketID);
end;

function TICS_EP_09.FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; 
                                    AutoCloseReceipt: WordBool; AsFiscalReceipt: WordBool; 
                                    const CardInfo: WideString; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPaymentByCard(PaymentForm, PaymentSum, AutoCloseReceipt, 
                                             AsFiscalReceipt, CardInfo, AuthCode);
end;

function TICS_EP_09.FPPrintModemStatus: WordBool;
begin
  Result := DefaultInterface.FPPrintModemStatus;
end;

function TICS_EP_09.FPGetUserPassword(UserID: Byte): WordBool;
begin
  Result := DefaultInterface.FPGetUserPassword(UserID);
end;

function TICS_EP_09.FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnServiceReport(SerialCode128B);
end;

function TICS_EP_09.FPPrintQRCode(const SerialQR: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintQRCode(SerialQR);
end;

function TICS_EP_09.FPGetRevizionID: WordBool;
begin
  Result := DefaultInterface.FPGetRevizionID;
end;

procedure TICS_EP_11.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{9199EB5C-C165-4434-A6BB-9657BC640E38}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_EP_11.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_EP_11;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_EP_11.GetControlInterface: IICS_EP_11;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_EP_11.Get_prGetBitmapIndex(id: Byte): Byte;
begin
  Result := DefaultInterface.prGetBitmapIndex[id];
end;

function TICS_EP_11.Get_prUDPDeviceSerialNumber(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceSerialNumber[id];
end;

function TICS_EP_11.Get_prUDPDeviceMAC(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceMAC[id];
end;

function TICS_EP_11.Get_prUDPDeviceIP(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceIP[id];
end;

function TICS_EP_11.Get_prUDPDeviceTCPport(id: Byte): Word;
begin
  Result := DefaultInterface.prUDPDeviceTCPport[id];
end;

function TICS_EP_11.Get_prUDPDeviceTCPportStr(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceTCPportStr[id];
end;

function TICS_EP_11.FPInitialize: Integer;
begin
  Result := DefaultInterface.FPInitialize;
end;

function TICS_EP_11.FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpen(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_EP_11.FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                              WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpenStr(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_EP_11.FPClose: WordBool;
begin
  Result := DefaultInterface.FPClose;
end;

function TICS_EP_11.FPClaimUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPClaimUSBDevice;
end;

function TICS_EP_11.FPReleaseUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPReleaseUSBDevice;
end;

function TICS_EP_11.FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
begin
  Result := DefaultInterface.FPTCPConnect(Host, TCP_port);
end;

function TICS_EP_11.FPTCPClose: WordBool;
begin
  Result := DefaultInterface.FPTCPClose;
end;

function TICS_EP_11.FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
begin
  Result := DefaultInterface.FPFindUDPDeviceList(SerialNumber);
end;

function TICS_EP_11.FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetPassword(UserID, OldPassword, NewPassword);
end;

function TICS_EP_11.FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
begin
  Result := DefaultInterface.FPRegisterCashier(CashierID, Name, Password);
end;

function TICS_EP_11.FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                 PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                 ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                 ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPRefundItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                          PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_EP_11.FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                    PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                    ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                    const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPRefundItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                             PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                             ItemCodeStr);
end;

function TICS_EP_11.FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                               PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPSaleItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                        PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_EP_11.FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                  PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSaleItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                           PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                           ItemCodeStr);
end;

function TICS_EP_11.FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
begin
  Result := DefaultInterface.FPCommentLine(CommentLine, OpenRefundReceipt);
end;

function TICS_EP_11.FPPrintZeroReceipt: WordBool;
begin
  Result := DefaultInterface.FPPrintZeroReceipt;
end;

function TICS_EP_11.FPLineFeed: WordBool;
begin
  Result := DefaultInterface.FPLineFeed;
end;

function TICS_EP_11.FPAnnulReceipt: WordBool;
begin
  Result := DefaultInterface.FPAnnulReceipt;
end;

function TICS_EP_11.FPCashIn(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashIn(CashSum);
end;

function TICS_EP_11.FPCashOut(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashOut(CashSum);
end;

function TICS_EP_11.FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                              AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPayment(PaymentForm, PaymentSum, AutoCloseReceipt, AsFiscalReceipt, 
                                       AuthCode);
end;

function TICS_EP_11.FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; 
                                       isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvHeaderLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_EP_11.FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; 
                                        isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvTrailerLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_EP_11.FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetLineCustomerDisplay(LineID, TextLine);
end;

function TICS_EP_11.FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDateStr(CurrentDateStr);
end;

function TICS_EP_11.FPGetCurrentDate: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentDate;
end;

function TICS_EP_11.FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTimeStr(CurrentTimeStr);
end;

function TICS_EP_11.FPGetCurrentTime: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentTime;
end;

function TICS_EP_11.FPOpenCashDrawer(Duration: Word): WordBool;
begin
  Result := DefaultInterface.FPOpenCashDrawer(Duration);
end;

function TICS_EP_11.FPPrintHardwareVersion: WordBool;
begin
  Result := DefaultInterface.FPPrintHardwareVersion;
end;

function TICS_EP_11.FPPrintLastKsefPacket: WordBool;
begin
  Result := DefaultInterface.FPPrintLastKsefPacket;
end;

function TICS_EP_11.FPPrintKsefPacket(PacketID: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefPacket(PacketID);
end;

function TICS_EP_11.FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                   const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeDiscount(isPercentType, isForItem, Value, TextLine);
end;

function TICS_EP_11.FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                 const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeMarkup(isPercentType, isForItem, Value, TextLine);
end;

function TICS_EP_11.FPOnlineModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPOnlineModeSwitch;
end;

function TICS_EP_11.FPCustomerDisplayModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCustomerDisplayModeSwitch;
end;

function TICS_EP_11.FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPChangeBaudRate(BaudRateIndex);
end;

function TICS_EP_11.FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportByLine(TextLine);
end;

function TICS_EP_11.FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportMultiLine(MultiLineText);
end;

function TICS_EP_11.FPCloseServiceReport: WordBool;
begin
  Result := DefaultInterface.FPCloseServiceReport;
end;

function TICS_EP_11.FPEnableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPEnableLogo(ProgPassword);
end;

function TICS_EP_11.FPDisableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPDisableLogo(ProgPassword);
end;

function TICS_EP_11.FPSetTaxRates(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetTaxRates(ProgPassword);
end;

function TICS_EP_11.FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPProgItem(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                        ItemTax, ItemName, ItemCode);
end;

function TICS_EP_11.FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPProgItemStr(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                           ItemTax, ItemName, ItemCodeStr);
end;

function TICS_EP_11.FPMakeXReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeXReport(ReportPassword);
end;

function TICS_EP_11.FPMakeZReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeZReport(ReportPassword);
end;

function TICS_EP_11.FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; 
                                        LastItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItems(ReportPassword, FirstItemCode, LastItemCode);
end;

function TICS_EP_11.FPMakeReportOnItemsStr(ReportPassword: Word; 
                                           const FirstItemCodeStr: WideString; 
                                           const LastItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItemsStr(ReportPassword, FirstItemCodeStr, 
                                                    LastItemCodeStr);
end;

function TICS_EP_11.FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                               LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_EP_11.FPMakePeriodicReportOnDateStr(ReportPassword: Word; 
                                                  const FirstDateStr: WideString; 
                                                  const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDateStr(ReportPassword, FirstDateStr, LastDateStr);
end;

function TICS_EP_11.FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                                    LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_EP_11.FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                       const FirstDateStr: WideString; 
                                                       const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDateStr(ReportPassword, FirstDateStr, 
                                                                LastDateStr);
end;

function TICS_EP_11.FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; 
                                                 LastNumber: Word): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnNumber(ReportPassword, FirstNumber, LastNumber);
end;

function TICS_EP_11.FPCutterModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCutterModeSwitch;
end;

function TICS_EP_11.FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceipt(SerialCode128B);
end;

function TICS_EP_11.FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceiptNew(SerialCode128C);
end;

function TICS_EP_11.FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnItem(SerialEAN13);
end;

function TICS_EP_11.FPGetPaymentFormNames: WordBool;
begin
  Result := DefaultInterface.FPGetPaymentFormNames;
end;

function TICS_EP_11.FPGetCurrentStatus: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentStatus;
end;

function TICS_EP_11.FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDate(CurrentDate);
end;

function TICS_EP_11.FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTime(CurrentTime);
end;

function TICS_EP_11.FPGetCashDrawerSum: WordBool;
begin
  Result := DefaultInterface.FPGetCashDrawerSum;
end;

function TICS_EP_11.FPGetDayReportProperties: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportProperties;
end;

function TICS_EP_11.FPGetTaxRates: WordBool;
begin
  Result := DefaultInterface.FPGetTaxRates;
end;

function TICS_EP_11.FPGetItemData(ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPGetItemData(ItemCode);
end;

function TICS_EP_11.FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPGetItemDataStr(ItemCodeStr);
end;

function TICS_EP_11.FPGetDayReportData: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportData;
end;

function TICS_EP_11.FPGetCurrentReceiptData: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentReceiptData;
end;

function TICS_EP_11.FPGetDayCorrectionsData: WordBool;
begin
  Result := DefaultInterface.FPGetDayCorrectionsData;
end;

function TICS_EP_11.FPGetDayPacketData: WordBool;
begin
  Result := DefaultInterface.FPGetDayPacketData;
end;

function TICS_EP_11.FPGetDaySumOfAddTaxes: WordBool;
begin
  Result := DefaultInterface.FPGetDaySumOfAddTaxes;
end;

function TICS_EP_11.FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefRange(FirstPacketID, LastPacketID);
end;

function TICS_EP_11.FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; 
                                    AutoCloseReceipt: WordBool; AsFiscalReceipt: WordBool; 
                                    const CardInfo: WideString; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPaymentByCard(PaymentForm, PaymentSum, AutoCloseReceipt, 
                                             AsFiscalReceipt, CardInfo, AuthCode);
end;

function TICS_EP_11.FPPrintModemStatus: WordBool;
begin
  Result := DefaultInterface.FPPrintModemStatus;
end;

function TICS_EP_11.FPGetUserPassword(UserID: Byte): WordBool;
begin
  Result := DefaultInterface.FPGetUserPassword(UserID);
end;

function TICS_EP_11.FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnServiceReport(SerialCode128B);
end;

function TICS_EP_11.FPPrintQRCode(const SerialQR: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintQRCode(SerialQR);
end;

function TICS_EP_11.FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool;
begin
  Result := DefaultInterface.FPLoadGraphicPattern(PatternFilePath);
end;

function TICS_EP_11.FPClearGraphicPattern: WordBool;
begin
  Result := DefaultInterface.FPClearGraphicPattern;
end;

function TICS_EP_11.FPUploadStaticGraphicData: WordBool;
begin
  Result := DefaultInterface.FPUploadStaticGraphicData;
end;

function TICS_EP_11.FPUploadGraphicDoc: WordBool;
begin
  Result := DefaultInterface.FPUploadGraphicDoc;
end;

function TICS_EP_11.FPPrintGraphicDoc: WordBool;
begin
  Result := DefaultInterface.FPPrintGraphicDoc;
end;

function TICS_EP_11.FPDeleteGraphicBitmaps: WordBool;
begin
  Result := DefaultInterface.FPDeleteGraphicBitmaps;
end;

function TICS_EP_11.FPGetGraphicFreeMemorySize: WordBool;
begin
  Result := DefaultInterface.FPGetGraphicFreeMemorySize;
end;

function TICS_EP_11.FPUploadImagesFromPattern(InvertColors: WordBool): WordBool;
begin
  Result := DefaultInterface.FPUploadImagesFromPattern(InvertColors);
end;

function TICS_EP_11.FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPUploadStringToGraphicDoc(LineIndex, TextLine);
end;

function TICS_EP_11.FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool;
begin
  Result := DefaultInterface.FPUploadBarcodeToGraphicDoc(BarcodeIndex, BarcodeData);
end;

function TICS_EP_11.FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool;
begin
  Result := DefaultInterface.FPUploadQRCodeToGraphicDoc(QRCodeIndex, QRCodeData);
end;

function TICS_EP_11.FPGetGraphicObjectsList: WordBool;
begin
  Result := DefaultInterface.FPGetGraphicObjectsList;
end;

function TICS_EP_11.FPDeleteBitmapObject(ObjIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPDeleteBitmapObject(ObjIndex);
end;

function TICS_EP_11.FPFullEraseGraphicMemory: WordBool;
begin
  Result := DefaultInterface.FPFullEraseGraphicMemory;
end;

function TICS_EP_11.FPEraseLogo: WordBool;
begin
  Result := DefaultInterface.FPEraseLogo;
end;

function TICS_EP_11.FPGetRevizionID: WordBool;
begin
  Result := DefaultInterface.FPGetRevizionID;
end;

procedure TICS_MZ_09.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{797961A8-DBE6-4C39-BB0C-34A91A133A82}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_MZ_09.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_MZ_09;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_MZ_09.GetControlInterface: IICS_MZ_09;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_MZ_09.FPInitialize: Integer;
begin
  Result := DefaultInterface.FPInitialize;
end;

function TICS_MZ_09.FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpen(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MZ_09.FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                              WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpenStr(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MZ_09.FPClose: WordBool;
begin
  Result := DefaultInterface.FPClose;
end;

function TICS_MZ_09.FPClaimUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPClaimUSBDevice;
end;

function TICS_MZ_09.FPReleaseUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPReleaseUSBDevice;
end;

function TICS_MZ_09.FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetPassword(UserID, OldPassword, NewPassword);
end;

function TICS_MZ_09.FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
begin
  Result := DefaultInterface.FPRegisterCashier(CashierID, Name, Password);
end;

function TICS_MZ_09.FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                 PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                 ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                 ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPRefundItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                          PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MZ_09.FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                    PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                    ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                    const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPRefundItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                             PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                             ItemCodeStr);
end;

function TICS_MZ_09.FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                               PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPSaleItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                        PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MZ_09.FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                  PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSaleItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                           PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                           ItemCodeStr);
end;

function TICS_MZ_09.FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
begin
  Result := DefaultInterface.FPCommentLine(CommentLine, OpenRefundReceipt);
end;

function TICS_MZ_09.FPPrintZeroReceipt: WordBool;
begin
  Result := DefaultInterface.FPPrintZeroReceipt;
end;

function TICS_MZ_09.FPLineFeed: WordBool;
begin
  Result := DefaultInterface.FPLineFeed;
end;

function TICS_MZ_09.FPAnnulReceipt: WordBool;
begin
  Result := DefaultInterface.FPAnnulReceipt;
end;

function TICS_MZ_09.FPCashIn(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashIn(CashSum);
end;

function TICS_MZ_09.FPCashOut(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashOut(CashSum);
end;

function TICS_MZ_09.FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                              AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPayment(PaymentForm, PaymentSum, AutoCloseReceipt, AsFiscalReceipt, 
                                       AuthCode);
end;

function TICS_MZ_09.FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; 
                                       isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvHeaderLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MZ_09.FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; 
                                        isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvTrailerLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MZ_09.FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetLineCustomerDisplay(LineID, TextLine);
end;

function TICS_MZ_09.FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDateStr(CurrentDateStr);
end;

function TICS_MZ_09.FPGetCurrentDate: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentDate;
end;

function TICS_MZ_09.FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTimeStr(CurrentTimeStr);
end;

function TICS_MZ_09.FPGetCurrentTime: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentTime;
end;

function TICS_MZ_09.FPOpenCashDrawer(Duration: Word): WordBool;
begin
  Result := DefaultInterface.FPOpenCashDrawer(Duration);
end;

function TICS_MZ_09.FPPrintHardwareVersion: WordBool;
begin
  Result := DefaultInterface.FPPrintHardwareVersion;
end;

function TICS_MZ_09.FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintLastKsefPacket(Compressed);
end;

function TICS_MZ_09.FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefPacket(PacketID, Compressed);
end;

function TICS_MZ_09.FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                   const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeDiscount(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MZ_09.FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                 const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeMarkup(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MZ_09.FPOnlineModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPOnlineModeSwitch;
end;

function TICS_MZ_09.FPCustomerDisplayModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCustomerDisplayModeSwitch;
end;

function TICS_MZ_09.FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPChangeBaudRate(BaudRateIndex);
end;

function TICS_MZ_09.FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportByLine(TextLine);
end;

function TICS_MZ_09.FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportMultiLine(MultiLineText);
end;

function TICS_MZ_09.FPCloseServiceReport: WordBool;
begin
  Result := DefaultInterface.FPCloseServiceReport;
end;

function TICS_MZ_09.FPEnableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPEnableLogo(ProgPassword);
end;

function TICS_MZ_09.FPDisableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPDisableLogo(ProgPassword);
end;

function TICS_MZ_09.FPSetTaxRates(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetTaxRates(ProgPassword);
end;

function TICS_MZ_09.FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPProgItem(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                        ItemTax, ItemName, ItemCode);
end;

function TICS_MZ_09.FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPProgItemStr(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                           ItemTax, ItemName, ItemCodeStr);
end;

function TICS_MZ_09.FPMakeXReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeXReport(ReportPassword);
end;

function TICS_MZ_09.FPMakeZReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeZReport(ReportPassword);
end;

function TICS_MZ_09.FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; 
                                        LastItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItems(ReportPassword, FirstItemCode, LastItemCode);
end;

function TICS_MZ_09.FPMakeReportOnItemsStr(ReportPassword: Word; 
                                           const FirstItemCodeStr: WideString; 
                                           const LastItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItemsStr(ReportPassword, FirstItemCodeStr, 
                                                    LastItemCodeStr);
end;

function TICS_MZ_09.FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                               LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MZ_09.FPMakePeriodicReportOnDateStr(ReportPassword: Word; 
                                                  const FirstDateStr: WideString; 
                                                  const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDateStr(ReportPassword, FirstDateStr, LastDateStr);
end;

function TICS_MZ_09.FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                                    LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MZ_09.FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                       const FirstDateStr: WideString; 
                                                       const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDateStr(ReportPassword, FirstDateStr, 
                                                                LastDateStr);
end;

function TICS_MZ_09.FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; 
                                                 LastNumber: Word): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnNumber(ReportPassword, FirstNumber, LastNumber);
end;

function TICS_MZ_09.FPCutterModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCutterModeSwitch;
end;

function TICS_MZ_09.FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceipt(SerialCode128B);
end;

function TICS_MZ_09.FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceiptNew(SerialCode128C);
end;

function TICS_MZ_09.FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnItem(SerialEAN13);
end;

function TICS_MZ_09.FPGetPaymentFormNames: WordBool;
begin
  Result := DefaultInterface.FPGetPaymentFormNames;
end;

function TICS_MZ_09.FPGetCurrentStatus: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentStatus;
end;

function TICS_MZ_09.FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDate(CurrentDate);
end;

function TICS_MZ_09.FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTime(CurrentTime);
end;

function TICS_MZ_09.FPGetCashDrawerSum: WordBool;
begin
  Result := DefaultInterface.FPGetCashDrawerSum;
end;

function TICS_MZ_09.FPGetDayReportProperties: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportProperties;
end;

function TICS_MZ_09.FPGetTaxRates: WordBool;
begin
  Result := DefaultInterface.FPGetTaxRates;
end;

function TICS_MZ_09.FPGetItemData(ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPGetItemData(ItemCode);
end;

function TICS_MZ_09.FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPGetItemDataStr(ItemCodeStr);
end;

function TICS_MZ_09.FPGetDayReportData: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportData;
end;

function TICS_MZ_09.FPGetCurrentReceiptData: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentReceiptData;
end;

function TICS_MZ_09.FPGetDayCorrectionsData: WordBool;
begin
  Result := DefaultInterface.FPGetDayCorrectionsData;
end;

function TICS_MZ_09.FPGetDaySumOfAddTaxes: WordBool;
begin
  Result := DefaultInterface.FPGetDaySumOfAddTaxes;
end;

function TICS_MZ_09.FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; 
                                     Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefRange(FirstPacketID, LastPacketID, Compressed);
end;

function TICS_MZ_09.FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; 
                                    AutoCloseReceipt: WordBool; AsFiscalReceipt: WordBool; 
                                    const CardInfo: WideString; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPaymentByCard(PaymentForm, PaymentSum, AutoCloseReceipt, 
                                             AsFiscalReceipt, CardInfo, AuthCode);
end;

function TICS_MZ_09.FPPrintModemStatus: WordBool;
begin
  Result := DefaultInterface.FPPrintModemStatus;
end;

function TICS_MZ_09.FPGetUserPassword(UserID: Byte): WordBool;
begin
  Result := DefaultInterface.FPGetUserPassword(UserID);
end;

function TICS_MZ_09.FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnServiceReport(SerialCode128B);
end;

function TICS_MZ_09.FPPrintQRCode(const SerialQR: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintQRCode(SerialQR);
end;

function TICS_MZ_09.FPSetContrast(Value: Byte): WordBool;
begin
  Result := DefaultInterface.FPSetContrast(Value);
end;

function TICS_MZ_09.FPGetContrast: WordBool;
begin
  Result := DefaultInterface.FPGetContrast;
end;

function TICS_MZ_09.FPGetRevizionID: WordBool;
begin
  Result := DefaultInterface.FPGetRevizionID;
end;

procedure TICS_MZ_11.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{45F5B9D0-D6D5-45EF-86E6-520A07D394A4}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_MZ_11.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_MZ_11;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_MZ_11.GetControlInterface: IICS_MZ_11;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_MZ_11.Get_prGetBitmapIndex(id: Byte): Byte;
begin
  Result := DefaultInterface.prGetBitmapIndex[id];
end;

function TICS_MZ_11.Get_prUDPDeviceSerialNumber(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceSerialNumber[id];
end;

function TICS_MZ_11.Get_prUDPDeviceMAC(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceMAC[id];
end;

function TICS_MZ_11.Get_prUDPDeviceIP(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceIP[id];
end;

function TICS_MZ_11.Get_prUDPDeviceTCPport(id: Byte): Word;
begin
  Result := DefaultInterface.prUDPDeviceTCPport[id];
end;

function TICS_MZ_11.Get_prUDPDeviceTCPportStr(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceTCPportStr[id];
end;

function TICS_MZ_11.FPInitialize: Integer;
begin
  Result := DefaultInterface.FPInitialize;
end;

function TICS_MZ_11.FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpen(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MZ_11.FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                              WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpenStr(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MZ_11.FPClose: WordBool;
begin
  Result := DefaultInterface.FPClose;
end;

function TICS_MZ_11.FPClaimUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPClaimUSBDevice;
end;

function TICS_MZ_11.FPReleaseUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPReleaseUSBDevice;
end;

function TICS_MZ_11.FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
begin
  Result := DefaultInterface.FPTCPConnect(Host, TCP_port);
end;

function TICS_MZ_11.FPTCPClose: WordBool;
begin
  Result := DefaultInterface.FPTCPClose;
end;

function TICS_MZ_11.FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
begin
  Result := DefaultInterface.FPFindUDPDeviceList(SerialNumber);
end;

function TICS_MZ_11.FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetPassword(UserID, OldPassword, NewPassword);
end;

function TICS_MZ_11.FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
begin
  Result := DefaultInterface.FPRegisterCashier(CashierID, Name, Password);
end;

function TICS_MZ_11.FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                 PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                 ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                 ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPRefundItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                          PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MZ_11.FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                    PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                    ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                    const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPRefundItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                             PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                             ItemCodeStr);
end;

function TICS_MZ_11.FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                               PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPSaleItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                        PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MZ_11.FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                  PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSaleItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                           PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                           ItemCodeStr);
end;

function TICS_MZ_11.FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
begin
  Result := DefaultInterface.FPCommentLine(CommentLine, OpenRefundReceipt);
end;

function TICS_MZ_11.FPPrintZeroReceipt: WordBool;
begin
  Result := DefaultInterface.FPPrintZeroReceipt;
end;

function TICS_MZ_11.FPLineFeed: WordBool;
begin
  Result := DefaultInterface.FPLineFeed;
end;

function TICS_MZ_11.FPAnnulReceipt: WordBool;
begin
  Result := DefaultInterface.FPAnnulReceipt;
end;

function TICS_MZ_11.FPCashIn(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashIn(CashSum);
end;

function TICS_MZ_11.FPCashOut(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashOut(CashSum);
end;

function TICS_MZ_11.FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                              AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPayment(PaymentForm, PaymentSum, AutoCloseReceipt, AsFiscalReceipt, 
                                       AuthCode);
end;

function TICS_MZ_11.FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; 
                                       isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvHeaderLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MZ_11.FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; 
                                        isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvTrailerLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MZ_11.FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetLineCustomerDisplay(LineID, TextLine);
end;

function TICS_MZ_11.FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDateStr(CurrentDateStr);
end;

function TICS_MZ_11.FPGetCurrentDate: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentDate;
end;

function TICS_MZ_11.FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTimeStr(CurrentTimeStr);
end;

function TICS_MZ_11.FPGetCurrentTime: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentTime;
end;

function TICS_MZ_11.FPOpenCashDrawer(Duration: Word): WordBool;
begin
  Result := DefaultInterface.FPOpenCashDrawer(Duration);
end;

function TICS_MZ_11.FPPrintHardwareVersion: WordBool;
begin
  Result := DefaultInterface.FPPrintHardwareVersion;
end;

function TICS_MZ_11.FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintLastKsefPacket(Compressed);
end;

function TICS_MZ_11.FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefPacket(PacketID, Compressed);
end;

function TICS_MZ_11.FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                   const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeDiscount(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MZ_11.FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                 const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeMarkup(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MZ_11.FPOnlineModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPOnlineModeSwitch;
end;

function TICS_MZ_11.FPCustomerDisplayModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCustomerDisplayModeSwitch;
end;

function TICS_MZ_11.FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPChangeBaudRate(BaudRateIndex);
end;

function TICS_MZ_11.FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportByLine(TextLine);
end;

function TICS_MZ_11.FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportMultiLine(MultiLineText);
end;

function TICS_MZ_11.FPCloseServiceReport: WordBool;
begin
  Result := DefaultInterface.FPCloseServiceReport;
end;

function TICS_MZ_11.FPEnableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPEnableLogo(ProgPassword);
end;

function TICS_MZ_11.FPDisableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPDisableLogo(ProgPassword);
end;

function TICS_MZ_11.FPSetTaxRates(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetTaxRates(ProgPassword);
end;

function TICS_MZ_11.FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPProgItem(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                        ItemTax, ItemName, ItemCode);
end;

function TICS_MZ_11.FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPProgItemStr(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                           ItemTax, ItemName, ItemCodeStr);
end;

function TICS_MZ_11.FPMakeXReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeXReport(ReportPassword);
end;

function TICS_MZ_11.FPMakeZReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeZReport(ReportPassword);
end;

function TICS_MZ_11.FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; 
                                        LastItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItems(ReportPassword, FirstItemCode, LastItemCode);
end;

function TICS_MZ_11.FPMakeReportOnItemsStr(ReportPassword: Word; 
                                           const FirstItemCodeStr: WideString; 
                                           const LastItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItemsStr(ReportPassword, FirstItemCodeStr, 
                                                    LastItemCodeStr);
end;

function TICS_MZ_11.FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                               LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MZ_11.FPMakePeriodicReportOnDateStr(ReportPassword: Word; 
                                                  const FirstDateStr: WideString; 
                                                  const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDateStr(ReportPassword, FirstDateStr, LastDateStr);
end;

function TICS_MZ_11.FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                                    LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MZ_11.FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                       const FirstDateStr: WideString; 
                                                       const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDateStr(ReportPassword, FirstDateStr, 
                                                                LastDateStr);
end;

function TICS_MZ_11.FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; 
                                                 LastNumber: Word): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnNumber(ReportPassword, FirstNumber, LastNumber);
end;

function TICS_MZ_11.FPCutterModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCutterModeSwitch;
end;

function TICS_MZ_11.FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceipt(SerialCode128B);
end;

function TICS_MZ_11.FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceiptNew(SerialCode128C);
end;

function TICS_MZ_11.FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnItem(SerialEAN13);
end;

function TICS_MZ_11.FPGetPaymentFormNames: WordBool;
begin
  Result := DefaultInterface.FPGetPaymentFormNames;
end;

function TICS_MZ_11.FPGetCurrentStatus: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentStatus;
end;

function TICS_MZ_11.FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDate(CurrentDate);
end;

function TICS_MZ_11.FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTime(CurrentTime);
end;

function TICS_MZ_11.FPGetCashDrawerSum: WordBool;
begin
  Result := DefaultInterface.FPGetCashDrawerSum;
end;

function TICS_MZ_11.FPGetDayReportProperties: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportProperties;
end;

function TICS_MZ_11.FPGetTaxRates: WordBool;
begin
  Result := DefaultInterface.FPGetTaxRates;
end;

function TICS_MZ_11.FPGetItemData(ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPGetItemData(ItemCode);
end;

function TICS_MZ_11.FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPGetItemDataStr(ItemCodeStr);
end;

function TICS_MZ_11.FPGetDayReportData: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportData;
end;

function TICS_MZ_11.FPGetCurrentReceiptData: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentReceiptData;
end;

function TICS_MZ_11.FPGetDayCorrectionsData: WordBool;
begin
  Result := DefaultInterface.FPGetDayCorrectionsData;
end;

function TICS_MZ_11.FPGetDayPacketData: WordBool;
begin
  Result := DefaultInterface.FPGetDayPacketData;
end;

function TICS_MZ_11.FPGetDaySumOfAddTaxes: WordBool;
begin
  Result := DefaultInterface.FPGetDaySumOfAddTaxes;
end;

function TICS_MZ_11.FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; 
                                     Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefRange(FirstPacketID, LastPacketID, Compressed);
end;

function TICS_MZ_11.FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; 
                                    AutoCloseReceipt: WordBool; AsFiscalReceipt: WordBool; 
                                    const CardInfo: WideString; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPaymentByCard(PaymentForm, PaymentSum, AutoCloseReceipt, 
                                             AsFiscalReceipt, CardInfo, AuthCode);
end;

function TICS_MZ_11.FPPrintModemStatus: WordBool;
begin
  Result := DefaultInterface.FPPrintModemStatus;
end;

function TICS_MZ_11.FPGetUserPassword(UserID: Byte): WordBool;
begin
  Result := DefaultInterface.FPGetUserPassword(UserID);
end;

function TICS_MZ_11.FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnServiceReport(SerialCode128B);
end;

function TICS_MZ_11.FPPrintQRCode(const SerialQR: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintQRCode(SerialQR);
end;

function TICS_MZ_11.FPSetContrast(Value: Byte): WordBool;
begin
  Result := DefaultInterface.FPSetContrast(Value);
end;

function TICS_MZ_11.FPGetContrast: WordBool;
begin
  Result := DefaultInterface.FPGetContrast;
end;

function TICS_MZ_11.FPLoadGraphicPattern(const PatternFilePath: WideString): WordBool;
begin
  Result := DefaultInterface.FPLoadGraphicPattern(PatternFilePath);
end;

function TICS_MZ_11.FPClearGraphicPattern: WordBool;
begin
  Result := DefaultInterface.FPClearGraphicPattern;
end;

function TICS_MZ_11.FPUploadStaticGraphicData: WordBool;
begin
  Result := DefaultInterface.FPUploadStaticGraphicData;
end;

function TICS_MZ_11.FPUploadGraphicDoc: WordBool;
begin
  Result := DefaultInterface.FPUploadGraphicDoc;
end;

function TICS_MZ_11.FPPrintGraphicDoc: WordBool;
begin
  Result := DefaultInterface.FPPrintGraphicDoc;
end;

function TICS_MZ_11.FPDeleteGraphicBitmaps: WordBool;
begin
  Result := DefaultInterface.FPDeleteGraphicBitmaps;
end;

function TICS_MZ_11.FPGetGraphicFreeMemorySize: WordBool;
begin
  Result := DefaultInterface.FPGetGraphicFreeMemorySize;
end;

function TICS_MZ_11.FPUploadImagesFromPattern(InvertColors: WordBool): WordBool;
begin
  Result := DefaultInterface.FPUploadImagesFromPattern(InvertColors);
end;

function TICS_MZ_11.FPUploadStringToGraphicDoc(LineIndex: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPUploadStringToGraphicDoc(LineIndex, TextLine);
end;

function TICS_MZ_11.FPUploadBarcodeToGraphicDoc(BarcodeIndex: Byte; const BarcodeData: WideString): WordBool;
begin
  Result := DefaultInterface.FPUploadBarcodeToGraphicDoc(BarcodeIndex, BarcodeData);
end;

function TICS_MZ_11.FPUploadQRCodeToGraphicDoc(QRCodeIndex: Byte; const QRCodeData: WideString): WordBool;
begin
  Result := DefaultInterface.FPUploadQRCodeToGraphicDoc(QRCodeIndex, QRCodeData);
end;

function TICS_MZ_11.FPGetGraphicObjectsList: WordBool;
begin
  Result := DefaultInterface.FPGetGraphicObjectsList;
end;

function TICS_MZ_11.FPDeleteBitmapObject(ObjIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPDeleteBitmapObject(ObjIndex);
end;

function TICS_MZ_11.FPFullEraseGraphicMemory: WordBool;
begin
  Result := DefaultInterface.FPFullEraseGraphicMemory;
end;

function TICS_MZ_11.FPEraseLogo: WordBool;
begin
  Result := DefaultInterface.FPEraseLogo;
end;

function TICS_MZ_11.FPGetRevizionID: WordBool;
begin
  Result := DefaultInterface.FPGetRevizionID;
end;

procedure TICS_MF_09.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{E2428CCC-64C1-4ABE-AED7-FE6D8092854B}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_MF_09.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_MF_09;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_MF_09.GetControlInterface: IICS_MF_09;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_MF_09.Get_prUDPDeviceSerialNumber(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceSerialNumber[id];
end;

function TICS_MF_09.Get_prUDPDeviceMAC(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceMAC[id];
end;

function TICS_MF_09.Get_prUDPDeviceIP(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceIP[id];
end;

function TICS_MF_09.Get_prUDPDeviceTCPport(id: Byte): Word;
begin
  Result := DefaultInterface.prUDPDeviceTCPport[id];
end;

function TICS_MF_09.Get_prUDPDeviceTCPportStr(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceTCPportStr[id];
end;

function TICS_MF_09.FPInitialize: Integer;
begin
  Result := DefaultInterface.FPInitialize;
end;

function TICS_MF_09.FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpen(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MF_09.FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                              WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpenStr(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MF_09.FPClose: WordBool;
begin
  Result := DefaultInterface.FPClose;
end;

function TICS_MF_09.FPClaimUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPClaimUSBDevice;
end;

function TICS_MF_09.FPReleaseUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPReleaseUSBDevice;
end;

function TICS_MF_09.FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
begin
  Result := DefaultInterface.FPTCPConnect(Host, TCP_port);
end;

function TICS_MF_09.FPTCPClose: WordBool;
begin
  Result := DefaultInterface.FPTCPClose;
end;

function TICS_MF_09.FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
begin
  Result := DefaultInterface.FPFindUDPDeviceList(SerialNumber);
end;

function TICS_MF_09.FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetPassword(UserID, OldPassword, NewPassword);
end;

function TICS_MF_09.FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
begin
  Result := DefaultInterface.FPRegisterCashier(CashierID, Name, Password);
end;

function TICS_MF_09.FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                 PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                 ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                 ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPRefundItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                          PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MF_09.FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                    PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                    ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                    const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPRefundItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                             PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                             ItemCodeStr);
end;

function TICS_MF_09.FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                               PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPSaleItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                        PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MF_09.FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                  PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSaleItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                           PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                           ItemCodeStr);
end;

function TICS_MF_09.FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
begin
  Result := DefaultInterface.FPCommentLine(CommentLine, OpenRefundReceipt);
end;

function TICS_MF_09.FPPrintZeroReceipt: WordBool;
begin
  Result := DefaultInterface.FPPrintZeroReceipt;
end;

function TICS_MF_09.FPLineFeed: WordBool;
begin
  Result := DefaultInterface.FPLineFeed;
end;

function TICS_MF_09.FPAnnulReceipt: WordBool;
begin
  Result := DefaultInterface.FPAnnulReceipt;
end;

function TICS_MF_09.FPCashIn(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashIn(CashSum);
end;

function TICS_MF_09.FPCashOut(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashOut(CashSum);
end;

function TICS_MF_09.FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                              AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPayment(PaymentForm, PaymentSum, AutoCloseReceipt, AsFiscalReceipt, 
                                       AuthCode);
end;

function TICS_MF_09.FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; 
                                       isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvHeaderLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MF_09.FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; 
                                        isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvTrailerLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MF_09.FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetLineCustomerDisplay(LineID, TextLine);
end;

function TICS_MF_09.FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDateStr(CurrentDateStr);
end;

function TICS_MF_09.FPGetCurrentDate: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentDate;
end;

function TICS_MF_09.FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTimeStr(CurrentTimeStr);
end;

function TICS_MF_09.FPGetCurrentTime: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentTime;
end;

function TICS_MF_09.FPOpenCashDrawer(Duration: Word): WordBool;
begin
  Result := DefaultInterface.FPOpenCashDrawer(Duration);
end;

function TICS_MF_09.FPPrintHardwareVersion: WordBool;
begin
  Result := DefaultInterface.FPPrintHardwareVersion;
end;

function TICS_MF_09.FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintLastKsefPacket(Compressed);
end;

function TICS_MF_09.FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefPacket(PacketID, Compressed);
end;

function TICS_MF_09.FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                   const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeDiscount(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MF_09.FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                 const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeMarkup(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MF_09.FPOnlineModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPOnlineModeSwitch;
end;

function TICS_MF_09.FPCustomerDisplayModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCustomerDisplayModeSwitch;
end;

function TICS_MF_09.FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPChangeBaudRate(BaudRateIndex);
end;

function TICS_MF_09.FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportByLine(TextLine);
end;

function TICS_MF_09.FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportMultiLine(MultiLineText);
end;

function TICS_MF_09.FPCloseServiceReport: WordBool;
begin
  Result := DefaultInterface.FPCloseServiceReport;
end;

function TICS_MF_09.FPEnableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPEnableLogo(ProgPassword);
end;

function TICS_MF_09.FPDisableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPDisableLogo(ProgPassword);
end;

function TICS_MF_09.FPSetTaxRates(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetTaxRates(ProgPassword);
end;

function TICS_MF_09.FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPProgItem(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                        ItemTax, ItemName, ItemCode);
end;

function TICS_MF_09.FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPProgItemStr(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                           ItemTax, ItemName, ItemCodeStr);
end;

function TICS_MF_09.FPMakeXReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeXReport(ReportPassword);
end;

function TICS_MF_09.FPMakeZReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeZReport(ReportPassword);
end;

function TICS_MF_09.FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; 
                                        LastItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItems(ReportPassword, FirstItemCode, LastItemCode);
end;

function TICS_MF_09.FPMakeReportOnItemsStr(ReportPassword: Word; 
                                           const FirstItemCodeStr: WideString; 
                                           const LastItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItemsStr(ReportPassword, FirstItemCodeStr, 
                                                    LastItemCodeStr);
end;

function TICS_MF_09.FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                               LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MF_09.FPMakePeriodicReportOnDateStr(ReportPassword: Word; 
                                                  const FirstDateStr: WideString; 
                                                  const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDateStr(ReportPassword, FirstDateStr, LastDateStr);
end;

function TICS_MF_09.FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                                    LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MF_09.FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                       const FirstDateStr: WideString; 
                                                       const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDateStr(ReportPassword, FirstDateStr, 
                                                                LastDateStr);
end;

function TICS_MF_09.FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; 
                                                 LastNumber: Word): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnNumber(ReportPassword, FirstNumber, LastNumber);
end;

function TICS_MF_09.FPCutterModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCutterModeSwitch;
end;

function TICS_MF_09.FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceipt(SerialCode128B);
end;

function TICS_MF_09.FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceiptNew(SerialCode128C);
end;

function TICS_MF_09.FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnItem(SerialEAN13);
end;

function TICS_MF_09.FPGetPaymentFormNames: WordBool;
begin
  Result := DefaultInterface.FPGetPaymentFormNames;
end;

function TICS_MF_09.FPGetCurrentStatus: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentStatus;
end;

function TICS_MF_09.FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDate(CurrentDate);
end;

function TICS_MF_09.FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTime(CurrentTime);
end;

function TICS_MF_09.FPGetCashDrawerSum: WordBool;
begin
  Result := DefaultInterface.FPGetCashDrawerSum;
end;

function TICS_MF_09.FPGetDayReportProperties: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportProperties;
end;

function TICS_MF_09.FPGetTaxRates: WordBool;
begin
  Result := DefaultInterface.FPGetTaxRates;
end;

function TICS_MF_09.FPGetItemData(ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPGetItemData(ItemCode);
end;

function TICS_MF_09.FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPGetItemDataStr(ItemCodeStr);
end;

function TICS_MF_09.FPGetDayReportData: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportData;
end;

function TICS_MF_09.FPGetCurrentReceiptData: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentReceiptData;
end;

function TICS_MF_09.FPGetDayCorrectionsData: WordBool;
begin
  Result := DefaultInterface.FPGetDayCorrectionsData;
end;

function TICS_MF_09.FPGetDaySumOfAddTaxes: WordBool;
begin
  Result := DefaultInterface.FPGetDaySumOfAddTaxes;
end;

function TICS_MF_09.FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; 
                                     Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefRange(FirstPacketID, LastPacketID, Compressed);
end;

function TICS_MF_09.FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; 
                                    AutoCloseReceipt: WordBool; AsFiscalReceipt: WordBool; 
                                    const CardInfo: WideString; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPaymentByCard(PaymentForm, PaymentSum, AutoCloseReceipt, 
                                             AsFiscalReceipt, CardInfo, AuthCode);
end;

function TICS_MF_09.FPPrintModemStatus: WordBool;
begin
  Result := DefaultInterface.FPPrintModemStatus;
end;

function TICS_MF_09.FPGetUserPassword(UserID: Byte): WordBool;
begin
  Result := DefaultInterface.FPGetUserPassword(UserID);
end;

function TICS_MF_09.FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnServiceReport(SerialCode128B);
end;

function TICS_MF_09.FPPrintQRCode(const SerialQR: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintQRCode(SerialQR);
end;

function TICS_MF_09.FPSetContrast(Value: Byte): WordBool;
begin
  Result := DefaultInterface.FPSetContrast(Value);
end;

function TICS_MF_09.FPGetContrast: WordBool;
begin
  Result := DefaultInterface.FPGetContrast;
end;

function TICS_MF_09.FPGetRevizionID: WordBool;
begin
  Result := DefaultInterface.FPGetRevizionID;
end;

procedure TICS_MF_11.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{FF5A7BBE-CEE6-48FD-A3D2-6255851B3BFE}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_MF_11.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_MF_11;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_MF_11.GetControlInterface: IICS_MF_11;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_MF_11.Get_prUDPDeviceSerialNumber(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceSerialNumber[id];
end;

function TICS_MF_11.Get_prUDPDeviceMAC(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceMAC[id];
end;

function TICS_MF_11.Get_prUDPDeviceIP(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceIP[id];
end;

function TICS_MF_11.Get_prUDPDeviceTCPport(id: Byte): Word;
begin
  Result := DefaultInterface.prUDPDeviceTCPport[id];
end;

function TICS_MF_11.Get_prUDPDeviceTCPportStr(id: Byte): WideString;
begin
  Result := DefaultInterface.prUDPDeviceTCPportStr[id];
end;

function TICS_MF_11.FPInitialize: Integer;
begin
  Result := DefaultInterface.FPInitialize;
end;

function TICS_MF_11.FPOpen(COMport: Byte; BaudRate: SYSUINT; ReadTimeout: Byte; WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpen(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MF_11.FPOpenStr(const COMport: WideString; BaudRate: SYSUINT; ReadTimeout: Byte; 
                              WriteTimeout: Byte): WordBool;
begin
  Result := DefaultInterface.FPOpenStr(COMport, BaudRate, ReadTimeout, WriteTimeout);
end;

function TICS_MF_11.FPClose: WordBool;
begin
  Result := DefaultInterface.FPClose;
end;

function TICS_MF_11.FPClaimUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPClaimUSBDevice;
end;

function TICS_MF_11.FPReleaseUSBDevice: WordBool;
begin
  Result := DefaultInterface.FPReleaseUSBDevice;
end;

function TICS_MF_11.FPTCPConnect(const Host: WideString; TCP_port: Word): WordBool;
begin
  Result := DefaultInterface.FPTCPConnect(Host, TCP_port);
end;

function TICS_MF_11.FPTCPClose: WordBool;
begin
  Result := DefaultInterface.FPTCPClose;
end;

function TICS_MF_11.FPFindUDPDeviceList(const SerialNumber: WideString): WordBool;
begin
  Result := DefaultInterface.FPFindUDPDeviceList(SerialNumber);
end;

function TICS_MF_11.FPSetPassword(UserID: Byte; OldPassword: Word; NewPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetPassword(UserID, OldPassword, NewPassword);
end;

function TICS_MF_11.FPRegisterCashier(CashierID: Byte; const Name: WideString; Password: Word): WordBool;
begin
  Result := DefaultInterface.FPRegisterCashier(CashierID, Name, Password);
end;

function TICS_MF_11.FPRefundItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                 PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                 ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                 ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPRefundItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                          PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MF_11.FPRefundItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                    PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                    ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                    const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPRefundItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                             PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                             ItemCodeStr);
end;

function TICS_MF_11.FPSaleItem(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                               PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPSaleItem(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                        PrintFromMemory, ItemPrice, ItemTax, ItemName, ItemCode);
end;

function TICS_MF_11.FPSaleItemStr(Qty: SYSINT; QtyPrecision: Byte; PrintEAN13: WordBool; 
                                  PrintSingleQty: WordBool; PrintFromMemory: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSaleItemStr(Qty, QtyPrecision, PrintEAN13, PrintSingleQty, 
                                           PrintFromMemory, ItemPrice, ItemTax, ItemName, 
                                           ItemCodeStr);
end;

function TICS_MF_11.FPCommentLine(const CommentLine: WideString; OpenRefundReceipt: WordBool): WordBool;
begin
  Result := DefaultInterface.FPCommentLine(CommentLine, OpenRefundReceipt);
end;

function TICS_MF_11.FPPrintZeroReceipt: WordBool;
begin
  Result := DefaultInterface.FPPrintZeroReceipt;
end;

function TICS_MF_11.FPLineFeed: WordBool;
begin
  Result := DefaultInterface.FPLineFeed;
end;

function TICS_MF_11.FPAnnulReceipt: WordBool;
begin
  Result := DefaultInterface.FPAnnulReceipt;
end;

function TICS_MF_11.FPCashIn(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashIn(CashSum);
end;

function TICS_MF_11.FPCashOut(CashSum: SYSUINT): WordBool;
begin
  Result := DefaultInterface.FPCashOut(CashSum);
end;

function TICS_MF_11.FPPayment(PaymentForm: Byte; PaymentSum: SYSUINT; AutoCloseReceipt: WordBool; 
                              AsFiscalReceipt: WordBool; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPayment(PaymentForm, PaymentSum, AutoCloseReceipt, AsFiscalReceipt, 
                                       AuthCode);
end;

function TICS_MF_11.FPSetAdvHeaderLine(LineID: Byte; const TextLine: WideString; 
                                       isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvHeaderLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MF_11.FPSetAdvTrailerLine(LineID: Byte; const TextLine: WideString; 
                                        isDoubleWidth: WordBool; isDoubleHeight: WordBool): WordBool;
begin
  Result := DefaultInterface.FPSetAdvTrailerLine(LineID, TextLine, isDoubleWidth, isDoubleHeight);
end;

function TICS_MF_11.FPSetLineCustomerDisplay(LineID: Byte; const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetLineCustomerDisplay(LineID, TextLine);
end;

function TICS_MF_11.FPSetCurrentDateStr(const CurrentDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDateStr(CurrentDateStr);
end;

function TICS_MF_11.FPGetCurrentDate: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentDate;
end;

function TICS_MF_11.FPSetCurrentTimeStr(const CurrentTimeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTimeStr(CurrentTimeStr);
end;

function TICS_MF_11.FPGetCurrentTime: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentTime;
end;

function TICS_MF_11.FPOpenCashDrawer(Duration: Word): WordBool;
begin
  Result := DefaultInterface.FPOpenCashDrawer(Duration);
end;

function TICS_MF_11.FPPrintHardwareVersion: WordBool;
begin
  Result := DefaultInterface.FPPrintHardwareVersion;
end;

function TICS_MF_11.FPPrintLastKsefPacket(Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintLastKsefPacket(Compressed);
end;

function TICS_MF_11.FPPrintKsefPacket(PacketID: SYSUINT; Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefPacket(PacketID, Compressed);
end;

function TICS_MF_11.FPMakeDiscount(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                   const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeDiscount(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MF_11.FPMakeMarkup(isPercentType: WordBool; isForItem: WordBool; Value: SYSUINT; 
                                 const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeMarkup(isPercentType, isForItem, Value, TextLine);
end;

function TICS_MF_11.FPOnlineModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPOnlineModeSwitch;
end;

function TICS_MF_11.FPCustomerDisplayModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCustomerDisplayModeSwitch;
end;

function TICS_MF_11.FPChangeBaudRate(BaudRateIndex: Byte): WordBool;
begin
  Result := DefaultInterface.FPChangeBaudRate(BaudRateIndex);
end;

function TICS_MF_11.FPPrintServiceReportByLine(const TextLine: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportByLine(TextLine);
end;

function TICS_MF_11.FPPrintServiceReportMultiLine(const MultiLineText: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintServiceReportMultiLine(MultiLineText);
end;

function TICS_MF_11.FPCloseServiceReport: WordBool;
begin
  Result := DefaultInterface.FPCloseServiceReport;
end;

function TICS_MF_11.FPEnableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPEnableLogo(ProgPassword);
end;

function TICS_MF_11.FPDisableLogo(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPDisableLogo(ProgPassword);
end;

function TICS_MF_11.FPSetTaxRates(ProgPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPSetTaxRates(ProgPassword);
end;

function TICS_MF_11.FPProgItem(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                               ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                               ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPProgItem(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                        ItemTax, ItemName, ItemCode);
end;

function TICS_MF_11.FPProgItemStr(ProgPassword: Word; QtyPrecision: Byte; isRefundItem: WordBool; 
                                  ItemPrice: SYSINT; ItemTax: Byte; const ItemName: WideString; 
                                  const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPProgItemStr(ProgPassword, QtyPrecision, isRefundItem, ItemPrice, 
                                           ItemTax, ItemName, ItemCodeStr);
end;

function TICS_MF_11.FPMakeXReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeXReport(ReportPassword);
end;

function TICS_MF_11.FPMakeZReport(ReportPassword: Word): WordBool;
begin
  Result := DefaultInterface.FPMakeZReport(ReportPassword);
end;

function TICS_MF_11.FPMakeReportOnItems(ReportPassword: Word; FirstItemCode: Int64; 
                                        LastItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItems(ReportPassword, FirstItemCode, LastItemCode);
end;

function TICS_MF_11.FPMakeReportOnItemsStr(ReportPassword: Word; 
                                           const FirstItemCodeStr: WideString; 
                                           const LastItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakeReportOnItemsStr(ReportPassword, FirstItemCodeStr, 
                                                    LastItemCodeStr);
end;

function TICS_MF_11.FPMakePeriodicReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                               LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MF_11.FPMakePeriodicReportOnDateStr(ReportPassword: Word; 
                                                  const FirstDateStr: WideString; 
                                                  const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnDateStr(ReportPassword, FirstDateStr, LastDateStr);
end;

function TICS_MF_11.FPMakePeriodicShortReportOnDate(ReportPassword: Word; FirstDate: TDateTime; 
                                                    LastDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDate(ReportPassword, FirstDate, LastDate);
end;

function TICS_MF_11.FPMakePeriodicShortReportOnDateStr(ReportPassword: Word; 
                                                       const FirstDateStr: WideString; 
                                                       const LastDateStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicShortReportOnDateStr(ReportPassword, FirstDateStr, 
                                                                LastDateStr);
end;

function TICS_MF_11.FPMakePeriodicReportOnNumber(ReportPassword: Word; FirstNumber: Word; 
                                                 LastNumber: Word): WordBool;
begin
  Result := DefaultInterface.FPMakePeriodicReportOnNumber(ReportPassword, FirstNumber, LastNumber);
end;

function TICS_MF_11.FPCutterModeSwitch: WordBool;
begin
  Result := DefaultInterface.FPCutterModeSwitch;
end;

function TICS_MF_11.FPPrintBarcodeOnReceipt(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceipt(SerialCode128B);
end;

function TICS_MF_11.FPPrintBarcodeOnReceiptNew(const SerialCode128C: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnReceiptNew(SerialCode128C);
end;

function TICS_MF_11.FPPrintBarcodeOnItem(const SerialEAN13: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnItem(SerialEAN13);
end;

function TICS_MF_11.FPGetPaymentFormNames: WordBool;
begin
  Result := DefaultInterface.FPGetPaymentFormNames;
end;

function TICS_MF_11.FPGetCurrentStatus: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentStatus;
end;

function TICS_MF_11.FPSetCurrentDate(CurrentDate: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentDate(CurrentDate);
end;

function TICS_MF_11.FPSetCurrentTime(CurrentTime: TDateTime): WordBool;
begin
  Result := DefaultInterface.FPSetCurrentTime(CurrentTime);
end;

function TICS_MF_11.FPGetCashDrawerSum: WordBool;
begin
  Result := DefaultInterface.FPGetCashDrawerSum;
end;

function TICS_MF_11.FPGetDayReportProperties: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportProperties;
end;

function TICS_MF_11.FPGetTaxRates: WordBool;
begin
  Result := DefaultInterface.FPGetTaxRates;
end;

function TICS_MF_11.FPGetItemData(ItemCode: Int64): WordBool;
begin
  Result := DefaultInterface.FPGetItemData(ItemCode);
end;

function TICS_MF_11.FPGetItemDataStr(const ItemCodeStr: WideString): WordBool;
begin
  Result := DefaultInterface.FPGetItemDataStr(ItemCodeStr);
end;

function TICS_MF_11.FPGetDayReportData: WordBool;
begin
  Result := DefaultInterface.FPGetDayReportData;
end;

function TICS_MF_11.FPGetCurrentReceiptData: WordBool;
begin
  Result := DefaultInterface.FPGetCurrentReceiptData;
end;

function TICS_MF_11.FPGetDayCorrectionsData: WordBool;
begin
  Result := DefaultInterface.FPGetDayCorrectionsData;
end;

function TICS_MF_11.FPGetDayPacketData: WordBool;
begin
  Result := DefaultInterface.FPGetDayPacketData;
end;

function TICS_MF_11.FPGetDaySumOfAddTaxes: WordBool;
begin
  Result := DefaultInterface.FPGetDaySumOfAddTaxes;
end;

function TICS_MF_11.FPPrintKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord; 
                                     Compressed: WordBool): WordBool;
begin
  Result := DefaultInterface.FPPrintKsefRange(FirstPacketID, LastPacketID, Compressed);
end;

function TICS_MF_11.FPPaymentByCard(PaymentForm: Byte; PaymentSum: SYSUINT; 
                                    AutoCloseReceipt: WordBool; AsFiscalReceipt: WordBool; 
                                    const CardInfo: WideString; const AuthCode: WideString): WordBool;
begin
  Result := DefaultInterface.FPPaymentByCard(PaymentForm, PaymentSum, AutoCloseReceipt, 
                                             AsFiscalReceipt, CardInfo, AuthCode);
end;

function TICS_MF_11.FPPrintModemStatus: WordBool;
begin
  Result := DefaultInterface.FPPrintModemStatus;
end;

function TICS_MF_11.FPGetUserPassword(UserID: Byte): WordBool;
begin
  Result := DefaultInterface.FPGetUserPassword(UserID);
end;

function TICS_MF_11.FPPrintBarcodeOnServiceReport(const SerialCode128B: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintBarcodeOnServiceReport(SerialCode128B);
end;

function TICS_MF_11.FPPrintQRCode(const SerialQR: WideString): WordBool;
begin
  Result := DefaultInterface.FPPrintQRCode(SerialQR);
end;

function TICS_MF_11.FPSetContrast(Value: Byte): WordBool;
begin
  Result := DefaultInterface.FPSetContrast(Value);
end;

function TICS_MF_11.FPGetContrast: WordBool;
begin
  Result := DefaultInterface.FPGetContrast;
end;

function TICS_MF_11.FPGetRevizionID: WordBool;
begin
  Result := DefaultInterface.FPGetRevizionID;
end;

procedure TICS_Modem.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{40923073-DFC8-492C-A178-3DC5AEC1BCCE}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_Modem.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_Modem;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_Modem.GetControlInterface: IICS_Modem;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_Modem.ModemInitialize(const portName: WideString): Integer;
begin
  Result := DefaultInterface.ModemInitialize(portName);
end;

function TICS_Modem.ModemAckuirerConnect: WordBool;
begin
  Result := DefaultInterface.ModemAckuirerConnect;
end;

function TICS_Modem.ModemAckuirerUnconditionalConnect: WordBool;
begin
  Result := DefaultInterface.ModemAckuirerUnconditionalConnect;
end;

function TICS_Modem.ModemUpdateStatus: WordBool;
begin
  Result := DefaultInterface.ModemUpdateStatus;
end;

function TICS_Modem.ModemVerifyPacket(PacketID: SYSUINT): WordBool;
begin
  Result := DefaultInterface.ModemVerifyPacket(PacketID);
end;

function TICS_Modem.ModemFindPacket(DayReport: Word; ReceiptNumber: Word; ReceiptType: Byte): WordBool;
begin
  Result := DefaultInterface.ModemFindPacket(DayReport, ReceiptNumber, ReceiptType);
end;

function TICS_Modem.ModemFindPacketByDateTime(FindDateTime: TDateTime; FindForward: WordBool): WordBool;
begin
  Result := DefaultInterface.ModemFindPacketByDateTime(FindDateTime, FindForward);
end;

function TICS_Modem.ModemFindPacketByDateTimeStr(const FindDateTimeStr: WideString; 
                                                 FindForward: WordBool): WordBool;
begin
  Result := DefaultInterface.ModemFindPacketByDateTimeStr(FindDateTimeStr, FindForward);
end;

function TICS_Modem.ModemReadKsefPacket(PacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.ModemReadKsefPacket(PacketID);
end;

function TICS_Modem.ModemReadKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.ModemReadKsefRange(FirstPacketID, LastPacketID);
end;

function TICS_Modem.ModemReadKsefByZReport(ZReport: Word): WordBool;
begin
  Result := DefaultInterface.ModemReadKsefByZReport(ZReport);
end;

function TICS_Modem.ModemGetCurrentTask: WordBool;
begin
  Result := DefaultInterface.ModemGetCurrentTask;
end;

function TICS_Modem.ModemSaveKsefRangeToBin(const Dir: WideString; const FileName: WideString; 
                                            FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.ModemSaveKsefRangeToBin(Dir, FileName, FirstPacketID, LastPacketID);
end;

function TICS_Modem.ModemSaveKsefByZreportToBin(const Dir: WideString; const FileName: WideString; 
                                                ZReport: Word): WordBool;
begin
  Result := DefaultInterface.ModemSaveKsefByZreportToBin(Dir, FileName, ZReport);
end;

procedure TICS_Modem_08.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID:      '{CBAA4B5F-A9C3-4C59-91CD-BEAA5B65E3F8}';
    EventIID:     '';
    EventCount:   0;
    EventDispIDs: nil;
    LicenseKey:   nil (*HR:$00000000*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
end;

procedure TICS_Modem_08.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IICS_Modem;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TICS_Modem_08.GetControlInterface: IICS_Modem;
begin
  CreateControl;
  Result := FIntf;
end;

function TICS_Modem_08.ModemInitialize(const portName: WideString): Integer;
begin
  Result := DefaultInterface.ModemInitialize(portName);
end;

function TICS_Modem_08.ModemAckuirerConnect: WordBool;
begin
  Result := DefaultInterface.ModemAckuirerConnect;
end;

function TICS_Modem_08.ModemAckuirerUnconditionalConnect: WordBool;
begin
  Result := DefaultInterface.ModemAckuirerUnconditionalConnect;
end;

function TICS_Modem_08.ModemUpdateStatus: WordBool;
begin
  Result := DefaultInterface.ModemUpdateStatus;
end;

function TICS_Modem_08.ModemVerifyPacket(PacketID: SYSUINT): WordBool;
begin
  Result := DefaultInterface.ModemVerifyPacket(PacketID);
end;

function TICS_Modem_08.ModemFindPacket(DayReport: Word; ReceiptNumber: Word; ReceiptType: Byte): WordBool;
begin
  Result := DefaultInterface.ModemFindPacket(DayReport, ReceiptNumber, ReceiptType);
end;

function TICS_Modem_08.ModemFindPacketByDateTime(FindDateTime: TDateTime; FindForward: WordBool): WordBool;
begin
  Result := DefaultInterface.ModemFindPacketByDateTime(FindDateTime, FindForward);
end;

function TICS_Modem_08.ModemFindPacketByDateTimeStr(const FindDateTimeStr: WideString; 
                                                    FindForward: WordBool): WordBool;
begin
  Result := DefaultInterface.ModemFindPacketByDateTimeStr(FindDateTimeStr, FindForward);
end;

function TICS_Modem_08.ModemReadKsefPacket(PacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.ModemReadKsefPacket(PacketID);
end;

function TICS_Modem_08.ModemReadKsefRange(FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.ModemReadKsefRange(FirstPacketID, LastPacketID);
end;

function TICS_Modem_08.ModemReadKsefByZReport(ZReport: Word): WordBool;
begin
  Result := DefaultInterface.ModemReadKsefByZReport(ZReport);
end;

function TICS_Modem_08.ModemGetCurrentTask: WordBool;
begin
  Result := DefaultInterface.ModemGetCurrentTask;
end;

function TICS_Modem_08.ModemSaveKsefRangeToBin(const Dir: WideString; const FileName: WideString; 
                                               FirstPacketID: LongWord; LastPacketID: LongWord): WordBool;
begin
  Result := DefaultInterface.ModemSaveKsefRangeToBin(Dir, FileName, FirstPacketID, LastPacketID);
end;

function TICS_Modem_08.ModemSaveKsefByZreportToBin(const Dir: WideString; 
                                                   const FileName: WideString; ZReport: Word): WordBool;
begin
  Result := DefaultInterface.ModemSaveKsefByZreportToBin(Dir, FileName, ZReport);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TICS_EP_08, TICS_EP_09, TICS_EP_11, TICS_MZ_09, 
    TICS_MZ_11, TICS_MF_09, TICS_MF_11, TICS_Modem, TICS_Modem_08]);
end;

end.
