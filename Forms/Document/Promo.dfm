inherited PromoForm: TPromoForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'>'
  ClientHeight = 481
  ClientWidth = 928
  ExplicitWidth = 944
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 141
    Width = 928
    Height = 340
    ExplicitTop = 141
    ExplicitWidth = 928
    ExplicitHeight = 340
    ClientRectBottom = 340
    ClientRectRight = 928
    inherited tsMain: TcxTabSheet
      Caption = '&1. '#1058#1086#1074#1072#1088#1099
      ExplicitWidth = 928
      ExplicitHeight = 316
      inherited cxGrid: TcxGrid
        Width = 928
        Height = 135
        ExplicitWidth = 928
        ExplicitHeight = 135
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object colGoodsName: TcxGridDBColumn [1]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 168
          end
          object colGoodsKindName: TcxGridDBColumn [2]
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = GoodsKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 113
          end
          object colAmount: TcxGridDBColumn [3]
            Caption = '% '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colPrice: TcxGridDBColumn [4]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colPriceWithOutVAT: TcxGridDBColumn [5]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithOutVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 80
          end
          object colPriceWithVAT: TcxGridDBColumn [6]
            Caption = #1089' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 80
          end
          object colAmountReal: TcxGridDBColumn [7]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountReal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1098#1077#1084' '#1087#1088#1086#1076#1072#1078' '#1074' '#1072#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076', '#1082#1075
            Width = 120
          end
          object colAmountPlanMin: TcxGridDBColumn [8]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'.'
            DataBinding.FieldName = 'AmountPlanMin'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1091#1084' '#1087#1083#1072#1085#1080#1088#1091#1077#1084#1086#1075#1086' '#1086#1073#1098#1077#1084#1072' '#1087#1088#1086#1076#1072#1078' '#1085#1072' '#1072#1082#1094#1080#1086#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' ('#1074' '#1082#1075')'
            Width = 70
          end
          object colAmountPlanMax: TcxGridDBColumn [9]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'.'
            DataBinding.FieldName = 'AmountPlanMax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1082#1089#1080#1084#1091#1084' '#1087#1083#1072#1085#1080#1088#1091#1077#1084#1086#1075#1086' '#1086#1073#1098#1077#1084#1072' '#1087#1088#1086#1076#1072#1078' '#1085#1072' '#1072#1082#1094#1080#1086#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' ('#1074' '#1082#1075')'
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 143
        Width = 928
        Height = 173
        Align = alBottom
        TabOrder = 1
        object cxSplitter1: TcxSplitter
          Left = 569
          Top = 1
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer8Style'
          Control = cxPageControl1
        end
        object cxPageControl1: TcxPageControl
          Left = 1
          Top = 1
          Width = 568
          Height = 171
          Align = alLeft
          TabOrder = 1
          Properties.ActivePage = tsPartner
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 568
          ClientRectTop = 24
          object tsPartner: TcxTabSheet
            Caption = '&2. '#1055#1072#1088#1090#1085#1077#1088#1099
            object cxGridPartner: TcxGrid
              Left = 0
              Top = 0
              Width = 568
              Height = 147
              Align = alClient
              PopupMenu = pmPartner
              TabOrder = 0
              object cxGridDBTableViewPartner: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = PartnerDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsCustomize.DataRowSizing = True
                OptionsData.CancelOnExit = False
                OptionsData.Inserting = False
                OptionsView.ColumnAutoWidth = True
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object colp_PartnerCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'PartnerCode'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 49
                end
                object colp_PartnerName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'PartnerName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = PromoPartnerChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 206
                end
                object colp_PartnerDescName: TcxGridDBColumn
                  Caption = #1069#1083#1077#1084#1077#1085#1090
                  DataBinding.FieldName = 'PartnerDescName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 88
                end
                object colp_isErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
                  DataBinding.FieldName = 'isErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 50
                end
                object colJuridical_Name: TcxGridDBColumn
                  Caption = #1070#1088'. '#1083#1080#1094#1086
                  DataBinding.FieldName = 'Juridical_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 109
                end
                object colRetail_Name: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100
                  DataBinding.FieldName = 'Retail_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 102
                end
                object colContractCode: TcxGridDBColumn
                  Caption = #1050#1086#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
                  DataBinding.FieldName = 'ContractCode'
                  Width = 70
                end
                object colContractName: TcxGridDBColumn
                  Caption = #8470' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = ContractChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Width = 70
                end
                object colContractTagName: TcxGridDBColumn
                  Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractTagName'
                  Width = 70
                end
              end
              object cxGridLevelPartner: TcxGridLevel
                GridView = cxGridDBTableViewPartner
              end
            end
          end
        end
        object cxPageControl2: TcxPageControl
          Left = 577
          Top = 1
          Width = 350
          Height = 171
          Align = alClient
          TabOrder = 2
          Properties.ActivePage = tsConditionPromo
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 350
          ClientRectTop = 24
          object tsConditionPromo: TcxTabSheet
            Caption = '&3. '#1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103
            object cxGridConditionPromo: TcxGrid
              Left = 0
              Top = 0
              Width = 350
              Height = 147
              Align = alClient
              PopupMenu = pmCondition
              TabOrder = 0
              object cxGridDBTableViewConditionPromo: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = ConditionPromoDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsCustomize.DataRowSizing = True
                OptionsData.CancelOnExit = False
                OptionsData.Inserting = False
                OptionsView.ColumnAutoWidth = True
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object colcp_Amount: TcxGridDBColumn
                  Caption = #1047#1085#1072#1095#1077#1085#1080#1077
                  DataBinding.FieldName = 'Amount'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 71
                end
                object colcp_ConditionPromoName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'ConditionPromoName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = ConditionPromoChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 289
                end
                object colcp_isErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
                  DataBinding.FieldName = 'isErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 50
                end
              end
              object cxGridLevelConditionPromo: TcxGridLevel
                GridView = cxGridDBTableViewConditionPromo
              end
            end
          end
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 135
        Width = 928
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = Panel1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 928
    Height = 115
    TabOrder = 3
    ExplicitWidth = 928
    ExplicitHeight = 115
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 18
      ExplicitLeft = 8
      ExplicitTop = 18
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 4
      ExplicitLeft = 8
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Top = 18
      ExplicitLeft = 89
      ExplicitTop = 18
      ExplicitWidth = 88
      Width = 88
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      Top = 4
      ExplicitLeft = 89
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Top = 38
      ExplicitTop = 38
    end
    inherited ceStatus: TcxButtonEdit
      Top = 54
      ExplicitTop = 54
      ExplicitWidth = 170
      ExplicitHeight = 22
      Width = 170
    end
    object cxLabel3: TcxLabel
      Left = 579
      Top = 38
      Caption = #1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072
    end
    object edAdvertising: TcxButtonEdit
      Left = 579
      Top = 54
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 202
    end
    object cxLabel4: TcxLabel
      Left = 380
      Top = 4
      Caption = #1042#1080#1076' '#1072#1082#1094#1080#1080
    end
    object edPromoKind: TcxButtonEdit
      Left = 380
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 193
    end
    object cxLabel11: TcxLabel
      Left = 788
      Top = 4
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 788
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 125
    end
    object cxLabel5: TcxLabel
      Left = 195
      Top = 4
      Caption = #1040#1082#1094#1080#1103' '#1089
    end
    object deStartPromo: TcxDateEdit
      Left = 195
      Top = 18
      EditValue = 42132d
      TabOrder = 13
      Width = 81
    end
    object cxLabel6: TcxLabel
      Left = 278
      Top = 4
      Caption = #1040#1082#1094#1080#1103' '#1087#1086
    end
    object deEndPromo: TcxDateEdit
      Left = 278
      Top = 18
      EditValue = 42132d
      TabOrder = 15
      Width = 81
    end
    object cxLabel7: TcxLabel
      Left = 195
      Top = 38
      Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1089
    end
    object deStartSale: TcxDateEdit
      Left = 195
      Top = 54
      EditValue = 42132d
      TabOrder = 17
      Width = 81
    end
    object cxLabel8: TcxLabel
      Left = 278
      Top = 38
      Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086
    end
    object deEndSale: TcxDateEdit
      Left = 278
      Top = 54
      EditValue = 42132d
      TabOrder = 19
      Width = 83
    end
    object cxLabel9: TcxLabel
      Left = 380
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1089
    end
    object deOperDateStart: TcxDateEdit
      Left = 380
      Top = 54
      EditValue = 42132d
      TabOrder = 21
      Width = 87
    end
    object cxLabel10: TcxLabel
      Left = 471
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1086
    end
    object deOperDateEnd: TcxDateEdit
      Left = 471
      Top = 54
      EditValue = 42132d
      TabOrder = 23
      Width = 87
    end
    object edCostPromo: TcxCurrencyEdit
      Left = 788
      Top = 54
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = False
      Properties.UseThousandSeparator = True
      TabOrder = 24
      Width = 125
    end
    object cxLabel12: TcxLabel
      Left = 788
      Top = 38
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103
    end
    object cxLabel13: TcxLabel
      Left = 579
      Top = 75
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 579
      Top = 91
      TabOrder = 27
      Width = 334
    end
    object cxLabel14: TcxLabel
      Left = 8
      Top = 75
      Caption = #1060#1048#1054' ('#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1080#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonalTrade: TcxButtonEdit
      Left = 8
      Top = 91
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 268
    end
    object cxLabel16: TcxLabel
      Left = 278
      Top = 75
      Caption = #1060#1048#1054' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonal: TcxButtonEdit
      Left = 278
      Top = 91
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 295
    end
    object edUnit: TcxButtonEdit
      Left = 579
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 32
      Width = 202
    end
    object cxLabel17: TcxLabel
      Left = 579
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 312
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 312
  end
  inherited ActionList: TActionList
    Top = 311
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Movement_PromoPartner
        end
        item
          StoredProc = spSelect_MovementItem_PromoCondition
        end>
    end
    object InsertRecord: TInsertRecord [2]
      Category = 'Goods'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = GoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 45
      ImageIndex = 0
    end
    inherited actMISetErased: TdsdUpdateErased
      Category = 'Goods'
      TabSheet = tsMain
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1090#1086#1074#1072#1088'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1072#1082#1094#1080#1080'?'
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Category = 'Goods'
      TabSheet = tsMain
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
        end>
    end
    object UpdateConditionDS: TdsdUpdateDataSet [5]
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMICondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMICondition
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = ConditionPromoDS
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Movement_PromoPartner
        end
        item
          StoredProc = spSelect_MovementItem_PromoCondition
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelect_Movement_Promo_Print
      StoredProcList = <
        item
          StoredProc = spSelect_Movement_Promo_Print
        end>
      DataSets = <
        item
          DataSet = PrintHead
          UserName = 'frxHead'
        end>
      ReportName = #1040#1082#1094#1080#1103
      ReportNameParam.Value = #1040#1082#1094#1080#1103
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object InsertRecordPartner: TInsertRecord
      Category = 'Partner'
      TabSheet = tsPartner
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewPartner
      Action = PromoPartnerChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object ErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      TabSheet = tsPartner
      MoveParams = <>
      StoredProc = spErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spErasedMIPartner
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PartnerDS
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1080#1079' '#1072#1082#1094#1080#1080'?'
    end
    object UnErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      TabSheet = tsPartner
      MoveParams = <>
      StoredProc = spUnErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spUnErasedMIPartner
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = PartnerDS
    end
    object PromoPartnerChoiceForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenChoiceForm1'
      FormName = 'TPromoPartnerForm'
      FormNameParam.Value = 'TPromoPartnerForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'DescName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerDescName'
          DataType = ftString
        end
        item
          Name = 'Juridical_Name'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Juridical_Name'
          DataType = ftString
        end
        item
          Name = 'Retail_Name'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Retail_Name'
          DataType = ftString
        end>
      isShowModal = True
    end
    object dsdUpdateDSPartner: TdsdUpdateDataSet
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIPartner
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = PartnerDS
    end
    object InsertCondition: TInsertRecord
      Category = 'Condition'
      TabSheet = tsPartner
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewConditionPromo
      Action = ConditionPromoChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1089#1083#1086#1074#1080#1077' '#1091#1095#1072#1089#1090#1080#1103'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1089#1083#1086#1074#1080#1077' '#1091#1095#1072#1089#1090#1080#1103'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object ErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      TabSheet = tsConditionPromo
      MoveParams = <>
      StoredProc = spErasedMICondition
      StoredProcList = <
        item
          StoredProc = spErasedMICondition
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1059#1089#1083#1086#1074#1080#1077' '#1091#1095#1072#1089#1090#1080#1103'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1059#1089#1083#1086#1074#1080#1077' '#1091#1095#1072#1089#1090#1080#1103'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ConditionPromoDS
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1091#1095#1072#1089#1090#1080#1103' '#1080#1079' '#1072#1082#1094#1080#1080'?'
    end
    object UnErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      TabSheet = tsPartner
      MoveParams = <>
      StoredProc = spUnErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spUnErasedMIPartner
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ConditionPromoDS
    end
    object ConditionPromoChoiceForm: TOpenChoiceForm
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ConditionPromoChoiceForm'
      FormName = 'TConditionPromoForm'
      FormNameParam.Value = 'TConditionPromoForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object ContractChoiceForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
        end
        item
          Name = 'Code'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 272
  end
  inherited MasterCDS: TClientDataSet
    Top = 272
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoGoods'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
      end>
    Top = 272
  end
  inherited BarManager: TdxBarManager
    Top = 271
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
          ItemName = 'dxBarButton1'
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
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
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
          ItemName = 'bbPrint'
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
    inherited bbShowAll: TdxBarButton
      Visible = ivNever
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = InsertRecordPartner
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = ErasedPartner
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = UnErasedPartner
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = InsertCondition
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = UnErasedCondition
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = ErasedCondition
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        DataSummaryItemIndex = 0
      end>
    Left = 62
    Top = 361
  end
  inherited PopupMenu: TPopupMenu
    Left = 152
    Top = 312
    object N2: TMenuItem [0]
      Action = InsertRecord
    end
    object N3: TMenuItem [1]
      Action = actMISetErased
    end
    object N4: TMenuItem [2]
      Action = actMISetUnErased
    end
    object N5: TMenuItem [3]
      Caption = '-'
    end
  end
  inherited FormParams: TdsdFormParams
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 272
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Promo'
    Top = 272
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Promo'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PromoKindId'
        Value = Null
        Component = StatusGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PromoKindName'
        Value = Null
        Component = PromoKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'StartPromo'
        Value = Null
        Component = deStartPromo
        DataType = ftDateTime
      end
      item
        Name = 'EndPromo'
        Value = Null
        Component = deEndPromo
        DataType = ftDateTime
      end
      item
        Name = 'StartSale'
        Value = Null
        Component = deStartSale
        DataType = ftDateTime
      end
      item
        Name = 'EndSale'
        Value = Null
        Component = deEndSale
        DataType = ftDateTime
      end
      item
        Name = 'OperDateStart'
        Value = Null
        Component = deOperDateStart
        DataType = ftDateTime
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = deOperDateEnd
        DataType = ftDateTime
      end
      item
        Name = 'CostPromo'
        Value = Null
        Component = edCostPromo
        DataType = ftFloat
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
      end
      item
        Name = 'AdvertisingId'
        Value = Null
        Component = AdvertisingGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'AdvertisingName'
        Value = Null
        Component = AdvertisingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalTradeId'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalTradeName'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
      end
      item
        Name = 'PersonalName'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'TextValue'
      end>
    Left = 320
    Top = 264
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Promo'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPromoKindId'
        Value = Null
        Component = PromoKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inStartPromo'
        Value = Null
        Component = deStartPromo
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndPromo'
        Value = Null
        Component = deEndPromo
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inStartSale'
        Value = Null
        Component = deStartSale
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndSale'
        Value = Null
        Component = deEndSale
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDateStart'
        Value = Null
        Component = deOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = deOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inCostPromo'
        Value = Null
        Component = edCostPromo
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAdvertisingId'
        Value = Null
        Component = AdvertisingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = PersonalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 322
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = AdvertisingGuides
      end
      item
        Guides = PersonalTradeGuides
      end
      item
        Guides = PersonalGuides
      end>
    Left = 216
    Top = 264
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edPromoKind
      end
      item
        Control = edUnit
      end
      item
        Control = edAdvertising
      end
      item
        Control = edPersonalTrade
      end
      item
        Control = edPersonal
      end
      item
        Control = edPriceList
      end>
    Left = 256
    Top = 265
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 16
    Top = 360
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetErased'
    Left = 406
    Top = 232
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetUnErased'
    Left = 454
    Top = 232
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoGoods'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'outPriceWithOutVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithOutVAT'
        DataType = ftFloat
      end
      item
        Name = 'outPriceWithVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithVAT'
        DataType = ftFloat
      end
      item
        Name = 'inAmountReal'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountReal'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountPlanMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMin'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountPlanMax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMax'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end>
    Left = 456
    Top = 280
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 456
    Top = 336
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 876
    Top = 196
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 748
    Top = 48
  end
  object PromoKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromoKind
    FormNameParam.Value = 'TPromoKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPromoKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PromoKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PromoKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 516
    Top = 8
  end
  object AdvertisingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAdvertising
    FormNameParam.Value = 'TAdvertisingForm'
    FormNameParam.DataType = ftString
    FormName = 'TAdvertisingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AdvertisingGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AdvertisingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 44
    Top = 96
  end
  object PersonalTradeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonalForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalTradeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 316
    Top = 96
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonalForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 548
    Top = 96
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 700
  end
  object spSelect_Movement_PromoPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoPartner'
    DataSet = PartnerCDS
    DataSets = <
      item
        DataSet = PartnerCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        ParamType = ptUnknown
      end>
    PackSize = 1
    Left = 544
    Top = 328
  end
  object PartnerCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 120
    Top = 512
  end
  object PartnerDS: TDataSource
    DataSet = PartnerCDS
    Left = 160
    Top = 512
  end
  object spErasedMIPartner: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoPartner_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 510
    Top = 232
  end
  object spUnErasedMIPartner: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoPartner_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 542
    Top = 232
  end
  object spInsertUpdateMIPartner: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 544
    Top = 280
  end
  object dsdDBViewAddOnPartner: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPartner
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        DataSummaryItemIndex = 0
      end>
    Left = 142
    Top = 361
  end
  object ConditionPromoDS: TDataSource
    DataSet = ConditionPromoCDS
    Left = 568
    Top = 504
  end
  object ConditionPromoCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 528
    Top = 504
  end
  object spSelect_MovementItem_PromoCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoCondition'
    DataSet = ConditionPromoCDS
    DataSets = <
      item
        DataSet = ConditionPromoCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
      end>
    PackSize = 1
    Left = 704
    Top = 328
  end
  object spInsertUpdateMICondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inConditionPromoId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'ConditionPromoId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 704
    Top = 280
  end
  object spUnErasedMICondition: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 702
    Top = 232
  end
  object spErasedMICondition: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 702
    Top = 176
  end
  object dsdDBViewAddOnConditionPromo: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewConditionPromo
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        DataSummaryItemIndex = 0
      end>
    Left = 214
    Top = 353
  end
  object pmPartner: TPopupMenu
    Images = dmMain.ImageList
    Left = 208
    Top = 496
    object MenuItem1: TMenuItem
      Action = InsertRecordPartner
    end
    object MenuItem2: TMenuItem
      Action = ErasedPartner
    end
    object MenuItem3: TMenuItem
      Action = UnErasedPartner
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object MenuItem5: TMenuItem
      Action = actRefresh
    end
    object MenuItem6: TMenuItem
      Action = actGridToExcel
    end
  end
  object pmCondition: TPopupMenu
    Images = dmMain.ImageList
    Left = 672
    Top = 488
    object MenuItem7: TMenuItem
      Action = InsertCondition
    end
    object MenuItem8: TMenuItem
      Action = ErasedCondition
    end
    object MenuItem9: TMenuItem
      Action = UnErasedCondition
    end
    object MenuItem10: TMenuItem
      Caption = '-'
    end
    object MenuItem11: TMenuItem
      Action = actRefresh
    end
    object MenuItem12: TMenuItem
      Action = actGridToExcel
    end
  end
  object PrintHead: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 728
    Top = 128
  end
  object spSelect_Movement_Promo_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Promo_Print'
    DataSet = PrintHead
    DataSets = <
      item
        DataSet = PrintHead
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 776
    Top = 128
  end
end
