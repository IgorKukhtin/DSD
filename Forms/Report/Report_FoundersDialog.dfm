object Report_FoundersDialogForm: TReport_FoundersDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1091#1095#1088#1077#1076#1080#1090#1077#1083#1103#1084'>'
  ClientHeight = 174
  ClientWidth = 401
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
    Left = 81
    Top = 123
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 255
    Top = 123
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 128
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 100
  end
  object deStart: TcxDateEdit
    Left = 8
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 100
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 128
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel20: TcxLabel
    Left = 8
    Top = 59
    Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    Visible = False
  end
  object edAccount: TcxButtonEdit
    Left = 97
    Top = 58
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Visible = False
    Width = 131
  end
  object cxLabel9: TcxLabel
    Left = 8
    Top = 85
    Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
    Visible = False
  end
  object edInfoMoneyDestination: TcxButtonEdit
    Left = 98
    Top = 85
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Visible = False
    Width = 76
  end
  object cxLabel13: TcxLabel
    Left = 250
    Top = 55
    Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    Visible = False
  end
  object edInfoMoneyGroup: TcxButtonEdit
    Left = 378
    Top = 54
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Visible = False
    Width = 92
  end
  object cxLabel5: TcxLabel
    Left = 250
    Top = 85
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    Visible = False
  end
  object edInfoMoney: TcxButtonEdit
    Left = 378
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Visible = False
    Width = 92
  end
  object cbisDate: TcxCheckBox
    Left = 250
    Top = 27
    Caption = #1087#1086' '#1076#1072#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 14
    Width = 80
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 136
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 194
    Top = 119
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
    Left = 354
    Top = 121
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
        Name = 'AccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountName'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyDestinationId'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyDestinationName'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyGroupId'
        Value = Null
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyGroupName'
        Value = Null
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inisDate'
        Value = ''
        Component = cbisDate
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 10
    Top = 104
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccount_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 88
    Top = 53
  end
  object GuidesInfoMoneyDestination: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoneyDestination
    FormNameParam.Value = 'TInfoMoneyDestination_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyDestination_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 150
    Top = 78
  end
  object GuidesInfoMoneyGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoneyGroup
    FormNameParam.Value = 'TInfoMoneyGroup_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyGroup_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Juridical'
        DataType = ftString
      end>
    Left = 344
    Top = 37
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Juridical'
        DataType = ftString
      end>
    Left = 392
    Top = 69
  end
end
