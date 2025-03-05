object PartionCellCheckEditForm: TPartionCellCheckEditForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1074#1099#1073#1086#1088'  <'#1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103'>'
  ClientHeight = 168
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actGet
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 111
    Top = 30
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 258
  end
  object cxLabel1: TcxLabel
    Left = 111
    Top = 12
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 91
    Top = 120
    Width = 75
    Height = 25
    Action = actGet_check
    Default = True
    TabOrder = 3
  end
  object cxButton2: TcxButton
    Left = 235
    Top = 120
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 94
  end
  object cePSW: TcxTextEdit
    Left = 111
    Top = 63
    Properties.EchoMode = eemPassword
    Properties.PasswordChar = '*'
    TabOrder = 0
    Width = 258
  end
  object cxLabel9: TcxLabel
    Left = 63
    Top = 64
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object ActionList: TActionList
    Left = 192
    Top = 96
    object actGet: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
    object actGet_check: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_check
      StoredProcList = <
        item
          StoredProc = spGet_check
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spGet_check: TdsdStoredProc
    StoredProcName = 'gpGet_Object_PartionCell_check'
    DataSets = <>
    OutputType = otResult
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
        Name = 'ioIsLock_record'
        Value = Null
        Component = FormParams
        ComponentItem = 'ioIsLock_record'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPSW'
        Value = ''
        Component = cePSW
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 102
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsLock_record'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_PartionCell'
    DataSets = <>
    OutputType = otResult
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'PSW'
        Value = Null
        Component = cePSW
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isLock_record'
        Value = Null
        Component = FormParams
        ComponentItem = 'ioIsLock_record'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 96
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
    Left = 336
    Top = 62
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 24
    Top = 86
  end
end
