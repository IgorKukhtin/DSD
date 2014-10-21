inherited EDIJournalForm: TEDIJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <EDI>'
  ClientHeight = 424
  ClientWidth = 1102
  AddOnFormData.OnLoadAction = actSetDefaults
  ExplicitWidth = 1110
  ExplicitHeight = 451
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Width = 1102
    Height = 367
    ExplicitTop = 57
    ExplicitWidth = 1102
    ExplicitHeight = 367
    ClientRectBottom = 367
    ClientRectRight = 1102
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1102
      ExplicitHeight = 367
      inherited cxGrid: TcxGrid
        Width = 1102
        Height = 209
        Align = alTop
        ExplicitWidth = 1102
        ExplicitHeight = 209
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm_Sale
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm_Sale
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082'. (EDI)'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clOperDate_Order: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'  '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'OperDate_Order'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clInvNumber: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1103#1074#1082'. (EDI)'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumber_Order: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'InvNumber_Order'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clOperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. (EDI)'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clOperDatePartner_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clOperDate_Tax: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Tax'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clOperDate_TaxCorrective: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'OperDate_TaxCorrective'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clOperDateTax: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'. (EDI)'
            DataBinding.FieldName = 'OperDateTax'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. (EDI)'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumberPartner_Tax: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumberTax: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'. (EDI)'
            DataBinding.FieldName = 'InvNumberTax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clInvNumberPartner_TaxCorrective: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner_TaxCorrective'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clFromName_Sale: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object clToName_Sale: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' (EDI)'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clJuridicalNameFind: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1081#1076#1077#1085#1086')'
            DataBinding.FieldName = 'JuridicalNameFind'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' (EDI)'
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clGLNCode: TcxGridDBColumn
            Caption = 'GLN '#1102#1088'.'#1083'. (EDI)'
            DataBinding.FieldName = 'GLNCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clGLNPlaceCode: TcxGridDBColumn
            Caption = 'GLN '#1087#1086#1082'. (EDI)'
            DataBinding.FieldName = 'GLNPlaceCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clPartnerNameFind: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' ('#1085#1072#1081#1076#1077#1085')'
            DataBinding.FieldName = 'PartnerNameFind'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clTotalCountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' (EDI)'
            DataBinding.FieldName = 'TotalCountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object clTotalCountPartner_Sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'TotalCountPartner_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object clTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' (EDI)'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clTotalSumm_Sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'TotalSumm_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clDescName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'DescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object clmovIsCheck: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'isCheck'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clisElectron: TcxGridDBColumn
            Caption = #1050#1074#1080#1090#1072#1085#1094#1080#1103
            DataBinding.FieldName = 'isElectron'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
        end
      end
      object Splitter: TcxSplitter
        Left = 0
        Top = 209
        Width = 1102
        Height = 3
        AlignSplitter = salTop
        Control = cxGrid
      end
      object BottomPanel: TPanel
        Left = 0
        Top = 212
        Width = 1102
        Height = 155
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object cxChildGrid: TcxGrid
          Left = 0
          Top = 0
          Width = 785
          Height = 155
          Align = alLeft
          PopupMenu = PopupMenu
          TabOrder = 0
          object cxChildGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ClientDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Kind = skSum
                Column = colAmountOrder
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = colAmountPartner
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountPartnerEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartner
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartnerEDI
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartner
              end
              item
                Kind = skSum
                Column = colAmountOrder
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = colAmountPartner
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountPartnerEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartnerEDI
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object clGoodsGLNCode: TcxGridDBColumn
              Caption = #1050#1086#1076' GLN'
              DataBinding.FieldName = 'GLNCode'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 40
            end
            object clGoodsName: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088
              DataBinding.FieldName = 'GoodsName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 78
            end
            object clGoodsNameEDI: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088' (EDI)'
              DataBinding.FieldName = 'GoodsNameEDI'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 77
            end
            object clGoodsKind: TcxGridDBColumn
              Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
              DataBinding.FieldName = 'GoodsKindName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clPrice: TcxGridDBColumn
              Caption = #1062#1077#1085#1072
              DataBinding.FieldName = 'Price'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 45
            end
            object colAmountOrder: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072
              DataBinding.FieldName = 'AmountOrder'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object colAmountPartner: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1082'.'
              DataBinding.FieldName = 'AmountPartner'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clAmountPartnerEDI: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' (EDI)'
              DataBinding.FieldName = 'AmountPartnerEDI'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 55
            end
            object clSummPartner: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1076#1086#1082'.'
              DataBinding.FieldName = 'SummPartner'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clSummPartnerEDI: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' (EDI)'
              DataBinding.FieldName = 'SummPartnerEDI'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 55
            end
            object clIsCheck: TcxGridDBColumn
              Caption = #1056#1072#1079#1085#1080#1094#1072
              DataBinding.FieldName = 'isCheck'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 45
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxChildGridDBTableView
          end
        end
        object cxProtocolGrid: TcxGrid
          Left = 786
          Top = 0
          Width = 316
          Height = 155
          Align = alClient
          PopupMenu = PopupMenu
          TabOrder = 1
          object cxProtocolGridView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ProtocolDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.00'
                Kind = skSum
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object colProtocolOperDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072
              DataBinding.FieldName = 'OperDate'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
            object colProtocolText: TcxGridDBColumn
              Caption = #1054#1087#1080#1089#1072#1085#1080#1077
              DataBinding.FieldName = 'ProtocolText'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object colProtocolUserName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
              DataBinding.FieldName = 'UserName'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
          end
          object cxGridProtocolLevel: TcxGridLevel
            GridView = cxProtocolGridView
          end
        end
        object cxVerticalSplitter: TcxSplitter
          Left = 785
          Top = 0
          Width = 1
          Height = 155
          Control = cxChildGrid
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 1102
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 184
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BottomPanel
        Properties.Strings = (
          'Height'
          'Left'
          'Width')
      end
      item
        Component = cxChildGrid
        Properties.Strings = (
          'Height'
          'Width')
      end
      item
        Component = cxGrid
        Properties.Strings = (
          'Height')
      end
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
        Component = Splitter
        Properties.Strings = (
          'Top')
      end>
    Top = 184
  end
  inherited ActionList: TActionList
    Top = 183
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spClient
        end
        item
          StoredProc = spProtocol
        end>
    end
    object actStoredProcTaxCorrectivePrint: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectTaxCorrective_Client
        end>
      Caption = 'actExecPrintStoredProc'
    end
    object maEDIReceiptLoad: TMultiAction
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReceipt
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1079#1072#1103#1074#1082#1072#1084' '#1080#1079' EDI?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1082#1074#1080#1090#1072#1085#1094#1080#1103#1093' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1082#1074#1080#1090#1072#1085#1094#1080#1103#1084' '#1080#1079' EDI'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1082#1074#1080#1090#1072#1085#1094#1080#1103#1084' '#1080#1079' EDI'
    end
    object EDIActionComdocLoad: TEDIAction
      Category = 'EDI Load'
      MoveParams = <>
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EDI = EDI
      EDIDocType = ediComDoc
      spHeader = spHeaderComDoc
      spList = spListComDoc
      Directory = '/inbox'
    end
    object maEDIComDocLoad: TMultiAction
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIActionComdocLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1093' ComDoc '#1080#1079' EDI?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' ComDoc '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' ComDoc '#1080#1079' EDI'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' ComDoc '#1080#1079' EDI'
      ImageIndex = 30
    end
    object mactReturnComdoc: TMultiAction
      Category = 'EDI COMDOC'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end
        item
          Action = actStoredProcTaxCorrectivePrint
        end
        item
          Action = EDIDeclarReturn
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1074' EDI'
      Caption = 'ReturnCOMDOC'
    end
    object maEDIOrdersLoad: TMultiAction
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIActionOrdersLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1079#1072#1103#1074#1082#1072#1084' '#1080#1079' EDI?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1079#1072#1103#1074#1082#1072#1084' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1079#1072#1103#1074#1082#1072#1084' '#1080#1079' EDI'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1079#1072#1103#1074#1082#1072#1084' '#1080#1079' EDI'
      ImageIndex = 27
    end
    object EDIActionOrdersLoad: TEDIAction
      Category = 'EDI Load'
      MoveParams = <>
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EDI = EDI
      EDIDocType = ediOrder
      spHeader = spHeaderOrder
      spList = spListOrder
      Directory = '/inbox'
    end
    object actStoredProcTaxPrint: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = 'actExecPrintStoredProc'
    end
    object actSetDefaults: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGetDefaultEDI
      StoredProcList = <
        item
          StoredProc = spGetDefaultEDI
        end>
      Caption = 'actSetDefaults'
    end
    object actOpenSaleForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenSaleForm'
      FormName = 'TSale_PartnerForm'
      FormNameParam.Value = 'TSale_PartnerForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'MovementId_Sale'
        end
        item
          Name = 'ShowAll'
          Value = 'false'
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Component = MasterCDS
          ComponentItem = 'OperDatePartner_Sale'
          DataType = ftDateTime
        end>
      isShowModal = False
    end
    object actUpdate_EDIComdoc_Params: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_EDIComdoc_Params
      StoredProcList = <
        item
          StoredProc = spUpdate_EDIComdoc_Params
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084
      ImageIndex = 41
      InfoAfterExecute = #1057#1074#1103#1079#1100' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1072
    end
    object actUpdateMI_EDIComdoc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate_SaleLinkEDI
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_SaleLinkEDI
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' ComDoc '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' ComDoc '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 42
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' ComDoc '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085' '#1087#1077#1088#1077#1085#1086#1089' '#1076#1072#1085#1085#1099#1093' '#1080#1079' ComDoc '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
    end
    object mactCOMDOC: TMultiAction
      Category = 'EDI COMDOC'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1074' EDI'
      Caption = 'EDI '#1056#1072#1089#1093#1086#1076
    end
    object mactDECLAR: TMultiAction
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = actStoredProcTaxPrint
        end
        item
          Action = EDIDeclar
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1074' EDI'
      Caption = 'EDI '#1053#1072#1083#1086#1075#1086#1074#1072#1103
    end
    object EDIDeclar: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediDeclar
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actExecPrintStoredProc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = 'actExecPrintStoredProc'
    end
    object EDIReceipt: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediReceipt
      spHeader = spInsert_Protocol_EDIReceipt
      Directory = '/inbox'
    end
    object EDIReturnComDoc: TEDIAction
      Category = 'EDI COMDOC'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediReturnComDoc
      spHeader = spGetFileName
      spList = spGetFileBlob
      HeaderDataSet = MasterCDS
      Directory = '/outbox'
    end
    object EDIDeclarReturn: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediDeclarReturn
      HeaderDataSet = PrintHeaderCDS
      Directory = '/outbox'
    end
    object mactSendComdoc: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end>
      View = cxGridDBTableView
      Caption = 'mactSendComdoc'
    end
    object mactSendComdocAndRefresh: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = mactSendComdoc
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074' EDI?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = 'EDI '#1056#1072#1089#1093#1086#1076
    end
    object mactSendDeclar: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIDeclar
        end>
      View = cxGridDBTableView
      Caption = 'EDI '#1053#1072#1083#1086#1075#1086#1074#1072#1103
    end
    object mactSendDeclarAndRefresh: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = mactSendDeclar
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074' EDI?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = 'EDI '#1053#1072#1083#1086#1075#1086#1074#1072#1103
    end
    object mactSendReturn: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end
        item
          Action = actStoredProcTaxCorrectivePrint
        end
        item
          Action = EDIDeclarReturn
        end>
      View = cxGridDBTableView
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = 'mactSendReturn'
    end
    object mactSendReturnAndRefresh: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = mactSendReturn
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074' EDI?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = 'EDI '#1042#1086#1079#1074#1088#1072#1090
      Hint = 'EDI '#1042#1086#1079#1074#1088#1072#1090
    end
  end
  inherited MasterDS: TDataSource
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    Top = 56
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDI'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Top = 56
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 56
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
          ItemName = 'bbLoadOrder'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadComDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReceipt'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_EDIComdoc_Params'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_SaleLinkEDI'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bb_mactComDoc'
        end
        item
          Visible = True
          ItemName = 'bbDeclar'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReturnCOMDOC'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbLoadComDoc: TdxBarButton
      Action = maEDIComDocLoad
      Category = 0
    end
    object bbLoadOrder: TdxBarButton
      Action = maEDIOrdersLoad
      Category = 0
    end
    object bbGotoSale: TdxBarButton
      Action = actOpenSaleForm
      Category = 0
    end
    object bbUpdate_EDIComdoc_Params: TdxBarButton
      Action = actUpdate_EDIComdoc_Params
      Category = 0
    end
    object bbInsertUpdate_SaleLinkEDI: TdxBarButton
      Action = actUpdateMI_EDIComdoc
      Category = 0
    end
    object bb_mactComDoc: TdxBarButton
      Action = mactCOMDOC
      Category = 0
    end
    object bbDeclar: TdxBarButton
      Action = mactDECLAR
      Category = 0
    end
    object bbReceipt: TdxBarButton
      Action = maEDIReceiptLoad
      Category = 0
    end
    object bbReturnCOMDOC: TdxBarButton
      Action = mactReturnComdoc
      Caption = 'EDI '#1042#1086#1079#1074#1088#1072#1090
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 448
    Top = 120
  end
  inherited PopupMenu: TPopupMenu
    Top = 184
    object EDI4: TMenuItem [0]
      Action = mactSendComdocAndRefresh
    end
    object EDI5: TMenuItem [1]
      Action = mactSendDeclarAndRefresh
    end
    object mactSendReturnAndRefresh1: TMenuItem [2]
      Action = mactSendReturnAndRefresh
    end
    object N4: TMenuItem [3]
      Caption = '-'
    end
    object N5: TMenuItem [4]
      Action = actUpdate_EDIComdoc_Params
    end
    object ComDoc1: TMenuItem [5]
      Action = actUpdateMI_EDIComdoc
    end
    object N3: TMenuItem [6]
      Caption = '-'
    end
    object EDI1: TMenuItem [7]
      Action = maEDIOrdersLoad
    end
    object EDI2: TMenuItem [8]
      Action = maEDIComDocLoad
    end
    object EDI3: TMenuItem [9]
      Action = maEDIReceiptLoad
    end
    object N2: TMenuItem [10]
      Caption = '-'
    end
  end
  object spHeaderOrder: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EDIOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrderOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inGLN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNPlace'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MovementId'
        Value = Null
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
      end>
    PackSize = 1
    Left = 168
    Top = 120
  end
  object spListOrder: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_EDIOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAmountOrder'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 168
    Top = 168
  end
  object spClient: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_EDI'
    DataSet = ClientCDS
    DataSets = <
      item
        DataSet = ClientCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 96
    Top = 312
  end
  object ClientDS: TDataSource
    DataSet = ClientCDS
    Left = 64
    Top = 312
  end
  object ClientCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 32
    Top = 312
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 320
    Top = 72
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 328
    Top = 152
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.Component = FormParams
    ConnectionParams.Host.ComponentItem = 'Host'
    ConnectionParams.Host.DataType = ftString
    ConnectionParams.User.Value = Null
    ConnectionParams.User.Component = FormParams
    ConnectionParams.User.ComponentItem = 'UserName'
    ConnectionParams.User.DataType = ftString
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.Component = FormParams
    ConnectionParams.Password.ComponentItem = 'Password'
    ConnectionParams.Password.DataType = ftString
    Left = 416
    Top = 56
  end
  object spHeaderComDoc: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EDIComdoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrderOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPartnerInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPartnerOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDateTax'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberSaleLink'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDateSaleLink'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOKPO'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDesc'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MovementId'
        Value = Null
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
      end>
    PackSize = 1
    Left = 240
    Top = 144
  end
  object spListComDoc: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_EDIComDoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAmountPartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPricePartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inSummPartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 192
    Top = 160
  end
  object DBChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxChildGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 168
    Top = 344
  end
  object ProtocolCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 880
    Top = 296
  end
  object ProtocolDS: TDataSource
    DataSet = ProtocolCDS
    Left = 808
    Top = 296
  end
  object spProtocol: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDIProtocol'
    DataSet = ProtocolCDS
    DataSets = <
      item
        DataSet = ProtocolCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 840
    Top = 304
  end
  object DBProtocolViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxProtocolGridView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 808
    Top = 328
  end
  object spGetDefaultEDI: TdsdStoredProc
    StoredProcName = 'gpGetDefaultEDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
      end>
    PackSize = 1
    Left = 464
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Host'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'Password'
        Value = Null
        DataType = ftString
      end>
    Left = 520
    Top = 48
  end
  object spInsertUpdate_SaleLinkEDI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SaleLinkEDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId_EDI'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId'
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 680
    Top = 144
  end
  object spUpdate_EDIComdoc_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_EDIComdoc_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 712
    Top = 152
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
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
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 679
    Top = 16
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 724
    Top = 17
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 732
    Top = 62
  end
  object spSelectTax_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
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
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
      end
      item
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 679
    Top = 72
  end
  object spInsert_Protocol_EDIReceipt: TdsdStoredProc
    StoredProcName = 'gpInsert_Protocol_EDIReceipt'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inisOk'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inTaxNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inEDIEvent'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperMonth'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFileName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 256
    Top = 64
  end
  object spGetFileBlob: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ComDoc'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 392
    Top = 192
  end
  object spGetFileName: TdsdStoredProc
    StoredProcName = 'gpGet_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'outFileName'
        Value = Null
        DataType = ftString
      end>
    PackSize = 1
    Left = 400
    Top = 240
  end
  object spSelectTaxCorrective_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
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
        Component = MasterCDS
        ComponentItem = 'MovementId_TaxCorrective'
        ParamType = ptInput
      end
      item
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 679
    Top = 112
  end
end
