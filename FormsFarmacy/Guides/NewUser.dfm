object NewUserForm: TNewUserForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 409
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel2: TcxLabel
    Left = 21
    Top = 75
    Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072
  end
  object edPhone: TcxTextEdit
    Left = 21
    Top = 94
    TabOrder = 2
    Width = 321
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 22
    Caption = #1060#1048#1054
  end
  object edName: TcxTextEdit
    Left = 21
    Top = 41
    TabOrder = 1
    Width = 321
  end
  object ceUnit: TcxButtonEdit
    Left = 22
    Top = 212
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 320
  end
  object cxLabel12: TcxLabel
    Left = 21
    Top = 189
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cePosition: TcxButtonEdit
    Left = 21
    Top = 149
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Text = 'TPositionForm'
    Width = 321
  end
  object cxLabel11: TcxLabel
    Left = 21
    Top = 130
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object edLogin: TcxTextEdit
    Left = 22
    Top = 265
    TabOrder = 5
    Width = 321
  end
  object cxLabel3: TcxLabel
    Left = 22
    Top = 246
    Caption = #1051#1086#1075#1080#1085
  end
  object edPassword: TcxTextEdit
    Left = 21
    Top = 321
    TabOrder = 6
    Width = 321
  end
  object cxLabel4: TcxLabel
    Left = 21
    Top = 302
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object cxButton2: TcxButton
    Left = 224
    Top = 363
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 8
  end
  object cxButton1: TcxButton
    Left = 62
    Top = 363
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 7
  end
  object ceInternshipCompleted: TcxCheckBox
    Left = 193
    Top = 8
    Caption = #1057#1090#1072#1078#1080#1088#1086#1074#1082#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1072
    TabOrder = 14
    Width = 149
  end
  object ceisSite: TcxCheckBox
    Left = 105
    Top = 8
    Caption = #1044#1083#1103' '#1089#1072#1081#1090#1072
    TabOrder = 15
    Width = 82
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 276
    Top = 135
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
    Left = 277
    Top = 21
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 279
    Top = 79
  end
  object UnitGuides: TdsdGuides
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
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 183
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
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
    Left = 127
    Top = 136
  end
  object ActionList: TActionList
    Left = 128
    Top = 24
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'dsdFormClose1'
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actShowPUSHMessageInfo
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
    object actExitName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_ExitName
      StoredProcList = <
        item
          StoredProc = spGet_ExitName
        end>
      Caption = 'actExitName'
    end
    object actShowPUSHMessageInfo: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHInfo
      StoredProcList = <
        item
          StoredProc = spPUSHInfo
        end>
      Caption = 'actShowPUSHMessageInfo'
    end
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_User_NewUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = Null
        Component = edPhone
        DataType = ftString
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
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Login'
        Value = Null
        Component = edLogin
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = 0.000000000000000000
        Component = edPassword
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 192
  end
  object HeaderExitName: THeaderExit
    ExitList = <
      item
        Control = edName
      end>
    Action = actExitName
    Left = 128
    Top = 248
  end
  object spGet_ExitName: TdsdStoredProc
    StoredProcName = 'gpGet_Object_User_ExitName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLogin'
        Value = Null
        Component = edLogin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Login'
        Value = ''
        Component = edLogin
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 248
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_NewUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = 0.000000000000000000
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = ''
        Component = edPhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLogin'
        Value = ''
        Component = edLogin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassword'
        Value = 'False'
        Component = edPassword
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInternshipCompleted'
        Value = Null
        Component = ceInternshipCompleted
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSite'
        Value = Null
        Component = ceisSite
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 80
  end
  object spPUSHInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_NewUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUserID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 274
    Top = 304
  end
end
