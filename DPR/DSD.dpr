program DSD;

uses
  Vcl.Forms,
  Controls,
  Classes,
  LoginFormUnit in '..\SOURCE\LoginFormUnit.pas' {LoginForm},
  StorageUnit in '..\SOURCE\StorageUnit.pas',
  AuthenticationUnit in '..\SOURCE\AuthenticationUnit.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonDataUnit in '..\SOURCE\CommonDataUnit.pas',
  MainFormUnit in '..\SOURCE\MainFormUnit.pas' {MainForm},
  FormUnit in '..\SOURCE\FormUnit.pas' {ParentForm},
  dsdDataSetWrapperUnit in '..\SOURCE\COMPONENT\dsdDataSetWrapperUnit.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  dsdActionUnit in '..\SOURCE\COMPONENT\dsdActionUnit.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  dsdGuidesUtilUnit in '..\SOURCE\COMPONENT\dsdGuidesUtilUnit.pas',
  FormStorageUnit in '..\SOURCE\FormStorageUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
         // Процесс аутентификации
 // with TLoginForm.Create(Application) do
    //Если все хорошо создаем главную форму Application.CreateForm();
   // if ShowModal = mrOk then
   TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);

   Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
end.
