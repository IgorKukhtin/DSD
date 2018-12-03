unit ListDiff;

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
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit, cxCheckBox;

type
  TListDiffForm = class(TAncestorBaseForm)
    ListDiffGrid: TcxGrid;
    ListDiffGridDBTableView: TcxGridDBTableView;
    ListDiffGridLevel: TcxGridLevel;
    ListDiffDS: TDataSource;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    ListDiffCDS: TClientDataSet;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    actSend: TAction;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    spSendListDiff: TdsdStoredProc;
    colComment: TcxGridDBColumn;
    colIsSend: TcxGridDBColumn;
    colDateInput: TcxGridDBColumn;
    colUserName: TcxGridDBColumn;
    procedure ParentFormCreate(Sender: TObject);
    procedure actSendExecute(Sender: TObject);
  private
    { Private declarations }
  public
  end;

  function CheckListDiffCDS : boolean;

  var MutexDiffCDS: THandle;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;


function CheckListDiffCDS : boolean;
  var ListDiffCDS : TClientDataSet;
begin
  Result := FileExists(ListDiff_lcl);
  if FileExists(ListDiff_lcl) then Exit;
  ListDiffCDS :=  TClientDataSet.Create(Nil);
  try
    try
      ListDiffCDS.FieldDefs.Add('ID', ftInteger);
      ListDiffCDS.FieldDefs.Add('Code', ftInteger);
      ListDiffCDS.FieldDefs.Add('Name', ftString, 200);
      ListDiffCDS.FieldDefs.Add('Amount', ftCurrency);
      ListDiffCDS.FieldDefs.Add('Price', ftCurrency);
      ListDiffCDS.FieldDefs.Add('Comment', ftString, 400);
      ListDiffCDS.FieldDefs.Add('UserID', ftInteger);
      ListDiffCDS.FieldDefs.Add('UserName', ftString, 80);
      ListDiffCDS.FieldDefs.Add('DateInput', ftDateTime);
      ListDiffCDS.FieldDefs.Add('IsSend', ftBoolean);
      ListDiffCDS.CreateDataSet;
      SaveLocalData(ListDiffCDS, ListDiff_lcl);
      Result := True;
    Except ON E:Exception do
      ShowMessage('Ошибка создания листа отказов:'#13#10 + E.Message);
    end;
  finally
    if ListDiffCDS.Active then ListDiffCDS.Close;
    ListDiffCDS.Free;
  end;
end;

procedure TListDiffForm.actSendExecute(Sender: TObject);
begin
  if not ListDiffCDS.Active  then Exit;
  if ListDiffCDS.RecordCount < 1  then Exit;

  if MessageDlg('Отправить все медикаменты с листа отказов?',
     mtConfirmation,[mbYes,mbNo], 0) <> mrYes then Exit;

  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    try

      LoadLocalData(ListDiffCDS, ListDiff_lcl);
      if not ListDiffCDS.Active then ListDiffCDS.Open;

      ListDiffCDS.First;
      while not ListDiffCDS.Eof do
      begin
        if not ListDiffCDS.FieldByName('IsSend').AsBoolean then
        begin
          spSendListDiff.Execute;
          ListDiffCDS.Edit;
          ListDiffCDS.FieldByName('IsSend').AsBoolean := True;
          ListDiffCDS.Post;
        end;
        ListDiffCDS.Next;
      end;
      SaveLocalData(ListDiffCDS, ListDiff_lcl);

    Except ON E:Exception do
      ShowMessage('Ошибка отправки листа отказов:'#13#10 + E.Message);
    end;
  finally
    ReleaseMutex(MutexDiffCDS);
  end;
end;

procedure TListDiffForm.ParentFormCreate(Sender: TObject);
begin
  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    if FileExists(ListDiff_lcl) then LoadLocalData(ListDiffCDS, ListDiff_lcl);
    if not ListDiffCDS.Active then ListDiffCDS.Open;
  finally
    ReleaseMutex(MutexDiffCDS);
  end;
end;

End.
