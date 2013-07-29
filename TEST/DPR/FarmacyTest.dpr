program FarmacyTest;

uses
  Forms,
  DUnitTestRunner,
  dbCreateStructureTest in '..\SOURCE\STRUCTURE\dbCreateStructureTest.pas',
  dbMetadataTest in '..\SOURCE\METADATA\dbMetadataTest.pas',
  zLibUtil in '..\SOURCE\zLibUtil.pas',
  dbFarmacyProcedureTest in '..\SOURCE\dbFarmacyProcedureTest.pas',
  UtilConst in '..\..\SOURCE\UtilConst.pas',
  dbEnumTest in '..\SOURCE\dbEnumTest.pas',
  LoadFarmacyFormTest in '..\SOURCE\LoadFarmacyFormTest.pas',
  PriceListGoodsItem in '..\..\Forms\PriceListGoodsItem.pas' {PriceListGoodsItemForm},
  MeasureEdit in '..\..\Forms\MeasureEdit.pas' {MeasureEditForm},
  CommonData in '..\..\SOURCE\CommonData.pas',
  Authentication in '..\..\SOURCE\Authentication.pas',
  FormStorage in '..\..\SOURCE\FormStorage.pas',
  ParentForm in '..\..\SOURCE\ParentForm.pas' {ParentForm},
  Storage in '..\..\SOURCE\Storage.pas',
  UtilConvert in '..\..\SOURCE\UtilConvert.pas',
  dsdAction in '..\..\SOURCE\COMPONENT\dsdAction.pas',
  dsdAddOn in '..\..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdDB in '..\..\SOURCE\COMPONENT\dsdDB.pas',
  dsdGuides in '..\..\SOURCE\COMPONENT\dsdGuides.pas',
  DataModul in '..\..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  ExtraChargeCategories in '..\..\FarmacyForms\ExtraChargeCategories.pas' {ExtraChargeCategoriesForm},
  ExtraChargeCategoriesEdit in '..\..\FarmacyForms\ExtraChargeCategoriesEdit.pas' {ExtraChargeCategoriesEditForm},
  Goods in '..\..\FarmacyForms\Goods.pas' {GoodsForm},
  GoodsEdit in '..\..\FarmacyForms\GoodsEdit.pas' {GoodsEditForm},
  Units in '..\..\FarmacyForms\Units.pas' {UnitForm},
  UnitEdit in '..\..\FarmacyForms\UnitEdit.pas' {UnitEditForm},
  dbTest in '..\SOURCE\dbTest.pas';

{$R *.res}

begin
  ConnectionPath := '..\INIT\farmacy_init.php';
  CreateStructurePath := '..\DATABASE\FARMACY\STRUCTURE\';
  MetadataPath := '..\DATABASE\FARMACY\METADATA\Desc\';
  EnumPath := '..\DATABASE\FARMACY\METADATA\Enum\';

  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;

  DUnitTestRunner.RunRegisteredTests;
end.
