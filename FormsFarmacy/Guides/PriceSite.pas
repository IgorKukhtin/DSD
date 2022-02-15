unit PriceSite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.ExtCtrls, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxCurrencyEdit, ExternalLoad, cxPCdxBarPopupMenu, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxLabel, cxDropDownEdit, cxCalendar, cxCheckBox,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  TPriceSiteForm = class(TAncestorEnumForm)
    dxBarControlContainerItemUnit: TdxBarControlContainerItem;
    FormParams: TdsdFormParams;
    dxBarButton1: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    DateChange: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    dsdUpdatePriceSite: TdsdUpdateDataSet;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    Remains: TcxGridDBColumn;
    dxBarButton6: TdxBarButton;
    Fix: TcxGridDBColumn;
    FixDateChange: TcxGridDBColumn;
    actPriceSiteHistoryOpen: TdsdOpenForm;
    dxBarButton7: TdxBarButton;
    Panel: TPanel;
    ExecuteDialog: TExecuteDialog;
    StartDate: TcxGridDBColumn;
    SummaRemains: TcxGridDBColumn;
    Goods_isTop: TcxGridDBColumn;
    dsdOpenForm: TdsdOpenForm;
    bbOpenForm: TdxBarButton;
    cxLabel2: TcxLabel;
    ceGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    Color_ExpirationDate: TcxGridDBColumn;
    DiffSP2: TcxGridDBColumn;
    CheckPriceSiteDate: TcxGridDBColumn;
    bb: TdxBarButton;
    spUpdate_Discont: TdsdStoredProc;
    actSiteDiscontDialog: TExecuteDialog;
    actUpdate_SiteDiscont: TdsdExecStoredProc;
    mactSiteDiscont: TMultiAction;
    dxBarButton8: TdxBarButton;
    DiscontStart: TcxGridDBColumn;
    DiscontEnd: TcxGridDBColumn;
    DiscontAmount: TcxGridDBColumn;
    DiscontPercent: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceSiteForm: TPriceSiteForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceSiteForm)
end.
