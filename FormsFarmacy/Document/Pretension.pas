unit Pretension;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxCurrencyEdit, dsdAddOn,
  dsdAction, cxCheckBox, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, cxImageComboBox,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxMemo;

type
  TPretensionForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrintTTN: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    Summ: TcxGridDBColumn;
    edPriceWithVAT: TcxCheckBox;
    cxLabel10: TcxLabel;
    edNDSKind: TcxButtonEdit;
    NDSKindGuides: TdsdGuides;
    Price: TcxGridDBColumn;
    actRefreshGoodsCode: TdsdExecStoredProc;
    bbRefreshGoodsCode: TdxBarButton;
    spIncome_GoodsId: TdsdStoredProc;
    cxLabel5: TcxLabel;
    AmountInIncome: TcxGridDBColumn;
    Remains: TcxGridDBColumn;
    WarningColor: TcxGridDBColumn;
    cxLabel12: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel13: TcxLabel;
    deIncomeOperDate: TcxDateEdit;
    mactEditPartnerData: TMultiAction;
    dxBarButton1: TdxBarButton;
    actPartnerDataDialog: TExecuteDialog;
    spUpdatePretension_PartnerData: TdsdStoredProc;
    actUpdatePretension_PartnerData: TdsdExecStoredProc;
    actPrintTTN: TdsdPrintAction;
    AmountOther: TcxGridDBColumn;
    actComplete: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    cbisDeferred: TcxCheckBox;
    spUpdate_isDeferred_No: TdsdStoredProc;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    spUpdateisDeferredNo: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    DeferredSend: TcxGridDBColumn;
    DeferredOut: TcxGridDBColumn;
    actPrintOptima: TdsdPrintAction;
    bbPrintOptima: TdxBarButton;
    edIncome: TcxTextEdit;
    cxmComment: TcxMemo;
    cxLabel6: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TPretensionForm);

end.
