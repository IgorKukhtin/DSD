program DSDFormContainer;

uses
  Vcl.Forms,
  Classes,
  DB,
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  BranchUnit in '..\Forms\BranchUnit.pas' {BranchForm},
  dsdDataSetWrapperUnit in '..\SOURCE\COMPONENT\dsdDataSetWrapperUnit.pas',
  StorageUnit in '..\SOURCE\StorageUnit.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  CommonDataUnit in '..\SOURCE\CommonDataUnit.pas',
  AuthenticationUnit in '..\SOURCE\AuthenticationUnit.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  dsdActionUnit in '..\SOURCE\COMPONENT\dsdActionUnit.pas',
  FormUnit in '..\SOURCE\FormUnit.pas' {ParentForm},
  JuridicalGroupEditUnit in '..\Forms\JuridicalGroupEditUnit.pas' {JuridicalGroupEditForm},
  FormContainerMainFormUnit in '..\SOURCE\FormContainerMainFormUnit.pas' {MainForm},
  JuridicalUnit in '..\Forms\JuridicalUnit.pas' {JuridicalForm},
  JuridicalEditUnit in '..\Forms\JuridicalEditUnit.pas' {JuridicalEditForm},
  dsdGuidesUtilUnit in '..\SOURCE\COMPONENT\dsdGuidesUtilUnit.pas',
  MeasureEditUnit in '..\Forms\MeasureEditUnit.pas' {MeasureEditForm},
  MeasureUnit in '..\Forms\MeasureUnit.pas' {MeasureForm},
  BusinessEditUnit in '..\Forms\BusinessEditUnit.pas' {BusinessEditForm},
  BusinessUnit in '..\Forms\BusinessUnit.pas' {BusinessForm},
  GoodsPropertyEditUnit in '..\Forms\GoodsPropertyEditUnit.pas' {GoodsPropertyEditForm},
  GoodsPropertyUnit in '..\Forms\GoodsPropertyUnit.pas' {GoodsPropertyForm},
  FormStorageUnit in '..\SOURCE\FormStorageUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TJuridicalGroupEditForm, JuridicalGroupEditForm);
  Application.CreateForm(TBranchForm, BranchForm);
  Application.CreateForm(TJuridicalForm, JuridicalForm);
  Application.CreateForm(TJuridicalEditForm, JuridicalEditForm);
  Application.CreateForm(TMeasureEditForm, MeasureEditForm);
  Application.CreateForm(TMeasureForm, MeasureForm);
  Application.CreateForm(TBusinessEditForm, BusinessEditForm);
  Application.CreateForm(TBusinessForm, BusinessForm);
  Application.CreateForm(TGoodsPropertyEditForm, GoodsPropertyEditForm);
  Application.CreateForm(TGoodsPropertyForm, GoodsPropertyForm);
  Application.Run;
end.
