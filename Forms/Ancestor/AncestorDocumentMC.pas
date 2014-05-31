unit AncestorDocumentMC;

interface

uses
  DataModul, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, dsdGuides, dsdDB,
  dsdAction, cxButtonEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel,
  cxTextEdit, Vcl.ExtCtrls, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit;

type
  TAncestorDocumentMCForm = class(TAncestorDBGridForm)
    EntryCDS: TClientDataSet;
    EntryDS: TDataSource;
    spSelectMIContainer: TdsdStoredProc;
    FormParams: TdsdFormParams;
    StatusGuides: TdsdGuides;
    spChangeStatus: TdsdStoredProc;
    spGet: TdsdStoredProc;
    spInsertUpdateMovement: TdsdStoredProc;
    GuidesFiller: TGuidesFiller;
    HeaderSaver: THeaderSaver;
    RefreshAddOn: TRefreshAddOn;
    spErasedMIMaster: TdsdStoredProc;
    spUnErasedMIMaster: TdsdStoredProc;
    spInsertUpdateMIMaster: TdsdStoredProc;
    EntryViewAddOn: TdsdDBViewAddOn;
    colIsErased: TcxGridDBColumn;
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    actAddMask: TdsdExecStoredProc;
    spInsertMaskMIMaster: TdsdStoredProc;
    bbAddMask: TdxBarButton;
    spGetTotalSumm: TdsdStoredProc;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    cxGridChild: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    colChildGoodsCode: TcxGridDBColumn;
    colChildGoodsName: TcxGridDBColumn;
    colChildGoodsKindName: TcxGridDBColumn;
    colChildAmount: TcxGridDBColumn;
    colChildAmountReceipt: TcxGridDBColumn;
    colChildPartionGoods: TcxGridDBColumn;
    colChildComment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    spInsertMaskMIChild: TdsdStoredProc;
    GuidesTo: TdsdGuides;
    GuidesFrom: TdsdGuides;
    DataPanel: TPanel;
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel15: TcxLabel;
    ceStatus: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    spInsertUpdateMIChild: TdsdStoredProc;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    bbAddChild: TdxBarButton;
    InsertRecordChild: TInsertRecord;
    GoodsChoiceForm: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
