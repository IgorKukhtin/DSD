object GoodsRepriceEditForm: TGoodsRepriceEditForm
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1099#1081' '#1058#1086#1074#1072#1088#1099' '#1089' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1086#1081' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080' '#1074' '#1084#1080#1085#1091#1089
  ClientHeight = 169
  ClientWidth = 344
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
    Left = 17
    Top = 79
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 17
    Top = 59
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 67
    Top = 130
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 193
    Top = 130
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 17
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 17
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 109
  end
  object cbisEnabled: TcxCheckBox
    Left = 149
    Top = 26
    Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 6
    Width = 164
  end
  object ActionList: TActionList
    Left = 81
    Top = 99
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
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
    StoredProcName = 'gpInsertUpdate_Object_GoodsReprice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
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
        Name = 'inisEnabled'
        Value = Null
        Component = cbisEnabled
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 305
    Top = 95
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 41
    Top = 111
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsReprice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEnabled'
        Value = Null
        Component = cbisEnabled
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 265
    Top = 63
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 145
    Top = 78
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
    Left = 129
    Top = 55
  end
end
