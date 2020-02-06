inherited Member_ObjectToEditForm: TMember_ObjectToEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'>'
  ClientHeight = 521
  ClientWidth = 287
  ExplicitWidth = 293
  ExplicitHeight = 549
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 41
    Top = 487
    TabOrder = 1
    ExplicitLeft = 41
    ExplicitTop = 487
  end
  inherited bbCancel: TcxButton
    Left = 173
    Top = 487
    TabOrder = 2
    ExplicitLeft = 173
    ExplicitTop = 487
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 0
    Top = 0
    Width = 287
    Height = 473
    Align = alTop
    TabOrder = 0
    Properties.ActivePage = tsCommon
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 473
    ClientRectRight = 287
    ClientRectTop = 24
    object tsCommon: TcxTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 0
      object edMeasureName: TcxTextEdit
        Left = 7
        Top = 60
        TabOrder = 1
        Width = 273
      end
      object cxLabel1: TcxLabel
        Left = 7
        Top = 44
        Caption = #1060#1048#1054
      end
      object Код: TcxLabel
        Left = 7
        Top = 4
        Caption = #1050#1086#1076
      end
      object cxLabel15: TcxLabel
        Left = 7
        Top = 402
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095'. IBAN '#1047#1055' - '#1060'1'
      end
      object edCardIBAN: TcxTextEdit
        Left = 7
        Top = 419
        TabOrder = 25
        Width = 130
      end
      object edCardIBANSecond: TcxTextEdit
        Left = 150
        Top = 419
        TabOrder = 28
        Width = 130
      end
      object cxLabel16: TcxLabel
        Left = 150
        Top = 400
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095'. IBAN '#1047#1055' -'#1060'2'
      end
      object cxLabel8: TcxLabel
        Left = 7
        Top = 161
        Caption = #8470' '#1082#1072#1088#1090#1086#1095#1085#1086#1075#1086' '#1089#1095#1077#1090#1072' '#1047#1055' - '#1060'1'
      end
      object ceCard: TcxTextEdit
        Left = 7
        Top = 176
        TabOrder = 11
        Width = 151
      end
      object ceCode: TcxCurrencyEdit
        Left = 7
        Top = 22
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 0
        Width = 117
      end
      object ceINN: TcxTextEdit
        Left = 7
        Top = 99
        TabOrder = 3
        Width = 273
      end
      object cxLabel2: TcxLabel
        Left = 7
        Top = 82
        Caption = #1048#1053#1053
      end
      object cxLabel3: TcxLabel
        Left = 7
        Top = 124
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      end
      object cxLabel4: TcxLabel
        Left = 7
        Top = 357
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      end
      object ceDriverCertificate: TcxTextEdit
        Left = 7
        Top = 138
        TabOrder = 4
        Width = 273
      end
      object ceComment: TcxTextEdit
        Left = 7
        Top = 375
        TabOrder = 5
        Width = 273
      end
      object cbOfficial: TcxCheckBox
        Left = 140
        Top = 6
        Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        TabOrder = 2
        Width = 141
      end
      object cbNotCompensation: TcxCheckBox
        Left = 140
        Top = 33
        Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1086#1090#1087#1091#1089#1082#1072
        Caption = #1048#1089#1082#1083'. '#1080#1079' '#1082#1086#1084#1087#1077#1085#1089'. '#1086#1090#1087'.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 31
        Width = 140
      end
      object cxLabel7: TcxLabel
        Left = 7
        Top = 274
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      end
      object ceInfoMoney: TcxButtonEdit
        Left = 7
        Top = 290
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 9
        Width = 273
      end
      object cxLabel9: TcxLabel
        Left = 7
        Top = 317
        Caption = #1050#1086#1084#1091' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1103#1077#1084
        Style.LookAndFeel.Kind = lfOffice11
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfOffice11
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfOffice11
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfOffice11
        StyleHot.LookAndFeel.NativeStyle = False
        Transparent = True
      end
      object edPersonal: TcxButtonEdit
        Left = 7
        Top = 333
        Properties.Buttons = <
          item
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.BorderStyle = ebsUltraFlat
        Style.LookAndFeel.Kind = lfOffice11
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfOffice11
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfOffice11
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfOffice11
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 10
        Width = 273
      end
      object cxLabel10: TcxLabel
        Left = 7
        Top = 199
        Caption = #8470' '#1082#1072#1088#1090#1086#1095#1085#1086#1075#1086' '#1089#1095#1077#1090#1072' '#1047#1055' - '#1060'2'
      end
      object ceCardSecond: TcxTextEdit
        Left = 7
        Top = 214
        TabOrder = 14
        Width = 151
      end
      object cxLabel11: TcxLabel
        Left = 7
        Top = 236
        Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095'.'#1072#1083#1080#1084#1077#1085#1090#1099'('#1091#1076#1077#1088#1078'.)'
      end
      object ceCardChild: TcxTextEdit
        Left = 7
        Top = 251
        TabOrder = 16
        Width = 151
      end
      object cxLabel12: TcxLabel
        Left = 164
        Top = 161
        Caption = #1041#1072#1085#1082' '#1060'1'
      end
      object ceBank: TcxButtonEdit
        Left = 164
        Top = 176
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 18
        Width = 116
      end
      object cxLabel13: TcxLabel
        Left = 164
        Top = 199
        Caption = #1041#1072#1085#1082' '#1074#1090#1086#1088#1072#1103' '#1092#1086#1088#1084#1072
      end
      object ceBankSecond: TcxButtonEdit
        Left = 164
        Top = 214
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 20
        Width = 116
      end
      object cxLabel14: TcxLabel
        Left = 164
        Top = 236
        Caption = #1041#1072#1085#1082' '#1072#1083#1080#1084#1077#1085#1090#1099'('#1091#1076#1077#1088#1078'.)'
      end
      object ceBankChild: TcxButtonEdit
        Left = 164
        Top = 251
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 21
        Width = 116
      end
    end
    object tsContact: TcxTabSheet
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 1
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
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
    Top = 263
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
    Top = 311
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 223
    Top = 358
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
        end>
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 128
    Top = 103
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Member_All'
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
        Value = 'False'
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
        Name = 'inInfoMoneyId'
        Value = Null
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectToId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId'
        Value = Null
        Component = BankGuides
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
      end>
    Left = 224
    Top = 48
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
        Value = 'False'
        Component = cbOfficial
        DataType = ftBoolean
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
        Component = BankGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = BankGuides
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
        Name = 'BankChildid'
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
      end>
    Top = 136
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
    Left = 64
    Top = 72
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
    Left = 136
    Top = 136
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
    Left = 144
    Top = 295
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    isShowModal = True
    Key = '0'
    FormNameParam.Value = 'TPersonalUnitFounder_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalUnitFounder_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = PersonalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 366
  end
  object BankGuides: TdsdGuides
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
        Component = BankGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 191
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
    Left = 232
    Top = 231
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
    Left = 216
    Top = 287
  end
end
