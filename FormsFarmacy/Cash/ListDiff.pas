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
  cxBlobEdit, cxCheckBox, cxNavigator, dxDateRanges, System.Actions;

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
    colDiffKindId: TcxGridDBColumn;
    DiffKindCDS: TClientDataSet;
    procedure ParentFormCreate(Sender: TObject);
    procedure actSendExecute(Sender: TObject);
    procedure colDiffKindIdGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);
  private
    { Private declarations }
  public
  end;

  function CheckListDiffCDS : boolean;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;

function CheckListDiffStrucnureCDS : boolean;
  var ListDiffCDS, ListDiffNewCDS : TClientDataSet;
begin
  Result := False;
  try
    ListDiffCDS :=  TClientDataSet.Create(Nil);
    ListDiffNewCDS :=  TClientDataSet.Create(Nil);
    try
      LoadLocalData(ListDiffCDS, ListDiff_lcl);
      if not ListDiffCDS.Active then Exit;

      if not Assigned(ListDiffCDS.FindField('DiffKindId')) or
         (ListDiffCDS.FindField('Amount').DataType <> ftFloat) or
         TRUE then
      begin
        ListDiffNewCDS.FieldDefs.Add('ID', ftInteger);
        ListDiffNewCDS.FieldDefs.Add('Code', ftInteger);
        ListDiffNewCDS.FieldDefs.Add('Name', ftString, 255);
        ListDiffNewCDS.FieldDefs.Add('Amount', ftFloat);
        ListDiffNewCDS.FieldDefs.Add('Price', ftFloat);
        ListDiffNewCDS.FieldDefs.Add('DiffKindId', ftInteger);
        ListDiffNewCDS.FieldDefs.Add('Comment', ftString, 255);
        ListDiffNewCDS.FieldDefs.Add('UserID', ftInteger);
        ListDiffNewCDS.FieldDefs.Add('UserName', ftString, 80);
        ListDiffNewCDS.FieldDefs.Add('DateInput', ftDateTime);
        ListDiffNewCDS.FieldDefs.Add('IsSend', ftBoolean);
        ListDiffNewCDS.CreateDataSet;
        ListDiffNewCDS.Open;

        ListDiffCDS.First;
        while not ListDiffCDS.Eof do
        begin
          ListDiffNewCDS.Append;
          ListDiffNewCDS.FieldByName('ID').AsVariant := ListDiffCDS.FieldByName('ID').AsVariant;
          ListDiffNewCDS.FieldByName('Code').AsVariant := ListDiffCDS.FieldByName('Code').AsVariant;
          ListDiffNewCDS.FieldByName('Name').AsVariant := ListDiffCDS.FieldByName('Name').AsVariant;
          ListDiffNewCDS.FieldByName('Amount').AsVariant := ListDiffCDS.FieldByName('Amount').AsVariant;
          ListDiffNewCDS.FieldByName('Price').AsVariant := ListDiffCDS.FieldByName('Price').AsVariant;
          ListDiffNewCDS.FieldByName('DiffKindId').AsVariant := ListDiffCDS.FieldByName('DiffKindId').AsVariant;
          ListDiffNewCDS.FieldByName('Comment').AsVariant := ListDiffCDS.FieldByName('Comment').AsVariant;
          ListDiffNewCDS.FieldByName('UserID').AsVariant := ListDiffCDS.FieldByName('UserID').AsVariant;
          ListDiffNewCDS.FieldByName('UserName').AsVariant := ListDiffCDS.FieldByName('UserName').AsVariant;
          ListDiffNewCDS.FieldByName('DateInput').AsVariant := ListDiffCDS.FieldByName('DateInput').AsVariant;
          ListDiffNewCDS.FieldByName('IsSend').AsVariant := ListDiffCDS.FieldByName('IsSend').AsVariant;
          ListDiffNewCDS.Post;
          ListDiffCDS.Next;
        end;

        SaveLocalData(ListDiffNewCDS, ListDiff_lcl);
      end;
      Result := True;
    finally
      if ListDiffCDS.Active then ListDiffCDS.Close;
      ListDiffCDS.Free;
      if ListDiffNewCDS.Active then ListDiffNewCDS.Close;
      ListDiffNewCDS.Free;
    end;
  Except ON E:Exception do
    ShowMessage('Ошибка создания листа отказов:'#13#10 + E.Message);
  end;
end;

function CheckListDiffCDS : boolean;
  var ListDiffCDS : TClientDataSet;
begin
  ListDiffCDS :=  TClientDataSet.Create(Nil);
  try
    LoadLocalData(ListDiffCDS, ListDiff_lcl);
    if ListDiffCDS.Active then
    begin
      Result := CheckListDiffStrucnureCDS;
      Exit;
    end;

    try
      ListDiffCDS.FieldDefs.Add('ID', ftInteger);
      ListDiffCDS.FieldDefs.Add('Code', ftInteger);
      ListDiffCDS.FieldDefs.Add('Name', ftString, 255);
      ListDiffCDS.FieldDefs.Add('Amount', ftFloat);
      ListDiffCDS.FieldDefs.Add('Price', ftFloat);
      ListDiffCDS.FieldDefs.Add('DiffKindId', ftInteger);
      ListDiffCDS.FieldDefs.Add('Comment', ftString, 255);
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
      if not ListDiffCDS.Active then Exit;

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

procedure TListDiffForm.colDiffKindIdGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: string);
  var I : Integer;
begin
  if not TryStrToInt(AText, I) then Exit;
  if not DiffKindCDS.Active then Exit;
  if DiffKindCDS.Locate('id', I, []) then
       AText := DiffKindCDS.FieldByName('Name').AsString;
end;

procedure TListDiffForm.ParentFormCreate(Sender: TObject);
begin
  if FileExists(DiffKind_lcl) then
  begin
    WaitForSingleObject(MutexDiffKind, INFINITE);
    try
      LoadLocalData(DiffKindCDS,DiffKind_lcl);
      if not DiffKindCDS.Active then DiffKindCDS.Open;
    finally
      ReleaseMutex(MutexDiffKind);
    end;
  end;

  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    if FileExists(ListDiff_lcl) then LoadLocalData(ListDiffCDS, ListDiff_lcl);
    if not ListDiffCDS.Active then
    begin
      CheckListDiffCDS;
      LoadLocalData(ListDiffCDS, ListDiff_lcl);
    end;
  finally
    ReleaseMutex(MutexDiffCDS);
  end;

end;

End.
