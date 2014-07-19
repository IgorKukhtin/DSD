unit EDI;

interface

uses Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb, OrderXML;

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar, ediComDocSave);

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
    procedure InsertUpdateOrder(ORDER: IXMLORDERType; spHeader, spList: TdsdStoredProc);
    procedure InsertUpdateComDoc(�������������������: IXML�������������������Type; spHeader, spList: TdsdStoredProc);
    procedure FTPSetConnection;
    procedure SignFile(FileName: string);
    procedure PutFileToFTP(FileName: string; Directory: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet; Directory: String);
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
UtilConvert, ComObj;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIAction], TEDIAction);
end;

{ TEDI }

procedure TEDI.COMDOCSave(HeaderDataSet, ItemsDataSet: TDataSet; Directory: String);
var
  �������������������: IXML�������������������Type;
  i: integer;
  XMLFileName, P7SFileName: string;
begin
  // ������� xml ����
  ������������������� := New�������������������;
  �������������������.���������.�������������� := HeaderDataSet.FieldByName('InvNumber').asString;
  �������������������.���������.������������ := '��������� ��������';
  �������������������.���������.���������������� := '006';
  �������������������.���������.������������� := FormatDateTime('yyyy-mm-dd', HeaderDataSet.FieldByName('OperDate').asDateTime);
  �������������������.���������.��������������� := HeaderDataSet.FieldByName('InvNumberOrder').asString;

  with �������������������.�������.Add do begin
       ����������������� := '���������';
       ���������������� :=  HeaderDataSet.FieldByName('JuridicalName_From').asString;
       �������������� :=    HeaderDataSet.FieldByName('OKPO_From').asString;
       ��� :=               HeaderDataSet.FieldByName('INN_From').asString;
  end;
  with �������������������.�������.Add do begin
       ����������������� := '��������';
       ���������������� :=  HeaderDataSet.FieldByName('JuridicalName_To').asString;
       �������������� :=    HeaderDataSet.FieldByName('OKPO_To').asString;
       ��� :=               HeaderDataSet.FieldByName('INN_To').asString;
  end;

  i := 1;
  ItemsDataSet.First;
  while not ItemsDataSet.Eof do begin
    with �������������������.�������.Add do begin
         �� := i;
         ������ := i;
         ������������ := ItemsDataSet.FieldByName('GoodsName_Juridical').asString;
         �������������� := ItemsDataSet.FieldByName('ArticleGLN_Juridical').asString;
         ��������ʳ������ := gfFloatToStr(ItemsDataSet.FieldByName('AmountPartner').AsFloat);
         ֳ�� := gfFloatToStr(ItemsDataSet.FieldByName('PriceWVAT').AsFloat);
    end;
    ItemsDataSet.Next;
  end;

  // ��������� �� ����
  XMLFileName := ExtractFilePath(ParamStr(0)) + 'comdoc_' + FormatDateTime('yyyymmddhhnnss', Date + Time ) + '_' + HeaderDataSet.FieldByName('InvNumber').asString + '_006.xml';
  �������������������.OwnerDocument.SaveToFile(XMLFileName);
  P7SFileName := StringReplace(XMLFileName, 'xml', 'p7s', [rfIgnoreCase]);
  try
    // ���������
    SignFile(XMLFileName);
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then begin
       FInsertEDIEvents.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
       FInsertEDIEvents.ParamByName('inEDIEvent').Value   := '�������� ����������� � ��������';
       FInsertEDIEvents.Execute;
    end;
    // ���������� �� FTP
    PutFileToFTP(P7SFileName, '/outbox');
    if HeaderDataSet.FieldByName('EDIId').asInteger <> 0 then begin
       FInsertEDIEvents.ParamByName('inMovementId').Value := HeaderDataSet.FieldByName('EDIId').asInteger;
       FInsertEDIEvents.ParamByName('inEDIEvent').Value   := '�������� ��������� �� FTP';
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
    �������������������: IXML�������������������Type;
begin
    FTPSetConnection;
    // ��������� ����� � FTP
    FIdFTP.Connect;
    if FIdFTP.Connected then begin
       FIdFTP.ChangeDir(Directory);
       try
         List := TStringList.Create;
         Stream := TStringStream.Create;
         FIdFTP.List(List, '' ,false);
         with TGaugeFactory.GetGauge('�������� ������', 1, List.Count) do
         try
           Start;
           for I := 0 to List.Count - 1 do begin
               // ���� ������ ����� ����� comdoc, � ��������� .p7s
               if (copy(list[i], 1, 6) = 'comdoc') and (copy(list[i], length(list[i]) - 3, 4) = '.p7s') then begin
                  if (StartDate <= gfStrFormatToDate(copy(list[i], 8, 8), 'yyyymmdd'))
                    and (gfStrFormatToDate(copy(list[i], 8, 8), 'yyyymmdd') <= EndDate)  then begin
                  // ����� ���� � ���
                    Stream.Clear;
                    FIdFTP.Get(List[i], Stream);
                    FileData := Utf8ToAnsi(Stream.DataString);
                    // ������ ��������� <?xml
                    FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                    FileData := copy(FileData, 1, pos('</�������������������>', FileData) + 21);
                    ������������������� := Load�������������������(FileData);
                    if (�������������������.���������.���������������� = '007')
                      or(�������������������.���������.���������������� = '004') then begin
                         // ��������� � �������
                         InsertUpdateComDoc(�������������������, spHeader, spList);
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

procedure TEDI.DESADVSave(HeaderDataSet, ItemsDataSet: TDataSet);
var
  DESADV: IXMLDESADVType;
  Stream: TStream;
  i: integer;
begin
  DESADV := NewDESADV;
  // ������� XML
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
  // ��������� ��� �� ftp
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
  �������������������: IXML�������������������Type;
  spHeader, spList: TdsdStoredProc);
var MovementId, GoodsPropertyId: Integer;
    i: integer;
begin
  with spHeader, ������������������� do begin
    ParamByName('inOrderInvNumber').Value := ���������.���������������;
    if ���������.�������������� <> '' then
       ParamByName('inOrderOperDate').Value  := VarToDateTime(���������.��������������)
    else
       ParamByName('inOrderOperDate').Value  := VarToDateTime(���������.�������������);
    ParamByName('inSaleInvNumber').Value  := ���������.��������������;
    ParamByName('inSaleOperDate').Value   := VarToDateTime(���������.�������������);

    for i:= 0 to �������.Count - 1 do
        if �������.����������[i].����������������� = '��������' then begin
           ParamByName('inOKPO').Value := �������.����������[i].��������������;
           ParamByName('inJuridicalName').Value := �������.����������[i].����������������;
        end;
     Execute;
     MovementId := ParamByName('MovementId').Value;
     GoodsPropertyId := StrToInt(ParamByName('GoodsPropertyId').asString);
  end;
  with spList, �������������������.������� do
       for I := 0 to GetCount - 1 do begin
           with �����[i] do begin
             ParamByName('inMovementId').Value := MovementId;
             ParamByName('inGoodsPropertyId').Value := GoodsPropertyId;
             ParamByName('inGoodsName').Value := ������������;
             ParamByName('inGLNCode').Value := ��������������;
             ParamByName('inAmountPartner').Value := gfStrToFloat(��������ʳ������);
             ParamByName('inSummPartner').Value := gfStrToFloat(�������������.����������);
//             ParamByName('inPricePartner').Value := ParamByName('inSummPartner').Value / ParamByName('inAmountPartner').Value;
             ParamByName('inPricePartner').Value := gfStrToFloat(������ֳ��);
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
    // ��������� ����� � FTP
    FIdFTP.Connect;
    if FIdFTP.Connected then begin
       FIdFTP.ChangeDir(Directory);
       try
         List := TStringList.Create;
         Stream := TStringStream.Create;
         FIdFTP.List(List, '' ,false);
         if List.Count = 0 then
            exit;
         with TGaugeFactory.GetGauge('�������� ������', 0, List.Count) do
         try
           Start;
           for I := 0 to List.Count - 1 do begin
             // ���� ������ ����� ����� order � ��������� .xml
             if (copy(list[i], 1, 5) = 'order') and (copy(list[i], length(list[i]) - 3, 4) = '.xml') then begin
                if (StartDate <= gfStrFormatToDate(copy(list[i], 7, 8), 'yyyymmdd'))
                    and (gfStrFormatToDate(copy(list[i], 7, 8), 'yyyymmdd') <= EndDate)  then begin
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
begin
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
end;

procedure TEDI.SignFile(FileName: string);
var
  ComSigner: OleVariant;
  privateKey: string;
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
      //��������� �����������
      ComSigner.SetCryptToCertCert(ExtractFilePath(ParamStr(0)) + '������ �.�..cer');
      ComSigner.SetCryptToCertCert(ExtractFilePath(ParamStr(0)) + '���������� � ��������� ������������� ����1.cer');
      ComSigner.SetCryptToCertCert(ExtractFilePath(ParamStr(0)) + '���������� � ��������� ������������� ����.cer');

      // ��������� ������
      ComSigner.SetPrivateKey(ExtractFilePath(ParamStr(0)) + '���� - ������ �.�..ZS2', '24447183', 1); //���������
      // ��������� ������
      ComSigner.SetPrivateKey(ExtractFilePath(ParamStr(0)) + '���� - ��� �_������ - ���������� � ��������� �_����_�����_��� ����.ZS2', '24447183', 3); //������
      // ��������� ������
      ComSigner.SetPrivateKey(ExtractFilePath(ParamStr(0)) + '���� - ��� ���������� - ���������� � ��������� �_����_�����_��� ����.ZS2', '24447183', 4); //����

      // ���������� �/��� ����������
      ComSigner.Process(FileName, 2);         //ComDoc
      // ComSigner.Process("D:\OUTBOX\4\23440000654654J1201205100400000610520142344.xml", 1); //Declar
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
  // �������� ��������
  case EDIDocType of
    ediOrder:  EDI.OrderLoad(spHeader, spList, Directory, StartDateParam.Value, EndDateParam.Value);
    ediComDoc: EDI.ComdocLoad(spHeader, spList, Directory, StartDateParam.Value, EndDateParam.Value);
    ediComDocSave: EDI.COMDOCSave(HeaderDataSet, ListDataSet, Directory);
//    ediDesadv,
//    ediDeclar
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

