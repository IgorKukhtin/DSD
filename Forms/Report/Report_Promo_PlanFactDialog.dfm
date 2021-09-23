inherited Report_Promo_PlanFactDialogForm: TReport_Promo_PlanFactDialogForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1072#1082#1094#1080#1103#1084' ('#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1083#1072#1085' '#1080' '#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1080')'
  ClientHeight = 196
  ClientWidth = 468
  ExplicitWidth = 474
  ExplicitHeight = 224
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 114
    Top = 155
    ExplicitLeft = 114
    ExplicitTop = 155
  end
  inherited bbCancel: TcxButton
    Left = 258
    Top = 155
    ExplicitLeft = 258
    ExplicitTop = 155
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
    Left = 69
    Top = 35
    Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1040#1082#1094#1080#1080
    TabOrder = 8
    Width = 144
  end
  object cbTender: TcxCheckBox [9]
    Left = 215
    Top = 35
    Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1058#1077#1085#1076#1077#1088#1099
    TabOrder = 9
    Width = 161
  end
  object cbGoodsKind: TcxCheckBox [10]
    Left = 355
    Top = 87
    Caption = #1075#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1086' '#1074#1080#1076#1072#1084
    TabOrder = 10
    Visible = False
    Width = 145
  end
  object cxLabel6: TcxLabel [11]
    Left = 56
    Top = 115
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit [12]
    Left = 139
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 301
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 128
    Top = 147
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 29
    Top = 147
  end
  inherited ActionList: TActionList
    Left = 156
    Top = 146
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
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
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 197
    Top = 147
  end
  object GuidesUnit: TdsdGuides
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
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
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
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 265
    Top = 105
  end
end
