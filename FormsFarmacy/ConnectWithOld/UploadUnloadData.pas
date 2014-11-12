unit UploadUnloadData;

interface

uses
  Windows, Data.DB, Datasnap.DBClient, System.Classes, dsdDB, VKDBFDataSet;

type
  TdmUnloadUploadData = class(TDataModule)
    spUnload: TdsdStoredProc;
    UnloadDataCDS: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    SendTable: TVKSmartDBF;
    procedure SaveGoods;
    procedure OpenSendTable(pathFullTableName:string);
    procedure InsertSendTable(EXEC_STR:String);
  public
    procedure UnloadData;
  end;

implementation

uses Forms, SimpleGauge, StrUtils, SysUtils;

{$R *.DFM}

procedure TdmUnloadUploadData.OpenSendTable(pathFullTableName:string);
begin
 Application.ProcessMessages;
 with SendTable do begin
      Close;
      DBFFileName := pathFullTableName;
      AccessMode.OpenReadWrite := true;
      with DBFFieldDefs.Add as TVKDBFFieldDef do begin
          Name := 'EXEC_STR';
          field_type := 'M';
      end;
      try
         Open;
      except
         CreateTable;
         Open;
      end;
 end;
end;
{------------------------------------------------------------------------------}
procedure TdmUnloadUploadData.DataModuleCreate(Sender: TObject);
begin
  SendTable := TVKSmartDBF.Create(nil);
  TVKSmartDBF(SendTable).OEM := true;
end;

procedure TdmUnloadUploadData.InsertSendTable(EXEC_STR:String);
begin
   with SendTable do begin
      Insert;
      FieldByName('EXEC_STR').AsString:=EXEC_STR;
      Post;
   end;
end;
{------------------------------------------------------------------------------}
procedure TdmUnloadUploadData.SaveGoods;
begin
  spUnload.StoredProcName := 'gpSelect_Object_Goods_Retail';
  spUnload.Execute;
  with TGaugeFactory.GetGauge('Загрузка данных', 1, UnloadDataCDS.RecordCount) do begin
    Start;
    try
      while not UnloadDataCDS.EOF do begin
        InsertSendTable('call InsertUpdateGoodsExternal(' + chr(39) +
            UnloadDataCDS.FieldByName('Name').asString + chr(39) + ',' +
            chr(39) + chr(39) + ',' +
            UnloadDataCDS.FieldByName('Code').asString + ',' +
            ReplaceStr(UnloadDataCDS.FieldByName('NDS').asString, FormatSettings.DecimalSeparator, '.') + ',' +
            chr(39) + copy(UnloadDataCDS.FieldByName('Name').asString, 1, 20) +
            chr(39) + ',' +chr(39) + UnloadDataCDS.FieldByName('MeasureName').asString +
            chr(39) + ', 0, 1);');
        IncProgress;
        UnloadDataCDS.Next;
      end;
    finally
     Finish
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TdmUnloadUploadData.UnloadData;
begin
  OpenSendTable('D:\Unload\guides.dbf');
  SaveGoods;
  SendTable.Close;
end;
{------------------------------------------------------------------------------}

end.
