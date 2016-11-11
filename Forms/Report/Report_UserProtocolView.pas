unit Report_UserProtocolView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Report_UserProtocol, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxCurrencyEdit, cxCalendar, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdDB, dsdGuides, dsdAddOn, ChoicePeriod, Vcl.Menus,
  dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxCheckBox, cxButtonEdit, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, Vcl.ExtCtrls, cxSplitter, cxGridChartView, cxGridDBChartView,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC;

type
  TReport_UserProtocolViewForm = class(TReport_UserProtocolForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_UserProtocolViewForm);

end.
