unit MoneyPlace_Object;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum_boat, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxImageComboBox, Vcl.Menus, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
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
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxContainer, cxTextEdit, cxLabel,
  cxCurrencyEdit;

type
  TMoneyPlace_ObjectForm = class(TAncestorEnum_boatForm)
    ItemName: TcxGridDBColumn;
    Code: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    IsErased: TcxGridDBColumn;
    Panel_btn: TPanel;
    btnFormClose: TcxButton;
    btnChoiceGuides: TcxButton;
    Panel2: TPanel;
    lbSearchName: TcxLabel;
    edSearchName: TcxTextEdit;
    FieldFilter_Name: TdsdFieldFilter;
    InfoMoneyName: TcxGridDBColumn;
    TaxKind_Value: TcxGridDBColumn;
    TaxKindName: TcxGridDBColumn;
    TaxKindName_Info: TcxGridDBColumn;
    TaxKindName_Comment: TcxGridDBColumn;
    InfoMoneyName_all: TcxGridDBColumn;
    TaxNumber: TcxGridDBColumn;
    actInsert_client: TdsdInsertUpdateAction;
    actUpdate_client: TdsdInsertUpdateAction;
    actInsert_Partner: TdsdInsertUpdateAction;
    actUpdate_partner: TdsdInsertUpdateAction;
    bbInsert_Partner: TdxBarButton;
    bbInsert_client: TdxBarButton;
    bbUpdate_client: TdxBarButton;
    bbLieferanten: TdxBarSubItem;
    bbKunden: TdxBarSubItem;
    bbUpdate_partner: TdxBarButton;
    mactInsert_client: TMultiAction;
    mactInsert_Partner: TMultiAction;
    btnInsert_Partner: TcxButton;
    btnInsert_client: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMoneyPlace_ObjectForm);

end.
