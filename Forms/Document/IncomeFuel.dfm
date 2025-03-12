object IncomeFuelForm: TIncomeFuelForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')>'
  ClientHeight = 525
  ClientWidth = 1052
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 1052
    Height = 90
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 74
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 177
      Top = 23
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 89
    end
    object cxLabel2: TcxLabel
      Left = 177
      Top = 5
      Caption = #1044#1072#1090#1072' ('#1072#1074#1090#1086')'
    end
    object edFrom: TcxButtonEdit
      Left = 274
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 172
    end
    object edTo: TcxButtonEdit
      Left = 455
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Width = 135
    end
    object cxLabel3: TcxLabel
      Left = 277
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086' ('#1048#1089#1090#1086#1095#1085#1080#1082' '#1079#1072#1087#1088#1072#1074#1082#1080')'
    end
    object cxLabel4: TcxLabel
      Left = 455
      Top = 5
      Caption = #1050#1086#1084#1091' ('#1060#1080#1079'.'#1083'., '#1091#1095#1088#1077#1076'.)'
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 274
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 130
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 406
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 406
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object cxLabel9: TcxLabel
      Left = 738
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object edContract: TcxButtonEdit
      Left = 738
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 130
    end
    object cxLabel10: TcxLabel
      Left = 599
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 599
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 130
    end
    object cxLabel12: TcxLabel
      Left = 738
      Top = 45
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
    end
    object edDriver: TcxButtonEdit
      Left = 738
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 130
    end
    object edRoute: TcxButtonEdit
      Left = 599
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 17
      Width = 130
    end
    object cxLabel5: TcxLabel
      Left = 599
      Top = 45
      Caption = #1052#1072#1088#1096#1088#1091#1090
    end
    object cxLabel6: TcxLabel
      Left = 88
      Top = 5
      Caption = #8470' '#1095#1077#1082#1072
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 88
      Top = 23
      TabOrder = 20
      Width = 84
    end
    object cxLabel8: TcxLabel
      Left = 8
      Top = 45
      Caption = '*'#1057#1090#1072#1090#1091#1089
    end
    object cxLabel11: TcxLabel
      Left = 455
      Top = 45
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077', '#1075#1088#1085' '#1079#1072' 1'#1083'.'
    end
    object edChangePrice: TcxCurrencyEdit
      Left = 458
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = False
      TabOrder = 23
      Width = 135
    end
    object edOperDatePartner: TcxDateEdit
      Left = 177
      Top = 63
      EditValue = 42387d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 24
      Width = 89
    end
    object cxLabel13: TcxLabel
      Left = 177
      Top = 45
      Caption = #1044#1072#1090#1072' '#1079#1072#1087#1088#1072#1074#1082#1080
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 63
      Properties.Buttons = <
        item
          Action = CompleteMovement
          Kind = bkGlyph
        end
        item
          Action = UnCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = DeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 163
    end
    object edChangePriceUser: TcxCheckBox
      Left = 874
      Top = 23
      Caption = #1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 179
    end
  end
  object PageControl: TcxPageControl
    Left = 0
    Top = 116
    Width = 1052
    Height = 409
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 409
    ClientRectRight = 1052
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGridChild: TcxGrid
        Left = 0
        Top = 207
        Width = 1052
        Height = 178
        Align = alBottom
        TabOrder = 0
        object cxGridDBTableViewChild: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount
            end
            item
              Kind = skSum
              Column = OperDate
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Distance_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Distance_calc
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Appending = True
          OptionsData.DeletingConfirmation = False
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object LineNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object DayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
            DataBinding.FieldName = 'DayOfWeekName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object RouteMemberCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'RouteMemberCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object RouteMemberName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074')'
            DataBinding.FieldName = 'RouteMemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 208
          end
          object clStartOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1085#1072#1095'. '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'StartOdometre'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
          end
          object clEndOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1082#1086#1085#1077#1095'. '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'EndOdometre'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0;;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 128
          end
          object Distance_calc: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075' '#1092#1072#1082#1090' '#1082#1084
            DataBinding.FieldName = 'Distance_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object clAmount: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1072#1074#1082#1072', '#1083
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 106
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
        end
        object cxGridLevelChild: TcxGridLevel
          GridView = cxGridDBTableViewChild
        end
      end
      object cxSplitterChild: TcxSplitter
        Left = 0
        Top = 199
        Width = 1052
        Height = 8
        AlignSplitter = salBottom
        Control = cxGridChild
      end
      object cxGrid: TcxGrid
        Left = 0
        Top = 105
        Width = 1052
        Height = 94
        Align = alClient
        TabOrder = 2
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
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
              Column = AmountSumm
            end
            item
              Kind = skSum
              Column = Price
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
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object FuelName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
            DataBinding.FieldName = 'FuelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0;;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1052
        Height = 97
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 3
        object cxGridDBTableViewInfo: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = InfoDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = '+,0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = '+,0.00;-,0.00; ;'
              Kind = skSum
            end
            item
              Format = '+,0.00;-,0.00; ;'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object AmountFuel: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1072#1074#1090#1086
            DataBinding.FieldName = 'AmountFuel'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Reparation: TcxGridDBColumn
            Caption = #1040#1084#1086#1088#1090'. '#1079#1072' 1 '#1082#1084', '#1075#1088#1085'.'
            DataBinding.FieldName = 'Reparation'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object LimitMoney: TcxGridDBColumn
            Caption = #1051#1080#1084#1080#1090', '#1075#1088#1085
            DataBinding.FieldName = 'LimitMoney'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object LimitChange: TcxGridDBColumn
            Caption = #1051#1080#1084#1080#1090' ('#1089#1083#1091#1078'.) '#1075#1088#1085
            DataBinding.FieldName = 'LimitChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object LimitDistance: TcxGridDBColumn
            Caption = #1051#1080#1084#1080#1090', '#1082#1084
            DataBinding.FieldName = 'LimitDistance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object LimitDistanceChange: TcxGridDBColumn
            Caption = #1051#1080#1084#1080#1090' ('#1089#1083#1091#1078'.) '#1082#1084
            DataBinding.FieldName = 'LimitDistanceChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object StartOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1085#1072#1095'. '#1082#1084
            DataBinding.FieldName = 'StartOdometre'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EndOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1082#1086#1085'. '#1082#1084
            DataBinding.FieldName = 'EndOdometre'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DistanceReal: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075' '#1086#1073#1097#1080#1081' '#1082#1084
            DataBinding.FieldName = 'DistanceReal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object FuelCalc: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1083'. ('#1088#1072#1089#1095'. '#1085#1072' '#1087#1088#1086#1073#1077#1075' '#1092'.)'
            DataBinding.FieldName = 'FuelCalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object FuelRealCalc: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1083'. ('#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086')'
            DataBinding.FieldName = 'FuelRealCalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object FuelDiff: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1083'. ('#1086#1089#1090#1072#1090#1086#1082' '#1083#1080#1084'. '#1082#1084'.)'
            DataBinding.FieldName = 'FuelDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object FuelSummDiff: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1086#1089#1090#1072#1090#1086#1082' '#1083#1080#1084'. '#1082#1084'.)'
            DataBinding.FieldName = 'FuelSummDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object SummDiff: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1086#1089#1090#1072#1090#1086#1082' '#1083#1080#1084'. '#1075#1088#1085')'
            DataBinding.FieldName = 'SummDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object SummDiffTotal: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1086#1089#1090#1072#1090#1086#1082' '#1048#1058#1054#1043#1054')'
            DataBinding.FieldName = 'SummDiffTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object SummReparation: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1072#1084#1086#1088#1090#1080#1079#1072#1094#1080#1103')'
            DataBinding.FieldName = 'SummReparation'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object SummPersonal: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085' ('#1047#1055' '#1080#1090#1086#1075')'
            DataBinding.FieldName = 'SummPersonal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevelInfo: TcxGridLevel
          GridView = cxGridDBTableViewInfo
        end
      end
      object cxSplitter2: TcxSplitter
        Left = 0
        Top = 97
        Width = 1052
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salTop
        Control = cxGrid1
      end
    end
    object cxTabSheetSign: TcxTabSheet
      Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 2
      object cxGridSign: TcxGrid
        Left = 0
        Top = 0
        Width = 1052
        Height = 385
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewSign: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = SignDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object sgOrd: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object sgUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object sgOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1076#1077#1081#1089#1090#1074#1080#1103
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object sgIsSign: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1044#1072'/'#1053#1077#1090')'
            DataBinding.FieldName = 'isSign'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1044#1072'/'#1053#1077#1090')'
            Width = 80
          end
          object sclSignInternalName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100
            DataBinding.FieldName = 'SignInternalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = SignInternalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 278
          end
          object sclisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableViewSign
        end
      end
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
        Name = 'inPaidKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 311
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_IncomeFuel'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
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
    PackSize = 1
    Left = 92
    Top = 272
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 99
    Top = 203
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
          ItemName = 'bbMIProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordChild'
        end
        item
          Visible = True
          ItemName = 'bbRouteMember'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignYes'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignNo'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpdateChangePriceUser'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbSignProtocolOpenForm'
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
          ItemName = 'bbMIContainer'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
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
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbInsertRecordChild: TdxBarButton
      Action = InsertRecordChild
      Category = 0
    end
    object bbSetErasedChild: TdxBarButton
      Action = SetErasedChild
      Category = 0
    end
    object bbSetUnErasedChild: TdxBarButton
      Action = SetUnErasedChild
      Category = 0
    end
    object bbMIProtocol: TdxBarButton
      Action = MIProtocolOpenForm
      Category = 0
    end
    object bbMIChildProtocol: TdxBarButton
      Action = MIChildProtocolOpenForm
      Category = 0
    end
    object bbRouteMember: TdxBarButton
      Action = RouteMemberChoiceForm
      Category = 0
    end
    object bbSignProtocolOpenForm: TdxBarButton
      Action = SignProtocolOpenForm
      Category = 0
    end
    object bbInsertUpdateMISignYes: TdxBarButton
      Action = actInsertUpdateMISignYes
      Category = 0
    end
    object bbInsertUpdateMISignNo: TdxBarButton
      Action = actInsertUpdateMISignNo
      Category = 0
    end
    object bbOpdateChangePriceUser: TdxBarButton
      Action = macUpdateChangePriceUserDialog
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
    Left = 65
    Top = 205
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 33
    Top = 203
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
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
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
        end
        item
          StoredProc = spGetInfo
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
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
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_IncomeFuel'
      ReportNameParam.Value = 'PrintMovement_IncomeFuel'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object SetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
    object actMIContainer: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 57
      FormName = 'TMovementItemContainerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object RouteMemberChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      ImageIndex = 1
      FormName = 'TRouteMemberForm'
      FormNameParam.Value = 'TRouteMemberForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'RouteMemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'RouteMemberName'
          DataType = ftWideString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'RouteMemberCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecordChild: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewChild
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      ShortCut = 45
      ImageIndex = 0
    end
    object SetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end
        item
          StoredProc = spGetInfo
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object SetUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end
        item
          StoredProc = spGetInfo
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object actUpdateInfoDs: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = 'actUpdateInfoDS'
      DataSource = InfoDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object MIChildProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1052#1072#1088#1096#1088#1091#1090#1086#1074' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1052#1072#1088#1096#1088#1091#1090#1086#1074' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074')>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'RouteMemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MIProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
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
        end>
      isShowModal = False
    end
    object SignProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetSign
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1080'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = SignCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = SignCDS
          ComponentItem = 'SignInternalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object SignInternalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SignInternalChoiceForm'
      FormName = 'TSignInternalForm'
      FormNameParam.Value = 'TSignInternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = SignCDS
          ComponentItem = 'SignInternalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = SignCDS
          ComponentItem = 'SignInternalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertUpdateMISignNo: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_No
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_No
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 52
    end
    object actInsertUpdateMISignYes: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_Yes
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_Yes
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 58
    end
    object actUpdateChangePriceUser: TdsdDataSetRefresh
      Category = 'Update'
      MoveParams = <>
      StoredProc = spUpdateChangePriceUser
      StoredProcList = <
        item
          StoredProc = spUpdateChangePriceUser
        end>
      Caption = 'actUpdateChangePriceUser'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 43
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdateChangePriceUserDialog: TExecuteDialog
      Category = 'Update'
      MoveParams = <>
      Caption = 'actUpdateChangePriceUserDialog'
      ImageIndex = 43
      FormName = 'TChangePriceUserDialogForm'
      FormNameParam.Value = 'TChangePriceUserDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ChangePrice'
          Value = Null
          Component = edChangePrice
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isChangePriceUser'
          Value = Null
          Component = edChangePriceUser
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateChangePriceUserDialog: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateChangePriceUserDialog
        end
        item
          Action = actUpdateChangePriceUser
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077'>'
      ImageIndex = 43
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 272
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 272
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TSourceFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSourceFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
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
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePrice'
        Value = 0.000000000000000000
        Component = edChangePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 16
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TMember_TrasportChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.ParamType = ptInputOutput
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_TrasportChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
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
      end
      item
        Name = 'AmountFuel'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'AmountFuel'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Reparation'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'Reparation'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitMoney'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'LimitMoney'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitDistance'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'LimitDistance'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 8
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 760
    Top = 87
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_IncomeFuel'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
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
      end>
    PackSize = 1
    Left = 158
    Top = 272
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 2
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 488
    Top = 287
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 724
    Top = 186
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_IncomeMemberFuel'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
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
        Name = 'inChangePrice'
        Value = 0.000000000000000000
        Component = edChangePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountFuel'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'AmountFuel'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReparation'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'Reparation'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimit'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'LimitMoney'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimitDistance'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'LimitDistance'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimitChange'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'LimitChange'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimitDistanceChange'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'LimitDistanceChange'
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
        Name = 'ioToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalDriverId'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 922
    Top = 72
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edInvNumberPartner
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
        Control = edChangePrice
      end
      item
        Control = edPaidKind
      end
      item
        Control = edContract
      end
      item
        Control = edRoute
      end
      item
        Control = edDriver
      end
      item
        Control = cxGrid1
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
    GetStoredProc = spGet
    Left = 224
    Top = 52
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_IncomeFuel'
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
        DataType = ftDateTime
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
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToParentId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'ParentId'
        DataType = ftString
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
        Name = 'ChangePrice'
        Value = 0.000000000000000000
        Component = edChangePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'AmountFuel'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Reparation'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitMoney'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitChange'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitDistance'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitDistanceChange'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartOdometre'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndOdometre'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DistanceReal'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isChangePriceUser'
        Value = Null
        Component = edChangePriceUser
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 992
    Top = 61
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 864
    Top = 79
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 168
    Top = 53
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inPaidKindId'
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 40
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 736
    Top = 40
  end
  object GuidesPersonalDriver: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDriver
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 560
    Top = 40
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 487
    Top = 37
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 550
    Top = 284
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 590
    Top = 284
  end
  object StatusGuides: TdsdGuides
    Tag = 123
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 31
    Top = 41
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Income'
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
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 71
    Top = 41
  end
  object spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSumm'
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
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 316
    Top = 276
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 288
    Top = 431
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 408
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 100
    Top = 438
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Child'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inOperDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteMemberName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'RouteMemberName'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartOdometre'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'StartOdometre'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndOdometre'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'EndOdometre'
        DataType = ftFloat
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
        Name = 'outDistance_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Distance_calc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartOdometre_calc'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'StartOdometre'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndOdometre_calc'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'EndOdometre'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDistanceDiff'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'DistanceReal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 186
    Top = 445
  end
  object spSelectMIChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_IncomeFuel_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 516
    Top = 376
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_IncomeFuel_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartOdometre_calc'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndOdometre_calc'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDistanceDiff'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 366
    Top = 396
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_IncomeFuel_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartOdometre_calc'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndOdometre_calc'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDistanceDiff'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 470
    Top = 420
  end
  object spGetInfo: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_IncomeFuel'
    DataSet = InfoCDS
    DataSets = <
      item
        DataSet = InfoCDS
      end>
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
        Name = 'AmountFuel'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'AmountFuel'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Reparation'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'Reparation'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitMoney'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'LimitMoney'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitChange'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'LimitChange'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitDistance'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'LimitDistance'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitDistanceChange'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'LimitDistanceChange'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartOdometre'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'StartOdometre'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndOdometre'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'EndOdometre'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DistanceReal'
        Value = ''
        Component = InfoCDS
        ComponentItem = 'DistanceReal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelCalc'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'FuelCalc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelRealCalc'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'FuelRealCalc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelDiff'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'FuelDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FuelSummDiff'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'FuelSummDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiff'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'SummDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummDiffTotal'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'SummDiffTotal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummReparation'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'SummReparation'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummPersonal'
        Value = Null
        Component = InfoCDS
        ComponentItem = 'SummPersonal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 192
  end
  object InfoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 193
  end
  object InfoDS: TDataSource
    DataSet = InfoCDS
    Left = 360
    Top = 192
  end
  object dsdDBViewAddOnInfo: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewInfo
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 256
    Top = 199
  end
  object SignDS: TDataSource
    DataSet = SignCDS
    Left = 868
    Top = 294
  end
  object SignCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 824
    Top = 296
  end
  object dsdDBViewAddOnSign: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewSign
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 864
    Top = 335
  end
  object spSelectMISign: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_IncomeFuel_Sign'
    DataSet = SignCDS
    DataSets = <
      item
        DataSet = SignCDS
      end>
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 964
    Top = 344
  end
  object spInsertUpdateMISign_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
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
        Name = 'inisSign'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 219
  end
  object spInsertUpdateMISign_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
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
        Name = 'inisSign'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 275
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 700
    Top = 369
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 422
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_IncomeFuel_Print'
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
    Left = 599
    Top = 392
  end
  object spUpdateChangePriceUser: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_IncomeFuel_ChangePriceUser'
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
        Name = 'inChangePrice'
        Value = Null
        Component = edChangePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisChangePriceUser'
        Value = Null
        Component = edChangePriceUser
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 377
  end
end
