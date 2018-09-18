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
  procedure ListDiffAddGoods(ListGoodsCDS : TClientDataSet);

  var MutexDiffCDS: THandle;

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

procedure ListDiffAddGoods(ListGoodsCDS : TClientDataSet);
  var  AValues: array[0..1] of string; nCount, nInput : currency;
      ListDiffCDS : TClientDataSet;
begin

  if not ListGoodsCDS.Active  then Exit;
  if ListGoodsCDS.RecordCount < 1  then Exit;
  if not CheckListDiffCDS then Exit;

  AValues[0] := '1'; AValues[1] := '';

  WaitForSingleObject(MutexDiffCDS, INFINITE);
  try
    ListDiffCDS :=  TClientDataSet.Create(Nil);
    try
      try
        LoadLocalData(ListDiffCDS, ListDiff_lcl);
        if not ListDiffCDS.Active then ListDiffCDS.Open;

        nInput := 0;
        ListDiffCDS.First;
        while not ListDiffCDS.Eof do
        begin
          if (ListDiffCDS.FieldByName('ID').AsInteger = ListGoodsCDS.FieldByName('ID').AsInteger) and
            (StartOfTheDay(ListDiffCDS.FieldByName('DateInput').AsDateTime) = Date) then
            nInput := nInput + ListDiffCDS.FieldByName('Amount').AsCurrency;
          ListDiffCDS.Next;
        end;

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

          if not TryStrToCurr(AValues[0], nCount) or (nCount = 0) then
          begin
            ShowMessage('Должно быть число не равное 0.');
          end else if (nInput + nCount) < 0 then
          begin
            if nInput = 0 then
              ShowMessage('Медикамент в течении дня не добавлялся в лист оказов.')
            else ShowMessage('Вы пытаетест отменить с листа отказов больше чем добавлено.'#13#10 +
                             'Можно вернуть не более ' + CurrToStr(nInput));
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

        ListDiffCDS.Append;
        ListDiffCDS.FieldByName('ID').AsInteger := ListGoodsCDS.FieldByName('ID').AsInteger;
        ListDiffCDS.FieldByName('Amount').AsCurrency := nCount;
        ListDiffCDS.FieldByName('Code').AsInteger := ListGoodsCDS.FieldByName('GoodsCode').AsInteger;
        ListDiffCDS.FieldByName('Name').AsString := ListGoodsCDS.FieldByName('GoodsName').AsString;
        ListDiffCDS.FieldByName('Price').AsCurrency := ListGoodsCDS.FieldByName('Price').AsCurrency;
        if AValues[1] <> '' then ListDiffCDS.FieldByName('Comment').AsString := AValues[1]
        else ListDiffCDS.FieldByName('Comment').AsVariant := Null;
        ListDiffCDS.FieldByName('UserID').AsString := gc_User.Session;
        ListDiffCDS.FieldByName('UserName').AsString := gc_User.Login;
        ListDiffCDS.FieldByName('DateInput').AsDateTime := Now;
        ListDiffCDS.FieldByName('IsSend').AsBoolean := False;
        ListDiffCDS.Post;
        SaveLocalData(ListDiffCDS, ListDiff_lcl);
      Except ON E:Exception do
        ShowMessage('Ошибка сохранения листа отказов:'#13#10 + E.Message);
      end;
    finally
      if ListDiffCDS.Active then ListDiffCDS.Close;
      ListDiffCDS.Free;
    end;
  finally
    ReleaseMutex(MutexDiffCDS);
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
