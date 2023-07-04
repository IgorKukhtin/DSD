unit Pos_ECRCommX_BPOS1Lib;

interface

uses Winapi.Windows, Winapi.ActiveX, System.Variants, System.SysUtils, System.Win.ComObj,
     PosInterface;

type
  TPos_ECRCommX_BPOS1Lib = class(TInterfacedObject, IPos)
  private
    FPOS : Variant;
    FLastPosError : String;
    FLastPosRRN : String;
    FCancel : Boolean;
    FMsgDescriptionProc : TMsgDescriptionProc;
    FPOSTerminalCode : integer;

    procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
    function GetMsgDescriptionProc: TMsgDescriptionProc;
    function GetLastPosError : string;
    function GetProcessType : TPosProcessType;
  protected
    function WaitPosResponsePrivat() : Integer;
    function CheckConnection : Boolean;
    function Payment(ASumma : Currency) : Boolean;
    function Refund(ASumma : Currency) : Boolean;
    procedure Cancel;
  public
    constructor Create(APOSTerminalCode : Integer);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

uses IniUtils;

constructor TPos_ECRCommX_BPOS1Lib.Create(APOSTerminalCode : Integer);
begin
  inherited Create;
  FPOSTerminalCode := APOSTerminalCode;
end;

procedure TPos_ECRCommX_BPOS1Lib.SetMsgDescriptionProc(Value: TMsgDescriptionProc);
begin
  FMsgDescriptionProc := Value;
end;

function TPos_ECRCommX_BPOS1Lib.GetMsgDescriptionProc: TMsgDescriptionProc;
begin
  Result := FMsgDescriptionProc;
end;

function TPos_ECRCommX_BPOS1Lib.GetLastPosError : string;
begin
  Result := FLastPosError;
end;

function TPos_ECRCommX_BPOS1Lib.GetProcessType : TPosProcessType;
begin
  Result := pptProcess;
end;

procedure TPos_ECRCommX_BPOS1Lib.AfterConstruction;
var
  ClassID : TCLSID;
  aResult : hResult;
begin
  inherited AfterConstruction;

  FPOS := Unassigned;
  FCancel := False;
  aResult := CLSIDFromProgID(PWideChar(WideString('ECRCommX.BPOS1Lib')), ClassID);
  if aResult <> S_OK then
    raise Exception.Create('Ќе установлена ECRCommX библиотека~ дл€ POS-терминала.')
  else FPOS := CreateOLEObject('ECRCommX.BPOS1Lib');
end;

procedure TPos_ECRCommX_BPOS1Lib.BeforeDestruction;
begin
  FPOS := Unassigned;
  inherited BeforeDestruction;
end;

function TPos_ECRCommX_BPOS1Lib.WaitPosResponsePrivat() : Integer;
begin
  while FPOS.LastResult = 2 do
  begin
    if FCancel then
    begin
      if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('ѕрервано пользователем...');
      FPOS.Cancel;
      Result := -1;
      Exit;
    end;
    if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc(FPOS.LastStatMsgDescription);
  end;

  Result := FPOS.LastResult;

  if FPOS.LastResult = 1 then
  begin
    FLastPosError := IntToStr(FPOS.LastErrorCode) + ' ( ' + FPOS.LastErrorDescription + ' )';
  end;
end;

function TPos_ECRCommX_BPOS1Lib.CheckConnection : Boolean;
begin
  Result := True;
end;

function TPos_ECRCommX_BPOS1Lib.Payment(ASumma : Currency) : Boolean;
var
  Summa : Integer;
begin
  Result := False;
  Summa := StrToInt(FloatToStr(ASumma * 100));
  FPOS.SetErrorLang(2);                                                    // язык сообщений. 2-”кр
  try
    FPOS.CommOpen(iniPosPortNumber(FPOSTerminalCode), iniPosPortSpeed(FPOSTerminalCode));
    if WaitPosResponsePrivat() = 0 then
    begin
      FPOS.Purchase( Summa, 0, 0 );
      if WaitPosResponsePrivat() <> 0 then Exit;

      FLastPosRRN := FPOS.RRN;

      FPOS.Confirm;
      if WaitPosResponsePrivat() = 0 then
        Result := True;
    end
    else begin
      FPOS.Cancel;
      Result := False;
    end;
  finally
   FPOS.CommClose;
  end;
end;

function TPos_ECRCommX_BPOS1Lib.Refund(ASumma : Currency) : Boolean;
var
  Summa : Integer;
begin
  Result := False;
  Summa := StrToInt(FloatToStr(ASumma * 100));
  FPOS.SetErrorLang(2);                                                    // язык сообщений. 2-”кр
  try
    FPOS.CommOpen(iniPosPortNumber(FPOSTerminalCode), iniPosPortSpeed(FPOSTerminalCode));
    if WaitPosResponsePrivat() = 0 then
    begin
      FPOS.Refund( Summa, 0, 0 );
      if WaitPosResponsePrivat() <> 0 then Exit;

      FLastPosRRN := FPOS.RRN;

      FPOS.Confirm;
      if WaitPosResponsePrivat() = 0 then
        Result := True;
    end
    else begin
      FPOS.Cancel;
      Result := False;
    end;
  finally
   FPOS.CommClose;
  end;
end;

procedure TPos_ECRCommX_BPOS1Lib.Cancel;
begin
  FCancel := True;
end;

end.
