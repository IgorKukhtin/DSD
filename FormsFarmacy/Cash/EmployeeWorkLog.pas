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

function CheckEmployeeWorkLogCDS : boolean;
  var EmployeeWorkLogCDS : TClientDataSet;
begin
  Result := FileExists(EmployeeWorkLog_lcl);
  if Result then Exit;
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
      if not EmployeeWorkLogCDS.Active then
      begin
        DeleteLocalData(EmployeeWorkLog_lcl);
        CheckEmployeeWorkLogCDS;
        LoadLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
      end;
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
    if EmployeeWorkLogCDS.Active then EmployeeWorkLogCDS.Close;
    EmployeeWorkLogCDS.Free;
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
      if not EmployeeWorkLogCDS.Active then
      begin
        DeleteLocalData(EmployeeWorkLog_lcl);
        CheckEmployeeWorkLogCDS;
        LoadLocalData(EmployeeWorkLogCDS, EmployeeWorkLog_lcl);
      end;
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
