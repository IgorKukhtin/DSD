unit Report_Goods;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon;

type
  TReport_GoodsForm = class(TAncestorReportForm)
    cxLabel3: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    LocationDescName: TcxGridDBColumn;
    LocationName: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    MovementDescName: TcxGridDBColumn;
    SummStart: TcxGridDBColumn;
    SummIn: TcxGridDBColumn;
    SummOut: TcxGridDBColumn;
    SummEnd: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    ObjectByName: TcxGridDBColumn;
    OperDatePartner: TcxGridDBColumn;
    ObjectByCode: TcxGridDBColumn;
    AmountStart: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edLocation: TcxButtonEdit;
    LocationGuides: TdsdGuides;
    PartionGoods: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    isActive: TcxGridDBColumn;
    ObjectByDescName: TcxGridDBColumn;
    MovementDescName_order: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    MovementId: TcxGridDBColumn;
    isRemains: TcxGridDBColumn;
    GoodsCode_parent: TcxGridDBColumn;
    GoodsName_parent: TcxGridDBColumn;
    GoodsKindName_complete: TcxGridDBColumn;
    GoodsKindName_parent: TcxGridDBColumn;
    Price_end: TcxGridDBColumn;
    Price_partner: TcxGridDBColumn;
    SummPartnerOut: TcxGridDBColumn;
    SummPartnerIn: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edUnitGroup: TcxButtonEdit;
    GuidesUnitGroup: TdsdGuides;
    GoodsGroupGuides: TdsdGuides;
    Amount_Change: TcxGridDBColumn;
    Summ_Change_branch: TcxGridDBColumn;
    Amount_40200: TcxGridDBColumn;
    Summ_40200_branch: TcxGridDBColumn;
    Amount_Loss: TcxGridDBColumn;
    Summ_Loss_branch: TcxGridDBColumn;
    Summ_Change_zavod: TcxGridDBColumn;
    Summ_40200_zavod: TcxGridDBColumn;
    Summ_Loss_zavod: TcxGridDBColumn;
    cbPartner: TcxCheckBox;
    isPage3: TcxGridDBColumn;
    isExistsPage3: TcxGridDBColumn;
    cbSumm_branch: TcxCheckBox;
    bbSumm_branch: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    Price_branch: TcxGridDBColumn;
    Price_branch_end: TcxGridDBColumn;
    SummStart_branch: TcxGridDBColumn;
    SummIn_branch: TcxGridDBColumn;
    SummOut_branch: TcxGridDBColumn;
    SummEnd_branch: TcxGridDBColumn;
    Summ_branch: TcxGridDBColumn;
    isRePrice: TcxGridDBColumn;
    isInv: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    actGetForm: TdsdExecStoredProc;
    actOpenForm: TdsdOpenForm;
    actOpenDocument: TMultiAction;
    bbOpenDocument: TdxBarButton;
    FormParams: TdsdFormParams;
    isPeresort: TcxGridDBColumn;
    cbPapty: TcxCheckBox;
    InvNumber_Full: TcxGridDBColumn;
    StartSale_promo: TcxGridDBColumn;
    EndSale_promo: TcxGridDBColumn;
    DayOfWeekName_doc: TcxGridDBColumn;
    DayOfWeekName_partner: TcxGridDBColumn;
    OperDate_Protocol_auto: TcxGridDBColumn;
    UserName_Protocol_auto: TcxGridDBColumn;
    PersonalGroupName: TcxGridDBColumn;
    PartionCellName: TcxGridDBColumn;
    isPartionCell_Close: TcxGridDBColumn;
    spMovementReComplete: TdsdStoredProc;
    actMovementReComplete: TdsdExecStoredProc;
    macMovementReComplete_list: TMultiAction;
    macMovementReComplete: TMultiAction;
    bbMovementReComplete: TdxBarButton;
    OperDate_Protocol_mi: TcxGridDBColumn;
    UserName_Protocol_mi: TcxGridDBColumn;
    MovementProtocolOpenForm: TdsdOpenForm;
    bbMovementProtocolOpenForm: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsForm);

end.
