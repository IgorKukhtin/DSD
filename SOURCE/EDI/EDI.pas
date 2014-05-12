unit EDI;

interface

uses Classes, DB, dsdAction, IdFTP, dsdDb;

type

  // Компонент работы с EDI. Пока все засунем в него
  // Ну не совсем все, конечно, но много
  TEDI = class(TComponent)
  private
    FIdFTP: TIdFTP;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADV(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure ComdocLoad(spHeader, spList: TdsdStoredProc);
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
    FDirectory: string;
    FPassword: string;
    FHost: string;
    FUser: string;
    FspHeader: TdsdStoredProc;
    FspList: TdsdStoredProc;
  published
    property Host: string read FHost write FHost;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
    property Directory: string read FDirectory write FDirectory;
    property spHeader: TdsdStoredProc read FspHeader write FspHeader;
    property spList: TdsdStoredProc read FspList write FspList;
  end;

  procedure Register;

implementation

uses VCL.ActnList, DBClient, DesadvXML, SysUtils, Dialogs, ComDocXML, SimpleGauge;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIActionDesadv], TEDIActionDesadv);
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
                  FIdFTP.Get(List[i], Stream);
                  FileData := Utf8ToAnsi(Stream.DataString);
                  // Начало документа <?xml
                  FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                  FileData := copy(FileData, 1, pos('</ЕлектроннийДокумент>', FileData) + 21);
                  ЕлектроннийДокумент := LoadЕлектроннийДокумент(FileData);
                  if ЕлектроннийДокумент.Заголовок.КодТипуДокументу = '004' then begin
                 //    ShowMessage(FileData);
                     break;
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
     //  FIdFTP.
       //FIdFTP.Put(Stream, 'testDECLAR.xml');
    end;
    FIdFTP.Quit;


  // Парсим их в XML
  // загружаем в базенку
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

end.
