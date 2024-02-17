program BoatMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain},
  uDM in 'uDM.pas' {DM: TDataModule},
  UtilConst in 'Components\UtilConst.pas',
  FMX.DataWedgeBarCode in 'Components\FMX.DataWedgeBarCode.pas';

{$R *.res}

begin
  dsdProject := prBoat;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
