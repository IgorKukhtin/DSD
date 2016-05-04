inherited GoodsAllRetailForm: TGoodsAllRetailForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1058#1086#1074#1072#1088#1086#1074' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
  ClientHeight = 492
  ClientWidth = 1079
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1095
  ExplicitHeight = 527
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1079
    Height = 466
    ExplicitWidth = 1079
    ExplicitHeight = 466
    ClientRectBottom = 466
    ClientRectRight = 1079
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1079
      ExplicitHeight = 466
      inherited cxGrid: TcxGrid
        Width = 1079
        Height = 153
        Align = alTop
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        ExplicitWidth = 1079
        ExplicitHeight = 153
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object MainId_1: TcxGridDBColumn
            Caption = 'MainId'
            DataBinding.FieldName = 'GoodsMainId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Id_1: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LinkId_1: TcxGridDBColumn
            DataBinding.FieldName = 'LinkId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Code_1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object CodeStr_1: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090#1088#1086#1095#1085#1099#1081
            DataBinding.FieldName = 'CodeStr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Name_1: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object MeasureName_1: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object NDSKindName_1: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object ObjectDescName_1: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ObjectName_1: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MakerName_1: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object MakerLinkName_1: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' - Link'
            DataBinding.FieldName = 'MakerLinkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupName_1: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object isClose_1: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isTOP_1: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isPromo_1: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isFirst_1: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isSecond_1: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090' '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isPublished_1: TcxGridDBColumn
            Caption = #1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isUpload_1: TcxGridDBColumn
            DataBinding.FieldName = 'isUpload'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isSpecCondition_1: TcxGridDBColumn
            DataBinding.FieldName = 'isSpecCondition'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MinimumLot_1: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object PercentMarkup_1: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Price_1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object ReferCode_1: TcxGridDBColumn
            DataBinding.FieldName = 'ReferCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReferPrice_1: TcxGridDBColumn
            DataBinding.FieldName = 'ReferPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErased_1: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
      object cxGridGChild1: TcxGrid
        Left = 0
        Top = 161
        Width = 1079
        Height = 162
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        object cxGridDBTableViewChild1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS_1
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
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object MainId_2: TcxGridDBColumn
            Caption = 'MainId'
            DataBinding.FieldName = 'GoodsMainId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Id_2: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LinkId_2: TcxGridDBColumn
            DataBinding.FieldName = 'LinkId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Code_2: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object CodeStr_2: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090#1088#1086#1095#1085#1099#1081
            DataBinding.FieldName = 'CodeStr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Name_2: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1054#1073#1097#1077#1077
            DataBinding.FieldName = 'Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object MeasureName_2: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object NDSKindName_2: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object ObjectDescName_2: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ObjectName_2: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MakerName_2: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object MakerLinkName_2: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' - Link'
            DataBinding.FieldName = 'MakerLinkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupName_2: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object isClose_2: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isTOP_2: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isPromo_2: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isFirst_2: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isSecond_2: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090' '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isPublished_2: TcxGridDBColumn
            Caption = #1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isUpload_2: TcxGridDBColumn
            DataBinding.FieldName = 'isUpload'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isSpecCondition_2: TcxGridDBColumn
            DataBinding.FieldName = 'isSpecCondition'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MinimumLot_2: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object PercentMarkup_2: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Price_2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object ReferCode_2: TcxGridDBColumn
            DataBinding.FieldName = 'ReferCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReferPrice_2: TcxGridDBColumn
            DataBinding.FieldName = 'ReferPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErased_2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevelChild1: TcxGridLevel
          GridView = cxGridDBTableViewChild1
        end
      end
      object cxSplitter: TcxSplitter
        Left = 0
        Top = 153
        Width = 1079
        Height = 8
        AlignSplitter = salTop
        Control = cxGrid
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 331
        Width = 1079
        Height = 135
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        PopupMenu = PopupMenu
        TabOrder = 2
        LookAndFeel.Kind = lfFlat
        LookAndFeel.NativeStyle = True
        object cxGridDBTableViewChild2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS_2
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
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object MainId_3: TcxGridDBColumn
            Caption = 'MainId'
            DataBinding.FieldName = 'GoodsMainId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Id_3: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LinkId_3: TcxGridDBColumn
            DataBinding.FieldName = 'LinkId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Code_3: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object CodeStr_3: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090#1088#1086#1095#1085#1099#1081
            DataBinding.FieldName = 'CodeStr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Name_3: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object MeasureName_3: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object NDSKindName_3: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object ObjectDescName_3: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ObjectName_3: TcxGridDBColumn
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MakerName_3: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object MakerLinkName_3: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' - Link'
            DataBinding.FieldName = 'MakerLinkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsGroupName_3: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object isClose_3: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isTOP_3: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isPromo_3: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103' '
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isUpload_3: TcxGridDBColumn
            DataBinding.FieldName = 'isUpload'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isSpecCondition_3: TcxGridDBColumn
            DataBinding.FieldName = 'isSpecCondition'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isFirst_3: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isSecond_3: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090' '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isPublished_3: TcxGridDBColumn
            Caption = #1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object MinimumLot_3: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object PercentMarkup_3: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Price_3: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object ReferCode_3: TcxGridDBColumn
            DataBinding.FieldName = 'ReferCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReferPrice_3: TcxGridDBColumn
            DataBinding.FieldName = 'ReferPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErased_3: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewChild2
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 323
        Width = 1079
        Height = 8
        AlignSplitter = salBottom
        Control = cxGrid2
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 467
    Top = 48
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 624
    Top = 72
  end
  inherited ActionList: TActionList
    Left = 199
    Top = 127
    object DataSetDelete: TDataSetDelete [0]
      Category = 'Delete'
      Caption = '&Delete'
      Hint = 'Delete'
      DataSource = ChildDS_1
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectMaster
        end
        item
          StoredProc = spSelectChild2
        end>
    end
    object mactListDelete: TMultiAction [2]
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end>
      DataSource = ChildDS_1
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1079#1080'? '
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1082#1086#1076#1086#1074
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      WithoutNext = True
    end
    inherited actInsert: TInsertUpdateChoiceAction
      Enabled = False
      ShortCut = 0
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      ShortCut = 0
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      isShowModal = True
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      Enabled = False
      ShortCut = 0
    end
    inherited dsdSetErased: TdsdUpdateErased
      Category = 'Delete'
      StoredProc = dsdStoredProc1
      StoredProcList = <
        item
          StoredProc = dsdStoredProc1
        end>
      ImageIndex = -1
      ShortCut = 0
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
    end
    object actGoodsLinkRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMaster
      StoredProcList = <
        item
          StoredProc = spSelectMaster
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactDelete: TMultiAction
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end
        item
          Action = DataSetDelete
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1079#1080'? '
      Caption = #1059#1076#1072#1083#1077#1085#1080#1077
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'Delete'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = dsdStoredProc1
      StoredProcList = <
        item
          StoredProc = dsdStoredProc1
        end>
      Caption = 'dsdExecStoredProc1'
    end
  end
  inherited MasterDS: TDataSource
    Left = 104
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 32
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsAll_Common'
    DataSet = ChildCDS_1
    DataSets = <
      item
        DataSet = ChildCDS_1
      end>
    Left = 176
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 736
    Top = 72
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbEdit: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Action = mactDelete
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    object bbLabel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbJuridical: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    Left = 272
    Top = 80
  end
  inherited PopupMenu: TPopupMenu
    Left = 680
    Top = 64
    object N9: TMenuItem [5]
      Action = mactListDelete
    end
    object N8: TMenuItem [6]
      Caption = '-'
    end
  end
  inherited spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ChildCDS_1
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 776
    Top = 96
  end
  object spSelectMaster: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsAll_Retail'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Params = <>
    PackSize = 1
    Left = 184
    Top = 72
  end
  object ChildCDS_1: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'GoodsMainId'
    MasterFields = 'GoodsMainId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 32
    Top = 256
  end
  object ChildDS_1: TDataSource
    DataSet = ChildCDS_1
    Left = 96
    Top = 248
  end
  object DBViewAddOnChild1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild1
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 272
    Top = 248
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actGoodsLinkRefresh
    ComponentList = <
      item
      end>
    Left = 568
    Top = 56
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS_1
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 64
  end
  object ChildCDS_2: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'GoodsMainId'
    MasterFields = 'GoodsMainId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 40
    Top = 416
  end
  object ChildDS_2: TDataSource
    DataSet = ChildCDS_2
    Left = 96
    Top = 424
  end
  object dsdDBViewAddOnChild2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild2
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 288
    Top = 416
  end
  object spSelectChild2: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsAll_Juridical'
    DataSet = ChildCDS_2
    DataSets = <
      item
        DataSet = ChildCDS_2
      end>
    Params = <>
    PackSize = 1
    Left = 176
    Top = 408
  end
end
