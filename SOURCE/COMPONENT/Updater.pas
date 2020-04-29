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
begin
  // !!! DEMO
  if gc_ProgramName = 'FDemo.exe' then exit;
  if gc_ProgramName = 'Boutique_Demo.exe' then exit;


  StoredProc := TdsdStoredProc.Create(nil);
  try
    //основное подключение из базы
    StoredProc.Params.AddParam('inConstName', ftString, ptInput, 'zc_Enum_GlobalConst_ConnectParam');
    StoredProc.Params.AddParam('gpGetConstName', ftString, ptOutput, '');
    StoredProc.OutputType := otResult;
    StoredProc.StoredProcName := 'gpGetConstName';
    try
      StoredProc.Execute;
    except
      // Если это наша ошибка, то тихонько обходим
      on E: EStorageException do begin
         exit;
      end;
      // Если не наша, то возмущаемся
      on E: Exception do
          raise;
    end;
    //основное подключение из базы
    Connection := StoredProc.ParamByName('gpGetConstName').AsString;
    //
    //
    StringList := TStringList.Create;
    with StringList do begin
       LoadFromFile(ConnectionPath);
       fFind:=false;
       fFirst_colocall:=false;
       fFirst_srv:=false;
       // есть ли в init.php подключение как в базе, если вдруг нет - в init.php надо изменить
       for i:=0 to Count-1 do fFind:= (fFind) or (StringList[i] = Connection);
       // какой первый в init.php - colocall или integer-srv
       for i:=0 to Count-1
       do if (Pos(AnsiUpperCase('colocall'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_srv = FALSE)
          then fFirst_colocall:= TRUE
          else if (Pos(AnsiUpperCase('alan'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_colocall = FALSE)
               then fFirst_srv:= TRUE;
       //
       StringList.Free;
    end;
    //
    //
    if (fAlan_colocall = TRUE) and (fFirst_srv = TRUE) and (Connection = '') then
       // 1.1. надо переключиться на colocall
       UpdateConnect('alan')
    else
    if (fAlan_colocall = FALSE) and (fFirst_colocall = TRUE) and (Connection = '') then
       // 1.2. надо переключиться на integer-srv
       UpdateConnect('colocall')
    else
    if (TStorageFactory.GetStorage.Connection <> Connection) and (fFind = FALSE) and (Connection<>'')
      // and (TStorageFactory.GetStorage.Connection <> ReplaceStr(Connection,'srv.alan','srv2.alan'))
    then
       // 1.3. надо как раньше на integer-srv + integer-srv2
       UpdateConnect(Connection);
    //
    //
    // теперь тоже самое для отчетов
    //
    if Pos('\init.php', ConnectionPath) > 0 then
    begin
        StoredProc.Params.Clear;
        //основное подключение из базы
        StoredProc.Params.AddParam('inConstName', ftString, ptInput, 'zc_Enum_GlobalConst_ConnectReportParam');
        StoredProc.Params.AddParam('gpGetConstName', ftString, ptOutput, '');
        StoredProc.OutputType := otResult;
        StoredProc.StoredProcName := 'gpGetConstName';
        try
          StoredProc.Execute;
        except
          // Если это наша ошибка, то тихонько обходим
          on E: EStorageException do begin
             exit;
          end;
          // Если не наша, то возмущаемся
          on E: Exception do
              raise;
        end;
        //основное подключение из базы
        ReportConnection := StoredProc.ParamByName('gpGetConstName').AsString;
        //
        StringList := TStringList.Create;
        with StringList do begin
           if FileExists(ReplaceStr(ConnectionPath,'\init.php','\initRep.php')) = TRUE
           then LoadFromFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
           fFind:=false;
           fFirst_colocall:=false;
           fFirst_srv:=false;
           // есть ли в init.php подключение как в базе, если вдруг нет - в init.php надо изменить
           for i:=0 to Count-1 do fFind:= (fFind) or (StringList[i] = ReportConnection);
           // какой первый в init.php - colocall или integer-srv
           for i:=0 to Count-1
           do if (Pos(AnsiUpperCase('colocall'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_srv = FALSE)
              then fFirst_colocall:= TRUE
              else if (Pos(AnsiUpperCase('alan'), AnsiUpperCase(StringList[i])) > 0)and(fFirst_colocall = FALSE)
                   then fFirst_srv:= TRUE;
           //
           StringList.Free;
        end;

    if (fAlan_colocall = TRUE) and (fFirst_srv = TRUE) then
       // 2.1. надо переключиться на colocall
       UpdateConnectReport(TStorageFactory.GetStorage.Connection)
    else
    if (fAlan_colocall = FALSE) and (fFirst_colocall = TRUE) then
       // 2.2. надо переключиться на integer-srv
       UpdateConnectReport(TStorageFactory.GetStorage.Connection)
    else
        if (fFind = FALSE) and (ReportConnection<>'')
        then
           // 2.3. надо как раньше на integer-srv + integer-srv2
           UpdateConnectReport(ReportConnection);
    end;
    //
    //
    // теперь тоже самое для отчетов фармаси
    //
    if Pos('\farmacy_init.php', ConnectionPath) > 0 then
    begin
        StoredProc.Params.Clear;
        //основное подключение из базы
        StoredProc.Params.AddParam('inConstName', ftString, ptInput, 'zc_Enum_GlobalConst_ConnectReportParam');
        StoredProc.Params.AddParam('gpGetConstName', ftString, ptOutput, '');
        StoredProc.OutputType := otResult;
        StoredProc.StoredProcName := 'gpGetConstName';
        try
          StoredProc.Execute;
        except
          // Если это наша ошибка, то тихонько обходим
          on E: EStorageException do begin
             exit;
          end;
          // Если не наша, то возмущаемся
          on E: Exception do
              raise;
        end;
        //основное подключение из базы
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
    // теперь тоже самое для отчетов фармаси через сервис
    //
    if Pos('\farmacy_init.php', ConnectionPath) > 0 then
    begin
        StoredProc.Params.Clear;
        //основное подключение из базы
        StoredProc.Params.AddParam('inConstName', ftString, ptInput, 'zc_Enum_GlobalConst_ConnectReportLocalService');
        StoredProc.Params.AddParam('gpGetConstName', ftString, ptOutput, '');
        StoredProc.OutputType := otResult;
        StoredProc.StoredProcName := 'gpGetConstName';
        try
          StoredProc.Execute;
        except
          // Если это наша ошибка, то тихонько обходим
          on E: EStorageException do begin
             exit;
          end;
          // Если не наша, то возмущаемся
          on E: Exception do
              raise;
        end;
        //основное подключение из базы
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
    BaseVersionInfo := TdsdFormStorageFactory.GetStorage.LoadFileVersion(ExtractFileName(ParamStr(0)));
    LocalVersionInfo := UnilWin.GetFileVersion(ParamStr(0));
    if (BaseVersionInfo.VerHigh > LocalVersionInfo.VerHigh) or
       ((BaseVersionInfo.VerHigh = LocalVersionInfo.VerHigh) and (BaseVersionInfo.VerLow > LocalVersionInfo.VerLow)) then
        if MessageDlg('Обнаружена новая версия программы! Обновить', mtInformation, mbOKCancel, 0) = mrOk then
           UpdateProgram;
  except
    on E: Exception do
       TMessagesForm.Create(nil).Execute('Не работает автоматическое обновление.'#13#10'Обратитесь к разработчику', E.Message);
  end;
end;

class procedure TUpdater.AutomaticUpdateProgramStart;
begin
  try
    Application.ProcessMessages;
    UpdateProgram;
  except
    on E: Exception do
       TMessagesForm.Create(nil).Execute('Не работает автоматическое обновление.'#13#10'Обратитесь к разработчику', E.Message);
  end;
end;


class procedure TUpdater.UpdateConnect (Connection: string);
var StringList: TStringList;
begin
  StringList := TStringList.Create;
  try

  // 1.1. надо переключиться на colocall
  if (fAlan_colocall = TRUE)and(Pos(AnsiUpperCase('alan'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://project-vds.vds.colocall.com/projectReal/index.php');
    StringList.SaveToFile(ConnectionPath);
  end
  else
  // 1.2. надо переключиться на integer-srv
  if (fAlan_colocall = FALSE)and(Pos(AnsiUpperCase('colocall'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://integer-srv.alan.dp.ua');
    StringList.Add('http://project-vds.vds.colocall.com/projectReal/index.php');
    StringList.SaveToFile(ConnectionPath);
  end
  else
  // 1.3. надо как раньше на integer-srv + integer-srv2
  begin
    if Pos('srv2.alan', Connection) > 0 then Connection:=ReplaceStr(Connection,'srv2.alan','srv.alan');
    StringList.Add(Connection);
    if Pos('srv2.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv2.alan','srv.alan'));
    if Pos('srv.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv.alan','srv2.alan'));
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
    ShowMessage('Путь к серверу приложений изменен с <'+TStorageFactory.GetStorage.Connection+'> на <'+'другой'+'>. Нажмите кнопку для перезапуска')
  else
    ShowMessage('Путь к серверу приложений изменен с <'+TStorageFactory.GetStorage.Connection+'> на <'+Connection+'>. Нажмите кнопку для перезапуска')
  ;
  Application.Terminate;
  ShellExecute(Application.Handle, 'open', PWideChar(Application.ExeName), nil, nil, SW_SHOWNORMAl);
end;

class procedure TUpdater.UpdateConnectReport (Connection: string; Restart : boolean = True);
var StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
  // 1.1. надо переключиться на colocall
  if (fAlan_colocall = TRUE)and(Pos(AnsiUpperCase('alan'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
    exit;
  end
  else
  // 1.2. надо переключиться на integer-srv
  if (fAlan_colocall = FALSE)and(Pos(AnsiUpperCase('colocall'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://integer-srv-r.alan.dp.ua');
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
    exit;
  end
  else
  // 1.3. надо как раньше на integer-srv + integer-srv2
  begin
    if Pos('srv2-r.alan', Connection) > 0 then Connection:=ReplaceStr(Connection,'srv2-r.alan','srv-r.alan');
    StringList.Add(Connection);
    if Pos('srv2-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv2-r.alan','srv-r.alan'));
    if Pos('srv-r.alan', Connection) > 0 then StringList.Add(ReplaceStr(Connection,'srv-r.alan','srv2-r.alan'));
    if Pos('\farmacy_init.php', ConnectionPath) > 0 then
      StringList.SaveToFile(ReplaceStr(ConnectionPath,'\farmacy_init.php','\farmacy_initRep.php'))
    else StringList.SaveToFile(ReplaceStr(ConnectionPath,'\init.php','\initRep.php'));
  end;
  finally
    StringList.Free;
  end;
  if Restart then
  begin
    ShowMessage('Путь к серверу ОТЧЕТОВ изменен на <'+Connection+'>. Нажмите кнопку для перезапуска');
    Application.Terminate;
    ShellExecute(Application.Handle, 'open', PWideChar(Application.ExeName), nil, nil, SW_SHOWNORMAl);
  end;
end;

class procedure TUpdater.UpdateConnectReportLocal (Connection: string; Restart : boolean = True);
var StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
  // 1.1. надо переключиться на colocall
  if (fAlan_colocall = TRUE)and(Pos(AnsiUpperCase('alan'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.SaveToFile(ConnectionPath);
    exit;
  end
  else
  // 1.2. надо переключиться на integer-srv
  if (fAlan_colocall = FALSE)and(Pos(AnsiUpperCase('colocall'), AnsiUpperCase(Connection)) > 0) then
  begin
    StringList.Add('http://integer-srv-r.alan.dp.ua');
    StringList.Add('http://project-vds.vds.colocall.com/projectRealR/index.php');
    StringList.SaveToFile(ConnectionPath);
    exit;
  end
  else
  // 1.3. надо как раньше на integer-srv + integer-srv2
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
    ShowMessage('Путь к серверу ОТЧЕТОВ изменен на <'+Connection+'>. Нажмите кнопку для перезапуска');
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
    // Пусть FarmacyCashServise.exe обновляеться всегда, а то не обновляют
  then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'FarmacyCashServise.exe', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('FarmacyCashServise.exe')));

  //2.
  FileWriteString(ParamStr(0)+'.uTMP', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName(ParamStr(0))));

  //3.
  if (not FileExists(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe')) or (GetFileSizeByName(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe') = 0)
  then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('Upgrader4.exe')));

  //4.
  if (gc_ProgramName <> 'FDemo.exe') and (not FileExists(ExtractFilePath(ParamStr(0)) + 'midas.dll'))
  then
     FileWriteString(ExtractFilePath(ParamStr(0)) + 'midas.dll', TdsdFormStorageFactory.GetStorage.LoadFile(ExtractFileName('midas.dll')));

  //5.
  Execute(ExtractFilePath(ParamStr(0)) + 'Upgrader4.exe ' + ParamStr(0), ExtractFileDir(ParamStr(0)));

  ShowMessage('Программа успешно обновлена. Нажмите кнопку для перезапуска');
  Application.Terminate
end;

end.



