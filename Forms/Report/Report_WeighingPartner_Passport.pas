unit Report_WeighingPartner_Passport;

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
  TReport_WeighingPartner_PassportForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    GoodsGroupNameFull: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    bbPrint: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    StatusCode: TcxGridDBColumn;
    actRefresh_Detail: TdsdDataSetRefresh;
    spSelectMIPrintPassport: TdsdStoredProc;
    actSelectMIPrintPassport: TdsdPrintAction;
    BoxName_1: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    lbSearchName: TcxLabel;
    edSearchBarCode: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    dsdChoiceGuides1: TdsdChoiceGuides;
    BarCode: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edSearchGoodsCode: TcxTextEdit;
    cxLabel4: TcxLabel;
    edSearchPartionNum: TcxTextEdit;
    MovementItemId: TcxGridDBColumn;
    ItemName_inf: TcxGridDBColumn;
    ItemName: TcxGridDBColumn;
    spUpdate_Count: TdsdStoredProc;
    actUpdateDS: TdsdUpdateDataSet;
    cxLabel5: TcxLabel;
    edBoxName_1: TcxTextEdit;
    cxLabel6: TcxLabel;
    edBoxName_2: TcxTextEdit;
    cxLabel7: TcxLabel;
    edBoxName_3: TcxTextEdit;
    cxLabel9: TcxLabel;
    edBoxName_4: TcxTextEdit;
    cxLabel8: TcxLabel;
    edBoxName_5: TcxTextEdit;
    cxLabel10: TcxLabel;
    edBoxName_6: TcxTextEdit;
    cxLabel11: TcxLabel;
    edBoxName_7: TcxTextEdit;
    cxLabel12: TcxLabel;
    edBoxName_8: TcxTextEdit;
    cxLabel13: TcxLabel;
    edBoxName_9: TcxTextEdit;
    cxLabel14: TcxLabel;
    edBoxName_10: TcxTextEdit;
    spGet_Box_NPP: TdsdStoredProc;
    actContinueAction: TdsdContinueAction;
    spGet_CheckingPSW: TdsdStoredProc;
    actExecuteDialogPSW: TExecuteDialog;
    macUpDate_Count: TMultiAction;
    actGet_CheckingPSW: TdsdExecStoredProc;
    actUpdate_Count: TdsdExecStoredProc;
    spGetBoxNamePSW: TdsdStoredProc;
    actGetBoxNamePSW: TdsdExecStoredProc;
    macGetCheckDialog: TMultiAction;
    outMessageText: TShowMessageAction;
    Amount_sh_inv: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_WeighingPartner_PassportForm);

end.
