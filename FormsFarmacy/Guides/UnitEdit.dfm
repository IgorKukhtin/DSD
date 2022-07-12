object UnitEditForm: TUnitEditForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ClientHeight = 620
  ClientWidth = 515
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
    Top = 27
    TabOrder = 0
    Width = 209
  end
  object cxLabel1: TcxLabel
    Left = 255
    Top = 8
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 98
    Top = 575
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 317
    Top = 575
    Width = 75
    Height = 25
    Action = FormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 15
    Top = 8
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 15
    Top = 27
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
    Top = 68
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
    Top = 50
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 255
    Top = 68
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
    Top = 93
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1076#1083#1103' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080
  end
  object edMarginCategory: TcxButtonEdit
    Left = 15
    Top = 112
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 217
  end
  object cbRepriceAuto: TcxCheckBox
    Left = 255
    Top = 98
    Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
    Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072
    TabOrder = 13
    Width = 113
  end
  object ceUnitCategory: TcxButtonEdit
    Left = 367
    Top = 112
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
    Top = 93
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '
  end
  object cbPharmacyItem: TcxCheckBox
    Left = 349
    Top = 4
    Caption = #1040#1087#1090#1077#1095#1085#1099#1081' '#1087#1091#1085#1082#1090
    TabOrder = 15
    Width = 115
  end
  object cbSUN: TcxCheckBox
    Left = 113
    Top = 4
    Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
    Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 119
  end
  object cbAutoMCS: TcxCheckBox
    Left = 255
    Top = 117
    Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
    Caption = #1040#1074#1090#1086' '#1087#1077#1088'. '#1053#1058#1047
    TabOrder = 17
    Width = 113
  end
  object cxPageControl: TcxPageControl
    Left = 15
    Top = 144
    Width = 489
    Height = 409
    TabOrder = 18
    Properties.ActivePage = cxTabSheet3
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 409
    ClientRectRight = 489
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 0
      object cbDividePartionDate: TcxCheckBox
        Left = 7
        Top = 69
        Hint = #1056#1072#1079#1073#1080#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
        Caption = #1056#1072#1079#1073#1080#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
        TabOrder = 0
        Width = 234
      end
      object cbGoodsCategory: TcxCheckBox
        Left = 7
        Top = 50
        Hint = #1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
        Caption = #1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
        TabOrder = 1
        Width = 179
      end
      object ceNormOfManDays: TcxCurrencyEdit
        Left = 7
        Top = 227
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 2
        Width = 216
      end
      object ceProvinceCity: TcxButtonEdit
        Left = 250
        Top = 145
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 3
        Width = 209
      end
      object ceTaxService: TcxCurrencyEdit
        Left = 7
        Top = 23
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 4
        Width = 90
      end
      object ceTaxServiceNigth: TcxCurrencyEdit
        Left = 134
        Top = 23
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 5
        Width = 90
      end
      object cxLabel10: TcxLabel
        Left = 250
        Top = 129
        Caption = #1056#1072#1081#1086#1085
      end
      object cxLabel11: TcxLabel
        Left = 7
        Top = 168
        Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
      end
      object cxLabel12: TcxLabel
        Left = 132
        Top = 168
        Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
      end
      object cxLabel13: TcxLabel
        Left = 250
        Top = 168
        Caption = #1052#1077#1085#1077#1076#1078#1077#1088
      end
      object cxLabel14: TcxLabel
        Left = 7
        Top = 130
        Caption = #1056#1077#1075#1080#1086#1085
      end
      object cxLabel16: TcxLabel
        Left = 7
        Top = 208
        Caption = #1053#1086#1088#1084#1072' '#1095#1077#1083#1086#1074#1077#1082#1086#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
      end
      object cxLabel17: TcxLabel
        Left = 250
        Top = 91
        Caption = #1058#1077#1083#1077#1092#1086#1085
      end
      object cxLabel18: TcxLabel
        Left = 7
        Top = 251
        Hint = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1091#1088#1072#1074#1085#1080#1074#1072#1085#1080#1103' '#1094#1077#1085' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
        Caption = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1091#1088#1072#1074#1085#1080#1074#1072#1085#1080#1103' '#1094#1077#1085' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel20: TcxLabel
        Left = 250
        Top = 50
        Caption = #1053#1072#1095'. '#1085#1086#1095'. '#1094#1077#1085
      end
      object cxLabel21: TcxLabel
        Left = 359
        Top = 50
        Caption = #1054#1082#1086#1085'. '#1085#1086#1095'. '#1094#1077#1085
      end
      object cxLabel26: TcxLabel
        Left = 250
        Top = 208
        Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 2'
      end
      object cxLabel27: TcxLabel
        Left = 250
        Top = 251
        Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 3'
      end
      object cxLabel28: TcxLabel
        Left = 247
        Top = 426
        Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
        Caption = #1050#1086#1101#1092'. '#1073#1072#1083'. '#1087#1088#1080#1093'.'
      end
      object cxLabel29: TcxLabel
        Left = 359
        Top = 426
        Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
        Caption = #1050#1086#1101#1092'. '#1073#1072#1083'. '#1088#1072#1089#1093'.'
      end
      object cxLabel4: TcxLabel
        Left = 7
        Top = 4
        Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080
      end
      object cxLabel6: TcxLabel
        Left = 134
        Top = 4
        Caption = '% '#1074' '#1085#1086#1095#1085'. '#1089#1084'.'
      end
      object cxLabel7: TcxLabel
        Left = 250
        Top = 4
        Caption = #1053#1072#1095'. '#1085#1086#1095'. '#1089#1084#1077#1085#1099
      end
      object cxLabel8: TcxLabel
        Left = 359
        Top = 4
        Caption = #1054#1082#1086#1085'. '#1085#1086#1095'. '#1089#1084#1077#1085#1099
      end
      object cxLabel9: TcxLabel
        Left = 7
        Top = 91
        Caption = #1040#1076#1088#1077#1089
      end
      object edAddress: TcxTextEdit
        Left = 7
        Top = 108
        TabOrder = 25
        Width = 216
      end
      object edArea: TcxButtonEdit
        Left = 7
        Top = 146
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 26
        Width = 217
      end
      object edCloseDate: TcxDateEdit
        Left = 132
        Top = 186
        EditValue = 42993d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 27
        Width = 92
      end
      object edCreateDate: TcxDateEdit
        Left = 7
        Top = 186
        EditValue = 42993d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 28
        Width = 90
      end
      object edEndServiceNigth: TcxDateEdit
        Left = 356
        Top = 23
        EditValue = 43234d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        TabOrder = 29
        Width = 100
      end
      object edPhone: TcxTextEdit
        Left = 250
        Top = 108
        TabOrder = 30
        Width = 209
      end
      object edStartServiceNigth: TcxDateEdit
        Left = 250
        Top = 23
        EditValue = 43225d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DateOnError = deNull
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        Properties.Nullstring = ' '
        Properties.YearsInMonthList = False
        TabOrder = 31
        Width = 100
      end
      object edTaxUnitEnd: TcxDateEdit
        Left = 356
        Top = 69
        EditValue = 43234d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        TabOrder = 32
        Width = 100
      end
      object edTaxUnitStart: TcxDateEdit
        Left = 250
        Top = 69
        EditValue = 43225d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DateOnError = deNull
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        Properties.Nullstring = ' '
        Properties.YearsInMonthList = False
        TabOrder = 33
        Width = 100
      end
      object edUnitRePrice: TcxButtonEdit
        Left = 7
        Top = 270
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 34
        Width = 216
      end
      object edUserManager: TcxButtonEdit
        Left = 250
        Top = 186
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 35
        Width = 209
      end
      object edUserManager2: TcxButtonEdit
        Left = 250
        Top = 226
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 36
        Width = 209
      end
      object edUserManager3: TcxButtonEdit
        Left = 250
        Top = 270
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 37
        Width = 209
      end
      object cxLabel47: TcxLabel
        Left = 7
        Top = 293
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074#1099#1075#1088#1091#1079#1082#1080
      end
      object edLayout: TcxButtonEdit
        Left = 7
        Top = 309
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 39
        Width = 217
      end
      object edPharmacyManagerPhone: TcxTextEdit
        Left = 250
        Top = 348
        TabOrder = 40
        Width = 209
      end
      object cxLabel50: TcxLabel
        Left = 250
        Top = 331
        Caption = #1058#1077#1083#1077#1092#1086#1085' '#1047#1072#1074'. '#1072#1087#1090#1077#1082#1086#1081
      end
      object edPharmacyManager: TcxTextEdit
        Left = 7
        Top = 348
        TabOrder = 42
        Width = 216
      end
      object cxLabel51: TcxLabel
        Left = 7
        Top = 331
        Caption = #1060#1048#1054' '#1047#1072#1074'. '#1072#1087#1090#1077#1082#1086#1081
      end
    end
    object cxTabSheet3: TcxTabSheet
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      object edUnitOverdue: TcxButtonEdit
        Left = 0
        Top = 27
        Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074'.'
        ParentShowHint = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 0
        Width = 220
      end
      object cxLabel25: TcxLabel
        Left = 0
        Top = 6
        Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074'.'
        Caption = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095'. '#1090#1086#1074'.'
        ParentShowHint = False
        ShowHint = True
      end
      object edListDaySUN: TcxTextEdit
        Left = 0
        Top = 73
        Hint = #1086#1090' 1 '#1076#1086' 7 '#1095#1077#1088#1077#1079' '#1079#1087#1090'.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Width = 220
      end
      object cbNotCashMCS: TcxCheckBox
        Left = 240
        Top = 11
        Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
        Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1053#1058#1047' '#1085#1072' '#1082#1072#1089#1089#1072#1093
        TabOrder = 2
        Width = 233
      end
      object cbNotCashListDiff: TcxCheckBox
        Left = 240
        Top = 26
        Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
        Caption = #1042#1090#1086#1088#1072#1103' '#1096#1082#1072#1083#1072' '#1076#1083#1103' '#1083#1080#1089#1090#1086#1074' '#1086#1090#1082#1072#1079#1086#1074
        TabOrder = 3
        Width = 246
      end
      object cxLabel38: TcxLabel
        Left = 0
        Top = 51
        Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
      end
      object cxLabel42: TcxLabel
        Left = 240
        Top = 98
        Hint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053')'
        Caption = #1050#1086#1083'. '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082'. '#1057#1059#1053')'
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel44: TcxLabel
        Left = 240
        Top = 192
        Hint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053'-2-'#1055#1048')'
        Caption = #1050#1086#1083'. '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082'. '#1057#1059#1053'-2-'#1055#1048')'
        ParentShowHint = False
        ShowHint = True
      end
      object edSun_v4Income: TcxCurrencyEdit
        Left = 240
        Top = 211
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 11
        Width = 220
      end
      object edSun_v2Income: TcxCurrencyEdit
        Left = 240
        Top = 165
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 16
        Width = 220
      end
      object cxLabel45: TcxLabel
        Left = 240
        Top = 144
        Hint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053'-2)'
        Caption = #1050#1086#1083'. '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082'. '#1057#1059#1053'-2)'
        ParentShowHint = False
        ShowHint = True
      end
      object edUnitOld: TcxButtonEdit
        Left = 0
        Top = 165
        Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074'.'
        ParentShowHint = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 5
        Width = 220
      end
      object cxLabel39: TcxLabel
        Left = 0
        Top = 144
        Hint = #1057#1090#1072#1088#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080#1077' ('#1079#1072#1082#1088#1099#1090#1086#1077')'
        Caption = #1057#1090#1072#1088#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080#1077' ('#1079#1072#1082#1088#1099#1090#1086#1077')'
        ParentShowHint = False
        ShowHint = True
      end
      object ceMorionCode: TcxCurrencyEdit
        Left = 0
        Top = 211
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 10
        Width = 217
      end
      object edSunIncome: TcxCurrencyEdit
        Left = 240
        Top = 117
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 7
        Width = 220
      end
      object cxLabel40: TcxLabel
        Left = 0
        Top = 192
        Caption = #1050#1086#1076' '#1084#1086#1088#1080#1086#1085#1072
      end
      object cbTechnicalRediscount: TcxCheckBox
        Left = 240
        Top = 41
        Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
        Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1080' '#1055#1057' '
        TabOrder = 12
        Width = 246
      end
      object cbRedeemByHandSP: TcxCheckBox
        Left = 0
        Top = 298
        Hint = #1055#1086#1075#1072#1096#1072#1090#1100' '#1095#1077#1088#1077#1079' '#1089#1072#1081#1090' '#1074#1088#1091#1095#1085#1091#1102' ('#1073#1077#1079' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103' API)'
        Caption = #1055#1086#1075#1072#1096#1072#1090#1100' '#1074#1088#1091#1095#1085#1091#1102
        TabOrder = 13
        Width = 125
      end
      object cbSp: TcxCheckBox
        Left = 0
        Top = 278
        Hint = #1076#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
        Caption = #1057#1086#1094'.'#1087#1088#1086#1077#1082#1090
        TabOrder = 14
        Width = 89
      end
      object cbTopNo: TcxCheckBox
        Left = 0
        Top = 317
        Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' '#1076#1083#1103' '#1072#1087#1090#1077#1082#1080
        Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' '#1076#1083#1103' '#1072#1087#1090#1077#1082#1080
        TabOrder = 15
        Width = 183
      end
      object cxLabel19: TcxLabel
        Left = 0
        Top = 236
        Caption = #1052#1077#1076'. '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1082#1084#1091' 1303'
      end
      object cxLabel22: TcxLabel
        Left = 126
        Top = 278
        Hint = #1044#1072#1090#1072' '#1085#1072#1095'.'#1088#1072#1073#1086#1090#1099' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072#1084
        Caption = #1044#1072#1090#1072' '#1085#1072#1095'.'
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel23: TcxLabel
        Left = 239
        Top = 278
        Caption = #1053#1072#1095'. '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090
      end
      object cxLabel24: TcxLabel
        Left = 351
        Top = 278
        Caption = #1054#1082#1086#1085'. '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090
      end
      object edDateSp: TcxDateEdit
        Left = 126
        Top = 297
        EditValue = 42993d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 20
        Width = 90
      end
      object edEndSP: TcxDateEdit
        Left = 348
        Top = 297
        EditValue = 43234d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        TabOrder = 21
        Width = 100
      end
      object edKoeffInSUN: TcxCurrencyEdit
        Left = 239
        Top = 328
        Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
        ParentShowHint = False
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        ShowHint = True
        TabOrder = 22
        Width = 100
      end
      object edKoeffOutSUN: TcxCurrencyEdit
        Left = 348
        Top = 328
        Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
        ParentShowHint = False
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        ShowHint = True
        TabOrder = 23
        Width = 100
      end
      object edPartnerMedical: TcxButtonEdit
        Left = 0
        Top = 252
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 24
        Width = 448
      end
      object edStartSP: TcxDateEdit
        Left = 239
        Top = 297
        EditValue = 43225d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DateOnError = deNull
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        Properties.Nullstring = ' '
        Properties.YearsInMonthList = False
        TabOrder = 25
        Width = 100
      end
      object cbAlertRecounting: TcxCheckBox
        Left = 240
        Top = 57
        Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
        Caption = #1054#1087#1086#1074#1077#1097#1077#1085#1080#1077' '#1087#1077#1088#1077#1076' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1084
        TabOrder = 26
        Width = 246
      end
      object cxLabel43: TcxLabel
        Left = 0
        Top = 98
        Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053' 2 - '#1055#1048
      end
      object edListDaySUN_pi: TcxTextEdit
        Left = 0
        Top = 117
        Hint = #1086#1090' 1 '#1076#1086' 7 '#1095#1077#1088#1077#1079' '#1079#1087#1090'.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 28
        Width = 220
      end
      object cdMinPercentMarkup: TcxCheckBox
        Left = 0
        Top = 336
        Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1091#1102' '#1085#1072#1094#1077#1085#1082#1091' '#1087#1086' '#1089#1077#1090#1080' '#1080#1083#1080' '#1072#1087#1090#1077#1082#1077
        Caption = #1052#1080#1085#1080'. '#1085#1072#1094#1077#1085#1082#1072' '#1087#1086' '#1089#1077#1090#1080' '#1080#1083#1080' '#1072#1087#1090#1077#1082#1077
        TabOrder = 33
        Width = 216
      end
      object cbBlockCommentSendTP: TcxCheckBox
        Left = 240
        Top = 73
        Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
        Caption = #1041#1083#1080#1082#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1084#1077#1085#1090#1099' '#1089' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077#1084' '#1058#1055
        TabOrder = 34
        Width = 246
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1044#1083#1103' '#1074#1099#1075#1088#1091#1079#1086#1082
      ImageIndex = 1
      object cxLabel30: TcxLabel
        Left = 162
        Top = 12
        Caption = #1043#1077#1086#1075#1088#1072#1092#1080#1095#1077#1089#1082#1072#1103' '#1076#1086#1083#1075#1086#1090#1072' ('#1074#1074#1086#1076#1080#1090#1100' '#1095#1077#1088#1077#1079' '#1090#1086#1095#1082#1091')'
      end
      object cxLabel31: TcxLabel
        Left = 15
        Top = 12
        Caption = #1043#1077#1086#1075#1088#1072#1092#1080#1095#1077#1089#1082#1072#1103' '#1096#1080#1088#1086#1090#1072
      end
      object cxLabel32: TcxLabel
        Left = 227
        Top = 68
        Caption = #1054#1082#1086#1085'. '#1088#1072#1073#1086#1090#1099
      end
      object cxLabel33: TcxLabel
        Left = 115
        Top = 68
        Caption = #1053#1072#1095'. '#1088#1072#1073#1086#1090#1099
      end
      object cxLabel34: TcxLabel
        Left = 15
        Top = 88
        Caption = #1055#1086#1085'. -  '#1087#1103#1090#1085'.'
      end
      object cxLabel35: TcxLabel
        Left = 15
        Top = 120
        Caption = #1057#1091#1073#1073#1086#1090#1072
      end
      object cxLabel36: TcxLabel
        Left = 15
        Top = 152
        Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
      end
      object cxLabel37: TcxLabel
        Left = 15
        Top = 68
        Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
      end
      object ceMondayEnd: TcxDateEdit
        Left = 224
        Top = 87
        EditValue = 43234d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        TabOrder = 3
        Width = 100
      end
      object ceMondayStart: TcxDateEdit
        Left = 115
        Top = 87
        EditValue = 43225d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DateOnError = deNull
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        Properties.Nullstring = ' '
        Properties.YearsInMonthList = False
        TabOrder = 2
        Width = 100
      end
      object ceSaturdayEnd: TcxDateEdit
        Left = 224
        Top = 119
        EditValue = 43234d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        TabOrder = 5
        Width = 100
      end
      object ceSaturdayStart: TcxDateEdit
        Left = 117
        Top = 119
        EditValue = 43225d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DateOnError = deNull
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        Properties.Nullstring = ' '
        Properties.YearsInMonthList = False
        TabOrder = 4
        Width = 100
      end
      object ceSundayEnd: TcxDateEdit
        Left = 224
        Top = 151
        EditValue = 43234d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        TabOrder = 7
        Width = 100
      end
      object ceSundayStart: TcxDateEdit
        Left = 115
        Top = 151
        EditValue = 43225d
        Properties.ArrowsForYear = False
        Properties.AssignedValues.EditFormat = True
        Properties.DateButtons = [btnNow]
        Properties.DateOnError = deNull
        Properties.DisplayFormat = 'HH:MM'
        Properties.Kind = ckDateTime
        Properties.Nullstring = ' '
        Properties.YearsInMonthList = False
        TabOrder = 6
        Width = 100
      end
      object edLatitude: TcxTextEdit
        Left = 15
        Top = 35
        TabOrder = 0
        Width = 129
      end
      object edLongitude: TcxTextEdit
        Left = 163
        Top = 35
        TabOrder = 1
        Width = 129
      end
      object edAccessKeyYF: TcxTextEdit
        Left = 15
        Top = 201
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        Width = 450
      end
      object cxLabel41: TcxLabel
        Left = 15
        Top = 179
        Caption = #1050#1083#1102#1095' '#1061#1054' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1076#1072#1085#1085#1099#1093' '#1070#1088#1080#1103'-'#1060#1072#1088#1084
      end
      object ceSerialNumberTabletki: TcxCurrencyEdit
        Left = 15
        Top = 246
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 18
        Width = 168
      end
      object cxLabel46: TcxLabel
        Left = 15
        Top = 227
        Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1085#1072' '#1089#1072#1081#1090#1077' '#1090#1072#1073#1083#1077#1090#1086#1082
      end
      object cxLabel48: TcxLabel
        Left = 14
        Top = 270
        Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
      end
      object edPromoForSale: TcxTextEdit
        Left = 14
        Top = 289
        TabOrder = 21
        Width = 129
      end
      object ceSerialNumberMypharmacy: TcxCurrencyEdit
        Left = 220
        Top = 246
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 22
        Width = 168
      end
      object cxLabel49: TcxLabel
        Left = 220
        Top = 227
        Caption = #1057#1077#1088'. '#1085#1086#1084#1077#1088' '#1085#1072' '#1089#1072#1081#1090#1077' "'#1052#1086#1103' '#1072#1087#1090#1077#1082#1072'"'
      end
      object edTokenKashtan: TcxTextEdit
        Left = 15
        Top = 336
        ParentShowHint = False
        ShowHint = True
        TabOrder = 24
        Width = 450
      end
      object cxLabel52: TcxLabel
        Left = 15
        Top = 314
        Caption = #9#1058#1086#1082#1077#1085' '#1072#1087#1090#1077#1095#1085#1086#1081' '#1089#1077#1090#1080' '#1074' '#1052#1048#1057' '#171#1050#1072#1096#1090#1072#1085#187
      end
      object edTelegramId: TcxTextEdit
        Left = 220
        Top = 289
        TabOrder = 26
        Width = 129
      end
      object cxLabel53: TcxLabel
        Left = 220
        Top = 270
        Caption = 'ID '#1072#1087#1090#1077#1082#1080' '#1074' Telegram'
      end
    end
  end
  object ActionList: TActionList
    Left = 396
    Top = 505
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
        Name = 'inKoeffInSUN'
        Value = Null
        Component = edKoeffInSUN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffOutSUN'
        Value = Null
        Component = edKoeffOutSUN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSunIncome'
        Value = Null
        Component = edSunIncome
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSun_v2Income'
        Value = Null
        Component = edSun_v2Income
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSun_v4Income'
        Value = Null
        Component = edSun_v4Income
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartServiceNigth'
        Value = Null
        Component = edStartServiceNigth
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndServiceNigth'
        Value = Null
        Component = edEndServiceNigth
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCreateDate'
        Value = Null
        Component = edCreateDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCloseDate'
        Value = Null
        Component = edCloseDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxUnitStartDate'
        Value = Null
        Component = edTaxUnitStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxUnitEndDate'
        Value = Null
        Component = edTaxUnitEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateSP'
        Value = Null
        Component = edDateSp
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartTimeSP'
        Value = Null
        Component = edStartSP
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndTimeSP'
        Value = Null
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
        Name = 'inLayoutId'
        Value = Null
        Component = GuidesLayout
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
      end
      item
        Name = 'inisAutoMCS'
        Value = Null
        Component = cbAutoMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTopNo'
        Value = Null
        Component = cbTopNo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inListDaySUN'
        Value = Null
        Component = edListDaySUN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inListDaySUN_pi'
        Value = Null
        Component = edListDaySUN_pi
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLatitude'
        Value = Null
        Component = edLatitude
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLongitude'
        Value = Null
        Component = edLongitude
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMondayStart'
        Value = Null
        Component = ceMondayStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMondayEnd'
        Value = Null
        Component = ceMondayEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSaturdayStart'
        Value = Null
        Component = ceSaturdayStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSaturdayEnd'
        Value = Null
        Component = ceSaturdayEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSundayStart'
        Value = Null
        Component = ceSundayStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSundayEnd'
        Value = Null
        Component = ceSundayEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotCashMCS'
        Value = Null
        Component = cbNotCashMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotCashListDiff'
        Value = Null
        Component = cbNotCashListDiff
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitOldId'
        Value = Null
        Component = GuidesUnitOld
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMorionCode'
        Value = Null
        Component = ceMorionCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccessKeyYF'
        Value = Null
        Component = edAccessKeyYF
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTechnicalRediscount'
        Value = Null
        Component = cbTechnicalRediscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAlertRecounting'
        Value = Null
        Component = cbAlertRecounting
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSerialNumberTabletki'
        Value = Null
        Component = ceSerialNumberTabletki
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoForSale'
        Value = Null
        Component = edPromoForSale
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'iniscdMinPercentMarkup'
        Value = Null
        Component = cdMinPercentMarkup
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSerialNumberMypharmacy'
        Value = Null
        Component = ceSerialNumberMypharmacy
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBlockCommentSendTP'
        Value = Null
        Component = cbBlockCommentSendTP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPharmacyManager'
        Value = Null
        Component = edPharmacyManager
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPharmacyManagerPhone'
        Value = Null
        Component = edPharmacyManagerPhone
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTokenKashtan'
        Value = Null
        Component = edTokenKashtan
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTelegramId'
        Value = Null
        Component = edTelegramId
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 140
    Top = 25
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 412
    Top = 369
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
        Name = 'KoeffInSUN'
        Value = Null
        Component = edKoeffInSUN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'KoeffOutSUN'
        Value = Null
        Component = edKoeffOutSUN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartServiceNigth'
        Value = Null
        Component = edStartServiceNigth
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndServiceNigth'
        Value = Null
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
        Value = Null
        Component = edCreateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CloseDate'
        Value = Null
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
        Value = Null
        Component = edTaxUnitStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxUnitEndDate'
        Value = Null
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
        Value = Null
        Component = edDateSp
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartTimeSP'
        Value = Null
        Component = edStartSP
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndTimeSP'
        Value = Null
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
      end
      item
        Name = 'isAutoMCS'
        Value = False
        Component = cbAutoMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTopNo'
        Value = Null
        Component = cbTopNo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Latitude'
        Value = Null
        Component = edLatitude
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Longitude'
        Value = Null
        Component = edLongitude
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MondayStart'
        Value = Null
        Component = ceMondayStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MondayEnd'
        Value = Null
        Component = ceMondayEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaturdayStart'
        Value = Null
        Component = ceSaturdayStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaturdayEnd'
        Value = Null
        Component = ceSaturdayEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SundayStart'
        Value = Null
        Component = ceSundayStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SundayEnd'
        Value = Null
        Component = ceSundayEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ListDaySUN'
        Value = Null
        Component = edListDaySUN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ListDaySUN_pi'
        Value = Null
        Component = edListDaySUN_pi
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotCashMCS'
        Value = Null
        Component = cbNotCashMCS
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotCashListDiff'
        Value = Null
        Component = cbNotCashListDiff
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitOldId'
        Value = Null
        Component = GuidesUnitOld
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitOldName'
        Value = Null
        Component = GuidesUnitOld
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = ceMorionCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccessKeyYF'
        Value = Null
        Component = edAccessKeyYF
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SunIncome'
        Value = Null
        Component = edSunIncome
        MultiSelectSeparator = ','
      end
      item
        Name = 'Sun_v2Income'
        Value = Null
        Component = edSun_v2Income
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Sun_v4Income'
        Value = Null
        Component = edSun_v4Income
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTechnicalRediscount'
        Value = Null
        Component = cbTechnicalRediscount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAlertRecounting'
        Value = Null
        Component = cbAlertRecounting
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SerialNumberTabletki'
        Value = Null
        Component = ceSerialNumberTabletki
        MultiSelectSeparator = ','
      end
      item
        Name = 'LayoutId'
        Value = Null
        Component = GuidesLayout
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LayoutName'
        Value = Null
        Component = GuidesLayout
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoForSale'
        Value = Null
        Component = edPromoForSale
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMinPercentMarkup'
        Value = Null
        Component = cdMinPercentMarkup
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SerialNumberMypharmacy'
        Value = Null
        Component = ceSerialNumberMypharmacy
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBlockCommentSendTP'
        Value = Null
        Component = cbBlockCommentSendTP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PharmacyManager'
        Value = Null
        Component = edPharmacyManager
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PharmacyManagerPhone'
        Value = Null
        Component = edPharmacyManagerPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TokenKashtan'
        Value = Null
        Component = edTokenKashtan
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TelegramId'
        Value = Null
        Component = edTelegramId
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 36
    Top = 21
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
    Top = 63
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
    Top = 55
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
    Left = 80
    Top = 119
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
    Left = 272
    Top = 341
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
    Left = 304
    Top = 329
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
    Left = 80
    Top = 319
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
    Top = 111
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
    Left = 105
    Top = 403
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
    Left = 385
    Top = 351
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
    Left = 153
    Top = 211
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
    Left = 400
    Top = 285
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
    Left = 300
    Top = 504
  end
  object GuidesUnitOld: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitOld
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitOld
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitOld
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 153
    Top = 259
  end
  object GuidesLayout: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLayout
    FormNameParam.Value = 'TLayoutForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLayoutForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLayout
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLayout
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 343
  end
end
