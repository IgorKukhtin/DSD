unit UGatewaySvc;

interface

uses
  Winapi.Windows
  , System.Win.Registry
  , System.SysUtils
  , System.Classes
  , Vcl.SvcMgr
  , USettings
  , ULog
  , UGateway;

type
  TWMSGatewaySvc = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
  strict private
    FExporter: TExporterThread;
    FImporter: TImporterThread;
  strict private
    procedure ExpNotificationMsg(const AMsg: string);
    procedure ImpNotificationMsg(const AMsg: string);
    procedure StartGateway;
    procedure StopGateway;
  public
    function GetServiceController: TServiceController; override;
  end;

var
  WMSGatewaySvc: TWMSGatewaySvc;

implementation

{$R *.dfm}

uses
  UConstants,
  UDefinitions;

var
  mLog: TLog;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  WMSGatewaySvc.Controller(CtrlCode);
end;

function TWMSGatewaySvc.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TWMSGatewaySvc.ImpNotificationMsg(const AMsg: string);
begin
  mLog.Write(cImportMsgLog, AMsg);
end;

procedure TWMSGatewaySvc.ExpNotificationMsg(const AMsg: string);
begin
  mLog.Write(cExportMsgLog, AMsg);
end;

procedure TWMSGatewaySvc.ServiceAfterInstall(Sender: TService);
var
  Reg: TRegistry;
const
  cDescr = 'The service provide data exchange between ALAN and WMS databases';
begin
  Reg := TRegistry.Create(KEY_READ  or  KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Self.name, False) then
    begin
      Reg.WriteString('Description', cDescr);
      Reg.CloseKey ;
    end;
  finally
    FreeAndNil(Reg);
  end;
end;

procedure TWMSGatewaySvc.ServiceCreate(Sender: TObject);
begin
  mLog.Write(cSvcLog, 'Service create');
end;

procedure TWMSGatewaySvc.ServiceDestroy(Sender: TObject);
begin
  mLog.Write(cSvcLog, 'Service destroy');
end;

procedure TWMSGatewaySvc.ServiceExecute(Sender: TService);
begin
  while not Terminated do
  begin
    ServiceThread.ProcessRequests(False);
    TThread.Sleep(1000);
  end;
end;

procedure TWMSGatewaySvc.ServiceStart(Sender: TService; var Started: Boolean);
begin
  mLog.Write(cSvcLog, 'Service start');

  StartGateway;
  Started := True;
end;

procedure TWMSGatewaySvc.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  mLog.Write(cSvcLog, 'Service stop');
  StopGateway;

  mLog.Write(cSvcLog, 'Service stopped');
  Stopped := True;
end;

procedure TWMSGatewaySvc.StartGateway;
begin
  FImporter := TImporterThread.Create(cCreateRunning, ImpNotificationMsg, tknDriven);
  Sleep(100);
  FExporter := TExporterThread.Create(cCreateRunning, ExpNotificationMsg, tknDriven);
end;

procedure TWMSGatewaySvc.StopGateway;
begin
  FImporter.Terminate;
  FExporter.Terminate;

  FImporter.WaitFor(c1Minute * 2);
  FExporter.WaitFor(c1Minute * 2);

  FreeAndNil(FImporter);
  FreeAndNil(FExporter);
end;

initialization
  mLog := TLog.Create;

finalization
  FreeAndNil(mLog);

end.
