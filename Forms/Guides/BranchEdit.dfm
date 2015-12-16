﻿object BranchEditForm: TBranchEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1060#1080#1083#1080#1072#1083'>'
  ClientHeight = 204
  ClientWidth = 336
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
    Left = 21
    Top = 76
    TabOrder = 0
    Width = 284
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 55
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 56
    Top = 167
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 167
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 21
    Top = 10
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 21
    Top = 31
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 130
  end
  object edInvNumber: TcxTextEdit
    Left = 159
    Top = 31
    TabOrder = 6
    Width = 146
  end
  object cxLabel2: TcxLabel
    Left = 159
    Top = 10
    Caption = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1082#1086#1076
  end
  object cbIsMedoc: TcxCheckBox
    Left = 21
    Top = 106
    Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1080#1079' '#1084#1077#1076#1082#1072
    TabOrder = 8
    Width = 180
  end
  object cbisPartionDoc: TcxCheckBox
    Left = 21
    Top = 133
    Caption = #1055#1072#1088#1090#1080#1086#1085#1085#1099#1081' '#1091#1095#1077#1090' '#1076#1086#1083#1075#1086#1074' '#1085#1072#1083
    TabOrder = 9
    Width = 180
  end
  object ActionList: TActionList
    Left = 256
    Top = 24
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
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
      Caption = #1054#1082
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Branch'
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
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inIsMedoc'
        Value = Null
        Component = cbIsMedoc
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inisPartionDoc'
        Value = Null
        Component = cbisPartionDoc
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 293
    Top = 61
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Top = 96
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Branch'
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
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'IsMedoc'
        Value = Null
        Component = cbIsMedoc
        DataType = ftBoolean
      end
      item
        Name = 'IsPartionDoc'
        Value = Null
        Component = cbisPartionDoc
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 224
    Top = 98
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
      end
      item
        Properties.Strings = (
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 296
    Top = 133
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 48
  end
end
