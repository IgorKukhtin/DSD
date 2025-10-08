﻿object Report_GoodsDialogForm: TReport_GoodsDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1084'>'
  ClientHeight = 256
  ClientWidth = 477
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
    Left = 113
    Top = 218
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 278
    Top = 218
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 107
    Top = 27
    EditValue = 44927d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 11
    Top = 27
    EditValue = 44927d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object edGoods: TcxButtonEdit
    Left = 207
    Top = 135
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 249
  end
  object edUnitGroup: TcxButtonEdit
    Left = 11
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 445
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 58
    Caption = #1057#1082#1083#1072#1076'/'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080':'
  end
  object cxLabel2: TcxLabel
    Left = 207
    Top = 117
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077':'
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 107
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel1: TcxLabel
    Left = 207
    Top = 7
    Caption = #1055#1072#1088#1090#1080#1103':'
  end
  object edPartion: TcxButtonEdit
    Left = 207
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 249
  end
  object Код: TcxLabel
    Left = 11
    Top = 117
    Caption = 'Interne Nr'
  end
  object ceCode: TcxCurrencyEdit
    Left = 11
    Top = 135
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 90
  end
  object edArticle: TcxTextEdit
    Left = 107
    Top = 135
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 90
  end
  object cxLabel18: TcxLabel
    Left = 107
    Top = 117
    Caption = 'Artikel Nr'
  end
  object cbPartNumber: TcxCheckBox
    Left = 107
    Top = 178
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' S/N ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' S/N'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
    Width = 122
  end
  object cbPartion: TcxCheckBox
    Left = 8
    Top = 178
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1055#1072#1088#1090#1080#1103' '#8470
    ParentShowHint = False
    ShowHint = True
    TabOrder = 17
    Width = 83
  end
  object cbOrderClient: TcxCheckBox
    Left = 235
    Top = 178
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072' '#8470
    ParentShowHint = False
    ShowHint = True
    TabOrder = 18
    Width = 118
  end
  object cbisPartionCell: TcxCheckBox
    Left = 373
    Top = 178
    Hint = #1087#1086#1082#1072#1079#1072#1090#1100' <'#1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1072#1088#1090#1080#1103' '#8470'> ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1055#1086' '#1103#1095#1077#1081#1082#1072#1084
    ParentShowHint = False
    ShowHint = True
    TabOrder = 19
    Width = 83
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 280
    Top = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 64
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
    Left = 408
    Top = 78
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'PartionId'
        Value = Null
        Component = GuidesPartion
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionName'
        Value = Null
        Component = GuidesPartion
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartNumber'
        Value = Null
        Component = cbPartNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartion'
        Value = Null
        Component = cbPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOrderClient'
        Value = Null
        Component = cbOrderClient
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionCell'
        Value = Null
        Component = cbisPartionCell
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 409
    Top = 179
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ChoiceForm'
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
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 143
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
    Left = 168
    Top = 112
  end
  object GuidesPartion: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartion
    FormNameParam.Value = 'TPartionGoodsChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartionGoodsChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartion
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull'
        Value = ''
        Component = GuidesPartion
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitName'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 23
  end
end
