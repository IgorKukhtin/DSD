inherited GoodsMainTab_ErrorForm: TGoodsMainTab_ErrorForm
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' '#1075#1083#1072#1074#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 535
  ClientWidth = 1079
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1095
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1079
    Height = 509
    ExplicitWidth = 1079
    ExplicitHeight = 466
    ClientRectBottom = 509
    ClientRectRight = 1079
    inherited tsMain: TcxTabSheet
      ExplicitLeft = -3
      ExplicitWidth = 1079
      ExplicitHeight = 841
      inherited cxGrid: TcxGrid
        Width = 1079
        Height = 243
        Align = alTop
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        ExplicitLeft = -3
        ExplicitTop = 14
        ExplicitWidth = 1079
        ExplicitHeight = 243
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
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
          object Code_1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ObjectCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Name_1: TcxGridDBColumn
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
          object MorionCode_1: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1052#1040#1056#1048#1054#1053
            DataBinding.FieldName = 'MorionCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
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
          object isClose_1: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isNotUploadSites_1: TcxGridDBColumn
            DataBinding.FieldName = 'isNotUploadSites'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isDoesNotShare_1: TcxGridDBColumn
            DataBinding.FieldName = 'isDoesNotShare'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isAllowDivision_1: TcxGridDBColumn
            DataBinding.FieldName = 'isAllowDivision'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isNotTransferTime_1: TcxGridDBColumn
            DataBinding.FieldName = 'isNotTransferTime'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isNotMarion_1: TcxGridDBColumn
            DataBinding.FieldName = 'isNotMarion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isNOT_1: TcxGridDBColumn
            DataBinding.FieldName = 'isNOT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsGroupName_1: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
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
          object ExchangeName_1: TcxGridDBColumn
            DataBinding.FieldName = 'ExchangeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object ConditionsKeepName_1: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object GoodsGroupPromoName_1: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
            DataBinding.FieldName = 'GoodsGroupPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
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
          object CountPrice_1: TcxGridDBColumn
            DataBinding.FieldName = 'CountPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object LastPrice_1: TcxGridDBColumn
            DataBinding.FieldName = 'LastPrice'
            Width = 70
          end
          object LastPriceOld_1: TcxGridDBColumn
            DataBinding.FieldName = 'LastPriceOld'
            Width = 70
          end
          object MakerName_1: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object NameUkr_1: TcxGridDBColumn
            Caption = #1059#1082#1088'. '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'NameUkr'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CodeUKTZED_1: TcxGridDBColumn
            DataBinding.FieldName = 'CodeUKTZED'
            Width = 70
          end
          object Analog_1: TcxGridDBColumn
            DataBinding.FieldName = 'Analog'
            Width = 70
          end
          object isPublished_1: TcxGridDBColumn
            Caption = #1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object SiteKey_1: TcxGridDBColumn
            DataBinding.FieldName = 'SiteKey'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object Foto_1: TcxGridDBColumn
            DataBinding.FieldName = 'Foto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Thumb_1: TcxGridDBColumn
            DataBinding.FieldName = 'Thumb'
            Width = 70
          end
          object AppointmentName_1: TcxGridDBColumn
            DataBinding.FieldName = 'AppointmentName'
            Width = 90
          end
          object Color_Code: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Code'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_Name: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Name'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_MorionCode: TcxGridDBColumn
            DataBinding.FieldName = 'Color_MorionCode'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isErased: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isErased'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isClose: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isClose'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isNotUploadSites: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isNotUploadSites'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isDoesNotShare: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isDoesNotShare'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isAllowDivision: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isAllowDivision'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isNotTransferTime: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isNotTransferTime'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isNotMarion: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isNotMarion'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isNOT: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isNOT'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_MeasureId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_MeasureId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_NDSKindId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_NDSKindId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_Exchange: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Exchange'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_ConditionsKeepId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ConditionsKeepId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_GoodsGroupPromoID: TcxGridDBColumn
            DataBinding.FieldName = 'Color_GoodsGroupPromoID'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_ReferCode: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ReferCode'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_ReferPrice: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ReferPrice'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_CountPrice: TcxGridDBColumn
            DataBinding.FieldName = 'Color_CountPrice'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_LastPrice: TcxGridDBColumn
            DataBinding.FieldName = 'Color_LastPrice'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_MakerName: TcxGridDBColumn
            DataBinding.FieldName = 'Color_MakerName'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_GoodsGroupId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_GoodsGroupId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_NameUkr: TcxGridDBColumn
            DataBinding.FieldName = 'Color_NameUkr'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_CodeUKTZED: TcxGridDBColumn
            DataBinding.FieldName = 'Color_CodeUKTZED'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_Analog: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Analog'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isPublished: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isPublished'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_SiteKey: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SiteKey'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_Foto: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Foto'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_Thumb: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Thumb'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_AppointmentId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_AppointmentId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
        end
        object cxGridLevel1: TcxGridLevel
        end
      end
      object cxGridGChild1: TcxGrid
        Left = 0
        Top = 252
        Width = 1079
        Height = 257
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        ExplicitLeft = 24
        ExplicitTop = 264
        ExplicitWidth = 1052
        ExplicitHeight = 233
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
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
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
          object Code_2: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ObjectCode'
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
          object MorionCode_2: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1052#1040#1056#1048#1054#1053
            DataBinding.FieldName = 'MorionCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
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
          object isClose_2: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isNotUploadSites_2: TcxGridDBColumn
            DataBinding.FieldName = 'isNotUploadSites'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isDoesNotShare_2: TcxGridDBColumn
            DataBinding.FieldName = 'isDoesNotShare'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isAllowDivision_2: TcxGridDBColumn
            DataBinding.FieldName = 'isAllowDivision'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isNotTransferTime_2: TcxGridDBColumn
            DataBinding.FieldName = 'isNotTransferTime'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isNotMarion_2: TcxGridDBColumn
            DataBinding.FieldName = 'isNotMarion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isNOT_2: TcxGridDBColumn
            DataBinding.FieldName = 'isNOT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsGroupName_2: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
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
          object ExchangeName_2: TcxGridDBColumn
            DataBinding.FieldName = 'ExchangeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object ConditionsKeepName_2: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object GoodsGroupPromoName_2: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
            DataBinding.FieldName = 'GoodsGroupPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
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
          object CountPrice_2: TcxGridDBColumn
            DataBinding.FieldName = 'CountPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object LastPrice_2: TcxGridDBColumn
            DataBinding.FieldName = 'LastPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object LastPriceOld_2: TcxGridDBColumn
            DataBinding.FieldName = 'LastPriceOld'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MakerName_2: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object NameUkr_2: TcxGridDBColumn
            Caption = #1059#1082#1088'. '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'NameUkr'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CodeUKTZED: TcxGridDBColumn
            DataBinding.FieldName = 'CodeUKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Analog_2: TcxGridDBColumn
            DataBinding.FieldName = 'Analog'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isPublished_2: TcxGridDBColumn
            Caption = #1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object SiteKey_2: TcxGridDBColumn
            DataBinding.FieldName = 'SiteKey'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object Foto_2: TcxGridDBColumn
            DataBinding.FieldName = 'Foto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object Thumb_2: TcxGridDBColumn
            DataBinding.FieldName = 'Thumb'
            Width = 70
          end
          object AppointmentName_2: TcxGridDBColumn
            DataBinding.FieldName = 'AppointmentName'
            Width = 90
          end
        end
        object cxGridLevelChild1: TcxGridLevel
          GridView = cxGridDBTableViewChild1
        end
      end
      object cxSplitter: TcxSplitter
        Left = 0
        Top = 243
        Width = 1079
        Height = 9
        AlignSplitter = salTop
        Control = cxGrid
        ExplicitTop = 249
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
        end
        item
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
    inherited ProtocolOpenForm: TdsdOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'1'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'1'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGoodsLinkRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
    object Protocol2OpenForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'2'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'2'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS_1
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS_1
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object Protocol3OpenForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'3'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'3'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    StoredProcName = 'gpSelect_Object_GoodsMain_ErrorTab'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS_1
      end>
    OutputType = otMultiDataSet
    Left = 216
    Top = 184
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 136
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
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
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
    object bbProtocol2OpenForm: TdxBarButton
      Action = Protocol2OpenForm
      Category = 0
    end
    object bbProtocol3OpenForm: TdxBarButton
      Action = Protocol3OpenForm
      Category = 0
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
    ColorRuleList = <
      item
        ColorColumn = MorionCode_1
        BackGroundValueColumn = Color_MorionCode
        ColorValueList = <>
      end
      item
        ColorColumn = Name_1
        BackGroundValueColumn = Color_Name
        ColorValueList = <>
      end
      item
        ColorColumn = Analog_1
        BackGroundValueColumn = Color_Analog
        ColorValueList = <>
      end
      item
        ColorColumn = AppointmentName_1
        BackGroundValueColumn = Color_AppointmentId
        ColorValueList = <>
      end
      item
        ColorColumn = Code_1
        BackGroundValueColumn = Color_Code
        ColorValueList = <>
      end
      item
        ColorColumn = CodeUKTZED_1
        BackGroundValueColumn = Color_CodeUKTZED
        ColorValueList = <>
      end
      item
        ColorColumn = ConditionsKeepName_1
        BackGroundValueColumn = Color_ConditionsKeepId
        ColorValueList = <>
      end
      item
        ColorColumn = CountPrice_1
        BackGroundValueColumn = Color_CountPrice
        ColorValueList = <>
      end
      item
        ColorColumn = ExchangeName_1
        BackGroundValueColumn = Color_Exchange
        ColorValueList = <>
      end
      item
        ColorColumn = Foto_1
        BackGroundValueColumn = Color_Foto
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupName_1
        BackGroundValueColumn = Color_GoodsGroupId
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupPromoName_1
        BackGroundValueColumn = Color_GoodsGroupPromoID
        ColorValueList = <>
      end
      item
        ColorColumn = isAllowDivision_1
        BackGroundValueColumn = Color_isAllowDivision
        ColorValueList = <>
      end
      item
        ColorColumn = isClose_1
        BackGroundValueColumn = Color_isClose
        ColorValueList = <>
      end
      item
        ColorColumn = isDoesNotShare_1
        BackGroundValueColumn = Color_isDoesNotShare
        ColorValueList = <>
      end
      item
        ColorColumn = isErased_1
        BackGroundValueColumn = Color_isErased
        ColorValueList = <>
      end
      item
        ColorColumn = isNOT_1
        BackGroundValueColumn = Color_isNOT
        ColorValueList = <>
      end
      item
        ColorColumn = isNotMarion_1
        BackGroundValueColumn = Color_isNotMarion
        ColorValueList = <>
      end
      item
        ColorColumn = isNotTransferTime_1
        BackGroundValueColumn = Color_isNotTransferTime
        ColorValueList = <>
      end
      item
        ColorColumn = isNotUploadSites_1
        BackGroundValueColumn = Color_isNotUploadSites
        ColorValueList = <>
      end
      item
        ColorColumn = isPublished_1
        BackGroundValueColumn = Color_isPublished
        ColorValueList = <>
      end
      item
        ColorColumn = LastPrice_1
        BackGroundValueColumn = Color_LastPrice
        ColorValueList = <>
      end
      item
        ColorColumn = Color_MakerName
        BackGroundValueColumn = Color_MakerName
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureName_1
        BackGroundValueColumn = Color_MeasureId
        ColorValueList = <>
      end
      item
        ColorColumn = NDSKindName_1
        BackGroundValueColumn = Color_NDSKindId
        ColorValueList = <>
      end
      item
        ColorColumn = NameUkr_1
        BackGroundValueColumn = Color_NameUkr
        ColorValueList = <>
      end
      item
        ColorColumn = ReferCode_1
        BackGroundValueColumn = Color_ReferCode
        ColorValueList = <>
      end
      item
        ColorColumn = ReferPrice_1
        BackGroundValueColumn = Color_ReferPrice
        ColorValueList = <>
      end
      item
        ColorColumn = SiteKey_1
        BackGroundValueColumn = Color_SiteKey
        ColorValueList = <>
      end
      item
        ColorColumn = Thumb_1
        BackGroundValueColumn = Color_Thumb
        ColorValueList = <>
      end>
    Left = 296
    Top = 112
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
  object ChildCDS_1: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
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
end
