inherited ServiceEditForm: TServiceEditForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077
  ClientHeight = 328
  ClientWidth = 644
  ExplicitWidth = 660
  ExplicitHeight = 366
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 40
    Top = 53
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxButton1: TcxButton
    Left = 186
    Top = 276
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 446
    Top = 276
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceInvNumber: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 4
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 344
    Top = 53
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 151
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 205
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel
    Left = 344
    Top = 101
    Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceMainJuridical: TcxButtonEdit
    Left = 344
    Top = 76
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 273
  end
  object cePaidKind: TcxButtonEdit
    Left = 40
    Top = 174
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 273
  end
  object ceUnit: TcxButtonEdit
    Left = 40
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 273
  end
  object ceInfoMoney: TcxButtonEdit
    Left = 344
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 12
    Width = 273
  end
  object ceOperDate: TcxDateEdit
    Left = 40
    Top = 76
    TabOrder = 13
    Width = 273
  end
  object ceAmount: TcxCurrencyEdit
    Left = 344
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 14
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 344
    Top = 3
    Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
  end
  object ceBusiness: TcxButtonEdit
    Left = 344
    Top = 174
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 16
    Width = 273
  end
  object cxLabel9: TcxLabel
    Left = 344
    Top = 151
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceJuridical: TcxButtonEdit
    Left = 40
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 18
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 101
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ActionList: TActionList
    Left = 240
    Top = 168
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdFormClose1: TdsdFormClose
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PersonalService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end
      item
        Name = 'inInvNumber'
        Component = ceInvNumber
        DataType = ftString
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'inOperDate'
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'inAmount'
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'inJuridicalId'
        Component = JuridicalGuides
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'inMainJuridicalId'
        Component = MainJuridicalGuides
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'inBusinessId'
        Component = BusinessGuides
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'inPaidKindId'
        Component = PaidKindGuides
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'inInfoMoneyId'
        Component = InfoMoneyGuides
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'inUnitId'
        Component = UnitGuides
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Left = 264
    Top = 64
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 312
    Top = 16
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProfitLoss'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'InvNumber'
        Component = ceInvNumber
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'OperDate'
        Component = ceOperDate
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'StatusCode'
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'StatusName'
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'Amount'
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end>
    Left = 192
    Top = 72
  end
  object MainJuridicalGuides: TdsdGuides
    LookupControl = ceMainJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 496
    Top = 61
  end
  object PaidKindGuides: TdsdGuides
    LookupControl = cePaidKind
    FormName = 'TPaidKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 192
    Top = 165
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
    Left = 240
    Top = 224
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 256
    Top = 24
  end
  object UnitGuides: TdsdGuides
    LookupControl = ceUnit
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 208
    Top = 229
  end
  object InfoMoneyGuides: TdsdGuides
    LookupControl = ceInfoMoney
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 480
    Top = 117
  end
  object BusinessGuides: TdsdGuides
    LookupControl = ceBusiness
    FormName = 'TBusinessForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 456
    Top = 157
  end
  object JuridicalGuides: TdsdGuides
    LookupControl = ceJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 200
    Top = 117
  end
end
