object Report_PersonalCompleteDialogForm: TReport_PersonalCompleteDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084'>'
  ClientHeight = 232
  ClientWidth = 388
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
    Left = 80
    Top = 189
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 254
    Top = 189
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 232
    Top = 6
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 82
  end
  object deStart: TcxDateEdit
    Left = 77
    Top = 6
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 82
  end
  object edPosition: TcxButtonEdit
    Left = 98
    Top = 96
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 250
  end
  object edPersonal: TcxButtonEdit
    Left = 98
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 250
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 100
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082':'
  end
  object cxLabel1: TcxLabel
    Left = 11
    Top = 135
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
  end
  object cxLabel6: TcxLabel
    Left = 26
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 174
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cbinIsDay: TcxCheckBox
    Left = 26
    Top = 33
    Caption = #1087#1086' '#1076#1085#1103#1084
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 65
  end
  object cxLabel2: TcxLabel
    Left = 11
    Top = 65
    Caption = #1060#1080#1083#1080#1072#1083':'
  end
  object edBranch: TcxButtonEdit
    Left = 98
    Top = 65
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 250
  end
  object cbIsMovement: TcxCheckBox
    Left = 114
    Top = 33
    Caption = #1054#1090' '#1082#1086#1075#1086' / '#1050#1086#1084#1091
    Properties.ReadOnly = False
    TabOrder = 13
    Width = 107
  end
  object cbDoc: TcxCheckBox
    Left = 232
    Top = 33
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    TabOrder = 14
    Width = 148
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 355
    Top = 119
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 352
    Top = 57
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
    Left = 291
    Top = 149
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
        Name = 'PositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = Null
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDay'
        Value = Null
        Component = cbinIsDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMovement'
        Value = Null
        Component = cbIsMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDoc'
        Value = Null
        Component = cbDoc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 27
    Top = 153
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 150
    Top = 125
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 245
    Top = 89
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    Key = '0'
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = BranchGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 126
    Top = 51
  end
end
