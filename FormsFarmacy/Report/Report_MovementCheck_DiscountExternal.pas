unit Report_MovementCheck_DiscountExternal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AncestorReport, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, Data.DB, cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxPC, cxContainer, cxTextEdit,
  cxLabel, cxCurrencyEdit, cxButtonEdit, Vcl.DBActns, cxMaskEdit, Vcl.ExtCtrls,
  Vcl.ComCtrls, dxCore, cxDateUtils, ChoicePeriod, cxDropDownEdit, cxCalendar,
  dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TReport_MovementCheck_DiscountExternalForm = class(TAncestorReportForm)
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    actRefreshSearch: TdsdExecStoredProc;
    Amount: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    gpGetObjectGoods: TdsdStoredProc;
    Price: TcxGridDBColumn;
    getMovementForm: TdsdStoredProc;
    FormParams: TdsdFormParams;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    ceDiscountExternal: TcxButtonEdit;
    cxLabel4: TcxLabel;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesDiscountExternal: TdsdGuides;
    UnitGuides: TdsdGuides;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    DiscountCardName: TcxGridDBColumn;
    DiscountExternalName: TcxGridDBColumn;
    FromName: TcxGridDBColumn;
    PriceWithVAT: TcxGridDBColumn;
    DateCompensation: TcxGridDBColumn;
    actUpdateMainDS: TdsdUpdateDataSet;
    spUpdateDateCompensation: TdsdStoredProc;
    spUpdateDateCompensationFilter: TdsdStoredProc;
    matUpdateDateCompensation: TMultiAction;
    actUpdateDateCompensation: TdsdExecStoredProc;
    actExecuteDialogDateCompensation: TExecuteDialog;
    bbUpdateDateCompensation: TdxBarButton;
    dxBarButton1: TdxBarButton;
    InvNumberIncome: TcxGridDBColumn;
    OperDateIncome: TcxGridDBColumn;
    ActNumber: TcxGridDBColumn;
    AmountAct: TcxGridDBColumn;
    spUpdateActNumberAndAmountFilter: TdsdStoredProc;
    spUpdateActNumberAndAmount: TdsdStoredProc;
    mactUpdateActNumberAndAmountFilter: TMultiAction;
    actUpdateActNumberAndAmountFilter: TdsdExecStoredProc;
    actExecuteDialogactActNumberAndAmount: TExecuteDialog;
    bbUpdateActNumberAndAmount: TdxBarButton;
    isClosed: TcxGridDBColumn;
    spUpdate_Closed: TdsdStoredProc;
    mactUpdate_Closed: TMultiAction;
    actUpdate_Closed: TdsdExecStoredProc;
    bbUpdate_Closed: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementCheck_DiscountExternalForm);

end.
