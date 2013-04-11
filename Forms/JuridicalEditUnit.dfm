inherited JuridicalEditForm: TJuridicalEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1075#1086' '#1083#1080#1094#1072
  ClientHeight = 332
  ClientWidth = 367
  ExplicitWidth = 375
  ExplicitHeight = 359
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
    Top = 293
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 293
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
  object cxLabel2: TcxLabel
    Left = 40
    Top = 104
    Caption = #1050#1086#1076' GLN'
  end
  object edGLNCode: TcxTextEdit
    Left = 40
    Top = 127
    TabOrder = 7
    Width = 153
  end
  object cbisCorporate: TcxCheckBox
    Left = 202
    Top = 127
    Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
    TabOrder = 8
    Width = 111
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 162
    Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083#1080#1094
  end
  object ceParentGroup: TcxLookupComboBox
    Left = 40
    Top = 185
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = JuridicalGroupDS
    TabOrder = 10
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 218
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsProperty: TcxLookupComboBox
    Left = 40
    Top = 241
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = GoodsPropertyDS
    TabOrder = 12
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
          StoredProc = spGetGoodsProperty
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
    StoredProcName = 'gpInsertUpdate_Object_Juridical'
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
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNCode'
        Component = edGLNCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inisCorporate'
        Component = cbisCorporate
        DataType = ftBoolean
        ParamType = ptInput
        Value = 'False'
      end
      item
        Name = 'inJuridicalGroupId'
        Component = dsdJuridicalGroupGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inGoodsPropertyId'
        Component = dsdGoodsPropertyGuides
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
    StoredProcName = 'gpGet_Object_Juridical'
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
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'GLNCode'
        Component = edGLNCode
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'isCorporate'
        Component = cbisCorporate
        DataType = ftInteger
        ParamType = ptOutput
        Value = 'False'
      end
      item
        Name = 'JuridicalGroupId'
        Component = dsdJuridicalGroupGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'JuridicalGroupName'
        Component = dsdJuridicalGroupGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'GoodsPropertyId'
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'GoodsPropertyName'
        Component = dsdGoodsPropertyGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end>
    Left = 192
    Top = 88
  end
  object JuridicalGroupDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 176
  end
  object spGetJuridicalGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalGroup'
    DataSet = JuridicalGroupDataSet
    DataSets = <
      item
        DataSet = JuridicalGroupDataSet
      end>
    Params = <>
    Left = 216
    Top = 176
  end
  object JuridicalGroupDS: TDataSource
    DataSet = JuridicalGroupDataSet
    Left = 256
    Top = 176
  end
  object dsdJuridicalGroupGuides: TdsdGuides
    LookupControl = ceParentGroup
    Left = 312
    Top = 184
  end
  object GoodsPropertyDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 168
    Top = 224
  end
  object spGetGoodsProperty: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsProperty'
    DataSet = GoodsPropertyDataSet
    DataSets = <
      item
        DataSet = GoodsPropertyDataSet
      end>
    Params = <>
    Left = 208
    Top = 224
  end
  object GoodsPropertyDS: TDataSource
    DataSet = GoodsPropertyDataSet
    Left = 248
    Top = 224
  end
  object dsdGoodsPropertyGuides: TdsdGuides
    LookupControl = ceGoodsProperty
    Left = 304
    Top = 232
  end
end
