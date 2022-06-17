unit CheckSummCard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdDB,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, dxBarBuiltInMenu, cxNavigator, cxCurrencyEdit, dsdGuides,
  cxButtonEdit, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCheckBox, DataModul;

type
  TCheckSummCardForm = class(TAncestorJournalForm)
    colUnitName: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    spGet_UserUnit: TdsdStoredProc;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    spReComplete: TdsdStoredProc;
    N13: TMenuItem;
    colBayer: TcxGridDBColumn;
    colCashMember: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    BayerPhone: TcxGridDBColumn;
    InvNumberOrder: TcxGridDBColumn;
    ConfirmedKindName: TcxGridDBColumn;
    ConfirmedKindClientName: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    bbPrint: TdxBarButton;
    dxBarButton1: TdxBarButton;
    CheckSourceKindName: TcxGridDBColumn;
    colSummCard: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    spUpdateMovement: TdsdStoredProc;
    CancelReason: TcxGridDBColumn;
    isDeliverySite: TcxGridDBColumn;
    SummaDelivery: TcxGridDBColumn;
    isCallOrder: TcxGridDBColumn;
    CommentCustomer: TcxGridDBColumn;
    isMobileApplication: TcxGridDBColumn;
    UserReferalsName: TcxGridDBColumn;
    isConfirmByPhone: TcxGridDBColumn;
    DateComing: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TCheckSummCardForm)

end.
