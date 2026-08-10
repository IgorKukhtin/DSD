inherited PartnerEditForm: TPartnerEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072'>'
  ClientHeight = 625
  ClientWidth = 1087
  ExplicitWidth = 1093
  ExplicitHeight = 654
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 65
    Top = 592
    TabOrder = 2
    ExplicitLeft = 65
    ExplicitTop = 592
  end
  inherited bbCancel: TcxButton
    Left = 237
    Top = 592
    TabOrder = 0
    ExplicitLeft = 237
    ExplicitTop = 592
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 4
    Top = 9
    Width = 1075
    Height = 577
    TabOrder = 1
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 577
    ClientRectRight = 1075
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1047#1072#1075#1072#1083#1100#1085#1072
      ImageIndex = 0
      object edAddress: TcxTextEdit
        Left = 158
        Top = 160
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 195
      end
      object cxLabel1: TcxLabel
        Left = 15
        Top = 161
        Caption = #1040#1076#1088#1077#1089
      end
      object Код: TcxLabel
        Left = 15
        Top = 7
        Caption = #1050#1086#1076
      end
      object ceCode: TcxCurrencyEdit
        Left = 45
        Top = 8
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 3
        Width = 54
      end
      object cxLabel2: TcxLabel
        Left = 117
        Top = 7
        Caption = 'GLN - '#1084#1077#1089#1090#1086' '#1076#1086#1089#1090#1072#1074#1082#1080
      end
      object edGLNCode: TcxTextEdit
        Left = 233
        Top = 6
        TabOrder = 5
        Width = 120
      end
      object cxLabel3: TcxLabel
        Left = 15
        Top = 101
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
      end
      object edJuridical: TcxButtonEdit
        Left = 158
        Top = 100
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 7
        Width = 195
      end
      object cxLabel4: TcxLabel
        Left = 15
        Top = 219
        Caption = #1047#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1085#1080#1084#1072#1077#1090#1089#1103' '#1079#1072#1082#1072#1079
      end
      object cxLabel5: TcxLabel
        Left = 15
        Top = 189
        Caption = #1063#1077#1088#1077#1079' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1086#1092#1086#1088#1084#1083#1103#1077#1090#1089#1103' '#1076#1086#1082#1091#1084#1077#1085#1090
      end
      object cxLabel6: TcxLabel
        Left = 15
        Top = 247
        Caption = #1052#1072#1088#1096#1088#1091#1090
      end
      object ceRoute: TcxButtonEdit
        Left = 158
        Top = 246
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 11
        Width = 195
      end
      object cxLabel7: TcxLabel
        Left = 961
        Top = 412
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
        Visible = False
      end
      object ceRouteSorting: TcxButtonEdit
        Left = 1022
        Top = 410
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 13
        Visible = False
        Width = 57
      end
      object cxLabel8: TcxLabel
        Left = 735
        Top = 131
        Caption = #1060#1080#1079'. '#1083#1080#1094#1086' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
      end
      object ceMemberTake: TcxButtonEdit
        Left = 878
        Top = 130
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 15
        Width = 195
      end
      object cePrepareDayCount: TcxCurrencyEdit
        Left = 253
        Top = 218
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Properties.EditFormat = '0'
        TabOrder = 16
        Width = 100
      end
      object ceDocumentDayCount: TcxCurrencyEdit
        Left = 253
        Top = 188
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Properties.EditFormat = '0'
        TabOrder = 17
        Width = 100
      end
      object cxLabel9: TcxLabel
        Left = 380
        Top = 321
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
      end
      object cxLabel10: TcxLabel
        Left = 950
        Top = 397
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1040#1082#1094#1080#1086#1085#1085#1099#1081')'
        Visible = False
      end
      object cePriceList: TcxButtonEdit
        Left = 515
        Top = 320
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 20
        Width = 204
      end
      object cePriceListPromo: TcxButtonEdit
        Left = 995
        Top = 397
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 23
        Visible = False
        Width = 54
      end
      object cxLabel11: TcxLabel
        Left = 380
        Top = 380
        Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
      end
      object cxLabel12: TcxLabel
        Left = 569
        Top = 380
        Caption = #1044#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1072#1082#1094#1080#1080
      end
      object edStartPromo: TcxDateEdit
        Left = 380
        Top = 398
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        Properties.ValidateOnEnter = False
        TabOrder = 24
        Width = 120
      end
      object edEndPromo: TcxDateEdit
        Left = 569
        Top = 397
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        Properties.ValidateOnEnter = False
        TabOrder = 26
        Width = 120
      end
      object cxLabel13: TcxLabel
        Left = 15
        Top = 131
        Caption = #1059#1089#1083#1086#1074#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
      end
      object edShortName: TcxTextEdit
        Left = 158
        Top = 130
        TabOrder = 29
        Width = 195
      end
      object cxLabel14: TcxLabel
        Left = 380
        Top = 221
        Caption = #1059#1083#1080#1094#1072'/'#1087#1088#1086#1089#1087#1077#1082#1090
      end
      object cxLabel15: TcxLabel
        Left = 532
        Top = 247
        Caption = #1044#1086#1084':'
      end
      object cxLabel16: TcxLabel
        Left = 628
        Top = 247
        Caption = #1050#1086#1088#1087#1091#1089':'
      end
      object cxLabel17: TcxLabel
        Left = 458
        Top = 271
        Caption = #8470' '#1057#1082#1083#1072#1076#1072' '#1080#1083#1080' '#1082#1074'.:'
      end
      object ceStreet: TcxButtonEdit
        Left = 484
        Top = 220
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 32
        Width = 235
      end
      object edHouseNumber: TcxTextEdit
        Left = 562
        Top = 246
        TabOrder = 33
        Width = 45
      end
      object edCaseNumber: TcxTextEdit
        Left = 674
        Top = 246
        TabOrder = 34
        Width = 45
      end
      object edRoomNumber: TcxTextEdit
        Left = 562
        Top = 270
        TabOrder = 36
        Width = 157
      end
      object cxLabel18: TcxLabel
        Left = 737
        Top = 7
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
      end
      object cePersonal: TcxButtonEdit
        Left = 878
        Top = 6
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 38
        Width = 195
      end
      object cxLabel19: TcxLabel
        Left = 735
        Top = 41
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1090#1086#1088#1075#1086#1074#1099#1081')'
      end
      object cePersonalTrade: TcxButtonEdit
        Left = 878
        Top = 40
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 40
        Width = 195
      end
      object cxLabel20: TcxLabel
        Left = 15
        Top = 333
        Caption = #1056#1077#1075#1080#1086#1085
      end
      object ceArea: TcxButtonEdit
        Left = 158
        Top = 332
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 42
        Width = 195
      end
      object cxLabel21: TcxLabel
        Left = 15
        Top = 390
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1090#1086#1095#1082#1080
      end
      object cePartnerTag: TcxButtonEdit
        Left = 158
        Top = 389
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 44
        Width = 195
      end
      object cxLabel22: TcxLabel
        Left = 380
        Top = 7
        Caption = #1054#1073#1083#1072#1089#1090#1100
      end
      object ceRegion: TcxButtonEdit
        Left = 484
        Top = 6
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 46
        Width = 235
      end
      object cxLabel23: TcxLabel
        Left = 380
        Top = 41
        Caption = #1056#1072#1081#1086#1085
      end
      object ceProvince: TcxButtonEdit
        Left = 484
        Top = 40
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 48
        Width = 235
      end
      object cxLabel24: TcxLabel
        Left = 380
        Top = 71
        Caption = #1042#1080#1076' '#1085#1072#1089'.'#1087#1091#1085#1082#1090#1072
      end
      object ceCityKind: TcxButtonEdit
        Left = 484
        Top = 70
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 50
        Width = 235
      end
      object cxLabel25: TcxLabel
        Left = 380
        Top = 101
        Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
      end
      object ceCity: TcxButtonEdit
        Left = 485
        Top = 100
        Properties.AutoSelect = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        TabOrder = 52
        Width = 235
      end
      object cxLabel26: TcxLabel
        Left = 380
        Top = 131
        Caption = #1052#1080#1082#1088#1086#1088#1072#1081#1086#1085
      end
      object ceProvinceCity: TcxButtonEdit
        Left = 484
        Top = 130
        Properties.AutoSelect = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        TabOrder = 54
        Width = 235
      end
      object cxLabel27: TcxLabel
        Left = 380
        Top = 191
        Caption = #1042#1080#1076
      end
      object ceStreetKind: TcxButtonEdit
        Left = 484
        Top = 190
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 56
        Width = 235
      end
      object cxLabel28: TcxLabel
        Left = 380
        Top = 161
        Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1080#1085#1076#1077#1082#1089
      end
      object edPostalCode: TcxTextEdit
        Left = 484
        Top = 160
        TabOrder = 57
        Width = 235
      end
      object cbEdiOrdspr: TcxCheckBox
        Left = 15
        Top = 30
        Caption = 'EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
        TabOrder = 58
        Width = 134
      end
      object cbEdiDesadv: TcxCheckBox
        Left = 233
        Top = 30
        Caption = 'EDI - '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
        TabOrder = 59
        Width = 120
      end
      object cbEdiInvoice: TcxCheckBox
        Left = 155
        Top = 29
        Caption = 'EDI - '#1057#1095#1077#1090
        TabOrder = 61
        Width = 76
      end
      object cxLabel29: TcxLabel
        Left = 130
        Top = 54
        Caption = 'GLN - '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
      end
      object edGLNCodeJuridical: TcxTextEdit
        Left = 15
        Top = 71
        TabOrder = 63
        Width = 100
      end
      object cxLabel30: TcxLabel
        Left = 15
        Top = 54
        Caption = 'GLN - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
      end
      object edGLNCodeRetail: TcxTextEdit
        Left = 130
        Top = 71
        TabOrder = 64
        Width = 100
      end
      object edGLNCodeCorporate: TcxTextEdit
        Left = 253
        Top = 71
        TabOrder = 67
        Width = 100
      end
      object cxLabel31: TcxLabel
        Left = 253
        Top = 54
        Caption = 'GLN - '#1087#1086#1089#1090#1072#1074#1097#1080#1082
      end
      object cxLabel32: TcxLabel
        Left = 380
        Top = 296
        Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088'  '#1089#1074'-'#1074' '#1090#1086#1074'.'
      end
      object ceGoodsProperty: TcxButtonEdit
        Left = 515
        Top = 295
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 68
        Width = 204
      end
      object cbValue1: TcxCheckBox
        Left = 473
        Top = 423
        Caption = #1055#1085'.'
        TabOrder = 69
        Width = 39
      end
      object cbValue2: TcxCheckBox
        Left = 509
        Top = 423
        Caption = #1042#1090'.'
        TabOrder = 70
        Width = 38
      end
      object cbValue3: TcxCheckBox
        Left = 544
        Top = 423
        Caption = #1057#1088'.'
        TabOrder = 71
        Width = 39
      end
      object cbValue4: TcxCheckBox
        Left = 580
        Top = 423
        Caption = #1063#1090'.'
        TabOrder = 72
        Width = 40
      end
      object cbValue5: TcxCheckBox
        Left = 615
        Top = 423
        Caption = #1055#1090'.'
        TabOrder = 73
        Width = 39
      end
      object cbValue6: TcxCheckBox
        Left = 650
        Top = 423
        Caption = #1057#1073'.'
        TabOrder = 74
        Width = 39
      end
      object cbValue7: TcxCheckBox
        Left = 687
        Top = 423
        ParentCustomHint = False
        Caption = #1042#1089'.'
        TabOrder = 77
        Width = 37
      end
      object cxLabel33: TcxLabel
        Left = 366
        Top = 423
        Caption = #1043#1088#1072#1092#1080#1082' '#1087#1086#1089#1077#1097#1077#1085#1080#1103':'
      end
      object cxLabel34: TcxLabel
        Left = 15
        Top = 419
        Caption = 'GPS ('#1096#1080#1088#1086#1090#1072')'
      end
      object edGPSN: TcxTextEdit
        Left = 89
        Top = 418
        Properties.ReadOnly = True
        TabOrder = 79
        Width = 92
      end
      object cxLabel35: TcxLabel
        Left = 187
        Top = 419
        Caption = 'GPS ('#1076#1086#1083#1075#1086#1090#1072')'
      end
      object edGPSE: TcxTextEdit
        Left = 261
        Top = 418
        Properties.ReadOnly = True
        TabOrder = 81
        Width = 92
      end
      object cxLabel36: TcxLabel
        Left = 366
        Top = 449
        Caption = #1043#1088#1072#1092#1080#1082' '#1079#1072#1074#1086#1079#1072':'
      end
      object cbDelivery1: TcxCheckBox
        Left = 473
        Top = 444
        Caption = #1055#1085'.'
        Properties.ReadOnly = True
        TabOrder = 82
        Width = 39
      end
      object cbDelivery2: TcxCheckBox
        Left = 509
        Top = 444
        Caption = #1042#1090'.'
        Properties.ReadOnly = True
        TabOrder = 83
        Width = 38
      end
      object cbDelivery3: TcxCheckBox
        Left = 544
        Top = 444
        Caption = #1057#1088'.'
        Properties.ReadOnly = True
        TabOrder = 84
        Width = 39
      end
      object cbDelivery4: TcxCheckBox
        Left = 580
        Top = 444
        Caption = #1063#1090'.'
        Properties.ReadOnly = True
        TabOrder = 85
        Width = 40
      end
      object cbDelivery5: TcxCheckBox
        Left = 615
        Top = 444
        Caption = #1055#1090'.'
        Properties.ReadOnly = True
        TabOrder = 86
        Width = 39
      end
      object cbDelivery6: TcxCheckBox
        Left = 650
        Top = 444
        Caption = #1057#1073'.'
        Properties.ReadOnly = True
        TabOrder = 87
        Width = 39
      end
      object cbDelivery7: TcxCheckBox
        Left = 687
        Top = 444
        ParentCustomHint = False
        Caption = #1042#1089'.'
        Properties.ReadOnly = True
        TabOrder = 89
        Width = 37
      end
      object cxLabel37: TcxLabel
        Left = 735
        Top = 71
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
      end
      object cePersonalMerch: TcxButtonEdit
        Left = 878
        Top = 70
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 91
        Width = 195
      end
      object cxLabel38: TcxLabel
        Left = 15
        Top = 361
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1058#1058
      end
      object edCategory: TcxCurrencyEdit
        Left = 158
        Top = 360
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Properties.EditFormat = '0'
        TabOrder = 93
        Width = 195
      end
      object cxLabel39: TcxLabel
        Left = 15
        Top = 275
        Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077')'
      end
      object edRoute30201: TcxButtonEdit
        Left = 158
        Top = 274
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 95
        Width = 195
      end
      object cxLabel40: TcxLabel
        Left = 380
        Top = 347
        Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077')'
      end
      object cePriceList30201: TcxButtonEdit
        Left = 529
        Top = 346
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 97
        Width = 190
      end
      object cxLabel47: TcxLabel
        Left = 15
        Top = 448
        Caption = #1055#1086#1076#1088#1072#1079#1076'.('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073'.)'
      end
      object edUnitMobile: TcxButtonEdit
        Left = 141
        Top = 447
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 99
        Width = 212
      end
      object cxLabel41: TcxLabel
        Left = 366
        Top = 472
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077'('#1076#1083#1103' '#1087#1088#1086#1076#1072#1078#1080')'
      end
      object edMovementComment: TcxTextEdit
        Left = 509
        Top = 471
        TabOrder = 100
        Width = 210
      end
      object edTaxSale_Personal: TcxCurrencyEdit
        Left = 1019
        Top = 220
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 102
        Width = 54
      end
      object cxLabel42: TcxLabel
        Left = 735
        Top = 222
        Caption = #1057#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088' - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
      end
      object edTaxSale_PersonalTrade: TcxCurrencyEdit
        Left = 1019
        Top = 246
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 104
        Width = 54
      end
      object cxLabel43: TcxLabel
        Left = 736
        Top = 247
        Caption = #1058#1055' - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
      end
      object edTaxSale_MemberSaler1: TcxCurrencyEdit
        Left = 1019
        Top = 274
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 106
        Width = 54
      end
      object cxLabel44: TcxLabel
        Left = 735
        Top = 275
        Caption = #1055#1088#1086#1076#1072#1074#1077#1094'-1 - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
      end
      object edTaxSale_MemberSaler2: TcxCurrencyEdit
        Left = 1019
        Top = 303
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 109
        Width = 54
      end
      object cxLabel45: TcxLabel
        Left = 735
        Top = 304
        Caption = #1055#1088#1086#1076#1072#1074#1077#1094'-2 - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
      end
      object cxLabel46: TcxLabel
        Left = 735
        Top = 161
        Caption = #1060#1080#1079' '#1083#1080#1094#1086' ('#1055#1088#1086#1076#1072#1074#1077#1094'-1)'
      end
      object edMemberSaler1: TcxButtonEdit
        Left = 878
        Top = 160
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 111
        Width = 195
      end
      object cxLabel48: TcxLabel
        Left = 735
        Top = 191
        Caption = #1060#1080#1079' '#1083#1080#1094#1086' ('#1055#1088#1086#1076#1072#1074#1077#1094'-2)'
      end
      object edMemberSaler2: TcxButtonEdit
        Left = 878
        Top = 190
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 112
        Width = 195
      end
      object edBranchCode: TcxTextEdit
        Left = 736
        Top = 370
        TabOrder = 114
        Width = 81
      end
      object cxLabel49: TcxLabel
        Left = 736
        Top = 347
        Caption = #1053#1086#1084#1077#1088' '#1092#1080#1083#1080#1072#1083#1072
      end
      object edBranchJur: TcxTextEdit
        Left = 832
        Top = 370
        TabOrder = 117
        Width = 241
      end
      object cxLabel50: TcxLabel
        Left = 832
        Top = 347
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1102#1088'.'#1083#1080#1094#1072' '#1076#1083#1103' '#1092#1080#1083#1080#1072#1083#1072
      end
      object cxLabel51: TcxLabel
        Left = 736
        Top = 398
        Caption = #1050#1086#1076' '#1090#1077#1088#1084#1080#1085#1072#1083#1072
      end
      object edTerminal: TcxTextEdit
        Left = 735
        Top = 419
        TabOrder = 119
        Width = 81
      end
      object cxLabel52: TcxLabel
        Left = 735
        Top = 101
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
      end
      object edPersonalSigning: TcxButtonEdit
        Left = 878
        Top = 100
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 120
        Width = 195
      end
      object cbEdiOrdspr_vch: TcxCheckBox
        Left = 16
        Top = 501
        Caption = #1042#1063#1040#1057#1053#1054' - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
        TabOrder = 121
        Width = 160
      end
      object cbEdiInvoice_vch: TcxCheckBox
        Left = 184
        Top = 501
        Caption = #1042#1063#1040#1057#1053#1054' - '#1057#1095#1077#1090
        TabOrder = 122
        Width = 102
      end
      object cbEdiDesadv_vch: TcxCheckBox
        Left = 291
        Top = 501
        Caption = #1042#1063#1040#1057#1053#1054' - '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
        TabOrder = 124
        Width = 154
      end
      object cxLabel53: TcxLabel
        Left = 15
        Top = 478
        Caption = #1042#1063#1040#1057#1053#1054' - '#1050#1086#1076' GLN - '#1055#1086#1089#1090#1072#1074#1097#1080#1082
      end
      object edGLNCodeCorporate_vch: TcxTextEdit
        Left = 182
        Top = 476
        TabOrder = 127
        Width = 171
      end
      object cxLabel54: TcxLabel
        Left = 736
        Top = 449
        Caption = #1063#1077#1088#1077#1079' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1086#1092#1086#1088#1084'. '#1076#1086#1082'. ('#1052#1103#1089#1085'.'#1089#1099#1088#1100#1077')'
      end
      object cxLabel55: TcxLabel
        Left = 736
        Top = 472
        Caption = #1047#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1085#1080#1084'-'#1089#1103' '#1079#1072#1082#1072#1079' ('#1052#1103#1089#1085'.'#1089#1099#1088#1100#1077')'
      end
      object edPrepareDayCount_30201: TcxCurrencyEdit
        Left = 988
        Top = 472
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Properties.EditFormat = '0'
        TabOrder = 128
        Width = 85
      end
      object edDocumentDayCount_30201: TcxCurrencyEdit
        Left = 988
        Top = 447
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Properties.EditFormat = '0'
        TabOrder = 129
        Width = 85
      end
      object cbDayCount_30201: TcxCheckBox
        Left = 871
        Top = 419
        Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1072' '#1089#1093#1077#1084#1072' ('#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077')'
        TabOrder = 130
        Width = 202
      end
      object cxLabel57: TcxLabel
        Left = 15
        Top = 529
        Caption = #1058#1080#1087' '#1086#1090#1075#1088#1091#1079#1082#1080
      end
      object edTypeCommerc: TcxButtonEdit
        Left = 141
        Top = 528
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 132
        Width = 212
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1082#1086#1084#1077#1088#1094#1110#1111
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = False
      DesignSize = (
        1075
        553)
      object cxLabel56: TcxLabel
        Left = 17
        Top = 0
        Caption = #1052#1072#1088#1096#1088#1091#1090' '#1058#1058
      end
      object ceRouteTT: TcxButtonEdit
        Left = 17
        Top = 15
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 248
      end
      object cxLabel59: TcxLabel
        Left = 287
        Top = 0
        Caption = #1043#1088#1091#1087#1087#1072' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      end
      object edPersonalGroupCommerc: TcxButtonEdit
        Left = 287
        Top = 16
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 4
        Width = 273
      end
      object cxLabel72: TcxLabel
        Left = 582
        Top = 0
        Caption = #1054#1090#1076#1077#1083' '#1082#1086#1084#1084#1077#1088#1094#1080#1080
      end
      object edUnitCommerc: TcxButtonEdit
        Left = 582
        Top = 15
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 6
        Width = 273
      end
      object Panel1: TPanel
        Left = 17
        Top = 68
        Width = 854
        Height = 291
        Anchors = [akTop]
        BevelWidth = 5
        BiDiMode = bdLeftToRight
        BorderStyle = bsSingle
        Caption = #1056#1086#1079#1076#1088#1110#1073
        DoubleBuffered = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentBackground = False
        ParentDoubleBuffered = False
        ParentFont = False
        ParentShowHint = False
        ShowCaption = False
        ShowHint = False
        TabOrder = 0
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        object cxLabel66: TcxLabel
          Left = 13
          Top = 2
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 1)'
          Style.TextColor = clWindowText
        end
        object cePosition_1: TcxButtonEdit
          Left = 271
          Top = 21
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 2
          Width = 273
        end
        object cxLabel61: TcxLabel
          Left = 271
          Top = 51
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 2) '#9
        end
        object cePosition_2: TcxButtonEdit
          Left = 271
          Top = 70
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 6
          Width = 273
        end
        object cxLabel62: TcxLabel
          Left = 271
          Top = 98
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 3) '#9
        end
        object cePosition_3: TcxButtonEdit
          Left = 271
          Top = 117
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 10
          Width = 273
        end
        object cxLabel63: TcxLabel
          Left = 271
          Top = 142
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 4)'
        end
        object cePosition_4: TcxButtonEdit
          Left = 271
          Top = 162
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 15
          Width = 273
        end
        object cxLabel64: TcxLabel
          Left = 273
          Top = 188
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 5)'
        end
        object cePosition_5: TcxButtonEdit
          Left = 271
          Top = 207
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 19
          Width = 273
        end
        object cxLabel65: TcxLabel
          Left = 271
          Top = 237
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 6) '#9
        end
        object cePosition_6: TcxButtonEdit
          Left = 271
          Top = 255
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 23
          Width = 273
        end
        object edPersonal_1: TcxButtonEdit
          Left = 12
          Top = 24
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 13
          Width = 248
        end
        object edPersonal_2: TcxButtonEdit
          Left = 12
          Top = 70
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 14
          Width = 248
        end
        object cxLabel68: TcxLabel
          Left = 12
          Top = 98
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 3)'
        end
        object edPersonal_3: TcxButtonEdit
          Left = 12
          Top = 117
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 16
          Width = 248
        end
        object edPersonal_4: TcxButtonEdit
          Left = 12
          Top = 162
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 17
          Width = 248
        end
        object cxLabel69: TcxLabel
          Left = 12
          Top = 142
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 4)'
        end
        object cxLabel70: TcxLabel
          Left = 12
          Top = 188
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 5)'
        end
        object edPersonal_5: TcxButtonEdit
          Left = 12
          Top = 207
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 20
          Width = 248
        end
        object edPersonal_6: TcxButtonEdit
          Left = 12
          Top = 255
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 21
          Width = 248
        end
        object cxLabel71: TcxLabel
          Left = 12
          Top = 237
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 6)'
        end
        object cxLabel60Unit: TcxLabel
          Left = 557
          Top = 2
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 1)'
        end
        object ceUnit_1: TcxButtonEdit
          Left = 557
          Top = 21
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 1
          Width = 273
        end
        object cxLabel61Unit: TcxLabel
          Left = 557
          Top = 51
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 2) '#9
        end
        object ceUnit_2: TcxButtonEdit
          Left = 557
          Top = 70
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 3
          Width = 273
        end
        object cxLabel62Unit: TcxLabel
          Left = 557
          Top = 98
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 3) '#9
        end
        object ceUnit_3: TcxButtonEdit
          Left = 557
          Top = 117
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 5
          Width = 273
        end
        object cxLabel63Unit: TcxLabel
          Left = 557
          Top = 142
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 4)'
        end
        object ceUnit_4: TcxButtonEdit
          Left = 557
          Top = 162
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 7
          Width = 273
        end
        object cxLabel64Unit: TcxLabel
          Left = 557
          Top = 188
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 5)'
        end
        object ceUnit_5: TcxButtonEdit
          Left = 557
          Top = 207
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 9
          Width = 273
        end
        object cxLabel65Unit: TcxLabel
          Left = 557
          Top = 237
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 6) '#9
        end
        object ceUnit_6: TcxButtonEdit
          Left = 557
          Top = 255
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 11
          Width = 273
        end
        object cxLabel60: TcxLabel
          Left = 271
          Top = 2
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 1)'
        end
        object cxLabel67: TcxLabel
          Left = 12
          Top = 51
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 2)'
        end
      end
      object Panel2: TPanel
        Left = 17
        Top = 385
        Width = 854
        Height = 162
        Anchors = [akTop]
        BevelWidth = 5
        BiDiMode = bdLeftToRight
        BorderStyle = bsSingle
        Caption = #1056#1086#1079#1076#1088#1110#1073
        DoubleBuffered = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentBackground = False
        ParentDoubleBuffered = False
        ParentFont = False
        ParentShowHint = False
        ShowCaption = False
        ShowHint = False
        TabOrder = 7
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        object cxLabel58: TcxLabel
          Left = 12
          Top = 2
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 1)'
          Style.TextColor = clWindowText
        end
        object cePosition_1ret: TcxButtonEdit
          Left = 271
          Top = 21
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 2
          Width = 273
        end
        object cxLabel73: TcxLabel
          Left = 271
          Top = 51
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 2) '#9
        end
        object cePosition_2ret: TcxButtonEdit
          Left = 271
          Top = 70
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 6
          Width = 273
        end
        object cxLabel74: TcxLabel
          Left = 271
          Top = 98
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 3) '#9
        end
        object cePosition_3ret: TcxButtonEdit
          Left = 271
          Top = 117
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 8
          Width = 273
        end
        object edPersonal_1ret: TcxButtonEdit
          Left = 12
          Top = 21
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 9
          Width = 248
        end
        object edPersonal_2ret: TcxButtonEdit
          Left = 12
          Top = 70
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 10
          Width = 248
        end
        object cxLabel78: TcxLabel
          Left = 12
          Top = 98
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 3)'
        end
        object edPersonal_3ret: TcxButtonEdit
          Left = 12
          Top = 117
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 11
          Width = 248
        end
        object cxLabel82: TcxLabel
          Left = 557
          Top = 2
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 1)'
        end
        object ceUnit_1ret: TcxButtonEdit
          Left = 557
          Top = 21
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 1
          Width = 273
        end
        object cxLabel83: TcxLabel
          Left = 557
          Top = 51
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 2) '#9
        end
        object ceUnit_2ret: TcxButtonEdit
          Left = 557
          Top = 70
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 3
          Width = 273
        end
        object cxLabel84: TcxLabel
          Left = 557
          Top = 98
          Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' ('#1056#1110#1074#1077#1085#1100' 3) '#9
        end
        object ceUnit_3ret: TcxButtonEdit
          Left = 557
          Top = 117
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          TabOrder = 5
          Width = 273
        end
        object cxLabel88: TcxLabel
          Left = 271
          Top = 2
          Caption = #1055#1086#1089#1072#1076#1072' ('#1056#1110#1074#1077#1085#1100' 1)'
        end
        object cxLabel89: TcxLabel
          Left = 12
          Top = 51
          Caption = #1057#1087#1110#1074#1088#1086#1073#1110#1090#1085#1080#1082' ('#1056#1110#1074#1077#1085#1100' 2)'
        end
      end
      object cxLabel75: TcxLabel
        Left = 17
        Top = 49
        Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1082#1086#1084#1077#1088#1094#1110#1111': '#1056#1086#1079#1076#1088#1110#1073
        Style.BorderColor = clBackground
        Style.TextColor = clBlue
        Style.TextStyle = [fsBold]
      end
      object cxLabel76: TcxLabel
        Left = 17
        Top = 365
        Caption = #1057#1090#1088#1091#1082#1090#1091#1088#1072' '#1082#1086#1084#1077#1088#1094#1110#1111': '#1052#1077#1088#1077#1078#1110
        Style.BorderColor = clBackground
        Style.TextColor = clBlue
        Style.TextStyle = [fsBold]
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 899
    Top = 286
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 208
    Top = 200
  end
  inherited ActionList: TActionList
    Left = 999
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGet_Commerc
        end>
    end
    object actUpdate_Commerc: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_Commerc
      StoredProcList = <
        item
          StoredProc = spUpdate_Commerc
        end
        item
          StoredProc = spGet_Commerc
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaskId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 130
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Partner'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartnerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartnerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAddress'
        Value = ''
        Component = edAddress
        DataType = ftString
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
        Name = 'inShortName'
        Value = ''
        Component = edShortName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCodeJuridical'
        Value = Null
        Component = edGLNCodeJuridical
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCodeRetail'
        Value = Null
        Component = edGLNCodeRetail
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCodeCorporate'
        Value = Null
        Component = edGLNCodeCorporate
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchCode'
        Value = Null
        Component = edBranchCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchJur'
        Value = Null
        Component = edBranchJur
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTerminal'
        Value = Null
        Component = edTerminal
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHouseNumber'
        Value = ''
        Component = edHouseNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCaseNumber'
        Value = ''
        Component = edCaseNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRoomNumber'
        Value = ''
        Component = edRoomNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStreetId'
        Value = ''
        Component = StreetGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrepareDayCount'
        Value = 0.000000000000000000
        Component = cePrepareDayCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentDayCount'
        Value = 0.000000000000000000
        Component = ceDocumentDayCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrepareDayCount_30201'
        Value = Null
        Component = edPrepareDayCount_30201
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentDayCount_30201'
        Value = Null
        Component = edDocumentDayCount_30201
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCategory'
        Value = Null
        Component = edCategory
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxSale_Personal'
        Value = Null
        Component = edTaxSale_Personal
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxSale_PersonalTrade'
        Value = Null
        Component = edTaxSale_PersonalTrade
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxSale_MemberSaler1'
        Value = Null
        Component = edTaxSale_MemberSaler1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxSale_MemberSaler2'
        Value = Null
        Component = edTaxSale_MemberSaler2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDayCount_30201'
        Value = Null
        Component = cbDayCount_30201
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEdiOrdspr'
        Value = Null
        Component = cbEdiOrdspr
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEdiInvoice'
        Value = Null
        Component = cbEdiInvoice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEdiDesadv'
        Value = Null
        Component = cbEdiDesadv
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEdiOrdspr_vch'
        Value = Null
        Component = cbEdiOrdspr_vch
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEdiInvoice_vch'
        Value = Null
        Component = cbEdiInvoice_vch
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEdiDesadv_vch'
        Value = Null
        Component = cbEdiDesadv_vch
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCodeCorporate_vch'
        Value = Null
        Component = edGLNCodeCorporate_vch
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = dsdRouteGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId_30201'
        Value = Null
        Component = GuidesRoute30201
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteSortingId'
        Value = ''
        Component = dsdRouteSortingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        Component = GuidesRouteTT
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberTakeId'
        Value = ''
        Component = GuidesMemberTake
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberSaler1Id'
        Value = Null
        Component = GuidesMemberSaler1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberSaler2Id'
        Value = Null
        Component = GuidesMemberSaler2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalMerchId'
        Value = Null
        Component = GuidesPersonalMerch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalSigningId'
        Value = Null
        Component = GuidesPersonalSigning
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerTagId'
        Value = ''
        Component = PartnerTagGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        Component = GoodsPropertyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_30201'
        Value = Null
        Component = GuidesPriceList30201
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListPromoId'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitMobileId'
        Value = Null
        Component = GuidesUnitMobile
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTypeCommercId'
        Value = Null
        Component = GuidesTypeCommerc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        Component = GuidesUnitCommerc
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = 0d
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = 0d
        Component = edEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegionName'
        Value = ''
        Component = ceRegion
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProvinceName'
        Value = ''
        Component = ceProvince
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCityName'
        Value = ''
        Component = ceCity
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCityKindId'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProvinceCityName'
        Value = ''
        Component = ceProvinceCity
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPostalCode'
        Value = ''
        Component = edPostalCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStreetName'
        Value = ''
        Component = ceStreet
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStreetKindId'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = cbValue1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = cbValue2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = cbValue3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = cbValue4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = cbValue5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = cbValue6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = cbValue7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementComment'
        Value = Null
        Component = edMovementComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 832
    Top = 335
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Partner'
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaskId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = FormParams
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShortName'
        Value = ''
        Component = edShortName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCodeJuridical'
        Value = Null
        Component = edGLNCodeJuridical
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCodeRetail'
        Value = Null
        Component = edGLNCodeRetail
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCodeCorporate'
        Value = Null
        Component = edGLNCodeCorporate
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = ''
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HouseNumber'
        Value = ''
        Component = edHouseNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CaseNumber'
        Value = ''
        Component = edCaseNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RoomNumber'
        Value = ''
        Component = edRoomNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StreetId'
        Value = ''
        Component = StreetGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StreetName'
        Value = ''
        Component = StreetGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PrepareDayCount'
        Value = 0.000000000000000000
        Component = cePrepareDayCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentDayCount'
        Value = 0.000000000000000000
        Component = ceDocumentDayCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'EdiOrdspr'
        Value = Null
        Component = cbEdiOrdspr
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'EdiInvoice'
        Value = Null
        Component = cbEdiInvoice
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'EdiDesadv'
        Value = Null
        Component = cbEdiDesadv
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteId'
        Value = ''
        Component = dsdRouteGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName'
        Value = ''
        Component = dsdRouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = ''
        Component = dsdRouteSortingGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = ''
        Component = dsdRouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberTakeId'
        Value = ''
        Component = GuidesMemberTake
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberTakeName'
        Value = ''
        Component = GuidesMemberTake
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeId'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeName'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalMerchId'
        Value = Null
        Component = GuidesPersonalMerch
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalMerchName'
        Value = Null
        Component = GuidesPersonalMerch
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaId'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaName'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerTagId'
        Value = ''
        Component = PartnerTagGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerTagName'
        Value = ''
        Component = PartnerTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        Component = GoodsPropertyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = Null
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListPromoId'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListPromoName'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = 0d
        Component = edStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = 0d
        Component = edEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PostalCode'
        Value = ''
        Component = edPostalCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProvinceCityName'
        Value = ''
        Component = ProvinceCityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName'
        Value = ''
        Component = CityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityKindName'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityKindId'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegionName'
        Value = ''
        Component = GuidesRegion
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProvinceName'
        Value = ''
        Component = GuidesProvince
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StreetKindName'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StreetKindId'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value1'
        Value = Null
        Component = cbValue1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value2'
        Value = Null
        Component = cbValue2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value3'
        Value = Null
        Component = cbValue3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value4'
        Value = Null
        Component = cbValue4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value5'
        Value = Null
        Component = cbValue5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value6'
        Value = Null
        Component = cbValue6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value7'
        Value = Null
        Component = cbValue7
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'GPSE'
        Value = Null
        Component = edGPSE
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GPSN'
        Value = Null
        Component = edGPSN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Delivery1'
        Value = Null
        Component = cbDelivery1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Delivery2'
        Value = Null
        Component = cbDelivery2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Delivery3'
        Value = Null
        Component = cbDelivery3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Delivery5'
        Value = Null
        Component = cbDelivery5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Delivery4'
        Value = Null
        Component = cbDelivery4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Delivery6'
        Value = Null
        Component = cbDelivery6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Delivery7'
        Value = Null
        Component = cbDelivery7
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Category'
        Value = Null
        Component = edCategory
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId_30201'
        Value = Null
        Component = GuidesPriceList30201
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName_30201'
        Value = Null
        Component = GuidesPriceList30201
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteId_30201'
        Value = Null
        Component = GuidesRoute30201
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName_30201'
        Value = Null
        Component = GuidesRoute30201
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitMobileId'
        Value = Null
        Component = GuidesUnitMobile
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitMobileName'
        Value = Null
        Component = GuidesUnitMobile
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementComment'
        Value = Null
        Component = edMovementComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSaler1Id'
        Value = Null
        Component = GuidesMemberSaler1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSaler1Name'
        Value = Null
        Component = GuidesMemberSaler1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSaler2Id'
        Value = Null
        Component = GuidesMemberSaler2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSaler2Name'
        Value = Null
        Component = GuidesMemberSaler2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxSale_Personal'
        Value = Null
        Component = edTaxSale_Personal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxSale_PersonalTrade'
        Value = Null
        Component = edTaxSale_PersonalTrade
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxSale_MemberSaler1'
        Value = Null
        Component = edTaxSale_MemberSaler1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxSale_MemberSaler2'
        Value = Null
        Component = edTaxSale_MemberSaler2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchCode'
        Value = Null
        Component = edBranchCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchJur'
        Value = Null
        Component = edBranchJur
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Terminal'
        Value = Null
        Component = edTerminal
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalSigningId'
        Value = Null
        Component = GuidesPersonalSigning
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalSigningName'
        Value = Null
        Component = GuidesPersonalSigning
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCodeCorporate_vch'
        Value = Null
        Component = edGLNCodeCorporate_vch
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EdiDesadv_vch'
        Value = Null
        Component = cbEdiDesadv_vch
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'EdiInvoice_vch'
        Value = Null
        Component = cbEdiInvoice_vch
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'EdiOrdspr_vch'
        Value = Null
        Component = cbEdiOrdspr_vch
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentDayCount_30201'
        Value = Null
        Component = edDocumentDayCount_30201
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PrepareDayCount_30201'
        Value = Null
        Component = edPrepareDayCount_30201
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDayCount_30201'
        Value = Null
        Component = cbDayCount_30201
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteTTId'
        Value = Null
        Component = GuidesRouteTT
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteTTName'
        Value = Null
        Component = GuidesRouteTT
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TypeCommercId'
        Value = Null
        Component = GuidesTypeCommerc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TypeCommercName'
        Value = Null
        Component = GuidesTypeCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCommercId'
        Value = Null
        Component = GuidesUnitCommerc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCommercName'
        Value = Null
        Component = GuidesUnitCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupCommercId'
        Value = Null
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupCommercName'
        Value = Null
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 928
    Top = 340
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 354
  end
  object GuidesMemberTake: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMemberTake
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberTake
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberTake
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 936
    Top = 120
  end
  object dsdRouteSortingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteSortingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdRouteSortingGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdRouteSortingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 261
  end
  object dsdRouteGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdRouteGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdRouteGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 172
  end
  object dsdPriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceList
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdPriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 302
  end
  object dsdPriceListPromoGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceListPromo
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdPriceListPromoGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 608
    Top = 350
  end
  object StreetGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStreet
    FormNameParam.Value = 'TStreetForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStreetForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = StreetGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = StreetGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 496
    Top = 187
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 976
    Top = 65525
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 928
    Top = 37
  end
  object AreaGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AreaGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 346
  end
  object PartnerTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerTag
    FormNameParam.Value = 'TPartnerTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerTagGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 361
  end
  object GuidesRegion: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRegion
    FormNameParam.Value = 'TRegionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRegionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRegion
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRegion
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 752
    Top = 43
  end
  object GuidesProvince: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProvince
    FormNameParam.Value = 'TProvinceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProvinceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProvince
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProvince
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 808
    Top = 67
  end
  object CityKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCityKind
    FormNameParam.Value = 'TCityKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCityKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CityKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 752
    Top = 107
  end
  object CityGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCity
    FormNameParam.Value = 'TCityForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCityForm'
    PositionDataSet = 'ClientDataSet'
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
      end
      item
        Name = 'ProvinceId'
        Value = Null
        Component = GuidesProvince
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProvinceName'
        Value = Null
        Component = GuidesProvince
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegionId'
        Value = Null
        Component = GuidesRegion
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegionName'
        Value = Null
        Component = GuidesRegion
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityKindId'
        Value = Null
        Component = CityKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityKindName'
        Value = Null
        Component = CityKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 656
    Top = 107
  end
  object ProvinceCityGuides: TdsdGuides
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
        Component = ProvinceCityGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProvinceCityGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 131
  end
  object StreetKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStreetKind
    FormNameParam.Value = 'TStreetKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStreetKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = StreetKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 648
    Top = 163
  end
  object GoodsPropertyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
    Top = 291
  end
  object GuidesPersonalMerch: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalMerch
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalMerch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalMerch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1016
    Top = 53
  end
  object GuidesRoute30201: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute30201
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute30201
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute30201
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 259
  end
  object GuidesPriceList30201: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceList30201
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceList30201
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceList30201
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 480
    Top = 237
  end
  object GuidesUnitMobile: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitMobile
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitMobile
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitMobile
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 896
    Top = 228
  end
  object GuidesMemberSaler1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberSaler1
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberSaler1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberSaler1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 976
    Top = 160
  end
  object GuidesMemberSaler2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberSaler2
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberSaler2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberSaler2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 904
    Top = 184
  end
  object GuidesPersonalSigning: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalSigning
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalSigning
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalSigning
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 976
    Top = 91
  end
  object GuidesRouteTT: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRouteTT
    FormNameParam.Value = 'TRouteTTForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteTTForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRouteTT
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRouteTT
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnitCommerc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnitCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = Null
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 169
    Top = 43
  end
  object GuidesTypeCommerc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTypeCommerc
    FormNameParam.Value = 'TTypeCommercForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTypeCommercForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTypeCommerc
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTypeCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 45
  end
  object GuidesUnitCommerc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitCommerc
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitCommerc
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 45
  end
  object GuidesPersonalGroupCommerc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalGroupCommerc
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 454
    Top = 37
  end
  object GuidesPosition_1: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 348
    Top = 101
  end
  object GuidesPosition_2: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_2
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 388
    Top = 144
  end
  object GuidesPosition_3: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_3
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 380
    Top = 189
  end
  object GuidesPosition_4: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_4
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_4
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 380
    Top = 245
  end
  object GuidesPosition_5: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_5
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_5
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 372
    Top = 291
  end
  object GuidesPosition_6: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_6
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_6
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_6
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 460
    Top = 333
  end
  object GuidesUnit_1: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 716
    Top = 157
  end
  object GuidesUnit_2: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_2
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 772
    Top = 160
  end
  object GuidesUnit_3: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_3
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 772
    Top = 205
  end
  object GuidesUnit_4: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_4
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_4
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 764
    Top = 237
  end
  object GuidesUnit_5: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_5
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_5
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 772
    Top = 291
  end
  object GuidesUnit_6: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_6
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_6
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_6
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 748
    Top = 357
  end
  object Guides_Personal_1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_1
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 101
  end
  object Guides_Personal_2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_2
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 141
  end
  object Guides_Personal_3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_3
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_3
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 189
  end
  object Guides_Personal_4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_4
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_4
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 237
  end
  object Guides_Personal_5: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_5
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_5
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 277
  end
  object Guides_Personal_6: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_6
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_6
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_6
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 341
  end
  object spGet_Commerc: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Partner_Commerc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = 0
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId_1'
        Value = ''
        Component = Guides_Personal_1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_1'
        Value = ''
        Component = Guides_Personal_1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId_2'
        Value = ''
        Component = Guides_Personal_2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_2'
        Value = ''
        Component = Guides_Personal_2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId_3'
        Value = ''
        Component = Guides_Personal_3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_3'
        Value = ''
        Component = Guides_Personal_3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId_4'
        Value = ''
        Component = Guides_Personal_4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_4'
        Value = ''
        Component = Guides_Personal_4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId_5'
        Value = ''
        Component = Guides_Personal_5
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_5'
        Value = ''
        Component = Guides_Personal_5
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId_6'
        Value = ''
        Component = Guides_Personal_6
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_6'
        Value = ''
        Component = Guides_Personal_6
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId_1'
        Value = ''
        Component = GuidesPosition_1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_1'
        Value = ''
        Component = GuidesPosition_1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId_2'
        Value = ''
        Component = GuidesPosition_2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_2'
        Value = ''
        Component = GuidesPosition_2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId_3'
        Value = ''
        Component = GuidesPosition_3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_3'
        Value = ''
        Component = GuidesPosition_3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId_4'
        Value = ''
        Component = GuidesPosition_4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_4'
        Value = ''
        Component = GuidesPosition_4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId_5'
        Value = ''
        Component = GuidesPosition_5
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_5'
        Value = ''
        Component = GuidesPosition_5
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId_6'
        Value = ''
        Component = GuidesPosition_6
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_6'
        Value = ''
        Component = GuidesPosition_6
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId_1'
        Value = ''
        Component = GuidesUnit_1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_1'
        Value = ''
        Component = GuidesUnit_1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId_2'
        Value = ''
        Component = GuidesUnit_2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId_3'
        Value = ''
        Component = GuidesUnit_3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_2'
        Value = ''
        Component = GuidesUnit_2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_3'
        Value = ''
        Component = GuidesUnit_3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId_4'
        Value = ''
        Component = GuidesUnit_4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_4'
        Value = ''
        Component = GuidesUnit_4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId_5'
        Value = ''
        Component = GuidesUnit_5
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_5'
        Value = ''
        Component = GuidesUnit_5
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId_6'
        Value = ''
        Component = GuidesUnit_6
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_6'
        Value = ''
        Component = GuidesUnit_6
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_1ret'
        Value = Null
        Component = Guides_Personal_1ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_2ret'
        Value = Null
        Component = Guides_Personal_2ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName_3ret'
        Value = Null
        Component = Guides_Personal_3ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_1ret'
        Value = Null
        Component = GuidesPosition_1ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_2ret'
        Value = Null
        Component = GuidesPosition_21ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_3ret'
        Value = Null
        Component = GuidesPosition_3ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_1ret'
        Value = Null
        Component = GuidesUnit_1ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_2ret'
        Value = Null
        Component = GuidesUnit_2ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_3ret'
        Value = Null
        Component = GuidesUnit_3ret
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 992
    Top = 348
  end
  object GuidesUnit_1ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_1ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_1ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_1ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 700
    Top = 429
  end
  object GuidesUnit_2ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_2ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_2ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_2ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 684
    Top = 477
  end
  object GuidesUnit_3ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_3ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_3ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_3ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 732
    Top = 517
  end
  object GuidesPosition_1ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_1ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_1ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_1ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 404
    Top = 421
  end
  object GuidesPosition_21ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_2ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_21ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_21ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 444
    Top = 461
  end
  object GuidesPosition_3ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_3ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_3ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_3ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 412
    Top = 509
  end
  object Guides_Personal_1ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_1ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_1ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_1ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 413
  end
  object Guides_Personal_2ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_2ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_2ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_2ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 469
  end
  object Guides_Personal_3ret: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal_3ret
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Guides_Personal_3ret
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Guides_Personal_3ret
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 170
    Top = 513
  end
  object spUpdate_Commerc: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_Commerc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = 0
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteTTId'
        Value = ''
        Component = GuidesRouteTT
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitCommercId'
        Value = ''
        Component = GuidesUnitCommerc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupCommercId'
        Value = ''
        Component = GuidesPersonalGroupCommerc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 327
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edPersonalGroupCommerc
      end
      item
        Control = ceRouteTT
      end
      item
        Control = edUnitCommerc
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Action = actUpdate_Commerc
    Left = 920
    Top = 544
  end
end
