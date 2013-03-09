program DSDFormContainer;

uses
  Vcl.Forms,
  Classes,
  DB,
  MeasureUnit in '..\Forms\MeasureUnit.pas' {MeasureForm},
  dsdDataSetWrapperUnit in '..\SOURCE\COMPONENT\dsdDataSetWrapperUnit.pas',
  StorageUnit in '..\SOURCE\StorageUnit.pas',
  UtilType in '..\SOURCE\UtilType.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonDataUnit in '..\SOURCE\CommonDataUnit.pas',
  AuthenticationUnit in '..\SOURCE\AuthenticationUnit.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  dsdActionUnit in '..\SOURCE\COMPONENT\dsdActionUnit.pas',
  FormUnit in '..\SOURCE\FormUnit.pas' {ParentForm},
  MeasureEditUnit in '..\Forms\MeasureEditUnit.pas' {MeasureEditForm},
  FormContainerMainFormUnit in '..\SOURCE\FormContainerMainFormUnit.pas' {MainForm},
  ClientUnit in '..\Forms\ClientUnit.pas' {ParentForm1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMeasureEditForm, MeasureEditForm);
  Application.CreateForm(TMeasureForm, MeasureForm);
  Application.CreateForm(TParentForm1, ParentForm1);
  Application.Run;
end.
