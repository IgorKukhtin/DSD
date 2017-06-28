unit MovementGoods_Journal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdGuides, cxButtonEdit, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TMovementGoodsJournalForm = class(TAncestorJournalForm)
    DescName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    actOpenDocument: TMultiAction;
    actOpenForm: TdsdOpenForm;
    actMovementForm: TdsdExecStoredProc;
    bbOpenDocument: TdxBarButton;
    getMovementForm: TdsdStoredProc;
    cxLabel4: TcxLabel;
    edGoodsKind: TcxButtonEdit;
    cxLabel5: TcxLabel;
    edGoods: TcxButtonEdit;
    GoodsKindGuides: TdsdGuides;
    GoodsPartionGuides: TdsdGuides;
    BranchCode: TcxGridDBColumn;
    BranchName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    edPartionGoods: TcxButtonEdit;
    GoodsGuides: TdsdGuides;
    edLocation: TcxButtonEdit;
    LocationGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceAccountGroup: TcxButtonEdit;
    cxLabel7: TcxLabel;
    AccountGroupGuides: TdsdGuides;
    edUnitGroup: TcxButtonEdit;
    cxLabel8: TcxLabel;
    UnitGroupGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    InfoMoneyGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TMovementGoodsJournalForm)

end.
