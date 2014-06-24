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
  PriceListGoodsItem in '..\..\Forms\Guides\PriceListGoodsItem.pas' {PriceListGoodsItemForm},
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
  dbTest in '..\SOURCE\dbTest.pas',
  ChoicePeriod in '..\..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  Defaults in '..\..\SOURCE\COMPONENT\Defaults.pas',
  UnilWin in '..\..\SOURCE\UnilWin.pas',
  MessagesUnit in '..\..\SOURCE\MessagesUnit.pas' {MessagesForm},
  SimpleGauge in '..\..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  ClientBankLoad in '..\..\SOURCE\COMPONENT\ClientBankLoad.pas',
  Document in '..\..\SOURCE\COMPONENT\Document.pas',
  ExternalLoad in '..\..\SOURCE\COMPONENT\ExternalLoad.pas',
  Log in '..\..\SOURCE\Log.pas',
  ExternalData in '..\..\SOURCE\COMPONENT\ExternalData.pas',
  ExternalSave in '..\..\SOURCE\COMPONENT\ExternalSave.pas',
  VKDBFDataSet in '..\..\SOURCE\DBF\VKDBFDataSet.pas',
  VKDBFPrx in '..\..\SOURCE\DBF\VKDBFPrx.pas',
  VKDBFUtil in '..\..\SOURCE\DBF\VKDBFUtil.pas',
  VKDBFMemMgr in '..\..\SOURCE\DBF\VKDBFMemMgr.pas',
  VKDBFCrypt in '..\..\SOURCE\DBF\VKDBFCrypt.pas',
  VKDBFGostCrypt in '..\..\SOURCE\DBF\VKDBFGostCrypt.pas',
  VKDBFCDX in '..\..\SOURCE\DBF\VKDBFCDX.pas',
  VKDBFIndex in '..\..\SOURCE\DBF\VKDBFIndex.pas',
  VKDBFSorters in '..\..\SOURCE\DBF\VKDBFSorters.pas',
  VKDBFCollate in '..\..\SOURCE\DBF\VKDBFCollate.pas',
  VKDBFParser in '..\..\SOURCE\DBF\VKDBFParser.pas',
  VKDBFNTX in '..\..\SOURCE\DBF\VKDBFNTX.pas',
  VKDBFSortedList in '..\..\SOURCE\DBF\VKDBFSortedList.pas',
  ObjectTest in '..\SOURCE\Objects\ObjectTest.pas',
  cxGridAddOn in '..\..\SOURCE\DevAddOn\cxGridAddOn.pas',
  MeDOC in '..\..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\..\SOURCE\MeDOC\MeDocXML.pas',
  ComDocXML in '..\..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\..\SOURCE\EDI\DesadvXML.pas',
  EDI in '..\..\SOURCE\EDI\EDI.pas',
  OrderXML in '..\..\SOURCE\EDI\OrderXML.pas';

{$R *.res}

begin
  ConnectionPath := '..\INIT\farmacy_init.php';
  CreateStructurePath := '..\DATABASE\FARMACY\STRUCTURE\';

  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.Run;

  DUnitTestRunner.RunRegisteredTests;
end.
