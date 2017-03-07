object DiscountToolsEditForm: TDiscountToolsEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1086#1094#1077#1085#1090#1086#1074' '#1087#1086' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1099#1084' '#1089#1082#1080#1076#1082#1072#1084'>'
  ClientHeight = 241
  ClientWidth = 295
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
  object cxButton1: TcxButton
    Left = 39
    Top = 192
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 4
  end
  object cxButton2: TcxButton
    Left = 183
    Top = 192
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
  end
  object cxLabel3: TcxLabel
    Left = 9
    Top = 129
    Caption = #1053#1072#1079#1074#1072#1085#1080#1103' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
  end
  object ceDiscountName: TcxButtonEdit
    Left = 7
    Top = 145
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 11
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
  end
  object edStartSumm: TcxCurrencyEdit
    Left = 8
    Top = 28
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 0
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 51
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
  end
  object edEndSumm: TcxCurrencyEdit
    Left = 8
    Top = 68
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = '0'
    TabOrder = 1
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 89
    Caption = #1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080
  end
  object edDiscountTax: TcxCurrencyEdit
    Left = 8
    Top = 106
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = '0'
    TabOrder = 2
    Width = 273
  end
  object ActionList: TActionList
    Left = 176
    Top = 8
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_DiscountTools'
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
        Name = 'inStartSumm'
        Value = Null
        Component = edStartSumm
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSumm'
        Value = Null
        Component = edEndSumm
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = edDiscountTax
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountId'
        Value = Null
        Component = DiscountToolsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 60
    Top = 80
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 56
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_DiscountTools'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartSumm'
        Value = Null
        Component = edStartSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndSumm'
        Value = Null
        Component = edEndSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountId'
        Value = Null
        Component = DiscountToolsGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountName'
        Value = Null
        Component = DiscountToolsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 8
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
    Left = 228
    Top = 96
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 94
    Top = 176
  end
  object DiscountToolsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDiscountName
    FormNameParam.Value = 'TDiscountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DiscountToolsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DiscountToolsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 214
    Top = 149
  end
end
