unit BankStatementJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, Vcl.Menus,
  dsdAddOn, ChoicePeriod, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, ClientBankLoad, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, ExternalLoad, cxButtonEdit, dsdGuides,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dsdCommon;

type
  TBankStatementJournalForm = class(TAncestorJournalForm)
    BankName: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    BankPrivatLoad: TClientBankLoadAction;
    BankForumLoad: TClientBankLoadAction;
    BankVostokLoad: TClientBankLoadAction;
    BankFidoLoad: TClientBankLoadAction;
    bbBankPrivat: TdxBarButton;
    bbBankVostok: TdxBarButton;
    bbBankForum: TdxBarButton;
    bbBankErnst: TdxBarButton;
    BankPrivat: TMultiAction;
    BankForum: TMultiAction;
    BankVostok: TMultiAction;
    BankFido: TMultiAction;
    BankOTPLoad: TClientBankLoadAction;
    BankOTP: TMultiAction;
    bbOTPLoad: TdxBarButton;
    bbPireus: TdxBarButton;
    BankPireus: TMultiAction;
    BankPireusLoad: TClientBankLoadAction;
    BankPireusDBF: TMultiAction;
    BankPireusDBFLoad: TClientBankLoadAction;
    bbPireusDBFLoad: TdxBarButton;
    BankMarfinLoad: TClientBankLoadAction;
    BankMarfin: TMultiAction;
    bbMarfinLoad: TdxBarButton;
    ProcreditBankLoad: TClientBankLoadAction;
    ProcreditBank: TMultiAction;
    bbProkreditBank: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    BankOTPXLSLoad: TClientBankLoadAction;
    BankOTPXLS: TMultiAction;
    bbBankOTPXLS: TdxBarButton;
    mRaiffeisenBankLoad: TMultiAction;
    RaiffeisenBankLoad: TClientBankLoadAction;
    bbRaiffeisenBankLoad: TdxBarButton;
    BankOshad: TMultiAction;
    BankOshadLoad: TClientBankLoadAction;
    bbBankOshad: TdxBarButton;
    actGetImportSetting_csv_Privat: TdsdExecStoredProc;
    spGetImportSettingId_Privat: TdsdStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    mactStartLoad_csv_Privat: TMultiAction;
    bbStartLoad_csv_Privat: TdxBarButton;
    dxBarSubItem1: TdxBarSubItem;
    actGetImportSetting_csv_Vostok: TdsdExecStoredProc;
    mactStartLoad_csv_Vostok: TMultiAction;
    bbStartLoad_csv_Vostok: TdxBarButton;
    JuridicalName: TcxGridDBColumn;
    spGetImportSettingId_Vostok: TdsdStoredProc;
    dxBarSeparator1: TdxBarSeparator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TBankStatementJournalForm);

end.
