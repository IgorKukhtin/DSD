unit CheckItemJournal;

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
  dxSkinXmas2008Blue, cxCheckBox;

type
  TCheckItemJournalForm = class(TAncestorJournalForm)
    colUnitName: TcxGridDBColumn;
    colCashNumber: TcxGridDBColumn;
    colTotalCount: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    coPaidTypeName: TcxGridDBColumn;
    ceUnit: TcxButtonEdit;
    cxLabel3: TcxLabel;
    UnitGuides: TdsdGuides;
    rdUnit: TRefreshDispatcher;
    actGet_UserUnit: TdsdExecStoredProc;
    dsdStoredProc1: TdsdStoredProc;
    N13: TMenuItem;
    colBayer: TcxGridDBColumn;
    colCashMember: TcxGridDBColumn;
    colFiscalCheckNumber: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    colTotalSummChangePercent: TcxGridDBColumn;
    IsDeferred: TcxGridDBColumn;
    colBayerPhone: TcxGridDBColumn;
    InvNumberOrder: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    PrintDialog: TExecuteDialog;
    macPrint: TMultiAction;
    bbPrint: TdxBarButton;
    colTotalSummPayAdd: TcxGridDBColumn;
    actCashSummaForDey: TdsdOpenForm;
    bbChoiceGuides: TdxBarButton;
    cxLabel4: TcxLabel;
    edGoods: TcxButtonEdit;
    actChoiceGuides: TdsdChoiceGuides;
    GuidesGoods: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TCheckItemJournalForm)

end.
