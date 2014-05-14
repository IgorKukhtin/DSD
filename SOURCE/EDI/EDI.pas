unit EDI;

interface

uses Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb;

type

  // Компонент работы с EDI. Пока все засунем в него
  // Ну не совсем все, конечно, но много
  TEDI = class(TComponent)
  private
    FIdFTP: TIdFTP;
    procedure InsertUpdateComDoc(ЕлектроннийДокумент: IXMLЕлектроннийДокументType; spHeader, spList: TdsdStoredProc);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADV(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure ComdocLoad(spHeader, spList: TdsdStoredProc);
  end;

  TConnectionParams = class(TPersistent)
  private
    FDirectory: string;
    FPassword: string;
    FHost: string;
    FUser: string;
  published
    property Host: string read FHost write FHost;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
    property Directory: string read FDirectory write FDirectory;
  end;

  TEDIActionDesadv = class(TdsdCustomAction)
  private
    FHeaderDataSet: TDataSet;
    FListDataSet: TDataSet;
  protected
    function LocalExecute: boolean; override;
  published
    property HeaderDataSet: TDataSet read FHeaderDataSet write FHeaderDataSet;
    property ListDataSet: TDataSet read FListDataSet write FListDataSet;
  end;

  TEDIActionComdocLoad = class(TdsdCustomAction)
  private
    FspHeader: TdsdStoredProc;
    FspList: TdsdStoredProc;
    FConnectionParams: TConnectionParams;
  protected
    function LocalExecute: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ConnectionParams: TConnectionParams read FConnectionParams write FConnectionParams;
    property spHeader: TdsdStoredProc read FspHeader write FspHeader;
    property spList: TdsdStoredProc read FspList write FspList;
  end;

  procedure Register;

implementation

uses VCL.ActnList, DBClient, DesadvXML, SysUtils, Dialogs, SimpleGauge, Variants;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIActionDesadv], TEDIActionDesadv);
  RegisterActions('EDI', [TEDIActionComdocLoad], TEDIActionComdocLoad);
end;

{ TEDI }

procedure TEDI.ComdocLoad(spHeader, spList: TdsdStoredProc);
var List: TStrings;
    i: integer;
    Stream: TStringStream;
    FileData: string;
    ЕлектроннийДокумент: IXMLЕлектроннийДокументType;
begin
    // загружаем файлы с FTP
    FIdFTP.Connect;
    if FIdFTP.Connected then begin
       FIdFTP.ChangeDir('/archive');
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
                  // тянем файл к нам
                  Stream.Clear;
                  FIdFTP.Get(List[i], Stream);
                  FileData := Utf8ToAnsi(Stream.DataString);
                  // Начало документа <?xml
                  FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                  FileData := copy(FileData, 1, pos('</ЕлектроннийДокумент>', FileData) + 21);
                  ЕлектроннийДокумент := LoadЕлектроннийДокумент(FileData);
                  if ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '004' then begin
                     // загружаем в базенку
                     InsertUpdateComDoc(ЕлектроннийДокумент, spHeader, spList);
                  end;
               end;
               IncProgress;
           end;
         finally
           Finish;
         end;
       finally
         List.Free;
         Stream.Free;
       end;
    end;
    FIdFTP.Quit;
end;

constructor TEDI.Create(AOwner: TComponent);
begin
  inherited;
  FIdFTP := TIdFTP.Create(nil);
  FIdFTP.Username := 'uatovalanftp';
  FIdFTP.Password := 'ftp349067';
  FIdFTP.Host := 'ruftpex.edi.su';
end;

procedure TEDI.DESADV(HeaderDataSet, ItemsDataSet: TDataSet);
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
  inherited;
end;

procedure TEDI.InsertUpdateComDoc(
  ЕлектроннийДокумент: IXMLЕлектроннийДокументType;
  spHeader, spList: TdsdStoredProc);
var MovementId: Integer;
    i: integer;
begin
  with spHeader, ЕлектроннийДокумент do begin
    ParamByName('outid').Value := 0;
    ParamByName('inOrderInvNumber').Value := Заголовок.НомерЗамовлення;
    if Заголовок.ДатаЗамовлення <> '' then
       ParamByName('inOrderOperDate').Value  := VarToDateTime(Заголовок.ДатаЗамовлення)
    else
       ParamByName('inOrderOperDate').Value  := VarToDateTime(Заголовок.ДатаДокументу);
    ParamByName('inSaleInvNumber').Value  := Заголовок.НомерДокументу;
    ParamByName('inSaleOperDate').Value   := VarToDateTime(Заголовок.ДатаДокументу);

    for i:= 0 to Сторони.Count - 1 do
        if Сторони.Контрагент[i].СтатусКонтрагента = 'Покупець' then begin
           ParamByName('inGLN').Value := Сторони.Контрагент[i].GLN;
           ParamByName('inOKPO').Value := Сторони.Контрагент[i].КодКонтрагента;
        end;
     Execute;
     MovementId := ParamByName('outid').Value;
  end;

end;

{ TEDIActionDesadv }

function TEDIActionDesadv.LocalExecute: boolean;
begin
  with TEDI.Create(Self) do
  try
    DESADV(Self.HeaderDataSet, Self.ListDataSet);
  finally
    Free;
  end;
end;

{ TEDIActionComdocLoad }

constructor TEDIActionComdocLoad.Create(AOwner: TComponent);
begin
  inherited;
  FConnectionParams := TConnectionParams.Create
end;

destructor TEDIActionComdocLoad.Destroy;
begin
  FreeAndNil(FConnectionParams);
  inherited;
end;

function TEDIActionComdocLoad.LocalExecute: boolean;
var
  EDI: TEDI;
begin
  EDI := TEDI.Create(nil);
  // создание документа
  try
     EDI.ComdocLoad(spHeader, spList);
     { запускаем процедуру выгрузки документа DESADV}
  finally
    EDI.Free;
  end;
end;

end.
