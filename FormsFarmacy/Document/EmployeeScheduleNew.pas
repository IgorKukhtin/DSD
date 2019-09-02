unit EmployeeScheduleNew;

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
  TEmployeeScheduleNewForm = class(TAncestorDocumentForm)
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    bbPrintCheck: TdxBarButton;
    bbGet_SP_Prior: TdxBarButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    HeaderCDS: TClientDataSet;
    actDataDialog: TExecuteDialog;
    HeaderPrewCDS: TClientDataSet;
    actUserNickDialig: TOpenChoiceForm;
    actAddUser: TMultiAction;
    actspInsertUser: TdsdExecStoredProc;
    spInsertUser: TdsdStoredProc;
    UnitName: TcxGridDBBandedColumn;
    ValueStart: TcxGridDBBandedColumn;
    actExecPreviousMonth: TdsdExecStoredProc;
    spPreviousMonth: TdsdStoredProc;
    actPreviousMonth: TMultiAction;
    dxBarButton4: TdxBarButton;
    Color_Calc: TcxGridDBBandedColumn;
    ValuePrev: TcxGridDBBandedColumn;
    CrossDBViewPrevAddOn: TCrossDBViewAddOn;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    CrossDBViewStartAddOn: TCrossDBViewAddOn;
    Color_CalcUser: TcxGridDBBandedColumn;
    actUpdateUnit: TMultiAction;
    actChoiceUnitTreeForm: TOpenChoiceForm;
    actExecStoredUpdateUnit: TdsdExecStoredProc;
    actUpdateSubstitutionUnit: TMultiAction;
    actChoiceSubstitutionUnitTreeForm: TOpenChoiceForm;
    actExecStoredUpdateSubstitutionUnit: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    spUpdateUnit: TdsdStoredProc;
    spUpdateSubstitutionUnit: TdsdStoredProc;
    actCrossDBViewSetSubstitutionUnit: TCrossDBViewSetTypeId;
    ValueEnd: TcxGridDBBandedColumn;
    actPayrollTypeChoice: TOpenChoiceForm;
    CrossDBViewEndAddOn: TCrossDBViewAddOn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TEmployeeScheduleNewForm);

end.
