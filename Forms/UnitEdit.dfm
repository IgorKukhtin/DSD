inherited UnitEditForm: TUnitEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1075#1086' '#1083#1080#1094#1072
  ClientHeight = 254
  ClientWidth = 352
  ExplicitWidth = 368
  ExplicitHeight = 292
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 72
    Top = 216
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 216
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
    Top = 98
    Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
  end
  object ceParentGroup: TcxLookupComboBox
    Left = 40
    Top = 121
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = UnitlGroupDS
    TabOrder = 7
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 154
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceBranch: TcxLookupComboBox
    Left = 40
    Top = 177
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = BranchDS
    TabOrder = 9
    Width = 273
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
          StoredProc = spGetBranch
        end
        item
          StoredProc = spGetJuridicalGroup
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
        Name = 'inUnitGroupId'
        Component = dsdUnitGroupGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inBranchId'
        Component = dsdBranchGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
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
        Value = ''
      end
      item
        Name = 'JuridicalGroupId'
        Component = dsdUnitGroupGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'JuridicalGroupName'
        Component = dsdUnitGroupGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'GoodsPropertyId'
        Component = dsdBranchGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'GoodsPropertyName'
        Component = dsdBranchGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end>
    Left = 192
    Top = 88
  end
  object UnitGroupDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 112
  end
  object spGetJuridicalGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitGroup'
    DataSet = UnitGroupDataSet
    DataSets = <
      item
        DataSet = UnitGroupDataSet
      end>
    Params = <>
    Left = 216
    Top = 112
  end
  object UnitlGroupDS: TDataSource
    DataSet = UnitGroupDataSet
    Left = 256
    Top = 112
  end
  object dsdUnitGroupGuides: TdsdGuides
    Key = '0'
    LookupControl = ceParentGroup
    PositionDataSet = 'ClientDataSet'
    Left = 312
    Top = 120
  end
  object BranchDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 168
    Top = 160
  end
  object spGetBranch: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Branch'
    DataSet = BranchDataSet
    DataSets = <
      item
        DataSet = BranchDataSet
      end>
    Params = <>
    Left = 208
    Top = 160
  end
  object BranchDS: TDataSource
    DataSet = BranchDataSet
    Left = 248
    Top = 160
  end
  object dsdBranchGuides: TdsdGuides
    Key = '0'
    LookupControl = ceBranch
    PositionDataSet = 'ClientDataSet'
    Left = 304
    Top = 168
  end
end
