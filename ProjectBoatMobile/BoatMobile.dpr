program BoatMobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain},
  uDM in 'uDM.pas' {DM: TDataModule},
  FMX.UtilConst in '..\SOURCE FMX\COMPONENT\FMX.UtilConst.pas';

{$R *.res}

begin
  dsdProject := prBoat;
  dsdHTTPCharSet := csUTF_8;
  dsdXML_Version := '1.0';
  dsdXML_SufixUTF8 := True;

  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.


