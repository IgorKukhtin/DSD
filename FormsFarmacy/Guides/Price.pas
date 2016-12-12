unit Price;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.ExtCtrls, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxCurrencyEdit, ExternalLoad, cxPCdxBarPopupMenu, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxLabel, cxDropDownEdit, cxCalendar, cxCheckBox;

type
  TPriceForm = class(TAncestorEnumForm)
    dxBarControlContainerItemUnit: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    dxBarButton1: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    clDateChange: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    dsdUpdatePrice: TdsdUpdateDataSet;
    rdUnit: TRefreshDispatcher;
    clMCSValue: TcxGridDBColumn;
    clMCSDateChange: TcxGridDBColumn;
    actStartLoadMCS: TMultiAction;
    actDoLoadMCS: TExecuteImportSettingsAction;
    dxBarButton3: TdxBarButton;
    spGetImportSetting_MCS: TdsdStoredProc;
    actGetImportSetting_MCS: TdsdExecStoredProc;
    spGetImportSetting_Price: TdsdStoredProc;
    actGetImportSetting_Price: TdsdExecStoredProc;
    actDoLoadPrice: TExecuteImportSettingsAction;
    actStartLoadPrice: TMultiAction;
    dxBarButton4: TdxBarButton;
    clMCSIsClose: TcxGridDBColumn;
    clMCSNotRecalc: TcxGridDBColumn;
    spRecalcMCS: TdsdStoredProc;
    actRecalcMCS: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    actStartRecalcMCS: TMultiAction;
    actRecalcMCSDialog: TExecuteDialog;
    colRemains: TcxGridDBColumn;
    spDelete_Object_MCS: TdsdStoredProc;
    actDelete_Object_MCS: TdsdExecStoredProc;
    dxBarButton6: TdxBarButton;
    colFix: TcxGridDBColumn;
    colMCSIsCloseDateChange: TcxGridDBColumn;
    colMCSNotRecalcDateChange: TcxGridDBColumn;
    colFixDateChange: TcxGridDBColumn;
    actPriceHistoryOpen: TdsdOpenForm;
    dxBarButton7: TdxBarButton;
    Panel: TPanel;
    deOperDate: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel1: TcxLabel;
    ExecuteDialog: TExecuteDialog;
    StartDate: TcxGridDBColumn;
    SummaRemains: TcxGridDBColumn;
    clGoods_isTop: TcxGridDBColumn;
    dsdOpenForm: TdsdOpenForm;
    bbOpenForm: TdxBarButton;
    cxLabel2: TcxLabel;
    ceGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    Color_ExpirationDate: TcxGridDBColumn;
    colIdBarCode: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceForm: TPriceForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceForm)
end.
