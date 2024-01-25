program GetEmail;

uses
  MidasLib,
  Vcl.Forms,
  SysUtils,
  Main in '..\FormsFarmacy\MainUnitService\GetEmail\Main.pas' {MainForm},
  Authentication in '..\SOURCE\Authentication.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  Log in '..\SOURCE\Log.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  Storage in '..\SOURCE\Storage.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  UnilWin in '..\SOURCE\UnilWin.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  cxGridAddOn in '..\SOURCE\DevAddOn\cxGridAddOn.pas',
  ExternalSave in '..\SOURCE\COMPONENT\ExternalSave.pas',
  ExternalData in '..\SOURCE\COMPONENT\ExternalData.pas',
  VKDBFCDX in '..\SOURCE\DBF\VKDBFCDX.pas',
  VKDBFCollate in '..\SOURCE\DBF\VKDBFCollate.pas',
  VKDBFCrypt in '..\SOURCE\DBF\VKDBFCrypt.pas',
  VKDBFDataSet in '..\SOURCE\DBF\VKDBFDataSet.pas',
  VKDBFGostCrypt in '..\SOURCE\DBF\VKDBFGostCrypt.pas',
  VKDBFIndex in '..\SOURCE\DBF\VKDBFIndex.pas',
  VKDBFMemMgr in '..\SOURCE\DBF\VKDBFMemMgr.pas',
  VKDBFNTX in '..\SOURCE\DBF\VKDBFNTX.pas',
  VKDBFParser in '..\SOURCE\DBF\VKDBFParser.pas',
  VKDBFPrx in '..\SOURCE\DBF\VKDBFPrx.pas',
  VKDBFSortedList in '..\SOURCE\DBF\VKDBFSortedList.pas',
  VKDBFSorters in '..\SOURCE\DBF\VKDBFSorters.pas',
  VKDBFUtil in '..\SOURCE\DBF\VKDBFUtil.pas',
  Defaults in '..\SOURCE\COMPONENT\Defaults.pas',
  Document in '..\SOURCE\COMPONENT\Document.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  EDI in '..\SOURCE\EDI\EDI.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  sevenzip in '..\FormsFarmacy\MainUnitService\GetEmail\sevenzip.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  zLibUtil in '..\TEST\SOURCE\zLibUtil.pas',
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  DOCUMENTINVOICE_PRN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_PRN_XML.pas',
  DOCUMENTINVOICE_TN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_TN_XML.pas',
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  DialogPswSms in '..\SOURCE\DialogPswSms.pas' {DialogPswSmsForm},
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201011 in '..\SOURCE\MeDOC\Medoc_J1201011.pas',
  Medoc_J1201012 in '..\SOURCE\MeDOC\Medoc_J1201012.pas',
  Medoc_J1201111 in '..\SOURCE\MeDOC\Medoc_J1201111.pas',
  Medoc_J1201112 in '..\SOURCE\MeDOC\Medoc_J1201112.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas',
  Medoc_J1201211 in '..\SOURCE\MeDOC\Medoc_J1201211.pas',
  Medoc_J1201212 in '..\SOURCE\MeDOC\Medoc_J1201212.pas',
  MEDOC_TLB in '..\SOURCE\MeDOC\MEDOC_TLB.pas',
  Medoc1201006 in '..\SOURCE\MeDOC\Medoc1201006.pas',
  Medoc1201007 in '..\SOURCE\MeDOC\Medoc1201007.pas',
  MeDocCOM in '..\SOURCE\MeDOC\MeDocCOM.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas';

{$R *.res}

begin
  dsdProject := prFarmacy;
  ConnectionPath := '..\INIT\farmacy_init.php';
  gc_ProgramName := 'Farmacy.exe';

  if FindCmdLineSwitch('realfarmacy', true)
  then gc_AdminPassword := 'Админ1234'
  else gc_AdminPassword := 'Админ1111';

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
