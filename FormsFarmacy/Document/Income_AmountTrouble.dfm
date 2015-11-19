inherited Income_AmountTroubleForm: TIncome_AmountTroubleForm
  Caption = #1055#1088#1086#1073#1083#1077#1084#1085#1099#1077' '#1090#1086#1074#1072#1088#1099' '#1074' '#1087#1088#1080#1093#1086#1076#1077
  ClientHeight = 407
  ClientWidth = 796
  AddOnFormData.Params = FormParams
  ExplicitWidth = 812
  ExplicitHeight = 445
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 796
    Height = 381
    ClientRectBottom = 381
    ClientRectRight = 796
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 796
        Height = 381
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = colAmountManual
            end
            item
              Format = '+,0.###;-,0.###; ;'
              Kind = skSum
              Column = colAmountDiff
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 52
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            Options.Editing = False
            Width = 139
          end
          object colPartnerGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsCode'
            Options.Editing = False
            Width = 78
          end
          object colPartnerGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            Options.Editing = False
            Width = 158
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            DataBinding.FieldName = 'Amount'
            Options.Editing = False
            Width = 78
          end
          object colAmountManual: TcxGridDBColumn
            Caption = #1060#1072#1082#1090'. '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountManual'
            Width = 69
          end
          object colAmountDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'AmountDiff'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.###;-,0.###; ;'
            Options.Editing = False
          end
          object colReasonDifferencesName: TcxGridDBColumn
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
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
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
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReasonDifferencesName'
          DataType = ftString
          ParamType = ptInput
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
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'AmountManual'
          ToParam.DataType = ftFloat
        end
        item
          FromParam.Value = 0
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'ReasonDifferencesId'
        end
        item
          FromParam.Value = ' '
          FromParam.DataType = ftString
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'ReasonDifferencesName'
          ToParam.DataType = ftString
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
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inReasonDifferences'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesId'
        ParamType = ptInput
      end
      item
        Name = 'outAmountDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end
      item
        Value = Null
        ParamType = ptUnknown
      end>
    PackSize = 1
    Left = 224
    Top = 104
  end
end
