﻿object UserHelsiEditForm: TUserHelsiEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1089#1090#1091#1087' '#1082' '#1089#1072#1081#1090#1091' '#1093#1077#1083#1089#1080
  ClientHeight = 405
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
    TabStop = False
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 13
    Top = 48
    Caption = #1051#1086#1075#1080#1085
  end
  object cxButton1: TcxButton
    Left = 54
    Top = 363
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 5
  end
  object cxButton2: TcxButton
    Left = 189
    Top = 363
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 6
  end
  object Код: TcxLabel
    Left = 13
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 13
    Top = 26
    TabStop = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 185
  end
  object cxLabel3: TcxLabel
    Left = 13
    Top = 102
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1079#1072#1088#1077#1075#1077#1089#1090#1088#1080#1088#1086#1074#1072#1085' '#1082#1083#1102#1095
  end
  object edUnit: TcxButtonEdit
    Left = 13
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 0
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 13
    Top = 154
    Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1085#1072' '#1089#1072#1081#1090#1077' '#1061#1077#1083#1089#1080
  end
  object edUserName: TcxTextEdit
    Left = 13
    Top = 175
    Properties.PasswordChar = '*'
    TabOrder = 1
    Width = 273
  end
  object edUserPassword: TcxTextEdit
    Left = 13
    Top = 223
    Properties.PasswordChar = '*'
    TabOrder = 2
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 13
    Top = 202
    Caption = #1055#1072#1088#1086#1083#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1085#1072' '#1089#1072#1081#1090#1077' '#1061#1077#1083#1089#1080
  end
  object cxLabel6: TcxLabel
    Left = 13
    Top = 250
    Caption = #1060#1072#1081#1083#1086#1074#1099#1081' '#1082#1083#1102#1095#1100
  end
  object cxLabel7: TcxLabel
    Left = 13
    Top = 297
    Caption = #1055#1072#1088#1086#1083#1100' '#1082' '#1092#1072#1081#1083#1086#1074#1086#1084#1091' '#1082#1083#1102#1095#1091
  end
  object edKeyPassword: TcxTextEdit
    Left = 13
    Top = 320
    Properties.PasswordChar = '*'
    TabOrder = 4
    Width = 273
  end
  object edKey: TcxButtonEdit
    Left = 13
    Top = 271
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 273
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
    StoredProcName = 'gpInsertUpdate_Object_HelsiUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
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
        Name = 'inUserName'
        Value = Null
        Component = edUserName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserPassword'
        Value = Null
        Component = edUserPassword
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKey'
        Value = Null
        Component = edKey
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKeyPassword'
        Value = Null
        Component = edKeyPassword
        DataType = ftString
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
    Left = 133
    Top = 80
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_HelsiUser'
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
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = edUserName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserPassword'
        Value = Null
        Component = edUserPassword
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        Component = edKey
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'KeyPassword'
        Value = Null
        Component = edKeyPassword
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 165
    Top = 136
  end
  object UnitGuides: TdsdGuides
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
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 85
    Top = 125
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
  object dsdFileToBase641: TdsdFileToBase64
    LookupControl = edKey
    Left = 176
    Top = 256
  end
end
