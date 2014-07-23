unit EDI;

interface

uses Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb, OrderXML;

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar, ediComDocSave);
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
    procedure InsertUpdateOrder(ORDER: IXMLORDERType; spHeader, spList: TdsdStoredProc);
    procedure InsertUpdateComDoc(ЕлектроннийДокумент: IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc);
    procedure FTPSetConnection;
    procedure SignFile(FileName: string; SignType: TSignType);
    procedure PutFileToFTP(FileName: string; Directory: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet; Directory: String);
    procedure DeclarSave(HeaderDataSet, ItemsDataSet: TDataSet; Directory: String);
    procedure ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String; StartDate, EndDate: TDateTime);
    procedure OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String; StartDate, EndDate: TDateTime);
  published
    property ConnectionParams: TConnectionParams read FConnectionParams write FConnectionParams;
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

uses Windows, VCL.ActnList, DBClient, DesadvXML, SysUtils, Dialogs, SimpleGauge, Variants,
UtilConvert, ComObj, DeclarXML, DateUtils;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIAction], TEDIAction);
end;

{ TEDI }
function PAD0(Src: string; Lg: Integer): string;
begin
  Result := Src;
  while Length(Result) < Lg do
    Result := '0' + Result;
end;

procedure TEDI.COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet; Directory: String);
var
  ЕлектроннийДокумент: IXMLЕлектроннийДокументType;
  i: integer;
  XMLFileName, P7SFileName: string;
begin
  // создать xml файл
  ЕлектроннийДокумент := NewЕлектроннийДокумент;
  ЕлектроннийДокумент.Заголовок.НомерДокументу := HeaderDataSet.FieldByName('InvNumber').asString;
  ЕлектроннийДокумент.Заголовок.ТипДокументу := 'Видаткова накладна';
  ЕлектроннийДокумент.Заголовок.КодТипуДокументу := '006';
  ЕлектроннийДокумент.Заголовок.ДатаДокументу := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate').asDateTime);
  ЕлектроннийДокумент.Заголовок.НомерЗамовлення := HeaderDataSet.FieldByName('InvNumberOrder').asString;

  with ЕлектроннийДокумент.Сторони.Add do begin
       СтатусКонтрагента := 'Продавець';
       ВидОсоби := 'Юридична';
       НазваКонтрагента :=  HeaderDataSet.FieldByName('JuridicalName_From').asString;
       КодКонтрагента :=    HeaderDataSet.FieldByName('OKPO_From').asString;
       ІПН :=               HeaderDataSet.FieldByName('INN_From').asString;
       GLN :=               HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  end;
  with ЕлектроннийДокумент.Сторони.Add do begin
       СтатусКонтрагента := 'Покупець';
       ВидОсоби := 'Юридична';
       НазваКонтрагента :=  HeaderDataSet.FieldByName('JuridicalName_To').asString;
       КодКонтрагента :=    HeaderDataSet.FieldByName('OKPO_To').asString;
       ІПН :=               HeaderDataSet.FieldByName('INN_To').asString;
       GLN :=               HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with ЕлектроннийДокумент.Таблиця.Add do begin
         ІД := i;
         НомПоз := i;
         АртикулПокупця := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
         Найменування := ItemsDataSet.FieldByName('GoodsName').asString;
         ПрийнятаКількість := gfFloatToStr(ItemsDataSet.FieldByName('AmountPartner').AsFloat);
         Ціна := gfFloatToStr(ItemsDataSet.FieldByName('PriceWVAT').AsFloat);
         inc(i);
    end;
    ItemsDataSet.Next;
  end;

  // сохранить на диск
  XMLFileName := ExtractFilePath(ParamStr(0)) + 'comdoc_' + FormatDateTime('yyyymmddhhnnss', Date + Time ) + '_' + HeaderDataSet.FieldByName('InvNumber').asString + '_006.xml';
  ЕлектроннийДокумент.OwnerDocument.SaveToFile(XMLFileName);
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // подписать
    SignFile(XMLFileName, stComDoc);
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then begin
       FInsertEDIEvents.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
       FInsertEDIEvents.ParamByName('inEDIEvent').Value   := 'Документ сформирован и подписан';
       FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then begin
       FInsertEDIEvents.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
       FInsertEDIEvents.ParamByName('inEDIEvent').Value   := 'Документ отправлен на FTP';
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
  FConnectionParams := TConnectionParams.Create;
  FIdFTP := TIdFTP.Create(nil);
  FInsertEDIEvents := TdsdStoredProc.Create(nil);
  FInsertEDIEvents.Params.AddParam('inMovementId', ftInteger, ptInput, 0);
  FInsertEDIEvents.Params.AddParam('inEDIEvent', ftString, ptInput, '');
  FInsertEDIEvents.StoredProcName := 'gpInsert_Movement_EDIEvents';
  FInsertEDIEvents.OutputType := otResult;
end;

procedure TEDI.ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String; StartDate, EndDate: TDateTime);
var List: TStrings;
    i: integer;
    Stream: TStringStream;
    FileData: string;
    ЕлектроннийДокумент: IXMLЕлектроннийДокументType;
begin
    FTPSetConnection;
    // загружаем файлы с FTP
    FIdFTP.Connect;
    if FIdFTP.Connected then begin
       FIdFTP.ChangeDir(Directory);
       try
         List := TStringList.Create;
         Stream := TStringStream.Create;
         FIdFTP.List(List, '' ,false);
         with TGaugeFactory.GetGauge('Загрузка данных', 1, List.Count) do
         try
           Start;
           for I := 0 to List.Count - 1 do begin
               // если первые буквы файла comdoc, а последние .p7s
               if (copy(list[i], 1, 6) = 'comdoc') and (copy(list[i], length(list[i]) - 3, 4) = '.p7s') then begin
                  if (StartDate <= gfStrFormatToDate(copy(list[i], 8, 8), 'yyyymmdd'))
                    and (gfStrFormatToDate(copy(list[i], 8, 8), 'yyyymmdd') <= EndDate)  then begin
                  // тянем файл к нам
                    Stream.Clear;
                    FIdFTP.Get(List[i], Stream);
                    FileData := Utf8ToAnsi(Stream.DataString);
                    // Начало документа <?xml
                    FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                    FileData := copy(FileData, 1, pos('</ЕлектроннийДокумент>', FileData) + 21);
                    ЕлектроннийДокумент := LoadЕлектроннийДокумент(FileData);
                    if (ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '007')
                      or(ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '004') then begin
                         // загружаем в базенку
                         InsertUpdateComDoc(ЕлектроннийДокумент, spHeader, spList);
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

procedure TEDI.DeclarSave(HeaderDataSet, ItemsDataSet: TDataSet;
  Directory: String);
const
  C_DOC = 'J12';
  C_DOC_SUB = '010';
  C_DOC_VER = '5';
  C_DOC_TYPE = '0';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName: string;
begin
  // создать xml файл
  DECLAR := NewDECLAR;
  DECLAR.DECLARHEAD.TIN := HeaderDataSet.FieldByName('OKPO_From').asString;
  DECLAR.DECLARHEAD.C_DOC := C_DOC;
  DECLAR.DECLARHEAD.C_DOC_SUB := C_DOC_SUB;
  DECLAR.DECLARHEAD.C_DOC_VER := C_DOC_VER;
  DECLAR.DECLARHEAD.C_DOC_TYPE := C_DOC_TYPE;
  DECLAR.DECLARHEAD.C_DOC_CNT :=  copy(HeaderDataSet.FieldByName('InvNumber').asString, 1, 7);
  DECLAR.DECLARHEAD.C_REG := C_REG;
  DECLAR.DECLARHEAD.C_RAJ := C_RAJ;
  DECLAR.DECLARHEAD.PERIOD_MONTH := FormatDateTime('mm', HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.PERIOD_TYPE := PERIOD_TYPE;
  DECLAR.DECLARHEAD.PERIOD_YEAR := FormatDateTime('yyyy', HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.C_STI_ORIG := C_REG + C_RAJ;
  DECLAR.DECLARHEAD.C_DOC_STAN := C_DOC_STAN;
  DECLAR.DECLARHEAD.D_FILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName('BuyerGLNCode').asString + ';SU:' + HeaderDataSet.FieldByName('SupplierGLNCode').asString;

  DECLAR.DECLARBODY.HORIG := '1';
  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.HNUM := HeaderDataSet.FieldByName('InvNumber').asString;
  DECLAR.DECLARBODY.HNAMESEL := HeaderDataSet.FieldByName('JuridicalName_From').asString;
  DECLAR.DECLARBODY.HNAMEBUY := HeaderDataSet.FieldByName('JuridicalName_To').asString;
  DECLAR.DECLARBODY.HKSEL := HeaderDataSet.FieldByName('OKPO_From').asString;
  DECLAR.DECLARBODY.HKBUY := HeaderDataSet.FieldByName('OKPO_To').asString;
  DECLAR.DECLARBODY.HLOCSEL := HeaderDataSet.FieldByName('JuridicalAddress_From').asString;
  DECLAR.DECLARBODY.HLOCBUY := HeaderDataSet.FieldByName('JuridicalAddress_To').asString;
  DECLAR.DECLARBODY.HTELSEL := HeaderDataSet.FieldByName('Phone_From').asString;
  DECLAR.DECLARBODY.HTELBUY := HeaderDataSet.FieldByName('Phone_To').asString;

  DECLAR.DECLARBODY.H01G1S := 'Договір;COMDOC:' + HeaderDataSet.FieldByName('InvNumberPartnerEDI').asString + ';DATE:' + HeaderDataSet.FieldByName('OperDatePartnerEDI').asString;
  DECLAR.DECLARBODY.H01G2D := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  DECLAR.DECLARBODY.H01G3S := HeaderDataSet.FieldByName('ContractName').AsString;
  DECLAR.DECLARBODY.H02G1S := 'Оплата з поточного рахунка';

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with DECLAR.DECLARBODY.RXXXXG2D.Add do begin
         ROWNUM := IntToStr(i);
         NodeValue := FormatDateTime('ddmmyyyy', HeaderDataSet.FieldByName('OperDate').asDateTime);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with DECLAR.DECLARBODY.RXXXXG3S.Add do begin
         ROWNUM := IntToStr(i);
         NodeValue := ItemsDataSet.FieldByName('GoodsName').AsString + ';GTIN:' +
         ItemsDataSet.FieldByName('BarCodeGLN_Juridical').AsString + ';IDBY:' + ItemsDataSet.FieldByName('ArticleGLN_Juridical').AsString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with DECLAR.DECLARBODY.RXXXXG4S.Add do begin
         ROWNUM := IntToStr(i);
         NodeValue := ItemsDataSet.FieldByName('MeasureName').AsString;
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do begin
         ROWNUM := IntToStr(i);
         NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('Amount').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with DECLAR.DECLARBODY.RXXXXG6.Add do begin
         ROWNUM := IntToStr(i);
         NodeValue := gfFloatToStr(ItemsDataSet.FieldByName('PriceNoVAT').AsFloat);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with DECLAR.DECLARBODY.RXXXXG7.Add do begin
         ROWNUM := IntToStr(i);
         NodeValue := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat), DecimalSeparator, cMainDecimalSeparator, []);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;

  DECLAR.DECLARBODY.R01G7 := gfFloatToStr(HeaderDataSet.FieldByName('TotalSummMVAT').AsFloat);
  DECLAR.DECLARBODY.R01G11 := DECLAR.DECLARBODY.R01G7;
  DECLAR.DECLARBODY.R03G7 := gfFloatToStr(HeaderDataSet.FieldByName('SummVAT').AsFloat);
  DECLAR.DECLARBODY.R03G11 := DECLAR.DECLARBODY.R03G7;
  DECLAR.DECLARBODY.R04G7 := StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT').AsFloat), DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R04G11 := DECLAR.DECLARBODY.R04G7;
  DECLAR.DECLARBODY.H10G1S := 'Неграш';

  // сохранить на диск
  XMLFileName := ExtractFilePath(ParamStr(0)) + C_REG + C_RAJ + '0024447183' +
      C_DOC + C_DOC_SUB + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
      PAD0(copy(HeaderDataSet.FieldByName('InvNumber').asString, 1, 7),7) + '1' +
      FormatDateTime('mmyyyy', HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.xml';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // подписать
    SignFile(XMLFileName, stDeclar);
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then begin
       FInsertEDIEvents.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
       FInsertEDIEvents.ParamByName('inEDIEvent').Value   := 'Налоговая сформирована и подписана';
       FInsertEDIEvents.Execute;
    end;
    // перекинуть на FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then begin
       FInsertEDIEvents.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
       FInsertEDIEvents.ParamByName('inEDIEvent').Value   := 'Налоговая отправлена на FTP';
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
  DESADV.DATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate').asDateTime);
  DESADV.DELIVERYDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate').asDateTime);
  DESADV.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  DESADV.ORDERDATE := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate').asDateTime - 1);
  DESADV.DELIVERYNOTENUMBER := HeaderDataSet.FieldByName('InvNumber').asString;

  DESADV.HEAD.SUPPLIER := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
  DESADV.HEAD.BUYER := HeaderDataSet.FieldByName('BuyerGLNCode').asString;
  DESADV.HEAD.DELIVERYPLACE := HeaderDataSet.FieldByName('DELIVERYPLACEGLNCode').asString;
  DESADV.HEAD.SENDER := DESADV.HEAD.SUPPLIER;
  DESADV.HEAD.RECIPIENT := DESADV.HEAD.BUYER;

  DESADV.HEAD.PACKINGSEQUENCE.HIERARCHICALID := '1';

  with ItemsDataSet do begin
     First;
     i := 1;
     while not EOF do begin
         with DESADV.HEAD.PACKINGSEQUENCE.POSITION.Add do begin
           POSITIONNUMBER := i;
           PRODUCT := ItemsDataSet.FieldByName('BarCodeGLN_Juridical').AsString;
           PRODUCTIDSUPPLIER := ItemsDataSet.FieldByName('Id').AsString;
           PRODUCTIDBUYER := ItemsDataSet.FieldByName('ArticleGLN_Juridical').AsString;
           DELIVEREDQUANTITY := FormatFloat('0.00', ItemsDataSet.FieldByName('Amount').asFloat);
           DELIVEREDUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').AsString;
           ORDEREDQUANTITY := DELIVEREDQUANTITY;
           COUNTRYORIGIN := 'UA';
           PRICE := FormatFloat('0.00', ItemsDataSet.FieldByName('Price').asFloat);
         end;
         inc(i);
         Next;
     end;
     Close;
     Free;
  end;

  Stream := TMemoryStream.Create;
  // Переслать его по ftp
  try
    DESADV.OwnerDocument.SaveToStream(Stream);
    FTPSetConnection;
    FIdFTP.Connect;
    if FIdFTP.Connected then begin
       FIdFTP.ChangeDir('/error');
       FIdFTP.Put(Stream, 'testDECLAR.xml');
    end;
    FIdFTP.Quit;
  finally
    Stream.Free;
  end;
end;

destructor TEDI.Destroy;
begin
  FreeAndNil(FIdFTP);
  FreeAndNil(FConnectionParams);
  FreeAndNil(FInsertEDIEvents);
  inherited;
end;

procedure TEDI.FTPSetConnection;
begin
  FIdFTP.Username := ConnectionParams.User.AsString;
  FIdFTP.Password := ConnectionParams.Password.AsString;
  FIdFTP.Host := ConnectionParams.Host.AsString;
end;

procedure TEDI.InsertUpdateOrder(ORDER: IXMLORDERType; spHeader,
  spList: TdsdStoredProc);
var MovementId, GoodsPropertyId: Integer;
    i: integer;
begin
  with spHeader, ORDER do begin
    ParamByName('inOrderInvNumber').Value := NUMBER;
    ParamByName('inOrderOperDate').Value  := VarToDateTime(DATE);

    ParamByName('inGLNPlace').Value := HEAD.DELIVERYPLACE;
    ParamByName('inGLN').Value := HEAD.BUYER;

    Execute;
    MovementId := ParamByName('MovementId').Value;
    GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
  end;
  for I := 0 to ORDER.HEAD.POSITION.Count - 1 do
     with spList, ORDER.HEAD.POSITION[i] do begin
         ParamByName('inMovementId').Value := MovementId;
         ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
         ParamByName('inGoodsName').Value := CHARACTERISTIC.DESCRIPTION;
         ParamByName('inGLNCode').Value := PRODUCTIDBUYER;
         ParamByName('inAmountOrder').Value := gfStrToFloat(ORDEREDQUANTITY);
         Execute;
     end;
end;

procedure TEDI.InsertUpdateComDoc(
  ЕлектроннийДокумент: IXMLЕлектроннийДокументType;
  spHeader, spList: TdsdStoredProc);
var MovementId, GoodsPropertyId: Integer;
    i: integer;
begin
  with spHeader, ЕлектроннийДокумент do begin
    ParamByName('inOrderInvNumber').Value := Заголовок.НомерЗамовлення;
    if Заголовок.ДатаЗамовлення <> '' then
       ParamByName('inOrderOperDate').Value  := VarToDateTime(Заголовок.ДатаЗамовлення)
    else
       ParamByName('inOrderOperDate').Value  := VarToDateTime(Заголовок.ДатаДокументу);
    ParamByName('inSaleInvNumber').Value  := Заголовок.НомерДокументу;
    ParamByName('inSaleOperDate').Value   := VarToDateTime(Заголовок.ДатаДокументу);

    for i:= 0 to Сторони.Count - 1 do
        if Сторони.Контрагент[i].СтатусКонтрагента = 'Покупець' then begin
           ParamByName('inOKPO').Value := Сторони.Контрагент[i].КодКонтрагента;
           ParamByName('inJuridicalName').Value := Сторони.Контрагент[i].НазваКонтрагента;
        end;
     Execute;
     MovementId := ParamByName('MovementId').Value;
     GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
  end;
  with spList, ЕлектроннийДокумент.Таблиця do
       for I := 0 to GetCount - 1 do begin
           with Рядок[i] do begin
             ParamByName('inMovementId').Value := MovementId;
             ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
             ParamByName('inGoodsName').Value := Найменування;
             ParamByName('inGLNCode').Value := АртикулПокупця;
             ParamByName('inAmountPartner').Value := gfStrToFloat(ПрийнятаКількість);
             ParamByName('inSummPartner').Value := gfStrToFloat(ВсьогоПоРядку.СумаБезПДВ);
//             ParamByName('inPricePartner').Value := ParamByName('inSummPartner').Value / ParamByName('inAmountPartner').Value;
             ParamByName('inPricePartner').Value := gfStrToFloat(БазоваЦіна);
             Execute;
           end;
       end;
end;

function lpStrToDateTime(DateTimeString: string): TDateTime;
begin
  result := VarToDateTime(DateTimeString)
end;

procedure TEDI.OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String; StartDate, EndDate: TDateTime);
var List: TStrings;
    i: integer;
    Stream: TStringStream;
    FileData: string;
    ORDER: IXMLORDERType;
begin
    FTPSetConnection;
    // загружаем файлы с FTP
    FIdFTP.Connect;
    if FIdFTP.Connected then begin
       FIdFTP.ChangeDir(Directory);
       try
         List := TStringList.Create;
         Stream := TStringStream.Create;
         FIdFTP.List(List, '' ,false);
         if List.Count = 0 then
            exit;
         with TGaugeFactory.GetGauge('Загрузка данных', 0, List.Count) do
         try
           Start;
           for I := 0 to List.Count - 1 do begin
             // если первые буквы файла order а последние .xml
             if (copy(list[i], 1, 5) = 'order') and (copy(list[i], length(list[i]) - 3, 4) = '.xml') then begin
                if (StartDate <= gfStrFormatToDate(copy(list[i], 7, 8), 'yyyymmdd'))
                    and (gfStrFormatToDate(copy(list[i], 7, 8), 'yyyymmdd') <= EndDate)  then begin
                  // тянем файл к нам
                  Stream.Clear;
                  FIdFTP.Get(List[i], Stream);
                  ORDER := LoadORDER(Utf8ToAnsi(Stream.DataString));
                   // загружаем в базенку
                  InsertUpdateOrder(ORDER, spHeader, spList);
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

procedure TEDI.PutFileToFTP(FileName, Directory: string);
begin
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
end;

procedure TEDI.SignFile(FileName: string; SignType: TSignType);
var
  ComSigner: OleVariant;
  privateKey: string;
  vbSignType: integer;
begin
  ComSigner := CreateOleObject('ComSigner.ComSigner');
  try
    privateKey :=  '<RSAKeyValue>'+
      '<Modulus>0vCnV3tJx2QhZl6KoCpyskW2Q4EB4lUspJVmvaqGIhWujFpaNESHmIKlbc47JCIFY+VtYenKJVPnfZN+xlw7QsfRiKX7AdOmUm+No+X2U3eDkq0+byeMvT9m1zo3MaX6yCWlicvpYDPO29iJn8RfGYmVIO0p54ERXdZg6GuD4Nc=</Modulus>'+
      '<Exponent>AQAB</Exponent>'     +
      '<P>77+YBsrKezqaqOaQV0LFfP+c9J+N2qzmOlm04MD4TzbXC9huCQjaywzqadcdfNWERtQT1Dc0iOhHpR4xLSVgmw==</P>  '     +
      '<Q>4T0kYYkrJIZdBwaewETHk52yHIIu2jr4WFEKiwCSYI++WcocVVoRKabx96v3NDmTzQUIhmH0xFOYJY+BzzbOdQ==</Q>  '     +
      '<DP>CkEEjI3R2TFpef3agJDvh2gbW28Tjx3D/wzlKpO2SxUKX4xTMHm7eeHEiOBVd4heTvU1H+d4jL56ifpfmhG2Lw==</DP>  '     +
      '<DQ>N7CyahtMO3+tSKtuXQOkhO8ctsfJZdPmy49eF/hQOOfRnMnIL6JRVAcfFKnEOXly/eIctX1K07AHkmHlKqLWcQ==</DQ>  '     +
      '<InverseQ>01ZjPqfM69PA0hsYb6/5O38XT7IITGQPt1hMkTpVjhlDc3r3isPV8mgoTY/iKmTWx66Exjn+IlT6qB/X1FwDsw==</InverseQ> '     +
      '<D>YN9/YpgusmDkS+CYNmU4JnIIeejZxilKps0sEWeqUSX28uMdsQpV4W8CbTK8i2QKaK25NbHKEal+Uvf1TUCXP8b7xE5+FIcSykHd/Ta+veQM1Ljxnuwylkbq3N4GvyYro7D1z3trt6AxlGgDu8QjRoBc2Ba9XXRtlAToiN4i8y0=</D>'+
      '</RSAKeyValue>';
    ComSigner.Initialize('ifin.ua', privateKey);
    try
      ComSigner.ResetPrivateKey;
      ComSigner.ResetCryptToCert;
      //Установка сетификатов
      ComSigner.SetCryptToCertCert(ExtractFilePath(ParamStr(0)) + 'Exite_Для Шифрования.cer');
//      ComSigner.SetCryptToCertCert(ExtractFilePath(ParamStr(0)) + 'Неграш О.В..cer');
//      ComSigner.SetCryptToCertCert(ExtractFilePath(ParamStr(0)) + 'Товариство з обмеженою відповідальністю АЛАН1.cer');
//      ComSigner.SetCryptToCertCert(ExtractFilePath(ParamStr(0)) + 'Товариство з обмеженою відповідальністю АЛАН.cer');

      // Установка ключей
      ComSigner.SetPrivateKey(ExtractFilePath(ParamStr(0)) + 'Ключ - Неграш О.В..ZS2', '24447183', 1); //бухгалтер
      // Установка ключей
      ComSigner.SetPrivateKey(ExtractFilePath(ParamStr(0)) + 'Ключ - для в_дтиску - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2', '24447183', 3); //Печать
      // Установка ключей
      ComSigner.SetPrivateKey(ExtractFilePath(ParamStr(0)) + 'Ключ - для шифрування - Товариство з обмеженою в_дпов_дальн_стю АЛАН.ZS2', '24447183', 4); //Шифр

      if SignType = stDeclar then
         vbSignType := 1;
      if SignType = stComdoc then
         vbSignType := 2;

      // Подписание и/или шифрование
      ComSigner.Process(FileName, vbSignType);

    finally
       ComSigner.Dispose;
    end;
  finally
    ComSigner := Unassigned
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
    ediOrder:  EDI.OrderLoad(spHeader, spList, Directory, StartDateParam.Value, EndDateParam.Value);
    ediComDoc: EDI.ComdocLoad(spHeader, spList, Directory, StartDateParam.Value, EndDateParam.Value);
    ediComDocSave: EDI.COMDOCSave(HeaderDataSet, ListDataSet, Directory);
    ediDeclar: EDI.DeclarSave(HeaderDataSet, ListDataSet, Directory);
//    ediDesadv,
  end;
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

  FIdFTP.Username := 'uatovalanftp';
  FIdFTP.Password := 'ftp349067';
  FIdFTP.Host := 'ruftpex.edi.su';
   '/archive'

