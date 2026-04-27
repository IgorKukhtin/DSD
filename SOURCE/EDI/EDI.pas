unit EDI;

{$I ..\dsdVer.inc}

interface

uses DBClient, Classes, DB, dsdAction, IdFTP, ComDocXML, dsdCommon, dsdDb, OrderXML, UtilConst
     {$IFDEF DELPHI103RIO}, System.JSON, Actions {$ELSE} , Data.DBXJSON {$ENDIF};

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar, ediComDocSave, ediDelnotSave,
    ediReceipt, ediReturnComDoc, ediDeclarReturn, ediOrdrsp, ediInvoice, ediError,
    ediRecadv, ediTTN, ediComDocSign, ediComDocSendSign, ediSendCondra, ediSignCondra);
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

  // Компонент работы с EDI. Пока все засунем в него
  // Ну не совсем все, конечно, но много
  TEDI = class(TdsdComponent)
  private
    lFileName_save:String;
    FIdFTP: TIdFTP;
    FConnectionParams: TConnectionParams;
    FInsertEDIEvents: TdsdStoredProc;
    FInsertVchasnoEventsDoc: TdsdStoredProc;
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
    function InsertUpdateComDoc(ЕлектроннийДокумент
      : IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc; ADealId, AVchasno_id, ADocumentId_vch : String): Integer;
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
      spHeader, spList: TdsdStoredProc; lFileName, ADealId, AId_doc : String);
    procedure UpdateOrderDESADVSaveVchasnoEDI(AEDIId, Id_send: Integer; AId_doc: String; isError : Boolean);
    procedure UpdateOrderORDERSPSaveVchasnoEDI(AEDIId, Id_send: Integer; isError : Boolean);

    procedure UpdateOrderDELNOTSaveVchasnoEDI(AEDIId, Id_send: Integer; DocumentId, VchasnoId: String; isError : Boolean);
    procedure UpdateOrderCOMDOCSaveVchasnoEDI(AEDIId, Id_send: Integer; DocumentId, VchasnoId: String; isError : Boolean);

    procedure UpdateOrderDELNOTSignVchasnoEDI(AEDIId, Id_send: Integer; isError : Boolean);

    procedure UpdateDesadvCondraSignVchasnoEDI(AEDIId, Id_send: Integer; isError : Boolean);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure INVOICESave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure ORDRSPSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure IFTMINSave(HeaderDataSet, ItemsDataSet: TDataSet); // інструкції з транспортування IFTMIN
    procedure COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet;
      Directory: String; DebugMode: boolean);
    // квитанция
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
    // заказ
    procedure OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String;
      StartDate, EndDate: TDateTime);
    procedure ReturnSave(MovementDataSet: TDataSet;
      spFileInfo, spFileBlob: TdsdStoredProc; Directory: string; DebugMode: boolean);
    procedure ErrorLoad(Directory: string);
    // заказ VchasnoEDI
    procedure OrderLoadVchasnoEDI(AOrder, AFileName, ADealId, AId_doc : string; spHeader, spList: TdsdStoredProc);
    // Comdoc VchasnoEDI
    procedure ComdocLoadVchasnoEDI(FileData, AFileName, ADealId, AVchasno_id, ADocumentId_vch : string; spHeader, spList: TdsdStoredProc);
    // отправка подтверждения заказа
    procedure ORDERSPSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
    // отправка повідомлення про відвантаження
    procedure DESADVSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
    // отправка видатковой-Delnot накладной
    procedure DelnotSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
    // отправка видатковой-ComDoc накладной
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
    // Здесь не нужны Caption, Hint и т.д., так как всегда используется в MultiAction
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
    FMetadataParam: TdsdParam;
    //Качественное
    FMetadata_sender_glnParam: TdsdParam;
    FMetadata_recipient_glnParam: TdsdParam;
    FMetadata_buyer_glnParam: TdsdParam;
    FMetadata_numberParam: TdsdParam;
    FMetadata_document_function_codeParam: TdsdParam;
    FMetadata_fileParam: TdsdParam;
    FMetadata_doc_to_attach_idParam: TdsdParam;
    FMetadata_doc_to_attach_numberParam: TdsdParam;

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
    function POSTCondraEDI(ATypeExchange : Integer): Boolean;
    function POSTSignVchasnoEDI: Boolean;
    function SignData(UserSign : String): Boolean;
    function OrderLoad : Boolean;
    function ComDoc007Load : Boolean;
    function OrdrspSave : Boolean;
    function DESADVSave : Boolean;
    function DelnotSave : Boolean;
    function ComDocSave : Boolean;
    function DoSignComDoc: Boolean;
    function DoSendSignComDoc: Boolean;
    function DoSendCondra: Boolean;
    function DoSignCondra: Boolean;

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
//    property Metadata: TdsdParam read FMetadataParam write FMetadataParam;
    // Содержимое массива Json для формирования DataSet
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

    function LoadInvoiceNRСontent(AUUID : String; var AjsonItem: TJSONObject): Boolean;
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
  caType = 'UA1';  // Не обязательный, если не используется крипто-заголовок
	euKeyTypeAccountant = 1;  // для подписи бухгалтера
	euKeyTypeDirector   = 2;     // для подписи директора
	euKeyTypeDigitalStamp = 3;   // для подписи печати
  okError = 'Виконано успішно';

implementation

uses Windows, VCL.ActnList, DesadvXML, SysUtils, Dialogs, SimpleGauge,
  Variants, UtilConvert, ComObj, DeclarXML, InvoiceXML, DateUtils,
  FormStorage, UnilWin, OrdrspXML, StrUtils, StatusXML, RecadvXML,
  DesadvFozzXML, OrderSpFozzXML, IftminFozzXML, Registry, System.IniFiles,
  DOCUMENTINVOICE_TN_XML, DOCUMENTINVOICE_PRN_XML, UAECMRXML,
  invoice_delnote_base, invoice_comdoc_vchasno,
  Vcl.Forms, System.IOUtils, System.RegularExpressions, ZLib, Math,
  IdHTTP, IdSSLOpenSSL, IdURI, IdCTypes, IdSSLOpenSSLHeaders,
  IdMultipartFormData, Xml.XMLDoc, Soap.EncdDecd, EUSignCP, EUSignCPOwnUI,
  DOCUMENTINVOICE_DRN_XML
 ,CommonData;

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
  ЕлектроннийДокумент: ComDocXML.IXMLЕлектроннийДокументType;
  i: integer;
  XMLFileName, P7SFileName: string;
begin
  // создать xml файл
  ЕлектроннийДокумент := ComDocXML.NewЕлектроннийДокумент;
  ЕлектроннийДокумент.Заголовок.НомерДокументу :=
    HeaderDataSet.FieldByName('InvNumber').asString;
  ЕлектроннийДокумент.Заголовок.ТипДокументу := 'Видаткова накладна';
  ЕлектроннийДокумент.Заголовок.КодТипуДокументу := '006';
  ЕлектроннийДокумент.Заголовок.ДатаДокументу := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  ЕлектроннийДокумент.Заголовок.НомерЗамовлення :=
    HeaderDataSet.FieldByName('InvNumberOrder').asString;

  with ЕлектроннийДокумент.Сторони.Add do
  begin
    СтатусКонтрагента := 'Продавець';
    ВидОсоби := 'Юридична';
    НазваКонтрагента := HeaderDataSet.FieldByName('JuridicalName_From')
      .asString;
    КодКонтрагента := HeaderDataSet.FieldByName('OKPO_From').asString;
    ІПН := HeaderDataSet.FieldByName('INN_From').asString;
    if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
    then GLN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  end;
  with ЕлектроннийДокумент.Сторони.Add do
  begin
    СтатусКонтрагента := 'Покупець';
    ВидОсоби := 'Юридична';
    НазваКонтрагента := HeaderDataSet.FieldByName('JuridicalName_To').asString;
    КодКонтрагента := HeaderDataSet.FieldByName('OKPO_To').asString;
    ІПН := HeaderDataSet.FieldByName('INN_To').asString;
    GLN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with ЕлектроннийДокумент.Таблиця.Add do
    begin
      ІД := i;
      НомПоз := i;
      АртикулПокупця := ItemsDataSet.FieldByName
        ('ArticleGLN_Juridical').asString;
      Найменування := ItemsDataSet.FieldByName('GoodsName').asString;
      ПрийнятаКількість :=
        gfFloatToStr(ItemsDataSet.FieldByName('AmountPartner').AsFloat);
      Ціна := gfFloatToStr(ItemsDataSet.FieldByName('PriceWVAT').AsFloat);
      inc(i);
    end;
    ItemsDataSet.Next;
  end;

  // сохранить на диск
  XMLFileName := ExtractFilePath(ParamStr(0)) + 'comdoc_' +
    FormatDateTime('yyyymmddhhnnss', Date + Time) + '_' +
    HeaderDataSet.FieldByName('InvNumber').asString + '_006.xml';
  ЕлектроннийДокумент.OwnerDocument.SaveToFile(XMLFileName);
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
     //***if FileExists(XMLFileName) then showMessage('exists ' + XMLFileName + #10+#13 + ' start SignFile')
     //***else showMessage('not exists ' + XMLFileName + #10+#13 + ' start SignFile');

    // подписать
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
        'Документ сформирован и подписан';
      FInsertEDIEvents.Execute;
    end;

     //***if FileExists(XMLFileName) then showMessage('exists ' + XMLFileName + #10+#13 + ' start на FTP')
     //***else showMessage('not exists ' + XMLFileName + #10+#13 + ' end SignFile');

     //***if FileExists(P7SFileName) then showMessage('exists ' + P7SFileName + #10+#13 + ' start на FTP')
     //***else showMessage('not exists ' + P7SFileName + #10+#13 + ' end SignFile');

    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');

     //***if FileExists(XMLFileName) then showMessage('exists ' + XMLFileName + #10+#13 + ' end на FTP')
     //***else showMessage('not exists ' + XMLFileName + #10+#13 + ' end SignFile');

     //***if FileExists(P7SFileName) then showMessage('exists ' + P7SFileName + #10+#13 + ' end на FTP')
     //***else showMessage('not exists ' + P7SFileName + #10+#13 + ' end SignFile');

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        'Документ отправлен на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // удалить файлы
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

  // для EDI + Vachsno
  FInsertEDIEvents := TdsdStoredProc.Create(nil);
  FInsertEDIEvents.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FInsertEDIEvents.Params.AddParam('inMovementId_send', ftInteger, ptInput, 0);
  FInsertEDIEvents.Params.AddParam('inEDIEvent', ftString, ptInput, '');
  FInsertEDIEvents.StoredProcName := 'gpInsert_Movement_EDIEvents';
  FInsertEDIEvents.OutputType := otResult;

  // для Vachsno
  FInsertVchasnoEventsDoc := TdsdStoredProc.Create(nil);
  FInsertVchasnoEventsDoc.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FInsertVchasnoEventsDoc.Params.AddParam('inMovementId_send', ftInteger, ptInput, 0);
  //DocumentId
  FInsertVchasnoEventsDoc.Params.AddParam('inDocumentId', ftString, ptInput, '');
  //VchasnoId
  FInsertVchasnoEventsDoc.Params.AddParam('inVchasnoId', ftString, ptInput, '');
  //Id_doc - Desadv
  FInsertVchasnoEventsDoc.Params.AddParam('inId_doc', ftString, ptInput, '');
  //Описание события
  FInsertVchasnoEventsDoc.Params.AddParam('inEDIEvent', ftString, ptInput, '');
  //
  FInsertVchasnoEventsDoc.StoredProcName := 'gpInsert_Movement_EDIEvents';
  FInsertVchasnoEventsDoc.OutputType := otResult;

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
  FUpdateEDIErrorState.Params.AddParam('inMovementId_send', ftInteger, ptInput, 0);
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
  FUpdateEDIVchasnoEDI.Params.AddParam('inId_doc', ftString, ptInput, '');
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
  ЕлектроннийДокумент: ComDocXML.IXMLЕлектроннийДокументType;
  Present: TDateTime;
  Year, Month, Day: Word;
begin
  FTPSetConnection;
  // загружаем файлы с FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('Загрузка данных', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            // если первые буквы файла comdoc, а последние .p7s. Реализация
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
                // тянем файл к нам
                Stream.Clear;
                FIdFTP.Get(List[i], Stream);
                FileData := Utf8ToAnsi(Stream.DataString);
                // Начало документа <?xml
                if pos('<?xml', FileData) > 0 then
                begin
                  FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                end else
                begin
                  // Если нет <?xml то берем по <ЕлектроннийДокумент>
                  FileData := '<?xml version="1.0" encoding="utf-8"?>'#13#10 +
                              copy(FileData, pos('<ЕлектроннийДокумент>', FileData), MaxInt);
                end;
                FileData := copy(FileData, 1, pos('</ЕлектроннийДокумент>',
                  FileData) + 21);
                try
                MovementId:= 0;
                ЕлектроннийДокумент := ComDocXML.LoadЕлектроннийДокумент(FileData);
                except ON E: Exception DO
                      Begin
                         ShowMessage(E.Message +#10  +#13 + List[i]);
                         MovementId:= -1;
                      End;
                end;
                if MovementId <> -1
                then

                if (ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '007')
                 or(ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '004')
                 or(ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '012')
                 //13.07.2022
                 or(ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '005')
               then
                begin
                  // загружаем в базенку
                  try
                    MovementId := InsertUpdateComDoc(ЕлектроннийДокумент,
                      spHeader, spList, '', '', '');
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
                // теперь перенесли файл в директроию Archive
                if MovementId <> -1 then
                Begin
                  try
                    if not FIdFTP.Connected then
                       FIdFTP.Connect;
                    FIdFTP.ChangeDir('/archive');
                    FIdFTP.Put(Stream, List[i]);
                  finally
                    FIdFTP.ChangeDir(Directory);
                    try FIdFTP.Delete(List[i]); except ShowMessage ('Повторная загрузка <'+List[i]+'>');end;
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
  // создать xml файл
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);
  // создать xml файл
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
     // Не видається покупцю  / причина
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // Підлягає реєстрації в ЄРПН постачальником (продавцем)
     DECLAR.DECLARBODY.HERPN0 := '1';
  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // Підлягає реєстрації в ЄРПН покупцем
     DECLAR.DECLARBODY.HERPN := '1';
  if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
     //До зведеної податкової накладної
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

  //Посадова (уповноважена) особа/фізична особа
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_to').asString;

  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  // сохранить на диск
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
    // подписать
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
        'Корректировка сформирована и подписана';
      FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // Увеличить счетчик отправок
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
        'Корректировка отправлена на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // удалить файлы
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
  // создать xml файл
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);
  // создать xml файл
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
     // Не видається покупцю  / причина
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

  if HeaderDataSet.FieldByName('ERPN').asString <> '' then
     // Підлягає реєстрації в ЄРПН постачальником (продавцем)
     DECLAR.DECLARBODY.HERPN0 := '1';
  if HeaderDataSet.FieldByName('ERPN2').asString <> '' then
     // Підлягає реєстрації в ЄРПН покупцем
     DECLAR.DECLARBODY.HERPN := '1';
  if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
     //До зведеної податкової накладної
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

  //Посадова (уповноважена) особа/фізична особа
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_to').asString;

  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  // сохранить на диск
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
    // подписать
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
        'Корректировка сформирована и подписана';
      FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // Увеличить счетчик отправок
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
        'Корректировка отправлена на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // удалить файлы
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
  // создать xml файл
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);
  // создать xml файл
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
         // Не видається покупцю
        DECLAR.DECLARBODY.HORIG1 := '1';
        // Не видається покупцю (тип причини)
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
    raise Exception.Create('Не определен телефон Продавца');
  DECLAR.DECLARBODY.HTELSEL := HeaderDataSet.FieldByName('Phone_To').asString;
  if HeaderDataSet.FieldByName('Phone_From').asString = '' then
    raise Exception.Create('Не определен телефон Покупателя');
  DECLAR.DECLARBODY.HTELBUY := HeaderDataSet.FieldByName('Phone_From').asString;

  DECLAR.DECLARBODY.H02G1S := 'Поставки;COMDOC:' + HeaderDataSet.FieldByName
    ('InvNumberPartnerEDI').asString + ';DATE:' + FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime) + ';';

  DECLAR.DECLARBODY.H02G2D := DECLAR.DECLARBODY.H01G1D;
  DECLAR.DECLARBODY.H02G3S := DECLAR.DECLARBODY.H01G2S;
  if C_DOC_VER = '5' then begin
     DECLAR.DECLARBODY.H04G1D := DECLAR.DECLARBODY.HPODFILL;
     DECLAR.DECLARBODY.H03G1S := 'Оплата з поточного рахунка';
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
  DECLAR.DECLARBODY.H10G2S := HeaderDataSet.FieldByName('N10').asString; // 'Неграш';

  if SendToFTP then
    lDirectory := ExtractFilePath(ParamStr(0))
  else
    lDirectory := Self.Directory;

  if not DirectoryExists(lDirectory) then
    ForceDirectories(lDirectory);

  // сохранить на диск
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
    // подписать
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
        'Налоговая сформирована и подписана';
      FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // Увеличить счетчик отправок
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
        'Корректировочная налоговая отправлена на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // удалить файлы
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

   // создать xml файл
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
     // Не видається покупцю  / причина
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

   if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
   begin
     //До зведеної податкової накладної
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


  //итоговые суммы
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


  //Посадова (уповноважена) особа/фізична особа
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').asString;


  // путь к файлу
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
//  ShowMessage ('start подписать - SignFile : ' + XMLFileName);
    // подписать
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

//  ShowMessage ('end подписать - SignFile : ' + XMLFileName);

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        'Налоговая сформирована и подписана';
      FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // Увеличить счетчик отправок
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

      // Записать данные в протокол
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        'Налоговая отправлена на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // удалить файлы
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

   // создать xml файл
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
     // Не видається покупцю  / причина
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

   if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
   begin
     //До зведеної податкової накладної
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


  //итоговые суммы
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


  //Посадова (уповноважена) особа/фізична особа
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').asString;


  // путь к файлу
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
//  ShowMessage ('start подписать - SignFile : ' + XMLFileName);
    // подписать
    SignFile(XMLFileName, stDeclar, DebugMode
           , HeaderDataSet.FieldByName('UserSign').asString
           , HeaderDataSet.FieldByName('UserSeal').asString
           , HeaderDataSet.FieldByName('UserKey').asString
           , HeaderDataSet.FieldByName('NameExite').asString
           , HeaderDataSet.FieldByName('NameFiscal').asString
            );

//  ShowMessage ('end подписать - SignFile : ' + XMLFileName);

    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        'Налоговая сформирована и подписана';
      FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // Увеличить счетчик отправок
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

      // Записать данные в протокол
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        'Налоговая отправлена на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // удалить файлы
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

   // создать xml файл
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
    raise Exception.Create('Не определен телефон Продавца');
  DECLAR.DECLARBODY.HTELSEL := HeaderDataSet.FieldByName('Phone_From').asString;
  if HeaderDataSet.FieldByName('Phone_To').asString = '' then
   raise Exception.Create('Не определен телефон Покупателя');
  DECLAR.DECLARBODY.HTELBUY := HeaderDataSet.FieldByName('Phone_To').asString;

  DECLAR.DECLARBODY.H01G1S := 'Поставки;COMDOC:' + HeaderDataSet.FieldByName
    ('InvNumberPartnerEDI').asString + ';DATE:' + FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime) + ';';
  DECLAR.DECLARBODY.H01G2D := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  DECLAR.DECLARBODY.H01G3S := HeaderDataSet.FieldByName('ContractName')
    .asString;
  DECLAR.DECLARBODY.H02G1S := 'Оплата з поточного рахунка';

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
  DECLAR.DECLARBODY.H10G1S := HeaderDataSet.FieldByName('N10').asString; //'Неграш';

  // путь к файлу
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
    // подписать
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
        'Налоговая сформирована и подписана';
      FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      // Увеличить счетчик отправок
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

      // Записать данные в протокол
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        'Налоговая отправлена на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    // удалить файлы
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
            // Создать XML
            DESADV_fozz := DesadvFozzXML.NewDESADV;
            // Номер повідомлення про відвантаження
            DESADV_fozz.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // Дата документа
            DESADV_fozz.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // Дата поставки
            DESADV_fozz.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // Час поставки
            DESADV_fozz.DELIVERYTIME := '00:00';
            // Номер замовлення
            DESADV_fozz.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // Дата замовлення
            DESADV_fozz.ORDERDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
            // Номер підтвердження замовлення
            DESADV_fozz.ORDRSPNUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // Дата підтвердження замовлення
            DESADV_fozz.ORDRSPDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // Номер накладної
            DESADV_fozz.DELIVERYNOTENUMBER := StrToInt(HeaderDataSet.FieldByName('InvNumber').asString);
            // Дата накладної
            DESADV_fozz.DELIVERYNOTEDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // Номер договору на поставку
            DESADV_fozz.CAMPAIGNNUMBER := HeaderDataSet.FieldByName('ContractName').asString;
            // Кількість машин
            DESADV_fozz.TRANSPORTQUANTITY := 1;
            // Номер транспортного засобу
            //DESADV_fozz.TRANSPORTID := 1; //HeaderDataSet.FieldByName('CarName').asString;
            // Тип транспорту:  "31"  Грузовой  или "48"  Легковой
            DESADV_fozz.TRANSPORTERTYPE := 31; //HeaderDataSet.FieldByName('CarModelName').asString;
            // Тип транспортування: 20 - залізничний, 30 - дорожній, 40 - повітряний, 60 - спарений, 100 - кур’єрська служба
            DESADV_fozz.TRANSPORTTYPE := 30;
            //
            // GLN постачальника
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then DESADV_fozz.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // GLN покупця
            DESADV_fozz.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // GLN місця доставки
            DESADV_fozz.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // GLN кінцевого консигнатора
            DESADV_fozz.HEAD.FINALRECIPIENT:= HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // GLN відправника повідомлення
            DESADV_fozz.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
            // GLN одержувача повідомлення
            DESADV_fozz.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;

            // Номер транзакції
            DESADV_fozz.HEAD.EDIINTERCHANGEID:= '1';

            // Номер ієрархії упаковки
            DESADV_fozz.HEAD.PACKINGSEQUENCE.HIERARCHICALID := 1;

            with ItemsDataSet do
            begin
              First;
              i := 1;
              while not Eof do
              begin
                with DESADV_fozz.HEAD.PACKINGSEQUENCE.POSITION.Add do
                begin
                  // Номер товарної позиції
                  POSITIONNUMBER := IntToStr(i);
                  // Штрихкод продукту
                  PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                  // Артикул в БД покупця
                  PRODUCTIDBUYER := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                  // кількість, що поставляється
                  DELIVEREDQUANTITY :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('AmountPartner').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // Одиниці виміру
                  // ??? DELIVEREDUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;
                  // Замовлена кількість
                  ORDEREDQUANTITY :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('AmountOrder').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  // Кількість ящиків
                  if ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat > 0
                  then
                      BOXESQUANTITY :=
                        StringReplace(FormatFloat('0.##',
                        ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat),
                        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  // Сума товару без ПДВ
                  AMOUNT :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // Ціна продукту без ПДВ
                  PRICE :=
                    StringReplace(FormatFloat('0.00##',
                    ItemsDataSet.FieldByName('PriceNoVAT').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // Ставка податку (ПДВ,%)
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

  // Создать XML - DESADV_fozz_Amount - дог.№ 7183Р AND vbUserId <> 1329039  -- Авто-Загрузка EDI
  if (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
 and (HeaderDataSet.FieldByName('isSchema_fozz_desadv').asBoolean = FALSE)
 and (1=1)
  then begin
            // 1.1. Создать XML - fozzy - Amount
            DESADV_fozz_Amount := DOCUMENTINVOICE_TN_XML.NewDocumentInvoice;
            // Номер повідомлення про відвантаження
            DESADV_fozz_Amount.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
            // Дата документа
            DESADV_fozz_Amount.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            //Код типу документа: TN - накладна за кількістю
            DESADV_fozz_Amount.InvoiceHeader.DocumentFunctionCode := 'TN';
            // Номер договору на поставку
            DESADV_fozz_Amount.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
            // Дата договору
            DESADV_fozz_Amount.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
            // Номер замовлення
            DESADV_fozz_Amount.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // Дата замовлення
            DESADV_fozz_Amount.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);

            // Глобальний номер розташування (GLN) контрагента - GLN покупця
            if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // Податковий ідентифікаційний номер - покупця
            if HeaderDataSet.FieldByName('INN_To').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
            // Код ЄДРПОУ - покупця
            if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
            // Назва контрагента
            DESADV_fozz_Amount.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;


            // Глобальний номер розташування (GLN) контрагента - GLN продавця
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // Податковий ідентифікаційний номер - продавця
            if HeaderDataSet.FieldByName('INN_From').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
            // Код ЄДРПОУ - продавця
            if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
            // Назва продавця
            DESADV_fozz_Amount.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

            // Глобальний номер розташування (GLN) контрагента - GLN Точка доставки
            if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
            then DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // Юридична особа об’єкту доставки
            DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
            // Місто - Точка доставки
            DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
            // Вулиця і номер будинку - Точка доставки
            DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
            // Поштовий код - Точка доставки
            //try DESADV_fozz_Amount.InvoiceParties.DeliveryPoint.PostalCode := StrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString);except end;



            with ItemsDataSet do
            begin
              First;
              i := 1;
              while not Eof do
              begin
                with DESADV_fozz_Amount.InvoiceLines.Add do
                begin
                  // Номер товарної позиції
                  LineItem.LineNumber := i;
                  // Штрихкод продукту
                  LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                  // Артикул в БД покупця
                  LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                  // Найменування товарної позиції
                  LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;
                  // кількість, що поставляється
                  LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
                  // BuyerUnitOfMeasure
                  LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;


                  // Ставка податку (ПДВ,%):
                  LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;
                  // Ставка податку (ПДВ,%):
                  LineItem.TaxCategoryCode := 'S';

                end;
                inc(i);
                Next;
              end;
            end;


            // 1.2. Создать XML - fozzy - Price
            AmountSummNoVAT_fozz:= 0;
            VATPercent_fozz:= 0;
            //
            DESADV_fozz_Price := DOCUMENTINVOICE_PRN_XML.NewDocumentInvoice;
            // Номер повідомлення про відвантаження
            DESADV_fozz_Price.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
            // Дата документа
            DESADV_fozz_Price.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            //Код типу документа: TN - накладна за кількістю
            DESADV_fozz_Price.InvoiceHeader.DocumentFunctionCode := 'PRN';
            // Номер договору на поставку
            DESADV_fozz_Price.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
            // Дата договору
            DESADV_fozz_Price.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
            // Загальна кількість накладних
            DESADV_fozz_Price.InvoiceHeader.InvoiceQuantity := 1;
            // Порядковий номер накладної
            DESADV_fozz_Price.InvoiceHeader.InvoiceSequences := 1;
            // Номер замовлення
            DESADV_fozz_Price.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // Дата замовлення
            DESADV_fozz_Price.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
            // Номер документу-підстави (Накладної за кількістю)
            //DESADV_fozz_Amount.InvoiceReference.Invoice.OriginalInvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
            // Дата складання документу-підстави (Накладної за кількістю)
            //DESADV_fozz_Price.InvoiceReference.Invoice.OriginalInvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);

            // Глобальний номер розташування (GLN) контрагента - GLN покупця
            if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // Податковий ідентифікаційний номер - покупця
            if HeaderDataSet.FieldByName('INN_To').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
            // Код ЄДРПОУ - покупця
            if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
            // Назва контрагента
            DESADV_fozz_Price.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;


            // Глобальний номер розташування (GLN) контрагента - GLN продавця
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // Податковий ідентифікаційний номер - продавця
            if HeaderDataSet.FieldByName('INN_From').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
            // Код ЄДРПОУ - продавця
            if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
            // Назва продавця
            DESADV_fozz_Price.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

            // Глобальний номер розташування (GLN) контрагента - GLN Точка доставки
            if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // Юридична особа об’єкту доставки
            DESADV_fozz_Price.InvoiceParties.DeliveryPoint.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
            // Місто - Точка доставки
            DESADV_fozz_Price.InvoiceParties.DeliveryPoint.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
            // Вулиця і номер будинку - Точка доставки
            DESADV_fozz_Price.InvoiceParties.DeliveryPoint.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
            // Поштовий код - Точка доставки
            //try DESADV_fozz_Price.InvoiceParties.DeliveryPoint.PostalCode := StrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString);except end;

            // Глобальний номер розташування (GLN) контрагента - GLN Платник
            if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
            then DESADV_fozz_Price.InvoiceParties.Payer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
            // Назва контрагента - Платник
            DESADV_fozz_Price.InvoiceParties.Payer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
            // Місто - Платник
            DESADV_fozz_Price.InvoiceParties.Payer.CityName := 'м. Київ';
            // Місто - Платник
            DESADV_fozz_Price.InvoiceParties.Payer.StreetAndNumber := 'вул. Бутлерова, буд.1';


            with ItemsDataSet do
            begin
              First;
              i := 1;
              while not Eof do
              begin
                with DESADV_fozz_Price.InvoiceLines.Add do
                begin
                  // Номер товарної позиції
                  LineItem.LineNumber := i;
                  // Штрихкод продукту
                  LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                  // Артикул в БД покупця
                  LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                  // код УКТЗЕД
                  LineItem.ExternalItemCode := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
                  // Найменування товарної позиції
                  LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;
                  // кількість, що поставляється
                  LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
                  // BuyerUnitOfMeasure
                  LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;

                  // Ціна однієї одиниці без ПДВ
                  LineItem.InvoiceUnitNetPrice := ItemsDataSet.FieldByName('PriceNoVAT').AsFloat;
                  // Ціна однієї одиниці без ПДВ
                  //LineItem.InvoiceUnitGrossPrice := ItemsDataSet.FieldByName('PriceWVAT').AsFloat;
                  // Ставка податку (ПДВ,%):
                  LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;

                  // Ставка податку (ПДВ,%):
                  LineItem.TaxCategoryCode := 'S';

                  // Сума з ПДВ
                  LineItem.GrossAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat;
                  // Сума податку
                  LineItem.TaxAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat - ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
                  // Сума без ПДВ
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
            // Кількість рядків в документі
            DESADV_fozz_Price.InvoiceSummary.TotalLines := i;
            // Загальна сума без ПДВ
            DESADV_fozz_Price.InvoiceSummary.TotalNetAmount := AmountSummNoVAT_fozz;
            // Сума ПДВ
            DESADV_fozz_Price.InvoiceSummary.TotalNetAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100 - AmountSummNoVAT_fozz;
            // Загальна сума з ПДВ
            DESADV_fozz_Price.InvoiceSummary.TotalGrossAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100;


  end;

  //else
      begin
            // Создать XML - Desadv - ВСЕГДА + может быть BOXESQUANTITY
            DESADV := DesadvXML.NewDESADV;
            //
            DESADV.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // Дата документа
            DESADV.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // Дата поставки
            DESADV.DELIVERYDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            //
            DESADV.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            // Дата замовлення
            DESADV.ORDERDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
            //
            DESADV.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            // Дата накладної
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
            // GLN одержувача повідомлення
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
                  // Замовлена кількість
                  ORDEREDQUANTITY :=
                    StringReplace(FormatFloat('0.000',
                    ItemsDataSet.FieldByName('AmountOrder').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // Кількість ящиків
                  if ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat > 0
                  then
                      BOXESQUANTITY :=
                        StringReplace(FormatFloat('0.##',
                        ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat),
                        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  COUNTRYORIGIN := 'UA';
                  PRICE := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('Price').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

                  // Цена з ПДВ
                  PRICEWITHVAT := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // ПДВ
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
   // не для BOXESQUANTITY
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
    // !временно!
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
    // здесь сохранили на ftp
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
          'Документ DOCUMENTINVOICE_TN отправлен на FTP'
      else
        FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
          'Документ DESADV отправлен на FTP';
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
  // 2.Send XML - only fozzy - ВСЕГДА DESADV  + если BOXESQUANTITY
  if (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
  or (HeaderDataSet.FieldByName('isSchema_fozz_desadv').asBoolean = TRUE)
  then
  try
    Stream := TMemoryStream.Create;

    DESADV.OwnerDocument.SaveToStream(Stream);
    lNumber:= DESADV.NUMBER;
    //
    FileName := 'desadv_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';

    // !временно!
       try
         DESADV     .OwnerDocument.SaveToFile(FDirectoryError + FileName);
       except
         DESADV     .OwnerDocument.SaveToFile(FileName);
       end;
    // здесь сохранили на ftp
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
          'Документ DESADV отправлен на FTP';
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
    // !временно!
       try
         DESADV_fozz_Price.OwnerDocument.SaveToFile(FileName)
       except
         DESADV_fozz_Price.OwnerDocument.SaveToFile(FileName)
       end;
    // здесь сохранили на ftp
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
          'Документ DOCUMENTINVOICE_PRN отправлен на FTP';
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
  FreeAndNil(FInsertVchasnoEventsDoc);
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
  // загружаем файлы с FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('Загрузка данных', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            // если первые буквы файла desadv, а последние .xml. Desadv
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
            // если первые буквы файла desadv, а последние .xml. Desadv
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
      try if ORDERPRICE <> ''
          then ParamByName('inPriceOrder').Value := gfStrToFloat(ORDERPRICE)
          else ParamByName('inPriceOrder').Value := 0;
      except ParamByName('inPriceOrder').Value := 0; end;
      Execute;
    end;
    //
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :='{'+IntToStr(i)+'}Загрузка ORDER из EDI завершена _'+lFileName+'_';
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
      // 1.2. Создать XML - fozzy - Price
      AmountSummNoVAT_fozz:= 0;
      VATPercent_fozz:= 0;
      //
      DOCUMENTINVOICE_DRN := DOCUMENTINVOICE_DRN_XML.NewDocumentInvoice;
      // Номер повідомлення про відвантаження
      DOCUMENTINVOICE_DRN.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
      // Дата документа
      DOCUMENTINVOICE_DRN.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
      //Код типу документа: TN - накладна за кількістю
      DOCUMENTINVOICE_DRN.InvoiceHeader.DocumentFunctionCode := 'DRN';
      // Номер договору на поставку
      DOCUMENTINVOICE_DRN.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
      // Дата договору
      DOCUMENTINVOICE_DRN.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
      // Номер замовлення
      DOCUMENTINVOICE_DRN.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
      // Дата замовлення
      DOCUMENTINVOICE_DRN.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
      // Номер документу-підстави (Накладної за кількістю)
      //DOCUMENTINVOICE_DRN.InvoiceReference.Invoice.OriginalInvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
      // Дата складання документу-підстави (Накладної за кількістю)
      //DOCUMENTINVOICE_DRN.InvoiceReference.Invoice.OriginalInvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);

      // Глобальний номер розташування (GLN) контрагента - GLN покупця
      if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
      // Податковий ідентифікаційний номер - покупця
      if HeaderDataSet.FieldByName('INN_To').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
      // Код ЄДРПОУ - покупця
      if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
      // Назва контрагента
      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;

      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
      if TryStrToInt(HeaderDataSet.FieldByName('PostalCode_To').asString, nInt) and (nInt <> 0) then
        DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.PostalCode := IntToStr(nInt);
      DOCUMENTINVOICE_DRN.InvoiceParties.Buyer.PhoneNumber := SplitString(HeaderDataSet.FieldByName('Phone_To').asString, ',')[0];

      // Глобальний номер розташування (GLN) контрагента - GLN продавця
      if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
      // Податковий ідентифікаційний номер - продавця
      if HeaderDataSet.FieldByName('INN_From').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
      // Код ЄДРПОУ - продавця
      if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
      // Назва продавця
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_From').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.CityName := HeaderDataSet.FieldByName('CityName_From').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.PostalCode := HeaderDataSet.FieldByName('PostalCode_From').asString;
      DOCUMENTINVOICE_DRN.InvoiceParties.Seller.PhoneNumber := HeaderDataSet.FieldByName('Phone_From').asString;

      // Глобальний номер розташування (GLN) контрагента - GLN Точка доставки
      if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
      then DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
      // Юридична особа об’єкту доставки
      DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
      // Місто - Точка доставки
      DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
      // Вулиця і номер будинку - Точка доставки
      DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
      // Поштовий код - Точка доставки
      DOCUMENTINVOICE_DRN.InvoiceParties.DeliveryPoint.PostalCode := HeaderDataSet.FieldByName('PostalCode_To').asString;

      with ItemsDataSet do
      begin
        First;
        i := 1;
        while not Eof do
        begin
          with DOCUMENTINVOICE_DRN.InvoiceLines.Add do
          begin
            // Номер товарної позиції
            LineItem.LineNumber := i;
            // Штрихкод продукту
            LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
            // Артикул в БД покупця
            LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
            // код УКТЗЕД
            LineItem.ExternalItemCode := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
            // Найменування товарної позиції
            LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;

            // кількість, що поставляється
            LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
            // BuyerUnitOfMeasure
            LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;

            // Ціна однієї одиниці без ПДВ
            LineItem.InvoiceUnitNetPrice := ItemsDataSet.FieldByName('PriceNoVAT').AsFloat;
            // Ціна однієї одиниці з ПДВ
            LineItem.InvoiceUnitGrossPrice := RoundTo(ItemsDataSet.FieldByName('PriceWVAT').AsFloat, -2);

            // Ставка податку (ПДВ,%):
            LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;
            LineItem.TaxCategoryCode := 'S';

            // Сума з ПДВ
            LineItem.GrossAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat;
            // Сума податку
            LineItem.TaxAmount := RoundTo(ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat - ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat, -2);
            // Сума без ПДВ
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
      // Кількість рядків в документі
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalLines := i;
      // Загальна сума без ПДВ
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalNetAmount := RoundTo(AmountSummNoVAT_fozz, -2);
      // Сума ПДВ
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalTaxAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100 - RoundTo(AmountSummNoVAT_fozz, -2);
      // Загальна сума з ПДВ
      DOCUMENTINVOICE_DRN.InvoiceSummary.TotalGrossAmount := Round(100 * AmountSummNoVAT_fozz * (1 + VATPercent_fozz/100)) / 100;


      //
      //
      Stream := TMemoryStream.Create;
      try
        DOCUMENTINVOICE_DRN.OwnerDocument.SaveToStream(Stream);
        lNumber:= DOCUMENTINVOICE_DRN.InvoiceHeader.InvoiceNumber;
        //
        FileName := 'DOCUMENTINVOICE_DRN_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + lNumber + '.xml';
        // !временно!
//        if FisEDISaveLocal
//        then
           try
             DOCUMENTINVOICE_DRN.OwnerDocument.SaveToFile(FileName)
           except
           end;
        // здесь сохранили на ftp
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
            'Документ DOCUMENTINVOICE отправлен на FTP';
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
    // Создать XML
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
          'Документ INVOICE отправлен на FTP';
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
            // Создать XML
            IFTMIN_fozz := IFTMINFozzXML.NewIFTMIN;
            // Номер документа повинен бути наступного формату X_Y, де Х — це порядковий номер машини, яка їде по замовленню Y — це загальна кількість машин, яка поїде по замовленню (мінімальна к-ть - 1, максимальна - 99). Х повинен бути менше або дорівнювати Y. Наприклад 2_5.
            IFTMIN_fozz.NUMBER := '1_1';
            // Дата документа
            IFTMIN_fozz.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // Дата поставки
            IFTMIN_fozz.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
            // Час доставки
            IFTMIN_fozz.DELIVERYTIME := '00:00';
            // Тип документа: O — оригинал, R — замена, D — удаление, F — фиктивность заказа, PO — предзаказ, OS — заказ на услугу/маркетинг
            IFTMIN_fozz.DOCTYPE := 'O';
            //Допустиме значення - «ON»
            IFTMIN_fozz.DOCUMENT.DOCITEM.DOCTYPE:='ON';
            // Номер замовлення
            IFTMIN_fozz.DOCUMENT.DOCITEM.DOCNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            //
            // GLN вантажовідправника
            if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
            then IFTMIN_fozz.HEAD.CONSIGNOR := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
            // GLN місця доставки
            IFTMIN_fozz.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
            // GLN відправника повідомлення
            IFTMIN_fozz.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
            // GLN одержувача повідомлення
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
                  // Номер позиції - Можлива тільки одна позиція
                  POSITIONNUMBER := IntToStr(i);
                  // Тип упаковки
                  PACKAGETYPE := '201';
                  // Кількість упаковок
                  PACKAGEQUANTITY :=
                    StringReplace(FormatFloat('0.####',
                    HeaderDataSet.FieldByName('WeighingCount').AsFloat),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  // Вага - Грузоподьемность
                  PACKAGEWIGHT :=
                    StringReplace(FormatFloat('0.00##',
                    24000),
                    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                  //Максимальна кількість упаковок
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
    // !временно!
    if (FisEDISaveLocal) or (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
    then
       try
         IFTMIN_fozz.OwnerDocument.SaveToFile(FileName)
       except
         IFTMIN_fozz.OwnerDocument.SaveToFile(FDirectoryError + FileName)
       end;
    // здесь созранили на ftp
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
        'Документ IFTMIN отправлен на FTP';
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
        ('Ошибка библиотеки Exite. EUTaxService.ResetPrivateKey(euKeyTypeAccountant)'#10#13 +
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
        ('Ошибка библиотеки Exite. EUTaxService.ResetPrivateKey(euKeyTypeAccountant)'#10#13 +
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
        ('Ошибка библиотеки Exite. EUTaxService.ResetPrivateKey(euKeyTypeAccountant)'#10#13 +
        E.Message);
    end;
  end;
// exit;
  try
    // 1.Установка ключей
    if UserSign <> ''
    then if ExtractFilePath(UserSign) <> ''
         then FileName := UserSign
         else FileName := ExtractFilePath(ParamStr(0)) + UserSign
    else FileName := ExtractFilePath(ParamStr(0)) + 'Ключ - Неграш О.В..ZS2';
    // проверка
    if not FileExists(FileName) then raise Exception.Create('Файл не найден : <'+FileName+'>');

	  ComSigner.SetPrivateKeyFile (euKeyTypeAccountant, FileName, '24447183', false); // бухгалтер
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite.ComSigner.SetPrivateKeyFile.euKeyTypeAccountant'
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // 2.Установка ключей
    if UserSeal <> ''
    then FileName := UserSeal
    else FileName := ExtractFilePath(ParamStr(0))
                  + 'Ключ - для в_дтиску - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2';
    // проверка
    if not FileExists(FileName) then raise Exception.Create('Файл не найден : <'+FileName+'>');

	  ComSigner.SetPrivateKeyFile (euKeyTypeDigitalStamp, FileName, '24447183', false); // Печать
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite.ComSigner.SetPrivateKeyFile.euKeyTypeDigitalStamp'
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    //3. Установка ключей
    if UserKey <> ''
    then FileName := UserKey
    else FileName := ExtractFilePath(ParamStr(0))
                   + 'Ключ - для шифрування - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2';
    // проверка
    if not FileExists(FileName) then raise Exception.Create('Файл не найден : <'+FileName+'>');

	  ComSigner.SetPrivateKeyFile (euKeyTypeDigitalStamp, FileName, '24447183', false); // Печать
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite.ComSigner.SetPrivateKeyFile.euKeyTypeDigitalStamp'
        + FileName + #10#13 + E.Message);
    end;
  end;

end;

function TEDI.InsertUpdateComDoc(ЕлектроннийДокумент
  : ComDocXML.IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc; ADealId, AVchasno_id, ADocumentId_vch : String): integer;
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
  Param: IXMLПараметрType;
begin
  with spHeader, ЕлектроннийДокумент do
  begin
    ParamByName('inOrderInvNumber').Value := Заголовок.НомерЗамовлення;
    ParamByName('inComDocDate').Value := ConvertEDIDate(Заголовок.ДатаДокументу);

    if (Заголовок.ДатаЗамовлення <> '')and(Заголовок.ДатаЗамовлення <> '--')
    then
      try ParamByName('inOrderOperDate').Value := ConvertEDIDate(Заголовок.ДатаЗамовлення)
      except
         ParamByName('inOrderOperDate').Value:= ConvertEDIDate(Заголовок.ДатаДокументу);
      end
    else
      ParamByName('inOrderOperDate').Value :=ConvertEDIDate(Заголовок.ДатаДокументу);

    ParamByName('inPartnerInvNumber').Value := Заголовок.НомерДокументу;
    if Заголовок.КодТипуДокументу = '007' then begin
       if Заголовок.ДокПідстава.ДатаДокументу <> '' then
          ParamByName('inOperDateSaleLink').Value :=
               ConvertEDIDate(Заголовок.ДокПідстава.ДатаДокументу);

       ParamByName('inInvNumberSaleLink').Value :=
           Заголовок.ДокПідстава.НомерДокументу;
       ParamByName('inGLNPlace').Value := '';
       for i := 0 to Параметри.Count - 1 do
           if Параметри.Параметр[i].назва = 'Точка доставки' then begin
              ParamByName('inGLNPlace').Value := Параметри.Параметр[i].NodeValue;
              break;
           end;

       if Заголовок.ДокПідстава.ДатаДокументу = '' then
          ParamByName('inPartnerOperDate').Value :=
            ConvertEDIDate(Заголовок.ДатаДокументу)
       else
          ParamByName('inPartnerOperDate').Value :=
            ConvertEDIDate(Заголовок.ДокПідстава.ДатаДокументу)
    end
    else
       ParamByName('inPartnerOperDate').Value :=
         ConvertEDIDate(Заголовок.ДатаДокументу);
    if Заголовок.КодТипуДокументу = '012' then
    begin
      ParamByName('inGLNPlace').Value := '';
      ParamByName('inDesc').Value := 'Return';
      ParamByName('inInvNumberTax').Value :=
        Параметри.ParamByName('Номер податкової накладної').NodeValue;
      if not VarIsNull(Параметри.ParamByName('Дата податкової накладної')
        .NodeValue) then
        ParamByName('inOperDateTax').Value :=
          ConvertEDIDate(Параметри.ParamByName('Дата податкової накладної')
          .NodeValue);
      ParamByName('inInvNumberSaleLink').Value :=
        Заголовок.ДокПідстава.НомерДокументу;
      ParamByName('inOperDateSaleLink').Value :=
        ConvertEDIDate(Заголовок.ДокПідстава.ДатаДокументу);
    end
    else begin
      ParamByName('inDesc').Value := 'Sale';
      ParamByName('inInvNumberTax').Value := '';
      //ParamByName('inInvNumberSaleLink').Value := '';
    end;

    for i := 0 to Сторони.Count - 1 do
      if Сторони.Контрагент[i].СтатусКонтрагента = 'Покупець' then
      begin
        ParamByName('inOKPO').Value := Сторони.Контрагент[i].КодКонтрагента;
        ParamByName('inJuridicalName').Value := Сторони.Контрагент[i]
          .НазваКонтрагента;
      end;
    //
    ParamByName('inDealId').Value := ADealId;
    ParamByName('inVchasnoId').Value := AVchasno_id;
    ParamByName('inDocumentId_vch').Value := ADocumentId_vch;
    //
    Execute;
    MovementId := ParamByName('MovementId').Value;
    GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
  end;
  with spList, ЕлектроннийДокумент.Таблиця do
    for i := 0 to GetCount - 1 do
    begin
      with Рядок[i] do
      begin
        ParamByName('inMovementId').Value := MovementId;
        ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
        ParamByName('inGoodsName').Value := Copy(TRIM(Найменування),1,254);
        ParamByName('inGLNCode').Value := АртикулПокупця;
        if ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '012' then
          ParamByName('inAmountPartner').Value :=
            gfStrToFloat(ДоПовернення.Кількість)
        else
          ParamByName('inAmountPartner').Value :=
            gfStrToFloat(ПрийнятаКількість);
        ParamByName('inSummPartner').Value :=
          gfStrToFloat(ВсьогоПоРядку.СумаБезПДВ);
        ParamByName('inPricePartner').Value := gfStrToFloat(БазоваЦіна);
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
    // загружаем файлы с FTP
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
        with TGaugeFactory.GetGauge('Загрузка данных', 0, List.Count) do
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
              // если первые буквы файла order а последние .xml
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
                    AddToLog('3.1. тянем файл к нам ii_begin = ' + IntToStr(ii_begin));

                    // тянем файл к нам
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

                    // загружаем в базенку
//  gc_isDebugMode:= TRUE;
//  gc_isShowTimeMode:= TRUE;
                    InsertUpdateOrder(ORDER, spHeader, spList, List[i]);

                    AddToLog('3.6. InsertUpdateOrder = ok');

                    //
                    //Пытаемся найти параметр
                    if Assigned(spHeader.Params.ParamByName('gIsDelete'))
                    then fIsDelete:= spHeader.ParamByName('gIsDelete').Value
                    else fIsDelete:= false;

                    AddToLog('3.7. теперь перенесли файл в директроию Archive');
                    // теперь перенесли файл в директроию Archive
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
                    AddToLog('3.8. finish - перенесли файл в директроию Archive');

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
        AddToLog('4.3. загружено = <'+IntToStr(ii_begin)+'>');

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
          // Создать XML
          ORDRSP_fozz := OrderSpFozzXML.NewOrderSp;
          // Номер підтвердження замовлення
          ORDRSP_fozz.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
          // Дата документа
          ORDRSP_fozz.Date := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          // Час створення документа
          ORDRSP_fozz.Time := FormatDateTime('hh:mm',HeaderDataSet.FieldByName('OperDate_insert').asDateTime);
          // Номер замовлення
          ORDRSP_fozz.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
          // Дата замовлення
          ORDRSP_fozz.ORDERDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
          // Дата доставки
          ORDRSP_fozz.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          // Час поставки
          ORDRSP_fozz.DELIVERYTIME := '00:00';
          // Код валюти
          ORDRSP_fozz.CURRENCY := 'UAH';
          // Номер договору на поставку
          ORDRSP_fozz.CAMPAIGNNUMBER := HeaderDataSet.FieldByName('ContractName').asString;
          // 4 - поставка змінена, 5 - заміна документа, 29 - поставка прийнята, 27 - поставка не прийнята
          ORDRSP_fozz.ACTION := 29;
          //
          // GLN постачальника
          if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
          then ORDRSP_fozz.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
          // GLN покупця
          ORDRSP_fozz.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
          // GLN місця доставки
          ORDRSP_fozz.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
          // GLN платника
          ORDRSP_fozz.HEAD.INVOICEPARTNER:= HeaderDataSet.FieldByName('BuyerGLNCode').asString;
          // GLN відправника повідомлення
          ORDRSP_fozz.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
          // GLN одержувача повідомлення
          ORDRSP_fozz.HEAD.RECIPIENT := HeaderDataSet.FieldByName('RecipientGLNCode').asString;

          with ItemsDataSet do
          begin
            First;
            i := 1;
            while not Eof do
            begin
              with ORDRSP_fozz.HEAD.POSITION.Add do
              begin
                // Номер товарної позиції
                POSITIONNUMBER := IntToStr(i);
                // Штрих-код продукту
                PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
                // Артикул в БД покупця
                PRODUCTIDBUYER := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
                // Опис продукту
                DESCRIPTION := ItemsDataSet.FieldByName('GoodsName').asString;
                // 1 - товар буде поставлений без змін, 2 - зміна замовленої кількості ,,, 3 - відмовлено в постачанні ,,,
                if ItemsDataSet.FieldByName('AmountOrder').AsFloat = ItemsDataSet.FieldByName('AmountPartner').AsFloat
                then PRODUCTTYPE := '1';
                if ItemsDataSet.FieldByName('AmountOrder').AsFloat <> ItemsDataSet.FieldByName('AmountPartner').AsFloat
                then PRODUCTTYPE := '2';
                if ItemsDataSet.FieldByName('AmountOrder').AsFloat = 0
                then PRODUCTTYPE := '3';
                // Замовлена кількість
                ORDEREDQUANTITY :=
                  StringReplace(FormatFloat('0.00##',
                  ItemsDataSet.FieldByName('AmountOrder').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                // Наявна кількість
                ACCEPTEDQUANTITY :=
                  StringReplace(FormatFloat('0.00##',
                  ItemsDataSet.FieldByName('AmountPartner').AsFloat),
                  FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
                // Мінімальна замовлена кількість
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
          // Создать XML
          ORDRSP := ORDRSPXML.NewORDRSP;
          //
          ORDRSP.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
          // Дата документа
          ORDRSP.Date := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          // Дата доставки
          ORDRSP.DELIVERYDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
          //
          ORDRSP.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
          // Дата замовлення
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
    // !временно!
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
    // здесь созранили на ftp
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
        'Документ ORDRSP отправлен на FTP';
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
      // загружаем файл на FTP
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
  // загружаем файлы с FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('Загрузка данных', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            if (AnsiLowerCase(copy(List[i], Length(List[i]) - 3, 4)) = '.xml')
               and (AnsiLowerCase(copy(List[i], 1, 6)) = 'recadv') then
            begin
              // тянем файл к нам
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
              // теперь перенесли файл в директроию Archive
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
  // загружаем файлы с FTP
  FIdFTP.Connect;
  if FIdFTP.Connected then
  begin
    FIdFTP.ChangeDir(Directory);
    List := TStringList.Create;
    Receipt := TStringList.Create;
    Stream := TStringStream.Create;
    try
      FIdFTP.List(List, '', false);
      with TGaugeFactory.GetGauge('Загрузка данных', 1, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            if (AnsiLowerCase(copy(List[i], Length(List[i]) - 3, 4)) = '.xml')
               and (AnsiLowerCase(copy(List[i], 1, 6)) = 'status') then
            begin
            (*
              // тянем файл к нам
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
            // последние .rpl.
            if AnsiLowerCase(copy(List[i], Length(List[i]) - 3, 4)) = '.rpl'
            then
            begin
              // тянем файл к нам
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
              // теперь перенесли файл в директроию Archive
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
  // Получаем файл из блоба
  MovementId := MovementDataSet.FieldByName('Id').asInteger;

  spFileInfo.ParamByName('inMovementId').Value := MovementId;
  spFileInfo.Execute;
  FileName := spFileInfo.ParamByName('outFileName').asString;

  spFileBlob.ParamByName('inMovementId').Value := MovementId;
  FileName := ExtractFilePath(ParamStr(0)) + FileName;
  FileWriteString(FileName, ReConvertConvert(spFileBlob.Execute));
  try

    // Подписылаем его
    SignFile(FileName, stComDoc, DebugMode
           , MovementDataSet.FieldByName('UserSign').asString
           , MovementDataSet.FieldByName('UserSeal').asString
           , MovementDataSet.FieldByName('UserKey').asString
           , MovementDataSet.FieldByName('NameExite').asString
           , MovementDataSet.FieldByName('NameFiscal').asString
            );

    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      'Документ сформирован и подписан';
    FInsertEDIEvents.Execute;

    // перекинуть на FTP
    //ShowMessage(FileName);exit;
    PutFileToFTP(ReplaceStr(FileName, '.xml', '.p7s'), Directory);
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      'Документ отправлен на FTP';
    FInsertEDIEvents.Execute;
  finally
    // Удаляем
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
  EUTaxService_СертификатExite, EUTaxService_СертификатМДС: string;
  ddd: OleVariant;
begin

if VarIsNull(ComSigner) then
    InitializeComSigner(DebugMode, UserSign, UserSeal, UserKey);

  if SignType = stDeclar then
    vbSignType := 1;
  if SignType = stComDoc then
    vbSignType := 2;

  // Подписание и/или шифрование
  for i := 1 to 10 do
    try
      if SignType = stComDoc then begin
          //ShowMessage('start FileName');
          ComSigner.SetFilesOptions(false);
          Error := ComSigner.GetLastErrorDescription;
          if Error <> okError then
             raise Exception.Create('ComSigner.SetFilesOptions(False) ' + Error);

          // проверка
          if not FileExists(FileName) then raise Exception.Create('Файл не найден : <'+FileName+'>');

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
             //!!!если изменился - обязтельно выполнить это под отладкой, что б узнать значение строки (и захаркодить её), при этом выбрать нужный сертификат!!!
             EUTaxService_СертификатExite := ComSigner.SelectServerCert;
             ShowMessage('EUTaxService_СертификатExite := ' + EUTaxService_СертификатExite);
             //!!!если изменился - обязтельно выполнить это под отладкой, что б узнать значение строки (и захаркодить её), при этом выбрать нужный сертификат!!!
             EUTaxService_СертификатМДС   := ComSigner.SelectServerCert;
             ShowMessage('EUTaxService_СертификатМДС := ' + EUTaxService_СертификатМДС);
         end;

         if NameExite <> ''
         then EUTaxService_СертификатExite := NameExite
         else EUTaxService_СертификатExite := 'O=ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "Е-КОМ";PostalCode=01042;CN=ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ "Е-КОМ";Serial=34241719;C=UA;L=місто КИЇВ;StreetAddress=провулок Новопечерський, буд. 19/3, корпус 1, к. 6';
         if NameFiscal <> ''
         then EUTaxService_СертификатМДС   := NameFiscal
         else EUTaxService_СертификатМДС   := 'O=Державна фіскальна служба України;CN=Державна фіскальна служба України.  ОТРИМАНО;Serial=2122385;C=UA;L=Київ';

         ddd := VarArrayCreate([0, 1], varOleStr);
         ddd[0] := EUTaxService_СертификатМДС;
         ddd[1] := EUTaxService_СертификатExite;
         ComSigner.SetFilesOptions(true);
         ComSigner.ProtectFilesEx(FileName, true, false, true, true, false, 'pn@exite.ua', ddd);
      end;
      Break;
    except
      on E: Exception do
      begin
        if i > 9 then
          raise Exception.Create
            ('Ошибка библиотеки Exite. ComSigner.SignFilesByAccountant'#10#13 + E.Message);
      end;
    end;
end;

procedure TEDI.InsertUpdateOrderVchasnoEDI(ORDER: OrderXML.IXMLORDERType;
  spHeader, spList: TdsdStoredProc; lFileName, ADealId, AId_doc : String);
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
  s : String;
begin
  try
    with spHeader, ORDER do
    begin
      ParamByName('inOrderInvNumber').Value := NUMBER;
      ParamByName('inOrderOperDate').Value := VarToDateTime(Date);

      ParamByName('inGLNPlace').Value := HEAD.DELIVERYPLACE;
      ParamByName('inGLN').Value := HEAD.BUYER;
      ParamByName('inDealId').Value := ADealId;
      ParamByName('inId_doc').Value := AId_doc;

      Execute;
      //
      // !!!Выход!!!
      if ParamByName('isLoad').Value then Exit;
      //
      MovementId := ParamByName('MovementId').Value;
      GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
    end;
  finally
      // обнулили, чтоб не мешать EDI
      spHeader.ParamByName('inDealId').Value := '';
      spHeader.ParamByName('inId_doc').Value := '';
  end;
  //
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
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :='{'+IntToStr(i)+'}Загрузка ORDER из Вчасно EDI завершена _'+lFileName+'_';
    FInsertEDIEvents.Execute;
    //
    FUpdateEDIVchasnoEDI.ParamByName('inMovementId').Value := MovementId;
    FUpdateEDIVchasnoEDI.ParamByName('inDealId').Value := ADealId;
    FUpdateEDIVchasnoEDI.ParamByName('inId_doc').Value := AId_doc;
    FUpdateEDIVchasnoEDI.Execute;
end;

procedure TEDI.UpdateOrderDESADVSaveVchasnoEDI(AEDIId, Id_send: Integer; AId_doc: String; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin
     try
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := Id_send;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
      FUpdateEDIErrorState.Execute;
    finally
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := 0;
    end;

    try
      FInsertVchasnoEventsDoc.ParamByName('inMovementId').Value := AEDIId;
      FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := Id_send;
      FInsertVchasnoEventsDoc.ParamByName('inDocumentId').Value :='';
      FInsertVchasnoEventsDoc.ParamByName('inVchasnoId').Value :='';
      FInsertVchasnoEventsDoc.ParamByName('inId_doc').Value :=AId_doc;
      //
      if isError = TRUE
      then FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Ошибка Отправка Вчасно Уведомление об отгрузке'
      else FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Отправка Вчасно Уведомление об отгрузке';
      FInsertVchasnoEventsDoc.Execute;
    finally
      FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := 0;
      FInsertVchasnoEventsDoc.ParamByName('inId_doc').Value := '';
    end;
  end;
end;

procedure TEDI.UpdateOrderORDERSPSaveVchasnoEDI(AEDIId, Id_send: Integer; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin
    try
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := Id_send;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
      FUpdateEDIErrorState.Execute;
    finally
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := 0;
    end;

    try
      FInsertEDIEvents.ParamByName('inMovementId').Value :=AEDIId;
      FInsertEDIEvents.ParamByName('inMovementId_send').Value := Id_send;
      if isError = TRUE
      then FInsertEDIEvents.ParamByName('inEDIEvent').Value := 'Ошибка Отправка Вчасно Подтверждение заказа'
      else FInsertEDIEvents.ParamByName('inEDIEvent').Value := 'Отправка Вчасно Подтверждение заказа';
      FInsertEDIEvents.Execute;
    finally
      FInsertEDIEvents.ParamByName('inMovementId_send').Value := 0;
    end;
  end;
end;

procedure TEDI.UpdateOrderCOMDOCSaveVchasnoEDI(AEDIId, Id_send: Integer; DocumentId, VchasnoId: String; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin

    try
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := Id_send;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
      FUpdateEDIErrorState.Execute;
    finally
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := 0;
    end;

    try
      FInsertVchasnoEventsDoc.ParamByName('inMovementId').Value :=AEDIId;
      FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := Id_send;
      FInsertVchasnoEventsDoc.ParamByName('inDocumentId').Value :=DocumentId;
      FInsertVchasnoEventsDoc.ParamByName('inVchasnoId').Value :=VchasnoId;
      if isError = TRUE
      then FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Ошибка Отправка Вчасно COMDOC-Расходная накладная'
      else FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Отправка Вчасно COMDOC-Расходная накладная';
      FInsertVchasnoEventsDoc.Execute;
    finally
      FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := 0;
    end;
  end;
end;

procedure TEDI.UpdateOrderDELNOTSaveVchasnoEDI(AEDIId, Id_send: Integer; DocumentId, VchasnoId: String; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin

    try
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := Id_send;
      FUpdateEDIErrorState.Execute;
    finally
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := 0;
    end;

    try
      FInsertVchasnoEventsDoc.ParamByName('inMovementId').Value :=AEDIId;
      FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := Id_send;
      FInsertVchasnoEventsDoc.ParamByName('inDocumentId').Value :=DocumentId;
      FInsertVchasnoEventsDoc.ParamByName('inVchasnoId').Value :=VchasnoId;
      if isError = TRUE
      then FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Ошибка Отправка Вчасно DELNOT-Расходная накладная'
      else FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Отправка Вчасно DELNOT-Расходная накладная';
      FInsertVchasnoEventsDoc.Execute;
    finally
      FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := 0;
    end;
  end;
end;

procedure TEDI.UpdateDesadvCondraSignVchasnoEDI(AEDIId, Id_send: Integer; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin

    try
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := Id_send;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
      FUpdateEDIErrorState.Execute;
    finally
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := 0;
    end;

    try
      FInsertEDIEvents.ParamByName('inMovementId').Value :=AEDIId;
      FInsertEDIEvents.ParamByName('inMovementId_send').Value := Id_send;
      if isError = TRUE
      then FInsertEDIEvents.ParamByName('inEDIEvent').Value := 'Ошибка Подписи Вчасно Декларация'
      else FInsertEDIEvents.ParamByName('inEDIEvent').Value := 'Подпись Вчасно Расходная Декларация';
      FInsertEDIEvents.Execute;
    finally
      FInsertEDIEvents.ParamByName('inMovementId_send').Value := 0;
    end;
  end;
    //
end;

procedure TEDI.UpdateOrderDELNOTSignVchasnoEDI(AEDIId, Id_send: Integer; isError : Boolean);
begin
  if AEDIId <> 0 then
  begin

    try
      FUpdateEDIErrorState.ParamByName('inMovementId').Value := AEDIId;
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := Id_send;
      FUpdateEDIErrorState.ParamByName('inIsError').Value := isError;
      FUpdateEDIErrorState.Execute;
    finally
      FUpdateEDIErrorState.ParamByName('inMovementId_send').Value := 0;
    end;

    try
      FInsertEDIEvents.ParamByName('inMovementId').Value :=AEDIId;
      FInsertEDIEvents.ParamByName('inMovementId_send').Value := Id_send;
      if isError = TRUE
      then FInsertEDIEvents.ParamByName('inEDIEvent').Value := 'Ошибка Подписи Вчасно Расходная накладная'
      else FInsertEDIEvents.ParamByName('inEDIEvent').Value := 'Подпись Вчасно Расходная накладная';
      FInsertEDIEvents.Execute;
    finally
      FInsertEDIEvents.ParamByName('inMovementId_send').Value := 0;
    end;
  end;
    //
end;

procedure TEDI.OrderLoadVchasnoEDI(AOrder, AFileName, ADealId, AId_doc: String; spHeader, spList: TdsdStoredProc);
var
  ORDER: OrderXML.IXMLORDERType;
begin
  try
    ORDER := OrderXML.LoadORDER(AOrder);
    // загружаем в базенку
    InsertUpdateOrderVchasnoEDI(ORDER, spHeader, spList, AFileName, ADealId, AId_doc);
  except
    on E: Exception do begin raise Exception.Create(E.Message);
    end;
  end;
end;

procedure TEDI.ComdocLoadVchasnoEDI(FileData, AFileName, ADealId, AVchasno_id, ADocumentId_vch: String; spHeader, spList: TdsdStoredProc);
var
  ЕлектроннийДокумент: ComDocXML.IXMLЕлектроннийДокументType;
  MovementId: Integer;
begin
                MovementId:= 0;
                try
                   ЕлектроннийДокумент := ComDocXML.LoadЕлектроннийДокумент(FileData);
                except ON E: Exception DO
                      Begin
                         ShowMessage(E.Message +#10  +#13 + 'LoadЕлектроннийДокумент ADealId = ' + ADealId);
                         MovementId:= -1;
                      End;
                end;

                if MovementId <> -1
                then

                if (ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '007')
                 or(ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '004')
                 or(ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '012')
                 //13.07.2022
                 or(ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '005')
               then
                begin
                  // загружаем в базенку
                  try
                    MovementId := InsertUpdateComDoc(ЕлектроннийДокумент,
                      spHeader, spList, ADealId, AVchasno_id, ADocumentId_vch);
                  Except ON E: Exception DO
                    Begin
                      MovementId := -1;
                      ShowMessage(E.Message +#10  +#13 + 'InsertUpdateComDoc ADealId = ' + ADealId);
                    End;
                  end;
                end;
end;


procedure TEDI.ORDERSPSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
var ORDRSP: ORDRSPXML.IXMLORDRSPType;
    i: integer;
begin

  // Создать XML
  ORDRSP := ORDRSPXML.NewORDRSP;
  //
  ORDRSP.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  //Дата Підтвердження замовлення
  ORDRSP.Date := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  //Очікувана дата доставки
  ORDRSP.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  //Номер Замовлення у системі Вчано.EDI
  ORDRSP.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  //Дата Замовлення
  ORDRSP.ORDERDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
  // Номер договору на поставку
  ORDRSP.CAMPAIGNNUMBER:= HeaderDataSet.FieldByName('ContractName').asString;
  // Дата договору
  ORDRSP.CAMPAIGNNUMBERDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);

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
  //
  lFileName_save:= 'VchasnoEDI_ORDRSP_'
                   +HeaderDataSet.FieldByName('InvNumber').asString
                   +' '
                   +FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDate').asDateTime)
                   +'.xml'
                   ;
  ORDRSP.OwnerDocument.SaveToFile(lFileName_save);
  //test
  if AnsiUpperCase(gc_ProgramName) = AnsiUpperCase('Project.exe')
  then ORDRSP.OwnerDocument.SaveToFile('test_ORDRSP_VchasnoEDI.xml');
  //
  ORDRSP.OwnerDocument.SaveToStream(Stream);
end;

procedure TEDI.DESADVSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
var
  DESADV: DesadvXML.IXMLDESADVType;
  i: integer;
begin
  // Создать XML
  DESADV := DesadvXML.NewDESADV;
  // Номер повідомлення про відвантаження
  DESADV.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  // Дата Повідомлення про відвантаження
  DESADV.Date := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  //Очікувана дата доставки
  DESADV.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  //Очікуваний час доставки
  //DESADV.DELIVERYTIME := '00:00';
  // Номер замовлення
  DESADV.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  // Дата замовлення
  DESADV.ORDERDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDateOrder').asDateTime);
  // Номер накладної
  DESADV.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  // Дата накладної
  DESADV.DELIVERYNOTEDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  // Номер договору на поставку
  DESADV.CAMPAIGNNUMBER:= HeaderDataSet.FieldByName('ContractName').asString;
  // Дата договору
  DESADV.CAMPAIGNNUMBERDATE := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);

  //
  if HeaderDataSet.FieldByName('INFO_RoomNumber').asString <> ''
  then DESADV.INFO := HeaderDataSet.FieldByName('INFO_RoomNumber').asString;

  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then
      DESADV.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  DESADV.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  DESADV.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName
    ('DELIVERYPLACEGLNCode').asString;
  DESADV.HEAD.SENDER := HeaderDataSet.FieldByName('SenderGLNCode').asString;
  DESADV.HEAD.RECIPIENT := HeaderDataSet.FieldByName ('RecipientGLNCode').asString;

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

        // Замовлена кількість
        ORDEREDQUANTITY :=
          StringReplace(FormatFloat('0.000',
          ItemsDataSet.FieldByName('AmountOrder').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        // Кількість ящиків
        if ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat > 0
        then
            BOXESQUANTITY :=
              StringReplace(FormatFloat('0.##',
              ItemsDataSet.FieldByName('Count_Box_fozz').AsFloat),
              FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        COUNTRYORIGIN := 'UA';
        PRICE := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('Price').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

        // Цена з ПДВ
        PRICEWITHVAT := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('PriceWVAT').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
        // ПДВ
        TAXRATE:= StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('VATPercent').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

      end;
      inc(i);
      Next;
    end;
  end;
  //
  lFileName_save:= 'VchasnoEDI_DESADV_'
                   +HeaderDataSet.FieldByName('InvNumber').asString
                   +' '
                   +FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDate').asDateTime)
                   +'.xml'
                   ;
  //
  DESADV.OwnerDocument.SaveToFile(lFileName_save);
  //test
  if AnsiUpperCase(gc_ProgramName) = AnsiUpperCase('Project.exe')
  then DESADV.OwnerDocument.SaveToFile('test_DESADV_VchasnoEDI.xml');
  //
  DESADV.OwnerDocument.SaveToStream(Stream);
end;

procedure TEDI.DelnotSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
var
  Delnot_Vchasno: invoice_delnote_base.IXMLDocumentInvoiceType;
  i: integer;
  TotalGrossAmount, TotalNetAmount : Double;
begin
  // 1.1. Создать XML - fozzy - Amount
  Delnot_Vchasno := invoice_delnote_base.NewDocumentInvoice;
  // Номер повідомлення про відвантаження
  Delnot_Vchasno.InvoiceHeader.InvoiceNumber := HeaderDataSet.FieldByName('InvNumber').asString;
  // Дата документа
  Delnot_Vchasno.InvoiceHeader.InvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDatePartner').asDateTime);
  //Код типу документа: TN - накладна за кількістю
  Delnot_Vchasno.InvoiceHeader.DocumentFunctionCode := 'TN';
  // Номер договору на поставку
  Delnot_Vchasno.InvoiceHeader.ContractNumber := HeaderDataSet.FieldByName('ContractName').asString;
  // Дата договору
  Delnot_Vchasno.InvoiceHeader.ContractDate := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  // Місце складання
  Delnot_Vchasno.InvoiceHeader.Place := HeaderDataSet.FieldByName('PlaceOf').asString;
  // Номер замовлення
  Delnot_Vchasno.InvoiceReference.Order.BuyerOrderNumber := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  // Дата замовлення
  Delnot_Vchasno.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);

  // Дата замовлення
  Delnot_Vchasno.InvoiceReference.Order.BuyerOrderDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);

  // Номер повідомлення про відвантаження
  Delnot_Vchasno.InvoiceReference.DespatchAdvice.DespatchAdviceNumber := HeaderDataSet.FieldByName('InvNumber').asString;

  //Номер податкової накладної
  if HeaderDataSet.FieldByName('InvNumberPartner_Master').asString <> ''
  then begin
         Delnot_Vchasno.InvoiceReference.TaxInvoice.TaxInvoiceNumber := HeaderDataSet.FieldByName('InvNumberPartner_Master').asString;
         Delnot_Vchasno.InvoiceReference.TaxInvoice.TaxInvoiceDate := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate_tax').asDateTime);
  end;


  // Глобальний номер розташування (GLN) контрагента - GLN покупця
  if HeaderDataSet.FieldByName('BuyerGLNCode').asString <> ''
  then Delnot_Vchasno.InvoiceParties.Buyer.ILN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  // Податковий ідентифікаційний номер - покупця
  if HeaderDataSet.FieldByName('INN_To').asString <> ''
  then Delnot_Vchasno.InvoiceParties.Buyer.TaxID := HeaderDataSet.FieldByName('INN_To').asString;
  // Код ЄДРПОУ - покупця
  if HeaderDataSet.FieldByName('OKPO_To').asString <> ''
  then Delnot_Vchasno.InvoiceParties.Buyer.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_To').asString;
  // Назва контрагента
  Delnot_Vchasno.InvoiceParties.Buyer.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString;
  // Місто - Точка доставки
  Delnot_Vchasno.InvoiceParties.Buyer.CityName := HeaderDataSet.FieldByName('CityName_To').asString;
  // Вулиця і номер будинку - Точка доставки
  Delnot_Vchasno.InvoiceParties.Buyer.StreetAndNumber := HeaderDataSet.FieldByName('StreetName_To').asString;
  // Поштовий код - Точка доставки
  Delnot_Vchasno.InvoiceParties.Buyer.PostalCode := HeaderDataSet.FieldByName('PostalCode_To').asString;
  // Country
  Delnot_Vchasno.InvoiceParties.Buyer.Country := HeaderDataSet.FieldByName('CountryName_to').asString;

  // Глобальний номер розташування (GLN) контрагента - GLN продавця
  if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
  then Delnot_Vchasno.InvoiceParties.Seller.ILN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  // Податковий ідентифікаційний номер - продавця
  if HeaderDataSet.FieldByName('INN_From').asString <> ''
  then Delnot_Vchasno.InvoiceParties.Seller.TaxID := HeaderDataSet.FieldByName('INN_From').asString;
  // Код ЄДРПОУ - продавця
  if HeaderDataSet.FieldByName('OKPO_From').asString <> ''
  then Delnot_Vchasno.InvoiceParties.Seller.UtilizationRegisterNumber := HeaderDataSet.FieldByName('OKPO_From').asString;
  // Назва продавця
  Delnot_Vchasno.InvoiceParties.Seller.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString;

  // Глобальний номер розташування (GLN) контрагента - GLN Точка доставки
  if HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString <> ''
  then Delnot_Vchasno.InvoiceParties.DeliveryPoint.ILN := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;

  TotalGrossAmount := 0;
  TotalNetAmount := 0;
  with ItemsDataSet do
  begin
    First;
    i := 1;
    while not Eof do
    begin
      with Delnot_Vchasno.InvoiceLines.Add do
      begin
        // Номер товарної позиції
        LineItem.LineNumber := i;
        // Штрихкод продукту
        LineItem.EAN := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
        // Артикул в БД покупця
        LineItem.BuyerItemCode := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
        // Найменування товарної позиції
        LineItem.ItemDescription := ItemsDataSet.FieldByName('GoodsName').asString;
        // кількість, що поставляється
        LineItem.InvoiceQuantity := ItemsDataSet.FieldByName('AmountPartner').AsFloat;
        // BuyerUnitOfMeasure
        //LineItem.BuyerUnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;
        //Одиниця виміру
        LineItem.UnitOfMeasure := ItemsDataSet.FieldByName('MeasureName').asString;
        // код УКТЗЕД
        LineItem.ExternalItemCode := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;
        // Ціна однієї одиниці без ПДВ
        LineItem.InvoiceUnitNetPrice := ItemsDataSet.FieldByName('PriceNoVAT').AsFloat;
        // Ставка податку (ПДВ,%):
        LineItem.TaxRate := ItemsDataSet.FieldByName('VATPercent').AsInteger;
        // Ставка податку (ПДВ,%):
        //LineItem.TaxCategoryCode := 'S';

        // Сума податку
        LineItem.TaxAmount := ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat - ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
        // Сума без ПДВ
        LineItem.NetAmount := ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;

        TotalGrossAmount := TotalGrossAmount + ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat;
        TotalNetAmount := TotalNetAmount + ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat;
      end;
      inc(i);
      Next;
    end;
  end;

    // Кількість рядків в документі
  Delnot_Vchasno.InvoiceSummary.TotalLines := i;
  // Загальна сума без ПДВ
  // Кількість рядків в документі
  Delnot_Vchasno.InvoiceSummary.TotalLines := i;
  // Загальна сума без ПДВ
  Delnot_Vchasno.InvoiceSummary.TotalNetAmount := Round(100 * TotalNetAmount) / 100;
  // Сума ПДВ
  Delnot_Vchasno.InvoiceSummary.TotalTaxAmount := Round(1.2 * Round(100 * TotalNetAmount)) / 100
                                                    - Round(100 * TotalNetAmount) / 100
                                                     ;
  // Загальна сума з ПДВ
  Delnot_Vchasno.InvoiceSummary.TotalGrossAmount := Round(1.2 * Round(100 * TotalNetAmount)) / 100;

  Delnot_Vchasno.OwnerDocument.SaveToFile('test_Delnot_VchasnoEDI.xml');
  Delnot_Vchasno.OwnerDocument.SaveToStream(Stream);
end;

procedure TEDI.ComDocSaveVchasnoEDI(HeaderDataSet, ItemsDataSet: TDataSet; Stream: TMemoryStream);
//procedure TEDI.COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet;
//  Directory: String; DebugMode: boolean);
var
  ЕлектроннийДокумент: invoice_comdoc_vchasno.IXMLЕлектроннийДокументType;
  i: integer;
  XMLFileName: string;
begin
  // создать xml файл
  ЕлектроннийДокумент := invoice_comdoc_vchasno.NewЕлектроннийДокумент;
  ЕлектроннийДокумент.Заголовок.НомерДокументу := HeaderDataSet.FieldByName('InvNumber').asString;
  ЕлектроннийДокумент.Заголовок.ТипДокументу := 'Видаткова накладна';
  ЕлектроннийДокумент.Заголовок.КодТипуДокументу := '006';
  ЕлектроннийДокумент.Заголовок.ДатаДокументу := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDate').asDateTime);

  ЕлектроннийДокумент.Заголовок.НомерЗамовлення :=HeaderDataSet.FieldByName('InvNumberOrder').asString;
  ЕлектроннийДокумент.Заголовок.ДатаЗамовлення :=FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDateOrder').asDateTime);

  with ЕлектроннийДокумент.Заголовок.ДокПідстава do
  begin
    НомерДокументу := HeaderDataSet.FieldByName('InvNumber').asString;
    ТипДокументу := 'Повідомлення про відвантаження';
    КодТипуДокументу := '001';
    ДатаДокументу := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDate').asDateTime);
  end;

  with ЕлектроннийДокумент.Сторони.Add do
  begin
    СтатусКонтрагента := 'Продавець';
    //ВидОсоби := 'Юридична';
    НазваКонтрагента := HeaderDataSet.FieldByName('JuridicalName_From')
      .asString;
    КодКонтрагента := HeaderDataSet.FieldByName('OKPO_From').asString;
    ІПН := HeaderDataSet.FieldByName('INN_From').asString;
    if HeaderDataSet.FieldByName('SupplierGLNCode').asString <> ''
    then GLN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  end;
  with ЕлектроннийДокумент.Сторони.Add do
  begin
    СтатусКонтрагента := 'Покупець';
    //ВидОсоби := 'Юридична';
    НазваКонтрагента := HeaderDataSet.FieldByName('JuridicalName_To').asString;
    КодКонтрагента := HeaderDataSet.FieldByName('OKPO_To').asString;
    ІПН := HeaderDataSet.FieldByName('INN_To').asString;
    GLN := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  end;

  // Глобальний номер розташування (GLN) контрагента - GLN Точка доставки
  with ЕлектроннийДокумент.Параметри.Add do
  begin
       назва:= 'Точка доставки';
       NodeValue:= HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
  end;
  //Адреса доставки - Точка доставки
  with ЕлектроннийДокумент.Параметри.Add do
  begin
       назва:= 'Адреса доставки';
       NodeValue:= HeaderDataSet.FieldByName('PartnerAddress_To').asString;
  end;

  //Номер договору на поставку
  with ЕлектроннийДокумент.Параметри.Add do
  begin
       назва:= 'Номер договору';
       NodeValue:= HeaderDataSet.FieldByName('ContractName').asString;
  end;
  //Дата договору
  with ЕлектроннийДокумент.Параметри.Add do
  begin
       назва:= 'Дата договору';
       NodeValue:= FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  end;

  //Номер податкової накладної
  with ЕлектроннийДокумент.Параметри.Add do
  begin
       назва:= 'Номер податкової накладної';
       NodeValue:= HeaderDataSet.FieldByName('InvNumberPartner_Master').asString;
  end;
  //Дата податкової накладної
  with ЕлектроннийДокумент.Параметри.Add do
  begin
       назва:= 'Дата податкової накладної';
       NodeValue:= FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate_tax').asDateTime);
  end;

  with ЕлектроннийДокумент.ВсьогоПоДокументу do
  begin
       СумаБезПДВ:= gfFloatToStr(HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat);
       ПДВ:= gfFloatToStr(HeaderDataSet.FieldByName('SummVAT').AsFloat);
       Сума:= gfFloatToStr(HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat);
  end;


  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do
  begin
    with ЕлектроннийДокумент.Таблиця.Add do
    begin
      //ІД := i;
      НомПоз := i;
      Штрихкод := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').asString;
      АртикулПокупця := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
      Найменування := ItemsDataSet.FieldByName('GoodsName').asString;
      //ОдиницяВиміру
      ОдиницяВиміру:= ItemsDataSet.FieldByName('MeasureName').asString;
      // код УКТЗЕД
      КодУКТЗЕД := ItemsDataSet.FieldByName('GoodsCodeUKTZED').asString;

      ПрийнятаКількість := gfFloatToStr(ItemsDataSet.FieldByName('AmountPartner').AsFloat);
      //Ціна за одиницю без ПДВ
      БазоваЦіна:= gfFloatToStr(ItemsDataSet.FieldByName('PriceNoVAT').AsFloat);
      //Ціна за одиницю з ПДВ
      Ціна := gfFloatToStr(ItemsDataSet.FieldByName('PriceWVAT').AsFloat);
      //СтавкаПДВ
      СтавкаПДВ := gfFloatToStr(ItemsDataSet.FieldByName('VATPercent').AsFloat);

      //ВсьогоПоРядку - Сума Без ПДВ
      ВсьогоПоРядку.СумаБезПДВ:= gfFloatToStr(ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat);
      //ВсьогоПоРядку - Сума ПДВ
      ВсьогоПоРядку.ПДВ:= gfFloatToStr(ROUND(ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat * 100) / 100 - ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat);
      //ВсьогоПоРядку - Сума з ПДВ
      ВсьогоПоРядку.Сума:= gfFloatToStr(ROUND(ItemsDataSet.FieldByName('AmountSummWVAT').AsFloat * 100) / 100);


      inc(i);
    end;
    ItemsDataSet.Next;
  end;

  ЕлектроннийДокумент.OwnerDocument.SaveToFile('test_ComDoc_VchasnoEDI.xml');
  ЕлектроннийДокумент.OwnerDocument.SaveToStream(Stream);

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
  // создание документ
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
  with TdsdPairParamsItem(FPairParams.Add) do
  begin
    DataType := ftString;
    FieldName := 'vchasno_id';
    PairName := 'vchasno_id';
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

  FMetadataParam := TdsdParam.Create(nil);
  FMetadataParam.DataType := ftString;
  FMetadataParam.Value := '';

  FMetadata_sender_glnParam := TdsdParam.Create(nil);
  FMetadata_sender_glnParam.DataType := ftString;
  FMetadata_sender_glnParam.Value := '';

  FMetadata_recipient_glnParam := TdsdParam.Create(nil);
  FMetadata_recipient_glnParam.DataType := ftString;
  FMetadata_recipient_glnParam.Value := '';

  FMetadata_buyer_glnParam := TdsdParam.Create(nil);
  FMetadata_buyer_glnParam.DataType := ftString;
  FMetadata_buyer_glnParam.Value := '';

  FMetadata_numberParam := TdsdParam.Create(nil);
  FMetadata_numberParam.DataType := ftString;
  FMetadata_numberParam.Value := '';

  FMetadata_document_function_codeParam := TdsdParam.Create(nil);
  FMetadata_document_function_codeParam.DataType := ftString;
  FMetadata_document_function_codeParam.Value := '';

  FMetadata_fileParam := TdsdParam.Create(nil);
  FMetadata_fileParam.DataType := ftString;
  FMetadata_fileParam.Value := '';

  FMetadata_doc_to_attach_idParam := TdsdParam.Create(nil);
  FMetadata_doc_to_attach_idParam.DataType := ftString;
  FMetadata_doc_to_attach_idParam.Value := '';

  FMetadata_doc_to_attach_numberParam := TdsdParam.Create(nil);
  FMetadata_doc_to_attach_numberParam.DataType := ftString;
  FMetadata_doc_to_attach_numberParam.Value := '';


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
  FreeAndNil(FMetadataParam);
  FreeAndNil(FFileNameParam);

  FreeAndNil(FMetadata_sender_glnParam);
  FreeAndNil(FMetadata_recipient_glnParam);
  FreeAndNil(FMetadata_buyer_glnParam);
  FreeAndNil(FMetadata_numberParam);
  FreeAndNil(FMetadata_document_function_codeParam);
  FreeAndNil(FMetadata_fileParam);
  FreeAndNil(FMetadata_doc_to_attach_idParam);
  FreeAndNil(FMetadata_doc_to_attach_numberParam);

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
// 0 - Загрузить списак документов в Json
// 1 - Загрузить списак документов в DataSet
// 2 - Звгрузить пракрепленный файл в Result
// 3 - Звгрузить пракрепленный файл и сохранить его на диск
// 4 - Звгрузить оригинальный файл в Result
// 5 - Звгрузить оригинальный файл и сохранить его на диск
// 6 - Отправка файла с методанными
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
      FileData: string;
begin
  inherited;
  Result := False;

  if (FTokenParam.Value = '') or
     (FHostParam.Value = '') then
  begin
    ShowMessages('Не заполнены Host или Токен.');
    Exit;
  end;

  if (ATypeExchange = 1) then
  begin
    if not Assigned(ADataSet) then
    begin
      ShowMessages('Не указан DataSet.');
      Exit;
    end;

    if FPairParams.Count = 0 then
    begin
      ShowMessages('Не определены данные в PairParams для формирования DataSet.');
      Exit;
    end;
  end;

  // Непосредственно отправка

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
    if ATypeExchange in [2, 3, 22] then
    begin
      Params := '/' + FOrderParam.Value + '/original';

    end else if ATypeExchange in [4, 5] then
    begin

      //comdoc+delnot
      if FEDIDocType = ediSignCondra
      then Params := '/condra/' + FDocumentIdParam.Value + '/attachments'
      else Params := '/' + FDocumentIdParam.Value + '/original';

      //condra
      //Params := '/condra/' + FDocumentIdParam.Value + '/attachments';

    end else
    begin
      Params := 'type=' + FDocTypeParam.AsString;

      if (FDateFromParam.Value <> Null) and (FDateFromParam.Value <> Null) then
        Params := Params + '&date_from=' + FormatDateTime('YYYY-MM-DD', StrToDateTime(FDateFromParam.Value));

      if (FDateToParam.Value <> Null) and (FDateToParam.Value <> Null) then
        Params := Params + '&date_to=' + FormatDateTime('YYYY-MM-DD', StrToDateTime(FDateToParam.Value));

      if FDocStatusParam.Value <> '' then
       if ATypeExchange = 11
       then
           // получить ComDoc
           Params := Params + '&vchasno_status=signed_and_sent'
       else
            // получить Order
            Params := Params + '&deal_status=' + FDocStatusParam.Value;

      if Params <> '' then Params := '?' + Params;
    end;

    Stream := TMemoryStream.Create;

    if ATypeExchange = 22
    then //ComDoc - так уже работает
         StringStream:= TStringStream.Create('') // , TEncoding.Ansi

    else //Order
         StringStream:= TStringStream.Create('', TEncoding.UTF8);

    //
    try
      try
        //comdoc+delnot
        IdHTTP.Get(TIdURI.URLEncode(FHostParam.Value + Params), Stream);

        //condra
        //IdHTTP.Get(TIdURI.URLEncode('https://edi.vchasno.ua/api/v2/additional-documents' + Params), Stream);

      except on E:EIdHTTPProtocolException
            do ShowMessages(e.ErrorMessage);
      end;

      if IdHTTP.ResponseCode = 200 then
      begin

        // разархевируем полученный результат если надо
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

           // если задано сразу имя файла
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

           // проверяем путь файла
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

           // проверяем имя файла
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

           // сохраним файл
           StringStream.SaveToFile(FFileNameParam.Value);
           Result := True;
        end
        else
        // Order + ComDoc
        if ATypeExchange in [1, 11] then
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

          // для теста - сохранить список документов который надо будет обработать
          StringStream.SaveToFile('test_TJSONArray.txt');

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

           // Order + ComDoc - здесь уже ОДИН документ
           if ATypeExchange in [2, 22] then
           begin
             FFileNameParam.Value := '';
             if Pos('filename', IdHTTP.Response.ContentDisposition) > 0 then
             begin
               Res := TRegEx.Split(IdHTTP.Response.ContentDisposition, '"');
               if (High(Res) > 1) and (TPath.GetFileName(Res[1]) <> '') then
                 FFileNameParam.Value := TPath.GetFileName(Res[1])
             end;
           end;

          // для теста - сохранили содержиомое документа
          //StringStream.SaveToFile('test_TJSON_data.txt');


          // вернули содержиомое документа
          if ATypeExchange = 2
          then FResultParam.Value := StringStream.DataString
          else begin
                    // ***уже работает
                    FileData := Utf8ToAnsi(StringStream.DataString);

                    // Если нет <?xml то берем по <ЕлектроннийДокумент>
                    FileData := '<?xml version="1.0" encoding="utf-8"?>'#13#10 +
                                copy(FileData, pos('<ЕлектроннийДокумент>', FileData), MaxInt);
                    //???
                    FileData := copy(FileData, 1, pos('</ЕлектроннийДокумент>',
                      FileData) + 21);


                    //FileData:= ReplaceStr(FileData,'<ДатаЗамовлення>--</ДатаЗамовлення>','<ДатаЗамовлення></ДатаЗамовлення>');

                    // test
                    //ShowMessage(FileData);

                    // test
                    AddToLog('');
                    AddToLog('start ЕлектроннийДокумент Id : ' + FOrderParam.Value);
                    AddToLog('deal_id : ' + ADataSet.FieldByName('deal_id').AsString);
                    AddToLog('vchasno_id  :' + ADataSet.FieldByName('vchasno_id').AsString);
                    AddToLog(FileData);
                    AddToLog('');

                    FResultParam.Value := FileData;
               end;

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
// 0 - Отправить данных с потока
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
    ShowMessages('Не заполнены Host или Токен.');
    Exit;
  end;

  // Непосредственно отправка

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
      //
      if FileExists(EDI.lFileName_save) then DeleteFile(EDI.lFileName_save);

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

// ATypeExchange
// 0 - Отправить файла + методанные
function TdsdVchasnoEDIAction.POSTCondraEDI(ATypeExchange : Integer): Boolean;
  var IdHTTP: TCustomIdHTTP;
      Params, S: String;
      Stream: TIdMultiPartFormDataStream;
      jsonObj: TJSONObject;
      testStringStream:TStringStream;
begin
  inherited;
  Result := False;

  if (FTokenParam.Value = '') or
     (FHostParam.Value = '') then
  begin
    ShowMessages('Не заполнены Host или Токен.');
    Exit;
  end;

  // Непосредственно отправка

  IdHTTP := TCustomIdHTTP.Create(Nil);
  Stream := TIdMultiPartFormDataStream.Create;
  try

    // Поле JSON (можна задати ContentType)
    //Stream.AddFormField('metadata', FMetadataParam.Value, 'utf-8').ContentType := 'application/json';
    //
    if FMetadata_sender_glnParam.Value <> ''             then Stream.AddFormField('sender_gln', FMetadata_sender_glnParam.Value);
    if FMetadata_recipient_glnParam.Value <> ''          then Stream.AddFormField('recipient_gln', FMetadata_recipient_glnParam.Value);
    if FMetadata_buyer_glnParam.Value <> ''              then Stream.AddFormField('buyer_gln', FMetadata_buyer_glnParam.Value);
    if FMetadata_numberParam.Value <> ''                 then Stream.AddFormField('number', FMetadata_numberParam.Value);
    if FMetadata_document_function_codeParam.Value <> '' then Stream.AddFormField('document_function_code', FMetadata_document_function_codeParam.Value);
    if FMetadata_fileParam.Value <> ''                   then Stream.AddFormField('file', FMetadata_fileParam.Value);
    if FMetadata_doc_to_attach_idParam.Value <> ''       then Stream.AddFormField('doc_to_attach_id', FMetadata_doc_to_attach_idParam.Value);
    if FMetadata_doc_to_attach_numberParam.Value <> ''   then Stream.AddFormField('doc_to_attach_number', FMetadata_doc_to_attach_numberParam.Value);
    // Додаємо файл
    Stream.AddFile('file', FFileNameParam.Value, 'application/pdf');

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
//    Params := 'deal_id=' + FOrderParam.Value;
//    if Params <> '' then Params := '?' + Params;

    try
      S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + Params), Stream);
    except on E:EIdHTTPProtocolException  do
                ShowMessages(e.ErrorMessage);
    end;

    // для теста -
    //testStringStream:= TStringStream.Create('', TEncoding.UTF8);
    //Stream.Position := 0;
    //testStringStream.CopyFrom(Stream, 0);
    //testStringStream.SaveToFile('test_Condra.txt');
    //testStringStream.Free;


    if IdHTTP.ResponseCode in [200,201] then
    begin
      jsonObj := TJSONObject.ParseJSONValue(S) as TJSONObject;
      try
        // ?для Condra не так?
        if (jsonObj.Get('deal_status') <> nil) and (jsonObj.Get('deal_status').JsonValue.Value = 'in_work') and
         (jsonObj.Get('document_id') <> nil)  then
        begin
          FDocumentIdParam.Value := jsonObj.Get('document_id').JsonValue.Value;
          if jsonObj.Get('vchasno_id') <> nil then
            FVchasnoIdParam.Value := jsonObj.Get('vchasno_id').JsonValue.Value
          else FVchasnoIdParam.Value := '';
        end
        else
        // Так для Condra
        if (jsonObj.Get('vchasno_status') <> nil) and (jsonObj.Get('vchasno_status').JsonValue.Value = 'ready_to_be_signed') and
         (jsonObj.Get('id') <> nil)  then
        begin
          FDocumentIdParam.Value := jsonObj.Get('id').JsonValue.Value;
          //if jsonObj.Get('vchasno_id') <> nil then
          //  FVchasnoIdParam.Value := jsonObj.Get('vchasno_id').JsonValue.Value
          //else FVchasnoIdParam.Value := '';
        end

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

const

  Base64EncodeChars: array[0..63] of Char = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/');

function base64encode(const Data: TBytes): string;
var
  R, Len, I, J, L : Longint;
  C : LongWord;
begin
  Result := '';
  Len := Length(Data);
  if Len = 0 then Exit;
  R := Len mod 3;
  Dec(Len, R);
  L := (Len div 3) * 4;
  if (R > 0) then Inc(L, 4);
  SetLength(Result, L);
  I := 0;
  J := 1;
  while (I < Len) do begin
    C := Data[I];
    Inc(I);
    C := (C shl 8) or Data[I];
    Inc(I);
    C := (C shl 8) or Data[I];
    Inc(I);
    Result[J] := Base64EncodeChars[C shr 18];
    Inc(J);
    Result[J] := Base64EncodeChars[(C shr 12) and $3F];
    Inc(J);
    Result[J] := Base64EncodeChars[(C shr 6) and $3F];
    Inc(J);
    Result[J] := Base64EncodeChars[C and $3F];
    Inc(J);
  end;
  if (R = 1) then begin
    C := Data[I];
    Result[J] := Base64EncodeChars[C shr 2];
    Inc(J);
    Result[J] := Base64EncodeChars[(C and $03) shl 4];
    Inc(J);
    Result[J] := '=';
    Inc(J);
    Result[J] := '=';
  end
  else if (R = 2) then begin
    C := Data[I];
    Inc(I);
    C := (C shl 8) or Data[I];
    Result[J] := Base64EncodeChars[C shr 10];
    Inc(J);
    Result[J] := Base64EncodeChars[(C shr 4) and $3F];
    Inc(J);
    Result[J] := Base64EncodeChars[(C and $0F) shl 2];
    Inc(J);
    Result[J] := '=';
  end;
end;

function TdsdVchasnoEDIAction.POSTSignVchasnoEDI: Boolean;
  var IdHTTP: TCustomIdHTTP;
      S, Params: String;
      fileStreamSing: TMemoryStream;
      fileStreamStamp: TMemoryStream;
      Stream: TStringStream;
      JSONObject: TJSONObject;

      Body: string;
      ByteArray: TBytes;

  function MemoryToBytes(const Ptr: Pointer; Size: Integer): TBytes;
  begin
    SetLength(Result, Size);
    if (Size > 0) and Assigned(Ptr) then
      Move(Ptr^, Result[0], Size);
  end;

begin
  inherited;
  Result := False;

  if (FTokenParam.Value = '') or
     (FHostParam.Value = '') then
  begin
    ShowMessages('Не заполнены Host или Токен.');
    Exit;
  end;

  if not FileExists(FFileNameParam.Value + '_sign.p7s') then
  begin
    ShowMessages('Файл ' + FFileNameParam.Value + '_sign.p7s' + ' не найден.');
    Exit;
  end;

  // Непосредственно загрузка файла для подписи

  IdHTTP := TCustomIdHTTP.Create(Nil);
  try

    fileStreamSing := TMemoryStream.Create;
    fileStreamSing.LoadFromFile(FFileNameParam.Value + '_sign.p7s');
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then
    begin
      fileStreamStamp := TMemoryStream.Create;
      fileStreamStamp.LoadFromFile(FFileNameParam.Value + '_stamp.p7s');
    end;

    try
      JSONObject := TJSONObject.Create;
      try
        try

          ByteArray := MemoryToBytes(fileStreamSing.Memory, fileStreamSing.Size);
          JSONObject.AddPair('signature',  base64encode(ByteArray));
          if Assigned(fileStreamStamp) then
          begin
            ByteArray := MemoryToBytes(fileStreamStamp.Memory, fileStreamStamp.Size);
            JSONObject.AddPair('stamp', base64encode(ByteArray));
          end;
          Body := JSONObject.ToString;

        except on E:EIdHTTPProtocolException  do
                    ShowMessages('Ошибка: ' + e.ErrorMessage);
        end;
      finally
        JSONObject.Free;
      end;
    finally
      FreeAndNil(fileStreamStamp);

      FreeAndNil(fileStreamSing);
    end;

    IdHTTP.Request.Clear;
    IdHTTP.Request.ContentType := 'application/json';
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.AcceptEncoding := 'gzip, deflate, br';
    //IdHTTP.Request.Accept := '*/*';
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
        //comdoc+delnot+condra
        S := IdHTTP.Post(TIdURI.URLEncode(FHostParam.Value + Params), Stream);

        //condra
        //S := IdHTTP.Post(TIdURI.URLEncode('https://edi.vchasno.ua/api/v2/additional-documents' + Params), Stream);

      except on E:EIdHTTPProtocolException  do
                ShowMessages('Ошибка: ' + e.ErrorMessage);
      end;
    finally
      FreeAndNil(Stream);
    end;

    if (IdHTTP.ResponseCode = 200) or (IdHTTP.ResponseCode = 201) then
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
      ShowMessages('Ошибка Не найден файл библиотеки подписи: ' + EUDLLName);
    end;
  end;

{$IFDEF WIN64}

  SignFile := ExtractFilePath(ParamStr(0)) + 'SignFile.exe';

  if not FileExists(SignFile) then
  begin
    ShowMessages('Ошибка Не найдена программа шифрования: ' + SignFile);
    Exit;
  end;

  // 1.Установка ключей
  if ExtractFilePath(UserSign) <> ''
  then FileKeyName := AnsiString(UserSign)
  else FileKeyName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

  // проверка
  if not FileExists(String(FileKeyName)) then
  begin
    ShowMessages('Файл не найден : <'+String(FileKeyName)+'>');
    Exit;
  end;

  FKeyFileNameParam.Value := ExtractFileName(String(FileKeyName));

  FileName := FFileNameParam.Value;
  // проверка
  if not FileExists(String(FileName)) then
  begin
    ShowMessages('Файл документа не найден : <'+String(FileName)+'>');
    Exit;
  end;

  CmdLine := '"' + SignFile + '" "' + apath + '" "' + FileKeyName + '" "24447183" "' + FileName + '"';

  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
  end;

  // Запускаем процесс подписи
  // Ожидаем завершения приложения
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
    ShowMessages('Ошибка Не найдена результат работы программы шифрования: ' + FileName);
    Exit;
  end;

  f := TiniFile.Create(FileName);

  try
    try
      if F.ReadString('SignResult', 'Ошибка', '') = '' then
      begin
        FKeyUserNameParam.Value := F.ReadString('SignResult', 'UserName', '');
        Result := True;
      end else ShowMessages('Ошибка ' + F.ReadString('SignResult', 'Ошибка', ''));;
    Except
    end;
  finally
    f.Free;
  end;
  DeleteFile(FileName);

{$ELSE}

  if not EULoadDLL(apath) then
  begin
    ShowMessages('Ошибка Не загружена библиотеки подписи: ' + EUDLLName);
    Exit;
  end;
  CPInterface := EUGetInterface();
  if CPInterface = nil then
  begin
    EUUnloadDLL();
    ShowMessages('Ошибка Не загружена библиотеки подписи: ' + EUDLLName);
    Exit;
  end;
  CPInterface.SetUIMode(false);
  EUInitializeOwnUI(CPInterface, true);
  try

    nError := CPInterface.Initialize();
    if nError <> EU_ERROR_NONE then
    begin
      ShowMessages('Ошибка Инициализации библиотеки подписи: ' + EUDLLName);
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
        ShowMessages('Ошибка В библиотеке подписи: ' + E.Message);
        Exit;
      end;
    end;

    try
      // 1.Установка ключей
      if ExtractFilePath(UserSign) <> ''
      then FileName := AnsiString(UserSign)
      else FileName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

      // проверка
      if not FileExists(String(FileName)) then
      begin
        ShowMessages('Файл не найден : <'+String(FileName)+'>');
        Exit;
      end;

      FKeyFileNameParam.Value := ExtractFileName(String(FileName));

      nError := CPInterface.ReadPrivateKeyFile (PAnsiChar(FileName), PAnsiChar('24447183'), @CertOwnerInfo); // бухгалтер
      if nError <> EU_ERROR_NONE then
      begin
        ShowMessages('Ошибка В библиотеке при загрузке электронного ключа: ' + CPInterface.GetErrorDesc(nError));
        Exit;
      end;

      FKeyUserNameParam.Value := String(CertOwnerInfo.SubjectFullName);
    except
      on E: Exception do
      begin
        ShowMessages('Ошибка В библиотеке при загрузке электронного ключа:' + E.Message);
        Exit;
      end;
    end;

    try
      // 2.Непосредственно подпись
      FileName := FFileNameParam.Value;
      // проверка
      if not FileExists(String(FileName)) then
      begin
        ShowMessages('Файл документа не найден : <'+String(FileName)+'>');
        Exit;
      end;

      nError := CPInterface.SignFile(PAnsiChar(FileName), PAnsiChar(FileName + '.p7s'), True);
      if nError <> EU_ERROR_NONE then
      begin
        ShowMessages('Ошибка В библиотеке при надожении подписи: ' + CPInterface.GetErrorDesc(nError));
        Exit;
      end;
    except
      on E: Exception do
      begin
        ShowMessages('Ошибка В библиотеке при надожении подписи:' + E.Message);
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

function TdsdVchasnoEDIAction.ComDoc007Load : Boolean;
  var DataSetCDS: TClientDataSet;
begin
  Result := False;

  FDocTypeParam.Value := 9;
  FDocStatusParam.Value := 'new';
//  FDocStatusParam.Value := 'rejected';

  // Загрузим список ComDoc-007 с Вчасно EDI - new
  DataSetCDS := TClientDataSet.Create(Nil);
  try

    if not GetVchasnoEDI(11, DataSetCDS) then
      raise Exception.Create('Ошибка загрузки списка ComDoc-документов-new.');

    if DataSetCDS.RecordCount > 0 then
    begin
        with TGaugeFactory.GetGauge(Caption, 0, DataSetCDS.RecordCount) do
        begin
          Start;
          try
            DataSetCDS.First;
            while not DataSetCDS.Eof do
            begin
              FOrderParam.Value := DataSetCDS.FieldByName('Id').AsString;
              if GetVchasnoEDI(22, DataSetCDS) then
              begin
                // создание документ
                case EDIDocType of
                  ediComDoc: EDI.ComDocLoadVchasnoEDI(FResultParam.Value
                                                     ,FFileNameParam.Value
                                                     ,DataSetCDS.FieldByName('deal_id').AsString
                                                     ,DataSetCDS.FieldByName('vchasno_id').AsString
                                                     ,DataSetCDS.FieldByName('id').AsString
                                                     ,FspHeader, FspList
                                                    );
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
    end
    else
    begin
      //ShowMessages('Нет накладных-new для загрузки.');
      Result := true;
      Exit;
    end;

  finally
    DataSetCDS.Free;
  end;

end;


function TdsdVchasnoEDIAction.OrderLoad : Boolean;
  var DataSetCDS: TClientDataSet;
begin
  Result := False;

  FDocTypeParam.Value := 1;
  FDocStatusParam.Value := 'new';
//  FDocStatusParam.Value := 'rejected';

  // Загрузим список заявок с Вчасно EDI - new
  DataSetCDS := TClientDataSet.Create(Nil);
  try

    if not GetVchasnoEDI(1, DataSetCDS) then
      raise Exception.Create('Ошибка загрузки списка Order-документов-new.');

    if DataSetCDS.RecordCount > 0 then
    begin
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
                // создание документ
                case EDIDocType of
                  ediOrder: EDI.OrderLoadVchasnoEDI(Copy(FResultParam.Value, Max(POS('<', FResultParam.Value), 1), Length(FResultParam.Value)),
                                                    FFileNameParam.Value, DataSetCDS.FieldByName('deal_id').AsString,DataSetCDS.FieldByName('Id').AsString, FspHeader, FspList
                                                   );
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

        //
        // загружаются rejected - ???отклоненный???
        //
        {Result := false;
        //
        DataSetCDS.Free;
        //
        DataSetCDS := TClientDataSet.Create(Nil);
        //
        // загружаются rejected - ???отклоненный???
        FDocStatusParam.Value := 'rejected';
        // Загрузим список заявок с Вчасно EDI - rejected
        if not GetVchasnoEDI(1, DataSetCDS) then
          raise Exception.Create('Ошибка загрузки списка документов-rejected.');
        //
        if DataSetCDS.RecordCount > 0 then
        begin
            ShowMessages('Есть накладные-rejected для загрузки.');
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
                    // создание документ
                    case EDIDocType of
                      ediOrder: EDI.OrderLoadVchasnoEDI(Copy(FResultParam.Value, Max(POS('<', FResultParam.Value), 1), Length(FResultParam.Value)),
                                                        FFileNameParam.Value, DataSetCDS.FieldByName('deal_id').AsString, FspHeader, FspList
                                                       );
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
        end

        else
        begin
          //ShowMessages('Нет накладных-rejected для загрузки.');
          Result := true;
          Exit;
        end;}

    end
    else
    begin
      //ShowMessages('Нет накладных-new для загрузки.');
      Result := true;
      Exit;
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
       EDI.lFileName_save:='';
       Stream.Free;
     end;
     //
     EDI.UpdateOrderORDERSPSaveVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger, HeaderDataSet.FieldByName('MovementId_EDI_send').asInteger, not Result);
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
       EDI.lFileName_save:='';
       Stream.Free;
     end;
     //
     EDI.UpdateOrderDESADVSaveVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger, HeaderDataSet.FieldByName('MovementId_EDI_send').asInteger, FDocumentIdParam.Value, not Result);
  end;

end;

function TdsdVchasnoEDIAction.DelnotSave : Boolean;
  var Stream: TMemoryStream;
begin
  Result := False;
  if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
  begin

     Stream := TMemoryStream.Create;
     try
       EDI.DelnotSaveVchasnoEDI(HeaderDataSet, ListDataSet, Stream);
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
                                       , HeaderDataSet.FieldByName('MovementId_EDI_send').asInteger
                                       , FDocumentIdParam.Value, FVchasnoIdParam.Value
                                       , not Result
                                        );
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
     EDI.UpdateOrderCOMDOCSaveVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger
                                       , HeaderDataSet.FieldByName('MovementId_EDI_send').asInteger
                                       , FDocumentIdParam.Value, FVchasnoIdParam.Value
                                       , not Result
                                        );
  end;

end;

function TdsdVchasnoEDIAction.DoSignComDoc: Boolean;
begin
  Result := False;
  if HeaderDataSet.FieldByName('DocumentId_vch').AsString = '' then Exit;
//  if HeaderDataSet.FieldByName('VchasnoId').AsString = '' then Exit;

  FOrderParam.Value := HeaderDataSet.FieldByName('DealId').AsString;
  FDocumentIdParam.Value := HeaderDataSet.FieldByName('DocumentId_vch').AsString;
  FVchasnoIdParam.Value := HeaderDataSet.FieldByName('VchasnoId').AsString;
  try

    // Получим файл документа
    Result := GetVchasnoEDI(5);
    //Result := GetDocETTN('4823036500001', '32d2bc90-577e-4e4c-af17-722b49cf1c86');

    if FileExists(FFileNameParam.Value + '.p7s') then DeleteFile(FFileNameParam.Value + '.p7s');
    if FileExists(FFileNameParam.Value + '_sign.p7s') then DeleteFile(FFileNameParam.Value + '_sign.p7s');
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then DeleteFile(FFileNameParam.Value + '_stamp.p7s');

    // Подпись файла 1
    if Result and (HeaderDataSet.FieldByName('UserSign').asString <> '') then
    begin
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSign').asString);
      if FileExists(FFileNameParam.Value + '.p7s') then
        RenameFile(FFileNameParam.Value + '.p7s', FFileNameParam.Value + '_sign.p7s');
    end;

    // Подпись файла 2
    if Result and (HeaderDataSet.FieldByName('UserSeal').asString <> '') then
    begin
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSeal').asString);
      if FileExists(FFileNameParam.Value + '.p7s') then
        RenameFile(FFileNameParam.Value + '.p7s', FFileNameParam.Value + '_stamp.p7s');
    end;

    // Отправка подписанных файлов eTTN
    if Result then Result := POSTSignVchasnoEDI;

    // Запишем в базу чей ключ и дату
    EDI.UpdateOrderDELNOTSignVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger
                                      , HeaderDataSet.FieldByName('MovementId_EDI_send').asInteger
                                      , not Result
                                        );

  finally
    // удалим временные файлы
    if FileExists(FFileNameParam.Value) then DeleteFile(FFileNameParam.Value);
    if FileExists(FFileNameParam.Value + '.p7s') then DeleteFile(FFileNameParam.Value + '.p7s');
    if FileExists(FFileNameParam.Value + '_sign.p7s') then DeleteFile(FFileNameParam.Value + '_sign.p7s');
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then DeleteFile(FFileNameParam.Value + '_stamp.p7s');
  end;

end;

function TdsdVchasnoEDIAction.DoSendSignComDoc: Boolean;
  var cXML : String;
begin
  Result := DelnotSave;
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

function TdsdVchasnoEDIAction.DoSignCondra: Boolean;
begin
  Result := False;

  if HeaderDataSet.FieldByName('DocId_vch_Condra').AsString = '' then Exit;
//  if HeaderDataSet.FieldByName('VchasnoId').AsString = '' then Exit;

  FOrderParam.Value := HeaderDataSet.FieldByName('DealId').AsString;
  //Это ІД Condra
  FDocumentIdParam.Value := HeaderDataSet.FieldByName('DocId_vch_Condra').AsString;
  //
  FVchasnoIdParam.Value := HeaderDataSet.FieldByName('VchasnoId').AsString;
  try

    // Получим файл документа
    Result := GetVchasnoEDI(5);
    //Result := GetDocETTN('4823036500001', '32d2bc90-577e-4e4c-af17-722b49cf1c86');

    if FileExists(FFileNameParam.Value + '.p7s') then DeleteFile(FFileNameParam.Value + '.p7s');
    if FileExists(FFileNameParam.Value + '_sign.p7s') then DeleteFile(FFileNameParam.Value + '_sign.p7s');
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then DeleteFile(FFileNameParam.Value + '_stamp.p7s');

    // Подпись файла 1
    if Result and (HeaderDataSet.FieldByName('UserSign').asString <> '') then
    begin
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSign').asString);
      if FileExists(FFileNameParam.Value + '.p7s') then
        RenameFile(FFileNameParam.Value + '.p7s', FFileNameParam.Value + '_sign.p7s');
    end;

    // Подпись файла 2
    if Result and (HeaderDataSet.FieldByName('UserSeal').asString <> '') then
    begin
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSeal').asString);
      if FileExists(FFileNameParam.Value + '.p7s') then
        RenameFile(FFileNameParam.Value + '.p7s', FFileNameParam.Value + '_stamp.p7s');
    end;

    // Отправка подписанных файлов
    if Result then Result := POSTSignVchasnoEDI;

    // Запишем в базу чей ключ и дату
    EDI.UpdateDesadvCondraSignVchasnoEDI(HeaderDataSet.FieldByName('EDIId').asInteger
                                       , HeaderDataSet.FieldByName('MovementId_EDI_send').asInteger
                                       , not Result
                                        );

  finally
    // удалим временные файлы
    if FileExists(FFileNameParam.Value) then DeleteFile(FFileNameParam.Value);
    if FileExists(FFileNameParam.Value + '.p7s') then DeleteFile(FFileNameParam.Value + '.p7s');
    if FileExists(FFileNameParam.Value + '_sign.p7s') then DeleteFile(FFileNameParam.Value + '_sign.p7s');
    if FileExists(FFileNameParam.Value + '_stamp.p7s') then DeleteFile(FFileNameParam.Value + '_stamp.p7s');
  end;

end;


function TdsdVchasnoEDIAction.DoSendCondra: Boolean;
begin
  Result := False;
  //Это ІД Desadv
  if HeaderDataSet.FieldByName('DocId_vch').AsString = '' then Exit;

  FFileNameParam.Value := HeaderDataSet.FieldByName('FileName').AsString;
  FMetadataParam.Value := HeaderDataSet.FieldByName('Metadata').AsString;
  //
  FMetadata_sender_glnParam.Value := HeaderDataSet.FieldByName('sender_gln').AsString;
  FMetadata_recipient_glnParam.Value := HeaderDataSet.FieldByName('recipient_gln').AsString;
  FMetadata_buyer_glnParam.Value := HeaderDataSet.FieldByName('buyer_gln').AsString;
  FMetadata_numberParam.Value := HeaderDataSet.FieldByName('number').AsString;
  FMetadata_document_function_codeParam.Value := HeaderDataSet.FieldByName('document_function_code').AsString;
  FMetadata_fileParam.Value := HeaderDataSet.FieldByName('FileName_pdf').AsString;
  FMetadata_doc_to_attach_idParam.Value := HeaderDataSet.FieldByName('doc_to_attach_id').AsString;
  FMetadata_doc_to_attach_numberParam.Value := HeaderDataSet.FieldByName('doc_to_attach_number').AsString;
  //
  try

    // Отправляем файл документа
    Result := POSTCondraEDI(0);

    // Запишем в базу что сделали
    try
      EDI.FInsertVchasnoEventsDoc.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('MovementId_edi').asInteger;
      EDI.FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := 0;
      // ІД Condra
      EDI.FInsertVchasnoEventsDoc.ParamByName('inDocumentId').Value :=FDocumentIdParam.Value;
      //
      EDI.FInsertVchasnoEventsDoc.ParamByName('inVchasnoId').Value :='';
      // ІД Desadv
      EDI.FInsertVchasnoEventsDoc.ParamByName('inId_doc').Value :=HeaderDataSet.FieldByName('DocId_vch').AsString;
      //
      if not Result = TRUE
      then EDI.FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Ошибка Отправки Вчасно Декларация'
      else EDI.FInsertVchasnoEventsDoc.ParamByName('inEDIEvent').Value := 'Отправка Вчасно Декларация';
      EDI.FInsertVchasnoEventsDoc.Execute;
    finally
      EDI.FInsertVchasnoEventsDoc.ParamByName('inMovementId_send').Value := 0;
      EDI.FInsertVchasnoEventsDoc.ParamByName('inId_doc').Value := '';
    end;

  finally
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
    ediComDoc : Result := ComDoc007Load;
    ediOrdrsp : Result := OrdrspSave;
    ediDesadv : Result := DESADVSave;
    ediComDocSave : Result := ComDocSave;
    ediDelnotSave : Result := DelnotSave;


    ediComDocSign : Result := DoSignComDoc;
    ediComDocSendSign : Result := DoSendSignComDoc;

    ediSendCondra : Result := DoSendCondra;
    ediSignCondra : Result := DoSignCondra;

  else raise Exception.Create('Не описано метод обработки типа документов.');
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
       ShowError('Не заполнено:' +
                 IfThen(HeaderDataSet.FieldByName('GLN_car').asString = '', ' GLN для Перевізника;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_from').asString = '', ' GLN для Замовника;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_to').asString = '', ' GLN для Вантажоодержувача;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_Unit').asString = '', ' GLN для Пункт навантаження;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_Unloading').asString = '', ' GLN для Пункта розвантаження;', '') +
                 IfThen(HeaderDataSet.FieldByName('GLN_Driver').asString = '', ' GLN для Водія;', '') +
                 IfThen(HeaderDataSet.FieldByName('KATOTTG_Unit').asString = '', ' КАТОТТГ Пункта навантаження;', '') {+
                 IfThen(HeaderDataSet.FieldByName('KATOTTG_Unloading').asString = '', ' КАТОТТГ Пункта розвантаження;', '')});

    // Создать XML
    UAECMR := UAECMRXML.NewUAECMR;
    // ***** Початок змісту документа
    UAECMR.ECMR.ExchangedDocumentContext.SpecifiedTransactionID := '0';
    UAECMR.ECMR.ExchangedDocumentContext.BusinessProcessSpecifiedDocumentContextParameter.ID := 'urn:ua:e-transport.gov.ua:ettn:01';
    UAECMR.ECMR.ExchangedDocumentContext.GuidelineSpecifiedDocumentContextParameter.ID := 'urn:ua:e-transport.gov.ua:ettn:01:generic:001';

    // ***** Реквізити ТТН
    // порядковий номер (серія) документа ТТН
    UAECMR.ECMR.ExchangedDocument.ID := HeaderDataSet.FieldByName('InvNumber').asString;
    // Дата і час складання документа (виписування ТТН)
    UAECMR.ECMR.ExchangedDocument.IssueDateTime.DateTime := gfFormatToDateTime (HeaderDataSet.FieldByName('OperDate').AsDateTime);
    // Додані записи
//    // CA - Перевізник
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_car').asString; // '9864232596110';
//      Content := 'CA';
//    end;
//    // OB - Замовник
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_from').asString; // '9864232596127';
//      Content := 'OB';
//    end;
//    // CZ - Вантажовідправник
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_from').asString; // '9864065749080'
//      Content := 'CZ';
//    end;
//    // CN - Вантажоодержувач
//    with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//    begin
//      ContentCode.ListAgencyID := 'GLN';
//      ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_to').asString; // '9864232596127';
//      Content := 'CN';
//    end;
//
//    // DR - Водій
//    if HeaderDataSet.FieldByName('GLN_Driver').asString <> '' then
//      with UAECMR.ECMR.ExchangedDocument.IncludedNote.Add do
//      begin
//        ContentCode.ListAgencyID := 'GLN';
//        ContentCode.NodeValue := HeaderDataSet.FieldByName('GLN_Driver').asString; // '9864232596745';
//        Content := 'DR';
//      end;

    // Місце складання документа
    UAECMR.ECMR.ExchangedDocument.IssueLogisticsLocation.Name := HeaderDataSet.FieldByName('PlaceOf').asString;
    UAECMR.ECMR.ExchangedDocument.IssueLogisticsLocation.Description := HeaderDataSet.FieldByName('PlaceOfDescription').asString;

    // ***** Інформація про перевезення
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.GrossWeightMeasure.UnitCode := 'KGM';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.GrossWeightMeasure.NodeValue := RoundTo(HeaderDataSet.FieldByName('Weight_all').AsCurrency, -1);
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.GrossWeightMeasure;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.AssociatedInvoiceAmount.CurrencyID := 'UAH';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.AssociatedInvoiceAmount.NodeValue := RoundTo(HeaderDataSet.FieldByName('TotalSumm').AsCurrency, -2);
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignmentItemQuantity := HeaderDataSet.FieldByName('TotalCountKg').AsFloat;

    // * Вантажовідправник
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.Id.SchemeAgencyID := 'ЄДРПОУ';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.Id.NodeValue := HeaderDataSet.FieldByName('OKPO_From').asString; // 32132132;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString; // 'ТОВ "Вантажовідправник_v3"';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.RoleCode := 'CZ';
      // Контакти відповідального представника
    if HeaderDataSet.FieldByName('ConsignorPersonINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsignorTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := 'РНОКПП';
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

    // * Вантажоодержувач
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.Id.SchemeAgencyID := 'ЄДРПОУ';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.Id.NodeValue := HeaderDataSet.FieldByName('OKPO_To').asString; // '32135483';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString; // 'ТОВ "Вантажоодержувач_v3" (прод)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.RoleCode := 'CN';
      // Контакти відповідального представника
    if HeaderDataSet.FieldByName('ConsigneePersonINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := 'РНОКПП';
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

    // * Перевізник
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.Id.SchemeAgencyID := 'ЄДРПОУ';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.Id.NodeValue := HeaderDataSet.FieldByName('OKPO_car').asString; // '32131212';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_car').asString; // 'ТОВ "Перевізник_v3" (прод)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.RoleCode := 'CA';
      // Контакти водія
    if HeaderDataSet.FieldByName('DriverINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := 'РНОКПП';
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

    // * Замовник
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.ID.SchemeAgencyID := 'ЄДРПОУ';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.ID.NodeValue := HeaderDataSet.FieldByName('OKPO_From').asString; // '32135483';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.Name := HeaderDataSet.FieldByName('JuridicalName_From').asString; // 'ТОВ "Вантажоодержувач_v3" (прод)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.RoleCode := 'OB';
      // Контакти відповідального представника
    if HeaderDataSet.FieldByName('NotifiedPersonINN').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedTaxRegistration.ID.SchemeAgencyID := 'РНОКПП';
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
      // * Ідентифікаційний код відповідальної особи
    //UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedGovernmentRegistration.ID := 'XYZ000012';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedGovernmentRegistration.ID := HeaderDataSet.FieldByName('GLN_from').asString;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.NotifiedTradeParty.SpecifiedGovernmentRegistration.TypeCode := 'TRADEPARTY_GLN';

    // Пункт навантаження
    if HeaderDataSet.FieldByName('KATOTTG_Unit').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.CarrierAcceptanceLogisticsLocation.ID.SchemeAgencyID := 'КАТОТТГ';
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

    // Пункт розвантаження
    if HeaderDataSet.FieldByName('KATOTTG_Unloading').asString <> '' then
    begin
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.ID.SchemeAgencyID := 'КАТОТТГ';
      UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.ID.NodeValue := HeaderDataSet.FieldByName('KATOTTG_Unloading').asString;
    end;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.Name := HeaderDataSet.FieldByName('JuridicalName_To').asString; // 'ТОВ "Вантажоодержувач_v3" (прод)';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.TypeCode := 10;
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.Description := HeaderDataSet.FieldByName('PartnerAddress_Unloading').asString; // 'Україна, 12351, Сумська обл,  Сумський р-н, м. Суми, вул. Київська, 1';
    //UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.LatitudeMeasure := '50.4489298';
    //UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.LatitudeMeasure := '30.5194162';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.SystemID.SchemeAgencyID := 'GLN';
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.ConsigneeReceiptLogisticsLocation.PhysicalGeographicalCoordinate.SystemID.NodeValue := HeaderDataSet.FieldByName('GLN_Unloading').asString; // 9864232596127;

    // Розвантажувальні роботи
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.DeliveryTransportEvent.Description := 'Розвантаження';
      // Контакти Роль учасника (Вантажоодержувач - CN)
    if HeaderDataSet.FieldByName('DeliveryCN_PersonName').asString <> '' then
    begin
      with UAECMR.ECMR.SpecifiedSupplyChainConsignment.DeliveryTransportEvent.CertifyingTradeParty.Add do
      begin
        Name := 'Комірник';
        RoleCode := 'CN';
        if HeaderDataSet.FieldByName('DeliveryCN_PersonINN').asString <> '' then
        begin
          SpecifiedTaxRegistration.ID.SchemeAgencyID := 'РНОКПП';
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

    // Навантажувальні роботи
    UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.Description := 'Навантаження';
    if HeaderDataSet.FieldByName('PickUpCZ_PersonName').asString <> '' then
    begin
      with UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.Add do
      begin
        Name := 'Комірник';
        RoleCode := 'CZ';
        if HeaderDataSet.FieldByName('PickUpCZ_PersonINN').asString <> '' then
        begin
          SpecifiedTaxRegistration.ID.SchemeAgencyID := 'РНОКПП';
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

  //  UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.Name := 'Водій';
  //  UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.RoleCode := 'DR';
  //  UAECMR.ECMR.SpecifiedSupplyChainConsignment.PickUpTransportEvent.CertifyingTradeParty.DefinedTradeContact.PersonName := 'Гуменний Володимир Антонович'; //HeaderDataSet.FieldByName('PersonalDriverName').asString;

    // Відомості про вантаж
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
        //GlobalID.SchemeAgencyID := 'УКТЗЕД';
        //GlobalID.NodeValue := 500;
        NatureIdentificationTransportCargo.Identification := ListDataSet.FieldByName('goodsname').AsString;
        //ApplicableTransportDangerousGoods.UNDGIdentificationCode := 0;
        //ApplicableTransportDangerousGoods.PackagingDangerLevelCode := 1;
        //AssociatedReferencedLogisticsTransportEquipment.ID := '123456789-123';
        //TransportLogisticsPackage.ItemQuantity := 100;
        //TransportLogisticsPackage.TypeCode := 'SA';
        //TransportLogisticsPackage.Type_ := 'кг';
        //TransportLogisticsPackage.PhysicalLogisticsShippingMarks.Marking := 'Упаковано в мішки';
        //TransportLogisticsPackage.PhysicalLogisticsShippingMarks.BarcodeLogisticsLabel.ID := 'Упаковано в мішки';
      end;
      ListDataSet.Next;
    end;

    // Автомобіль
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
    // Автомобіль (прицеп)
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

    // Вид перевезень
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
      ShowError('Ошибка Не найден файл библиотеки подписи: ' + EUDLLName);
    end;
  end;

{$IFDEF WIN64}

  SignFile := ExtractFilePath(ParamStr(0)) + 'SignFile.exe';

  if not FileExists(SignFile) then
  begin
    ShowError('Ошибка Не найдена программа шифрования: ' + SignFile);
  end;

  // 1.Установка ключей
  if ExtractFilePath(UserSign) <> ''
  then FileKeyName := AnsiString(UserSign)
  else FileKeyName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

  // проверка
  if not FileExists(String(FileKeyName)) then ShowError('Файл не найден : <'+String(FileKeyName)+'>');

  FKeyFileNameParam.Value := ExtractFileName(String(FileKeyName));

  FileName := AnsiString(ExtractFilePath(ParamStr(0)) + FResultParam.Value);
  // проверка
  if not FileExists(String(FileName)) then ShowError('Файл tTTN не найден : <'+String(FileName)+'>');

  CmdLine := '"' + SignFile + '" "' + apath + '" "' + FileKeyName + '" "24447183" "' + FileName + '"';

  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
  end;

  // Запускаем процесс подписи
  // Ожидаем завершения приложения
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
    ShowError('Ошибка Не найдена результат работы программы шифрования: ' + FileName);
  end;

  f := TiniFile.Create(FileName);

  try
    try
      if F.ReadString('SignResult', 'Ошибка', '') = '' then
      begin
        FKeyUserNameParam.Value := F.ReadString('SignResult', 'UserName', '');
        Result := True;
      end else ShowError('Ошибка ' + F.ReadString('SignResult', 'Ошибка', ''));;
    Except
    end;
  finally
    f.Free;
  end;
  DeleteFile(FileName);

{$ELSE}

  if not EULoadDLL(apath) then
  begin
    ShowError('Ошибка Не загружена библиотеки подписи: ' + EUDLLName);
  end;
  CPInterface := EUGetInterface();
  if CPInterface = nil then
  begin
    EUUnloadDLL();
    ShowError('Ошибка Не загружена библиотеки подписи: ' + EUDLLName);
  end;
  CPInterface.SetUIMode(false);
  EUInitializeOwnUI(CPInterface, true);
  try

    nError := CPInterface.Initialize();
    if nError <> EU_ERROR_NONE then
    begin
      ShowError('Ошибка Инициализации библиотеки подписи: ' + EUDLLName);
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
        ShowError('Ошибка В библиотеке подписи: ' + E.Message);
      end;
    end;

    try
      // 1.Установка ключей
      if ExtractFilePath(UserSign) <> ''
      then FileName := AnsiString(UserSign)
      else FileName := AnsiString(ExtractFilePath(ParamStr(0)) + UserSign);

      // проверка
      if not FileExists(String(FileName)) then ShowError('Файл не найден : <'+String(FileName)+'>');

      FKeyFileNameParam.Value := ExtractFileName(String(FileName));

      nError := CPInterface.ReadPrivateKeyFile (PAnsiChar(FileName), PAnsiChar('24447183'), @CertOwnerInfo); // бухгалтер
      if nError <> EU_ERROR_NONE then
      begin
        ShowError('Ошибка В библиотеке при загрузке электронного ключа: ' + CPInterface.GetErrorDesc(nError));
      end;

      FKeyUserNameParam.Value := String(CertOwnerInfo.SubjectFullName);
    except
      on E: Exception do
      begin
        ShowError('Ошибка В библиотеке при загрузке электронного ключа:' + E.Message);
      end;
    end;

    try
      // 2.Неарспедственно подпись
      FileName := AnsiString(ExtractFilePath(ParamStr(0)) + FResultParam.Value);
      // проверка
      if not FileExists(String(FileName)) then ShowError('Файл tTTN не найден : <'+String(FileName)+'>');

      nError := CPInterface.SignFile(PAnsiChar(FileName), PAnsiChar(FileName + '.p7s'), True);
      if nError <> EU_ERROR_NONE then
      begin
        ShowError('Ошибка В библиотеке при надожении подписи: ' + CPInterface.GetErrorDesc(nError));
      end;
    except
      on E: Exception do
      begin
        ShowError('Ошибка В библиотеке при надожении подписи:' + E.Message);
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
    ShowError('Не заполнены Host, логин или пароль.');
    Exit;
  end;

  // Непосредственно отправка

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
                  ShowError('Ошибка получения токена: ' + e.ErrorMessage);
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
    ShowError('Не получен токе. Отправка еЕЕТ невозможна.');
    Exit;
  end;

  // Непосредственно отправка

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
                  ShowError('Ошибка отправки ТТН: ' + e.ErrorMessage);
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
    ShowError('Не получен токе. Загрузка файла еЕЕТ невозможна.');
    Exit;
  end;

  // Непосредственно загрузка файла для подписи

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
                  ShowError('Ошибка получение файла ТТН: ' + e.ErrorMessage);
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
    ShowError('Не получен токе. Загрузка файла еЕЕТ невозможна.');
    Exit;
  end;

  // Непосредственно загрузка файла для подписи

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
                ShowError('Ошибка поиска КАТОТТГ места выгрузки: ' + e.ErrorMessage);
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
          FErrorParam.Value := 'Ошибка поиска КАТОТТГ места выгрузки: Не знполнено в данных базы EDI';
          if Assigned(FUpdateError) then FUpdateError.Execute;
          Result := True;
        end;
      end else ShowError('Ошибка поиска КАТОТТГ места выгрузки: Количество запмсей по gln места выгрузки более одной.');
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
    ShowError('Не получен токе. Подпись еЕЕТ невозможна.');
    Exit;
  end;

  // Непосредственно загрузка файла для подписи

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
    else ShowError('Не описана роль пдписи eTTN.');
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
                  ShowError('Ошибка: ' + e.ErrorMessage);
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

function TdsdEDINAction.LoadInvoiceNRСontent(AUUID : String; var AjsonItem: TJSONObject): Boolean;
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
                  ShowError('Ошибка получение накладных на повернення": ' + e.ErrorMessage);
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
                  ShowError('Ошибка получение накладных на повернення": ' + e.ErrorMessage);
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
      jsonItem, jsonСontent : TJSONObject;
      Offset, Count, CountDuble, i: Integer;

begin
  Result := False;

  if FTokenParam.Value = '' then
  begin
    ShowError('Не получен токе. Загрузка накладных на повернення невозможна.');
    Exit;
  end;

  if not Assigned(FUpdateUuid) then
  begin
    ShowError('Не указана процедура загрузки.');
    Exit;
  end;

  // Непосредственно загрузка файла для подписи

  Offset := 0;
  Count := 10;
  CountDuble := 0;
  while (CountDuble < 10) and LoadInvoiceNRHeader(Offset, Count, JsonArray) and (jsonArray.Size > 0) do
  begin
    for i := 0 to jsonArray.Size - 1 do
    begin
      jsonItem := TJSONObject(jsonArray.Get(i));

      if LoadInvoiceNRСontent(jsonItem.Get('doc_uuid').JsonValue.Value, jsonСontent) then
      begin

        UpdateUuid.ParamByName('inDoc_UUID').Value := jsonItem.Get('doc_uuid').JsonValue.Value;
        UpdateUuid.ParamByName('indocNumber').Value := jsonItem.Get('docNumber').JsonValue.Value;
        UpdateUuid.ParamByName('indocDate').Value := DateOf(IncHour(UnixToDateTime(TJSONNumber(jsonItem.Get('docDate').JsonValue).AsInt64), 10));
        UpdateUuid.ParamByName('inJuridicalName').Value := TJSONObject(TJSONObject(jsonСontent.Get('InvoiceParties').JsonValue).Get('Buyer').JsonValue).Get('Name').JsonValue.Value;
        UpdateUuid.ParamByName('inGLNSender').Value := jsonItem.Get('uuidSender').JsonValue.Value;
        UpdateUuid.ParamByName('inGLNReceiver').Value := jsonItem.Get('uuidReceiver').JsonValue.Value;
        UpdateUuid.ParamByName('inDelivery_place_GLN').Value := TJSONObject(jsonItem.Get('extraFields').JsonValue).Get('delivery_place_uuid').JsonValue.Value;
        UpdateUuid.ParamByName('inDeliveryNoteNumber').Value := TJSONObject(TJSONObject(jsonСontent.Get('InvoiceReference').JsonValue).Get('DeliveryNote').JsonValue).Get('DeliveryNoteNumber').JsonValue.Value;
        UpdateUuid.ParamByName('inContractNumber').Value := TJSONObject(jsonСontent.Get('InvoiceHeader').JsonValue).Get('ContractNumber').JsonValue.Value;
        UpdateUuid.ParamByName('inInvoiceLines').Value := TJSONObject(jsonСontent.Get('InvoiceLines').JsonValue).Get('Line').JsonValue.ToString;
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

  // Пробуем найти КАТОТТГ
  if (HeaderDataSet.FieldByName('KATOTTG_Unloading').asString = '') and
     Assigned(FUpdateKATOTTG) then
  begin
    if HeaderDataSet.FieldByName('GLN_Unloading').asString = '' then
    begin
      ShowError('Не определен GLN для Пункта розвантаження.');
      Exit;
    end;
    if not GetIdentifiers(HeaderDataSet.FieldByName('GLN_From').asString, HeaderDataSet.FieldByName('GLN_Unloading').asString) then Exit;
  end;

  // Сформируем XML
  UAECMREDI(cXML);

  // Отправим eTTN
  Result := SendETTN(HeaderDataSet.FieldByName('GLN_from').asString, HeaderDataSet.FieldByName('UuId').AsString, cXML);

  // Запишем в базу Uuid
  if Result and ((FResultParam.Value <> HeaderDataSet.FieldByName('UuId').AsString)) and
     Assigned(FUpdateUuid) then FUpdateUuid.Execute;

end;


function TdsdEDINAction.DoSignDcuETTN: Boolean;
  var GLN_Sign : String;
begin
  Result := False;

  if (HeaderDataSet.FieldByName('UuId').asString = '') then
     ShowError('ТТН не отправлена. Подпись невозиожна.');

    case FEDINActions of
      edinSignConsignor, edinSendSingETTN : GLN_Sign := HeaderDataSet.FieldByName('GLN_from').asString;
      edinSignCarrier  : GLN_Sign := HeaderDataSet.FieldByName('GLN_car').asString;
    else ShowError('Не описана роль пдписи eTTN.');
    end;

  if GLN_Sign = '' then ShowError('Не заполнено GLN подписанта.');

  if not GetToken then Exit;

  try

    // Получим файл eTTN
    Result := GetDocETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    //Result := GetDocETTN('4823036500001', '32d2bc90-577e-4e4c-af17-722b49cf1c86');

    // Подпись файла 1
    if Result and (HeaderDataSet.FieldByName('UserSign').asString <> '') then
    begin
      if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s') then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s');
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSign').asString);

      // Отправка подписанного файла eTTN
      if Result then Result := SignDcuETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    end;

    // Подпись файла 2
    if Result and (HeaderDataSet.FieldByName('UserSeal').asString <> '') then
    begin
      if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s') then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s');
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserSeal').asString);

      // Отправка подписанного файла eTTN
      if Result then Result := SignDcuETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    end;

    // Подпись файла 3
    if Result and (HeaderDataSet.FieldByName('UserKey').asString <> '') then
    begin
      if FileExists(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s') then DeleteFile(ExtractFilePath(ParamStr(0)) + FResultParam.Value + '.p7s');
      if Result then Result := SignData(HeaderDataSet.FieldByName('UserKey').asString);

      // Отправка подписанного файла eTTN
      if Result then Result := SignDcuETTN(GLN_Sign, HeaderDataSet.FieldByName('UuId').AsString);
    end;

    // Запишем в базу чей ключ и дату
    if Result and Assigned(FUpdateSign) then FUpdateSign.Execute;

  finally
    // удалим временные файлы
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

  // Загрузим DOCUMENTINVOICE_NP
  Result := LoadInvoiceNR;

end;

function TdsdEDINAction.LocalExecute: Boolean;
begin

  case FEDINActions of
    edinSendETTN : Result := DoSendETTN;
    edinSignConsignor, edinSignCarrier  : Result := DoSignDcuETTN;
    edinSendSingETTN : Result := DoSendSingETTN;

    edinLoadInvoiceNR : Result := DoLoadInvoiceNR;

  else ShowError('Не описано метод обработки типа документов.');
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
