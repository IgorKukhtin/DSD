object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 518
  Width = 722
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 40
    Top = 97
  end
  object qryMeta: TFDMetaInfoQuery
    Connection = conMain
    MetaInfoKind = mkCatalogs
    Left = 120
    Top = 32
  end
  object qryMeta2: TFDMetaInfoQuery
    Connection = conMain
    MetaInfoKind = mkCatalogs
    Left = 184
    Top = 32
  end
  object conMain: TFDConnection
    Params.Strings = (
      
        'Database=C:\POLAK\PROJECT\OUTSORCE\Customers\VisualTax\vtMobile\' +
        'DataBase\vtMobile.sdb'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 272
    Top = 32
  end
  object qrySelect: TFDQuery
    Connection = conMain
    Left = 40
    Top = 160
  end
  object tblObject_Const: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Const'
    TableName = 'Object_Const'
    Left = 184
    Top = 144
    object tblObject_ConstPaidKindId_First: TIntegerField
      FieldName = 'PaidKindId_First'
    end
    object tblObject_ConstPaidKindName_First: TStringField
      FieldName = 'PaidKindName_First'
      Size = 255
    end
    object tblObject_ConstPaidKindId_Second: TIntegerField
      FieldName = 'PaidKindId_Second'
    end
    object tblObject_ConstPaidKindName_Second: TStringField
      FieldName = 'PaidKindName_Second'
      Size = 255
    end
    object tblObject_ConstStatusId_Complete: TIntegerField
      FieldName = 'StatusId_Complete'
    end
    object tblObject_ConstStatusName_Complete: TStringField
      FieldName = 'StatusName_Complete'
      Size = 255
    end
    object tblObject_ConstStatusId_UnComplete: TIntegerField
      FieldName = 'StatusId_UnComplete'
    end
    object tblObject_ConstStatusName_UnComplete: TStringField
      FieldName = 'StatusName_UnComplete'
      Size = 255
    end
    object tblObject_ConstStatusId_Erased: TIntegerField
      FieldName = 'StatusId_Erased'
    end
    object tblObject_ConstStatusName_Erased: TStringField
      FieldName = 'StatusName_Erased'
      Size = 255
    end
    object tblObject_ConstUnitId: TIntegerField
      FieldName = 'UnitId'
    end
    object tblObject_ConstUnitName: TStringField
      FieldName = 'UnitName'
      Size = 255
    end
    object tblObject_ConstUnitId_ret: TIntegerField
      FieldName = 'UnitId_ret'
    end
    object tblObject_ConstUnitName_ret: TStringField
      FieldName = 'UnitName_ret'
    end
    object tblObject_ConstCashId: TIntegerField
      FieldName = 'CashId'
    end
    object tblObject_ConstCashName: TStringField
      FieldName = 'CashName'
      Size = 255
    end
    object tblObject_ConstMemberId: TIntegerField
      FieldName = 'MemberId'
    end
    object tblObject_ConstMemberName: TStringField
      FieldName = 'MemberName'
      Size = 255
    end
    object tblObject_ConstPersonalId: TIntegerField
      FieldName = 'PersonalId'
    end
    object tblObject_ConstUserId: TIntegerField
      FieldName = 'UserId'
    end
    object tblObject_ConstUserLogin: TStringField
      FieldName = 'UserLogin'
      Size = 255
    end
    object tblObject_ConstUserPassword: TStringField
      FieldName = 'UserPassword'
      Size = 255
    end
    object tblObject_ConstWebService: TStringField
      FieldName = 'WebService'
      Size = 255
    end
    object tblObject_ConstSyncDateIn: TDateTimeField
      FieldName = 'SyncDateIn'
    end
    object tblObject_ConstSyncDateOut: TDateTimeField
      FieldName = 'SyncDateOut'
    end
  end
  object tblObject_Partner: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Partner'
    TableName = 'Object_Partner'
    Left = 320
    Top = 144
    object tblObject_PartnerId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_PartnerObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_PartnerValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_PartnerAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object tblObject_PartnerGPSN: TFloatField
      FieldName = 'GPSN'
    end
    object tblObject_PartnerGPSE: TFloatField
      FieldName = 'GPSE'
    end
    object tblObject_PartnerSchedule: TStringField
      FieldName = 'Schedule'
      Size = 255
    end
    object tblObject_PartnerDebtSum: TFloatField
      FieldName = 'DebtSum'
    end
    object tblObject_PartnerOverSum: TFloatField
      FieldName = 'OverSum'
    end
    object tblObject_PartnerOverDays: TIntegerField
      FieldName = 'OverDays'
    end
    object tblObject_PartnerPrepareDayCount: TIntegerField
      FieldName = 'PrepareDayCount'
    end
    object tblObject_PartnerJuridicalId: TIntegerField
      FieldName = 'JuridicalId'
    end
    object tblObject_PartnerRouteId: TIntegerField
      FieldName = 'RouteId'
    end
    object tblObject_PartnerContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object tblObject_PartnerPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object tblObject_PartnerPriceListId_ret: TIntegerField
      FieldName = 'PriceListId_ret'
    end
    object tblObject_PartnerisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_Juridical: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Juridical'
    TableName = 'Object_Juridical'
    Left = 184
    Top = 264
    object tblObject_JuridicalId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_JuridicalObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_JuridicalValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_JuridicalDebtSum: TFloatField
      FieldName = 'DebtSum'
    end
    object tblObject_JuridicalOverSum: TFloatField
      FieldName = 'OverSum'
    end
    object tblObject_JuridicalOverDays: TIntegerField
      FieldName = 'OverDays'
    end
    object tblObject_JuridicalContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object tblObject_JuridicalisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_Route: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Route'
    TableName = 'Object_Route'
    Left = 184
    Top = 384
    object tblObject_RouteId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_RouteObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_RouteValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_RouteisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_GoodsGroup: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_GoodsGroup'
    TableName = 'Object_GoodsGroup'
    Left = 184
    Top = 208
    object tblObject_GoodsGroupId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_GoodsGroupObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_GoodsGroupValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_GoodsGroupisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_Goods: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Goods'
    TableName = 'Object_Goods'
    Left = 320
    Top = 208
    object tblObject_GoodsId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_GoodsObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_GoodsValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_GoodsWeight: TFloatField
      FieldName = 'Weight'
    end
    object tblObject_GoodsRemains: TFloatField
      FieldName = 'Remains'
    end
    object tblObject_GoodsForecast: TFloatField
      FieldName = 'Forecast'
    end
    object tblObject_GoodsGoodsGroupId: TIntegerField
      FieldName = 'GoodsGroupId'
    end
    object tblObject_GoodsMeasureId: TIntegerField
      FieldName = 'MeasureId'
    end
    object tblObject_GoodsisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_GoodsKind: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_GoodsKind'
    TableName = 'Object_GoodsKind'
    Left = 320
    Top = 384
    object tblObject_GoodsKindId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_GoodsKindObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_GoodsKindValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_GoodsKindisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_Measure: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Measure'
    TableName = 'Object_Measure'
    Left = 184
    Top = 448
    object tblObject_MeasureId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_MeasureObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_MeasureValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_MeasureisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_GoodsLinkGoodsKind: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_GoodsLinkGoodsKind'
    TableName = 'Object_GoodsLinkGoodsKind'
    Left = 320
    Top = 448
    object tblObject_GoodsLinkGoodsKindId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_GoodsLinkGoodsKindGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblObject_GoodsLinkGoodsKindGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblObject_GoodsLinkGoodsKindisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_Contract: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Contract'
    TableName = 'Object_Contract'
    Left = 184
    Top = 328
    object tblObject_ContractId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_ContractObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_ContractValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_ContractContractTagName: TStringField
      FieldName = 'ContractTagName'
      Size = 255
    end
    object tblObject_ContractInfoMoneyName: TStringField
      FieldName = 'InfoMoneyName'
      Size = 255
    end
    object tblObject_ContractComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tblObject_ContractPaidKindId: TIntegerField
      FieldName = 'PaidKindId'
    end
    object tblObject_ContractStartDate: TDateTimeField
      FieldName = 'StartDate'
    end
    object tblObject_ContractEndDate: TDateTimeField
      FieldName = 'EndDate'
    end
    object tblObject_ContractChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object tblObject_ContractDelayDayCalendar: TFloatField
      FieldName = 'DelayDayCalendar'
    end
    object tblObject_ContractDelayDayBank: TFloatField
      FieldName = 'DelayDayBank'
    end
    object tblObject_ContractisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_PriceList: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_PriceList'
    TableName = 'Object_PriceList'
    Left = 320
    Top = 264
    object tblObject_PriceListId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_PriceListObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_PriceListValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_PriceListisErased: TBooleanField
      FieldName = 'isErased'
    end
    object tblObject_PriceListPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object tblObject_PriceListVATPercent: TBooleanField
      FieldName = 'VATPercent'
    end
  end
  object tblObject_PriceListItems: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_PriceListItems'
    TableName = 'Object_PriceListItems'
    Left = 320
    Top = 328
    object tblObject_PriceListItemsId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_PriceListItemsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblObject_PriceListItemsPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object tblObject_PriceListItemsStartDate: TDateTimeField
      FieldName = 'StartDate'
    end
    object tblObject_PriceListItemsEndDate: TDateTimeField
      FieldName = 'EndDate'
    end
    object tblObject_PriceListItemsPrice: TFloatField
      FieldName = 'Price'
    end
  end
  object qryPartner: TFDQuery
    Connection = conMain
    SQL.Strings = (
      'select * from Object_Partner')
    Left = 40
    Top = 224
    object qryPartnerId: TIntegerField
      FieldName = 'Id'
    end
    object qryPartnerName: TStringField
      FieldName = 'Name'
      Size = 250
    end
    object qryPartnerAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object qryPartnerSCHEDULE: TStringField
      FieldName = 'SCHEDULE'
    end
    object qryPartnerGPSN: TFloatField
      FieldName = 'GPSN'
    end
    object qryPartnerGPSE: TFloatField
      FieldName = 'GPSE'
    end
    object qryPartnerCONTRACTID: TIntegerField
      FieldName = 'CONTRACTID'
    end
    object qryPartnerContractName: TWideStringField
      FieldName = 'ContractName'
    end
    object qryPartnerimAddress: TLargeintField
      FieldName = 'imAddress'
    end
    object qryPartnerimContract: TLargeintField
      FieldName = 'imContract'
    end
    object qryPartnerPRICELISTID: TIntegerField
      FieldName = 'PRICELISTID'
    end
  end
  object qryPriceList: TFDQuery
    Connection = conMain
    SQL.Strings = (
      'select * from Object_Partner')
    Left = 40
    Top = 280
    object qryPriceListId: TIntegerField
      FieldName = 'Id'
    end
    object qryPriceListValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
  end
  object qryGoods: TFDQuery
    Connection = conMain
    SQL.Strings = (
      'select * from Object_Partner')
    Left = 40
    Top = 344
    object qryGoodsId: TIntegerField
      FieldName = 'Id'
    end
    object qryGoodsGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object qryGoodsweight: TFloatField
      FieldName = 'weight'
    end
    object qryGoodsPrice: TFloatField
      FieldName = 'Price'
    end
    object qryGoodsEndDate: TDateTimeField
      FieldName = 'EndDate'
    end
    object qryGoodsGroupName: TStringField
      FieldName = 'GroupName'
      Size = 255
    end
    object qryGoodsMeasureName: TStringField
      FieldName = 'MeasureName'
      Size = 255
    end
    object qryGoodsOBJECTCODE: TIntegerField
      FieldName = 'OBJECTCODE'
    end
  end
  object tblMovement_OrderExternal: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Movement_OrderExternal'
    TableName = 'Movement_OrderExternal'
    Left = 464
    Top = 144
    object tblMovement_OrderExternalId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object tblMovement_OrderExternalGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovement_OrderExternalInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object tblMovement_OrderExternalOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object tblMovement_OrderExternalStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object tblMovement_OrderExternalPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblMovement_OrderExternalPaidKindId: TIntegerField
      FieldName = 'PaidKindId'
    end
    object tblMovement_OrderExternalContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object tblMovement_OrderExternalPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object tblMovement_OrderExternalPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object tblMovement_OrderExternalVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
    object tblMovement_OrderExternalChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object tblMovement_OrderExternalTotalCountKg: TFloatField
      FieldName = 'TotalCountKg'
    end
    object tblMovement_OrderExternalTotalSumm: TFloatField
      FieldName = 'TotalSumm'
    end
    object tblMovement_OrderExternalInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object tblMovement_OrderExternalisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object tblMovementItem_OrderExternal: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_OrderExternal'
    TableName = 'MovementItem_OrderExternal'
    Left = 464
    Top = 208
    object tblMovementItem_OrderExternalId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovementItem_OrderExternalMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblMovementItem_OrderExternalGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovementItem_OrderExternalGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblMovementItem_OrderExternalGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblMovementItem_OrderExternalChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object tblMovementItem_OrderExternalAmount: TFloatField
      FieldName = 'Amount'
    end
    object tblMovementItem_OrderExternalPrice: TFloatField
      FieldName = 'Price'
    end
  end
  object tblMovement_StoreReal: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Movement_StoreReal'
    TableName = 'Movement_StoreReal'
    Left = 464
    Top = 264
    object tblMovement_StoreRealId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovement_StoreRealGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovement_StoreRealInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object tblMovement_StoreRealOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object tblMovement_StoreRealStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object tblMovement_StoreRealPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblMovement_StoreRealPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object tblMovement_StoreRealPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object tblMovement_StoreRealVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
    object tblMovement_StoreRealTotalCountKg: TFloatField
      FieldName = 'TotalCountKg'
    end
    object tblMovement_StoreRealTotalSumm: TFloatField
      FieldName = 'TotalSumm'
    end
  end
  object tblMovementItem_StoreReal: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_StoreReal'
    TableName = 'MovementItem_StoreReal'
    Left = 464
    Top = 328
    object tblMovementItem_StoreRealId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovementItem_StoreRealMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblMovementItem_StoreRealGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovementItem_StoreRealGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblMovementItem_StoreRealGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblMovementItem_StoreRealAmount: TFloatField
      FieldName = 'Amount'
    end
    object tblMovementItem_StoreRealPrice: TFloatField
      FieldName = 'Price'
    end
  end
  object qryOrderItems: TFDQuery
    FilterOptions = [foCaseInsensitive]
    Connection = conMain
    SQL.Strings = (
      
        'select G.ID GoodsID, GK.ID KindID, G.VALUEDATA || '#39' ('#39' || GK.VAL' +
        'UEDATA || '#39')'#39' Name, G.ID || '#39';'#39' || GK.ID || '#39';'#39' || G.VALUEDATA |' +
        '| '#39' ('#39' || GK.VALUEDATA || '#39');'#39' || PI.PRICE FullInfo from OBJECT_' +
        'GOODS G JOIN OBJECT_GOODSLINKGOODSKIND GLK ON GLK.GOODSID = G.ID' +
        ' JOIN OBJECT_GOODSKIND GK ON GK.ID = GLK.GOODSKINDID AND GK.ISER' +
        'ASED = 0 JOIN OBJECT_PRICELISTITEMS PI ON PI.GOODSID = G.ID and ' +
        'PI.PRICELISTID = :PRICELISTID WHERE G.ISERASED = 0 order by Name')
    Left = 40
    Top = 408
    ParamData = <
      item
        Name = 'PRICELISTID'
        DataType = ftInteger
        ParamType = ptInput
      end>
    object qryOrderItemsGoodsID: TIntegerField
      FieldName = 'GoodsID'
    end
    object qryOrderItemsKindID: TIntegerField
      FieldName = 'KindID'
    end
    object qryOrderItemsFullInfo: TWideStringField
      FieldName = 'FullInfo'
      Size = 100
    end
    object qryOrderItemsName: TWideStringField
      FieldName = 'Name'
      Size = 500
    end
  end
end
