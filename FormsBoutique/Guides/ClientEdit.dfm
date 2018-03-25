object ClientEditForm: TClientEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1080'>'
  ClientHeight = 497
  ClientWidth = 294
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
    Top = 69
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 52
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 37
    Top = 457
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 12
  end
  object cxButton2: TcxButton
    Left = 168
    Top = 457
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 13
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 8
    Top = 24
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 99
    Caption = #1053#1086#1084#1077#1088' '#1082#1072#1088#1090#1099
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 232
    Caption = #1040#1076#1088#1077#1089
  end
  object edAddress: TcxTextEdit
    Left = 8
    Top = 251
    TabOrder = 6
    Width = 273
  end
  object edDiscountCard: TcxTextEdit
    Left = 8
    Top = 117
    TabOrder = 1
    Width = 135
  end
  object edPhoneMobile: TcxTextEdit
    Left = 8
    Top = 295
    TabOrder = 7
    Width = 135
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 278
    Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085
  end
  object edPhone: TcxTextEdit
    Left = 144
    Top = 295
    TabOrder = 8
    Width = 133
  end
  object cxLabel6: TcxLabel
    Left = 144
    Top = 278
    Caption = #1058#1077#1083#1077#1092#1086#1085', '#1076#1088#1091#1075#1086#1081
  end
  object ceCity: TcxButtonEdit
    Left = 8
    Top = 207
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 189
    Caption = #1043#1086#1088#1086#1076
  end
  object edDiscountTax: TcxCurrencyEdit
    Left = 8
    Top = 166
    Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
    EditValue = '0'
    ParentShowHint = False
    Properties.DecimalPlaces = 1
    Properties.DisplayFormat = '0.0 %'
    ShowHint = True
    TabOrder = 3
    Width = 135
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 143
    Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
    Caption = '% '#1089#1082#1080#1076#1082#1080
  end
  object cxLabel9: TcxLabel
    Left = 148
    Top = 143
    Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1063#1072#1076#1086' '#1085#1072' '#1043#1088#1091#1087#1087#1091' <'#1054#1073#1091#1074#1100'>'
    Caption = '% '#1089#1082#1080#1076#1082#1080' '#1054#1073#1091#1074#1100
    ParentShowHint = False
    ShowHint = True
  end
  object edDiscountTaxTwo: TcxCurrencyEdit
    Left = 148
    Top = 166
    Hint = '% '#1089#1082#1080#1076#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1063#1072#1076#1086' '#1085#1072' '#1043#1088#1091#1087#1087#1091' <'#1054#1073#1091#1074#1100'>'
    EditValue = 0.000000000000000000
    ParentShowHint = False
    Properties.DecimalPlaces = 1
    Properties.DisplayFormat = '0.0 %'
    ShowHint = True
    TabOrder = 4
    Width = 133
  end
  object edHappyDate: TcxDateEdit
    Left = 148
    Top = 117
    Hint = #1044#1072#1090#1072'.'#1052#1077#1089#1103#1094
    EditValue = 42796d
    ParentShowHint = False
    Properties.DisplayFormat = 'DD.MM'
    Properties.SaveTime = False
    Properties.ShowTime = False
    ShowHint = True
    TabOrder = 2
    Width = 133
  end
  object cxLabel10: TcxLabel
    Left = 148
    Top = 99
    Hint = #1044#1072#1090#1072'.'#1052#1077#1089#1103#1094
    Caption = #1044#1077#1085#1100' '#1088#1086#1078#1076#1077#1085#1080#1103
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel11: TcxLabel
    Left = 8
    Top = 320
    Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
  end
  object edMail: TcxTextEdit
    Left = 8
    Top = 337
    TabOrder = 9
    Width = 273
  end
  object cxLabel12: TcxLabel
    Left = 8
    Top = 399
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 8
    Top = 417
    TabOrder = 11
    Width = 273
  end
  object ceDiscountKind: TcxButtonEdit
    Left = 8
    Top = 377
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 273
  end
  object cxLabel13: TcxLabel
    Left = 8
    Top = 359
    Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
  end
  object ActionList: TActionList
    Left = 166
    Top = 321
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
    StoredProcName = 'gpInsertUpdate_Object_Client'
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
        Name = 'ioCode'
        Value = 0
        Component = edCode
        ParamType = ptInputOutput
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
        Name = 'inDiscountCard'
        Value = Null
        Component = edDiscountCard
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTaxTwo'
        Value = Null
        Component = edDiscountTaxTwo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHappyDate'
        Value = 'NULL'
        Component = edHappyDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhoneMobile'
        Value = Null
        Component = edPhoneMobile
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhone'
        Value = Null
        Component = edPhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMail'
        Value = Null
        Component = edMail
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCityId'
        Value = Null
        Component = CityGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountKindId'
        Value = Null
        Component = DiscountKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 86
    Top = 233
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 70
    Top = 177
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Client'
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
        Name = 'Code'
        Value = 0
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
        Name = 'DiscountCard'
        Value = Null
        Component = edDiscountCard
        DataType = ftString
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
        Name = 'DiscountTaxTwo'
        Value = Null
        Component = edDiscountTaxTwo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HappyDate'
        Value = 'NULL'
        Component = edHappyDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhoneMobile'
        Value = Null
        Component = edPhoneMobile
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
        Name = 'Mail'
        Value = Null
        Component = edMail
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityId'
        Value = Null
        Component = CityGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName'
        Value = Null
        Component = CityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountKindId'
        Value = Null
        Component = DiscountKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountKindName'
        Value = Null
        Component = DiscountKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 150
    Top = 177
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
    Left = 102
    Top = 337
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 78
    Top = 281
  end
  object CityGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCity
    FormNameParam.Value = 'TCityForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCityForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CityGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 60
    Top = 329
  end
  object DiscountKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDiscountKind
    FormNameParam.Value = 'TDiscountKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DiscountKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DiscountKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 148
    Top = 379
  end
end
