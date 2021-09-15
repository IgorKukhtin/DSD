unit ReestrStartMovement;

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
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxSplitter,
  cxImageComboBox, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TReestrStartMovementForm = class(TAncestorDocumentForm)
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    actSaleChoiceForm: TOpenChoiceForm;
    cxLabel25: TcxLabel;
    edInvNumberTransport: TcxButtonEdit;
    TransportChoiceGuides: TdsdGuides;
    cxLabel27: TcxLabel;
    edCar: TcxButtonEdit;
    CarGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    edPersonalDriver: TcxButtonEdit;
    PersonalDriverGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    edMember: TcxButtonEdit;
    MemberGuides: TdsdGuides;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    BarCode: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    InvNumber_Sale: TcxGridDBColumn;
    OperDate_Sale: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    spSelectBarCode: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actRefreshStart: TdsdDataSetRefresh;
    BarCode_Sale: TcxGridDBColumn;
    LineNum: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    BarCode_Transport: TcxGridDBColumn;
    RefreshDispatcher: TRefreshDispatcher;
    Checked: TcxGridDBColumn;
    RouteGroupName: TcxGridDBColumn;
    macMISetErased: TMultiAction;
    ExternalDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    macUpdateMov: TMultiAction;
    actUpdate: TdsdDataSetRefresh;
    actPrintPeriod: TdsdPrintAction;
    spSelectPrintPeriod: TdsdStoredProc;
    bbPrintPeriod: TdxBarButton;
    macPrintPeriod: TMultiAction;
    actDialog_Print: TExecuteDialog;
    cxLabel18: TcxLabel;
    cePersonal: TcxButtonEdit;
    GuidesPersonal: TdsdGuides;
    cxLabel19: TcxLabel;
    cePersonalTrade: TcxButtonEdit;
    GuidesPersonalTrade: TdsdGuides;
    cbReestrKind: TcxCheckBox;
    actPrintGroupPersonal: TdsdPrintAction;
    bbPrintGroupPersonal: TdxBarButton;
    actPrintPeriodGroup: TdsdPrintAction;
    macPrintPeriodGroup: TMultiAction;
    bbPrintPeriodGroup: TdxBarButton;
    spSelectPrintGroup: TdsdStoredProc;
    spSelectPrintPeriodGroup: TdsdStoredProc;
    actPrintForDriver: TdsdPrintAction;
    bbPrintForDriver: TdxBarButton;
    isNotPayForWeight: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReestrStartMovementForm);

end.
