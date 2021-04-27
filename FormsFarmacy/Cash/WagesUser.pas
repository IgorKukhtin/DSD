unit WagesUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxGridBandedTableView, cxGridDBBandedTableView, DataModul, cxCurrencyEdit,
  cxMemo, cxButtonEdit, Vcl.StdCtrls, cxButtons;

type
  TWagesUserForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    Panel: TPanel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    PanelBottom: TPanel;
    ceTotal: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceCard: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    ceOnHand: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    actDataDialog: TExecuteDialog;
    dxBarButton2: TdxBarButton;
    UnitName: TcxGridDBColumn;
    PayrollTypeName: TcxGridDBColumn;
    DateCalculation: TcxGridDBColumn;
    AmountAccrued: TcxGridDBColumn;
    Formula: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel5: TcxLabel;
    ceHolidaysHospital: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceDirector: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel16: TcxLabel;
    edAttempts: TcxTextEdit;
    cxLabel8: TcxLabel;
    edStatus: TcxTextEdit;
    cxLabel9: TcxLabel;
    edDateTimeTest: TcxDateEdit;
    cxLabel10: TcxLabel;
    ceResult: TcxCurrencyEdit;
    ceSummaCleaning: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ceSummaSP: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    ceSummaOther: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceSummaValidationResults: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    ceSummaTotal: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    cxLabel17: TcxLabel;
    ceSUN1: TcxCurrencyEdit;
    cxLabel18: TcxLabel;
    edPasswordEHels: TcxTextEdit;
    cxLabel19: TcxLabel;
    ceSummaTechnicalRediscount: TcxCurrencyEdit;
    cxLabel20: TcxLabel;
    ceIlliquidAssets: TcxCurrencyEdit;
    cxLabel21: TcxLabel;
    ceSummaMoneyBox: TcxCurrencyEdit;
    cxLabel22: TcxLabel;
    ceSummaFullCharge: TcxCurrencyEdit;
    cxLabel23: TcxLabel;
    ceSummaMoneyBoxUsed: TcxCurrencyEdit;
    cxLabel24: TcxLabel;
    cePenaltySUN: TcxCurrencyEdit;
    cxLabel25: TcxLabel;
    ceSummaFine: TcxCurrencyEdit;
    cxLabel26: TcxLabel;
    ceIntentionalPeresort: TcxCurrencyEdit;
    cxLabel27: TcxLabel;
    actListGoodsBadTiming: TdsdOpenStaticForm;
    ceMarketing: TcxCurrencyEdit;
    actDblClickMarketing: TdsdDblClickAction;
    deDateCalculation: TcxDateEdit;
    cxLabel28: TcxLabel;
    actFormClose: TdsdFormClose;
    cxLabel29: TcxLabel;
    ceMarketingRepayment: TcxCurrencyEdit;
    actDblClickIlliquidMarketing: TdsdDblClickAction;
    actListGoodsIlliquidMarketing: TdsdOpenStaticForm;
    ceIlliquidAssetsRepayment: TcxCurrencyEdit;
    cxLabel30: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TWagesUserForm);

end.
