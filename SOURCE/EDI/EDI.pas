unit EDI;

{$I ..\dsdVer.inc}

interface

uses DBClient, Classes, DB, dsdAction, IdFTP, ComDocXML, dsdCommon, dsdDb, OrderXML, UtilConst
     {$IFDEF DELPHI103RIO}, System.JSON, Actions {$ELSE} , Data.DBXJSON {$ENDIF};

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar, ediComDocSave,
    ediReceipt, ediReturnComDoc, ediDeclarReturn, ediOrdrsp, ediInvoice, ediError,
    ediRecadv, ediTTN, ediComDocSign, ediComDocSendSign);
  TSignType = (stDeclar, stComDoc);

  TConnectionParams = class(TPersistent)
  private
    FPassword: TdsdParam;
    FHost: TdsdParam;
    FUser: TdsdParam;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Host: TdsdParam read FHost write FHost;
    property User: TdsdParam read FUser write FUser;
    property Password: TdsdParam read FPassword write FPassword;
  end;

  // ��������� ������ � EDI. ���� ��� ������� � ����
  // �� �� ������ ���, �������, �� �����
  TEDI = class(TdsdComponent)
  private
    FIdFTP: TIdFTP;
    FConnectionParams: TConnectionParams;
    FInsertEDIEvents: TdsdStoredProc;
    FInsertEDIEventsDoc: TdsdStoredProc;
    FExistsOrder: TdsdStoredProc;
    FUpdateDeclarAmount: TdsdStoredProc;
    FInsertEDIFile: TdsdStoredProc;
    FUpdateEDIErrorState: TdsdStoredProc;
    FUpdateDeclarFileName: TdsdStoredProc;
    FGetSaveFilePath: TdsdStoredProc;
    FUpdateEDIVchasnoEDI: TdsdStoredProc;
    ComSigner: OleVariant;
    FSendToFTP: boolean;
    FDirectory: string;
    FDirectoryError: string;
    FisEDISaveLocal: boolean;
    procedure InsertUpdateOrder(ORDER: OrderXML.IXMLORDERType;
      spHeader, spList: TdsdStoredProc; lFileName : String);
    function fIsExistsOrder(lFileName : String) : Boolean;
    function InsertUpdateComDoc(�������������������
      : IXML�������������������Type; spHeader, spList: TdsdStoredProc): integer;
    procedure FTPSetConnection;
    procedure InitializeComSigner(DebugMode: boolean; UserSign, UserSeal, UserKey : string);
    procedure SignFile(FileName: string; SignType: TSignType; DebugMode: boolean; UserSign, UserSeal, UserKey, NameExite, NameFiscal : string );

    procedure PutFileToFTP(FileName: string; Directory: string);
    procedure PutStreamToFTP(Stream: TStream; FileName: string;
      Directory: string);
    procedure SetDirectory(const Value: string);
    function ConvertEDIDate(ADateTime: string): TDateTime;
    // VchasnoEDI
    procedure InsertUpdateOrderVchasnoEDI(ORDER: OrderXML.IXMLORDERType;
      spHeader, spList: TdsdStoredProc; lFileName, ADealId : String);
    procedure UpdateOrderDESADVSaveVchasnoEDI(AEDIId: Integer; isError : Boolean);
    procedure UpdateOrderORDERSPSaveVchasnoEDI(AEDIId: Integer; isError : Boolean);
    procedure UpdateOrderDELNOTSaveVchasnoEDI(AEDIId: Integer; DocumentId, VchasnoId: String; isError : Boolean);
    procedure UpdateOrderDELNOTSignVchasnoEDI(AEDIId: Integer; isError : Boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure INVOICESave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure ORDRSPSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure IFTMINSave(HeaderDataSet, ItemsDataSet: TDataSet); // ���������� � ��������������� IFTMIN
    procedure COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet;
      Directory: String; DebugMode: boolean);
    // ���������
    procedure ReceiptLoad(spProtocol: TdsdStoredProc; Directory: String);
    procedure RecadvLoad(spHeader: TdsdStoredProc; Directory: String);

    procedure DeclarSave(HeaderDataSet, ItemsDataSet: TDataSet; StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarSave_start(HeaderDataSet, ItemsDataSet: TDataSet; StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarSave_start01042016(HeaderDataSet, ItemsDataSet: TDataSet; StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarSave_start01032017(HeaderDataSet, ItemsDataSet: TDataSet; StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);

    procedure DeclarReturnSave(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarReturnSave_start(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarReturnSave_start01042016(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarReturnSave_start01032017(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);

    //
    procedure ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String;
      StartDate, EndDate: TDateTime);
    // �����
    procedure OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String;
      StartDate, EndDate: TDateTime);
    procedure ReturnSave(MovementDataSet: TDataSet;
      spFileInfo, spFileBlob: TdsdStoredProc; Directory: string; DebugMode: boolean);
    procedure ErrorLoad(Directory: string);
    // ����� VchasnoEDI
    procedure OrderLoadVchasnoEDI(AOrder, AFileName, ADealId : string; spHeader, spList: TdsdStoredProc);
    // �������� ����������� ��� ������������
    procedure DESADVSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
    // �������� ������������� ������
    procedure ORDERSPSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
    // �������� ���������� ���������
    procedure ComDocSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
  published
    property ConnectionParams: TConnectionParams read FConnectionParams
      write FConnectionParams;
    property SendToFTP: boolean read FSendToFTP write FSendToFTP default true;
    property Directory: string read FDirectory write SetDirectory;
  end;

  TEDIAction = class(TdsdCustomAction)
  private
    FspHeader: TdsdStoredProc;
    FspList: TdsdStoredProc;
    FEDIDocType: TEDIDocType;
    FEDI: TEDI;
    FDirectory: string;
    FHeaderDataSet: TDataSet;
    FListDataSet: TDataSet;
    FEndDate: TdsdParam;
    FStartDate: TdsdParam;
  protected
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    // ����� �� ����� Caption, Hint � �.�., ��� ��� ������ ������������ � MultiAction
    property StartDateParam: TdsdParam read FStartDate write FStartDate;
    property EndDateParam: TdsdParam read FEndDate write FEndDate;
    property EDI: TEDI read FEDI write FEDI;
    property EDIDocType: TEDIDocType read FEDIDocType write FEDIDocType;
    property spHeader: TdsdStoredProc read FspHeader write FspHeader;
    property spList: TdsdStoredProc read FspList write FspList;
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    property ListDataSet: TDataSet read FListDataSet write FListDataSet;
    property Directory: string read FDirectory write FDirectory;
  end;

  TdsdVchasnoEDIAction = class(TdsdCustomAction)
  private

    FHostParam: TdsdParam;
    FTokenParam: TdsdParam;
    FDocTypeParam: TdsdParam;
    FDocStatusParam: TdsdParam;
    FOrderParam: TdsdParam;
    FDocumentIdParam: TdsdParam;
    FVchasnoIdParam: TdsdParam;
    FDateFromParam: TdsdParam;
    FDateToParam: TdsdParam;
    FDefaultFilePathParam: TdsdParam;
    FDefaultFileNameParam: TdsdParam;
    FShowErrorMessagesParam: TdsdParam;
    FErrorTextParam: TdsdParam;

    FResultParam: TdsdParam;
    FFileNameParam: TdsdParam;

    FKeyFileNameParam: TdsdParam;
    FKeyUserNameParam: TdsdParam;

    FPairParams: TOwnedCollection;
    FHeaderDataSet: TDataSet;
    FListDataSet: TDataSet;

    FEDIDocType: TEDIDocType;
    FEDI: TEDI;

    FspHeader: TdsdStoredProc;
    FspList: TdsdStoredProc;


  protected
    function LocalExecute: Boolean; override;
    function GetVchasnoEDI(ATypeExchange : Integer; ADataSet: TClientDataSet = Nil): Boolean;
    function POSTVchasnoEDI(ATypeExchange : Integer; AStream: TMemoryStream): Boolean;
    function POSTSignVchasnoEDI: Boolean;
    function SignData(UserSign : String): Boolean;
    function OrderLoad : Boolean;
    function OrdrspSave : Boolean;
    function DESADVSave : Boolean;
    function ComDocSave : Boolean;
    function DoSignComDoc: Boolean;
    function DoSendSignComDoc: Boolean;
    procedure ShowMessages(AMessage: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Host: TdsdParam read FHostParam write FHostParam;
    property Token: TdsdParam read FTokenParam write FTokenParam;
//    property DocType: TdsdParam read FDocTypeParam write FDocTypeParam;
//    property DocStatusParam: TdsdParam read FDocStatusParam write FDocStatusParam;
//    property Order: TdsdParam read FOrderParam write FOrderParam;
    property DateFrom: TdsdParam read FDateFromParam write FDateFromParam;
    property DateTo: TdsdParam read FDateToParam write FDateToParam;
//    property DefaultFilePath: TdsdParam read FDefaultFilePathParam write FDefaultFilePathParam;
//    property DefaultFileName: TdsdParam read FDefaultFileNameParam write FDefaultFileNameParam;

    property EDI: TEDI read FEDI write FEDI;
    property EDIDocType: TEDIDocType read FEDIDocType write FEDIDocType default ediOrder;

    property KeyFileName: TdsdParam read FKeyFileNameParam write FKeyFileNameParam;
    property KeyUserName: TdsdParam read FKeyUserNameParam write FKeyUserNameParam;
    property ShowErrorMessages: TdsdParam read FShowErrorMessagesParam write FShowErrorMessagesParam;
    property ErrorText: TdsdParam read FErrorTextParam write FErrorTextParam;
//    property Result: TdsdParam read FResultParam write FResultParam;
//    property FileName: TdsdParam read FFileNameParam write FFileNameParam;
    // ���������� ������� Json ��� ������������ DataSet
//    property PairParams: TOwnedCollection read FPairParams write FPairParams;
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    property ListDataSet: TDataSet read FListDataSet write FListDataSet;
    property spHeader: TdsdStoredProc read FspHeader write FspHeader;
    property spList: TdsdStoredProc read FspList write FspList;

  end;


  TEDINActionsType = (edinSendETTN, edinSignConsignor, edinSignCarrier, edinSendSingETTN, edinLoadInvoiceNR);

  TdsdEDINAction = class(TdsdCustomAction)
  private
    FHostParam: TdsdParam;
    FLoginParam: TdsdParam;
    FPasswordParam: TdsdParam;
    FTokenParam: TdsdParam;
    FResultParam: TdsdParam;
    FKeyFileNameParam: TdsdParam;
    FKeyUserNameParam: TdsdParam;
    FErrorParam: TdsdParam;

    FGLNParam: TdsdParam;
    FGLN_SenderParam: TdsdParam;

    FHeaderDataSet: TDataSet;
    FListDataSet: TDataSet;

    FUpdateUuid: TdsdStoredProc;
    FUpdateSign: TdsdStoredProc;
    FUpdateKATOTTG: TdsdStoredProc;
    FUpdateError: TdsdStoredProc;

    FEDINActions : TEDINActionsType;

  protected
    function GetToken: Boolean;
    function SendETTN(AGLN, AUuId, AXML : String): Boolean;
    function GetDocETTN(AGLN, AUuId : String): Boolean;
    function GetIdentifiers(AGLN, AQuery : String): Boolean;
    function SignDcuETTN(AGLN, AUuId : String): Boolean;

    function LoadInvoiceNR�ontent(AUUID : String; var AjsonItem: TJSONObject): Boolean;
    function LoadInvoiceNRHeader(AOffset, ACount: Integer; var AJsonArray: TJSONArray): Boolean;
    function LoadInvoiceNR: Boolean;

    procedure UAECMREDI(var AXML: String);
    function SignData(UserSign : String): Boolean;

    function DoSendETTN: Boolean;
    function DoSignDcuETTN: Boolean;
    function DoSendSingETTN: Boolean;
    function DoLoadInvoiceNR: Boolean;
    function LocalExecute: Boolean; override;
    function ShowError(AError : String): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Caption;
    property Hint;
    property ShortCut;
    property ImageIndex;
    property SecondaryShortCuts;
    property QuestionBeforeExecute;
    property InfoAfterExecute;
    property Host: TdsdParam read FHostParam write FHostParam;
    property Login: TdsdParam read FLoginParam write FLoginParam;
    property Password: TdsdParam read FPasswordParam write FPasswordParam;
    property Token: TdsdParam read FTokenParam write FTokenParam;
    property Result: TdsdParam read FResultParam write FResultParam;
    property Error: TdsdParam read FErrorParam write FErrorParam;

    property GLN: TdsdParam read FGLNParam write FGLNParam;
    property GLN_Sender: TdsdParam read FGLN_SenderParam write FGLN_SenderParam;

    property KeyFileName: TdsdParam read FKeyFileNameParam write FKeyFileNameParam;
    property KeyUserName: TdsdParam read FKeyUserNameParam write FKeyUserNameParam;

    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    property ListDataSet: TDataSet read FListDataSet write FListDataSet;

    property UpdateUuid: TdsdStoredProc read FUpdateUuid write FUpdateUuid;
    property UpdateSign: TdsdStoredProc read FUpdateSign write FUpdateSign;
    property UpdateKATOTTG: TdsdStoredProc read FUpdateKATOTTG write FUpdateKATOTTG;
    property UpdateError: TdsdStoredProc read FUpdateError write FUpdateError;

    property EDINActions : TEDINActionsType read FEDINActions write FEDINActions default edinSendETTN;

  end;


procedure Register;
function lpStrToDateTime(DateTimeString: string): TDateTime;

const
  caType = 'UA1';  // �� ������������, ���� �� ������������ ������-���������
	euKeyTypeAccountant = 1;  // ��� ������� ����������
	euKeyTypeDirector   = 2;     // ��� ������� ���������
	euKeyTypeDigitalStamp = 3;   // ��� ������� ������
  okError = '�������� ������';

implementation

uses Windows, VCL.ActnList, DesadvXML, SysUtils, Dialogs, SimpleGauge,
  Variants, UtilConvert, ComObj, DeclarXML, InvoiceXML, DateUtils,
  FormStorage, UnilWin, OrdrspXML, StrUtils, StatusXML, RecadvXML,
  DesadvFozzXML, OrderSpFozzXML, IftminFozzXML, Registry, System.IniFiles,
  DOCUMENTINVOICE_TN_XML, DOCUMENTINVOICE_PRN_XML, UAECMRXML,
  Vcl.Forms, System.IOUtils, System.RegularExpressions, ZLib, Math,
  IdHTTP, IdSSLOpenSSL, IdURI, IdCTypes, IdSSLOpenSSLHeaders,
  IdMultipartFormData, Xml.XMLDoc, Soap.EncdDecd, EUSignCP, EUSignCPOwnUI,
  DOCUMENTINVOICE_DRN_XML;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIAction], TEDIAction);
  RegisterActions('EDI', [TdsdVchasnoEDIAction], TdsdVchasnoEDIAction);
  RegisterActions('EDI', [TdsdEDINAction], TdsdEDINAction);
end;

{ TEDI }
function PAD0(Src: string; Lg: integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := '0' + Result;
end;

procedure TEDI.COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet;
  Directory: String; DebugMode: boolean);
var
  �������������������: IXML�������������������Type;
  i: integer;
  XMLFileName, P7SFileName: string;
begin
  // ������� xml ����
  ������������������� := New�������������������;
  �������������������.���������.�������������� :=
    HeaderDataSet.FieldByName('InvNumber').asString;
  �������������������.���������.������������ := '��������� ��������';
  �������������������.���������.���������������� := '006';
  �������������������.���������.������������� := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  �������������������.���������.��������������� :=
    HeaderDataSet.FieldByName('InvNumberOrder').asString;

  with �������������������.�������.Add do
  begin
    ����������������� := '���������';
    �������� := '��������';
    ���������������� := HeaderDataSet.FieldByName('JuridicalName_From')
      .asString;
    �������������� := HeaderDataSet.FieldByName('OKPO_From').asString;
    ��� := HeaderDataSet.FieldByName('INN_From').asString;
    if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
    then GLN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  end;
  with �������������������.�������.Add do
  begin
    ����������������� := '��������';
    �������� := '��������';
    ���������������� := HeaderDataSet.FieldByName('JuridicalName_To').asString;
    �������������� := HeaderDataSet.FieldByName('OKPO_To').asString;
    ��� := HeaderDataSet.FieldByName('INN_To').asString;
    GLN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with �������������������.�������.Add do
    begin
      �� := i;
      ������ := i;
      �������������� := ItemsDataSet.FieldByName
        ('ArticleGLN_Juridical').asString;
      ������������ := ItemsDataSet.FieldByName('GoodsName').asString;
      ��������ʳ������ :=
        gfFloatToStr(ItemsDataSet.FieldByName('AmountPartner').AsFloat);
      ֳ�� := gfFloatToStr(ItemsDataSet.FieldByName('PriceWVAT').AsFloat);
      inc(i);
    end;
    ItemsDataSet.Next;
  end;

  // ��������� �� ����
  XMLFileName := ExtractFilePath(ParamStr(0)) + 'comdoc_' +
    FormatDateTime('yyyymmddhhnnss', Date + Time) + '_' +
    HeaderDataSet.FieldByName('InvNumber').asString + '_006.xml';
  �������������������.OwnerDocument.SaveToFile(XMLFileName);
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
     //***if FileExists(XMLFileName) then showMessage('exists ' + XMLFileName + #10+#13 + ' start SignFile')
     //***else showMessage('not exists ' + XMLFileName + #10+#13 + ' start SignFile');

    // ���������
    SignFile(XMLFileName, stComDoc, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

     //***if FileExists(XMLFileName) then showMessage('exists ' + XMLFileName + #10+#13 + ' end SignFile')
     //***else showMessage('not exists ' + XMLFileName + #10+#13 + ' end SignFile');

     //***if FileExists(P7SFileName) then showMessage('exists ' + P7SFileName + #10+#13 + ' end SignFile')
     //***else showMessage('not exists ' + P7SFileName + #10+#13 + ' end SignFile');

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '�������� ����������� � ��������';
      FInsertEDIEvents.Execute;
    end;

     //***if FileExists(XMLFileName) then showMessage('exists ' + XMLFileName + #10+#13 + ' start �� FTP')
     //***else showMessage('not exists ' + XMLFileName + #10+#13 + ' end SignFile');

     //***if FileExists(P7SFileName) then showMessage('exists ' + P7SFileName + #10+#13 + ' start �� FTP')
     //***else showMessage('not exists ' + P7SFileName + #10+#13 + ' end SignFile');

    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');

     //***if FileExists(XMLFileName) then showMessage('exists ' + XMLFileName + #10+#13 + ' end �� FTP')
     //***else showMessage('not exists ' + XMLFileName + #10+#13 + ' end SignFile');

     //***if FileExists(P7SFileName) then showMessage('exists ' + P7SFileName + #10+#13 + ' end �� FTP')
     //***else showMessage('not exists ' + P7SFileName + #10+#13 + ' end SignFile');

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '�������� ��������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // ������� �����
    if FileExists(XMLFileName) then
      DeleteFile(XMLFileName);
    if FileExists(P7SFileName) then
      DeleteFile(P7SFileName);
  end;
end;

function TEDI.ConvertEDIDate(ADateTime: string): TDateTime;
var FormatSettings : TFormatSettings;
begin
  FormatSettings.DateSeparator := '-';
  FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  result := StrToDate(ADateTime, FormatSettings)
end;

constructor TEDI.Create(AOwner: TComponent);
begin
  inherited;
  SendToFTP := true;
  ComSigner := null;

  FConnectionParams := TConnectionParams.Create;
  FIdFTP := TIdFTP.Create(nil);
  FInsertEDIFile := TdsdStoredProc.Create(nil);
  FInsertEDIFile.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FInsertEDIFile.Params.AddParam('inFileName', ftString, ptInput, '');
  FInsertEDIFile.Params.AddParam('inFileText', ftBlob, ptInput, '');
  FInsertEDIFile.StoredProcName := 'gpInsert_EDIFiles';
  FInsertEDIFile.OutputType := otResult;

  FInsertEDIEvents := TdsdStoredProc.Create(nil);
  FInsertEDIEvents.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FInsertEDIEvents.Params.AddParam('inEDIEvent', ftString, ptInput, '');
  FInsertEDIEvents.StoredProcName := 'gpInsert_Movement_EDIEvents';
  FInsertEDIEvents.OutputType := otResult;

  FInsertEDIEventsDoc := TdsdStoredProc.Create(nil);
  FInsertEDIEventsDoc.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FInsertEDIEventsDoc.Params.AddParam('inDocumentId', ftString, ptInput, '');
  FInsertEDIEventsDoc.Params.AddParam('inVchasnoId', ftString, ptInput, '');
  FInsertEDIEventsDoc.Params.AddParam('inEDIEvent', ftString, ptInput, '');
  FInsertEDIEventsDoc.StoredProcName := 'gpInsert_Movement_EDIEvents';
  FInsertEDIEventsDoc.OutputType := otResult;

  FExistsOrder := TdsdStoredProc.Create(nil);
  FExistsOrder.Params.AddParam('inFileName', ftString, ptInput, '');
  FExistsOrder.Params.AddParam('outIsExists', ftBoolean, ptOutput, false);
  FExistsOrder.StoredProcName := 'gpSelect_Movement_EDI_exists';
  FExistsOrder.OutputType := otResult;


  FUpdateDeclarAmount := TdsdStoredProc.Create(nil);
  FUpdateDeclarAmount.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FUpdateDeclarAmount.Params.AddParam('inAmount', ftInteger, ptInput, '');
  FUpdateDeclarAmount.StoredProcName := 'gpUpdate_Movement_DeclarAmount';
  FUpdateDeclarAmount.OutputType := otResult;

  FUpdateDeclarFileName := TdsdStoredProc.Create(nil);
  FUpdateDeclarFileName.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FUpdateDeclarFileName.Params.AddParam('inFileName', ftString, ptInput, '');
  FUpdateDeclarFileName.StoredProcName := 'gpUpdate_DeclarFileName';
  FUpdateDeclarFileName.OutputType := otResult;

  FUpdateEDIErrorState := TdsdStoredProc.Create(nil);
  FUpdateEDIErrorState.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FUpdateEDIErrorState.Params.AddParam('inDocType', ftString, ptInput, '');
  FUpdateEDIErrorState.Params.AddParam('inOperDate', ftDateTime, ptInput, Date);
  FUpdateEDIErrorState.Params.AddParam('inInvNumber', ftString, ptInput, '');
  FUpdateEDIErrorState.Params.AddParam('inIsError', ftBoolean, ptInput, false);
  FUpdateEDIErrorState.Params.AddParam('IsFind', ftBoolean, ptOutput, false);
  FUpdateEDIErrorState.StoredProcName := 'gpUpdate_Movement_EDIErrorState';
  FUpdateEDIErrorState.OutputType := otResult;

  FUpdateEDIVchasnoEDI := TdsdStoredProc.Create(nil);
  FUpdateEDIVchasnoEDI.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FUpdateEDIVchasnoEDI.Params.AddParam('inDealId', ftString, ptInput, '');
  FUpdateEDIVchasnoEDI.StoredProcName := 'gpUpdate_Movement_EDI_VchasnoEDI';
  FUpdateEDIVchasnoEDI.OutputType := otResult;


  FGetSaveFilePath := TdsdStoredProc.Create(nil);
  FGetSaveFilePath.OutputType := otResult;
  FGetSaveFilePath.StoredProcName := 'gpGetDirectoryEdiName';
  FGetSaveFilePath.Params.AddParam('Directory', ftString, ptOutput, '');
  FGetSaveFilePath.Params.AddParam('isEDISaveLocal', ftBoolean, ptOutput, '');
  if not (csDesigning in ComponentState) then begin
     FGetSaveFilePath.Execute;
     FDirectoryError := FGetSaveFilePath.ParamByName('Directory').AsString;
     FisEDISaveLocal := FGetSaveFilePath.ParamByName('isEDISaveLocal').Value;
  end;
end;

procedure TEDI.ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String;
  StartDate, EndDate: TDateTime);
var
  List: TStrings;
  i, MovementId: integer;
  Stream: TStringStream;
  FileData: string;
  DocData: TDateTime;
  �������������������: IXML�������������������Type;
  Present: TDateTime;
  Year, Month, Day: Word;
begin
  FTPSetConnection;
  // ��������� ����� � FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('�������� ������', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            // ���� ������ ����� ����� comdoc, � ��������� .p7s. ����������
            if (copy(List[i], 1, 6) = 'comdoc') and
              ((ExtractFileExt(List[i]) = '.p7s')
            or (ExtractFileExt(List[i]) = '.xml'))
            then
            begin
              Present:=Now;
              DecodeDate(Present, Year, Month, Day);
              if Pos('_'+IntToStr(Year),List[i]) > 0
              then DocData := gfStrFormatToDate(copy(List[i], Pos('_'+IntToStr(Year),List[i])+1, 8), 'yyyymmdd')
              else DocData := gfStrFormatToDate(copy(List[i], Pos('_'+IntToStr(Year-1),List[i])+1, 8), 'yyyymmdd');
              //
              if (StartDate <= DocData) and (DocData <= EndDate) then
              begin
// if List[i] = 'comdoc_20220708093713_f0d886da-cc79-4720-b444-88ac76b81f02_0024163_007.p7s' then ShowMessage('');
                // ����� ���� � ���
                Stream.Clear;
                FIdFTP.Get(List[i], Stream);
                FileData := Utf8ToAnsi(Stream.DataString);
                // ������ ��������� <?xml
                if pos('<?xml', FileData) > 0 then
                begin
                  FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                end else
                begin
                  // ���� ��� <?xml �� ����� �� <�������������������>
                  FileData := '<?xml version="1.0" encoding="utf-8"?>'#13#10 +
                              copy(FileData, pos('<�������������������>', FileData), MaxInt);
                end;
                FileData := copy(FileData, 1, pos('</�������������������>',
                  FileData) + 21);
                try
                MovementId:= 0;
                ������������������� := Load�������������������(FileData);
                except ON E: Exception DO
                      Begin
                         ShowMessage(E.Message +#10  +#13 + List[i]);
                         MovementId:= -1;
                      End;
                end;
                if MovementId <> -1
                then

                if (�������������������.���������.���������������� = '007')
                 or(�������������������.���������.���������������� = '004')
                 or(�������������������.���������.���������������� = '012')
                 //13.07.2022
                 or(�������������������.���������.���������������� = '005')
               then
                begin
                  // ��������� � �������
                  try
                    MovementId := InsertUpdateComDoc(�������������������,
                      spHeader, spList);
                  Except ON E: Exception DO
                    Begin
                      MovementId := -1;
                      ShowMessage(E.Message +#10  +#13 + List[i]);
                    End;
                  end;
                  if MovementId <> -1 then
                  Begin
                    FInsertEDIFile.ParamByName('inMovementId').Value :=
                      MovementId;
                    FInsertEDIFile.ParamByName('inFileName').Value := List[i];
                    FInsertEDIFile.ParamByName('inFileText').Value :=
                      ConvertConvert(Stream.DataString);
                    try
                      FInsertEDIFile.Execute;
                    Except ON E: Exception DO
                      Begin
                        ShowMessage(E.Message);
                        MovementId := -1;
                      End;
                    end;
                  End;
                end;
                // ������ ��������� ���� � ���������� Archive
                if MovementId <> -1 then
                Begin
                  try
                    if not FIdFTP.Connected then
                       FIdFTP.Connect;
                    FIdFTP.ChangeDir('/archive');
                    FIdFTP.Put(Stream, List[i]);
                  finally
                    FIdFTP.ChangeDir(Directory);
                    try FIdFTP.Delete(List[i]); except ShowMessage ('��������� �������� <'+List[i]+'>');end;
                  end;
                End;
              end;
            end;
            IncProgress;
          end;
        finally
          Finish;
        end;
    finally
      FIdFTP.Quit;
      List.Free;
      Stream.Free;
    end;
  end;
end;

procedure TEDI.DeclarReturnSave(HeaderDataSet, ItemsDataSet: TDataSet;
  StoredProc: TdsdStoredProc; Directory: String; DebugMode: boolean);
var F: TFormatSettings;
begin
     F.DateSeparator := '.';
     F.TimeSeparator := ':';
     F.ShortDateFormat := 'dd.mm.yyyy';
     F.ShortTimeFormat := 'hh24:mi:ss';

     if HeaderDataSet.FieldByName('OperDate').asDateTime >= StrToDateTime( '01.03.2017', F)
     then lpDeclarReturnSave_start01032017(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode)
     else
         if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.04.2016', F)
         then lpDeclarReturnSave_start01042016(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode)
         else lpDeclarReturnSave_start(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode);
end;

procedure TEDI.lpDeclarReturnSave_start01042016(HeaderDataSet, ItemsDataSet: TDataSet;
  StoredProc: TdsdStoredProc; Directory: String; DebugMode: boolean);
const
  C_DOC = 'J12';
  C_DOC_SUB = '012';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
  lDirectory: string;
  C_DOC_VER: string;
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';

  C_DOC_VER := '8';
  // ������� xml ����
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);
  // ������� xml ����
  DECLAR := NewDECLAR;
  DECLAR.OwnerDocument.Encoding := 'WINDOWS-1251';
  DECLAR.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_To').asString;
  DECLAR.DECLARHEAD.C_DOC := C_DOC;
  DECLAR.DECLARHEAD.C_DOC_SUB := C_DOC_SUB;
  DECLAR.DECLARHEAD.C_DOC_VER := C_DOC_VER;
  DECLAR.DECLARHEAD.C_DOC_TYPE := C_DOC_TYPE;
  DECLAR.DECLARHEAD.C_DOC_CNT :=
    copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1, 7);
  DECLAR.DECLARHEAD.C_REG := C_REG;
  DECLAR.DECLARHEAD.C_RAJ := C_RAJ;
  DECLAR.DECLARHEAD.PERIOD_MONTH := FormatDateTime('mm',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.PERIOD_TYPE := PERIOD_TYPE;
  DECLAR.DECLARHEAD.PERIOD_YEAR := FormatDateTime('yyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.C_STI_ORIG := C_REG + C_RAJ;
  DECLAR.DECLARHEAD.C_DOC_STAN := C_DOC_STAN;
  DECLAR.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                              + ';SU:' + HeaderDataSet.FieldByName('SupplierGLNCode').asString
  else
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                               ;

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������  / �������
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // ϳ����� ��������� � ���� �������������� (���������)
     DECLAR.DECLARBODY.HERPN0 := '1';
  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // ϳ����� ��������� � ���� ��������
     DECLAR.DECLARBODY.HERPN := '1';
  if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
     //�� ������� ��������� ��������
     DECLAR.DECLARBODY.H03 := '1';


  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName('InvNumberPartner')
    .asString);
  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

  DECLAR.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate_Child').asDateTime);
  DECLAR.DECLARBODY.HPODNUM := trim(HeaderDataSet.FieldByName('InvNumber_Child')
    .asString);
  DECLAR.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName
    ('JuridicalName_To').asString;
  DECLAR.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName
    ('JuridicalName_From').asString;
  DECLAR.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').asString;
  DECLAR.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').asString;
  if HeaderDataSet.FieldByName('InvNumberBranch_From').asString <> ''
  then DECLAR.DECLARBODY.HFBUY := HeaderDataSet.FieldByName('InvNumberBranch_From').asString;

  DECLAR.DECLARBODY.R02G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummvat').AsFloat),
    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R01G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummmvat').AsFloat),
    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R001G03 := DECLAR.DECLARBODY.R02G9;


  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG001.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('LineNum').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('kindname').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG3S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('GoodsName').asString + ';GTIN:' +
        HeaderDataSet.FieldByName('BarCodeGLN_Juridical').asString + ';IDBY:' +
        HeaderDataSet.FieldByName('ArticleGLN_Juridical').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('GoodsCodeUKTZED').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('MeasureName').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;


  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG105_2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('MeasureCode').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := '-' + gfFloatToStr
        (HeaderDataSet.FieldByName('Amount').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG6.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('Price').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG7.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('Price_for_PriceCor').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG8.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('Amount_for_PriceCor').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG008.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('VATPercent').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG010.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := '-' + StringReplace(FormatFloat('0.00',
        HeaderDataSet.FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator,
        cMainDecimalSeparator, []);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  //�������� (������������) �����/������� �����
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_to').asString;

  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  // ��������� �� ����
  XMLFileName := lDirectory + C_REG + C_RAJ +
    PAD0(HeaderDataSet.FieldByName('OKPO_To').asString, 10) + C_DOC + C_DOC_SUB
    + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.p7s';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;
  P7SFileName := XMLFileName; //StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);

//  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // ���������
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '������������� ������������ � ���������';
      FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // ��������� ������� ��������
      FUpdateDeclarAmount.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarAmount.ParamByName('inAmount').Value :=
        StrToInt(C_DOC_TYPE) + 1;
      FUpdateDeclarAmount.Execute;

      FUpdateDeclarFileName.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarFileName.ParamByName('inFileName').Value :=
        ExtractFileName(XMLFileName);
      FUpdateDeclarFileName.Execute;

      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '������������� ���������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // ������� �����
    if FileExists(XMLFileName) then
      DeleteFile(XMLFileName);
    if FileExists(P7SFileName) then
      DeleteFile(P7SFileName);
  end;
end;

procedure TEDI.lpDeclarReturnSave_start01032017(HeaderDataSet, ItemsDataSet: TDataSet;
  StoredProc: TdsdStoredProc; Directory: String; DebugMode: boolean);
const
  C_DOC = 'J12';
  C_DOC_SUB = '012';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
  lDirectory: string;
  C_DOC_VER: string;
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';

  C_DOC_VER := '9';
  // ������� xml ����
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);
  // ������� xml ����
  DECLAR := NewDECLAR;
  DECLAR.OwnerDocument.Encoding := 'WINDOWS-1251';
  DECLAR.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_To').asString;
  DECLAR.DECLARHEAD.C_DOC := C_DOC;
  DECLAR.DECLARHEAD.C_DOC_SUB := C_DOC_SUB;
  DECLAR.DECLARHEAD.C_DOC_VER := C_DOC_VER;
  DECLAR.DECLARHEAD.C_DOC_TYPE := C_DOC_TYPE;
  DECLAR.DECLARHEAD.C_DOC_CNT :=
    copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1, 7);
  DECLAR.DECLARHEAD.C_REG := C_REG;
  DECLAR.DECLARHEAD.C_RAJ := C_RAJ;
  DECLAR.DECLARHEAD.PERIOD_MONTH := FormatDateTime('mm',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.PERIOD_TYPE := PERIOD_TYPE;
  DECLAR.DECLARHEAD.PERIOD_YEAR := FormatDateTime('yyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.C_STI_ORIG := C_REG + C_RAJ;
  DECLAR.DECLARHEAD.C_DOC_STAN := C_DOC_STAN;
  DECLAR.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                              + ';SU:' + HeaderDataSet.FieldByName('SupplierGLNCode').asString
  else
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                               ;

  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������  / �������
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // ϳ����� ��������� � ���� �������������� (���������)
     DECLAR.DECLARBODY.HERPN0 := '1';
  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // ϳ����� ��������� � ���� ��������
     DECLAR.DECLARBODY.HERPN := '1';
  if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
     //�� ������� ��������� ��������
     DECLAR.DECLARBODY.H03 := '1';


  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName('InvNumberPartner')
    .asString);
  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

  DECLAR.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate_Child').asDateTime);
  DECLAR.DECLARBODY.HPODNUM := trim(HeaderDataSet.FieldByName('InvNumber_Child')
    .asString);
  DECLAR.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName
    ('JuridicalName_To').asString;
  DECLAR.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName
    ('JuridicalName_From').asString;
  DECLAR.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').asString;
  DECLAR.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').asString;
  if HeaderDataSet.FieldByName('InvNumberBranch_From').asString <> ''
  then DECLAR.DECLARBODY.HFBUY := HeaderDataSet.FieldByName('InvNumberBranch_From').asString;

  DECLAR.DECLARBODY.R02G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummvat').AsFloat),
    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R01G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummmvat').AsFloat),
    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R001G03 := DECLAR.DECLARBODY.R02G9;


  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG001.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('LineNum').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('kindname').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG3S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('GoodsName').asString + ';GTIN:' +
        HeaderDataSet.FieldByName('BarCodeGLN_Juridical').asString + ';IDBY:' +
        HeaderDataSet.FieldByName('ArticleGLN_Juridical').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('GoodsCodeUKTZED').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('MeasureName').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;


  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG105_2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('MeasureCode').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := '-' + gfFloatToStr
        (HeaderDataSet.FieldByName('Amount').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG6.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('Price').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG7.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('Price_for_PriceCor').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG8.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('Amount_for_PriceCor').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG008.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('VATPercent').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG010.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := '-' + StringReplace(FormatFloat('0.00',
        HeaderDataSet.FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator,
        cMainDecimalSeparator, []);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  //�������� (������������) �����/������� �����
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_to').asString;

  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  // ��������� �� ����
  XMLFileName := lDirectory + C_REG + C_RAJ +
    PAD0(HeaderDataSet.FieldByName('OKPO_To').asString, 10) + C_DOC + C_DOC_SUB
    + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.p7s';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;
  P7SFileName := XMLFileName; //StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);

//  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // ���������
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '������������� ������������ � ���������';
      FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // ��������� ������� ��������
      FUpdateDeclarAmount.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarAmount.ParamByName('inAmount').Value :=
        StrToInt(C_DOC_TYPE) + 1;
      FUpdateDeclarAmount.Execute;

      FUpdateDeclarFileName.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarFileName.ParamByName('inFileName').Value :=
        ExtractFileName(XMLFileName);
      FUpdateDeclarFileName.Execute;

      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '������������� ���������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // ������� �����
    if FileExists(XMLFileName) then
      DeleteFile(XMLFileName);
    if FileExists(P7SFileName) then
      DeleteFile(P7SFileName);
  end;
end;

procedure TEDI.lpDeclarReturnSave_start(HeaderDataSet, ItemsDataSet: TDataSet;
  StoredProc: TdsdStoredProc; Directory: String; DebugMode: boolean);
const
  C_DOC = 'J12';
  C_DOC_SUB = '012';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
  lDirectory: string;
  C_DOC_VER: string;
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';

   if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.12.2014', F) then
     C_DOC_VER := '5'
   else begin
     if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.01.2015', F) then
        C_DOC_VER := '6'
     else
        C_DOC_VER := '7'
   end;
  // ������� xml ����
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);
  // ������� xml ����
  DECLAR := NewDECLAR;
  DECLAR.OwnerDocument.Encoding := 'WINDOWS-1251';
  DECLAR.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_To').asString;
  DECLAR.DECLARHEAD.C_DOC := C_DOC;
  DECLAR.DECLARHEAD.C_DOC_SUB := C_DOC_SUB;
  DECLAR.DECLARHEAD.C_DOC_VER := C_DOC_VER;
  DECLAR.DECLARHEAD.C_DOC_TYPE := C_DOC_TYPE;
  DECLAR.DECLARHEAD.C_DOC_CNT :=
    copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1, 7);
  DECLAR.DECLARHEAD.C_REG := C_REG;
  DECLAR.DECLARHEAD.C_RAJ := C_RAJ;
  DECLAR.DECLARHEAD.PERIOD_MONTH := FormatDateTime('mm',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.PERIOD_TYPE := PERIOD_TYPE;
  DECLAR.DECLARHEAD.PERIOD_YEAR := FormatDateTime('yyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.C_STI_ORIG := C_REG + C_RAJ;
  DECLAR.DECLARHEAD.C_DOC_STAN := C_DOC_STAN;
  DECLAR.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName('SupplierGLNCode').asString
                             + ';SU:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
  else
  DECLAR.DECLARHEAD.SOFTWARE := 'SU:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString;

  if C_DOC_VER <> '7' then
     DECLAR.DECLARBODY.HORIG := '1'
  else begin
     if HeaderDataSet.FieldByName('isERPN').AsBoolean then
        DECLAR.DECLARBODY.HERPN := '1';
     if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then begin
         // �� �������� �������
        DECLAR.DECLARBODY.HORIG1 := '1';
        // �� �������� ������� (��� �������)
        DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
     end;
  end;

  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName('InvNumberPartner')
    .asString);
  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

  DECLAR.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate_Child').asDateTime);
  DECLAR.DECLARBODY.HPODNUM := trim(HeaderDataSet.FieldByName('InvNumber_Child')
    .asString);
  DECLAR.DECLARBODY.H01G1D := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  DECLAR.DECLARBODY.H01G2S := HeaderDataSet.FieldByName('ContractName')
    .asString;
  DECLAR.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName
    ('JuridicalName_To').asString;
  DECLAR.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName
    ('JuridicalName_From').asString;
  DECLAR.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_To').asString;
  DECLAR.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_From').asString;
  DECLAR.DECLARBODY.HLOCSEL := HeaderDataSet.FieldByName
    ('JuridicalAddress_To').asString;
  DECLAR.DECLARBODY.HLOCBUY := HeaderDataSet.FieldByName
    ('JuridicalAddress_From').asString;
  if HeaderDataSet.FieldByName('Phone_To').asString = '' then
    raise Exception.Create('�� ��������� ������� ��������');
  DECLAR.DECLARBODY.HTELSEL := HeaderDataSet.FieldByName('Phone_To').asString;
  if HeaderDataSet.FieldByName('Phone_From').asString = '' then
    raise Exception.Create('�� ��������� ������� ����������');
  DECLAR.DECLARBODY.HTELBUY := HeaderDataSet.FieldByName('Phone_From').asString;

  DECLAR.DECLARBODY.H02G1S := '��������;COMDOC:' + HeaderDataSet.FieldByName
    ('InvNumberPartnerEDI').asString + ';DATE:' + FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime) + ';';

  DECLAR.DECLARBODY.H02G2D := DECLAR.DECLARBODY.H01G1D;
  DECLAR.DECLARBODY.H02G3S := DECLAR.DECLARBODY.H01G2S;
  if C_DOC_VER = '5' then begin
     DECLAR.DECLARBODY.H04G1D := DECLAR.DECLARBODY.HPODFILL;
     DECLAR.DECLARBODY.H03G1S := '������ � ��������� �������';
  end;

  // DECLAR.DECLARBODY.H01G1D := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  // DEC1LAR.DECLARBODY.H01G2S := HeaderDataSet.FieldByName('ContractName').AsString;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG1D.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := FormatDateTime('ddmmyyyy',
        HeaderDataSet.FieldByName('OperDate').asDateTime);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('kindname').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG3S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('GoodsName').asString + ';GTIN:' +
        HeaderDataSet.FieldByName('BarCodeGLN_Juridical').asString + ';IDBY:' +
        HeaderDataSet.FieldByName('ArticleGLN_Juridical').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('GoodsCodeUKTZED').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := HeaderDataSet.FieldByName('MeasureName').asString;
    end;
    inc(i);
    HeaderDataSet.Next;
  end;


  if C_DOC_VER = '7' then begin
    i := 1;
    HeaderDataSet.First;
    while not HeaderDataSet.Eof do
    begin
      with DECLAR.DECLARBODY.RXXXXG105_2S.Add do
      begin
        ROWNUM := IntToStr(i);
        NodeValue := HeaderDataSet.FieldByName('MeasureCode').asString;
      end;
      inc(i);
      HeaderDataSet.Next;
    end;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := '-' + gfFloatToStr
        (HeaderDataSet.FieldByName('Amount').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG6.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('Price').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG7.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('Price_for_PriceCor').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG8.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr
        (HeaderDataSet.FieldByName('Amount_for_PriceCor').AsFloat);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG9.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := '-' + StringReplace(FormatFloat('0.00',
        HeaderDataSet.FieldByName('AmountSumm').AsFloat), FormatSettings.DecimalSeparator,
        cMainDecimalSeparator, []);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  DECLAR.DECLARBODY.R01G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummmvat').AsFloat),
    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R02G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummvat').AsFloat),
    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

  if C_DOC_VER <> '7' then
     DECLAR.DECLARBODY.H10G1D := FormatDateTime('ddmmyyyy',
        HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.H10G2S := HeaderDataSet.FieldByName('N10').asString; // '������';

  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  // ��������� �� ����
  XMLFileName := lDirectory + C_REG + C_RAJ +
    PAD0(HeaderDataSet.FieldByName('OKPO_To').asString, 10) + C_DOC + C_DOC_SUB
    + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.p7s';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;
  P7SFileName := XMLFileName; //StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);

//  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // ���������
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '��������� ������������ � ���������';
      FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // ��������� ������� ��������
      FUpdateDeclarAmount.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarAmount.ParamByName('inAmount').Value :=
        StrToInt(C_DOC_TYPE) + 1;
      FUpdateDeclarAmount.Execute;

      FUpdateDeclarFileName.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarFileName.ParamByName('inFileName').Value :=
        ExtractFileName(XMLFileName);
      FUpdateDeclarFileName.Execute;

      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '���������������� ��������� ���������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // ������� �����
    if FileExists(XMLFileName) then
      DeleteFile(XMLFileName);
    if FileExists(P7SFileName) then
      DeleteFile(P7SFileName);
  end;
end;

procedure TEDI.DeclarSave(HeaderDataSet, ItemsDataSet: TDataSet;
     StoredProc: TdsdStoredProc;  Directory: String; DebugMode: boolean);
var F: TFormatSettings;
begin
     F.DateSeparator := '.';
     F.TimeSeparator := ':';
     F.ShortDateFormat := 'dd.mm.yyyy';
     F.ShortTimeFormat := 'hh24:mi:ss';

     if HeaderDataSet.FieldByName('OperDate').asDateTime >= StrToDateTime( '01.03.2017', F)
     then lpDeclarSave_start01032017(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode)
     else
         if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.04.2016', F)
         then lpDeclarSave_start01042016(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode)
         else lpDeclarSave_start(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode);
end;

procedure TEDI.lpDeclarSave_start01042016(HeaderDataSet, ItemsDataSet: TDataSet;
     StoredProc: TdsdStoredProc;  Directory: String; DebugMode: boolean);
const
  C_DOC = 'J12';
  C_DOC_SUB = '010';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
  lDirectory: string;
  C_DOC_VER: string;
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';

   // ������� xml ����
   C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount').asInteger);

  C_DOC_VER := '8';

  DECLAR := NewDECLAR;
  DECLAR.OwnerDocument.Encoding := 'WINDOWS-1251';
  DECLAR.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').asString;
  DECLAR.DECLARHEAD.C_DOC := C_DOC;
  DECLAR.DECLARHEAD.C_DOC_SUB := C_DOC_SUB;
  DECLAR.DECLARHEAD.C_DOC_VER := C_DOC_VER;
  DECLAR.DECLARHEAD.C_DOC_TYPE := C_DOC_TYPE;
  DECLAR.DECLARHEAD.C_DOC_CNT :=
    copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1, 7);
  DECLAR.DECLARHEAD.C_REG := C_REG;
  DECLAR.DECLARHEAD.C_RAJ := C_RAJ;
  DECLAR.DECLARHEAD.PERIOD_MONTH := FormatDateTime('mm',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.PERIOD_TYPE := PERIOD_TYPE;
  DECLAR.DECLARHEAD.PERIOD_YEAR := FormatDateTime('yyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.C_STI_ORIG := C_REG + C_RAJ;
  DECLAR.DECLARHEAD.C_DOC_STAN := C_DOC_STAN;
  DECLAR.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI_tax').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                              + ';SU:' + HeaderDataSet.FieldByName('SupplierGLNCode').asString
  else
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI_tax').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                               ;


  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������  / �������
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

   if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
   begin
     //�� ������� ��������� ��������
     DECLAR.DECLARBODY.H03 := '1';
   end;

  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName('InvNumberPartner')
    .asString);
  DECLAR.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName
    ('JuridicalName_From').asString;
  DECLAR.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName
    ('JuridicalName_To').asString;
  DECLAR.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_From').asString;
  DECLAR.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').asString;

  if HeaderDataSet.FieldByName('InvNumberBranch_To').asString <> ''
  then DECLAR.DECLARBODY.HFBUY := HeaderDataSet.FieldByName('InvNumberBranch_To').asString;


  //�������� �����
  DECLAR.DECLARBODY.R04G11 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R03G11 :=
  StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R03G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R01G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

    If HeaderDataSet.FieldByName('VATPercent').AsFloat = 901
    then DECLAR.DECLARBODY.R01G9 :=
                StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11')
                .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    If HeaderDataSet.FieldByName('VATPercent').AsFloat = 902
    then DECLAR.DECLARBODY.R01G8 :=
                StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11')
                .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG3S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('GoodsName').asString + ';GTIN:' +
        ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString + ';IDBY:' +
        ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;


  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('MeasureName').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG105_2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('MeasureCode').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('Amount').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG6.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('PriceNoVAT').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG008.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('VATPercent').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG010.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := StringReplace(FormatFloat('0.00',
        ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat),
        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;


  //�������� (������������) �����/������� �����
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').asString;


  // ���� � �����
  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  XMLFileName := lDirectory + C_REG + C_RAJ +
    PAD0(HeaderDataSet.FieldByName('OKPO_From').asString, 10) + C_DOC +
    C_DOC_SUB + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.p7s';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;
  P7SFileName := XMLFileName; //StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
//  ShowMessage ('start ��������� - SignFile : ' + XMLFileName);
    // ���������
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

//  ShowMessage ('end ��������� - SignFile : ' + XMLFileName);

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '��������� ������������ � ���������';
      FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // ��������� ������� ��������
      FUpdateDeclarAmount.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarAmount.ParamByName('inAmount').Value :=
        StrToInt(C_DOC_TYPE) + 1;
      FUpdateDeclarAmount.Execute;

      FUpdateDeclarFileName.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarFileName.ParamByName('inFileName').Value :=
        ExtractFileName(XMLFileName);
      FUpdateDeclarFileName.Execute;

      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;

      // �������� ������ � ��������
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '��������� ���������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // ������� �����
    if FileExists(XMLFileName) then
      DeleteFile(XMLFileName);
    if FileExists(P7SFileName) then
      DeleteFile(P7SFileName);
  end;
end;

procedure TEDI.lpDeclarSave_start01032017(HeaderDataSet, ItemsDataSet: TDataSet;
     StoredProc: TdsdStoredProc;  Directory: String; DebugMode: boolean);
const
  C_DOC = 'J12';
  C_DOC_SUB = '010';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
  lDirectory: string;
  C_DOC_VER: string;
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';

   // ������� xml ����
   C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount').asInteger);

  C_DOC_VER := '9';

  DECLAR := NewDECLAR;
  DECLAR.OwnerDocument.Encoding := 'WINDOWS-1251';
  DECLAR.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').asString;
  DECLAR.DECLARHEAD.C_DOC := C_DOC;
  DECLAR.DECLARHEAD.C_DOC_SUB := C_DOC_SUB;
  DECLAR.DECLARHEAD.C_DOC_VER := C_DOC_VER;
  DECLAR.DECLARHEAD.C_DOC_TYPE := C_DOC_TYPE;
  DECLAR.DECLARHEAD.C_DOC_CNT :=
    copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1, 7);
  DECLAR.DECLARHEAD.C_REG := C_REG;
  DECLAR.DECLARHEAD.C_RAJ := C_RAJ;
  DECLAR.DECLARHEAD.PERIOD_MONTH := FormatDateTime('mm',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.PERIOD_TYPE := PERIOD_TYPE;
  DECLAR.DECLARHEAD.PERIOD_YEAR := FormatDateTime('yyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.C_STI_ORIG := C_REG + C_RAJ;
  DECLAR.DECLARHEAD.C_DOC_STAN := C_DOC_STAN;
  DECLAR.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI_tax').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                              + ';SU:' + HeaderDataSet.FieldByName('SupplierGLNCode').asString
  else
  DECLAR.DECLARHEAD.SOFTWARE := 'COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString
                              + ';DATE:' + FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartnerEDI_tax').asDateTime)
                              + ';BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                               ;


  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������  / �������
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

   if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
   begin
     //�� ������� ��������� ��������
     DECLAR.DECLARBODY.H03 := '1';
   end;

  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName('InvNumberPartner')
    .asString);
  DECLAR.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName
    ('JuridicalName_From').asString;
  DECLAR.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName
    ('JuridicalName_To').asString;
  DECLAR.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_From').asString;
  DECLAR.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').asString;

  if HeaderDataSet.FieldByName('InvNumberBranch_To').asString <> ''
  then DECLAR.DECLARBODY.HFBUY := HeaderDataSet.FieldByName('InvNumberBranch_To').asString;


  //�������� �����
  DECLAR.DECLARBODY.R04G11 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R03G11 :=
  StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R03G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R01G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

    If HeaderDataSet.FieldByName('VATPercent').AsFloat = 901
    then DECLAR.DECLARBODY.R01G9 :=
                StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11')
                .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    If HeaderDataSet.FieldByName('VATPercent').AsFloat = 902
    then DECLAR.DECLARBODY.R01G8 :=
                StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT_11')
                .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG3S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('GoodsName').asString + ';GTIN:' +
        ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString + ';IDBY:' +
        ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;


  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('MeasureName').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG105_2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('MeasureCode').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('Amount').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG6.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('PriceNoVAT').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG008.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('VATPercent').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG010.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := StringReplace(FormatFloat('0.00',
        ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat),
        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;


  //�������� (������������) �����/������� �����
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').asString;


  // ���� � �����
  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  XMLFileName := lDirectory + C_REG + C_RAJ +
    PAD0(HeaderDataSet.FieldByName('OKPO_From').asString, 10) + C_DOC +
    C_DOC_SUB + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.p7s';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;
  P7SFileName := XMLFileName; //StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
//  ShowMessage ('start ��������� - SignFile : ' + XMLFileName);
    // ���������
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

//  ShowMessage ('end ��������� - SignFile : ' + XMLFileName);

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '��������� ������������ � ���������';
      FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // ��������� ������� ��������
      FUpdateDeclarAmount.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarAmount.ParamByName('inAmount').Value :=
        StrToInt(C_DOC_TYPE) + 1;
      FUpdateDeclarAmount.Execute;

      FUpdateDeclarFileName.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarFileName.ParamByName('inFileName').Value :=
        ExtractFileName(XMLFileName);
      FUpdateDeclarFileName.Execute;

      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;

      // �������� ������ � ��������
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '��������� ���������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // ������� �����
    if FileExists(XMLFileName) then
      DeleteFile(XMLFileName);
    if FileExists(P7SFileName) then
      DeleteFile(P7SFileName);
  end;
end;


procedure TEDI.lpDeclarSave_start(HeaderDataSet, ItemsDataSet: TDataSet;
     StoredProc: TdsdStoredProc;  Directory: String; DebugMode: boolean);
const
  C_DOC = 'J12';
  C_DOC_SUB = '010';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
  lDirectory: string;
  C_DOC_VER: string;
  F: TFormatSettings;
begin
   F.DateSeparator := '.';
   F.TimeSeparator := ':';
   F.ShortDateFormat := 'dd.mm.yyyy';
   F.ShortTimeFormat := 'hh24:mi:ss';

   // ������� xml ����
   C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);

   if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.12.2014', F) then
     C_DOC_VER := '5'
   else begin
     if HeaderDataSet.FieldByName('OperDate').asDateTime < StrToDateTime( '01.01.2015', F) then
        C_DOC_VER := '6'
     else
        C_DOC_VER := '7'
   end;

  DECLAR := NewDECLAR;
  DECLAR.OwnerDocument.Encoding := 'WINDOWS-1251';
  DECLAR.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').asString;
  DECLAR.DECLARHEAD.C_DOC := C_DOC;
  DECLAR.DECLARHEAD.C_DOC_SUB := C_DOC_SUB;
  DECLAR.DECLARHEAD.C_DOC_VER := C_DOC_VER;
  DECLAR.DECLARHEAD.C_DOC_TYPE := C_DOC_TYPE;
  DECLAR.DECLARHEAD.C_DOC_CNT :=
    copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1, 7);
  DECLAR.DECLARHEAD.C_REG := C_REG;
  DECLAR.DECLARHEAD.C_RAJ := C_RAJ;
  DECLAR.DECLARHEAD.PERIOD_MONTH := FormatDateTime('mm',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.PERIOD_TYPE := PERIOD_TYPE;
  DECLAR.DECLARHEAD.PERIOD_YEAR := FormatDateTime('yyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.C_STI_ORIG := C_REG + C_RAJ;
  DECLAR.DECLARHEAD.C_DOC_STAN := C_DOC_STAN;
  DECLAR.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                             + ';SU:' + HeaderDataSet.FieldByName('SupplierGLNCode').asString
  else
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString
                               ;

  if C_DOC_VER <> '7' then
     DECLAR.DECLARBODY.HORIG := '1';

  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName('InvNumberPartner')
    .asString);
  DECLAR.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName
    ('JuridicalName_From').asString;
  DECLAR.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName
    ('JuridicalName_To').asString;
  DECLAR.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('INN_From').asString;
  DECLAR.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('INN_To').asString;
  DECLAR.DECLARBODY.HLOCSEL := HeaderDataSet.FieldByName
    ('JuridicalAddress_From').asString;
  DECLAR.DECLARBODY.HLOCBUY := HeaderDataSet.FieldByName
    ('JuridicalAddress_To').asString;
  if HeaderDataSet.FieldByName('Phone_From').asString = '' then
    raise Exception.Create('�� ��������� ������� ��������');
  DECLAR.DECLARBODY.HTELSEL := HeaderDataSet.FieldByName('Phone_From').asString;
  if HeaderDataSet.FieldByName('Phone_To').asString = '' then
   raise Exception.Create('�� ��������� ������� ����������');
  DECLAR.DECLARBODY.HTELBUY := HeaderDataSet.FieldByName('Phone_To').asString;

  DECLAR.DECLARBODY.H01G1S := '��������;COMDOC:' + HeaderDataSet.FieldByName
    ('InvNumberPartnerEDI').asString + ';DATE:' + FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime) + ';';
  DECLAR.DECLARBODY.H01G2D := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  DECLAR.DECLARBODY.H01G3S := HeaderDataSet.FieldByName('ContractName')
    .asString;
  DECLAR.DECLARBODY.H02G1S := '������ � ��������� �������';

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG2D.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := FormatDateTime('ddmmyyyy',
        HeaderDataSet.FieldByName('OperDate').asDateTime);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG3S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('GoodsName').asString + ';GTIN:' +
        ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString + ';IDBY:' +
        ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG4S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('MeasureName').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG105_2S.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := ItemsDataSet.FieldByName('MeasureCode').asString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('Amount').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG6.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('PriceNoVAT').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG7.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := StringReplace(FormatFloat('0.00',
        ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat),
        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  DECLAR.DECLARBODY.R01G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R01G11 := DECLAR.DECLARBODY.R01G7;
  DECLAR.DECLARBODY.R03G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R03G11 := DECLAR.DECLARBODY.R03G7;
  DECLAR.DECLARBODY.R04G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R04G11 := DECLAR.DECLARBODY.R04G7;
  DECLAR.DECLARBODY.H10G1S := HeaderDataSet.FieldByName('N10').asString; //'������';

  // ���� � �����
  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  XMLFileName := lDirectory + C_REG + C_RAJ +
    PAD0(HeaderDataSet.FieldByName('OKPO_From').asString, 10) + C_DOC +
    C_DOC_SUB + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.p7s';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;
  P7SFileName := XMLFileName; //StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // ���������
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '��������� ������������ � ���������';
      FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // ��������� ������� ��������
      FUpdateDeclarAmount.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarAmount.ParamByName('inAmount').Value :=
        StrToInt(C_DOC_TYPE) + 1;
      FUpdateDeclarAmount.Execute;

      FUpdateDeclarFileName.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateDeclarFileName.ParamByName('inFileName').Value :=
        ExtractFileName(XMLFileName);
      FUpdateDeclarFileName.Execute;

      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;

      // �������� ������ � ��������
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '��������� ���������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // ������� �����
    if FileExists(XMLFileName) then
      DeleteFile(XMLFileName);
    if FileExists(P7SFileName) then
      DeleteFile(P7SFileName);
  end;
end;

procedure TEDI.DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  DESADV: DesadvXML.IXMLDESADVType;
  DESADV_fozz: DesadvFozzXML.IXMLDESADVType;
  DESADV_fozz_Amount: DOCUMENTINVOICE_TN_XML.IXMLDocumentInvoiceType;
  DESADV_fozz_Price : DOCUMENTINVOICE_PRN_XML.IXMLDocumentInvoiceType;
  Stream: TStream;
  i: integer;
  FileName: string;
  lNumber: string;
  AmountSummNoVAT_fozz: Double;
  VATPercent_fozz: Integer;
begin
  if (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
     and (1=0)
  then begin
            // ������� XML
            DESADV_fozz := DesadvFozzXML.NewDESADV;
            // ����� ����������� ��� ������������
            DESADV_fozz.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // ���� ���������
            DESADV_fozz.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // ���� ��������
            DESADV_fozz.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // ��� ��������
            DESADV_fozz.DELIVERYTIME := '00:00';
            // ����� ����������
            DESADV_fozz.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // ���� ����������
            DESADV_fozz.ORDERDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
            // ����� ������������ ����������
            DESADV_fozz.ORDRSPNUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // ���� ������������ ����������
            DESADV_fozz.ORDRSPDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // ����� ��������
            DESADV_fozz.DELIVERYNOTENUMBER := StrToInt(HeaderDataSet.FieldByName('InvNumber').asString);
            // ���� ��������
            DESADV_fozz.DELIVERYNOTEDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // ����� �������� �� ��������
            DESADV_fozz.CAMPAIGNNUMBER := HeaderDataSet.FieldByName('ContractName').asString;
            // ʳ������ �����
            DESADV_fozz.TRANSPORTQUANTITY := 1;
            // ����� ������������� ������
            //DESADV_fozz.TRANSPORTID := 1; //HeaderDataSet.FieldByName('CarName').asString;
            // ��� ����������:  "31"  ��������  ��� "48"  ��������
            DESADV_fozz.TRANSPORTERTYPE := 31; //HeaderDataSet.FieldByName('CarModelName').asString;
            // ��� ���������������: 20 - ����������, 30 - �������, 40 - ���������, 60 - ��������, 100 - �������� ������
            DESADV_fozz.TRANSPORTTYPE := 30;
            //
            // GLN �������������
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then DESADV_fozz.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // GLN �������
            DESADV_fozz.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // GLN ���� ��������
            DESADV_fozz.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // GLN �������� ������������
            DESADV_fozz.HEAD.FINALRECIPIENT:= HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // GLN ���������� �����������
            DESADV_fozz.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
            // GLN ���������� �����������
            DESADV_fozz.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;

            // ����� ����������
            DESADV_fozz.HEAD.EDIINTERCHANGEID:= '1';

            // ����� �������� ��������
            DESADV_fozz.HEAD.PACKINGSEQUENCE.HIERARCHICALID := 1;

            with ItemsDataSet do
            begin
              First;
              i := 1;
              while not Eof do
              begin
                with DESADV_fozz.HEAD.PACKINGSEQUENCE.POSITION.Add do
                begin
                  // ����� ������� �������
                  POSITIONNUMBER := IntToStr(i);
                  // �������� ��������
                  PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                  // ������� � �� �������
                  PRODUCTIDBUYER := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                  // �������, �� �������������
                  DELIVEREDQUANTITY :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('AmountPartner').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // ������� �����
                  // ??? DELIVEREDUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;
                  // ��������� �������
                  ORDEREDQUANTITY :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('AmountOrder').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  // ʳ������ �����
                  if ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat > 0
                  then
                      BOXESQUANTITY :=
                        StringReplace(FormatFloat('0.##',
                        ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat),
                        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  // ���� ������ ��� ���
                  AMOUNT :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // ֳ�� �������� ��� ���
                  PRICE :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('PriceNoVAT').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // ������ ������� (���,%)
                  TAXRATE :=
                    StringReplace(FormatFloat('0.0###',
                    HeaderDataSet.FieldByName('VATPercent').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                end;
                inc(i);
                Next;
              end;
            end;
  end
  else

  // ������� XML - DESADV_fozz_Amount - ���.� 7183� AND vbUserId <> 1329039  -- ����-�������� EDI
  if (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
 and (HeaderDataSet.FieldByName('isSchema_fozz_desadv').asBoolean = FALSE)
 and (1=1)
  then begin
            // 1.1. ������� XML - fozzy - Amount
            DESADV_fozz_Amount := DOCUMENTINVOICE_TN_XML.NewDocumentInvoice;
            // ����� ����������� ��� ������������
            DESADV_fozz_Amount.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
            // ���� ���������
            DESADV_fozz_Amount.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            //��� ���� ���������: TN - �������� �� �������
            DESADV_fozz_Amount.InvoiceHeader.DocumentFunctionCode := 'TN';
            // ����� �������� �� ��������
            DESADV_fozz_Amount.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
            // ���� ��������
            DESADV_fozz_Amount.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
            // ����� ����������
            DESADV_fozz_Amount.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // ���� ����������
            DESADV_fozz_Amount.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);

            // ���������� ����� ������������ (GLN) ����������� - GLN �������
            if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // ���������� ���������������� ����� - �������
            if HeaderDataSet.FieldByName('INN_To').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
            // ��� ������ - �������
            if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
            // ����� �����������
            DESADV_fozz_Amount.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;


            // ���������� ����� ������������ (GLN) ����������� - GLN ��������
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // ���������� ���������������� ����� - ��������
            if HeaderDataSet.FieldByName('INN_From').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
            // ��� ������ - ��������
            if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
            // ����� ��������
            DESADV_fozz_Amount.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

            // ���������� ����� ������������ (GLN) ����������� - GLN ����� ��������
            if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // �������� ����� �ᒺ��� ��������
            DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
            // ̳��� - ����� ��������
            DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
            // ������ � ����� ������� - ����� ��������
            DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
            // �������� ��� - ����� ��������
            //try DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.PostalCode := StrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString);except end;



            with ItemsDataSet do
            begin
              First;
              i := 1;
              while not Eof do
              begin
                with DESADV_fozz_Amount.InvoiceLines.Add do
                begin
                  // ����� ������� �������
                  LineItem.LineNumber := i;
                  // �������� ��������
                  LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                  // ������� � �� �������
                  LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                  // ������������ ������� �������
                  LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;
                  // �������, �� �������������
                  LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
                  // BuyerUnitOfMeasure
                  LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;


                  // ������ ������� (���,%):
                  LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;
                  // ������ ������� (���,%):
                  LineItem.TaxCategoryCode := 'S';

                end;
                inc(i);
                Next;
              end;
            end;


            // 1.2. ������� XML - fozzy - Price
            AmountSummNoVAT_fozz:= 0;
            VATPercent_fozz:= 0;
            //
            DESADV_fozz_Price := DOCUMENTINVOICE_PRN_XML.NewDocumentInvoice;
            // ����� ����������� ��� ������������
            DESADV_fozz_Price.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
            // ���� ���������
            DESADV_fozz_Price.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            //��� ���� ���������: TN - �������� �� �������
            DESADV_fozz_Price.InvoiceHeader.DocumentFunctionCode := 'PRN';
            // ����� �������� �� ��������
            DESADV_fozz_Price.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
            // ���� ��������
            DESADV_fozz_Price.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
            // �������� ������� ���������
            DESADV_fozz_Price.InvoiceHeader.InvoiceQuantity := 1;
            // ���������� ����� ��������
            DESADV_fozz_Price.InvoiceHeader.InvoiceSequences := 1;
            // ����� ����������
            DESADV_fozz_Price.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // ���� ����������
            DESADV_fozz_Price.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
            // ����� ���������-������� (�������� �� �������)
            //DESADV_fozz_Amount.InvoiceReference.Invoice.OriginalInvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
            // ���� ��������� ���������-������� (�������� �� �������)
            //DESADV_fozz_Price.InvoiceReference.Invoice.OriginalInvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);

            // ���������� ����� ������������ (GLN) ����������� - GLN �������
            if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // ���������� ���������������� ����� - �������
            if HeaderDataSet.FieldByName('INN_To').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
            // ��� ������ - �������
            if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
            // ����� �����������
            DESADV_fozz_Price.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;


            // ���������� ����� ������������ (GLN) ����������� - GLN ��������
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // ���������� ���������������� ����� - ��������
            if HeaderDataSet.FieldByName('INN_From').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
            // ��� ������ - ��������
            if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
            // ����� ��������
            DESADV_fozz_Price.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

            // ���������� ����� ������������ (GLN) ����������� - GLN ����� ��������
            if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // �������� ����� �ᒺ��� ��������
            DESADV_fozz_Price.InvoiceParties.DeliveryPoint.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
            // ̳��� - ����� ��������
            DESADV_fozz_Price.InvoiceParties.DeliveryPoint.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
            // ������ � ����� ������� - ����� ��������
            DESADV_fozz_Price.InvoiceParties.DeliveryPoint.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
            // �������� ��� - ����� ��������
            //try DESADV_fozz_Price.InvoiceParties.DeliveryPoint.PostalCode := StrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString);except end;

            // ���������� ����� ������������ (GLN) ����������� - GLN �������
            if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Payer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // ����� ����������� - �������
            DESADV_fozz_Price.InvoiceParties.Payer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
            // ̳��� - �������
            DESADV_fozz_Price.InvoiceParties.Payer.CityName := '�. ���';
            // ̳��� - �������
            DESADV_fozz_Price.InvoiceParties.Payer.StreetAndNumber := '���. ���������, ���.1';


            with ItemsDataSet do
            begin
              First;
              i := 1;
              while not Eof do
              begin
                with DESADV_fozz_Price.InvoiceLines.Add do
                begin
                  // ����� ������� �������
                  LineItem.LineNumber := i;
                  // �������� ��������
                  LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                  // ������� � �� �������
                  LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                  // ��� ������
                  LineItem.ExternalItemCode := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
                  // ������������ ������� �������
                  LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;
                  // �������, �� �������������
                  LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
                  // BuyerUnitOfMeasure
                  LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;

                  // ֳ�� ���� ������� ��� ���
                  LineItem.InvoiceUnitNetPrice := ItemsDataSet.FieldByName('PriceNoVAT').AsFloat;
                  // ֳ�� ���� ������� ��� ���
                  //LineItem.InvoiceUnitGrossPrice := ItemsDataSet.FieldByName('PriceWVAT').AsFloat;
                  // ������ ������� (���,%):
                  LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;

                  // ������ ������� (���,%):
                  LineItem.TaxCategoryCode := 'S';

                  // ���� � ���
                  LineItem.GrossAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat;
                  // ���� �������
                  LineItem.TaxAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat - ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
                  // ���� ��� ���
                  LineItem.NetAmount := ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
                  //
                  AmountSummNoVAT_fozz:= AmountSummNoVAT_fozz + ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
                  VATPercent_fozz:= ItemsDataSet.FieldByName('VATPercent').AsInteger;
                end;
                inc(i);
                Next;
              end;
            end;
            //
            // ʳ������ ����� � ��������
            DESADV_fozz_Price.InvoiceSummary.TotalLines := i;
            // �������� ���� ��� ���
            DESADV_fozz_Price.InvoiceSummary.TotalNetAmount := AmountSummNoVAT_fozz;
            // ���� ���
            DESADV_fozz_Price.InvoiceSummary.TotalNetAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100 - AmountSummNoVAT_fozz;
            // �������� ���� � ���
            DESADV_fozz_Price.InvoiceSummary.TotalGrossAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100;


  end;

  //else
      begin
            // ������� XML - Desadv - ������ + ����� ���� BOXESQUANTITY
            DESADV := DesadvXML.NewDESADV;
            //
            DESADV.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // ���� ���������
            DESADV.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // ���� ��������
            DESADV.DELIVERYDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            //
            DESADV.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // ���� ����������
            DESADV.ORDERDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
            //
            DESADV.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // ���� ��������
            DESADV.DELIVERYNOTEDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            //
            if HeaderDataSet.FieldByName('INFO_RoomNumber').asString <> ''
            then DESADV.INFO := HeaderDataSet.FieldByName('INFO_RoomNumber').asString;

            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then
                DESADV.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            DESADV.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            DESADV.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName
              ('DELIVERYPLACEGLNCode').asString;
            DESADV.HEAD.SENDER := HeaderDataSet.FieldByName
              ('SenderGLNCode').asString;
            // GLN ���������� �����������
            DESADV.HEAD.RECIPIENT := HeaderDataSet.FieldByName
              ('RecipientGLNCode').asString;
            DESADV.HEAD.PACKINGSEQUENCE.HIERARCHICALID := '1';

            with ItemsDataSet do
            begin
              First;
              i := 1;
              while not Eof do
              begin
                with DESADV.HEAD.PACKINGSEQUENCE.POSITION.Add do
                begin
                  POSITIONNUMBER := i;
                  PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                  PRODUCTIDSUPPLIER := ItemsDataSet.FieldByName('Id').asString;
                  PRODUCTIDBUYER := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                  DESCRIPTION := ItemsDataSet.FieldByName('GoodsName').asString;
                  DELIVEREDQUANTITY :=
                    StringReplace(FormatFloat('0.000',
                    ItemsDataSet.FieldByName('AmountPartner').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  DELIVEREDUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;
                  // ��������� �������
                  ORDEREDQUANTITY :=
                    StringReplace(FormatFloat('0.000',
                    ItemsDataSet.FieldByName('AmountOrder').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // ʳ������ �����
                  if ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat > 0
                  then
                      BOXESQUANTITY :=
                        StringReplace(FormatFloat('0.##',
                        ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat),
                        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  COUNTRYORIGIN := 'UA';
                  PRICE := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('Price').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  // ���� � ���
                  PRICEWITHVAT := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // ���
                  TAXRATE:= StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('VATPercent').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                end;
                inc(i);
                Next;
              end;
            end;

  end;
  //
  // 1. Send
  Stream := TMemoryStream.Create;
  try
   // �� ��� BOXESQUANTITY
   if (HeaderDataSet.FieldByName('isSchema_fozz_desadv').asBoolean = FALSE) then
   begin
    if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
    then begin
              DESADV_fozz_Amount.OwnerDocument.SaveToStream(Stream);
              lNumber:= DESADV_fozz_Amount.InvoiceHeader.InvoiceNumber;
              //
              FileName := 'DOCUMENTINVOICE_TN_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';
         end
    else begin DESADV.OwnerDocument.SaveToStream(Stream);
              lNumber:= DESADV.NUMBER;
              //
              FileName := 'desadv_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';
         end;
    // !��������!
    if (FisEDISaveLocal) or (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
   //or (1=1)
    then
       try
         if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
         then DESADV_fozz_Amount.OwnerDocument.SaveToFile(FileName)
         else DESADV     .OwnerDocument.SaveToFile(FDirectoryError + FileName);
       except
         if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
         then DESADV_fozz_Amount.OwnerDocument.SaveToFile(FileName)
         else DESADV            .OwnerDocument.SaveToFile(FileName);
       end;
    // ����� ��������� �� ftp
    PutStreamToFTP(Stream, FileName, '/outbox');
    //
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;
      FInsertEDIEvents.ParamByName('inMovementId').Value :=HeaderDataSet.FieldByName('EDIId').asInteger;

      if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
      then
        FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
          '�������� DOCUMENTINVOICE_TN ��������� �� FTP'
      else
        FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
          '�������� DESADV ��������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
   end;

  finally
    Stream.Free;
    //
    if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
    then DeleteFile(FileName);
  end;
  //
  //
  // 2.Send XML - only fozzy - ������ DESADV  + ���� BOXESQUANTITY
  if (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
  or (HeaderDataSet.FieldByName('isSchema_fozz_desadv').asBoolean = TRUE)
  then
  try
    Stream := TMemoryStream.Create;

    DESADV.OwnerDocument.SaveToStream(Stream);
    lNumber:= DESADV.NUMBER;
    //
    FileName := 'desadv_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';

    // !��������!
       try
         DESADV     .OwnerDocument.SaveToFile(FDirectoryError + FileName);
       except
         DESADV     .OwnerDocument.SaveToFile(FileName);
       end;
    // ����� ��������� �� ftp
    PutStreamToFTP(Stream, FileName, '/outbox');
    //
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;

      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
        FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
          '�������� DESADV ��������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    Stream.Free;
    //
    DeleteFile(FileName);
  end;

  // 3.Send XML - fozzy - Price
  if (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
 and (HeaderDataSet.FieldByName('isSchema_fozz_desadv').asBoolean = FALSE)
  then
  try
    Stream := TMemoryStream.Create;
    //
    DESADV_fozz_Price.OwnerDocument.SaveToStream(Stream);
    lNumber:= DESADV_fozz_Price.InvoiceHeader.InvoiceNumber;
    //
    FileName := 'DOCUMENTINVOICE_PRN_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';
    // !��������!
       try
         DESADV_fozz_Price.OwnerDocument.SaveToFile(FileName)
       except
         DESADV_fozz_Price.OwnerDocument.SaveToFile(FileName)
       end;
    // ����� ��������� �� ftp
    PutStreamToFTP(Stream, FileName, '/outbox');
    //
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;

      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
      then
        FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
          '�������� DOCUMENTINVOICE_PRN ��������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    Stream.Free;
    //
    DeleteFile(FileName);
  end;

end;

destructor TEDI.Destroy;
begin
  if not VarIsNull(ComSigner) then
     ComSigner.Finalize;
  ComSigner := null;

  FreeAndNil(FIdFTP);
  FreeAndNil(FConnectionParams);
  FreeAndNil(FInsertEDIEvents);
  FreeAndNil(FUpdateDeclarAmount);
  FreeAndNil(FInsertEDIFile);
  FreeAndNil(FUpdateDeclarFileName);
  FreeAndNil(FUpdateEDIVchasnoEDI);
  FreeAndNil(FInsertEDIEvents);
  FreeAndNil(FInsertEDIEventsDoc);
  inherited;
end;

procedure TEDI.ErrorLoad(Directory: string);
var
    List: TStringList;
    Stream: TStringStream;
    i: integer;
    DESADV: IXMLDESADVType;
    Invoice: IXMLINVOICEType;
begin
  FTPSetConnection;
  // ��������� ����� � FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('�������� ������', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            // ���� ������ ����� ����� desadv, � ��������� .xml. Desadv
            if (lowercase(copy(List[i], 1, 6)) = 'desadv') and
              (copy(List[i], Length(List[i]) - 3, 4) = '.xml') then
            begin
              Stream.Clear;
              FIdFTP.Get(List[i], Stream);
              DESADV := LoadDESADV(Stream.DataString);

              FUpdateEDIErrorState.ParamByName('inMovementId').Value := 0;
              FUpdateEDIErrorState.ParamByName('inDocType').Value := 'desadv';
              FUpdateEDIErrorState.ParamByName('inOperDate').Value := VarToDateTime(DESADV.ORDERDATE);
              FUpdateEDIErrorState.ParamByName('inInvNumber').Value := DESADV.ORDERNUMBER;
              FUpdateEDIErrorState.ParamByName('inIsError').Value := true;

              FUpdateEDIErrorState.Execute;
              if FUpdateEDIErrorState.ParamByName('IsFind').Value then
                try
                  FIdFTP.ChangeDir('/archive');
                  FIdFTP.Put(Stream, 'error_' + List[i]);
                finally
                  FIdFTP.ChangeDir(Directory);
                  FIdFTP.Delete(List[i]);
                end;
            end;
            // ���� ������ ����� ����� desadv, � ��������� .xml. Desadv
            if (lowercase(copy(List[i], 1, 7)) = 'invoice') and
              (copy(List[i], Length(List[i]) - 3, 4) = '.xml') then
            begin
              Stream.Clear;
              FIdFTP.Get(List[i], Stream);
              Invoice := LoadINVOICE(Stream.DataString);

              FUpdateEDIErrorState.ParamByName('inMovementId').Value := 0;
              FUpdateEDIErrorState.ParamByName('inDocType').Value := 'invoice';
              FUpdateEDIErrorState.ParamByName('inOperDate').Value := VarToDateTime(DESADV.ORDERDATE);
              FUpdateEDIErrorState.ParamByName('inInvNumber').Value := DESADV.ORDERNUMBER;
              FUpdateEDIErrorState.ParamByName('inIsError').Value := true;

              FUpdateEDIErrorState.Execute;
              if FUpdateEDIErrorState.ParamByName('IsFind').Value then
                try
                  FIdFTP.ChangeDir('/archive');
                  FIdFTP.Put(Stream, 'error_' + List[i]);
                finally
                  FIdFTP.ChangeDir(Directory);
                  FIdFTP.Delete(List[i]);
                end;
            end;
            IncProgress;
          end;
        finally
          Finish;
        end;
    finally
      FIdFTP.Disconnect;
      List.Free;
      Stream.Free;
    end;
  end;
end;

procedure TEDI.FTPSetConnection;
begin
  FIdFTP.Username := ConnectionParams.User.asString;
  FIdFTP.Password := ConnectionParams.Password.asString;
  FIdFTP.Host := ConnectionParams.Host.asString;
  FIdFTP.Passive := true;
  FIdFTP.ListenTimeout := 600;
  FIdFTP.TransferTimeOut := 600;
  FIdFTP.ReadTimeOut := 600000;
end;

function TEDI.fIsExistsOrder(lFileName : String) : Boolean;
begin
    FExistsOrder.ParamByName('inFileName').Value := lFileName;
    FExistsOrder.Execute;
    Result:= FExistsOrder.ParamByName('outIsExists').Value = TRUE;
end;

procedure TEDI.InsertUpdateOrder(ORDER: OrderXML.IXMLORDERType;
  spHeader, spList: TdsdStoredProc; lFileName : String);
var
  MovementId, GoodsPropertyId: integer;
  isMetro : Boolean;
  i: integer;
  s : String;
  s1, s2 : String;
begin
  with spHeader, ORDER do
  begin
    ParamByName('inOrderInvNumber').Value := NUMBER;
    ParamByName('inOrderOperDate').Value := VarToDateTime(Date);

    ParamByName('inGLNPlace').Value := HEAD.DELIVERYPLACE;
    ParamByName('inGLN').Value := HEAD.BUYER;

    Execute;
    MovementId := ParamByName('MovementId').Value;
    GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
    isMetro := ParamByName('isMetro').Value;
  end;
  for i := 0 to ORDER.HEAD.POSITION.Count - 1 do
    with spList, ORDER.HEAD.POSITION[i] do
    begin
      ParamByName('inMovementId').Value := MovementId;
      ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
      //
      s:= CHARACTERISTIC.DESCRIPTION;
      if Pos(char(189), s) > 0
      then begin System.Insert('1/2', s, Pos(char(189), s) + 1);System.Delete(s, Pos(char(189), s), 1);end;
      ParamByName('inGoodsName').Value := s;
      //

      try if isMetro = TRUE
          then ParamByName('inGLNCode').Value := BUYERPARTNUMBER //PRODUCTIDBUYER
          else ParamByName('inGLNCode').Value := PRODUCTIDBUYER;
      except
            {try s1 := BUYERPARTNUMBER; //PRODUCTIDBUYER
                ShowMessage (s1);
                s2 := PRODUCTIDBUYER;
                ShowMessage (s2);
            except
                ShowMessage ('not');
            end;}

      end;
      try ParamByName('inAmountOrder').Value := gfStrToFloat(ORDEREDQUANTITY); except ParamByName('inAmountOrder').Value := 0; end;
      try ParamByName('inPriceOrder').Value := gfStrToFloat(ORDERPRICE); except ParamByName('inPriceOrder').Value := 0; end;
      Execute;
    end;
    //
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :='{'+IntToStr(i)+'}�������� ORDER �� EDI ��������� _'+lFileName+'_';
    FInsertEDIEvents.Execute;
end;

procedure TEDI.INVOICESave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  INVOICE: IXMLINVOICEType;
  DOCUMENTINVOICE_DRN: DOCUMENTINVOICE_DRN_XML.IXMLDocumentInvoiceType;
  Stream: TStream;
  i, nInt: integer;
  FileName, lNumber: string;
  AmountSummNoVAT_fozz: Double;
  VATPercent_fozz: Integer;
  cDS : Char;
begin
  if HeaderDataSet.FieldByName('isDOCUMENTINVOICE_DRN').asBoolean = TRUE then
  begin
    cDS := FormatSettings.DecimalSeparator;
    try
      FormatSettings.DecimalSeparator := '.';
      // 1.2. ������� XML - fozzy - Price
      AmountSummNoVAT_fozz:= 0;
      VATPercent_fozz:= 0;
      //
      DOCUMENTINVOICE_DRN := DOCUMENTINVOICE_DRN_XML.NewDocumentInvoice;
      // ����� ����������� ��� ������������
      DOCUMENTINVOICE_DRN.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
      // ���� ���������
      DOCUMENTINVOICE_DRN.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
      //��� ���� ���������: TN - �������� �� �������
      DOCUMENTINVOICE_DRN.InvoiceHeader.DocumentFunctionCode := 'DRN';
      // ����� �������� �� ��������
      DOCUMENTINVOICE_DRN.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
      // ���� ��������
      DOCUMENTINVOICE_DRN.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
      // ����� ����������
      DOCUMENTINVOICE_DRN.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
      // ���� ����������
      DOCUMENTINVOICE_DRN.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
      // ����� ���������-������� (�������� �� �������)
      //DOCUMENTINVOICE_DRN.InvoiceReference.Invoice.OriginalInvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
      // ���� ��������� ���������-������� (�������� �� �������)
      //DOCUMENTINVOICE_DRN.InvoiceReference.Invoice.OriginalInvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);

      // ���������� ����� ������������ (GLN) ����������� - GLN �������
      if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
      // ���������� ���������������� ����� - �������
      if HeaderDataSet.FieldByName('INN_To').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
      // ��� ������ - �������
      if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
      // ����� �����������
      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;

      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
      if TryStrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString, nInt) and (nInt <> 0) then
        DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.PostalCode := IntToStr(nInt);
      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.PhoneNumber := SplitString(HeaderDataSet.FieldByName('Phone_To').asString, ',')[0];

      // ���������� ����� ������������ (GLN) ����������� - GLN ��������
      if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
      // ���������� ���������������� ����� - ��������
      if HeaderDataSet.FieldByName('INN_From').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
      // ��� ������ - ��������
      if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
      // ����� ��������
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_From').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.CityName := HeaderDataSet.FieldByName('CityName_From').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.PostalCode := HeaderDataSet.FieldByName('PostalCode_From').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.PhoneNumber := HeaderDataSet.FieldByName('Phone_From').asString;

      // ���������� ����� ������������ (GLN) ����������� - GLN ����� ��������
      if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
      // �������� ����� �ᒺ��� ��������
      DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
      // ̳��� - ����� ��������
      DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
      // ������ � ����� ������� - ����� ��������
      DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
      // �������� ��� - ����� ��������
      //try DESADV_fozz_Price.InvoiceParties.DeliveryPoint.PostalCode := StrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString);except end;

      with ItemsDataSet do
      begin
        First;
        i := 1;
        while not Eof do
        begin
          with DOCUMENTINVOICE_DRN.InvoiceLines.Add do
          begin
            // ����� ������� �������
            LineItem.LineNumber := i;
            // �������� ��������
            LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
            // ������� � �� �������
            LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
            // ��� ������
            LineItem.ExternalItemCode := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
            // ������������ ������� �������
            LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;

            // �������, �� �������������
            LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
            // BuyerUnitOfMeasure
            LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;

            // ֳ�� ���� ������� ��� ���
            LineItem.InvoiceUnitNetPrice := ItemsDataSet.FieldByName('PriceNoVAT').AsFloat;
            // ֳ�� ���� ������� � ���
            LineItem.InvoiceUnitGrossPrice := RoundTo(ItemsDataSet.FieldByName('PriceWVAT').AsFloat, -2);

            // ������ ������� (���,%):
            LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;
            LineItem.TaxCategoryCode := 'S';

            // ���� � ���
            LineItem.GrossAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat;
            // ���� �������
            LineItem.TaxAmount := RoundTo(ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat - ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat, -2);
            // ���� ��� ���
            LineItem.NetAmount := ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
            //
            AmountSummNoVAT_fozz:= AmountSummNoVAT_fozz + ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
            VATPercent_fozz:= ItemsDataSet.FieldByName('VATPercent').AsInteger;
          end;
          inc(i);
          Next;
        end;
      end;
      //
      // ʳ������ ����� � ��������
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalLines := i;
      // �������� ���� ��� ���
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalNetAmount := RoundTo(AmountSummNoVAT_fozz, -2);
      // ���� ���
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalTaxAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100 - RoundTo(AmountSummNoVAT_fozz, -2);
      // �������� ���� � ���
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalGrossAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100;


      //
      //
      Stream := TMemoryStream.Create;
      try
        DOCUMENTINVOICE_DRN.OwnerDocument.SaveToStream(Stream);
        lNumber:= DOCUMENTINVOICE_DRN.InvoiceHeader.InvoiceNumber;
        //
        FileName := 'DOCUMENTINVOICE_DRN_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';
        // !��������!
//        if FisEDISaveLocal
//        then
           try
             DOCUMENTINVOICE_DRN.OwnerDocument.SaveToFile(FileName)
           except
           end;
        // ����� ��������� �� ftp
        PutStreamToFTP(Stream, FileName, '/outbox');
        //
        if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
        begin
          FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
          FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
          FUpdateEDIErrorState.Execute;

          FInsertEDIEvents.ParamByName('inMovementId').Value :=
            HeaderDataSet.FieldByName('EDIId').asInteger;
          FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
            '�������� DOCUMENTINVOICE ��������� �� FTP';
          FInsertEDIEvents.Execute;
        end;
      finally
        Stream.Free;
        //
        DeleteFile(FileName);
      end;
    finally
      FormatSettings.DecimalSeparator := cDS;
    end;
  end else
  begin

    INVOICE := NewINVOICE;
    // ������� XML
    INVOICE.DOCUMENTNAME := '380';
    INVOICE.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
    INVOICE.Date := FormatDateTime('yyyy-mm-dd',
      HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
    INVOICE.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
      HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
    INVOICE.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
    INVOICE.ORDERDATE := FormatDateTime('yyyy-mm-dd',
      HeaderDataSet.FieldByName('OperDateOrder').asDateTime);//!!!OperDateOrder!!!
    INVOICE.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
    INVOICE.DELIVERYNOTEDATE := FormatDateTime('yyyy-mm-dd',
      HeaderDataSet.FieldByName('OperDatePartner').asDateTime);

    INVOICE.GOODSTOTALAMOUNT :=
      StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT')
      .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    INVOICE.POSITIONSAMOUNT :=
      StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSumm')
      .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    INVOICE.VATSUM := StringReplace(FormatFloat('0.00',
      HeaderDataSet.FieldByName('SummVAT').AsFloat),
      FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    INVOICE.INVOICETOTALAMOUNT :=
      StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSumm')
      .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    INVOICE.TAXABLEAMOUNT :=
      StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT')
      .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    INVOICE.VAT := StringReplace(FormatFloat('0',
      HeaderDataSet.FieldByName('VATPercent').AsFloat),
      FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

    if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
    then
        INVOICE.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
    INVOICE.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
    INVOICE.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName
      ('DELIVERYPLACEGLNCode').asString;
    INVOICE.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
    INVOICE.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;

    with ItemsDataSet do
    begin
      First;
      i := 1;
      while not Eof do
      begin
        with INVOICE.HEAD.POSITION.Add do
        begin
          POSITIONNUMBER := IntToStr(i);
          PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
          PRODUCTIDBUYER := ItemsDataSet.FieldByName
            ('ArticleGLN_Juridical').asString;
          INVOICEUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;
          INVOICEDQUANTITY :=
            StringReplace(FormatFloat('0.000',
            ItemsDataSet.FieldByName('AmountPartner').AsFloat),
            FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
          UNITPRICE := StringReplace(FormatFloat('0.00',
            ItemsDataSet.FieldByName('PriceNoVAT').AsFloat),
            FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
          PRICEWITHVAT :=
            StringReplace(FormatFloat('0.00',
            ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
            FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
          GROSSPRICE :=
            StringReplace(FormatFloat('0.00',
            ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
            FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
          AMOUNT := StringReplace(FormatFloat('0.00',
            ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat),
            FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
          AMOUNTTYPE := '203';
          TAX.FUNCTION_ := '7';
          TAX.TAXTYPECODE := 'VAT';
          TAX.TAXRATE := INVOICE.VAT;
          TAX.TAXAMOUNT :=
            StringReplace(FormatFloat('0.00',
            ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat -
            ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat),
            FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
          TAX.CATEGORY := 'S';
        end;
        inc(i);
        Next;
      end;
    end;

    Stream := TMemoryStream.Create;
    INVOICE.OwnerDocument.SaveToStream(Stream);
    FileName := 'invoice_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + INVOICE.NUMBER + '.xml';
    if FisEDISaveLocal then
       try
         INVOICE.OwnerDocument.SaveToFile(FDirectoryError + FileName);
       except
         INVOICE.OwnerDocument.SaveToFile(FileName);
       end;
    try
      PutStreamToFTP(Stream, FileName, '/outbox');
      if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
      begin
        FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
        FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
        FUpdateEDIErrorState.Execute;
        FInsertEDIEvents.ParamByName('inMovementId').Value :=
          HeaderDataSet.FieldByName('EDIId').asInteger;
        FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
          '�������� INVOICE ��������� �� FTP';
        FInsertEDIEvents.Execute;
      end;
    finally
      Stream.Free;
    end;
  end;
end;

procedure TEDI.IFTMINSave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  IFTMIN_fozz: IftminFozzXML.IXMLIFTMINType;
  Stream: TStream;
  i: integer;
  FileName: string;
  lNumber: string;
begin
  //
  if  (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = FALSE)
   OR (HeaderDataSet.FieldByName('isSchema_fozz_desadv').asBoolean = TRUE)
  then exit;
  //
            // ������� XML
            IFTMIN_fozz := IFTMINFozzXML.NewIFTMIN;
            // ����� ��������� ������� ���� ���������� ������� X_Y, �� � � �� ���������� ����� ������, ��� ��� �� ���������� Y � �� �������� ������� �����, ��� ���� �� ���������� (�������� �-�� - 1, ����������� - 99). � ������� ���� ����� ��� ���������� Y. ��������� 2_5.
            IFTMIN_fozz.NUMBER := '1_1';
            // ���� ���������
            IFTMIN_fozz.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // ���� ��������
            IFTMIN_fozz.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // ��� ��������
            IFTMIN_fozz.DELIVERYTIME := '00:00';
            // ��� ���������: O � ��������, R � ������, D � ��������, F � ����������� ������, PO � ���������, OS � ����� �� ������/���������
            IFTMIN_fozz.DOCTYPE := 'O';
            //��������� �������� - �ON�
            IFTMIN_fozz.DOCUMENT.DOCITEM.DOCTYPE:='ON';
            // ����� ����������
            IFTMIN_fozz.DOCUMENT.DOCITEM.DOCNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            //
            // GLN �����������������
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then IFTMIN_fozz.HEAD.CONSIGNOR := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // GLN ���� ��������
            IFTMIN_fozz.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // GLN ���������� �����������
            IFTMIN_fozz.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
            // GLN ���������� �����������
            IFTMIN_fozz.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;
            //
            //
            with ItemsDataSet do
            begin
              First;
              i := 1;
              //while not Eof do
              //begin
                with IFTMIN_fozz.HEAD.POSITIONS do
                begin
                  // ����� ������� - ������� ����� ���� �������
                  POSITIONNUMBER := IntToStr(i);
                  // ��� ��������
                  PACKAGETYPE := '201';
                  // ʳ������ ��������
                  PACKAGEQUANTITY :=
                    StringReplace(FormatFloat('0.####',
                    HeaderDataSet.FieldByName('WeighingCount').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // ���� - ����������������
                  PACKAGEWIGHT :=
                    StringReplace(FormatFloat('0.00##',
                    24000),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  //����������� ������� ��������
                  MAXPACKAGEQUANTITY :='32';

                end;
                inc(i);
                Next;
              //end;
            end;
  //
  //
  Stream := TMemoryStream.Create;
  try
    if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
    then begin
              IFTMIN_fozz.OwnerDocument.SaveToStream(Stream);
              lNumber:= HeaderDataSet.FieldByName('InvNumber').asString;
         end;
    //
    FileName := 'Iftmin_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';
    // !��������!
    if (FisEDISaveLocal) or (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
    then
       try
         IFTMIN_fozz.OwnerDocument.SaveToFile(FileName)
       except
         IFTMIN_fozz.OwnerDocument.SaveToFile(FDirectoryError + FileName)
       end;
    // ����� ��������� �� ftp
    PutStreamToFTP(Stream, FileName, '/outbox');
    //
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;

      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '�������� IFTMIN ��������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TEDI.InitializeComSigner (DebugMode: boolean; UserSign, UserSeal, UserKey : string);
var
  privateKey: string;
  FileName, Error: string;

begin
  ComSigner := CreateOleObject('EUTaxServiceFile.Library.1');

  ComSigner.Initialize(caType);

  if DebugMode then begin
     ComSigner.SetUIMode(true);
     ComSigner.SetSettings;
  end;

  ComSigner.SetUIMode(false);
//ComSigner.SetUIMode(TRUE);

  try
  	ComSigner.ResetPrivateKey(euKeyTypeAccountant);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('������ ���������� Exite. EUTaxService.ResetPrivateKey(euKeyTypeAccountant)'#10#13 +
        E.Message);
    end;
  end;

  try
  	ComSigner.ResetPrivateKey(euKeyTypeDirector);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('������ ���������� Exite. EUTaxService.ResetPrivateKey(euKeyTypeAccountant)'#10#13 +
        E.Message);
    end;
  end;

  try
  	ComSigner.ResetPrivateKey(euKeyTypeDigitalStamp);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('������ ���������� Exite. EUTaxService.ResetPrivateKey(euKeyTypeAccountant)'#10#13 +
        E.Message);
    end;
  end;
// exit;
  try
    // 1.��������� ������
    if UserSign <> ''
    then if ExtractFilePath(UserSign) <> ''
         then FileName := UserSign
         else FileName := ExtractFilePath(ParamStr(0)) + UserSign
    else FileName := ExtractFilePath(ParamStr(0)) + '���� - ������ �.�..ZS2';
    // ��������
    if not FileExists(FileName) then raise Exception.Create('���� �� ������ : <'+FileName+'>');

	  ComSigner.SetPrivateKeyFile (euKeyTypeAccountant, FileName, '24447183', false); // ���������
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('������ ���������� Exite.ComSigner.SetPrivateKeyFile.euKeyTypeAccountant'
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // 2.��������� ������
    if UserSeal <> ''
    then FileName := UserSeal
    else FileName := ExtractFilePath(ParamStr(0))
                  + '���� - ��� �_������ - ���������� � ��������� �_����_�����_��� ����.ZS2';
    // ��������
    if not FileExists(FileName) then raise Exception.Create('���� �� ������ : <'+FileName+'>');

	  ComSigner.SetPrivateKeyFile (euKeyTypeDigitalStamp, FileName, '24447183', false); // ������
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('������ ���������� Exite.ComSigner.SetPrivateKeyFile.euKeyTypeDigitalStamp'
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    //3. ��������� ������
    if UserKey <> ''
    then FileName := UserKey
    else FileName := ExtractFilePath(ParamStr(0))
                   + '���� - ��� ���������� - ���������� � ��������� �_����_�����_��� ����.ZS2';
    // ��������
    if not FileExists(FileName) then raise Exception.Create('���� �� ������ : <'+FileName+'>');

	  ComSigner.SetPrivateKeyFile (euKeyTypeDigitalStamp, FileName, '24447183', false); // ������
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('������ ���������� Exite.ComSigner.SetPrivateKeyFile.euKeyTypeDigitalStamp'
        + FileName + #10#13 + E.Message);
    end;
  end;

end;

function TEDI.InsertUpdateComDoc(�������������������
  : IXML�������������������Type; spHeader, spList: TdsdStoredProc): integer;
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
  Param: IXML��������Type;
begin
  with spHeader, ������������������� do
  begin
    ParamByName('inOrderInvNumber').Value := ���������.���������������;
    ParamByName('inComDocDate').Value := ConvertEDIDate(���������.�������������);
    if ���������.�������������� <> '' then
      ParamByName('inOrderOperDate').Value :=
        ConvertEDIDate(���������.��������������)
    else
      ParamByName('inOrderOperDate').Value :=
        ConvertEDIDate(���������.�������������);
    ParamByName('inPartnerInvNumber').Value := ���������.��������������;
    if ���������.���������������� = '007' then begin
       if ���������.���ϳ������.������������� <> '' then
          ParamByName('inOperDateSaleLink').Value :=
               ConvertEDIDate(���������.���ϳ������.�������������);

       ParamByName('inInvNumberSaleLink').Value :=
           ���������.���ϳ������.��������������;
       ParamByName('inGLNPlace').Value := '';
       for i := 0 to ���������.Count - 1 do
           if ���������.��������[i].����� = '����� ��������' then begin
              ParamByName('inGLNPlace').Value := ���������.��������[i].NodeValue;
              break;
           end;

       if ���������.���ϳ������.������������� = '' then
          ParamByName('inPartnerOperDate').Value :=
            ConvertEDIDate(���������.�������������)
       else
          ParamByName('inPartnerOperDate').Value :=
            ConvertEDIDate(���������.���ϳ������.�������������)
    end
    else
       ParamByName('inPartnerOperDate').Value :=
         ConvertEDIDate(���������.�������������);
    if ���������.���������������� = '012' then
    begin
      ParamByName('inGLNPlace').Value := '';
      ParamByName('inDesc').Value := 'Return';
      ParamByName('inInvNumberTax').Value :=
        ���������.ParamByName('����� ��������� ��������').NodeValue;
      if not VarIsNull(���������.ParamByName('���� ��������� ��������')
        .NodeValue) then
        ParamByName('inOperDateTax').Value :=
          ConvertEDIDate(���������.ParamByName('���� ��������� ��������')
          .NodeValue);
      ParamByName('inInvNumberSaleLink').Value :=
        ���������.���ϳ������.��������������;
      ParamByName('inOperDateSaleLink').Value :=
        ConvertEDIDate(���������.���ϳ������.�������������);
    end
    else begin
      ParamByName('inDesc').Value := 'Sale';
      ParamByName('inInvNumberTax').Value := '';
      //ParamByName('inInvNumberSaleLink').Value := '';
    end;

    for i := 0 to �������.Count - 1 do
      if �������.����������[i].����������������� = '��������' then
      begin
        ParamByName('inOKPO').Value := �������.����������[i].��������������;
        ParamByName('inJuridicalName').Value := �������.����������[i]
          .����������������;
      end;
    Execute;
    MovementId := ParamByName('MovementId').Value;
    GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
  end;
  with spList, �������������������.������� do
    for i := 0 to GetCount - 1 do
    begin
      with �����[i] do
      begin
        ParamByName('inMovementId').Value := MovementId;
        ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
        ParamByName('inGoodsName').Value := Copy(TRIM(������������),1,254);
        ParamByName('inGLNCode').Value := ��������������;
        if �������������������.���������.���������������� = '012' then
          ParamByName('inAmountPartner').Value :=
            gfStrToFloat(������������.ʳ������)
        else
          ParamByName('inAmountPartner').Value :=
            gfStrToFloat(��������ʳ������);
        ParamByName('inSummPartner').Value :=
          gfStrToFloat(�������������.����������);
        ParamByName('inPricePartner').Value := gfStrToFloat(������ֳ��);
        Execute;
      end;
    end;
  Result := MovementId
end;

function lpStrToDateTime(DateTimeString: string): TDateTime;
begin
  Result := VarToDateTime(DateTimeString)
end;

procedure AddToLog(S: string);
var
  LogStr: string;
  LogFileName: string;
  LogFile: TextFile;
begin
  Application.ProcessMessages;
  LogStr := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + S;
  //LogMemo.Lines.Add(LogStr);
  LogFileName := ChangeFileExt(Application.ExeName, '') + '_' + FormatDateTime('yyyymmdd', Date) + '_del.log';

  AssignFile(LogFile, LogFileName);

  if FileExists(LogFileName) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  Writeln(LogFile, LogStr);
  CloseFile(LogFile);
  Application.ProcessMessages;
end;

procedure TEDI.OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String;
  StartDate, EndDate: TDateTime);
var
  List: TStrings;
  //s : String;
  i: integer;
  Stream: TStringStream;
  ORDER: OrderXML.IXMLORDERType;
  DocData: TDateTime;
  fIsDelete : Boolean; // add 10.08.2018
  s, err_msg : String;
  ii: Integer;
  ii_begin: Integer;
begin
  ii_begin:=0;
  try
    AddToLog('');
    AddToLog('');
    AddToLog('1.1. start OrderLoad');
    FTPSetConnection;

    AddToLog('1.2. start FIdFTP.Connect');
    // ��������� ����� � FTP
    FIdFTP.Connect;

    if FIdFTP.Connected
    then AddToLog('1.3. end FIdFTP.Connect = true')
    else AddToLog('1.3. end FIdFTP.Connect = false');

    if FIdFTP.Connected then
    begin

      FIdFTP.ChangeDir(Directory);
      AddToLog('1.4. FIdFTP.ChangeDir');

      List := TStringList.Create;
      AddToLog('1.5. TStringList.Create');

      Stream := TStringStream.Create;
      AddToLog('1.6. TStringStream.Create');

      try
        err_msg:= '';
        ii:=0;
        //
        AddToLog('1.7. start FIdFTP.List');
        FIdFTP.List(List, '', false);
        AddToLog('1.8. end FIdFTP.List count = '+IntToStr(List.Count));

        if List.Count = 0 then
          exit;
        with TGaugeFactory.GetGauge('�������� ������', 0, List.Count) do
          try
            AddToLog('2.1. Start');
            Start;

            AddToLog('2.2. finish Start');
            AddToLog('2.3. List.Count = ' + IntToStr(List.Count));

            for i := 0 to List.Count - 1 do
            begin

              s:= List[i];
              //AddToLog('2.4. i = (' + IntToStr(i)+')');
              //AddToLog('2.5. List[i] = ' + s);


              //if (copy(s, 1, 5) = 'order') then showMessage(s);
              // ���� ������ ����� ����� order � ��������� .xml
              if ((copy(List[i], 1, 5) = 'order') and (copy(List[i], Length(List[i]) - 3, 4) = '.xml'))
               or((AnsiUpperCase(copy(List[i], 1, 11)) = AnsiUpperCase('inbox\order')) and (copy(List[i], Length(List[i]) - 3, 4) = '.xml'))
              then begin

                AddToLog('2.4. i = (' + IntToStr(i)+')');
                AddToLog('2.5. List[i] = ' + s);

                if fIsExistsOrder(List[i]) = true then
                   if err_msg = '' then err_msg:= '--- ignore file <'+ List[i]+')'
                   else
                else
                begin
                  DocData := gfStrFormatToDate(copy(List[i], 7, 8), 'yyyymmdd');
                  if (StartDate <= DocData) and (DocData <= EndDate) then
                  begin

                    ii_begin:= ii_begin + 1;
                    AddToLog('3.1. ����� ���� � ��� ii_begin = ' + IntToStr(ii_begin));

                    // ����� ���� � ���
                    Stream.Clear;

                    if FIdFTP.Connected
                    then AddToLog('3.2. check FIdFTP.Connected = true')
                    else AddToLog('3.2. check FIdFTP.Connected = false')
                    ;

                    if not FIdFTP.Connected then
                    begin
                      FIdFTP.Connect;
                      //
                      if FIdFTP.Connected
                      then AddToLog('3.3. try FIdFTP.Connected = true')
                      else AddToLog('3.3. try FIdFTP.Connected = false')
                      ;
                    end;

                    FIdFTP.ChangeDir(Directory);
                    AddToLog('3.3. FIdFTP.ChangeDir = ' + Directory);

                    FIdFTP.Get(List[i], Stream);
                    AddToLog('3.4. FIdFTP.Get');

                    ORDER := OrderXML.LoadORDER(Utf8ToAnsi(Stream.DataString));
                    AddToLog('3.5. OrderXML.LoadORDER');

                    // ��������� � �������
//  gc_isDebugMode:= TRUE;
//  gc_isShowTimeMode:= TRUE;
                    InsertUpdateOrder(ORDER, spHeader, spList, List[i]);

                    AddToLog('3.6. InsertUpdateOrder = ok');

                    //
                    //�������� ����� ��������
                    if Assigned(spHeader.Params.ParamByName('gIsDelete'))
                    then fIsDelete:= spHeader.ParamByName('gIsDelete').Value
                    else fIsDelete:= false;

                    AddToLog('3.7. ������ ��������� ���� � ���������� Archive');
                    // ������ ��������� ���� � ���������� Archive
                    if (DocData < Date) or (fIsDelete = true)
                    then
                       try
                         // FIdFTP.ChangeDir('/archive');
                         // FIdFTP.Put(Stream, List[i]);
                         //err_msg:= '';
                         try
                             AddToLog('start ' + List[i]);
                             FIdFTP.Delete(List[i]);
                             AddToLog('try - 1  = ok');
                         except
                              try FIdFTP.Delete(List[i]); AddToLog('try - 2  = ok'); except FIdFTP.Delete(List[i]); AddToLog('try - 3  = ok'); end;
                         end;
                       except
                         on E: Exception do begin
                           ii:= ii + 1;
                           err_msg:= '(' + intToStr(ii) + ')' + 'Delete - ' + s + ' : ' + E.Message;
                           AddToLog('err:  ' + err_msg);
                           //if err_msg = ''
                           //then err_msg:= '(' + intToStr(ii) + ')' + 'Delete - ' + s + ' : ' + E.Message
                           //else err_msg:= '(' + intToStr(ii) + ')' + err_msg;
                           //raise Exception.Create (err_msg);
                           //ShowMessage(err_msg);
                         end;
                       //finally
                       //  FIdFTP.ChangeDir(Directory);
                       //  FIdFTP.Delete(List[i]);
                       end;
                    //
                    AddToLog('3.8. finish - ��������� ���� � ���������� Archive');

                  end;
                end;
              end;
              //
              IncProgress;
            end;
          finally
            Finish;
          end;
      finally

        AddToLog('4.1. FIdFTP.Disconnect');

        FIdFTP.Disconnect;
        List.Free;
        Stream.Free;
        //
        if (err_msg <> '') then raise Exception.Create (err_msg);

        AddToLog('4.2. check err_msg = <'+err_msg+'>');
        AddToLog('4.3. ��������� = <'+IntToStr(ii_begin)+'>');

      end;
    end;
  except
    on E: Exception do begin

        AddToLog('5. !!!ERROR!!! = <'+err_msg+'>');

        if (err_msg <> '')
        then raise Exception.Create (err_msg)
        else raise Exception.Create(E.Message);
    end;
  end;

   AddToLog('6. !ok OrderLoad = ok!');
   AddToLog('');
   AddToLog('');
end;

procedure TEDI.ORDRSPSave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  ORDRSP: ORDRSPXML.IXMLORDRSPType;
  ORDRSP_fozz: OrderSpFozzXML.IXMLORDRSPType;
  Stream: TStream;
  i: integer;
  FileName: string;
  lNumber: string;
begin

  if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
  then begin
          // ������� XML
          ORDRSP_fozz := OrderSpFozzXML.NewOrderSp;
          // ����� ������������ ����������
          ORDRSP_fozz.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
          // ���� ���������
          ORDRSP_fozz.Date := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          // ��� ��������� ���������
          ORDRSP_fozz.Time := FormatDateTime('hh:mm',HeaderDataSet.FieldByName('OperDate_insert').asDateTime);
          // ����� ����������
          ORDRSP_fozz.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
          // ���� ����������
          ORDRSP_fozz.ORDERDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
          // ���� ��������
          ORDRSP_fozz.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          // ��� ��������
          ORDRSP_fozz.DELIVERYTIME := '00:00';
          // ��� ������
          ORDRSP_fozz.CURRENCY := 'UAH';
          // ����� �������� �� ��������
          ORDRSP_fozz.CAMPAIGNNUMBER := HeaderDataSet.FieldByName('ContractName').asString;
          // 4 - �������� ������, 5 - ����� ���������, 29 - �������� ��������, 27 - �������� �� ��������
          ORDRSP_fozz.ACTION := 29;
          //
          // GLN �������������
          if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
          then ORDRSP_fozz.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
          // GLN �������
          ORDRSP_fozz.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
          // GLN ���� ��������
          ORDRSP_fozz.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
          // GLN ��������
          ORDRSP_fozz.HEAD.INVOICEPARTNER:= HeaderDataSet.FieldByName('BuyerGLNCode').asString;
          // GLN ���������� �����������
          ORDRSP_fozz.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
          // GLN ���������� �����������
          ORDRSP_fozz.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;

          with ItemsDataSet do
          begin
            First;
            i := 1;
            while not Eof do
            begin
              with ORDRSP_fozz.HEAD.POSITION.Add do
              begin
                // ����� ������� �������
                POSITIONNUMBER := IntToStr(i);
                // �����-��� ��������
                PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                // ������� � �� �������
                PRODUCTIDBUYER := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                // ���� ��������
                DESCRIPTION := ItemsDataSet.FieldByName('GoodsName').asString;
                // 1 - ����� ���� ����������� ��� ���, 2 - ���� ��������� ������� ,,, 3 - ��������� � ��������� ,,,
                if ItemsDataSet.FieldByName('AmountOrder').AsFloat = ItemsDataSet.FieldByName('AmountPartner').AsFloat
                then PRODUCTTYPE := '1';
                if ItemsDataSet.FieldByName('AmountOrder').AsFloat <> ItemsDataSet.FieldByName('AmountPartner').AsFloat
                then PRODUCTTYPE := '2';
                if ItemsDataSet.FieldByName('AmountOrder').AsFloat = 0
                then PRODUCTTYPE := '3';
                // ��������� �������
                ORDEREDQUANTITY :=
                  StringReplace(FormatFloat('0.00##',
                  ItemsDataSet.FieldByName('AmountOrder').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                // ������ �������
                ACCEPTEDQUANTITY :=
                  StringReplace(FormatFloat('0.00##',
                  ItemsDataSet.FieldByName('AmountPartner').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                // ̳������� ��������� �������
                MINIMUMORDERQUANTITY :=
                  StringReplace(FormatFloat('0.00##',
                  14{ItemsDataSet.FieldByName('AmountOrder').AsFloat}),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

              end;
              inc(i);
              Next;
            end;
          end;
       end
  else begin
          // ������� XML
          ORDRSP := ORDRSPXML.NewORDRSP;
          //
          ORDRSP.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
          // ���� ���������
          ORDRSP.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          // ���� ��������
          ORDRSP.DELIVERYDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          //
          ORDRSP.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
          // ���� ����������
          ORDRSP.ORDERDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);

          if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
          then
              ORDRSP.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
          ORDRSP.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
          ORDRSP.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName
            ('DELIVERYPLACEGLNCode').asString;
          ORDRSP.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
          ORDRSP.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;

          with ItemsDataSet do
          begin
            First;
            i := 1;
            while not Eof do
            begin
              with ORDRSP.HEAD.POSITION.Add do
              begin
                POSITIONNUMBER := IntToStr(i);
                PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                PRODUCTIDSUPPLIER := ItemsDataSet.FieldByName('Id').asString;
                PRODUCTIDBUYER := ItemsDataSet.FieldByName
                  ('ArticleGLN_Juridical').asString;
                ORDRSPUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;
                if ItemsDataSet.FieldByName('AmountOrder')
                  .AsFloat = ItemsDataSet.FieldByName('AmountPartner').AsFloat then
                  PRODUCTTYPE := '1';

                if ItemsDataSet.FieldByName('AmountOrder').AsFloat <>
                  ItemsDataSet.FieldByName('AmountPartner').AsFloat then
                  PRODUCTTYPE := '2';

                if ItemsDataSet.FieldByName('AmountOrder').AsFloat = 0 then
                  PRODUCTTYPE := '3';

                ORDEREDQUANTITY :=
                  StringReplace(FormatFloat('0.000',
                  ItemsDataSet.FieldByName('AmountOrder').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                ACCEPTEDQUANTITY :=
                  StringReplace(FormatFloat('0.000',
                  ItemsDataSet.FieldByName('AmountPartner').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                PRICE :=
                  StringReplace(FormatFloat('0.00',
                  ItemsDataSet.FieldByName('PriceNoVAT').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                PRICEWITHVAT :=
                  StringReplace(FormatFloat('0.00',
                  ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                VAT :=
                  StringReplace(FormatFloat('0.00',
                  HeaderDataSet.FieldByName('VATPercent').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

              end;
              inc(i);
              Next;
            end;
          end;
       end;
  //
  //
  Stream := TMemoryStream.Create;
  try
    if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
    then begin
              ORDRSP_fozz.OwnerDocument.SaveToStream(Stream);
              lNumber:= ORDRSP_fozz.NUMBER
    end
    else begin
              ORDRSP.OwnerDocument.SaveToStream(Stream);
              lNumber:= ORDRSP.NUMBER
    end;
    //
    FileName := 'ORDRSP_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';
    // !��������!
    if (FisEDISaveLocal) or (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
    then
       try
         if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
         then ORDRSP_fozz.OwnerDocument.SaveToFile(FileName)
         else ORDRSP     .OwnerDocument.SaveToFile(FDirectoryError + FileName);
       except
         if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
         then ORDRSP_fozz.OwnerDocument.SaveToFile(FileName)
         else ORDRSP     .OwnerDocument.SaveToFile(FileName);
       end;
    // ����� ��������� �� ftp
    PutStreamToFTP(Stream, FileName, '/outbox');
    //
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := false;
      FUpdateEDIErrorState.Execute;
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '�������� ORDRSP ��������� �� FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TEDI.PutFileToFTP(FileName, Directory: string);
var
  i: integer;
begin
  for i := 1 to 10 do
    try
      FTPSetConnection;
      // ��������� ���� �� FTP
      FIdFTP.Connect;
      if FIdFTP.Connected then
        try
          FIdFTP.ChangeDir(Directory);
          FIdFTP.Put(FileName);
        finally
          FIdFTP.Disconnect;
        end;
      Break;
    except
      on E: Exception do
      begin
        if i > 9 then
          raise Exception.Create(E.Message);
      end;
    end;
end;

procedure TEDI.PutStreamToFTP(Stream: TStream; FileName: string;
  Directory: string);
var
  i: integer;
begin
  for i := 1 to 10 do
  begin
    try
      FTPSetConnection;
      FIdFTP.Connect;
      if FIdFTP.Connected then
      begin
        FIdFTP.ChangeDir(Directory);
        FIdFTP.Put(Stream, FileName);
      end;
      FIdFTP.Disconnect;
      Break;
    except
      on E: Exception do
      begin
        if i > 9 then
          raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

procedure TEDI.RecadvLoad(spHeader: TdsdStoredProc; Directory: String);
var
  List: TStrings;
  i: integer;
  Stream: TStringStream;
  RECADV: IXMLRECADVType;
begin
  FTPSetConnection;
  // ��������� ����� � FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('�������� ������', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            if (AnsiLowerCase(copy(List[i], Length(List[i]) - 3, 4)) = '.xml')
               and (AnsiLowerCase(copy(List[i], 1, 6)) = 'recadv') then
            begin
              // ����� ���� � ���
              Stream.Clear;
              //try
                FIdFTP.Get(List[i], Stream);
                RECADV := LoadRECADV(Stream.DataString);
                spHeader.ParamByName('inOrderInvNumber').Value := RECADV.ORDERNUMBER;
                spHeader.ParamByName('inOperDate').Value := RECADV.DATE;
                spHeader.ParamByName('inGLNPlace').Value := RECADV.HEAD.DELIVERYPLACE;
                spHeader.ParamByName('inDesadvNumber').Value := RECADV.NUMBER;
                spHeader.Execute;
              //except
              // break;
              //end;
              {}
              // ������ ��������� ���� � ���������� Archive
              try
                FIdFTP.ChangeDir('/archive');
                FIdFTP.Put(Stream, List[i]);
              finally
                FIdFTP.ChangeDir(Directory);
                FIdFTP.Delete(List[i]);
              end;
            end;
            IncProgress;
          end;
        finally
          Finish;
        end;
    finally
      FIdFTP.Disconnect;
      List.Free;
      Stream.Free;
    end;
  end;
end;

procedure TEDI.ReceiptLoad(spProtocol: TdsdStoredProc; Directory: String);
  procedure FillReceipt(s: string; Receipt: TStrings);
  var g: string;
      j: integer;
  begin
    g := '';
    for j := 1 to Length(s) do
      if s[j] = #13 then
      begin
        Receipt.Add(g);
        g := '';
      end
      else if s[j] <> #10 then
        g := g + s[j];
    if g <> '' then
      Receipt.Add(g);
  end;
  procedure FillProtocol(Receipt: TStrings; spProtocol: TdsdStoredProc; ListValue: string);
  var FileName: string;
      DOCRNNDate: string;
  begin
    spProtocol.ParamByName('inisOk').Value := Receipt[4] = 'RESULT=0';
    spProtocol.ParamByName('inTaxNumber').Value := StrToInt(copy(ListValue, 26, 7));
    spProtocol.ParamByName('inEDIEvent').Value := copy(Receipt[1], 9, MaxInt);
    spProtocol.ParamByName('inOperMonth').Value :=
      EncodeDate(StrToInt(copy(ListValue, 36, 4)), StrToInt(copy(ListValue, 34, 2)), 1);
    FileName := copy(Receipt[0], pos('FILENAME=', Receipt[0]) + 9, MaxInt);
    spProtocol.ParamByName('inFileName').Value :=
      copy(FileName, 1, 23) + '__' + copy(FileName, 26, MaxInt);
    if spProtocol.ParamByName('inisOk').Value then begin
       spProtocol.ParamByName('inInvNumberRegistered').Value := copy(Receipt[5], 8, MaxInt);
       DOCRNNDate := copy(Receipt[11], 10, 8);
       spProtocol.ParamByName('inDateRegistered').Value :=
          EncodeDate(StrToInt(copy(DOCRNNDate, 1, 4)), StrToInt(copy(DOCRNNDate, 5, 2)), StrToInt(copy(DOCRNNDate, 7, 2)));
    end
    else
       spProtocol.ParamByName('inDateRegistered').Value := Date;
  end;
var
  List, Receipt: TStrings;
  i: integer;
  Stream: TStringStream;
begin
  FTPSetConnection;
  // ��������� ����� � FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Receipt := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('�������� ������', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            if (AnsiLowerCase(copy(List[i], Length(List[i]) - 3, 4)) = '.xml')
               and (AnsiLowerCase(copy(List[i], 1, 6)) = 'status') then
            begin
            (*
              // ����� ���� � ���
              Stream.Clear;
              FIdFTP.Get(List[i], Stream);
              Status := LoadStatus(Stream.DataString);
              spProtocol.ParamByName('inisOk').Value := Status.Status = '3';
              spProtocol.ParamByName('inTaxNumber').Value := Status.DocNumber;
              spProtocol.ParamByName('inEDIEvent').Value := Status.Description;
              spProtocol.ParamByName('inOperMonth').Value :=
                EncodeDate(StrToInt(copy(List[i], 36, 4)),
                StrToInt(copy(List[i], 34, 2)), 1);
              spProtocol.ParamByName('inFileName').Value :='';
              spProtocol.Execute;
              try
                FIdFTP.ChangeDir('/archive');
                FIdFTP.Put(Stream, List[i]);
              finally
                FIdFTP.ChangeDir(Directory);
                FIdFTP.Delete(List[i]);
              end;*)
            end;
            // ��������� .rpl.
            if AnsiLowerCase(copy(List[i], Length(List[i]) - 3, 4)) = '.rpl'
            then
            begin
              // ����� ���� � ���
              Stream.Clear;
              try
                FIdFTP.Get(List[i], Stream);
              except
                break;
              end;
              FillReceipt(Stream.DataString, Receipt);
              FillProtocol(Receipt, spProtocol, List[i]);
              spProtocol.Execute;
              Receipt.Clear;
              // ������ ��������� ���� � ���������� Archive
              try
                FIdFTP.ChangeDir('/archive');
                FIdFTP.Put(Stream, List[i]);
              finally
                FIdFTP.ChangeDir(Directory);
                FIdFTP.Delete(List[i]);
              end;
            end;
            IncProgress;
          end;
        finally
          Finish;
        end;
    finally
      FIdFTP.Disconnect;
      List.Free;
      Receipt.Free;
      Stream.Free;
    end;
  end;
end;

procedure TEDI.ReturnSave(MovementDataSet: TDataSet;
  spFileInfo, spFileBlob: TdsdStoredProc; Directory: string; DebugMode: boolean);
var
  MovementId: integer;
  FileName: String;
begin
  // �������� ���� �� �����
  MovementId := MovementDataSet.FieldByName('Id').asInteger;

  spFileInfo.ParamByName('inMovementId').Value := MovementId;
  spFileInfo.Execute;
  FileName := spFileInfo.ParamByName('outFileName').asString;

  spFileBlob.ParamByName('inMovementId').Value := MovementId;
  FileName := ExtractFilePath(ParamStr(0)) + FileName;
  FileWriteString(FileName, ReConvertConvert(spFileBlob.Execute));
  try

    // ����������� ���
    SignFile(FileName, stComDoc, DebugMode
           , MovementDataSet.FieldByName('UserSign').asString
           , MovementDataSet.FieldByName('UserSeal').asString
           , MovementDataSet.FieldByName('UserKey').asString
           , MovementDataSet.FieldByName('NameExite').asString
           , MovementDataSet.FieldByName('NameFiscal').asString
            );

    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      '�������� ����������� � ��������';
    FInsertEDIEvents.Execute;

    // ���������� �� FTP
    //ShowMessage(FileName);exit;
    PutFileToFTP(ReplaceStr(FileName, '.xml', '.p7s'), Directory);
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      '�������� ��������� �� FTP';
    FInsertEDIEvents.Execute;
  finally
    // �������
    DeleteFile(ReplaceStr(FileName, '.xml', '.p7s'));
    DeleteFile(FileName);
  end;
end;

procedure TEDI.SetDirectory(const Value: string);
begin
  FDirectory := Value;
end;

procedure TEDI.SignFile(FileName: string; SignType: TSignType; DebugMode: boolean; UserSign, UserSeal, UserKey, NameExite, NameFiscal : string);
var
  vbSignType: integer;
  i: integer;
  Error: string;
  EUTaxService_����������Exite, EUTaxService_�������������: string;
  ddd: OleVariant;
begin

if VarIsNull(ComSigner) then
    InitializeComSigner(DebugMode, UserSign, UserSeal, UserKey);

  if SignType = stDeclar then
    vbSignType := 1;
  if SignType = stComDoc then
    vbSignType := 2;

  // ���������� �/��� ����������
  for i := 1 to 10 do
    try
      if SignType = stComDoc then begin
          //ShowMessage('start FileName');
          ComSigner.SetFilesOptions(false);
          Error := ComSigner.GetLastErrorDescription;
          if Error <> okError then
             raise Exception.Create('ComSigner.SetFilesOptions(False) ' + Error);

          // ��������
          if not FileExists(FileName) then raise Exception.Create('���� �� ������ : <'+FileName+'>');

          ComSigner.SignFilesByAccountant(FileName);
          Error := ComSigner.GetLastErrorDescription;
          if Error <> okError then
             raise Exception.Create('ComSigner.SignFilesByAccountant('+FileName+') ' + Error);

          ComSigner.SignFilesByDigitalStamp(FileName);
          Error := ComSigner.GetLastErrorDescription;
          if Error <> okError then
             raise Exception.Create('ComSigner.SignFilesByDigitalStamp('+FileName+') ' + Error);
      end;
      if SignType = stDeclar then
      begin

         if DebugMode then
         begin
             //!!!���� ��������� - ���������� ��������� ��� ��� ��������, ��� � ������ �������� ������ (� ����������� �), ��� ���� ������� ������ ����������!!!
             EUTaxService_����������Exite := ComSigner.SelectServerCert;
             ShowMessage('EUTaxService_����������Exite := ' + EUTaxService_����������Exite);
             //!!!���� ��������� - ���������� ��������� ��� ��� ��������, ��� � ������ �������� ������ (� ����������� �), ��� ���� ������� ������ ����������!!!
             EUTaxService_�������������   := ComSigner.SelectServerCert;
             ShowMessage('EUTaxService_������������� := ' + EUTaxService_�������������);
         end;

         if NameExite <> ''
         then EUTaxService_����������Exite := NameExite
         else EUTaxService_����������Exite := 'O=���������� � ��������� ²���²����Ͳ��� "�-���";PostalCode=01042;CN=���������� � ��������� ²���²����Ͳ��� "�-���";Serial=34241719;C=UA;L=���� �ȯ�;StreetAddress=�������� ��������������, ���. 19/3, ������ 1, �. 6';
         if NameFiscal <> ''
         then EUTaxService_�������������   := NameFiscal
         else EUTaxService_�������������   := 'O=�������� ��������� ������ ������;CN=�������� ��������� ������ ������.  ��������;Serial=2122385;C=UA;L=���';

         ddd := VarArrayCreate([0, 1], varOleStr);
         ddd[0] := EUTaxService_�������������;
         ddd[1] := EUTaxService_����������Exite;
         ComSigner.SetFilesOptions(true);
         ComSigner.ProtectFilesEx(FileName, true, false, true, true, false, 'pn@exite.ua', ddd);
      end;
      Break;
    except
      on E: Exception do
      begin
        if i > 9 then
          raise Exception.Create
            ('������ ���������� Exite. ComSigner.SignFilesByAccountant'#10#13 + E.Message);
      end;
    end;
end;

procedure TEDI.InsertUpdateOrderVchasnoEDI(ORDER: OrderXML.IXMLORDERType;
  spHeader, spList: TdsdStoredProc; lFileName, ADealId : String);
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
  s : String;
begin
  with spHeader, ORDER do
  begin
    ParamByName('inOrderInvNumber').Value := NUMBER;
    ParamByName('inOrderOperDate').Value := VarToDateTime(Date);

    ParamByName('inGLNPlace').Value := HEAD.DELIVERYPLACE;
    ParamByName('inGLN').Value := HEAD.BUYER;

    Execute;
    if ParamByName('isLoad').Value then Exit;
    MovementId := ParamByName('MovementId').Value;
    GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
  end;
  for i := 0 to ORDER.HEAD.POSITION.Count - 1 do
    with spList, ORDER.HEAD.POSITION[i] do
    begin
      ParamByName('inMovementId').Value := MovementId;
      ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
      //
      s:= CHARACTERISTIC.DESCRIPTION;
      if Pos(char(189), s) > 0
      then begin System.Insert('1/2', s, Pos(char(189), s) + 1);System.Delete(s, Pos(char(189), s), 1);end;
      ParamByName('inGoodsName').Value := s;
      //
      ParamByName('inGLNCode').Value := PRODUCTIDBUYER;
      try ParamByName('inAmountOrder').Value := gfStrToFloat(ORDEREDQUANTITY); except ParamByName('inAmountOrder').Value := 0; end;
      try ParamByName('inPriceOrder').Value := gfStrToFloat(ORDERPRICE); except ParamByName('inPriceOrder').Value := 0; end;
      Execute;
    end;
    //
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :='{'+IntToStr(i)+'}�������� ORDER �� ������ EDI ��������� _'+lFileName+'_';
    FInsertEDIEvents.Execute;
    //
    FUpdateEDIVchasnoEDI.ParamByName('inMovementId').Value := MovementId;
    FUpdateEDIVchasnoEDI.ParamByName('inDealId').Value := ADealId;
    FUpdateEDIVchasnoEDI.Execute;
end;

procedure TEDI.UpdateOrderDESADVSaveVchasnoEDI(AEDIId: Integer; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin
    FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
    FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
    FUpdateEDIErrorState.Execute;

    FInsertEDIEvents.ParamByName('inMovementId').Value := AEDIId;
    if isError = TRUE
    then FInsertEDIEvents.ParamByName('inEDIEvent').Value := '������ �������� ������ ����������� �� ��������'
    else FInsertEDIEvents.ParamByName('inEDIEvent').Value := '�������� ������ ����������� �� ��������';
    FInsertEDIEvents.Execute;
  end;
end;

procedure TEDI.UpdateOrderORDERSPSaveVchasnoEDI(AEDIId: Integer; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin

    FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
    FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
    FUpdateEDIErrorState.Execute;

    FInsertEDIEvents.ParamByName('inMovementId').Value :=AEDIId;
    if isError = TRUE
    then FInsertEDIEvents.ParamByName('inEDIEvent').Value := '������ �������� ������ ������������� ������'
    else FInsertEDIEvents.ParamByName('inEDIEvent').Value := '�������� ������ ������������� ������';
    FInsertEDIEvents.Execute;
  end;
end;

procedure TEDI.UpdateOrderDELNOTSaveVchasnoEDI(AEDIId: Integer; DocumentId, VchasnoId: String; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin

    FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
    FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
    FUpdateEDIErrorState.Execute;

    FInsertEDIEventsDoc.ParamByName('inMovementId').Value :=AEDIId;
    FInsertEDIEventsDoc.ParamByName('inDocumentId').Value :=DocumentId;
    FInsertEDIEventsDoc.ParamByName('inVchasnoId').Value :=VchasnoId;
    if isError = TRUE
    then FInsertEDIEventsDoc.ParamByName('inEDIEvent').Value := '������ �������� ������ ��������� ���������'
    else FInsertEDIEventsDoc.ParamByName('inEDIEvent').Value := '�������� ������ ��������� ���������';
    FInsertEDIEventsDoc.Execute;
  end;
end;

procedure TEDI.UpdateOrderDELNOTSignVchasnoEDI(AEDIId: Integer; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin

    FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
    FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
    FUpdateEDIErrorState.Execute;

    FInsertEDIEvents.ParamByName('inMovementId').Value :=AEDIId;
    if isError = TRUE
    then FInsertEDIEvents.ParamByName('inEDIEvent').Value := '������ ������� ������ ��������� ���������'
    else FInsertEDIEvents.ParamByName('inEDIEvent').Value := '������� ������ ��������� ���������';
    FInsertEDIEvents.Execute;
  end;
end;

procedure TEDI.OrderLoadVchasnoEDI(AOrder, AFileName, ADealId: String; spHeader, spList: TdsdStoredProc);
var
  ORDER: OrderXML.IXMLORDERType;
begin
  try
    ORDER := OrderXML.LoadORDER(AOrder);
    // ��������� � �������
    InsertUpdateOrderVchasnoEDI(ORDER, spHeader, spList, AFileName, ADealId);
  except
    on E: Exception do begin raise Exception.Create(E.Message);
    end;
  end;
end;

procedure TEDI.DESADVSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
var
  DESADV: DesadvXML.IXMLDESADVType;
  i: integer;
begin
  // ������� XML
  DESADV := DesadvXML.NewDESADV;
  //
  DESADV.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  DESADV.Date := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DESADV.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DESADV.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  DESADV.ORDERDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
  DESADV.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  DESADV.DELIVERYNOTEDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  //
  if HeaderDataSet.FieldByName('INFO_RoomNumber').asString <> ''
  then DESADV.INFO := HeaderDataSet.FieldByName('INFO_RoomNumber').asString;

  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
      DESADV.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  DESADV.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  DESADV.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName
    ('DELIVERYPLACEGLNCode').asString;
  DESADV.HEAD.SENDER := HeaderDataSet.FieldByName
    ('SenderGLNCode').asString;
  DESADV.HEAD.RECIPIENT := HeaderDataSet.FieldByName
    ('RecipientGLNCode').asString;
  DESADV.HEAD.PACKINGSEQUENCE.HIERARCHICALID := '1';

  with ItemsDataSet do
  begin
    First;
    i := 1;
    while not Eof do
    begin
      with DESADV.HEAD.PACKINGSEQUENCE.POSITION.Add do
      begin
        POSITIONNUMBER := i;
        PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
        PRODUCTIDSUPPLIER := ItemsDataSet.FieldByName('Id').asString;
        PRODUCTIDBUYER := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
        DESCRIPTION := ItemsDataSet.FieldByName('GoodsName').asString;
        DELIVEREDQUANTITY :=
          StringReplace(FormatFloat('0.000',
          ItemsDataSet.FieldByName('AmountPartner').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
        DELIVEREDUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;

        // ��������� �������
        ORDEREDQUANTITY :=
          StringReplace(FormatFloat('0.000',
          ItemsDataSet.FieldByName('AmountOrder').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        // ʳ������ �����
        if ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat > 0
        then
            BOXESQUANTITY :=
              StringReplace(FormatFloat('0.##',
              ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat),
              FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        COUNTRYORIGIN := 'UA';
        PRICE := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('Price').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        // ���� � ���
        PRICEWITHVAT := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
        // ���
        TAXRATE:= StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('VATPercent').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

      end;
      inc(i);
      Next;
    end;
  end;

  DESADV.OwnerDocument.SaveToFile('test_DESADV_VchasnoEDI.xml');
  DESADV.OwnerDocument.SaveToStream(Stream);
end;

procedure TEDI.ORDERSPSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
var ORDRSP: ORDRSPXML.IXMLORDRSPType;
    i: integer;
begin

  // ������� XML
  ORDRSP := ORDRSPXML.NewORDRSP;
  //
  ORDRSP.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  ORDRSP.Date := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  ORDRSP.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  ORDRSP.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  ORDRSP.ORDERDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
      ORDRSP.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  ORDRSP.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  ORDRSP.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName
    ('DELIVERYPLACEGLNCode').asString;
  ORDRSP.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
  ORDRSP.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;

  with ItemsDataSet do
  begin
    First;
    i := 1;
    while not Eof do
    begin
      with ORDRSP.HEAD.POSITION.Add do
      begin
        POSITIONNUMBER := IntToStr(i);
        PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
        PRODUCTIDSUPPLIER := ItemsDataSet.FieldByName('Id').asString;
        PRODUCTIDBUYER := ItemsDataSet.FieldByName
          ('ArticleGLN_Juridical').asString;
        DESCRIPTION := ItemsDataSet.FieldByName('GoodsName').asString;
        ORDRSPUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;
        if ItemsDataSet.FieldByName('AmountOrder')
          .AsFloat = ItemsDataSet.FieldByName('AmountPartner').AsFloat then
          PRODUCTTYPE := '1';

        if ItemsDataSet.FieldByName('AmountOrder').AsFloat <>
          ItemsDataSet.FieldByName('AmountPartner').AsFloat then
          PRODUCTTYPE := '2';

        if ItemsDataSet.FieldByName('AmountOrder').AsFloat = 0 then
          PRODUCTTYPE := '3';

        ORDEREDQUANTITY :=
          StringReplace(FormatFloat('0.000',
          ItemsDataSet.FieldByName('AmountOrder').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
        ACCEPTEDQUANTITY :=
          StringReplace(FormatFloat('0.000',
          ItemsDataSet.FieldByName('AmountPartner').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        PRICE :=
          StringReplace(FormatFloat('0.00',
          ItemsDataSet.FieldByName('PriceNoVAT').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        PRICEWITHVAT :=
          StringReplace(FormatFloat('0.00',
          ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        VAT :=
          StringReplace(FormatFloat('0.00',
          HeaderDataSet.FieldByName('VATPercent').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

      end;
      inc(i);
      Next;
    end;
  end;

  ORDRSP.OwnerDocument.SaveToFile('test_ORDRSP_VchasnoEDI.xml');
  ORDRSP.OwnerDocument.SaveToStream(Stream);
end;

procedure TEDI.ComDocSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
var
  DESADV_fozz_Amount: DOCUMENTINVOICE_TN_XML.IXMLDocumentInvoiceType;
  i: integer;
  TotalGrossAmount, TotalNetAmount : Double;
begin
  // 1.1. ������� XML - fozzy - Amount
  DESADV_fozz_Amount := DOCUMENTINVOICE_TN_XML.NewDocumentInvoice;
  // ����� ����������� ��� ������������
  DESADV_fozz_Amount.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
  // ���� ���������
  DESADV_fozz_Amount.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  //��� ���� ���������: TN - �������� �� �������
  DESADV_fozz_Amount.InvoiceHeader.DocumentFunctionCode := 'TN';
  // ����� �������� �� ��������
  DESADV_fozz_Amount.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
  // ���� ��������
  DESADV_fozz_Amount.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  // ����� ����������
  DESADV_fozz_Amount.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  // ���� ����������
  DESADV_fozz_Amount.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);

  // ���������� ����� ������������ (GLN) ����������� - GLN �������
  if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
  then DESADV_fozz_Amount.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  // ���������� ���������������� ����� - �������
  if HeaderDataSet.FieldByName('INN_To').asString <> ''
  then DESADV_fozz_Amount.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
  // ��� ������ - �������
  if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
  then DESADV_fozz_Amount.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
  // ����� �����������
  DESADV_fozz_Amount.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;


  // ���������� ����� ������������ (GLN) ����������� - GLN ��������
  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then DESADV_fozz_Amount.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  // ���������� ���������������� ����� - ��������
  if HeaderDataSet.FieldByName('INN_From').asString <> ''
  then DESADV_fozz_Amount.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
  // ��� ������ - ��������
  if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
  then DESADV_fozz_Amount.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
  // ����� ��������
  DESADV_fozz_Amount.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

  // ���������� ����� ������������ (GLN) ����������� - GLN ����� ��������
  if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
  then DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
  // �������� ����� �ᒺ��� ��������
  DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
  // ̳��� - ����� ��������
  DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
  // ������ � ����� ������� - ����� ��������
  DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
  // �������� ��� - ����� ��������
  //try DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.PostalCode := StrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString);except end;


  TotalGrossAmount := 0;
  TotalNetAmount := 0;
  with ItemsDataSet do
  begin
    First;
    i := 1;
    while not Eof do
    begin
      with DESADV_fozz_Amount.InvoiceLines.Add do
      begin
        // ����� ������� �������
        LineItem.LineNumber := i;
        // �������� ��������
        LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
        // ������� � �� �������
        LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
        // ������������ ������� �������
        LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;
        // �������, �� �������������
        LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
        // BuyerUnitOfMeasure
        //LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;
        //������� �����
        LineItem.UnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;
        // ��� ������
        LineItem.ExternalItemCode := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
        // ֳ�� ���� ������� ��� ���
        LineItem.InvoiceUnitNetPrice := ItemsDataSet.FieldByName('PriceNoVAT').AsFloat;
        // ������ ������� (���,%):
        LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;
        // ������ ������� (���,%):
        //LineItem.TaxCategoryCode := 'S';

        // ���� �������
        LineItem.TaxAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat - ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
        // ���� ��� ���
        LineItem.NetAmount := ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;

        TotalGrossAmount := TotalGrossAmount + ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat;
        TotalNetAmount := TotalNetAmount + ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
      end;
      inc(i);
      Next;
    end;
  end;

    // ʳ������ ����� � ��������
  DESADV_fozz_Amount.InvoiceSummary.TotalLines := i;
  // �������� ���� ��� ���
  // ʳ������ ����� � ��������
  DESADV_fozz_Amount.InvoiceSummary.TotalLines := i;
  // �������� ���� ��� ���
  DESADV_fozz_Amount.InvoiceSummary.TotalNetAmount := TotalNetAmount;
  // ���� ���
  DESADV_fozz_Amount.InvoiceSummary.TotalTaxAmount := TotalGrossAmount - TotalNetAmount;
  // �������� ���� � ���
  DESADV_fozz_Amount.InvoiceSummary.TotalGrossAmount := TotalGrossAmount;

  DESADV_fozz_Amount.OwnerDocument.SaveToFile('test_ComDoc_VchasnoEDI.xml');
  DESADV_fozz_Amount.OwnerDocument.SaveToStream(Stream);
end;

{ TEDIActionEDI }

constructor TEDIAction.Create(AOwner: TComponent);
begin
  inherited;
  FEndDate := TdsdParam.Create(nil);
  FStartDate := TdsdParam.Create(nil);
end;

destructor TEDIAction.Destroy;
begin
  FreeAndNil(FEndDate);
  FreeAndNil(FStartDate);
  inherited;
end;

function TEDIAction.LocalExecute: boolean;
begin
  // �������� ��������
  case EDIDocType of
    ediOrder:
      EDI.OrderLoad(spHeader, spList, Directory, StartDateParam.Value,
        EndDateParam.Value);
    ediComDoc:
      EDI.ComdocLoad(spHeader, spList, Directory, StartDateParam.Value,
        EndDateParam.Value);
    ediComDocSave:
      EDI.COMDOCSave(HeaderDataSet, ListDataSet, Directory, ShiftDown);
    ediDeclar:
      EDI.DeclarSave(HeaderDataSet, ListDataSet, spHeader, Directory, ShiftDown);
    ediReceipt:
      EDI.ReceiptLoad(spHeader, Directory);
    ediReturnComDoc:
      EDI.ReturnSave(HeaderDataSet, spHeader, spList, Directory, ShiftDown);
    ediDeclarReturn:
      EDI.DeclarReturnSave(HeaderDataSet, ListDataSet, spHeader, Directory, ShiftDown);
    ediDesadv: begin
      EDI.DESADVSave(HeaderDataSet, ListDataSet);
      EDI.IFTMINSave(HeaderDataSet, ListDataSet);
    end;
    ediOrdrsp:
      EDI.ORDRSPSave(HeaderDataSet, ListDataSet);
    ediInvoice:
      EDI.INVOICESave(HeaderDataSet, ListDataSet);
    ediRecadv:
      EDI.RecadvLoad(spHeader, Directory);
    ediError:
      EDI.ErrorLoad(Directory);
  end;
  Result := true;
end;

{ TConnectionParams }

constructor TConnectionParams.Create;
begin
  inherited;
  FHost := TdsdParam.Create(nil);
  FUser := TdsdParam.Create(nil);
  FPassword := TdsdParam.Create(nil);
end;

destructor TConnectionParams.Destroy;
begin
  FreeAndNil(FHost);
  FreeAndNil(FUser);
  FreeAndNil(FPassword);
  inherited;
end;

type
  TCustomIdHTTP = class(TIdHTTP)
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  private
    procedure OnStatusInfoEx(ASender: TObject; const AsslSocket: PSSL; const AWhere, Aret: TIdC_INT; const AType, AMsg: String);
  end;

{ TCustomIdHTTP }

constructor TCustomIdHTTP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  with IOHandler as TIdSSLIOHandlerSocketOpenSSL do begin
    OnStatusInfoEx := Self.OnStatusInfoEx;
    SSLOptions.Method := sslvSSLv23;
    {$if CompilerVersion < 30}
    SSLOptions.SSLVersions := [sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1];
    {$ifend}
  end;
end;

destructor TCustomIdHTTP.Destroy;
begin
  IOHandler.Free;
  inherited Destroy;
end;

procedure TCustomIdHTTP.OnStatusInfoEx(ASender: TObject; const AsslSocket: PSSL; const AWhere, Aret: TIdC_INT;
  const AType, AMsg: String);
begin
  SSL_set_tlsext_host_name(AsslSocket, AnsiString(Request.Host));
end;

  {TdsdVchasnoEDIAction}

constructor TdsdVchasnoEDIAction.Create(AOwner: TComponent);
begin
  inherited;

  FPairParams := TOwnedCollection.Create(Self, TdsdPairParamsItem);
  with TdsdPairParamsItem(FPairParams.Add) do
  begin
    DataType := ftString;
    FieldName := 'Id';
    PairName := 'Id';
  end;
  with TdsdPairParamsItem(FPairParams.Add) do
  begin
    DataType := ftString;
    FieldName := 'deal_id';
    PairName := 'deal_id';
  end;

  FHostParam := TdsdParam.Create;
  FHostParam.DataType := ftString;
  FHostParam.Value := '';

  FTokenParam := TdsdParam.Create(nil);
  FTokenParam.DataType := ftString;
  FTokenParam.Value := '';

  FDocTypeParam := TdsdParam.Create(nil);
  FDocTypeParam.DataType := ftString;
  FDocTypeParam.Value := '';

  FDocStatusParam := TdsdParam.Create(nil);
  FDocStatusParam.DataType := ftString;
  FDocStatusParam.Value := '';


  FOrderParam := TdsdParam.Create(nil);
  FOrderParam.DataType := ftString;
  FOrderParam.Value := '';

  FDocumentIdParam := TdsdParam.Create(nil);
  FDocumentIdParam.DataType := ftString;
  FDocumentIdParam.Value := '';

  FVchasnoIdParam := TdsdParam.Create(nil);
  FVchasnoIdParam.DataType := ftString;
  FVchasnoIdParam.Value := '';

  FDateFromParam := TdsdParam.Create(nil);
  FDateFromParam.DataType := ftDateTime;
  FDateFromParam.Value := Null;

  FDateToParam := TdsdParam.Create(nil);
  FDateToParam.DataType := ftDateTime;
  FDateToParam.Value := Null;;

  FDefaultFilePathParam := TdsdParam.Create(nil);
  FDefaultFilePathParam.DataType := ftString;
  FDefaultFilePathParam.Value := '';

  FDefaultFileNameParam := TdsdParam.Create(nil);
  FDefaultFileNameParam.DataType := ftString;
  FDefaultFileNameParam.Value := '';


  FResultParam := TdsdParam.Create(nil);
  FResultParam.DataType := ftWideString;
  FResultParam.Value := '';

  FFileNameParam := TdsdParam.Create(nil);
  FFileNameParam.DataType := ftString;
  FFileNameParam.Value := '';

  FKeyFileNameParam := TdsdParam.Create(nil);
  FKeyFileNameParam.DataType := ftString;
  FKeyFileNameParam.Value := '';

  FKeyUserNameParam := TdsdParam.Create(nil);
  FKeyUserNameParam.DataType := ftString;
  FKeyUserNameParam.Value := '';

  FShowErrorMessagesParam := TdsdParam.Create(nil);
  FShowErrorMessagesParam.DataType := ftBoolean;
  FShowErrorMessagesParam.Value := True;

  FErrorTextParam := TdsdParam.Create(nil);
  FErrorTextParam.DataType := ftString;
  FErrorTextParam.Value := '';
  FEDIDocType:= ediOrder;
end;

destructor TdsdVchasnoEDIAction.Destroy;
begin
  FreeAndNil(FErrorTextParam);
  FreeAndNil(FShowErrorMessagesParam);
  FreeAndNil(FKeyUserNameParam);
  FreeAndNil(FKeyFileNameParam);
  FreeAndNil(FDefaultFilePathParam);
  FreeAndNil(FDefaultFileNameParam);
  FreeAndNil(FFileNameParam);
  FreeAndNil(FHostParam);
  FreeAndNil(FTokenParam);
  FreeAndNil(FVchasnoIdParam);
  FreeAndNil(FDocumentIdParam);
  FreeAndNil(FOrderParam);
  FreeAndNil(FDateFromParam);
  FreeAndNil(FDateToParam);
  FreeAndNil(FDocStatusParam);
  FreeAndNil(FDocTypeParam);
  FreeAndNil(FResultParam);
  FreeAndNil(FPairParams);
  inherited;
end;

// ATypeExchange
// 0 - ��������� ������ ���������� � Json
// 1 - ��������� ������ ���������� � DataSet
// 2 - ��������� ������������� ���� � Result
// 3 - ��������� ������������� ���� � ��������� ��� �� ����
// 4 - ��������� ������������ ���� � Result
// 5 - ��������� ������������ ���� � ��������� ��� �� ����
function TdsdVchasnoEDIAction.GetVchasnoEDI(ATypeExchange : Integer; ADataSet: TClientDataSet = Nil): Boolean;
  var IdHTTP: TCustomIdHTTP;
      i,j : Integer;
      Params: String;
      Stream: TMemoryStream; StringStream: TStringStream;
      ZDC : TZDecompressionStream;
      cFilePath, cFileName : String;
      strTempFile : array[0..MAX_PATH-1] of char;
      Res: TArray<string>;
      JsonArray: TJSONArray;
      jsonItem : TJSONObject;
begin
  inherited;
  Result := False;

  if (FTokenParam.Value = '') or
     (FHostParam.Value = '') then
  begin
    ShowMessages('�� ��������� Host ��� �����.');
    Exit;
  end;

  if (ATypeExchange = 1) then
  begin
    if not Assigned(ADataSet) then
    begin
      ShowMessages('�� ������ DataSet.');
      Exit;
    end;

    if FPairParams.Count = 0 then
    begin
      ShowMessages('�� ���������� ������ � PairParams ��� ������������ DataSet.');
      Exit;
    end;
  end;

  // ��������������� ��������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try
    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'UTF-8';
    IdHTTP.Request.Accept := '*/*';
    IdHTTP.Request.AcceptEncoding := 'gzip, deflate';
    IdHTTP.Request.Connection := 'keep-alive';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '';
    if ATypeExchange in [2, 3] then
    begin
      Params := '/' + FOrderParam.Value + '/original';
    end else if ATypeExchange in [4, 5] then
    begin
      Params := '/' + FDocumentIdParam.Value + '/original';
    end else
    begin
      Params := 'type=' + FDocTypeParam.AsString;

      if (FDateFromParam.Value <> Null) and (FDateFromParam.Value <> Null) then
        Params := Params + '&date_from=' + FormatDateTime('YYYY-MM-DD', StrToDateTime(FDateFromParam.Value));

      if (FDateToParam.Value <> Null) and (FDateToParam.Value <> Null) then
        Params := Params + '&date_to=' + FormatDateTime('YYYY-MM-DD', StrToDateTime(FDateToParam.Value));

      if FDocStatusParam.Value <> '' then
        Params := Params + '&deal_status=' + FDocStatusParam.Value;

      if Params <> '' then Params := '?' + Params;
    end;

    Stream := TMemoryStream.Create;
    StringStream:= TStringStream.Create('', TEncoding.UTF8);
    try
      try
        IdHTTP.Get(TIdURI.URLEncode(FHostParam.Value + Params), Stream);
      except on E:EIdHTTPProtocolException  do ShowMessages(e.ErrorMessage);
      end;

      if IdHTTP.ResponseCode = 200 then
      begin

        // ������������� ���������� ��������� ���� ����
        if IdHTTP.Response.ContentEncoding = 'gzip' then
        begin
          Stream.Position := 0;
          ZDC := TZDecompressionStream.Create(Stream, 15 + 16);
          try
            StringStream.CopyFrom(ZDC, 0);
          finally
            ZDC.Free;
          end;
        end else
        begin
          Stream.Position := 0;
          StringStream.CopyFrom(Stream, 0);
        end;

        if ATypeExchange in [3, 5] then
        begin

           cFilePath := '';
           cFileName := '';

           // ���� ������ ����� ��� �����
           if FFileNameParam.Value <> '' then
           begin
             if ExpandFileName(ExtractFilePath(FFileNameParam.Value)) <> '' then
             begin
               if not DirectoryExists(ExpandFileName(ExtractFilePath(FFileNameParam.Value))) then
                 ForceDirectories(ExpandFileName(ExtractFilePath(FFileNameParam.Value)));
               if DirectoryExists(ExpandFileName(ExtractFilePath(FFileNameParam.Value))) then
                 cFilePath := ExpandFileName(ExtractFilePath(FFileNameParam.Value))
             end;

             if TPath.GetFileName(FFileNameParam.Value) <> '' then
               cFileName := TPath.GetFileName(FFileNameParam.Value);
           end;

           // ��������� ���� �����
           if cFilePath = '' then
           begin
             if ExpandFileName(FDefaultFilePathParam.Value) <> '' then
             begin
               if not DirectoryExists(ExpandFileName(FDefaultFilePathParam.Value)) then
                 ForceDirectories(ExpandFileName(FDefaultFilePathParam.Value));
               if DirectoryExists(ExpandFileName(FDefaultFilePathParam.Value)) then
                 cFilePath := ExpandFileName(FDefaultFilePathParam.Value)
               else cFilePath := ExtractFilePath(ParamStr(0));
             end else cFilePath := ExtractFilePath(ParamStr(0));
           end;

           // ��������� ��� �����
           if cFileName = '' then
           begin
             if TPath.GetFileName(FDefaultFileNameParam.Value) = '' then
             begin
               if Pos('filename', IdHTTP.Response.ContentDisposition) > 0 then
               begin
                 Res := TRegEx.Split(IdHTTP.Response.ContentDisposition, '"');
                 if (High(Res) > 1) and (TPath.GetFileName(Res[1]) <> '') then
                   cFileName := TPath.GetFileName(Res[1])
               end;

               if cFileName = '' then
               begin
                 GetTempFileName(PChar(cFilePath), '', 0, strTempFile);
                 cFileName := String(strTempFile) + '_original.xml';
               end;
             end else cFileName := FDefaultFileNameParam.Value;
           end;
           FFileNameParam.Value := TPath.Combine(cFilePath, cFileName);

           // �������� ����
           StringStream.SaveToFile(FFileNameParam.Value);
           Result := True;
        end else if ATypeExchange = 1 then
        begin

          ADataSet.Close;
          ADataSet.FieldDefs.Clear;

          for i := 0 to FPairParams.Count - 1 do
          begin
            case TdsdPairParamsItem(FPairParams.Items[i]).DataType of
              ftBoolean : ADataSet.FieldDefs.Add(TdsdPairParamsItem(FPairParams.Items[i]).FieldName, ftBoolean);
              ftInteger : ADataSet.FieldDefs.Add(TdsdPairParamsItem(FPairParams.Items[i]).FieldName, ftInteger);
              ftFloat : ADataSet.FieldDefs.Add(TdsdPairParamsItem(FPairParams.Items[i]).FieldName, ftFloat);
              ftWideString : ADataSet.FieldDefs.Add(TdsdPairParamsItem(FPairParams.Items[i]).FieldName, ftWideString);
              ftDateTime : ADataSet.FieldDefs.Add(TdsdPairParamsItem(FPairParams.Items[i]).FieldName, ftDateTime);
            else ADataSet.FieldDefs.Add(TdsdPairParamsItem(FPairParams.Items[i]).FieldName, ftString, 255);
            end;
          end;

          ADataSet.CreateDataSet;

          jsonArray := TJSONObject.ParseJSONValue(StringStream.DataString) as TJSONArray;

          for J := 0 to jsonArray.Size - 1 do
          begin
            jsonItem := TJSONObject(jsonArray.Get(J));
            ADataSet.Append;
            for i := 0 to FPairParams.Count - 1 do
              if jsonItem.Get(LowerCase(TdsdPairParamsItem(FPairParams.Items[i]).PairName)) <> Nil then
            begin
              case TdsdPairParamsItem(FPairParams.Items[i]).DataType of
                ftDateTime : ADataSet.FieldByName(TdsdPairParamsItem(FPairParams.Items[i]).FieldName).Value :=
                               gfXSStrToDate(jsonItem.Get(TdsdPairParamsItem(FPairParams.Items[i]).FieldName).JsonValue.Value);
              else ADataSet.FieldByName(TdsdPairParamsItem(FPairParams.Items[i]).FieldName).Value :=
                     jsonItem.Get(LowerCase(TdsdPairParamsItem(FPairParams.Items[i]).PairName)).JsonValue.Value;
              end;
            end;
            ADataSet.Post;
          end;
          Result := True;
        end else
        begin

           if ATypeExchange = 2 then
           begin
             FFileNameParam.Value := '';
             if Pos('filename', IdHTTP.Response.ContentDisposition) > 0 then
             begin
               Res := TRegEx.Split(IdHTTP.Response.ContentDisposition, '"');
               if (High(Res) > 1) and (TPath.GetFileName(Res[1]) <> '') then
                 FFileNameParam.Value := TPath.GetFileName(Res[1])
             end;
           end;

          FResultParam.Value := StringStream.DataString;
          Result := True;
        end;
      end;
    finally
      Stream.Free;
      StringStream.Free
    end;
  finally
    IdHTTP.Free;
  end;
end;

// ATypeExchange
// 0 - ��������� ������ � ������
function TdsdVchasnoEDIAction.POSTVchasnoEDI(ATypeExchange : Integer; AStream: TMemoryStream): Boolean;
  var IdHTTP: TCustomIdHTTP;
      Params, S: String;
      Stream: TIdMultiPartFormDataStream;
      jsonObj: TJSONObject;
begin
  inherited;
  Result := False;

  if (FTokenParam.Value = '') or
     (FHostParam.Value = '') then
  begin
    ShowMessages('�� ��������� Host ��� �����.');
    Exit;
  end;

  // ��������������� ��������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  Stream := TIdMultiPartFormDataStream.Create;
  try

    Stream.AddFormField('file', '', '',  AStream, 'file');

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'multipart/form-data; boundary=' + Stream.Boundary;
    IdHTTP.Request.ContentLength := Stream.Size;
    IdHTTP.Request.ContentEncoding := 'UTF-8';
    IdHTTP.Request.Accept := '*/*';
    IdHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
    IdHTTP.Request.Connection := 'keep-alive';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '';
    Params := 'deal_id=' + FOrderParam.Value;
    if Params <> '' then Params := '?' + Params;

    AStream.Position := 0;

    try
      S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + Params), Stream);
    except on E:EIdHTTPProtocolException  do
                ShowMessages(e.ErrorMessage);
    end;

    if IdHTTP.ResponseCode in [200,201] then
    begin
      jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
      try
        if (jsonObj.Get('deal_status') <> nil) and (jsonObj.Get('deal_status').JsonValue.Value = 'in_work') and
         (jsonObj.Get('document_id') <> nil)  then
        begin
          FDocumentIdParam.Value := jsonObj.Get('document_id').JsonValue.Value;
          if jsonObj.Get('vchasno_id') <> nil then
            FVchasnoIdParam.Value := jsonObj.Get('vchasno_id').JsonValue.Value
          else FVchasnoIdParam.Value := '';
        end;
      finally
        FreeAndNil(jsonObj);
      end;
      Result := True;
    end;
  finally
    Stream.Free;
    IdHTTP.Free;
  end;
end;

function TdsdVchasnoEDIAction.POSTSignVchasnoEDI: Boolean;
  var IdHTTP: TCustomIdHTTP;
      S, Params: String;
      fileStreamSing: TFileStream;
      base64StreamSing: TStringStream;
      fileStreamStamp: TFileStream;
      base64StreamStamp: TStringStream;
      Stream: TStringStream;
      Body: string;
begin
  inherited;
  Result := False;

  if (FTokenParam.Value = '') or
     (FHostParam.Value = '') then
  begin
    ShowMessages('�� ��������� Host ��� �����.');
    Exit;
  end;

  if not FileExists(FFileNameParam.Value + '_sign.p7s') then
  begin
    ShowMessages('���� ' + FFileNameParam.Value + '_sign.p7s' + ' �� ������.');
    Exit;
  end;

  // ��������������� �������� ����� ��� �������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    fileStreamSing := TFileStream.Create(FFileNameParam.Value + '_sign.p7s', fmOpenRead);
    base64StreamSing := TStringStream.Create('', TEncoding.UTF8);
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then
    begin
      fileStreamStamp := TFileStream.Create(FFileNameParam.Value + '_stamp.p7s', fmOpenRead);
      base64StreamStamp := TStringStream.Create('', TEncoding.UTF8);
    end;

    try
      try
        EncodeStream(fileStreamSing, base64StreamSing);

        Body := '{'#13 +
                '  "signature": ' +  base64StreamSing.DataString + ''#13;
        if Assigned(fileStreamStamp) then
        begin
          EncodeStream(fileStreamStamp, base64StreamStamp);

          Body := Body + ', "stamp": ' + base64StreamStamp.DataString + ''#13;
        end;
        Body := Body + #13 + '}';
      except on E:EIdHTTPProtocolException  do
                  ShowMessages('������: ' + e.ErrorMessage);
      end;
    finally
      FreeAndNil(fileStreamStamp);
      FreeAndNil(base64StreamStamp);
      FreeAndNil(fileStreamSing);
      FreeAndNil(base64StreamSing);
    end;

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json; charset=utf-8';
    IdHTTP.Request.ContentEncoding := 'UTF-8';
    IdHTTP.Request.Accept := '*/*';
    IdHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
    //IdHTTP.Request.Connection := 'keep-alive';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '/' + FDocumentIdParam.Value + '/signatures';
    Stream := TStringStream.Create(Body, TEncoding.UTF8);
    Stream.SaveToFile('111.json');
    Stream.Position := 0;
    try
      try
        S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + Params), Stream);
      except on E:EIdHTTPProtocolException  do
                  ShowMessages('������: ' + e.ErrorMessage);
      end;
    finally
      FreeAndNil(Stream);
    end;

    if IdHTTP.ResponseCode = 200 then
    begin
      Result := True;
    end;
  finally
    IdHTTP.Free;
  end;
end;

function TdsdVchasnoEDIAction.SignData(UserSign : String) : boolean;
var
  apath: String;
{$IFDEF WIN64}
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine, SignFile, FileKeyName, FileName: String;
  f: TIniFile;
{$ELSE}
  FileName: AnsiString;
  CPInterface: PEUSignCP;
  CertOwnerInfo : TEUCertOwnerInfo;
  Param : DWORD;
  nError : integer;
{$ENDIF WIN64}
begin

  Result := False;

  apath := 'c:\Program Files (x86)\Institute of Informational Technologies\Certificate Authority-1.3\End User\';
  if not FileExists(apath + String(EUDLLName)) then
  begin
    apath := 'c:\Program Files\Institute of Informational Technologies\Certificate Authority-1.3\End User\';
    if not FileExists(apath + String(EUDLLName)) then
    begin
      ShowMessages('������ �� ������ ���� ���������� �������: ' + EUDLLName);
    end;
  end;

{$IFDEF WIN64}

  SignFile := ExtractFilePath(ParamStr(0)) + 'SignFile.exe';

  if not FileExists(SignFile) then
  begin
    ShowMessages('������ �� ������� ��������� ����������: ' + SignFile);
  end;

  // 1.��������� ������
  if ExtractFilePath(UserSign) <> ''
  then FileKeyName := AnsiString(UserSign)
  else FileKeyName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

  // ��������
  if not FileExists(String(FileKeyName)) then ShowError('���� �� ������ : <'+String(FileKeyName)+'>');

  FKeyFileNameParam.Value := ExtractFileName(String(FileKeyName));

  FileName := FFileNameParam.Value;
  // ��������
  if not FileExists(String(FileName)) then ShowError('���� ��������� �� ������ : <'+String(FileName)+'>');

  CmdLine := '"' + SignFile + '" "' + apath + '" "' + FileKeyName + '" "24447183" "' + FileName + '"';

  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
  end;

  // ��������� ������� �������
  // ������� ���������� ����������
  if CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false,
                   CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                   PChar(ExtractFilePath(FileName)), StartInfo, ProcInfo) then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    // Free the Handles
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;

  FileName := ExtractFilePath(ParamStr(0)) + 'SignFileResult.dat';

  if not FileExists(FileName) then
  begin
    ShowMessages('������ �� ������� ��������� ������ ��������� ����������: ' + FileName);
    Exit;
  end;

  f := TiniFile.Create(FileName);

  try
    try
      if F.ReadString('SignResult', '������', '') = '' then
      begin
        FKeyUserNameParam.Value := F.ReadString('SignResult', 'UserName', '');
        Result := True;
      end else ShowError('������ ' + F.ReadString('SignResult', '������', ''));;
    Except
    end;
  finally
    f.Free;
  end;
  DeleteFile(FileName);

{$ELSE}

  if not EULoadDLL(apath) then
  begin
    ShowMessages('������ �� ��������� ���������� �������: ' + EUDLLName);
    Exit;
  end;
  CPInterface := EUGetInterface();
  if CPInterface = nil then
  begin
    EUUnloadDLL();
    ShowMessages('������ �� ��������� ���������� �������: ' + EUDLLName);
    Exit;
  end;
  CPInterface.SetUIMode(false);
  EUInitializeOwnUI(CPInterface, true);
  try

    nError := CPInterface.Initialize();
    if nError <> EU_ERROR_NONE then
    begin
      ShowMessages('������ ������������� ���������� �������: ' + EUDLLName);
      Exit;
    end;
    if ShiftDown then
    begin
       CPInterface.SetUIMode(true);
       CPInterface.SetSettings;
    end;

    CPInterface.SetUIMode(false);

    Param := EU_SIGN_TYPE_CADES_X_LONG;
    CPInterface.SetRuntimeParameter(PAnsiChar(EU_SIGN_TYPE_PARAMETER), @Param, sizeof(Param));

    try
      CPInterface.ResetPrivateKey;
    except
      on E: Exception do
      begin
        ShowMessages('������ � ���������� �������: ' + E.Message);
        Exit;
      end;
    end;

    try
      // 1.��������� ������
      if ExtractFilePath(UserSign) <> ''
      then FileName := AnsiString(UserSign)
      else FileName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

      // ��������
      if not FileExists(String(FileName)) then
      begin
        ShowMessages('���� �� ������ : <'+String(FileName)+'>');
        Exit;
      end;

      FKeyFileNameParam.Value := ExtractFileName(String(FileName));

      nError := CPInterface.ReadPrivateKeyFile (PAnsiChar(FileName), PAnsiChar('24447183'), @CertOwnerInfo); // ���������
      if nError <> EU_ERROR_NONE then
      begin
        ShowMessages('������ � ���������� ��� �������� ������������ �����: ' + CPInterface.GetErrorDesc(nError));
        Exit;
      end;

      FKeyUserNameParam.Value := String(CertOwnerInfo.SubjectFullName);
    except
      on E: Exception do
      begin
        ShowMessages('������ � ���������� ��� �������� ������������ �����:' + E.Message);
        Exit;
      end;
    end;

    try
      // 2.��������������� �������
      FileName := FFileNameParam.Value;
      // ��������
      if not FileExists(String(FileName)) then
      begin
        ShowMessages('���� ��������� �� ������ : <'+String(FileName)+'>');
        Exit;
      end;

      nError := CPInterface.SignFile(PAnsiChar(FileName), PAnsiChar(FileName + '.p7s'), True);
      if nError <> EU_ERROR_NONE then
      begin
        ShowMessages('������ � ���������� ��� ��������� �������: ' + CPInterface.GetErrorDesc(nError));
        Exit;
      end;
    except
      on E: Exception do
      begin
        ShowMessages('������ � ���������� ��� ��������� �������:' + E.Message);
        Exit;
      end;
    end;

    Result := True;
  finally
    CPInterface.Finalize;
    EUUnloadDLL();
  end;
{$ENDIF WIN64}

end;

function TdsdVchasnoEDIAction.OrderLoad : Boolean;
  var DataSetCDS: TClientDataSet;
begin
  Result := False;

  FDocTypeParam.Value := 1;
  FDocStatusParam.Value := 'new';

  // �������� ������ ������ � ������ EDI
  DataSetCDS := TClientDataSet.Create(Nil);
  try

    if not GetVchasnoEDI(1, DataSetCDS) then
      raise Exception.Create('������ �������� ������ ����������.');

    if DataSetCDS.RecordCount = 0 then
    begin
      //ShowMessages('��� ��������� ��� ��������.');
      Result := true;
      Exit;
    end;

    with TGaugeFactory.GetGauge(Caption, 0, DataSetCDS.RecordCount) do
    begin
      Start;
      try
        DataSetCDS.First;
        while not DataSetCDS.Eof do
        begin
          FOrderParam.Value := DataSetCDS.FieldByName('Id').AsString;
          if GetVchasnoEDI(2) then
          begin
            // �������� ��������
            case EDIDocType of
              ediOrder: EDI.OrderLoadVchasnoEDI(Copy(FResultParam.Value, Max(POS('<', FResultParam.Value), 1), Length(FResultParam.Value)),
                                                FFileNameParam.Value, DataSetCDS.FieldByName('deal_id').AsString, FspHeader, FspList);
            end;
          end;
          IncProgress(1);
          DataSetCDS.Next;
        end;
        Result := true;
      finally
        Finish;
      end;
    end;

  finally
    DataSetCDS.Free;
  end;

end;

function TdsdVchasnoEDIAction.OrdrspSave : Boolean;
  var Stream: TMemoryStream;
begin
  Result := False;
  if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
  begin

     Stream := TMemoryStream.Create;
     try
       EDI.ORDERSPSaveVchasnoEDI(HeaderDataSet, ListDataSet, Stream);
       FOrderParam.Value := HeaderDataSet.FieldByName('DealId').AsString;
       //FOrderParam.Value := '0f4a31d1-2bed-6837-562d-65f03ea5055a';
       //Stream.SaveToFile('C:\Work\1_Log\ORDERSPS\ORDERSPS_original.xml');
       //Stream.LoadFromFile('c:\Work\1_Log\ORDERSPS\ORDRSP_original.xml');
       Result := POSTVchasnoEDI(0, Stream);
     finally
       Stream.Free;
     end;
     //
     EDI.UpdateOrderORDERSPSaveVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger, not Result);
  end;

end;

function TdsdVchasnoEDIAction.DESADVSave : Boolean;
  var Stream: TMemoryStream;
begin
  Result := False;
  if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
  begin

     Stream := TMemoryStream.Create;
     try
       EDI.DESADVSaveVchasnoEDI(HeaderDataSet, ListDataSet, Stream);
       FOrderParam.Value := HeaderDataSet.FieldByName('DealId').AsString;
       //FOrderParam.Value := '0f4a31d1-2bed-6837-562d-65f03ea5055a';
       //Stream.SaveToFile('C:\Work\1_Log\ORDERSPS\DESADV_original.xml');
       //Stream.LoadFromFile('c:\Work\1_Log\ORDERSPS\DESADV_original.xml');
       Result := POSTVchasnoEDI(0, Stream);
     finally
       Stream.Free;
     end;
     //
     EDI.UpdateOrderDESADVSaveVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger, not Result);
  end;

end;

function TdsdVchasnoEDIAction.ComDocSave : Boolean;
  var Stream: TMemoryStream;
begin
  Result := False;
  if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
  begin

     Stream := TMemoryStream.Create;
     try
       EDI.ComDocSaveVchasnoEDI(HeaderDataSet, ListDataSet, Stream);
       FOrderParam.Value := HeaderDataSet.FieldByName('DealId').AsString;
       //FOrderParam.Value := '0f4a31d1-2bed-6837-562d-65f03ea5055a';
       //Stream.SaveToFile('C:\Work\1_Log\ORDERSPS\DELNOT00_original.xml');
       //Stream.LoadFromFile('c:\Work\1_Log\ORDERSPS\DELNOT_original.xml');
       Result := POSTVchasnoEDI(0, Stream);
     finally
       Stream.Free;
     end;
     //
     EDI.UpdateOrderDELNOTSaveVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger
                                       , FDocumentIdParam.Value, FVchasnoIdParam.Value
                                       , not Result
                                        );
  end;

end;

function TdsdVchasnoEDIAction.DoSignComDoc: Boolean;
begin
  Result := False;
  if HeaderDataSet.FieldByName('DocumentId_vch').AsString = '' then Exit;

  FOrderParam.Value := HeaderDataSet.FieldByName('DealId').AsString;
  FDocumentIdParam.Value := HeaderDataSet.FieldByName('DocumentId_vch').AsString;
  FVchasnoIdParam.Value := HeaderDataSet.FieldByName('VchasnoId').AsString;
  try

    // ������� ���� ���������
    Result := GetVchasnoEDI(5);
    //Result := GetDocETTN('4823036500001', '32d2bc90-577e-4e4c-af17-722b49cf1c86');

    if FileExists(FFileNameParam.Value + '.p7s') then DeleteFile(FFileNameParam.Value + '.p7s');
    if FileExists(FFileNameParam.Value + '_sign.p7s') then DeleteFile(FFileNameParam.Value + '_sign.p7s');
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then DeleteFile(FFileNameParam.Value + '_stamp.p7s');

    // ������� ����� 1
    if Result and (HeaderDataSet.FieldByName('UserSign').asString <> '') then
    begin
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSign').asString);
      if FileExists(FFileNameParam.Value + '.p7s') then
        RenameFile(FFileNameParam.Value + '.p7s', FFileNameParam.Value + '_sign.p7s');
    end;

    // ������� ����� 2
//    if Result and (HeaderDataSet.FieldByName('UserSeal').asString <> '') then
//    begin
//      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSeal').asString);
//      if FileExists(FFileNameParam.Value + '.p7s') then
//        RenameFile(FFileNameParam.Value + '.p7s', FFileNameParam.Value + '_stamp.p7s');
//    end;

    // �������� ����������� ������ eTTN
    if Result then Result := POSTSignVchasnoEDI;

    // ������� � ���� ��� ���� � ����
    EDI.UpdateOrderDELNOTSignVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger
                                       , not Result
                                        );

  finally
    // ������ ��������� �����
    if FileExists(FFileNameParam.Value) then DeleteFile(FFileNameParam.Value);
    if FileExists(FFileNameParam.Value + '.p7s') then DeleteFile(FFileNameParam.Value + '.p7s');
    if FileExists(FFileNameParam.Value + '_sign.p7s') then DeleteFile(FFileNameParam.Value + '_sign.p7s');
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then DeleteFile(FFileNameParam.Value + '_stamp.p7s');
  end;

end;

function TdsdVchasnoEDIAction.DoSendSignComDoc: Boolean;
  var cXML : String;
begin
  Result := ComDocSave;
  if Result then
  begin
    if (FResultParam.Value <> HeaderDataSet.FieldByName('EDIId').AsString) then
    begin
      HeaderDataSet.Edit;
      HeaderDataSet.FieldByName('EDIId').AsString := FResultParam.Value;
      HeaderDataSet.Post;
    end;
    Result := DoSignComDoc;
  end;
end;

procedure TdsdVchasnoEDIAction.ShowMessages(AMessage: String);
begin
  FErrorTextParam.Value := AMessage;
  if FShowErrorMessagesParam.Value then ShowMessage(AMessage);
end;

function TdsdVchasnoEDIAction.LocalExecute: Boolean;
begin

  FErrorTextParam.Value := '';
  case FEDIDocType of
    ediOrder : Result := OrderLoad;
    ediOrdrsp : Result := OrdrspSave;
    ediDesadv : Result := DESADVSave;
    ediComDocSave : Result := ComDocSave;

    ediComDocSign : Result := DoSignComDoc;
    ediComDocSendSign : Result := DoSendSignComDoc;

  else raise Exception.Create('�� ������� ����� ��������� ���� ����������.');
  end;

end;

  { TdsdEDINAction }

constructor TdsdEDINAction.Create(AOwner: TComponent);
begin
  inherited;

  FHostParam := TdsdParam.Create;
  FHostParam.DataType := ftString;
  FHostParam.Value := '';

  FTokenParam := TdsdParam.Create(nil);
  FTokenParam.DataType := ftString;
  FTokenParam.Value := '';

  FLoginParam := TdsdParam.Create(nil);
  FLoginParam.DataType := ftString;
  FLoginParam.Value := '';

  FPasswordParam := TdsdParam.Create(nil);
  FPasswordParam.DataType := ftString;
  FPasswordParam.Value := '';

  FResultParam := TdsdParam.Create(nil);
  FResultParam.DataType := ftString;
  FResultParam.Value := '';

  FKeyFileNameParam := TdsdParam.Create(nil);
  FKeyFileNameParam.DataType := ftString;
  FKeyFileNameParam.Value := '';

  FKeyUserNameParam := TdsdParam.Create(nil);
  FKeyUserNameParam.DataType := ftString;
  FKeyUserNameParam.Value := '';

  FErrorParam := TdsdParam.Create(nil);
  FErrorParam.DataType := ftString;
  FErrorParam.Value := '';

  FGLNParam := TdsdParam.Create(nil);
  FGLNParam.DataType := ftString;
  FGLNParam.Value := '';

  FGLN_SenderParam := TdsdParam.Create(nil);
  FGLN_SenderParam.DataType := ftString;
  FGLN_SenderParam.Value := '';

  FEDINActions:= edinSendETTN;
end;

destructor TdsdEDINAction.Destroy;
begin
  FreeAndNil(FPasswordParam);
  FreeAndNil(FLoginParam);
  FreeAndNil(FHostParam);
  FreeAndNil(FTokenParam);
  FreeAndNil(FResultParam);
  FreeAndNil(FKeyFileNameParam);
  FreeAndNil(FKeyUserNameParam);
  FreeAndNil(FErrorParam);
  FreeAndNil(FGLNParam);
  FreeAndNil(FGLN_SenderParam);
  inherited;
end;

function TdsdEDINAction.ShowError(AError : String): Boolean;
begin
  FErrorParam.Value := Copy(AError, 1, 255);
  if Assigned(FUpdateError) then FUpdateError.Execute;

  raise Exception.Create(AError);
end;

procedure TdsdEDINAction.UAECMREDI(var AXML: String);
var UAECMR: IXMLUAECMRType;
    cDS : Char;
begin
  cDS := FormatSettings.DecimalSeparator;
  try
    FormatSettings.DecimalSeparator := '.';

    if (HeaderDataSet.FieldByName('GLN_car').asString = '') or
       (HeaderDataSet.FieldByName('GLN_from').asString = '') or
       (HeaderDataSet.FieldByName('GLN_to').asString = '') or
       (HeaderDataSet.FieldByName('GLN_Unloading').asString = '') or
       (HeaderDataSet.FieldByName('GLN_Unit').asString = '') or
       (HeaderDataSet.FieldByName('GLN_Driver').asString = '') or
       (HeaderDataSet.FieldByName('KATOTTG_Unit').asString = '') {or
       (HeaderDataSet.FieldByName('KATOTTG_Unloading').asString = '')} then
       ShowError('�� ���������:' +
                 IfThen(HeaderDataSet.FieldByName('GLN_car').asString = '', ' GLN ��� ����������;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_from').asString = '', ' GLN ��� ���������;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_to').asString = '', ' GLN ��� �����������������;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_Unit').asString = '', ' GLN ��� ����� ������������;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_Unloading').asString = '', ' GLN ��� ������ �������������;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_Driver').asString = '', ' GLN ��� ����;', '') +
                 IfThen(HeaderDataSet.FieldByName('KATOTTG_Unit').asString = '', ' ������� ������ ������������;', '') {+
                 IfThen(HeaderDataSet.FieldByName('KATOTTG_Unloading').asString = '', ' ������� ������ �������������;', '')});

    // ������� XML
    UAECMR := UAECMRXML.NewUAECMR;
    // ***** ������� ����� ���������
    UAECMR.ECMR.ExchangedDocumentContext.SpecifiedTransactionID := '0';
    UAECMR.ECMR.ExchangedDocumentContext.BusinessProcessSpecifiedDocumentContextParameter.ID := 'urn:ua:e-transport.gov.ua:ettn:01';
    UAECMR.ECMR.ExchangedDocumentContext.GuidelineSpecifiedDocumentContextParameter.ID := 'urn:ua:e-transport.gov.ua:ettn:01:generic:001';

    // ***** �������� ���
    // ���������� ����� (����) ��������� ���
    UAECMR.ECMR.ExchangedDocument.ID := HeaderDataSet.FieldByName('InvNumber').asString;
    // ���� � ��� ��������� ��������� (����������� ���)
    UAECMR.ECMR.ExchangedDocument.IssueDateTime.DateTime := gfFormatToDateTime (HeaderDataSet.FieldByName('OperDate').AsDateTime);
    // ����� ������
//    // CA - ���������
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_car').asString; // '9864232596110';
//      Content := 'CA';
//    end;
//    // OB - ��������
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_from').asString; // '9864232596127';
//      Content := 'OB';
//    end;
//    // CZ - ����������������
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_from').asString; // '9864065749080'
//      Content := 'CZ';
//    end;
//    // CN - ����������������
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_to').asString; // '9864232596127';
//      Content := 'CN';
//    end;
//
//    // DR - ����
//    if HeaderDataSet.FieldByName('GLN_Driver').asString <> '' then
//      with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//      begin
//        ContentCode.ListAgencyID := 'GLN';
//        ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_Driver').asString; // '9864232596745';
//        Content := 'DR';
//      end;

    // ̳��� ��������� ���������
    UAECMR.ECMR.ExchangedDocument.IssueLogisticsLocation.Name := HeaderDataSet.FieldByName('PlaceOf').asString;
    UAECMR.ECMR.ExchangedDocument.IssueLogisticsLocation.Description := HeaderDataSet.FieldByName('PlaceOfDescription').asString;

    // ***** ���������� ��� �����������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.GrossWeightMeasure.UnitCode := 'KGM';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.GrossWeightMeasure.NodeValue := RoundTo(HeaderDataSet.FieldByName('Weight_all').AsCurrency, -1);
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.GrossWeightMeasure;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.AssociatedInvoiceAmount.CurrencyID := 'UAH';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.AssociatedInvoiceAmount.NodeValue := RoundTo(HeaderDataSet.FieldByName('TotalSumm').AsCurrency, -2);
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignmentItemQuantity := HeaderDataSet.FieldByName('TotalCountKg').AsFloat;

    // * ����������������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.Id.SchemeAgencyID := '������';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.Id.NodeValue := HeaderDataSet.FieldByName('OKPO_From').asString; // 32132132;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString; // '��� "����������������_v3"';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.RoleCode := 'CZ';
      // �������� ������������� ������������
    if HeaderDataSet.FieldByName('ConsignorPersonINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := '������';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.SpecifiedTaxRegistration.ID.NodeValue := HeaderDataSet.FieldByName('ConsignorPersonINN').asString;;
    end;
    if HeaderDataSet.FieldByName('ConsignorPersonName').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.DefinedTradeContact.PersonName := HeaderDataSet.FieldByName('ConsignorPersonName').asString;
    if HeaderDataSet.FieldByName('ConsignorPersonTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.DefinedTradeContact.TelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('ConsignorPersonTelephone').asString;;
    if HeaderDataSet.FieldByName('ConsignorPersonMobileTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.DefinedTradeContact.MobileTelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('ConsignorPersonMobileTelephone').asString;;
    if HeaderDataSet.FieldByName('ConsignorPersonEmailURI').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.DefinedTradeContact.EmailURIUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('ConsignorPersonEmailURI').asString;;
    if HeaderDataSet.FieldByName('PostcodeCode_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.PostalTradeAddress.PostcodeCode := HeaderDataSet.FieldByName('PostcodeCode_From').asString;
    if HeaderDataSet.FieldByName('StreetName_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.PostalTradeAddress.StreetName := HeaderDataSet.FieldByName('StreetName_From').asString;
    if HeaderDataSet.FieldByName('CityName_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.PostalTradeAddress.CityName := HeaderDataSet.FieldByName('CityName_From').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.PostalTradeAddress.CountryID := 'UA';
    if HeaderDataSet.FieldByName('CountrySubDivisionName_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.PostalTradeAddress.CountrySubDivisionName := HeaderDataSet.FieldByName('CountrySubDivisionName_From').asString;

    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.SpecifiedGovernmentRegistration.ID := HeaderDataSet.FieldByName('GLN_from').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.SpecifiedGovernmentRegistration.TypeCode := 'TRADEPARTY_GLN';

    // * ����������������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.Id.SchemeAgencyID := '������';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.Id.NodeValue := HeaderDataSet.FieldByName('OKPO_To').asString; // '32135483';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString; // '��� "����������������_v3" (����)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.RoleCode := 'CN';
      // �������� ������������� ������������
    if HeaderDataSet.FieldByName('ConsigneePersonINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := '������';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.SpecifiedTaxRegistration.ID.NodeValue := HeaderDataSet.FieldByName('ConsigneePersonINN').asString;;
    end;
    if HeaderDataSet.FieldByName('ConsigneePersonName').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.DefinedTradeContact.PersonName := HeaderDataSet.FieldByName('ConsigneePersonName').asString;
    if HeaderDataSet.FieldByName('ConsigneePersonTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.DefinedTradeContact.TelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('ConsigneePersonTelephone').asString;;
    if HeaderDataSet.FieldByName('ConsigneePersonMobileTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.DefinedTradeContact.MobileTelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('ConsigneePersonMobileTelephone').asString;;
    if HeaderDataSet.FieldByName('ConsigneePersonEmailURI').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.DefinedTradeContact.EmailURIUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('ConsigneePersonEmailURI').asString;;
    if HeaderDataSet.FieldByName('PostcodeCode_To').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.PostalTradeAddress.PostcodeCode := HeaderDataSet.FieldByName('PostcodeCode_To').asString;
    if HeaderDataSet.FieldByName('StreetName_To').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.PostalTradeAddress.StreetName := HeaderDataSet.FieldByName('StreetName_To').asString;
    if HeaderDataSet.FieldByName('CityName_To').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.PostalTradeAddress.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.PostalTradeAddress.CountryID := 'UA';
    if HeaderDataSet.FieldByName('CountrySubDivisionName_To').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.PostalTradeAddress.CountrySubDivisionName := HeaderDataSet.FieldByName('CountrySubDivisionName_To').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.SpecifiedGovernmentRegistration.ID := HeaderDataSet.FieldByName('GLN_to').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.SpecifiedGovernmentRegistration.TypeCode := 'TRADEPARTY_GLN';

    // * ���������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.Id.SchemeAgencyID := '������';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.Id.NodeValue := HeaderDataSet.FieldByName('OKPO_car').asString; // '32131212';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_car').asString; // '��� "���������_v3" (����)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.RoleCode := 'CA';
      // �������� ����
    if HeaderDataSet.FieldByName('DriverINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := '������';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.SpecifiedTaxRegistration.ID.NodeValue := HeaderDataSet.FieldByName('DriverINN').asString;;
    end;
    if HeaderDataSet.FieldByName('PersonalDriverName').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.DefinedTradeContact.PersonName := HeaderDataSet.FieldByName('PersonalDriverName').asString;
    if HeaderDataSet.FieldByName('DriverTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.DefinedTradeContact.TelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('DriverTelephone').asString;;
    if HeaderDataSet.FieldByName('DriverMobileTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.DefinedTradeContact.MobileTelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('DriverMobileTelephone').asString;;
    if HeaderDataSet.FieldByName('DriverEmailURI').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.DefinedTradeContact.EmailURIUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('DriverEmailURI').asString;;
    if HeaderDataSet.FieldByName('PostcodeCode_car').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.PostalTradeAddress.PostcodeCode := HeaderDataSet.FieldByName('PostcodeCode_car').asString;
    if HeaderDataSet.FieldByName('StreetName_car').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.PostalTradeAddress.StreetName := HeaderDataSet.FieldByName('StreetName_car').asString;
    if HeaderDataSet.FieldByName('CityName_car').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.PostalTradeAddress.CityName := HeaderDataSet.FieldByName('CityName_car').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.PostalTradeAddress.CountryID := 'UA';
    if HeaderDataSet.FieldByName('CountrySubDivisionName_car').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.PostalTradeAddress.CountrySubDivisionName := HeaderDataSet.FieldByName('CountrySubDivisionName_car').asString;
    if HeaderDataSet.FieldByName('DriverCertificate').asString <> '' then
      with UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.SpecifiedGovernmentRegistration.Add do
      begin
        ID := HeaderDataSet.FieldByName('DriverCertificate').asString; // '3234715572';
      end;
    with UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.SpecifiedGovernmentRegistration.Add do
    begin
      ID := HeaderDataSet.FieldByName('GLN_Driver').asString;
      TypeCode := 'DRIVER_GLN';
    end;
    with UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.SpecifiedGovernmentRegistration.Add do
    begin
      ID := HeaderDataSet.FieldByName('GLN_car').asString;
      TypeCode := 'TRADEPARTY_GLN';
    end;

    // * ��������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.ID.SchemeAgencyID := '������';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.ID.NodeValue := HeaderDataSet.FieldByName('OKPO_From').asString; // '32135483';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString; // '��� "����������������_v3" (����)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.RoleCode := 'OB';
      // �������� ������������� ������������
    if HeaderDataSet.FieldByName('NotifiedPersonINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := '������';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedTaxRegistration.ID.NodeValue := HeaderDataSet.FieldByName('NotifiedPersonINN').asString;;
    end;
    if HeaderDataSet.FieldByName('NotifiedPersonName').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.DefinedTradeContact.PersonName := HeaderDataSet.FieldByName('NotifiedPersonName').asString;
    if HeaderDataSet.FieldByName('NotifiedPersonTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.DefinedTradeContact.TelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('NotifiedPersonTelephone').asString;;
    if HeaderDataSet.FieldByName('NotifiedPersonMobileTelephone').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.DefinedTradeContact.MobileTelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('NotifiedPersonMobileTelephone').asString;;
    if HeaderDataSet.FieldByName('NotifiedPersonEmailURI').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.DefinedTradeContact.EmailURIUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('NotifiedPersonEmailURI').asString;;
    if HeaderDataSet.FieldByName('PostcodeCode_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.PostalTradeAddress.PostcodeCode := HeaderDataSet.FieldByName('PostcodeCode_From').asString;
    if HeaderDataSet.FieldByName('StreetName_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.PostalTradeAddress.StreetName := HeaderDataSet.FieldByName('StreetName_From').asString;
    if HeaderDataSet.FieldByName('CityName_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.PostalTradeAddress.CityName := HeaderDataSet.FieldByName('CityName_From').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.PostalTradeAddress.CountryID := 'UA';
    if HeaderDataSet.FieldByName('CountrySubDivisionName_From').asString <> '' then
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.PostalTradeAddress.CountrySubDivisionName := HeaderDataSet.FieldByName('CountrySubDivisionName_From').asString;
      // * ���������������� ��� ����������� �����
    //UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedGovernmentRegistration.ID := 'XYZ000012';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedGovernmentRegistration.ID := HeaderDataSet.FieldByName('GLN_from').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedGovernmentRegistration.TypeCode := 'TRADEPARTY_GLN';

    // ����� ������������
    if HeaderDataSet.FieldByName('KATOTTG_Unit').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.ID.SchemeAgencyID := '�������';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.ID.NodeValue := HeaderDataSet.FieldByName('KATOTTG_Unit').asString;
    end;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.Name := HeaderDataSet.FieldByName('Name_Unit').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.TypeCode := 5;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.Description := HeaderDataSet.FieldByName('Address_Unit').asString;
    if HeaderDataSet.FieldByName('GLN_Unit').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.PhysicalGeographicalCoordinate.SystemID.SchemeAgencyID := 'GLN';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.PhysicalGeographicalCoordinate.SystemID.NodeValue := HeaderDataSet.FieldByName('GLN_Unit').asString;
    end;;

    // ����� �������������
    if HeaderDataSet.FieldByName('KATOTTG_Unloading').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.ID.SchemeAgencyID := '�������';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.ID.NodeValue := HeaderDataSet.FieldByName('KATOTTG_Unloading').asString;
    end;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString; // '��� "����������������_v3" (����)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.TypeCode := 10;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.Description := HeaderDataSet.FieldByName('PartnerAddress_Unloading').asString; // '������, 12351, ������� ���,  �������� �-�, �. ����, ���. �������, 1';
    //UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.LatitudeMeasure := '50.4489298';
    //UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.LatitudeMeasure := '30.5194162';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.SystemID.SchemeAgencyID := 'GLN';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.SystemID.NodeValue := HeaderDataSet.FieldByName('GLN_Unloading').asString; // 9864232596127;

    // ��������������� ������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.DeliveryTransportEvent.Description := '�������������';
      // �������� ���� �������� (���������������� - CN)
    if HeaderDataSet.FieldByName('DeliveryCN_PersonName').asString <> '' then
    begin
      with UAECMR.ECMR.SpecifiedSupplyChainConsignment.DeliveryTransportEvent.CertifyingTradeParty.Add do
      begin
        Name := '�������';
        RoleCode := 'CN';
        if HeaderDataSet.FieldByName('DeliveryCN_PersonINN').asString <> '' then
        begin
          SpecifiedTaxRegistration.ID.SchemeAgencyID := '������';
          SpecifiedTaxRegistration.ID.NodeValue := HeaderDataSet.FieldByName('DeliveryCN_PersonINN').asString;;
        end;
        if HeaderDataSet.FieldByName('DeliveryCN_PersonName').asString <> '' then
          DefinedTradeContact.PersonName := HeaderDataSet.FieldByName('DeliveryCN_PersonName').asString;
        if HeaderDataSet.FieldByName('DeliveryCN_PersonTelephone').asString <> '' then
          DefinedTradeContact.TelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('DeliveryCN_PersonTelephone').asString;;
        if HeaderDataSet.FieldByName('DeliveryCN_PersonMobileTelephone').asString <> '' then
          DefinedTradeContact.MobileTelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('DeliveryCN_PersonMobileTelephone').asString;;
        if HeaderDataSet.FieldByName('DeliveryCN_PersonEmailURI').asString <> '' then
          DefinedTradeContact.EmailURIUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('DeliveryCN_PersonEmailURI').asString;;
      end;
    end;

    // �������������� ������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.Description := '������������';
    if HeaderDataSet.FieldByName('PickUpCZ_PersonName').asString <> '' then
    begin
      with UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.Add do
      begin
        Name := '�������';
        RoleCode := 'CZ';
        if HeaderDataSet.FieldByName('PickUpCZ_PersonINN').asString <> '' then
        begin
          SpecifiedTaxRegistration.ID.SchemeAgencyID := '������';
          SpecifiedTaxRegistration.ID.NodeValue := HeaderDataSet.FieldByName('PickUpCZ_PersonINN').asString;;
        end;
        if HeaderDataSet.FieldByName('PickUpCZ_PersonName').asString <> '' then
          DefinedTradeContact.PersonName := HeaderDataSet.FieldByName('PickUpCZ_PersonName').asString;
        if HeaderDataSet.FieldByName('PickUpCZ_PersonTelephone').asString <> '' then
          DefinedTradeContact.TelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('PickUpCZ_PersonTelephone').asString;;
        if HeaderDataSet.FieldByName('PickUpCZ_PersonMobileTelephone').asString <> '' then
          DefinedTradeContact.MobileTelephoneUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('PickUpCZ_PersonMobileTelephone').asString;;
        if HeaderDataSet.FieldByName('PickUpCZ_PersonEmailURI').asString <> '' then
          DefinedTradeContact.EmailURIUniversalCommunication.CompleteNumber := HeaderDataSet.FieldByName('PickUpCZ_PersonEmailURI').asString;;
      end;
    end;

  //  UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.Name := '����';
  //  UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.RoleCode := 'DR';
  //  UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.DefinedTradeContact.PersonName := '�������� ��������� ���������'; //HeaderDataSet.FieldByName('PersonalDriverName').asString;

    // ³������ ��� ������
    ListDataSet.First;
    while not ListDataSet.Eof do
    begin
      with UAECMR.ECMR.SpecifiedSupplyChainConsignment.IncludedSupplyChainConsignmentItem.Add do
      begin
        SequenceNumeric := ListDataSet.RecNo;
//        InvoiceAmount.CurrencyID := 'UAH';
//        InvoiceAmount.NodeValue := RoundTo(ListDataSet.FieldByName('AmountSummWVAT').AsCurrency, -2);
        GrossWeightMeasure.UnitCode := 'KGM';
        GrossWeightMeasure.NodeValue := RoundTo(ListDataSet.FieldByName('TotalWeight_BruttoKg').AsCurrency, -2);
//        TariffQuantity.UnitCode := 'UAH';
//        TariffQuantity.NodeValue := RoundTo(ListDataSet.FieldByName('pricenovat').AsCurrency, -2);
        TransportLogisticsPackage.ItemQuantity := ListDataSet.FieldByName('Amount_Weight').AsFloat;
        TransportLogisticsPackage.Type_ := ListDataSet.FieldByName('MeasureName').AsString;
        //GlobalID.SchemeAgencyID := '������';
        //GlobalID.NodeValue := 500;
        NatureIdentificationTransportCargo.Identification := ListDataSet.FieldByName('goodsname').AsString;
        //ApplicableTransportDangerousGoods.UNDGIdentificationCode := 0;
        //ApplicableTransportDangerousGoods.PackagingDangerLevelCode := 1;
        //AssociatedReferencedLogisticsTransportEquipment.ID := '123456789-123';
        //TransportLogisticsPackage.ItemQuantity := 100;
        //TransportLogisticsPackage.TypeCode := 'SA';
        //TransportLogisticsPackage.Type_ := '��';
        //TransportLogisticsPackage.PhysicalLogisticsShippingMarks.Marking := '��������� � ����';
        //TransportLogisticsPackage.PhysicalLogisticsShippingMarks.BarcodeLogisticsLabel.ID := '��������� � ����';
      end;
      ListDataSet.Next;
    end;

    // ���������
    with UAECMR.ECMR.SpecifiedSupplyChainConsignment.UtilizedLogisticsTransportEquipment.Add do
    begin
      ID := HeaderDataSet.FieldByName('CarName').asString;
      if HeaderDataSet.FieldByName('CarBrandName').asString <> '' then
        with ApplicableNote.Add do
        begin
          ContentCode := 'BRAND';
          Content := HeaderDataSet.FieldByName('CarBrandName').asString;
        end;
      if HeaderDataSet.FieldByName('CarModelName').asString <> '' then
        with ApplicableNote.Add do
        begin
          ContentCode := 'MODEL';
          Content := HeaderDataSet.FieldByName('CarModelName').asString;
        end;
      if HeaderDataSet.FieldByName('CarColorName').asString <> '' then
        with ApplicableNote.Add do
        begin
          ContentCode := 'COLOR';
          Content := HeaderDataSet.FieldByName('CarColorName').asString;
        end;
      if HeaderDataSet.FieldByName('CarTypeName').asString <> '' then
        with ApplicableNote.Add do
        begin
          ContentCode := 'TYPE';
          Content := HeaderDataSet.FieldByName('CarTypeName').asString;
        end;
    end;
    // ��������� (������)
    if HeaderDataSet.FieldByName('CarTrailerName').asString <> '' then
    begin
      with UAECMR.ECMR.SpecifiedSupplyChainConsignment.UtilizedLogisticsTransportEquipment.Add do
      begin
        ID := HeaderDataSet.FieldByName('CarTrailerName').asString;
        CategoryCode := 'TE';
        CharacteristicCode := 14;
        if HeaderDataSet.FieldByName('CarTrailerBrandName').asString <> '' then
          with ApplicableNote.Add do
          begin
            ContentCode := 'BRAND';
            Content := HeaderDataSet.FieldByName('CarTrailerBrandName').asString;
          end;
        if HeaderDataSet.FieldByName('CarTrailerModelName').asString <> '' then
          with ApplicableNote.Add do
          begin
            ContentCode := 'MODEL';
            Content := HeaderDataSet.FieldByName('CarTrailerModelName').asString;
          end;
      if HeaderDataSet.FieldByName('CarTrailerColorName').asString <> '' then
        with ApplicableNote.Add do
        begin
          ContentCode := 'COLOR';
          Content := HeaderDataSet.FieldByName('CarTrailerColorName').asString;
        end;
      if HeaderDataSet.FieldByName('CarTrailerTypeName').asString <> '' then
        with ApplicableNote.Add do
        begin
          ContentCode := 'TYPE';
          Content := HeaderDataSet.FieldByName('CarTrailerTypeName').asString;
        end;
      end;
    end;

    // ��� ����������
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.DeliveryInstructions.Description := HeaderDataSet.FieldByName('DeliveryInstructionsName').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.DeliveryInstructions.DescriptionCode := 'TRANSPORTATION_TYPE';

    UAECMR.OwnerDocument.SaveToXML(AXML);
    UAECMR.OwnerDocument.SaveToFile('111.xml');
  finally
    FormatSettings.DecimalSeparator := cDS;
  end;
end;

function TdsdEDINAction.SignData(UserSign : String) : boolean;
var
  apath: String;
{$IFDEF WIN64}
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine, SignFile, FileKeyName, FileName: String;
  f: TIniFile;
{$ELSE}
  FileName: AnsiString;
  CPInterface: PEUSignCP;
  CertOwnerInfo : TEUCertOwnerInfo;
  Param : DWORD;
  nError : integer;
{$ENDIF WIN64}
begin

  Result := False;

  apath := 'c:\Program Files (x86)\Institute of Informational Technologies\Certificate Authority-1.3\End User\';
  if not FileExists(apath + String(EUDLLName)) then
  begin
    apath := 'c:\Program Files\Institute of Informational Technologies\Certificate Authority-1.3\End User\';
    if not FileExists(apath + String(EUDLLName)) then
    begin
      ShowError('������ �� ������ ���� ���������� �������: ' + EUDLLName);
    end;
  end;

{$IFDEF WIN64}

  SignFile := ExtractFilePath(ParamStr(0)) + 'SignFile.exe';

  if not FileExists(SignFile) then
  begin
    ShowError('������ �� ������� ��������� ����������: ' + SignFile);
  end;

  // 1.��������� ������
  if ExtractFilePath(UserSign) <> ''
  then FileKeyName := AnsiString(UserSign)
  else FileKeyName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

  // ��������
  if not FileExists(String(FileKeyName)) then ShowError('���� �� ������ : <'+String(FileKeyName)+'>');

  FKeyFileNameParam.Value := ExtractFileName(String(FileKeyName));

  FileName := AnsiString(ExtractFilePath(ParamStr(0)) + FResultParam.Value);
  // ��������
  if not FileExists(String(FileName)) then ShowError('���� tTTN �� ������ : <'+String(FileName)+'>');

  CmdLine := '"' + SignFile + '" "' + apath + '" "' + FileKeyName + '" "24447183" "' + FileName + '"';

  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
  end;

  // ��������� ������� �������
  // ������� ���������� ����������
  if CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false,
                   CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                   PChar(ExtractFilePath(FileName)), StartInfo, ProcInfo) then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    // Free the Handles
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;

  FileName := ExtractFilePath(ParamStr(0)) + 'SignFileResult.dat';

  if not FileExists(FileName) then
  begin
    ShowError('������ �� ������� ��������� ������ ��������� ����������: ' + FileName);
  end;

  f := TiniFile.Create(FileName);

  try
    try
      if F.ReadString('SignResult', '������', '') = '' then
      begin
        FKeyUserNameParam.Value := F.ReadString('SignResult', 'UserName', '');
        Result := True;
      end else ShowError('������ ' + F.ReadString('SignResult', '������', ''));;
    Except
    end;
  finally
    f.Free;
  end;
  DeleteFile(FileName);

{$ELSE}

  if not EULoadDLL(apath) then
  begin
    ShowError('������ �� ��������� ���������� �������: ' + EUDLLName);
  end;
  CPInterface := EUGetInterface();
  if CPInterface = nil then
  begin
    EUUnloadDLL();
    ShowError('������ �� ��������� ���������� �������: ' + EUDLLName);
  end;
  CPInterface.SetUIMode(false);
  EUInitializeOwnUI(CPInterface, true);
  try

    nError := CPInterface.Initialize();
    if nError <> EU_ERROR_NONE then
    begin
      ShowError('������ ������������� ���������� �������: ' + EUDLLName);
    end;
    if ShiftDown then
    begin
       CPInterface.SetUIMode(true);
       CPInterface.SetSettings;
    end;

    CPInterface.SetUIMode(false);

    Param := EU_SIGN_TYPE_CADES_X_LONG;
    CPInterface.SetRuntimeParameter(PAnsiChar(EU_SIGN_TYPE_PARAMETER), @Param, sizeof(Param));

    try
      CPInterface.ResetPrivateKey;
    except
      on E: Exception do
      begin
        ShowError('������ � ���������� �������: ' + E.Message);
      end;
    end;

    try
      // 1.��������� ������
      if ExtractFilePath(UserSign) <> ''
      then FileName := AnsiString(UserSign)
      else FileName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

      // ��������
      if not FileExists(String(FileName)) then ShowError('���� �� ������ : <'+String(FileName)+'>');

      FKeyFileNameParam.Value := ExtractFileName(String(FileName));

      nError := CPInterface.ReadPrivateKeyFile (PAnsiChar(FileName), PAnsiChar('24447183'), @CertOwnerInfo); // ���������
      if nError <> EU_ERROR_NONE then
      begin
        ShowError('������ � ���������� ��� �������� ������������ �����: ' + CPInterface.GetErrorDesc(nError));
      end;

      FKeyUserNameParam.Value := String(CertOwnerInfo.SubjectFullName);
    except
      on E: Exception do
      begin
        ShowError('������ � ���������� ��� �������� ������������ �����:' + E.Message);
      end;
    end;

    try
      // 2.��������������� �������
      FileName := AnsiString(ExtractFilePath(ParamStr(0)) + FResultParam.Value);
      // ��������
      if not FileExists(String(FileName)) then ShowError('���� tTTN �� ������ : <'+String(FileName)+'>');

      nError := CPInterface.SignFile(PAnsiChar(FileName), PAnsiChar(FileName + '.p7s'), True);
      if nError <> EU_ERROR_NONE then
      begin
        ShowError('������ � ���������� ��� ��������� �������: ' + CPInterface.GetErrorDesc(nError));
      end;
    except
      on E: Exception do
      begin
        ShowError('������ � ���������� ��� ��������� �������:' + E.Message);
      end;
    end;

    Result := True;
  finally
    CPInterface.Finalize;
    EUUnloadDLL();
  end;
{$ENDIF WIN64}

end;

function TdsdEDINAction.GetToken: Boolean;
  var IdHTTP: TCustomIdHTTP;
      S: String;
      SL: TStringList;
      jsonObj: TJSONObject;
begin
  Result := False;
  FTokenParam.Value := '';

  if (FPasswordParam.Value = '') or
     (FLoginParam.Value = '') or
     (FHostParam.Value = '') then
  begin
    ShowError('�� ��������� Host, ����� ��� ������.');
    Exit;
  end;

  // ��������������� ��������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    SL := TStringList.Create;
    try
      try
        SL.Add('email=' + FLoginParam.Value);
        SL.Add('password=' + FPasswordParam.Value);
        S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + '/api/authorization/hash'), SL);
      except on E:EIdHTTPProtocolException  do
                  ShowError('������ ��������� ������: ' + e.ErrorMessage);
      end;
    finally
      SL.Free;
    end;

    if IdHTTP.ResponseCode = 200 then
    begin
      jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
      try
        if jsonObj.Get('SID') <> nil then
        begin
          FTokenParam.Value := jsonObj.Get('SID').JsonValue.Value;
          Result := True;
        end;
      finally
        FreeAndNil(jsonObj);
      end;
    end;
  finally
    IdHTTP.Free;
  end;
end;

function TdsdEDINAction.SendETTN(AGLN, AUuId, AXML : String): Boolean;
  var IdHTTP: TCustomIdHTTP;
      S, Params: String;
      Steam: TStringStream;
      jsonObj: TJSONObject;
begin
  Result := False;

  if FTokenParam.Value = '' then
  begin
    ShowError('�� ������� ����. �������� ���� ����������.');
    Exit;
  end;

  // ��������������� ��������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/xml';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '?gln=' + AGLN;
    if AUuId <> '' then Params := Params + '&doc_uuid=' + AUuId;

    Steam := TStringStream.Create(AXML, TEncoding.UTF8);
    try
      try
        S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + '/api/eds/doc/ettn/ttn' + Params), Steam);
      except on E:EIdHTTPProtocolException  do
                  ShowError('������ �������� ���: ' + e.ErrorMessage);
      end;
    finally
      Steam.Free;
    end;

    if IdHTTP.ResponseCode = 200 then
    begin
      jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
      try
        if jsonObj.Get('doc_uuid') <> nil then
        begin
          FResultParam.Value := jsonObj.Get('doc_uuid').JsonValue.Value;
          Result := True;
        end;
      finally
        FreeAndNil(jsonObj);
      end;
    end;
  finally
    IdHTTP.Free;
  end;
end;

function TdsdEDINAction.GetDocETTN(AGLN, AUuId : String): Boolean;
  var IdHTTP: TCustomIdHTTP;
      Params: String;
      Steam: TMemoryStream;
begin
  Result := False;

  if FTokenParam.Value = '' then
  begin
    ShowError('�� ������� ����. �������� ����� ���� ����������.');
    Exit;
  end;

  // ��������������� �������� ����� ��� �������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '?gln=' + AGLN + '&doc_uuid=' + AUuId + '&format=ecmr&response_type=file';

    Steam := TMemoryStream.Create;
    try
      try
        IdHTTP.Get(TIdURI.URLEncode(FHostParam.Value + '/api/eds/doc/ettn/body' + Params), Steam);
      except on E:EIdHTTPProtocolException  do
                  ShowError('������ ��������� ����� ���: ' + e.ErrorMessage);
      end;

      if IdHTTP.ResponseCode = 200 then
      begin
        FResultParam.Value := IdHTTP.Response.RawHeaders.Params['Content-Disposition', 'filename'];
        Steam.SaveToFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value);
        Result := True;
      end;
    finally
      Steam.Free;
    end;
  finally
    IdHTTP.Free;
  end;
end;

function TdsdEDINAction.GetIdentifiers(AGLN, AQuery : String): Boolean;
  var IdHTTP: TCustomIdHTTP;
      S, Params: String;
      jsonArray: TJSONArray;
      List : TStringList;
begin
  Result := False;

  if FTokenParam.Value = '' then
  begin
    ShowError('�� ������� ����. �������� ����� ���� ����������.');
    Exit;
  end;

  // ��������������� �������� ����� ��� �������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '?gln=' + AGLN + '&query=' + AQuery; // + '&katottg_required=true';

    try
      List := TStringList.Create;
      try
        List.Add(TIdURI.URLEncode(FHostParam.Value + '/api/oas/identifiers' + Params));
        List.SaveToFile('GetKATOTTG.txt');
      finally
        List.Free;
      end;

      S := IdHTTP.Get(TIdURI.URLEncode(FHostParam.Value + '/api/oas/identifiers' + Params));
    except on E:EIdHTTPProtocolException  do
                ShowError('������ ������ ������� ����� ��������: ' + e.ErrorMessage);
    end;

    if IdHTTP.ResponseCode = 200 then
    begin
      jsonArray := TJSONObject.ParseJSONValue(S) as TJSONArray;
      if jsonArray.Size = 1 then
      begin
        if (TJSONObject(jsonArray.Get(0)).Get('katottg') <> nil) and
           (TJSONObject(jsonArray.Get(0)).Get('katottg').JsonValue.Value <> '') then
        begin
          FResultParam.Value := TJSONObject(jsonArray.Get(0)).Get('katottg').JsonValue.Value;
          if Assigned(FUpdateKATOTTG) then FUpdateKATOTTG.Execute;
          HeaderDataSet.Edit;
          HeaderDataSet.FieldByName('KATOTTG_Unloading').asString := FResultParam.Value;
          HeaderDataSet.Post;
          Result := True;
        end else
        begin
          FErrorParam.Value := '������ ������ ������� ����� ��������: �� ��������� � ������ ���� EDI';
          if Assigned(FUpdateError) then FUpdateError.Execute;
          Result := True;
        end;
      end else ShowError('������ ������ ������� ����� ��������: ���������� ������� �� gln ����� �������� ����� �����.');
    end;
  finally
    IdHTTP.Free;
    FResultParam.Value := '';
  end;
end;

function TdsdEDINAction.SignDcuETTN(AGLN, AUuId : String): Boolean;
  var IdHTTP: TCustomIdHTTP;
      S, Params: String;
      fileStream: TFileStream;
      base64Stream: TStringStream;
      Stream: TStringStream;
begin
  Result := False;

  if FTokenParam.Value = '' then
  begin
    ShowError('�� ������� ����. ������� ���� ����������.');
    Exit;
  end;

  // ��������������� �������� ����� ��� �������

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
    //IdHTTP.Request.Accept := '*/*';
    //IdHTTP.Request.Connection := 'keep-alive';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '?gln=' + AGLN;

    case FEDINActions of
      edinSignConsignor, edinSendSingETTN : Params := Params + '&role_code=CZ';
      edinSignCarrier  : Params := Params + '&role_code=CA';
    else ShowError('�� ������� ���� ������ eTTN.');
    end;

    Params := Params + '&doc_uuid=' + AUuId;

    fileStream := TFileStream.Create(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s', fmOpenRead);
    base64Stream := TStringStream.Create('', TEncoding.UTF8);
    try
      try
        EncodeStream(fileStream, base64Stream);
        Stream := TStringStream.Create('["' + base64Stream.DataString + '"]', TEncoding.UTF8);
        try
          S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + '/api/eds/doc/ettn/sign' + Params), Stream);
        finally
          FreeAndNil(Stream);
        end;
      except on E:EIdHTTPProtocolException  do
                  ShowError('������: ' + e.ErrorMessage);
      end;
    finally
      FreeAndNil(fileStream);
      FreeAndNil(base64Stream);
    end;

    if IdHTTP.ResponseCode = 200 then
    begin
      Result := True;
    end;
  finally
    IdHTTP.Free;
  end;
end;

function TdsdEDINAction.LoadInvoiceNR�ontent(AUUID : String; var AjsonItem: TJSONObject): Boolean;
  var IdHTTP: TCustomIdHTTP;
      Params: String;
      Body: String;
      S: String;
      Steam: TStringStream;
      jsonItem : TJSONObject;
begin
  Result := False;

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '?gln=' + FGLNParam.Value;
    Body := '[' + AUUID + ']';

    Steam := TStringStream.Create(Body, TEncoding.UTF8);
    try
      try
        S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + '/api/v2/eds/doc/content' + Params), Steam);
      except on E:EIdHTTPProtocolException  do
                  ShowError('������ ��������� ��������� �� ����������": ' + e.ErrorMessage);
      end;

      if IdHTTP.ResponseCode = 200 then
      begin

        jsonItem := TJSONObject.ParseJSONValue(S) as TJSONObject;
        AjsonItem := TJSONObject.ParseJSONValue(jsonItem.Get(AUUID).JsonValue.Value) AS TJSONObject;

        Result := True;
      end;
    finally
      Steam.Free;
    end;
  finally
    IdHTTP.Free;
  end;

end;

function TdsdEDINAction.LoadInvoiceNRHeader(AOffset, ACount: Integer; var AJsonArray: TJSONArray): Boolean;
  var IdHTTP: TCustomIdHTTP;
      Params: String;
      Body: String;
      S: String;
      Steam: TStringStream;
      JsonArray: TJSONArray;
      jsonItem : TJSONObject;

begin
  Result := False;

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.CustomHeaders.FoldLines := False;
    IdHTTP.Request.CustomHeaders.AddValue('Authorization', FTokenParam.Value);
    IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.13014 YaBrowser/13.12.1599.13014 Safari/537.36';

    Params := '?gln=' + FGLNParam.Value + '&status_id=2';
    Body := '{'#13 +
            '  "direction": {'#13 +
            '     "sender": ["' + FGLN_SenderParam.Value +  '"],'#13 +
            '     "receiver": [],'#13 +
            '     "type": "EQ"'#13 +
            '  },'#13 +
            '  "exchangeStatus": [],'#13 +
            '  "families": [1,7],'#13 +
            '  "statuses": ["1","2","3","4","5","6","7"],'#13 +
            '  "extraParams": ['#13 +
            '    {'#13 +
            '      "operator": "AND",'#13 +
            '      "type": "EQUALS",'#13 +
            '      "value": "7",'#13 +
            '      "fieldName": "sub_doc_type_id"'#13 +
            '    }'#13 +
            '  ],'#13 +
            '  "limit": {'#13 +
            '    "offset": "' + IntToStr(AOffset) + '",'#13 +
            '    "count": ' + IntToStr(ACount) + #13 +
            '  },'#13 +
            '  "orderBy":{'#13 +
            '    "fieldName": "doc_id",'#13 +
            '    "orderType": "desc"'#13 +
            '  },'#13 +
            '  "type": ['#13 +
            '    {'#13 +
            '       "type": "0"'#13 +
            '    }'#13 +
            '  ]'#13 +
            '}';

    Steam := TStringStream.Create(Body, TEncoding.UTF8);
    try
      try
        S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + '/api/eds/docs/search' + Params), Steam);
      except on E:EIdHTTPProtocolException  do
                  ShowError('������ ��������� ��������� �� ����������": ' + e.ErrorMessage);
      end;

      if IdHTTP.ResponseCode = 200 then
      begin

        jsonItem := TJSONObject.ParseJSONValue(S) as TJSONObject;
        AJsonArray := TJSONArray(jsonItem.Get('items').JsonValue);

        Result := True;
      end;
    finally
      Steam.Free;
    end;
  finally
    IdHTTP.Free;
  end;
end;

function TdsdEDINAction.LoadInvoiceNR: Boolean;
  var JsonArray: TJSONArray;
      jsonItem, json�ontent : TJSONObject;
      Offset, Count, CountDuble, i: Integer;

begin
  Result := False;

  if FTokenParam.Value = '' then
  begin
    ShowError('�� ������� ����. �������� ��������� �� ���������� ����������.');
    Exit;
  end;

  if not Assigned(FUpdateUuid) then
  begin
    ShowError('�� ������� ��������� ��������.');
    Exit;
  end;

  // ��������������� �������� ����� ��� �������

  Offset := 0;
  Count := 10;
  CountDuble := 0;
  while (CountDuble < 10) and LoadInvoiceNRHeader(Offset, Count, JsonArray) and (jsonArray.Size > 0) do
  begin
    for i := 0 to jsonArray.Size - 1 do
    begin
      jsonItem := TJSONObject(jsonArray.Get(i));

      if LoadInvoiceNR�ontent(jsonItem.Get('doc_uuid').JsonValue.Value, json�ontent) then
      begin

        UpdateUuid.ParamByName('inDoc_UUID').Value := jsonItem.Get('doc_uuid').JsonValue.Value;
        UpdateUuid.ParamByName('indocNumber').Value := jsonItem.Get('docNumber').JsonValue.Value;
        UpdateUuid.ParamByName('indocDate').Value := DateOf(IncHour(UnixToDateTime(TJSONNumber(jsonItem.Get('docDate').JsonValue).AsInt64), 10));
        UpdateUuid.ParamByName('inJuridicalName').Value := TJSONObject(TJSONObject(json�ontent.Get('InvoiceParties').JsonValue).Get('Buyer').JsonValue).Get('Name').JsonValue.Value;
        UpdateUuid.ParamByName('inGLNSender').Value := jsonItem.Get('uuidSender').JsonValue.Value;
        UpdateUuid.ParamByName('inGLNReceiver').Value := jsonItem.Get('uuidReceiver').JsonValue.Value;
        UpdateUuid.ParamByName('inDelivery_place_GLN').Value := TJSONObject(jsonItem.Get('extraFields').JsonValue).Get('delivery_place_uuid').JsonValue.Value;
        UpdateUuid.ParamByName('inDeliveryNoteNumber').Value := TJSONObject(TJSONObject(json�ontent.Get('InvoiceReference').JsonValue).Get('DeliveryNote').JsonValue).Get('DeliveryNoteNumber').JsonValue.Value;
        UpdateUuid.ParamByName('inContractNumber').Value := TJSONObject(json�ontent.Get('InvoiceHeader').JsonValue).Get('ContractNumber').JsonValue.Value;
        UpdateUuid.ParamByName('inInvoiceLines').Value := TJSONObject(json�ontent.Get('InvoiceLines').JsonValue).Get('Line').JsonValue.ToString;
        UpdateUuid.ParamByName('IsInsert').Value := False;
        UpdateUuid.Execute;

        if not UpdateUuid.ParamByName('IsInsert').Value then Inc(CountDuble);
      end;
    end;
    Offset := Offset + Count;
  end;
  Result := True;
end;

function TdsdEDINAction.DoSendETTN: Boolean;
  var cXML : String;
begin
  Result := False;
  FErrorParam.Value := '';
  if not GetToken then Exit;

  // ������� ����� �������
  if (HeaderDataSet.FieldByName('KATOTTG_Unloading').asString = '') and
     Assigned(FUpdateKATOTTG) then
  begin
    if HeaderDataSet.FieldByName('GLN_Unloading').asString = '' then
    begin
      ShowError('�� ��������� GLN ��� ������ �������������.');
      Exit;
    end;
    if not GetIdentifiers(HeaderDataSet.FieldByName('GLN_From').asString, HeaderDataSet.FieldByName('GLN_Unloading').asString) then Exit;
  end;

  // ���������� XML
  UAECMREDI(cXML);

  // �������� eTTN
  Result := SendETTN(HeaderDataSet.FieldByName('GLN_from').asString, HeaderDataSet.FieldByName('UuId').AsString, cXML);

  // ������� � ���� Uuid
  if Result and ((FResultParam.Value <> HeaderDataSet.FieldByName('UuId').AsString)) and
     Assigned(FUpdateUuid) then FUpdateUuid.Execute;

end;


function TdsdEDINAction.DoSignDcuETTN: Boolean;
  var GLN_Sign : String;
begin
  Result := False;

  if (HeaderDataSet.FieldByName('UuId').asString = '') then
     ShowError('��� �� ����������. ������� ����������.');

    case FEDINActions of
      edinSignConsignor, edinSendSingETTN : GLN_Sign := HeaderDataSet.FieldByName('GLN_from').asString;
      edinSignCarrier  : GLN_Sign := HeaderDataSet.FieldByName('GLN_car').asString;
    else ShowError('�� ������� ���� ������ eTTN.');
    end;

  if GLN_Sign = '' then ShowError('�� ��������� GLN ����������.');

  if not GetToken then Exit;

  try

    // ������� ���� eTTN
    Result := GetDocETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    //Result := GetDocETTN('4823036500001', '32d2bc90-577e-4e4c-af17-722b49cf1c86');

    // ������� ����� 1
    if Result and (HeaderDataSet.FieldByName('UserSign').asString <> '') then
    begin
      if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s') then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s');
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSign').asString);

      // �������� ������������ ����� eTTN
      if Result then Result := SignDcuETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    end;

    // ������� ����� 2
    if Result and (HeaderDataSet.FieldByName('UserSeal').asString <> '') then
    begin
      if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s') then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s');
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSeal').asString);

      // �������� ������������ ����� eTTN
      if Result then Result := SignDcuETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    end;

    // ������� ����� 3
    if Result and (HeaderDataSet.FieldByName('UserKey').asString <> '') then
    begin
      if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s') then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s');
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserKey').asString);

      // �������� ������������ ����� eTTN
      if Result then Result := SignDcuETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    end;

    // ������� � ���� ��� ���� � ����
    if Result and Assigned(FUpdateSign) then FUpdateSign.Execute;

  finally
    // ������ ��������� �����
    if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value) then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value);
    if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s') then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s');
  end;

end;

function TdsdEDINAction.DoSendSingETTN: Boolean;
  var cXML : String;
begin
  Result := DoSendETTN;
  if Result then
  begin
    if (FResultParam.Value <> HeaderDataSet.FieldByName('UuId').AsString) then
    begin
      HeaderDataSet.Edit;
      HeaderDataSet.FieldByName('UuId').AsString := FResultParam.Value;
      HeaderDataSet.Post;
    end;
    Result := DoSignDcuETTN;
    if Result and (HeaderDataSet.FieldByName('GLN_from').asString = HeaderDataSet.FieldByName('GLN_car').asString) then
    begin
      try
        FEDINActions := edinSignCarrier;
        Result := DoSignDcuETTN;
      finally
        FEDINActions := edinSendSingETTN;
      end;
    end;
  end;
end;

function TdsdEDINAction.DoLoadInvoiceNR: Boolean;
begin
  Result := False;
  FErrorParam.Value := '';
  if not GetToken then Exit;

  // �������� DOCUMENTINVOICE_NP
  Result := LoadInvoiceNR;

end;

function TdsdEDINAction.LocalExecute: Boolean;
begin

  case FEDINActions of
    edinSendETTN : Result := DoSendETTN;
    edinSignConsignor, edinSignCarrier  : Result := DoSignDcuETTN;
    edinSendSingETTN : Result := DoSendSingETTN;

    edinLoadInvoiceNR : Result := DoLoadInvoiceNR;

  else ShowError('�� ������� ����� ��������� ���� ����������.');
  end;

end;

initialization
  Classes.RegisterClass(TEDI);
  Classes.RegisterClass(TEDIAction);
  Classes.RegisterClass(TdsdVchasnoEDIAction);
  Classes.RegisterClass(TdsdEDINAction);

end.

{ FIdFTP.Username := 'uatovalanftp'; FIdFTP.Password := 'ftp349067';
  FIdFTP.Host := 'ruftpex.edi.su'; '/archive' Gj bnjue}
