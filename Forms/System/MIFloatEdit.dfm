object MIFloatEditForm: TMIFloatEditForm
  Left = 0
  Top = 0
  Caption = #1042#1074#1086#1076' '#1079#1085#1072#1095#1077#1085#1080#1103
  ClientHeight = 157
  ClientWidth = 331
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
  object cxButton1: TcxButton
    Left = 54
    Top = 116
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 204
    Top = 116
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object cxMemo1: TcxMemo
    AlignWithMargins = True
    Left = 40
    Top = 16
    TabStop = False
    Enabled = False
    Lines.Strings = (
      #1062#1077#1085#1072)
    Properties.ReadOnly = True
    Style.BorderStyle = ebsNone
    Style.Color = clBtnFace
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    Style.Shadow = False
    StyleDisabled.BorderStyle = ebsNone
    StyleDisabled.TextColor = clWindowText
    TabOrder = 2
    Height = 26
    Width = 242
  end
  object ceValue: TcxCurrencyEdit
    Left = 41
    Top = 53
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 3
    Width = 249
  end
  object ActionList: TActionList
    Left = 200
    Top = 12
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
    StoredProcName = 'gpUpdate_MI_ParamFloat'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 0.000000000000000000
        Component = dsdFormParams
        ComponentItem = 'DescCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescProcess'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'DescProcess'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = ''
        Component = ceValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 64
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Label'
        Value = #1062#1077#1085#1072#13#10
        Component = cxMemo1
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DescCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 64
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_ParamFloat'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = ''
        Component = dsdFormParams
        ComponentItem = 'DescCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value'
        Component = ceValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 128
    Top = 15
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
    Left = 200
    Top = 56
  end
end
