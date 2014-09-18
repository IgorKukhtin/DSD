unit Partner1CLink_Excel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxSplitter, cxContainer, cxTextEdit, cxMaskEdit, cxButtonEdit,
  dsdGuides, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter, DataModul, cxLabel, cxImageComboBox;

type
  TPartner1CLink_ExcelForm = class(TAncestorDBGridForm)
    colPartnerCode: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    colClientCode1C: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    dxBarControlContainerItem: TdxBarControlContainerItem;
    edBranch: TcxButtonEdit;
    BranchLinkGuides: TdsdGuides;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceBranchForm: TOpenChoiceForm;
    colJuridicalName: TcxGridDBColumn;
    actChoicePartnerForm: TOpenChoiceForm;
    cxLabel1: TcxLabel;
    bbBranchLabel: TdxBarControlContainerItem;
    colPartnerName1C: TcxGridDBColumn;
    colOKPO1C: TcxGridDBColumn;
    clItemName: TcxGridDBColumn;
    clINN: TcxGridDBColumn;
    clINN1C: TcxGridDBColumn;
    colPartnerId: TcxGridDBColumn;
    colJuridicalId: TcxGridDBColumn;
    clPartner1CLinkId: TcxGridDBColumn;
    clJuridicalNameExcel: TcxGridDBColumn;
    clPartnerNameExcel: TcxGridDBColumn;
    clOKPOExcel: TcxGridDBColumn;
    clKodBranchExcel: TcxGridDBColumn;
    clPartnerNameCalcExcel: TcxGridDBColumn;
    index: TcxGridDBColumn;
    citytype: TcxGridDBColumn;
    cityname: TcxGridDBColumn;
    regiontype: TcxGridDBColumn;
    region: TcxGridDBColumn;
    streettype: TcxGridDBColumn;
    streetname: TcxGridDBColumn;
    house: TcxGridDBColumn;
    house1: TcxGridDBColumn;
    house2: TcxGridDBColumn;
    house3: TcxGridDBColumn;
    kontakt1name: TcxGridDBColumn;
    kontakt1tel: TcxGridDBColumn;
    kontakt1email: TcxGridDBColumn;
    kontakt2name: TcxGridDBColumn;
    kontakt2tel: TcxGridDBColumn;
    kontakt2email: TcxGridDBColumn;
    kontakt3name: TcxGridDBColumn;
    kontakt3tel: TcxGridDBColumn;
    kontakt3email: TcxGridDBColumn;
    clJuridicalNameExcel_find: TcxGridDBColumn;
    clIsOKPO1C_OKPO: TcxGridDBColumn;
    clIsOKPO1C_OKPOExcel: TcxGridDBColumn;
    clIsOKPOExcel_OKPO: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartner1CLink_ExcelForm);

end.
