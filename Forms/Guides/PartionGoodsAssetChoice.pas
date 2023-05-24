unit PartionGoodsAssetChoice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  Vcl.Menus, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxImageComboBox, cxContainer, dsdGuides, cxLabel,
  cxTextEdit, cxMaskEdit, cxButtonEdit, Vcl.ExtCtrls, cxCurrencyEdit;

type
  TPartionGoodsAssetChoiceForm = class(TAncestorEnumForm)
    OperDate: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    UnitName: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    Amount: TcxGridDBColumn;
    Panel: TPanel;
    edGoods: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GoodsGuides: TdsdGuides;
    cxLabel1: TcxLabel;
    edUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    RefreshDispatcher: TRefreshDispatcher;
    GoodsCode: TcxGridDBColumn;
    PartNumber: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    PartionModelName: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

registerClass(TPartionGoodsAssetChoiceForm);

end.
