unit Oven;

interface

uses System.SysUtils, System.Classes, WinTypes, WinProcs, Modlink;

type

  TMU110 = class

  private
    FModbusConnection: TModbusConnection;
    FModbusClient: TModbusClient;
    constructor ActualCreate(AOwner: TComponent);
    constructor Create(AOwner: TComponent = nil);
  public
    function SetPort(APort: string): boolean;
    function SetAddress(AAddress: byte): boolean;
    function SetFlashTime(ATime: word): boolean;
    function OutOn(AOutNumber: byte): boolean;
    function OutOff(AOutNumber: byte): boolean;
    function OutFlash(AOutNumber: byte): boolean;
    class function GetInstance(AOwner: TComponent = nil): TMU110;
    destructor Destroy; override;
  end;

implementation

var MU110: TMU110;


constructor TMU110.ActualCreate(AOwner: TComponent);
begin
    inherited Create;
    FModbusConnection:= TModbusConnection.Create(AOwner);
    FModbusClient:= TModbusClient.Create(AOwner);
    FModbusConnection.BaudRate:= br9600;
    FModbusConnection.Parity:= psNone;
    FModbusClient.ServerAddress:= 16;
    FModbusClient.Connection:= FModbusConnection;
end;

constructor TMU110.Create(AOwner: TComponent = nil);
begin
    raise Exception.Create('Attempt to create an instance of TSingleton');
end;

class function TMU110.GetInstance(AOwner: TComponent = nil): TMU110;
begin
    if MU110 = nil then MU110:= TMU110.ActualCreate(AOwner);
      Result := MU110;
end;

destructor TMU110.Destroy;
begin
    FModbusClient.Free;
    FModbusConnection.Free;
    MU110:= nil;
    inherited Destroy;
end;

function TMU110.SetPort(APort: string): boolean;
begin
   try
       FModbusConnection.Active:= false;
       FModbusConnection.Port:= APort;
       Result:= true;
   except
       Result:= false;
   end;
end;

function TMU110.SetAddress(AAddress: byte): boolean;
begin
    try
       FModbusConnection.Active:= false;
       FModbusClient.ServerAddress:= AAddress;
       Result:= true;
    except
       Result:= false;
    end;
end;

function TMU110.SetFlashTime(ATime: word): boolean;
var
    StartReg, i: Word;
    RegValues: TRegValues;
begin
 //        if MU110 <> nil then MessageDlg('MU110 exist '+MU110.FModbusConnection.Port+' Address '+
 //        IntToStr(MU110.FModbusClient.ServerAddress) , mtInformation,
 //     [mbOk], 0, mbOk);
    try
       FModbusConnection.Active:= true;
       StartReg:= 32;
       SetLength(RegValues, 8);
       for i:=0 to 7 do RegValues[i]:= ATime;
       FModbusClient.WriteMultipleRegisters(StartReg, RegValues);
       Result:= true;
    except
       Result:= false;
    end;
end;

function TMU110.OutOn(AOutNumber: byte): boolean;
var
    StartReg: Word;
    RegValues: TRegValues;
begin
 //        if MU110 <> nil then MessageDlg('MU110 exist '+MU110.FModbusConnection.Port+' Address '+
 //        IntToStr(MU110.FModbusClient.ServerAddress) , mtInformation,
 //     [mbOk], 0, mbOk);
    try
       FModbusConnection.Active:= true;
       StartReg:= AOutNumber - 1;
       SetLength(RegValues, 1);
       RegValues[0]:= 1000;
       FModbusClient.WriteMultipleRegisters(StartReg, RegValues);
       Result:= true;
    except
       Result:= false;
    end;
end;

function TMU110.OutOff(AOutNumber: byte): boolean;
var
    StartReg: Word;
    RegValues: TRegValues;
begin
 //        if MU110 <> nil then MessageDlg('MU110 exist '+MU110.FModbusConnection.Port+' Address '+
 //        IntToStr(MU110.FModbusClient.ServerAddress) , mtInformation,
 //     [mbOk], 0, mbOk);
    try
       FModbusConnection.Active:= true;
       StartReg:= AOutNumber - 1;
       SetLength(RegValues, 1);
       RegValues[0]:= 0;
       FModbusClient.WriteMultipleRegisters(StartReg, RegValues);
       Result:= true;
    except
       Result:= false;
    end;
end;

function TMU110.OutFlash(AOutNumber: byte): boolean;
var
    StartReg: Word;
    RegValues: TRegValues;
begin
 //        if MU110 <> nil then MessageDlg('MU110 exist '+MU110.FModbusConnection.Port+' Address '+
 //        IntToStr(MU110.FModbusClient.ServerAddress) , mtInformation,
 //     [mbOk], 0, mbOk);
    try
       FModbusConnection.Active:= true;
       StartReg:= AOutNumber - 1;
       SetLength(RegValues, 1);
       RegValues[0]:= 500;
       FModbusClient.WriteMultipleRegisters(StartReg, RegValues);
       Result:= true;
    except
       Result:= false;
    end;
end;

end.

