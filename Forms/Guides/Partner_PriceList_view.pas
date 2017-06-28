unit Partner_PriceList_view;

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
  dxSkinXmas2008Blue, cxImageComboBox, cxButtonEdit, cxCurrencyEdit,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, dsdGuides;

type
  TPartner_PriceList_viewForm = class(TAncestorEnumForm)
    InvNumber: TcxGridDBColumn;
    StartDate: TcxGridDBColumn;
    JuridicalCode: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    PaidKindName: TcxGridDBColumn;
    InfoMoneyName: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    EndDate: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    PartnerCode: TcxGridDBColumn;
    PartnerName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Code: TcxGridDBColumn;
    ContractComment: TcxGridDBColumn;
    actChoiceRoute: TOpenChoiceForm;
    actChoiceRouteSorting: TOpenChoiceForm;
    actChoicePersonalTake: TOpenChoiceForm;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    ContainerId: TcxGridDBColumn;
    PersonalTradeCode: TcxGridDBColumn;
    PersonalTradeName: TcxGridDBColumn;
    PositionName_PersonalTrade: TcxGridDBColumn;
    BranchName_PersonalTrade: TcxGridDBColumn;
    LabelOperDate: TcxLabel;
    bbLabelOperDate: TdxBarControlContainerItem;
    bbOperDate: TdxBarControlContainerItem;
    deOperDate: TcxDateEdit;
    PriceListName_income: TcxGridDBColumn;
    PriceListName_GP_sale: TcxGridDBColumn;
    PriceListName_GP_return: TcxGridDBColumn;
    PriceListName_GP_return_prior: TcxGridDBColumn;
    PriceListName_30103_sale: TcxGridDBColumn;
    PriceListName_30103_return: TcxGridDBColumn;
    PriceListName_30201_sale: TcxGridDBColumn;
    PriceListName_30201_return: TcxGridDBColumn;
    DescName_income: TcxGridDBColumn;
    DescName_GP_sale: TcxGridDBColumn;
    DescName_GP_return: TcxGridDBColumn;
    DescName_GP_return_prior: TcxGridDBColumn;
    DescName_30103_sale: TcxGridDBColumn;
    DescName_30103_return: TcxGridDBColumn;
    DescName_30201_sale: TcxGridDBColumn;
    DescName_30201_return: TcxGridDBColumn;
    LabelJuridical: TcxLabel;
    edJuridical: TcxButtonEdit;
    bbLabelJuridical: TdxBarControlContainerItem;
    bbJuridical: TdxBarControlContainerItem;
    bbLabelRetail: TdxBarControlContainerItem;
    bbRetail: TdxBarControlContainerItem;
    LabelRetail: TcxLabel;
    edRetail: TcxButtonEdit;
    GuidesJuridical: TdsdGuides;
    GuidesRetail: TdsdGuides;
    RetailName: TcxGridDBColumn;
    OperDate_income: TcxGridDBColumn;
    OperDate_GP_sale: TcxGridDBColumn;
    OperDate_GP_return: TcxGridDBColumn;
    OperDate_GP_return_prior: TcxGridDBColumn;
    OperDate_30103_sale: TcxGridDBColumn;
    OperDate_30103_return: TcxGridDBColumn;
    OperDate_30201_sale: TcxGridDBColumn;
    OperDate_30201_return: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

registerClass(TPartner_PriceList_viewForm);

end.
