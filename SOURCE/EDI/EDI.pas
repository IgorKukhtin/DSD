unit EDI;

interface

uses Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb, OrderXML;

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar, ediComDocSave,
    ediReceipt, ediReturnComDoc, ediDeclarReturn, ediOrdrsp, ediInvoice, ediError);
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
    FUpdateDeclarAmount: TdsdStoredProc;
    FInsertEDIFile: TdsdStoredProc;
    FUpdateEDIErrorState: TdsdStoredProc;
    FUpdateDeclarFileName: TdsdStoredProc;
    ComSigner: OleVariant;
    FSendToFTP: boolean;
    FDirectory: string;
    procedure InsertUpdateOrder(ORDER: IXMLORDERType;
      spHeader, spList: TdsdStoredProc);
    function InsertUpdateComDoc(ЕлектроннийДокумент
      : IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc): integer;
    procedure FTPSetConnection;
    procedure InitializeComSigner;
    procedure SignFile(FileName: string; SignType: TSignType);
    procedure PutFileToFTP(FileName: string; Directory: string);
    procedure PutStreamToFTP(Stream: TStream; FileName: string;
      Directory: string);
    procedure SetDirectory(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure ORDRSPSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure INVOICESave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet;
      Directory: String);
    procedure ReceiptLoad(spProtocol: TdsdStoredProc; Directory: String);
    procedure DeclarSave(HeaderDataSet, ItemsDataSet: TDataSet; StoredProc: TdsdStoredProc;
      Directory: String);
    procedure DeclarReturnSave(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
      Directory: String);
    procedure ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String;
      StartDate, EndDate: TDateTime);
    procedure OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String;
      StartDate, EndDate: TDateTime);
    procedure ReturnSave(MovementDataSet: TDataSet;
      spFileInfo, spFileBlob: TdsdStoredProc; Directory: string);
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

implementation

uses Windows, VCL.ActnList, DBClient, DesadvXML, SysUtils, Dialogs, SimpleGauge,
  Variants, UtilConvert, ComObj, DeclarXML, InvoiceXML, DateUtils,
  FormStorage, UnilWin, OrdrspXML, StrUtils, StatusXML;

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
  Directory: String);
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
    GLN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
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
    // подписать
    SignFile(XMLFileName, stComDoc);
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        'Документ сформирован и подписан';
      FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
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
              (copy(List[i], Length(List[i]) - 3, 4) = '.p7s') then
            begin
              DocData := gfStrFormatToDate(copy(List[i], 8, 8), 'yyyymmdd');
              if (StartDate <= DocData) and (DocData <= EndDate) then
              begin
                // тянем файл к нам
                Stream.Clear;
                FIdFTP.Get(List[i], Stream);
                FileData := Utf8ToAnsi(Stream.DataString);
                // Начало документа <?xml
                FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                FileData := copy(FileData, 1, pos('</ЕлектроннийДокумент>',
                  FileData) + 21);
                ЕлектроннийДокумент := LoadЕлектроннийДокумент(FileData);
                if (ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '007') or
                  (ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '004') or
                  (ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '012') then
                begin
                  // загружаем в базенку
                  MovementId := InsertUpdateComDoc(ЕлектроннийДокумент,
                    spHeader, spList);
                  FInsertEDIFile.ParamByName('inMovementId').Value :=
                    MovementId;
                  FInsertEDIFile.ParamByName('inFileName').Value := List[i];
                  FInsertEDIFile.ParamByName('inFileText').Value :=
                    ConvertConvert(Stream.DataString);
                  FInsertEDIFile.Execute;
                end;
                // теперь перенесли файл в директроию Archive
                try
                  FIdFTP.ChangeDir('/archive');
                  FIdFTP.Put(Stream, List[i]);
                finally
                  FIdFTP.ChangeDir(Directory);
                  FIdFTP.Delete(List[i]);
                end;
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
  StoredProc: TdsdStoredProc; Directory: String);
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
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName
    ('SupplierGLNCode').asString + ';SU:' + HeaderDataSet.FieldByName
    ('BuyerGLNCode').asString;

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
        HeaderDataSet.FieldByName('AmountSumm').AsFloat), DecimalSeparator,
        cMainDecimalSeparator, []);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  DECLAR.DECLARBODY.R01G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummmvat').AsFloat),
    DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R02G9 := '-' + StringReplace
    (FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummvat').AsFloat),
    FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

  if C_DOC_VER <> '7' then
     DECLAR.DECLARBODY.H10G1D := FormatDateTime('ddmmyyyy',
        HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.H10G2S := 'Неграш';

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
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.xml';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;

  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // подписать
    SignFile(XMLFileName, stDeclar);
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
     StoredProc: TdsdStoredProc;  Directory: String);
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
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName
    ('BuyerGLNCode').asString + ';SU:' + HeaderDataSet.FieldByName
    ('SupplierGLNCode').asString;

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
  DECLAR.DECLARBODY.H10G1S := 'Неграш';

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
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.xml';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  if not SendToFTP then begin
     if Assigned(StoredProc) then
        StoredProc.Execute;
     exit;
  end;
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // подписать
    SignFile(XMLFileName, stDeclar);
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
  DESADV: IXMLDESADVType;
  Stream: TStream;
  i: integer;
begin
  DESADV := NewDESADV;
  // Создать XML
  DESADV.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  DESADV.Date := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DESADV.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DESADV.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  DESADV.ORDERDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime - 1);
  DESADV.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;

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
        PRODUCTIDBUYER := ItemsDataSet.FieldByName
          ('ArticleGLN_Juridical').asString;
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
        PRICE := FormatFloat('0.00', ItemsDataSet.FieldByName('Price').AsFloat);
      end;
      inc(i);
      Next;
    end;
  end;

  Stream := TMemoryStream.Create;
  try
    DESADV.OwnerDocument.SaveToStream(Stream);
    PutStreamToFTP(Stream, 'desadv_' + FormatDateTime('yyyymmddhhnn', Now) + '_'
      + DESADV.NUMBER + '.xml', '/outbox');
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
  end;
end;

destructor TEDI.Destroy;
var
  i: integer;
begin
  if not VarIsNull(ComSigner) then
    repeat
      i := IUnknown(ComSigner)._Release;
      if i < 0 then
      begin
        // ошибка;
        Break;
      end;
    until i = 0;
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
      FIdFTP.Quit;
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

procedure TEDI.InsertUpdateOrder(ORDER: IXMLORDERType;
  spHeader, spList: TdsdStoredProc);
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
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
  end;
  for i := 0 to ORDER.HEAD.POSITION.Count - 1 do
    with spList, ORDER.HEAD.POSITION[i] do
    begin
      ParamByName('inMovementId').Value := MovementId;
      ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
      ParamByName('inGoodsName').Value := CHARACTERISTIC.DESCRIPTION;
      ParamByName('inGLNCode').Value := PRODUCTIDBUYER;
      ParamByName('inAmountOrder').Value := gfStrToFloat(ORDEREDQUANTITY);
      Execute;
    end;
end;

procedure TEDI.INVOICESave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  INVOICE: IXMLINVOICEType;
  Stream: TStream;
  i: integer;
begin
  INVOICE := NewINVOICE;
  // Создать XML
  INVOICE.DOCUMENTNAME := '380';
  INVOICE.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  INVOICE.Date := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  INVOICE.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  INVOICE.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  INVOICE.ORDERDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime - 1);
  INVOICE.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  INVOICE.DELIVERYNOTEDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

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

  INVOICE.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode')
    .asString;
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
        INVOICEDQUANTITY :=
          StringReplace(FormatFloat('0.000',
          ItemsDataSet.FieldByName('AmountPartner').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
        UNITPRICE := StringReplace(FormatFloat('0.00',
          ItemsDataSet.FieldByName('PriceNoVAT').AsFloat),
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
  try
    PutStreamToFTP(Stream, 'invoice_' + FormatDateTime('yyyymmddhhnn', Now) +
      '_' + INVOICE.NUMBER + '.xml', '/outbox');
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

procedure TEDI.InitializeComSigner;
var
  privateKey: string;
  FileName: string;
begin
  ComSigner := CreateOleObject('ComSigner.ComSigner');
  privateKey := '<RSAKeyValue>' +
    '<Modulus>0vCnV3tJx2QhZl6KoCpyskW2Q4EB4lUspJVmvaqGIhWujFpaNESHmIKlbc47JCIFY+VtYenKJVPnfZN+xlw7QsfRiKX7AdOmUm+No+X2U3eDkq0+byeMvT9m1zo3MaX6yCWlicvpYDPO29iJn8RfGYmVIO0p54ERXdZg6GuD4Nc=</Modulus>'
    + '<Exponent>AQAB</Exponent>' +
    '<P>77+YBsrKezqaqOaQV0LFfP+c9J+N2qzmOlm04MD4TzbXC9huCQjaywzqadcdfNWERtQT1Dc0iOhHpR4xLSVgmw==</P>  '
    + '<Q>4T0kYYkrJIZdBwaewETHk52yHIIu2jr4WFEKiwCSYI++WcocVVoRKabx96v3NDmTzQUIhmH0xFOYJY+BzzbOdQ==</Q>  '
    + '<DP>CkEEjI3R2TFpef3agJDvh2gbW28Tjx3D/wzlKpO2SxUKX4xTMHm7eeHEiOBVd4heTvU1H+d4jL56ifpfmhG2Lw==</DP>  '
    + '<DQ>N7CyahtMO3+tSKtuXQOkhO8ctsfJZdPmy49eF/hQOOfRnMnIL6JRVAcfFKnEOXly/eIctX1K07AHkmHlKqLWcQ==</DQ>  '
    + '<InverseQ>01ZjPqfM69PA0hsYb6/5O38XT7IITGQPt1hMkTpVjhlDc3r3isPV8mgoTY/iKmTWx66Exjn+IlT6qB/X1FwDsw==</InverseQ> '
    + '<D>YN9/YpgusmDkS+CYNmU4JnIIeejZxilKps0sEWeqUSX28uMdsQpV4W8CbTK8i2QKaK25NbHKEal+Uvf1TUCXP8b7xE5+FIcSykHd/Ta+veQM1Ljxnuwylkbq3N4GvyYro7D1z3trt6AxlGgDu8QjRoBc2Ba9XXRtlAToiN4i8y0=</D>'
    + '</RSAKeyValue>';
  try
    ComSigner.Initialize('ifin.ua', privateKey);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('Ошибка библиотеки Exite. ComSigner.Initialize'#10#13 + E.Message);
    end;
  end;
  try
    ComSigner.ResetPrivateKey;
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('Ошибка библиотеки Exite. ComSigner.ResetPrivateKey'#10#13 +
        E.Message);
    end;
  end;
  try
    ComSigner.ResetCryptToCert;
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('Ошибка библиотеки Exite. ComSigner.ResetCryptToCert'#10#13 +
        E.Message);
    end;
  end;

  // Установка сетификатов
  try
    FileName := ExtractFilePath(ParamStr(0)) +
      'Товариство з обмеженою відповідальністю АЛАН.cer';
    ComSigner.SaveCert(FileName);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite. ComSigner.SaveCert ' +
        FileName + #10#13 + E.Message);
    end;
  end;

  // Установка сетификатов
  try
    FileName := ExtractFilePath(ParamStr(0)) +
      'Товариство з обмеженою відповідальністю АЛАН1.cer';
    ComSigner.SaveCert(FileName);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite. ComSigner.SaveCert ' +
        FileName + #10#13 + E.Message);
    end;
  end;

  // Установка сетификатов
  try
    FileName := ExtractFilePath(ParamStr(0)) + 'Неграш О.В..cer';
    ComSigner.SaveCert(FileName);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite. ComSigner.SaveCert ' +
        FileName + #10#13 + E.Message);
    end;
  end;

  // Установка сетификатов
  try
    FileName := ExtractFilePath(ParamStr(0)) + 'Exite_Для Шифрования.cer';
    ComSigner.SetCryptToCertCert(FileName);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('Ошибка библиотеки Exite. ComSigner.SetCryptToCertCert ' + FileName +
        #10#13 + E.Message);
    end;
  end;

  // Установка сетификатов
  try
    FileName := ExtractFilePath(ParamStr(0)) + '27399.cer';
    ComSigner.SetCryptToCertCert(FileName);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create
        ('Ошибка библиотеки Exite. ComSigner.SetCryptToCertCert ' + FileName +
        #10#13 + E.Message);
    end;
  end;

  try
    // Установка ключей
    FileName := ExtractFilePath(ParamStr(0)) + 'Ключ - Неграш О.В..ZS2';
    ComSigner.SetPrivateKey(FileName, '24447183', 1); // бухгалтер
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite. ComSigner.SetPrivateKey '
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // Установка ключей
    FileName := ExtractFilePath(ParamStr(0)) +
      'Ключ - для в_дтиску - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2';
    ComSigner.SetPrivateKey(FileName, '24447183', 3); // Печать
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite. ComSigner.SetPrivateKey '
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // Установка ключей
    FileName := ExtractFilePath(ParamStr(0)) +
      'Ключ - для шифрування - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2';
    ComSigner.SetPrivateKey(FileName, '24447183', 4); // Печать
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('Ошибка библиотеки Exite. ComSigner.SetPrivateKey '
        + FileName + #10#13 + E.Message);
    end;
  end;
end;

function TEDI.InsertUpdateComDoc(ЕлектроннийДокумент
  : IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc): integer;
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
begin
  with spHeader, ЕлектроннийДокумент do
  begin
    ParamByName('inOrderInvNumber').Value := Заголовок.НомерЗамовлення;
    if Заголовок.ДатаЗамовлення <> '' then
      ParamByName('inOrderOperDate').Value :=
        VarToDateTime(Заголовок.ДатаЗамовлення)
    else
      ParamByName('inOrderOperDate').Value :=
        VarToDateTime(Заголовок.ДатаДокументу);
    ParamByName('inPartnerInvNumber').Value := Заголовок.НомерДокументу;
    if Заголовок.КодТипуДокументу = '007' then begin
       if Заголовок.ДокПідстава.ДатаДокументу = '' then
          ParamByName('inPartnerOperDate').Value :=
            VarToDateTime(Заголовок.ДатаДокументу)
       else
          ParamByName('inPartnerOperDate').Value :=
            VarToDateTime(Заголовок.ДокПідстава.ДатаДокументу)
    end
    else
       ParamByName('inPartnerOperDate').Value :=
         VarToDateTime(Заголовок.ДатаДокументу);
    if Заголовок.КодТипуДокументу = '012' then
    begin
      ParamByName('inDesc').Value := 'Return';
      ParamByName('inInvNumberTax').Value :=
        Параметри.ParamByName('Номер податкової накладної').NodeValue;
      if not VarIsNull(Параметри.ParamByName('Дата податкової накладної')
        .NodeValue) then
        ParamByName('inOperDateTax').Value :=
          VarToDateTime(Параметри.ParamByName('Дата податкової накладної')
          .NodeValue);
      ParamByName('inInvNumberSaleLink').Value :=
        Заголовок.ДокПідстава.НомерДокументу;
      ParamByName('inOperDateSaleLink').Value :=
        VarToDateTime(Заголовок.ДокПідстава.ДатаДокументу);
    end
    else
      ParamByName('inDesc').Value := 'Sale';

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
        ParamByName('inGoodsName').Value := Найменування;
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

procedure TEDI.OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String;
  StartDate, EndDate: TDateTime);
var
  List: TStrings;
  i: integer;
  Stream: TStringStream;
  ORDER: IXMLORDERType;
  DocData: TDateTime;
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
        FIdFTP.List(List, '', false);
        if List.Count = 0 then
          exit;
        with TGaugeFactory.GetGauge('Загрузка данных', 0, List.Count) do
          try
            Start;
            for i := 0 to List.Count - 1 do
            begin
              // если первые буквы файла order а последние .xml
              if (copy(List[i], 1, 5) = 'order') and
                (copy(List[i], Length(List[i]) - 3, 4) = '.xml') then
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
                  ORDER := LoadORDER(Utf8ToAnsi(Stream.DataString));
                  // загружаем в базенку
                  InsertUpdateOrder(ORDER, spHeader, spList);
                  // теперь перенесли файл в директроию Archive
                  if DocData < Date then
                    try
                      FIdFTP.ChangeDir('/archive');
                      FIdFTP.Put(Stream, List[i]);
                    finally
                      FIdFTP.ChangeDir(Directory);
                      FIdFTP.Delete(List[i]);
                    end;
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
  except
    on E: Exception do
      raise E;
  end;
end;

procedure TEDI.ORDRSPSave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  ORDRSP: IXMLORDRSPType;
  Stream: TStream;
  i: integer;
begin

  ORDRSP := NewORDRSP;
  // Создать XML
  ORDRSP.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  ORDRSP.Date := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  ORDRSP.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  ORDRSP.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  ORDRSP.ORDERDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime - 1);

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
      end;
      inc(i);
      Next;
    end;
  end;

  Stream := TMemoryStream.Create;
  try
    ORDRSP.OwnerDocument.SaveToStream(Stream);
    PutStreamToFTP(Stream, 'ORDRSP_' + FormatDateTime('yyyymmddhhnn', Now) + '_'
      + ORDRSP.NUMBER + '.xml', '/outbox');
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
          FIdFTP.Quit;
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
      FIdFTP.Quit;
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

procedure TEDI.ReceiptLoad(spProtocol: TdsdStoredProc; Directory: String);
var
  List, Receipt: TStrings;
  i, j: integer;
  Stream: TStringStream;
  g, FileName: string;
  Status: IXMLStatusType;
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
              FIdFTP.Get(List[i], Stream);
              g := '';
              for j := 1 to Length(Stream.DataString) do
                if Stream.DataString[j] = #13 then
                begin
                  Receipt.Add(g);
                  g := '';
                end
                else if Stream.DataString[j] <> #10 then
                  g := g + Stream.DataString[j];
              if g <> '' then
                Receipt.Add(g);
              spProtocol.ParamByName('inisOk').Value := Receipt[4] = 'RESULT=0';
              spProtocol.ParamByName('inTaxNumber').Value :=
                StrToInt(copy(List[i], 26, 7));
              spProtocol.ParamByName('inEDIEvent').Value :=
                copy(Receipt[1], 9, MaxInt);
              spProtocol.ParamByName('inOperMonth').Value :=
                EncodeDate(StrToInt(copy(List[i], 36, 4)),
                StrToInt(copy(List[i], 34, 2)), 1);
              FileName := copy(Receipt[0], pos('FILENAME=', Receipt[0]) +
                9, MaxInt);
              spProtocol.ParamByName('inFileName').Value :=
                copy(FileName, 1, 23) + '__' + copy(FileName, 26, MaxInt);
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
      FIdFTP.Quit;
      List.Free;
      Receipt.Free;
      Stream.Free;
    end;
  end;
end;

procedure TEDI.ReturnSave(MovementDataSet: TDataSet;
  spFileInfo, spFileBlob: TdsdStoredProc; Directory: string);
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
    SignFile(FileName, stComDoc);
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      'Документ сформирован и подписан';
    FInsertEDIEvents.Execute;

    // перекинуть на FTP
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

procedure TEDI.SignFile(FileName: string; SignType: TSignType);
var
  vbSignType: integer;
  i: integer;
begin
  if VarIsNull(ComSigner) then
    InitializeComSigner;

  if SignType = stDeclar then
    vbSignType := 1;
  if SignType = stComDoc then
    vbSignType := 2;

  // Подписание и/или шифрование
  for i := 1 to 10 do
    try
      ComSigner.Process(FileName, vbSignType);
      Break;
    except
      on E: Exception do
      begin
        if i > 9 then
          raise Exception.Create
            ('Ошибка библиотеки Exite. ComSigner.Process'#10#13 + E.Message);
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
      EDI.COMDOCSave(HeaderDataSet, ListDataSet, Directory);
    ediDeclar:
      EDI.DeclarSave(HeaderDataSet, ListDataSet, spHeader, Directory);
    ediReceipt:
      EDI.ReceiptLoad(spHeader, Directory);
    ediReturnComDoc:
      EDI.ReturnSave(HeaderDataSet, spHeader, spList, Directory);
    ediDeclarReturn:
      EDI.DeclarReturnSave(HeaderDataSet, ListDataSet, spHeader, Directory);
    ediDesadv:
      EDI.DESADVSave(HeaderDataSet, ListDataSet);
    ediOrdrsp:
      EDI.ORDRSPSave(HeaderDataSet, ListDataSet);
    ediInvoice:
      EDI.INVOICESave(HeaderDataSet, ListDataSet);
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

end.

{ FIdFTP.Username := 'uatovalanftp'; FIdFTP.Password := 'ftp349067';
  FIdFTP.Host := 'ruftpex.edi.su'; '/archive' }
