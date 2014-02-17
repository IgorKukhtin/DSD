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
  dxSkinsdxBarPainter, DataModul;

type
  TPartner1CLinkForm = class(TAncestorDBGridForm)
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colDetailCode: TcxGridDBColumn;
    colDetailName: TcxGridDBColumn;
    colDetailBranch: TcxGridDBColumn;
    dxBarControlContainerItem: TdxBarControlContainerItem;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceBranchForm: TOpenChoiceForm;
    actInsertRecord: TInsertRecord;
    bbAddRecord: TdxBarButton;
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
