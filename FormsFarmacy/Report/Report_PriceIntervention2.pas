unit Report_PriceIntervention2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox, cxGridBandedTableView,
  cxGridDBBandedTableView, cxSplitter;

type
  TReport_PriceIntervention2Form = class(TAncestorReportForm)
    bbExecuteDialog: TdxBarButton;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cePrice1: TcxCurrencyEdit;
    cePrice2: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel12: TcxLabel;
    cePrice5: TcxCurrencyEdit;
    cePrice6: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    cePrice3: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
    cePrice4: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    ceMarginReport: TcxButtonEdit;
    MarginReportGuides: TdsdGuides;
    MarginReportItemOpenForm: TdsdOpenForm;
    ExecuteDialog: TExecuteDialog;
    spInsertUpdate: TdsdStoredProc;
    bb: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBColumn1: TcxGridDBColumn;
    cxGridDBColumn2: TcxGridDBColumn;
    cxGridDBColumn3: TcxGridDBColumn;
    cxGridDBColumn4: TcxGridDBColumn;
    cxGridDBColumn5: TcxGridDBColumn;
    cxGridDBColumn6: TcxGridDBColumn;
    cxGridDBColumn7: TcxGridDBColumn;
    cxGridDBColumn8: TcxGridDBColumn;
    cxGridDBColumn9: TcxGridDBColumn;
    cxGridDBColumn10: TcxGridDBColumn;
    cxGridDBColumn11: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DBViewAddOn1: TdsdDBViewAddOn;
    MasterCDS1: TClientDataSet;
    MasterDS1: TDataSource;
    spSelectMaster: TdsdStoredProc;
    cxSplitter: TcxSplitter;
    actInsertUpdate: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_PriceIntervention2Form: TReport_PriceIntervention2Form;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_PriceIntervention2Form)
end.
