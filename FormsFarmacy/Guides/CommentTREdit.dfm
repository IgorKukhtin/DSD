﻿object CommentTREditForm: TCommentTREditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1089#1090#1088#1086#1082' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1077#1088#1077#1091#1095#1077#1090#1072'>'
  ClientHeight = 269
  ClientWidth = 439
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
    Left = 20
    Top = 71
    TabOrder = 0
    Width = 400
  end
  object cxLabel1: TcxLabel
    Left = 20
    Top = 48
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 91
    Top = 218
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 241
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
    Left = 20
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 20
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 400
  end
  object cbisExplanation: TcxCheckBox
    Left = 20
    Top = 105
    Caption = ' '#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1086#1077' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1087#1086#1103#1089#1085#1077#1085#1080#1103' '
    TabOrder = 6
    Width = 245
  end
  object cbisResort: TcxCheckBox
    Left = 20
    Top = 130
    Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1087#1077#1088#1077#1089#1086#1088#1090#1072
    TabOrder = 7
    Width = 146
  end
  object cbisDifferenceSum: TcxCheckBox
    Left = 20
    Top = 156
    Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1087#1077#1088#1077#1089#1086#1088#1090#1072' '#1074' '#1089#1091#1084#1084#1077
    TabOrder = 8
    Width = 181
  end
  object cxLabel9: TcxLabel
    Left = 219
    Top = 156
    Caption = ' '#1044#1086#1087#1091#1089#1090#1080#1084#1072#1103' '#1088#1072#1079#1085#1080#1094#1072' '
  end
  object edDifferenceSum: TcxCurrencyEdit
    Left = 340
    Top = 155
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 80
  end
  object cbisBlockFormSUN: TcxCheckBox
    Left = 20
    Top = 183
    Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1057#1059#1053' '#1087#1088#1080' '#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1093' '#1058#1055
    TabOrder = 11
    Width = 325
  end
  object ActionList: TActionList
    Left = 252
    Top = 20
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
    StoredProcName = 'gpInsertUpdate_Object_CommentTR'
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
        Name = 'isExplanation'
        Value = Null
        Component = cbisExplanation
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisResort'
        Value = Null
        Component = cbisResort
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDifferenceSum'
        Value = Null
        Component = cbisDifferenceSum
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDifferenceSum'
        Value = Null
        Component = edDifferenceSum
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBlockFormSUN'
        Value = Null
        Component = cbisBlockFormSUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 188
    Top = 56
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 4
    Top = 32
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CommentTR'
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
        Name = 'isExplanation'
        Value = Null
        Component = cbisExplanation
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isResort'
        Value = Null
        Component = cbisResort
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDifferenceSum'
        Value = Null
        Component = cbisDifferenceSum
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DifferenceSum'
        Value = Null
        Component = edDifferenceSum
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBlockFormSUN'
        Value = Null
        Component = cbisBlockFormSUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 324
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 188
    Top = 7
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
    Left = 324
    Top = 64
  end
end
