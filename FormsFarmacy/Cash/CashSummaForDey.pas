unit CashSummaForDey;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls;

type
  TCashSummaForDeyForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    PaidTypeName: TcxGridDBColumn;
    SummCash: TcxGridDBColumn;
    SummCard: TcxGridDBColumn;
    cxGridNDS: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    NDS: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    Panel: TPanel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edCashRegisterName: TcxTextEdit;
    cxLabel1: TcxLabel;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashSummaForDeyForm);

end.
