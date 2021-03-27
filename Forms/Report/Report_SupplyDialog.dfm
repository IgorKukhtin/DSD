object Report_SupplyDialogForm: TReport_SupplyDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1044#1083#1103' '#1089#1085#1072#1073#1078#1077#1085#1080#1103'>'
  ClientHeight = 212
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 130
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 304
    Top = 176
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 89
    Top = 37
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 80
  end
  object deStart: TcxDateEdit
    Left = 89
    Top = 12
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 80
  end
  object edGoods: TcxButtonEdit
    Left = 254
    Top = 131
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 244
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 254
    Top = 87
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 244
  end
  object edUnitGroup: TcxButtonEdit
    Left = 14
    Top = 87
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 232
  end
  object cxLabel3: TcxLabel
    Left = 14
    Top = 67
    Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
  end
  object cxLabel1: TcxLabel
    Left = 255
    Top = 65
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
  end
  object cxLabel2: TcxLabel
    Left = 255
    Top = 114
    Caption = #1058#1086#1074#1072#1088':'
  end
  object cxLabel5: TcxLabel
    Left = 179
    Top = 13
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1089' ...'
  end
  object cxLabel10: TcxLabel
    Left = 172
    Top = 38
    AutoSize = False
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1087#1086' ...'
    Height = 17
    Width = 76
  end
  object deEnd2: TcxDateEdit
    Left = 254
    Top = 37
    EditValue = 43101d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 12
    Width = 79
  end
  object deStart2: TcxDateEdit
    Left = 254
    Top = 12
    EditValue = 43101d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 79
  end
  object cxLabel11: TcxLabel
    Left = 14
    Top = 13
    Caption = #1055#1077#1088#1080#1086#1076'1 '#1089' ...'
  end
  object cxLabel12: TcxLabel
    Left = 9
    Top = 38
    AutoSize = False
    Caption = #1055#1077#1088#1080#1086#1076'1 '#1087#1086' ...'
    Height = 17
    Width = 76
  end
  object cxLabel13: TcxLabel
    Left = 344
    Top = 15
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1089' ...'
  end
  object cxLabel14: TcxLabel
    Left = 339
    Top = 38
    AutoSize = False
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1087#1086' ...'
    Height = 17
    Width = 76
  end
  object deStart3: TcxDateEdit
    Left = 419
    Top = 12
    EditValue = 43101d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 18
    Width = 79
  end
  object deEnd3: TcxDateEdit
    Left = 419
    Top = 37
    EditValue = 43101d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 19
    Width = 79
  end
  object cbGoodsKind: TcxCheckBox
    Left = 36
    Top = 131
    Caption = #1055#1086' '#1074#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
    Properties.ReadOnly = False
    State = cbsChecked
    TabOrder = 20
    Width = 113
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 128
    Top = 24
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 424
    Top = 152
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 160
    Top = 132
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate1'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate1'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate2'
        Value = Null
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate2'
        Value = Null
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate3'
        Value = Null
        Component = deStart3
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate3'
        Value = Null
        Component = deEnd3
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
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
    Left = 16
    Top = 136
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 119
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 96
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 96
  end
  object PeriodChoice3: TPeriodChoice
    DateStart = deEnd3
    DateEnd = deEnd3
    Left = 440
    Top = 16
  end
  object PeriodChoice2: TPeriodChoice
    DateStart = deEnd2
    DateEnd = deEnd2
    Left = 304
    Top = 16
  end
end
