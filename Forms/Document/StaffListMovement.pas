unit StaffListMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
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
  TStaffListMovementForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    PositionLevelName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    StaffPaidKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actPositionChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    StaffHoursName: TcxGridDBColumn;
    cxLabel22: TcxLabel;
    ceComment: TcxTextEdit;
    bbPrintNoGroup: TdxBarButton;
    cxLabel8: TcxLabel;
    edInsertDate: TcxDateEdit;
    cxLabel7: TcxLabel;
    edInsertName: TcxButtonEdit;
    bbPrintSaleOrder: TdxBarButton;
    bbPrintSaleOrderTax: TdxBarButton;
    bbPersonalGroupChoiceForm: TdxBarButton;
    edUpdateName: TcxButtonEdit;
    cxLabel4: TcxLabel;
    edUpdateDate: TcxDateEdit;
    cxLabel5: TcxLabel;
    StaffHoursDayName: TcxGridDBColumn;
    InsertRecord: TInsertRecord;
    bbInsertRecord: TdxBarButton;
    HeaderExit: THeaderExit;
    bbdd: TdxBarButton;
    cxLabel24: TcxLabel;
    edDepartment: TcxButtonEdit;
    cxLabel14: TcxLabel;
    cePersonalHead: TcxButtonEdit;
    GuidesPersonalHead: TdsdGuides;
    StaffHoursLengthName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    AmountReport: TcxGridDBColumn;
    StaffCount_1: TcxGridDBColumn;
    edCount_1: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edCount_2: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    cxLabel11: TcxLabel;
    edCount_3: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edCount_4: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    edCount_5: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    edCount_6: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    edCount_7: TcxCurrencyEdit;
    TotalStaffCount: TcxGridDBColumn;
    TotalStaffHoursLength: TcxGridDBColumn;
    NormCount: TcxGridDBColumn;
    NormHours: TcxGridDBColumn;
    WageFund: TcxGridDBColumn;
    WageFund_byOne: TcxGridDBColumn;
    actPositionLevelChoice: TOpenChoiceForm;
    actStaffPaidKindChoiceForm: TOpenChoiceForm;
    actStaffHoursDayChoiceForm: TOpenChoiceForm;
    actStaffHoursChoiceForm: TOpenChoiceForm;
    actStaffHoursLengthChoiceForm: TOpenChoiceForm;
    actPersonalChoiceForm: TOpenChoiceForm;
    GuidesUnit: TdsdGuides;
    spInsert_MI_byMovement: TdsdStoredProc;
    actOpenStaffListJournalChoice: TOpenChoiceForm;
    actInsertMIMaster_byMovement: TdsdExecStoredProc;
    macInsertMI_byMovement: TMultiAction;
    bbInsertMI_byMovement: TdxBarButton;
    actRefreshGet: TdsdDataSetRefresh;
    PositionCode: TcxGridDBColumn;
    cxLabel10: TcxLabel;
    edDepartment2: TcxButtonEdit;
    Staff_Summ_real_calc: TcxGridDBColumn;
    Staff_Summ_add_calc: TcxGridDBColumn;
    Staff_Summ_total_real_calc: TcxGridDBColumn;
    Staff_Summ_total_add_calc: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TStaffListMovementForm);

end.
