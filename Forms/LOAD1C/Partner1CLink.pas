unit Partner1CLink;

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
  TPartner1CLinkForm = class(TAncestorDBGridForm)
    colPartnerCode: TcxGridDBColumn;
    colPartnerName: TcxGridDBColumn;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colBranchName: TcxGridDBColumn;
    dxBarControlContainerItem: TdxBarControlContainerItem;
    edBranch: TcxButtonEdit;
    BranchLinkGuides: TdsdGuides;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceBranchForm: TOpenChoiceForm;
    actInsertRecord: TInsertRecord;
    bbAddRecord: TdxBarButton;
    colContractNumber: TcxGridDBColumn;
    actChoiceContractForm: TOpenChoiceForm;
    actInsertPartner: TInsertUpdateChoiceAction;
    bbInsertPartner: TdxBarButton;
    colJuridicalName: TcxGridDBColumn;
    actChoicePartnerForm: TOpenChoiceForm;
    cxLabel1: TcxLabel;
    bbBranchLabel: TdxBarControlContainerItem;
    spGetPointName: TdsdStoredProc;
    actGetPointName: TdsdExecStoredProc;
    actInsertRecordEmpty: TInsertRecord;
    bbInsertEmptyRecord: TdxBarButton;
    actInsertPartner1CLink: TdsdExecStoredProc;
    spInsertPartner1CLink: TdsdStoredProc;
    bbInsertPartner1CLink: TdxBarButton;
    actInsertPartner1CLinkAll: TMultiAction;
    colName_find1C: TcxGridDBColumn;
    colOKPO_find1C: TcxGridDBColumn;
    actUpdatePartner1CLink_Partner: TdsdExecStoredProc;
    actUpdatePartner1CLink_PartnerAll: TMultiAction;
    spUpdatePartner1CLink_Partner: TdsdStoredProc;
    bbUpdatePartner1CLink_Partner: TdxBarButton;
    clItemName: TcxGridDBColumn;
    clINN: TcxGridDBColumn;
    clINN_find1C: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartner1CLinkForm);

end.
