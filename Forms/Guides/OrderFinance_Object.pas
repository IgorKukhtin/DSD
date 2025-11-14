unit OrderFinance_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, cxSplitter, Vcl.StdActns, cxDropDownEdit,
  ExternalLoad, cxBlobEdit, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue,
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
  cxContainer, cxLabel, cxTextEdit, cxMaskEdit, dsdGuides, cxCurrencyEdit,
  dsdCommon;

type
  TOrderFinance_ObjectForm = class(TAncestorDBGridForm)
    clName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    spInsertUpdateOrderFinance: TdsdStoredProc;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    bbChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    spErasedUnErased: TdsdStoredProc;
    bbUpdate: TdxBarButton;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    actProtocolMaster: TdsdOpenForm;
    bbProtocolMaster: TdxBarButton;
    bbProtocolChild: TdxBarButton;
    clCode: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    bbInsertRecordChild: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bb: TdxBarButton;
    MemberName_insert: TcxGridDBColumn;
    MemberName_1: TcxGridDBColumn;
    MemberName_2: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TOrderFinance_ObjectForm);

end.
