object DM: TDM
  OnCreate = DataModuleCreate
  Height = 643
  Width = 1202
  PixelsPerInch = 144
  object cdsInventoryJournal: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 304
    object cdsInventoryJournalId: TIntegerField
      FieldName = 'Id'
    end
    object cdsInventoryJournalOperDate: TWideStringField
      FieldName = 'OperDate'
    end
    object cdsInventoryJournalInvNumber: TWideStringField
      FieldName = 'InvNumber'
    end
    object cdsInventoryJournalStatusName: TWideStringField
      FieldName = 'StatusName'
    end
    object cdsInventoryJournalStatusId: TIntegerField
      FieldName = 'StatusId'
    end
    object cdsInventoryJournalTotalCount: TWideStringField
      FieldName = 'TotalCount'
      Size = 25
    end
    object cdsInventoryJournalUnitName: TWideStringField
      FieldName = 'UnitName'
      Size = 255
    end
    object cdsInventoryJournalComment: TWideStringField
      FieldName = 'Comment'
      Size = 255
    end
    object cdsInventoryJournalisList: TBooleanField
      FieldName = 'isList'
    end
    object cdsInventoryJournalEditButton: TIntegerField
      FieldName = 'EditButton'
    end
  end
  object cdsInventory: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
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
    Left = 496
    Top = 304
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
    object cdsInventoryListAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryListAmountRemains: TFloatField
      FieldName = 'AmountRemains'
    end
    object cdsInventoryListAmountDiff: TFloatField
      FieldName = 'AmountDiff'
    end
    object cdsInventoryListAmountRemains_curr: TFloatField
      FieldName = 'AmountRemains_curr'
    end
    object cdsInventoryListPrice: TFloatField
      FieldName = 'Price'
    end
    object cdsInventoryListSumma: TFloatField
      FieldName = 'Summa'
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
    TableName = 'InventoryGoods'
    Left = 516
    Top = 164
    object tblInventoryGoodsMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object tblInventoryGoodsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object tblInventoryGoodsPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 30
    end
    object tblInventoryGoodsAmount: TFloatField
      FieldName = 'Amount'
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
      'SELECT IG.MovementId'
      '     , IG.GoodsId'
      '     , G.Code          AS GoodsCode'
      '     , G.Name          AS GoodsName'
      '     , G.Article'
      '     , G.EAN'
      '     , G.GoodsGroupName'
      '     , G.MeasureName'
      '     , IG.PartNumber'
      '     , IG.Amount'
      ''
      'FROM InventoryGoods AS IG'
      ''
      '     LEFT JOIN Goods G ON G.Id = IG.GoodsId'
      ''
      'WHERE IG.MovementId = :MovementId')
    Left = 108
    Top = 549
    ParamData = <
      item
        Name = 'MOVEMENTID'
        ParamType = ptInput
      end>
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
    object qryInventoryGoodsAmount: TFloatField
      FieldName = 'Amount'
    end
    object qryInventoryGoodsDeleteId: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'DeleteId'
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
    Left = 712
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
end
