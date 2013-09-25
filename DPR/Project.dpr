program Project;

uses
  Vcl.Forms,
  Controls,
  Classes,
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
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
  // Процесс аутентификации
  with TLoginForm.Create(Application) do
    //Если все хорошо создаем главную форму Application.CreateForm();
    if ShowModal = mrOk then begin
       Application.CreateForm(TMainFormInstance, MainFormInstance);
  Application.CreateForm(TdmMain, dmMain);
  end;
  Application.Run;
end.
