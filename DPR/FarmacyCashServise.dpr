program FarmacyCashServise;

uses
  MidasLib,
  Vcl.Forms,
  System.SysUtils,
  Controls,
  FarmacyCashService in '..\FormsFarmacy\Cash\FarmacyCashService.pas' {MainCashForm2},
  UtilConst in '..\SOURCE\UtilConst.pas',
  dsdException in '..\SOURCE\dsdException.pas',
  Log in '..\SOURCE\Log.pas',
  dsdDB in '..\SOURCE\COMPONENT\dsdDB.pas',
  Storage in '..\SOURCE\Storage.pas',
  MessagesUnit in '..\SOURCE\MessagesUnit.pas' {MessagesForm},
  SimpleGauge in '..\SOURCE\SimpleGauge.pas' {SimpleGaugeForm},
  CommonData in '..\SOURCE\CommonData.pas',
  Authentication in '..\SOURCE\Authentication.pas',
  dsdAction in '..\SOURCE\COMPONENT\dsdAction.pas',
  dsdGuides in '..\SOURCE\COMPONENT\dsdGuides.pas',
  ParentForm in '..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAddOn in '..\SOURCE\COMPONENT\dsdAddOn.pas',
  dsdDataSetDataLink in '..\SOURCE\COMPONENT\dsdDataSetDataLink.pas',
  FormStorage in '..\SOURCE\FormStorage.pas',
  ChoicePeriod in '..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  UnilWin in '..\SOURCE\UnilWin.pas',
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
  EDI in '..\SOURCE\EDI\EDI.pas',
  Document in '..\SOURCE\COMPONENT\Document.pas',
  MeDOC in '..\SOURCE\MeDOC\MeDOC.pas',
  ComDocXML in '..\SOURCE\EDI\ComDocXML.pas',
  DeclarXML in '..\SOURCE\EDI\DeclarXML.pas',
  DesadvXML in '..\SOURCE\EDI\DesadvXML.pas',
  InvoiceXML in '..\SOURCE\EDI\InvoiceXML.pas',
  OrderXML in '..\SOURCE\EDI\OrderXML.pas',
  OrdrspXML in '..\SOURCE\EDI\OrdrspXML.pas',
  StatusXML in '..\SOURCE\EDI\StatusXML.pas',
  MeDocXML in '..\SOURCE\MeDOC\MeDocXML.pas',
  dsdInternetAction in '..\SOURCE\COMPONENT\dsdInternetAction.pas',
  LoginForm in '..\SOURCE\LoginForm.pas' {LoginForm},
  DataModul in '..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  Updater in '..\SOURCE\COMPONENT\Updater.pas',
  AncestorBase in '..\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  UtilConvert in '..\SOURCE\UtilConvert.pas',
  CashInterface in '..\FormsFarmacy\Cash\CashInterface.pas',
  IniUtils in '..\FormsFarmacy\Cash\IniUtils.pas',
  AncestorDialog in '..\Forms\Ancestor\AncestorDialog.pas' {AncestorDialogForm: TParentForm},
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  LocalWorkUnit in '..\SOURCE\LocalWorkUnit.pas',
  Splash in '..\FormsFarmacy\Cash\Splash.pas' {frmSplash},
  LocalStorage in '..\FormsFarmacy\Cash\LocalStorage.pas',
  IFIN_J1201009 in '..\SOURCE\MeDOC\IFIN_J1201009.pas',
  IFIN_J1201209 in '..\SOURCE\MeDOC\IFIN_J1201209.pas',
  dsdPivotGrid in '..\SOURCE\COMPONENT\dsdPivotGrid.pas',
  dsdExportToXLSAction in '..\SOURCE\COMPONENT\dsdExportToXLSAction.pas',
  Medoc_J1201010 in '..\SOURCE\MeDOC\Medoc_J1201010.pas',
  Medoc_J1201210 in '..\SOURCE\MeDOC\Medoc_J1201210.pas',
  dsdExportToXMLAction in '..\SOURCE\COMPONENT\dsdExportToXMLAction.pas',
  PUSHMessage in '..\SOURCE\COMPONENT\PUSHMessage.pas' {PUSHMessageForm},
  OrderSpFozzXML in '..\SOURCE\EDI\OrderSpFozzXML.pas',
  DesadvFozzXML in '..\SOURCE\EDI\DesadvFozzXML.pas',
  IftminFozzXML in '..\SOURCE\EDI\IftminFozzXML.pas',
  dsdTranslator in '..\SOURCE\COMPONENT\dsdTranslator.pas',
  UnitMyIP in '..\SOURCE\UnitMyIP.pas',
  StorageSQLite in '..\SOURCE\StorageSQLite.pas';

{$R *.res}

begin
  Application.ShowMainForm:=False;
  Application.MainFormOnTaskBar:=False;
  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';
  SQLiteFile := iniLocalDataBaseSQLite;
  dsdProject := prFarmacy;
  gc_ProgramName := 'FarmacyCashServise.exe';

  TdsdApplication.Create;

  with TLoginForm.Create(Application) do
  Begin
   // ќтключаем сохранение параметров
   cxPropertiesStore.Active := False;
   // «аполн€ем авторизационные пол€
   edUserName.Text:=ParamStr(1);
   edPassword.Text:=ParamStr(2);
    //≈сли все хорошо создаем главную форму Application.CreateForm();
   AllowLocalConnect := True;  // разрешаем локальный режим

     if ParamStr(2)<>'' then // ≈сли два параметра, то не спрашивать логин и пароль
       begin
        btnOkClick(btnOk);  // нажимаем проверку логина  если передали два параметра запуска
//       TAuthentication.CheckLogin(TStorageFactory.GetStorage, ParamStr(1), ParamStr(2), gc_User); // не работает вместе с AllowLocalConnect := True;
       end
      else
       if ShowModal <> mrOk then
       begin
        Free;
        exit;
       end;

    if not gc_User.Local and (ParamStr(2) = '') then
    Begin
      TUpdater.AutomaticUpdateProgram;
      if ParamStr(2) = '' then TUpdater.AutomaticCheckConnect;
    End
    else
      gc_isSetDefault := True;
     //
    Application.CreateForm(TdmMain, dmMain);
    Application.CreateForm(TMainCashForm2, MainCashForm2);
    StartCheckConnectThread(7);
  End;

  Application.Run;

end.
