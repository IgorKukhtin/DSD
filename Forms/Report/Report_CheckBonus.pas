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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxImageComboBox;

type
  TReport_CheckBonusForm = class(TAncestorReportForm)
    clInvNumber_master: TcxGridDBColumn;
    clValue: TcxGridDBColumn;
    clSum_CheckBonus: TcxGridDBColumn;
    clPaidKindName: TcxGridDBColumn;
    clConditionKindName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clSum_Bonus: TcxGridDBColumn;
    clBonusKindName: TcxGridDBColumn;
    clInfoMoneyName_master: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edBonusKind: TcxButtonEdit;
    DocumentTaxKindGuides: TdsdGuides;
    clSum_BonusFact: TcxGridDBColumn;
    clInvNumber_child: TcxGridDBColumn;
    clInvNumber_find: TcxGridDBColumn;
    clInfoMoneyName_child: TcxGridDBColumn;
    clInfoMoneyName_find: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    actDocBonus: TdsdExecStoredProc;
    spInsertUpdate: TdsdStoredProc;
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
