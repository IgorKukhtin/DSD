inherited CashCloseReturnDialogForm: TCashCloseReturnDialogForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1080#1072#1083#1086#1075' '#1079#1072#1082#1088#1099#1090#1080#1103' '#1095#1077#1082#1072
  ClientHeight = 164
  ClientWidth = 655
  GlassFrame.Bottom = 60
  Position = poScreenCenter
  OnKeyDown = ParentFormKeyDown
  AddOnFormData.isAlwaysRefresh = False
  ExplicitWidth = 661
  ExplicitHeight = 193
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 215
    Top = 104
    Action = actPrintReceipt
    ModalResult = 0
    ExplicitLeft = 215
    ExplicitTop = 104
  end
  inherited bbCancel: TcxButton
    Left = 338
    Top = 104
    ModalResult = 2
    ExplicitLeft = 338
    ExplicitTop = 104
  end
  object cxGroupBox1: TcxGroupBox [2]
    Left = 8
    Top = 8
    Caption = #1057#1091#1084#1084#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
    TabOrder = 2
    Height = 73
    Width = 201
    object edSalerCash: TcxCurrencyEdit
      Left = 16
      Top = 19
      ParentFont = False
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = ',0.00'
      Properties.OnChange = edSalerCashPropertiesChange
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -29
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 177
    end
  end
  object cxLabel1: TcxLabel [3]
    Left = 215
    Top = 13
    Caption = #1057#1091#1084#1084#1072' '#1074' '#1095#1077#1082#1077':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel2: TcxLabel [4]
    Left = 278
    Top = 46
    Caption = #1057#1076#1072#1095#1072':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object lblSdacha: TcxLabel [5]
    Left = 382
    Top = 46
    Caption = '0.00'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.Shadow = False
    Style.TextColor = clRed
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taRightJustify
    AnchorX = 422
  end
  object lblTotalSumma: TcxLabel [6]
    Left = 382
    Top = 13
    Caption = '0.00'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.Shadow = False
    Style.TextColor = clBlue
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taRightJustify
    AnchorX = 422
  end
  object rgPaidType: TcxRadioGroup [7]
    Left = 428
    Top = 8
    Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
    ParentFont = False
    Properties.Items = <
      item
        Caption = '[ / ] '#1054#1087#1083#1072#1090#1072' '#1085#1072#1083#1080#1095#1085#1099#1084#1080
        Value = 0
      end
      item
        Caption = '[ * ] '#1054#1087#1083#1072#1090#1072' '#1082#1072#1088#1090#1086#1081
        Value = 1
      end
      item
        Caption = '[ ** ] '#1057#1084#1077#1096#1077#1085#1085#1072#1103' '#1086#1087#1083#1072#1090#1072
        Value = '2'
      end>
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 8
    OnClick = edSalerCashPropertiesChange
    Height = 105
    Width = 217
  end
  object cxGroupBox2: TcxGroupBox [8]
    Left = 8
    Top = 80
    Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1099' '#1085#1072#1083#1080#1095#1085#1099#1084#1080
    TabOrder = 3
    Height = 73
    Width = 201
    object edSalerCashAdd: TcxCurrencyEdit
      Left = 16
      Top = 19
      ParentFont = False
      Properties.DecimalPlaces = 1
      Properties.DisplayFormat = ',0.00'
      Properties.OnChange = edSalerCashPropertiesChange
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -29
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 177
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Active = False
    Left = 491
    Top = 120
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 456
    Top = 120
  end
  inherited ActionList: TActionList
    Left = 527
    Top = 119
    inherited actRefresh: TdsdDataSetRefresh
      AfterAction = actShow
      StoredProc = spGet_Movement
      StoredProcList = <
        item
          StoredProc = spGet_Movement
        end
        item
          StoredProc = spSelect
        end>
    end
    object actShow: TAction
      Category = 'DSDLib'
      OnExecute = actShowExecute
    end
    object actPrintReceipt: TAction
      Category = 'DSDLib'
      Caption = 'Ok'
      OnExecute = actPrintReceiptExecute
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 568
    Top = 120
  end
  object spGet_Movement: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_CashCloseReturn'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummaTotal'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPaidType'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 211
    Top = 112
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 392
    Top = 120
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ReturnIn_Check'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 112
  end
  object spComplete_Movement: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ReturnIn_Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidType'
        Value = False
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashRegister'
        Value = False
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inZReport'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFiscalCheckNumber'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSummPayAdd'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 56
  end
end
