unit ZakazExternal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dsdAddOn, DataModul;

type
  TZakazExternalForm = class(TParentForm)
    dsdFormParams: TdsdFormParams;
    spSelectMovementItem: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    dsdGuidesFrom: TdsdGuides;
    spGet: TdsdStoredProc;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    spSelectMovementContainerItem: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdateMovementItem: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    frxDBDataset: TfrxDBDataset;
    cxLabel14: TcxLabel;
    edInvNumberPartner: TcxTextEdit;
    cxLabel4: TcxLabel;
    edOperDateMark: TcxDateEdit;
    cxLabel12: TcxLabel;
    ceRoute: TcxButtonEdit;
    RouteGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    ceRouteSorting: TcxButtonEdit;
    dsdGuidesRouteSorting: TdsdGuides;
    cxLabel6: TcxLabel;
    cxLabel5: TcxLabel;
    edOperDatePartner: TcxDateEdit;
    edFrom: TcxButtonEdit;
    cePersonal: TcxButtonEdit;
    PersonalGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    JuridicalGroupGuides: TdsdGuides;
    RefreshAddOn: TRefreshAddOn;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colAmountSecond: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TZakazExternalForm);

end.
