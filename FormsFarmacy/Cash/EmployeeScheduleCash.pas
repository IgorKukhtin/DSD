unit EmployeeScheduleCash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, Datasnap.DBClient,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, DateUtils,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  System.Actions, Vcl.ComCtrls, dxCore, cxDateUtils, cxCheckBox, cxDropDownEdit,
  cxLabel, cxCalendar, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxNavigator, dxDateRanges, cxDBData, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGridDBTableView, cxGrid;

type
  TEmployeeScheduleCashForm = class(TAncestorDialogForm)
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cbStartHour: TcxComboBox;
    cbStartMin: TcxComboBox;
    cxLabel6: TcxLabel;
    cbEndMin: TcxComboBox;
    cxLabel7: TcxLabel;
    cbEndHour: TcxComboBox;
    cbServiceExit: TcxCheckBox;
    Panel1: TPanel;
    Panel2: TPanel;
    MasterCDS: TClientDataSet;
    SubstitutionDS: TDataSource;
    SubstitutionCDS: TClientDataSet;
    HeaderUserCDS: TClientDataSet;
    HeaderCDS: TClientDataSet;
    spSelect: TdsdStoredProc;
    MasterDS: TDataSource;
    spGet: TdsdStoredProc;
    cxGridSubstitution: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBBandedTableViewSubstitution: TcxGridDBBandedTableView;
    Substitution_Note: TcxGridDBBandedColumn;
    Substitution_UnitName: TcxGridDBBandedColumn;
    Substitution_NoteStart: TcxGridDBBandedColumn;
    Substitution_NoteEnd: TcxGridDBBandedColumn;
    Substitution_NoteNext: TcxGridDBBandedColumn;
    Substitution_Value: TcxGridDBBandedColumn;
    Substitution_ValueEnd: TcxGridDBBandedColumn;
    Substitution_ValueStart: TcxGridDBBandedColumn;
    Substitution_ValueNext: TcxGridDBBandedColumn;
    Substitution_Color_CalcFont: TcxGridDBBandedColumn;
    Substitution_Nil1: TcxGridDBBandedColumn;
    Substitution_Nil2: TcxGridDBBandedColumn;
    Substitution_Nil3: TcxGridDBBandedColumn;
    cxGridLevelSubstitution: TcxGridLevel;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    Note: TcxGridDBBandedColumn;
    NoteStart: TcxGridDBBandedColumn;
    NoteEnd: TcxGridDBBandedColumn;
    NoteNext: TcxGridDBBandedColumn;
    Value: TcxGridDBBandedColumn;
    ValueStart: TcxGridDBBandedColumn;
    ValueEnd: TcxGridDBBandedColumn;
    ValueNext: TcxGridDBBandedColumn;
    Color_Calc: TcxGridDBBandedColumn;
    Color_CalcFont: TcxGridDBBandedColumn;
    Color_CalcFontUser: TcxGridDBBandedColumn;
    cxGridLevel: TcxGridLevel;
    CrossDBViewAddOnSubstitutionNext: TCrossDBViewAddOn;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    CrossDBViewStartAddOn: TCrossDBViewAddOn;
    CrossDBViewEndAddOn: TCrossDBViewAddOn;
    CrossDBViewNextAddOn: TCrossDBViewAddOn;
    CrossDBViewAddOnSubstitution: TCrossDBViewAddOn;
    CrossDBViewAddOnSubstitutionValueStart: TCrossDBViewAddOn;
    CrossDBViewAddOnSubstitutionValueEnd: TCrossDBViewAddOn;
    cxButton1: TcxButton;
    procedure bbOkClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    function EmployeeScheduleCashExecute: boolean;
  end;

implementation

{$R *.dfm}

uses LocalWorkUnit, CommonData, MainCash2;

function CheckEmployeeScheduleCDS : boolean;
  var EmployeeScheduleCDS : TClientDataSet;
begin
  Result := FileExists(EmployeeSchedule_lcl);
  if Result then Exit;

  EmployeeScheduleCDS :=  TClientDataSet.Create(Nil);
  try
    try
      EmployeeScheduleCDS.FieldDefs.Add('UserID', ftInteger);
      EmployeeScheduleCDS.FieldDefs.Add('Date', ftDateTime);
      EmployeeScheduleCDS.FieldDefs.Add('DateStart', ftDateTime);
      EmployeeScheduleCDS.FieldDefs.Add('DateEnd', ftDateTime);
      EmployeeScheduleCDS.FieldDefs.Add('ServiceExit', ftBoolean);
      EmployeeScheduleCDS.FieldDefs.Add('IsSend', ftBoolean);
      EmployeeScheduleCDS.CreateDataSet;
      SaveLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl);
      Result := True;
    Except ON E:Exception do
      ShowMessage('Ошибка создания лога работы сотрудников:'#13#10 + E.Message);
    end;
  finally
    if EmployeeScheduleCDS.Active then EmployeeScheduleCDS.Close;
    EmployeeScheduleCDS.Free;
  end;
end;


procedure TEmployeeScheduleCashForm.bbOkClick(Sender: TObject);
  var EmployeeScheduleCDS : TClientDataSet;
      DateStart, DateEnd : TDateTime;
      nHour, nMin : integer;
      bYes : boolean;
begin
  EmployeeScheduleCDS :=  TClientDataSet.Create(Nil);
  WaitForSingleObject(MutexEmployeeSchedule, INFINITE);
  try
    try
      LoadLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl);
      if not EmployeeScheduleCDS.Active then EmployeeScheduleCDS.Open;
      bYes := EmployeeScheduleCDS.Locate('UserID;Date', VarArrayOf([gc_User.Session, Date]), []);

      if bYes then
      begin
        if EmployeeScheduleCDS.FieldByName('ServiceExit').AsBoolean <> cbServiceExit.Checked then
        begin
          ShowMessage('Изменение признака служебный выход запрещено.');
          Exit;
        end;

        if EmployeeScheduleCDS.FieldByName('ServiceExit').AsBoolean then
        begin
          Close;
          Exit;
        end;
      end;

      if cbServiceExit.Checked then
      begin
        EmployeeScheduleCDS.Append;
        EmployeeScheduleCDS.FieldByName('UserID').AsString := gc_User.Session;
        EmployeeScheduleCDS.FieldByName('Date').AsDateTime := Date;
        EmployeeScheduleCDS.FieldByName('DateStart').AsVariant := Null;
        EmployeeScheduleCDS.FieldByName('DateEnd').AsVariant := Null;
        EmployeeScheduleCDS.FieldByName('ServiceExit').AsBoolean := True;
        EmployeeScheduleCDS.FieldByName('IsSend').AsBoolean := False;
        EmployeeScheduleCDS.Post;
      end else
      begin

        if (cbStartHour.Text = '') or not TryStrToInt(cbStartHour.Text, nHour) then
        begin
          ShowMessage('Не заполнен час прихода.');
          Exit;
        end;

        if (cbStartMin.Text = '') or not TryStrToInt(cbStartMin.Text, nMin) or not (nMin in [0, 30]) then
        begin
          ShowMessage('Минуты прихода длжны быть 00 или 30.');
          Exit;
        end;

        DateStart := EncodeDateTime(YearOf(Date), MonthOf(Date), DayOf(Date), nHour, nMin, 0, 0);

        if (cbEndHour.Text = '') or not TryStrToInt(cbEndHour.Text, nHour) then
        begin
          ShowMessage('Не заполнен час ухода.');
          Exit;
        end;

        if (cbEndMin.Text = '') or not TryStrToInt(cbEndMin.Text, nMin) or not (nMin in [0, 30]) then
        begin
          ShowMessage('Минуты ухода длжны быть 00 или 30.');
          Exit;
        end;
        DateEnd := EncodeDateTime(YearOf(Date), MonthOf(Date), DayOf(Date), nHour, nMin, 0, 0);

        if DateEnd < DateStart then DateEnd := IncDay(DateEnd);
        if DateEnd = DateStart then
        begin
          ShowMessage('Время прихода и ухода должны различаться.');
          Exit;
        end;

        if bYes then
        begin
          if EmployeeScheduleCDS.FieldByName('DateStart').AsVariant <> DateStart then
          begin
            ShowMessage('Изменение времени прихода запрещено.');
            Exit;
          end;
        end else
        begin

          if DateStart < IncMinute(Now, - 30) then
          begin
            ShowMessage('Ошибка. Вы пытаетесь поставить время прихода не соответствующее реальному времени! Время прихода не должно быть менее 30 мин от текущего времени!');
            Exit;
          end;

          if HourOf(Now) < 20 then
          begin
            if (HourOf(DateStart) < 7) OR (HourOf(DateStart) >= 21) then
            begin
              ShowMessage('Ошибка. Время прихода должно быть в диапазон с 7:00 до 21:00.');
              Exit;
            end;
          end else
          begin
            if HourOf(DateStart) < 21 then
            begin
              ShowMessage('Ошибка. Время прихода должно быть в диапазон с 21:00 по 24:00.');
              Exit;
            end;
          end;
        end;

        if HourOf(DateStart) < 21 then
        begin
          if TimeOf(DateStart) >= TimeOf(DateEnd) then
          begin
            ShowMessage('Ошибка. Время ухода должно быть больше времени прихода.');
            Exit;
          end;

          if TimeOf(DateEnd) > TimeOf(EncodeTime(21, 30, 1, 0)) then
          begin
            ShowMessage('Ошибка. Время ухода должно быть в диапазон с ' + FormatDateTime('HH:NN', DateStart) + ' до 21:30.');
            Exit;
          end;
        end else
        begin
          if (TimeOf(DateEnd) > TimeOf(EncodeTime(8, 0, 0, 0))) AND (TimeOf(DateEnd) < TimeOf(EncodeTime(21, 0, 0, 0))) then
          begin
            ShowMessage('Ошибка. Время ухода должно быть в диапазон с ' + FormatDateTime('HH:NN', DateStart) + ' по 8:00.');
            Exit;
          end;
        end;

        if bYes then
        begin
          if EmployeeScheduleCDS.FieldByName('DateEnd').AsDateTime = DateEnd then
          begin
            Close;
            Exit;
          end;
          EmployeeScheduleCDS.Edit;
        end else EmployeeScheduleCDS.Append;

        EmployeeScheduleCDS.FieldByName('UserID').AsString := gc_User.Session;
        EmployeeScheduleCDS.FieldByName('Date').AsDateTime := Date;
        EmployeeScheduleCDS.FieldByName('DateStart').AsVariant := DateStart;
        EmployeeScheduleCDS.FieldByName('DateEnd').AsVariant := DateEnd;
        EmployeeScheduleCDS.FieldByName('ServiceExit').AsBoolean := False;
        EmployeeScheduleCDS.FieldByName('IsSend').AsBoolean := False;
        EmployeeScheduleCDS.Post;
      end;

      SaveLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl);
      Close;
    Except ON E:Exception do
      ShowMessage('Ошибка сохранения отметки о времени работы. Покажите это окно системному администратору: ' + #13#10 + E.Message);
    end;
  finally
    if EmployeeScheduleCDS.Active then EmployeeScheduleCDS.Close;
    EmployeeScheduleCDS.Free;
    ReleaseMutex(MutexEmployeeSchedule);
    PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 50);
  end;
end;

procedure TEmployeeScheduleCashForm.cxButton1Click(Sender: TObject);
begin
  PostMessage(HWND_BROADCAST, FM_SERVISE, 2, 50);
end;

function TEmployeeScheduleCashForm.EmployeeScheduleCashExecute: boolean;
  var EmployeeScheduleCDS : TClientDataSet;
begin
  edOperDate.Date := Date;
  CheckEmployeeScheduleCDS;
  EmployeeScheduleCDS :=  TClientDataSet.Create(Nil);
  WaitForSingleObject(MutexEmployeeSchedule, INFINITE);
  try

    if not gc_User.Local then
    begin
      spSelect.Execute;
    end else
    begin
      Panel2.Visible := False;
      Height := Panel1.Height + edOperDate.Height * 2;
      Panel1.Align := alClient;
    end;


    try
      LoadLocalData(EmployeeScheduleCDS, EmployeeSchedule_lcl);
      if not EmployeeScheduleCDS.Active then EmployeeScheduleCDS.Open;
      if EmployeeScheduleCDS.Locate('UserID;Date', VarArrayOf([gc_User.Session, Date]), []) then
      begin
        cbServiceExit.Checked := EmployeeScheduleCDS.FieldByName('ServiceExit').AsBoolean;
        cbServiceExit.Enabled := False;

        if not EmployeeScheduleCDS.FieldByName('DateStart').IsNull then
        begin
          cbStartHour.Text := IntToStr(HourOf(EmployeeScheduleCDS.FieldByName('DateStart').AsDateTime));
          cbStartMin.Text := IntToStr(MinuteOf(EmployeeScheduleCDS.FieldByName('DateStart').AsDateTime));
        end else cbStartMin.Text := '0';
        if Length(cbStartMin.Text) < 2 then cbStartMin.Text := '0' + cbStartMin.Text;

        if not EmployeeScheduleCDS.FieldByName('DateEnd').IsNull then
        begin
          cbEndHour.Text := IntToStr(HourOf(EmployeeScheduleCDS.FieldByName('DateEnd').AsDateTime));
          cbEndMin.Text := IntToStr(MinuteOf(EmployeeScheduleCDS.FieldByName('DateEnd').AsDateTime));
        end else cbEndMin.Text := '0';
        if Length(cbEndMin.Text) < 2 then cbEndMin.Text := '0' + cbEndMin.Text;

        cbStartHour.Enabled := False;
        cbStartMin.Enabled := False;
        cbEndHour.Enabled := not cbServiceExit.Checked;
        cbEndMin.Enabled := cbEndHour.Enabled;
      end else
      begin
        cbStartMin.Text := '00';
        cbEndMin.Text := '00';
      end;
    Except ON E:Exception do
    end;
  finally
    if EmployeeScheduleCDS.Active then EmployeeScheduleCDS.Close;
    EmployeeScheduleCDS.Free;
    ReleaseMutex(MutexEmployeeSchedule);
  end;

  Result := ShowModal = mrOK;
end;

End.
