object Report_GoodsMI_SendOnPriceDialogForm: TReport_GoodsMI_SendOnPriceDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077'>'
  ClientHeight = 290
  ClientWidth = 303
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
    Left = 49
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 162
    Top = 248
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 8
    Top = 66
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 9
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 9
    Top = 210
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 277
  end
  object cxLabel1: TcxLabel
    Left = 9
    Top = 188
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
  end
  object cxLabel6: TcxLabel
    Left = 9
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 46
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 141
    Caption = #1050#1086#1084#1091':'
  end
  object edUnitTo: TcxButtonEdit
    Left = 9
    Top = 161
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 277
  end
  object cxLabel8: TcxLabel
    Left = 9
    Top = 98
    Caption = #1054#1090' '#1082#1086#1075#1086':'
  end
  object edUnitFrom: TcxButtonEdit
    Left = 9
    Top = 118
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 277
  end
  object cbTradeMark: TcxCheckBox
    Left = 136
    Top = 7
    Caption = #1087#1086' '#1058#1086#1088#1075#1086#1074#1099#1084' '#1084#1072#1088#1082#1072#1084
    Properties.ReadOnly = False
    TabOrder = 12
    Width = 150
  end
  object cbGoods: TcxCheckBox
    Left = 136
    Top = 27
    Caption = #1087#1086' '#1058#1086#1074#1072#1088#1072#1084
    Properties.ReadOnly = False
    TabOrder = 13
    Width = 150
  end
  object cbGoodsKind: TcxCheckBox
    Left = 136
    Top = 47
    Caption = #1087#1086' '#1042#1080#1076#1072#1084
    Properties.ReadOnly = False
    TabOrder = 14
    Width = 150
  end
  object cbMovement: TcxCheckBox
    Left = 136
    Top = 66
    Caption = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 15
    Width = 150
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 80
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 32
    Top = 239
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
    Left = 96
    Top = 75
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'UnitToId'
        Value = ''
        Component = GuidesUnitTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'UnitToName'
        Value = ''
        Component = GuidesUnitTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'UnitFromId'
        Value = Null
        Component = GuidesUnitFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'UnitFromName'
        Value = Null
        Component = GuidesUnitFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'isTradeMark'
        Value = Null
        Component = cbTradeMark
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'isGoods'
        Value = Null
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'isGoodsKind'
        Value = Null
        Component = cbGoodsKind
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'isMovement'
        Value = Null
        Component = cbMovement
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 248
    Top = 239
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 136
    Top = 191
  end
  object GuidesUnitTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 144
    Top = 136
  end
  object GuidesUnitFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 148
    Top = 87
  end
end
