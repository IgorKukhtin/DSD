unit ListGoodsKeyword;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, cxNavigator, cxDataControllerConditionalFormattingRulesManagerDialog,
  DataModul, System.Actions, dxDateRanges;

type
  TListGoodsKeywordForm = class(TAncestorBaseForm)
    ListGoodsKeywordGrid: TcxGrid;
    ListGoodsKeywordGridDBTableView: TcxGridDBTableView;
    ListGoodsKeywordGridLevel: TcxGridLevel;
    ListGoodsKeywordDS: TDataSource;
    colGoodsCode: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    ListGoodsKeywordCDS: TClientDataSet;
    colAccommodationName: TcxGridDBColumn;
    RemainsCDS: TClientDataSet;
    colAmount: TcxGridDBColumn;
    spSelect: TdsdStoredProc;
    CashListDiffCDS: TClientDataSet;
    pnlLocal: TPanel;
    DiffKindCDS: TClientDataSet;
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbGridToExcel: TdxBarButton;
    bbOpen: TdxBarButton;
    edKeyword: TcxTextEdit;
    dxBarButton1: TdxBarButton;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    ExecuteDialog: TExecuteDialog;
    actRefreshGrid: TAction;
    actGridToExcel: TdsdGridToExcel;
    dxBarButton2: TdxBarButton;
    procedure actRefreshGridExecute(Sender: TObject);
    procedure ParentFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  end;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, ListDiff, ListDiffAddGoods, MainCash2;


procedure TListGoodsKeywordForm.actRefreshGridExecute(Sender: TObject);
begin

  if gc_User.Local then
  begin

    edKeyword.Text := InputBox('Введите ключевое слово', 'Ключевое слово', edKeyword.Text);

    pnlLocal.Visible := True;

    if RemainsCDS.Active then RemainsCDS.Close;
    WaitForSingleObject(MutexRemains, INFINITE);
    try
      LoadLocalData(RemainsCDS, Remains_lcl);
    finally
      ReleaseMutex(MutexRemains);
    end;

    if ListGoodsKeywordCDS.Active then ListGoodsKeywordCDS.Close;
    ListGoodsKeywordCDS.FieldDefs.Clear;
    ListGoodsKeywordCDS.FieldDefs.Add('ID', ftInteger);
    ListGoodsKeywordCDS.FieldDefs.Add('GoodsCode', ftInteger);
    ListGoodsKeywordCDS.FieldDefs.Add('GoodsName', ftString, 200);
    ListGoodsKeywordCDS.FieldDefs.Add('Amount', ftCurrency);
    ListGoodsKeywordCDS.FieldDefs.Add('AccommodationName', ftString, 80);
    ListGoodsKeywordCDS.CreateDataSet;

    ListGoodsKeywordCDS.DisableControls;
    try
      RemainsCDS.First;
      while not RemainsCDS.Eof do
      begin
        if (edKeyword.Text = '') or (Pos(edKeyword.Text, RemainsCDS.FieldByName('GoodsName').AsString) > 0) then
        begin
          if ListGoodsKeywordCDS.Locate('Id', RemainsCDS.FieldByName('Id').AsInteger, []) then
          begin
            ListGoodsKeywordCDS.Edit;
            ListGoodsKeywordCDS.FieldByName('Amount').AsCurrency := ListGoodsKeywordCDS.FieldByName('Amount').AsCurrency + RemainsCDS.FieldByName('Remains').AsCurrency;
          end else
          begin
            ListGoodsKeywordCDS.Append;
            ListGoodsKeywordCDS.FieldByName('Id').AsInteger := RemainsCDS.FieldByName('Id').AsInteger;
            ListGoodsKeywordCDS.FieldByName('GoodsCode').AsInteger := RemainsCDS.FieldByName('GoodsCode').AsInteger;
            ListGoodsKeywordCDS.FieldByName('GoodsName').AsString := RemainsCDS.FieldByName('GoodsName').AsString;
            ListGoodsKeywordCDS.FieldByName('Amount').AsCurrency := RemainsCDS.FieldByName('Remains').AsCurrency;
            ListGoodsKeywordCDS.FieldByName('AccommodationName').AsString := RemainsCDS.FieldByName('AccommodationName').AsString;
          end;
          ListGoodsKeywordCDS.Post;
        end;
        RemainsCDS.Next;
      end;
    finally
      ListGoodsKeywordCDS.EnableControls;
    end;

  end else
  begin
    pnlLocal.Visible := False;
    ExecuteDialog.Execute;
    spSelect.Execute();
  end;

end;

procedure TListGoodsKeywordForm.ParentFormCreate(Sender: TObject);
begin
  actRefreshGridExecute(Sender);
end;

End.
