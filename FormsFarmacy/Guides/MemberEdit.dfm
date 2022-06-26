inherited MemberEditForm: TMemberEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'>'
  ClientHeight = 497
  ClientWidth = 354
  ExplicitWidth = 360
  ExplicitHeight = 526
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 73
    Top = 458
    TabOrder = 1
    ExplicitLeft = 73
    ExplicitTop = 458
  end
  inherited bbCancel: TcxButton
    Left = 205
    Top = 458
    TabOrder = 2
    ExplicitLeft = 205
    ExplicitTop = 458
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 0
    Top = 0
    Width = 354
    Height = 441
    Align = alTop
    TabOrder = 0
    Properties.ActivePage = tsCommon
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 441
    ClientRectRight = 354
    ClientRectTop = 24
    object tsCommon: TcxTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 0
      ExplicitLeft = -64
      ExplicitTop = 0
      ExplicitHeight = 409
      object edMeasureName: TcxTextEdit
        Left = 7
        Top = 66
        TabOrder = 1
        Width = 273
      end
      object cxLabel1: TcxLabel
        Left = 7
        Top = 50
        Caption = #1060#1048#1054
      end
      object Код: TcxLabel
        Left = 7
        Top = 4
        Caption = #1050#1086#1076
      end
      object ceCode: TcxCurrencyEdit
        Left = 7
        Top = 22
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 0
        Width = 124
      end
      object ceINN: TcxTextEdit
        Left = 7
        Top = 146
        TabOrder = 3
        Width = 157
      end
      object cxLabel2: TcxLabel
        Left = 7
        Top = 129
        Caption = #1048#1053#1053
      end
      object cxLabel3: TcxLabel
        Left = 171
        Top = 129
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      end
      object cxLabel4: TcxLabel
        Left = 7
        Top = 272
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      end
      object ceDriverCertificate: TcxTextEdit
        Left = 171
        Top = 146
        TabOrder = 4
        Width = 157
      end
      object ceComment: TcxTextEdit
        Left = 7
        Top = 290
        TabOrder = 5
        Width = 321
      end
      object cbOfficial: TcxCheckBox
        Left = 143
        Top = 2
        Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        TabOrder = 2
        Width = 141
      end
      object cxLabel7: TcxLabel
        Left = 171
        Top = 177
        Caption = #1057#1087#1077#1094#1080#1072#1083#1100#1085#1086#1089#1090#1100
      end
      object ceEducation: TcxButtonEdit
        Left = 171
        Top = 194
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 12
        Width = 157
      end
      object cxLabel8: TcxLabel
        Left = 7
        Top = 177
        Caption = #1058#1077#1083#1077#1092#1086#1085
      end
      object edPhone: TcxTextEdit
        Left = 7
        Top = 194
        TabOrder = 14
        Width = 157
      end
      object cxLabel9: TcxLabel
        Left = 7
        Top = 221
        Caption = #1052#1077#1089#1090#1086' '#1087#1088#1086#1078#1080#1074#1072#1085#1080#1103
      end
      object edAddress: TcxTextEdit
        Left = 7
        Top = 241
        TabOrder = 16
        Width = 321
      end
      object cePosition: TcxButtonEdit
        Left = 7
        Top = 340
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 17
        Width = 321
      end
      object cxLabel11: TcxLabel
        Left = 7
        Top = 323
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
      end
      object ceManagerPharmacy: TcxCheckBox
        Left = 143
        Top = 17
        Hint = #1047#1072#1074#1077#1076#1091#1102#1097#1072#1103' '#1072#1087#1090#1077#1082#1086#1081
        Caption = #1047#1072#1074#1077#1076#1091#1102#1097#1072#1103' '#1072#1087#1090#1077#1082#1086#1081
        TabOrder = 19
        Width = 141
      end
      object ceUnit: TcxButtonEdit
        Left = 8
        Top = 385
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 20
        Width = 320
      end
      object cxLabel12: TcxLabel
        Left = 7
        Top = 367
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      end
      object ceNotSchedule: TcxCheckBox
        Left = 143
        Top = 32
        Hint = #1053#1077' '#1090#1088#1077#1073#1086#1074#1072#1090#1100' '#1086#1090#1084#1077#1095#1072#1090#1100#1089#1103' '#1074' '#1082#1072#1089#1089#1077'  '
        Caption = #1053#1077' '#1090#1088#1077#1073#1086#1074#1072#1090#1100' '#1086#1090#1084#1077#1095#1072#1090#1100#1089#1103' '#1074' '#1082#1072#1089#1089#1077'  '
        TabOrder = 22
        Width = 211
      end
      object cbReleasedMarketingPlan: TcxCheckBox
        Left = 143
        Top = 47
        Hint = #1053#1077' '#1090#1088#1077#1073#1086#1074#1072#1090#1100' '#1086#1090#1084#1077#1095#1072#1090#1100#1089#1103' '#1074' '#1082#1072#1089#1089#1077'  '
        Caption = #1054#1089#1074#1086#1073#1086#1078#1076#1077#1085' '#1086#1090' '#1087#1083#1072#1085#1072' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
        TabOrder = 23
        Width = 211
      end
      object edMeasureNameUkr: TcxTextEdit
        Left = 7
        Top = 105
        TabOrder = 24
        Width = 273
      end
      object cxLabel13: TcxLabel
        Left = 7
        Top = 89
        Caption = #1060#1048#1054' '#1085#1072' '#1059#1082#1088#1072#1080#1085#1089#1082#1086#1084' '#1103#1079#1099#1082#1077
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
        Width = 322
      end
      object cxLabel6: TcxLabel
        Left = 7
        Top = 55
        Caption = 'E-mail '#1087#1086#1076#1087#1080#1089#1100
      end
      object EMailSign: TcxMemo
        Left = 7
        Top = 77
        TabOrder = 3
        Height = 59
        Width = 322
      end
      object cxLabel10: TcxLabel
        Left = 7
        Top = 143
        Caption = #1060#1086#1090#1086
      end
      object Photo: TcxMemo
        Left = 7
        Top = 166
        TabOrder = 5
        Height = 107
        Width = 322
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 107
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 272
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 239
    Top = 271
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
    Left = 168
    Top = 248
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
        Name = 'inNameUkr'
        Value = Null
        Component = edMeasureNameUkr
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
        Name = 'inComment'
        Value = ''
        Component = ceComment
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
        Name = 'inAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhoto'
        Value = Null
        Component = Photo
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEducationId'
        Value = Null
        Component = EducationGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inManagerPharmacy'
        Value = Null
        Component = ceManagerPharmacy
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionID'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitID'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotSchedule'
        Value = Null
        Component = ceNotSchedule
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReleasedMarketingPlan'
        Value = Null
        Component = cbReleasedMarketingPlan
        DataType = ftBoolean
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
        Name = 'NameUkr'
        Value = Null
        Component = edMeasureNameUkr
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
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EducationId'
        Value = Null
        Component = EducationGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'EducationName'
        Value = Null
        Component = EducationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'Phone'
        Value = Null
        Component = edPhone
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Photo'
        Value = Null
        Component = Photo
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ManagerPharmacy'
        Value = Null
        Component = ceManagerPharmacy
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionID'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitID'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotSchedule'
        Value = Null
        Component = ceNotSchedule
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReleasedMarketingPlan'
        Value = Null
        Component = cbReleasedMarketingPlan
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 120
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
    Left = 88
    Top = 80
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
    Left = 96
    Top = 120
  end
  object EducationGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceEducation
    FormNameParam.Value = 'TEducationForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TEducationForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = EducationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = EducationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 88
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
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
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 239
    Top = 320
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 367
  end
end
