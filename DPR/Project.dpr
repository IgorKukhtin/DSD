program Project;

uses
  Vcl.Forms,
  Controls,
  Classes,
  SysUtils,
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  Storage in '..\SOURCE\Storage.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  MainForm in '..\SOURCE\MainForm.pas' {MainForm},
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  AboutBoxUnit in '..\SOURCE\AboutBoxUnit.pas' {AboutBox},
  UnilWin in '..\SOURCE\UnilWin.pas',
  UtilTimeLogger in '..\SOURCE\UtilTimeLogger.pas',
  ClientBankLoad in '..\SOURCE\COMPONENT\ClientBankLoad.pas',
  MemDBFTable in '..\SOURCE\MemDBFTable.pas',
  SimpleGauge in '..\SOURCE\SimpleGauge.pas',
  FastReportAddOn in '..\SOURCE\COMPONENT\FastReportAddOn.pas',
  Document in '..\SOURCE\COMPONENT\Document.pas',
  dialogs,
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  ExternalDocumentLoad in '..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  Log in '..\SOURCE\Log.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas';

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');

  // ������� ��������������
  with TLoginForm.Create(Application) do
    //���� ��� ������ ������� ������� ����� Application.CreateForm();
    if ShowModal = mrOk then begin
       TUpdater.AutomaticUpdateProgram;
       Application.CreateForm(TMainForm, MainFormInstance);
  Application.CreateForm(TdmMain, dmMain);
  end;
  Application.Run;
end.
