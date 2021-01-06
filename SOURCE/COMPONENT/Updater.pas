unit Updater;

interface

type

  TUpdater = class
  private
     class procedure UpdateConnect (Connection: string);
     class procedure UpdateConnectReport (Connection: string; Restart : boolean = True);
     class procedure UpdateConnectReportLocal (Connection: string; Restart : boolean = True);
     class procedure UpdateProgram;
  public
     class procedure AutomaticCheckConnect;
     class procedure AutomaticUpdateProgram;
     class procedure AutomaticUpdateProgramStart;
  end;

  const fAlan_colocall : Boolean = FALSE;
//  const fAlan_colocall : Boolean = TRUE;

implementation

uses UnilWin, VCL.Dialogs, Controls, StdCtrls, FormStorage, SysUtils, forms,
     MessagesUnit, dsdDB, DB, Storage, UtilConst, Classes, ShellApi, Windows,
     StrUtils, CommonData, LocalWorkUnit;
{ TUpdater }

class procedure TUpdater.AutomaticCheckConnect;
var StoredProc: TdsdStoredProc;
    Connection, ReportConnection, ReportConnectionLocal: String;
    StringList: TStringList;
    StringListConnection: TStringList;
    i:Integer;
    fFind, fFirst_colocall, fFirst_srv:Boolean;
           fNext_colocall, fNext_srv:Boolean;
    fAlan_conn : Boolean;
begin
  // !!! DEMO
  if gc_ProgramName = 'FDemo.exe' then exit;
  if gc_ProgramName = 'Boutique_Demo.exe' then exit;
  //
  if (AnsiUpperCase(ParamStr(1)) = AnsiUpperCase('/noConnectParam'))
   or(AnsiUpperCase(ParamStr(2)) = AnsiUpperCase('/noConnectParam'))
   or(AnsiUpperCase(ParamStr(3)) = AnsiUpperCase('/noConnectParam'))
  then exit;


  // !!! ���� ����
  fAlan_conn:= Pos('\init.php', ConnectionPath) > 0;


  StoredProc := TdsdStoredProc.Create(nil);
  try
    //�������� ����������� �� ����
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
    //�������� ����������� �� ����
    Connection := StoredProc.ParamByName('gpGetConstName').AsString;
    //
    //
    StringList := TStringList.Create;
    with StringList do begin
       LoadFromFile(ConnectionPath);
       // ���� ������ ���� ��������� ����������� � ����
       if fAlan_conn = TRUE
       then fFind:= (Connection = '')
       else fFind:= false;
       //
       fFirst_colocall:=false;
       fFirst_srv:=false;
       fNext_colocall:=false;
       fNext_srv:=false;

       // ���� � init.php ����������� ��� � ����, ���� ����� ��� - � init.php ���� ��������
       if fAlan_conn = TRUE
       then // ���� ������
            if Count > 0 then
            for i:=0 to 0       do fFind:= (fFind) or (StringList[i] = Connection)
            else
       else //�����
            for i:=0 to Count-1 do fFind:= (fFind) or (StringList[i] = Connection);

       // ����� ������ � init.php - colocall ��� integer-srv
       if Count > 0 then
       for i:=0 to 0
       do if (Pos(AnsiUpperCase('colocall'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_srv = FALSE)
          then fFirst_colocall:= TRUE
          else if (Pos(AnsiUpperCase('alan'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_colocall = FALSE)
               then fFirst_srv:= TRUE;

       // ����� ������ � init.php - colocall ��� integer-srv
       if Count > 1 then
       for i:=1 to 1
       do if (Pos(AnsiUpperCase('colocall'), AnsiUpperCase(StringList[i])) > 0)and(fNext_srv = FALSE)
          then fNext_colocall:= TRUE
          else if (Pos(AnsiUpperCase('alan'), AnsiUpperCase(StringList[i])) > 0)and(fNext_colocall = FALSE)
               then fNext_srv:= TRUE;
       //
       if (fAlan_conn = TRUE) and (Count < 3) then fNext_colocall:= true;
       //
       StringList.Free;
    end;
    //
    //
    if (fAlan_colocall = TRUE) and (fFirst_srv = TRUE) //and (Connection = '')
        and (fAlan_conn = TRUE) and (gc_ProgramName <> 'Boutique.exe') and (gc_ProgramName <> 'ProjectBoat.exe')
    then
       // 1.1. ���� ������������� � integer-srv �� colocall
       UpdateConnect('alan')

    else
    if (fAlan_colocall = FALSE) and ((fFirst_colocall = TRUE) or (fNext_colocall = true)) //and (Connection = '')
       and (fAlan_conn = TRUE) and (gc_ProgramName <> 'Boutique.exe') and (gc_ProgramName <> 'ProjectBoat.exe') then
       // 1.2. ���� ������������� � colocall �� integer-srv ��� ������ ������� colocall ��� ������� 3-�� colocall
       UpdateConnect('colocall')

    else
    if (TStorageFactory.GetStorage.Connection <> Connection) and (fFind = FALSE) and (Connection<>'')
      // and (TStorageFactory.GetStorage.Connection <> ReplaceStr(Connection,'srv.alan','srv2.alan'))
    then
       // 1.3. ���� ��� ������ �� integer-srv + integer-srv2
       UpdateConnect(Connection);
    //
    //
    // ������ ���� ����� ��� ������� - !!! ���� ����
    //
    if fAlan_conn = TRUE then
    begin
        StoredProc.Params.Clear;
        //�������� ����������� �� ����
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
        //�������� ����������� �� ����
        ReportConnection := StoredProc.ParamByName('gpGetConstName').AsString;
        //
        StringList := TStringList.Create;
        with StringList do begin
           if FileExists(ReplaceStr(ConnectionPath,'\init.php','\initRep.php')) = TRUE
           then LoadFromFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));

       // ���� ������ ���� ��������� ����������� � ����
       fFind:= false;
       fFirst_colocall:=false;
       fFirst_srv:=false;
       fNext_colocall:=false;
       fNext_srv:=false;

       // ���� ������ � initRep.php ����������� ��� � ����, ���� ����� ��� - � initRep.php ���� ��������
       if Count > 0 then
       for i:=0 to 0 do fFind:= (fFind) or (StringList[i] = Connection);
       // ����� ������ � initRep.php - colocall ��� integer-srv
       if Count > 0 then
       for i:=0 to 0
       do if (Pos(AnsiUpperCase('colocall'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_srv = FALSE)
          then fFirst_colocall:= TRUE
          else if (Pos(AnsiUpperCase('alan'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_colocall = FALSE)
               then fFirst_srv:= TRUE;

       // ����� ������ � init.php - colocall ��� integer-srv
       if Count > 1 then
       for i:=1 to 1
       do if (Pos(AnsiUpperCase('colocall'), AnsiUpperCase(StringList[i])) > 0)and(fNext_srv = FALSE)
          then fNext_colocall:= TRUE
          else if (Pos(AnsiUpperCase('alan'), AnsiUpperCase(StringList[i])) > 0)and(fNext_colocall = FALSE)
               then fNext_srv:= TRUE;
       //
       if (fAlan_conn = TRUE) and (Count < 3) then fNext_colocall:= true;
       //
       StringList.Free;
    end;
    //
    //
    if (fAlan_colocall = TRUE) and (fFirst_srv = TRUE) then
       // 2.1. ���� ������������� � integer-srv �� colocall
       UpdateConnectReport('alan')

    else
    if (fAlan_colocall = FALSE) and ((fFirst_colocall = TRUE) or (fNext_colocall = true)) then
       // 2.2. ���� ������������� � colocall �� integer-srv ��� ������ ������� colocall ��� ������� 3-�� colocall
       UpdateConnectReport('colocall')

    else
        if (fFind = FALSE) and (ReportConnection<>'')
        then
           // 2.3. ���� ��� ������ �� integer-srv + integer-srv2
           UpdateConnectReport(ReportConnection);
    end;
    //
    //
    // ������ ���� ����� ��� ������� �������
    //
    if Pos('\farmacy_init.php', ConnectionPath) > 0 then
    begin
        StoredProc.Params.Clear;
        //�������� ����������� �� ����
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
        //�������� ����������� �� ����
        ReportConnection := StoredProc.ParamByName('gpGetConstName').AsString;
        //
        StringList := TStringList.Create;
        StringListConnection := TStringList.Create;
        StringListConnection.Text := ReportConnection;
        with StringList do begin
           if FileExists(ReplaceStr(ConnectionPath,'\farmacy_init.php','\farmacy_initRep.php')) = TRUE
           then LoadFromFile(ReplaceStr(ConnectionPath,'\farmacy_init.php','\farmacy_initRep.php'));
           fFind:=Count <> 0;
           if fFind then
           begin
             if Count = StringListConnection.Count then
               for i:=0 to Count-1 do
               begin
                 fFind:= Strings[i] = StringListConnection.Strings[i];
                 if fFind = FALSE then Break;
               end
             else fFind:=False;
           end;
           StringList.Free;
           StringListConnection.Free;
        end;
        if    (fFind = FALSE) and (ReportConnection<>'')
        then
           UpdateConnectReport(ReportConnection, False);

    end;
    //
    //
    // ������ ���� ����� ��� ������� ������� ����� ������
    //
    if Pos('\farmacy_init.php', ConnectionPath) > 0 then
    begin
        StoredProc.Params.Clear;
        //�������� ����������� �� ����
        StoredProc.Params.AddParam('inConstName', ftString, ptInput, 'zc_Enum_GlobalConst_ConnectReportLocalService');
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
        //�������� ����������� �� ����
        ReportConnectionLocal := StoredProc.ParamByName('gpGetConstName').AsString;
        //
        StringList := TStringList.Create;
        StringListConnection := TStringList.Create;
        StringListConnection.Text := ReportConnectionLocal;
        with StringList do begin
           if FileExists(ReplaceStr(ConnectionPath,'\farmacy_init.php','\farmacy_initRepLocal.php')) = TRUE
           then LoadFromFile(ReplaceStr(ConnectionPath,'\farmacy_init.php','\farmacy_initRepLocal.php'));
           fFind:=Count <> 0;
           if fFind then
           begin
             if Count = StringListConnection.Count then
               for i:=0 to Count-1 do
               begin
                 fFind:= Strings[i] = StringListConnection.Strings[i];
                 if fFind = FALSE then Break;
               end
             else fFind:=False;
           end;
           StringList.Free;
           StringListConnection.Free;
        end;

        if    (fFind = FALSE) and (ReportConnectionLocal<>'')
        then
           UpdateConnectReportLocal(ReportConnectionLocal, False);

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
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)), GetBinaryPlatfotmSuffics(ParamStr(0)));
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

class procedure TUpdater.AutomaticUpdateProgramStart;
begin
  try
    Application.ProcessMessages;
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

  // 1.1. ���� ������������� � alan �� colocall
  if (fAlan_colocall = TRUE) and (AnsiUpperCase(Connection) = AnsiUpperCase('alan')) then
  begin
    StringList.Add('http://project-vds.vds.colocall.com/projectReal/index.php');
    StringList.Add('http://integer-srv.alan.dp.ua');
    StringList.Add('http://integer-srv2.alan.dp.ua');
    StringList.SaveToFile(ConnectionPath);
  end
  else
  // 1.2. ���� ������������� � colocall �� integer-srv
  if (fAlan_colocall = FALSE) and (AnsiUpperCase(Connection) = AnsiUpperCase('colocall')) then
  begin
    StringList.Add('http://integer-srv.alan.dp.ua');
    StringList.Add('http://integer-srv2.alan.dp.ua');
    StringList.Add('http://project-vds.vds.colocall.com/projectReal/index.php');
    StringList.SaveToFile(ConnectionPath);
  end
  else
  // 1.3. ���� ��� ������ �� integer-srv + integer-srv2
  begin
    //������ ��� ������
    StringList.Add(Connection);
    //�������������� ������ ������
    if Pos('srv2.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv2.alan','srv.alan'));
    if Pos('srv.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv.alan','srv2.alan'));
    //���� ������ ��������� - ������
    if (Pos('alan', Connection) > 0) then StringList.Add('http://project-vds.vds.colocall.com/projectReal/index.php');
    //���������
    StringList.SaveToFile(ConnectionPath);
  end
  finally
    StringList.Free;
  end;
  //
  //
  if  ((fAlan_colocall = TRUE) and(Pos(AnsiUpperCase('alan'),     AnsiUpperCase(Connection)) > 0))
    or((fAlan_colocall = FALSE)and(Pos(AnsiUpperCase('colocall'), AnsiUpperCase(Connection)) > 0))
  then
    ShowMessage('���� � ������� ���������� ������� � <'+TStorageFactory.GetStorage.Connection+'> �� <'+'������'+'>. ������� ������ ��� �����������')
  else
    ShowMessage('���� � ������� ���������� ������� � <'+TStorageFactory.GetStorage.Connection+'> �� <'+Connection+'>. ������� ������ ��� �����������')
  ;
  Application.Terminate;
  ShellExecute(Application.Handle, 'open', PWideChar(Application.ExeName), nil, nil, SW_SHOWNORMAl);
end;

class procedure TUpdater.UpdateConnectReport (Connection: string; Restart : boolean = True);
var StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
  // 1.1. ���� ������������� �� colocall
  if (fAlan_colocall = TRUE) and (AnsiUpperCase(Connection) = AnsiUpperCase('alan')) then
  begin
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.Add('http://integer-srv-r.alan.dp.ua');
    StringList.Add('http://integer-srv2-r.alan.dp.ua');
    StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
    exit;
  end
  else
  // 1.2. ���� ������������� �� integer-srv
  if (fAlan_colocall = FALSE)and(Pos(AnsiUpperCase('colocall'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://integer-srv-r.alan.dp.ua');
    StringList.Add('http://integer-srv2-r.alan.dp.ua');
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
    exit;
  end
  else
  // 1.3. ���� ��� ������ �� integer-srv + integer-srv2
  begin
    //������ ��� ������
    StringList.Add(Connection);
    //�������������� ������ ������
    if Pos('srv2-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv2-r.alan','srv-r.alan'));
    if Pos('srv-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv-r.alan','srv2-r.alan'));
    //���� ������ ��������� - ������
    if (Pos('alan', Connection) > 0) then StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    //
    //farmacy
    if Pos('\farmacy_init.php', ConnectionPath) > 0 then
      StringList.SaveToFile(ReplaceStr(ConnectionPath,'\farmacy_init.php','\farmacy_initRep.php'))
    else StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
  end;
  finally
    StringList.Free;
  end;
  if Restart then
  begin
    ShowMessage('���� � ������� ������� ������� �� <'+Connection+'>. ������� ������ ��� �����������');
    Application.Terminate;
    ShellExecute(Application.Handle, 'open', PWideChar(Application.ExeName), nil, nil, SW_SHOWNORMAl);
  end;
end;

class procedure TUpdater.UpdateConnectReportLocal (Connection: string; Restart : boolean = True);
var StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
  // 1.1. ���� ������������� �� colocall
  if (fAlan_colocall = TRUE)and(Pos(AnsiUpperCase('alan'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.SaveToFile(ConnectionPath);
    exit;
  end
  else
  // 1.2. ���� ������������� �� integer-srv
  if (fAlan_colocall = FALSE)and(Pos(AnsiUpperCase('colocall'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://integer-srv-r.alan.dp.ua');
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.SaveToFile(ConnectionPath);
    exit;
  end
  else
  // 1.3. ���� ��� ������ �� integer-srv + integer-srv2
  begin
    if Pos('srv2-r.alan', Connection) > 0 then Connection:=ReplaceStr(Connection,'srv2-r.alan','srv-r.alan');
    StringList.Add(Connection);
    if Pos('srv2-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv2-r.alan','srv-r.alan'));
    if Pos('srv-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv-r.alan','srv2-r.alan'));
    if Pos('\farmacy_init.php', ConnectionPath) > 0 then
      StringList.SaveToFile(ReplaceStr(ConnectionPath,'\farmacy_init.php','\farmacy_initRepLocal.php'))
    else StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRepLocal.php'));
  end;
  finally
    StringList.Free;
  end;
  if Restart then
  begin
    ShowMessage('���� � ������� ������� ������� �� <'+Connection+'>. ������� ������ ��� �����������');
    Application.Terminate;
    ShellExecute(Application.Handle, 'open', PWideChar(Application.ExeName), nil, nil, SW_SHOWNORMAl);
  end;
end;


class procedure TUpdater.UpdateProgram;
var S : String;
begin
  //1.
  S:= ExtractFileName(ParamStr(0));
  if (UpperCase(S) = UpperCase('FarmacyCash.exe'))
    // and (not FileExists(ExtractFilePath(ParamStr(0)) + 'FarmacyCashServise.exe'))
    // ����� FarmacyCashServise.exe ������������ ������, � �� �� ���������
  then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'FarmacyCashServise.exe', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('FarmacyCashServise.exe'),
        GetBinaryPlatfotmSuffics(ExtractFilePath(ParamStr(0)) + 'FarmacyCashServise.exe')));

  //2.
  FileWriteString(ParamStr(0)+'.uTMP', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName(ParamStr(0)), GetBinaryPlatfotmSuffics(ParamStr(0))));

  //3.
  if (not FileExists(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe')) or (GetFileSizeByName(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe') = 0)
  then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('Upgrader4.exe'),
       GetBinaryPlatfotmSuffics(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe')));

  //4.
  if (gc_ProgramName <> 'FDemo.exe') and (not FileExists(ExtractFilePath(ParamStr(0)) + 'midas.dll'))
  then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'midas.dll', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('midas.dll'), ''));

  //5.
  Execute(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe ' + ParamStr(0), ExtractFileDir(ParamStr(0)));

  ShowMessage('��������� ������� ���������. ������� ������ ��� �����������');
  Application.Terminate
end;

end.



