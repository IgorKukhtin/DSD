object EmployeeScheduleFillingForm: TEmployeeScheduleFillingForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1075#1088#1072#1092#1080#1082#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
  ClientHeight = 258
  ClientWidth = 432
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
    Left = 84
    Top = 218
    Width = 75
    Height = 25
    Action = actExecuteFilling
    Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100
    Default = True
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 258
    Top = 218
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object cxLabel3: TcxLabel
    Left = 176
    Top = 58
    Caption = #1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
  end
  object cePayrollType: TcxButtonEdit
    Left = 176
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1101'.'#1087'.>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 4
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1101'.'#1087'.>'
    Width = 241
  end
  object DateNavigator: TcxDateNavigator
    Left = 8
    Top = 10
    Width = 147
    Height = 129
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ShowWeekNumbers = False
    TabOrder = 0
    UnlimitedSelection = True
  end
  object ceUser: TcxButtonEdit
    Left = 176
    Top = 31
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 5
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072'>'
    Width = 241
  end
  object cxLabel1: TcxLabel
    Left = 176
    Top = 10
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object cbEndMin: TcxComboBox
    Left = 248
    Top = 187
    Properties.Items.Strings = (
      ''
      '00'
      '30')
    TabOrder = 7
    Width = 54
  end
  object cxLabel7: TcxLabel
    Left = 233
    Top = 188
    Caption = ' : '
  end
  object cbEndHour: TcxComboBox
    Left = 176
    Top = 187
    Properties.Items.Strings = (
      ''
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23')
    TabOrder = 9
    Width = 54
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 188
    Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1093#1086#1076#1072':'
  end
  object cbStartMin: TcxComboBox
    Left = 248
    Top = 156
    Properties.Items.Strings = (
      ''
      '00'
      '30')
    TabOrder = 11
    Width = 54
  end
  object cxLabel6: TcxLabel
    Left = 233
    Top = 157
    Caption = ' : '
  end
  object cbStartHour: TcxComboBox
    Left = 176
    Top = 156
    Properties.Items.Strings = (
      ''
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23')
    TabOrder = 13
    Width = 54
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 157
    Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072':'
  end
  object ceUnit: TcxButtonEdit
    Left = 176
    Top = 127
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 15
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Width = 241
  end
  object cxLabel5: TcxLabel
    Left = 176
    Top = 107
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1076#1083#1103' '#1087#1086#1076#1084#1077#1085' '#1080#1083#1080' '#1085#1072#1076#1086' '#1079#1072#1084#1077#1085#1080#1090#1100')'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 103
    Top = 145
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementID'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = DateNavigator
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 23
    Top = 145
  end
  object GuidesPayrollType: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePayrollType
    FormNameParam.Value = 'TPayrollTypeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPayrollTypeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPayrollType
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPayrollType
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 75
  end
  object GuidesUser: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUser
    FormNameParam.Value = 'TUserNickForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserNickForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 25
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
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
    Left = 360
    Top = 127
  end
  object spUpdateEmployeeScheduleUser: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_EmployeeSchedule_Filling'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = DateNavigator
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserID'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitID'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPayrollTypeID'
        Value = 'False'
        Component = GuidesPayrollType
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartHour'
        Value = ''
        Component = cbStartHour
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartMin'
        Value = ''
        Component = cbStartMin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndHour'
        Value = ''
        Component = cbEndHour
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndMin'
        Value = ''
        Component = cbEndMin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 362
    Top = 184
  end
  object ActionList: TActionList
    Left = 24
    Top = 208
    object actExecuteFilling: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actFormClose
      ActionList = <
        item
          Action = actExecuteSPFilling
        end>
      DateNavigator = DateNavigator
      Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1075#1088#1072#1092#1080#1082#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      Hint = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1075#1088#1072#1092#1080#1082#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
    end
    object actExecuteSPFilling: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEmployeeScheduleUser
      StoredProcList = <
        item
          StoredProc = spUpdateEmployeeScheduleUser
        end>
      Caption = 'actExecuteSPFilling'
    end
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ModalResult = 1
      Caption = 'actFormClose'
    end
  end
end
