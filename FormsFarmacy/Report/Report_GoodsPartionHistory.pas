unit Report_GoodsPartionHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdGuides,
  cxButtonEdit, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView, cxGrid, cxPC;

type
  TReport_GoodsPartionHistoryForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edParty: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesGoods: TdsdGuides;
    GuidesParty: TdsdGuides;
    colMovementId: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colMovementDescId: TcxGridDBColumn;
    colMovementDescName: TcxGridDBColumn;
    colFromId: TcxGridDBColumn;
    colFromName: TcxGridDBColumn;
    colToId: TcxGridDBColumn;
    colToName: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colAmountIn: TcxGridDBColumn;
    colAmountOut: TcxGridDBColumn;
    colAmountInvent: TcxGridDBColumn;
    colMCSValue: TcxGridDBColumn;
    colSaldo: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_GoodsPartionHistoryForm: TReport_GoodsPartionHistoryForm;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_GoodsPartionHistoryForm);
end.
