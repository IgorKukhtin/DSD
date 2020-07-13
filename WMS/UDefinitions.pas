unit UDefinitions;

interface

uses
  FireDAC.Comp.Client;

type
  TNotifyProc = procedure of object;
  TNotifyMsgProc = procedure(const AMsg: string) of object;

  TThreadKind = (tknDriven, tknNondriven);

  TDataObjects = record
    HeaderQry, DetailQry, InsertQry, ErrorQry, SelectQry, DoneQry, ExecQry: TFDQuery;
  end;

  TPacketKind = (pknOrderStatusChanged, pknReceivingResult, pknWmsMovementASNLoad, pknWmsObjectClient,
                 pknWmsObjectPack, pknWmsObjectSKU, pknWmsObjectSKUCode, pknWmsObjectSKUGroup, pknWmsObjectUser,
                 pknWmsMovementIncoming, pknWmsMovementOrder);

  TPacketValues = record
    Message_Type: string;
    Header_Id: Integer;
    Detail_Id: Integer;
    MovementId: string;
    SKU_Id: string;
    Name: string;
    Qty: string;
    Weight: string;
    Weight_Biz: string;
    OperDate: TDateTime;
    Production_Date: string;
    Err_Code: Integer;
  private
    Ferr_descr: string;
    procedure SetErrDescr(AValue: string);
    function GetErrDescr: string;
  public
    property Err_Descr: string read GetErrDescr write SetErrDescr;
  end;

  TPacketValuesArray = array of TPacketValues;

implementation

{ TPacketValues }

function TPacketValues.GetErrDescr: string;
begin
  Result := Ferr_descr;
end;

procedure TPacketValues.SetErrDescr(AValue: string);
begin
  Ferr_descr := Ferr_descr + AValue + ' ';
end;

end.
