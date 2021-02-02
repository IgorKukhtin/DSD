object PartnerEditForm: TPartnerEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <Lieferanten>'
  ClientHeight = 431
  ClientWidth = 571
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 550
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 54
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 166
    Top = 409
    Width = 75
    Height = 25
    Action = actInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 310
    Top = 409
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 130
  end
  object cxLabel3: TcxLabel
    Left = 287
    Top = 274
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 287
    Top = 294
    TabOrder = 7
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 97
    Caption = #1060#1072#1082#1089
  end
  object edFax: TcxTextEdit
    Left = 10
    Top = 117
    TabOrder = 9
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 287
    Top = 97
    Caption = #1058#1077#1083'. '#1085#1086#1084#1077#1088
  end
  object edPhone: TcxTextEdit
    Left = 287
    Top = 117
    TabOrder = 11
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 143
    Caption = #1052#1086#1073#1080#1083#1100#1085#1099#1081
  end
  object edMobile: TcxTextEdit
    Left = 10
    Top = 163
    TabOrder = 13
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 287
    Top = 143
    Caption = #1056'/ '#1089#1095#1077#1090
  end
  object edIBAN: TcxTextEdit
    Left = 287
    Top = 163
    TabOrder = 15
    Width = 273
  end
  object cxLabel8: TcxLabel
    Left = 10
    Top = 187
    Caption = #1059#1083#1080#1094#1072
  end
  object edStreet: TcxTextEdit
    Left = 10
    Top = 207
    TabOrder = 17
    Width = 273
  end
  object cxLabel9: TcxLabel
    Left = 287
    Top = 187
    Caption = #1050#1086#1085#1090#1072#1085#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
  end
  object edMember: TcxTextEdit
    Left = 287
    Top = 207
    TabOrder = 19
    Width = 273
  end
  object cxLabel10: TcxLabel
    Left = 10
    Top = 230
    Caption = #1040#1076#1088#1077#1089' '#1089#1072#1081#1090#1072
  end
  object edWWW: TcxTextEdit
    Left = 10
    Top = 250
    TabOrder = 21
    Width = 273
  end
  object cxLabel11: TcxLabel
    Left = 287
    Top = 230
    Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
  end
  object edEmail: TcxTextEdit
    Left = 287
    Top = 250
    TabOrder = 23
    Width = 273
  end
  object cxLabel12: TcxLabel
    Left = 10
    Top = 274
    Caption = #1053#1072#1096' '#1082#1086#1076' '#1074' '#1080#1093' '#1073#1072#1079#1077
  end
  object edCodeDB: TcxTextEdit
    Left = 10
    Top = 294
    TabOrder = 25
    Width = 273
  end
  object cxLabel13: TcxLabel
    Left = 10
    Top = 321
    Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1072#1076#1088#1077#1089
  end
  object edPLZ: TcxButtonEdit
    Left = 10
    Top = 338
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 273
  end
  object cxLabel14: TcxLabel
    Left = 287
    Top = 321
    Caption = #1041#1072#1085#1082
  end
  object edBank: TcxButtonEdit
    Left = 287
    Top = 338
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 273
  end
  object cxLabel15: TcxLabel
    Left = 10
    Top = 363
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object edInfoMoney: TcxButtonEdit
    Left = 10
    Top = 380
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 273
  end
  object cxLabel16: TcxLabel
    Left = 287
    Top = 363
    Caption = #1058#1080#1087' '#1053#1044#1057
  end
  object edTaxKind: TcxButtonEdit
    Left = 287
    Top = 380
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 33
    Width = 273
  end
  object ceDiscountTax: TcxCurrencyEdit
    Left = 153
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 34
    Width = 130
  end
  object Код: TcxLabel
    Left = 151
    Top = 8
    Caption = '% '#1089#1082#1080#1076#1082#1080
  end
  object ceDayCalendar: TcxCurrencyEdit
    Left = 287
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 36
    Width = 130
  end
  object cxLabel17: TcxLabel
    Left = 287
    Top = 8
    Hint = #1054#1090#1089#1088#1086#1095#1082#1072' '#1074' '#1082#1072#1083#1077#1085#1076#1072#1088#1085#1099#1093' '#1076#1085#1103#1093
    Caption = #1054#1090#1089#1088'. '#1074' '#1082#1072#1083#1077#1085#1076'. '#1076#1085'.'
    ParentShowHint = False
    ShowHint = True
  end
  object ceDayBank: TcxCurrencyEdit
    Left = 430
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 38
    Width = 130
  end
  object cxLabel18: TcxLabel
    Left = 430
    Top = 8
    Hint = #1054#1090#1089#1088#1086#1095#1082#1072' '#1074' '#1073#1072#1085#1082#1086#1074#1089#1082#1080#1093' '#1076#1085#1103#1093
    Caption = #1054#1090#1089#1088'. '#1074' '#1073#1072#1085#1082'. '#1076#1085'.'
  end
  object ActionList: TActionList
    Left = 152
    Top = 99
    object actDataSetRefresh: TdsdDataSetRefresh
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
    object actInsertUpdateGuides: TdsdInsertUpdateGuides
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
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Partner'
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
        Value = 0.000000000000000000
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
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFax'
        Value = Null
        Component = edFax
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
        Name = 'inMobile'
        Value = Null
        Component = edMobile
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIBAN'
        Value = Null
        Component = edIBAN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStreet'
        Value = Null
        Component = edStreet
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMember'
        Value = Null
        Component = edMember
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWWW'
        Value = Null
        Component = edWWW
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmail'
        Value = Null
        Component = edEmail
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeDB'
        Value = Null
        Component = edCodeDB
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayCalendar'
        Value = Null
        Component = ceDayCalendar
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayBank'
        Value = Null
        Component = ceDayBank
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPLZId'
        Value = Null
        Component = GuidesPLZ
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 91
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 64
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Partner'
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        DataType = ftUnknown
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
        Name = 'CodeDB'
        Value = Null
        Component = edCodeDB
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Email'
        Value = Null
        Component = edEmail
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Fax'
        Value = Null
        Component = edFax
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IBAN'
        Value = Null
        Component = edIBAN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member'
        Value = Null
        Component = edMember
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Mobile'
        Value = Null
        Component = edMobile
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
        Name = 'Street'
        Value = Null
        Component = edStreet
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'WWW'
        Value = Null
        Component = edWWW
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PLZId'
        Value = Null
        Component = GuidesPLZ
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PLZName'
        Value = Null
        Component = GuidesPLZ
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = ceDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCalendar'
        Value = Null
        Component = ceDayCalendar
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayBank'
        Value = Null
        Component = ceDayBank
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
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
    Left = 160
    Top = 147
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 104
    Top = 147
  end
  object GuidesPLZ: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPLZ
    FormNameParam.Value = 'TPLZForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPLZForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPLZ
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPLZ
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 325
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBank
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 477
    Top = 325
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 359
  end
  object GuidesTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind
    FormNameParam.Value = 'TTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 469
    Top = 359
  end
end
