unit CheckJackdawsGreenJournalCash;

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
  cxCurrencyEdit, cxButtonEdit, cxSplitter;

type
  TCheckJackdawsGreenJournalCashForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    dxBarButton1: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    PriceSale: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    bbConfirmedKind_Complete: TdxBarButton;
    bbConfirmedKind_UnComplete: TdxBarButton;
    Color_Calc: TcxGridDBColumn;
    Color_CalcDoc: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    dxBarButton4: TdxBarButton;
    ListPartionDateKindName: TcxGridDBColumn;
    dxBarButton5: TdxBarButton;
    bbUpdateOperDate: TdxBarButton;
    FormParams: TdsdFormParams;
    dxBarButton6: TdxBarButton;
    bbUpdateNotMCS: TdxBarButton;
    actCashCloseJeckdawsDialog: TdsdOpenStaticForm;
    dxBarButton7: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TCheckJackdawsGreenJournalCashForm)

end.
