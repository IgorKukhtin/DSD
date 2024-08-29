program WmsMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain},
  FMX.UtilConst in '..\SOURCE FMX\COMPONENT\FMX.UtilConst.pas',
  uDM in 'uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  dsdXML_Version:= '1.0';

  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.


