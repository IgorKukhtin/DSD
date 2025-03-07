object DM: TDM
  OnCreate = DataModuleCreate
  Height = 491
  Width = 959
  PixelsPerInch = 144
  object cdsChoiceCelEdit: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 142
    Top = 172
    object cdsChoiceCelEditChoiceCellId: TIntegerField
      FieldName = 'ChoiceCellId'
    end
    object cdsChoiceCelEditChoiceCellCode: TIntegerField
      FieldName = 'ChoiceCellCode'
    end
    object cdsChoiceCelEditChoiceCellName: TStringField
      FieldName = 'ChoiceCellName'
      Size = 255
    end
    object cdsChoiceCelEditGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsChoiceCelEditGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsChoiceCelEditGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsChoiceCelEditGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object cdsChoiceCelEditGoodsKindName: TStringField
      FieldName = 'GoodsKindName'
      Size = 255
    end
    object cdsChoiceCelEditPartionGoodsDate: TDateTimeField
      FieldName = 'PartionGoodsDate'
    end
    object cdsChoiceCelEditPartionGoodsDate_next: TDateTimeField
      FieldName = 'PartionGoodsDate_next'
    end
  end
  object cdsChoiceCelListTop: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsChoiceCelListTopCalcFields
    Left = 312
    Top = 279
    object cdsChoiceCelListTopId: TIntegerField
      FieldName = 'Id'
    end
    object cdsChoiceCelListTopStatusCode: TIntegerField
      FieldName = 'StatusCode'
    end
    object cdsChoiceCelListTopInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object cdsChoiceCelListTopOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object cdsChoiceCelListTopMovementItemId: TIntegerField
      FieldName = 'MovementItemId'
    end
    object cdsChoiceCelListTopGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsChoiceCelListTopGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsChoiceCelListTopGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsChoiceCelListTopChoiceCellCode: TIntegerField
      FieldName = 'ChoiceCellCode'
    end
    object cdsChoiceCelListTopChoiceCellName: TStringField
      FieldName = 'ChoiceCellName'
      Size = 255
    end
    object cdsChoiceCelListTopGoodsKindName: TStringField
      FieldName = 'GoodsKindName'
      Size = 255
    end
    object cdsChoiceCelListTopPartionGoodsDate: TDateTimeField
      FieldName = 'PartionGoodsDate'
    end
    object cdsChoiceCelListTopPartionGoodsDate_next: TDateTimeField
      FieldName = 'PartionGoodsDate_next'
    end
    object cdsChoiceCelListTopInsertName: TStringField
      FieldName = 'InsertName'
      Size = 255
    end
    object cdsChoiceCelListTopInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object cdsChoiceCelListTopErasedCode: TIntegerField
      FieldName = 'ErasedCode'
    end
    object cdsChoiceCelListTopPartionGoodsDateLabel: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionGoodsDateLabel'
      Size = 255
      Calculated = True
    end
    object cdsChoiceCelListTopPartionGoodsDate_nextLabel: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionGoodsDate_nextLabel'
      Size = 255
      Calculated = True
    end
  end
  object cdsChoiceCelList: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsChoiceCelListCalcFields
    Left = 136
    Top = 272
    object cdsChoiceCelListId: TIntegerField
      FieldName = 'Id'
    end
    object cdsChoiceCelListStatusCode: TIntegerField
      FieldName = 'StatusCode'
    end
    object cdsChoiceCelListOperDate: TDateTimeField
      FieldName = 'OperDate'
    end
    object cdsChoiceCelListInvNumber: TStringField
      FieldName = 'InvNumber'
      Size = 255
    end
    object cdsChoiceCelListMovementItemId: TIntegerField
      FieldName = 'MovementItemId'
    end
    object cdsChoiceCelListGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsChoiceCelListGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsChoiceCelListGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsChoiceCelListChoiceCellCode: TIntegerField
      FieldName = 'ChoiceCellCode'
    end
    object cdsChoiceCelListChoiceCellName: TStringField
      FieldName = 'ChoiceCellName'
      Size = 255
    end
    object cdsChoiceCelListGoodsKindName: TStringField
      FieldName = 'GoodsKindName'
      Size = 255
    end
    object cdsChoiceCelListPartionGoodsDate: TDateTimeField
      FieldName = 'PartionGoodsDate'
    end
    object cdsChoiceCelListPartionGoodsDate_next: TDateTimeField
      FieldName = 'PartionGoodsDate_next'
    end
    object cdsChoiceCelListInsertName: TStringField
      FieldName = 'InsertName'
      Size = 255
    end
    object cdsChoiceCelListInsertDate: TDateTimeField
      FieldName = 'InsertDate'
    end
    object cdsChoiceCelListErasedCode: TIntegerField
      FieldName = 'ErasedCode'
    end
    object cdsChoiceCelListPartionGoodsDateLabel: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionGoodsDateLabel'
      Size = 255
      Calculated = True
    end
    object cdsChoiceCelListPartionGoodsDate_nextLabel: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionGoodsDate_nextLabel'
      Size = 255
      Calculated = True
    end
  end
  object cdsInventoryListTop: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsInventoryListTopCalcFields
    Left = 720
    Top = 279
    object cdsInventoryListTopMovementItemId: TIntegerField
      FieldName = 'MovementItemId'
    end
    object cdsInventoryListTopStatusCode: TIntegerField
      FieldName = 'StatusCode'
    end
    object cdsInventoryListTopGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsInventoryListTopGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsInventoryListTopGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsInventoryListTopChoiceGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object cdsInventoryListTopGoodsKindName: TStringField
      FieldName = 'GoodsKindName'
      Size = 255
    end
    object cdsInventoryListTopAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryListTopPartionCellName: TStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsInventoryListTopPartionGoodsDate: TDateTimeField
      FieldName = 'PartionGoodsDate'
    end
    object cdsInventoryListTopPartionNum: TIntegerField
      FieldName = 'PartionNum'
    end
    object cdsInventoryListTopBoxId_1: TIntegerField
      FieldName = 'BoxId_1'
    end
    object cdsInventoryListTopBoxName_1: TStringField
      FieldName = 'BoxName_1'
      Size = 255
    end
    object cdsInventoryListTopCountTare_1: TIntegerField
      FieldName = 'CountTare_1'
    end
    object cdsInventoryListTopWeightTare_1: TFloatField
      FieldName = 'WeightTare_1'
    end
    object cdsInventoryListTopBoxId_2: TIntegerField
      FieldName = 'BoxId_2'
    end
    object cdsInventoryListTopBoxName_2: TStringField
      FieldName = 'BoxName_2'
      Size = 255
    end
    object cdsInventoryListTopCountTare_2: TIntegerField
      FieldName = 'CountTare_2'
    end
    object cdsInventoryListTopWeightTare_2: TFloatField
      FieldName = 'WeightTare_2'
    end
    object cdsInventoryListTopBoxId_3: TIntegerField
      FieldName = 'BoxId_3'
    end
    object cdsInventoryListTopBoxName_3: TStringField
      FieldName = 'BoxName_3'
      Size = 255
    end
    object cdsInventoryListTopCountTare_3: TIntegerField
      FieldName = 'CountTare_3'
    end
    object cdsInventoryListTopWeightTare_3: TFloatField
      FieldName = 'WeightTare_3'
    end
    object cdsInventoryListTopBoxId_4: TIntegerField
      FieldName = 'BoxId_4'
    end
    object cdsInventoryListTopBoxName_4: TStringField
      FieldName = 'BoxName_4'
      Size = 255
    end
    object cdsInventoryListTopCountTare_4: TIntegerField
      FieldName = 'CountTare_4'
    end
    object cdsInventoryListTopWeightTare_4: TFloatField
      FieldName = 'WeightTare_4'
    end
    object cdsInventoryListTopBoxId_5: TIntegerField
      FieldName = 'BoxId_5'
    end
    object cdsInventoryListTopBoxName_5: TStringField
      FieldName = 'BoxName_5'
      Size = 255
    end
    object cdsInventoryListTopCountTare_5: TIntegerField
      FieldName = 'CountTare_5'
    end
    object cdsInventoryListTopWeightTare_5: TFloatField
      FieldName = 'WeightTare_5'
    end
    object cdsInventoryListTopCountTare_calc: TIntegerField
      FieldName = 'CountTare_calc'
    end
    object cdsInventoryListTopWeightTare_calc: TFloatField
      FieldName = 'WeightTare_calc'
    end
    object cdsInventoryListTopErasedCode: TIntegerField
      FieldName = 'ErasedCode'
    end
    object cdsInventoryListTopAmountCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'AmountCaption'
      Size = 50
      Calculated = True
    end
    object cdsInventoryListTopPartionGoodsDateCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionGoodsDateCaption'
      Size = 50
      Calculated = True
    end
    object cdsInventoryListTopPartionNumCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionNumCaption'
      Size = 50
      Calculated = True
    end
    object cdsInventoryListTopCountTare_calcCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'CountTare_calcCaption'
      Size = 50
      Calculated = True
    end
  end
  object cdsInventoryList: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = cdsInventoryListCalcFields
    Left = 504
    Top = 280
    object cdsInventoryListMovementItemId: TIntegerField
      FieldName = 'MovementItemId'
    end
    object cdsInventoryListStatusCode: TIntegerField
      FieldName = 'StatusCode'
    end
    object cdsInventoryListGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsInventoryListGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsInventoryListGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsInventoryListChoiceGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object cdsInventoryListGoodsKindName: TStringField
      FieldName = 'GoodsKindName'
      Size = 255
    end
    object cdsInventoryListAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryListPartionCellName: TStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsInventoryListPartionGoodsDate: TDateTimeField
      FieldName = 'PartionGoodsDate'
    end
    object cdsInventoryListPartionNum: TIntegerField
      FieldName = 'PartionNum'
    end
    object cdsInventoryListBoxId_1: TIntegerField
      FieldName = 'BoxId_1'
    end
    object cdsInventoryListBoxName_1: TStringField
      FieldName = 'BoxName_1'
      Size = 255
    end
    object cdsInventoryListCountTare_1: TIntegerField
      FieldName = 'CountTare_1'
    end
    object cdsInventoryListWeightTare_1: TFloatField
      FieldName = 'WeightTare_1'
    end
    object cdsInventoryListBoxId_2: TIntegerField
      FieldName = 'BoxId_2'
    end
    object cdsInventoryListBoxName_2: TStringField
      FieldName = 'BoxName_2'
      Size = 255
    end
    object cdsInventoryListCountTare_2: TIntegerField
      FieldName = 'CountTare_2'
    end
    object cdsInventoryListWeightTare_2: TFloatField
      FieldName = 'WeightTare_2'
    end
    object cdsInventoryListBoxId_3: TIntegerField
      FieldName = 'BoxId_3'
    end
    object cdsInventoryListBoxName_3: TStringField
      FieldName = 'BoxName_3'
      Size = 255
    end
    object cdsInventoryListCountTare_3: TIntegerField
      FieldName = 'CountTare_3'
    end
    object cdsInventoryListWeightTare_3: TFloatField
      FieldName = 'WeightTare_3'
    end
    object cdsInventoryListBoxId_4: TIntegerField
      FieldName = 'BoxId_4'
    end
    object cdsInventoryListBoxName_4: TStringField
      FieldName = 'BoxName_4'
      Size = 255
    end
    object cdsInventoryListCountTare_4: TIntegerField
      FieldName = 'CountTare_4'
    end
    object cdsInventoryListWeightTare_4: TFloatField
      FieldName = 'WeightTare_4'
    end
    object cdsInventoryListBoxId_5: TIntegerField
      FieldName = 'BoxId_5'
    end
    object cdsInventoryListBoxName_5: TStringField
      FieldName = 'BoxName_5'
      Size = 255
    end
    object cdsInventoryListCountTare_5: TIntegerField
      FieldName = 'CountTare_5'
    end
    object cdsInventoryListWeightTare_5: TFloatField
      FieldName = 'WeightTare_5'
    end
    object cdsInventoryListCountTare_calc: TIntegerField
      FieldName = 'CountTare_calc'
    end
    object cdsInventoryListWeightTare_calc: TFloatField
      FieldName = 'WeightTare_calc'
    end
    object cdsInventoryListErasedCode: TIntegerField
      FieldName = 'ErasedCode'
    end
    object cdsInventoryListAmountCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'AmountCaption'
      Size = 50
      Calculated = True
    end
    object cdsInventoryListPartionGoodsDateCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionGoodsDateCaption'
      Size = 50
      Calculated = True
    end
    object cdsInventoryListPartionNumCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'PartionNumCaption'
      Size = 50
      Calculated = True
    end
    object cdsInventoryListCountTare_calcCaption: TStringField
      FieldKind = fkCalculated
      FieldName = 'CountTare_calcCaption'
      Size = 50
      Calculated = True
    end
  end
  object cdsInventoryEdit: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 502
    Top = 180
    object cdsInventoryEditMovementItemId: TIntegerField
      FieldName = 'MovementItemId'
    end
    object cdsInventoryEditGoodsId: TIntegerField
      FieldName = 'GoodsId'
    end
    object cdsInventoryEditGoodsCode: TIntegerField
      FieldName = 'GoodsCode'
    end
    object cdsInventoryEditGoodsName: TStringField
      FieldName = 'GoodsName'
      Size = 255
    end
    object cdsInventoryEditGoodsKindId: TIntegerField
      FieldName = 'GoodsKindId'
    end
    object cdsInventoryEditGoodsKindName: TStringField
      FieldName = 'GoodsKindName'
      Size = 255
    end
    object cdsInventoryEditAmount: TFloatField
      FieldName = 'Amount'
    end
    object cdsInventoryEditPartionCellName: TStringField
      FieldName = 'PartionCellName'
      Size = 255
    end
    object cdsInventoryEditPartionGoodsDate: TDateTimeField
      FieldName = 'PartionGoodsDate'
    end
    object cdsInventoryEditPartionNum: TIntegerField
      FieldName = 'PartionNum'
    end
    object cdsInventoryEditBoxId_1: TIntegerField
      FieldName = 'BoxId_1'
    end
    object cdsInventoryEditBoxName_1: TStringField
      FieldName = 'BoxName_1'
      Size = 255
    end
    object cdsInventoryEditCountTare_1: TIntegerField
      FieldName = 'CountTare_1'
    end
    object cdsInventoryEditWeightTare_1: TFloatField
      FieldName = 'WeightTare_1'
    end
    object cdsInventoryEditBoxId_2: TIntegerField
      FieldName = 'BoxId_2'
    end
    object cdsInventoryEditBoxName_2: TStringField
      FieldName = 'BoxName_2'
      Size = 255
    end
    object cdsInventoryEditCountTare_2: TIntegerField
      FieldName = 'CountTare_2'
    end
    object cdsInventoryEditWeightTare_2: TFloatField
      FieldName = 'WeightTare_2'
    end
    object cdsInventoryEditBoxId_3: TIntegerField
      FieldName = 'BoxId_3'
    end
    object cdsInventoryEditBoxName_3: TStringField
      FieldName = 'BoxName_3'
      Size = 255
    end
    object cdsInventoryEditCountTare_3: TIntegerField
      FieldName = 'CountTare_3'
    end
    object cdsInventoryEditWeightTare_3: TFloatField
      FieldName = 'WeightTare_3'
    end
    object cdsInventoryEditBoxId_4: TIntegerField
      FieldName = 'BoxId_4'
    end
    object cdsInventoryEditBoxName_4: TStringField
      FieldName = 'BoxName_4'
      Size = 255
    end
    object cdsInventoryEditCountTare_4: TIntegerField
      FieldName = 'CountTare_4'
    end
    object cdsInventoryEditWeightTare_4: TFloatField
      FieldName = 'WeightTare_4'
    end
    object cdsInventoryEditBoxId_5: TIntegerField
      FieldName = 'BoxId_5'
    end
    object cdsInventoryEditBoxName_5: TStringField
      FieldName = 'BoxName_5'
      Size = 255
    end
    object cdsInventoryEditCountTare_5: TIntegerField
      FieldName = 'CountTare_5'
    end
    object cdsInventoryEditWeightTare_5: TFloatField
      FieldName = 'WeightTare_5'
    end
    object cdsInventoryEditCountTare_calc: TIntegerField
      FieldName = 'CountTare_calc'
    end
    object cdsInventoryEditWeightTare_calc: TFloatField
      FieldName = 'WeightTare_calc'
    end
  end
end
