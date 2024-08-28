object DM: TDM
  OnCreate = DataModuleCreate
  Height = 409
  Width = 799
  PixelsPerInch = 120
  object cdsChoiceCelEdit: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 125
    Top = 70
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
    Left = 307
    Top = 179
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
    Left = 113
    Top = 187
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
end
