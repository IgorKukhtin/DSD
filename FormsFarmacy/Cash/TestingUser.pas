unit TestingUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  System.DateUtils, Dialogs, StdCtrls, Mask, DB, Buttons, System.StrUtils,
  Gauges, cxGraphics, cxControls, cxLookAndFeels, Math,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxCurrencyEdit,
  cxClasses, cxPropertiesStore, dsdAddOn, dxSkinsCore, dxSkinsDefaultPainters,
  Datasnap.DBClient, Vcl.Menus, cxButtons, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxMaskEdit, Vcl.ExtCtrls,
  Vcl.ActnList, cxButtonEdit, cxLabel, cxMemo, dsdDB, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxNavigator, cxDBData,
  cxGridCustomTableView, cxGridCardView, cxGridDBCardView,
  cxGridCustomLayoutView, cxGridLevel, cxGridCustomView, cxGridTableView,
  cxGridDBTableView, cxGrid, Vcl.Grids, cxCheckBox, cxImage;

type
  TTestingUserForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ActionList1: TActionList;
    meQuestion: TcxMemo;
    cxLabel1: TcxLabel;
    Panel5: TPanel;
    mePossibleAnswer1: TcxMemo;
    mePossibleAnswer2: TcxMemo;
    Panel6: TPanel;
    mePossibleAnswer3: TcxMemo;
    mePossibleAnswer4: TcxMemo;
    bOk: TcxButton;
    Timer1: TTimer;
    laTime: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    spTitle: TdsdStoredProc;
    TitleCDS: TClientDataSet;
    TaskCDS: TClientDataSet;
    spTask: TdsdStoredProc;
    TaskDS: TDataSource;
    sgViewingResults: TStringGrid;
    cbLastMonth: TcxCheckBox;
    actInsertUpdate_TestingUser: TdsdStoredProc;
    imPossibleAnswer1: TcxImage;
    imPossibleAnswer2: TcxImage;
    imPossibleAnswer3: TcxImage;
    imPossibleAnswer4: TcxImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure mePossibleAnswer1DblClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure bOkKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure bOkExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure sgViewingResultsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgViewingResultsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbLastMonthClick(Sender: TObject);
    procedure mePossibleAnswer1Click(Sender: TObject);
    procedure imPossibleAnswer1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FMemo : TcxMemo;
    FImage: TcxImage;
    FStart : Boolean;
    FPassed : Boolean;
    FFocused : Integer;
    FShielding : Boolean;

    FTimeEnd : TDateTime;
    procedure SetQuestion;
  public
    procedure CommitTest;
  end;

  procedure ShowTestingUser;

implementation

{$R *.dfm}

uses CommonData, LocalWorkUnit, PUSHMessage, FormStorage;

{ TTestingUserForm }

procedure SetImage(Image : TcxImage; Text : String);
  var Item: TCollectionItem;
      Data : AnsiString; Len, I, J : Integer;
      Graphic: TGraphic; Ext, FieldName: string;
      GraphicClass: TGraphicClass;
      MemoryStream : TMemoryStream;
begin
  try
    MemoryStream := TMemoryStream.Create;
    try
      Image.Clear;

      Data := ReConvertConvert(Text);
      Ext := trim(Copy(Data, 1, 255));
      Ext := AnsiLowerCase(ExtractFileExt(Ext));
      Delete(Ext, 1, 1);

      if 'wmf' = Ext then GraphicClass := TMetafile;
      if 'emf' =  Ext then GraphicClass := TMetafile;
      if 'ico' =  Ext then GraphicClass := TIcon;
      if 'tiff' = Ext then GraphicClass := TWICImage;
      if 'tif' = Ext then GraphicClass := TWICImage;
      if 'png' = Ext then GraphicClass := TWICImage;
      if 'gif' = Ext then GraphicClass := TWICImage;
      if 'jpeg' = Ext then GraphicClass := TWICImage;
      if 'jpg' = Ext then GraphicClass := TWICImage;
      if 'bmp' = Ext then GraphicClass := TBitmap;
      if GraphicClass = nil then Exit;

      Data := Copy(Data, 256, maxint);
      Len := Length(Data);
      MemoryStream.WriteBuffer(Data[1],  Len);
      MemoryStream.Position := 0;

      Graphic := TGraphicClass(GraphicClass).Create;
      try
        Graphic.LoadFromStream(MemoryStream);
        Image.Picture.Graphic := Graphic;
      finally
        Graphic.Free;
      end;
    finally
      MemoryStream.Free
    end;
  except
  end;
end;

procedure TTestingUserForm.mePossibleAnswer1Click(Sender: TObject);
begin
  if Sender is TcxMemo then FFocused := TcxMemo(Sender).Tag
  else if Sender is TcxImage then FFocused := TcxImage(Sender).Tag;
end;

procedure TTestingUserForm.mePossibleAnswer1DblClick(Sender: TObject);
begin
  if FPassed then Exit;
  FImage := Nil;
  FMemo := Nil;
  if Sender is TcxMemo then
  begin
    FMemo := TcxMemo(Sender);
    FMemo.Style.BorderColor := FMemo.StyleFocused.BorderColor;
    FMemo.Style.Color := FMemo.StyleFocused.Color;
    FMemo.Style.TextColor := FMemo.StyleFocused.TextColor;
  end else if Sender is TcxImage then
  begin
    FImage := TcxImage(Sender);
    FImage.Style.BorderColor := FImage.StyleFocused.BorderColor;
    FImage.Style.Color := FImage.StyleFocused.Color;
    FImage.Style.TextColor := FImage.StyleFocused.TextColor;
  end;
  bOk.Caption := 'Подтвердите вариант ' + IntToStr(FFocused);
  bOk.Visible := True;
  bOk.SetFocus;
end;

procedure TTestingUserForm.SetQuestion;
begin
  FFocused := 1;

  meQuestion.Lines.Text := TaskCDS.FieldByName('Question').AsString;

  if TaskCDS.FieldByName('isGraphics1').AsBoolean then
  begin
    SetImage(imPossibleAnswer1, TaskCDS.FieldByName('PossibleAnswer1').AsString);
    mePossibleAnswer1.Visible := False;
  end else
  begin
    mePossibleAnswer1.Lines.Text := ' 1. ' + TaskCDS.FieldByName('PossibleAnswer1').AsString;
    mePossibleAnswer1.Visible := True;
    if Length(mePossibleAnswer1.Lines.Text) > 300 then
      mePossibleAnswer1.Style.Font.Size := meQuestion.Style.Font.Size * 8 DIV 10
    else mePossibleAnswer1.Style.Font.Size := meQuestion.Style.Font.Size;
  end;

  if TaskCDS.FieldByName('isGraphics2').AsBoolean then
  begin
    SetImage(imPossibleAnswer2, TaskCDS.FieldByName('PossibleAnswer2').AsString);
    mePossibleAnswer2.Visible := False;
  end else
  begin
    mePossibleAnswer2.Lines.Text := ' 2. ' + TaskCDS.FieldByName('PossibleAnswer2').AsString;
    mePossibleAnswer2.Visible := True;
    if Length(mePossibleAnswer2.Lines.Text) > 300 then
      mePossibleAnswer2.Style.Font.Size := meQuestion.Style.Font.Size * 8 DIV 10
    else mePossibleAnswer2.Style.Font.Size := meQuestion.Style.Font.Size;
  end;

  if TaskCDS.FieldByName('isGraphics3').AsBoolean then
  begin
    SetImage(imPossibleAnswer3, TaskCDS.FieldByName('PossibleAnswer3').AsString);
    mePossibleAnswer3.Visible := False;
  end else
  begin
    mePossibleAnswer3.Lines.Text := ' 3. ' + TaskCDS.FieldByName('PossibleAnswer3').AsString;
    mePossibleAnswer3.Visible := True;
    if Length(mePossibleAnswer3.Lines.Text) > 300 then
      mePossibleAnswer3.Style.Font.Size := meQuestion.Style.Font.Size * 8 DIV 10
    else mePossibleAnswer3.Style.Font.Size := meQuestion.Style.Font.Size;
  end;

  if TaskCDS.FieldByName('isGraphics4').AsBoolean then
  begin
    SetImage(imPossibleAnswer4, TaskCDS.FieldByName('PossibleAnswer4').AsString);
    mePossibleAnswer4.Visible := False;
  end else
  begin
    mePossibleAnswer4.Lines.Text := ' 4. ' + TaskCDS.FieldByName('PossibleAnswer4').AsString;
    mePossibleAnswer4.Visible := True;
    if Length(mePossibleAnswer4.Lines.Text) > 300 then
      mePossibleAnswer4.Style.Font.Size := meQuestion.Style.Font.Size * 8 DIV 10
    else mePossibleAnswer4.Style.Font.Size := meQuestion.Style.Font.Size;
  end;

  imPossibleAnswer1.Visible := not mePossibleAnswer1.Visible;
  imPossibleAnswer2.Visible := not mePossibleAnswer2.Visible;
  imPossibleAnswer3.Visible := not mePossibleAnswer3.Visible;
  imPossibleAnswer4.Visible := not mePossibleAnswer4.Visible;
  if imPossibleAnswer1.Visible then ActiveControl := imPossibleAnswer1 else ActiveControl := mePossibleAnswer1;
end;

procedure TTestingUserForm.sgViewingResultsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
  var S : string;
begin
  if gdFocused in State then
  begin
     sgViewingResults.Canvas.Brush.Color := clHighlight;
     sgViewingResults.Canvas.Font.Color := clHighlightText;
  end else
  begin
    sgViewingResults.Canvas.Brush.Color := clWindow;

    TaskCDS.Locate('ID', ACol + 1, []);
    if TaskCDS.FieldByName('CorrectAnswer').AsInteger = TaskCDS.FieldByName('Response').AsInteger then
      sgViewingResults.Canvas.Font.Color := clWindowText
    else sgViewingResults.Canvas.Font.Color := clRed;
  end;
  sgViewingResults.Canvas.FillRect(Rect);

  S := IntToStr(ACol + 1);
  DrawText((Sender as TStrinGgrid).Canvas.Handle, Pchar(S), Length(S), Rect, DT_WORDBREAK or DT_CENTER or DT_VCENTER);
end;

procedure TTestingUserForm.sgViewingResultsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin

  TaskCDS.Locate('ID', ACol + 1, []);

  SetQuestion;

  mePossibleAnswer1.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 1, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 1, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer1.StyleFocused.Color := mePossibleAnswer1.Style.Color;

  mePossibleAnswer2.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 2, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 2, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer2.StyleFocused.Color := mePossibleAnswer2.Style.Color;

  mePossibleAnswer3.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 3, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 3, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer3.StyleFocused.Color := mePossibleAnswer3.Style.Color;

  mePossibleAnswer4.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 4, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 4, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer4.StyleFocused.Color := mePossibleAnswer4.Style.Color;

  imPossibleAnswer1.Style.BorderColor := mePossibleAnswer1.Style.Color;
  imPossibleAnswer1.StyleFocused.BorderColor := mePossibleAnswer1.Style.Color;
  imPossibleAnswer2.Style.BorderColor := mePossibleAnswer2.Style.Color;
  imPossibleAnswer2.StyleFocused.BorderColor := mePossibleAnswer2.Style.Color;
  imPossibleAnswer3.Style.BorderColor := mePossibleAnswer3.Style.Color;
  imPossibleAnswer3.StyleFocused.BorderColor := mePossibleAnswer3.Style.Color;
  imPossibleAnswer4.Style.BorderColor := mePossibleAnswer4.Style.Color;
  imPossibleAnswer4.StyleFocused.BorderColor := mePossibleAnswer4.Style.Color;

end;

procedure TTestingUserForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not FStart then Close;

  if FTimeEnd < Now then
  begin
    CommitTest;
    Exit;
  end;

  try
    laTime.Caption := IntToStr(Round(SecondSpan(Now, FTimeEnd))) + ' сек.';
  finally
    Timer1.Enabled := True;
  end;
end;

procedure TTestingUserForm.bOkClick(Sender: TObject);
begin
  bOk.Visible := False;
  Timer1.Enabled := False;
  try
    FShielding := True;
    TaskCDS.Edit;
    TaskCDS.FieldByName('Response').AsInteger := FFocused;
    TaskCDS.FieldByName('EndTime').AsDateTime := Now;
    TaskCDS.Post;
    cxLabel3.Caption := 'Вопросов ' + IntToStr(TitleCDS.FieldByName('Question').AsInteger) + ' пройдено ' + TaskCDS.FieldByName('Id').AsString;

    TaskCDS.Next;
    if not TaskCDS.Eof then
    begin
      SetQuestion;
      if mePossibleAnswer1.Visible then mePossibleAnswer1.SetFocus else imPossibleAnswer1.SetFocus;

      TaskCDS.Edit;
      TaskCDS.FieldByName('StartTime').AsDateTime := Now;
      TaskCDS.Post;
    end else CommitTest;
  finally
    if Assigned(FMemo) then
    begin
      FMemo.Style.BorderColor := meQuestion.Style.BorderColor;
      FMemo.Style.Color := meQuestion.Style.Color;
      FMemo.Style.TextColor := meQuestion.Style.TextColor;
    end;
    if Assigned(FImage) then
    begin
      FImage.Style.BorderColor := meQuestion.Style.BorderColor;
      FImage.Style.Color := meQuestion.Style.Color;
      FImage.Style.TextColor := meQuestion.Style.TextColor;
    end;
    Timer1.Enabled := not FPassed;
  end;
end;

procedure TTestingUserForm.bOkExit(Sender: TObject);
begin
  bOk.Visible := False;
  if Assigned(FMemo) then
  begin
    FMemo.Style.BorderColor := meQuestion.Style.BorderColor;
    FMemo.Style.Color := meQuestion.Style.Color;
    FMemo.Style.TextColor := meQuestion.Style.TextColor;
  end;
  if Assigned(FImage) then
  begin
    FImage.Style.BorderColor := meQuestion.Style.BorderColor;
    FImage.Style.Color := meQuestion.Style.Color;
    FImage.Style.TextColor := meQuestion.Style.TextColor;
  end;
end;

procedure TTestingUserForm.bOkKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    bOk.Visible := False;
    if Assigned(FMemo) then FMemo.SetFocus;
    if Assigned(FImage) then FImage.SetFocus;
  end;
end;

procedure TTestingUserForm.cbLastMonthClick(Sender: TObject);
begin
  if ActiveControl = cbLastMonth then mePossibleAnswer1.SetFocus;
end;

procedure TTestingUserForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FStart and not FPassed then
  begin

    if MessageDlg('Прервать выполнение теста?'#13#10#13#10'Попытка будет засчитана.', mtInformation, mbOKCancel, 0) = mrOk then
    begin
      CommitTest;
    end else Action := TCloseAction.caNone;
  end;
end;

procedure TTestingUserForm.FormCreate(Sender: TObject);
begin

  FStart := False;
  FFocused := 1;
  FShielding := False;

  FMemo := Nil;
  FImage := Nil;
  try
    spTitle.Execute;
    spTask.Execute;
  except on E:Exception do
    begin
      if pos('context', AnsilowerCase(e.Message)) > 0 then
         ShowMessage(trim (Copy(e.Message, 1, pos('context', AnsilowerCase(e.Message)) - 1)))
      else ShowMessage(e.Message);
      FStart := False;
      Exit;
    end;
  end;

  FStart := MessageDlg('Начать выполнение теста?'#13#10#13#10'В случае прерывания теста попытка будет засчитана при любом результате.', mtInformation, mbOKCancel, 0) = mrOk;
  FPassed := False;
  if not FStart then Exit;
  cbLastMonth.Checked := MessageDlg('Здача экзамена за:'#13#10#13#10'Yes - текущий месяц'#13#10'No - прошлый месяц', mtInformation, mbYesNo, 0) <> mrYes;

  TaskCDS.First;
  SetQuestion;
end;

procedure TTestingUserForm.FormResize(Sender: TObject);
begin
  Panel5.Width := Panel2.Width div 2;
  mePossibleAnswer1.Height :=  (Panel2.Height - cxLabel1.Height) div 2;
  mePossibleAnswer3.Height :=  (Panel2.Height - cxLabel1.Height) div 2;
  imPossibleAnswer1.Height := mePossibleAnswer1.Height;
  imPossibleAnswer3.Height := mePossibleAnswer3.Height;
  bOk.Left := (Panel2.Width - bOk.Width) div 2
end;

procedure TTestingUserForm.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
  if TitleCDS.Active then
  begin
    cxLabel4.Caption := TitleCDS.FieldByName('UserName').AsString;
    FTimeEnd := IncSecond(Now, TitleCDS.FieldByName('TimeTest').AsInteger);
    laTime.Caption := IntToStr(TitleCDS.FieldByName('TimeTest').AsInteger) + ' сек.';
    cxLabel3.Caption := 'Вопросов ' + IntToStr(TitleCDS.FieldByName('Question').AsInteger) + ' пройдено 0';
  end;
end;

procedure TTestingUserForm.imPossibleAnswer1KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not FPassed and (Shift = []) then
  case Key of
    VK_HOME, VK_NUMPAD7 : FFocused := 1;
    VK_PRIOR, VK_NUMPAD9 : FFocused := 3;
    VK_UP, VK_NUMPAD8 : if FFocused = 2 then FFocused := 1 else if FFocused = 4 then FFocused := 3;
    VK_LEFT, VK_NUMPAD4 : if FFocused = 3 then FFocused := 1 else if FFocused = 4 then FFocused := 2;
    VK_RIGHT, VK_NUMPAD6 : if FFocused = 1 then FFocused := 3 else if FFocused = 2 then FFocused := 4;
    VK_DOWN, VK_NUMPAD2 : if FFocused = 1 then FFocused := 2 else if FFocused = 3 then FFocused := 4;
    VK_END, VK_NUMPAD1 : FFocused := 2;
    VK_NEXT, VK_NUMPAD3 : FFocused := 4;
    VK_RETURN : if not bOk.Visible and not FShielding then mePossibleAnswer1DblClick(Sender);
  end;

  if Key <> VK_RETURN then
  case FFocused of
    1 : if mePossibleAnswer1.Visible then mePossibleAnswer1.SetFocus else imPossibleAnswer1.SetFocus;
    2 : if mePossibleAnswer2.Visible then mePossibleAnswer2.SetFocus else imPossibleAnswer2.SetFocus;
    3 : if mePossibleAnswer3.Visible then mePossibleAnswer3.SetFocus else imPossibleAnswer3.SetFocus;
    4 : if mePossibleAnswer4.Visible then mePossibleAnswer4.SetFocus else imPossibleAnswer4.SetFocus;
  end;

  Key := 0;
  FShielding := False;
end;

procedure TTestingUserForm.CommitTest;
  var nCorrect : Integer;
begin
  if bOk.Visible then bOkClick(bOk);
  if not TaskCDS.Active then Exit;

  cbLastMonth.Enabled := False;
  FPassed := True;
  laTime.Caption := 'Завершен.';

  nCorrect := 0;
  TaskCDS.First;
  while not TaskCDS.Eof do
  begin
    if TaskCDS.FieldByName('CorrectAnswer').AsInteger = TaskCDS.FieldByName('Response').AsInteger then Inc(nCorrect);
    TaskCDS.Next;
  end;

  if (Date >= EncodeDate(2021, 8, 1)) and (gc_User.Session <> '3') then
  begin
    try
      actInsertUpdate_TestingUser.Params.ParamByName('ioId').Value := 0;
      actInsertUpdate_TestingUser.Params.ParamByName('inUserId').Value := TitleCDS.FieldByName('UserId').AsInteger;
      actInsertUpdate_TestingUser.Params.ParamByName('inResult').Value := RoundTo(nCorrect / TitleCDS.FieldByName('Question').AsInteger * 100, - 2);
      if cbLastMonth.Checked then
        actInsertUpdate_TestingUser.Params.ParamByName('inDateTest').Value := IncDay(Now, - DayOf(Date))
      else actInsertUpdate_TestingUser.Params.ParamByName('inDateTest').Value := Now;
      actInsertUpdate_TestingUser.Execute;
    except on E:Exception do
      begin
       if pos('context', AnsilowerCase(e.Message)) > 0 then
          ShowMessage(trim (Copy(e.Message, 1, pos('context', AnsilowerCase(e.Message)) - 1)))
       else ShowMessage(e.Message);
      end;
    end;
  end else ShowMessage('Данные будут сохраняться с 01.08.21');

  cxLabel3.Caption := 'Вопросов ' + IntToStr(TitleCDS.FieldByName('Question').AsInteger) + ' правельных ответов ' + IntToStr(nCorrect) +
    ' процент выполнения ' + CurrToStr(RoundTo(nCorrect / TitleCDS.FieldByName('Question').AsInteger * 100, -2)) + ' тест ' +
    IfThen(RoundTo(nCorrect / TitleCDS.FieldByName('Question').AsInteger * 100, -2) < 85, 'не сдан', 'сдан');

  if RoundTo(nCorrect / TitleCDS.FieldByName('Question').AsInteger * 100, -2) < 80 then cxLabel3.Style.Font.Color := clRed;


  sgViewingResults.Visible := True;
  sgViewingResults.ColCount := TitleCDS.FieldByName('Question').AsInteger;
  sgViewingResults.DefaultColWidth := (Panel1.Width - 4 - TitleCDS.FieldByName('Question').AsInteger) div TitleCDS.FieldByName('Question').AsInteger;

  mePossibleAnswer1.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer1.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer1.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer1.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;
  mePossibleAnswer2.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer2.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer2.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer2.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;
  mePossibleAnswer3.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer3.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer3.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer3.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;
  mePossibleAnswer4.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer4.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer4.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer4.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;

  mePossibleAnswer1.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer1.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer1.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer1.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;
  mePossibleAnswer2.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer2.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer2.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer2.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;
  mePossibleAnswer3.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer3.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer3.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer3.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;
  mePossibleAnswer4.Style.BorderColor := meQuestion.Style.BorderColor;
  mePossibleAnswer4.Style.TextColor := meQuestion.Style.TextColor;
  mePossibleAnswer4.StyleFocused.BorderColor := meQuestion.StyleFocused.BorderColor;
  mePossibleAnswer4.StyleFocused.TextColor := meQuestion.StyleFocused.TextColor;

  TaskCDS.First;
  SetQuestion;

  mePossibleAnswer1.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 1, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 1, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer1.StyleFocused.Color := mePossibleAnswer1.Style.Color;

  mePossibleAnswer2.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 2, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 2, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer2.StyleFocused.Color := mePossibleAnswer2.Style.Color;

  mePossibleAnswer3.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 3, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 3, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer3.StyleFocused.Color := mePossibleAnswer3.Style.Color;

  mePossibleAnswer4.Style.Color := IfThen(TaskCDS.FieldByName('CorrectAnswer').AsInteger = 4, clLime,
                                   IfThen(TaskCDS.FieldByName('Response').AsInteger = 4, TColor($A7CCFE), meQuestion.Style.Color));
  mePossibleAnswer4.StyleFocused.Color := mePossibleAnswer4.Style.Color;

  imPossibleAnswer1.Style.BorderColor := mePossibleAnswer1.Style.Color;
  imPossibleAnswer1.StyleFocused.BorderColor := mePossibleAnswer1.Style.Color;
  imPossibleAnswer2.Style.BorderColor := mePossibleAnswer2.Style.Color;
  imPossibleAnswer2.StyleFocused.BorderColor := mePossibleAnswer2.Style.Color;
  imPossibleAnswer3.Style.BorderColor := mePossibleAnswer3.Style.Color;
  imPossibleAnswer3.StyleFocused.BorderColor := mePossibleAnswer3.Style.Color;
  imPossibleAnswer4.Style.BorderColor := mePossibleAnswer4.Style.Color;
  imPossibleAnswer4.StyleFocused.BorderColor := mePossibleAnswer4.Style.Color;

end;


procedure ShowTestingUser;
  var  TestingUser : TTestingUserForm;
begin
   TestingUser := TTestingUserForm.Create(Application.MainForm);
   try
     if TestingUser.FStart then TestingUser.ShowModal;
   finally
     TestingUser.Free;
   end;
end;

initialization

  RegisterClass(TTestingUserForm)

end.
