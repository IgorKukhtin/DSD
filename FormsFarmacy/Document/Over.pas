unit Over;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, cxSplitter, dxBarBuiltInMenu, cxNavigator,
  cxCalc, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TOverForm = class(TAncestorDocumentForm)
    edUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chPrice: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    ChildDS: TDataSource;
    ChildCDS: TClientDataSet;
    DBViewChildAddOn: TdsdDBViewAddOn;
    chMCS: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    bbPrioritetPartner: TdxBarButton;
    chComment: TcxGridDBColumn;
    bbSetGoodsLink: TdxBarButton;
    bbDeleteLink: TdxBarButton;
    chMinExpirationDate: TcxGridDBColumn;
    mactDeleteLinkGroup: TMultiAction;
    mactDeleteLinkDS: TMultiAction;
    N2: TMenuItem;
    chRemains: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    MCS: TcxGridDBColumn;
    GoodsGroupName: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    actUpdateChildDS: TdsdUpdateDataSet;
    spInsertUpdateMIChild: TdsdStoredProc;
    AmountSend: TcxGridDBColumn;
    actUpdateAmount: TdsdExecStoredProc;
    spUpdate_MI_Over_Amount: TdsdStoredProc;
    macUpdateAmount: TMultiAction;
    bbUpdateAmount: TdxBarButton;
    macUpdateAmountSingl: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOverForm);

end.
