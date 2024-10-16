unit Union_ClientPartner;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, cxPropertiesStore, dxBar,
  Vcl.ActnList, DataModul, ParentForm, dsdDB, dsdAction, dsdAddOn, dxBarExtItems,
  cxGridBandedTableView, cxGridDBBandedTableView, cxCheckBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCurrencyEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxContainer,
  cxTextEdit, cxLabel;

type
  TUnion_ClientPartnerForm = class(TParentForm)
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    spSelect: TdsdStoredProc;
    dsdGridToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbChoice: TdxBarButton;
    cxGridDBTableView: TcxGridDBTableView;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    actChoiceGuides: TdsdChoiceGuides;
    DBViewAddOn: TdsdDBViewAddOn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    DescName: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    TaxKind_Value: TcxGridDBColumn;
    TaxKindName_Info: TcxGridDBColumn;
    TaxKindName_Comment: TcxGridDBColumn;
    actInsert_client: TdsdInsertUpdateAction;
    actUpdate_client: TdsdInsertUpdateAction;
    actInsert_Partner: TdsdInsertUpdateAction;
    actUpdate_partner: TdsdInsertUpdateAction;
    spUnErased: TdsdStoredProc;
    spErased: TdsdStoredProc;
    actSetErased: TdsdUpdateErased;
    actSetUnErased: TdsdUpdateErased;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    bbtInsert_client: TdxBarButton;
    bbUpdate_client: TdxBarButton;
    bbInsert_Partner: TdxBarButton;
    bbUpdate_partner: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actFormClose: TdsdFormClose;
    Panel_btn: TPanel;
    btnFormClose: TcxButton;
    btnChoiceGuides: TcxButton;
    TaxKindName: TcxGridDBColumn;
    Panel2: TPanel;
    lbSearchName: TcxLabel;
    edSearchName: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    InfoMoneyName_all: TcxGridDBColumn;
    bbInsert_client: TdxBarButton;
    bb: TdxBarButton;
    mactInsert_Partner: TMultiAction;
    mactInsert_client: TMultiAction;
    btnInsert_Partner: TcxButton;
    btnInsert_client: TcxButton;
    dxBarSeparator1: TdxBarSeparator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TUnion_ClientPartnerForm);

end.
