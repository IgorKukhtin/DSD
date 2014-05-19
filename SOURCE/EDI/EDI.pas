unit EDI;

interface

uses Classes, DB, dsdAction, IdFTP, ComDocXML, dsdDb, OrderXML;

type

  TEDIDocType = (ediOrder, ediComDoc, ediDesadv, ediDeclar);

  TConnectionParams = class(TPersistent)
  private
    FPassword: string;
    FHost: string;
    FUser: string;
  published
    property Host: string read FHost write FHost;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
  end;
  // ��������� ������ � EDI. ���� ��� ������� � ����
  // �� �� ������ ���, �������, �� �����
  TEDI = class(TComponent)
  private
    FIdFTP: TIdFTP;
    FConnectionParams: TConnectionParams;
    procedure InsertUpdateOrder(ORDER: IXMLORDERType; spHeader, spList: TdsdStoredProc);
    procedure InsertUpdateComDoc(�������������������: IXML�������������������Type; spHeader, spList: TdsdStoredProc);
    procedure FTPSetConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADV(HeaderDataSet, ItemsDataSet: TDataSet);
    procedure ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String);
    procedure OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String);
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
  protected
    function LocalExecute: boolean; override;
  published
    property EDI: TEDI read FEDI write FEDI;
    property EDIDocType: TEDIDocType read FEDIDocType write FEDIDocType;
    property spHeader: TdsdStoredProc read FspHeader write FspHeader;
    property spList: TdsdStoredProc read FspList write FspList;
    property Directory: string read FDirectory write FDirectory;
  end;

  procedure Register;

implementation

uses VCL.ActnList, DBClient, DesadvXML, SysUtils, Dialogs, SimpleGauge, Variants,
UtilConvert;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIAction], TEDIAction);
end;

{ TEDI }

constructor TEDI.Create(AOwner: TComponent);
begin
  inherited;
  FConnectionParams := TConnectionParams.Create;
  FIdFTP := TIdFTP.Create(nil);
end;

procedure TEDI.ComdocLoad(spHeader, spList: TdsdStoredProc; Directory: String);
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
                  // ����� ���� � ���
                  Stream.Clear;
                  FIdFTP.Get(List[i], Stream);
                  FileData := Utf8ToAnsi(Stream.DataString);
                  // ������ ��������� <?xml
                  FileData := copy(FileData, pos('<?xml', FileData), MaxInt);
                  FileData := copy(FileData, 1, pos('</�������������������>', FileData) + 21);
                  ������������������� := Load�������������������(FileData);
                  if �������������������.���������.���������������� = '007' then begin
                     // ��������� � �������
                     InsertUpdateComDoc(�������������������, spHeader, spList);
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

procedure TEDI.DESADV(HeaderDataSet, ItemsDataSet: TDataSet);
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
  inherited;
end;

procedure TEDI.FTPSetConnection;
begin
  FIdFTP.Username := ConnectionParams.User;// 'uatovalanftp';
  FIdFTP.Password := ConnectionParams.Password; // 'ftp349067';
  FIdFTP.Host := ConnectionParams.Host;// 'ruftpex.edi.su';
end;

procedure TEDI.InsertUpdateOrder(ORDER: IXMLORDERType; spHeader,
  spList: TdsdStoredProc);
var MovementId: Integer;
    i: integer;
begin
{  with spHeader, ORDER do begin
    ParamByName('outid').Value := 0;
    ParamByName('inOrderInvNumber').Value := ���������.���������������;
    if ���������.�������������� <> '' then
       ParamByName('inOrderOperDate').Value  := VarToDateTime(���������.��������������)
    else
       ParamByName('inOrderOperDate').Value  := VarToDateTime(���������.�������������);
    ParamByName('inSaleInvNumber').Value  := ���������.��������������;
    ParamByName('inSaleOperDate').Value   := VarToDateTime(���������.�������������);

    for i:= 0 to �������.Count - 1 do
        if �������.����������[i].����������������� = '��������' then begin
           ParamByName('inGLN').Value := �������.����������[i].GLN;
           ParamByName('inOKPO').Value := �������.����������[i].��������������;
        end;
     Execute;
     MovementId := ParamByName('outid').Value;
  end;
  with spList, ORDER.������� do
       for I := 0 to GetCount - 1 do begin
           with �����[i] do begin
             ParamByName('inMovementId').Value := MovementId;
             ParamByName('inGoodsName').Value := ������������;
             ParamByName('inGLNCode').Value := ��������������;
             ParamByName('inAmountOrder').Value := 0;
             ParamByName('inAmountPartner').Value := gfStrToFloat(��������ʳ������);
             ParamByName('inPricePartner').Value := gfStrToFloat(ֳ��);
             ParamByName('inSummPartner').Value := gfStrToFloat(�������������.����);
             Execute;
           end;
       end;}
end;

procedure TEDI.InsertUpdateComDoc(
  �������������������: IXML�������������������Type;
  spHeader, spList: TdsdStoredProc);
var MovementId: Integer;
    i: integer;
begin
  with spHeader, ������������������� do begin
    ParamByName('outid').Value := 0;
    ParamByName('inOrderInvNumber').Value := ���������.���������������;
    if ���������.�������������� <> '' then
       ParamByName('inOrderOperDate').Value  := VarToDateTime(���������.��������������)
    else
       ParamByName('inOrderOperDate').Value  := VarToDateTime(���������.�������������);
    ParamByName('inSaleInvNumber').Value  := ���������.��������������;
    ParamByName('inSaleOperDate').Value   := VarToDateTime(���������.�������������);

    for i:= 0 to �������.Count - 1 do
        if �������.����������[i].����������������� = '��������' then begin
           ParamByName('inGLN').Value := �������.����������[i].GLN;
           ParamByName('inOKPO').Value := �������.����������[i].��������������;
        end;
     Execute;
     MovementId := ParamByName('outid').Value;
  end;
  with spList, �������������������.������� do
       for I := 0 to GetCount - 1 do begin
           with �����[i] do begin
             ParamByName('inMovementId').Value := MovementId;
             ParamByName('inGoodsName').Value := ������������;
             ParamByName('inGLNCode').Value := ��������������;
             ParamByName('inAmountOrder').Value := 0;
             ParamByName('inAmountPartner').Value := gfStrToFloat(��������ʳ������);
             ParamByName('inPricePartner').Value := gfStrToFloat(ֳ��);
             ParamByName('inSummPartner').Value := gfStrToFloat(�������������.����);
             Execute;
           end;
       end;
end;

procedure TEDI.OrderLoad(spHeader, spList: TdsdStoredProc; Directory: String);
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
         with TGaugeFactory.GetGauge('�������� ������', 1, List.Count) do
         try
           Start;
           for I := 0 to List.Count - 1 do begin
               // ���� ������ ����� ����� comdoc, � ��������� .p7s
               if (copy(list[i], 1, 5) = 'order') and (copy(list[i], length(list[i]) - 3, 4) = '.xml') then begin
                  // ����� ���� � ���
                  Stream.Clear;
                  FIdFTP.Get(List[i], Stream);
//                  FileData := Utf8ToAnsi(Stream.DataString);
                  ORDER := LoadORDER(Stream.DataString);
                   // ��������� � �������
                   InsertUpdateOrder(ORDER, spHeader, spList);
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

{ TEDIActionEDI }

function TEDIAction.LocalExecute: boolean;
begin
  // �������� ��������
  case EDIDocType of
    ediOrder:  EDI.OrderLoad(spHeader, spList, Directory);
    ediComDoc: EDI.ComdocLoad(spHeader, spList, Directory);
//    ediDesadv,
//    ediDeclar
  end;
end;

end.

  FIdFTP.Username := 'uatovalanftp';
  FIdFTP.Password := 'ftp349067';
  FIdFTP.Host := 'ruftpex.edi.su';
   '/archive'

