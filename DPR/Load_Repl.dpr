program Load_Repl;

uses
  Forms,
  SysUtils,
  Storage in '..\SOURCE\Storage.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
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
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  EDI in '..\SOURCE\EDI\EDI.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  cxGridAddOn in '..\SOURCE\DevAddOn\cxGridAddOn.pas',
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
  ExternalDocumentLoad in '..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  Main in '..\Load_Repl\Main.pas' {MainForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas',
  Medoc1201007 in '..\SOURCE\MeDOC\Medoc1201007.pas',
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas';

{$R *.res}

begin
  Application.Initialize;
  ConnectionPath := '..\INIT\init_repl.php';
  Logger.Enabled := FindCmdLineSwitch('log');
  gc_ProgramName := 'Load_repl.exe';

  Application.CreateForm(TMainForm, MainForm);
  MainForm.Show;

  Application.Run;

end.
