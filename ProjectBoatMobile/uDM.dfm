object DM: TDM
  OnCreate = DataModuleCreate
  Height = 643
  Width = 1018
  PixelsPerInch = 144
  object cdsInventoryJournal: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 128
    Top = 144
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
    Top = 152
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
    Left = 480
    Top = 160
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
  object cdsInventoryGoods: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 656
    Top = 160
    object cdsInventoryGoodsMovementId: TIntegerField
      FieldName = 'MovementId'
    end
    object cdsInventoryGoodsGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsInventoryGoodsGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsInventoryGoodsGoodsName: TWideStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsInventoryGoodsArticle: TWideStringField
      FieldName = 'Article'
      Size = 40
    end
    object cdsInventoryGoodsEAN: TWideStringField
      FieldName = 'EAN'
      Size = 40
    end
    object cdsInventoryGoodsGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsInventoryGoodsMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object cdsInventoryGoodsPartNumber: TWideStringField
      FieldName = 'PartNumber'
      Size = 255
    end
    object cdsInventoryGoodsAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryGoodsisSend: TBooleanField
      FieldName = 'isSend'
    end
    object cdsInventoryGoodsDeleteId: TIntegerField
      FieldName = 'DeleteId'
    end
  end
  object cdsGoods: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 120
    Top = 264
    object cdsGoodsId: TIntegerField
      FieldName = 'Id'
    end
    object cdsGoodsCode: TIntegerField
      FieldName = 'Code'
    end
    object cdsGoodsName: TWideStringField
      FieldName = 'Name'
      Size = 255
    end
    object cdsGoodsArticle: TWideStringField
      FieldName = 'Article'
    end
    object cdsGoodsEAN: TWideStringField
      FieldName = 'EAN'
    end
    object cdsGoodsGoodsGroupName: TWideStringField
      FieldName = 'GoodsGroupName'
      Size = 255
    end
    object cdsGoodsMeasureName: TWideStringField
      FieldName = 'MeasureName'
    end
    object cdsGoodsisErased: TBooleanField
      FieldName = 'isErased'
    end
  end
  object cdsGoodsList: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 264
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
    Left = 456
    Top = 32
  end
  object fdfAnsiUpperCase: TFDSQLiteFunction
    DriverLink = fdDriverLink
    FunctionName = 'AnsiUpperCase'
    ArgumentsCount = 1
    OnCalculate = fdfAnsiUpperCaseCalculate
    Left = 608
    Top = 32
  end
end
