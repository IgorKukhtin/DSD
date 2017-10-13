unit Report_Movement_AnotherRetail;

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
  cxCurrencyEdit, DataModul, frxClass, frxDBSet, dsdGuides, cxButtonEdit,
  dxSkinsCore, cxImageComboBox, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter;

type
  TReport_Movement_AnotherRetailForm = class(TAncestorReportForm)
    ItemName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    bbPrintOfficial: TdxBarButton;
    cxLabel6: TcxLabel;
    edGoods: TcxButtonEdit;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actOpenForm: TdsdOpenForm;
    actGetForm: TdsdExecStoredProc;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    spJuridicalBalance: TdsdStoredProc;
    bbPrint: TdxBarButton;
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    bbPrintTurnover: TdxBarButton;
    bbPrintCurrency: TdxBarButton;
    GuidesGoods: TdsdGuides;
    Статус: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_Movement_AnotherRetailForm)

end.
