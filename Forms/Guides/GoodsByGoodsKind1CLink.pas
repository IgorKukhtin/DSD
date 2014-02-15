unit GoodsByGoodsKind1CLink;

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
  dxSkinsdxBarPainter;

type
  TGoodsByGoodsKind1CLinkForm = class(TAncestorDBGridForm)
    cxDetailGrid: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxSplitter: TcxSplitter;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colDetailCode: TcxGridDBColumn;
    colDetailName: TcxGridDBColumn;
    colDetailBranch: TcxGridDBColumn;
    DetailCDS: TClientDataSet;
    DetailDS: TDataSource;
    spDetailSelect: TdsdStoredProc;
    dxBarControlContainerItem: TdxBarControlContainerItem;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    spInsertUpdate: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    actChoiceBranchForm: TOpenChoiceForm;
    colGoodsKindName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TGoodsByGoodsKind1CLinkForm);

end.
