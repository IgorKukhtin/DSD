unit ProjectsImprovementsJournal;

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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCalc, cxBlobEdit, cxSplitter;

type
  TProjectsImprovementsJournalForm = class(TAncestorJournalForm)
    coTitle: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrint1: TdxBarButton;
    dxBarButton1: TdxBarButton;
    ExecuteDialog: TExecuteDialog;
    coDescription: TcxGridDBColumn;
    colisApprovedBy: TcxGridDBColumn;
    bbAddRedCheck: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton3: TdxBarButton;
    spInsertUpdateMovement: TdsdStoredProc;
    actUpdateMainDS: TdsdUpdateDataSet;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    detOperDate: TcxGridDBColumn;
    detPerformed: TcxGridDBColumn;
    detDescription: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    DetailDS: TDataSource;
    DetailDCS: TClientDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actUpdateDetailDS: TdsdUpdateDataSet;
    spSelectDetai: TdsdStoredProc;
    detUserName: TcxGridDBColumn;
    detisApprovedBy: TcxGridDBColumn;
    detTitle: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    spUpdateMovement_ApprovedBy: TdsdStoredProc;
    DBViewAddOnDetail: TdsdDBViewAddOn;
    actUpdateMovement_ApprovedBy: TdsdExecStoredProc;
    dxBarButton4: TdxBarButton;
    spUpdateMovementItem_ApprovedBy: TdsdStoredProc;
    actUpdateMovementItem_ApprovedBy: TdsdExecStoredProc;
    spUpdateMovementItem_Performed: TdsdStoredProc;
    dsdExecStoredProc1: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    actMISetErased: TdsdUpdateErased;
    actMISetUnErased: TdsdUpdateErased;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    dxBarButton9: TdxBarButton;
    dclisErased: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TProjectsImprovementsJournalForm);
end.
