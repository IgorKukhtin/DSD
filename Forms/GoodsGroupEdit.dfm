object GoodsGroupEditForm: TGoodsGroupEditForm
  Left = 0
  Top = 0
  Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 192
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  isAlwaysRefresh = True
  isFree = False
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 8
    Top = 78
    TabOrder = 1
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 55
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1099
  end
  object cxButton1: TcxButton
    Left = 40
    Top = 156
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 3
  end
  object cxButton2: TcxButton
    Left = 184
    Top = 156
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 100
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit
    Left = 8
    Top = 28
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 273
  end
  object Код: TcxLabel
    Left = 8
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceParentGroup: TcxButtonEdit
    Left = 8
    Top = 123
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 273
  end
  object ActionList: TActionList
    Left = 208
    Top = 56
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
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
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
    StoredProcName = 'gpInsertUpdate_Object_GoodsGroup'
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
        Name = 'inParentId'
        Value = ''
        Component = GoodsGroupGuides
        ParamType = ptInput
      end>
    Left = 208
    Top = 8
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 152
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsGroup'
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'ParentId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 160
    Top = 48
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 208
    Top = 112
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 104
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
    StorageType = stStream
    Left = 64
    Top = 8
  end
end
