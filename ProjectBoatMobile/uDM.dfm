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
    object cdsInventoryJournalStatus: TWideStringField
      FieldName = 'Status'
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
end
