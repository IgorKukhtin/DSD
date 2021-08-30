inherited OrderInternalZeroingSUAForm: TOrderInternalZeroingSUAForm
  Caption = #1047#1072#1085#1091#1083#1077#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080' '#1087#1086' '#1057#1059#1040
  ClientHeight = 316
  ClientWidth = 875
  AddOnFormData.Params = FormParams
  ExplicitWidth = 891
  ExplicitHeight = 355
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 875
    Height = 290
    ExplicitTop = 58
    ExplicitWidth = 820
    ExplicitHeight = 258
    ClientRectBottom = 290
    ClientRectRight = 875
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 820
      ExplicitHeight = 258
      inherited cxGrid: TcxGrid
        Width = 875
        Height = 290
        ExplicitWidth = 820
        ExplicitHeight = 258
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_Layout
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_OrderInternal
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_Income
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_Send
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_OrderExternal
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_Reserve
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object NeedReorder: TcxGridDBColumn
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100
            DataBinding.FieldName = 'NeedReorder'
            Width = 42
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            Width = 158
          end
          object Amount: TcxGridDBColumn
            Caption = #1042' '#1079#1072#1082#1072#1079' ('#1047#1072#1085#1091#1083#1077#1085#1086')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object MCS: TcxGridDBColumn
            DataBinding.FieldName = 'MCS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object MCS_isClose: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' '#1082#1086#1076
            DataBinding.FieldName = 'MCS_isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object Amount_Layout: TcxGridDBColumn
            Caption = #1042#1099#1082#1083#1072#1076#1082#1072
            DataBinding.FieldName = 'Amount_Layout'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object Amount_OrderInternal: TcxGridDBColumn
            Caption = #1042' '#1079#1072#1082#1072#1079#1077
            DataBinding.FieldName = 'Amount_OrderInternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object Amount_Income: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076#1099' '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'Amount_Income'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Amount_Send: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1074#1089#1077
            DataBinding.FieldName = 'Amount_Send'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1074#1089#1077' '#1085#1077#1087#1088#1086#1074#1077#1076#1077#1085#1085#1099#1077
            Options.Editing = False
            Width = 75
          end
          object Amount_OrderExternal: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079' '#1087#1086#1089#1090#1072#1074#1097'.'
            DataBinding.FieldName = 'Amount_OrderExternal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Amount_Reserve: TcxGridDBColumn
            Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            DataBinding.FieldName = 'Amount_Reserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
        end
      end
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actDataToJsonAction: TdsdDataToJsonAction
      Category = 'DSDLib'
      MoveParams = <>
      View = cxGridDBTableView
      JsonParam.Name = 'Json'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'Json'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'NeedReorder'
          PairName = 'NeedReorder'
        end
        item
          FieldName = 'GoodsId'
          PairName = 'GoodsId'
        end
        item
          FieldName = 'Amount'
          PairName = 'Amount'
        end>
      Caption = 'actDataToJsonAction'
    end
    object actExecSPCreateVIPSend: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actFormClose
      BeforeAction = actDataToJsonAction
      PostDataSetBeforeExecute = False
      StoredProc = spactUpdateZeroingSUA
      StoredProcList = <
        item
          StoredProc = spactUpdateZeroingSUA
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' VIP '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1080' '#1086#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1074' '#1079#1072#1082#1072#1079
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' VIP '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1080' '#1086#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1074' '#1079#1072#1082#1072#1079
      ImageIndex = 80
    end
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actFormClose'
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ZeroingSUA'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbLabel: TdxBarControlContainerItem
      Caption = 'bbLabel'
      Category = 0
      Hint = 'bbLabel'
      Visible = ivAlways
    end
    object bbGuides: TdxBarControlContainerItem
      Caption = 'bbGuides'
      Category = 0
      Hint = 'bbGuides'
      Visible = ivAlways
    end
    object bbShowAll: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Visible = ivAlways
      ImageIndex = 63
    end
    object bbInsertUpdate: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      Visible = ivAlways
      ImageIndex = 27
    end
    object dxBarButton1: TdxBarButton
      Action = actExecSPCreateVIPSend
      Category = 0
    end
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
      end>
    Left = 104
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Json'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 152
  end
  object spactUpdateZeroingSUA: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternal_ZeroingSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJson'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Json'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 152
  end
end
