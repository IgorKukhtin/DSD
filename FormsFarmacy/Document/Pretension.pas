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
  cxMemo, cxCheckComboBox, Document;

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
    Summ: TcxGridDBColumn;
    edPriceWithVAT: TcxCheckBox;
    cxLabel10: TcxLabel;
    edNDSKind: TcxButtonEdit;
    NDSKindGuides: TdsdGuides;
    Price: TcxGridDBColumn;
    bbRefreshGoodsCode: TdxBarButton;
    cxLabel5: TcxLabel;
    AmountInIncome: TcxGridDBColumn;
    Remains: TcxGridDBColumn;
    WarningColor: TcxGridDBColumn;
    cxLabel12: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    cxLabel13: TcxLabel;
    deIncomeOperDate: TcxDateEdit;
    dxBarButton1: TdxBarButton;
    actPartnerDataDialog: TExecuteDialog;
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
    bbPrintOptima: TdxBarButton;
    edIncome: TcxTextEdit;
    cxmComment: TcxMemo;
    cxLabel6: TcxLabel;
    AmountDiff: TcxGridDBColumn;
    CheckedName: TcxGridDBColumn;
    spUpdate_BranchDate: TdsdStoredProc;
    spUpdate_ClearBranchDate: TdsdStoredProc;
    deBranchDate: TcxDateEdit;
    cxLabel7: TcxLabel;
    actUpdate_BranchDate: TdsdExecStoredProc;
    actUpdate_ClearBranchDate: TdsdExecStoredProc;
    actDataChoiceDialog: TExecuteDialog;
    dxBarButton5: TdxBarButton;
    ReasonDifferencesName: TcxGridDBColumn;
    AmountIncome: TcxGridDBColumn;
    Panel2: TPanel;
    Panel3: TPanel;
    cxLabel8: TcxLabel;
    cxGridFile: TcxGrid;
    cxGridDBTableViewFile: TcxGridDBTableView;
    chisErased: TcxGridDBColumn;
    chNumber: TcxGridDBColumn;
    chFileName: TcxGridDBColumn;
    cxGridLevelV: TcxGridLevel;
    Panel1: TPanel;
    FileCDS: TClientDataSet;
    FileDS: TDataSource;
    DBViewAddOnFile: TdsdDBViewAddOn;
    spSelectFile: TdsdStoredProc;
    dxBarButton6: TdxBarButton;
    actOpenFileDialog: TFileDialogAction;
    actAddFile: TdsdExecStoredProc;
    spAddFile: TdsdStoredProc;
    actRefreshFile: TdsdExecStoredProc;
    spUpdateFile: TdsdStoredProc;
    actUpdateFile: TdsdExecStoredProc;
    actErasedMIFile: TdsdUpdateErased;
    actUnErasedMIFile: TdsdUpdateErased;
    spErasedMIFile: TdsdStoredProc;
    spUnErasedMIFile: TdsdStoredProc;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    MovementItemProtocolFileOpenForm: TdsdOpenForm;
    dxBarButton11: TdxBarButton;
    actSendClipboard: TdsdSendClipboardAction;
    dxBarButton12: TdxBarButton;
    spGetData: TdsdStoredProc;
    actGetData: TdsdExecStoredProc;
    PartnerGoodsName: TcxGridDBColumn;
    spGetFTPParams: TdsdStoredProc;
    actSendFTPFile: TdsdFTP;
    actOpenFile: TdsdFTP;
    actGetFTPParams: TdsdExecStoredProc;
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
