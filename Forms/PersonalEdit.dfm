inherited PersonalEditForm: TPersonalEditForm
  Caption = #1053#1086#1074#1099#1081' '#1089#1086#1090#1088#1091#1076#1085#1080#1082
  ClientHeight = 370
  ClientWidth = 686
  ExplicitWidth = 694
  ExplicitHeight = 397
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 76
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = 'NULL'
  end
  object cxButton1: TcxButton
    Left = 173
    Top = 289
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 478
    Top = 289
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 103
    Caption = #1044#1072#1090#1072' '#1087#1088#1080#1085#1103#1090#1080#1103
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 159
    Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
  end
  object ceMember: TcxLookupComboBox
    Left = 351
    Top = 182
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = MemberDS
    TabOrder = 8
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 209
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cePosition: TcxLookupComboBox
    Left = 40
    Top = 230
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = PositionDS
    TabOrder = 10
    Width = 273
  end
  object edDateIn: TcxTextEdit
    Left = 40
    Top = 132
    TabOrder = 11
    Width = 273
  end
  object edDateOut: TcxTextEdit
    Left = 40
    Top = 182
    TabOrder = 12
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 351
    Top = 159
    Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
  end
  object ceUnit: TcxLookupComboBox
    Left = 351
    Top = 26
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = UnitDS
    TabOrder = 14
    Width = 273
  end
  object cxLabel7: TcxLabel
    Left = 351
    Top = 3
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  end
  object cxLabel8: TcxLabel
    Left = 351
    Top = 53
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
  end
  object ceJuridical: TcxLookupComboBox
    Left = 351
    Top = 76
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = JuridicalDS
    TabOrder = 17
    Width = 273
  end
  object ceBusiness: TcxLookupComboBox
    Left = 351
    Top = 132
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = BusinessDS
    TabOrder = 18
    Width = 273
  end
  object cxLabel9: TcxLabel
    Left = 351
    Top = 109
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ActionList: TActionList
    Left = 296
    Top = 72
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
    object dsdExecStoredProc: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose1: TdsdFormClose
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Personal'
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
        Name = 'inCode'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inBranchId'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'inPaidKindId'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'inCurrencyId'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    Left = 240
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 240
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Personal'
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
        Name = 'Name'
        Component = edName
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'BranchId'
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end
      item
        Name = 'BranchName'
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = Null
      end
      item
        Name = 'PaidKindId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end
      item
        Name = 'PaidKindName'
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end
      item
        Name = 'CurrencyId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end
      item
        Name = 'CurrencyName'
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end>
    Left = 528
    Top = 232
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
    Left = 136
    Top = 40
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 584
    Top = 240
  end
  object MemberDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 560
    Top = 181
  end
  object spGetMember: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Member'
    DataSet = MemberDataSet
    DataSets = <
      item
        DataSet = MemberDataSet
      end>
    Params = <>
    Left = 592
    Top = 181
  end
  object MemberDS: TDataSource
    DataSet = MemberDataSet
    Left = 632
    Top = 181
  end
  object MemberGuides: TdsdGuides
    Key = '0'
    LookupControl = ceMember
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Left = 664
    Top = 181
  end
  object PositionDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 440
    Top = 229
  end
  object spGetPosition: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Position'
    DataSet = PositionDataSet
    DataSets = <
      item
        DataSet = PositionDataSet
      end>
    Params = <>
    Left = 408
    Top = 229
  end
  object PositionDS: TDataSource
    DataSet = PositionDataSet
    Left = 344
    Top = 229
  end
  object dsdPosition: TdsdGuides
    Key = '0'
    LookupControl = cePosition
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Left = 376
    Top = 229
  end
  object UnitDS: TDataSource
    DataSet = UnitDataSet
    Left = 591
    Top = 23
  end
  object dsdUnit: TdsdGuides
    Key = '0'
    LookupControl = ceUnit
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Left = 623
    Top = 23
  end
  object spGetUnit: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    DataSet = UnitDataSet
    DataSets = <
      item
        DataSet = UnitDataSet
      end>
    Params = <>
    Left = 647
    Top = 23
  end
  object UnitDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 671
    Top = 23
  end
  object JuridicalDS: TDataSource
    DataSet = JuridicalDataSet
    Left = 583
    Top = 65
  end
  object JuridicalDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 663
    Top = 65
  end
  object spGetJuridical: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical'
    DataSet = JuridicalDataSet
    DataSets = <
      item
        DataSet = JuridicalDataSet
      end>
    Params = <>
    Left = 639
    Top = 65
  end
  object dsdJuridical: TdsdGuides
    Key = '0'
    LookupControl = ceJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    Left = 615
    Top = 65
  end
  object BusinessDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 655
    Top = 113
  end
  object dsdBusiness: TdsdGuides
    Key = '0'
    LookupControl = ceBusiness
    FormName = 'TBusinessForm'
    PositionDataSet = 'ClientDataSet'
    Left = 607
    Top = 113
  end
  object spGetBusiness: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Business'
    DataSet = BusinessDataSet
    DataSets = <
      item
        DataSet = BusinessDataSet
      end>
    Params = <>
    Left = 631
    Top = 113
  end
  object BusinessDS: TDataSource
    DataSet = BusinessDataSet
    Left = 575
    Top = 113
  end
end
