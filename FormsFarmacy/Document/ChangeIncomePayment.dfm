inherited ChangeIncomePaymentForm: TChangeIncomePaymentForm
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1086#1083#1075#1072' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084
  ClientHeight = 321
  ClientWidth = 468
  ExplicitWidth = 474
  ExplicitHeight = 349
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 114
    Top = 280
    Action = actInsertUpdate
    ExplicitLeft = 114
    ExplicitTop = 280
  end
  inherited bbCancel: TcxButton
    Left = 240
    Top = 280
    Action = actFormClose
    ExplicitLeft = 240
    ExplicitTop = 280
  end
  object Код: TcxLabel [2]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edInvNumber: TcxTextEdit [3]
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 3
    Text = '0'
    Width = 78
  end
  object cxLabel1: TcxLabel [4]
    Left = 107
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object deOperDate: TcxDateEdit [5]
    Left = 107
    Top = 25
    EditValue = 42353d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 110
  end
  object cxLabel2: TcxLabel [6]
    Left = 8
    Top = 52
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object edFrom: TcxButtonEdit [7]
    Left = 8
    Top = 73
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 433
  end
  object cxLabel13: TcxLabel [8]
    Left = 8
    Top = 106
    Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
  end
  object edJuridical: TcxButtonEdit [9]
    Left = 8
    Top = 129
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 433
  end
  object cxLabel7: TcxLabel [10]
    Left = 240
    Top = 5
    Caption = #1057#1091#1084#1084#1072
  end
  object ceSumm: TcxCurrencyEdit [11]
    Left = 240
    Top = 25
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 11
    Width = 120
  end
  object cxLabel6: TcxLabel [12]
    Left = 8
    Top = 159
    Caption = #1058#1080#1087
  end
  object edChangeIncomePaymentKind: TcxButtonEdit [13]
    Left = 8
    Top = 182
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 433
  end
  object cxLabel10: TcxLabel [14]
    Left = 8
    Top = 214
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit [15]
    Left = 8
    Top = 237
    TabOrder = 15
    Width = 433
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
    end
    object actInsertUpdate: TdsdInsertUpdateGuides
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
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
      end>
    Left = 376
    Top = 264
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 41
    Top = 106
  end
  object FromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'BankId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'BankName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CurrencyValue'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ParValue'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 42353d
        Component = deOperDate
        DataType = ftDateTime
      end>
    Left = 44
    Top = 53
  end
  object ChangeIncomePaymentKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChangeIncomePaymentKind
    FormNameParam.Value = 'TChangeIncomePaymentKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TChangeIncomePaymentKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChangeIncomePaymentKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChangeIncomePaymentKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 40
    Top = 170
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ChangeIncomePayment'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Value = 42353d
        Component = deOperDate
        DataType = ftDateTime
      end
      item
        Name = 'TotalSumm'
        Value = 0.000000000000000000
        Component = ceSumm
        DataType = ftFloat
      end
      item
        Name = 'FromId'
        Value = ''
        Component = FromGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = FromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ChangeIncomePaymentKindId'
        Value = ''
        Component = ChangeIncomePaymentKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ChangeIncomePaymentKindName'
        Value = ''
        Component = ChangeIncomePaymentKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
      end>
    PackSize = 1
    Left = 296
    Top = 212
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ChangeIncomePayment'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 42353d
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inTotalSumm'
        Value = 0.000000000000000000
        Component = ceSumm
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inChangeIncomePaymentKindId'
        Value = ''
        Component = ChangeIncomePaymentKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 344
    Top = 212
  end
end
