program SendData_WMS;

uses
  Vcl.SvcMgr,
  Vcl.Forms,
  Winapi.Windows,
  System.SysUtils,
  Main in 'Main.pas' {MainForm},
  UData in 'UData.pas' {dmData: TDataModule},
  USettings in 'USettings.pas',
  UConstants in 'UConstants.pas',
  ULog in 'ULog.pas',
  UImportWMS in 'UImportWMS.pas',
  UDefinitions in 'UDefinitions.pas',
  UQryThread in 'UQryThread.pas',
  UCommon in 'UCommon.pas',
  UGatewaySvc in 'UGatewaySvc.pas' {WMSGatewaySvc: TService},
  UGateway in 'UGateway.pas',
  UFileVersion in 'UFileVersion.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  if USettings.IsService then
  begin
    if not Vcl.SvcMgr.Application.DelayInitialize or Vcl.SvcMgr.Application.Installing then
      Vcl.SvcMgr.Application.Initialize;
    Vcl.SvcMgr.Application.CreateForm(TWMSGatewaySvc, WMSGatewaySvc);
  Vcl.SvcMgr.Application.Run;
  end
  else
  begin
    Vcl.Forms.Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TdmData, dmData);
    Vcl.Forms.Application.Run;
  end;
end.
