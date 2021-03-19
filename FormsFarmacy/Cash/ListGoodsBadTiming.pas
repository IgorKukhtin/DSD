unit ListGoodsBadTiming;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, Math,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  dxSkinsdxBarPainter, dxBar, cxSpinEdit, dxBarExtItems, cxBarEditItem,
  cxBlobEdit, cxCheckBox, cxNavigator, RegularExpressions, dxDateRanges,
  System.Actions;

type
  TListGoodsBadTimingForm = class(TAncestorBaseForm)
    ListGoodsBadTimingGrid: TcxGrid;
    ListGoodsBadTimingGridDBTableView: TcxGridDBTableView;
    ListGoodsBadTimingGridLevel: TcxGridLevel;
    ListGoodsBadTimingDS: TDataSource;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    AmountSend: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    ListGoodsBadTimingCDS: TClientDataSet;
    BarManager: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    actSend: TAction;
    dxBarButton1: TdxBarButton;
    cxBarEditItem1: TcxBarEditItem;
    dxBarButton2: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    dxBarStatic1: TdxBarStatic;
    spListGoodsBadTiming: TdsdStoredProc;
    ExpirationDate: TcxGridDBColumn;
    PartionDateKindName: TcxGridDBColumn;
    Remount: TcxGridDBColumn;
    AmountCheck: TcxGridDBColumn;
    SummaCheck: TcxGridDBColumn;
    actClear: TAction;
    bbClear: TdxBarButton;
    actExportExel: TdsdGridToExcel;
    bbExportExel: TdxBarButton;
    actAddOne: TAction;
    DBViewAddOn: TdsdDBViewAddOn;
    procedure ListGoodsBadTimingCDSBeforePost(DataSet: TDataSet);
    procedure ParentFormDestroy(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure ListGoodsBadTimingCDSAfterOpen(DataSet: TDataSet);
    procedure actAddOneExecute(Sender: TObject);
    procedure actSendExecute(Sender: TObject);
  private
    { Private declarations }
    FIsLoad : boolean;
  public
  end;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;

procedure TListGoodsBadTimingForm.actAddOneExecute(Sender: TObject);
begin
  if ListGoodsBadTimingCDS.FieldByName('Remount').AsCurrency > ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency then
  begin
    ListGoodsBadTimingCDS.Edit;
    ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency := ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency +
      Min(1, ListGoodsBadTimingCDS.FieldByName('Remount').AsCurrency - ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency);
    ListGoodsBadTimingCDS.Post;
  end;
end;

procedure TListGoodsBadTimingForm.actClearExecute(Sender: TObject);
  var nPos : integer;
begin
  inherited;
  ListGoodsBadTimingCDS.DisableControls;
  nPos := ListGoodsBadTimingCDS.RecNo;
  try
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin
      if ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency <> 0 then
      begin
        ListGoodsBadTimingCDS.Edit;
        ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency := 0;
        ListGoodsBadTimingCDS.Post;
      end;
      ListGoodsBadTimingCDS.Next;
    end;
  finally
    ListGoodsBadTimingCDS.RecNo := nPos;
    ListGoodsBadTimingCDS.EnableControls;
    if FileExists(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat') then DeleteFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
  end;
end;

procedure TListGoodsBadTimingForm.actSendExecute(Sender: TObject);
begin
  inherited;
//
end;

procedure TListGoodsBadTimingForm.ListGoodsBadTimingCDSAfterOpen(
  DataSet: TDataSet);
  var List : TStringList; I, nRecNo : Integer; Res: TArray<string>;

  function StrToVar(AStr : String) : Variant;
  begin
    if AStr = '' then Result := Null
    else Result := StrToInt(AStr);
  end;

begin
  inherited;

  try
    nRecNo := MainCashForm.RemainsCDS.RecNo;
    MainCashForm.RemainsCDS.DisableControls;
    MainCashForm.RemainsCDS.Filtered := false;
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin
      if not MainCashForm.RemainsCDS.Locate('ID;PartionDateKindId;NDSKindId;DiscountExternalID;DivisionPartiesID',
                VarArrayOf([ListGoodsBadTimingCDS.FieldByName('Id').AsInteger,
                            ListGoodsBadTimingCDS.FieldByName('PartionDateKindId').AsVariant,
                            ListGoodsBadTimingCDS.FieldByName('NDSKindId').AsVariant,
                            ListGoodsBadTimingCDS.FieldByName('DiscountExternalID').AsVariant,
                            ListGoodsBadTimingCDS.FieldByName('DivisionPartiesID').AsVariant]), []) then
      begin
        ListGoodsBadTimingCDS.Edit;
        ListGoodsBadTimingCDS.FieldByName('Price').AsVariant := MainCashForm.RemainsCDS.FieldByName('Price').AsVariant;
        ListGoodsBadTimingCDS.Post;
      end;
      ListGoodsBadTimingCDS.Next;
    end;
  finally
    MainCashForm.RemainsCDS.Filtered := True;
    MainCashForm.RemainsCDS.RecNo := nRecNo;
    MainCashForm.RemainsCDS.EnableControls;
  end;

  if MainCashForm.FormParams.ParamByName('isCorrectMarketing').Value then
  begin

  end else
  begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat') then Exit;
    List := TStringList.Create;
    ListGoodsBadTimingCDS.DisableControls;
    try
      FIsLoad := True;
      List.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
      for I := 0 to List.Count - 1 do
      begin
         Res := TRegEx.Split(List.Strings[I], ';');
         if High(Res) <> 5 then Continue;
         if ListGoodsBadTimingCDS.Locate('ID;PartionDateKindId;DivisionPartiesID;DiscountExternalID;NDSKindId',
            VarArrayOf([StrToInt(Res[0]), StrToVar(Res[2]), StrToVar(Res[3]), StrToVar(Res[4]), StrToVar(Res[5])]), []) then
         begin
           ListGoodsBadTimingCDS.Edit;
           ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency := Min(ListGoodsBadTimingCDS.FieldByName('Remount').AsCurrency, StrToCurr(Res[1]));
           ListGoodsBadTimingCDS.Post;
         end;
      end;
    finally
      FIsLoad := False;
      ListGoodsBadTimingCDS.First;
      ListGoodsBadTimingCDS.EnableControls;
      List.Free;
    end;
  end;
end;

procedure TListGoodsBadTimingForm.ListGoodsBadTimingCDSBeforePost(
  DataSet: TDataSet);
begin
  inherited;

  if not FIsLoad then
  begin
    if Dataset['AmountCheck'] > Dataset['Remount'] then
    begin
      raise Exception.Create('Количество больше остатка...');
      Exit;
    end;

    if Dataset['AmountCheck'] < 0 then
    begin
      raise Exception.Create('Количество больше или равно 0...');
      Exit;
    end;

    if Dataset['AmountCheck'] > (Dataset['Remount'] - Dataset['AmountSend']) then
    begin
      ShowMessage('Товар отложен в перемещении на склад отложки перед опуском надо будет отменить отложку...');
    end;
  end;

  Dataset['SummaCheck'] := Dataset['Price'] * Dataset['AmountCheck'];
end;

procedure TListGoodsBadTimingForm.ParentFormDestroy(Sender: TObject);
  var List : TStringList;
begin
  inherited;

  List := TStringList.Create;
  ListGoodsBadTimingCDS.DisableControls;
  try
    ListGoodsBadTimingCDS.First;
    while not ListGoodsBadTimingCDS.Eof do
    begin
      if ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsCurrency > 0 then
        List.Add(ListGoodsBadTimingCDS.FieldByName('Id').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('AmountCheck').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('PartionDateKindId').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('DivisionPartiesId').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('DiscountExternalID').AsString + ';' +
                 ListGoodsBadTimingCDS.FieldByName('NDSKindId').AsString);
      ListGoodsBadTimingCDS.Next;
    end;
  finally
    ListGoodsBadTimingCDS.EnableControls;
    if List.Count > 0 then List.SaveToFile(ExtractFilePath(ParamStr(0)) + 'GoodsBadTiming.dat');
    List.Free;
  end;
end;

initialization
  RegisterClass(TListGoodsBadTimingForm);


End.
