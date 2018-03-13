unit uDSDSvcMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs;

type
  TFarmacyService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  FarmacyService: TFarmacyService;

implementation

{$R *.dfm}

uses dmDSD;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  FarmacyService.Controller(CtrlCode);
end;

function TFarmacyService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TFarmacyService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Log('Starting...');
  DM := TDM.Create(nil);
  Log('Started');
  Started := True;
end;

procedure TFarmacyService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  DM.HTTPServer.OnCommandGet := nil;
  DM.HTTPServer.Active := False;
  DM.Free;
end;

end.
