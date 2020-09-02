object EmployeeScheduleAddUserDialogForm: TEmployeeScheduleAddUserDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1075#1088#1072#1092#1080#1082#1072' '#1088#1072#1073#1086#1090#1099' '#1090#1080#1087' '#1076#1085#1103
  ClientHeight = 212
  ClientWidth = 340
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
    Left = 61
    Top = 173
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object cxButton2: TcxButton
    Left = 200
    Top = 173
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
  object deDateStart: TcxDateEdit
    Left = 163
    Top = 104
    EditValue = 42705d
    Properties.DateButtons = [btnClear, btnNow, btnToday]
    Properties.Kind = ckDateTime
    Properties.PostPopupValueOnTab = True
    TabOrder = 2
    Width = 146
  end
  object cxLabel6: TcxLabel
    Left = 26
    Top = 105
    Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072':'
  end
  object deDateEnd: TcxDateEdit
    Left = 163
    Top = 136
    EditValue = 42705d
    Properties.DateButtons = [btnClear, btnNow, btnToday]
    Properties.Kind = ckDateTime
    Properties.PostPopupValueOnTab = True
    TabOrder = 3
    Width = 146
  end
  object cxLabel1: TcxLabel
    Left = 26
    Top = 137
    Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1091#1093#1086#1076#1072':'
  end
  object edUser: TcxTextEdit
    Left = 101
    Top = 8
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 208
  end
  object cxLabel2: TcxLabel
    Left = 26
    Top = 9
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object cxLabel3: TcxLabel
    Left = 26
    Top = 72
    Caption = #1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072':'
  end
  object cePayrollType: TcxButtonEdit
    Left = 101
    Top = 71
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1101'.'#1087'.>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 1
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1088#1072#1089#1095#1077#1090#1072' '#1101'.'#1087'.>'
    Width = 208
  end
  object edUnit: TcxButtonEdit
    Left = 101
    Top = 39
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 208
  end
  object cxLabel4: TcxLabel
    Left = 26
    Top = 40
    Caption = #1040#1087#1090#1077#1082#1072':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
    Top = 102
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
    Left = 24
    Top = 44
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UserName'
        Value = Null
        Component = edUser
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PayrollTypeId'
        Value = Null
        Component = GuidesPayrollType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateStart'
        Value = 41579d
        Component = deDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateEnd'
        Value = 'NULL'
        Component = deDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 23
    Top = 94
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deDateStart
    Left = 96
    Top = 96
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
    Left = 192
    Top = 67
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
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
    Left = 224
    Top = 24
  end
end
