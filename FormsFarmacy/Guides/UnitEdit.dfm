object UnitEditForm: TUnitEditForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ClientHeight = 665
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = DataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 255
    Top = 26
    TabOrder = 0
    Width = 209
  end
  object cxLabel1: TcxLabel
    Left = 255
    Top = 3
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 99
    Top = 628
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 293
    Top = 628
    Width = 75
    Height = 25
    Action = FormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 15
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 15
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 217
  end
  object cxLabel3: TcxLabel
    Left = 15
    Top = 50
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object ceParent: TcxButtonEdit
    Left = 15
    Top = 73
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 217
  end
  object cxLabel5: TcxLabel
    Left = 255
    Top = 49
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 255
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 209
  end
  object cxLabel2: TcxLabel
    Left = 15
    Top = 102
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1076#1083#1103' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080
  end
  object edMarginCategory: TcxButtonEdit
    Left = 15
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 217
  end
  object cxLabel4: TcxLabel
    Left = 15
    Top = 156
    Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080
  end
  object ceTaxService: TcxCurrencyEdit
    Left = 15
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 90
  end
  object cbRepriceAuto: TcxCheckBox
    Left = 255
    Top = 121
    Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
    Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072
    TabOrder = 15
    Width = 113
  end
  object cxLabel6: TcxLabel
    Left = 142
    Top = 156
    Caption = '% '#1074' '#1085#1086#1095#1085'. '#1089#1084'.'
  end
  object ceTaxServiceNigth: TcxCurrencyEdit
    Left = 142
    Top = 175
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 17
    Width = 90
  end
  object cxLabel7: TcxLabel
    Left = 255
    Top = 156
    Caption = #1053#1072#1095'. '#1085#1086#1095'. '#1089#1084#1077#1085#1099
  end
  object cxLabel8: TcxLabel
    Left = 367
    Top = 156
    Caption = #1054#1082#1086#1085'. '#1085#1086#1095'. '#1089#1084#1077#1085#1099
  end
  object edEndServiceNigth: TcxDateEdit
    Left = 364
    Top = 175
    EditValue = 43234d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    TabOrder = 20
    Width = 100
  end
  object edStartServiceNigth: TcxDateEdit
    Left = 255
    Top = 175
    EditValue = 43225d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DateOnError = deNull
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    Properties.Nullstring = ' '
    Properties.YearsInMonthList = False
    TabOrder = 21
    Width = 100
  end
  object cxLabel9: TcxLabel
    Left = 15
    Top = 243
    Caption = #1040#1076#1088#1077#1089
  end
  object edAddress: TcxTextEdit
    Left = 15
    Top = 260
    TabOrder = 23
    Width = 217
  end
  object cxLabel10: TcxLabel
    Left = 255
    Top = 289
    Caption = #1056#1072#1081#1086#1085
  end
  object ceProvinceCity: TcxButtonEdit
    Left = 255
    Top = 305
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 25
    Width = 209
  end
  object cxLabel11: TcxLabel
    Left = 15
    Top = 339
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
  end
  object edCreateDate: TcxDateEdit
    Left = 15
    Top = 359
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 27
    Width = 90
  end
  object edCloseDate: TcxDateEdit
    Left = 140
    Top = 359
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 28
    Width = 92
  end
  object cxLabel12: TcxLabel
    Left = 140
    Top = 339
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
  end
  object cxLabel13: TcxLabel
    Left = 255
    Top = 339
    Caption = #1052#1077#1085#1077#1076#1078#1077#1088
  end
  object edUserManager: TcxButtonEdit
    Left = 255
    Top = 359
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 209
  end
  object cxLabel14: TcxLabel
    Left = 16
    Top = 290
    Caption = #1056#1077#1075#1080#1086#1085
  end
  object edArea: TcxButtonEdit
    Left = 15
    Top = 306
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 33
    Width = 217
  end
  object ceUnitCategory: TcxButtonEdit
    Left = 367
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 12
    Width = 97
  end
  object cxLabel15: TcxLabel
    Left = 367
    Top = 102
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '
  end
  object ceNormOfManDays: TcxCurrencyEdit
    Left = 16
    Top = 410
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 35
    Width = 216
  end
  object cxLabel16: TcxLabel
    Left = 16
    Top = 387
    Caption = #1053#1086#1088#1084#1072' '#1095#1077#1083#1086#1074#1077#1082#1086#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
  end
  object cxLabel17: TcxLabel
    Left = 254
    Top = 237
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object edPhone: TcxTextEdit
    Left = 255
    Top = 260
    TabOrder = 38
    Width = 209
  end
  object cxLabel18: TcxLabel
    Left = 16
    Top = 442
    Caption = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1091#1088#1072#1074#1085#1080#1074#1072#1085#1080#1103' '#1094#1077#1085' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
  end
  object edUnitRePrice: TcxButtonEdit
    Left = 16
    Top = 458
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 40
    Width = 216
  end
  object cxLabel19: TcxLabel
    Left = 16
    Top = 486
    Caption = #1052#1077#1076'. '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1082#1084#1091' 1303'
  end
  object edPartnerMedical: TcxButtonEdit
    Left = 16
    Top = 502
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 42
    Width = 448
  end
  object cbPharmacyItem: TcxCheckBox
    Left = 349
    Top = 3
    Caption = #1040#1087#1090#1077#1095#1085#1099#1081' '#1087#1091#1085#1082#1090
    TabOrder = 43
    Width = 115
  end
  object cxLabel20: TcxLabel
    Left = 255
    Top = 202
    Caption = #1053#1072#1095'. '#1085#1086#1095'. '#1094#1077#1085
  end
  object cxLabel21: TcxLabel
    Left = 367
    Top = 202
    Caption = #1054#1082#1086#1085'. '#1085#1086#1095'. '#1094#1077#1085
  end
  object edTaxUnitEnd: TcxDateEdit
    Left = 364
    Top = 221
    EditValue = 43234d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    TabOrder = 46
    Width = 100
  end
  object edTaxUnitStart: TcxDateEdit
    Left = 255
    Top = 221
    EditValue = 43225d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DateOnError = deNull
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    Properties.Nullstring = ' '
    Properties.YearsInMonthList = False
    TabOrder = 47
    Width = 100
  end
  object cbGoodsCategory: TcxCheckBox
    Left = 15
    Top = 202
    Hint = #1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
    Caption = #1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
    TabOrder = 48
    Width = 179
  end
  object cbSp: TcxCheckBox
    Left = 16
    Top = 535
    Hint = #1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
    Caption = #1057#1086#1094'.'#1087#1088#1086#1077#1082#1090
    TabOrder = 50
    Width = 89
  end
  object cxLabel22: TcxLabel
    Left = 142
    Top = 535
    Hint = #1044#1072#1090#1072' '#1085#1072#1095'.'#1088#1072#1073#1086#1090#1099' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072#1084
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'.'
    ParentShowHint = False
    ShowHint = True
  end
  object edDateSp: TcxDateEdit
    Left = 142
    Top = 554
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 52
    Width = 90
  end
  object cxLabel23: TcxLabel
    Left = 255
    Top = 535
    Caption = #1053#1072#1095'. '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090
  end
  object edStartSP: TcxDateEdit
    Left = 255
    Top = 554
    EditValue = 43225d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DateOnError = deNull
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    Properties.Nullstring = ' '
    Properties.YearsInMonthList = False
    TabOrder = 54
    Width = 100
  end
  object edEndSP: TcxDateEdit
    Left = 364
    Top = 554
    EditValue = 43234d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    TabOrder = 55
    Width = 100
  end
  object cxLabel24: TcxLabel
    Left = 367
    Top = 535
    Caption = #1054#1082#1086#1085'. '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090
  end
  object cbDividePartionDate: TcxCheckBox
    Left = 15
    Top = 221
    Hint = #1056#1072#1079#1073#1080#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
    Caption = #1056#1072#1079#1073#1080#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
    TabOrder = 49
    Width = 234
  end
  object cbRedeemByHandSP: TcxCheckBox
    Left = 16
    Top = 555
    Hint = #1055#1086#1075#1072#1096#1072#1090#1100' '#1095#1077#1088#1077#1079' '#1089#1072#1081#1090' '#1074#1088#1091#1095#1085#1091#1102' ('#1073#1077#1079' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103' API)'
    Caption = #1055#1086#1075#1072#1096#1072#1090#1100' '#1074#1088#1091#1095#1085#1091#1102
    TabOrder = 57
    Width = 125
  end
  object edUnitOverdue: TcxButtonEdit
    Left = 16
    Top = 601
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 58
    Width = 297
  end
  object cxLabel25: TcxLabel
    Left = 17
    Top = 580
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel26: TcxLabel
    Left = 255
    Top = 387
    Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 2'
  end
  object edUserManager2: TcxButtonEdit
    Left = 255
    Top = 409
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 61
    Width = 209
  end
  object cxLabel27: TcxLabel
    Left = 251
    Top = 438
    Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 3'
  end
  object edUserManager3: TcxButtonEdit
    Left = 255
    Top = 458
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 63
    Width = 209
  end
  object cbSUN: TcxCheckBox
    Left = 345
    Top = 601
    Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
    Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
    Properties.ReadOnly = True
    TabOrder = 64
    Width = 119
  end
  object ActionList: TActionList
    Left = 356
    Top = 398
    object DataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
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
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Unit'
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
        Name = 'inAddress'
        Value = Null
        Component = edAddress
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
        Name = 'inTaxService'
        Value = Null
        Component = ceTaxService
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxServiceNigth'
        Value = Null
        Component = ceTaxServiceNigth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartServiceNigth'
        Value = '0'
        Component = edStartServiceNigth
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndServiceNigth'
        Value = 'NULL'
        Component = edEndServiceNigth
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCreateDate'
        Value = 'NULL'
        Component = edCreateDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCloseDate'
        Value = 'NULL'
        Component = edCloseDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxUnitStartDate'
        Value = 'NULL'
        Component = edTaxUnitStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxUnitEndDate'
        Value = 'NULL'
        Component = edTaxUnitEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateSP'
        Value = 'NULL'
        Component = edDateSp
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartTimeSP'
        Value = 'NULL'
        Component = edStartSP
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndTimeSP'
        Value = 'NULL'
        Component = edEndSP
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSP'
        Value = Null
        Component = cbSp
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRepriceAuto'
        Value = Null
        Component = cbRepriceAuto
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarginCategoryId'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProvinceCityId'
        Value = Null
        Component = GuidesProvinceCity
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManagerId'
        Value = Null
        Component = GuidesUserManager
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManager2Id'
        Value = Null
        Component = GuidesUserManager2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManager3Id'
        Value = Null
        Component = GuidesUserManager3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitCategoryId'
        Value = Null
        Component = GuidesUnitCategory
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitRePriceId'
        Value = Null
        Component = GuidesUnitRePrice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNormOfManDays'
        Value = Null
        Component = ceNormOfManDays
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPharmacyItem'
        Value = Null
        Component = cbPharmacyItem
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsCategory'
        Value = Null
        Component = cbGoodsCategory
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDividePartionDate'
        Value = Null
        Component = cbDividePartionDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRedeemByHandSP'
        Value = Null
        Component = cbRedeemByHandSP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitOverdueId'
        Value = Null
        Component = GuidesUnitOverdue
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 148
    Top = 398
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 420
    Top = 398
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit'
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
        Name = 'ParentId'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryId'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MarginCategoryName'
        Value = Null
        Component = MarginCategoryGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxService'
        Value = Null
        Component = ceTaxService
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxServiceNigth'
        Value = Null
        Component = ceTaxServiceNigth
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartServiceNigth'
        Value = 'NULL'
        Component = edStartServiceNigth
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndServiceNigth'
        Value = 'NULL'
        Component = edEndServiceNigth
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRepriceAuto'
        Value = Null
        Component = cbRepriceAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftFloat
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
        Name = 'ProvinceCityId'
        Value = Null
        Component = GuidesProvinceCity
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProvinceCityName'
        Value = Null
        Component = GuidesProvinceCity
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CreateDate'
        Value = 'NULL'
        Component = edCreateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CloseDate'
        Value = 'NULL'
        Component = edCloseDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManagerId'
        Value = Null
        Component = GuidesUserManager
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManagerName'
        Value = Null
        Component = GuidesUserManager
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManager2Id'
        Value = Null
        Component = GuidesUserManager2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManager2Name'
        Value = Null
        Component = GuidesUserManager2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManager3Id'
        Value = Null
        Component = GuidesUserManager3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserManager3Name'
        Value = Null
        Component = GuidesUserManager3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCategoryId'
        Value = Null
        Component = GuidesUnitCategory
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCategoryName'
        Value = Null
        Component = GuidesUnitCategory
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NormOfManDays'
        Value = Null
        Component = ceNormOfManDays
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitRePriceId'
        Value = Null
        Component = GuidesUnitRePrice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitRePriceName'
        Value = Null
        Component = GuidesUnitRePrice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalId'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PharmacyItem'
        Value = Null
        Component = cbPharmacyItem
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxUnitStartDate'
        Value = 'NULL'
        Component = edTaxUnitStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxUnitEndDate'
        Value = 'NULL'
        Component = edTaxUnitEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsCategory'
        Value = Null
        Component = cbGoodsCategory
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSp'
        Value = Null
        Component = cbSp
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateSp'
        Value = 'NULL'
        Component = edDateSp
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartTimeSP'
        Value = 'NULL'
        Component = edStartSP
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndTimeSP'
        Value = 'NULL'
        Component = edEndSP
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DividePartionDate'
        Value = Null
        Component = cbDividePartionDate
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'RedeemByHandSP'
        Value = Null
        Component = cbRedeemByHandSP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitOverdueID'
        Value = Null
        Component = GuidesUnitOverdue
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitOverdueName'
        Value = Null
        Component = GuidesUnitOverdue
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSun'
        Value = Null
        Component = cbSUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 84
    Top = 390
  end
  object ParentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ParentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 64
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 48
  end
  object MarginCategoryGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMarginCategory
    FormNameParam.Value = 'TMarginCategoryForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMarginCategoryForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MarginCategoryGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MarginCategoryGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 112
  end
  object GuidesProvinceCity: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProvinceCity
    FormNameParam.Value = 'TProvinceCityForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProvinceCityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProvinceCity
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProvinceCity
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 294
  end
  object GuidesUserManager: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUserManager
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUserManager
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuidesUserManager
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 346
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 296
  end
  object GuidesUnitCategory: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnitCategory
    FormNameParam.Value = 'TUnitCategoryForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitCategoryForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitCategory
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitCategory
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 112
  end
  object GuidesUnitRePrice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitRePrice
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitRePrice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitRePrice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 145
    Top = 456
  end
  object GuidesPartnerMedical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartnerMedical
    FormNameParam.Value = 'TPartnerMedicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 233
    Top = 484
  end
  object GuidesUnitOverdue: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitOverdue
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitOverdue
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitOverdue
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 225
    Top = 584
  end
  object GuidesUserManager2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUserManager2
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUserManager2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuidesUserManager2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 394
  end
  object GuidesUserManager3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUserManager3
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUserManager3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuidesUserManager3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 356
    Top = 437
  end
end
