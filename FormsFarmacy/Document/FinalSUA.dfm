inherited FinalSUAForm: TFinalSUAForm
  Caption = #1048#1090#1086#1075#1086#1074#1099#1081' '#1057#1059#1040
  ClientHeight = 560
  ClientWidth = 973
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 989
  ExplicitHeight = 599
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 133
    Width = 973
    Height = 427
    ExplicitTop = 133
    ExplicitWidth = 973
    ExplicitHeight = 427
    ClientRectBottom = 427
    ClientRectRight = 973
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 973
      ExplicitHeight = 403
      inherited cxGrid: TcxGrid
        Width = 973
        Height = 403
        ExplicitWidth = 973
        ExplicitHeight = 403
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = SendSUN
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = AmountOI
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 222
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 253
          end
          object MCS: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object Amount: TcxGridDBColumn
            Caption = #1055#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Styles.Content = dmMain.cxHeaderL1Style
            Styles.Header = dmMain.cxHeaderL1Style
            Width = 95
          end
          object SendSUN: TcxGridDBColumn
            Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074'. '#1074' '#1087#1077#1088#1077#1084#1077#1097'.'
            DataBinding.FieldName = 'SendSUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'. '#1091' '#1086#1090#1087#1088#1072#1074'.'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountOI: TcxGridDBColumn
            Caption = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountOI'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isTop: TcxGridDBColumn
            Caption = #1058#1054#1055' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'isTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object isClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090' '#1087#1086' '#1089#1077#1090#1080
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object isNot: TcxGridDBColumn
            Caption = #1053#1054#1058'- '#1085#1077#1087#1077#1088#1077#1084#1077#1097'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'isNot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object MCSIsClose: TcxGridDBColumn
            Caption = #1059#1073#1080#1090'  '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1084
            DataBinding.FieldName = 'MCSIsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object isPromoBonus: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'.  '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'isPromoBonus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object isLearnWeek: TcxGridDBColumn
            Caption = #1059#1095#1072#1089'-'#1102#1090' '#1085#1072' '#1101#1090#1086#1081' '#1085#1077#1076#1077#1083#1077
            DataBinding.FieldName = 'isLearnWeek'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 973
    Height = 107
    TabOrder = 3
    ExplicitWidth = 973
    ExplicitHeight = 107
    inherited edInvNumber: TcxTextEdit
      Left = 9
      Top = 22
      ExplicitLeft = 9
      ExplicitTop = 22
    end
    inherited cxLabel1: TcxLabel
      Left = 9
      Top = 4
      ExplicitLeft = 9
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 109
      Top = 22
      ExplicitLeft = 109
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 109
      Top = 4
      ExplicitLeft = 109
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Left = 9
      Top = 46
      ExplicitLeft = 9
      ExplicitTop = 46
    end
    inherited ceStatus: TcxButtonEdit
      Left = 9
      Top = 64
      ExplicitLeft = 9
      ExplicitTop = 64
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    object cxLabel7: TcxLabel
      Left = 221
      Top = 46
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 221
      Top = 64
      Properties.ReadOnly = False
      TabOrder = 7
      Width = 371
    end
    object cxLabel10: TcxLabel
      Left = 221
      Top = 4
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
    end
    object edInsertName: TcxButtonEdit
      Left = 221
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 118
    end
    object cxLabel12: TcxLabel
      Left = 345
      Top = 4
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
    end
    object edInsertdate: TcxDateEdit
      Left = 345
      Top = 22
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 120
    end
    object cxLabel11: TcxLabel
      Left = 474
      Top = 4
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
    end
    object edUpdateName: TcxButtonEdit
      Left = 474
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 118
    end
    object cxLabel13: TcxLabel
      Left = 599
      Top = 4
      Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
    end
    object edUpdateDate: TcxDateEdit
      Left = 599
      Top = 22
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 120
    end
    object edCalculation: TcxDateEdit
      Left = 598
      Top = 64
      EditValue = 42485d
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 120
    end
    object cxLabel3: TcxLabel
      Left = 598
      Top = 46
      Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081'.'
    end
    object cbOnlyOrder: TcxCheckBox
      Left = 725
      Top = 22
      Caption = #1058#1086#1083#1100#1082#1086' '#1074' '#1079#1072#1082#1072#1079
      TabOrder = 18
      Width = 105
    end
    object edDateOrder: TcxDateEdit
      Left = 724
      Top = 64
      EditValue = 42132d
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 100
    end
    object cxLabel4: TcxLabel
      Left = 724
      Top = 46
      Caption = #1044#1072#1090#1072' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1079#1072#1082#1072#1079
    end
  end
  inherited ActionList: TActionList
    object actRefreshUnit: TdsdDataSetRefresh [0]
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
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelect
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    object matExecUpfdate_Multiplicity: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialogNeed
      ActionList = <
        item
          Action = actUpdate_MI_FinalSUA_Need
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100
      ImageIndex = 43
    end
    object actUpdate_MI_FinalSUA_Need: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpUpdate_MI_FinalSUA_Need
      StoredProcList = <
        item
          StoredProc = gpUpdate_MI_FinalSUA_Need
        end>
      Caption = 'actExecUpfdate_Multiplicity'
    end
    object actExecuteDialogNeed: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogUpdate_PercentWagesStore'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = Null
          Component = FormParams
          ComponentItem = 'Need'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = Null
          Component = FormParams
          ComponentItem = 'NeedLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecuteDataChoiceDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDataChoiceDialog'
      FormName = 'TDataChoiceDialogForm'
      FormNameParam.Value = 'TDataChoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'DateOrder'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = #1042#1074#1077#1076#1080#1090#1077' '#1044#1072#1090#1091' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1079#1072#1082#1072#1079
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_DateOrder: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshUnit
      BeforeAction = actExecuteDataChoiceDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_DateOrder
      StoredProcList = <
        item
          StoredProc = spUpdate_DateOrder
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1072#1090#1072' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1079#1072#1082#1072#1079'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1072#1090#1072' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1079#1072#1082#1072#1079'"'
      ImageIndex = 80
    end
    object actUpdate_DateOrderClear: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshUnit
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_DateOrderClear
      StoredProcList = <
        item
          StoredProc = spUpdate_DateOrderClear
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1072#1090#1072' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1079#1072#1082#1072#1079'"'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1072#1090#1072' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1079#1072#1082#1072#1079'"'
      ImageIndex = 77
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1072#1090#1072' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1079#1072#1082#1072#1079'"?'
    end
  end
  inherited MasterDS: TDataSource
    Top = 224
  end
  inherited MasterCDS: TClientDataSet
    Top = 224
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_FinalSUA'
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
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 328
  end
  inherited BarManager: TdxBarManager
    Left = 96
    Top = 223
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormIncome'
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    object bbOpenPartionDateKind: TdxBarButton
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082'>'
      Category = 0
      Visible = ivAlways
      ImageIndex = 24
    end
    object bbInsertMI: TdxBarButton
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084
      Category = 0
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1088#1086#1082#1072#1084
      Visible = ivAlways
      ImageIndex = 74
    end
    object bbOpenFormIncome: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1093#1086#1076'>'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1093#1086#1076'>'
      Visible = ivAlways
      ImageIndex = 28
    end
    object bbMIChildProtocolOpenForm: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1072#1088#1090#1080#1080'>'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1072#1088#1090#1080#1080'>'
      Visible = ivAlways
      ImageIndex = 34
    end
    object dxBarButton1: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = matExecUpfdate_Multiplicity
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_DateOrder
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdate_DateOrderClear
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
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Top = 241
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Need'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NeedLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' '#1087#1086#1090#1088#1077#1073#1085#1086#1089#1090#1100
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateOrder'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 232
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_FinalSUA'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 176
    Top = 256
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_FinalSUA'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
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
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
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
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertId'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateId'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertdate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = Null
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Calculation'
        Value = Null
        Component = edCalculation
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyOrder'
        Value = Null
        Component = cbOnlyOrder
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateOrder'
        Value = Null
        Component = edDateOrder
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 200
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_FinalSUA'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlyOrder'
        Value = Null
        Component = cbOnlyOrder
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 346
    Top = 200
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actRefresh
      end>
    Left = 248
    Top = 240
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edComment
      end
      item
        Control = cbOnlyOrder
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 224
    Top = 201
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 72
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 598
    Top = 344
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 208
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_FinalSUA'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 408
    Top = 272
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 448
    Top = 320
  end
  inherited spGetTotalSumm: TdsdStoredProc
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
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 604
    Top = 268
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 238
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 348
    Top = 377
  end
  object GuidesInsert: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 282
    Top = 6
  end
  object GuidesUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUpdateName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 506
    Top = 6
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshUnit
    ComponentList = <
      item
      end
      item
      end>
    Left = 536
    Top = 200
  end
  object gpUpdate_MI_FinalSUA_Need: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_FinalSUA'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'Need'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 80
    Top = 376
  end
  object spUpdate_DateOrder: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_FinalSUA_DateOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateOrder'
        Value = 42132d
        Component = FormParams
        ComponentItem = 'DateOrder'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 754
    Top = 296
  end
  object spUpdate_DateOrderClear: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_FinalSUA_DateOrderClear'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 754
    Top = 376
  end
end
