object MemberEditForm: TMemberEditForm
  Left = 0
  Top = 0
  Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  ClientHeight = 322
  ClientWidth = 339
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
  object edMeasureName: TcxTextEdit
    Left = 32
    Top = 86
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 63
    Caption = #1060#1048#1054
  end
  object cxButton1: TcxButton
    Left = 56
    Top = 289
    Width = 75
    Height = 25
    Action = InsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 289
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 32
    Top = 19
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 32
    Top = 42
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object ceINN: TcxTextEdit
    Left = 32
    Top = 136
    TabOrder = 6
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 32
    Top = 113
    Caption = #1048#1053#1053
  end
  object cxLabel3: TcxLabel
    Left = 32
    Top = 163
    Caption = #1042#1086#1076#1080#1090#1077#1083#1100#1089#1082#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
  end
  object cxLabel4: TcxLabel
    Left = 32
    Top = 213
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceDriverCertificate: TcxTextEdit
    Left = 32
    Top = 186
    TabOrder = 10
    Width = 273
  end
  object ceComment: TcxTextEdit
    Left = 32
    Top = 236
    TabOrder = 11
    Width = 273
  end
  object ActionList: TActionList
    Left = 256
    Top = 88
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
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
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Member'
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
        Component = edMeasureName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inINN'
        Value = ''
        Component = ceINN
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDriverCertificate'
        Value = ''
        Component = ceDriverCertificate
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 272
    Top = 32
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 168
    Top = 144
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Member'
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
        Component = edMeasureName
        DataType = ftString
      end
      item
        Name = 'INN'
        Value = ''
        Component = ceINN
        DataType = ftString
      end
      item
        Name = 'DriverCertificate'
        Value = ''
        Component = ceDriverCertificate
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end>
    Left = 248
    Top = 136
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
    Left = 128
    Top = 96
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
  end
end
