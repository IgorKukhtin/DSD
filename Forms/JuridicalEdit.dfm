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
    Top = 68
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
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 6
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 293
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 7
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 25
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 8
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 92
    Caption = #1050#1086#1076' GLN'
  end
  object edGLNCode: TcxTextEdit
    Left = 40
    Top = 115
    TabOrder = 1
    Width = 153
  end
  object cbisCorporate: TcxCheckBox
    Left = 202
    Top = 115
    Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
    TabOrder = 2
    Width = 111
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 139
    Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083#1080#1094
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 184
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object ceJuridicalGroup: TcxButtonEdit
    Left = 40
    Top = 162
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 273
  end
  object ceGoodsProperty: TcxButtonEdit
    Left = 40
    Top = 207
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 232
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
  end
  object ceInfoMoney: TcxButtonEdit
    Left = 40
    Top = 255
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
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
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
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
        Name = 'inGLNCode'
        Component = edGLNCode
        DataType = ftString
        ParamType = ptInput
        Value = ''
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
        Component = JuridicalGroupGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inGoodsPropertyId'
        Component = GoodsPropertyGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inInfoMoneyId'
        Component = InfoMoneyGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
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
      end
      item
        Name = 'GroupId'
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'GroupName'
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
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
        Name = 'GLNCode'
        Component = edGLNCode
        DataType = ftString
        ParamType = ptOutput
        Value = ''
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
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'JuridicalGroupName'
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'GoodsPropertyId'
        Component = GoodsPropertyGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'GoodsPropertyName'
        Component = GoodsPropertyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'InfoMoneyId'
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'InfoMoneyName'
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Left = 192
    Top = 88
  end
  object JuridicalGroupGuides: TdsdGuides
    LookupControl = ceJuridicalGroup
    FormName = 'TJuridicalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 224
    Top = 152
  end
  object GoodsPropertyGuides: TdsdGuides
    LookupControl = ceGoodsProperty
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 288
    Top = 192
  end
  object InfoMoneyGuides: TdsdGuides
    LookupControl = ceInfoMoney
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 288
    Top = 240
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 16
    Top = 280
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
    Left = 304
    Top = 120
  end
end
