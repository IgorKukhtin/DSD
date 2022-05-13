inherited Report_Movement_PriceListForm: TReport_Movement_PriceListForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072#1084'>'
  ClientHeight = 341
  ClientWidth = 1071
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1087
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 1071
    Height = 261
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 1071
    ExplicitHeight = 261
    ClientRectBottom = 261
    ClientRectRight = 1071
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1071
      ExplicitHeight = 261
      inherited cxGrid: TcxGrid
        Width = 1071
        Height = 261
        ExplicitWidth = 1071
        ExplicitHeight = 261
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsData.CancelOnExit = True
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
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Width = 70
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 70
          end
          object PartnerName: TcxGridDBColumn
            Caption = 'Lieferanten'
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            Options.Editing = False
            Width = 108
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object DiscountPartnerName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1082'. '#1091' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'DiscountPartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' '#1089#1082#1080#1076#1082#1080' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 97
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'.'#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object MeasureParentName: TcxGridDBColumn
            Caption = #1045#1076'.'#1080#1079#1084' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            DataBinding.FieldName = 'MeasureParentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object isOutlet: TcxGridDBColumn
            Caption = 'Outlet'
            DataBinding.FieldName = 'isOutlet'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object Amount: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object PriceParent: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            DataBinding.FieldName = 'PriceParent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            Options.Editing = False
            Width = 77
          end
          object MeasureMult: TcxGridDBColumn
            Caption = #1042#1083#1086#1078#1077#1085#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MeasureMult'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object EmpfPriceParent: TcxGridDBColumn
            Caption = #1056#1077#1082#1086#1084#1077#1085'. '#1094#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087'.)'
            DataBinding.FieldName = 'EmpfPriceParent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            Options.Editing = False
            Width = 57
          end
          object MinCount: TcxGridDBColumn
            Caption = #1052#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'MinCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            Options.Editing = False
            Width = 57
          end
          object MinCountMult: TcxGridDBColumn
            Caption = #1056#1077#1082#1086#1084'. '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'MinCountMult'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1082#1086#1084#1077#1085#1076#1091#1077#1084#1086#1077' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            Options.Editing = False
            Width = 57
          end
          object WeightParent: TcxGridDBColumn
            DataBinding.FieldName = 'WeightParent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object CatalogPage: TcxGridDBColumn
            DataBinding.FieldName = 'CatalogPage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 171
          end
          object GoodsCode: TcxGridDBColumn
            Caption = 'Interne Nr'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Article: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsTagName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
            DataBinding.FieldName = 'GoodsTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1077#1090#1072#1083#1080
            DataBinding.FieldName = 'GoodsTypeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProdColorName: TcxGridDBColumn
            Caption = 'Farbe'
            DataBinding.FieldName = 'ProdColorName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsSizeName: TcxGridDBColumn
            Caption = #1056#1072#1079#1084#1077#1088
            DataBinding.FieldName = 'GoodsSizeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object EngineName: TcxGridDBColumn
            Caption = 'Engine'
            DataBinding.FieldName = 'EngineName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1086#1090#1086#1088
            Options.Editing = False
            Width = 80
          end
          object myCount_pl: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1076#1086#1082'. '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'myCount_pl'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1071
    Height = 54
    ExplicitWidth = 1071
    ExplicitHeight = 54
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 44197d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 44197d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 31
      ExplicitLeft = 6
      ExplicitTop = 31
    end
    object cxLabel3: TcxLabel
      Left = 221
      Top = 31
      Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077':'
    end
    object edGoods: TcxButtonEdit
      Left = 315
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 209
    end
    object cxLabel8: TcxLabel
      Left = 249
      Top = 6
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
    object edPartner: TcxButtonEdit
      Left = 315
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 209
    end
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
        Component = GuidesGoods
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPartner
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actRefreshEmpty: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1041#1077#1079' '#1079#1072#1082#1072#1079#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091' ('#1076#1072') / '#1042#1089#1077' ('#1053#1077#1090')'
      Hint = #1041#1077#1079' '#1079#1072#1082#1072#1079#1072' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091' ('#1076#1072') / '#1042#1089#1077' ('#1053#1077#1090')'
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementDescName_order;OperDate;ObjectByName;InvNumber'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSumm_branch'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Movement_PriceListDialogForm'
      FormNameParam.Value = 'TReport_Movement_PriceListDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenFormPriceList: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
      ImageIndex = 28
      FormName = 'TPriceListMovementForm'
      FormNameParam.Value = 'TPriceListMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Movement_PriceList'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
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
          ItemName = 'bbOpenFormClient'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbSumm_branch: TdxBarControlContainerItem
      Caption = 'bbSumm_branch'
      Category = 0
      Hint = 'bbSumm_branch'
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenFormClient: TdxBarButton
      Action = actOpenFormPriceList
      Category = 0
    end
    object bbOpenFormPartner: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1082#1072#1079' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Visible = ivAlways
      ImageIndex = 28
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesPartner
      end
      item
      end
      item
      end
      item
        Component = GuidesGoods
      end>
    Left = 168
    Top = 144
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 11
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
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
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 200
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 240
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 200
  end
end
