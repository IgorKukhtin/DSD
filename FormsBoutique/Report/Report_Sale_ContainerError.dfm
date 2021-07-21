inherited Report_Sale_ContainerErrorForm: TReport_Sale_ContainerErrorForm
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1044#1086#1083#1075#1086#1074
  ClientHeight = 425
  ClientWidth = 1065
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 1081
  ExplicitHeight = 463
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1065
    Height = 25
    Visible = False
    ExplicitWidth = 1065
    ExplicitHeight = 25
    inherited deStart: TcxDateEdit
      Left = 29
      EditValue = 42736d
      Visible = False
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      EditValue = 42736d
      Visible = False
      ExplicitLeft = 142
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      Visible = False
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 120
      ExplicitWidth = 20
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 51
    Width = 1065
    Height = 374
    TabOrder = 3
    ExplicitTop = 51
    ExplicitWidth = 1065
    ExplicitHeight = 374
    ClientRectBottom = 374
    ClientRectRight = 1065
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1065
      ExplicitHeight = 374
      inherited cxGrid: TcxGrid
        Width = 1065
        Height = 374
        ExplicitWidth = 1065
        ExplicitHeight = 374
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
              Column = SummDebt_Container
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDebt_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDebt_Container
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt_Container
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDebt_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDebt_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountDebt_Container
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayReturn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPayOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalChangePercentPay
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object LabelName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'LabelName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1040#1088#1090#1080#1082#1091#1083
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object GoodsSizeName: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object SummDebt_Sale: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1087#1086' '#1076#1086#1082'. '#1087#1088#1086#1076#1072#1078#1080' ('#1074' '#1043#1056#1053')'
            DataBinding.FieldName = 'SummDebt_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object SummDebt_Container: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1087#1086' '#1087#1088#1086#1074#1086#1076#1082#1072#1084' ('#1074' '#1043#1056#1053')'
            DataBinding.FieldName = 'SummDebt_Container'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object CountDebt_Sale: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1087#1086' '#1076#1086#1082'. '#1087#1088#1086#1076#1072#1078#1080' ('#1096#1090'.)'
            DataBinding.FieldName = 'CountDebt_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object CountDebt_Container: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1087#1086' '#1087#1088#1086#1074#1086#1076#1082#1072#1084' ('#1096#1090'.)'
            DataBinding.FieldName = 'CountDebt_Container'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1057#1082#1080#1076#1082#1080' 1'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ChangePercentNext: TcxGridDBColumn
            Caption = '% '#1057#1082#1080#1076#1082#1080' 2'
            DataBinding.FieldName = 'ChangePercentNext'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object OperPriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1043#1056#1053
            DataBinding.FieldName = 'OperPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object TotalSummPriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1087#1088#1072#1081#1089')'
            DataBinding.FieldName = 'TotalSummPriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalPay: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1043#1056#1053
            DataBinding.FieldName = 'TotalPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object SummChangePercent: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082'. '#1074' '#1087#1088#1086#1076#1072#1078#1077
            DataBinding.FieldName = 'SummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 70
          end
          object TotalChangePercent: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1082'. '#1074' '#1087#1088#1086#1076#1072#1078#1077
            DataBinding.FieldName = 'TotalChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1082#1080#1076#1082#1072' '#1074' '#1087#1088#1086#1076#1072#1078#1077' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalCountReturn: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'TotalCountReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalReturn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'TotalReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalPayReturn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'TotalPayReturn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalPayOth: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1087#1083'. '#1074' '#1088#1072#1089#1095'.'
            DataBinding.FieldName = 'TotalPayOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1087#1083#1072#1090#1072' '#1074' '#1088#1072#1089#1095#1077#1090#1072#1093' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object TotalChangePercentPay: TcxGridDBColumn
            Caption = #1044#1086#1087'. '#1089#1082'. '#1074' '#1088#1072#1089#1095'.'
            DataBinding.FieldName = 'TotalChangePercentPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1088#1072#1089#1095#1077#1090#1072#1093' '#1043#1056#1053
            Options.Editing = False
            Width = 80
          end
          object OperDate_Partion: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'OperDate_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object Invnumber_Partion: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'Invnumber_Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsMI_AccountDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_AccountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41579d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41608d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshMovement: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshSize: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1056#1072#1079#1084#1077#1088#1072#1084
      Hint = #1087#1086' '#1056#1072#1079#1084#1077#1088#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartner: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'LocationId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSizeId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSizeName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPeriod'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42736d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42736d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDItems'
          IndexFieldNames = 'OperDate;DescName;InvNumber;LabelName;GoodsSizeName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42736d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42736d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Sale_ContainerError'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 416
    Top = 65528
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end>
    Left = 688
    Top = 280
  end
end
