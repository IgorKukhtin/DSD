unit InventoryJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet,
  dxBarBuiltInMenu, cxNavigator, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCalc, dsdExportToXLSAction;

type
  TInventoryJournalForm = class(TAncestorJournalForm)
    UnitName: TcxGridDBColumn;
    DeficitSumm: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    ProficitSumm: TcxGridDBColumn;
    bbPrint1: TdxBarButton;
    dxBarButton1: TdxBarButton;
    FullInvent: TcxGridDBColumn;
    Diff: TcxGridDBColumn;
    DiffSumm: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    Diff_calc: TcxGridDBColumn;
    DeficitSumm_calc: TcxGridDBColumn;
    ProficitSumm_calc: TcxGridDBColumn;
    DiffSumm_calc: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    spPUSHCompile: TdsdStoredProc;
    actPUSHCompile: TdsdShowPUSHMessage;
    actPrintInventoryTime: TdsdExportToXLS;
    spInventoryTime: TdsdStoredProc;
    actExecInventoryTime: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    spPUSHCompileFull: TdsdStoredProc;
    spCompileUnitFull_Finish: TdsdStoredProc;
    spCompileUnitFull_Start: TdsdStoredProc;
    actCompileUnitFull_Finish: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TInventoryJournalForm);
end.
