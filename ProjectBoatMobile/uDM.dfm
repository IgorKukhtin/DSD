object DM: TDM
  OnCreate = DataModuleCreate
  Height = 643
  Width = 1202
  PixelsPerInch = 144
  object cdsInventory: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 304
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
    OnCalcFields = cdsInventoryListCalcFields
    Left = 288
    Top = 312
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
    object cdsInventoryListAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsInventoryListAmountRemains_curr: TFloatField
      FieldName = 'AmountRemains_curr'
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
    object cdsInventoryListErasedId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'ErasedId'
      Calculated = True
    end
  end
  object cdsGoodsEAN: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 416
    object cdsGoodsEANId: TIntegerField
      FieldName = 'Id'
    end
    object cdsGoodsEANCode: TIntegerField
      FieldName = 'Code'
    end
    object cdsGoodsEANEAN: TWideStringField
      FieldName = 'EAN'
    end
  end
  object cdsGoodsList: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 416
    object cdsGoodsListId: TIntegerField
      FieldName = 'Id'
    end
    object cdsGoodsListCode: TIntegerField
      FieldName = 'Code'
    end
    object cdsGoodsListName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
    object cdsGoodsListArticle: TWideStringField
      FieldName = 'Article'
    end
    object cdsGoodsListEAN: TWideStringField
      FieldName = 'EAN'
    end
    object cdsGoodsListGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsGoodsListMeasureName: TWideStringField
      FieldName = 'MeasureName'
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
    Left = 516
    Top = 164
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
  object qryInventoryGoods: TFDQuery
    OnCalcFields = qryInventoryGoodsCalcFields
    Connection = conMain
    SQL.Strings = (
      'SELECT IG.LocalId'
      '     , IG.Id'
      '     , IG.MovementId'
      '     , IG.GoodsId'
      '     , G.Code          AS GoodsCode'
      '     , G.Name          AS GoodsName'
      '     , G.Article'
      '     , G.EAN'
      '     , G.GoodsGroupName'
      '     , G.MeasureName'
      '     , IG.PartNumber'
      '     , IG.PartionCellName'
      '     , IG.Amount'
      '     , IG.AmountRemains'
      '     , IG.TotalCount'
      '     , IG.Error'
      ''
      'FROM InventoryGoods AS IG'
      ''
      '     LEFT JOIN Goods G ON G.Id = IG.GoodsId'
      ''
      'WHERE IG.MovementId = :MovementId'
      'ORDER BY IG.LocalId DESC')
    Left = 124
    Top = 533
    ParamData = <
      item
        Name = 'MOVEMENTID'
        ParamType = ptInput
      end>
    object qryInventoryGoodsLocalId: TAutoIncField
      FieldName = 'LocalId'
    end
    object qryInventoryGoodsId: TIntegerField
      FieldName = 'Id'
    end
    object qryInventoryGoodsMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object qryInventoryGoodsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object qryInventoryGoodsGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object qryInventoryGoodsGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object qryInventoryGoodsArticle: TWideStringField
      FieldName = 'Article'
      Size = 40
    end
    object qryInventoryGoodsEAN: TWideStringField
      FieldName = 'EAN'
      Size = 40
    end
    object qryInventoryGoodsGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object qryInventoryGoodsMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object qryInventoryGoodsPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 255
    end
    object qryInventoryGoodsPartionCellName: TWideStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object qryInventoryGoodsAmount: TFloatField
      FieldName = 'Amount'
    end
    object qryInventoryGoodsAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object qryInventoryGoodsTotalCount: TFloatField
      FieldName = 'TotalCount'
    end
    object qryInventoryGoodsError: TWideStringField
      FieldName = 'Error'
      Size = 500
    end
    object qryInventoryGoodsAmountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountLabel'
      Calculated = True
    end
    object qryInventoryGoodsAmountRemainsLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'AmountRemainsLabel'
      Calculated = True
    end
    object qryInventoryGoodsTotalCountLabel: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'TotalCountLabel'
      Calculated = True
    end
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
    Left = 276
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
    Left = 464
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
  object cdsDictList: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 464
    Top = 416
    object cdsDictListId: TIntegerField
      FieldName = 'Id'
    end
    object cdsDictListCode: TIntegerField
      FieldName = 'Code'
    end
    object cdsDictListName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
  end
end
