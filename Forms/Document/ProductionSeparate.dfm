inherited ProductionSeparateForm: TProductionSeparateForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
  ClientHeight = 678
  ClientWidth = 913
  ExplicitTop = -68
  ExplicitWidth = 929
  ExplicitHeight = 717
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 122
    Width = 913
    Height = 556
    TabOrder = 2
    ExplicitTop = 122
    ExplicitWidth = 913
    ExplicitHeight = 556
    ClientRectBottom = 556
    ClientRectRight = 913
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 913
      ExplicitHeight = 532
      inherited cxGrid: TcxGrid
        Width = 913
        Height = 224
        ExplicitWidth = 913
        ExplicitHeight = 224
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colLiveWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colLiveWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          inherited colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1088#1072#1089#1093#1086#1076')'
          end
          object GoodsKindName: TcxGridDBColumn [3]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 122
          end
          object MeasureName: TcxGridDBColumn [4]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object StorageLineName: TcxGridDBColumn [5]
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
            DataBinding.FieldName = 'StorageLineName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStorageLine
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amount: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object PriceIn: TcxGridDBColumn [7]
            Caption = #1062#1077#1085#1072' '#1089'/'#1089
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object SummIn: TcxGridDBColumn [8]
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089
            DataBinding.FieldName = 'SummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colLiveWeight: TcxGridDBColumn [9]
            Caption = #1046#1080#1074#1086#1081' '#1074#1077#1089
            DataBinding.FieldName = 'LiveWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object HeadCount: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 229
        Width = 913
        ExplicitTop = 229
        ExplicitWidth = 913
        inherited cxGridDBTableViewChild: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildLiveWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummIn_hist
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildHeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildLiveWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummIn_hist
            end>
          Styles.Content = nil
          object GoodsGroupCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076' '#1075#1088#1091#1087#1087#1099
            DataBinding.FieldName = 'GoodsGroupCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1075#1088#1091#1087#1087#1099' '#1076#1083#1103' '#1089#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1087#1077#1095#1072#1090#1080
            Width = 70
          end
          object CholdGoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          inherited colChildGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076')'
          end
          object ChildGoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceChild
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 122
          end
          object CholdMeasureName: TcxGridDBColumn [5]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ChildStorageLineName: TcxGridDBColumn [6]
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
            DataBinding.FieldName = 'StorageLineName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStorageLineChild
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ChildAmount: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object chPriceIn_hist: TcxGridDBColumn [8]
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'PriceIn_hist'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chPriceIn: TcxGridDBColumn [9]
            Caption = #1062#1077#1085#1072' '#1089'/'#1089
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chSummIn: TcxGridDBColumn [10]
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089
            DataBinding.FieldName = 'SummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chSummIn_hist: TcxGridDBColumn [11]
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'SummIn_hist'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ChildLiveWeight: TcxGridDBColumn [12]
            Caption = #1046#1080#1074#1086#1081' '#1074#1077#1089
            DataBinding.FieldName = 'LiveWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ChildHeadCount: TcxGridDBColumn [13]
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object ChildPartionGoods: TcxGridDBColumn [14]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chIsCalculated: TcxGridDBColumn [15]
            Caption = #1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'isCalculated'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088#1072#1089#1095#1077#1090' '#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077'-'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080'> ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 55
          end
          inherited colChildIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxBottomSplitter: TcxSplitter
        Top = 224
        Width = 913
        ExplicitTop = 224
        ExplicitWidth = 913
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 913
    Height = 96
    ExplicitWidth = 913
    ExplicitHeight = 96
    inherited cxLabel15: TcxLabel
      Caption = '*'#1057#1090#1072#1090#1091#1089
      ExplicitWidth = 46
    end
    inherited ceStatus: TcxButtonEdit
      ExplicitHeight = 22
    end
    object cePartionGoods: TcxTextEdit
      Left = 214
      Top = 61
      TabOrder = 10
      Width = 270
    end
    object cxLabel10: TcxLabel
      Left = 214
      Top = 43
      Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
    end
    object cbCalculated: TcxCheckBox
      Left = 490
      Top = 61
      Caption = #1088#1072#1089#1095#1077#1090' '#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077'-'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080'>'
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 335
    end
    object edIsAuto: TcxCheckBox
      Left = 766
      Top = 23
      Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 143
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    inherited actGridToExcel: TdsdGridToExcel
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' - 1 '#1074' Excel'
    end
    object actPrint_4001: TdsdPrintAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001)'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001)'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001)'
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001)'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080
    end
    object actPrint_Ceh: TdsdPrintAction [10]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintCeh
      StoredProcList = <
        item
          StoredProc = spSelectPrintCeh
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupCode;GoodsGroupNameFull;GoodsName'
        end
        item
          DataSet = PrintItemsTwoCDS
          UserName = 'frxDBDMasterTwo'
          IndexFieldNames = 'StorageLineCode;StorageLineName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1086#1073#1074#1072#1083#1082#1077
      ReportNameParam.Value = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1086#1073#1074#1072#1083#1082#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateChildDS: TdsdUpdateDataSet [11]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    inherited actMIMasterProtocol: TdsdOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1088#1072#1089#1093#1086#1076')>'
    end
    inherited actMIChildProtocol: TdsdOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083#1077#1084#1077#1085#1090#1072' ('#1087#1088#1080#1093#1086#1076')>'
    end
    inherited actGoodsChoiceMaster: TOpenChoiceForm
      isShowModal = False
    end
    inherited actGoodsChoiceChild: TOpenChoiceForm
      isShowModal = False
    end
    object actGoodsKindChoiceChild: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStorageLine: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TStorageLineForm'
      FormName = 'TStorageLineForm'
      FormNameParam.Value = 'TStorageLineForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageLineName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStorageLineChild: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TStorageLineForm'
      FormName = 'TStorageLineForm'
      FormNameParam.Value = 'TStorageLineForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'StorageLineId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'StorageLineName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_MI_Calculated: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_Calculated
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_Calculated
        end
        item
          StoredProc = spSelect
        end>
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072'/'#1085#1077#1090' '#1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1087#1088#1080#1093#1086#1076#1072' - '#1088#1072#1089#1095#1077#1090' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1055#1088#1086#1080#1079#1074#1086#1076 +
        #1089#1090#1074#1077'-'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080'>'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072'/'#1085#1077#1090' '#1076#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1087#1088#1080#1093#1086#1076#1072' - '#1088#1072#1089#1095#1077#1090' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1055#1088#1086#1080#1079#1074#1086#1076 +
        #1089#1090#1074#1077'-'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080'>'
      ImageIndex = 76
    end
    object actCalculated: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCalculated
      StoredProcList = <
        item
          StoredProc = spCalculated
        end
        item
          StoredProc = spSelect
        end>
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072'/'#1085#1077#1090' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' - '#1088#1072#1089#1095#1077#1090' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077'-'#1088#1072 +
        #1079#1076#1077#1083#1077#1085#1080#1080'>'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072'/'#1085#1077#1090' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' - '#1088#1072#1089#1095#1077#1090' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077'-'#1088#1072 +
        #1079#1076#1077#1083#1077#1085#1080#1080'>'
      ImageIndex = 77
    end
    object actUpdate_StorageLineByChild: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpUpdate_StorageLineByChild
      StoredProcList = <
        item
          StoredProc = gpUpdate_StorageLineByChild
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actUpdate_StorageLineByChild'
    end
    object macUpdate_StorageLineByChild: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_StorageLineByChild
        end>
      QuestionBeforeExecute = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1088#1072#1089#1093#1086#1076' '#1087#1086' '#1083#1080#1085#1080#1103#1084' '#1087#1088'-'#1074#1072' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080#1093#1086#1076'?'
      InfoAfterExecute = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1074#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1088#1072#1089#1093#1086#1076' '#1087#1086' '#1083#1080#1085#1080#1103#1084' '#1087#1088'-'#1074#1072' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080#1093#1086#1076
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1088#1072#1089#1093#1086#1076' '#1087#1086' '#1083#1080#1085#1080#1103#1084' '#1087#1088'-'#1074#1072' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080#1093#1086#1076
      ImageIndex = 42
    end
    object actGridChildToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Grid = cxGridChild
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' - 2 '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  inherited MasterCDS: TClientDataSet
    Left = 656
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ProductionSeparate'
  end
  inherited BarManager: TdxBarManager
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
          BeginGroup = True
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddChild'
        end
        item
          Visible = True
          ItemName = 'bbErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedChild'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_StorageLineByChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbCalculated'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_MI_Calculated'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrint_4001'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Ceh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIMasterProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
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
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbPrint_Ceh: TdxBarButton
      Action = actPrint_Ceh
      Category = 0
    end
    object bbCalculated: TdxBarButton
      Action = actCalculated
      Category = 0
    end
    object bbUpdate_MI_Calculated: TdxBarButton
      Action = actUpdate_MI_Calculated
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1090#1086#1074#1072#1088#1072' "'#1088#1072#1089#1089#1095#1080#1090#1099#1074#1072#1077#1090#1089#1103' '#1044#1072'/'#1053#1077#1090'"'
      Category = 0
    end
    object bbUpdate_StorageLineByChild: TdxBarButton
      Action = macUpdate_StorageLineByChild
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actGridChildToExcel
      Category = 0
    end
    object bbPrint_4001: TdxBarButton
      Action = actPrint_4001
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 96
    Top = 272
  end
  inherited FormParams: TdsdFormParams
    Left = 136
    Top = 208
  end
  inherited StatusGuides: TdsdGuides
    Tag = 123
    Left = 144
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ProductionSeparate'
    Left = 80
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProductionSeparate'
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
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
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
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionGoods'
        Value = ''
        Component = cePartionGoods
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCalculated'
        Value = Null
        Component = cbCalculated
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsAuto'
        Value = Null
        Component = edIsAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 168
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ProductionSeparate'
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
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = ''
        Component = cePartionGoods
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 450
    Top = 200
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 224
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = cePartionGoods
      end>
    Left = 272
    Top = 241
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 192
    Top = 256
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Master_SetErased'
    Left = 478
    Top = 248
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Master_SetUnErased'
    Left = 390
    Top = 200
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Master'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageLineId'
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
      end
      item
        Name = 'inLiveWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LiveWeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 560
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Master'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLiveWeight'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited ChildCDS: TClientDataSet
    IndexFieldNames = ''
    MasterFields = ''
    MasterSource = nil
    PacketRecords = -1
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Child_SetErased'
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionSeparate_Child_SetUnErased'
  end
  inherited spInsertMaskMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Child'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inParentId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLiveWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'LiveWeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited GuidesTo: TdsdGuides
    PositionDataSet = 'MasterCDS'
  end
  inherited GuidesFrom: TdsdGuides
    PositionDataSet = 'MasterCDS'
    Left = 304
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ProductionSeparate_Child'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
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
        Name = 'inParentId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLiveWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'LiveWeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 767
    Top = 176
  end
  object spSelectPrintCeh: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Ceh_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsTwoCDS
      end>
    OutputType = otMultiDataSet
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
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 671
    Top = 128
  end
  object PrintItemsTwoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 612
    Top = 174
  end
  object spCalculated: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Calculated'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCalculated'
        Value = Null
        Component = cbCalculated
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 419
  end
  object spUpdate_MI_Calculated: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionSeparate_Calculated'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisCalculated'
        Value = False
        Component = ChildCDS
        ComponentItem = 'isCalculated'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 451
  end
  object gpUpdate_StorageLineByChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionSeparate_StorageLineByChild'
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
      end>
    PackSize = 1
    Left = 96
    Top = 427
  end
end
