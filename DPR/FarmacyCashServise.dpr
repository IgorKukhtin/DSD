program FarmacyCashServise;

uses
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
  CashCloseDialog in '..\FormsFarmacy\Cash\CashCloseDialog.pas' {CashCloseDialogForm: TParentForm},
  CashWork in '..\FormsFarmacy\Cash\CashWork.pas' {CashWorkForm},
  AncestorDialog in '..\Forms\Ancestor\AncestorDialog.pas' {AncestorDialogForm: TParentForm},
  dsdApplication in '..\SOURCE\dsdApplication.pas',
  ExternalLoad in '..\SOURCE\COMPONENT\ExternalLoad.pas',
  RecadvXML in '..\SOURCE\EDI\RecadvXML.pas',
  LocalWorkUnit in '..\SOURCE\LocalWorkUnit.pas',
  Splash in '..\FormsFarmacy\Cash\Splash.pas' {frmSplash}
//  , MainCash in '..\FormsFarmacy\Cash\MainCash.pas' {MainCashForm: TParentForm}
  ;

{$R *.res}

begin
//  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
//  Application.CreateForm(TMainCashForm, MainCashForm);
//  Application.Run;

  Application.Initialize;
  Logger.Enabled := FindCmdLineSwitch('log');
  ConnectionPath := '..\INIT\farmacy_init.php';

  TdsdApplication.Create;

  with TLoginForm.Create(Application) do
  Begin
    //Если все хорошо создаем главную форму Application.CreateForm();
    AllowLocalConnect := False; //True;

    if FindCmdLineSwitch('autologin', true)
    then begin
     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1111', gc_User);
     //TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1234', gc_User);
     gc_User.Local:=TRUE;// !!!НЕ ЗАГРУЖАЕТСЯ БАЗА!!!
    end
    else if ShowModal <> mrOk then exit;

//    gc_User := TUser.Create(ParamStr(1));
//    gc_User := TUser.Create('{5850E3FE-7EF9-4A55-96BD-98E3BEA4E60E}');
//     TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ1111', gc_User);

    begin
          if not gc_User.Local then
          Begin
            TUpdater.AutomaticUpdateProgram;
            TUpdater.AutomaticCheckConnect;
          End
          else
            gc_isSetDefault := True;
          //
  Application.CreateForm(TdmMain, dmMain);

  Application.CreateForm(TMainCashForm2, MainCashForm2);

  end;
  End;
  Application.Run;



end.
