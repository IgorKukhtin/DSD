inherited UnitEditForm: TUnitEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ClientHeight = 281
  ClientWidth = 497
  ExplicitWidth = 505
  ExplicitHeight = 308
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 216
    Top = 26
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 216
    Top = 3
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 118
    Top = 232
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 312
    Top = 232
    Width = 75
    Height = 25
    Action = FormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
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
    Width = 153
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 50
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object cxLabel4: TcxLabel
    Left = 248
    Top = 50
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceParent: TcxButtonEdit
    Left = 40
    Top = 73
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 8
    Width = 185
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 113
    Caption = #1041#1080#1079#1085#1077#1089#1099
  end
  object ceBranch: TcxButtonEdit
    Left = 248
    Top = 73
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 241
  end
  object ceBusiness: TcxButtonEdit
    Left = 40
    Top = 136
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 11
    Width = 201
  end
  object cxLabel5: TcxLabel
    Left = 269
    Top = 113
    Caption = #1070#1088'. '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 269
    Top = 136
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 13
    Width = 220
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 169
    Caption = #1059#1087#1088'. '#1089#1095#1077#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceAccountDirection: TcxButtonEdit
    Left = 40
    Top = 192
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 201
  end
  object cxLabel7: TcxLabel
    Left = 269
    Top = 169
    Caption = #1057#1090#1072#1090#1100#1103' '#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
  end
  object ceProfitLossDirection: TcxButtonEdit
    Left = 269
    Top = 192
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 17
    Width = 220
  end
  object ActionList: TActionList
    Left = 48
    Top = 216
    object DataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
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
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Unit'
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
        Value = 0.000000000000000000
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inParentId'
        Component = ParentGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inBranchId'
        Component = BranchGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inBusinessId'
        Component = BusinessGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inJuridicalId'
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inAccountDirectionId'
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inProfitLossDirectionId'
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 48
    Top = 248
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 16
    Top = 216
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit'
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
        Value = 0.000000000000000000
      end
      item
        Name = 'ParentId'
        Component = ParentGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ParentName'
        Component = ParentGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'BranchId'
        Component = BranchGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'BranchName'
        Component = BranchGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'BusinessId'
        Component = BusinessGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'BusinessName'
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'JuridicalId'
        Component = JuridicalGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'JuridicalName'
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'AccountDirectionId'
        Component = AccountDirectionGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'AccountDirectionName'
        Component = AccountDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ProfitLossDirectionId'
        Component = ProfitLossDirectionGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ProfitLossDirectionName'
        Component = ProfitLossDirectionGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Left = 16
    Top = 240
  end
  object ParentGuides: TdsdGuides
    LookupControl = ceParent
    FormName = 'TUnitForm'
    PositionDataSet = 'TreeDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <>
    Left = 152
    Top = 56
  end
  object BranchGuides: TdsdGuides
    LookupControl = ceBranch
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <>
    Left = 424
    Top = 48
  end
  object BusinessGuides: TdsdGuides
    LookupControl = ceBusiness
    FormName = 'TBusinessForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 168
    Top = 120
  end
  object JuridicalGuides: TdsdGuides
    LookupControl = ceJuridical
    FormName = 'TJuridicalForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <>
    Left = 384
    Top = 112
  end
  object AccountDirectionGuides: TdsdGuides
    LookupControl = ceAccountDirection
    FormName = 'TAccountDirectionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 160
    Top = 168
  end
  object ProfitLossDirectionGuides: TdsdGuides
    LookupControl = ceProfitLossDirection
    FormName = 'TProfitLossDirectionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 376
    Top = 160
  end
end
