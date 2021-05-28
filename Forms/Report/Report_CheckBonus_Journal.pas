unit Report_CheckBonus_Journal;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxImageComboBox,
  cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TReport_CheckBonus_JournalForm = class(TAncestorReportForm)
    InvNumber_master: TcxGridDBColumn;
    Value: TcxGridDBColumn;
    Sum_CheckBonus: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    ConditionKindName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    Sum_Bonus: TcxGridDBColumn;
    BonusKindName: TcxGridDBColumn;
    InfoMoneyName_master: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edBonusKind: TcxButtonEdit;
    GuidesDocumentBonusKind: TdsdGuides;
    Sum_BonusFact: TcxGridDBColumn;
    InvNumber_child: TcxGridDBColumn;
    InvNumber_find: TcxGridDBColumn;
    InfoMoneyName_child: TcxGridDBColumn;
    InfoMoneyName_find: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel3: TcxLabel;
    edPaidKind: TcxButtonEdit;
    GuidesPaidKind: TdsdGuides;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    actRefreshMovement: TdsdDataSetRefresh;
    cbMovement: TcxCheckBox;
    cxLabel6: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    RetailName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    isSend: TcxGridDBColumn;
    actOpenReportDetailForm: TdsdOpenForm;
    bbOpenReportDetail: TdxBarButton;
    actPrintSing: TdsdPrintAction;
    bbPrintSing: TdxBarButton;
    Sum_AccountSendDebt: TcxGridDBColumn;
    actPrintGroup: TdsdPrintAction;
    bbPrintGroup: TdxBarButton;
    isSalePart: TcxGridDBColumn;
    AmountKg: TcxGridDBColumn;
    AmountSh: TcxGridDBColumn;
    PartKg: TcxGridDBColumn;
    cxLabel7: TcxLabel;
    edOperDate: TcxDateEdit;
    macInsertUpdate_ByGrid: TMultiAction;
    spInsertUpdate_ByGrid: TdsdStoredProc;
    actInsertUpdate_ByGrid: TdsdExecStoredProc;
    macInsertUpdate_ByGrid_list: TMultiAction;
    bbInsertUpdate_ByGrid: TdxBarButton;
    cxLabel8: TcxLabel;
    GuidesMember: TdsdGuides;
    edMember: TcxButtonEdit;
    actPrintSingDetail: TdsdPrintAction;
    bbPrintSingDetail: TdxBarButton;
    cbisReport: TcxCheckBox;
    StatusCode: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_CheckBonus_JournalForm);

end.
