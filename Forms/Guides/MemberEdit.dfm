inherited MemberEditForm: TMemberEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'>'
  ClientHeight = 502
  ClientWidth = 349
  ExplicitWidth = 355
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 45
    Top = 468
    TabOrder = 1
    ExplicitLeft = 45
    ExplicitTop = 468
  end
  inherited bbCancel: TcxButton
    Left = 177
    Top = 468
    TabOrder = 2
    ExplicitLeft = 177
    ExplicitTop = 468
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 0
    Top = 0
    Width = 349
    Height = 457
    Align = alTop
    TabOrder = 0
    Properties.ActivePage = tsCommon
    Properties.CustomButtons.Buttons = <>
    ExplicitLeft = -8
    ExplicitTop = 16
    ClientRectBottom = 457
    ClientRectRight = 349
    ClientRectTop = 24
    object tsCommon: TcxTabSheet
      Caption = #1054#1073#1097#1080#1077
      ImageIndex = 0
      ExplicitLeft = -64
      ExplicitTop = 56
      object edMeasureName: TcxTextEdit
        Left = 14
        Top = 60
        TabOrder = 1
        Width = 273
      end
      object cxLabel1: TcxLabel
        Left = 14
        Top = 44
        Caption = #1060#1048#1054
      end
      object Код: TcxLabel
        Left = 14
        Top = 4
        Caption = #1050#1086#1076
      end
      object cxLabel14: TcxLabel
        Left = 14
        Top = 385
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095'. IBAN '#1047#1055' - '#1060'1'
      end
      object edCardIBAN: TcxTextEdit
        Left = 14
        Top = 401
        TabOrder = 23
        Width = 130
      end
      object cxLabel15: TcxLabel
        Left = 157
        Top = 383
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095'. IBAN '#1047#1055' -'#1060'2'
      end
      object edCardIBANSecond: TcxTextEdit
        Left = 157
        Top = 401
        TabOrder = 28
        Width = 130
      end
      object cxLabel10: TcxLabel
        Left = 14
        Top = 249
        Hint = #8470' '#1082#1072#1088#1090#1086#1095#1085#1086#1075#1086' '#1089#1095#1077#1090#1072' '#1072#1083#1080#1084#1077#1085#1090#1099' ('#1091#1076#1077#1088#1078#1072#1085#1080#1077')'
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095'.'#1072#1083#1080#1084#1077#1085#1090#1099'('#1091#1076#1077#1088#1078'.)'
      end
      object ceCardChild: TcxTextEdit
        Left = 14
        Top = 267
        TabOrder = 11
        Width = 151
      end
      object cxLabel9: TcxLabel
        Left = 14
        Top = 204
        Caption = #8470' '#1082#1072#1088#1090#1086#1095#1085#1086#1075#1086' '#1089#1095#1077#1090#1072' '#1047#1055' - '#1060'2'
      end
      object ceCardSecond: TcxTextEdit
        Left = 14
        Top = 222
        TabOrder = 6
        Width = 151
      end
      object cxLabel8: TcxLabel
        Left = 14
        Top = 161
        Caption = #8470' '#1082#1072#1088#1090#1086#1095#1085#1086#1075#1086' '#1089#1095#1077#1090#1072' '#1047#1055' - '#1060'1'
      end
      object ceCard: TcxTextEdit
        Left = 14
        Top = 177
        TabOrder = 12
        Text = '1234 5678 9092 2345'
        Width = 151
      end
      object ceCode: TcxCurrencyEdit
        Left = 14
        Top = 22
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 0
        Width = 127
      end
      object ceINN: TcxTextEdit
        Left = 14
        Top = 100
        TabOrder = 3
        Width = 151
      end
      object cxLabel2: TcxLabel
        Left = 14
        Top = 83
        Caption = #1048#1053#1053
      end
      object cxLabel3: TcxLabel
        Left = 14
        Top = 123
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      end
      object cxLabel4: TcxLabel
        Left = 14
        Top = 340
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      end
      object ceDriverCertificate: TcxTextEdit
        Left = 14
        Top = 137
        TabOrder = 4
        Width = 273
      end
      object ceComment: TcxTextEdit
        Left = 14
        Top = 359
        TabOrder = 5
        Width = 273
      end
      object cbOfficial: TcxCheckBox
        Left = 147
        Top = 6
        Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        TabOrder = 21
        Width = 140
      end
      object cbNotCompensation: TcxCheckBox
        Left = 147
        Top = 33
        Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1086#1090#1087#1091#1089#1082#1072
        Caption = #1048#1089#1082#1083'. '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089'. '#1086#1090#1087'.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Width = 140
      end
      object cxLabel7: TcxLabel
        Left = 14
        Top = 293
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      end
      object ceInfoMoney: TcxButtonEdit
        Left = 14
        Top = 314
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 10
        Width = 273
      end
      object cxLabel11: TcxLabel
        Left = 171
        Top = 161
        Caption = #1041#1072#1085#1082' '#1060'1'
      end
      object ceBank: TcxButtonEdit
        Left = 171
        Top = 177
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 14
        Width = 116
      end
      object cxLabel12: TcxLabel
        Left = 171
        Top = 204
        Caption = #1041#1072#1085#1082' '#1074#1090#1086#1088#1072#1103' '#1092#1086#1088#1084#1072
      end
      object ceBankSecond: TcxButtonEdit
        Left = 171
        Top = 222
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 16
        Width = 116
      end
      object cxLabel13: TcxLabel
        Left = 171
        Top = 249
        Caption = #1041#1072#1085#1082' '#1072#1083#1080#1084#1077#1085#1090#1099'('#1091#1076#1077#1088#1078'.)'
      end
      object ceBankChild: TcxButtonEdit
        Left = 171
        Top = 267
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 18
        Width = 116
      end
      object cxLabel16: TcxLabel
        Left = 171
        Top = 83
        Caption = #1055#1086#1083
      end
      object edGender: TcxButtonEdit
        Left = 171
        Top = 100
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 31
        Width = 116
      end
    end
    object tsContact: TcxTabSheet
      Caption = #1050#1086#1085#1090#1072#1082#1090#1099
      ImageIndex = 1
      ExplicitTop = 29
      ExplicitWidth = 294
      object cxLabel5: TcxLabel
        Left = 7
        Top = 4
        Caption = 'E-mail'
      end
      object edEmail: TcxTextEdit
        Left = 7
        Top = 25
        TabOrder = 1
        Width = 273
      end
      object cxLabel6: TcxLabel
        Left = 7
        Top = 55
        Caption = 'E-mail '#1087#1086#1076#1087#1080#1089#1100
      end
      object EMailSign: TcxMemo
        Left = 7
        Top = 76
        TabOrder = 3
        Height = 145
        Width = 273
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1055#1072#1089#1087#1086#1088#1090
      ImageIndex = 2
      ExplicitLeft = 16
      ExplicitTop = 29
      object cxLabel17: TcxLabel
        Left = 10
        Top = 13
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1089#1077#1088#1080#1103
      end
      object edPSP_S: TcxTextEdit
        Left = 10
        Top = 31
        TabOrder = 1
        Width = 82
      end
      object cxLabel18: TcxLabel
        Left = 109
        Top = 13
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1085#1086#1084#1077#1088
      end
      object edPSP_N: TcxTextEdit
        Left = 109
        Top = 31
        TabOrder = 3
        Width = 102
      end
      object cxLabel19: TcxLabel
        Left = 10
        Top = 61
        Caption = #1055#1072#1089#1087#1086#1088#1090', '#1082#1077#1084' '#1074#1099#1076#1072#1085
      end
      object edPSP_W: TcxTextEdit
        Left = 10
        Top = 79
        TabOrder = 5
        Width = 321
      end
      object cxLabel20: TcxLabel
        Left = 10
        Top = 102
        Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
      end
      object edPSP_D: TcxTextEdit
        Left = 10
        Top = 120
        TabOrder = 7
        Width = 110
      end
      object cxLabel21: TcxLabel
        Left = 131
        Top = 104
        Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1089
      end
      object edPSP_Start: TcxDateEdit
        Left = 131
        Top = 120
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 9
        Width = 94
      end
      object edPSP_End: TcxDateEdit
        Left = 237
        Top = 120
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 10
        Width = 94
      end
      object cxLabel22: TcxLabel
        Left = 237
        Top = 104
        Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086
      end
      object edBirthday: TcxDateEdit
        Left = 226
        Top = 31
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 12
        Width = 105
      end
      object увBirthday: TcxLabel
        Left = 226
        Top = 15
        Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
      end
      object cxLabel23: TcxLabel
        Left = 10
        Top = 150
        Caption = #1054#1073#1083#1072#1089#1090#1100', '#1087#1088#1086#1087#1080#1089#1082#1072
      end
      object edRegion: TcxButtonEdit
        Left = 10
        Top = 166
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 15
        Width = 150
      end
      object cxLabel24: TcxLabel
        Left = 10
        Top = 239
        Caption = #1054#1073#1083#1072#1089#1090#1100', '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1077
      end
      object edRegion_Real: TcxButtonEdit
        Left = 10
        Top = 255
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 17
        Width = 150
      end
      object cxLabel25: TcxLabel
        Left = 170
        Top = 150
        Caption = #1043#1086#1088#1086#1076'/'#1089#1077#1083#1086'/'#1087#1075#1090', '#1087#1088#1086#1087#1080#1089#1082#1072
      end
      object edCity: TcxButtonEdit
        Left = 170
        Top = 166
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 19
        Width = 161
      end
      object cxLabel26: TcxLabel
        Left = 170
        Top = 239
        Caption = #1043#1086#1088#1086#1076'/'#1089#1077#1083#1086'/'#1087#1075#1090', '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1077
      end
      object edCity_real: TcxButtonEdit
        Left = 170
        Top = 255
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 21
        Width = 161
      end
      object cxLabel27: TcxLabel
        Left = 10
        Top = 193
        Caption = #1059#1083#1080#1094#1072', '#1085#1086#1084#1077#1088' '#1076#1086#1084#1072', '#1085#1086#1084#1077#1088' '#1082#1074#1072#1088#1090#1080#1088#1099', '#1087#1088#1086#1087#1080#1089#1082#1072
      end
      object edStreet: TcxTextEdit
        Left = 10
        Top = 211
        TabOrder = 23
        Width = 321
      end
      object cxLabel28: TcxLabel
        Left = 10
        Top = 282
        Caption = #1059#1083#1080#1094#1072', '#1085#1086#1084#1077#1088' '#1076#1086#1084#1072', '#1085#1086#1084#1077#1088' '#1082#1074#1072#1088#1090#1080#1088#1099', '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1077
      end
      object edStreet_Real: TcxTextEdit
        Left = 10
        Top = 300
        TabOrder = 25
        Width = 321
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1044#1077#1090#1080
      ImageIndex = 3
      ExplicitLeft = -3
      ExplicitTop = 88
      object cxLabel29: TcxLabel
        Left = 230
        Top = 10
        Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
      end
      object edBirthdayChildren1: TcxDateEdit
        Left = 230
        Top = 26
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 1
        Width = 101
      end
      object cxLabel30: TcxLabel
        Left = 8
        Top = 8
        Caption = #1056#1077#1073#1077#1085#1086#1082' 1, '#1060#1048#1054
      end
      object edChildren1: TcxTextEdit
        Left = 8
        Top = 26
        TabOrder = 3
        Width = 209
      end
      object cxLabel31: TcxLabel
        Left = 8
        Top = 53
        Caption = #1056#1077#1073#1077#1085#1086#1082' 2, '#1060#1048#1054
      end
      object edChildren2: TcxTextEdit
        Left = 8
        Top = 71
        TabOrder = 5
        Width = 209
      end
      object edBirthdayChildren2: TcxDateEdit
        Left = 230
        Top = 71
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 6
        Width = 101
      end
      object cxLabel32: TcxLabel
        Left = 230
        Top = 55
        Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
      end
      object edChildren3: TcxTextEdit
        Left = 8
        Top = 115
        TabOrder = 8
        Width = 209
      end
      object cxLabel33: TcxLabel
        Left = 230
        Top = 99
        Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
      end
      object edBirthdayChildren3: TcxDateEdit
        Left = 230
        Top = 115
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 10
        Width = 101
      end
      object cxLabel34: TcxLabel
        Left = 8
        Top = 98
        Caption = #1056#1077#1073#1077#1085#1086#1082' 3, '#1060#1048#1054
      end
      object cxLabel35: TcxLabel
        Left = 8
        Top = 144
        Caption = #1056#1077#1073#1077#1085#1086#1082' 4, '#1060#1048#1054
      end
      object edChildren4: TcxTextEdit
        Left = 8
        Top = 160
        TabOrder = 13
        Width = 209
      end
      object edBirthdayChildren4: TcxDateEdit
        Left = 230
        Top = 160
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 14
        Width = 101
      end
      object cxLabel36: TcxLabel
        Left = 230
        Top = 144
        Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
      end
      object cxLabel37: TcxLabel
        Left = 8
        Top = 187
        Caption = #1056#1077#1073#1077#1085#1086#1082' 5, '#1060#1048#1054
      end
      object edChildren5: TcxTextEdit
        Left = 8
        Top = 203
        TabOrder = 17
        Width = 209
      end
      object edBirthdayChildren5: TcxDateEdit
        Left = 230
        Top = 203
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 18
        Width = 101
      end
      object cxLabel38: TcxLabel
        Left = 230
        Top = 187
        Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
      end
      object cxLabel39: TcxLabel
        Left = 8
        Top = 242
        Caption = #1044#1077#1082#1088#1077#1090' '#1089
      end
      object edDekret_Start: TcxDateEdit
        Left = 8
        Top = 258
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 21
        Width = 101
      end
      object cxLabel40: TcxLabel
        Left = 128
        Top = 242
        Caption = #1044#1077#1082#1088#1077#1090' '#1087#1086
      end
      object edDekret_End: TcxDateEdit
        Left = 128
        Top = 258
        EditValue = 0d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 23
        Width = 101
      end
    end
    object cxTabSheet3: TcxTabSheet
      Caption = #1055#1088#1086#1095#1077#1077
      ImageIndex = 4
      ExplicitTop = 29
      object cxLabel41: TcxLabel
        Left = 10
        Top = 14
        Caption = #1050#1074#1072#1083#1080#1092#1080#1082#1072#1094#1080#1103
      end
      object edMemberSkill: TcxButtonEdit
        Left = 10
        Top = 30
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 303
      end
      object cxLabel42: TcxLabel
        Left = 10
        Top = 59
        Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1074#1072#1082#1072#1085#1089#1080#1080
      end
      object edJobSource: TcxButtonEdit
        Left = 10
        Top = 75
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 3
        Width = 303
      end
      object cxLabel43: TcxLabel
        Left = 10
        Top = 105
        Caption = #1057#1091#1076#1080#1084#1086#1089#1090#1080
      end
      object edLaw: TcxTextEdit
        Left = 10
        Top = 123
        TabOrder = 5
        Width = 303
      end
      object cxLabel44: TcxLabel
        Left = 10
        Top = 151
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077' '#1076#1083#1103' '#1074#1086#1078#1076#1077#1085#1080#1103' '#1082#1072#1088#1099' '#1080' '#1090'.'#1087'.'
      end
      object edDriverCertificateAdd: TcxTextEdit
        Left = 10
        Top = 169
        TabOrder = 7
        Width = 303
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 227
    Top = 351
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
    Top = 311
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 175
    Top = 70
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetMemberContact
        end>
    end
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spInsertUpdateContact
        end
        item
          StoredProc = spInsertUpdateIts
        end>
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 312
    Top = 159
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Member'
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
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edMeasureName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsOfficial'
        Value = False
        Component = cbOfficial
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotCompensation'
        Value = Null
        Component = cbNotCompensation
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inINN'
        Value = ''
        Component = ceINN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDriverCertificate'
        Value = ''
        Component = ceDriverCertificate
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCard'
        Value = Null
        Component = ceCard
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardSecond'
        Value = Null
        Component = ceCardSecond
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardChild'
        Value = Null
        Component = ceCardChild
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardIBAN'
        Value = Null
        Component = edCardIBAN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCardIBANSecond'
        Value = Null
        Component = edCardIBANSecond
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
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
        Name = 'inBankSecondId'
        Value = Null
        Component = BankSecondGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankChildId'
        Value = Null
        Component = BankChildGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 96
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Member'
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
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edMeasureName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsOfficial'
        Value = False
        Component = cbOfficial
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN'
        Value = ''
        Component = ceINN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverCertificate'
        Value = ''
        Component = ceDriverCertificate
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Card'
        Value = Null
        Component = ceCard
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CardSecond'
        Value = Null
        Component = ceCardSecond
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CardChild'
        Value = Null
        Component = ceCardChild
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CardIBAN'
        Value = Null
        Component = edCardIBAN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CardIBANSecond'
        Value = Null
        Component = edCardIBANSecond
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
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
        Name = 'BankSecondId'
        Value = Null
        Component = BankSecondGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondName'
        Value = Null
        Component = BankSecondGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankChildId'
        Value = Null
        Component = BankChildGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankChildName'
        Value = Null
        Component = BankChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotCompensation'
        Value = Null
        Component = cbNotCompensation
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'GenderId'
        Value = Null
        Component = GuidesGender
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GenderName'
        Value = Null
        Component = GuidesGender
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSkillId'
        Value = Null
        Component = GuidesMemberSkill
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSkillName'
        Value = Null
        Component = GuidesMemberSkill
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JobSourceId'
        Value = Null
        Component = GuidesJobSource
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JobSourceName'
        Value = Null
        Component = GuidesJobSource
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Birthday_Date'
        Value = Null
        Component = edBirthday
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegionId'
        Value = Null
        Component = GuidesRegion
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegionName'
        Value = Null
        Component = GuidesRegion
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityId'
        Value = Null
        Component = GuidesCity
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName'
        Value = Null
        Component = GuidesCity
        ComponentItem = 'TextValue'
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
        Name = 'RegionId_Real'
        Value = Null
        Component = GuidesRegion_Real
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RegionName_Real'
        Value = Null
        Component = GuidesRegion_Real
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityId_real'
        Value = Null
        Component = GuidesCity_real
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName_real'
        Value = Null
        Component = GuidesCity_real
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Street_Real'
        Value = Null
        Component = edStreet_Real
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children1_date'
        Value = Null
        Component = edBirthdayChildren1
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children2_date'
        Value = Null
        Component = edBirthdayChildren2
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children3_date'
        Value = Null
        Component = edBirthdayChildren3
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children4_date'
        Value = Null
        Component = edBirthdayChildren4
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children5_date'
        Value = Null
        Component = edBirthdayChildren5
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children1'
        Value = Null
        Component = edChildren1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children2'
        Value = Null
        Component = edChildren2
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children3'
        Value = Null
        Component = edChildren3
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children4'
        Value = Null
        Component = edChildren4
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Children5'
        Value = Null
        Component = edChildren5
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Law'
        Value = Null
        Component = edLaw
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DriverCertificateAdd'
        Value = Null
        Component = edDriverCertificateAdd
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSP_S'
        Value = Null
        Component = edPSP_S
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSP_N'
        Value = Null
        Component = edPSP_N
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSP_W'
        Value = Null
        Component = edPSP_W
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSP_D'
        Value = Null
        Component = edPSP_D
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSP_StartDate'
        Value = Null
        Component = edPSP_Start
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSP_EndDate'
        Value = Null
        Component = edPSP_End
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dekret_StartDate'
        Value = Null
        Component = edDekret_Start
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dekret_EndDate'
        Value = Null
        Component = edDekret_End
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 320
  end
  object spInsertUpdateContact: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MemberContact'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmail'
        Value = 0.000000000000000000
        Component = edEmail
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmailSign'
        Value = Null
        Component = EMailSign
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 432
  end
  object spGetMemberContact: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MemberContact'
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
        Name = 'EMail'
        Value = ''
        Component = edEmail
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EMailSign'
        Value = Null
        Component = EMailSign
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 424
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 319
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBank
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 312
    Top = 431
  end
  object BankSecondGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankSecond
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankSecondGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankSecondGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 215
  end
  object BankChildGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankChild
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankChildGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankChildGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 375
  end
  object GuidesGender: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TGenderForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGenderForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGender
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGender
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 71
  end
  object GuidesRegion: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRegion
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
        DataType = ftString
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
    Left = 53
    Top = 182
  end
  object GuidesRegion_Real: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRegion
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRegion_Real
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRegion_Real
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 69
    Top = 374
  end
  object GuidesCity: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCity
    FormNameParam.Value = 'TCityForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCity
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCity
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 221
    Top = 182
  end
  object GuidesCity_real: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCity
    FormNameParam.Value = 'TCityForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCityForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCity_real
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCity_real
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 245
    Top = 238
  end
  object GuidesMemberSkill: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberSkill
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberSkill
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberSkill
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 61
    Top = 54
  end
  object GuidesJobSource: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJobSource
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJobSource
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJobSource
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 101
    Top = 102
  end
  object spInsertUpdateIts: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MemberIts'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGenderId'
        Value = ''
        Component = GuidesGender
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberSkillId'
        Value = ''
        Component = GuidesMemberSkill
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJobSourceId'
        Value = Null
        Component = GuidesJobSource
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegionId'
        Value = Null
        Component = GuidesRegion
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegionId_Real'
        Value = Null
        Component = GuidesRegion_Real
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCityId'
        Value = Null
        Component = GuidesCity
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCityId_real'
        Value = Null
        Component = GuidesCity_real
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBirthday_date'
        Value = Null
        Component = edBirthday
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren1_date'
        Value = Null
        Component = edBirthdayChildren1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren2_date'
        Value = Null
        Component = edBirthdayChildren2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren3_date'
        Value = Null
        Component = edBirthdayChildren3
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren4_date'
        Value = Null
        Component = edBirthdayChildren4
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren5_date'
        Value = Null
        Component = edBirthdayChildren5
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPSP_Startdate'
        Value = Null
        Component = edPSP_Start
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPSP_Enddate'
        Value = Null
        Component = edPSP_End
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDekret_StartDate'
        Value = Null
        Component = edDekret_Start
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDekret_EndDate'
        Value = Null
        Component = edDekret_End
        DataType = ftDateTime
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
        Name = 'inStreet_Real'
        Value = Null
        Component = edStreet_Real
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren1'
        Value = Null
        Component = edChildren1
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren2'
        Value = Null
        Component = edChildren2
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren3'
        Value = Null
        Component = edChildren3
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren4'
        Value = Null
        Component = edChildren4
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildren5'
        Value = Null
        Component = edChildren5
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLaw'
        Value = Null
        Component = edLaw
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDriverCertificateAdd'
        Value = Null
        Component = edDriverCertificateAdd
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPSP_S'
        Value = Null
        Component = edPSP_S
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPSP_N'
        Value = Null
        Component = edPSP_N
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPSP_W'
        Value = Null
        Component = edPSP_W
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPSP_D'
        Value = Null
        Component = edPSP_D
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 424
  end
end
