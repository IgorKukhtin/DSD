unit MEDOC_TLB;

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
// File generated on 27.03.2015 22:47:36 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\ProgramData\MedocIS\MedocIS\medoc.dll\1 (1)
// LIBID: {F8D0E662-FB87-40A4-B9F2-D0B7CE5812A4}
// LCID: 0
// Helpfile: 
// HelpString: M.E.DOC - ���������� ��������
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of IZDocument.Trace_ShowMessage changed to 'Type_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  MEDOCMajorVersion = 1;
  MEDOCMinorVersion = 0;

  LIBID_MEDOC: TGUID = '{F8D0E662-FB87-40A4-B9F2-D0B7CE5812A4}';

  IID_IPrimaryDocs: TGUID = '{C24C3707-0DAD-4A66-B734-DDBAB20A1ECA}';
  IID_IZDataset: TGUID = '{034E9C6C-0380-4390-A6F1-773C19A1EA35}';
  IID_IZFields: TGUID = '{D73A0C73-DF7E-46B7-971E-0F3AA448440C}';
  IID_IZField: TGUID = '{E26CD37B-F3D9-426E-9EDC-73E24FAA2E0D}';
  IID_IZDocument: TGUID = '{671BCDE8-8C7E-4E52-A385-B2F5A0511FF4}';
  IID_IZApplication: TGUID = '{294C7E7B-F298-48F0-9328-8E87EC02C2F3}';
  IID_IZTemplate: TGUID = '{BF9432A4-D5DD-4EE0-BC7A-398C755ED50B}';
  IID_IDocSender: TGUID = '{E9B51C9F-ECC1-4D47-B311-A5CFDEF562A4}';
  IID_ISubSysFilter: TGUID = '{C7DB9BBE-58C5-42C7-A3DF-819FAB3E78B2}';
  IID_IDictionary: TGUID = '{6200291F-5956-4366-B2A7-0C474A646AAE}';
  IID_IPacketDoc: TGUID = '{F4FEE5D3-F09C-48D4-A589-95ECB2F3190F}';
  IID_IZDocumentWindow: TGUID = '{315DF0A5-CD01-439B-8BAE-CA0390EEF361}';
  CLASS_ZApplication: TGUID = '{A8C63ADD-5544-42CF-AB08-778C393B6630}';
  IID_IPrimaryDocsCallback: TGUID = '{BD2F3E62-8F2D-4E63-B22C-5E45FDE82FAF}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum tagZStateEnum
type
  tagZStateEnum = TOleEnum;
const
  zsInactive = $00000000;
  zsBrowse = $00000001;
  zsEdit = $00000002;
  zsInsert = $00000003;
  zsSetKey = $00000004;
  zsCalcFields = $00000005;
  zsFilter = $00000006;
  zsNewValue = $00000007;
  zsOldValue = $00000008;
  zsCurValue = $00000009;
  zsBlockRead = $0000000A;
  zsInternalCalc = $0000000B;
  zsOpening = $0000000C;

// Constants for enum tagZDataTypeEnum
type
  tagZDataTypeEnum = TOleEnum;
const
  zdtUnknown = $00000000;
  zdtString = $00000001;
  zdtSmallint = $00000002;
  zdtInteger = $00000003;
  zdtWord = $00000004;
  zdtBoolean = $00000005;
  zdtFloat = $00000006;
  zdtCurrency = $00000007;
  zdtBCD = $00000008;
  zdtDate = $00000009;
  zdtTime = $0000000A;
  zdtDateTime = $0000000B;
  zdtBytes = $0000000C;
  zdtVarBytes = $0000000D;
  zdtAutoInc = $0000000E;
  zdtBlob = $0000000F;
  zdtMemo = $00000010;
  zdtGraphic = $00000011;
  zdtFmtMemo = $00000012;
  zdtParadoxOle = $00000013;
  zdtDBaseOle = $00000014;
  zdtTypedBinary = $00000015;
  zdtCursor = $00000016;
  zdtFixedChar = $00000017;
  zdtWideString = $00000018;
  zdtLargeint = $00000019;
  zdtADT = $0000001A;
  zdtArray = $0000001B;
  zdtReference = $0000001C;
  zdtDataSet = $0000001D;
  zdtOraBlob = $0000001E;
  zdtOraClob = $0000001F;
  zdtVariant = $00000020;
  zdtInterface = $00000021;
  zdtIDispatch = $00000022;
  zdtGuid = $00000023;

// Constants for enum tagZPeriodTypEnum
type
  tagZPeriodTypEnum = TOleEnum;
const
  zptMonth = $00000000;
  zptQuarter = $0000000A;
  zptHalfYear = $00000014;
  zpt9Mnth = $00000019;
  zptYear = $0000001E;
  zptDay = $00000028;
  zptWeek = $00000032;
  zptTenDays = $0000003C;

// Constants for enum tagZCertReqTypes
type
  tagZCertReqTypes = TOleEnum;
const
  ReqTypeStamp = $00000000;
  ReqTypeDir = $00000001;
  ReqTypeBuh = $00000002;
  ReqTypeEmployee = $00000004;
  ReqTypeFiz = $00000005;
  ReqStampEnciph = $00000006;
  ReqDirEnciph = $00000007;
  ReqBuhEnciph = $00000008;
  ReqFizEnciph = $00000009;
  ReqEmpEnciph = $0000000A;

// Constants for enum tagZTraceMesStatEnum
type
  tagZTraceMesStatEnum = TOleEnum;
const
  zmsWarning = $00000000;
  zmsError = $00000001;

// Constants for enum tagZTraceMesTypEnum
type
  tagZTraceMesTypEnum = TOleEnum;
const
  zmtOk = $00000000;
  zmtYesNo = $00000001;

// Constants for enum tagZTraceMesResultEnum
type
  tagZTraceMesResultEnum = TOleEnum;
const
  zmrCancel = $00000000;
  zmrOk = $00000001;
  zmrYes = $00000002;
  zmrNo = $00000003;
  zmrIgnore = $00000004;
  zmrAbort = $00000005;
  zmrRetry = $00000006;

// Constants for enum tagZCmdTypeEnum
type
  tagZCmdTypeEnum = TOleEnum;
const
  zscText = $00000001;
  zscTable = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPrimaryDocs = interface;
  IPrimaryDocsDisp = dispinterface;
  IZDataset = interface;
  IZDatasetDisp = dispinterface;
  IZFields = interface;
  IZFieldsDisp = dispinterface;
  IZField = interface;
  IZFieldDisp = dispinterface;
  IZDocument = interface;
  IZDocumentDisp = dispinterface;
  IZApplication = interface;
  IZApplicationDisp = dispinterface;
  IZTemplate = interface;
  IZTemplateDisp = dispinterface;
  IDocSender = interface;
  IDocSenderDisp = dispinterface;
  ISubSysFilter = interface;
  ISubSysFilterDisp = dispinterface;
  IDictionary = interface;
  IDictionaryDisp = dispinterface;
  IPacketDoc = interface;
  IPacketDocDisp = dispinterface;
  IZDocumentWindow = interface;
  IZDocumentWindowDisp = dispinterface;
  IPrimaryDocsCallback = interface;
  IPrimaryDocsCallbackDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ZApplication = IZApplication;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  ZStateEnum = tagZStateEnum; 
  ZDataTypeEnum = tagZDataTypeEnum; 
  ZPeriodTypEnum = tagZPeriodTypEnum; 
  ZCertReqTypes = tagZCertReqTypes; 
  ZTraceMesStatEnum = tagZTraceMesStatEnum; 
  ZTraceMesTypEnum = tagZTraceMesTypEnum; 
  ZTraceMesResultEnum = tagZTraceMesResultEnum; 
  ZCmdTypeEnum = tagZCmdTypeEnum; 

// *********************************************************************//
// Interface: IPrimaryDocs
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C24C3707-0DAD-4A66-B734-DDBAB20A1ECA}
// *********************************************************************//
  IPrimaryDocs = interface(IDispatch)
    ['{C24C3707-0DAD-4A66-B734-DDBAB20A1ECA}']
    function GetParts: IZDataset; safecall;
    function GetGroups: IZDataset; safecall;
    function GetTemplates(partId: Integer; groupId: Integer): IZDataset; safecall;
    function GetTemplate(partId: Integer; const templateId: WideString): WideString; safecall;
    function GetTemplatesXML: WideString; safecall;
    procedure ProcessDoc(partId: Integer; const templateId: WideString; const docXML: WideString; 
                         docId: Integer; docDate: TDateTime; out result: Integer); safecall;
    procedure SetCallback(cb: OleVariant); safecall;
    procedure StartProcessDoc; safecall;
    procedure EndProcessDoc; safecall;
    procedure ProcessReport(const templateId: WideString; const docId: WideString; 
                            docDate: TDateTime; isParent: Integer; const docXML: WideString); safecall;
    function SeekDocumens(orgId: Integer; const charCode: WideString; const num: WideString; 
                          docDate: TDateTime): IZDataset; safecall;
    function CreateDocument(orgId: Integer; const charCode: WideString; const num: WideString; 
                            docDate: TDateTime): IZDocument; safecall;
    function OpenOrCreateDocument(orgId: Integer; const charCode: WideString; 
                                  const num: WideString; docDate: TDateTime; 
                                  const ExDocID: WideString; reWrite: WordBool): IZDocument; safecall;
    function GetNaklSendStatuses(const ExDocID: WideString; out sendDPAStatus: SYSINT; 
                                 out sendPartnerStatus: SYSINT): WordBool; safecall;
    procedure ProcessDocEx(const EDRPOU: WideString; const DEPT: WideString; partId: Integer; 
                           const templateId: WideString; const docXML: WideString; docId: Integer; 
                           docDate: TDateTime; out result: Integer); safecall;
    function GetSDOCSendStatuses(const ExDocID: WideString; SDoc: SYSINT; 
                                 out sendDPAStatus: SYSINT; out sendPartnerStatus: SYSINT): WordBool; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPrimaryDocsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C24C3707-0DAD-4A66-B734-DDBAB20A1ECA}
// *********************************************************************//
  IPrimaryDocsDisp = dispinterface
    ['{C24C3707-0DAD-4A66-B734-DDBAB20A1ECA}']
    function GetParts: IZDataset; dispid 1;
    function GetGroups: IZDataset; dispid 2;
    function GetTemplates(partId: Integer; groupId: Integer): IZDataset; dispid 3;
    function GetTemplate(partId: Integer; const templateId: WideString): WideString; dispid 4;
    function GetTemplatesXML: WideString; dispid 5;
    procedure ProcessDoc(partId: Integer; const templateId: WideString; const docXML: WideString; 
                         docId: Integer; docDate: TDateTime; out result: Integer); dispid 6;
    procedure SetCallback(cb: OleVariant); dispid 7;
    procedure StartProcessDoc; dispid 8;
    procedure EndProcessDoc; dispid 9;
    procedure ProcessReport(const templateId: WideString; const docId: WideString; 
                            docDate: TDateTime; isParent: Integer; const docXML: WideString); dispid 10;
    function SeekDocumens(orgId: Integer; const charCode: WideString; const num: WideString; 
                          docDate: TDateTime): IZDataset; dispid 11;
    function CreateDocument(orgId: Integer; const charCode: WideString; const num: WideString; 
                            docDate: TDateTime): IZDocument; dispid 12;
    function OpenOrCreateDocument(orgId: Integer; const charCode: WideString; 
                                  const num: WideString; docDate: TDateTime; 
                                  const ExDocID: WideString; reWrite: WordBool): IZDocument; dispid 13;
    function GetNaklSendStatuses(const ExDocID: WideString; out sendDPAStatus: SYSINT; 
                                 out sendPartnerStatus: SYSINT): WordBool; dispid 14;
    procedure ProcessDocEx(const EDRPOU: WideString; const DEPT: WideString; partId: Integer; 
                           const templateId: WideString; const docXML: WideString; docId: Integer; 
                           docDate: TDateTime; out result: Integer); dispid 15;
    function GetSDOCSendStatuses(const ExDocID: WideString; SDoc: SYSINT; 
                                 out sendDPAStatus: SYSINT; out sendPartnerStatus: SYSINT): WordBool; dispid 16;
  end;

// *********************************************************************//
// Interface: IZDataset
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {034E9C6C-0380-4390-A6F1-773C19A1EA35}
// *********************************************************************//
  IZDataset = interface(IDispatch)
    ['{034E9C6C-0380-4390-A6F1-773C19A1EA35}']
    function Get_Parent: IDispatch; safecall;
    procedure Set_Parent(const Value: IDispatch); safecall;
    function Get_GetlpDataSet: Integer; safecall;
    function Get_lpNotify: Integer; safecall;
    procedure Set_lpNotify(Value: Integer); safecall;
    function Get_lpParent: Integer; safecall;
    procedure Set_lpParent(Value: Integer); safecall;
    function Get_Bof: WordBool; safecall;
    function Get_Eof: WordBool; safecall;
    function Get_MaxRecords: Integer; safecall;
    function Get_RecordCount: Integer; safecall;
    function Get_State: ZStateEnum; safecall;
    function Get_RecNo: Integer; safecall;
    procedure Set_RecNo(Value: Integer); safecall;
    function Get_FldVal(Index: OleVariant): OleVariant; safecall;
    procedure Set_FldVal(Index: OleVariant; Value: OleVariant); safecall;
    function Get_FldOrigVal(Index: OleVariant): OleVariant; safecall;
    procedure Set_FldOrigVal(Index: OleVariant; Value: OleVariant); safecall;
    function Get_Fields: IZFields; safecall;
    procedure Append; safecall;
    procedure Cancel; safecall;
    function MoveBy(NumRecords: Integer): Integer; safecall;
    procedure Next; safecall;
    procedure Prior; safecall;
    procedure First; safecall;
    procedure Last; safecall;
    procedure Delete; safecall;
    procedure Post; safecall;
    procedure Edit; safecall;
    function ADORecordSet: IDispatch; safecall;
    function Get_Sort: WideString; safecall;
    procedure Set_Sort(const Value: WideString); safecall;
    function Get_Filter: WideString; safecall;
    procedure Set_Filter(const Value: WideString); safecall;
    procedure Clear(Full: WordBool); safecall;
    function Get_ShowException: WordBool; safecall;
    procedure Set_ShowException(Value: WordBool); safecall;
    procedure SetlpDataSet(Value: Integer; lpFieldList: Integer); safecall;
    function Get_UM: Integer; safecall;
    procedure Set_UM(Value: Integer); safecall;
    function Clone: IZDataset; safecall;
    function Locate(const FldName: WideString; FldValue: OleVariant): WordBool; safecall;
    function Locate2(const FldNames: WideString; FldValue1: OleVariant; FldValue2: OleVariant): WordBool; safecall;
    procedure Remove; safecall;
    property Parent: IDispatch read Get_Parent write Set_Parent;
    property GetlpDataSet: Integer read Get_GetlpDataSet;
    property lpNotify: Integer read Get_lpNotify write Set_lpNotify;
    property lpParent: Integer read Get_lpParent write Set_lpParent;
    property Bof: WordBool read Get_Bof;
    property Eof: WordBool read Get_Eof;
    property MaxRecords: Integer read Get_MaxRecords;
    property RecordCount: Integer read Get_RecordCount;
    property State: ZStateEnum read Get_State;
    property RecNo: Integer read Get_RecNo write Set_RecNo;
    property FldVal[Index: OleVariant]: OleVariant read Get_FldVal write Set_FldVal;
    property FldOrigVal[Index: OleVariant]: OleVariant read Get_FldOrigVal write Set_FldOrigVal;
    property Fields: IZFields read Get_Fields;
    property Sort: WideString read Get_Sort write Set_Sort;
    property Filter: WideString read Get_Filter write Set_Filter;
    property ShowException: WordBool read Get_ShowException write Set_ShowException;
    property UM: Integer read Get_UM write Set_UM;
  end;

// *********************************************************************//
// DispIntf:  IZDatasetDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {034E9C6C-0380-4390-A6F1-773C19A1EA35}
// *********************************************************************//
  IZDatasetDisp = dispinterface
    ['{034E9C6C-0380-4390-A6F1-773C19A1EA35}']
    property Parent: IDispatch dispid 1;
    property GetlpDataSet: Integer readonly dispid 2;
    property lpNotify: Integer dispid 3;
    property lpParent: Integer dispid 4;
    property Bof: WordBool readonly dispid 10;
    property Eof: WordBool readonly dispid 11;
    property MaxRecords: Integer readonly dispid 12;
    property RecordCount: Integer readonly dispid 13;
    property State: ZStateEnum readonly dispid 14;
    property RecNo: Integer dispid 15;
    property FldVal[Index: OleVariant]: OleVariant dispid 16;
    property FldOrigVal[Index: OleVariant]: OleVariant dispid 17;
    property Fields: IZFields readonly dispid 0;
    procedure Append; dispid 20;
    procedure Cancel; dispid 21;
    function MoveBy(NumRecords: Integer): Integer; dispid 22;
    procedure Next; dispid 23;
    procedure Prior; dispid 24;
    procedure First; dispid 25;
    procedure Last; dispid 26;
    procedure Delete; dispid 27;
    procedure Post; dispid 28;
    procedure Edit; dispid 29;
    function ADORecordSet: IDispatch; dispid 30;
    property Sort: WideString dispid 31;
    property Filter: WideString dispid 32;
    procedure Clear(Full: WordBool); dispid 33;
    property ShowException: WordBool dispid 5;
    procedure SetlpDataSet(Value: Integer; lpFieldList: Integer); dispid 7;
    property UM: Integer dispid 8;
    function Clone: IZDataset; dispid 6;
    function Locate(const FldName: WideString; FldValue: OleVariant): WordBool; dispid 9;
    function Locate2(const FldNames: WideString; FldValue1: OleVariant; FldValue2: OleVariant): WordBool; dispid 18;
    procedure Remove; dispid 19;
  end;

// *********************************************************************//
// Interface: IZFields
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D73A0C73-DF7E-46B7-971E-0F3AA448440C}
// *********************************************************************//
  IZFields = interface(IDispatch)
    ['{D73A0C73-DF7E-46B7-971E-0F3AA448440C}']
    function Get_Parent: IZDataset; safecall;
    procedure Set_Parent(const Value: IZDataset); safecall;
    function Get_GetlpDataSet: Integer; safecall;
    function Get_Count: Integer; safecall;
    function Get_Item(Index: OleVariant): IZField; safecall;
    procedure SetlpDataSet(Value: Integer; lpFieldList: Integer); safecall;
    property Parent: IZDataset read Get_Parent write Set_Parent;
    property GetlpDataSet: Integer read Get_GetlpDataSet;
    property Count: Integer read Get_Count;
    property Item[Index: OleVariant]: IZField read Get_Item; default;
  end;

// *********************************************************************//
// DispIntf:  IZFieldsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D73A0C73-DF7E-46B7-971E-0F3AA448440C}
// *********************************************************************//
  IZFieldsDisp = dispinterface
    ['{D73A0C73-DF7E-46B7-971E-0F3AA448440C}']
    property Parent: IZDataset dispid 1;
    property GetlpDataSet: Integer readonly dispid 2;
    property Count: Integer readonly dispid 10;
    property Item[Index: OleVariant]: IZField readonly dispid 0; default;
    procedure SetlpDataSet(Value: Integer; lpFieldList: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: IZField
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E26CD37B-F3D9-426E-9EDC-73E24FAA2E0D}
// *********************************************************************//
  IZField = interface(IDispatch)
    ['{E26CD37B-F3D9-426E-9EDC-73E24FAA2E0D}']
    function Get_Parent: IZFields; safecall;
    procedure Set_Parent(const Value: IZFields); safecall;
    function Get_GetlpDataSet: Integer; safecall;
    procedure Set_lpName(const Param1: WideString); safecall;
    procedure Set_lpNumber(Param1: Integer); safecall;
    function Get_Number: Integer; safecall;
    function Get_Name: WideString; safecall;
    function Get_ActualSize: Integer; safecall;
    function Get_DefinedSize: Integer; safecall;
    function Get_type_: ZDataTypeEnum; safecall;
    function Get_Precision: Integer; safecall;
    function Get_NumericScale: Integer; safecall;
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(Value: OleVariant); safecall;
    procedure SetlpDataSet(Value: Integer; lpFieldList: Integer); safecall;
    property Parent: IZFields read Get_Parent write Set_Parent;
    property GetlpDataSet: Integer read Get_GetlpDataSet;
    property lpName: WideString write Set_lpName;
    property lpNumber: Integer write Set_lpNumber;
    property Number: Integer read Get_Number;
    property Name: WideString read Get_Name;
    property ActualSize: Integer read Get_ActualSize;
    property DefinedSize: Integer read Get_DefinedSize;
    property type_: ZDataTypeEnum read Get_type_;
    property Precision: Integer read Get_Precision;
    property NumericScale: Integer read Get_NumericScale;
    property Value: OleVariant read Get_Value write Set_Value;
  end;

// *********************************************************************//
// DispIntf:  IZFieldDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E26CD37B-F3D9-426E-9EDC-73E24FAA2E0D}
// *********************************************************************//
  IZFieldDisp = dispinterface
    ['{E26CD37B-F3D9-426E-9EDC-73E24FAA2E0D}']
    property Parent: IZFields dispid 1;
    property GetlpDataSet: Integer readonly dispid 2;
    property lpName: WideString writeonly dispid 3;
    property lpNumber: Integer writeonly dispid 4;
    property Number: Integer readonly dispid 10;
    property Name: WideString readonly dispid 11;
    property ActualSize: Integer readonly dispid 12;
    property DefinedSize: Integer readonly dispid 13;
    property type_: ZDataTypeEnum readonly dispid 14;
    property Precision: Integer readonly dispid 15;
    property NumericScale: Integer readonly dispid 16;
    property Value: OleVariant dispid 0;
    procedure SetlpDataSet(Value: Integer; lpFieldList: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: IZDocument
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {671BCDE8-8C7E-4E52-A385-B2F5A0511FF4}
// *********************************************************************//
  IZDocument = interface(IDispatch)
    ['{671BCDE8-8C7E-4E52-A385-B2F5A0511FF4}']
    function Get_Parent: IZApplication; safecall;
    procedure Set_Parent(const Value: IZApplication); safecall;
    function Get_lpDocument: Integer; safecall;
    procedure Set_lpDocument(Value: Integer); safecall;
    function Get_CloseOnRelease: WordBool; safecall;
    procedure Set_CloseOnRelease(Value: WordBool); safecall;
    function Get_TmplCode: WideString; safecall;
    function Get_PerType: ZPeriodTypEnum; safecall;
    function Get_PerDate: TDateTime; safecall;
    function Get_Description: WideString; safecall;
    function Get_CrtDateTime: OleVariant; safecall;
    function Get_ModDateTime: OleVariant; safecall;
    function CreateView: IZDocumentWindow; safecall;
    procedure Save(Mode: Integer); safecall;
    procedure Close; safecall;
    function DataSets(RCName: OleVariant; RCTblType: Integer): IZDataset; safecall;
    procedure Refresh; safecall;
    function Get_Card: IZDataset; safecall;
    function Get_CardCode: Integer; safecall;
    procedure Trace_AddMessage(const Mes: WideString; const FieldName: WideString); safecall;
    function Trace_ShowMessages: WordBool; safecall;
    function Trace_ShowMessage(const Message: WideString; const Title: WideString; 
                               Stat: ZTraceMesStatEnum; Type_: ZTraceMesTypEnum): ZTraceMesResultEnum; safecall;
    function Get_Trace_MessageCount: Integer; safecall;
    function SumByList(const Name1: WideString; const Name2: WideString; const Name3: WideString; 
                       const Name4: WideString; const Name5: WideString; const Name6: WideString; 
                       const Name7: WideString; const Name8: WideString; const Name9: WideString; 
                       const Name10: WideString; const Name11: WideString; 
                       const Name12: WideString; const Name13: WideString; 
                       const Name14: WideString; const Name15: WideString; const Name16: WideString): Double; safecall;
    function SumByRange(const NamePart: WideString; FromIndex: Integer; ToIndex: Integer; 
                        EmptyIgnore: WordBool): Double; safecall;
    function SubByList(const Name1: WideString; const Name2: WideString; const Name3: WideString; 
                       const Name4: WideString; const Name5: WideString; const Name6: WideString; 
                       const Name7: WideString; const Name8: WideString; const Name9: WideString; 
                       const Name10: WideString; const Name11: WideString; 
                       const Name12: WideString; const Name13: WideString; 
                       const Name14: WideString; const Name15: WideString; const Name16: WideString): Double; safecall;
    function SubByRange(const NamePart: WideString; FromIndex: Integer; ToIndex: Integer; 
                        EmptyIgnore: WordBool): Double; safecall;
    function CalcPeriodDate(ParDate: TDateTime; PerType: ZPeriodTypEnum; PerModifier: Integer): TDateTime; safecall;
    function SimpleODBCDataSet(const ODBCSource: WideString; CommandType: ZCmdTypeEnum; 
                               const CommandText: WideString): IZDataset; safecall;
    function Get_GblVal(const Name: WideString): OleVariant; safecall;
    procedure Set_GblVal(const Name: WideString; Value: OleVariant); safecall;
    function CalcLastPeriodDate(ParDate: TDateTime; PerType: ZPeriodTypEnum; PerModifier: Integer): TDateTime; safecall;
    function RoundVal(Value: OleVariant; Digit: SYSINT): OleVariant; safecall;
    function Get_ShowException: WordBool; safecall;
    procedure Set_ShowException(Value: WordBool); safecall;
    function Get_Specif: Integer; safecall;
    procedure Set_Specif(Value: Integer); safecall;
    function SprVal(Spr: OleVariant; num: OleVariant): OleVariant; safecall;
    function Get_UM: SYSINT; safecall;
    function CheckByList(const Str: WideString; const Name1: WideString; const Name2: WideString; 
                         const Name3: WideString; const Name4: WideString; const Name5: WideString; 
                         const Name6: WideString; const Name7: WideString; const Name8: WideString; 
                         const Name9: WideString; const Name10: WideString; 
                         const Name11: WideString; const Name12: WideString; 
                         const Name13: WideString; const Name14: WideString; 
                         const Name15: WideString; const Name16: WideString): WordBool; safecall;
    function CheckByRange(const Str: WideString; const NamePart: WideString; FromIndex: Integer; 
                          ToIndex: Integer): WordBool; safecall;
    function Get_NPerDate: TDateTime; safecall;
    function GetPrevDocumentCD: Integer; safecall;
    procedure ExecScript(const Name: WideString); safecall;
    procedure UpdateSysFields; safecall;
    function CheckDuplicate: Integer; safecall;
    procedure Trace_InfoMessage(const Mes: WideString; const FieldName: WideString); safecall;
    procedure Trace_WarnMessage(const Mes: WideString; const FieldName: WideString); safecall;
    procedure Trace_ErrorMessage(const Mes: WideString; const FieldName: WideString); safecall;
    function GetP04TabByINN(const INN: WideString; TabNum: Integer): IZDataset; safecall;
    procedure DisableScripts; safecall;
    procedure EnableScripts; safecall;
    procedure Recalc; safecall;
    function Get_IDParent: Integer; safecall;
    procedure Set_IDParent(Value: Integer); safecall;
    property Parent: IZApplication read Get_Parent write Set_Parent;
    property lpDocument: Integer read Get_lpDocument write Set_lpDocument;
    property CloseOnRelease: WordBool read Get_CloseOnRelease write Set_CloseOnRelease;
    property TmplCode: WideString read Get_TmplCode;
    property PerType: ZPeriodTypEnum read Get_PerType;
    property PerDate: TDateTime read Get_PerDate;
    property Description: WideString read Get_Description;
    property CrtDateTime: OleVariant read Get_CrtDateTime;
    property ModDateTime: OleVariant read Get_ModDateTime;
    property Card: IZDataset read Get_Card;
    property CardCode: Integer read Get_CardCode;
    property Trace_MessageCount: Integer read Get_Trace_MessageCount;
    property GblVal[const Name: WideString]: OleVariant read Get_GblVal write Set_GblVal;
    property ShowException: WordBool read Get_ShowException write Set_ShowException;
    property Specif: Integer read Get_Specif write Set_Specif;
    property UM: SYSINT read Get_UM;
    property NPerDate: TDateTime read Get_NPerDate;
    property IDParent: Integer read Get_IDParent write Set_IDParent;
  end;

// *********************************************************************//
// DispIntf:  IZDocumentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {671BCDE8-8C7E-4E52-A385-B2F5A0511FF4}
// *********************************************************************//
  IZDocumentDisp = dispinterface
    ['{671BCDE8-8C7E-4E52-A385-B2F5A0511FF4}']
    property Parent: IZApplication dispid 1;
    property lpDocument: Integer dispid 2;
    property CloseOnRelease: WordBool dispid 3;
    property TmplCode: WideString readonly dispid 10;
    property PerType: ZPeriodTypEnum readonly dispid 11;
    property PerDate: TDateTime readonly dispid 12;
    property Description: WideString readonly dispid 13;
    property CrtDateTime: OleVariant readonly dispid 14;
    property ModDateTime: OleVariant readonly dispid 15;
    function CreateView: IZDocumentWindow; dispid 20;
    procedure Save(Mode: Integer); dispid 21;
    procedure Close; dispid 22;
    function DataSets(RCName: OleVariant; RCTblType: Integer): IZDataset; dispid 23;
    procedure Refresh; dispid 24;
    property Card: IZDataset readonly dispid 25;
    property CardCode: Integer readonly dispid 26;
    procedure Trace_AddMessage(const Mes: WideString; const FieldName: WideString); dispid 50;
    function Trace_ShowMessages: WordBool; dispid 51;
    function Trace_ShowMessage(const Message: WideString; const Title: WideString; 
                               Stat: ZTraceMesStatEnum; Type_: ZTraceMesTypEnum): ZTraceMesResultEnum; dispid 52;
    property Trace_MessageCount: Integer readonly dispid 53;
    function SumByList(const Name1: WideString; const Name2: WideString; const Name3: WideString; 
                       const Name4: WideString; const Name5: WideString; const Name6: WideString; 
                       const Name7: WideString; const Name8: WideString; const Name9: WideString; 
                       const Name10: WideString; const Name11: WideString; 
                       const Name12: WideString; const Name13: WideString; 
                       const Name14: WideString; const Name15: WideString; const Name16: WideString): Double; dispid 60;
    function SumByRange(const NamePart: WideString; FromIndex: Integer; ToIndex: Integer; 
                        EmptyIgnore: WordBool): Double; dispid 61;
    function SubByList(const Name1: WideString; const Name2: WideString; const Name3: WideString; 
                       const Name4: WideString; const Name5: WideString; const Name6: WideString; 
                       const Name7: WideString; const Name8: WideString; const Name9: WideString; 
                       const Name10: WideString; const Name11: WideString; 
                       const Name12: WideString; const Name13: WideString; 
                       const Name14: WideString; const Name15: WideString; const Name16: WideString): Double; dispid 62;
    function SubByRange(const NamePart: WideString; FromIndex: Integer; ToIndex: Integer; 
                        EmptyIgnore: WordBool): Double; dispid 63;
    function CalcPeriodDate(ParDate: TDateTime; PerType: ZPeriodTypEnum; PerModifier: Integer): TDateTime; dispid 64;
    function SimpleODBCDataSet(const ODBCSource: WideString; CommandType: ZCmdTypeEnum; 
                               const CommandText: WideString): IZDataset; dispid 65;
    property GblVal[const Name: WideString]: OleVariant dispid 66;
    function CalcLastPeriodDate(ParDate: TDateTime; PerType: ZPeriodTypEnum; PerModifier: Integer): TDateTime; dispid 4;
    function RoundVal(Value: OleVariant; Digit: SYSINT): OleVariant; dispid 5;
    property ShowException: WordBool dispid 6;
    property Specif: Integer dispid 7;
    function SprVal(Spr: OleVariant; num: OleVariant): OleVariant; dispid 67;
    property UM: SYSINT readonly dispid 8;
    function CheckByList(const Str: WideString; const Name1: WideString; const Name2: WideString; 
                         const Name3: WideString; const Name4: WideString; const Name5: WideString; 
                         const Name6: WideString; const Name7: WideString; const Name8: WideString; 
                         const Name9: WideString; const Name10: WideString; 
                         const Name11: WideString; const Name12: WideString; 
                         const Name13: WideString; const Name14: WideString; 
                         const Name15: WideString; const Name16: WideString): WordBool; dispid 68;
    function CheckByRange(const Str: WideString; const NamePart: WideString; FromIndex: Integer; 
                          ToIndex: Integer): WordBool; dispid 69;
    property NPerDate: TDateTime readonly dispid 9;
    function GetPrevDocumentCD: Integer; dispid 16;
    procedure ExecScript(const Name: WideString); dispid 17;
    procedure UpdateSysFields; dispid 18;
    function CheckDuplicate: Integer; dispid 19;
    procedure Trace_InfoMessage(const Mes: WideString; const FieldName: WideString); dispid 27;
    procedure Trace_WarnMessage(const Mes: WideString; const FieldName: WideString); dispid 28;
    procedure Trace_ErrorMessage(const Mes: WideString; const FieldName: WideString); dispid 29;
    function GetP04TabByINN(const INN: WideString; TabNum: Integer): IZDataset; dispid 30;
    procedure DisableScripts; dispid 31;
    procedure EnableScripts; dispid 32;
    procedure Recalc; dispid 33;
    property IDParent: Integer dispid 34;
  end;

// *********************************************************************//
// Interface: IZApplication
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {294C7E7B-F298-48F0-9328-8E87EC02C2F3}
// *********************************************************************//
  IZApplication = interface(IDispatch)
    ['{294C7E7B-F298-48F0-9328-8E87EC02C2F3}']
    function Get_MessageEnable: WordBool; safecall;
    procedure Set_MessageEnable(Value: WordBool); safecall;
    function Get_Name: WideString; safecall;
    function Get_VersionLo: Integer; safecall;
    function Get_VersionHi: Integer; safecall;
    procedure Hide; safecall;
    procedure Show; safecall;
    function OpenTemplate(const LocateString: WideString): IZTemplate; safecall;
    function OpenDocument(const LocateString: WideString): IZDocument; safecall;
    function CreateDocument(const LocateString: WideString): IZDocument; safecall;
    function CreateEmptyDocument: IZDocument; safecall;
    function OpenDocumentByParam(const TmplName: WideString; PeriodTyp: ZPeriodTypEnum; 
                                 PeriodDate: TDateTime; CrtDocDate: TDateTime): IZDocument; safecall;
    function CreateDocumentByParam(const TmplName: WideString; PeriodTyp: ZPeriodTypEnum; 
                                   CrtDocDate: TDateTime; PartName: OleVariant): IZDocument; safecall;
    function OpenDocumentByCode(Code: Integer; BasDisable: WordBool): IZDocument; safecall;
    function DocumentsDataSet(const CondString: WideString; Refresh: WordBool): IZDataset; safecall;
    function GetDocumentCDByPeriod(const TmplName: WideString; PeriodTyp: ZPeriodTypEnum; 
                                   PeriodDate: TDateTime; PeriodModifier: Integer): Integer; safecall;
    function PhisPers: IZDataset; safecall;
    function GetLsDateBegin(iTnParam: OleVariant): TDateTime; safecall;
    function GetSumVo(iTn: Integer; iMonth: Integer; iYear: Integer; iType: Integer; iCode: Integer): Single; safecall;
    function GetSumMinZp(dtDate: TDateTime): Single; safecall;
    function GetSumPMin(dtDate: TDateTime): Single; safecall;
    function GetChargePens(dtDate: TDateTime): Single; safecall;
    function GetChargeSocIns(dtDate: TDateTime): Single; safecall;
    function GetChargeEmploy(dtDate: TDateTime): Single; safecall;
    function GetChargeFatality(dtDate: TDateTime): Single; safecall;
    function GetLastDay(iMonthParam: OleVariant; iYearParam: OleVariant): TDateTime; safecall;
    function GetSumVoAll(iTnParam: OleVariant; iVoParam: OleVariant; iMonthParam: OleVariant; 
                         iYearParam: OleVariant): Single; safecall;
    function GetInvalid(iTnParam: OleVariant): SYSINT; safecall;
    function GetFirstDay(iMonthParam: OleVariant; iYearParam: OleVariant): TDateTime; safecall;
    function GetHolidays(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; safecall;
    function GetCalDays(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; safecall;
    function GetWorkDays(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; safecall;
    function GetSumVoPeriod(iTnParam: OleVariant; iVoParam: OleVariant; 
                            dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime; 
                            iRsumCalcParam: OleVariant): Single; safecall;
    function IsFirstWorkDay(iTnParam: OleVariant): SYSINT; safecall;
    function GetVo(iTnParam: OleVariant; iMonthParam: OleVariant; iYearParam: OleVariant; 
                   iZrpSplataParam: OleVariant; iRsumCalcParam: OleVariant): Single; safecall;
    function GetCountVo(iTnParam: OleVariant; iYearParam: OleVariant; iZrpSplataParam: OleVariant): SYSINT; safecall;
    function GetWorkDaysTn(iTnParam: OleVariant; dtDateBeginParam: TDateTime; 
                           dtDateEndParam: TDateTime): SYSINT; safecall;
    function OpenQuery(const TextQuery: WideString; NumRecordSet: OleVariant): IZDataset; safecall;
    function GetFullMonth(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; safecall;
    procedure UpdateQuery(const TextQuery: WideString); safecall;
    function GetLsPrivilage(iTnParam: OleVariant; iMonthParam: OleVariant; iYearParam: OleVariant): SYSINT; safecall;
    function GetSumVoMonth(iTnParam: OleVariant; iMonthParam: OleVariant; iYearParam: OleVariant): IZDataset; safecall;
    function DocDataSetParam(const charCode: WideString; PerType: OleVariant; PerDate: OleVariant): IZDataset; safecall;
    function GetDocsFldVal(const CondString: WideString; const FieldName: WideString): OleVariant; safecall;
    function OLECntShow(const Caption: WideString; Visible: WordBool; IsModal: WordBool; 
                        BorderStyle: Integer; Top: Integer; Left: Integer; Width: Integer; 
                        Height: Integer): OleVariant; safecall;
    procedure HalcOpen(const FileFullPath: WideString); safecall;
    procedure HalcNewRow; safecall;
    procedure HalcClose; safecall;
    procedure Set_HalcFldVal(const FieldName: WideString; Param2: OleVariant); safecall;
    procedure HalcCreateDbf(const FileFullPath: WideString; FieldParamArray: OleVariant); safecall;
    function DocsParamDataSet(const CondString: WideString): IZDataset; safecall;
    function Get_CurrentDirectory: WideString; safecall;
    function ChooseFirm(const EDRPOU: WideString; const DEPT: WideString): Integer; safecall;
    function Login(const UserName: WideString; const Password: WideString): Integer; safecall;
    function ConvStrToDbl(const Str: WideString): Double; safecall;
    function Get_TmplDirectory: WideString; safecall;
    function GetSprValue(const TableName: WideString; const KeyName: WideString; 
                         const KeyValue: WideString; const ValueName: WideString): OleVariant; safecall;
    function DateToStr(Date: TDateTime): WideString; safecall;
    function GetZvitObject(const objName: WideString): IDispatch; safecall;
    function GetPrimaryDocs: IPrimaryDocs; safecall;
    function CreateNNRequest: IZDocument; safecall;
    function SendNNRequest(const zdoc: IZDocument): Integer; safecall;
    function BuildNNStatusDS: IZDataset; safecall;
    function FillNNStatusDS(const filterDs: IZDataset): IZDataset; safecall;
    function CreateGovQryByCharCode(const charCode: WideString): IZDocument; safecall;
    function SeekOrg(const EDRPOU: WideString; const DEPT: WideString): Integer; safecall;
    function OpenOrCreateByExDocID(const TmplName: WideString; PeriodType: ZPeriodTypEnum; 
                                   CrtDocDate: TDateTime; PartName: OleVariant; 
                                   const ExDocID: WideString; reWrite: WordBool): IZDocument; safecall;
    function GetSendSTTByExDocID(const ExDocID: WideString): SYSINT; safecall;
    function GetDocSender: IDocSender; safecall;
    function GetCurrEdrpou: WideString; safecall;
    function GetCurrDept: WideString; safecall;
    procedure MoveToTrash(const ExDocID: WideString); safecall;
    function GetInTrashStatus(const ExDocID: WideString): WordBool; safecall;
    procedure RefreshRstDoc; safecall;
    function GetDocStatus(const ExDocID: WideString): SYSINT; safecall;
    function GetPrgVersion: Integer; safecall;
    function CreateNewRnn(const TmplName: WideString; const ExDocID: WideString; 
                          PeriodTyp: ZPeriodTypEnum; CrtDocDate: TDateTime): IZDocument; safecall;
    function GetRnnPortion(PeriodTyp: ZPeriodTypEnum; PerDate: TDateTime; RstType: SYSINT): SYSINT; safecall;
    function RunModule(const SubSystem: WideString): ISubSysFilter; safecall;
    function GetDictionary: IDictionary; safecall;
    function SelectFirm(const EDRPOU: WideString; const DEPT: WideString): WordBool; safecall;
    function CreateOrOpenCertReq(reqType: ZCertReqTypes; isUSC: WordBool; const ExDocID: WideString): IZDocument; safecall;
    procedure RefreshCertReq(const ExDocID: WideString); safecall;
    procedure ShowDocument(const ExDocID: WideString); safecall;
    function GetDocCrtDate(const ExDocID: WideString): TDateTime; safecall;
    function GetPacketDoc: IPacketDoc; safecall;
    property MessageEnable: WordBool read Get_MessageEnable write Set_MessageEnable;
    property Name: WideString read Get_Name;
    property VersionLo: Integer read Get_VersionLo;
    property VersionHi: Integer read Get_VersionHi;
    property HalcFldVal[const FieldName: WideString]: OleVariant write Set_HalcFldVal;
    property CurrentDirectory: WideString read Get_CurrentDirectory;
    property TmplDirectory: WideString read Get_TmplDirectory;
  end;

// *********************************************************************//
// DispIntf:  IZApplicationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {294C7E7B-F298-48F0-9328-8E87EC02C2F3}
// *********************************************************************//
  IZApplicationDisp = dispinterface
    ['{294C7E7B-F298-48F0-9328-8E87EC02C2F3}']
    property MessageEnable: WordBool dispid 5;
    property Name: WideString readonly dispid 10;
    property VersionLo: Integer readonly dispid 11;
    property VersionHi: Integer readonly dispid 12;
    procedure Hide; dispid 19;
    procedure Show; dispid 20;
    function OpenTemplate(const LocateString: WideString): IZTemplate; dispid 21;
    function OpenDocument(const LocateString: WideString): IZDocument; dispid 22;
    function CreateDocument(const LocateString: WideString): IZDocument; dispid 23;
    function CreateEmptyDocument: IZDocument; dispid 24;
    function OpenDocumentByParam(const TmplName: WideString; PeriodTyp: ZPeriodTypEnum; 
                                 PeriodDate: TDateTime; CrtDocDate: TDateTime): IZDocument; dispid 25;
    function CreateDocumentByParam(const TmplName: WideString; PeriodTyp: ZPeriodTypEnum; 
                                   CrtDocDate: TDateTime; PartName: OleVariant): IZDocument; dispid 26;
    function OpenDocumentByCode(Code: Integer; BasDisable: WordBool): IZDocument; dispid 27;
    function DocumentsDataSet(const CondString: WideString; Refresh: WordBool): IZDataset; dispid 50;
    function GetDocumentCDByPeriod(const TmplName: WideString; PeriodTyp: ZPeriodTypEnum; 
                                   PeriodDate: TDateTime; PeriodModifier: Integer): Integer; dispid 51;
    function PhisPers: IZDataset; dispid 3;
    function GetLsDateBegin(iTnParam: OleVariant): TDateTime; dispid 1;
    function GetSumVo(iTn: Integer; iMonth: Integer; iYear: Integer; iType: Integer; iCode: Integer): Single; dispid 2;
    function GetSumMinZp(dtDate: TDateTime): Single; dispid 4;
    function GetSumPMin(dtDate: TDateTime): Single; dispid 6;
    function GetChargePens(dtDate: TDateTime): Single; dispid 7;
    function GetChargeSocIns(dtDate: TDateTime): Single; dispid 8;
    function GetChargeEmploy(dtDate: TDateTime): Single; dispid 9;
    function GetChargeFatality(dtDate: TDateTime): Single; dispid 13;
    function GetLastDay(iMonthParam: OleVariant; iYearParam: OleVariant): TDateTime; dispid 14;
    function GetSumVoAll(iTnParam: OleVariant; iVoParam: OleVariant; iMonthParam: OleVariant; 
                         iYearParam: OleVariant): Single; dispid 15;
    function GetInvalid(iTnParam: OleVariant): SYSINT; dispid 16;
    function GetFirstDay(iMonthParam: OleVariant; iYearParam: OleVariant): TDateTime; dispid 17;
    function GetHolidays(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; dispid 18;
    function GetCalDays(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; dispid 28;
    function GetWorkDays(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; dispid 29;
    function GetSumVoPeriod(iTnParam: OleVariant; iVoParam: OleVariant; 
                            dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime; 
                            iRsumCalcParam: OleVariant): Single; dispid 30;
    function IsFirstWorkDay(iTnParam: OleVariant): SYSINT; dispid 31;
    function GetVo(iTnParam: OleVariant; iMonthParam: OleVariant; iYearParam: OleVariant; 
                   iZrpSplataParam: OleVariant; iRsumCalcParam: OleVariant): Single; dispid 32;
    function GetCountVo(iTnParam: OleVariant; iYearParam: OleVariant; iZrpSplataParam: OleVariant): SYSINT; dispid 33;
    function GetWorkDaysTn(iTnParam: OleVariant; dtDateBeginParam: TDateTime; 
                           dtDateEndParam: TDateTime): SYSINT; dispid 34;
    function OpenQuery(const TextQuery: WideString; NumRecordSet: OleVariant): IZDataset; dispid 35;
    function GetFullMonth(dtDateBeginParam: TDateTime; dtDateEndParam: TDateTime): SYSINT; dispid 37;
    procedure UpdateQuery(const TextQuery: WideString); dispid 36;
    function GetLsPrivilage(iTnParam: OleVariant; iMonthParam: OleVariant; iYearParam: OleVariant): SYSINT; dispid 38;
    function GetSumVoMonth(iTnParam: OleVariant; iMonthParam: OleVariant; iYearParam: OleVariant): IZDataset; dispid 39;
    function DocDataSetParam(const charCode: WideString; PerType: OleVariant; PerDate: OleVariant): IZDataset; dispid 40;
    function GetDocsFldVal(const CondString: WideString; const FieldName: WideString): OleVariant; dispid 41;
    function OLECntShow(const Caption: WideString; Visible: WordBool; IsModal: WordBool; 
                        BorderStyle: Integer; Top: Integer; Left: Integer; Width: Integer; 
                        Height: Integer): OleVariant; dispid 42;
    procedure HalcOpen(const FileFullPath: WideString); dispid 43;
    procedure HalcNewRow; dispid 44;
    procedure HalcClose; dispid 45;
    property HalcFldVal[const FieldName: WideString]: OleVariant writeonly dispid 48;
    procedure HalcCreateDbf(const FileFullPath: WideString; FieldParamArray: OleVariant); dispid 46;
    function DocsParamDataSet(const CondString: WideString): IZDataset; dispid 47;
    property CurrentDirectory: WideString readonly dispid 49;
    function ChooseFirm(const EDRPOU: WideString; const DEPT: WideString): Integer; dispid 52;
    function Login(const UserName: WideString; const Password: WideString): Integer; dispid 53;
    function ConvStrToDbl(const Str: WideString): Double; dispid 54;
    property TmplDirectory: WideString readonly dispid 55;
    function GetSprValue(const TableName: WideString; const KeyName: WideString; 
                         const KeyValue: WideString; const ValueName: WideString): OleVariant; dispid 56;
    function DateToStr(Date: TDateTime): WideString; dispid 57;
    function GetZvitObject(const objName: WideString): IDispatch; dispid 59;
    function GetPrimaryDocs: IPrimaryDocs; dispid 4096;
    function CreateNNRequest: IZDocument; dispid 4098;
    function SendNNRequest(const zdoc: IZDocument): Integer; dispid 4099;
    function BuildNNStatusDS: IZDataset; dispid 4100;
    function FillNNStatusDS(const filterDs: IZDataset): IZDataset; dispid 4101;
    function CreateGovQryByCharCode(const charCode: WideString): IZDocument; dispid 4102;
    function SeekOrg(const EDRPOU: WideString; const DEPT: WideString): Integer; dispid 4103;
    function OpenOrCreateByExDocID(const TmplName: WideString; PeriodType: ZPeriodTypEnum; 
                                   CrtDocDate: TDateTime; PartName: OleVariant; 
                                   const ExDocID: WideString; reWrite: WordBool): IZDocument; dispid 4104;
    function GetSendSTTByExDocID(const ExDocID: WideString): SYSINT; dispid 4105;
    function GetDocSender: IDocSender; dispid 4106;
    function GetCurrEdrpou: WideString; dispid 4107;
    function GetCurrDept: WideString; dispid 4108;
    procedure MoveToTrash(const ExDocID: WideString); dispid 4109;
    function GetInTrashStatus(const ExDocID: WideString): WordBool; dispid 4110;
    procedure RefreshRstDoc; dispid 4111;
    function GetDocStatus(const ExDocID: WideString): SYSINT; dispid 4112;
    function GetPrgVersion: Integer; dispid 4113;
    function CreateNewRnn(const TmplName: WideString; const ExDocID: WideString; 
                          PeriodTyp: ZPeriodTypEnum; CrtDocDate: TDateTime): IZDocument; dispid 4114;
    function GetRnnPortion(PeriodTyp: ZPeriodTypEnum; PerDate: TDateTime; RstType: SYSINT): SYSINT; dispid 4115;
    function RunModule(const SubSystem: WideString): ISubSysFilter; dispid 4116;
    function GetDictionary: IDictionary; dispid 4117;
    function SelectFirm(const EDRPOU: WideString; const DEPT: WideString): WordBool; dispid 4118;
    function CreateOrOpenCertReq(reqType: ZCertReqTypes; isUSC: WordBool; const ExDocID: WideString): IZDocument; dispid 4119;
    procedure RefreshCertReq(const ExDocID: WideString); dispid 4120;
    procedure ShowDocument(const ExDocID: WideString); dispid 4121;
    function GetDocCrtDate(const ExDocID: WideString): TDateTime; dispid 4122;
    function GetPacketDoc: IPacketDoc; dispid 4123;
  end;

// *********************************************************************//
// Interface: IZTemplate
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF9432A4-D5DD-4EE0-BC7A-398C755ED50B}
// *********************************************************************//
  IZTemplate = interface(IDispatch)
    ['{BF9432A4-D5DD-4EE0-BC7A-398C755ED50B}']
    function Get_Parent: IZApplication; safecall;
    procedure Set_Parent(const Value: IZApplication); safecall;
    function Get_lpTemplate: Integer; safecall;
    procedure Set_lpTemplate(Value: Integer); safecall;
    function Get_CloseOnRelease: WordBool; safecall;
    procedure Set_CloseOnRelease(Value: WordBool); safecall;
    procedure Close; safecall;
    property Parent: IZApplication read Get_Parent write Set_Parent;
    property lpTemplate: Integer read Get_lpTemplate write Set_lpTemplate;
    property CloseOnRelease: WordBool read Get_CloseOnRelease write Set_CloseOnRelease;
  end;

// *********************************************************************//
// DispIntf:  IZTemplateDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BF9432A4-D5DD-4EE0-BC7A-398C755ED50B}
// *********************************************************************//
  IZTemplateDisp = dispinterface
    ['{BF9432A4-D5DD-4EE0-BC7A-398C755ED50B}']
    property Parent: IZApplication dispid 1;
    property lpTemplate: Integer dispid 2;
    property CloseOnRelease: WordBool dispid 3;
    procedure Close; dispid 20;
  end;

// *********************************************************************//
// Interface: IDocSender
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E9B51C9F-ECC1-4D47-B311-A5CFDEF562A4}
// *********************************************************************//
  IDocSender = interface(IDispatch)
    ['{E9B51C9F-ECC1-4D47-B311-A5CFDEF562A4}']
    procedure Add(const DocGUID: WideString); safecall;
    procedure Clear; safecall;
    function Send(toGovAdr: WordBool): SYSINT; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDocSenderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E9B51C9F-ECC1-4D47-B311-A5CFDEF562A4}
// *********************************************************************//
  IDocSenderDisp = dispinterface
    ['{E9B51C9F-ECC1-4D47-B311-A5CFDEF562A4}']
    procedure Add(const DocGUID: WideString); dispid 1;
    procedure Clear; dispid 2;
    function Send(toGovAdr: WordBool): SYSINT; dispid 3;
  end;

// *********************************************************************//
// Interface: ISubSysFilter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C7DB9BBE-58C5-42C7-A3DF-819FAB3E78B2}
// *********************************************************************//
  ISubSysFilter = interface(IDispatch)
    ['{C7DB9BBE-58C5-42C7-A3DF-819FAB3E78B2}']
    function GetFilter: IZDataset; safecall;
    procedure ApplyFilter; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISubSysFilterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C7DB9BBE-58C5-42C7-A3DF-819FAB3E78B2}
// *********************************************************************//
  ISubSysFilterDisp = dispinterface
    ['{C7DB9BBE-58C5-42C7-A3DF-819FAB3E78B2}']
    function GetFilter: IZDataset; dispid 1;
    procedure ApplyFilter; dispid 2;
  end;

// *********************************************************************//
// Interface: IDictionary
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6200291F-5956-4366-B2A7-0C474A646AAE}
// *********************************************************************//
  IDictionary = interface(IDispatch)
    ['{6200291F-5956-4366-B2A7-0C474A646AAE}']
    function Open(const DictName: WideString): IZDataset; safecall;
    function IsReadOnly: WordBool; safecall;
    function Save: WordBool; safecall;
    procedure Clear(const DictName: WideString); safecall;
    function GetGenID(const DictName: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDictionaryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6200291F-5956-4366-B2A7-0C474A646AAE}
// *********************************************************************//
  IDictionaryDisp = dispinterface
    ['{6200291F-5956-4366-B2A7-0C474A646AAE}']
    function Open(const DictName: WideString): IZDataset; dispid 1;
    function IsReadOnly: WordBool; dispid 2;
    function Save: WordBool; dispid 3;
    procedure Clear(const DictName: WideString); dispid 4;
    function GetGenID(const DictName: WideString): Integer; dispid 5;
  end;

// *********************************************************************//
// Interface: IPacketDoc
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4FEE5D3-F09C-48D4-A589-95ECB2F3190F}
// *********************************************************************//
  IPacketDoc = interface(IDispatch)
    ['{F4FEE5D3-F09C-48D4-A589-95ECB2F3190F}']
    function Add(const parentExDocID: WideString; const childExDocID: WideString): SYSINT; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPacketDocDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4FEE5D3-F09C-48D4-A589-95ECB2F3190F}
// *********************************************************************//
  IPacketDocDisp = dispinterface
    ['{F4FEE5D3-F09C-48D4-A589-95ECB2F3190F}']
    function Add(const parentExDocID: WideString; const childExDocID: WideString): SYSINT; dispid 1;
  end;

// *********************************************************************//
// Interface: IZDocumentWindow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {315DF0A5-CD01-439B-8BAE-CA0390EEF361}
// *********************************************************************//
  IZDocumentWindow = interface(IDispatch)
    ['{315DF0A5-CD01-439B-8BAE-CA0390EEF361}']
    function Get_Parent: IZDocument; safecall;
    procedure Set_Parent(const Value: IZDocument); safecall;
    function Get_lpForm: Integer; safecall;
    procedure Set_lpForm(Value: Integer); safecall;
    function Get_CloseOnRelease: WordBool; safecall;
    procedure Set_CloseOnRelease(Value: WordBool); safecall;
    function Get_CloseOnWinClose: WordBool; safecall;
    procedure Set_CloseOnWinClose(Value: WordBool); safecall;
    function Get_Handle: Integer; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(Value: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(Value: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(Value: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(Value: Integer); safecall;
    procedure Hide; safecall;
    procedure Show(Modal: WordBool); safecall;
    procedure Close; safecall;
    property Parent: IZDocument read Get_Parent write Set_Parent;
    property lpForm: Integer read Get_lpForm write Set_lpForm;
    property CloseOnRelease: WordBool read Get_CloseOnRelease write Set_CloseOnRelease;
    property CloseOnWinClose: WordBool read Get_CloseOnWinClose write Set_CloseOnWinClose;
    property Handle: Integer read Get_Handle;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
  end;

// *********************************************************************//
// DispIntf:  IZDocumentWindowDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {315DF0A5-CD01-439B-8BAE-CA0390EEF361}
// *********************************************************************//
  IZDocumentWindowDisp = dispinterface
    ['{315DF0A5-CD01-439B-8BAE-CA0390EEF361}']
    property Parent: IZDocument dispid 1;
    property lpForm: Integer dispid 2;
    property CloseOnRelease: WordBool dispid 3;
    property CloseOnWinClose: WordBool dispid 4;
    property Handle: Integer readonly dispid 5;
    property Caption: WideString dispid 10;
    property Left: Integer dispid 11;
    property Top: Integer dispid 12;
    property Width: Integer dispid 13;
    property Height: Integer dispid 14;
    procedure Hide; dispid 19;
    procedure Show(Modal: WordBool); dispid 20;
    procedure Close; dispid 21;
  end;

// *********************************************************************//
// Interface: IPrimaryDocsCallback
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BD2F3E62-8F2D-4E63-B22C-5E45FDE82FAF}
// *********************************************************************//
  IPrimaryDocsCallback = interface(IDispatch)
    ['{BD2F3E62-8F2D-4E63-B22C-5E45FDE82FAF}']
    procedure StartImport(partId: Integer; const templateId: WideString); safecall;
    procedure ImportDoc(partId: Integer; const templateId: WideString; const docXML: WideString; 
                        out result: Integer; var docId: Integer); safecall;
    procedure EndImport; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPrimaryDocsCallbackDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BD2F3E62-8F2D-4E63-B22C-5E45FDE82FAF}
// *********************************************************************//
  IPrimaryDocsCallbackDisp = dispinterface
    ['{BD2F3E62-8F2D-4E63-B22C-5E45FDE82FAF}']
    procedure StartImport(partId: Integer; const templateId: WideString); dispid 1;
    procedure ImportDoc(partId: Integer; const templateId: WideString; const docXML: WideString; 
                        out result: Integer; var docId: Integer); dispid 2;
    procedure EndImport; dispid 3;
  end;

// *********************************************************************//
// The Class CoZApplication provides a Create and CreateRemote method to          
// create instances of the default interface IZApplication exposed by              
// the CoClass ZApplication. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoZApplication = class
    class function Create: IZApplication;
    class function CreateRemote(const MachineName: string): IZApplication;
  end;

implementation

uses System.Win.ComObj;

class function CoZApplication.Create: IZApplication;
begin
  Result := CreateComObject(CLASS_ZApplication) as IZApplication;
end;

class function CoZApplication.CreateRemote(const MachineName: string): IZApplication;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ZApplication) as IZApplication;
end;

end.
