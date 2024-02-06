program EDIOrdersLoader;

uses
  Vcl.Forms,
  Storage,
  SysUtils,
  Authentication,
  CommonData,
  EDIOrdersLoader.Main in '..\EDIOrdersLoader\EDIOrdersLoader.Main.pas' {MainForm},
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  Log in '..\SOURCE\Log.pas',
  UtilConst in '..\SOURCE\UtilConst.pas',
  DOCUMENTINVOICE_PRN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_PRN_XML.pas',
  DOCUMENTINVOICE_TN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_TN_XML.pas',
  PdfiumCore in '..\SOURCE\Pdfium\PdfiumCore.pas',
  PdfiumCtrl in '..\SOURCE\Pdfium\PdfiumCtrl.pas',
  PdfiumLib in '..\SOURCE\Pdfium\PdfiumLib.pas',
  DOCUMENTINVOICE_DRN_XML in '..\SOURCE\EDI\fozzy\DOCUMENTINVOICE_DRN_XML.pas',
  EUSignCP in '..\SOURCE\EUSignCP\EUSignCP.pas',
  EUSignCPOwnUI in '..\SOURCE\EUSignCP\EUSignCPOwnUI.pas';

{$R *.res}

begin
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
//  Logger.Enabled:= TRUE;

//  gc_isDebugMode:= TRUE;
//  gc_isShowTimeMode:= TRUE;

  Application.MainFormOnTaskbar := True;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '����-�������� EDI', '��������123EDI', gc_User);
  //TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', 'qsxqsxw1', gc_User);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
