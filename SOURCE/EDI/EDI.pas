unit EDI;

interface

uses Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb, OrderXML;

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar, ediComDocSave,
    ediReceipt, ediReturnComDoc, ediDeclarReturn);
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
  TEDI = class(TComponent)
  private
    FIdFTP: TIdFTP;
    FConnectionParams: TConnectionParams;
    FInsertEDIEvents: TdsdStoredProc;
    FUpdateDeclarAmount: TdsdStoredProc;
    FInsertEDIFile: TdsdStoredProc;
    ComSigner: OleVariant;
    procedure InsertUpdateOrder(ORDER: IXMLORDERType;
      spHeader, spList: TdsdStoredProc);
    function InsertUpdateComDoc(�������������������
      : IXML�������������������Type; spHeader, spList: TdsdStoredProc): integer;
    procedure FTPSetConnection;
    procedure InitializeComSigner;
    procedure SignFile(FileName: string; SignType: TSignType);
    procedure PutFileToFTP(FileName: string; Directory: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet;
      Directory: String);
    procedure ReceiptLoad(spProtocol: TdsdStoredProc; Directory: String);
    procedure DeclarSave(HeaderDataSet, ItemsDataSet: TDataSet;
      Directory: String);
    procedure DeclarReturnSave(HeaderDataSet, ItemsDataSet: TDataSet;
      Directory: String);
    procedure ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String;
      StartDate, EndDate: TDateTime);
    procedure OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String;
      StartDate, EndDate: TDateTime);
    procedure ReturnSave(MovementDataSet: TDataSet;
      spFileInfo, spFileBlob: TdsdStoredProc; Directory: string);
  published
    property ConnectionParams: TConnectionParams read FConnectionParams
      write FConnectionParams;
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

uses Windows, VCL.ActnList, DBClient, DesadvXML, SysUtils, Dialogs, SimpleGauge,
  Variants,
  UtilConvert, ComObj, DeclarXML, DateUtils, FormStorage, UnilWin;

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
    GLN := HeaderDataSet.FieldByName('SupplierGLNCode').asString;
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
    // ���������
    SignFile(XMLFileName, stComDoc);
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then
    begin
      FInsertEDIEvents.ParamByName('inMovementId').Value :=
        HeaderDataSet.FieldByName('EDIId').asInteger;
      FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
        '�������� ����������� � ��������';
      FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
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

constructor TEDI.Create(AOwner: TComponent);
begin
  inherited;
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

end;

procedure TEDI.ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String;
  StartDate, EndDate: TDateTime);
var
  List: TStrings;
  i, MovementId: integer;
  Stream: TStringStream;
  FileData: string;
  �������������������: IXML�������������������Type;
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
              (copy(List[i], Length(List[i]) - 3, 4) = '.p7s') then
            begin
              if (StartDate <= gfStrFormatToDate(copy(List[i], 8, 8),
                'yyyymmdd')) and
                (gfStrFormatToDate(copy(List[i], 8, 8), 'yyyymmdd') <= EndDate)
              then
              begin
                // ����� ���� � ���
                Stream.Clear;
                FIdFTP.Get(List[i], Stream);
                FileData := Utf8ToAnsi(Stream.DataString);
                // ������ ��������� <?xml
                FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                FileData := copy(FileData, 1, pos('</�������������������>',
                  FileData) + 21);
                ������������������� := Load�������������������(FileData);
                if (�������������������.���������.���������������� = '007') or
                  (�������������������.���������.���������������� = '004') or
                  (�������������������.���������.���������������� = '012') then
                begin
                  // ��������� � �������
                  MovementId := InsertUpdateComDoc(�������������������,
                    spHeader, spList);
                  FInsertEDIFile.ParamByName('inMovementId').Value :=
                      MovementId;
                  FInsertEDIFile.ParamByName('inFileName').Value := List[i];
                  FInsertEDIFile.ParamByName('inFileText').Value :=
                      ConvertConvert(Stream.DataString);
                  FInsertEDIFile.Execute;
                end;
                // ������ ��������� ���� � ���������� Archive
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
  Directory: String);
const
  C_DOC = 'J12';
  C_DOC_SUB = '012';
  C_DOC_VER = '5';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
begin
  // ������� xml ����
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);
  // ������� xml ����
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
    ('SupplierGLNCode').asString + ';SU:' + HeaderDataSet.FieldByName
    ('BuyerGLNCode').asString;

  DECLAR.DECLARBODY.HORIG := '1';
  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName
    ('InvNumberPartner').asString);
  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

  DECLAR.DECLARBODY.HPODFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate_Child').asDateTime);
  DECLAR.DECLARBODY.HPODNUM := trim(HeaderDataSet.FieldByName
    ('InvNumber_Child').asString);
  DECLAR.DECLARBODY.H01G1D := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('ContractSigningDate').asDateTime);
  DECLAR.DECLARBODY.H01G2S := HeaderDataSet.FieldByName('ContractName')
    .asString;
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

  DECLAR.DECLARBODY.H02G1S := '��������;COMDOC:' + HeaderDataSet.FieldByName
    ('InvNumberPartnerEDI').asString + ';DATE:' + FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDatePartnerEDI').asDateTime) + ';';

  DECLAR.DECLARBODY.H02G2D := DECLAR.DECLARBODY.H01G1D;
  DECLAR.DECLARBODY.H02G3S := DECLAR.DECLARBODY.H01G2S;

  DECLAR.DECLARBODY.H04G1D := DECLAR.DECLARBODY.HPODFILL;

  DECLAR.DECLARBODY.H03G1S := '������ � ��������� �������';

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

  i := 1;
  HeaderDataSet.First;
  while not HeaderDataSet.Eof do
  begin
    with DECLAR.DECLARBODY.RXXXXG5.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('Amount').AsFloat);
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
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('Price_for_PriceCor').AsFloat);
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
      NodeValue := gfFloatToStr(HeaderDataSet.FieldByName('Amount_for_PriceCor').AsFloat);
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
      NodeValue := StringReplace(FormatFloat('0.00',
        HeaderDataSet.FieldByName('AmountSumm').AsFloat), DecimalSeparator,
        cMainDecimalSeparator, []);
    end;
    inc(i);
    HeaderDataSet.Next;
  end;

  DECLAR.DECLARBODY.R01G9 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummmvat')
    .AsFloat), DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R02G9 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('totalsummvat')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

  DECLAR.DECLARBODY.H10G1D := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.H10G2S := '������';

  // ��������� �� ����
  XMLFileName := ExtractFilePath(ParamStr(0)) + C_REG + C_RAJ + PAD0(HeaderDataSet.FieldByName('OKPO_From').asString, 10) +
    C_DOC + C_DOC_SUB + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.xml';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // ���������
    SignFile(XMLFileName, stDeclar);
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

procedure TEDI.DeclarSave(HeaderDataSet, ItemsDataSet: TDataSet;
  Directory: String);
const
  C_DOC = 'J12';
  C_DOC_SUB = '010';
  C_DOC_VER = '5';
  C_DOC_CNT = '1';
  C_REG = '28';
  C_RAJ = '01';
  PERIOD_TYPE = '1';
  C_DOC_STAN = '1';
var
  DECLAR: IXMLDECLARType;
  i: integer;
  XMLFileName, P7SFileName, C_DOC_TYPE: string;
begin
  // ������� xml ����
  C_DOC_TYPE := IntToStr(HeaderDataSet.FieldByName('SendDeclarAmount')
    .asInteger);

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

  DECLAR.DECLARBODY.HORIG := '1';
  DECLAR.DECLARBODY.HFILL := FormatDateTime('ddmmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  DECLAR.DECLARBODY.HNUM := trim(HeaderDataSet.FieldByName
    ('InvNumberPartner').asString);
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
        ItemsDataSet.FieldByName('AmountSummNoVAT').AsFloat), FormatSettings.DecimalSeparator,
        cMainDecimalSeparator, []);
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
  DECLAR.DECLARBODY.H10G1S := '������';

  // ��������� �� ����
  XMLFileName := ExtractFilePath(ParamStr(0)) + C_REG + C_RAJ + PAD0(HeaderDataSet.FieldByName('OKPO_From').asString, 10) +
    C_DOC + C_DOC_SUB + '0' + C_DOC_VER + C_DOC_STAN + '0' + C_DOC_TYPE +
    PAD0(copy(trim(HeaderDataSet.FieldByName('InvNumberPartner').asString), 1,
    7), 7) + '1' + FormatDateTime('mmyyyy',
    HeaderDataSet.FieldByName('OperDate').asDateTime) + C_REG + C_RAJ + '.xml';
  DECLAR.OwnerDocument.SaveToFile(XMLFileName);
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // ���������
    SignFile(XMLFileName, stDeclar);
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
  DESADV: IXMLDESADVType;
  Stream: TStream;
  i: integer;
begin
  DESADV := NewDESADV;
  // ������� XML
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
  DESADV.HEAD.SENDER := DESADV.HEAD.SUPPLIER;
  DESADV.HEAD.RECIPIENT := DESADV.HEAD.BUYER;

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
        DELIVEREDQUANTITY := FormatFloat('0.00',
          ItemsDataSet.FieldByName('Amount').AsFloat);
        DELIVEREDUNIT := ItemsDataSet.FieldByName('DELIVEREDUNIT').asString;
        ORDEREDQUANTITY := DELIVEREDQUANTITY;
        COUNTRYORIGIN := 'UA';
        PRICE := FormatFloat('0.00', ItemsDataSet.FieldByName('Price').AsFloat);
      end;
      inc(i);
      Next;
    end;
    Close;
    Free;
  end;

  Stream := TMemoryStream.Create;
  // ��������� ��� �� ftp
  try
    DESADV.OwnerDocument.SaveToStream(Stream);
    FTPSetConnection;
    FIdFTP.Connect;
    if FIdFTP.Connected then
    begin
      FIdFTP.ChangeDir('/error');
      FIdFTP.Put(Stream, 'testDECLAR.xml');
    end;
    FIdFTP.Quit;
  finally
    Stream.Free;
  end;
end;

destructor TEDI.Destroy;
var i: integer;
begin
  if not VarIsNull(ComSigner) then
    repeat
      i := IUnknown(ComSigner)._Release;
      if i < 0 then
      begin
        // ������;
        Break;
      end;
    until i = 0;
  ComSigner := Null;

  FreeAndNil(FIdFTP);
  FreeAndNil(FConnectionParams);
  FreeAndNil(FInsertEDIEvents);
  FreeAndNil(FUpdateDeclarAmount);
  FreeAndNil(FInsertEDIFile);
  inherited;
end;

procedure TEDI.FTPSetConnection;
begin
  FIdFTP.Username := ConnectionParams.User.asString;
  FIdFTP.Password := ConnectionParams.Password.asString;
  FIdFTP.Host := ConnectionParams.Host.asString;
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
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.Initialize'#10#13 + E.Message);
    end;
  end;
  try
    ComSigner.ResetPrivateKey;
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.ResetPrivateKey'#10#13 + E.Message);
    end;
  end;
  try
    ComSigner.ResetCryptToCert;
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.ResetCryptToCert'#10#13 + E.Message);
    end;
  end;

   // ��������� �����������
  try
    FileName := ExtractFilePath(ParamStr(0)) + '���������� � ��������� ������������� ����.cer';
    ComSigner.SaveCert(FileName);
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.SaveCert ' + FileName + #10#13 + E.Message);
    end;
  end;

  // ��������� �����������
  try
    FileName := ExtractFilePath(ParamStr(0)) + '���������� � ��������� ������������� ����1.cer';
    ComSigner.SaveCert(FileName);
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.SaveCert ' + FileName + #10#13 + E.Message);
    end;
  end;

  // ��������� �����������
  try
    FileName := ExtractFilePath(ParamStr(0)) + '������ �.�..cer';
    ComSigner.SaveCert(FileName);
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.SaveCert ' + FileName + #10#13 + E.Message);
    end;
  end;

  // ��������� �����������
  try
    FileName := ExtractFilePath(ParamStr(0)) + 'Exite_��� ����������.cer';
    ComSigner.SetCryptToCertCert(FileName);
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.SetCryptToCertCert ' + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // ��������� ������
    FileName := ExtractFilePath(ParamStr(0)) + '���� - ������ �.�..ZS2';
    ComSigner.SetPrivateKey(FileName, '24447183', 1); // ���������
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.SetPrivateKey ' + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // ��������� ������
    FileName := ExtractFilePath(ParamStr(0)) +
      '���� - ��� �_������ - ���������� � ��������� �_����_�����_��� ����.ZS2';
    ComSigner.SetPrivateKey(FileName, '24447183', 3); // ������
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.SetPrivateKey ' + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // ��������� ������
    FileName := ExtractFilePath(ParamStr(0)) +
      '���� - ��� ���������� - ���������� � ��������� �_����_�����_��� ����.ZS2';
    ComSigner.SetPrivateKey(FileName, '24447183', 4); // ������
  except
    on E: Exception do begin
       ComSigner := null;
       raise Exception.Create('������ ���������� Exite. ComSigner.SetPrivateKey ' + FileName + #10#13 + E.Message);
    end;
  end;
end;

function TEDI.InsertUpdateComDoc(�������������������
  : IXML�������������������Type; spHeader, spList: TdsdStoredProc): integer;
var
  MovementId, GoodsPropertyId: integer;
  i: integer;
begin
  with spHeader, ������������������� do
  begin
    ParamByName('inOrderInvNumber').Value := ���������.���������������;
    if ���������.�������������� <> '' then
      ParamByName('inOrderOperDate').Value :=
        VarToDateTime(���������.��������������)
    else
      ParamByName('inOrderOperDate').Value :=
        VarToDateTime(���������.�������������);
    ParamByName('inPartnerInvNumber').Value := ���������.��������������;
    ParamByName('inPartnerOperDate').Value :=
      VarToDateTime(���������.�������������);
    if ���������.���������������� = '012' then
    begin
      ParamByName('inDesc').Value := 'Return';
      ParamByName('inInvNumberTax').Value :=
        ���������.ParamByName('����� ��������� ��������').NodeValue;
      if not VarIsNull(���������.ParamByName('���� ��������� ��������')
        .NodeValue) then
        ParamByName('inOperDateTax').Value :=
          VarToDateTime(���������.ParamByName('���� ��������� ��������')
          .NodeValue);
      ParamByName('inInvNumberSaleLink').Value :=
        ���������.���ϳ������.��������������;
      ParamByName('inOperDateSaleLink').Value :=
        VarToDateTime(���������.���ϳ������.�������������);
    end
    else
      ParamByName('inDesc').Value := 'Sale';

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
        ParamByName('inGoodsName').Value := ������������;
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

procedure TEDI.OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String;
  StartDate, EndDate: TDateTime);
var
  List: TStrings;
  i: integer;
  Stream: TStringStream;
  ORDER: IXMLORDERType;
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
      if List.Count = 0 then
        exit;
      with TGaugeFactory.GetGauge('�������� ������', 0, List.Count) do
        try
          Start;
          for i := 0 to List.Count - 1 do
          begin
            // ���� ������ ����� ����� order � ��������� .xml
            if (copy(List[i], 1, 5) = 'order') and
              (copy(List[i], Length(List[i]) - 3, 4) = '.xml') then
            begin
              if (StartDate <= gfStrFormatToDate(copy(List[i], 7, 8),
                'yyyymmdd')) and
                (gfStrFormatToDate(copy(List[i], 7, 8), 'yyyymmdd') <= EndDate)
              then
              begin
                // ����� ���� � ���
                Stream.Clear;
                FIdFTP.Get(List[i], Stream);
                ORDER := LoadORDER(Utf8ToAnsi(Stream.DataString));
                // ��������� � �������
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
var i: integer;
begin
  for I := 1 to 10 do
  try
    FTPSetConnection;
    // ��������� ���� �� FTP
    FIdFTP.Connect;
    if FIdFTP.Connected then
      try
        FIdFTP.ChangeDir(Directory);
        FIdFTP.Put(FileName);
      finally
        FIdFTP.Quit;
      end;
      break;
  except
    on E: Exception do begin
      if i > 9 then
         raise Exception.Create(E.Message);
    end;
  end;

end;

procedure TEDI.ReceiptLoad(spProtocol: TdsdStoredProc; Directory: String);
var
  List, Receipt: TStrings;
  i, j: integer;
  Stream: TStringStream;
  g: string;
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
            // ��������� .rpl.
            if AnsiLowerCase(copy(List[i], Length(List[i]) - 3, 4)) = '.rpl'
            then
            begin
              // ����� ���� � ���
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
              spProtocol.Execute;

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
    SignFile(FileName, stComDoc);
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      '�������� ����������� � ��������';
    FInsertEDIEvents.Execute;

    // ���������� �� FTP
    PutFileToFTP(FileName, Directory);
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      '�������� ��������� �� FTP';
    FInsertEDIEvents.Execute;
  finally
    // �������
    DeleteFile(FileName);
  end;
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

  // ���������� �/��� ����������
  for I := 1 to 10 do
  try
    ComSigner.Process(FileName, vbSignType);
    break;
  except
    on E: Exception do begin
      if i > 9 then
         raise Exception.Create('������ ���������� Exite. ComSigner.Process'#10#13 + E.Message);
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
  // �������� ��������
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
      EDI.DeclarSave(HeaderDataSet, ListDataSet, Directory);
    ediReceipt:
      EDI.ReceiptLoad(spHeader, Directory);
    ediReturnComDoc:
      EDI.ReturnSave(HeaderDataSet, spHeader, spList, Directory);
    ediDeclarReturn:
      EDI.DeclarReturnSave(HeaderDataSet, ListDataSet, Directory);
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

{  FIdFTP.Username := 'uatovalanftp'; FIdFTP.Password := 'ftp349067';
FIdFTP.Host := 'ruftpex.edi.su'; '/archive'}
