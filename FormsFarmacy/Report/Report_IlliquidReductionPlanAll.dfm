inherited Report_IlliquidReductionPlanAllForm: TReport_IlliquidReductionPlanAllForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072'>'
  ClientHeight = 504
  ClientWidth = 949
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 965
  ExplicitHeight = 543
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 949
    Height = 427
    ExplicitTop = 77
    ExplicitWidth = 949
    ExplicitHeight = 427
    ClientRectBottom = 427
    ClientRectRight = 949
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 949
      ExplicitHeight = 427
      inherited cxGrid: TcxGrid
        Width = 949
        Height = 427
        ExplicitWidth = 949
        ExplicitHeight = 427
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = SummaPenalty
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UserName
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaPenaltyCount
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaPenaltySum
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UserCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UserCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object UserName: TcxGridDBColumn
            Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.'
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 188
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072' ('#1086#1089#1085#1086#1074#1085#1072#1103')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 220
          end
          object AmountAll: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088#1086#1074' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'AmountAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object AmountStart: TcxGridDBColumn
            Caption = #1059#1095#1077#1090#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' ('#1073#1077#1079' '#1089#1077#1088#1099#1093')'
            DataBinding.FieldName = 'AmountStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object AmountSale: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object ProcSale: TcxGridDBColumn
            Caption = '% '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'ProcSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object SummaPenaltyCount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' '#1087#1086' '#1082#1086#1083#1080'-'#1074#1091
            DataBinding.FieldName = 'SummaPenaltyCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object ProcSaleIlliquid: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1086#1090' '#1089#1091#1084#1084#1099
            DataBinding.FieldName = 'ProcSaleIlliquid'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Calc'
            Visible = False
            Options.Editing = False
          end
          object SummaPenaltySum: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' '#1087#1086' '#1089#1091#1084#1084#1077
            DataBinding.FieldName = 'SummaPenaltySum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object SummaPenalty: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' '#1080#1090#1086#1075#1086
            DataBinding.FieldName = 'SummaPenalty'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ManDays: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
            DataBinding.FieldName = 'ManDays'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object DaysWorked: TcxGridDBColumn
            Caption = #1044#1085#1077#1081' '#1088#1072#1073#1086#1090#1072#1077#1090
            DataBinding.FieldName = 'DaysWorked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 949
    Height = 51
    ExplicitWidth = 949
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      EditValue = 43344d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      TabOrder = 1
      ExplicitWidth = 115
      Width = 115
    end
    inherited deEnd: TcxDateEdit
      Left = 131
      Top = 30
      EditValue = 42491d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 131
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072':'
      ExplicitWidth = 83
    end
    inherited cxLabel2: TcxLabel
      Left = 15
      Top = 31
      Visible = False
      ExplicitLeft = 15
      ExplicitTop = 31
    end
    object cePenalty: TcxCurrencyEdit
      Left = 748
      Top = 5
      EditValue = 250.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 4
      Width = 47
    end
    object cxLabel6: TcxLabel
      Left = 543
      Top = 6
      Caption = #1064#1090#1088#1072#1092' '#1079#1072' 1% '#1085#1077#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
    end
    object ceProcGoods: TcxCurrencyEdit
      Left = 335
      Top = 5
      EditValue = 20.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      TabOrder = 6
      Width = 45
    end
    object cxLabel3: TcxLabel
      Left = 225
      Top = 6
      Caption = '% '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1074#1099#1087'.'
    end
    object ceProcUnit: TcxCurrencyEdit
      Left = 487
      Top = 5
      EditValue = 10.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      TabOrder = 8
      Width = 53
    end
    object cxLabel4: TcxLabel
      Left = 385
      Top = 6
      Caption = '% '#1074#1099#1087'. '#1087#1086' '#1072#1087#1090#1077#1082#1077'.'
    end
    object cePlanAmount: TcxCurrencyEdit
      Left = 487
      Top = 26
      EditValue = 7.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      TabOrder = 10
      Width = 53
    end
    object cxLabel5: TcxLabel
      Left = 385
      Top = 27
      Caption = #1055#1083#1072#1085' '#1086#1090' '#1089#1091#1084#1084#1099
    end
    object cePenaltySum: TcxCurrencyEdit
      Left = 748
      Top = 26
      EditValue = 250.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 12
      Width = 47
    end
    object cxLabel7: TcxLabel
      Left = 543
      Top = 27
      Caption = #1064#1090#1088#1072#1092' '#1079#1072' 1% '#1085#1077#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1086#1090' '#1089#1091#1084#1084#1099
    end
    object cbPenaltySumInfo: TcxCheckBox
      Left = 801
      Top = 26
      Caption = #1054#1079#1085#1072#1082#1086#1084#1083#1077#1085#1080#1077
      TabOrder = 14
      Width = 99
    end
    object cbPenaltyInfo: TcxCheckBox
      Left = 801
      Top = 5
      Caption = #1054#1079#1085#1072#1082#1086#1084#1083#1077#1085#1080#1077
      TabOrder = 15
      Width = 99
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = ceProcGoods
        Properties.Strings = (
          'Value')
      end
      item
        Component = ceProcUnit
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePlanAmount
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePenalty
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePenaltySum
        Properties.Strings = (
          'Value')
      end
      item
        Component = cbPenaltyInfo
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPenaltySumInfo
        Properties.Strings = (
          'Checked')
      end>
    Left = 48
    Top = 240
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 191
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1072#1079#1074#1086#1088#1086#1090
      ImageIndex = 1
      FormName = 'TReport_IlliquidReductionPlanListForm'
      FormNameParam.Value = 'TReport_IlliquidReductionPlanListForm'
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UserID'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UserName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProcGoods'
          Value = Null
          Component = ceProcGoods
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProcUnit'
          Value = Null
          Component = ceProcUnit
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PlanAmount'
          Value = Null
          Component = cePlanAmount
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Penalty'
          Value = Null
          Component = cePenalty
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PenaltySum'
          Value = Null
          Component = cePenaltySum
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPenaltyInfo'
          Value = Null
          Component = cbPenaltyInfo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPenaltySumInfo'
          Value = Null
          Component = cbPenaltySumInfo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGetForm'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_IlliquidReductionPlanAllDialogForm'
      FormNameParam.Value = 'TReport_IlliquidReductionPlanAllDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProcGoods'
          Value = Null
          Component = ceProcGoods
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProcUnit'
          Value = Null
          Component = ceProcUnit
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PlanAmount'
          Value = Null
          Component = cePlanAmount
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Penalty'
          Value = Null
          Component = cePenalty
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PenaltySum'
          Value = Null
          Component = cePenaltySum
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPenaltyInfo'
          Value = Null
          Component = cbPenaltyInfo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPenaltySumInfo'
          Value = Null
          Component = cbPenaltySumInfo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_IlliquidReductionPlanAll'
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcGoods'
        Value = Null
        Component = ceProcGoods
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcUnit'
        Value = Null
        Component = ceProcUnit
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPlanAmount'
        Value = Null
        Component = cePlanAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPenalty'
        Value = Null
        Component = cePenalty
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPenaltyInfo'
        Value = Null
        Component = cbPenaltyInfo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPenaltySum'
        Value = Null
        Component = cePenaltySum
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPenaltySumInfo'
        Value = Null
        Component = cbPenaltySumInfo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenForm
      end>
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 136
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 136
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 104
    Top = 136
  end
end
