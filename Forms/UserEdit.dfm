object UserEditForm: TUserEditForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  ClientHeight = 261
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  isAlwaysRefresh = True
  isFree = False
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
    Left = 45
    Top = 218
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 189
    Top = 218
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
    Top = 157
    Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edMember: TcxButtonEdit
    Left = 13
    Top = 180
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
    Top = 124
    Properties.PasswordChar = '*'
    TabOrder = 8
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 13
    Top = 101
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object ActionList: TActionList
    Left = 269
    Top = 72
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
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
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPassword'
        Value = ''
        Component = edPassword
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId'
        Value = ''
        Component = MemberGuides
        ParamType = ptInput
      end>
    Left = 213
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'MemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Password'
        Value = ''
        Component = edPassword
        DataType = ftString
      end>
    Left = 165
    Top = 136
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
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
