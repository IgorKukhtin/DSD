unit UnitEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxButtonEdit, dsdCommon;

type
  TUnitEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    DataSetRefresh: TdsdDataSetRefresh;
    InsertUpdateGuides: TdsdInsertUpdateGuides;
    FormClose: TdsdFormClose;
    Код: TcxLabel;
    ceCode: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ParentGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    BranchGuides: TdsdGuides;
    ceParent: TcxButtonEdit;
    cxLabel2: TcxLabel;
    BusinessGuides: TdsdGuides;
    ceBranch: TcxButtonEdit;
    ceBusiness: TcxButtonEdit;
    cxLabel5: TcxLabel;
    ceJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    ceAccountDirection: TcxButtonEdit;
    cxLabel7: TcxLabel;
    ceProfitLossDirection: TcxButtonEdit;
    AccountDirectionGuides: TdsdGuides;
    ProfitLossDirectionGuides: TdsdGuides;
    cbPartionDate: TcxCheckBox;
    cxLabel8: TcxLabel;
    ceContract: TcxButtonEdit;
    ContractGuides: TdsdGuides;
    ceContract_Juridical: TcxButtonEdit;
    Contract_JuridicalGuides: TdsdGuides;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    ceContract_Infomoney: TcxButtonEdit;
    Contract_InfomoneyGuides: TdsdGuides;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    ceRoute: TcxButtonEdit;
    RouteGuides: TdsdGuides;
    ceRouteSorting: TcxButtonEdit;
    RouteSortingGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    ceArea: TcxButtonEdit;
    AreaGuides: TdsdGuides;
    cxLabel14: TcxLabel;
    cePersonalHead: TcxButtonEdit;
    GuidesPersonalHead: TdsdGuides;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    edAddress: TcxTextEdit;
    cxLabel17: TcxLabel;
    ceSheetWorkTime: TcxButtonEdit;
    SheetWorkTimeGuides: TdsdGuides;
    cbPartionGoodsKind: TcxCheckBox;
    cxLabel18: TcxLabel;
    edComment: TcxTextEdit;
    cbCountCount: TcxCheckBox;
    cbPartionGP: TcxCheckBox;
    cbAvance: TcxCheckBox;
    edGLN: TcxTextEdit;
    cxLabel19: TcxLabel;
    edKATOTTG: TcxTextEdit;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    edCity: TcxButtonEdit;
    GuidesCity: TdsdGuides;
    cxLabel23: TcxLabel;
    edAddressEDIN: TcxTextEdit;
    ceFounder: TcxButtonEdit;
    cxLabel22: TcxLabel;
    FounderGuides: TdsdGuides;
    cxLabel24: TcxLabel;
    deDepartment: TcxButtonEdit;
    GuidesDepartment: TdsdGuides;
    cxLabel25: TcxLabel;
    deDepartment_two: TcxButtonEdit;
    GuidesDepartment_two: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TUnitEditForm);

end.
