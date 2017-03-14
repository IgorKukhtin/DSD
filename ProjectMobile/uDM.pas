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
    tblObject_GoodsByGoodsKind: TFDTable;
    tblObject_GoodsByGoodsKindId: TIntegerField;
    tblObject_GoodsByGoodsKindGoodsId: TIntegerField;
    tblObject_GoodsByGoodsKindGoodsKindId: TIntegerField;
    tblObject_GoodsByGoodsKindisErased: TBooleanField;
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
    qryPartnerCONTRACTID: TIntegerField;
    qryPartnerContractName: TWideStringField;
    qryPartnerPRICELISTID: TIntegerField;
    qryPartnerGPSN: TFloatField;
    qryPartnerGPSE: TFloatField;
    qryPartnerPaidKindId: TIntegerField;
    qryPartnerChangePercent: TFloatField;
    qryPartnerPriceWithVAT: TBooleanField;
    qryPartnerVATPercent: TFloatField;
    tblObject_PartnerGPSN: TFloatField;
    tblObject_PartnerGPSE: TFloatField;
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
    tblMovementItem_OrderExternalMovementId: TIntegerField;
    tblMovementItem_OrderExternalGUID: TStringField;
    tblMovementItem_OrderExternalGoodsId: TIntegerField;
    tblMovementItem_OrderExternalGoodsKindId: TIntegerField;
    tblMovementItem_OrderExternalChangePercent: TFloatField;
    tblMovementItem_OrderExternalAmount: TFloatField;
    tblMovementItem_OrderExternalPrice: TFloatField;
    tblMovement_StoreReal: TFDTable;
    tblMovement_StoreRealGUID: TStringField;
    tblMovement_StoreRealInvNumber: TStringField;
    tblMovement_StoreRealOperDate: TDateTimeField;
    tblMovement_StoreRealStatusId: TIntegerField;
    tblMovement_StoreRealPartnerId: TIntegerField;
    tblMovementItem_StoreReal: TFDTable;
    tblMovementItem_StoreRealMovementId: TIntegerField;
    tblMovementItem_StoreRealGUID: TStringField;
    tblMovementItem_StoreRealGoodsId: TIntegerField;
    tblMovementItem_StoreRealGoodsKindId: TIntegerField;
    tblMovementItem_StoreRealAmount: TFloatField;
    qryGoodsItems: TFDQuery;
    qryGoodsItemsGoodsID: TIntegerField;
    qryGoodsItemsKindID: TIntegerField;
    qryGoodsItemsFullInfo: TWideStringField;
    tblMovement_OrderExternalId: TAutoIncField;
    tblObject_PriceListVATPercent: TFloatField;
    tblMovementItem_OrderExternalId: TAutoIncField;
    tblMovement_Visit: TFDTable;
    tblMovement_VisitPartnerId: TIntegerField;
    tblMovement_VisitId: TAutoIncField;
    tblMovement_VisitComment: TStringField;
    qryPartnerPhotos: TFDQuery;
    qryPartnerPhotosPhoto: TBlobField;
    qryPartnerPhotosComment: TStringField;
    tblObject_GoodsByGoodsKindRemains: TFloatField;
    tblObject_GoodsByGoodsKindForecast: TFloatField;
    tblObject_GoodsListSale: TFDTable;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IntegerField3: TIntegerField;
    BooleanField2: TBooleanField;
    tblObject_GoodsListSalePartnerId: TIntegerField;
    tblObject_GoodsListSaleAmountCalc: TFloatField;
    cdsOrderItems: TClientDataSet;
    cdsOrderItemsId: TIntegerField;
    cdsOrderItemsName: TStringField;
    cdsOrderItemsType: TStringField;
    cdsOrderItemsPrice: TFloatField;
    cdsOrderItemsRemains: TFloatField;
    cdsOrderItemsForecast: TFloatField;
    cdsOrderItemsCount: TFloatField;
    cdsOrderItemsMeasure: TStringField;
    cdsOrderItemsGoodsId: TIntegerField;
    cdsOrderItemsKindId: TIntegerField;
    cdsOrderItemsWeight: TFloatField;
    qryGoodsItemsKind: TStringField;
    qryGoodsItemsMeasure: TStringField;
    qryGoodsItemsPrice: TFloatField;
    qryGoodsItemsRemains: TFloatField;
    qryGoodsItemsName: TStringField;
    cdsOrderExternal: TClientDataSet;
    cdsOrderExternalName: TStringField;
    cdsOrderExternalPrice: TStringField;
    cdsOrderExternalWeigth: TStringField;
    cdsOrderExternalStatus: TStringField;
    cdsOrderExternalId: TIntegerField;
    cdsOrderExternalOperDate: TDateField;
    tblMovement_RouteMember: TFDTable;
    AutoIncField1: TAutoIncField;
    tblMovement_RouteMemberGPSN: TFloatField;
    tblMovement_RouteMemberGPSE: TFloatField;
    tblMovement_RouteMemberInsertDate: TDateTimeField;
    tblMovement_RouteMemberisSync: TBooleanField;
    tblMovement_RouteMemberGUID: TStringField;
    tblMovement_VisitGUID: TStringField;
    tblMovement_VisitInvNumber: TStringField;
    tblMovement_VisitOperDate: TDateTimeField;
    tblMovement_VisitStatusId: TIntegerField;
    tblMovement_VisitisSync: TBooleanField;
    tblMovementItem_Visit: TFDTable;
    tblMovementItem_VisitMovementId: TIntegerField;
    tblMovementItem_VisitGUID: TStringField;
    tblMovementItem_VisitPhoto: TBlobField;
    tblMovementItem_VisitComment: TStringField;
    tblMovementItem_VisitInsertDate: TDateTimeField;
    tblMovementItem_VisitId: TAutoIncField;
    qryPhotoGroups: TFDQuery;
    qryPhotos: TFDQuery;
    qryPhotoGroupsId: TIntegerField;
    qryPhotoGroupsComment: TStringField;
    qryPhotoGroupsStatusId: TIntegerField;
    qryPhotosId: TIntegerField;
    qryPhotosPhoto: TBlobField;
    qryPhotosComment: TStringField;
    tblObject_GoodsListSaleDaysCalc: TFloatField;
    cdsStoreReals: TClientDataSet;
    cdsStoreRealsComment: TStringField;
    cdsStoreRealsId: TIntegerField;
    cdsStoreRealsOperDate: TDateField;
    cdsStoreRealsName: TStringField;
    cdsStoreRealsStatus: TStringField;
    cdsStoreRealItems: TClientDataSet;
    cdsStoreRealItemsId: TIntegerField;
    cdsStoreRealItemsName: TStringField;
    cdsStoreRealItemsType: TStringField;
    cdsStoreRealItemsCount: TFloatField;
    cdsStoreRealItemsMeasure: TStringField;
    cdsStoreRealItemsGoodsId: TIntegerField;
    cdsStoreRealItemsKindId: TIntegerField;
    tblMovement_StoreRealIsSync: TBooleanField;
    tblMovement_StoreRealComment: TStringField;
    tblMovement_StoreRealId: TAutoIncField;
    tblMovementItem_StoreRealId: TAutoIncField;
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

    function SaveStoreReal(OldStoreRealId : string; Comment: string;
      DelItems : string; var ErrorMessage : string) : boolean;
    procedure LoadStoreReal(AId: string = '');
    procedure AddedGoodsToStoreReal(AGoods : string);
    procedure DefaultStoreRealItems;
    procedure LoadStoreRealItems(AId: integer);

    function SaveOrderExternal(OldOrderExternalId : string; OperDate: TDate;
      ToralPrice, TotalWeight: Currency; DelItems : string; var ErrorMessage : string) : boolean;
    procedure LoadOrderExternal(AId: string = '');
    procedure AddedGoodsToOrderExternal(AGoods : string);
    procedure DefaultOrderExternalItems;
    procedure LoadOrderExtrenalItems(AId: integer);

    procedure SavePhotoGroup(AGroupName: string);
    procedure LoadPhotoGroups;

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

  cdsStoreRealItems.CreateDataSet;
  cdsStoreReals.CreateDataSet;
  cdsOrderItems.CreateDataSet;
  cdsOrderExternal.CreateDataSet;
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
    GetDictionaries('GoodsByGoodsKind');
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
  str, str1 : string;
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
    if AName = 'GoodsByGoodsKind' then
    begin
      GetStoredProc.StoredProcName := 'gpSelectMobile_Object_GoodsByGoodsKind';
      CurDictTable := tblObject_GoodsByGoodsKind;
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

function TDM.SaveStoreReal(OldStoreRealId : string; Comment: string;
  DelItems : string; var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  i, MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
begin
  Result := false;

  if OldStoreRealId = '' then
  begin
    NewInvNumber := 1;

    qryMaxInvNumber := TFDQuery.Create(nil);
    try
      qryMaxInvNumber.Connection := conMain;
      qryMaxInvNumber.Open('select Max(InvNumber) from Movement_StoreReal');
      if qryMaxInvNumber.RecordCount > 0 then
        NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
    finally
      FreeAndNil(qryMaxInvNumber);
    end;
  end;

  conMain.StartTransaction;
  try
    tblMovement_StoreReal.Open;

    if OldStoreRealId = '' then
    begin
      tblMovement_StoreReal.Append;

      CreateGUID(GlobalId);
      tblMovement_StoreRealGUID.AsString := GUIDToString(GlobalId);
      tblMovement_StoreRealInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_StoreRealOperDate.AsDateTime := Date();
      tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
      tblMovement_StoreRealPartnerId.AsInteger := qryPartnerId.AsInteger;
      tblMovement_StoreRealComment.AsString := Comment;
      tblMovement_StoreRealisSync.AsBoolean := false;

      tblMovement_StoreReal.Post;
      {??? Возможно есть лучший способ получения значения Id новой записи }
      tblMovement_StoreReal.Refresh;
      tblMovement_StoreReal.Last;
      {???}
      MovementId := tblMovement_StoreRealId.AsInteger;
    end
    else
    begin
      if tblMovement_StoreReal.Locate('Id', OldStoreRealId) then
      begin
        tblMovement_StoreReal.Edit;

        tblMovement_StoreRealStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        tblMovement_StoreRealComment.AsString := Comment;

        tblMovement_StoreReal.Post;

        MovementId := StrToInt(OldStoreRealId);
      end
      else
      begin
        ErrorMessage := 'Ошибка работы с БД: не найдена редактируемая заявка';
        exit;
      end;
    end;

    tblMovementItem_StoreReal.Open;

    with cdsStoreRealItems do
    begin
      First;
      while not EOF do
      begin
        if FieldbyName('Id').AsInteger = -1 then // новая запись
        begin
          tblMovementItem_StoreReal.Append;

          tblMovementItem_StoreRealMovementId.AsInteger := MovementId;
          CreateGUID(GlobalId);
          tblMovementItem_StoreRealGUID.AsString := GUIDToString(GlobalId);
          tblMovementItem_StoreRealGoodsId.AsInteger := FieldbyName('GoodsId').AsInteger;
          tblMovementItem_StoreRealGoodsKindId.AsInteger := FieldbyName('KindId').AsInteger;
          tblMovementItem_StoreRealAmount.AsFloat := FieldbyName('Count').AsFloat;

          tblMovementItem_StoreReal.Post;
        end
        else
        begin
          if tblMovementItem_StoreReal.Locate('Id', FieldbyName('Id').AsInteger) then
          begin
            tblMovementItem_StoreReal.Edit;

            tblMovementItem_StoreRealAmount.AsFloat := FieldbyName('Count').AsFloat;

            tblMovementItem_StoreReal.Post;
          end;
        end;

        Next;
      end;
    end;

    if DelItems <> '' then
      conMain.ExecSQL('delete from MovementItem_StoreReal where ID in (' + DelItems + ')');

    conMain.Commit;

    if OldStoreRealId = '' then
      LoadStoreReal(IntToStr(MovementId))
    else
    begin
      cdsStoreReals.Edit;

      cdsStoreRealsComment.AsString := Comment;
      cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString;

      cdsStoreReals.Post;
    end;

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

procedure TDM.LoadStoreReal(AId : string = '');
var
  qryStoreReals : TFDQuery;
begin
  if AId = '' then
  begin
    cdsStoreReals.Open;
    cdsStoreReals.EmptyDataSet;
  end;

  qryStoreReals := TFDQuery.Create(nil);
  try
    qryStoreReals.Connection := conMain;
    qryStoreReals.SQL.Text := 'select ID, OPERDATE, COMMENT, ISSYNC, STATUSID' +
      ' from Movement_StoreReal' +
      ' where PARTNERID = ' + qryPartnerId.AsString +
      ' and STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString;
    if AId <> '' then
      qryStoreReals.SQL.Text := qryStoreReals.SQL.Text + ' and ID = ' + AId;
    qryStoreReals.SQL.Text := qryStoreReals.SQL.Text + ' order by OPERDATE desc';

    qryStoreReals.Open;
    cdsStoreReals.Open;

    qryStoreReals.First;
    while not qryStoreReals.EOF do
    begin
      cdsStoreReals.Append;
      cdsStoreRealsId.AsInteger := qryStoreReals.FieldByName('ID').AsInteger;
      cdsStoreRealsComment.AsString := qryStoreReals.FieldByName('COMMENT').AsString;
      cdsStoreRealsOperDate.AsDateTime := qryStoreReals.FieldByName('OPERDATE').AsDateTime;
      cdsStoreRealsName.AsString := 'Остатки на ' + FormatDateTime('DD.MM.YYYY', qryStoreReals.FieldByName('OPERDATE').AsDateTime);

      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryStoreReals.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsStoreRealsStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Erased.AsString
      else
        cdsStoreRealsStatus.AsString := 'Статус: Неизвестный';

      cdsStoreReals.Post;

      qryStoreReals.Next;
    end;

    qryStoreReals.Close;
  finally
    qryStoreReals.Free;
  end;
end;

procedure TDM.AddedGoodsToStoreReal(AGoods : string);
var
  ArrValue : TArray<string>;
begin
  ArrValue := AGoods.Split([';']);

  cdsStoreRealItems.Append;
  cdsStoreRealItemsId.AsString := ArrValue[0];
  cdsStoreRealItemsGoodsId.AsString := ArrValue[1];   // GoodsId
  cdsStoreRealItemsKindId.AsString := ArrValue[2];    // KindId
  cdsStoreRealItemsName.AsString := ArrValue[3];      // название товара
  cdsStoreRealItemsType.AsString := ArrValue[4];      // вид товара
  cdsStoreRealItemsMeasure.AsString := ' ' + ArrValue[5];   // единица измерения
  cdsStoreRealItemsCount.AsString := ArrValue[6];             // количество по умолчанию

  cdsStoreRealItems.Post;
end;

procedure TDM.DefaultStoreRealItems;
var
  qryGoodsListSale : TFDQuery;
begin
  cdsStoreRealItems.Open;
  cdsStoreRealItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || ' +
      'M.VALUEDATA || '';0'' ' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID AND GK.ISERASED = 0 ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
      'WHERE GLS.PARTNERID = ' + qryPartnerId.AsString + ' and GLS.ISERASED = 0 order by G.VALUEDATA ';

    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToStoreReal(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
  end;
end;

procedure TDM.LoadStoreRealItems(AId : integer);
var
  qryGoodsListSale : TFDQuery;
begin
  cdsStoreRealItems.Open;
  cdsStoreRealItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select ISR.ID || '';'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || ' +
      'M.VALUEDATA || '';'' || ISR.AMOUNT ' +
      'from MOVEMENTITEM_STOREREAL ISR ' +
      'JOIN OBJECT_GOODS G ON ISR.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = ISR.GOODSKINDID ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
      'WHERE ISR.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';

    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToStoreReal(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
  end;
end;


function TDM.SaveOrderExternal(OldOrderExternalId : string; OperDate: TDate;
  ToralPrice, TotalWeight: Currency; DelItems : string; var ErrorMessage : string) : boolean;
var
  GlobalId : TGUID;
  i, MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
begin
  Result := false;

  if OldOrderExternalId = '' then
  begin
    NewInvNumber := 1;

    qryMaxInvNumber := TFDQuery.Create(nil);
    try
      qryMaxInvNumber.Connection := conMain;
      qryMaxInvNumber.Open('select Max(InvNumber) from Movement_OrderExternal');
      if qryMaxInvNumber.RecordCount > 0 then
        NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
    finally
      FreeAndNil(qryMaxInvNumber);
    end;
  end;

  conMain.StartTransaction;
  try
    tblMovement_OrderExternal.Open;

    if OldOrderExternalId = '' then
    begin
      tblMovement_OrderExternal.Append;

      CreateGUID(GlobalId);
      tblMovement_OrderExternalGUID.AsString := GUIDToString(GlobalId);
      tblMovement_OrderExternalInvNumber.AsString := IntToStr(NewInvNumber);
      tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
      tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
      tblMovement_OrderExternalPartnerId.AsInteger := qryPartnerId.AsInteger;
      tblMovement_OrderExternalPaidKindId.AsInteger := qryPartnerPaidKindId.AsInteger;
      tblMovement_OrderExternalContractId.AsInteger := qryPartnerCONTRACTID.AsInteger;
      tblMovement_OrderExternalPriceListId.AsInteger := qryPartnerPRICELISTID.AsInteger;
      tblMovement_OrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
      tblMovement_OrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
      tblMovement_OrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
      tblMovement_OrderExternalTotalCountKg.AsFloat := TotalWeight;
      tblMovement_OrderExternalTotalSumm.AsFloat := ToralPrice;
      tblMovement_OrderExternalInsertDate.AsDateTime := Now();
      tblMovement_OrderExternalisSync.AsBoolean := false;

      tblMovement_OrderExternal.Post;
      {??? Возможно есть лучший способ получения значения Id новой записи }
      tblMovement_OrderExternal.Refresh;
      tblMovement_OrderExternal.Last;
      {???}
      MovementId := tblMovement_OrderExternalId.AsInteger;
    end
    else
    begin
      if tblMovement_OrderExternal.Locate('Id', OldOrderExternalId) then
      begin
        tblMovement_OrderExternal.Edit;

        tblMovement_OrderExternalOperDate.AsDateTime := OperDate;
        tblMovement_OrderExternalStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
        tblMovement_OrderExternalPriceWithVAT.AsBoolean := qryPartnerPriceWithVAT.AsBoolean;
        tblMovement_OrderExternalVATPercent.AsFloat := qryPartnerVATPercent.AsFloat;
        tblMovement_OrderExternalChangePercent.AsFloat := qryPartnerChangePercent.AsFloat;
        tblMovement_OrderExternalTotalCountKg.AsFloat := TotalWeight;
        tblMovement_OrderExternalTotalSumm.AsFloat := ToralPrice;

        tblMovement_OrderExternal.Post;

        MovementId := StrToInt(OldOrderExternalId);
      end
      else
      begin
        ErrorMessage := 'Ошибка работы с БД: не найдена редактируемая заявка';
        exit;
      end;
    end;

    tblMovementItem_OrderExternal.Open;

    with cdsOrderItems do
    begin
      First;
      while not EOF do
      begin
        if FieldbyName('Id').AsInteger = -1 then // новая запись
        begin
          tblMovementItem_OrderExternal.Append;

          tblMovementItem_OrderExternalMovementId.AsInteger := MovementId;
          CreateGUID(GlobalId);
          tblMovementItem_OrderExternalGUID.AsString := GUIDToString(GlobalId);
          tblMovementItem_OrderExternalGoodsId.AsInteger := FieldbyName('GoodsId').AsInteger;
          tblMovementItem_OrderExternalGoodsKindId.AsInteger := FieldbyName('KindId').AsInteger;
          tblMovementItem_OrderExternalAmount.AsFloat := FieldbyName('Count').AsFloat;
          tblMovementItem_OrderExternalPrice.AsFloat := FieldbyName('Price').AsFloat;

          tblMovementItem_OrderExternal.Post;
        end
        else
        begin
          if tblMovementItem_OrderExternal.Locate('Id', FieldbyName('Id').AsInteger) then
          begin
            tblMovementItem_OrderExternal.Edit;

            tblMovementItem_OrderExternalChangePercent.AsFloat := DM.qryPartnerChangePercent.AsFloat;
            tblMovementItem_OrderExternalAmount.AsFloat := FieldbyName('Count').AsFloat;
            tblMovementItem_OrderExternalPrice.AsFloat := FieldbyName('Price').AsFloat;

            tblMovementItem_OrderExternal.Post;
          end;
        end;

        Next;
      end;
    end;

    if DelItems <> '' then
      conMain.ExecSQL('delete from MOVEMENTITEM_ORDEREXTERNAL where ID in (' + DelItems + ')');

    conMain.Commit;

    if OldOrderExternalId = '' then
      LoadOrderExternal(IntToStr(MovementId))
    else
    begin
      cdsOrderExternal.Edit;

      cdsOrderExternalOperDate.AsDateTime := OperDate;
      cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', OperDate);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat('0.00', ToralPrice);
      cdsOrderExternalWeigth.AsString := 'Вес: ' + FormatFloat('0.00', TotalWeight);
      cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString;

      cdsOrderExternal.Post;
    end;

    Result := true;
  except
    on E : Exception do
    begin
      conMain.Rollback;
      ErrorMessage := E.Message;
    end;
  end;
end;

procedure TDM.LoadOrderExternal(AId : string = '');
var
  qryOrderExternal : TFDQuery;
begin
  if AId = '' then
  begin
    cdsOrderExternal.Open;
    cdsOrderExternal.EmptyDataSet;
  end;

  qryOrderExternal := TFDQuery.Create(nil);
  try
    qryOrderExternal.Connection := conMain;
    qryOrderExternal.SQL.Text := 'select ID, OPERDATE, TOTALCOUNTKG, TOTALSUMM, ISSYNC, STATUSID' +
      ' from MOVEMENT_ORDEREXTERNAL' +
      ' where PARTNERID = ' + qryPartnerId.AsString + ' and CONTRACTID = ' + qryPartnerCONTRACTID.AsString +
      ' and STATUSID <> ' + tblObject_ConstStatusId_Erased.AsString;
    if AId <> '' then
      qryOrderExternal.SQL.Text := qryOrderExternal.SQL.Text + ' and ID = ' + AId;
    qryOrderExternal.SQL.Text := qryOrderExternal.SQL.Text + ' order by OPERDATE desc';

    qryOrderExternal.Open;
    cdsOrderExternal.Open;

    qryOrderExternal.First;
    while not qryOrderExternal.EOF do
    begin
      cdsOrderExternal.Append;
      cdsOrderExternalid.AsInteger := qryOrderExternal.FieldByName('ID').AsInteger;
      cdsOrderExternalOperDate.AsDateTime := qryOrderExternal.FieldByName('OPERDATE').AsDateTime;
      cdsOrderExternalName.AsString := 'Заявка на ' + FormatDateTime('DD.MM.YYYY', qryOrderExternal.FieldByName('OPERDATE').AsDateTime);
      cdsOrderExternalPrice.AsString :=  'Стоимость: ' + FormatFloat('0.00', qryOrderExternal.FieldByName('TOTALSUMM').AsFloat);
      cdsOrderExternalWeigth.AsString := 'Вес: ' + FormatFloat('0.00', qryOrderExternal.FieldByName('TOTALCOUNTKG').AsFloat);

      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Complete.AsInteger then
        cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Complete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_UnComplete.AsInteger then
        cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_UnComplete.AsString
      else
      if qryOrderExternal.FieldByName('STATUSID').AsInteger = tblObject_ConstStatusId_Erased.AsInteger then
        cdsOrderExternalStatus.AsString := 'Статус: ' + tblObject_ConstStatusName_Erased.AsString
      else
        cdsOrderExternalStatus.AsString := 'Статус: Неизвестный';

      cdsOrderExternal.Post;

      qryOrderExternal.Next;
    end;

    qryOrderExternal.Close;
  finally
    qryOrderExternal.Free;
  end;
end;

procedure TDM.AddedGoodsToOrderExternal(AGoods : string);
var
  ArrValue : TArray<string>;
begin
  ArrValue := AGoods.Split([';']);

  cdsOrderItems.Append;
  cdsOrderItemsId.AsString := ArrValue[0];
  cdsOrderItemsGoodsId.AsString := ArrValue[1];   // GoodsId
  cdsOrderItemsKindId.AsString := ArrValue[2];    // KindId
  cdsOrderItemsName.AsString := ArrValue[3];      // название товара
  cdsOrderItemsType.AsString := ArrValue[4];      // вид товара
  cdsOrderItemsForecast.AsString := ArrValue[5];  // рекомендуемое количество
  cdsOrderItemsRemains.AsString := ArrValue[6];   // остаток товара
  cdsOrderItemsPrice.AsString := ArrValue[7];     // цена
  cdsOrderItemsMeasure.AsString := ' ' + ArrValue[8];   // единица измерения
  cdsOrderItemsWeight.AsString := ArrValue[9];         // вес
  cdsOrderItemsCount.AsString := ArrValue[10];             // количество по умолчанию

  cdsOrderItems.Post;
end;

procedure TDM.DefaultOrderExternalItems;
var
  qryGoodsListSale : TFDQuery;
begin
  cdsOrderItems.Open;
  cdsOrderItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select ''-1;'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || ' +
      'GLK.FORECAST || '';'' || GLK.REMAINS || '';'' || PI.PRICE || '';'' || M.VALUEDATA || '';'' || G.WEIGHT || '';0'' ' +
      'from OBJECT_GOODSLISTSALE GLS ' +
      'JOIN OBJECT_GOODS G ON GLS.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = GLS.GOODSKINDID AND GK.ISERASED = 0 ' +
      'JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = GLS.GOODSID AND GLK.GOODSKINDID = GLS.GOODSKINDID AND GLK.ISERASED = 0 ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID and M.ISERASED = 0 ' +
      'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = ' + qryPartnerPRICELISTID.AsString + ' ' +
      'WHERE GLS.PARTNERID = ' + qryPartnerId.AsString + ' and GLS.ISERASED = 0 order by G.VALUEDATA ';

    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToOrderExternal(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
  end;
end;

procedure TDM.LoadOrderExtrenalItems(AId : integer);
var
  qryGoodsListSale : TFDQuery;
begin
  cdsOrderItems.Open;
  cdsOrderItems.EmptyDataSet;

  qryGoodsListSale := TFDQuery.Create(nil);
  try
    qryGoodsListSale.Connection := conMain;
    qryGoodsListSale.SQL.Text := 'select IEO.ID || '';'' || G.ID || '';'' || GK.ID || '';'' || G.VALUEDATA || '';'' || GK.VALUEDATA || '';'' || ' +
      'GLK.FORECAST || '';'' || GLK.REMAINS || '';'' || PI.PRICE || '';'' || M.VALUEDATA || '';'' || G.WEIGHT || '';'' || IEO.AMOUNT ' +
      'from MOVEMENTITEM_ORDEREXTERNAL IEO ' +
      'JOIN OBJECT_GOODS G ON IEO.GOODSID = G.ID ' +
      'JOIN OBJECT_GOODSKIND GK ON GK.ID = IEO.GOODSKINDID ' +
      'JOIN OBJECT_GOODSBYGOODSKIND GLK ON GLK.GOODSID = IEO.GOODSID AND GLK.GOODSKINDID = IEO.GOODSKINDID ' +
      'JOIN OBJECT_MEASURE M ON M.ID = G.MEASUREID ' +
      'JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and PI.PRICELISTID = ' + qryPartnerPRICELISTID.AsString + ' ' +
      'WHERE IEO.MOVEMENTID = ' + IntToStr(AId) + ' order by G.VALUEDATA ';

    qryGoodsListSale.Open;

    qryGoodsListSale.First;
    while not qryGoodsListSale.EOF do
    begin
      AddedGoodsToOrderExternal(qryGoodsListSale.Fields[0].AsString);

      qryGoodsListSale.Next;
    end;

    qryGoodsListSale.Close;
  finally
    qryGoodsListSale.Free;
  end;
end;

procedure TDM.SavePhotoGroup(AGroupName: string);
var
  GlobalId : TGUID;
  i, MovementId, NewInvNumber : integer;
  qryMaxInvNumber : TFDQuery;
begin
  NewInvNumber := 1;

  qryMaxInvNumber := TFDQuery.Create(nil);
  try
    qryMaxInvNumber.Connection := conMain;
    qryMaxInvNumber.Open('select Max(InvNumber) from Movement_OrderExternal');
    if qryMaxInvNumber.RecordCount > 0 then
      NewInvNumber := StrToIntDef(qryMaxInvNumber.Fields[0].AsString, 0) + 1;
  finally
    FreeAndNil(qryMaxInvNumber);
  end;

  try
    tblMovement_Visit.Open;

    tblMovement_Visit.Append;

    CreateGUID(GlobalId);
    tblMovement_VisitGUID.AsString := GUIDToString(GlobalId);
    tblMovement_VisitInvNumber.AsString := IntToStr(NewInvNumber);
    tblMovement_VisitOperDate.AsDateTime := Now();
    tblMovement_VisitPartnerId.AsInteger := qryPartnerId.AsInteger;
    if Trim(AGroupName) <> '' then
      tblMovement_VisitComment.AsString := AGroupName
    else
      tblMovement_VisitComment.AsString := 'Общая';
    tblMovement_VisitStatusId.AsInteger := tblObject_ConstStatusId_Complete.AsInteger;
    tblMovement_VisitisSync.AsBoolean := false;

    tblMovement_Visit.Post;

    tblMovement_Visit.Close;
  except
    on E : Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TDM.LoadPhotoGroups;
begin
  qryPhotoGroups.Open('select Id, Comment, StatusId from Movement_Visit where PartnerId = ' + qryPartnerId.AsString +
    ' and StatusId <> ' + tblObject_ConstStatusId_Erased.AsString);
end;

initialization

Structure := TStructure.Create;

finalization

FreeAndNil(Structure);

end.

