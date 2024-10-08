object PriceDialogForm: TPriceDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1079#1085#1072#1095#1077#1085#1080#1103
  ClientHeight = 151
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 41
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 215
    Top = 101
    Width = 75
    Height = 28
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cePrice: TcxCurrencyEdit
    Left = 41
    Top = 53
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 2
    Width = 249
  end
  object cxMemo1: TcxMemo
    AlignWithMargins = True
    Left = 41
    Top = 21
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
    TabOrder = 3
    Height = 26
    Width = 242
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 134
    Top = 6
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 191
    Top = 76
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Label'
        Value = #1062#1077#1085#1072
        Component = cxMemo1
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 102
    Top = 86
  end
  object ActionList: TActionList
    Left = 267
    Top = 23
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_ParamFloat'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = Null
        Component = FormParams
        ComponentItem = 'DescCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value'
        Value = Null
        Component = cePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 72
  end
end
