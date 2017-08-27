program Load_Farmacy;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Storage in '..\..\SOURCE\Storage.pas',
  UtilConvert in '..\..\SOURCE\UtilConvert.pas',
  CommonData in '..\..\SOURCE\CommonData.pas',
  Authentication in '..\..\SOURCE\Authentication.pas',
  ParentForm in '..\..\SOURCE\ParentForm.pas' {ParentForm},
  FormStorage in '..\..\SOURCE\FormStorage.pas',
  dsdAction in '..\..\SOURCE\COMPONENT\dsdAction.pas',
  dsdAddOn in '..\..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdDB in '..\..\SOURCE\COMPONENT\dsdDB.pas',
  dsdGuides in '..\..\SOURCE\COMPONENT\dsdGuides.pas',
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
  cxGridAddOn in '..\..\SOURCE\DevAddOn\cxGridAddOn.pas',
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
  ComDocXML in '..\..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\..\SOURCE\EDI\DesadvXML.pas',
  EDI in '..\..\SOURCE\EDI\EDI.pas',
  MeDOC in '..\..\SOURCE\MeDOC\MeDOC.pas',
  MeDocXML in '..\..\SOURCE\MeDOC\MeDocXML.pas',
  ExternalDocumentLoad in '..\..\SOURCE\COMPONENT\ExternalDocumentLoad.pas',
  dsdInternetAction in '..\..\SOURCE\COMPONENT\dsdInternetAction.pas',
  OrderXML in '..\..\SOURCE\EDI\OrderXML.pas',
  OrdrspXML in '..\..\SOURCE\EDI\OrdrspXML.pas',
  InvoiceXML in '..\..\SOURCE\EDI\InvoiceXML.pas',
  dsdDataSetDataLink in '..\..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  dsdException in '..\..\SOURCE\dsdException.pas',
  StatusXML in '..\..\SOURCE\EDI\StatusXML.pas',
  RecadvXML in '..\..\SOURCE\EDI\RecadvXML.pas',
  UtilConst in '..\..\SOURCE\UtilConst.pas',
  IFIN_J1201209 in '..\..\SOURCE\MeDOC\IFIN_J1201209.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ConnectionPath := '..\INIT\farmacy_init.php';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
