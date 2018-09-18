unit ListDiff;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit;

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
    actDelete: TAction;
    actSend: TAction;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    spSendListDiff: TdsdStoredProc;
    ListDiffGridDBTableViewColumn1: TcxGridDBColumn;
    procedure ParentFormCreate(Sender: TObject);
    procedure ListDiffCDSBeforePost(DataSet: TDataSet);
    procedure ParentFormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSendExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure ListDiffCDSAfterPost(DataSet: TDataSet);
    procedure ParentFormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
  end;

function CheckListDiffCDS : boolean;
procedure ListDiffAddGoods(ListGoodsCDS : TClientDataSet);

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData;


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

procedure ListDiffAddGoods(ListGoodsCDS : TClientDataSet);
  var  AValues: array[0..1] of string; nCount : currency;
      ListDiffCDS : TClientDataSet;
begin

  if not ListGoodsCDS.Active  then Exit;
  if ListGoodsCDS.RecordCount < 1  then Exit;
  if not CheckListDiffCDS then Exit;

  AValues[0] := '1'; AValues[1] := '';

  if not InputQuery('Добавление препарата в лист отказов', ['Препарат: '#13#10 +
    ListGoodsCDS.FieldByName('GoodsName').AsString +
    #13#10#13#10'Количество', 'Примечание'], AValues,
  function (const AValues: array of string) : boolean
    var I : integer; E1, E2 : TEdit;
  begin
    Result := False; E1 := Nil;

    for I := 0 to Screen.ActiveForm.ComponentCount - 1 do
      if Screen.ActiveForm.Components[I] is TEdit then
      begin
        if E1 = Nil then E1 := TEdit(Screen.ActiveForm.Components[I])
        else
        begin
          E2 := TEdit(Screen.ActiveForm.Components[I]);
          Break;
        end;
      end;

    if not TryStrToCurr(AValues[0], nCount) or (nCount <= 0) then
    begin
      ShowMessage('Должно быть число от больше 0.');
    end else Result := True;

    if Result then
    begin
      if Screen.ActiveForm.ActiveControl = E1 then
      begin
        E2.SetFocus;
        Result := False;
      end;
    end else
    begin
      E1.SetFocus;
    end;
  end) then Exit;

  ListDiffCDS :=  TClientDataSet.Create(Nil);
  try
    try
      LoadLocalData(ListDiffCDS, ListDiff_lcl);
      if not ListDiffCDS.Active then ListDiffCDS.Open;
      if not ListDiffCDS.Locate('ID', ListGoodsCDS.FieldByName('ID').AsInteger, []) then
      begin
        ListDiffCDS.Append;
        ListDiffCDS.FieldByName('ID').AsInteger := ListGoodsCDS.FieldByName('ID').AsInteger;
        ListDiffCDS.FieldByName('Amount').AsCurrency := nCount;
      end else
      begin
        ListDiffCDS.Edit;
        ListDiffCDS.FieldByName('Amount').AsCurrency := ListDiffCDS.FieldByName('Amount').AsCurrency + nCount;
      end;
      ListDiffCDS.FieldByName('Code').AsInteger := ListGoodsCDS.FieldByName('GoodsCode').AsInteger;
      ListDiffCDS.FieldByName('Name').AsString := ListGoodsCDS.FieldByName('GoodsName').AsString;
      ListDiffCDS.FieldByName('Price').AsCurrency := ListGoodsCDS.FieldByName('Price').AsCurrency;
      if AValues[1] <> '' then ListDiffCDS.FieldByName('Comment').AsString := AValues[1]
      else ListDiffCDS.FieldByName('Comment').AsVariant := Null;
      ListDiffCDS.Post;
      SaveLocalData(ListDiffCDS, ListDiff_lcl);
    Except ON E:Exception do
      ShowMessage('Ошибка сохранения листа отказов:'#13#10 + E.Message);
    end;
  finally
    if ListDiffCDS.Active then ListDiffCDS.Close;
    ListDiffCDS.Free;
  end;
end;


procedure TListDiffForm.actDeleteExecute(Sender: TObject);
begin
  if not ListDiffCDS.Active  then Exit;
  if ListDiffCDS.RecordCount < 1  then Exit;

  if MessageDlg('Удалить из листа отказов:'#13#10#13#10 +
     ListDiffCDS.FieldByName('Name').AsString,
     mtConfirmation,[mbYes,mbNo], 0) <> mrYes then Exit;

  try
    if ListDiffCDS.State = dsEdit then ListDiffCDS.Post;
    ListDiffCDS.Delete;
    SaveLocalData(ListDiffCDS, ListDiff_lcl);
  Except ON E:Exception do
    ShowMessage('Ошибка сохранения листа отказов:'#13#10 + E.Message);
  end;
end;

procedure TListDiffForm.actSendExecute(Sender: TObject);
begin
  if not ListDiffCDS.Active  then Exit;
  if ListDiffCDS.RecordCount < 1  then Exit;

  if MessageDlg('Отправить все медикаменты с листа отказов?',
     mtConfirmation,[mbYes,mbNo], 0) <> mrYes then Exit;

  try
    if ListDiffCDS.State = dsEdit then ListDiffCDS.Post;
    ListDiffCDS.First;
    while not ListDiffCDS.Eof do
    begin
      if ListDiffCDS.FieldByName('Amount').AsCurrency > 0 then spSendListDiff.Execute;
      ListDiffCDS.Delete;
      SaveLocalData(ListDiffCDS, ListDiff_lcl);
    end;
  Except ON E:Exception do
    ShowMessage('Ошибка отправки листа отказов:'#13#10 + E.Message);
  end;

end;

procedure TListDiffForm.ListDiffCDSAfterPost(DataSet: TDataSet);
begin
  try
    SaveLocalData(ListDiffCDS, ListDiff_lcl);
  Except ON E:Exception do
    ShowMessage('Ошибка сохранения листа отказов:'#13#10 + E.Message);
  end;
end;

procedure TListDiffForm.ListDiffCDSBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('Amount').AsCurrency < 0 then
    raise Exception.Create('Количество должно быть больне нуля!');
end;

procedure TListDiffForm.ParentFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    if ListDiffCDS.State = dsEdit then
    begin
      ListDiffCDS.Post;
      SaveLocalData(ListDiffCDS, ListDiff_lcl);
    end;
  Except ON E:Exception do
    begin
      Action := caNone;
      ShowMessage('Ошибка сохранения листа отказов:'#13#10 + E.Message);
    end;
  end;
end;

procedure TListDiffForm.ParentFormCreate(Sender: TObject);
begin
  if FileExists(ListDiff_lcl) then LoadLocalData(ListDiffCDS, ListDiff_lcl);
  if not ListDiffCDS.Active then ListDiffCDS.Open;
end;

procedure TListDiffForm.ParentFormDestroy(Sender: TObject);
begin
  try
    if ListDiffCDS.State = dsEdit then ListDiffCDS.Post;
  Except ON E:Exception do
      ShowMessage('Ошибка сохранения листа отказов:'#13#10 + E.Message);
  end;
end;

End.
