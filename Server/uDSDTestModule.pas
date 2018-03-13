unit uDSDTestModule;

interface

uses
  TestFramework, System.Classes, SysUtils, System.Generics.Collections,
  Datasnap.DBClient, System.Variants, Data.DB, dmDSD, Windows, uFillDataSet;


type
  TCDSTest = class(TTestCase)
  private
    function CompareDataSet(ADataSet1, ADataSet2: TDataSet): boolean;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Get_Object_UserFormSettingsTest;
    procedure Select_Object_UnitTest;
    procedure Select_Object_PositionTest;
    procedure Select_Object_Goods_RetailTest;
    procedure SmallDataSetReadTest;
    procedure BigDataSetReadTest;
    procedure SimplePacketTest;
    procedure BigPacketTest;
    procedure Select_Movement_Check_Print_Test;
  end;

implementation


procedure TCDSTest.BigDataSetReadTest;
var
  LMasterDataSet, LChildDataSet: TClientDataSet;
  LMemoryStream: TMemoryStream;
  LResult: RawByteString;
  f: Cardinal;
begin
  LMasterDataSet := TClientDataSet.Create(nil);
  LChildDataSet  := TClientDataSet.Create(nil);
  LMemoryStream := TMemoryStream.Create;
  try
    LMasterDataSet.LoadFromFile('gpSelect_Object_Goods_Retail.bin');
    f := GetTickCount;

    LResult := TFillDataSet.PackDataset(LMasterDataSet);

   // Check(false, IntToStr(GetTickCount - f));

    LMemoryStream.Write(LResult[1], Length(LResult));
    LMemoryStream.Position := 0;

    LChildDataSet.LoadFromStream(LMemoryStream);

    CompareDataSet(LMasterDataSet, LChildDataSet)
  finally
    LMasterDataSet.Free;
    LChildDataSet.Free;
    LMemoryStream.Free;
  end;
end;

procedure TCDSTest.SmallDataSetReadTest;
var
  LMasterDataSet, LChildDataSet: TClientDataSet;
  LMemoryStream: TMemoryStream;
  LResult: RawByteString;
begin
  LMasterDataSet := TClientDataSet.Create(nil);
  LChildDataSet  := TClientDataSet.Create(nil);
  LMemoryStream := TMemoryStream.Create;
  try
    LMasterDataSet.LoadFromFile('gpSelect_Object_Unit.bin');
    LResult := TFillDataSet.PackDataset(LMasterDataSet);

    LMemoryStream.Write(LResult[1], Length(LResult));
    LMemoryStream.Position := 0;


    LChildDataSet.LoadFromStream(LMemoryStream);

    CompareDataSet(LMasterDataSet, LChildDataSet)
  finally
    LMasterDataSet.Free;
    LChildDataSet.Free;
    LMemoryStream.Free;
  end;
end;

procedure TCDSTest.BigPacketTest;
var
  LMasterDataSet: TClientDataSet;
  LResultCDS, LResultManual: RawByteString;
  LMemoryStream: TMemoryStream;
  i: integer;
  LFileStream: TFileStream;
begin
  LMasterDataSet := TClientDataSet.Create(nil);
  LMemoryStream := TMemoryStream.Create;
  try
    LMasterDataSet.LoadFromFile('gpSelect_Object_Goods_Retail.bin');
    LMasterDataSet.SaveToStream(LMemoryStream, dfBinary);

    SetLength(LResultCDS, LMemoryStream.Size);
    LMemoryStream.Position := 0;
    LMemoryStream.Read(LResultCDS[1], LMemoryStream.Size);

    LResultManual := TFillDataSet.PackDataset(LMasterDataSet);

    LFileStream := TFileStream.Create('result.bin', fmCreate);
    LFileStream.Write(LResultManual[1], Length(LResultManual));
    LFileStream.Free;


    for I := 0 to Length(LResultManual) do
    begin
      if I > Length(LResultManual) then
      begin
        Check(False, 'Manual length is lower');
        Exit;
      end;

      Check(LResultCDS[I] = LResultManual[I], { IntToHex(I, 1) + ' ' + } IntToStr(I) + ' CDS:' + IntToStr(byte(LResultCDS[I])) + ' Manual:' + IntToStr(byte(LResultManual[I])));
     end
  finally
    LMemoryStream.Free;
    LMasterDataSet.Free;
  end;
end;

function TCDSTest.CompareDataSet(ADataSet1, ADataSet2: TDataSet): boolean;
var
  i: integer;
begin
  ADataSet1.First;
  ADataSet2.First;
  while not ADataSet1.EOF do begin
    for I := 0 to ADataSet1.FieldCount - 1 do
      try
      Check(ADataSet1.Fields[I].AsVariant = ADataSet2.Fields[I].AsVariant,
         ADataSet1.Fields[I].FieldName + '=' + VarToStr(ADataSet1.Fields[I].AsVariant) + '   ' +
         ADataSet2.Fields[I].FieldName + '=' + VarToStr(ADataSet2.Fields[I].AsVariant));
      except
        check(false, FloatToStr(ADataSet2.Fields[I].AsDateTime) + '   ' + FloatToStr(ADataSet1.Fields[I].AsDateTime));

      end;
    ADataSet1.Next;
    ADataSet2.Next;
  end;
end;

procedure TCDSTest.SetUp;
begin
  inherited;
  DM := TDM.Create(nil);
end;

procedure TCDSTest.SimplePacketTest;
var
  LMasterDataSet: TClientDataSet;
  LResultCDS, LResultManual: RawByteString;
  LMemoryStream: TMemoryStream;
  i: integer;
  LFileStream: TFileStream;
begin
  LMasterDataSet := TClientDataSet.Create(nil);
  LMemoryStream := TMemoryStream.Create;
  try
    LMasterDataSet.LoadFromFile('gpSelect_Object_Unit.bin');
    LMasterDataSet.SaveToStream(LMemoryStream, dfBinary);

    SetLength(LResultCDS, LMemoryStream.Size);
    LMemoryStream.Position := 0;
    LMemoryStream.Read(LResultCDS[1], LMemoryStream.Size);

    LResultManual := TFillDataSet.PackDataset(LMasterDataSet);

    LFileStream := TFileStream.Create('result.bin', fmCreate);
    LFileStream.Write(LResultManual[1], Length(LResultManual));
    LFileStream.Free;


    for I := 0 to Length(LResultManual) do
    begin
      if I > Length(LResultManual) then
      begin
        Check(False, 'Manual length is lower');
        Exit;
      end;

      Check(LResultCDS[I] = LResultManual[I], { IntToHex(I, 1) + ' ' + } IntToStr(I) + ' CDS:' + IntToStr(byte(LResultCDS[I])) + ' Manual:' + IntToStr(byte(LResultManual[I])));
     end
  finally
    LMemoryStream.Free;
    LMasterDataSet.Free;
  end;
end;

procedure TCDSTest.TearDown;
begin
  inherited;
  DM.Free;
end;

procedure TCDSTest.Get_Object_UserFormSettingsTest;
var
  LStoredProc: TDSDStoredProc;
  LResultCDS, LResultManual: RawByteString;
  I: Integer;
  Param: TDSDStoredProcParam;
begin
  // TODO понять что делать с этими тестами
  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpGet_Object_UserFormSettings';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
    Param.ParamName := 'inForm';
    Param.DataType := 'TVarChar';
    Param.Value := '';
    ParamsList.Add(Param);
  end;
  LResultCDS := DM.StoredProcExecute(LStoredProc);

  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpGet_Object_UserFormSettings';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
    Param.ParamName := 'inForm';
    Param.DataType := 'TVarChar';
    Param.Value := '';
    ParamsList.Add(Param);
  end;

  LResultManual := DM.StoredProcExecute(LStoredProc);
  for I := 0 to Length(LResultManual) do
  begin
    if I > Length(LResultManual) then
    begin
      Check(False, 'Manual length is lower');
      Exit;
    end;

    Check(LResultCDS[I] = LResultManual[I], { IntToHex(I, 1) + ' ' + } IntToStr(I) + ' CDS:' + IntToStr(byte(LResultCDS[I])) + ' Manual:' + IntToStr(byte(LResultManual[I])));
  end;
end;

procedure TCDSTest.Select_Object_UnitTest;
var
  LStoredProc: TDSDStoredProc;
  LResultCDS, LResultManual: RawByteString;
  I: Integer;
  Param: TDSDStoredProcParam;
begin
  // TODO понять что делать с этими тестами
  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpSelect_Object_Unit';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
    Param.ParamName := 'inisShowAll';
    Param.DataType := 'Boolean';
    Param.Value := False;
    ParamsList.Add(Param);
  end;
  LResultCDS := DM.StoredProcExecute(LStoredProc);

  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpSelect_Object_Unit';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
    Param.ParamName := 'inisShowAll';
    Param.DataType := 'Boolean';
    Param.Value := False;
    ParamsList.Add(Param);
  end;
  LResultManual := DM.StoredProcExecute(LStoredProc);
  for I := 0 to Length(LResultManual) do
  begin
    if I > Length(LResultManual) then
    begin
      Check(False, 'Manual length is lower');
      Exit;
    end;

    Check(LResultCDS[I] = LResultManual[I], { IntToHex(I, 1) + ' ' + } IntToStr(I) + ' CDS:' + IntToStr(byte(LResultCDS[I])) + ' Manual:' + IntToStr(byte(LResultManual[I])));

  end;
end;

procedure TCDSTest.Select_Object_PositionTest;
var
  LStoredProc: TDSDStoredProc;
  LResultCDS, LResultManual: RawByteString;
  I: Integer;
begin
  // TODO понять что делать с этими тестами
  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpSelect_Object_Position';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
  end;
  LResultCDS := DM.StoredProcExecute(LStoredProc);

  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpSelect_Object_Position';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
  end;
  LResultManual := DM.StoredProcExecute(LStoredProc);
  for I := 0 to Length(LResultManual) do
  begin
    if I > Length(LResultManual) then
    begin
      Check(False, 'Manual length is lower');
      Exit;
    end;

    Check(LResultCDS[I] = LResultManual[I], { IntToHex(I, 1) + ' ' + } IntToStr(I) + ' CDS:' + IntToStr(byte(LResultCDS[I])) + ' Manual:' + IntToStr(byte(LResultManual[I])));
  end;

end;

procedure TCDSTest.Select_Movement_Check_Print_Test;
var
  LStoredProc: TDSDStoredProc;
  LResultCDS: RawByteString;
  LParam: TDSDStoredProcParam;
begin
  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := True;
    SPName := 'gpSelect_Movement_Check_Print';
    OutputType := 'otMultiDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
    LParam.ParamName := 'inMovementId';
    LParam.DataType := 'Integer';
    LParam.Value := 2333304;
    ParamsList.Add(LParam);
  end;

  LResultCDS := DM.StoredProcExecute(LStoredProc);


end;

procedure TCDSTest.Select_Object_Goods_RetailTest;
var
  LStoredProc: TDSDStoredProc;
  LResultCDS, LResultManual: RawByteString;
  I: Integer;
  LTick: Cardinal;

begin
  // TODO понять что делать с этими тестами
  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpSelect_Object_Goods_Retail';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
  end;

  LTick := TThread.GetTickCount;
  LResultCDS := DM.StoredProcExecute(LStoredProc);
  LTick := TThread.GetTickCount - LTick;

  Log(LTick.ToString);

  with LStoredProc do
  begin
    Session := '3';
    AutoWidth := False;
    SPName := 'gpSelect_Object_Goods_Retail';
    OutputType := 'otDataSet';
    DataSetType := '';
    ParamsList := TList<TDSDStoredProcParam>.Create;
  end;

  LTick := TThread.GetTickCount;
  LResultManual := DM.StoredProcExecute(LStoredProc);
  LTick := TThread.GetTickCount - LTick;

  Log(LTick.ToString);

  for I := 0 to Length(LResultManual) do
  begin
    if I > Length(LResultManual) then
    begin
      Check(False, 'Manual length is lower');
      Exit;
    end;

    Check(LResultCDS[I] = LResultManual[I], { IntToHex(I, 1) + ' ' + } IntToStr(I) + ' CDS:' + IntToStr(byte(LResultCDS[I])) + ' Manual:' + IntToStr(byte(LResultManual[I])));

  end;
end;



initialization
  TestFramework.RegisterTest('CDS Test', TCDSTest.Suite);

end.

