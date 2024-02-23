object DM: TDM
  Height = 1080
  Width = 1440
  PixelsPerInch = 144
  object cdsInventoryJournal: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 120
    Top = 48
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
    Left = 304
    Top = 48
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
    Left = 472
    Top = 48
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
    Params = <>
    Left = 648
    Top = 48
    object cdsInventoryGoodsId: TIntegerField
      FieldName = 'Id'
    end
  end
  object cdsGoods: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 168
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
end
