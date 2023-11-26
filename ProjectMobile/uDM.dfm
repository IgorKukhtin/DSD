object DM: TDM
  OnCreate = DataModuleCreate
  Height = 1012
  Width = 1626
  PixelsPerInch = 144
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 60
    Top = 145
  end
  object qryMeta: TFDMetaInfoQuery
    Connection = conMain
    MetaInfoKind = mkCatalogs
    Left = 180
    Top = 48
  end
  object qryMeta2: TFDMetaInfoQuery
    Connection = conMain
    MetaInfoKind = mkCatalogs
    Left = 276
    Top = 48
  end
  object conMain: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'LockingMode=Exclusive')
    LoginPrompt = False
    Left = 60
    Top = 48
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 408
    Top = 48
  end
  object tblObject_Const: TFDTable
    Connection = conMain
    FetchOptions.AssignedValues = [evItems]
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.UpdateTableName = 'Object_Const'
    TableName = 'Object_Const'
    Left = 624
    Top = 192
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
    object tblObject_ConstWebService_two: TStringField
      FieldName = 'WebService_two'
      Size = 255
    end
    object tblObject_ConstWebService_three: TStringField
      FieldName = 'WebService_three'
      Size = 255
    end
    object tblObject_ConstWebService_four: TStringField
      FieldName = 'WebService_four'
      Size = 255
    end
    object tblObject_ConstSyncDateIn: TDateTimeField
      FieldName = 'SyncDateIn'
    end
    object tblObject_ConstSyncDateOut: TDateTimeField
      FieldName = 'SyncDateOut'
    end
    object tblObject_ConstMobileVersion: TStringField
      FieldName = 'MobileVersion'
      Size = 255
    end
    object tblObject_ConstMobileAPKFileName: TStringField
      FieldName = 'MobileAPKFileName'
      Size = 255
    end
    object tblObject_ConstPriceListId_def: TIntegerField
      FieldName = 'PriceListId_def'
    end
    object tblObject_ConstPriceListName_def: TStringField
      FieldName = 'PriceListName_def'
      Size = 255
    end
    object tblObject_ConstOperDate_diff: TIntegerField
      FieldName = 'OperDate_diff'
    end
    object tblObject_ConstReturnDayCount: TIntegerField
      FieldName = 'ReturnDayCount'
    end
    object tblObject_ConstCriticalOverDays: TIntegerField
      FieldName = 'CriticalOverDays'
    end
    object tblObject_ConstCriticalDebtSum: TFloatField
      FieldName = 'CriticalDebtSum'
    end
    object tblObject_ConstAPIKey: TStringField
      FieldName = 'APIKey'
      Size = 250
    end
    object tblObject_ConstCriticalWeight: TFloatField
      FieldName = 'CriticalWeight'
      Origin = 'CriticalWeight'
    end
  end
  object tblObject_Partner: TFDTable
    IndexFieldNames = 'ID;CONTRACTID'
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Partner'
    TableName = 'Object_Partner'
    Left = 624
    Top = 300
    object tblObject_PartnerId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_PartnerGUID: TStringField
      FieldName = 'GUID'
      Size = 255
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
    object tblObject_PartnerDocumentDayCount: TFloatField
      FieldName = 'DocumentDayCount'
    end
    object tblObject_PartnerCalcDayCount: TFloatField
      FieldName = 'CalcDayCount'
    end
    object tblObject_PartnerOrderDayCount: TFloatField
      FieldName = 'OrderDayCount'
    end
    object tblObject_PartnerisOperDateOrder: TBooleanField
      FieldName = 'isOperDateOrder'
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
    object tblObject_PartnerisSync: TBooleanField
      FieldName = 'isSync'
    end
    object tblObject_PartnerShortAddress: TStringField
      FieldName = 'ShortAddress'
      Size = 255
    end
    object tblObject_PartnerShortName: TStringField
      FieldName = 'ShortName'
      Size = 255
    end
    object tblObject_PartnerisOrderMin: TBooleanField
      FieldName = 'isOrderMin'
      Origin = 'isOrderMin'
    end
  end
  object tblObject_Juridical: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Juridical'
    TableName = 'Object_Juridical'
    Left = 624
    Top = 492
    object tblObject_JuridicalId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_JuridicalGUID: TStringField
      FieldName = 'GUID'
      Size = 255
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
    object tblObject_JuridicalisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object tblObject_Route: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Route'
    TableName = 'Object_Route'
    Left = 792
    Top = 192
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
    Left = 972
    Top = 192
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
    Left = 972
    Top = 300
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
    object tblObject_GoodsGoodsGroupId: TIntegerField
      FieldName = 'GoodsGroupId'
    end
    object tblObject_GoodsMeasureId: TIntegerField
      FieldName = 'MeasureId'
    end
    object tblObject_GoodsTradeMarkId: TIntegerField
      FieldName = 'TradeMarkId'
    end
    object tblObject_GoodsisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_GoodsKind: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_GoodsKind'
    TableName = 'Object_GoodsKind'
    Left = 972
    Top = 396
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
    Left = 972
    Top = 588
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
  object tblObject_GoodsByGoodsKind: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_GoodsByGoodsKind'
    TableName = 'Object_GoodsByGoodsKind'
    Left = 972
    Top = 492
    object tblObject_GoodsByGoodsKindId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_GoodsByGoodsKindGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblObject_GoodsByGoodsKindGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblObject_GoodsByGoodsKindRemains: TFloatField
      FieldName = 'Remains'
    end
    object tblObject_GoodsByGoodsKindForecast: TFloatField
      FieldName = 'Forecast'
    end
    object tblObject_GoodsByGoodsKindisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_Contract: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_Contract'
    TableName = 'Object_Contract'
    Left = 624
    Top = 396
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
    Left = 792
    Top = 300
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
    object tblObject_PriceListPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object tblObject_PriceListVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
    object tblObject_PriceListisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblObject_PriceListItems: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_PriceListItems'
    TableName = 'Object_PriceListItems'
    Left = 792
    Top = 396
    object tblObject_PriceListItemsId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_PriceListItemsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblObject_PriceListItemsGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblObject_PriceListItemsPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object tblObject_PriceListItemsStartDate: TDateTimeField
      FieldName = 'OrderStartDate'
    end
    object tblObject_PriceListItemsEndDate: TDateTimeField
      FieldName = 'OrderEndDate'
    end
    object tblObject_PriceListItemsPrice: TFloatField
      FieldName = 'OrderPrice'
    end
    object tblObject_PriceListItemsSaleStartDate: TDateTimeField
      FieldName = 'SaleStartDate'
    end
    object tblObject_PriceListItemsSaleEndDate: TDateTimeField
      FieldName = 'SaleEndDate'
    end
    object tblObject_PriceListItemsSalePrice: TFloatField
      FieldName = 'SalePrice'
    end
    object tblObject_PriceListItemsReturnStartDate: TDateTimeField
      FieldName = 'ReturnStartDate'
    end
    object tblObject_PriceListItemsReturnEndDate: TDateTimeField
      FieldName = 'ReturnEndDate'
    end
    object tblObject_PriceListItemsReturnPrice: TFloatField
      FieldName = 'ReturnPrice'
    end
  end
  object qryPartner: TFDQuery
    OnCalcFields = qryPartnerCalcFields
    Connection = conMain
    Left = 60
    Top = 264
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
    object qryPartnerShortAddress: TStringField
      FieldName = 'ShortAddress'
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
    object qryPartnerJuridicalId: TIntegerField
      FieldName = 'JuridicalId'
    end
    object qryPartnerPaidKindId: TIntegerField
      FieldName = 'PaidKindId'
    end
    object qryPartnerChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object qryPartnerPRICELISTID: TIntegerField
      FieldName = 'PRICELISTID'
    end
    object qryPartnerPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object qryPartnerVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
    object qryPartnerPRICELISTID_RET: TIntegerField
      FieldName = 'PRICELISTID_RET'
    end
    object qryPartnerPriceWithVAT_RET: TBooleanField
      FieldName = 'PriceWithVAT_RET'
    end
    object qryPartnerVATPercent_RET: TFloatField
      FieldName = 'VATPercent_RET'
    end
    object qryPartnerCalcDayCount: TFloatField
      FieldName = 'CalcDayCount'
    end
    object qryPartnerOrderDayCount: TFloatField
      FieldName = 'OrderDayCount'
    end
    object qryPartnerisOperDateOrder: TBooleanField
      FieldName = 'isOperDateOrder'
    end
    object qryPartnerDebtSum: TFloatField
      FieldName = 'DebtSum'
    end
    object qryPartnerDebtSumJ: TFloatField
      FieldName = 'DebtSumJ'
    end
    object qryPartnerOverSum: TFloatField
      FieldName = 'OverSum'
    end
    object qryPartnerOverSumJ: TFloatField
      FieldName = 'OverSumJ'
    end
    object qryPartnerOverDays: TIntegerField
      FieldName = 'OverDays'
    end
    object qryPartnerOverDaysJ: TIntegerField
      FieldName = 'OverDaysJ'
    end
    object qryPartnerContractInfo: TStringField
      FieldKind = fkCalculated
      FieldName = 'ContractInfo'
      Size = 400
      Calculated = True
    end
    object qryPartnerFullName: TStringField
      FieldKind = fkCalculated
      FieldName = 'FullName'
      Size = 1000
      Calculated = True
    end
    object qryPartnerPartnerCount: TLargeintField
      FieldName = 'PartnerCount'
    end
    object qryPartnerShortName: TStringField
      FieldName = 'ShortName'
      Size = 255
    end
    object qryPartnerIsOrderMin: TBooleanField
      FieldName = 'isOrderMin'
    end
  end
  object qryPriceList: TFDQuery
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 60
    Top = 768
    object qryPriceListId: TIntegerField
      FieldName = 'Id'
    end
    object qryPriceListValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object qryPriceListPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object qryPriceListVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
  end
  object qryGoodsForPriceList: TFDQuery
    OnCalcFields = qryGoodsForPriceListCalcFields
    Connection = conMain
    Left = 204
    Top = 768
    object qryGoodsForPriceListId: TIntegerField
      FieldName = 'Id'
    end
    object qryGoodsForPriceListObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object qryGoodsForPriceListGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object qryGoodsForPriceListKindName: TStringField
      FieldName = 'KindName'
      Size = 255
    end
    object qryGoodsForPriceListPrice: TFloatField
      FieldName = 'Price'
    end
    object qryGoodsForPriceListMeasure: TStringField
      FieldName = 'Measure'
      Size = 100
    end
    object qryGoodsForPriceListStartDate: TDateTimeField
      FieldName = 'StartDate'
    end
    object qryGoodsForPriceListFullPrice: TStringField
      FieldKind = fkCalculated
      FieldName = 'FullPrice'
      Size = 200
      Calculated = True
    end
    object qryGoodsForPriceListTermin: TStringField
      FieldKind = fkCalculated
      FieldName = 'Termin'
      Size = 255
      Calculated = True
    end
    object qryGoodsForPriceListTradeMarkName: TStringField
      FieldName = 'TradeMarkName'
      Size = 255
    end
    object qryGoodsForPriceListFullGoodsName: TStringField
      FieldKind = fkCalculated
      FieldName = 'FullGoodsName'
      Size = 600
      Calculated = True
    end
  end
  object tblMovement_OrderExternal: TFDTable
    Connection = conMain
    FetchOptions.AssignedValues = [evDetailCascade]
    UpdateOptions.UpdateTableName = 'Movement_OrderExternal'
    TableName = 'Movement_OrderExternal'
    Left = 1200
    Top = 180
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
    object tblMovement_OrderExternalComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tblMovement_OrderExternalPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblMovement_OrderExternalUnitId: TIntegerField
      FieldName = 'UnitId'
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
    Left = 1200
    Top = 276
    object tblMovementItem_OrderExternalId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
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
    Left = 1200
    Top = 360
    object tblMovement_StoreRealId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
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
    object tblMovement_StoreRealComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tblMovement_StoreRealInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object tblMovement_StoreRealIsSync: TBooleanField
      FieldName = 'IsSync'
    end
  end
  object tblMovementItem_StoreReal: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_StoreReal'
    TableName = 'MovementItem_StoreReal'
    Left = 1200
    Top = 456
    object tblMovementItem_StoreRealId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
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
  end
  object qryGoodsItems: TFDQuery
    FilterOptions = [foCaseInsensitive]
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 54
    Top = 420
    object qryGoodsItemsGoodsID: TIntegerField
      FieldName = 'GoodsID'
    end
    object qryGoodsItemsKindID: TIntegerField
      FieldName = 'KindID'
    end
    object qryGoodsItemsObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object qryGoodsItemsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object qryGoodsItemsKind: TStringField
      FieldName = 'KindName'
      Size = 255
    end
    object qryGoodsItemsMeasure: TStringField
      FieldName = 'Measure'
      Size = 100
    end
    object qryGoodsItemsPrice: TFloatField
      FieldName = 'Price'
    end
    object qryGoodsItemsRemains: TFloatField
      FieldName = 'Remains'
    end
    object qryGoodsItemsFullInfo: TWideStringField
      FieldName = 'FullInfo'
      Size = 1000
    end
    object qryGoodsItemsPromoPrice: TWideStringField
      FieldName = 'PromoPrice'
      Size = 15
    end
    object qryGoodsItemsSearchName: TWideStringField
      FieldName = 'SearchName'
      Size = 257
    end
    object qryGoodsItemsTradeMark: TStringField
      FieldName = 'TradeMarkName'
      Size = 255
    end
    object qryGoodsItemsFullGoodsName: TWideStringField
      FieldName = 'FullGoodsName'
      Size = 400
    end
  end
  object tblMovement_Visit: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Movement_Visit'
    TableName = 'Movement_Visit'
    Left = 1440
    Top = 180
    object tblMovement_VisitId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object tblMovement_VisitGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovement_VisitPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblMovement_VisitComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tblMovement_VisitInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object tblMovement_VisitOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object tblMovement_VisitInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object tblMovement_VisitStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object tblMovement_VisitisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object tblObject_GoodsListSale: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_GoodsListSale'
    TableName = 'Object_GoodsListSale'
    Left = 792
    Top = 492
    object IntegerField1: TIntegerField
      FieldName = 'Id'
    end
    object IntegerField2: TIntegerField
      FieldName = 'GoodsId'
    end
    object IntegerField3: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblObject_GoodsListSalePartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblObject_GoodsListSaleAmountCalc: TFloatField
      FieldName = 'AmountCalc'
    end
    object BooleanField2: TBooleanField
      FieldName = 'isErased'
    end
  end
  object cdsOrderItems: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 336
    Top = 336
    object cdsOrderItemsId: TIntegerField
      FieldName = 'Id'
    end
    object cdsOrderItemsGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 250
    end
    object cdsOrderItemsKindName: TStringField
      FieldName = 'KindName'
      Size = 255
    end
    object cdsOrderItemsTradeMarkName: TStringField
      FieldName = 'TradeMarkName'
      Size = 255
    end
    object cdsOrderItemsPrice: TFloatField
      FieldName = 'Price'
    end
    object cdsOrderItemsWeight: TFloatField
      FieldName = 'Weight'
    end
    object cdsOrderItemsRemains: TFloatField
      FieldName = 'Remains'
    end
    object cdsOrderItemsRecommendCount: TFloatField
      FieldName = 'RecommendCount'
    end
    object cdsOrderItemsRecommend: TStringField
      FieldName = 'Recommend'
      Size = 10
    end
    object cdsOrderItemsMeasure: TStringField
      FieldName = 'Measure'
      Size = 100
    end
    object cdsOrderItemsCount: TFloatField
      FieldName = 'Count'
    end
    object cdsOrderItemsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsOrderItemsKindId: TIntegerField
      FieldName = 'KindId'
    end
    object cdsOrderItemsIsPromo: TStringField
      FieldName = 'IsPromo'
      Size = 50
    end
    object cdsOrderItemsisChangePercent: TBooleanField
      FieldName = 'isChangePercent'
    end
    object cdsOrderItemsPriceShow: TStringField
      FieldName = 'PriceShow'
      Size = 200
    end
  end
  object cdsOrderExternal: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 192
    Top = 336
    object cdsOrderExternalid: TIntegerField
      FieldName = 'id'
    end
    object cdsOrderExternalOperDate: TDateField
      FieldName = 'OperDate'
    end
    object cdsOrderExternalComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object cdsOrderExternalName: TStringField
      FieldName = 'Name'
      Size = 255
    end
    object cdsOrderExternalPrice: TStringField
      FieldName = 'Price'
      Size = 100
    end
    object cdsOrderExternalWeight: TStringField
      FieldName = 'Weight'
      Size = 100
    end
    object cdsOrderExternalStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object cdsOrderExternalStatus: TStringField
      FieldName = 'Status'
      Size = 200
    end
    object cdsOrderExternalisSync: TBooleanField
      FieldName = 'isSync'
    end
    object cdsOrderExternalPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object cdsOrderExternalPartnerName: TStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object cdsOrderExternalAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object cdsOrderExternalContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object cdsOrderExternalContractName: TStringField
      FieldName = 'ContractName'
      Size = 255
    end
    object cdsOrderExternalPaidKindId: TIntegerField
      FieldName = 'PaidKindId'
    end
    object cdsOrderExternalPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object cdsOrderExternalPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object cdsOrderExternalVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
    object cdsOrderExternalChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object cdsOrderExternalCalcDayCount: TFloatField
      FieldName = 'CalcDayCount'
    end
    object cdsOrderExternalOrderDayCount: TFloatField
      FieldName = 'OrderDayCount'
    end
    object cdsOrderExternalIsOperDateOrder: TBooleanField
      FieldName = 'isOperDateOrder'
    end
    object cdsOrderExternalIsOrderMin: TBooleanField
      FieldName = 'isOrderMin'
    end
    object cdsOrderExternalPartnerFullName: TStringField
      FieldName = 'PartnerFullName'
      Size = 1000
    end
  end
  object tblMovement_RouteMember: TFDTable
    Connection = conMain
    FetchOptions.AssignedValues = [evDetailCascade]
    UpdateOptions.UpdateTableName = 'Movement_RouteMember'
    TableName = 'Movement_RouteMember'
    Left = 1200
    Top = 576
    object AutoIncField1: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object tblMovement_RouteMemberGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovement_RouteMemberInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object tblMovement_RouteMemberGPSN: TFloatField
      FieldName = 'GPSN'
    end
    object tblMovement_RouteMemberGPSE: TFloatField
      FieldName = 'GPSE'
    end
    object tblMovement_RouteMemberAddressByGPS: TStringField
      FieldName = 'AddressByGPS'
      Size = 255
    end
    object tblMovement_RouteMemberisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object tblMovementItem_Visit: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_Visit'
    TableName = 'MovementItem_Visit'
    Left = 1440
    Top = 276
    object tblMovementItem_VisitId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object tblMovementItem_VisitMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblMovementItem_VisitGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovementItem_VisitPhoto: TBlobField
      FieldName = 'Photo'
    end
    object tblMovementItem_VisitComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tblMovementItem_VisitInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object tblMovementItem_VisitGPSN: TFloatField
      FieldName = 'GPSN'
    end
    object tblMovementItem_VisitGPSE: TFloatField
      FieldName = 'GPSE'
    end
    object tblMovementItem_VisitAddressByGPS: TStringField
      FieldName = 'AddressByGPS'
      Size = 255
    end
    object tblMovementItem_VisitisErased: TBooleanField
      FieldName = 'isErased'
    end
    object tblMovementItem_VisitisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object qryPhotoGroups: TFDQuery
    OnCalcFields = qryPhotoGroupsCalcFields
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 60
    Top = 684
    object qryPhotoGroupsId: TIntegerField
      FieldName = 'Id'
    end
    object qryPhotoGroupsComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object qryPhotoGroupsStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object qryPhotoGroupsName: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name'
      Size = 255
      Calculated = True
    end
    object qryPhotoGroupsOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object qryPhotoGroupsIsSync: TBooleanField
      FieldName = 'IsSync'
    end
  end
  object qryPhotos: TFDQuery
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 376
    Top = 684
    object qryPhotosId: TIntegerField
      FieldName = 'Id'
    end
    object qryPhotosPhoto: TBlobField
      FieldName = 'Photo'
    end
    object qryPhotosComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object qryPhotosisErased: TBooleanField
      FieldName = 'isErased'
    end
    object qryPhotosisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object cdsStoreReals: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 192
    Top = 420
    object cdsStoreRealsId: TIntegerField
      FieldName = 'Id'
    end
    object cdsStoreRealsOperDate: TDateField
      FieldName = 'OperDate'
    end
    object cdsStoreRealsName: TStringField
      FieldName = 'Name'
      Size = 255
    end
    object cdsStoreRealsComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object cdsStoreRealsStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object cdsStoreRealsStatus: TStringField
      FieldName = 'Status'
      Size = 255
    end
    object cdsStoreRealsisSync: TBooleanField
      FieldName = 'isSync'
    end
    object cdsStoreRealsPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object cdsStoreRealsPartnerName: TStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object cdsStoreRealsAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object cdsStoreRealsPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object cdsStoreRealsPartnerFullName: TStringField
      FieldName = 'PartnerFullName'
      Size = 1000
    end
  end
  object cdsStoreRealItems: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 420
    object cdsStoreRealItemsId: TIntegerField
      FieldName = 'Id'
    end
    object cdsStoreRealItemsGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsStoreRealItemsKindName: TStringField
      FieldName = 'KindName'
      Size = 255
    end
    object cdsStoreRealItemsTradeMarkName: TStringField
      FieldName = 'TradeMarkName'
      Size = 255
    end
    object cdsStoreRealItemsCount: TFloatField
      FieldName = 'Count'
    end
    object cdsStoreRealItemsMeasure: TStringField
      FieldName = 'Measure'
      Size = 100
    end
    object cdsStoreRealItemsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsStoreRealItemsKindId: TIntegerField
      FieldName = 'KindId'
    end
  end
  object tblMovement_Promo: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Movement_Promo'
    TableName = 'Movement_Promo'
    Left = 624
    Top = 720
    object tblMovement_PromoId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovement_PromoInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object tblMovement_PromoOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object tblMovement_PromoStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object tblMovement_PromoStartSale: TDateTimeField
      FieldName = 'StartSale'
    end
    object tblMovement_PromoEndSale: TDateTimeField
      FieldName = 'EndSale'
    end
    object tblMovement_PromoisChangePercent: TBooleanField
      FieldName = 'isChangePercent'
    end
    object tblMovement_PromoCommentMain: TStringField
      FieldName = 'CommentMain'
      Size = 255
    end
  end
  object tblMovementItem_PromoPartner: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_PromoPartner'
    TableName = 'MovementItem_PromoPartner'
    Left = 792
    Top = 720
    object tblMovementItem_PromoPartnerId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovementItem_PromoPartnerMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblMovementItem_PromoPartnerContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object tblMovementItem_PromoPartnerPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
  end
  object tblMovementItem_PromoGoods: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_PromoGoods'
    TableName = 'MovementItem_PromoGoods'
    Left = 972
    Top = 720
    object tblMovementItem_PromoGoodsId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovementItem_PromoGoodsMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblMovementItem_PromoGoodsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblMovementItem_PromoGoodsGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblMovementItem_PromoGoodsPriceWithOutVAT: TFloatField
      FieldName = 'PriceWithOutVAT'
    end
    object tblMovementItem_PromoGoodsPriceWithVAT: TFloatField
      FieldName = 'PriceWithVAT'
    end
    object tblMovementItem_PromoGoodsTaxPromo: TFloatField
      FieldName = 'TaxPromo'
    end
  end
  object tblMovement_ReturnIn: TFDTable
    Connection = conMain
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    UpdateOptions.UpdateTableName = 'Movement_ReturnIn'
    TableName = 'Movement_ReturnIn'
    Left = 1440
    Top = 360
    object tblMovement_ReturnInId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object tblMovement_ReturnInGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovement_ReturnInInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object tblMovement_ReturnInOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object tblMovement_ReturnInStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object tblMovement_ReturnInPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object tblMovement_ReturnInInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object tblMovement_ReturnInVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
    object tblMovement_ReturnInChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object tblMovement_ReturnInTotalCountKg: TFloatField
      FieldName = 'TotalCountKg'
    end
    object tblMovement_ReturnInTotalSummPVAT: TFloatField
      FieldName = 'TotalSummPVAT'
    end
    object tblMovement_ReturnInPaidKindId: TIntegerField
      FieldName = 'PaidKindId'
    end
    object tblMovement_ReturnInPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblMovement_ReturnInUnitId: TIntegerField
      FieldName = 'UnitId'
    end
    object tblMovement_ReturnInContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object tblMovement_ReturnInComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tblMovement_ReturnInSubjectDocId: TIntegerField
      FieldName = 'SubjectDocId'
    end
    object tblMovement_ReturnInisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object tblMovementItem_ReturnIn: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_ReturnIn'
    TableName = 'MovementItem_ReturnIn'
    Left = 1440
    Top = 456
    object tblMovementItem_ReturnInId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object tblMovementItem_ReturnInMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblMovementItem_ReturnInGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovementItem_ReturnInGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblMovementItem_ReturnInGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object tblMovementItem_ReturnInAmount: TFloatField
      FieldName = 'Amount'
    end
    object tblMovementItem_ReturnInPrice: TFloatField
      FieldName = 'Price'
    end
    object tblMovementItem_ReturnInChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object tblMovementItem_ReturnInSubjectDocId: TIntegerField
      FieldName = 'SubjectDocId'
    end
    object tblMovementItem_ReturnInisRecalcPrice: TBooleanField
      FieldName = 'isRecalcPrice'
    end
  end
  object cdsReturnIn: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 192
    Top = 504
    object cdsReturnInId: TIntegerField
      FieldName = 'Id'
    end
    object cdsReturnInOperDate: TDateField
      FieldName = 'OperDate'
    end
    object cdsReturnInName: TStringField
      FieldName = 'Name'
      Size = 255
    end
    object cdsReturnInPrice: TStringField
      FieldName = 'Price'
      Size = 100
    end
    object cdsReturnInWeight: TStringField
      FieldName = 'Weight'
      Size = 100
    end
    object cdsReturnInStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object cdsReturnInStatus: TStringField
      FieldName = 'Status'
      Size = 200
    end
    object cdsReturnInComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object cdsReturnInisSync: TBooleanField
      FieldName = 'isSync'
    end
    object cdsReturnInPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object cdsReturnInPartnerName: TStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object cdsReturnInAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object cdsReturnInContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object cdsReturnInContractName: TStringField
      FieldName = 'ContractName'
      Size = 255
    end
    object cdsReturnInPaidKindId: TIntegerField
      FieldName = 'PaidKindId'
    end
    object cdsReturnInPriceListId: TIntegerField
      FieldName = 'PriceListId'
    end
    object cdsReturnInPriceWithVAT: TBooleanField
      FieldName = 'PriceWithVAT'
    end
    object cdsReturnInVATPercent: TFloatField
      FieldName = 'VATPercent'
    end
    object cdsReturnInChangePercent: TFloatField
      FieldName = 'ChangePercent'
    end
    object cdsReturnInPartnerFullName: TStringField
      FieldName = 'PartnerFullName'
      Size = 1000
    end
    object cdsReturnInSubjectDocId: TIntegerField
      FieldName = 'SubjectDocId'
    end
    object cdsReturnInSubjectDocName: TStringField
      FieldName = 'SubjectDocName'
      Size = 255
    end
  end
  object cdsReturnInItems: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 504
    object cdsReturnInItemsId: TIntegerField
      FieldName = 'Id'
    end
    object cdsReturnInItemsGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsReturnInItemsKindName: TStringField
      FieldName = 'KindName'
      Size = 255
    end
    object cdsReturnInItemsTradeMarkName: TStringField
      FieldName = 'TradeMarkName'
      Size = 255
    end
    object cdsReturnInItemsPrice: TFloatField
      FieldName = 'Price'
    end
    object cdsReturnInItemsWeight: TFloatField
      FieldName = 'Weight'
    end
    object cdsReturnInItemsMeasure: TStringField
      FieldName = 'Measure'
      Size = 100
    end
    object cdsReturnInItemsCount: TFloatField
      FieldName = 'Count'
    end
    object cdsReturnInItemsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsReturnInItemsKindId: TIntegerField
      FieldName = 'KindId'
    end
    object cdsReturnInItemsRecalcPriceName: TStringField
      FieldName = 'RecalcPriceName'
    end
    object cdsReturnInItemsSubjectDocId: TIntegerField
      FieldName = 'SubjectDocId'
    end
    object cdsReturnInItemsSubjectDocName: TStringField
      FieldName = 'SubjectDocName'
      Size = 255
    end
    object cdsReturnInItemsCurrencyName: TStringField
      FieldName = 'CurrencyName'
      Size = 10
    end
  end
  object qryPromoPartners: TFDQuery
    Connection = conMain
    Left = 60
    Top = 852
    object qryPromoPartnersPartnerName: TStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object qryPromoPartnersContractName: TWideStringField
      FieldName = 'ContractName'
      Size = 255
    end
    object qryPromoPartnersAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object qryPromoPartnersPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object qryPromoPartnersContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object qryPromoPartnersPromoIds: TWideStringField
      FieldName = 'PromoIds'
    end
  end
  object qryPromoGoods: TFDQuery
    OnCalcFields = qryPromoGoodsCalcFields
    Connection = conMain
    Left = 192
    Top = 852
    object qryPromoGoodsGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object qryPromoGoodsKindName: TWideStringField
      FieldName = 'KindName'
      Size = 255
    end
    object qryPromoGoodsTax: TWideStringField
      FieldName = 'Tax'
      Size = 100
    end
    object qryPromoGoodsPrice: TWideStringField
      FieldName = 'Price'
      Size = 250
    end
    object qryPromoGoodsTermin: TWideStringField
      FieldName = 'Termin'
      Size = 200
    end
    object qryPromoGoodsPromoId: TIntegerField
      FieldName = 'PromoId'
    end
    object qryPromoGoodsObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object qryPromoGoodsTradeMarkName: TStringField
      FieldName = 'TradeMarkName'
      Size = 255
    end
    object qryPromoGoodsFullGoodsName: TStringField
      FieldKind = fkCalculated
      FieldName = 'FullGoodsName'
      Size = 400
      Calculated = True
    end
  end
  object tblMovement_Task: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Movement_Task'
    TableName = 'Movement_Task'
    Left = 624
    Top = 816
    object tblMovement_TaskId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovement_TaskInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object tblMovement_TaskOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object tblMovement_TaskStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object tblMovement_TaskPersonalId: TIntegerField
      FieldName = 'PersonalId'
    end
  end
  object tblMovementItem_Task: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'MovementItem_Task'
    TableName = 'MovementItem_Task'
    Left = 792
    Top = 816
    object tblMovementItem_TaskId: TIntegerField
      FieldName = 'Id'
    end
    object tblMovementItem_TaskMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblMovementItem_TaskPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblMovementItem_TaskClosed: TBooleanField
      FieldName = 'Closed'
    end
    object tblMovementItem_TaskDescription: TStringField
      FieldName = 'Description'
      Size = 500
    end
    object tblMovementItem_TaskComment: TStringField
      FieldName = 'Comment'
      Size = 500
    end
    object tblMovementItem_TaskisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object qrySelect: TFDQuery
    Connection = conMain
    Left = 192
    Top = 264
  end
  object cdsJuridicalCollation: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'DocType;DocDate;DocNum'
    Params = <>
    Left = 60
    Top = 936
    object cdsJuridicalCollationDocId: TIntegerField
      FieldName = 'DocId'
    end
    object cdsJuridicalCollationDocNum: TStringField
      FieldName = 'DocNum'
      Size = 200
    end
    object cdsJuridicalCollationDocType: TStringField
      FieldName = 'DocType'
      Size = 200
    end
    object cdsJuridicalCollationDocDate: TDateField
      FieldName = 'DocDate'
    end
    object cdsJuridicalCollationPaidKind: TStringField
      FieldName = 'PaidKind'
      Size = 100
    end
    object cdsJuridicalCollationFromName: TStringField
      FieldName = 'FromName'
      Size = 255
    end
    object cdsJuridicalCollationToName: TStringField
      FieldName = 'ToName'
      Size = 255
    end
    object cdsJuridicalCollationDebet: TStringField
      FieldName = 'Debet'
    end
    object cdsJuridicalCollationKredit: TStringField
      FieldName = 'Kredit'
    end
    object cdsJuridicalCollationDocNumDate: TStringField
      FieldName = 'DocNumDate'
      Size = 200
    end
    object cdsJuridicalCollationDocTypeShow: TStringField
      DisplayWidth = 300
      FieldName = 'DocTypeShow'
      Size = 300
    end
    object cdsJuridicalCollationFromToName: TStringField
      FieldName = 'FromToName'
      Size = 300
    end
    object cdsJuridicalCollationPaidKindShow: TStringField
      FieldName = 'PaidKindShow'
      Size = 255
    end
  end
  object cdsTasks: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 192
    Top = 936
    object cdsTasksId: TIntegerField
      FieldName = 'Id'
    end
    object cdsTasksInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object cdsTasksOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object cdsTasksPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object cdsTasksClosed: TBooleanField
      FieldName = 'Closed'
    end
    object cdsTasksDescription: TStringField
      FieldName = 'Description'
      Size = 1000
    end
    object cdsTasksComment: TStringField
      FieldName = 'Comment'
      Size = 1000
    end
    object cdsTasksPartnerName: TStringField
      FieldName = 'PartnerName'
      Size = 300
    end
    object cdsTasksTaskDate: TStringField
      FieldName = 'TaskDate'
      Size = 200
    end
    object cdsTasksTaskDescription: TStringField
      FieldName = 'TaskDescription'
      Size = 1100
    end
  end
  object qryPhotoGroupDocs: TFDQuery
    OnCalcFields = qryPhotoGroupDocsCalcFields
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 204
    Top = 684
    object qryPhotoGroupDocsId: TIntegerField
      FieldName = 'Id'
    end
    object qryPhotoGroupDocsComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object qryPhotoGroupDocsStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object qryPhotoGroupDocsName: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name'
      Size = 255
      Calculated = True
    end
    object qryPhotoGroupDocsOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object qryPhotoGroupDocsIsSync: TBooleanField
      FieldName = 'IsSync'
    end
    object qryPhotoGroupDocsPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object qryPhotoGroupDocsPartnerName: TStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object qryPhotoGroupDocsAddress: TStringField
      FieldName = 'Address'
      Size = 255
    end
    object qryPhotoGroupDocsGroupName: TStringField
      FieldKind = fkCalculated
      FieldName = 'GroupName'
      Size = 600
      Calculated = True
    end
  end
  object tblObject_TradeMark: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Object_TradeMark'
    TableName = 'Object_TradeMark'
    Left = 792
    Top = 588
    object tblObject_TradeMarkId: TIntegerField
      FieldName = 'Id'
    end
    object tblObject_TradeMarkObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object tblObject_TradeMarkValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_TradeMarkisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object tblMovement_Cash: TFDTable
    Connection = conMain
    UpdateOptions.UpdateTableName = 'Movement_Cash'
    TableName = 'Movement_Cash'
    Left = 1440
    Top = 576
    object tblMovement_CashId: TAutoIncField
      FieldName = 'Id'
      ProviderFlags = [pfInWhere]
      ReadOnly = True
    end
    object tblMovement_CashGUID: TStringField
      FieldName = 'GUID'
      Size = 255
    end
    object tblMovement_CashInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object tblMovement_CashInvNumberSale: TStringField
      FieldName = 'InvNumberSale'
      Size = 255
    end
    object tblMovement_CashOperDate: TDateField
      FieldName = 'OperDate'
    end
    object tblMovement_CashStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object tblMovement_CashInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object tblMovement_CashAmount: TFloatField
      FieldName = 'Amount'
    end
    object tblMovement_CashPaidKindId: TIntegerField
      FieldName = 'PaidKindId'
    end
    object tblMovement_CashPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object tblMovement_CashCashId: TIntegerField
      FieldName = 'CashId'
    end
    object tblMovement_CashMemberId: TIntegerField
      FieldName = 'MemberId'
    end
    object tblMovement_CashContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object tblMovement_CashComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tblMovement_CashisSync: TBooleanField
      FieldName = 'isSync'
    end
  end
  object qryCash: TFDQuery
    OnCalcFields = qryCashCalcFields
    Connection = conMain
    Left = 60
    Top = 600
    object qryCashId: TIntegerField
      FieldName = 'Id'
    end
    object qryCashInvNumberSale: TStringField
      FieldName = 'InvNumberSale'
      Size = 255
    end
    object qryCashAmount: TFloatField
      FieldName = 'Amount'
    end
    object qryCashComment: TStringField
      FieldName = 'Comment'
      Size = 255
    end
    object qryCashStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object qryCashOperDate: TDateField
      FieldName = 'OperDate'
    end
    object qryCashisSync: TBooleanField
      FieldName = 'isSync'
    end
    object qryCashName: TStringField
      FieldKind = fkCalculated
      FieldName = 'Name'
      Size = 300
      Calculated = True
    end
    object qryCashAmountShow: TStringField
      FieldKind = fkCalculated
      FieldName = 'AmountShow'
      Size = 200
      Calculated = True
    end
    object qryCashStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'Status'
      Size = 255
      Calculated = True
    end
    object qryCashPartnerId: TIntegerField
      FieldName = 'PartnerId'
    end
    object qryCashPartnerName: TWideStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object qryCashAddress: TWideStringField
      FieldName = 'Address'
      Size = 255
    end
    object qryCashContractId: TIntegerField
      FieldName = 'ContractId'
    end
    object qryCashContractName: TWideStringField
      FieldName = 'ContractName'
      Size = 400
    end
    object qryCashPAIDKINDID: TIntegerField
      FieldName = 'PAIDKINDID'
    end
  end
  object qryGoodsFullForPriceList: TFDQuery
    OnCalcFields = qryGoodsFullForPriceListCalcFields
    Connection = conMain
    Left = 384
    Top = 768
    object qryGoodsFullForPriceListId: TIntegerField
      FieldName = 'Id'
    end
    object qryGoodsFullForPriceListObjectCode: TIntegerField
      FieldName = 'ObjectCode'
    end
    object qryGoodsFullForPriceListGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object qryGoodsFullForPriceListKindName: TStringField
      FieldName = 'KindName'
      Size = 255
    end
    object qryGoodsFullForPriceListTradeMarkName: TStringField
      FieldName = 'TradeMarkName'
      Size = 255
    end
    object qryGoodsFullForPriceListMeasure: TStringField
      FieldName = 'Measure'
      Size = 100
    end
    object qryGoodsFullForPriceListOrderPrice: TFloatField
      FieldName = 'OrderPrice'
    end
    object qryGoodsFullForPriceListOrderStartDate: TDateTimeField
      FieldName = 'OrderStartDate'
    end
    object qryGoodsFullForPriceListOrderEndDate: TDateTimeField
      FieldName = 'OrderEndDate'
    end
    object qryGoodsFullForPriceListSalePrice: TFloatField
      FieldName = 'SalePrice'
    end
    object qryGoodsFullForPriceListSaleStartDate: TDateTimeField
      FieldName = 'SaleStartDate'
    end
    object qryGoodsFullForPriceListSaleEndDate: TDateTimeField
      FieldName = 'SaleEndDate'
    end
    object qryGoodsFullForPriceListReturnPrice: TFloatField
      FieldName = 'ReturnPrice'
    end
    object qryGoodsFullForPriceListReturnStartDate: TDateTimeField
      FieldName = 'ReturnStartDate'
    end
    object qryGoodsFullForPriceListReturnEndDate: TDateTimeField
      FieldName = 'ReturnEndDate'
    end
    object qryGoodsFullForPriceListOrderFullPrice: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrderFullPrice'
      Size = 200
      Calculated = True
    end
    object qryGoodsFullForPriceListOrderTermin: TStringField
      FieldKind = fkCalculated
      FieldName = 'OrderTermin'
      Size = 255
      Calculated = True
    end
    object qryGoodsFullForPriceListSaleFullPrice: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleFullPrice'
      Size = 200
      Calculated = True
    end
    object qryGoodsFullForPriceListSaleTermin: TStringField
      FieldKind = fkCalculated
      FieldName = 'SaleTermin'
      Size = 255
      Calculated = True
    end
    object qryGoodsFullForPriceListReturnFullPrice: TStringField
      FieldKind = fkCalculated
      FieldName = 'ReturnFullPrice'
      Size = 200
      Calculated = True
    end
    object qryGoodsFullForPriceListReturnTermin: TStringField
      FieldKind = fkCalculated
      FieldName = 'ReturnTermin'
      Size = 255
      Calculated = True
    end
    object qryGoodsFullForPriceListFullGoodsName: TStringField
      FieldKind = fkCalculated
      FieldName = 'FullGoodsName'
      Size = 600
      Calculated = True
    end
  end
  object qJuridicalCollationItems: TFDQuery
    Connection = conMain
    Left = 372
    Top = 852
    object qJuridicalCollationItemsValue: TStringField
      FieldName = 'Value'
      Size = 300
    end
    object qJuridicalCollationItemsId: TIntegerField
      FieldName = 'Id'
    end
    object qJuridicalCollationItemsDopValue: TWideStringField
      FieldName = 'DopValue'
      Size = 500
    end
  end
  object cdsJuridicalCollationDocItems: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 372
    Top = 930
    object cdsJuridicalCollationDocItemsDocId: TIntegerField
      FieldName = 'DocId'
    end
    object cdsJuridicalCollationDocItemsDocItemId: TIntegerField
      FieldName = 'DocItemId'
    end
    object cdsJuridicalCollationDocItemsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsJuridicalCollationDocItemsGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsJuridicalCollationDocItemsGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsJuridicalCollationDocItemsGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object cdsJuridicalCollationDocItemsGoodsKindName: TStringField
      FieldName = 'GoodsKindName'
      Size = 255
    end
    object cdsJuridicalCollationDocItemsPrice: TFloatField
      FieldName = 'Price'
    end
    object cdsJuridicalCollationDocItemsAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsJuridicalCollationDocItemsisPromo: TBooleanField
      FieldName = 'isPromo'
    end
    object cdsJuridicalCollationDocItemsGoodsFullName: TStringField
      FieldName = 'GoodsFullName'
      Size = 510
    end
    object cdsJuridicalCollationDocItemsPromoText: TStringField
      FieldName = 'PromoText'
      Size = 32
    end
    object cdsJuridicalCollationDocItemsPriceText: TStringField
      FieldName = 'PriceText'
    end
    object cdsJuridicalCollationDocItemsAmountText: TStringField
      FieldName = 'AmountText'
    end
  end
  object tblObject_SubjectDoc: TFDTable
    Connection = conMain
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'Object_SubjectDoc'
    Left = 624
    Top = 588
    object IntegerField4: TIntegerField
      FieldName = 'Id'
    end
    object IntegerField5: TIntegerField
      FieldName = 'ObjectCode'
    end
    object StringField1: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object tblObject_SubjectDocBaseName: TStringField
      FieldName = 'BaseName'
      Size = 255
    end
    object tblObject_SubjectDocCauseName: TStringField
      FieldName = 'CauseName'
      Size = 255
    end
    object BooleanField1: TBooleanField
      FieldName = 'isErased'
    end
  end
  object qrySubjectDoc: TFDQuery
    Connection = conMain
    SQL.Strings = (
      'select ID '
      '     , VALUEDATA  '
      '     , BaseName  '
      '     , CauseName  '
      'from OBJECT_SUBJECTDOC os'
      'where os.ISERASED = 0'
      'order by VALUEDATA')
    Left = 200
    Top = 604
    object qrySubjectDocId: TIntegerField
      FieldName = 'Id'
    end
    object qrySubjectDocValueData: TStringField
      FieldName = 'ValueData'
      Size = 255
    end
    object qrySubjectDocBaseName: TStringField
      FieldName = 'BaseName'
      Size = 255
    end
    object qrySubjectDocCauseName: TStringField
      FieldName = 'CauseName'
      Size = 255
    end
  end
end
