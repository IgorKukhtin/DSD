inherited TransportForm: TTransportForm
  Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
  ClientHeight = 489
  ClientWidth = 996
  KeyPreview = True
  PopupMenu = PopupMenu
  ExplicitWidth = 1012
  ExplicitHeight = 524
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 996
    Height = 84
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 20
      Enabled = False
      TabOrder = 0
      Width = 101
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 4
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 8
      Top = 56
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 101
    end
    object cxLabel2: TcxLabel
      Left = 8
      Top = 40
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edUnitForwarding: TcxButtonEdit
      Left = 812
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 12
      Width = 182
    end
    object edCar: TcxButtonEdit
      Left = 121
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Width = 145
    end
    object cxLabel3: TcxLabel
      Left = 812
      Top = 4
      Caption = #1052#1077#1089#1090#1086' '#1086#1090#1087#1088#1072#1074#1082#1080
    end
    object cxLabel4: TcxLabel
      Left = 121
      Top = 4
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' '
    end
    object edPersonalDriver: TcxButtonEdit
      Left = 121
      Top = 56
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 145
    end
    object cxLabel5: TcxLabel
      Left = 121
      Top = 40
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100
    end
    object edPersonalDriverMore: TcxButtonEdit
      Left = 659
      Top = 56
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 11
      Width = 145
    end
    object cxLabel6: TcxLabel
      Left = 659
      Top = 40
      Caption = #1042#1086#1076#1080#1090#1077#1083#1100', '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081
    end
    object edCarTrailer: TcxButtonEdit
      Left = 659
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Width = 145
    end
    object cxLabel7: TcxLabel
      Left = 659
      Top = 4
      Caption = #1055#1088#1080#1094#1077#1087
    end
    object edStartRunPlan: TcxDateEdit
      Left = 275
      Top = 20
      Properties.DateButtons = [btnClear, btnToday]
      Properties.InputKind = ikMask
      Properties.Kind = ckDateTime
      TabOrder = 4
      Width = 145
    end
    object cxLabel8: TcxLabel
      Left = 275
      Top = 4
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085' '
    end
    object edEndRunPlan: TcxDateEdit
      Left = 275
      Top = 56
      Properties.Kind = ckDateTime
      TabOrder = 5
      Width = 145
    end
    object cxLabel9: TcxLabel
      Left = 275
      Top = 40
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1087#1083#1072#1085
    end
    object cxLabel10: TcxLabel
      Left = 426
      Top = 4
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1099#1077#1079#1076#1072' '#1092#1072#1082#1090
    end
    object edStartRun: TcxDateEdit
      Left = 426
      Top = 20
      Properties.InputKind = ikMask
      Properties.Kind = ckDateTime
      TabOrder = 6
      Width = 147
    end
    object cxLabel11: TcxLabel
      Left = 426
      Top = 40
      Caption = #1044#1072#1090#1072'/'#1042#1088'.'#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103' '#1092#1072#1082#1090
    end
    object edEndRun: TcxDateEdit
      Left = 426
      Top = 56
      Properties.Kind = ckDateTime
      TabOrder = 7
      Width = 147
    end
    object edComment: TcxTextEdit
      Left = 812
      Top = 56
      TabOrder = 13
      Width = 182
    end
    object cxLabel12: TcxLabel
      Left = 812
      Top = 40
      Caption = ' '#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '
    end
    object edHoursWork: TcxCurrencyEdit
      Left = 580
      Top = 20
      Enabled = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 8
      Width = 71
    end
    object cxLabel13: TcxLabel
      Left = 580
      Top = 4
      Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074
    end
    object edHoursAdd: TcxCurrencyEdit
      Left = 580
      Top = 56
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 9
      Width = 71
    end
    object cxLabel14: TcxLabel
      Left = 580
      Top = 40
      Caption = #1044#1086#1087'. '#1095#1072#1089#1099
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 110
    Width = 996
    Height = 379
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetIncome
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 379
    ClientRectRight = 996
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 996
        Height = 210
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colWeight
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colAmount
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colEndOdometre
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
              Column = colWeight
            end
            item
              Kind = skSum
              Column = colAmount
            end
            item
              Kind = skSum
              Column = colEndOdometre
            end
            item
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colRouteCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'RouteCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colRouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = RouteChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 125
          end
          object colAmount: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 136
          end
          object colStartOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1085#1072#1095#1072#1083#1100#1085#1086#1077' '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'StartOdometre'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 176
          end
          object colEndOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1082#1086#1085#1077#1095#1085#1086#1077' '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'EndOdometre'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 175
          end
          object colWeight: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1075#1088#1091#1079#1072', '#1082#1075
            DataBinding.FieldName = 'Weight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object colFreightName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1091#1079#1072
            DataBinding.FieldName = 'FreightName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = FreightChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object colRouteKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1084#1072#1088#1096#1088#1091#1090#1072
            DataBinding.FieldName = 'RouteKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
      object cxGridChild: TcxGrid
        Left = 0
        Top = 215
        Width = 996
        Height = 140
        Align = alBottom
        TabOrder = 1
        object cxGridChildDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
              Column = colсhAmount
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
              Column = colсhAmount
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colchNumber: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Number'
            HeaderAlignmentVert = vaCenter
            Width = 36
          end
          object colсhFuelCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'FuelCode'
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colсhFuelName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
            DataBinding.FieldName = 'FuelName'
            HeaderAlignmentVert = vaCenter
            Width = 166
          end
          object colсhCalculated: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1087#1086' '#1088#1072#1089#1095'. ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'Calculated'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 64
          end
          object colсhAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' '#1092#1072#1082#1090#1091' '
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colсhAmount_calc: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'Amount_calc'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object colсhColdHour: TcxGridDBColumn
            Caption = #1061#1086#1083#1086#1076', '#1092#1072#1082#1090' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'ColdHour'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colсhColdDistance: TcxGridDBColumn
            Caption = #1061#1086#1083#1086#1076', '#1092#1072#1082#1090' '#1082#1084
            DataBinding.FieldName = 'ColdDistance'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colсhAmountColdHour: TcxGridDBColumn
            Caption = #1061#1086#1083#1086#1076', '#1085#1086#1088#1084#1072' '#1074' '#1095#1072#1089
            DataBinding.FieldName = 'AmountColdHour'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 64
          end
          object colсhAmountColdDistance: TcxGridDBColumn
            Caption = #1061#1086#1083#1086#1076', '#1085#1086#1088#1084#1072' '#1085#1072' 100 '#1082#1084
            DataBinding.FieldName = 'AmountColdDistance'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object colсhAmountFuel: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076', '#1085#1086#1088#1084#1072' '#1085#1072' 100 '#1082#1084
            DataBinding.FieldName = 'AmountFuel'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colсhRateFuelKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1085#1086#1088#1084#1099
            DataBinding.FieldName = 'RateFuelKindName'
            HeaderAlignmentVert = vaCenter
            Width = 91
          end
          object colchRateFuelKindTax: TcxGridDBColumn
            Caption = '% '#1089#1077#1079#1086#1085', '#1090#1077#1084#1087'.'
            DataBinding.FieldName = 'RateFuelKindTax'
            Width = 59
          end
        end
        object cxGridChildLevel: TcxGridLevel
          GridView = cxGridChildDBTableView
        end
      end
      object cxSplitterChild: TcxSplitter
        Left = 0
        Top = 210
        Width = 996
        Height = 5
        AlignSplitter = salBottom
        Control = cxGridChild
      end
    end
    object cxTabSheetIncome: TcxTabSheet
      Caption = #1055#1088#1080#1093#1086#1076#1099
      ImageIndex = 2
      object cxGridIncome: TcxGrid
        Left = 0
        Top = 0
        Width = 996
        Height = 355
        Align = alClient
        TabOrder = 0
        object cxGridIncomeDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = IncomeDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
              Column = clincPriceWithVAT
            end
            item
              Kind = skSum
              Position = spFooter
              Column = clincOperDate
            end
            item
              Kind = skSum
              Position = spFooter
              Column = clincPaidKindName
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
              Column = clincPriceWithVAT
            end
            item
              Kind = skSum
              Column = clincOperDate
            end
            item
              Kind = skSum
              Column = clincPaidKindName
            end
            item
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clincStatusCode: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = RouteChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clincInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clincOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clincFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086' ('#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clincPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clincGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clincGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clincFuelName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
            DataBinding.FieldName = 'FuelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clincAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clincPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clincAmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clincAmountSummTotal: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'AmountSummTotal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clincPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clincVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = FreightChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object clincCountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
        end
        object cxGridIncomeLevel: TcxGridLevel
          GridView = cxGridIncomeDBTableView
        end
      end
    end
    object cxTabSheetEntry: TcxTabSheet
      Caption = #1055#1088#1086#1074#1086#1076#1082#1080
      ImageIndex = 1
      object cxGridEntry: TcxGrid
        Left = 0
        Top = 0
        Width = 996
        Height = 355
        Align = alClient
        TabOrder = 0
        object cxGridEntryDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = EntryDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKreditAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebetAmount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          object colDebetAccountGroupCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1043#1088#1091#1087#1087#1072' '#1082#1086#1076
            DataBinding.FieldName = 'DebetAccountGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colDebetAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'DebetAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colDebetAccountDirectionCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1053#1072#1087#1088#1072#1074#1083' '#1082#1086#1076
            DataBinding.FieldName = 'DebetAccountDirectionCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colDebetAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'DebetAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colDebetAccountCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1082#1086#1076
            DataBinding.FieldName = 'DebetAccountCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colDebetAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044
            DataBinding.FieldName = 'DebetAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object colKreditAccountGroupCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1043#1088#1091#1087#1087#1072' '#1082#1086#1076
            DataBinding.FieldName = 'KreditAccountGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colKreditAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'KreditAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colKreditAccountDirectionCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1053#1072#1087#1088#1072#1074#1083' '#1082#1086#1076
            DataBinding.FieldName = 'KreditAccountDirectionCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colKreditAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'KreditAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colKreditAccountCode: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1082#1086#1076
            DataBinding.FieldName = 'KreditAccountCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colKreditAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050
            DataBinding.FieldName = 'KreditAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object colByObjectCode: TcxGridDBColumn
            Caption = #1054#1073'.'#1082#1086#1076
            DataBinding.FieldName = 'ByObjectCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colByObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ByObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colGoodsKindName_comlete: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colAccountOnComplete: TcxGridDBColumn
            Caption = '***'
            DataBinding.FieldName = 'AccountOnComplete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 25
          end
          object colDebetAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetAmount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colKreditAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditAmount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090'. '#1085#1072#1079#1085#1072#1095'.'
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colInfoMoneyCode_Detail: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090'. '#1085#1072#1079#1085#1072#1095'.'#1076#1077#1090'.'
            DataBinding.FieldName = 'InfoMoneyCode_Detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object colInfoMoneyName_Detail: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' '#1076#1077#1090#1072#1083#1100#1085#1086
            DataBinding.FieldName = 'InfoMoneyName_Detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
        object cxGridEntryLevel: TcxGridLevel
          GridView = cxGridEntryDBTableView
        end
      end
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 208
    Top = 336
  end
  object spSelectMovementItem: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Transport'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inShowAll'
        Component = BooleanStoredProcAction
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'inIsErased'
        Component = ShowErasedAction
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end>
    Left = 105
    Top = 226
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Height')
      end
      item
        Component = cxGridChild
        Properties.Strings = (
          'Height')
      end
      item
        Component = cxSplitterChild
        Properties.Strings = (
          'Top')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 80
    Top = 182
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 53
    Top = 182
    object BooleanStoredProcAction: TBooleanStoredProcAction
      Category = 'DSDLib'
      StoredProc = spSelectMovementItem
      StoredProcList = <
        item
          StoredProc = spSelectMovementItem
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object ShowErasedAction: TBooleanStoredProcAction
      Category = 'DSDLib'
      StoredProc = spSelectMovementItem
      StoredProcList = <
        item
          StoredProc = spSelectMovementItem
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMovementItem
        end
        item
          StoredProc = spSelectMIContainer
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      Params = <>
      ReportName = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelectMovementItem
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actUpdateIncomeDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateIncome
      StoredProcList = <
        item
          StoredProc = spInsertUpdateIncome
        end>
      Caption = 'actUpdateIncomeDS'
      DataSource = IncomeDS
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      View = cxGridDBTableView
      Action = RouteChoiceForm
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1052#1072#1088#1096#1088#1091#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1052#1072#1088#1096#1088#1091#1090
      ShortCut = 45
      ImageIndex = 0
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      StoredProcList = <>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1052#1072#1088#1096#1088#1091#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1052#1072#1088#1096#1088#1091#1090
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object SetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      StoredProcList = <>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1052#1072#1088#1096#1088#1091#1090
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1052#1072#1088#1096#1088#1091#1090
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object RouteChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      FormName = 'TRouteForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'RouteId'
          DataType = ftInteger
          ParamType = ptOutput
        end
        item
          Name = 'Code'
          Component = MasterCDS
          ComponentItem = 'RouteCode'
          DataType = ftInteger
          ParamType = ptOutput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          ParamType = ptOutput
        end
        item
          Name = 'RouteKindId'
          Component = MasterCDS
          ComponentItem = 'RouteKindId'
          DataType = ftInteger
          ParamType = ptOutput
        end
        item
          Name = 'RouteKindName'
          Component = MasterCDS
          ComponentItem = 'RouteKindName'
          DataType = ftString
          ParamType = ptOutput
        end
        item
          Name = 'FreightId'
          Component = MasterCDS
          ComponentItem = 'FreightId'
          DataType = ftInteger
          ParamType = ptOutput
        end
        item
          Name = 'FreightName'
          Component = MasterCDS
          ComponentItem = 'FreightName'
          DataType = ftString
          ParamType = ptOutput
        end>
      isShowModal = True
    end
    object FreightChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'FreightChoiceForm'
      FormName = 'TFreightForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'FreightId'
          DataType = ftInteger
          ParamType = ptOutput
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'FreightName'
          DataType = ftInteger
          ParamType = ptOutput
        end>
      isShowModal = True
    end
    object InsertRecordIncome: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetIncome
      View = cxGridIncomeDBTableView
      Action = IncomeChoiceForm
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086
      ShortCut = 45
      ImageIndex = 0
    end
    object IncomeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      FormName = 'TPartnerForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = IncomeCDS
          ComponentItem = 'FromId'
          DataType = ftInteger
          ParamType = ptOutput
        end
        item
          Name = 'Code'
          Component = IncomeCDS
          ComponentItem = 'FromCode'
          DataType = ftInteger
          ParamType = ptOutput
        end
        item
          Name = 'TextValue'
          Component = IncomeCDS
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptOutput
        end>
      isShowModal = True
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 45
    Top = 226
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 226
  end
  object GuidesCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'DriverId'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'DriverName'
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end>
    Left = 218
    Top = 19
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Transport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'InvNumber'
        Component = edInvNumber
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'OperDate'
        Component = edOperDate
        DataType = ftInteger
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'CarId'
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'CarName'
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'CarTrailerId'
        Component = GuidesCarTrailer
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'CarTrailerName'
        Component = GuidesCarTrailer
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverId'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverName'
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverMoreId'
        Component = GuidesPersonalDriverMore
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PersonalDriverMoreName'
        Component = GuidesPersonalDriverMore
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitForwardingId'
        Component = GuidesUnitForwarding
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitForwardingName'
        Component = GuidesUnitForwarding
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'StartRunPlan'
        Component = edStartRunPlan
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'EndRunPlan'
        Component = edEndRunPlan
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'StartRun'
        Component = edStartRun
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'EndRun'
        Component = edEndRun
        DataType = ftDateTime
        ParamType = ptOutput
        Value = 0d
      end
      item
        Name = 'HoursWork'
        Component = edHoursWork
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'HoursAdd'
        Component = edHoursAdd
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'Comment'
        Component = edComment
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end>
    Left = 223
    Top = 182
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 206
    Top = 286
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spSelectMIContainer: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemContainer_Movement'
    DataSet = EntryCDS
    DataSets = <
      item
        DataSet = EntryCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 106
    Top = 357
  end
  object EntryCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 17
    Top = 357
  end
  object EntryDS: TDataSource
    DataSet = EntryCDS
    Left = 46
    Top = 357
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Transport_Master'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inRouteId'
        Component = MasterCDS
        ComponentItem = 'RouteId'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inWeight'
        Component = MasterCDS
        ComponentItem = 'Weight'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inStartOdometre'
        Component = MasterCDS
        ComponentItem = 'StartOdometre'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inEndOdometre'
        Component = MasterCDS
        ComponentItem = 'EndOdometre'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFreightId'
        Component = MasterCDS
        ComponentItem = 'FreightId'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'inRouteKindId'
        Component = MasterCDS
        ComponentItem = 'RouteKindId'
        DataType = ftInteger
        ParamType = ptInput
      end>
    Left = 75
    Top = 226
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = MasterCDS
    BCDToCurrency = False
    Left = 134
    Top = 226
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 16
    Top = 270
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 44
    Top = 270
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Transport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end
      item
        Name = 'inInvNumber'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inOperDate'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inStartRunPlan'
        Component = edStartRunPlan
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inEndRunPlan'
        Component = edEndRunPlan
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inStartRun'
        Component = edStartRun
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inEndRun'
        Component = edEndRun
        DataType = ftDateTime
        ParamType = ptInput
        Value = 0d
      end
      item
        Name = 'inHoursAdd'
        Component = edHoursAdd
        DataType = ftFloat
        ParamType = ptInput
        Value = 0.000000000000000000
      end
      item
        Name = 'outHoursWork'
        Component = edHoursWork
        DataType = ftFloat
        ParamType = ptOutput
        Value = 0.000000000000000000
      end
      item
        Name = 'inComment'
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inCarId'
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inCarTrailerId'
        Component = GuidesCarTrailer
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPersonalDriverId'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inPersonalDriverMoreId'
        Component = GuidesPersonalDriverMore
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inUnitForwardingId'
        Component = GuidesUnitForwarding
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 347
    Top = 224
  end
  object GuidesCarTrailer: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCarTrailer
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesCarTrailer
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesCarTrailer
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 754
    Top = 19
  end
  object GuidesPersonalDriver: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalDriver
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 178
    Top = 35
  end
  object GuidesPersonalDriverMore: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalDriverMore
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesPersonalDriverMore
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesPersonalDriverMore
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 698
    Top = 35
  end
  object GuidesUnitForwarding: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitForwarding
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GuidesUnitForwarding
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GuidesUnitForwarding
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 938
    Top = 19
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Transport_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ChildCDS
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inParentId'
        Component = ChildCDS
        ComponentItem = 'ParentId'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'inFuelId'
        Component = ChildCDS
        ComponentItem = 'FuelId'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'inCalculated'
        Component = ChildCDS
        ComponentItem = 'Calculated'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'ioAmount'
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'outAmount_calc'
        Component = ChildCDS
        ComponentItem = 'Amount_calc'
        DataType = ftFloat
        ParamType = ptOutput
      end
      item
        Name = 'inColdHour'
        Component = ChildCDS
        ComponentItem = 'ColdHour'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inColdDistance'
        Component = ChildCDS
        ComponentItem = 'ColdDistance'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountColdHour'
        Component = ChildCDS
        ComponentItem = 'AmountColdHour'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountColdDistance'
        Component = ChildCDS
        ComponentItem = 'AmountColdDistance'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountFuel'
        Component = ChildCDS
        ComponentItem = 'AmountFuel'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inNumber'
        Component = ChildCDS
        ComponentItem = 'Number'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inRateFuelKindTax'
        Component = ChildCDS
        ComponentItem = 'RateFuelKindTax'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inRateFuelKindId'
        Component = ChildCDS
        ComponentItem = 'RateFuelKindId'
        DataType = ftInteger
        ParamType = ptInput
      end>
    Left = 74
    Top = 269
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.DataType = ftInteger
    IdParam.ParamType = ptOutput
    IdParam.Value = '0'
    GuidesList = <
      item
        Guides = GuidesCar
      end
      item
        Guides = GuidesPersonalDriver
      end
      item
        Guides = GuidesUnitForwarding
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 256
    Top = 196
  end
  object HeaderSaver: THeaderSaver
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.DataType = ftInteger
    IdParam.ParamType = ptOutput
    IdParam.Value = '0'
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edCar
      end
      item
        Control = edPersonalDriver
      end
      item
        Control = edStartRun
      end
      item
        Control = edStartRunPlan
      end
      item
        Control = edEndRun
      end
      item
        Control = edEndRunPlan
      end
      item
        Control = edHoursAdd
      end
      item
        Control = edCarTrailer
      end
      item
        Control = edPersonalDriverMore
      end
      item
        Control = edUnitForwarding
      end
      item
        Control = edComment
      end>
    Left = 299
    Top = 211
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 25
    Top = 182
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbBooleanAction'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddRoute'
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
          ItemName = 'bbAddIncome'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbEntryToGrid'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbBooleanAction: TdxBarButton
      Action = BooleanStoredProcAction
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bbEntryToGrid: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbAddRoute: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = SetUnErased
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = ShowErasedAction
      Category = 0
    end
    object bbAddIncome: TdxBarButton
      Action = InsertRecordIncome
      Category = 0
    end
  end
  object RefreshAddOn: TRefreshAddOn
    FormName = 'TransportJournalForm'
    DataSet = 'ClientDataSet'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 392
    Top = 288
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 111
    Top = 182
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = RouteChoiceForm
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    Left = 333
    Top = 304
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridChildDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    Left = 264
    Top = 320
  end
  object IncomeCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 314
  end
  object IncomeDS: TDataSource
    DataSet = IncomeCDS
    Left = 45
    Top = 314
  end
  object spSelectIncome: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportIncome'
    DataSet = IncomeCDS
    DataSets = <
      item
        DataSet = IncomeCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inShowAll'
        Component = BooleanStoredProcAction
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end
      item
        Name = 'inIsErased'
        Component = ShowErasedAction
        DataType = ftBoolean
        ParamType = ptInput
        Value = False
      end>
    Left = 106
    Top = 314
  end
  object spInsertUpdateIncome: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransportIncome'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inParentId'
        Component = FormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'ioMovementId'
        Component = IncomeCDS
        ComponentItem = 'MovementId'
        DataType = ftInteger
        ParamType = ptInputOutput
      end
      item
        Name = 'outInvNumber'
        Component = IncomeCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptOutput
      end
      item
        Name = 'inOperDate'
        Component = IncomeCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ioPriceWithVAT'
        Component = IncomeCDS
        ComponentItem = 'PriceWithVAT'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ioVATPercent'
        Component = IncomeCDS
        ComponentItem = 'VATPercent'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Component = IncomeCDS
        ComponentItem = 'FromId'
        DataType = ftInteger
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'ioPaidKindId'
        Component = IncomeCDS
        ComponentItem = 'PaidKindId'
        DataType = ftInteger
        ParamType = ptInputOutput
      end
      item
        Name = 'ioContractId'
        Component = IncomeCDS
        ComponentItem = 'ContractId'
        DataType = ftInteger
        ParamType = ptInputOutput
      end
      item
        Name = 'ioRouteId'
        Component = IncomeCDS
        ComponentItem = 'ioRouteId'
        DataType = ftInteger
        ParamType = ptInputOutput
      end
      item
        Name = 'inPersonalDriverId'
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 75
    Top = 314
  end
end
