unit HospitalDoc_1CJournal;

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
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, dsdCommon,
  ExternalLoad, cxMemo;

type
  THospitalDoc_1CJournalForm = class(TAncestorJournalForm)
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    ServiceDate: TcxGridDBColumn;
    StartStop: TcxGridDBColumn;
    EndStop: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    JuridicalBasisGuides: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    Code1C: TcxGridDBColumn;
    isMain: TcxGridDBColumn;
    FIO: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    bbOpenFormMemberHolidayEdit: TdxBarButton;
    SummPF: TcxGridDBColumn;
    spGetImportSetting: TdsdStoredProc;
    spGetImportSettingId: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    actStartLoad: TMultiAction;
    bbtStartLoad: TdxBarButton;
    spUpdate_MI_SheetWorkTime: TdsdStoredProc;
    actUpdate_SheetWorkTime: TdsdExecStoredProc;
    macUpdate_SheetWorkTime_list: TMultiAction;
    macUpdate_SheetWorkTime: TMultiAction;
    dxBarButton1: TdxBarButton;
    spInsert_MI_PersonalService: TdsdStoredProc;
    actInsert_MI_PersonalService: TdsdExecStoredProc;
    macInsert_PersonalService_list: TMultiAction;
    macInsert_PersonalService: TMultiAction;
    bbInsert_PersonalService: TdxBarButton;
    ceError: TcxMemo;
    cxLabel3: TcxLabel;
    spSelectError: TdsdStoredProc;
    spInsert_MI_PersonalServiceDel: TdsdStoredProc;
    actInsert_MI_PersonalServiceDel: TdsdExecStoredProc;
    macInsert_PersonalServiceDel_list: TMultiAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(THospitalDoc_1CJournalForm);
end.
