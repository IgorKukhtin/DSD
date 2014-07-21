unit PriceListGoodsItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, ParentForm, dsdDB, dsdAction, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxCheckBox, dxSkinsCore,
  Vcl.ExtCtrls, cxPC, dxDockControl, dxDockPanel, cxContainer, dsdGuides,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxLabel, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxDropDownEdit, cxCalendar, cxCurrencyEdit;

type
  TPriceListGoodsItemForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    dsdStoredProc: TdsdStoredProc;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    cxGridDBTableView: TcxGridDBTableView;
    clStartDate: TcxGridDBColumn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel: TPanel;
    cxLabel1: TcxLabel;
    edPriceList: TcxButtonEdit;
    PriceListGuides: TdsdGuides;
    clEndDate: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPriceListGoodsItemForm);

end.
