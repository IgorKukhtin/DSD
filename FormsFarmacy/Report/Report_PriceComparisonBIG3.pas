unit Report_PriceComparisonBIG3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, Vcl.ExtCtrls, cxSplitter, cxDropDownEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarBuiltInMenu, cxNavigator, cxCalendar, cxCurrencyEdit, cxContainer,
  cxTextEdit, cxLabel, cxMaskEdit, cxGridBandedTableView,
  cxGridDBBandedTableView, dsdGuides, cxDBEdit;

type
  TReport_PriceComparisonBIG3Form = class(TAncestorDBGridForm)
    dsdUpdateMaster: TdsdUpdateDataSet;
    dsdSetErased: TdsdUpdateErased;
    dsdUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    actOpenUnit: TOpenChoiceForm;
    actOpenUser: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    Panel1: TPanel;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    edContractPriceList: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edAreaName: TcxTextEdit;
    GoodsCode: TcxGridDBBandedColumn;
    Price: TcxGridDBBandedColumn;
    GoodsName: TcxGridDBBandedColumn;
    Price1: TcxGridDBBandedColumn;
    D1: TcxGridDBBandedColumn;
    Price2: TcxGridDBBandedColumn;
    D2: TcxGridDBBandedColumn;
    Price3: TcxGridDBBandedColumn;
    D3: TcxGridDBBandedColumn;
    ContractPriceListGuides: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    cxLabel1: TcxLabel;
    cxDBTextEdit1: TcxDBTextEdit;
    cxDBTextEdit2: TcxDBTextEdit;
    cxDBTextEdit3: TcxDBTextEdit;
    cxDBTextEdit4: TcxDBTextEdit;
    cxLabel2: TcxLabel;
    cxDBTextEdit5: TcxDBTextEdit;
    cxDBTextEdit6: TcxDBTextEdit;
    cxLabel4: TcxLabel;
    ContractNameBest: TcxGridDBBandedColumn;
    DBest: TcxGridDBBandedColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_PriceComparisonBIG3Form);

end.
