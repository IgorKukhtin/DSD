program MediCard;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  MediCard.Intf in '..\..\FormsFarmacy\DiscountService\MediCard.Intf.pas',
  MediCard.Dsgn in '..\..\FormsFarmacy\DiscountService\MediCard.Dsgn.pas',
  MediCard.Classes in '..\..\FormsFarmacy\DiscountService\MediCard.Classes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
