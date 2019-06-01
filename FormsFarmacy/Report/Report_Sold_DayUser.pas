unit Report_Sold_DayUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Report_Sold_Day, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxCalendar, cxCurrencyEdit, cxClasses, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, dsdGuides, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems,
  dxBar, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore,
  cxButtonEdit, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, Vcl.ExtCtrls,
  cxCustomPivotGrid, cxDBPivotGrid, cxGridChartView, cxGridDBChartView,
  cxSplitter, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter;

type
  TReport_Sold_DayUserForm = class(TReport_Sold_DayForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_Sold_DayUserForm: TReport_Sold_DayUserForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Sold_DayUserForm);

end.
