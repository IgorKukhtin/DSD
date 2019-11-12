unit Report_Movement_ProfitLossService;

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
  TReport_Movement_ProfitLossServiceForm = class(TAncestorReportForm)
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
    DocumentTaxKindGuides: TdsdGuides;
    Sum_BonusFact: TcxGridDBColumn;
    InvNumber_child: TcxGridDBColumn;
    InvNumber_find: TcxGridDBColumn;
    InfoMoneyName_child: TcxGridDBColumn;
    InfoMoneyName_find: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    actDocBonus: TdsdExecStoredProc;
    spInsertUpdate: TdsdStoredProc;
    Sum_CheckBonusFact: TcxGridDBColumn;
    Sum_SaleFact: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    cxLabel3: TcxLabel;
    edPaidKind: TcxButtonEdit;
    PaidKindGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    actRefreshMovement: TdsdDataSetRefresh;
    cxLabel8: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    cxLabel20: TcxLabel;
    edArea: TcxButtonEdit;
    GuidesArea: TdsdGuides;
    cxLabel6: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesRetail: TdsdGuides;
    cbPartner: TcxCheckBox;
    cbGoods: TcxCheckBox;
    cbGoodsKind: TcxCheckBox;
    PartnerName: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_Movement_ProfitLossServiceForm);

end.
