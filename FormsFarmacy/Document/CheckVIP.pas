unit CheckVIP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC;

type
  TCheckVIPForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    dsdStoredProc1: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actShowErased: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colCashRegisterName: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colCashMember: TcxGridDBColumn;
    colBayer: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    actDeleteCheck: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckVIPForm: TCheckVIPForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCheckVIPForm)

end.
