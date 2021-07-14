unit CheckCombine;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxPCdxBarPopupMenu, cxImageComboBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit, cxButtonEdit, cxSplitter, Vcl.ExtCtrls, cxContainer,
  cxTextEdit, cxDBEdit, cxLabel;

type
  TCheckCombineForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actShowErased: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    Bayer: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    isCheckCombine: TcxGridDBColumn;
    DiscountCardNumber: TcxGridDBColumn;
    DiscountExternalName: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    BayerPhone: TcxGridDBColumn;
    NumberOrder: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    ConfirmedKindClientName: TcxGridDBColumn;
    bbConfirmedKind_Complete: TdxBarButton;
    bbConfirmedKind_UnComplete: TdxBarButton;
    Color_Calc: TcxGridDBColumn;
    Color_CalcDoc: TcxGridDBColumn;
    InvNumberSP: TcxGridDBColumn;
    MedicSP: TcxGridDBColumn;
    SPKindName: TcxGridDBColumn;
    SPTax: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    actCheckCash: TdsdOpenForm;
    dxBarButton4: TdxBarButton;
    PartionDateKindName: TcxGridDBColumn;
    DateDelay: TcxGridDBColumn;
    ListPartionDateKindName: TcxGridDBColumn;
    spSmashCheck: TdsdStoredProc;
    dxBarButton5: TdxBarButton;
    bbUpdateOperDate: TdxBarButton;
    spUpdateCheckCombine: TdsdStoredProc;
    SummCard: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    dxBarButton6: TdxBarButton;
    AccommodationName: TcxGridDBColumn;
    bbUpdateNotMCS: TdxBarButton;
    isNotMCS: TcxGridDBColumn;
    Panel1: TPanel;
    MainCheckDS: TDataSource;
    MainCheckCDS: TClientDataSet;
    MainCheckItemDS: TDataSource;
    MainCheckItemCDS: TClientDataSet;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    maGoodsCode: TcxGridDBColumn;
    maGoodsName: TcxGridDBColumn;
    maAmount: TcxGridDBColumn;
    maPrice: TcxGridDBColumn;
    maPriceSale: TcxGridDBColumn;
    maChangePercent: TcxGridDBColumn;
    maSummChangePercent: TcxGridDBColumn;
    maAmountOrder: TcxGridDBColumn;
    maPartionDateKindName: TcxGridDBColumn;
    maAccommodationName: TcxGridDBColumn;
    maColor_Calc: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    cxLabel1: TcxLabel;
    cxDBTextEdit1: TcxDBTextEdit;
    cxDBTextEdit2: TcxDBTextEdit;
    cxLabel2: TcxLabel;
    cxDBTextEdit3: TcxDBTextEdit;
    cxLabel3: TcxLabel;
    cxDBTextEdit4: TcxDBTextEdit;
    cxLabel4: TcxLabel;
    matCheckCombine: TMultiAction;
    actCheckCombine: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TCheckCombineForm)

end.
