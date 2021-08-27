inherited CreateOrderFromMCSLayoutForm: TCreateOrderFromMCSLayoutForm
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1085#1072' '#1086#1089#1085#1086#1074#1077' '#1053#1058#1047' '#1080' '#1042#1099#1082#1083#1072#1076#1082#1080
  AddOnFormData.Params = FormParams
  ExplicitWidth = 591
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.ShowEditButtons = gsebAlways
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object NeedReorder: TcxGridDBColumn
            AlternateCaption = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1089#1086#1079#1076#1072#1090#1100' '#1079#1072#1082#1072#1079
            Caption = #1044#1072
            DataBinding.FieldName = 'NeedReorder'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderHint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1089#1086#1079#1076#1072#1090#1100' '#1079#1072#1082#1072#1079
            Width = 26
          end
          object UnitCode: TcxGridDBColumn
            AlternateCaption = #1050#1086#1076' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            HeaderHint = #1050#1086#1076' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            Options.Editing = False
            Width = 36
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Options.Editing = False
            Width = 78
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Options.Editing = False
            Width = 329
          end
          object ExistsOrderInternal: TcxGridDBColumn
            AlternateCaption = #1057#1091#1097#1077#1089#1090#1074#1091#1077#1090' '#1072#1074#1090#1086#1079#1072#1082#1072#1079' '#1085#1072' '#1089#1077#1075#1086#1076#1085#1103
            Caption = #1045#1089#1090#1100
            DataBinding.FieldName = 'ExistsOrderInternal'
            HeaderHint = #1057#1091#1097#1077#1089#1090#1074#1091#1077#1090' '#1072#1074#1090#1086#1079#1072#1082#1072#1079' '#1085#1072' '#1089#1077#1075#1086#1076#1085#1103
            Options.Editing = False
            Width = 43
          end
          object MovementId: TcxGridDBColumn
            AlternateCaption = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1079#1072#1103#1074#1082#1091
            Caption = '->'
            DataBinding.FieldName = 'MovementId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = mactOpenForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Properties.ViewStyle = vsButtonsOnly
            HeaderHint = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1079#1072#1103#1074#1082#1091
            Width = 34
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object mactOpenForm: TMultiAction
      Category = 'OpenInternalOrder'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_MovementId_OrderInternal_Auto
        end
        item
          Action = actOpenOrderInternalForm
        end>
      Caption = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1079#1072#1103#1074#1082#1091
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1079#1072#1103#1074#1082#1091
    end
    object actGet_MovementId_OrderInternal_Auto: TdsdExecStoredProc
      Category = 'OpenInternalOrder'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_MovementId_OrderInternal_Auto
      StoredProcList = <
        item
          StoredProc = spGet_MovementId_OrderInternal_Auto
        end>
      Caption = 'actGet_MovementId_OrderInternal_Auto'
    end
    object actOpenOrderInternalForm: TdsdOpenForm
      Category = 'OpenInternalOrder'
      MoveParams = <>
      Caption = 'actOpenOrderInternalForm'
      FormName = 'TOrderInternalForm'
      FormNameParam.Value = 'TOrderInternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actExecInsertUpdate_MovementItem_OrderInternalMCS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MovementItem_OrderInternalMCSLayout
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MovementItem_OrderInternalMCSLayout
        end>
      Caption = 'actExecInsertUpdate_MovementItem_OrderInternalMCS'
    end
    object actStartInsertUpdate_MovementItem_OrderInternalMCS: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actStartExec
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1089#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084'?'
      Caption = #1053#1072#1095#1072#1090#1100' '#1089#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Hint = #1053#1072#1095#1072#1090#1100' '#1089#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      ImageIndex = 30
    end
    object actStartExec: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecInsertUpdate_MovementItem_OrderInternalMCS
        end>
      View = cxGridDBTableView
      Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082
      Hint = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082
    end
    object actSelectAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
      ImageIndex = 63
      Value = False
      HintTrue = #1057#1085#1103#1090#1100' '#1086#1090#1084#1077#1090#1082#1080
      HintFalse = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
      CaptionTrue = #1057#1085#1103#1090#1100' '#1086#1090#1084#1077#1090#1082#1080
      CaptionFalse = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForOrderInternal'
    Params = <
      item
        Name = 'inSelectAll'
        Value = Null
        Component = actSelectAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 176
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actStartInsertUpdate_MovementItem_OrderInternalMCS
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actSelectAll
      Category = 0
    end
  end
  object spInsertUpdate_MovementItem_OrderInternalMCSLayout: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderInternalMCSLayout'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNeedCreate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NeedReorder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOrderExists'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ExistsOrderInternal'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 104
  end
  object spGet_MovementId_OrderInternal_Auto: TdsdStoredProc
    StoredProcName = 'gpGet_MovementId_OrderInternal_Auto'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 144
  end
end
