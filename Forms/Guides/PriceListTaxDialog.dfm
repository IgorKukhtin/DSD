object PriceListTaxDialogForm: TPriceListTaxDialogForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080
  ClientHeight = 288
  ClientWidth = 350
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
    Left = 85
    Top = 234
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 189
    Top = 234
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object cxLabel3: TcxLabel
    Left = 189
    Top = 59
    Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1094#1077#1085#1099' '#1089':'
  end
  object edOperDate: TcxDateEdit
    Left = 189
    Top = 82
    EditValue = 42236d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 0
    Width = 113
  end
  object Код: TcxLabel
    Left = 24
    Top = 9
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1086#1089#1085#1086#1074#1072#1085#1080#1077':'
  end
  object edPriceListFrom: TcxButtonEdit
    Left = 24
    Top = 31
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 5
    Width = 278
  end
  object cePriceTax: TcxCurrencyEdit
    Left = 24
    Top = 135
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 6
    Width = 144
  end
  object cxLabel4: TcxLabel
    Left = 24
    Top = 163
    Caption = ' '#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1088#1077#1079#1091#1083#1100#1090#1072#1090':'
  end
  object edPriceListTo: TcxButtonEdit
    Left = 24
    Top = 186
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 278
  end
  object cxLabel8: TcxLabel
    Left = 24
    Top = 115
    Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 59
    Caption = #1044#1072#1090#1072' '#1094#1077#1085#1099' '#1086#1089#1085#1086#1074#1072#1085#1080#1103':'
  end
  object edOperDateFrom: TcxDateEdit
    Left = 24
    Top = 82
    EditValue = 42236d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 11
    Width = 121
  end
  object ActionList: TActionList
    Left = 304
    Top = 8
    object dsdDataSetRefresh: TdsdDataSetRefresh
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
    object dsdFormClose1: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ObjectHistory_PriceListTax'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inPriceListFromId'
        Value = ''
        Component = PriceListGuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListToId'
        Value = ''
        Component = PriceListGuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = ''
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDateFrom'
        Value = Null
        Component = edOperDateFrom
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inTax'
        Value = Null
        Component = cePriceTax
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 275
    Top = 102
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'PriceListId'
        Value = Null
        Component = PriceListGuidesTo
        ComponentItem = 'Key'
        ParamType = ptInputOutput
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = PriceListGuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDateFrom
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 208
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
    Left = 288
    Top = 208
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 136
    Top = 184
  end
  object PriceListGuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceListFrom
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceListGuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 200
    Top = 8
  end
  object PriceListGuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceListTo
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceListGuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 56
    Top = 160
  end
end
