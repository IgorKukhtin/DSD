unit JuridicalOrderFinance;

interface

uses
  DataModul, Winapi.Windows, ParentForm, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxCurrencyEdit, cxCheckBox,
  dsdAddOn, dsdDB, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, Datasnap.DBClient, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  Vcl.Controls, cxGrid, AncestorGuides, cxPCdxBarPopupMenu, Vcl.Menus, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
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
  dxSkinXmas2008Blue, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxLabel, Vcl.ExtCtrls;

type
  TJuridicalOrderFinanceForm = class(TAncestorGuidesForm)
    isErased: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    bbShowDel: TdxBarButton;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    bbIn: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    FormParams: TdsdFormParams;
    JuridicalName: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    BankAccountName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    Panel: TPanel;
    cxLabel3: TcxLabel;
    edBank: TcxButtonEdit;
    GuidesBank: TdsdGuides;
    cxLabel2: TcxLabel;
    edBankAccount: TcxButtonEdit;
    GuidesBankAccount: TdsdGuides;
    spInsert_byMovBankAccount: TdsdStoredProc;
    ExecuteDialog: TExecuteDialog;
    spGetPeriod: TdsdStoredProc;
    macInsert_byMovBankAccount: TMultiAction;
    actInsert_byMovBankAccount: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    bbInsert_byMovBankAccount: TdxBarButton;
    Comment: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TJuridicalOrderFinanceForm);

end.
