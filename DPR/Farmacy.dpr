program Farmacy;

uses
  Windows,
  Vcl.Forms,
  Controls,
  SysUtils,
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  Storage in '..\SOURCE\Storage.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  FormStorage in '..\SOURCE\FormStorage.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  UnilWin in '..\SOURCE\UnilWin.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  ClientBankLoad in '..\SOURCE\COMPONENT\ClientBankLoad.pas',
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  Document in '..\SOURCE\COMPONENT\Document.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  Log in '..\SOURCE\Log.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  VKDBFDataSet in '..\SOURCE\DBF\VKDBFDataSet.pas',
  VKDBFPrx in '..\SOURCE\DBF\VKDBFPrx.pas',
  VKDBFUtil in '..\SOURCE\DBF\VKDBFUtil.pas',
  VKDBFMemMgr in '..\SOURCE\DBF\VKDBFMemMgr.pas',
  VKDBFCrypt in '..\SOURCE\DBF\VKDBFCrypt.pas',
  VKDBFGostCrypt in '..\SOURCE\DBF\VKDBFGostCrypt.pas',
  VKDBFCDX in '..\SOURCE\DBF\VKDBFCDX.pas',
  VKDBFIndex in '..\SOURCE\DBF\VKDBFIndex.pas',
  VKDBFSorters in '..\SOURCE\DBF\VKDBFSorters.pas',
  VKDBFCollate in '..\SOURCE\DBF\VKDBFCollate.pas',
  VKDBFParser in '..\SOURCE\DBF\VKDBFParser.pas',
  VKDBFNTX in '..\SOURCE\DBF\VKDBFNTX.pas',
  VKDBFSortedList in '..\SOURCE\DBF\VKDBFSortedList.pas',
  cxGridAddOn in '..\SOURCE\DevAddOn\cxGridAddOn.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  EDI in '..\SOURCE\EDI\EDI.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  AboutBoxUnit in '..\SOURCE\AboutBoxUnit.pas' {AboutBox},
  MainForm in '..\FormsFarmacy\MainForm.pas' {MainForm},
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  ExternalDocumentLoad in '..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  UploadUnloadData in '..\FormsFarmacy\ConnectWithOld\UploadUnloadData.pas' {dmUnloadUploadData: TDataModule},
  LookAndFillSettings in '..\SOURCE\LookAndFillSettings.pas' {LookAndFillSettingsForm},
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  AncestorMain in '..\Forms\Ancestor\AncestorMain.pas' {AncestorMainForm},
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  FastReportAddOn in '..\SOURCE\COMPONENT\FastReportAddOn.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  dsdXMLTransform in '..\SOURCE\COMPONENT\dsdXMLTransform.pas',
  RepriceUnit in '..\FormsFarmacy\ConnectWithOld\RepriceUnit.pas' {RepriceUnitForm},
  RepriceChangeRetail in '..\FormsFarmacy\ConnectWithOld\RepriceChangeRetail.pas' {RepriceСhangeRetailForm},
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  LocalWorkUnit in '..\SOURCE\LocalWorkUnit.pas',
  RoleUnion in '..\Forms\RoleUnion.pas' {RoleUnionForm: TParentForm},
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  MEDOC_TLB in '..\SOURCE\MeDOC\MEDOC_TLB.pas',
  MeDocCOM in '..\SOURCE\MeDOC\MeDocCOM.pas',
  ExportSalesForSupp in '..\FormsFarmacy\MainUnitService\ExportSalesForSuppliers\ExportSalesForSupp.pas' {ExportSalesForSuppForm},
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  Report_Analysis_Remains_Selling in '..\FormsFarmacy\Report\Report_Analysis_Remains_Selling.pas' {Report_Analysis_Remains_SellingForm},
  Report_ImplementationPlanEmployee in '..\FormsFarmacy\Report\Report_ImplementationPlanEmployee.pas',
  Report_IncomeConsumptionBalance in '..\FormsFarmacy\Report\Report_IncomeConsumptionBalance.pas' {Report_IncomeConsumptionBalanceForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  RepriceUnit_test in '..\FormsFarmacy\ConnectWithOld\RepriceUnit_test.pas' {RepriceUnit_testForm},
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas',
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
  PUSHMessageFarmacy in '..\FormsFarmacy\System\PUSHMessageFarmacy.pas' {PUSHMessageFarmacyForm},
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  SearchRemainsVIP in '..\FormsFarmacy\Document\SearchRemainsVIP.pas' {SearchRemainsVIPForm},
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  SearchByCaption in '..\FormsFarmacy\System\SearchByCaption.pas' {SearchByCaptionForm},
  RepricePromoUnit in '..\FormsFarmacy\ConnectWithOld\RepricePromoUnit.pas' {RepricePromoUnitForm};

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  // !!! Real
  ConnectionPath := '..\INIT\farmacy_init.php';
  gc_ProgramName := 'Farmacy.exe';
  // !!! DEMO
  // ConnectionPath := 'Demo.php';
  // gc_ProgramName := 'FDemo.exe';

  TdsdApplication.Create;

  // Процесс аутентификации
  if gc_ProgramName = 'FDemo.exe' then
  begin
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'demo', 'demo', gc_User);
     TUpdater.AutomaticUpdateProgram;
     TUpdater.AutomaticCheckConnect;
     Application.CreateForm(TdmMain, dmMain);
     Application.CreateForm(TMainForm, MainFormInstance);
  end
  else

      with TLoginForm.Create(Application) do
      //Если все хорошо создаем главную форму Application.CreateForm();
      if ShowModal = mrOk then
      begin
        TUpdater.AutomaticUpdateProgram;
        if not FindCmdLineSwitch('skipcheckconnect') then
           TUpdater.AutomaticCheckConnect;
        //
        Application.CreateForm(TdmMain, dmMain);
        Application.CreateForm(TMainForm, MainFormInstance);
      end;
  //
  Application.Run;
end.
