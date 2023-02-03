unit EDI;

{$I ..\dsdVer.inc}

interface

uses DBClient, Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb, OrderXML, UtilConst
     {$IFDEF DELPHI103RIO}, Actions {$ENDIF};

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar, ediComDocSave,
    ediReceipt, ediReturnComDoc, ediDeclarReturn, ediOrdrsp, ediInvoice, ediError,
    ediRecadv);
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
  TEDI = class(TComponent)
  private
    FIdFTP: TIdFTP;
    FConnectionParams: TConnectionParams;
    FInsertEDIEvents: TdsdStoredProc;
    FExistsOrder: TdsdStoredProc;
    FUpdateDeclarAmount: TdsdStoredProc;
    FInsertEDIFile: TdsdStoredProc;
    FUpdateEDIErrorState: TdsdStoredProc;
    FUpdateDeclarFileName: TdsdStoredProc;
    FGetSaveFilePath: TdsdStoredProc;
    ComSigner: OleVariant;
    FSendToFTP: boolean;
    FDirectory: string;
    FDirectoryError: string;
    FisEDISaveLocal: boolean;
    procedure InsertUpdateOrder(ORDER: OrderXML.IXMLORDERType;
      spHeader, spList: TdsdStoredProc; lFileName : String);
    function fIsExistsOrder(lFileName : String) : Boolean;
    function InsertUpdateComDoc(ЕлектроннийДокумент
      : IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc): integer;
    procedure FTPSetConnection;
    procedure InitializeComSigner(DebugMode: boolean; UserSign, UserSeal, UserKey : string);
    procedure SignFile(FileName: string; SignType: TSignType; DebugMode: boolean; UserSign, UserSeal, UserKey, NameExite, NameFiscal : string );

    procedure PutFileToFTP(FileName: string; Directory: string);
    procedure PutStreamToFTP(Stream: TStream; FileName: string;
      Directory: string);
    procedure SetDirectory(const Value: string);
    function ConvertEDIDate(ADateTime: string): TDateTime;
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
  FormStorage, UnilWin, OrdrspXML, StrUtils, StatusXML, RecadvXML
  , DesadvFozzXML, OrderSpFozzXML, IftminFozzXML
  , DOCUMENTINVOICE_TN_XML, DOCUMENTINVOICE_PRN_XML
  , Vcl.Forms
  ;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIAction], TEDIAction);
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
  ЕлектроннийДокумент: IXMLЕлектроннийДокументType;
  i: integer;
  XMLFileName, P7SFileName: string;
begin
  // создать xml файл
  ЕлектроннийДокумент := NewЕлектроннийДокумент;
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

  FInsertEDIEvents := TdsdStoredProc.Create(nil);
  FInsertEDIEvents.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FInsertEDIEvents.Params.AddParam('inEDIEvent', ftString, ptInput, '');
  FInsertEDIEvents.StoredProcName := 'gpInsert_Movement_EDIEvents';
  FInsertEDIEvents.OutputType := otResult;

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
  ЕлектроннийДокумент: IXMLЕлектроннийДокументType;
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
                FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                FileData := copy(FileData, 1, pos('</ЕлектроннийДокумент>',
                  FileData) + 21);
                try
                MovementId:= 0;
                ЕлектроннийДокумент := LoadЕлектроннийДокумент(FileData);
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
                    FIdFTP.Delete(List[i]);
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
            DESADV_fozz.ORDRSPDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate').asDateTime);
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
  if (HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE)
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


  end
  else begin
            // Создать XML
            DESADV := DesadvXML.NewDESADV;
            //
            DESADV.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
            DESADV.Date := FormatDateTime('yyyy-mm-dd',
              HeaderDataSet.FieldByName('OperDate').asDateTime);
            DESADV.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
              HeaderDataSet.FieldByName('OperDate').asDateTime);
            DESADV.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
            DESADV.ORDERDATE := FormatDateTime('yyyy-mm-dd',
              HeaderDataSet.FieldByName('OperDate').asDateTime);
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
                  ORDEREDQUANTITY :=
                    StringReplace(FormatFloat('0.000',
                    ItemsDataSet.FieldByName('AmountOrder').AsFloat),
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
  //
  Stream := TMemoryStream.Create;
  try
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
         else DESADV     .OwnerDocument.SaveToFile(FileName);
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
          'Документ DOCUMENTINVOICE_TN отправлен на FTP'
      else
        FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
          'Документ DESADV отправлен на FTP';
      FInsertEDIEvents.Execute;
    end;
  finally
    Stream.Free;
    //
    if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
    then DeleteFile(FileName);
  end;
  //
  //
  // Send XML - fozzy - Price
  if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = TRUE
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
      if isMetro = TRUE
      then ParamByName('inGLNCode').Value := BUYERPARTNUMBER //PRODUCTIDBUYER
      else ParamByName('inGLNCode').Value := PRODUCTIDBUYER;
      try ParamByName('inAmountOrder').Value := gfStrToFloat(ORDEREDQUANTITY); except ParamByName('inAmountOrder').Value := 0; end;
      try ParamByName('inPriceOrder').Value := gfStrToFloat(ORDERPRICE); except ParamByName('inPriceOrder').Value := 0; end;
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
  Stream: TStream;
  i: integer;
  FileName: string;
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

procedure TEDI.IFTMINSave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  IFTMIN_fozz: IftminFozzXML.IXMLIFTMINType;
  Stream: TStream;
  i: integer;
  FileName: string;
  lNumber: string;
begin
  //
  if HeaderDataSet.FieldByName('isSchema_fozz').asBoolean = FALSE
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
  : IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc): integer;
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
  Param: IXMLПараметрType;
begin
  with spHeader, ЕлектроннийДокумент do
  begin
    ParamByName('inOrderInvNumber').Value := Заголовок.НомерЗамовлення;
    ParamByName('inComDocDate').Value := ConvertEDIDate(Заголовок.ДатаДокументу);
    if Заголовок.ДатаЗамовлення <> '' then
      ParamByName('inOrderOperDate').Value :=
        ConvertEDIDate(Заголовок.ДатаЗамовлення)
    else
      ParamByName('inOrderOperDate').Value :=
        ConvertEDIDate(Заголовок.ДатаДокументу);
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
begin
  try
    FTPSetConnection;
    // загружаем файлы с FTP
    FIdFTP.Connect;
    if FIdFTP.Connected then
    begin
      FIdFTP.ChangeDir(Directory);
      List := TStringList.Create;
      Stream := TStringStream.Create;
      try
        err_msg:= '';
        ii:=0;
        //
        FIdFTP.List(List, '', false);
        if List.Count = 0 then
          exit;
        with TGaugeFactory.GetGauge('Загрузка данных', 0, List.Count) do
          try
            Start;
            for i := 0 to List.Count - 1 do
            begin
              s:= List[i];
              //if (copy(s, 1, 5) = 'order') then showMessage(s);
              // если первые буквы файла order а последние .xml
              if ((copy(List[i], 1, 5) = 'order') and (copy(List[i], Length(List[i]) - 3, 4) = '.xml'))
               or((AnsiUpperCase(copy(List[i], 1, 11)) = AnsiUpperCase('inbox\order')) and (copy(List[i], Length(List[i]) - 3, 4) = '.xml'))
              then
                if fIsExistsOrder(List[i]) = true then
                   if err_msg = '' then err_msg:= '--- ignore file <'+ List[i]+')'
                   else
                else
                begin
                  DocData := gfStrFormatToDate(copy(List[i], 7, 8), 'yyyymmdd');
                  if (StartDate <= DocData) and (DocData <= EndDate) then
                  begin
                    // тянем файл к нам
                    Stream.Clear;
                    if not FIdFTP.Connected then
                      FIdFTP.Connect;
                    FIdFTP.ChangeDir(Directory);
                    FIdFTP.Get(List[i], Stream);
                    ORDER := OrderXML.LoadORDER(Utf8ToAnsi(Stream.DataString));
                    // загружаем в базенку
//  gc_isDebugMode:= TRUE;
//  gc_isShowTimeMode:= TRUE;
                    InsertUpdateOrder(ORDER, spHeader, spList, List[i]);
                    //
                    //Пытаемся найти параметр
                    if Assigned(spHeader.Params.ParamByName('gIsDelete'))
                    then fIsDelete:= spHeader.ParamByName('gIsDelete').Value
                    else fIsDelete:= false;
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
                  end;
                end;
              //
              IncProgress;
            end;
          finally
            Finish;
          end;
      finally
        FIdFTP.Disconnect;
        List.Free;
        Stream.Free;
        //
        if (err_msg <> '') then raise Exception.Create (err_msg);
      end;
    end;
  except
    on E: Exception do begin
        if (err_msg <> '')
        then raise Exception.Create (err_msg)
        else raise Exception.Create(E.Message);
    end;
  end;
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
          ORDRSP_fozz.Date := FormatDateTime('yyyy-mm-dd',HeaderDataSet.FieldByName('OperDate').asDateTime);
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

initialization
  Classes.RegisterClass(TEDI);
  Classes.RegisterClass(TEDIAction);

end.

{ FIdFTP.Username := 'uatovalanftp'; FIdFTP.Password := 'ftp349067';
  FIdFTP.Host := 'ruftpex.edi.su'; '/archive' }
