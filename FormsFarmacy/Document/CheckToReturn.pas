unit CheckToReturn;

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
  Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar;

type
  TCheckToReturnForm = class(TAncestorDBGridForm)
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
    CashRegisterName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    StatusCode: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    bbConfirmedKind_Complete: TdxBarButton;
    bbConfirmedKind_UnComplete: TdxBarButton;
    Color_Calc: TcxGridDBColumn;
    Color_CalcDoc: TcxGridDBColumn;
    cxSplitter1: TcxSplitter;
    actCheckCash: TdsdOpenForm;
    dxBarButton4: TdxBarButton;
    PartionDateKindName: TcxGridDBColumn;
    ListPartionDateKindName: TcxGridDBColumn;
    dxBarButton5: TdxBarButton;
    bbUpdateOperDate: TdxBarButton;
    Panel1: TPanel;
    deOperDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    ceTotalSumm: TcxCurrencyEdit;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    dxBarButton6: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckToReturnForm: TCheckToReturnForm;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TCheckToReturnForm)

end.
