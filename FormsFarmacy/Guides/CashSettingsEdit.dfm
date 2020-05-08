object CashSettingsEditForm: TCashSettingsEditForm
  Left = 0
  Top = 0
  Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
  ClientHeight = 252
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edShareFromPriceName: TcxTextEdit
    Left = 16
    Top = 39
    TabOrder = 0
    Width = 509
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 19
    Caption = 
      #1055#1077#1088#1077#1095#1077#1085#1100' '#1092#1088#1072#1079' '#1074' '#1085#1072#1079#1074#1072#1085#1080#1103#1093' '#1090#1086#1074#1072#1088#1086#1074' '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1078#1085#1086' '#1076#1077#1083#1080#1090#1100' '#1089' '#1083#1102#1073#1086#1081' '#1094 +
      #1077#1085#1086#1081
  end
  object cxButton1: TcxButton
    Left = 159
    Top = 207
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 309
    Top = 207
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object edShareFromPriceCode: TcxTextEdit
    Left = 16
    Top = 87
    TabOrder = 4
    Width = 509
  end
  object cxLabel2: TcxLabel
    Left = 16
    Top = 67
    Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1082#1086#1076#1086#1074' '#1090#1086#1074#1072#1088#1086#1074' '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1078#1085#1086' '#1076#1077#1083#1080#1090#1100' '#1089' '#1083#1102#1073#1086#1081' '#1094#1077#1085#1086#1081
  end
  object cbGetHardwareData: TcxCheckBox
    Left = 16
    Top = 118
    Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Width = 233
  end
  object edDateBanSUN: TcxDateEdit
    Left = 191
    Top = 154
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 90
  end
  object cxLabel11: TcxLabel
    Left = 16
    Top = 155
    Caption = ' '#1044#1072#1090#1072' '#1079#1072#1087#1088#1077#1090#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1059#1053' '
  end
  object ActionList: TActionList
    Left = 344
    Top = 76
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
    StoredProcName = 'gpInsertUpdate_Object_CashSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inShareFromPriceName'
        Value = ''
        Component = edShareFromPriceName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShareFromPriceCode'
        Value = 0.000000000000000000
        Component = edShareFromPriceCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGetHardwareData'
        Value = Null
        Component = cbGetHardwareData
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateBanSUN'
        Value = 'NULL'
        Component = edDateBanSUN
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 80
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CashSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ShareFromPriceName'
        Value = ''
        Component = edShareFromPriceName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShareFromPriceCode'
        Value = 0.000000000000000000
        Component = edShareFromPriceCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGetHardwareData'
        Value = Null
        Component = cbGetHardwareData
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBanSUN'
        Value = 'NULL'
        Component = edDateBanSUN
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 328
    Top = 15
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
    Left = 384
    Top = 16
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 448
    Top = 136
  end
end
