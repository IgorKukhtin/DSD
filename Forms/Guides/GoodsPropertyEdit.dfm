object GoodsPropertyEditForm: TGoodsPropertyEditForm
  Left = 0
  Top = 0
  Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 220
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 307
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 92
    Top = 190
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 236
    Top = 190
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
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
    TabOrder = 3
    Width = 307
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 101
    Caption = #1055#1086#1079#1080#1094#1080#1103' '#1074#1077#1089#1072' '#1074' '#1096#1090#1088#1080#1093#1082#1086#1076#1077' '#1082#1075
  end
  object cxLabel4: TcxLabel
    Left = 183
    Top = 101
    Caption = #1055#1086#1079#1080#1094#1080#1103' '#1074#1077#1089#1072' '#1074' '#1096#1090#1088#1080#1093#1082#1086#1076#1077' '#1075#1088#1072#1084#1084#1099
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 124
    Caption = #1085#1072#1095#1072#1083#1100#1085#1072#1103
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 151
    Caption = #1082#1086#1085#1077#1095#1085#1072#1103
  end
  object cxLabel3: TcxLabel
    Left = 183
    Top = 124
    Caption = #1085#1072#1095#1072#1083#1100#1085#1072#1103
  end
  object cxLabel8: TcxLabel
    Left = 183
    Top = 151
    Caption = #1082#1086#1085#1077#1095#1085#1072#1103
  end
  object edStartPosInt: TcxCurrencyEdit
    Left = 72
    Top = 124
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 12
    Width = 95
  end
  object edEndPosInt: TcxCurrencyEdit
    Left = 72
    Top = 151
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 95
  end
  object edStartPosFrac: TcxCurrencyEdit
    Left = 252
    Top = 121
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 95
  end
  object edEndPosFrac: TcxCurrencyEdit
    Left = 252
    Top = 151
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 15
    Width = 95
  end
  object ActionList: TActionList
    Left = 320
    Top = 40
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsProperty'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStartPosInt'
        Value = Null
        Component = edStartPosInt
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inEndPosInt'
        Value = Null
        Component = edEndPosInt
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inStartPosFrac'
        Value = Null
        Component = edStartPosFrac
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inEndPosFrac'
        Value = Null
        Component = edEndPosFrac
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 240
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 240
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsProperty'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'StartPosInt'
        Value = Null
        Component = edStartPosInt
        DataType = ftFloat
      end
      item
        Name = 'EndPosInt'
        Value = Null
        Component = edEndPosInt
        DataType = ftFloat
      end
      item
        Name = 'StartPosFrac'
        Value = Null
        Component = edStartPosFrac
        DataType = ftFloat
      end
      item
        Name = 'EndPosFrac'
        Value = Null
        Component = edEndPosFrac
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 8
    Top = 48
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 8
    Top = 8
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
    Left = 16
    Top = 184
  end
end
