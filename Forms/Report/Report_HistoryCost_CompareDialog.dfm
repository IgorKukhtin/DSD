object Report_HistoryCost_CompareDialogForm: TReport_HistoryCost_CompareDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1094#1077#1085' '#1089'/'#1089' '#1079#1072' 2 '#1087#1077#1088#1080#1086#1076#1072'>'
  ClientHeight = 238
  ClientWidth = 242
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
    Left = 24
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 152
    Top = 200
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 187
    Top = 149
    EditValue = 42005d
    Properties.AssignedValues.DisplayFormat = True
    Properties.AssignedValues.EditFormat = True
    Properties.ShowTime = False
    TabOrder = 2
    Visible = False
    Width = 106
  end
  object deStart: TcxDateEdit
    Left = 187
    Top = 173
    EditValue = 42005d
    Properties.AssignedValues.DisplayFormat = True
    Properties.AssignedValues.EditFormat = True
    Properties.ShowTime = False
    TabOrder = 3
    Visible = False
    Width = 101
  end
  object edGoods: TcxButtonEdit
    Left = 11
    Top = 133
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 216
  end
  object cxLabel1: TcxLabel
    Left = 11
    Top = 112
    Caption = #1058#1086#1074#1072#1088':'
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 8
    Caption = #1052#1077#1089#1103#1094' 1:'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 8
    Caption = #1052#1077#1089#1103#1094' 2:'
  end
  object cxLabel4: TcxLabel
    Left = 11
    Top = 59
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 11
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 216
  end
  object cbisGoods: TcxCheckBox
    Left = 11
    Top = 165
    Hint = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
    Caption = #1087#1086' '#1090#1086#1074#1072#1088#1091' '#1076#1072'/'#1085#1077#1090
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 112
  end
  object edMonth1: TcxDateEdit
    Left = 11
    Top = 28
    EditValue = 42005d
    Properties.AssignedValues.EditFormat = True
    Properties.DisplayFormat = 'MMMM YYYY'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 11
    Width = 99
  end
  object edMonth2: TcxDateEdit
    Left = 121
    Top = 28
    EditValue = 42005d
    Properties.AssignedValues.EditFormat = True
    Properties.DisplayFormat = 'MMMM YYYY'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 12
    Width = 106
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 184
    Top = 112
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
    Left = 192
    Top = 44
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Month1'
        Value = 41579d
        Component = edMonth1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Month2'
        Value = 41608d
        Component = edMonth2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
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
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoods'
        Value = Null
        Component = cbisGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 176
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
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
    Left = 128
    Top = 120
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
    Left = 112
    Top = 73
  end
end
