unit Report_CheckBonus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus;

type
  TReport_CheckBonusForm = class(TAncestorReportForm)
    cContract_InvNumber: TcxGridDBColumn;
    clValue: TcxGridDBColumn;
    clSum_CheckBonus: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    clContractConditionKindName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clSum_Bonus: TcxGridDBColumn;
    clBonusKindName: TcxGridDBColumn;
    clInfoMoneyName: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edBonusKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    clSum_BonusFact: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_CheckBonusForm);

end.
