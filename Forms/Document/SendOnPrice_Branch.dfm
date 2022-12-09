inherited SendOnPrice_BranchForm: TSendOnPrice_BranchForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077' ('#1092#1080#1083#1080#1072#1083')>'
  ClientHeight = 668
  ClientWidth = 944
  ExplicitWidth = 960
  ExplicitHeight = 707
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 166
    Width = 944
    Height = 502
    ExplicitTop = 166
    ExplicitWidth = 944
    ExplicitHeight = 502
    ClientRectBottom = 502
    ClientRectRight = 944
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 944
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 944
        Height = 478
        ExplicitWidth = 944
        ExplicitHeight = 478
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
              Column = AmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPercentAmount
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
              Column = AmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Kind = skSum
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPercentAmount
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
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
          object GoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn [2]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
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
            Width = 100
          end
          object PartionGoods: TcxGridDBColumn [4]
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object MeasureName: TcxGridDBColumn [5]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object isPeresort: TcxGridDBColumn [6]
            Caption = #1055#1077#1088#1077#1089#1086#1088#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPeresort'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isBarCode: TcxGridDBColumn [7]
            Caption = #1057#1082#1080#1076#1082#1072' '#1089#1082#1072#1085'. '#1091#1087'.'
            DataBinding.FieldName = 'isBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountPack: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'CountPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object WeightTotal: TcxGridDBColumn [9]
            Caption = #1042#1077#1089' 1'#1077#1076'.  '#1089' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object WeightPack: TcxGridDBColumn [10]
            Caption = #1042#1077#1089' 1'#1077#1076'. '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object ChangePercentAmount: TcxGridDBColumn [11]
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089
            DataBinding.FieldName = 'ChangePercentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn [12]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountChangePercent: TcxGridDBColumn [13]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'AmountChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalPercentAmount: TcxGridDBColumn [14]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'TotalPercentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPartner: TcxGridDBColumn [15]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price: TcxGridDBColumn [16]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountForPrice: TcxGridDBColumn [17]
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountSumm: TcxGridDBColumn [18]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object UnitName: TcxGridDBColumn [19]
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 944
    Height = 140
    TabOrder = 3
    ExplicitWidth = 944
    ExplicitHeight = 140
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 183
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 183
      ExplicitWidth = 85
      Width = 85
    end
    inherited cxLabel2: TcxLabel
      Left = 183
      Caption = #1044#1072#1090#1072' ('#1088#1072#1089#1093#1086#1076')'
      ExplicitLeft = 183
      ExplicitWidth = 77
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 168
      ExplicitHeight = 22
      Width = 168
    end
    object cxLabel3: TcxLabel
      Left = 274
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 274
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 200
    end
    object edTo: TcxButtonEdit
      Left = 488
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 180
    end
    object cxLabel4: TcxLabel
      Left = 488
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 488
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 128
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 628
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 628
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 680
      Top = 63
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 144
    end
    object cxLabel8: TcxLabel
      Left = 680
      Top = 45
      Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
    end
    object edOperDatePartner: TcxDateEdit
      Left = 183
      Top = 63
      EditValue = 42193d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 15
      Width = 85
    end
    object cxLabel10: TcxLabel
      Left = 183
      Top = 45
      Caption = #1044#1072#1090#1072' ('#1087#1088#1080#1093#1086#1076')'
    end
    object cxLabel11: TcxLabel
      Left = 680
      Top = 5
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 680
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 144
    end
    object cxLabel5: TcxLabel
      Left = 87
      Top = 5
      Caption = #8470' '#1079#1072#1103#1074#1082#1080
    end
    object edInvNumberOrder: TcxButtonEdit
      Left = 87
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 89
    end
    object cxLabel25: TcxLabel
      Left = 8
      Top = 90
      Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
    end
    object edInvNumberTransport: TcxButtonEdit
      Left = 8
      Top = 108
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 260
    end
    object cxLabel22: TcxLabel
      Left = 680
      Top = 90
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 680
      Top = 108
      TabOrder = 24
      Width = 144
    end
    object cxLabel9: TcxLabel
      Left = 488
      Top = 90
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
    end
    object edSubjectDoc: TcxButtonEdit
      Left = 488
      Top = 108
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 180
    end
    object edInvNumberProduction: TcxButtonEdit
      Left = 274
      Top = 108
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 200
    end
    object cxLabel6: TcxLabel
      Left = 274
      Top = 90
      Caption = #8470' '#1076#1086#1082'. '#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1099
    end
  end
  object cbCalcAmountPartner: TcxCheckBox [2]
    Left = 274
    Top = 63
    Caption = #1056#1072#1089#1095#1077#1090' '#1087#1086' % '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089' :'
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 157
  end
  object edChangePercentAmount: TcxCurrencyEdit [3]
    Left = 434
    Top = 63
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    Properties.ReadOnly = False
    Properties.UseThousandSeparator = True
    TabOrder = 7
    Width = 40
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actPrintSaleOrderTax: TdsdPrintAction [0]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_SaleOrderTax
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SaleOrderTax
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      ImageIndex = 18
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
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actGoodsChoiceForm: TOpenChoiceForm [4]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1087#1088#1080#1093#1086#1076')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1087#1088#1080#1093#1086#1076')'
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = 2.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.ParamType = ptInput
    end
    object actPrintUnit: TdsdPrintAction [11]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintOut
      StoredProcList = <
        item
          StoredProc = spSelectPrintOut
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      ImageIndex = 19
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = 4.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDiff: TdsdPrintAction [12]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintOut
      StoredProcList = <
        item
          StoredProc = spSelectPrintOut
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1072#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1072#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081')'
      ImageIndex = 22
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = 3.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSaleOrder: TdsdPrintAction [13]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_SaleOrder
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SaleOrder
        end>
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      ImageIndex = 21
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
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintPackGross: TdsdPrintAction [14]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_Pack
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Pack
        end>
      Caption = #1059#1087#1072#1082'. '#1051#1080#1089#1090' '#1074#1077#1089' '#1041#1056#1059#1058#1058#1054
      Hint = #1059#1087#1072#1082'. '#1051#1080#1089#1090' '#1074#1077#1089' '#1041#1056#1059#1058#1058#1054
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;WeighingNumber;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = 1.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SalePackGross'
      ReportNameParam.Value = 'PrintMovement_SalePackGross'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintOut: TdsdPrintAction [15]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintOut
      StoredProcList = <
        item
          StoredProc = spSelectPrintOut
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1088#1072#1089#1093#1086#1076')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1088#1072#1089#1093#1086#1076')'
      ImageIndex = 19
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PrintParam'
          Value = 1.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [20]
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
    object UnitChoiceForm: TOpenChoiceForm [24]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoiceForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
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
    object actInsertUpdateMIAmountChangePercent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIAmountChangePercent
      StoredProcList = <
        item
          StoredProc = spUpdateMIAmountChangePercent
        end
        item
          StoredProc = spSelect
        end>
      Caption = 
        #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')> '#1074' <'#1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')> '#1080' <'#1050#1086#1083'-' +
        #1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = 
        #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')> '#1074' <'#1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')> '#1080' <'#1050#1086#1083'-' +
        #1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')>'
      ImageIndex = 42
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')> '#1074' <'#1050#1086#1083'-'#1074#1086' ('#1088#1072 +
        #1089#1093#1086#1076')> '#1080' <'#1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')>?'
      InfoAfterExecute = 
        #1044#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')> '#1074' <'#1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')> '#1080' <'#1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076 +
        #1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')> '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1091#1089#1087#1077#1096#1085#1086'.'
    end
    object actInsertUpdateMIAmountPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIAmountPartner
      StoredProcList = <
        item
          StoredProc = spUpdateMIAmountPartner
        end
        item
          StoredProc = spSelect
        end>
      Caption = 
        #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')> '#1074' <'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086 +
        #1076')>'
      Hint = 
        #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')> '#1074' <'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086 +
        #1076')>'
      ImageIndex = 41
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')> '#1074' ' +
        '<'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')>?'
      InfoAfterExecute = 
        #1044#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' ('#1088#1072#1089#1093#1086#1076')> '#1074' <'#1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')> '#1087#1077#1088#1077#1085#1077 +
        #1089#1083#1080' '#1091#1089#1087#1077#1096#1085#1086'.'
    end
    object actDialog_TTN: TdsdOpenForm
      Category = 'Print_TTN'
      MoveParams = <>
      Caption = 'actDialog_TTN'
      Hint = 'actDialog_TTN'
      FormName = 'TTransportGoodsForm'
      FormNameParam.Value = 'TTransportGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId_TransportGoods'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Sale'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate_TransportGoods'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPrint_TTN: TdsdPrintAction
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN
        end>
      Caption = 'actPrint_TTN'
      Hint = 'actPrint_TTN'
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = 'PrintMovement_TTN'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_TTN: TMultiAction
      Category = 'Print_TTN'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_TTN
        end
        item
          Action = actSPPrintTTNProcName
        end
        item
          Action = actPrint_TTN
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 15
    end
    object actSPPrintTTNProcName: TdsdExecStoredProc
      Category = 'Print_TTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTTN
      StoredProcList = <
        item
          StoredProc = spGetReporNameTTN
        end>
      Caption = 'actSPPrintTTNProcName'
    end
    object actOpenProductionUnitForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'>'
      ImageIndex = 32
      FormName = 'TProductionUnionForm'
      FormNameParam.Value = 'TProductionUnionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = GuidesProductionDoc
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SendOnPrice'
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
        Name = 'inPriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
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
        Name = 'inShowAll'
        Value = False
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
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
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
          ItemName = 'bbInsertUpdateMIAmount'
        end
        item
          Visible = True
          ItemName = 'bbtInsertUpdateMIAmountChangePercent'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenProductionUnitForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintOut'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintUnit'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintDiff'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintSaleOrder'
        end
        item
          Visible = True
          ItemName = 'bbPrintSaleOrderTax'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_TTN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintPackGross'
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
      Visible = True
    end
    object bbPrintOut: TdxBarButton
      Action = actPrintOut
      Category = 0
    end
    object bbPrintUnit: TdxBarButton
      Action = actPrintUnit
      Category = 0
    end
    object bbPrintDiff: TdxBarButton
      Action = actPrintDiff
      Category = 0
    end
    object bbInsertUpdateMIAmount: TdxBarButton
      Action = actInsertUpdateMIAmountPartner
      Category = 0
    end
    object bbPrintSaleOrder: TdxBarButton
      Action = actPrintSaleOrder
      Category = 0
    end
    object bbtInsertUpdateMIAmountChangePercent: TdxBarButton
      Action = actInsertUpdateMIAmountChangePercent
      Category = 0
    end
    object bbPrint_TTN: TdxBarButton
      Action = mactPrint_TTN
      Category = 0
    end
    object bbPrintPackGross: TdxBarButton
      Action = actPrintPackGross
      Category = 0
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Action = actPrintSaleOrderTax
      Category = 0
    end
    object bbOpenProductionUnitForm: TdxBarButton
      Action = actOpenProductionUnitForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 4
      end>
    Left = 534
    Top = 241
  end
  inherited PopupMenu: TPopupMenu
    Left = 504
    Top = 440
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
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
        Name = 'ReportNameSendOnPrice'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendOnPriceTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendOnPriceBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_TransportGoods'
        Value = 'NULL'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_TransportGoods'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTTN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 552
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_SendOnPrice'
    Left = 128
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SendOnPrice'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
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
        Name = 'inChangePercentAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'inChangePercentAmount'
        DataType = ftFloat
        ParamType = ptInput
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
        DataType = ftString
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
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
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
        Name = 'PriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Order'
        Value = Null
        Component = GuidesInvNumberOrder
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercentAmount'
        Value = Null
        Component = edChangePercentAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Transport'
        Value = Null
        Component = TransportChoiceGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Transport'
        Value = Null
        Component = TransportChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_TransportGoods'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate_TransportGoods'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_TransportGoods'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_TransportGoods'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocid'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocName'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Production'
        Value = Null
        Component = GuidesProductionDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_ProductionFull'
        Value = Null
        Component = GuidesProductionDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 256
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SendOnPrice_Branch'
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
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
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
        Name = 'inSubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Order'
        Value = Null
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 160
    Top = 192
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
        Control = edOperDatePartner
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edInvNumberOrder
      end
      item
        Control = edPriceList
      end
      item
        Control = ceComment
      end
      item
        Control = edSubjectDoc
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 616
    Top = 296
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SendOnPrice_Branch_SetErased'
    Left = 614
    Top = 488
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SendOnPrice_Branch_SetUnErased'
    Left = 614
    Top = 440
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SendOnPrice_Branch'
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
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPartner'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        Component = edChangePercentAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChangePercentAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercentAmount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChangePercentAmount'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
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
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightPack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightPack'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeightTotal'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightTotal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountPack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountPack'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SendOnPrice_Branch'
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
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        Component = edChangePercentAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChangePercentAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercentAmount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChangePercentAmount'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
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
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
        Component = PriceListGuides
      end>
    Left = 528
    Top = 320
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 460
    Top = 225
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 476
    Top = 286
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 628
    Top = 56
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_SendOnPrice_Print'
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
      end
      item
        Name = 'inReportType'
        Value = '1'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
  end
  object spSelectPrintOut: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_SendOnPrice_Print'
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
      end
      item
        Name = 'inReportType'
        Value = '0'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 359
    Top = 440
  end
  object GuidesInvNumberOrder: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
    FormNameParam.Value = 'TOrderExternalJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternalJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner_Sale'
        Value = 42193d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 116
  end
  object TransportChoiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberTransport
    Key = '0'
    FormNameParam.Value = 'TTransportJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTransportJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = TransportChoiceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = TransportChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 116
    Top = 96
  end
  object spInsertUpdateMovement_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_SendOnPrice_Transport'
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
        Name = 'inMovementId_Transport'
        Value = '0'
        Component = TransportChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 161
    Top = 432
  end
  object HeaderSaver2: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement_Params
    ControlList = <
      item
        Control = edInvNumberTransport
      end>
    GetStoredProc = spGet
    Left = 280
    Top = 177
  end
  object spUpdateMIAmountPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_SendOnPrice_AmountPartner'
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
    Left = 330
    Top = 328
  end
  object spSelectPrint_SaleOrder: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Order_Print'
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
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiffTax'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 687
    Top = 248
  end
  object spUpdateMIAmountChangePercent: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_SendOnPrice_AmountChangePercent'
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
    Left = 330
    Top = 376
  end
  object spSelectPrint_TTN: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TTN_Print'
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
    Left = 787
    Top = 360
  end
  object spSelectPrint_Pack: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Pack_Print'
    DataSet = PrintItemsCDS
    DataSets = <
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
      end
      item
        Name = 'inMovementId_by'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 775
    Top = 456
  end
  object spSelectPrint_SaleOrderTax: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Order_Print'
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
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiffTax'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 751
    Top = 248
  end
  object GuidesSubjectDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSubjectDoc
    FormNameParam.Value = 'TSubjectDocForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSubjectDocForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 536
    Top = 96
  end
  object spGetReporNameTTN: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransportGoods_ReportName'
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
      end
      item
        Name = 'gpGet_Movement_TransportGoods_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTTN'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 304
  end
  object GuidesProductionDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberProduction
    Key = '0'
    FormNameParam.Value = 'TProductionPeresortJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProductionPeresortJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesProductionDoc
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesProductionDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 356
    Top = 96
  end
end
