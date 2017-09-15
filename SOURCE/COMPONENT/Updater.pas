unit Updater;

interface

type

  TUpdater = class
  private
     class procedure UpdateConnect (Connection: string);
     class procedure UpdateConnectReport (Connection: string);
     class procedure UpdateProgram;
  public
     class procedure AutomaticCheckConnect;
     class procedure AutomaticUpdateProgram;
  end;

implementation

uses UnilWin, VCL.Dialogs, Controls, StdCtrls, FormStorage, SysUtils, forms,
     MessagesUnit, dsdDB, DB, Storage, UtilConst, Classes, ShellApi, Windows,
     StrUtils;
{ TUpdater }

class procedure TUpdater.AutomaticCheckConnect;
var StoredProc: TdsdStoredProc;
    Connection, ReportConnection: String;
    StringList: TStringList;
    i:Integer;
    fFind:Boolean;
begin
  StoredProc := TdsdStoredProc.Create(nil);
  try
    StoredProc.Params.AddParam('inConstName', ftString, ptInput, 'zc_Enum_GlobalConst_ConnectParam');
    StoredProc.Params.AddParam('gpGetConstName', ftString, ptOutput, '');
    StoredProc.OutputType := otResult;
    StoredProc.StoredProcName := 'gpGetConstName';
    try
      StoredProc.Execute;
    except
      // ���� ��� ���� ������, �� �������� �������
      on E: EStorageException do begin
         exit;
      end;
      // ���� �� ����, �� �����������
      on E: Exception do
          raise;
    end;
    Connection := StoredProc.ParamByName('gpGetConstName').AsString;
    //
    StringList := TStringList.Create;
    with StringList do begin
       LoadFromFile(ConnectionPath);
       fFind:=false;
       for i:=0 to Count-1
       do fFind:= (fFind) or (StringList[i] = Connection);
       StringList.Free;
    end;
    if    (TStorageFactory.GetStorage.Connection <> Connection) and (fFind = FALSE) and (Connection<>'')
      // and (TStorageFactory.GetStorage.Connection <> ReplaceStr(Connection,'srv.alan','srv2.alan'))
    then
       UpdateConnect(Connection);
    //
    // ������ ���� ����� ��� �������
    if Pos('\init.php', ConnectionPath) > 0 then
    begin
        StoredProc.Params.Clear;
        StoredProc.Params.AddParam('inConstName', ftString, ptInput, 'zc_Enum_GlobalConst_ConnectReportParam');
        StoredProc.Params.AddParam('gpGetConstName', ftString, ptOutput, '');
        StoredProc.OutputType := otResult;
        StoredProc.StoredProcName := 'gpGetConstName';
        try
          StoredProc.Execute;
        except
          // ���� ��� ���� ������, �� �������� �������
          on E: EStorageException do begin
             exit;
          end;
          // ���� �� ����, �� �����������
          on E: Exception do
              raise;
        end;
        ReportConnection := StoredProc.ParamByName('gpGetConstName').AsString;
        //
        StringList := TStringList.Create;
        with StringList do begin
           if FileExists(ReplaceStr(ConnectionPath,'\init.php','\initRep.php')) = TRUE
           then LoadFromFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
           fFind:=false;
           for i:=0 to Count-1
           do fFind:= (fFind) or (StringList[i] = ReportConnection);
           StringList.Free;
        end;
        if    (fFind = FALSE) and (ReportConnection<>'')
        then
           UpdateConnectReport(ReportConnection);

    end;

  finally
    StoredProc.Free;
  end;
end;

class procedure TUpdater.AutomaticUpdateProgram;
var LocalVersionInfo, BaseVersionInfo: TVersionInfo;
begin
  try
    Application.ProcessMessages;
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)));
    LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then
        if MessageDlg('���������� ����� ������ ���������! ��������', mtInformation, mbOKCancel, 0) = mrOk then
           UpdateProgram;
  except
    on E: Exception do
       TMessagesForm.Create(nil).Execute('�� �������� �������������� ����������.'#13#10'���������� � ������������', E.Message);
  end;
end;

class procedure TUpdater.UpdateConnect (Connection: string);
var StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
    if Pos('srv2.alan', Connection) > 0 then Connection:=ReplaceStr(Connection,'srv2.alan','srv.alan');
    StringList.Add(Connection);
    if Pos('srv2.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv2.alan','srv.alan'));
    if Pos('srv.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv.alan','srv2.alan'));
    StringList.SaveToFile(ConnectionPath);
  finally
    StringList.Free;
  end;
  ShowMessage('���� � ������� ���������� ������� � <'+TStorageFactory.GetStorage.Connection+'> �� <'+Connection+'>. ������� ������ ��� �����������');
  Application.Terminate;
  ShellExecute(Application.Handle, 'open', PWideChar(Application.ExeName), nil, nil, SW_SHOWNORMAl);
end;

class procedure TUpdater.UpdateConnectReport (Connection: string);
var StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
    if Pos('srv2-r.alan', Connection) > 0 then Connection:=ReplaceStr(Connection,'srv2-r.alan','srv-r.alan');
    StringList.Add(Connection);
    if Pos('srv2-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv2-r.alan','srv-r.alan'));
    if Pos('srv-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv-r.alan','srv2-r.alan'));
    StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
  finally
    StringList.Free;
  end;
  ShowMessage('���� � ������� ������� ������� �� <'+Connection+'>. ������� ������ ��� �����������');
  Application.Terminate;
  ShellExecute(Application.Handle, 'open', PWideChar(Application.ExeName), nil, nil, SW_SHOWNORMAl);
end;


class procedure TUpdater.UpdateProgram;
var S : String;
begin
  //1.
  S:= ExtractFileName(ParamStr(0));
  if (UpperCase(S) = UpperCase('FarmacyCash.exe'))
     and (not FileExists(ExtractFilePath(ParamStr(0)) + 'FarmacyCashServise.exe'))
  then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'FarmacyCashServise.exe', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('FarmacyCashServise.exe')));

  //2.
  FileWriteString(ParamStr(0)+'.uTMP', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName(ParamStr(0))));

  //3.
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe') then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('Upgrader4.exe')));

  //4.
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'midas.dll') then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'midas.dll', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('midas.dll')));

  //5.
  Execute(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe ' + ParamStr(0), ExtractFileDir(ParamStr(0)));

  ShowMessage('��������� ������� ���������. ������� ������ ��� �����������');
  Application.Terminate
end;

end.



