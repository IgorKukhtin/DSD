unit EDI;

interface

uses DBClient, Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb, OrderXML, UtilConst;

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

  // ��������� ������ � EDI. ���� ��� ������� � ����
  // �� �� ������ ���, �������, �� �����
  TEDI = class(TComponent)
  private
    FIdFTP: TIdFTP;
    FConnectionParams: TConnectionParams;
    FInsertEDIEvents: TdsdStoredProc;
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
    procedure InsertUpdateOrder(ORDER: IXMLORDERType;
      spHeader, spList: TdsdStoredProc);
    function InsertUpdateComDoc(�������������������
      : IXML�������������������Type; spHeader, spList: TdsdStoredProc): integer;
    procedure FTPSetConnection;
    procedure InitializeComSigner(DebugMode: boolean);
    procedure SignFile(FileName: string; SignType: TSignType; DebugMode: boolean);
    procedure PutFileToFTP(FileName: string; Directory: string);
    procedure PutStreamToFTP(Stream: TStream; FileName: string;
      Directory: string);
    procedure SetDirectory(const Value: string);
    function ConvertEDIDate(ADateTime: string): TDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure ORDRSPSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure INVOICESave(HeaderDataSet, ItemsDataSet: TDataSet);
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

    procedure DeclarReturnSave(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarReturnSave_start(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
      Directory: String; DebugMode: boolean);
    procedure lpDeclarReturnSave_start01042016(HeaderDataSet, ItemsDataSet: TDataSet;  StoredProc: TdsdStoredProc;
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
  FormStorage, UnilWin, OrdrspXML, StrUtils, StatusXML, RecadvXML;

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
    SignFile(XMLFileName, stComDoc, DebugMode);
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
              DocData := gfStrFormatToDate(copy(List[i], 8, 8), 'yyyymmdd');
              if (StartDate <= DocData) and (DocData <= EndDate) then
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
                  try
                    MovementId := InsertUpdateComDoc(�������������������,
                      spHeader, spList);
                  Except ON E: Exception DO
                    Begin
                      MovementId := -1;
                      ShowMessage(E.Message);
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

     if HeaderDataSet.FieldByName('OperDate_begin').asDateTime >= StrToDateTime( '01.04.2016', F)
     then lpDeclarReturnSave_start01042016(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode)
     else lpDeclarReturnSave_start(HeaderDataSet, ItemsDataSet, StoredProc, Directory, DebugMode);
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
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName
    ('SupplierGLNCode').asString + ';SU:' + HeaderDataSet.FieldByName
    ('BuyerGLNCode').asString;

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
    SignFile(XMLFileName, stDeclar, DebugMode);
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
  DECLAR.DECLARHEAD.SOFTWARE := 'BY:' + HeaderDataSet.FieldByName
    ('BuyerGLNCode').asString + ';SU:' + HeaderDataSet.FieldByName
    ('SupplierGLNCode').asString;


  if HeaderDataSet.FieldByName('isNotNDSPayer').asBoolean then
  begin
     // �� �������� �������  / �������
     DECLAR.DECLARBODY.HORIG1 := '1';
     DECLAR.DECLARBODY.HTYPR := HeaderDataSet.FieldByName('NotNDSPayerC1').asString + HeaderDataSet.FieldByName('NotNDSPayerC2').asString;
  end;

   if HeaderDataSet.FieldByName('TaxKind').asString <> '' then
     //�� ������� ��������� ��������
     DECLAR.DECLARBODY.H03 := '1';

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

  //�������� �����
  DECLAR.DECLARBODY.R01G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummMVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R03G7 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('SummVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
  DECLAR.DECLARBODY.R03G11 := DECLAR.DECLARBODY.R03G7;
  DECLAR.DECLARBODY.R04G11 :=
    StringReplace(FormatFloat('0.00', HeaderDataSet.FieldByName('TotalSummPVAT')
    .AsFloat), FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);

  //�������� (������������) �����/������� �����
  DECLAR.DECLARBODY.HBOS := HeaderDataSet.FieldByName('N10').asString;
  DECLAR.DECLARBODY.HKBOS := HeaderDataSet.FieldByName('AccounterINN_From').asString;

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
    with DECLAR.DECLARBODY.RXXXXG008.Add do
    begin
      ROWNUM := IntToStr(i);
      NodeValue := StringReplace(FormatFloat('0.00',
        HeaderDataSet.FieldByName('VATPersent').AsFloat),
        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
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
        ItemsDataSet.FieldByName('AmountSummNoVat_12').AsFloat),
        FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
    end;
    inc(i);
    ItemsDataSet.Next;
  end;


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
    SignFile(XMLFileName, stDeclar, DebugMode);
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
    SignFile(XMLFileName, stDeclar, DebugMode);
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
  DESADV: IXMLDESADVType;
  Stream: TStream;
  i: integer;
  FileName: string;
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
    HeaderDataSet.FieldByName('OperDate').asDateTime);
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
        PRICE := StringReplace(FormatFloat('0.00', ItemsDataSet.FieldByName('Price').AsFloat),
          FormatSettings.DecimalSeparator, cMainDecimalSeparator, []);
      end;
      inc(i);
      Next;
    end;
  end;

  Stream := TMemoryStream.Create;
  try
    DESADV.OwnerDocument.SaveToStream(Stream);
    FileName := 'desadv_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + DESADV.NUMBER + '.xml';
    if FisEDISaveLocal then
       try
         DESADV.OwnerDocument.SaveToFile(FDirectoryError + FileName);
       except
         DESADV.OwnerDocument.SaveToFile(FileName);
       end;
    PutStreamToFTP(Stream, FileName, '/outbox');
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
  end;
end;

destructor TEDI.Destroy;
var
  i: integer;
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
  FileName: string;
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

procedure TEDI.InitializeComSigner;
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

  try
    // ��������� ������
    FileName := ExtractFilePath(ParamStr(0)) + '���� - ������ �.�..ZS2';
	  ComSigner.SetPrivateKeyFile (euKeyTypeAccountant, FileName, '24447183', false); // ���������
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('������ ���������� Exite. ComSigner.SetPrivateKeyFile '
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // ��������� ������
    FileName := ExtractFilePath(ParamStr(0)) +
      '���� - ��� �_������ - ���������� � ��������� �_����_�����_��� ����.ZS2';
	  ComSigner.SetPrivateKeyFile (euKeyTypeDigitalStamp, FileName, '24447183', false); // ������
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('������ ���������� Exite. ComSigner.SetPrivateKeyFile '
        + FileName + #10#13 + E.Message);
    end;
  end;

  try
    // ��������� ������
    FileName := ExtractFilePath(ParamStr(0)) +
      '���� - ��� ���������� - ���������� � ��������� �_����_�����_��� ����.ZS2';
	  ComSigner.SetPrivateKeyFile (euKeyTypeDigitalStamp, FileName, '24447183', false); // ������
    Error := ComSigner.GetLastErrorDescription;
    if Error <> okError then
       raise Exception.Create(Error);
  except
    on E: Exception do
    begin
      ComSigner := null;
      raise Exception.Create('������ ���������� Exite. ComSigner.SetPrivateKeyFile '
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
  DocData: TDateTime;
begin
  try
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
                DocData := gfStrFormatToDate(copy(List[i], 7, 8), 'yyyymmdd');
                if (StartDate <= DocData) and (DocData <= EndDate) then
                begin
                  // ����� ���� � ���
                  Stream.Clear;
                  if not FIdFTP.Connected then
                    FIdFTP.Connect;
                  FIdFTP.ChangeDir(Directory);
                  FIdFTP.Get(List[i], Stream);
                  ORDER := LoadORDER(Utf8ToAnsi(Stream.DataString));
                  // ��������� � �������
                  InsertUpdateOrder(ORDER, spHeader, spList);
                  // ������ ��������� ���� � ���������� Archive
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
  FileName: string;
begin

  ORDRSP := NewORDRSP;
  // ������� XML
  ORDRSP.NUMBER := HeaderDataSet.FieldByName('InvNumber').asString;
  ORDRSP.Date := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  ORDRSP.DELIVERYDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);
  ORDRSP.ORDERNUMBER := HeaderDataSet.FieldByName('InvNumberOrder').asString;
  ORDRSP.ORDERDATE := FormatDateTime('yyyy-mm-dd',
    HeaderDataSet.FieldByName('OperDate').asDateTime);

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

  Stream := TMemoryStream.Create;
  try
    ORDRSP.OwnerDocument.SaveToStream(Stream);
    FileName := 'ORDRSP_' + FormatDateTime('yyyymmddhhnn', Now) + '_' + ORDRSP.NUMBER + '.xml';
    if FisEDISaveLocal then
       try
         ORDRSP.OwnerDocument.SaveToFile(FDirectoryError + FileName);
       except
         ORDRSP.OwnerDocument.SaveToFile(FileName);
       end;
    PutStreamToFTP(Stream, FileName, '/outbox');
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
      FIdFTP.Quit;
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
  Status: IXMLStatusType;
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
      FIdFTP.Quit;
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
    SignFile(FileName, stComDoc, DebugMode);
    FInsertEDIEvents.ParamByName('inMovementId').Value := MovementId;
    FInsertEDIEvents.ParamByName('inEDIEvent').Value :=
      '�������� ����������� � ��������';
    FInsertEDIEvents.Execute;

    // ���������� �� FTP
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

procedure TEDI.SignFile(FileName: string; SignType: TSignType; DebugMode: boolean);
var
  vbSignType: integer;
  i: integer;
  Error: string;
  EUTaxService_����������Exite, EUTaxService_�������������: string;
  ddd: OleVariant;
begin
  if VarIsNull(ComSigner) then
    InitializeComSigner(DebugMode);

  if SignType = stDeclar then
    vbSignType := 1;
  if SignType = stComDoc then
    vbSignType := 2;

  // ���������� �/��� ����������
  for i := 1 to 10 do
    try
      if SignType = stComDoc then begin
          ComSigner.SetFilesOptions(False);
          Error := ComSigner.GetLastErrorDescription;
          if Error <> okError then
             raise Exception.Create('ComSigner.SetFilesOptions(False) ' + Error);

          ComSigner.SignFilesByAccountant(FileName);
          Error := ComSigner.GetLastErrorDescription;
          if Error <> okError then
             raise Exception.Create('ComSigner.SignFilesByAccountant(FileName) ' + Error);

          ComSigner.SignFilesByDigitalStamp(FileName);
          Error := ComSigner.GetLastErrorDescription;
          if Error <> okError then
             raise Exception.Create('ComSigner.SignFilesByDigitalStamp(FileName) ' + Error);
      end;
      if SignType = stDeclar then begin
         // O=Գ����� ����� ;OU=Գ����� �����;Title=���������;CN=�볺� ����� ��������;SN=�볺�;GivenName=����� ��������;Serial=1497059;C=UA;L=���������;ST=�������
         // O=�������� ��������� ������ ������;OU=�������� ��������� ������ ������;Title=���������� �������;CN=�������� ��������� ������ ������. ��������;Serial=1671693;C=UA;L=���
//         EUTaxService_����������Exite := ComSigner.SelectServerCert;
//         EUTaxService_������������� := ComSigner.SelectServerCert;
         EUTaxService_����������Exite := 'O=Գ����� ����� ;OU=Գ����� �����;Title=���������;CN=�볺� ����� ��������;SN=�볺�;GivenName=����� ��������;Serial=1497059;C=UA;L=���������;ST=�������';
         EUTaxService_������������� := 'O=�������� ��������� ������ ������;OU=�������� ��������� ������ ������;Title=���������� �������;CN=�������� ��������� ������ ������. ��������;Serial=1671693;C=UA;L=���';
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
    ediDesadv:
      EDI.DESADVSave(HeaderDataSet, ListDataSet);
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
