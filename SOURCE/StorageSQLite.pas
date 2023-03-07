unit StorageSQLite;

{$I dsdVer.inc}

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, Vcl.Forms, Vcl.Dialogs,
  DB, DataSnap.DBClient, Soap.EncdDecd, Windows, UtilConst,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection, ZEncoding, Datasnap.Provider, System.Zip,
  {$IFDEF DELPHI103RIO} System.JSON {$ELSE} Data.DBXJSON {$ENDIF};

procedure SQLiteChechAndArc;

procedure SaveSQLiteData(ASrc: TClientDataSet; ATableName: String);
procedure LoadSQLiteData(ADst: TClientDataSet; ATableName: String; AShowError : Boolean = True);
procedure LoadSQLiteSQL(ADst: TClientDataSet; ASQL: String; AShowError : Boolean = True);

function LoadSQLiteFormData(AFormName, AData, ASession: String) : string;

procedure DeleteSQLiteData(ATableName: String);


implementation

var ZSQLiteConnection: TZConnection;
    MutexSQLite: THandle;

procedure Add_SQLiteLog(AMessage: String);
  var F: TextFile;
begin
  try
    AssignFile(F,ChangeFileExt(Application.ExeName,'_SQLite.log'));
    if not fileExists(ChangeFileExt(Application.ExeName,'_SQLite.log')) then
    begin
      Rewrite(F);
    end
    else
      Append(F);
    //
    try  Writeln(F, DateTimeToStr(Now) + ': ' + AMessage);
    finally CloseFile(F);
    end;
  except
  end;
end;

procedure SQLiteChechAndArc;
  var ZQuery: TZQuery; ZipFile: TZipFile;  ZipFileName: string;
begin
  try
    Add_SQLiteLog('Start MutexSQLite');
    WaitForSingleObject(MutexSQLite, INFINITE);
    try
      ZQuery := TZQuery.Create(Nil);
      ZQuery.Connection := ZSQLiteConnection;
      try
        ZSQLiteConnection.Database := SQLiteFile;
        ZSQLiteConnection.Connect;

        ZQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type = ''table''';
        ZQuery.Open;

        ZQuery.Close;
        ZSQLiteConnection.Disconnect;

        ZipFileName := TPath.GetFileNameWithoutExtension(SQLiteFile) + '.zip';

        ZipFile := TZipFile.Create;

        try
          ZipFile.Open(ZipFileName, zmWrite);
          ZipFile.Add(SQLiteFile);
          ZipFile.Close;
        finally
          ZipFile.Free;
        end;

      finally
        ZQuery.Free;
        ZSQLiteConnection.Disconnect;
      end;
    finally
      ReleaseMutex(MutexSQLite);
      Add_SQLiteLog('End MutexSQLite');
    end;
  Except on E: Exception do
    Add_SQLiteLog('Ошибка проверки и архивирования базы : ' + SQLiteFile + ' - ' + E.Message);
  end;
end;

procedure SaveSQLiteData(ASrc: TClientDataSet; ATableName: String);
  var ZQuery: TZQuery; I, J : Integer; S, SD : string;
      jsonItem : TJSONObject; JSONA: TJSONArray;

begin
  if not ASrc.Active then Exit;

  try
    Add_SQLiteLog('Stert MutexSQLite Save: ' + ATableName);
    WaitForSingleObject(MutexSQLite, INFINITE);
    try
      ZSQLiteConnection.Database := SQLiteFile;
      ZSQLiteConnection.Connect;
      ZQuery := TZQuery.Create(Nil);
      ZQuery.Connection := ZSQLiteConnection;
      ASrc.DisableControls;
      try

          // Удаляем новую если вдркг остался мусор
        ZQuery.SQL.Text := 'drop table if exists ' + ATableName+ 'New';
        ZQuery.ExecSQL;

          // Создаем новую таблицу
        S :=  'CREATE TABLE ' + ATableName + 'New (';
        for I := 0 to ASrc.FieldCount - 1 do
        begin
          if I > 0 then S := S + ', ';
          S := S + ASrc.Fields.Fields[I].FieldName + ' ';
          case ASrc.Fields.Fields[I].DataType of
            ftInteger, ftLargeint : S := S + 'Integer';
            ftDateTime : S := S + 'DateTime';
            ftString, ftWideString :
              if (ASrc.Fields.Fields[I].Size > 0) and (ASrc.Fields.Fields[I].Size <= 255) then
                S := S + 'VarChar(255)'
              else S := S + 'TEXT';
            ftMemo, ftWideMemo : S := S + 'TEXT';
            ftFloat, ftCurrency : S := S + 'Float';
            ftBoolean : S := S + 'Boolean';
          else
            Add_SQLiteLog('Ошибка сохранения таблицы: ' + ATableName + ' - Неописанный тип дпнных: ' + ASrc.Fields.Fields[I].FieldName);
          end;
        end;
        S := S + ')';

        ZQuery.SQL.Text := S;
        ZQuery.ExecSQL;

          // Готовим SQL для заливки
  //      S :=  'INSERT INTO ' + ATableName + 'New (';
  //      for I := 0 to ASrc.FieldCount - 1 do
  //      begin
  //        if I > 0 then S := S + ', ';
  //        S := S + ASrc.Fields.Fields[I].FieldName
  //      end;
  //      S := S + ') VALUES ';

          // Заливаем данные пока медленно но потом может решу чтоб быстрее
  //      ZQuery.Active := False;
  //      ZQuery.SQL.Text := 'select * from ' + ATableName + 'New limit 0';
  //      ZQuery.Active := True;
  //
  //      ASrc.First;
  //      while not ASrc.Eof do
  //      begin
  //        ZQuery.Append;
  //
  //        for I := 0 to ASrc.FieldCount - 1 do
  //        begin
  //          ZQuery.Fields.Fields[I].Value := ASrc.Fields.Fields[I].Value;
  //        end;
  //        ZQuery.Post;
  //
  //        ASrc.Next;
  //      end;

          // Заливаем данные через JSON
        S :=  '';
        for I := 0 to ASrc.Fields.Count - 1 do
        begin
          if I > 0 then S := S + ', ';
          S := S + 'json_extract(json_each.VALUE, ''$.' + ASrc.Fields.Fields[I].FieldName + ''')';
        end;

        JSONA := TJSONArray.Create;
        try
          ASrc.First;
          while not ASrc.Eof do
          begin
            jsonItem := TJSONObject.Create;

            for I := 0 to ASrc.Fields.Count - 1 do
            begin
              if ASrc.Fields.Fields[I].IsNull then
                jsonItem.AddPair(ASrc.Fields.Fields[I].FieldName, TJSONNull.Create)
              else
                case ASrc.Fields.Fields[I].DataType of
                  ftInteger, ftLargeint : jsonItem.AddPair(ASrc.Fields.Fields[I].FieldName, TJSONNumber.Create(ASrc.Fields.Fields[I].AsInteger));
                  ftDateTime : jsonItem.AddPair(ASrc.Fields.Fields[I].FieldName, TJSONString.Create(FormatDateTime('YYYY-MM-DD HH:NN:SS.ZZZ', ASrc.Fields.Fields[I].AsDateTime)));
                  ftFloat : jsonItem.AddPair(ASrc.Fields.Fields[I].FieldName, TJSONNumber.Create(ASrc.Fields.Fields[I].AsCurrency));
                  ftBoolean : if ASrc.Fields.Fields[I].AsBoolean then
                                jsonItem.AddPair(ASrc.Fields.Fields[I].FieldName, TJSONTrue.Create)
                              else jsonItem.AddPair(ASrc.Fields.Fields[I].FieldName, TJSONFalse.Create);
                else
                  jsonItem.AddPair(ASrc.Fields.Fields[I].FieldName, TJSONString.Create(ASrc.Fields.Fields[I].AsString));
                end;
            end;
            JSONA.AddElement(jsonItem);

            ASrc.Next;
          end;

          if ASrc.RecordCount > 0 then
          begin
            ZQuery.SQL.Text := 'INSERT INTO ' + ATableName + 'New SELECT ' + S + ' FROM json_each(:Json) AS json_each';
            ZQuery.ParamByName('Json').Value := JSONA.ToString;
            ZQuery.ExecSQL;
          end;
        finally
          JSONA.Free;
        end;


          // Удаляем предыдущий вариант
        ZQuery.SQL.Text := 'drop table if exists ' + ATableName;
        ZQuery.ExecSQL;

          // Переименовываем
        ZQuery.SQL.Text := 'ALTER TABLE ' + ATableName + 'New RENAME TO ' + ATableName;
        ZQuery.ExecSQL;

      finally
        ZQuery.Free;
        ZSQLiteConnection.Disconnect;
        ASrc.EnableControls;
      end;
    finally
      ReleaseMutex(MutexSQLite);
      Add_SQLiteLog('End MutexSQLite');
    end;
  Except on E: Exception do
    Add_SQLiteLog('Ошибка сохранения таблицы: ' + ATableName + ' - ' + E.Message);
  end;
end;

procedure LoadSQLiteData(ADst: TClientDataSet; ATableName: String; AShowError : Boolean = True);
  var  ZQuery: TZQuery; I : Integer;
       DataSetProvider: TDataSetProvider;
       ClientDataSet: TClientDataSet;
begin

  try
    Add_SQLiteLog('Stert MutexSQLite Load: ' + ATableName);
    WaitForSingleObject(MutexSQLite, INFINITE);
    try
      ZSQLiteConnection.Database := SQLiteFile;
      ZSQLiteConnection.Connect;
      ZQuery := TZQuery.Create(Nil);
      ZQuery.Connection := ZSQLiteConnection;
      try

          // Проверяем наличие таблицы
        ZQuery.SQL.Text := 'SELECT name FROM sqlite_master WHERE type = ''table'' AND name= ''' + ATableName + '''';
        ZQuery.Open;

        if ZQuery.RecordCount < 1 then Exit;

        ZQuery.Close;

        DataSetProvider := TDataSetProvider.Create(Application);
        DataSetProvider.Name := 'DataSetProvider';
        DataSetProvider.DataSet := ZQuery;
        ClientDataSet := TClientDataSet.Create(Application);
        ClientDataSet.ProviderName := DataSetProvider.Name;
        try

            // Получаем данные
          ZQuery.SQL.Text := 'select * FROM ' + ATableName;
          ZQuery.Active := True;

          ClientDataSet.Active := True;

          if ADst.Active then ADst.Close;

  //        for I := 0 to ZQuery.FieldCount - 1 do
  //        begin
  //          case ZQuery.Fields.Fields[I].DataType of
  //            ftInteger, ftLargeint : ADst.FieldDefs.Add(ZQuery.Fields.Fields[I].FieldName, ftInteger);
  //            ftDateTime : ADst.FieldDefs.Add(ZQuery.Fields.Fields[I].FieldName, ftDateTime);
  //            ftString, ftMemo, ftWideMemo, ftWideString :
  //              if (ZQuery.Fields.Fields[I].Size <= 255) and (ZQuery.Fields.Fields[I].Size > 0) then
  //                ADst.FieldDefs.Add(ZQuery.Fields.Fields[I].FieldName, ftString, 255)
  //              else ADst.FieldDefs.Add(ZQuery.Fields.Fields[I].FieldName, ftWideString);
  //            ftFloat : ADst.FieldDefs.Add(ZQuery.Fields.Fields[I].FieldName, ftFloat);
  //            ftBoolean : ADst.FieldDefs.Add(ZQuery.Fields.Fields[I].FieldName, ftBoolean);
  //          else
  //            Add_SQLiteLog('Ошибка сщоздания таблицы: ' + ATableName + ' - Неописанный тип дпнных: ' + ZQuery.Fields.Fields[I].FieldName);
  //          end;
  //        end;
  //        ADst.CreateDataSet;

          ADst.AppendData(ClientDataSet.Data, False);

        finally
          ClientDataSet.Free;
          DataSetProvider.Free;
        end;
      finally
        ZQuery.Free;
        ZSQLiteConnection.Disconnect;
      end;
    finally
      ReleaseMutex(MutexSQLite);
      Add_SQLiteLog('End MutexSQLite');
    end;
  Except on E: Exception do
    Add_SQLiteLog('Ошибка загрузки таблицы '+ ATableName + ' - ' + E.Message);
  end;
end;

procedure LoadSQLiteSQL(ADst: TClientDataSet; ASQL: String; AShowError : Boolean = True);
  var  ZQuery: TZQuery; I : Integer;
       DataSetProvider: TDataSetProvider;
       ClientDataSet: TClientDataSet;
begin

  try
    Add_SQLiteLog('Start MutexSQLite SQL');
    WaitForSingleObject(MutexSQLite, INFINITE);
    try
      ZSQLiteConnection.Database := SQLiteFile;
      ZSQLiteConnection.Connect;
      ZQuery := TZQuery.Create(Nil);
      ZQuery.Connection := ZSQLiteConnection;
      try

        DataSetProvider := TDataSetProvider.Create(Application);
        DataSetProvider.Name := 'DataSetProvider';
        DataSetProvider.DataSet := ZQuery;
        ClientDataSet := TClientDataSet.Create(Application);
        ClientDataSet.ProviderName := DataSetProvider.Name;
        try

            // Получаем данные
          ZQuery.SQL.Text := ASQL;
          ZQuery.Active := True;

          ClientDataSet.Active := True;

          if ADst.Active then ADst.Close;

          ADst.AppendData(ClientDataSet.Data, False);

        finally
          ClientDataSet.Free;
          DataSetProvider.Free;
        end;
      finally
        ZQuery.Free;
        ZSQLiteConnection.Disconnect;
      end;
    finally
      ReleaseMutex(MutexSQLite);
      Add_SQLiteLog('End MutexSQLite');
    end;
  Except on E: Exception do
    Add_SQLiteLog('Ошибка выполнения запроса: '+ ASQL + ' - ' + E.Message);
  end;
end;

function LoadSQLiteFormData(AFormName, AData, ASession: String) : string;
  var ClientDataSet: TClientDataSet;
begin
  Result := '';
  ClientDataSet := TClientDataSet.Create(Nil);
  try

    if AFormName = 'TMainCashForm2' then
      LoadSQLiteSQL(ClientDataSet, 'select MainForm from UserSettings where Id = ''' + ASession + '''')
    else if AFormName = 'TdmMain' then
      LoadSQLiteSQL(ClientDataSet, 'select DataModulForm from UserSettings where Id = ''' + ASession + '''')
    else LoadSQLiteSQL(ClientDataSet, 'select ' + AData + ' from FormData where FormName = ''' + AFormName + '''');

    if ClientDataSet.Active and (ClientDataSet.RecordCount > 0) then
      Result := ClientDataSet.Fields.Fields[0].AsString;

  finally
    ClientDataSet.Free;
  end;
end;

procedure DeleteSQLiteData(ATableName: String);
  var  ZQuery: TZQuery;
begin
  try
    Add_SQLiteLog('Stert MutexSQLite Delete: ' + ATableName);
    WaitForSingleObject(MutexSQLite, INFINITE);
    try
      ZSQLiteConnection.Database := SQLiteFile;
      ZSQLiteConnection.Connect;
      ZQuery := TZQuery.Create(Nil);
      ZQuery.Connection := ZSQLiteConnection;
      try

          // Удаляем если есть
        ZQuery.SQL.Text := 'drop table if exists ' + ATableName;
        ZQuery.ExecSQL;

      finally
        ZQuery.Free;
        ZSQLiteConnection.Disconnect;
      end;
    finally
      ReleaseMutex(MutexSQLite);
      Add_SQLiteLog('End MutexSQLite');
    end;
  Except on E: Exception do
     Add_SQLiteLog('Ошибка удаления таблицы '+ ATableName + ' - ' + E.Message);
  end;
end;

initialization

  MutexSQLite := CreateMutex(nil, false, 'farmacycashMutexSQLite');
  Add_SQLiteLog('Create MutexSQLite');
  GetLastError;
  ZSQLiteConnection := TZConnection.Create(Nil);
  ZSQLiteConnection.Protocol := 'sqlite-3';
  ZSQLiteConnection.LibraryLocation := ExtractFilePath(Application.ExeName) + 'sqlite3.dll';

finalization

  ZSQLiteConnection.Free;
  CloseHandle(MutexSQLite);

end.
