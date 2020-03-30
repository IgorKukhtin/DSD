inherited Report_PromoDialogForm: TReport_PromoDialogForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
  ClientHeight = 151
  ClientWidth = 458
  ExplicitWidth = 464
  ExplicitHeight = 179
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 114
    Top = 115
    ExplicitLeft = 114
    ExplicitTop = 115
  end
  inherited bbCancel: TcxButton
    Left = 258
    Top = 115
    ExplicitLeft = 258
    ExplicitTop = 115
  end
  object cxLabel1: TcxLabel [2]
    Left = 26
    Top = 9
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deStart: TcxDateEdit [3]
    Left = 128
    Top = 8
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 85
  end
  object cxLabel2: TcxLabel [4]
    Left = 239
    Top = 9
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deEnd: TcxDateEdit [5]
    Left = 355
    Top = 8
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 5
    Width = 85
  end
  object cxLabel17: TcxLabel [6]
    Left = 23
    Top = 73
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object edUnit: TcxButtonEdit [7]
    Left = 139
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 301
  end
  object cbPromo: TcxCheckBox [8]
    Left = 5
    Top = 35
    Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080
    TabOrder = 8
    Width = 144
  end
  object cbTender: TcxCheckBox [9]
    Left = 151
    Top = 35
    Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1058#1077#1085#1076#1077#1088#1099
    TabOrder = 9
    Width = 161
  end
  object cbGoodsKind: TcxCheckBox [10]
    Left = 309
    Top = 35
    Caption = #1075#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1086' '#1074#1080#1076#1072#1084
    TabOrder = 10
    Width = 145
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 128
    Top = 107
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 101
    Top = 107
  end
  inherited ActionList: TActionList
    Left = 156
    Top = 106
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTender'
        Value = Null
        Component = cbTender
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsKind'
        Value = Null
        Component = cbGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 101
    Top = 75
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 369
    Top = 59
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 232
    Top = 67
  end
end
