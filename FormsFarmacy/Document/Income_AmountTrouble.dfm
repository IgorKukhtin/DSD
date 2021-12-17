inherited Income_AmountTroubleForm: TIncome_AmountTroubleForm
  Caption = #1055#1088#1086#1073#1083#1077#1084#1085#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1074' '#1087#1088#1080#1093#1086#1076#1077
  ClientHeight = 407
  ClientWidth = 811
  AddOnFormData.Params = FormParams
  ExplicitWidth = 827
  ExplicitHeight = 446
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 811
    Height = 381
    ExplicitWidth = 796
    ExplicitHeight = 381
    ClientRectBottom = 381
    ClientRectRight = 811
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 796
      ExplicitHeight = 381
      inherited cxGrid: TcxGrid
        Width = 811
        Height = 381
        ExplicitWidth = 796
        ExplicitHeight = 381
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = '+,0.###;-,0.###; ;'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = PretensionAmount
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 52
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            Options.Editing = False
            Width = 139
          end
          object PartnerGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsCode'
            Options.Editing = False
            Width = 78
          end
          object PartnerGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            Options.Editing = False
            Width = 158
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            DataBinding.FieldName = 'Amount'
            Options.Editing = False
            Width = 78
          end
          object AmountManual: TcxGridDBColumn
            Caption = #1060#1072#1082#1090'. '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountManual'
            Width = 69
          end
          object PretensionAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1088#1077#1090#1077#1085#1079#1080#1080
            DataBinding.FieldName = 'PretensionAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Options.Editing = False
            Width = 77
          end
          object AmountDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'AmountDiff'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.###;-,0.###; ;'
            Options.Editing = False
            Width = 61
          end
          object ReasonDifferencesName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
            DataBinding.FieldName = 'ReasonDifferencesName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReasonDifferences
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Width = 132
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actReasonDifferences: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1095#1080#1085#1099' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
      FormName = 'TReasonDifferencesForm'
      FormNameParam.Value = 'TReasonDifferencesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actSetEqual: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Amount'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'AmountManual'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 0
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'ReasonDifferencesId'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = ' '
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'ReasonDifferencesName'
          ToParam.DataType = ftString
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spUpdate_MovementItem_Income_AmountManual
      StoredProcList = <
        item
          StoredProc = spUpdate_MovementItem_Income_AmountManual
        end>
      Caption = #1060#1072#1082#1090' = '#1076#1086#1082#1091#1084#1077#1085#1090
      ShortCut = 32
    end
    object dsdUpdateDataSet1: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MovementItem_Income_AmountManual
      StoredProcList = <
        item
          StoredProc = spUpdate_MovementItem_Income_AmountManual
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Income_Trouble'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 176
  end
  object spUpdate_MovementItem_Income_AmountManual: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Income_AmountManual'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonDifferences'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 104
  end
end
