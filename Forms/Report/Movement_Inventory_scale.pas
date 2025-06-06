unit Movement_Inventory_scale;

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
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, dxColorEdit,
  cxColorComboBox, cxCheckBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  cxImageComboBox;

type
  TMovement_Inventory_scaleForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    GoodsGroupNameFull: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    StatusCode: TcxGridDBColumn;
    actRefresh_Detail: TdsdDataSetRefresh;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    BoxName_1: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    lbSearchName: TcxLabel;
    edSearchBarCode: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    dsdChoiceGuides1: TdsdChoiceGuides;
    MovementItemId_passport: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edSearchGoodsCode: TcxTextEdit;
    cxLabel4: TcxLabel;
    edSearchPartionNum: TcxTextEdit;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    isErased: TcxGridDBColumn;
    spSelectPrint_Mov: TdsdStoredProc;
    actPrint_Mov: TdsdPrintAction;
    bbPrint_Mov: TdxBarButton;
    spSelectMIPrintPassport: TdsdStoredProc;
    actSelectMIPrintPassport: TdsdPrintAction;
    bbPrintPassport: TdxBarButton;
    actPrintGroup: TdsdPrintAction;
    actPrint_MovGroup: TdsdPrintAction;
    bbsPrint: TdxBarSubItem;
    dxBarSeparator1: TdxBarSeparator;
    bbPrint_MovGroup: TdxBarButton;
    bbPrintGroup: TdxBarButton;
    spSelectPrint_gr: TdsdStoredProc;
    spSelectPrint_Mov_gr: TdsdStoredProc;
    NumSecurity: TcxGridDBColumn;
    actPrintSecurity: TdsdPrintAction;
    spSelectPrint_Security: TdsdStoredProc;
    bbPrintSecurity: TdxBarButton;
    actUpdate_NumSecurity: TdsdOpenForm;
    bbUpdate_NumSecurity: TdxBarButton;
    actUpdate_NumSecurity2: TdsdOpenForm;
    bbUpdate_NumSecurity2: TdxBarButton;
    mactUpdate_NumSecurity: TMultiAction;
    mactUpdate_NumSecurity2: TMultiAction;
    spSelectPrint_Mov_Sec: TdsdStoredProc;
    spSelectPrint_Mov_gr_Sec: TdsdStoredProc;
    actPrint_Mov_Sec: TdsdPrintAction;
    actPrint_MovGroup_Sec: TdsdPrintAction;
    bbPrint_Mov_Sec: TdxBarButton;
    bbPrint_MovGroup_Sec: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TMovement_Inventory_scaleForm);

end.
