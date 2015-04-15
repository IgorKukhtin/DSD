program FarmacyCash;

uses
  Vcl.Forms,
  SysUtils,
  UtilConst in '..\SOURCE\UtilConst.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  Log in '..\SOURCE\Log.pas',
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  Storage in '..\SOURCE\Storage.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm};

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';

  TdsdApplication.Create;

  with TLoginForm.Create(Application) do
  //≈сли все хорошо создаем главную форму Application.CreateForm();
  if ShowModal = mrOk then
  begin
     TUpdater.AutomaticUpdateProgram;
     TUpdater.AutomaticCheckConnect;
     Application.CreateForm(TdmMain, dmMain);
  end;
  Application.Run;
end.
