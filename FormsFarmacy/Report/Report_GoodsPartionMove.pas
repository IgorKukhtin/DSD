unit Report_GoodsPartionMove;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxButtonEdit, dsdGuides, dxBarBuiltInMenu, cxNavigator;

type
  TReport_GoodsPartionMoveForm = class(TAncestorReportForm)
    cxLabel4: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edParty: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GuidesGoods: TdsdGuides;
    GuidesParty: TdsdGuides;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colStartRemainsAmount: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    colInvNumber: TcxGridDBColumn;
    colIncomeAmount: TcxGridDBColumn;
    colOutcomeAmount: TcxGridDBColumn;
    colEndRemainsAmount: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization

  RegisterClass(TReport_GoodsPartionMoveForm);

end.
