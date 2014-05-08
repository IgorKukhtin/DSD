unit EDI;

interface

uses Classes, DB, dsdAction;

type

  // Компонент работы с EDI. Пока все засунем в него
  // Ну не совсем все, конечно, но много
  TEDI = class(TComponent)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADV(HeaderDataSet, ListDataSet: TDataSet);
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

  procedure Register;

implementation

uses VCL.ActnList, DBClient, DesadvXML, IdFTP, SysUtils;

procedure Register;
begin
  RegisterComponents('DSDComponent', [TEDI]);
  RegisterActions('EDI', [TEDIActionDesadv], TEDIActionDesadv);
end;

{ TEDI }

constructor TEDI.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TEDI.DESADV(HeaderDataSet, ListDataSet: TDataSet);
var
  DESADV: IXMLDESADVType;
  IdFTP:  TIdFTP;
  Stream: TStream;
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



  Stream := TMemoryStream.Create;
  DESADV.OwnerDocument.SaveToStream(Stream);
  // Переслать его по ftp
  IdFTP := TIdFTP.Create(nil);
  IdFTP.Username := 'uatovalanftp';
  IdFTP.Password := 'ftp349067';
  IdFTP.Host := 'ruftpex.edi.su';
  try
    IdFTP.Connect;
    if IdFTP.Connected then begin
       IdFTP.ChangeDir('/error');
       IdFTP.Put(Stream, 'testDECLAR.xml');
    end;
    IdFTP.Quit;
  finally
    IdFTP.Free;
    Stream.Free;
  end;
end;

destructor TEDI.Destroy;
begin
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
