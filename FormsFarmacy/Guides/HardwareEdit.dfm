inherited HardwareEditForm: THardwareEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1040#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100' >'
  ClientHeight = 439
  ClientWidth = 467
  ExplicitWidth = 473
  ExplicitHeight = 468
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 97
    Top = 399
    TabOrder = 2
    ExplicitLeft = 97
    ExplicitTop = 399
  end
  inherited bbCancel: TcxButton
    Left = 270
    Top = 399
    TabOrder = 3
    ExplicitLeft = 270
    ExplicitTop = 399
  end
  object edName: TcxTextEdit [2]
    Left = 7
    Top = 66
    TabOrder = 1
    Width = 273
  end
  object cxLabel1: TcxLabel [3]
    Left = 7
    Top = 50
    Caption = #1048#1084#1103' '#1082#1086#1084#1087#1102#1090#1077#1088#1072' '
  end
  object Код: TcxLabel [4]
    Left = 7
    Top = 4
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 7
    Top = 22
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 273
  end
  object cxLabel7: TcxLabel [6]
    Left = 8
    Top = 93
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit [7]
    Left = 8
    Top = 110
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 272
  end
  object edBaseBoardProduct: TcxTextEdit [8]
    Left = 8
    Top = 153
    TabOrder = 8
    Width = 441
  end
  object cxLabel2: TcxLabel [9]
    Left = 8
    Top = 137
    Caption = #1052#1072#1090#1077#1088#1080#1085#1089#1082#1072#1103' '#1087#1083#1072#1090#1072
  end
  object edProcessorName: TcxTextEdit [10]
    Left = 8
    Top = 196
    TabOrder = 10
    Width = 441
  end
  object cxLabel3: TcxLabel [11]
    Left = 8
    Top = 180
    Caption = #1055#1088#1086#1094#1077#1089#1089#1086#1088
  end
  object edDiskDriveModel: TcxTextEdit [12]
    Left = 8
    Top = 238
    TabOrder = 12
    Width = 441
  end
  object cxLabel4: TcxLabel [13]
    Left = 8
    Top = 222
    Caption = #1046#1077#1089#1090#1082#1080#1081' '#1044#1080#1089#1082
  end
  object edPhysicalMemory: TcxTextEdit [14]
    Left = 8
    Top = 281
    TabOrder = 14
    Width = 441
  end
  object cxLabel5: TcxLabel [15]
    Left = 8
    Top = 265
    Caption = #1054#1087#1077#1088#1072#1090#1080#1074#1085#1072#1103' '#1087#1072#1084#1103#1090#1100
  end
  object ceCashRegister: TcxButtonEdit [16]
    Left = 301
    Top = 110
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 148
  end
  object cxLabel6: TcxLabel [17]
    Left = 301
    Top = 93
    Caption = #1050#1072#1089#1089#1086#1074#1099#1081' '#1072#1087#1087#1072#1088#1072#1090
  end
  object edComment: TcxTextEdit [18]
    Left = 8
    Top = 364
    TabOrder = 18
    Width = 441
  end
  object cxLabel8: TcxLabel [19]
    Left = 8
    Top = 348
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edIdentifier: TcxTextEdit [20]
    Left = 8
    Top = 321
    TabOrder = 20
    Width = 441
  end
  object cxLabel9: TcxLabel [21]
    Left = 8
    Top = 305
    Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 176
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 400
    Top = 32
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 207
    Top = 191
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
    end
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
        end>
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 328
    Top = 168
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Hardware'
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
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashRegisterId'
        Value = Null
        Component = GuidesCashRegister
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBaseBoardProduct'
        Value = 'NULL'
        Component = edBaseBoardProduct
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcessorName'
        Value = 'NULL'
        Component = edProcessorName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiskDriveModel'
        Value = Null
        Component = edDiskDriveModel
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhysicalMemory'
        Value = Null
        Component = edPhysicalMemory
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIdentifier'
        Value = Null
        Component = edIdentifier
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 32
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Hardware'
    Params = <
      item
        Name = 'inId'
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
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterId'
        Value = Null
        Component = GuidesCashRegister
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterName'
        Value = Null
        Component = GuidesCashRegister
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BaseBoardProduct'
        Value = Null
        Component = edBaseBoardProduct
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProcessorName'
        Value = 'NULL'
        Component = edProcessorName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiskDriveModel'
        Value = 'NULL'
        Component = edDiskDriveModel
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PhysicalMemory'
        Value = Null
        Component = edPhysicalMemory
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Identifier'
        Value = Null
        Component = edIdentifier
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 96
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 96
  end
  object GuidesCashRegister: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCashRegister
    FormNameParam.Value = 'TCashRegisterForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCashRegisterForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCashRegister
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCashRegister
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 104
  end
end
