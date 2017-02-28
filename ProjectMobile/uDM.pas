unit uDM;

interface

uses
  FMX.Forms, System.SysUtils, System.Classes, Generics.Collections, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Comp.UI, Variants, FireDAC.FMXUI.Wait, dsdDB, Datasnap.DBClient,
  FMX.Dialogs;

CONST
  DataBaseFileName = 'aMobile.sdb';

type
  TDataSets = TObjectList<TFDTable>;

  TStructure = Class(TObject)
  private
    FDataSets: TDataSets;
    FLastDataSet: TFDTable;
    function GetDataSet(const ATableName: String): TFDTable;
    procedure MakeIndex(ATable: TFDTable);
    procedure MakeDopIndex(ATable: TFDTable);
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure OpenDS(ATable: TFDTable);
    procedure AddTable(ATable: TFDTable);
    property DataSets: TDataSets read FDataSets;
    property DataSet[const ATableName: String]: TFDTable read GetDataSet;
  End;

  TDM = class(TDataModule)
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryMeta: TFDMetaInfoQuery;
    qryMeta2: TFDMetaInfoQuery;
    conMain: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    qrySelect: TFDQuery;
    tblObject_Const: TFDTable;
    tblObject_ConstPaidKindName_First: TStringField;
    tblObject_ConstPaidKindId_Second: TIntegerField;
    tblObject_ConstPaidKindName_Second: TStringField;
    tblObject_ConstStatusId_Complete: TIntegerField;
    tblObject_ConstStatusName_Complete: TStringField;
    tblObject_ConstStatusId_UnComplete: TIntegerField;
    tblObject_ConstStatusName_UnComplete: TStringField;
    tblObject_ConstStatusId_Erased: TIntegerField;
    tblObject_ConstStatusName_Erased: TStringField;
    tblObject_ConstUnitId: TIntegerField;
    tblObject_ConstUnitName: TStringField;
    tblObject_ConstUnitId_ret: TIntegerField;
    tblObject_ConstUnitName_ret: TStringField;
    tblObject_ConstCashId: TIntegerField;
    tblObject_ConstCashName: TStringField;
    tblObject_ConstMemberId: TIntegerField;
    tblObject_ConstMemberName: TStringField;
    tblObject_ConstPersonalId: TIntegerField;
    tblObject_ConstUserId: TIntegerField;
    tblObject_ConstUserLogin: TStringField;
    tblObject_ConstUserPassword: TStringField;
    tblObject_ConstWebService: TStringField;
    tblObject_ConstSyncDateIn: TDateTimeField;
    tblObject_ConstSyncDateOut: TDateTimeField;
    tblObject_Partner: TFDTable;
    tblObject_PartnerId: TIntegerField;
    tblObject_PartnerObjectCode: TIntegerField;
    tblObject_PartnerValueData: TStringField;
    tblObject_PartnerAddress: TStringField;
    tblObject_PartnerSchedule: TStringField;
    tblObject_PartnerDebtSum: TFloatField;
    tblObject_PartnerOverSum: TFloatField;
    tblObject_PartnerOverDays: TIntegerField;
    tblObject_PartnerPrepareDayCount: TIntegerField;
    tblObject_PartnerJuridicalId: TIntegerField;
    tblObject_PartnerRouteId: TIntegerField;
    tblObject_PartnerContractId: TIntegerField;
    tblObject_PartnerPriceListId: TIntegerField;
    tblObject_PartnerPriceListId_ret: TIntegerField;
    tblObject_PartnerisErased: TBooleanField;
    tblObject_Juridical: TFDTable;
    tblObject_JuridicalId: TIntegerField;
    tblObject_JuridicalObjectCode: TIntegerField;
    tblObject_JuridicalValueData: TStringField;
    tblObject_JuridicalDebtSum: TFloatField;
    tblObject_JuridicalOverSum: TFloatField;
    tblObject_JuridicalOverDays: TIntegerField;
    tblObject_JuridicalContractId: TIntegerField;
    tblObject_JuridicalisErased: TBooleanField;
    tblObject_Route: TFDTable;
    tblObject_RouteId: TIntegerField;
    tblObject_RouteObjectCode: TIntegerField;
    tblObject_RouteValueData: TStringField;
    tblObject_RouteisErased: TBooleanField;
    tblObject_GoodsGroup: TFDTable;
    tblObject_GoodsGroupId: TIntegerField;
    tblObject_GoodsGroupObjectCode: TIntegerField;
    tblObject_GoodsGroupValueData: TStringField;
    tblObject_GoodsGroupisErased: TBooleanField;
    tblObject_Goods: TFDTable;
    tblObject_GoodsId: TIntegerField;
    tblObject_GoodsObjectCode: TIntegerField;
    tblObject_GoodsValueData: TStringField;
    tblObject_GoodsWeight: TFloatField;
    tblObject_GoodsRemains: TFloatField;
    tblObject_GoodsForecast: TFloatField;
    tblObject_GoodsGoodsGroupId: TIntegerField;
    tblObject_GoodsMeasureId: TIntegerField;
    tblObject_GoodsisErased: TBooleanField;
    tblObject_GoodsKind: TFDTable;
    tblObject_GoodsKindId: TIntegerField;
    tblObject_GoodsKindObjectCode: TIntegerField;
    tblObject_GoodsKindValueData: TStringField;
    tblObject_GoodsKindisErased: TBooleanField;
    tblObject_Measure: TFDTable;
    tblObject_MeasureId: TIntegerField;
    tblObject_MeasureObjectCode: TIntegerField;
    tblObject_MeasureValueData: TStringField;
    tblObject_MeasureisErased: TBooleanField;
    tblObject_GoodsLinkGoodsKind: TFDTable;
    tblObject_GoodsLinkGoodsKindId: TIntegerField;
    tblObject_GoodsLinkGoodsKindGoodsId: TIntegerField;
    tblObject_GoodsLinkGoodsKindGoodsKindId: TIntegerField;
    tblObject_GoodsLinkGoodsKindisErased: TBooleanField;
    tblObject_Contract: TFDTable;
    tblObject_ContractId: TIntegerField;
    tblObject_ContractObjectCode: TIntegerField;
    tblObject_ContractValueData: TStringField;
    tblObject_ContractContractTagName: TStringField;
    tblObject_ContractInfoMoneyName: TStringField;
    tblObject_ContractComment: TStringField;
    tblObject_ContractPaidKindId: TIntegerField;
    tblObject_ContractStartDate: TDateTimeField;
    tblObject_ContractEndDate: TDateTimeField;
    tblObject_ContractChangePercent: TFloatField;
    tblObject_ContractDelayDayCalendar: TFloatField;
    tblObject_ContractDelayDayBank: TFloatField;
    tblObject_ContractisErased: TBooleanField;
    tblObject_PriceList: TFDTable;
    tblObject_PriceListId: TIntegerField;
    tblObject_PriceListObjectCode: TIntegerField;
    tblObject_PriceListValueData: TStringField;
    tblObject_PriceListisErased: TBooleanField;
    tblObject_PriceListPriceWithVAT: TBooleanField;
    tblObject_PriceListVATPercent: TBooleanField;
    tblObject_PriceListItems: TFDTable;
    tblObject_PriceListItemsId: TIntegerField;
    tblObject_PriceListItemsGoodsId: TIntegerField;
    tblObject_PriceListItemsPriceListId: TIntegerField;
    tblObject_PriceListItemsStartDate: TDateTimeField;
    tblObject_PriceListItemsEndDate: TDateTimeField;
    tblObject_PriceListItemsPrice: TFloatField;
    tblObject_ConstPaidKindId_First: TIntegerField;
    qryPartner: TFDQuery;
    qryPartnerAddress: TStringField;
    qryPartnerName: TStringField;
    qryPartnerSCHEDULE: TStringField;
    qryPartnerId: TIntegerField;
    tblObject_PartnerGPSN: TFloatField;
    tblObject_PartnerGPSE: TFloatField;
    qryPartnerGPSN: TFloatField;
    qryPartnerGPSE: TFloatField;
    qryPriceList: TFDQuery;
    qryGoods: TFDQuery;
    qryPriceListId: TIntegerField;
    qryPriceListValueData: TStringField;
    qryGoodsId: TIntegerField;
    qryGoodsGoodsName: TStringField;
    qryGoodsweight: TFloatField;
    qryGoodsPrice: TFloatField;
    qryGoodsEndDate: TDateTimeField;
    qryGoodsGroupName: TStringField;
    qryGoodsMeasureName: TStringField;
    qryGoodsOBJECTCODE: TIntegerField;
    tblMovement_OrderExternal: TFDTable;
    tblMovement_OrderExternalId: TIntegerField;
    tblMovement_OrderExternalGUID: TStringField;
    tblMovement_OrderExternalInvNumber: TStringField;
    tblMovement_OrderExternalOperDate: TDateTimeField;
    tblMovement_OrderExternalStatusId: TIntegerField;
    tblMovement_OrderExternalPartnerId: TIntegerField;
    tblMovement_OrderExternalPaidKindId: TIntegerField;
    tblMovement_OrderExternalContractId: TIntegerField;
    tblMovement_OrderExternalPriceListId: TIntegerField;
    tblMovement_OrderExternalPriceWithVAT: TBooleanField;
    tblMovement_OrderExternalVATPercent: TFloatField;
    tblMovement_OrderExternalChangePercent: TFloatField;
    tblMovement_OrderExternalTotalCountKg: TFloatField;
    tblMovement_OrderExternalTotalSumm: TFloatField;
    tblMovement_OrderExternalInsertDate: TDateTimeField;
    tblMovement_OrderExternalisSync: TBooleanField;
    tblMovementItem_OrderExternal: TFDTable;
    tblMovementItem_OrderExternalId: TIntegerField;
    tblMovementItem_OrderExternalMovementId: TIntegerField;
    tblMovementItem_OrderExternalGUID: TStringField;
    tblMovementItem_OrderExternalGoodsId: TIntegerField;
    tblMovementItem_OrderExternalGoodsKindId: TIntegerField;
    tblMovementItem_OrderExternalChangePercent: TFloatField;
    tblMovementItem_OrderExternalAmount: TFloatField;
    tblMovementItem_OrderExternalPrice: TFloatField;
    tblMovement_StoreReal: TFDTable;
    tblMovement_StoreRealId: TIntegerField;
    tblMovement_StoreRealGUID: TStringField;
    tblMovement_StoreRealInvNumber: TStringField;
    tblMovement_StoreRealOperDate: TDateTimeField;
    tblMovement_StoreRealStatusId: TIntegerField;
    tblMovement_StoreRealPartnerId: TIntegerField;
    tblMovement_StoreRealPriceListId: TIntegerField;
    tblMovement_StoreRealPriceWithVAT: TBooleanField;
    tblMovement_StoreRealVATPercent: TFloatField;
    tblMovement_StoreRealTotalCountKg: TFloatField;
    tblMovement_StoreRealTotalSumm: TFloatField;
    tblMovementItem_StoreReal: TFDTable;
    tblMovementItem_StoreRealId: TIntegerField;
    tblMovementItem_StoreRealMovementId: TIntegerField;
    tblMovementItem_StoreRealGUID: TStringField;
    tblMovementItem_StoreRealGoodsId: TIntegerField;
    tblMovementItem_StoreRealGoodsKindId: TIntegerField;
    tblMovementItem_StoreRealAmount: TFloatField;
    tblMovementItem_StoreRealPrice: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FConnected: Boolean;
    FDataBase: String;
    FSyncDataIn : TDate;
    FSyncDataOut : TDate;

    procedure InitStructure;
  public
    { Public declarations }
    function Connect: Boolean;
    function ConnectWithOutDB: Boolean;
    function CheckStructure: Boolean;
    function CreateDataBase: Boolean;

    function SynchronizeWithMainDatabase : string;
    procedure GetConfigurationInfo;
    procedure GetDictionaries(AName : string);

    property Connected: Boolean read FConnected;
  end;

var
  DM: TDM;
  Structure: TStructure;

implementation

uses
  System.IOUtils, CursorUtils;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TStructure }

procedure TStructure.AddTable(ATable: TFDTable);
begin
  if not FDataSets.Contains(ATable) then
  begin
    MakeIndex(ATable);
    MakeDopIndex(ATable);
    FDataSets.Add(ATable);
  end;
end;

constructor TStructure.Create;
begin
  inherited Create;
  FDataSets := TDataSets.Create(False);
end;

destructor TStructure.Destroy;
begin
  freeAndNil(FDataSets);
  inherited;
end;

function TStructure.GetDataSet(const ATableName: String): TFDTable;
var
  T: TFDTable;
begin
  if Assigned(FLastDataSet) AND SameText(FLastDataSet.TableName, ATableName)
  then
    Exit(FLastDataSet);

  for T in DataSets do
    if SameText(T.TableName, ATableName) then
    begin
      FLastDataSet := T;
      Exit(FLastDataSet);
    end;
  result := nil;
end;

procedure TStructure.OpenDS(ATable: TFDTable);
begin
  if ATable.Active then
    Exit;
  ATable.IndexName := '';
  ATable.Open;
  MakeIndex(ATable);
end;

procedure TStructure.MakeIndex(ATable: TFDTable);
{var
  IndexName: String;}
begin
  {???
  IndexName := 'PK_' + ATable.TableName;
  if (ATable.IndexDefs.Count = 0) then
  Begin
    if SameText(ATable.TableName, 'Words_rel_Table') then
    begin
      ATable.IndexDefs.Add(IndexName, ATable.Fields[0].FieldName + ';' +
        ATable.Fields[1].FieldName + ';' + ATable.Fields[2].FieldName,
        [ixPrimary, ixUnique]);
      with ATable.Indexes.Add do
      begin
        Name := IndexName;
        Fields := ATable.Fields[0].FieldName + ';' + ATable.Fields[1].FieldName
          + ';' + ATable.Fields[2].FieldName;
      end;
    end
    else if SameText(ATable.TableName, 'Doc_rel_Podmiot_Table') then
    begin
      ATable.IndexDefs.Add(IndexName, ATable.Fields[0].FieldName + ';' +
        ATable.Fields[1].FieldName, [ixPrimary, ixUnique]);
      with ATable.Indexes.Add do
      begin
        Name := IndexName;
        Fields := ATable.Fields[0].FieldName + ';' + ATable.Fields[1]
          .FieldName + ';';
      end;
    end
    else
    begin
      ATable.IndexDefs.Add(IndexName, ATable.Fields[0].FieldName,
        [ixPrimary, ixUnique]);
      with ATable.Indexes.Add do
      begin
        Name := IndexName;
        Fields := ATable.Fields[0].FieldName;
      end;
    end;
    ATable.IndexName := IndexName;
  End;
  }
end;

procedure TStructure.MakeDopIndex(ATable: TFDTable);
var
  IndexName: String;
begin
  if SameText(ATable.TableName, 'Words_Table') then
  begin
    IndexName := 'idx_Words_Table_TextWord';
    ATable.IndexDefs.Add(IndexName, 'TextWord', [ixUnique]);
    with ATable.Indexes.Add do
    begin
      Name := IndexName;
      Fields := 'TextWord';
    end;
  end
  else if SameText(ATable.TableName, 'Doc_Table') then
  begin
    IndexName := 'idx_Doc_Table_DocID';
    ATable.IndexDefs.Add(IndexName, 'DocID', [ixUnique]);
    with ATable.Indexes.Add do
    begin
      Name := IndexName;
      Fields := 'DocID';
    end;
  end;
End;

procedure TDM.InitStructure;
var
  C: TComponent;
begin
  for C in Self do
    if C is TFDTable then
    begin
      Structure.AddTable((C as TFDTable));
    end;
end;

function TDM.Connect: Boolean;
begin
  if conMain.Connected then
    Exit(True);

  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  conMain.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DataBaseFileName);
  {$ELSE}
  conMain.Params.Values['Database'] := DataBaseFileName;
  {$ENDIF}

  try
    conMain.Connected := True;
  except
    ON E: Exception DO
    Begin
      if not ConnectWithOutDB or not CreateDataBase then
        Exit(False);
    End;
  end;
  if not conMain.Connected then
    Exit(False);

  if not CheckStructure then
  Begin
    conMain.Connected := False;
    Exit(False);
  End;
  {
  if not CheckSystemData then
  begin
    conMain.Connected := False;
    Exit(False);
  End;
  }
  result := conMain.Connected;
end;

function TDM.ConnectWithOutDB: Boolean;
begin
  FDataBase := conMain.Params.Database;
  conMain.Params.Database := '';
  try
    conMain.Connected := True;
  except
    ON E: Exception DO
    Begin
      //WriteLogE(E.Message);
      Exit(False);
    End;
  end;
  result := True;
end;

function TDM.CheckStructure: Boolean;
var
  T: TFDTable;
  F: TField;
  ChangeStructure: Boolean;
  TempTable: TFDTable;
  J: Integer;

  DestDataType: TFDDataType;
  DestSize: LongWord;
  DestPrec, DestScale: Integer;
  DestAttrs: TFDDataAttributes;
begin
  // Check Tables
  qryMeta.Active := False;
  qryMeta.MetaInfoKind := mkTables;
  try
    qryMeta.Active := True;
  except
    ON E: Exception Do
    Begin
      //WriteLogE(E.Message);
      Exit(False);
    End;
  end;
  for T in Structure.DataSets do
  begin
    if not qryMeta.Locate('TABLE_NAME', T.TableName, [loCaseInsensitive]) then
    begin
      try
        T.CreateTable(False);
      except
        ON E: Exception DO
        Begin
          //WriteLog(E.Message);
          Exit(False);
        End;
      end;
    end
    else
    begin
      qryMeta2.Active := False;
      qryMeta2.MetaInfoKind := mkTableFields;
      qryMeta2.ObjectName := T.TableName;
      try
        qryMeta2.Active := True;
      except
        ON E: Exception Do
        Begin
          //WriteLogE(E.Message);
          Exit(False);
        End;
      end;
      ChangeStructure := False;
      for F in T.Fields do
      Begin
        if F.FieldKind <> fkData then
          Continue;
        if not qryMeta2.Locate('TABLE_NAME;COLUMN_NAME',
          VarArrayOf([T.TableName, F.FieldName]), [loCaseInsensitive]) then
        Begin
          ChangeStructure := True;
          break;
        End
        else
        Begin
          TFDFormatOptions.FieldDef2ColumnDef(F, DestDataType, DestSize,
            DestPrec, DestScale, DestAttrs);
          if (Integer(DestDataType) <> qryMeta2.FieldByName('COLUMN_DATATYPE')
            .AsInteger) or
            (Integer(DestSize) <> qryMeta2.FieldByName('COLUMN_LENGTH')
            .AsInteger) then
          Begin
            ChangeStructure := True;
            break;
          End;
        End;
      End;

      if not ChangeStructure then
      begin
        qryMeta2.First;
        while not qryMeta2.Eof do
        Begin
          if (T.FindField(qryMeta2.FieldByName('COLUMN_NAME').AsString) = nil)
            or (T.FindField(qryMeta2.FieldByName('COLUMN_NAME').AsString)
            .FieldKind <> fkData) then
          begin
            ChangeStructure := True;
            break;
          end;
          qryMeta2.Next;
        End;
      end;
      if ChangeStructure then
      Begin
        TempTable := TFDTable.Create(nil);
        try
          TempTable.Connection := conMain;
          TempTable.TableName := T.TableName;
          TempTable.Open;
          conMain.StartTransaction;
          try
            T.CreateTable(True);
            Structure.OpenDS(T);
            TempTable.First;
            while not TempTable.Eof do
            Begin
              T.Append;
              for J := 0 to TempTable.FieldCount - 1 do
                if T.FindField(TempTable.Fields[J].FieldName) <> nil then
                  T.FieldByName(TempTable.Fields[J].FieldName).Value :=
                    TempTable.Fields[J].Value;
              T.Post;
              TempTable.Next;
            End;
            conMain.Commit;
          except
            on E: Exception do
            Begin
              //WriteLogE(E.Message);
              conMain.Rollback;
              Exit(False);
            End;
          end;
        finally
          freeAndNil(TempTable);
        end;
      End;
    end;

  end;

  result := True;
end;

function TDM.CreateDataBase: Boolean;
begin
  if not conMain.Connected then
    Exit(False);
  try
    conMain.ExecSQL('CREATE DATABASE ' + FDataBase);
  except
    on E: Exception do
    begin
      //WriteLogE(E.Message);
      Exit(False);
    end;
  end;
  try
    conMain.ExecSQL('USE ' + FDataBase);
  except
    on E: Exception do
    begin
      //WriteLogE(E.Message);
      Exit(False);
    end;
  end;
  conMain.Params.Database := FDataBase;
  try
    conMain.Connected := True;
  except
    on E: Exception do
    begin
      //WriteLogE(E.Message);
      Exit(False);
    end;
  end;
  result := True;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  InitStructure;
  FConnected := Connect;
end;

function TDM.SynchronizeWithMainDatabase : string;
begin
  Result := '';

  tblObject_Const.Open;
  if tblObject_Const.RecordCount = 1 then
  begin
    FSyncDataIn := tblObject_ConstSyncDateIn.AsDateTime;
    FSyncDataOut := tblObject_ConstSyncDateOut.AsDateTime;
  end
  else
  begin
    FSyncDataIn := 0;
    FSyncDataOut := 0;
  end;

  conMain.StartTransaction;

  try
    GetConfigurationInfo;

    GetDictionaries('Partner');
    GetDictionaries('Juridical');
    GetDictionaries('Route');
    GetDictionaries('GoodsGroup');
    GetDictionaries('Goods');
    GetDictionaries('GoodsKind');
    GetDictionaries('Measure');
    GetDictionaries('GoodsLinkGoodsKind');
    GetDictionaries('Contract');
    GetDictionaries('PriceList');
    GetDictionaries('PriceListItems');

    conMain.Commit;
    Screen_Cursor_crDefault;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      Result := E.Message;
    end;
  end;
end;

procedure TDM.GetConfigurationInfo;
var
  x : integer;
  GetStoredProc : TdsdStoredProc;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  try
    GetStoredProc.StoredProcName := 'gpGetMobile_Object_Const';
    GetStoredProc.OutputType := otDataSet;
    GetStoredProc.DataSet := TClientDataSet.Create(nil);
    try
      GetStoredProc.Execute;

      tblObject_Const.Open;
      tblObject_Const.First;
      while not tblObject_Const.Eof do
        tblObject_Const.Delete;

      tblObject_Const.Append;

      for x := 0 to GetStoredProc.DataSet.Fields.Count - 1 do
        tblObject_Const.Fields[ x ].Value := GetStoredProc.DataSet.Fields[ x ].Value;

      tblObject_Const.FieldByName('SYNCDATEIN').AsDateTime := Date();

      tblObject_Const.Post;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(GetStoredProc);
  end;
end;


procedure TDM.GetDictionaries(AName : string);
var
  x : integer;
  GetStoredProc : TdsdStoredProc;
  CurDictTable : TFDTable;
begin
  GetStoredProc := TdsdStoredProc.Create(nil);
  try
    if AName = 'Partner' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Partner';
      CurDictTable := tblObject_Partner;
    end
    else
    if AName = 'Juridical' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Juridical';
      CurDictTable := tblObject_Juridical;
    end
    else
    if AName = 'Route' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Route';
      CurDictTable := tblObject_Route;
    end
    else
    if AName = 'GoodsGroup' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsGroup';
      CurDictTable := tblObject_GoodsGroup;
    end
    else
    if AName = 'Goods' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Goods';
      CurDictTable := tblObject_Goods;
    end
    else
    if AName = 'GoodsKind' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsKind';
      CurDictTable := tblObject_GoodsKind;
    end
    else
    if AName = 'Measure' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Measure';
      CurDictTable := tblObject_Measure;
    end
    else
    if AName = 'GoodsLinkGoodsKind' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsLinkGoodsKind';
      CurDictTable := tblObject_GoodsLinkGoodsKind;
    end
    else
    if AName = 'Contract' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_Contract';
      CurDictTable := tblObject_Contract;
    end
    else
    if AName = 'PriceList' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_PriceList';
      CurDictTable := tblObject_PriceList;
    end
    else
    if AName = 'PriceListItems' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_PriceListItems';
      CurDictTable := tblObject_PriceListItems;
    end;

    if GetStoredProc.StoredProcName = '' then
      exit;

    GetStoredProc.Params.AddParam('inSyncDateIn', ftDateTime, ptInput, FSyncDataIn);
    GetStoredProc.OutputType := otDataSet;
    GetStoredProc.DataSet := TClientDataSet.Create(nil);

    try
      GetStoredProc.Execute;

      CurDictTable.Open;
      with GetStoredProc.DataSet do
      begin
        First;
        while not Eof do
        begin
          if CurDictTable.Locate('Id', FieldByName('Id').AsInteger) then
            CurDictTable.Edit
          else
          begin
            if not FieldByName('isSync').AsBoolean then
            begin
              Next;
              continue;
            end;

            CurDictTable.Append;
          end;

          if FieldByName('isSync').AsBoolean then
          begin
            for x := 0 to CurDictTable.Fields.Count - 1 do
              CurDictTable.Fields[ x ].Value := GetStoredProc.DataSet.Fields[ x ].Value;
          end
          else
            CurDictTable.FieldByName('isErased').AsBoolean := true;

          CurDictTable.Post;

          Next;
        end;
      end;
    except
      on E : Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    if Assigned(CurDictTable) then
      CurDictTable.Close;
    FreeAndNil(GetStoredProc);
  end;
end;

initialization

Structure := TStructure.Create;

finalization

FreeAndNil(Structure);

end.

