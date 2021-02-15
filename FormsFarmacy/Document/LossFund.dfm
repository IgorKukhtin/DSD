inherited LossFundForm: TLossFundForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1057#1087#1080#1089#1072#1085#1080#1077' ('#1088#1072#1073#1086#1090#1072' '#1089' '#1092#1086#1085#1076#1086#1084')>'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PriceIn
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Remains_Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colIsErased
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PriceIn
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited DataPanel: TPanel
    TabOrder = 2
    inherited edComment: TcxTextEdit
      ExplicitWidth = 257
      Width = 257
    end
    inherited edCommentMarketing: TcxTextEdit
      TabOrder = 13
      Visible = False
    end
    inherited cxLabel4: TcxLabel
      Visible = False
    end
    inherited cbConfirmedMarketing: TcxCheckBox
      TabOrder = 17
      Visible = False
    end
    object ceSummaFund: TcxCurrencyEdit
      Left = 674
      Top = 67
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      TabOrder = 12
      Width = 93
    end
    object ceRetailFundResidue: TcxCurrencyEdit
      Left = 575
      Top = 67
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 93
    end
    object cxLabel21: TcxLabel
      Left = 575
      Top = 48
      Caption = #1086#1089#1090#1072#1090#1086#1082
    end
    object ceRetailFundUsed: TcxCurrencyEdit
      Left = 476
      Top = 67
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 93
    end
    object cxLabel6: TcxLabel
      Left = 476
      Top = 48
      Caption = #1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086
    end
    object ceRetailFund: TcxCurrencyEdit
      Left = 377
      Top = 67
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 93
    end
    object cxLabel8: TcxLabel
      Left = 377
      Top = 48
      Caption = #1060#1086#1085#1076': '#1085#1072#1082#1086#1087#1083#1077#1085#1086
    end
    object ceTotalSumm: TcxCurrencyEdit
      Left = 278
      Top = 67
      Properties.Alignment.Horz = taRightJustify
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 93
    end
    object cxLabel9: TcxLabel
      Left = 278
      Top = 48
      Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1080
    end
  end
  inherited ActionList: TActionList
    inherited actPrint: TdsdPrintAction
      DataSets = <
        item
          DataSet = PrintHeaderCDS
        end
        item
          DataSet = PrintItemsCDS
        end>
    end
    object actAmountDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actAmountDialog'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummaFundAvailable'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1057#1091#1084#1084#1072' '#1080#1079' '#1092#1086#1085#1076#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actRefreshGet: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = 'actRefreshGet'
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    object bbUpdate_SummaFund: TdxBarButton
      Action = actRefreshGet
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
  end
  inherited spGet: TdsdStoredProc
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42951d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ArticleLossId'
        Value = ''
        Component = GuidesArticleLoss
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ArticleLossName'
        Value = ''
        Component = GuidesArticleLoss
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailFund'
        Value = 0.000000000000000000
        Component = ceRetailFund
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailFundUsed'
        Value = ''
        Component = ceRetailFundUsed
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailFundResidue'
        Value = ''
        Component = ceRetailFundResidue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaFund'
        Value = ''
        Component = ceSummaFund
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaFundAvailable'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'SummaFundAvailable'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
  end
  inherited spUpdate_ConfirmedMarketing: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisConfirmedMarketing'
        Value = False
        Component = cbConfirmedMarketing
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
  end
  object spUpdate_SummaFund: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Loss_SummaFund'
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
        Name = 'inSummaFund'
        Value = 0.000000000000000000
        Component = ceSummaFund
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 590
    Top = 520
  end
  object HeaderSaverFund: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdate_SummaFund
    ControlList = <
      item
        Control = ceSummaFund
      end>
    GetStoredProc = spGet
    ActionAfterExecute = actRefreshGet
    Left = 592
    Top = 457
  end
end
