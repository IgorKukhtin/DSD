unit UnitTreeCash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  ParentForm, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu, cxImageComboBox,
  cxCheckBox, dsdAddOn, dsdDB, dsdAction, Vcl.ActnList, dxBarExtItems, dxBar,
  cxPropertiesStore, Datasnap.DBClient, cxGrid, cxSplitter, cxInplaceContainer,
  cxDBTL, cxTLData, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCalendar, cxNavigator, dxDateRanges, System.ImageList, Vcl.ImgList,
  System.Actions;

type
  TUnitTreeCashForm = class(TParentForm)
    TreeDS: TDataSource;
    TreeDataSet: TClientDataSet;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    bbInsert: TdxBarButton;
    spTree: TdsdStoredProc;
    bbEdit: TdxBarButton;
    bbErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    cxDBTreeList: TcxDBTreeList;
    ceParentName: TcxDBTreeListColumn;
    cxSplitter1: TcxSplitter;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    GridDS: TDataSource;
    ClientDataSet: TClientDataSet;
    spGrid: TdsdStoredProc;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    dsdDBTreeAddOn: TdsdDBTreeAddOn;
    bbChoice: TdxBarButton;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    dxBarStatic: TdxBarStatic;
    isLeaf: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    bbUnitChoiceForm: TdxBarButton;
    TaxService: TcxGridDBColumn;
    isRepriceAuto: TcxGridDBColumn;
    bbProtocolOpenForm: TdxBarButton;
    Address: TcxGridDBColumn;
    ProvinceCityName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    PartnerMedicalName: TcxGridDBColumn;
    isGoodsCategory: TcxGridDBColumn;
    isSP: TcxGridDBColumn;
    DateSP: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    ImageList: TImageList;
    cxPropertiesStore: TcxPropertiesStore;
    actChoice: TAction;
    dxBarButton2: TdxBarButton;
    procedure actChoiceExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TUnitTreeCashForm.actChoiceExecute(Sender: TObject);
begin
  if ClientDataSet.RecordCount > 0 then ModalResult := mrOk;
end;

initialization
  RegisterClass(TUnitTreeCashForm);

end.
