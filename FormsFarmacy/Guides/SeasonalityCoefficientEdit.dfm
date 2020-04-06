object SeasonalityCoefficientEditForm: TSeasonalityCoefficientEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080'>'
  ClientHeight = 320
  ClientWidth = 400
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
  object edName: TcxTextEdit
    Left = 8
    Top = 80
    TabOrder = 1
    Width = 378
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 61
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 86
    Top = 275
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 3
  end
  object cxButton2: TcxButton
    Left = 230
    Top = 275
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 29
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 376
  end
  object ceKoeff1: TcxCurrencyEdit
    Left = 8
    Top = 135
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 6
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 116
    Caption = #1071#1085#1074#1072#1088#1100
  end
  object ceKoeff2: TcxCurrencyEdit
    Left = 8
    Top = 183
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 90
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 164
    Caption = #1060#1077#1074#1088#1072#1083#1100
  end
  object ceKoeff3: TcxCurrencyEdit
    Left = 8
    Top = 239
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 10
    Width = 90
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 220
    Caption = #1052#1072#1088#1090
  end
  object ceKoeff4: TcxCurrencyEdit
    Left = 104
    Top = 135
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 12
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 104
    Top = 116
    Caption = #1040#1087#1088#1077#1083#1100
  end
  object ceKoeff5: TcxCurrencyEdit
    Left = 104
    Top = 183
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 90
  end
  object cxLabel7: TcxLabel
    Left = 104
    Top = 164
    Caption = #1052#1072#1081
  end
  object ceKoeff6: TcxCurrencyEdit
    Left = 104
    Top = 239
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 90
  end
  object cxLabel8: TcxLabel
    Left = 104
    Top = 220
    Caption = #1048#1102#1085#1100
  end
  object ceKoeff7: TcxCurrencyEdit
    Left = 200
    Top = 135
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 18
    Width = 90
  end
  object cxLabel9: TcxLabel
    Left = 200
    Top = 116
    Caption = #1048#1102#1083#1100
  end
  object ceKoeff8: TcxCurrencyEdit
    Left = 200
    Top = 183
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 20
    Width = 90
  end
  object cxLabel10: TcxLabel
    Left = 200
    Top = 164
    Caption = #1040#1074#1075#1091#1089#1090
  end
  object ceKoeff9: TcxCurrencyEdit
    Left = 200
    Top = 239
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 22
    Width = 90
  end
  object cxLabel11: TcxLabel
    Left = 200
    Top = 220
    Caption = #1057#1077#1085#1090#1103#1073#1088#1100
  end
  object ceKoeff10: TcxCurrencyEdit
    Left = 296
    Top = 135
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 24
    Width = 90
  end
  object cxLabel12: TcxLabel
    Left = 296
    Top = 116
    Caption = #1054#1082#1090#1103#1073#1088#1100
  end
  object ceKoeff11: TcxCurrencyEdit
    Left = 296
    Top = 183
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 26
    Width = 90
  end
  object cxLabel13: TcxLabel
    Left = 296
    Top = 164
    Caption = #1053#1086#1103#1073#1088#1100
  end
  object ceKoeff12: TcxCurrencyEdit
    Left = 296
    Top = 239
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 28
    Width = 90
  end
  object cxLabel14: TcxLabel
    Left = 296
    Top = 220
    Caption = #1044#1077#1082#1072#1073#1088#1100
  end
  object ActionList: TActionList
    Left = 208
    Top = 88
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
    StoredProcName = 'gpInsertUpdate_Object_SeasonalityCoefficient'
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
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'Koeff1'
        Value = Null
        Component = ceKoeff1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff2'
        Value = Null
        Component = ceKoeff2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff3'
        Value = Null
        Component = ceKoeff3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff4'
        Value = Null
        Component = ceKoeff4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff5'
        Value = Null
        Component = ceKoeff5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff6'
        Value = Null
        Component = ceKoeff6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff7'
        Value = Null
        Component = ceKoeff7
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff8'
        Value = Null
        Component = ceKoeff8
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff9'
        Value = Null
        Component = ceKoeff9
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff10'
        Value = Null
        Component = ceKoeff10
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff11'
        Value = Null
        Component = ceKoeff11
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff12'
        Value = Null
        Component = ceKoeff12
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 104
    Top = 64
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_SeasonalityCoefficient'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'Koeff1'
        Value = Null
        Component = ceKoeff1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff2'
        Value = Null
        Component = ceKoeff2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff3'
        Value = Null
        Component = ceKoeff3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff4'
        Value = Null
        Component = ceKoeff4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff5'
        Value = Null
        Component = ceKoeff5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff6'
        Value = Null
        Component = ceKoeff6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff7'
        Value = Null
        Component = ceKoeff7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff8'
        Value = Null
        Component = ceKoeff8
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff9'
        Value = Null
        Component = ceKoeff9
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff10'
        Value = Null
        Component = ceKoeff10
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff11'
        Value = Null
        Component = ceKoeff11
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Koeff12'
        Value = Null
        Component = ceKoeff12
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 185
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
    Left = 176
    Top = 184
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 248
    Top = 16
  end
end
