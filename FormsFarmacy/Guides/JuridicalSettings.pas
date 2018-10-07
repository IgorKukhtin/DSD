unit JuridicalSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxCheckBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack,
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
  TJuridicalSettingsForm = class(TAncestorEnumForm)
    JuridicalName: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    UpdateDataSet: TdsdUpdateDataSet;
    isPriceClose: TcxGridDBColumn;
    MainJuridicalName: TcxGridDBColumn;
    Bonus: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    Name: TcxGridDBColumn;
    PriceLimit: TcxGridDBColumn;
    ÑonditionalPercent: TcxGridDBColumn;
    isSite: TcxGridDBColumn;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    bbShowAll: TdxBarButton;
    bbSetErased: TdxBarButton;
    bbSetUnErased: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    isBonusVirtual: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpen: TdxBarButton;
    AreaName: TcxGridDBColumn;
    spUpdate_isPriceClose_Yes: TdsdStoredProc;
    spUpdate_isPriceClose_No: TdsdStoredProc;
    spUpdateisisPriceCloseNo: TdsdExecStoredProc;
    spUpdateisisPriceCloseYes: TdsdExecStoredProc;
    macUpdateisisPriceCloseNo: TMultiAction;
    macUpdateisisPriceCloseYes: TMultiAction;
    bbUpdateisisPriceCloseYes: TdxBarButton;
    bbUpdateisisPriceCloseNo: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TJuridicalSettingsForm);

end.
