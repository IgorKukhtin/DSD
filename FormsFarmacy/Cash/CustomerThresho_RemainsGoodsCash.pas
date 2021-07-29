unit CustomerThresho_RemainsGoodsCash;

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
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls,
  cxCurrencyEdit, cxButtonEdit;

type
  TCustomerThresho_RemainsGoodsCashForm = class(TAncestorDBGridForm)
    bbOpen: TdxBarButton;
    FormParams: TdsdFormParams;
    Amount: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    Panel1: TPanel;
    cxLabel1: TcxLabel;
    edGoodsName: TcxTextEdit;
    cxLabel2: TcxLabel;
    edAmount: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    dsdExecStoredProc1: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    spSetRequestDistribListDiff: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCustomerThresho_RemainsGoodsCashForm);

end.
