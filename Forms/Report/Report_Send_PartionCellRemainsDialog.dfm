object Report_Send_PartionCellRemainsDialogForm: TReport_Send_PartionCellRemainsDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' <'#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072' '#1087#1086' '#1071#1095#1077#1081#1082#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1086#1089#1090#1072#1090#1082#1080')>'
  ClientHeight = 168
  ClientWidth = 351
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
    Left = 62
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 200
    Top = 127
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 233
    Top = 23
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Visible = False
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 123
    Top = 23
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Visible = False
    Width = 90
  end
  object edUnit: TcxButtonEdit
    Left = 8
    Top = 50
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 322
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 27
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
  end
  object cxLabel6: TcxLabel
    Left = 123
    Top = 3
    Caption = #1044#1072#1090#1072' '#1089' :'
    Visible = False
  end
  object cxLabel7: TcxLabel
    Left = 233
    Top = 3
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
    Visible = False
  end
  object cbMovement: TcxCheckBox
    Left = 8
    Top = 83
    Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 103
  end
  object cbisCell: TcxCheckBox
    Left = 136
    Top = 83
    Caption = #1055#1086' '#1103#1095#1077#1081#1082#1072#1084
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 103
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 176
    Top = 4
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 8
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
    Left = 312
    Top = 52
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
        Name = 'isMovement'
        Value = Null
        Component = cbMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCell'
        Value = Null
        Component = cbisCell
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 116
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
    Left = 32
    Top = 24
  end
end
