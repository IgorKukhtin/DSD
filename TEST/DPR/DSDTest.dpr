program DSDTest;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Forms,
  DataModul in '..\..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  DropCreateDatabaseTestUnit in '..\SOURCE\DropCreateDatabaseTestUnit.pas',
  DataBaseStructureTestUnit in '..\SOURCE\DataBaseStructureTestUnit.pas',
  DataBaseUnit in '..\SOURCE\DataBaseUnit.pas' {Form1},
  AuthenticationUnit in '..\..\SOURCE\AuthenticationUnit.pas',
  StorageUnit in '..\..\SOURCE\StorageUnit.pas',
  AuthenticationTestUnit in '..\SOURCE\AuthenticationTestUnit.pas',
  UtilConst in '..\..\SOURCE\UtilConst.pas',
  DataBaseObjectTestUnit in '..\SOURCE\DataBaseObjectTestUnit.pas',
  UtilConvert in '..\..\SOURCE\UtilConvert.pas',
  DataBaseMovementTestUnit in '..\SOURCE\DataBaseMovementTestUnit.pas',
  dsdDataSetWrapperUnit in '..\..\SOURCE\COMPONENT\dsdDataSetWrapperUnit.pas',
  CommonDataUnit in '..\..\SOURCE\CommonDataUnit.pas',
  UtilUnit in '..\SOURCE\UtilUnit.pas',
  FarmacyStructureTestUnit in '..\SOURCE\Farmacy\FarmacyStructureTestUnit.pas',
  FarmacyTestUnit in '..\SOURCE\Farmacy\FarmacyTestUnit.pas',
  MeatGuidesTestUnit in '..\SOURCE\Meat\MeatGuidesTestUnit.pas',
  DataBaseUsersObjectTest in '..\SOURCE\DataBaseUsersObjectTest.pas',
  dsdGuidesUtilUnit in '..\..\SOURCE\COMPONENT\dsdGuidesUtilUnit.pas',
  LoadFormTestUnit in '..\SOURCE\LoadFormTestUnit.pas',
  FormStorageUnit in '..\..\SOURCE\FormStorageUnit.pas',
  BusinessEditUnit in '..\..\Forms\BusinessEditUnit.pas' {BusinessEditForm},
  GoodsGuidesUnit in '..\..\Forms\GoodsGuidesUnit.pas' {GoodsGuidesForm},
  GoodsPropertyEditUnit in '..\..\Forms\GoodsPropertyEditUnit.pas' {GoodsPropertyEditForm},
  GoodsPropertyUnit in '..\..\Forms\GoodsPropertyUnit.pas' {GoodsPropertyForm},
  BranchEditUnit in '..\..\Forms\BranchEditUnit.pas' {BranchEditForm},
  GoodsGroupEditUnit in '..\..\Forms\GoodsGroupEditUnit.pas' {GoodsGroupEditForm},
  MeasureEditUnit in '..\..\Forms\MeasureEditUnit.pas' {MeasureEditForm},
  MeasureUnit in '..\..\Forms\MeasureUnit.pas' {MeasureForm},
  FormUnit in '..\..\SOURCE\FormUnit.pas' {ParentForm},
  dsdActionUnit in '..\..\SOURCE\COMPONENT\dsdActionUnit.pas',
  BusinessUnit in '..\..\Forms\BusinessUnit.pas' {BusinessForm},
  BranchUnit in '..\..\Forms\BranchUnit.pas' {BranchForm},
  GoodstGroupUnit in '..\..\Forms\GoodstGroupUnit.pas' {GoodsGroupForm},
  JuridicalGroupEditUnit in '..\..\Forms\JuridicalGroupEditUnit.pas' {JuridicalGroupEditForm},
  JuridicalGroupUnit in '..\..\Forms\JuridicalGroupUnit.pas' {JuridicalGroupForm},
  JuridicalEditUnit in '..\..\Forms\JuridicalEditUnit.pas' {JuridicalEditForm},
  UnitEditUnit in '..\..\Forms\UnitEditUnit.pas' {UnitEditForm},
  UnitGroupEditUnit in '..\..\Forms\UnitGroupEditUnit.pas' {UnitGroupEditForm},
  UnitGroupUnit in '..\..\Forms\UnitGroupUnit.pas' {UnitGroupForm},
  UnitUnit in '..\..\Forms\UnitUnit.pas' {UnitForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;
  DUnitTestRunner.RunRegisteredTests;
end.

