program repl_xe2;

uses
  Vcl.Forms,
  UCommandData in '..\Replicator\UCommandData.pas',
  UCommon in '..\Replicator\UCommon.pas',
  UConstants in '..\Replicator\UConstants.pas',
  UData in '..\Replicator\UData.pas' {dmData: TDataModule},
  UDefinitions in '..\Replicator\UDefinitions.pas',
  UFileVersion in '..\Replicator\UFileVersion.pas',
  UImages in '..\Replicator\UImages.pas' {dmImages: TDataModule},
  ULog in '..\Replicator\ULog.pas',
  UMain in '..\Replicator\UMain.pas' {frmMain},
  UScriptFiles in '..\Replicator\UScriptFiles.pas',
  USettings in '..\Replicator\USettings.pas',
  USnapshotThread in '..\Replicator\USnapshotThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmImages, dmImages);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
