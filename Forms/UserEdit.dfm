object UserEditForm: TUserEditForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  ClientHeight = 476
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 13
    Top = 71
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 13
    Top = 48
    Caption = #1051#1086#1075#1080#1085
  end
  object cxButton1: TcxButton
    Left = 37
    Top = 443
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 181
    Top = 443
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 13
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 13
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 13
    Top = 151
    Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edMember: TcxButtonEdit
    Left = 13
    Top = 171
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 273
  end
  object edPassword: TcxTextEdit
    Left = 13
    Top = 121
    Properties.PasswordChar = '*'
    TabOrder = 8
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 13
    Top = 101
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object cxLabel4: TcxLabel
    Left = 13
    Top = 203
    Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1076#1087#1080#1089#1100
  end
  object edSign: TcxTextEdit
    Left = 13
    Top = 224
    Properties.PasswordChar = '*'
    TabOrder = 11
    Width = 273
  end
  object edSeal: TcxTextEdit
    Left = 13
    Top = 270
    Properties.PasswordChar = '*'
    TabOrder = 12
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 13
    Top = 251
    Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1077#1095#1072#1090#1100
  end
  object edKey: TcxTextEdit
    Left = 13
    Top = 320
    Properties.PasswordChar = '*'
    TabOrder = 14
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 13
    Top = 299
    Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1099#1081' '#1050#1083#1102#1095
  end
  object cxLabel7: TcxLabel
    Left = 13
    Top = 346
    Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#8470' '#1084#1086#1073' '#1091#1089#1090#1088'-'#1074#1072
  end
  object edProjectMobile: TcxTextEdit
    Left = 13
    Top = 367
    Properties.PasswordChar = '*'
    TabOrder = 17
    Width = 185
  end
  object ceisProjectMobile: TcxCheckBox
    Left = 204
    Top = 367
    Caption = #1058#1086#1088#1075'. '#1072#1075#1077#1085#1090
    TabOrder = 18
    Width = 82
  end
  object cxLabel8: TcxLabel
    Left = 118
    Top = 448
    Caption = #8470' '#1090#1077#1083#1077#1092#1086#1085#1072' '#1076#1083#1103' '#1040#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1080
    Visible = False
  end
  object edPhoneAuthent: TcxTextEdit
    Left = 71
    Top = 458
    Properties.PasswordChar = '*'
    TabOrder = 20
    Visible = False
    Width = 185
  end
  object cbisProjectAuthent: TcxCheckBox
    Left = 13
    Top = 404
    Caption = #1040#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1103' - Google Authenticator'
    TabOrder = 21
    Width = 257
  end
  object ActionList: TActionList
    Left = 269
    Top = 72
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassword'
        Value = ''
        Component = edPassword
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSign'
        Value = Null
        Component = edSign
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSeal'
        Value = Null
        Component = edSeal
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKey'
        Value = Null
        Component = edKey
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProjectMobile'
        Value = Null
        Component = edProjectMobile
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhoneAuthent'
        Value = Null
        Component = edPhoneAuthent
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisProjectMobile'
        Value = Null
        Component = ceisProjectMobile
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisProjectAuthent'
        Value = Null
        Component = cbisProjectAuthent
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 213
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 213
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = ''
        Component = edPassword
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserSign'
        Value = Null
        Component = edSign
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserSeal'
        Value = Null
        Component = edSeal
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserKey'
        Value = Null
        Component = edKey
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProjectMobile'
        Value = Null
        Component = edProjectMobile
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isProjectMobile'
        Value = Null
        Component = ceisProjectMobile
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneAuthent'
        Value = Null
        Component = edPhoneAuthent
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isProjectAuthent'
        Value = Null
        Component = cbisProjectAuthent
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 165
    Top = 136
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 85
    Top = 173
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 237
    Top = 176
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 221
    Top = 136
  end
end
