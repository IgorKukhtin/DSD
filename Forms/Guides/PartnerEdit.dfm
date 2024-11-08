inherited PartnerEditForm: TPartnerEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072'>'
  ClientHeight = 505
  ClientWidth = 1087
  ExplicitWidth = 1093
  ExplicitHeight = 534
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 816
    Top = 470
    TabOrder = 2
    ExplicitLeft = 816
    ExplicitTop = 470
  end
  inherited bbCancel: TcxButton
    Left = 948
    Top = 470
    ExplicitLeft = 948
    ExplicitTop = 470
  end
  object edAddress: TcxTextEdit [2]
    Left = 158
    Top = 160
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 195
  end
  object cxLabel1: TcxLabel [3]
    Left = 15
    Top = 161
    Caption = #1040#1076#1088#1077#1089
  end
  object Код: TcxLabel [4]
    Left = 15
    Top = 7
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 45
    Top = 6
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 54
  end
  object cxLabel2: TcxLabel [6]
    Left = 117
    Top = 7
    Caption = 'GLN - '#1084#1077#1089#1090#1086' '#1076#1086#1089#1090#1072#1074#1082#1080
  end
  object edGLNCode: TcxTextEdit [7]
    Left = 233
    Top = 6
    TabOrder = 5
    Width = 120
  end
  object cxLabel3: TcxLabel [8]
    Left = 15
    Top = 101
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edJuridical: TcxButtonEdit [9]
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
  object cxLabel4: TcxLabel [10]
    Left = 15
    Top = 219
    Caption = #1047#1072' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1085#1080#1084#1072#1077#1090#1089#1103' '#1079#1072#1082#1072#1079
  end
  object cxLabel5: TcxLabel [11]
    Left = 15
    Top = 189
    Caption = #1063#1077#1088#1077#1079' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1086#1092#1086#1088#1084#1083#1103#1077#1090#1089#1103' '#1076#1086#1082#1091#1084#1077#1085#1090
  end
  object cxLabel6: TcxLabel [12]
    Left = 15
    Top = 247
    Caption = #1052#1072#1088#1096#1088#1091#1090
  end
  object ceRoute: TcxButtonEdit [13]
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
  object cxLabel7: TcxLabel [14]
    Left = 203
    Top = 472
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
    Visible = False
  end
  object ceRouteSorting: TcxButtonEdit [15]
    Left = 253
    Top = 476
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
  object cxLabel8: TcxLabel [16]
    Left = 735
    Top = 131
    Caption = #1060#1080#1079'. '#1083#1080#1094#1086' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
  end
  object ceMemberTake: TcxButtonEdit [17]
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
  object cePrepareDayCount: TcxCurrencyEdit [18]
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
  object ceDocumentDayCount: TcxCurrencyEdit [19]
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
  object cxLabel9: TcxLabel [20]
    Left = 380
    Top = 321
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  end
  object cxLabel10: TcxLabel [21]
    Left = 8
    Top = 480
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1040#1082#1094#1080#1086#1085#1085#1099#1081')'
    Visible = False
  end
  object cePriceList: TcxButtonEdit [22]
    Left = 515
    Top = 320
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 204
  end
  object cePriceListPromo: TcxButtonEdit [23]
    Left = 103
    Top = 476
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
  object cxLabel11: TcxLabel [24]
    Left = 380
    Top = 380
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
  end
  object cxLabel12: TcxLabel [25]
    Left = 569
    Top = 380
    Caption = #1044#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1072#1082#1094#1080#1080
  end
  object edStartPromo: TcxDateEdit [26]
    Left = 380
    Top = 398
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 26
    Width = 120
  end
  object edEndPromo: TcxDateEdit [27]
    Left = 569
    Top = 397
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 27
    Width = 120
  end
  object cxLabel13: TcxLabel [28]
    Left = 15
    Top = 131
    Caption = #1059#1089#1083#1086#1074#1085#1086#1077' '#1086#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object edShortName: TcxTextEdit [29]
    Left = 158
    Top = 130
    TabOrder = 29
    Width = 195
  end
  object cxLabel14: TcxLabel [30]
    Left = 380
    Top = 221
    Caption = #1059#1083#1080#1094#1072'/'#1087#1088#1086#1089#1087#1077#1082#1090
  end
  object cxLabel15: TcxLabel [31]
    Left = 532
    Top = 247
    Caption = #1044#1086#1084':'
  end
  object cxLabel16: TcxLabel [32]
    Left = 628
    Top = 247
    Caption = #1050#1086#1088#1087#1091#1089':'
  end
  object cxLabel17: TcxLabel [33]
    Left = 458
    Top = 271
    Caption = #8470' '#1057#1082#1083#1072#1076#1072' '#1080#1083#1080' '#1082#1074'.:'
  end
  object ceStreet: TcxButtonEdit [34]
    Left = 484
    Top = 220
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 34
    Width = 235
  end
  object edHouseNumber: TcxTextEdit [35]
    Left = 562
    Top = 246
    TabOrder = 35
    Width = 45
  end
  object edCaseNumber: TcxTextEdit [36]
    Left = 674
    Top = 246
    TabOrder = 36
    Width = 45
  end
  object edRoomNumber: TcxTextEdit [37]
    Left = 562
    Top = 270
    TabOrder = 37
    Width = 157
  end
  object cxLabel18: TcxLabel [38]
    Left = 735
    Top = 7
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
  end
  object cePersonal: TcxButtonEdit [39]
    Left = 878
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 39
    Width = 195
  end
  object cxLabel19: TcxLabel [40]
    Left = 735
    Top = 41
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1090#1086#1088#1075#1086#1074#1099#1081')'
  end
  object cePersonalTrade: TcxButtonEdit [41]
    Left = 878
    Top = 40
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 41
    Width = 195
  end
  object cxLabel20: TcxLabel [42]
    Left = 15
    Top = 304
    Caption = #1056#1077#1075#1080#1086#1085
  end
  object ceArea: TcxButtonEdit [43]
    Left = 158
    Top = 303
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 195
  end
  object cxLabel21: TcxLabel [44]
    Left = 15
    Top = 361
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1090#1086#1095#1082#1080
  end
  object cePartnerTag: TcxButtonEdit [45]
    Left = 158
    Top = 360
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 45
    Width = 195
  end
  object cxLabel22: TcxLabel [46]
    Left = 380
    Top = 7
    Caption = #1054#1073#1083#1072#1089#1090#1100
  end
  object ceRegion: TcxButtonEdit [47]
    Left = 484
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 47
    Width = 235
  end
  object cxLabel23: TcxLabel [48]
    Left = 380
    Top = 41
    Caption = #1056#1072#1081#1086#1085
  end
  object ceProvince: TcxButtonEdit [49]
    Left = 484
    Top = 40
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 49
    Width = 235
  end
  object cxLabel24: TcxLabel [50]
    Left = 380
    Top = 71
    Caption = #1042#1080#1076' '#1085#1072#1089'.'#1087#1091#1085#1082#1090#1072
  end
  object ceCityKind: TcxButtonEdit [51]
    Left = 484
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 51
    Width = 235
  end
  object cxLabel25: TcxLabel [52]
    Left = 380
    Top = 101
    Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
  end
  object ceCity: TcxButtonEdit [53]
    Left = 484
    Top = 100
    Properties.AutoSelect = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 53
    Width = 235
  end
  object cxLabel26: TcxLabel [54]
    Left = 380
    Top = 131
    Caption = #1052#1080#1082#1088#1086#1088#1072#1081#1086#1085
  end
  object ceProvinceCity: TcxButtonEdit [55]
    Left = 484
    Top = 130
    Properties.AutoSelect = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 55
    Width = 235
  end
  object cxLabel27: TcxLabel [56]
    Left = 380
    Top = 191
    Caption = #1042#1080#1076
  end
  object ceStreetKind: TcxButtonEdit [57]
    Left = 484
    Top = 190
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 57
    Width = 235
  end
  object cxLabel28: TcxLabel [58]
    Left = 380
    Top = 161
    Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1080#1085#1076#1077#1082#1089
  end
  object edPostalCode: TcxTextEdit [59]
    Left = 484
    Top = 160
    TabOrder = 59
    Width = 235
  end
  object cbEdiOrdspr: TcxCheckBox [60]
    Left = 15
    Top = 29
    Caption = 'EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
    TabOrder = 60
    Width = 134
  end
  object cbEdiDesadv: TcxCheckBox [61]
    Left = 233
    Top = 30
    Caption = 'EDI - '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
    TabOrder = 61
    Width = 120
  end
  object cbEdiInvoice: TcxCheckBox [62]
    Left = 155
    Top = 29
    Caption = 'EDI - '#1057#1095#1077#1090
    TabOrder = 62
    Width = 76
  end
  object cxLabel29: TcxLabel [63]
    Left = 130
    Top = 54
    Caption = 'GLN - '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1100
  end
  object edGLNCodeJuridical: TcxTextEdit [64]
    Left = 15
    Top = 71
    TabOrder = 64
    Width = 100
  end
  object cxLabel30: TcxLabel [65]
    Left = 15
    Top = 54
    Caption = 'GLN - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
  end
  object edGLNCodeRetail: TcxTextEdit [66]
    Left = 130
    Top = 71
    TabOrder = 66
    Width = 100
  end
  object edGLNCodeCorporate: TcxTextEdit [67]
    Left = 253
    Top = 71
    TabOrder = 67
    Width = 100
  end
  object cxLabel31: TcxLabel [68]
    Left = 255
    Top = 54
    Caption = 'GLN - '#1087#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object cxLabel32: TcxLabel [69]
    Left = 380
    Top = 296
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088'  '#1089#1074'-'#1074' '#1090#1086#1074'.'
  end
  object ceGoodsProperty: TcxButtonEdit [70]
    Left = 515
    Top = 295
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 70
    Width = 204
  end
  object cbValue1: TcxCheckBox [71]
    Left = 473
    Top = 423
    Caption = #1055#1085'.'
    TabOrder = 71
    Width = 39
  end
  object cbValue2: TcxCheckBox [72]
    Left = 509
    Top = 423
    Caption = #1042#1090'.'
    TabOrder = 72
    Width = 38
  end
  object cbValue3: TcxCheckBox [73]
    Left = 544
    Top = 423
    Caption = #1057#1088'.'
    TabOrder = 73
    Width = 39
  end
  object cbValue4: TcxCheckBox [74]
    Left = 580
    Top = 423
    Caption = #1063#1090'.'
    TabOrder = 74
    Width = 40
  end
  object cbValue5: TcxCheckBox [75]
    Left = 615
    Top = 423
    Caption = #1055#1090'.'
    TabOrder = 75
    Width = 39
  end
  object cbValue6: TcxCheckBox [76]
    Left = 650
    Top = 423
    Caption = #1057#1073'.'
    TabOrder = 76
    Width = 39
  end
  object cbValue7: TcxCheckBox [77]
    Left = 687
    Top = 423
    ParentCustomHint = False
    Caption = #1042#1089'.'
    TabOrder = 77
    Width = 37
  end
  object cxLabel33: TcxLabel [78]
    Left = 366
    Top = 423
    Caption = #1043#1088#1072#1092#1080#1082' '#1087#1086#1089#1077#1097#1077#1085#1080#1103':'
  end
  object cxLabel34: TcxLabel [79]
    Left = 15
    Top = 390
    Caption = 'GPS ('#1096#1080#1088#1086#1090#1072')'
  end
  object edGPSN: TcxTextEdit [80]
    Left = 89
    Top = 389
    Properties.ReadOnly = True
    TabOrder = 80
    Width = 92
  end
  object cxLabel35: TcxLabel [81]
    Left = 187
    Top = 390
    Caption = 'GPS ('#1076#1086#1083#1075#1086#1090#1072')'
  end
  object edGPSE: TcxTextEdit [82]
    Left = 261
    Top = 389
    Properties.ReadOnly = True
    TabOrder = 82
    Width = 92
  end
  object cxLabel36: TcxLabel [83]
    Left = 366
    Top = 444
    Caption = #1043#1088#1072#1092#1080#1082' '#1079#1072#1074#1086#1079#1072':'
  end
  object cbDelivery1: TcxCheckBox [84]
    Left = 473
    Top = 444
    Caption = #1055#1085'.'
    Properties.ReadOnly = True
    TabOrder = 84
    Width = 39
  end
  object cbDelivery2: TcxCheckBox [85]
    Left = 509
    Top = 444
    Caption = #1042#1090'.'
    Properties.ReadOnly = True
    TabOrder = 85
    Width = 38
  end
  object cbDelivery3: TcxCheckBox [86]
    Left = 544
    Top = 444
    Caption = #1057#1088'.'
    Properties.ReadOnly = True
    TabOrder = 86
    Width = 39
  end
  object cbDelivery4: TcxCheckBox [87]
    Left = 580
    Top = 444
    Caption = #1063#1090'.'
    Properties.ReadOnly = True
    TabOrder = 87
    Width = 40
  end
  object cbDelivery5: TcxCheckBox [88]
    Left = 615
    Top = 444
    Caption = #1055#1090'.'
    Properties.ReadOnly = True
    TabOrder = 88
    Width = 39
  end
  object cbDelivery6: TcxCheckBox [89]
    Left = 650
    Top = 444
    Caption = #1057#1073'.'
    Properties.ReadOnly = True
    TabOrder = 89
    Width = 39
  end
  object cbDelivery7: TcxCheckBox [90]
    Left = 687
    Top = 444
    ParentCustomHint = False
    Caption = #1042#1089'.'
    Properties.ReadOnly = True
    TabOrder = 90
    Width = 37
  end
  object cxLabel37: TcxLabel [91]
    Left = 735
    Top = 71
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
  end
  object cePersonalMerch: TcxButtonEdit [92]
    Left = 878
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 92
    Width = 195
  end
  object cxLabel38: TcxLabel [93]
    Left = 15
    Top = 332
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1058#1058
  end
  object edCategory: TcxCurrencyEdit [94]
    Left = 158
    Top = 331
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.EditFormat = '0'
    TabOrder = 94
    Width = 195
  end
  object cxLabel39: TcxLabel [95]
    Left = 15
    Top = 275
    Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077')'
  end
  object edRoute30201: TcxButtonEdit [96]
    Left = 158
    Top = 274
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 96
    Width = 195
  end
  object cxLabel40: TcxLabel [97]
    Left = 380
    Top = 347
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1052#1103#1089#1085#1086#1077' '#1089#1099#1088#1100#1077')'
  end
  object cePriceList30201: TcxButtonEdit [98]
    Left = 529
    Top = 346
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 98
    Width = 190
  end
  object cxLabel47: TcxLabel [99]
    Left = 15
    Top = 419
    Caption = #1055#1086#1076#1088#1072#1079#1076'.('#1079#1072#1103#1074#1082#1080' '#1084#1086#1073'.)'
  end
  object edUnitMobile: TcxButtonEdit [100]
    Left = 141
    Top = 418
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 100
    Width = 212
  end
  object cxLabel41: TcxLabel [101]
    Left = 366
    Top = 473
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077'('#1076#1083#1103' '#1087#1088#1086#1076#1072#1078#1080')'
  end
  object edMovementComment: TcxTextEdit [102]
    Left = 509
    Top = 471
    TabOrder = 102
    Width = 210
  end
  object edTaxSale_Personal: TcxCurrencyEdit [103]
    Left = 1019
    Top = 220
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 103
    Width = 54
  end
  object cxLabel42: TcxLabel [104]
    Left = 735
    Top = 222
    Caption = #1057#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088' - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
  end
  object edTaxSale_PersonalTrade: TcxCurrencyEdit [105]
    Left = 1019
    Top = 246
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 105
    Width = 54
  end
  object cxLabel43: TcxLabel [106]
    Left = 736
    Top = 247
    Caption = #1058#1055' - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
  end
  object edTaxSale_MemberSaler1: TcxCurrencyEdit [107]
    Left = 1019
    Top = 274
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 107
    Width = 54
  end
  object cxLabel44: TcxLabel [108]
    Left = 735
    Top = 275
    Caption = #1055#1088#1086#1076#1072#1074#1077#1094'-1 - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
  end
  object edTaxSale_MemberSaler2: TcxCurrencyEdit [109]
    Left = 1019
    Top = 303
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 109
    Width = 54
  end
  object cxLabel45: TcxLabel [110]
    Left = 735
    Top = 304
    Caption = #1055#1088#1086#1076#1072#1074#1077#1094'-2 - % '#1086#1090' '#1090#1086#1074#1072#1088#1086#1086#1073#1086#1088#1086#1090#1072
  end
  object cxLabel46: TcxLabel [111]
    Left = 735
    Top = 161
    Caption = #1060#1080#1079' '#1083#1080#1094#1086' ('#1055#1088#1086#1076#1072#1074#1077#1094'-1)'
  end
  object edMemberSaler1: TcxButtonEdit [112]
    Left = 878
    Top = 160
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 112
    Width = 195
  end
  object cxLabel48: TcxLabel [113]
    Left = 735
    Top = 191
    Caption = #1060#1080#1079' '#1083#1080#1094#1086' ('#1055#1088#1086#1076#1072#1074#1077#1094'-2)'
  end
  object edMemberSaler2: TcxButtonEdit [114]
    Left = 878
    Top = 190
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 114
    Width = 195
  end
  object edBranchCode: TcxTextEdit [115]
    Left = 736
    Top = 370
    TabOrder = 115
    Width = 81
  end
  object cxLabel49: TcxLabel [116]
    Left = 736
    Top = 347
    Caption = #1053#1086#1084#1077#1088' '#1092#1080#1083#1080#1072#1083#1072
  end
  object edBranchJur: TcxTextEdit [117]
    Left = 832
    Top = 370
    TabOrder = 117
    Width = 241
  end
  object cxLabel50: TcxLabel [118]
    Left = 832
    Top = 347
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1102#1088'.'#1083#1080#1094#1072' '#1076#1083#1103' '#1092#1080#1083#1080#1072#1083#1072
  end
  object cxLabel51: TcxLabel [119]
    Left = 736
    Top = 398
    Caption = #1050#1086#1076' '#1090#1077#1088#1084#1080#1085#1072#1083#1072
  end
  object edTerminal: TcxTextEdit [120]
    Left = 735
    Top = 419
    TabOrder = 120
    Width = 81
  end
  object cxLabel52: TcxLabel [121]
    Left = 735
    Top = 101
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
  end
  object edPersonalSigning: TcxButtonEdit [122]
    Left = 878
    Top = 100
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 122
    Width = 195
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 355
    Top = 326
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 200
  end
  inherited ActionList: TActionList
    Left = 295
    Top = 65535
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
        Name = 'inJuridicalId'
        Value = ''
        Component = dsdJuridicalGuides
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
    Left = 592
    Top = 447
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
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = dsdJuridicalGuides
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
        Component = RegionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProvinceName'
        Value = ''
        Component = ProvinceGuides
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
      end>
    Left = 536
    Top = 452
  end
  object dsdJuridicalGuides: TdsdGuides
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
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 90
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
    Left = 64
    Top = 197
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
    Top = 228
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
    Left = 544
    Top = 326
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
    Left = 184
    Top = 353
  end
  object RegionGuides: TdsdGuides
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
        Component = RegionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RegionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 3
  end
  object ProvinceGuides: TdsdGuides
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
        Component = ProvinceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ProvinceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 632
    Top = 43
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
    Left = 552
    Top = 75
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
      end>
    Left = 640
    Top = 99
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
    Left = 568
    Top = 123
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
    Left = 200
    Top = 264
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
    Left = 504
    Top = 333
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
    Left = 264
    Top = 404
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
end
