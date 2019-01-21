unit EmployeeWorkLog;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Data.DB, Datasnap.DBClient, Vcl.Dialogs;

procedure EmployeeWorkLog_LogIn;
procedure EmployeeWorkLog_LogOut;
procedure EmployeeWorkLog_ZReport;

implementation

uses LocalWorkUnit, CommonData, MainCash2;

function CheckEmployeeWorkLogStrucnureCDS : boolean;
//  var EmployeeWorkLogCDS, EmployeeWorkLogNewCDS : TClientDataSet;
begin
  Result := True;
{  try
    EmployeeWorkLogCDS :=  TClientDataSet.Create(Nil);
    EmployeeWorkLogNewCDS :=  TClientDataSet.Create(Nil);
    WaitForSingleObject(MutexEmployeeWorkLog, INFINITE);
    try
      LoadLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
      if not EmployeeWorkLogCDS.Active then EmployeeWorkLogCDS.Open;

      if not Assigned(EmployeeWorkLogCDS.FindField('DiffKindId')) then
      begin
        EmployeeWorkLogNewCDS.FieldDefs.Add('ID', ftInteger);
        EmployeeWorkLogNewCDS.FieldDefs.Add('Code', ftInteger);
        EmployeeWorkLogNewCDS.FieldDefs.Add('Name', ftString, 200);
        EmployeeWorkLogNewCDS.FieldDefs.Add('Amount', ftCurrency);
        EmployeeWorkLogNewCDS.FieldDefs.Add('Price', ftCurrency);
        EmployeeWorkLogNewCDS.FieldDefs.Add('DiffKindId', ftInteger);
        EmployeeWorkLogNewCDS.FieldDefs.Add('Comment', ftString, 400);
        EmployeeWorkLogNewCDS.FieldDefs.Add('UserID', ftInteger);
        EmployeeWorkLogNewCDS.FieldDefs.Add('UserName', ftString, 80);
        EmployeeWorkLogNewCDS.FieldDefs.Add('DateInput', ftDateTime);
        EmployeeWorkLogNewCDS.FieldDefs.Add('IsSend', ftBoolean);
        EmployeeWorkLogNewCDS.CreateDataSet;
        EmployeeWorkLogNewCDS.Open;

        EmployeeWorkLogCDS.First;
        while not EmployeeWorkLogCDS.Eof do
        begin
          EmployeeWorkLogNewCDS.Append;
          EmployeeWorkLogNewCDS.FieldByName('ID').AsVariant := EmployeeWorkLogCDS.FieldByName('ID').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('Code').AsVariant := EmployeeWorkLogCDS.FieldByName('Code').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('Name').AsVariant := EmployeeWorkLogCDS.FieldByName('Name').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('Amount').AsVariant := EmployeeWorkLogCDS.FieldByName('Amount').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('Price').AsVariant := EmployeeWorkLogCDS.FieldByName('Price').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('DiffKindId').AsVariant := Null;
          EmployeeWorkLogNewCDS.FieldByName('Comment').AsVariant := EmployeeWorkLogCDS.FieldByName('Comment').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('UserID').AsVariant := EmployeeWorkLogCDS.FieldByName('UserID').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('UserName').AsVariant := EmployeeWorkLogCDS.FieldByName('UserName').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('DateInput').AsVariant := EmployeeWorkLogCDS.FieldByName('DateInput').AsVariant;
          EmployeeWorkLogNewCDS.FieldByName('IsSend').AsVariant := EmployeeWorkLogCDS.FieldByName('IsSend').AsVariant;
          EmployeeWorkLogNewCDS.Post;
          EmployeeWorkLogCDS.Next;
        end;

        SaveLocalData(EmployeeWorkLogNewCDS, EmployeeWorkLog_lcl);
      end;
      Result := True;
    finally
      ReleaseMutex(MutexEmployeeWorkLog);
      if EmployeeWorkLogCDS.Active then EmployeeWorkLogCDS.Close;
      EmployeeWorkLogCDS.Free;
      if EmployeeWorkLogNewCDS.Active then EmployeeWorkLogNewCDS.Close;
      EmployeeWorkLogNewCDS.Free;
    end;
  Except ON E:Exception do
    ShowMessage('Ошибка создания листа отказов:'#13#10 + E.Message);
  end;    }
end;

function CheckEmployeeWorkLogCDS : boolean;
  var EmployeeWorkLogCDS : TClientDataSet;
begin
  Result := FileExists(EmployeeWorkLog_lcl);
  if Result then
  begin
    Result := CheckEmployeeWorkLogStrucnureCDS;
    Exit;
  end;
  EmployeeWorkLogCDS :=  TClientDataSet.Create(Nil);
  try
    try
      EmployeeWorkLogCDS.FieldDefs.Add('UserID', ftInteger);
      EmployeeWorkLogCDS.FieldDefs.Add('DateLogIn', ftDateTime);
      EmployeeWorkLogCDS.FieldDefs.Add('DateZReport', ftDateTime);
      EmployeeWorkLogCDS.FieldDefs.Add('DateLogOut', ftDateTime);
      EmployeeWorkLogCDS.FieldDefs.Add('IsSend', ftBoolean);
      EmployeeWorkLogCDS.CreateDataSet;
      SaveLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
      Result := True;
    Except ON E:Exception do
      ShowMessage('Ошибка создания лога работы сотрудников:'#13#10 + E.Message);
    end;
  finally
    if EmployeeWorkLogCDS.Active then EmployeeWorkLogCDS.Close;
    EmployeeWorkLogCDS.Free;
  end;
end;

procedure EmployeeWorkLog_LogIn;
  var EmployeeWorkLogCDS : TClientDataSet;
begin
  EmployeeWorkLogCDS :=  TClientDataSet.Create(Nil);
  WaitForSingleObject(MutexEmployeeWorkLog, INFINITE);
  try
    try
      CheckEmployeeWorkLogCDS;
      LoadLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
      if not EmployeeWorkLogCDS.Active then EmployeeWorkLogCDS.Open;
      EmployeeWorkLogCDS.Append;
      EmployeeWorkLogCDS.FieldByName('UserID').AsString := gc_User.Session;
      EmployeeWorkLogCDS.FieldByName('DateLogIn').AsDateTime := Now;
      EmployeeWorkLogCDS.FieldByName('IsSend').AsBoolean := False;
      EmployeeWorkLogCDS.Post;
      SaveLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
    Except ON E:Exception do
      ShowMessage('Ошибка сохранения лога работы сотрудников:'#13#10 + E.Message);
    end;
  finally
    ReleaseMutex(MutexEmployeeWorkLog);
  end;
end;

procedure EmployeeWorkLog_Update(AZReport : Boolean);
  var EmployeeWorkLogCDS : TClientDataSet;
begin
  EmployeeWorkLogCDS :=  TClientDataSet.Create(Nil);
  WaitForSingleObject(MutexEmployeeWorkLog, INFINITE);
  try
    try
      CheckEmployeeWorkLogCDS;
      LoadLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
      if not EmployeeWorkLogCDS.Active then EmployeeWorkLogCDS.Open;
      if EmployeeWorkLogCDS.IsEmpty then Exit;
      EmployeeWorkLogCDS.Last;
      EmployeeWorkLogCDS.Edit;
      if AZReport then
        EmployeeWorkLogCDS.FieldByName('DateZReport').AsDateTime := Now
      else EmployeeWorkLogCDS.FieldByName('DateLogOut').AsDateTime := Now;
      EmployeeWorkLogCDS.FieldByName('IsSend').AsBoolean := False;
      EmployeeWorkLogCDS.Post;
      SaveLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
    Except ON E:Exception do
      ShowMessage('Ошибка сохранения лога работы сотрудников:'#13#10 + E.Message);
    end;
  finally
    ReleaseMutex(MutexEmployeeWorkLog);
  end;
end;

procedure EmployeeWorkLog_LogOut;
begin
  EmployeeWorkLog_Update(False);
end;

procedure EmployeeWorkLog_ZReport;
begin
  EmployeeWorkLog_Update(True);
end;

end.
