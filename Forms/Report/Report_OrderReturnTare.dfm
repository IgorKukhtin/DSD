inherited Report_OrderReturnTareForm: TReport_OrderReturnTareForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1047#1072#1103#1074#1082#1072#1084' '#1085#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099
  ClientHeight = 382
  ClientWidth = 762
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 778
  ExplicitHeight = 421
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 762
    Height = 323
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 762
    ExplicitHeight = 323
    ClientRectBottom = 323
    ClientRectRight = 762
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 762
      ExplicitHeight = 323
      inherited cxGrid: TcxGrid
        Width = 762
        Height = 323
        ExplicitWidth = 762
        ExplicitHeight = 323
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_return
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_order
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_sale
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_fact
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_return
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_order
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_sale
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount_fact
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
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 43
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object MovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'MovementDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088'.'
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 199
          end
          object Amount_sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'Amount_sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1086#1076#1072#1078#1072')'
            Width = 100
          end
          object Amount_order: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'Amount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object Amount_return: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'Amount_return'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 96
          end
          object Amount_fact: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1074#1086#1079#1074#1088#1072#1090' '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'Amount_fact'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' ('#1074#1086#1079#1074#1088#1072#1090' '#1092#1072#1082#1090') '#1087#1086' '#1079#1072#1103#1074#1082#1072#1084' '#1080' '#1073#1077#1079
            Width = 96
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 762
    Height = 33
    ExplicitWidth = 762
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 44562d
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 320
      EditValue = 44562d
      ExplicitLeft = 320
    end
    inherited cxLabel2: TcxLabel
      Left = 210
      ExplicitLeft = 210
    end
    object cbMovement: TcxCheckBox
      Left = 429
      Top = 6
      Action = actRefresh1
      Properties.ReadOnly = False
      TabOrder = 4
      Width = 158
    end
  end
  inherited ActionList: TActionList
    object actRefresh1: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenForm'
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMovementForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Movement_Form
      StoredProcList = <
        item
          StoredProc = spGet_Movement_Form
        end>
      Caption = 'actMovementForm'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_OrderReturnTareDialogForm'
      FormNameParam.Value = 'TReport_OrderReturnTareDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42736d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42736d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMovement'
          Value = False
          Component = cbMovement
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actReport_OrderReturnTare_Order: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1086#1082' '#1079#1072#1103#1074#1086#1082' '#1085#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099
      Hint = #1057#1087#1080#1089#1086#1082' '#1079#1072#1103#1074#1086#1082' '#1085#1072' '#1074#1086#1079#1074#1088#1072#1090' '#1090#1072#1088#1099
      ImageIndex = 25
      FormName = 'TReport_OrderReturnTare_OrderForm'
      FormNameParam.Value = 'TReport_OrderReturnTare_OrderForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Transport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Transport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_OrderReturnTare_Sale: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1086#1082' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1055#1088#1086#1076#1072#1078' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      Hint = #1057#1087#1080#1089#1086#1082' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1055#1088#1086#1076#1072#1078' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      ImageIndex = 24
      FormName = 'TReport_OrderReturnTare_SaleForm'
      FormNameParam.Value = 'TReport_OrderReturnTare_SaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Transport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Transport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_OrderReturnTare_ReturnIn: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1086#1082' '#1042#1086#1079#1074#1088#1072#1090#1085#1099#1093' '#1053#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      Hint = #1057#1087#1080#1089#1086#1082' '#1042#1086#1079#1074#1088#1072#1090#1085#1099#1093' '#1053#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1085#1086#1081' '#1090#1072#1088#1077
      ImageIndex = 26
      FormName = 'TReport_OrderReturnTare_ReturnInForm'
      FormNameParam.Value = 'TReport_OrderReturnTare_ReturnInForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42132d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Transport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Transport'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 144
  end
  inherited MasterCDS: TClientDataSet
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_OrderReturnTare'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = Null
        Component = cbMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 144
  end
  inherited BarManager: TdxBarManager
    Top = 144
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_OrderReturnTare_Sale'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_OrderReturnTare_Order'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_OrderReturnTare_ReturnIn'
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
    object dxBarButton1: TdxBarButton
      Action = mactOpenDocument
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbReport_OrderReturnTare_ReturnIn: TdxBarButton
      Action = actReport_OrderReturnTare_ReturnIn
      Category = 0
    end
    object bbReport_OrderReturnTare_Order: TdxBarButton
      Action = actReport_OrderReturnTare_Order
      Category = 0
    end
    object bbReport_OrderReturnTare_Sale: TdxBarButton
      Action = actReport_OrderReturnTare_Sale
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = mactOpenDocument
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMovement'
        Value = Null
        Component = cbMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 144
  end
  object spGet_Movement_Form: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form_two'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Movement_Send'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 128
  end
end
