object DM: TDM
  OnCreate = DataModuleCreate
  Height = 664
  Width = 1002
  PixelsPerInch = 144
  object cdsInventory: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 312
    object cdsInventoryId: TIntegerField
      FieldName = 'Id'
    end
    object cdsInventoryInvNumber: TWideStringField
      FieldName = 'InvNumber'
    end
    object cdsInventoryOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object cdsInventoryStatusName: TWideStringField
      FieldName = 'StatusName'
    end
    object cdsInventoryStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object cdsInventoryTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object cdsInventoryUnitId: TIntegerField
      FieldName = 'UnitId'
    end
    object cdsInventoryUnitName: TWideStringField
      FieldName = 'UnitName'
      Size = 255
    end
    object cdsInventoryComment: TWideStringField
      FieldName = 'Comment'
      Size = 255
    end
    object cdsInventoryisList: TBooleanField
      FieldName = 'isList'
    end
  end
  object cdsInventoryList: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = cdsInventoryListAfterScroll
    OnCalcFields = cdsInventoryListCalcFields
    Left = 272
    Top = 320
    object cdsInventoryListId: TIntegerField
      FieldName = 'Id'
    end
    object cdsInventoryListGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsInventoryListGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsInventoryListGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsInventoryListArticle: TWideStringField
      FieldName = 'Article'
      Size = 40
    end
    object cdsInventoryListEAN: TWideStringField
      FieldName = 'EAN'
    end
    object cdsInventoryListGoodsGroupId: TIntegerField
      FieldName = 'GoodsGroupId'
    end
    object cdsInventoryListGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsInventoryListMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object cdsInventoryListPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 255
    end
    object cdsInventoryListPartionCellId: TIntegerField
      FieldName = 'PartionCellId'
    end
    object cdsInventoryListPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsInventoryListAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryListTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object cdsInventoryListAmountDiff: TFloatField
      FieldName = 'AmountDiff'
    end
    object cdsInventoryListAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsInventoryListAmountRemains_curr: TFloatField
      FieldName = 'AmountRemains_curr'
    end
    object cdsInventoryListOrdUser: TIntegerField
      FieldName = 'OrdUser'
    end
    object cdsInventoryListOperDate_protocol: TDateTimeField
      FieldName = 'OperDate_protocol'
    end
    object cdsInventoryListUserName_protocol: TWideStringField
      FieldName = 'UserName_protocol'
      Size = 255
    end
    object cdsInventoryListisErased: TBooleanField
      FieldName = 'isErased'
    end
    object cdsInventoryListAmountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountLabel'
      Calculated = True
    end
    object cdsInventoryListAmountRemainsLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountRemainsLabel'
      Calculated = True
    end
    object cdsInventoryListTotalCountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'TotalCountLabel'
      Calculated = True
    end
    object cdsInventoryListAmountDiffLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountDiffLabel'
      Calculated = True
    end
    object cdsInventoryListOrdUserLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'OrdUserLabel'
      Calculated = True
    end
    object cdsInventoryListErasedId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ErasedId'
      Calculated = True
    end
  end
  object conMain: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'LockingMode=Exclusive')
    LoginPrompt = False
    Left = 124
    Top = 32
  end
  object fdGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 288
    Top = 32
  end
  object fdDriverLink: TFDPhysSQLiteDriverLink
    Left = 680
    Top = 32
  end
  object fdfAnsiUpperCase: TFDSQLiteFunction
    DriverLink = fdDriverLink
    FunctionName = 'AnsiUpperCase'
    ArgumentsCount = 1
    OnCalculate = fdfAnsiUpperCaseCalculate
    Left = 856
    Top = 32
  end
  object tblInventoryGoods: TFDTable
    Connection = conMain
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'InventoryGoods'
    Left = 628
    Top = 172
    object tblInventoryGoodsLocalId: TAutoIncField
      FieldName = 'LocalId'
    end
    object tblInventoryGoodsId: TIntegerField
      FieldName = 'Id'
    end
    object tblInventoryGoodsMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblInventoryGoodsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblInventoryGoodsPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 50
    end
    object tblInventoryGoodsAmount: TFloatField
      FieldName = 'Amount'
    end
    object tblInventoryGoodsAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object tblInventoryGoodsTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object tblInventoryGoodsPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object tblInventoryGoodsError: TWideStringField
      FieldName = 'Error'
      Size = 500
    end
    object tblInventoryGoodsisSend: TBooleanField
      FieldName = 'isSend'
    end
  end
  object qryMeta: TFDMetaInfoQuery
    Connection = conMain
    MetaInfoKind = mkCatalogs
    Left = 420
    Top = 32
  end
  object qryMeta2: TFDMetaInfoQuery
    Connection = conMain
    MetaInfoKind = mkCatalogs
    Left = 522
    Top = 35
  end
  object fdcUTF16NoCase: TFDSQLiteCollation
    DriverLink = fdDriverLink
    CollationName = 'UTF16NoCase'
    Flags = [sfIgnoreCase]
    Left = 1056
    Top = 32
  end
  object cdsOrderInternal: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1048
    Top = 304
    object cdsOrderInternalMovementItemId: TIntegerField
      FieldName = 'MovementItemId'
    end
    object cdsOrderInternalInvNumber_Full: TWideStringField
      FieldName = 'InvNumber_Full'
      Size = 255
    end
    object cdsOrderInternalInvNumberFull_OrderClient: TWideStringField
      FieldName = 'InvNumberFull_OrderClient'
      Size = 255
    end
    object cdsOrderInternalGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsOrderInternalAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsOrderInternalMovementPUId: TIntegerField
      FieldName = 'MovementPUId'
    end
    object cdsOrderInternalInvNumberFull_ProductionUnion: TWideStringField
      FieldName = 'InvNumberFull_ProductionUnion'
      Size = 255
    end
  end
  object tbGoods: TFDTable
    Connection = conMain
    TableName = 'Goods'
    Left = 116
    Top = 166
    object tbGoodsId: TIntegerField
      FieldName = 'Id'
    end
    object tbGoodsCode: TIntegerField
      FieldName = 'Code'
    end
    object tbGoodsName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
    object tbGoodsArticle: TWideStringField
      FieldName = 'Article'
      Size = 100
    end
    object tbGoodsArticleFilter: TWideStringField
      FieldName = 'ArticleFilter'
      Size = 100
    end
    object tbGoodsEAN: TWideStringField
      FieldName = 'EAN'
    end
    object tbGoodsGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object tbGoodsMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object tbGoodsUnitId: TIntegerField
      FieldName = 'UnitId'
    end
    object tbGoodsUnitID_receipt: TIntegerField
      FieldName = 'UnitID_receipt'
    end
    object tbGoodsUnitId_child_receipt: TIntegerField
      FieldName = 'UnitId_child_receipt'
    end
    object tbGoodsUnitId_parent_receipt: TIntegerField
      FieldName = 'UnitId_parent_receipt'
    end
    object tbGoodsisErased: TBooleanField
      FieldName = 'isErased'
    end
    object tbGoodsNameUpper: TWideStringField
      FieldName = 'NameUpper'
      Size = 255
    end
    object tbGoodsArticleUpper: TWideStringField
      FieldName = 'ArticleUpper'
      Size = 100
    end
    object tbGoodsisLoad: TBooleanField
      FieldName = 'isLoad'
    end
  end
  object tbPartionCell: TFDTable
    Connection = conMain
    TableName = 'PartionCell'
    Left = 244
    Top = 166
    object tbPartionCellId: TIntegerField
      FieldName = 'Id'
    end
    object tbPartionCellCode: TIntegerField
      FieldName = 'Code'
    end
    object tbPartionCellName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
    object tbPartionCellLevel: TFloatField
      FieldName = 'Level'
    end
    object tbPartionCellComment: TWideStringField
      FieldName = 'Comment'
      Size = 255
    end
    object tbPartionCellisLoad: TBooleanField
      FieldName = 'isLoad'
    end
  end
  object cdsInventoryItemEdit: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterEdit = cdsInventoryItemEditAfterEdit
    OnCalcFields = cdsInventoryItemEditCalcFields
    Left = 472
    Top = 312
    object cdsInventoryItemEditLocalId: TIntegerField
      FieldName = 'LocalId'
    end
    object cdsInventoryItemEditId: TIntegerField
      FieldName = 'Id'
    end
    object cdsInventoryItemEditGoodsId: TIntegerField
      FieldName = 'GoodsId'
      OnChange = cdsInventoryItemEditGoodsIdChange
    end
    object cdsInventoryItemEditGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsInventoryItemEditGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsInventoryItemEditArticle: TWideStringField
      FieldName = 'Article'
      Size = 100
    end
    object cdsInventoryItemEditPartNumber: TWideStringField
      FieldName = 'PartNumber'
      OnChange = cdsInventoryItemEditPartNumberChange
      Size = 255
    end
    object cdsInventoryItemEditGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsInventoryItemEditPartnerName: TWideStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object cdsInventoryItemEditPartionCellId: TIntegerField
      FieldName = 'PartionCellId'
    end
    object cdsInventoryItemEditPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsInventoryItemEditAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryItemEditTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object cdsInventoryItemEditAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsInventoryItemEditAmountDiff: TFloatField
      FieldKind = fkCalculated
      FieldName = 'AmountDiff'
      Calculated = True
    end
    object cdsInventoryItemEditTotalCountCalc: TFloatField
      FieldKind = fkCalculated
      FieldName = 'TotalCountCalc'
      Calculated = True
    end
  end
  object tbRemains: TFDTable
    Connection = conMain
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'Remains'
    Left = 468
    Top = 172
    object tbRemainsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tbRemainsRemains: TFloatField
      FieldName = 'Remains'
    end
    object tbRemainsRemains_curr: TFloatField
      FieldName = 'Remains_curr'
    end
    object tbRemainsisLoad: TBooleanField
      FieldName = 'isLoad'
    end
  end
  object qurGoodsList: TFDQuery
    AfterScroll = cdsDictListAfterScroll
    OnCalcFields = qurGoodsListCalcFields
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 108
    Top = 524
    object qurGoodsListId: TIntegerField
      FieldName = 'Id'
    end
    object qurGoodsListCode: TIntegerField
      FieldName = 'Code'
    end
    object qurGoodsListName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
    object qurGoodsListArticle: TWideStringField
      FieldName = 'Article'
      Size = 255
    end
    object qurGoodsListEAN: TWideStringField
      FieldName = 'EAN'
    end
    object qurGoodsListGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object qurGoodsListMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object qurGoodsListRemains: TFloatField
      FieldName = 'Remains'
      OnGetText = qurGoodsListRemainsGetText
    end
    object qurGoodsListRemains_curr: TFloatField
      FieldName = 'Remains_curr'
      OnGetText = qurGoodsListRemains_currGetText
    end
    object qurGoodsListRemainsLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'RemainsLabel'
      Size = 40
      Calculated = True
    end
    object qurGoodsListRemains_currLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'Remains_currLabel'
      Size = 40
      Calculated = True
    end
  end
  object qurDictList: TFDQuery
    AfterScroll = cdsDictListAfterScroll
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 268
    Top = 524
    object qurDictListId: TIntegerField
      FieldName = 'Id'
    end
    object qurDictListCode: TIntegerField
      FieldName = 'Code'
    end
    object qurDictListName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
  end
  object qurGoodsEAN: TFDQuery
    AfterScroll = cdsDictListAfterScroll
    Connection = conMain
    SQL.Strings = (
      '')
    Left = 420
    Top = 524
    object qurGoodsEANId: TIntegerField
      FieldName = 'Id'
    end
    object qurGoodsEANCode: TIntegerField
      FieldName = 'Code'
    end
    object qurGoodsEANEAN: TWideStringField
      FieldName = 'EAN'
    end
  end
  object cdsInventoryListTop: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsInventoryListTopCalcFields
    Left = 680
    Top = 312
    object cdsInventoryListTopId: TIntegerField
      FieldName = 'Id'
    end
    object cdsInventoryListTopLocalId: TIntegerField
      FieldName = 'LocalId'
    end
    object cdsInventoryListTopGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsInventoryListTopGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsInventoryListTopGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsInventoryListTopArticle: TWideStringField
      FieldName = 'Article'
      Size = 40
    end
    object cdsInventoryListTopEAN: TWideStringField
      FieldName = 'EAN'
    end
    object cdsInventoryListTopGoodsGroupId: TIntegerField
      FieldName = 'GoodsGroupId'
    end
    object cdsInventoryListTopGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsInventoryListTopMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object cdsInventoryListTopPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 255
    end
    object cdsInventoryListTopPartionCellId: TIntegerField
      FieldName = 'PartionCellId'
    end
    object cdsInventoryListTopPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsInventoryListTopAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryListTopTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object cdsInventoryListTopAmountDiff: TFloatField
      FieldName = 'AmountDiff'
    end
    object cdsInventoryListTopAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsInventoryListTopAmountRemains_curr: TFloatField
      FieldName = 'AmountRemains_curr'
    end
    object cdsInventoryListTopOrdUser: TIntegerField
      FieldName = 'OrdUser'
    end
    object cdsInventoryListTopOperDate_protocol: TDateTimeField
      FieldName = 'OperDate_protocol'
    end
    object cdsInventoryListTopUserName_protocol: TWideStringField
      FieldName = 'UserName_protocol'
      Size = 255
    end
    object cdsInventoryListTopisErased: TBooleanField
      FieldName = 'isErased'
    end
    object cdsInventoryListTopAmountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountLabel'
      Calculated = True
    end
    object cdsInventoryListTopAmountRemainsLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountRemainsLabel'
      Calculated = True
    end
    object cdsInventoryListTopTotalCountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'TotalCountLabel'
      Calculated = True
    end
    object cdsInventoryListTopAmountDiffLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountDiffLabel'
      Calculated = True
    end
    object cdsInventoryListTopErasedId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ErasedId'
      Calculated = True
    end
    object cdsInventoryListTopError: TWideStringField
      FieldName = 'Error'
    end
    object cdsInventoryListTopOrdUserLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'OrdUserLabel'
      Calculated = True
    end
  end
  object cdsSendItemEdit: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterEdit = cdsSendItemEditAfterEdit
    OnCalcFields = cdsSendItemEditCalcFields
    Left = 472
    Top = 416
    object cdsSendItemEditLocalId: TIntegerField
      FieldName = 'LocalId'
    end
    object cdsSendItemEditId: TIntegerField
      FieldName = 'Id'
    end
    object cdsSendItemEditGoodsId: TIntegerField
      FieldName = 'GoodsId'
      OnChange = cdsInventoryItemEditGoodsIdChange
    end
    object cdsSendItemEditGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsSendItemEditGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsSendItemEditArticle: TWideStringField
      FieldName = 'Article'
      Size = 100
    end
    object cdsSendItemEditPartNumber: TWideStringField
      FieldName = 'PartNumber'
      OnChange = cdsInventoryItemEditPartNumberChange
      Size = 255
    end
    object cdsSendItemEditGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsSendItemEditPartnerName: TWideStringField
      FieldName = 'PartnerName'
      Size = 255
    end
    object cdsSendItemEditPartionCellId: TIntegerField
      FieldName = 'PartionCellId'
    end
    object cdsSendItemEditPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsSendItemEditAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsSendItemEditTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object cdsSendItemEditAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsSendItemEditTotalCountCalc: TFloatField
      FieldKind = fkCalculated
      FieldName = 'TotalCountCalc'
      Calculated = True
    end
    object cdsSendItemEditFromId: TIntegerField
      FieldName = 'FromId'
    end
    object cdsSendItemEditFromCode: TIntegerField
      FieldName = 'FromCode'
    end
    object cdsSendItemEditFromName: TWideStringField
      FieldName = 'FromName'
      Size = 255
    end
    object cdsSendItemEditToId: TIntegerField
      FieldName = 'ToId'
    end
    object cdsSendItemEditToCode: TIntegerField
      FieldName = 'ToCode'
    end
    object cdsSendItemEditToName: TWideStringField
      FieldName = 'ToName'
      Size = 255
    end
  end
  object tbUnit: TFDTable
    Connection = conMain
    TableName = 'Unit'
    Left = 372
    Top = 166
    object tbUnitId: TIntegerField
      FieldName = 'Id'
    end
    object tbUnitCode: TIntegerField
      FieldName = 'Code'
    end
    object tbUnitName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
    object tbUnitisErased: TBooleanField
      FieldName = 'isErased'
    end
    object tbUnitisLoad: TBooleanField
      FieldName = 'isLoad'
    end
  end
  object cdsSendList: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = cdsSendListAfterScroll
    OnCalcFields = cdsSendListCalcFields
    Left = 272
    Top = 416
    object cdsSendListId: TIntegerField
      FieldName = 'Id'
    end
    object cdsSendListGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsSendListGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsSendListGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsSendListArticle: TWideStringField
      FieldName = 'Article'
      Size = 40
    end
    object cdsSendListEAN: TWideStringField
      FieldName = 'EAN'
    end
    object cdsSendListGoodsGroupId: TIntegerField
      FieldName = 'GoodsGroupId'
    end
    object cdsSendListGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsSendListMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object cdsSendListPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 255
    end
    object cdsSendListPartionCellId: TIntegerField
      FieldName = 'PartionCellId'
    end
    object cdsSendListPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsSendListAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsSendListTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object cdsSendListAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsSendListOrdUser: TIntegerField
      FieldName = 'OrdUser'
    end
    object cdsSendListOperDate_protocol: TDateTimeField
      FieldName = 'OperDate_protocol'
    end
    object cdsSendListUserName_protocol: TWideStringField
      FieldName = 'UserName_protocol'
      Size = 255
    end
    object cdsSendListisErased: TBooleanField
      FieldName = 'isErased'
    end
    object cdsSendListAmountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountLabel'
      Calculated = True
    end
    object cdsSendListAmountRemainsLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountRemainsLabel'
      Calculated = True
    end
    object cdsSendListTotalCountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'TotalCountLabel'
      Calculated = True
    end
    object cdsSendListOrdUserLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'OrdUserLabel'
      Calculated = True
    end
    object cdsSendListErasedId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ErasedId'
      Calculated = True
    end
    object cdsSendListOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object cdsSendListInvNumber: TWideStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object cdsSendListFromId: TIntegerField
      FieldName = 'FromId'
    end
    object cdsSendListFromCode: TIntegerField
      FieldName = 'FromCode'
    end
    object cdsSendListFromName: TWideStringField
      FieldName = 'FromName'
      Size = 255
    end
    object cdsSendListToId: TIntegerField
      FieldName = 'ToId'
    end
    object cdsSendListToCode: TIntegerField
      FieldName = 'ToCode'
    end
    object cdsSendListToName: TWideStringField
      FieldName = 'ToName'
      Size = 255
    end
    object cdsSendListFromNameLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'FromNameLabel'
      Size = 40
      Calculated = True
    end
    object cdsSendListToNameLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'ToNameLabel'
      Size = 40
      Calculated = True
    end
  end
  object cdsSendListTop: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsSendListCalcFields
    Left = 680
    Top = 424
    object cdsSendListTopId: TIntegerField
      FieldName = 'Id'
    end
    object cdsSendListTopLocalId: TIntegerField
      FieldName = 'LocalId'
    end
    object cdsSendListTopGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsSendListTopGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsSendListTopGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsSendListTopArticle: TWideStringField
      FieldName = 'Article'
      Size = 40
    end
    object cdsSendListTopEAN: TWideStringField
      FieldName = 'EAN'
    end
    object cdsSendListTopGoodsGroupId: TIntegerField
      FieldName = 'GoodsGroupId'
    end
    object cdsSendListTopGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsSendListTopMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object cdsSendListTopPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 255
    end
    object cdsSendListTopPartionCellId: TIntegerField
      FieldName = 'PartionCellId'
    end
    object cdsSendListTopPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsSendListTopAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsSendListTopTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object cdsSendListTopAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsSendListTopOrdUser: TIntegerField
      FieldName = 'OrdUser'
    end
    object cdsSendListTopOperDate_protocol: TDateTimeField
      FieldName = 'OperDate_protocol'
    end
    object cdsSendListTopUserName_protocol: TWideStringField
      FieldName = 'UserName_protocol'
      Size = 255
    end
    object cdsSendListTopisErased: TBooleanField
      FieldName = 'isErased'
    end
    object cdsSendListTopAmountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountLabel'
      Calculated = True
    end
    object cdsSendListTopAmountRemainsLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountRemainsLabel'
      Calculated = True
    end
    object cdsSendListTopTotalCountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'TotalCountLabel'
      Calculated = True
    end
    object cdsSendListTopOrdUserLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'OrdUserLabel'
      Calculated = True
    end
    object cdsSendListTopErasedId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ErasedId'
      Calculated = True
    end
    object cdsSendListTopError: TWideStringField
      FieldName = 'Error'
    end
    object cdsSendListTopOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object cdsSendListTopInvNumber: TWideStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object cdsSendListTopFromId: TIntegerField
      FieldName = 'FromId'
    end
    object cdsSendListTopFromCode: TIntegerField
      FieldName = 'FromCode'
    end
    object cdsSendListTopFromName: TWideStringField
      FieldName = 'FromName'
      Size = 255
    end
    object cdsSendListTopToId: TIntegerField
      FieldName = 'ToId'
    end
    object cdsSendListTopToCode: TIntegerField
      FieldName = 'ToCode'
    end
    object cdsSendListTopToName: TWideStringField
      FieldName = 'ToName'
      Size = 255
    end
    object cdsSendListTopFromNameLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'FromNameLabel'
      Size = 40
      Calculated = True
    end
    object cdsSendListTopToNameLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'ToNameLabel'
      Size = 40
      Calculated = True
    end
  end
  object tbSendGoods: TFDTable
    Connection = conMain
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'SendGoods'
    Left = 804
    Top = 172
    object tbSendGoodsLocalId: TAutoIncField
      FieldName = 'LocalId'
    end
    object tbSendGoodsDateScan: TIntegerField
      FieldName = 'DateScan'
    end
    object tbSendGoodsId: TIntegerField
      FieldName = 'Id'
    end
    object tbSendGoodsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tbSendGoodsPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 50
    end
    object tbSendGoodsAmount: TFloatField
      FieldName = 'Amount'
    end
    object tbSendGoodsAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object tbSendGoodsTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object tbSendGoodsPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object tbSendGoodsFromId: TIntegerField
      FieldName = 'FromId'
    end
    object tbSendGoodsToId: TIntegerField
      FieldName = 'ToId'
    end
    object tbSendGoodsError: TWideStringField
      FieldName = 'Error'
      Size = 500
    end
    object tbSendGoodsisSend: TBooleanField
      FieldName = 'isSend'
    end
  end
end
