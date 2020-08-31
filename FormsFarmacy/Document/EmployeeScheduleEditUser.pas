unit EmployeeScheduleEditUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxGridBandedTableView, cxGridDBBandedTableView, DataModul, cxTimeEdit;

type
  TEmployeeScheduleEditUserForm = class(TAncestorDocumentForm)
    bbPrintCheck: TdxBarButton;
    bbGet_SP_Prior: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    actDataDialog: TExecuteDialog;
    actUserNickDialig: TOpenChoiceForm;
    actAddUser: TMultiAction;
    actAddPayrollType: TdsdExecStoredProc;
    spAddPayrollType: TdsdStoredProc;
    actExecPreviousMonth: TdsdExecStoredProc;
    actPreviousMonth: TMultiAction;
    dxBarButton4: TdxBarButton;
    actUpdateUnit: TMultiAction;
    actChoiceUnitTreeForm: TOpenChoiceForm;
    actExecStoredUpdateUnit: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    spUpdateUnit: TdsdStoredProc;
    actPayrollTypeChoice: TOpenChoiceForm;
    edUserName: TcxTextEdit;
    cxLabel3: TcxLabel;
    edUnitName: TcxTextEdit;
    cxLabel4: TcxLabel;
    UnitName: TcxGridDBColumn;
    ShortName: TcxGridDBColumn;
    PayrollTypeName: TcxGridDBColumn;
    TimeStart: TcxGridDBColumn;
    TimeEnd: TcxGridDBColumn;
    DateStart: TcxGridDBColumn;
    DateEnd: TcxGridDBColumn;
    Color_CalcUser: TcxGridDBColumn;
    Day: TcxGridDBColumn;
    actUnitChoice: TOpenChoiceForm;
    isSubstitution: TcxGridDBColumn;
    actDelUserDay: TdsdExecStoredProc;
    dxBarButton7: TdxBarButton;
    spDelUserDay: TdsdStoredProc;
    actSetPayrollType: TMultiAction;
    actDialogPayrollType: TExecuteDialog;
    actExecViewPayrollType: TMultiAction;
    actExecPayrollType: TdsdExecStoredProc;
    spExecPayrollType: TdsdStoredProc;
    dxBarButton8: TdxBarButton;
    edUserCode: TcxTextEdit;
    actAddUserDialog: TExecuteDialog;
    dxBarButton9: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmployeeScheduleEditUserForm);

end.
