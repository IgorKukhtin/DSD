inherited SaveTaxDocumentForm: TSaveTaxDocumentForm
  ActiveControl = deStart
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074' '#1052#1077#1076#1086#1082
  ClientHeight = 202
  ClientWidth = 512
  AddOnFormData.RefreshAction = nil
  AddOnFormData.isSingle = False
  ExplicitWidth = 518
  ExplicitHeight = 231
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 164
    Top = 161
    Action = MultiAction
    ExplicitLeft = 164
    ExplicitTop = 161
  end
  inherited bbCancel: TcxButton
    Left = 292
    Top = 161
    Action = actClose
    ExplicitLeft = 292
    ExplicitTop = 161
  end
  object deStart: TcxDateEdit [2]
    Left = 132
    Top = 16
    EditValue = 42109d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 104
  end
  object deEnd: TcxDateEdit [3]
    Left = 371
    Top = 16
    EditValue = 42109d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 104
  end
  object cxLabel1: TcxLabel [4]
    Left = 5
    Top = 18
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072' ('#1076#1086#1082'.):'
  end
  object cxLabel2: TcxLabel [5]
    Left = 250
    Top = 18
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072' ('#1076#1086#1082'.):'
  end
  object cxLabel7: TcxLabel [6]
    Left = 5
    Top = 89
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
  end
  object ceInfoMoney: TcxButtonEdit [7]
    Left = 132
    Top = 88
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 343
  end
  object cxLabel5: TcxLabel [8]
    Left = 429
    Top = 153
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    Visible = False
  end
  object edPaidKind: TcxButtonEdit [9]
    Left = 420
    Top = 173
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Visible = False
    Width = 90
  end
  object deStartReg: TcxDateEdit [10]
    Left = 132
    Top = 51
    EditValue = 42109d
    Properties.ShowTime = False
    TabOrder = 10
    Width = 104
  end
  object deEndReg: TcxDateEdit [11]
    Left = 371
    Top = 51
    EditValue = 42109d
    Properties.ShowTime = False
    TabOrder = 11
    Width = 104
  end
  object cxLabel3: TcxLabel [12]
    Left = 5
    Top = 53
    Caption = #1053#1072#1095#1072#1083#1100#1085#1072#1103' '#1076#1072#1090#1072' ('#1088#1077#1075'.):'
  end
  object cxLabel4: TcxLabel [13]
    Left = 250
    Top = 53
    Caption = #1050#1086#1085#1077#1095#1085#1072#1103' '#1076#1072#1090#1072' ('#1088#1077#1075'.):'
  end
  object cbTaxCorrectiveOnly: TcxCheckBox [14]
    Left = 3
    Top = 126
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = #1058#1086#1083#1100#1082#1086' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
    TabOrder = 14
    Width = 140
  end
  object cbRegisterOnly: TcxCheckBox [15]
    Left = 150
    Top = 126
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = #1058#1086#1083#1100#1082#1086' '#1079#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1085#1099#1077
    TabOrder = 15
    Width = 169
  end
  object cbNotRegisterOnly: TcxCheckBox [16]
    Left = 326
    Top = 126
    Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    Caption = #1058#1086#1083#1100#1082#1086' '#1085#1077' '#1079#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1085#1099#1077
    TabOrder = 16
    Width = 184
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 155
    Top = 160
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deEndReg
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStartReg
        Properties.Strings = (
          'Date')
      end
      item
        Component = InfoMoneyGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 88
    Top = 160
  end
  inherited ActionList: TActionList
    Left = 23
    Top = 159
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spTaxBillList
      StoredProcList = <
        item
          StoredProc = spTaxBillList
        end>
    end
    object MultiAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actRefresh
        end
        item
          Action = ExternalSaveAction
        end
        item
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1083#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1052#1045#1044#1054#1050' '#1091#1089#1087#1077#1096#1085#1086' '#1074#1099#1075#1088#1091#1078#1077#1085#1099
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
    end
    object ExternalSaveAction: TExternalSaveAction
      Category = 'DSDLib'
      MoveParams = <>
      FieldDefs = <
        item
          Name = 'NPP'
          DataType = ftString
          Size = 15
        end
        item
          Name = 'DATEV'
          DataType = ftDate
        end
        item
          Name = 'NUM'
          DataType = ftString
          Size = 50
        end
        item
          Name = 'NAZP'
          DataType = ftString
          Size = 200
        end
        item
          Name = 'IPN'
          DataType = ftString
          Size = 20
        end
        item
          Name = 'ZAGSUM'
          DataType = ftBCD
          Precision = 2
          Size = 16
        end
        item
          Name = 'BAZOP20'
          DataType = ftBCD
          Precision = 2
          Size = 16
        end
        item
          Name = 'SUMPDV'
          DataType = ftBCD
          Precision = 2
          Size = 16
        end
        item
          Name = 'BAZOP0'
          DataType = ftBCD
          Precision = 2
          Size = 16
        end
        item
          Name = 'ZVILN'
          DataType = ftBCD
          Precision = 2
          Size = 16
        end
        item
          Name = 'EXPORT'
          DataType = ftBCD
          Precision = 2
          Size = 16
        end
        item
          Name = 'PZOB'
          DataType = ftBCD
          Size = 3
        end
        item
          Name = 'NREZ'
          DataType = ftBCD
          Size = 2
        end
        item
          Name = 'KOR'
          DataType = ftBCD
          Size = 2
        end
        item
          Name = 'WMDTYPE'
          DataType = ftBCD
          Size = 2
        end
        item
          Name = 'WMDTYPESTR'
          DataType = ftString
          Size = 4
        end
        item
          Name = 'DKOR'
          DataType = ftDate
        end
        item
          Name = 'D1_NUM'
          DataType = ftString
          Size = 20
        end>
      DataSet = TaxBillList
      OpenFileDialog = False
      FileName.Value = Null
      FileName.DataType = ftString
      FileName.MultiSelectSeparator = ','
    end
    object actClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
      Hint = #1054#1090#1084#1077#1085#1072
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 240
    Top = 128
  end
  object spTaxBillList: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Load'
    DataSet = TaxBillList
    DataSets = <
      item
        DataSet = TaxBillList
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 0d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 0d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateReg'
        Value = Null
        Component = deStartReg
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDateReg'
        Value = Null
        Component = deEndReg
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxCorrectiveOnly'
        Value = Null
        Component = cbTaxCorrectiveOnly
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRegisterOnly'
        Value = Null
        Component = cbRegisterOnly
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsNotRegisterOnly'
        Value = Null
        Component = cbNotRegisterOnly
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 152
  end
  object TaxBillList: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 384
    Top = 152
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 376
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 53
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 144
  end
  object PeriodChoiceReg: TPeriodChoice
    DateStart = deStartReg
    DateEnd = deEndReg
    Left = 296
    Top = 48
  end
end
