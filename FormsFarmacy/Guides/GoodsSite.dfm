inherited GoodsSiteForm: TGoodsSiteForm
  Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1076#1083#1103' '#1089#1072#1081#1090#1072
  ClientHeight = 544
  ClientWidth = 1178
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1194
  ExplicitHeight = 583
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1178
    Height = 518
    ExplicitWidth = 1178
    ExplicitHeight = 518
    ClientRectBottom = 518
    ClientRectRight = 1178
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1178
      ExplicitHeight = 518
      inherited cxGrid: TcxGrid
        Width = 1178
        Height = 518
        ExplicitWidth = 1178
        ExplicitHeight = 518
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Name
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076
            Options.Editing = False
            Width = 80
          end
          object MorionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'MorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
            Options.Editing = False
            Width = 80
          end
          object IdBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'IdBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1072#1087#1090#1077#1082#1072')'
            Options.Editing = False
            Width = 90
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
            Options.Editing = False
            Width = 110
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1088#1091#1089'. '#1103#1079#1099#1082#1077')'
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 324
          end
          object NDSKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1053#1044#1057
            Options.Editing = False
            Width = 68
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057', %'
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1044#1057', %'
            Options.Editing = False
            Width = 68
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1076#1080#1085#1080#1094#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
            Options.Editing = False
            Width = 59
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 75
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 96
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'IsClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 52
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
            Options.Editing = False
            Width = 37
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '1-'#1074#1099#1073#1086#1088
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090#1085#1099#1081' '#1074#1099#1073#1086#1088
            Options.Editing = False
            Width = 60
          end
          object isPublished: TcxGridDBColumn
            Caption = #1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            Width = 86
          end
          object isPublishedSite: TcxGridDBColumn
            Caption = #1054#1087#1091#1073#1083#1077#1082#1086#1074#1072#1085' '#1079#1072#1075#1088#1091#1078#1077#1085#1086' '#1089' '#1089#1072#1081#1090#1072
            DataBinding.FieldName = 'isPublishedSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            DataBinding.FieldName = 'isPromo'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            Options.Editing = False
            Width = 100
          end
          object MakerPromoName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074'. '#1084#1072#1088#1082'. '#1082#1086#1085#1090#1088'.'
            DataBinding.FieldName = 'MakerPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object RetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 70
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'Name'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 100
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1076#1072#1083#1077#1085
            Options.Editing = False
            Width = 51
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object isSp: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042' '#1089#1087#1080#1089#1082#1077' '#1087#1088#1086#1077#1082#1090#1072' '#171#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072#187
            Options.Editing = False
            Width = 60
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 116
          end
          object MakerNameUkr: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1059#1082#1088'. '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'MakerNameUkr'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object FormDispensingName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'FormDispensingName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object NumberPlates: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1089#1090#1080#1085' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'NumberPlates'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object QtyPackage: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'QtyPackage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object isRecipe: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
            DataBinding.FieldName = 'isRecipe'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object isExpDateExcSite: TcxGridDBColumn
            Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')'
            DataBinding.FieldName = 'isExpDateExcSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object isHideOnTheSite: TcxGridDBColumn
            Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1085#1072' '#1089#1072#1081#1090#1077' '#1085#1077#1090' '#1085#1072#1083#1080#1095#1080#1103' '#1080' '#1087#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'isHideOnTheSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1082#1088#1099#1074#1072#1090#1100' '#1085#1072' '#1089#1072#1081#1090#1077' '#1085#1077#1090' '#1074' '#1085#1072#1083#1080#1095#1080#1080' '#1080' '#1074' '#1087#1086#1089#1090#1072#1074#1082#1072#1093
            Options.Editing = False
            Width = 78
          end
          object DiscontSiteStart: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1086' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontSiteStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object DiscontSiteEnd: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontSiteEnd'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object DiscontAmountSite: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontAmountSite'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object DiscontPercentSite: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'DiscontPercentSite'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object isNotUploadSites: TcxGridDBColumn
            Caption = #1053#1077' '#1074#1099#1075#1088#1091#1078#1072#1090#1100' '#1076#1083#1103' '#1089#1090#1086#1088#1086#1085#1085#1080#1093' '#1089#1072#1081#1090#1086#1074
            DataBinding.FieldName = 'isNotUploadSites'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object Dosage: TcxGridDBColumn
            Caption = #1044#1086#1079#1080#1088#1086#1074#1082#1072
            DataBinding.FieldName = 'Dosage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object Volume: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1084
            DataBinding.FieldName = 'Volume'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object GoodsWhoCanName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091' '#1084#1086#1078#1085#1086
            DataBinding.FieldName = 'GoodsWhoCanName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object GoodsMethodApplName: TcxGridDBColumn
            Caption = #1057#1087#1086#1089#1086#1073' '#1087#1088#1080#1084#1077#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'GoodsMethodApplName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object GoodsSignOriginName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
            DataBinding.FieldName = 'GoodsSignOriginName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object Multiplicity: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080' ('#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1076#1077#1083#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'Multiplicity'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object isMultiplicityError: TcxGridDBColumn
            Caption = #1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'isMultiplicityError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 87
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 312
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 255
    inherited actRefresh: TdsdDataSetRefresh
      Category = 'Refresh'
    end
    inherited actInsert: TInsertUpdateChoiceAction
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
        end>
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      DataSetRefresh = mactAfterInsert
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      DataSetRefresh = spRefreshOneRecord
    end
    object InsertRecord1: TInsertRecord [4]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Params = <>
      Caption = 'InsertRecord1'
    end
    inherited dsdSetErased: TdsdUpdateErased
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1090#1086#1074#1072#1088'?'
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
    object macSimpleUpdateNDS: TMultiAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNDS
        end>
      View = cxGridDBTableView
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
    end
    object mactAfterInsert: TMultiAction [9]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = InsertRecord1
        end
        item
          Action = spRefreshOnInsert
        end
        item
          Action = DataSetPost1
        end>
      Caption = 'mactAfterInsert'
    end
    object macUpdateNDS: TMultiAction [10]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macSimpleUpdateNDS
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072'? '
      InfoAfterExecute = #1053#1044#1057' '#1086#1073#1085#1086#1074#1083#1077#1085#1086' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 76
    end
    object actUpdateNDS: TdsdExecStoredProc [11]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateNDS'
    end
    object spRefreshOneRecord: TdsdDataSetRefresh
      Category = 'Refresh'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macUpdateNot_No: TMultiAction
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058
      ImageIndex = 52
    end
    object DataSetInsert1: TDataSetInsert
      Category = 'Dataset'
      Caption = '&Insert'
      Hint = 'Insert'
      ImageIndex = 73
      DataSource = MasterDS
    end
    object DataSetPost1: TDataSetPost
      Category = 'Dataset'
      Caption = 'P&ost'
      Hint = 'Post'
      ImageIndex = 74
      DataSource = MasterDS
    end
    object spRefreshOnInsert: TdsdExecStoredProc
      Category = 'Refresh'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetOnInsert
      StoredProcList = <
        item
          StoredProc = spGetOnInsert
        end>
      Caption = 'spRefreshOnInsert'
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = mactUpdatePublishedSiteHide
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_isNotUploadSites
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_isNotUploadSites
        end
        item
          StoredProc = spUpdate_PublishedAll
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object actPublished: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_Published
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_Published
        end>
      Caption = 'actPublished'
    end
    object actSimplePublishedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPublished
        end>
      View = cxGridDBTableView
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
    end
    object actPublishedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimplePublishedList
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      ImageIndex = 58
    end
    object actUpdateAdditional: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'>'
      ShortCut = 16499
      ImageIndex = 43
      FormName = 'TGoodsAdditionalEditForm'
      FormNameParam.Value = 'TGoodsAdditionalEditForm'
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
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object ProtocolOpenMainForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
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
      isShowModal = False
    end
    object actUpdateGoodsAdditional: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGoodsAdditional
      StoredProcList = <
        item
          StoredProc = spUpdateGoodsAdditional
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
    end
    object actDialogGoodsAdditional: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_MakerName'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_FormDispensing'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_NumberPlates'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_QtyPackage'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_IsRecipe'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_MakerNameUkr'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      Caption = 'actDialogGoodsAdditional'
      FormName = 'TGoodsAdditionalEditDialogForm'
      FormNameParam.Value = 'TGoodsAdditionalEditDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MakerName'
          Value = ''
          Component = FormParams
          ComponentItem = 'MakerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MakerNameUkr'
          Value = Null
          Component = FormParams
          ComponentItem = 'MakerNameUkr'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FormDispensingId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'FormDispensingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'NumberPlates'
          Value = '0'
          Component = FormParams
          ComponentItem = 'NumberPlates'
          MultiSelectSeparator = ','
        end
        item
          Name = 'QtyPackage'
          Value = '0'
          Component = FormParams
          ComponentItem = 'QtyPackage'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Dosage'
          Value = Null
          Component = FormParams
          ComponentItem = 'Dosage'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Volume'
          Value = Null
          Component = FormParams
          ComponentItem = 'Volume'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsWhoCanList'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsWhoCanList'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsMethodApplId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsMethodApplId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSignOriginId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsSignOriginId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsRecipe'
          Value = False
          Component = FormParams
          ComponentItem = 'IsRecipe'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_MakerName'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_MakerName'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_MakerNameUkr'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_MakerNameUkr'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_FormDispensing'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_FormDispensing'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_NumberPlates'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_NumberPlates'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_QtyPackage'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_QtyPackage'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_Dosage'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_Dosage'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_Volume'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_Volume'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_GoodsWhoCan'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_GoodsWhoCan'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_GoodsMethodAppl'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_GoodsMethodAppl'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_GoodsSignOrigin'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_GoodsSignOrigin'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_IsRecipe'
          Value = False
          Component = FormParams
          ComponentItem = 'inis_IsRecipe'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactUpdateGoodsAdditional: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actDialogGoodsAdditional
      ActionList = <
        item
          Action = actUpdateGoodsAdditional
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 43
    end
    object mactUpdate_isExpDateExcSite: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isExpDateExcSite
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"'
      ImageIndex = 79
    end
    object actExecUpdate_isExpDateExcSite: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inExpDateExcSite_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_inExpDateExcSite_Revert
        end>
      Caption = 'actExecUpdate_isExpDateExcSite'
    end
    object actSiteDiscontDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSiteDiscontDialog'
      FormName = 'TSiteDiscontDialogForm'
      FormNameParam.Value = 'TSiteDiscontDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'DiscontSiteStart'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontSiteStart'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscontSiteEnd'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontSiteEnd'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscontPercentSite'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontPercentSite'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscontAmountSite'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscontAmountSite'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_SiteDiscont: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SiteDiscont
      StoredProcList = <
        item
          StoredProc = spUpdate_SiteDiscont
        end>
      Caption = 'actUpdate_SiteDiscont'
    end
    object mactSiteDiscont: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actSiteDiscontDialog
      ActionList = <
        item
          Action = actUpdate_SiteDiscont
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      ImageIndex = 43
    end
    object mactUpdate_Published_Revert: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actUpdate_Published_Revert
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077'"'
      ImageIndex = 79
    end
    object actUpdate_Published_Revert: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Published_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_Published_Revert
        end>
      Caption = 'actUpdate_Published_Revert'
    end
    object actFD_DownloadPublishedSite: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      AfterAction = actRefresh
      BeforeAction = actSite_Param
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.Port = 0
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = '172.17.2.13'
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = 3306
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = 'neboley'
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = 'db2012Ne8ol'
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = 'neboley'
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 
        'select Postgres_drug_id As Id, Status AS isPublished  from pharm' +
        '_drugs'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      DataSet = MasterCDS
      Operation = fdoMultiExecuteJSON
      Params = <>
      UpdateFields = <>
      IdFieldFrom = 'Id'
      IdFieldTo = 'Id'
      JsonParam.Value = ''
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'JSON'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'I'
        end
        item
          FieldName = 'isPublished'
          PairName = 'P'
        end>
      MultiExecuteAction = actUpdate_PublishedSite
      Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1089' '#1089#1072#1081#1090#1072
      ImageIndex = 27
      QuestionBeforeExecute = #1054#1073#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1089' '#1089#1072#1081#1090#1072'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086'.'
    end
    object actSite_Param: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSite_Param
      StoredProcList = <
        item
          StoredProc = spSite_Param
        end>
      Caption = 'actSite_Param'
    end
    object actUpdate_PublishedSite: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PublishedSite
      StoredProcList = <
        item
          StoredProc = spUpdate_PublishedSite
        end>
      Caption = 'actUpdate_PublishedSite'
    end
    object actFD_DownloadPublishedSiteOne: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.Port = 0
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 
        'select Postgres_drug_id As Id, Status AS isPublished  from pharm' +
        '_drugs where Postgres_drug_id = :Id'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      DataSet = MasterCDS
      Operation = fdoMultiExecuteJSON
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      UpdateFields = <>
      IdFieldFrom = 'Id'
      IdFieldTo = 'Id'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'JSON'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'I'
        end
        item
          FieldName = 'isPublished'
          PairName = 'P'
        end>
      MultiExecuteAction = actUpdate_PublishedSite
      Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1089' '#1089#1072#1081#1090#1072
    end
    object actFD_UpdatePublishedSite_Revert: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.Port = 0
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 
        'update pharm_drugs set Status = case when Status = 0 then 1 else' +
        ' 0 end where Postgres_drug_id = :Id'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      TypeTransaction = ttExecSQL
      DataSet = MasterCDS
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      UpdateFields = <>
      IdFieldFrom = 'Id'
      IdFieldTo = 'Id'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'JSON'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'I'
        end
        item
          FieldName = 'isPublished'
          PairName = 'P'
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1072
    end
    object mactUpdatePublishedSite_Revert: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSite_Param
        end
        item
          Action = actFD_UpdatePublishedSite_Revert
        end
        item
          Action = actFD_DownloadPublishedSiteOne
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1072'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1072
      ImageIndex = 79
    end
    object actFD_UpdatePublishedSite_Yes: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.Port = 0
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 'update pharm_drugs set Status = 1 where Postgres_drug_id = :Id'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      TypeTransaction = ttExecSQL
      DataSet = MasterCDS
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      UpdateFields = <>
      IdFieldFrom = 'Id'
      IdFieldTo = 'Id'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'JSON'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'I'
        end
        item
          FieldName = 'isPublished'
          PairName = 'P'
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1072
    end
    object mactDoUpdatePublishedSite_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actFD_UpdatePublishedSite_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077
    end
    object mactFD_DownloadPublishedSiteOne: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actFD_DownloadPublishedSiteOne
        end>
      View = cxGridDBTableView
      Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1089' '#1089#1072#1081#1090#1072
    end
    object mactUpdatePublishedSite_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSite_Param
        end
        item
          Action = mactDoUpdatePublishedSite_Yes
        end
        item
          Action = mactFD_DownloadPublishedSiteOne
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 79
    end
    object actFD_UpdatePublishedSite_No: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.Port = 0
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 'update pharm_drugs set Status = 0 where Postgres_drug_id = :Id'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      TypeTransaction = ttExecSQL
      DataSet = MasterCDS
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      UpdateFields = <>
      IdFieldFrom = 'Id'
      IdFieldTo = 'Id'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'JSON'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'I'
        end
        item
          FieldName = 'isPublished'
          PairName = 'P'
        end>
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1072
    end
    object mactDoUpdatePublishedSite_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actFD_UpdatePublishedSite_No
        end>
      View = cxGridDBTableView
      Caption = #1057#1085#1103#1090#1080#1077' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077
    end
    object mactUpdatePublishedSite_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSite_Param
        end
        item
          Action = mactDoUpdatePublishedSite_No
        end
        item
          Action = mactFD_DownloadPublishedSiteOne
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1073#1088#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1073#1088#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 76
    end
    object actUpdate_Published_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Published_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Published_Yes
        end>
      Caption = 'actUpdate_Published_Yes'
    end
    object mactUpdate_Published_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Published_Revert
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077'"'
    end
    object mactUpdatePublishedSiteAll_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSite_Param
        end
        item
          Action = mactDoUpdatePublishedSite_Yes
        end
        item
          Action = mactUpdate_Published_Yes
        end
        item
          Action = mactFD_DownloadPublishedSiteOne
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1091' '#1085#1072#1089' '#1080' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1091' '#1085#1072#1089' '#1080' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 80
    end
    object actUpdate_Published_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Published_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Published_No
        end>
      Caption = 'actUpdate_Published_No'
    end
    object mactUpdate_Published_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Published_Revert
        end>
      View = cxGridDBTableView
      Caption = #1057#1085#1103#1090#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077'"'
      Hint = #1057#1085#1103#1090#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' "'#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077'"'
    end
    object mactUpdatePublishedSiteAll_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSite_Param
        end
        item
          Action = mactDoUpdatePublishedSite_No
        end
        item
          Action = mactUpdate_Published_No
        end
        item
          Action = mactFD_DownloadPublishedSiteOne
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1073#1088#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1091' '#1085#1072#1089' '#1080' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1059#1073#1088#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1091' '#1085#1072#1089' '#1080' '#1085#1072' '#1089#1072#1081#1090#1077' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 77
    end
    object actFD_UpdatePublishedSiteHide: TdsdForeignData
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      ZConnection.ControlsCodePage = cCP_UTF16
      ZConnection.ClientCodepage = 'utf8'
      ZConnection.Properties.Strings = (
        'codepage=utf8')
      ZConnection.Port = 0
      ZConnection.Protocol = 'mysql-5'
      HostParam.Value = Null
      HostParam.Component = FormParams
      HostParam.ComponentItem = 'MySQL_Host'
      HostParam.DataType = ftString
      HostParam.MultiSelectSeparator = ','
      PortParam.Value = Null
      PortParam.Component = FormParams
      PortParam.ComponentItem = 'MySQL_Port'
      PortParam.MultiSelectSeparator = ','
      UserNameParam.Value = Null
      UserNameParam.Component = FormParams
      UserNameParam.ComponentItem = 'MySQL_Username'
      UserNameParam.DataType = ftString
      UserNameParam.MultiSelectSeparator = ','
      PasswordParam.Value = Null
      PasswordParam.Component = FormParams
      PasswordParam.ComponentItem = 'MySQL_Password'
      PasswordParam.DataType = ftString
      PasswordParam.MultiSelectSeparator = ','
      DataBase.Value = Null
      DataBase.Component = FormParams
      DataBase.ComponentItem = 'MySQL_DataBase'
      DataBase.DataType = ftString
      DataBase.MultiSelectSeparator = ','
      SQLParam.Value = 
        'update pharm_drugs set Status = case when Status = 0 then 1 else' +
        ' 0 end where Postgres_drug_id = :Id and Status <> :isPublishedSi' +
        'te'
      SQLParam.DataType = ftString
      SQLParam.MultiSelectSeparator = ','
      TypeTransaction = ttExecSQL
      DataSet = MasterCDS
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPublishedSite'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isPublishedSite'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      UpdateFields = <>
      IdFieldFrom = 'Id'
      IdFieldTo = 'Id'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'JSON'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'I'
        end
        item
          FieldName = 'isPublished'
          PairName = 'P'
        end>
      HideError = True
      ParamBollToInt = True
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1086#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1072
    end
    object mactUpdatePublishedSiteHide: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSite_Param
        end
        item
          Action = actFD_UpdatePublishedSiteHide
        end>
      Caption = 'mactUpdatePublishedSiteHide'
    end
    object actUpdate_Multiplicity: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = astExecuteDialogMultiplicity
      ActionList = <
        item
          Action = actExecUpfdate_Multiplicity
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      ImageIndex = 43
    end
    object actExecUpfdate_Multiplicity: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Multiplicity
      StoredProcList = <
        item
          StoredProc = spUpdate_Multiplicity
        end>
      Caption = 'actExecUpfdate_Multiplicity'
    end
    object astExecuteDialogMultiplicity: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogUpdate_PercentWagesStore'
      FormName = 'TAmountDialogForm'
      FormNameParam.Value = 'TAmountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Amount'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'Multiplicity'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1080#1076#1072#1078#1077'"'
          Component = FormParams
          ComponentItem = 'MultiplicityLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object maUpdate_isMultiplicityError: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isMultiplicityError
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      ImageIndex = 79
    end
    object actExecUpdate_isMultiplicityError: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMultiplicityError_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_isMultiplicityError_Revert
        end>
      Caption = 'actExecUpdate_isMultiplicityError'
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 24
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Site'
    Params = <
      item
        Name = 'inContractId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 40
    Top = 168
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAdditional'
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
          ItemName = 'bbChoiceGuides'
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
          ItemName = 'bsUpdate'
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
          ItemName = 'dxBarSubItem5'
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
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Style = dmMain.cxFooterStyle
      ShowCaption = False
    end
    object bbPublished: TdxBarButton
      Action = actPublishedList
      Category = 0
    end
    object bbLabel3: TdxBarControlContainerItem
      Caption = 'Label3'
      Category = 0
      Hint = 'Label3'
      Visible = ivAlways
    end
    object bbContract: TdxBarControlContainerItem
      Caption = 'Contract'
      Category = 0
      Hint = 'Contract'
      Visible = ivAlways
    end
    object bbUpdateNDS: TdxBarButton
      Action = macUpdateNDS
      Category = 0
    end
    object bbUpdate_CountPrice: TdxBarButton
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
      Category = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1089#1077#1090#1103#1084
      Style = dmMain.cxContentStyle
      Visible = ivAlways
      PaintStyle = psCaption
    end
    object bbStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbUpdateNotMarion_Yes: TdxBarButton
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbUpdateNotMarion_No: TdxBarButton
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdateNot_Yes: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1044#1072
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdateNot_No: TdxBarButton
      Action = macUpdateNot_No
      Category = 0
    end
    object bbUpdateNot_v2_Yes: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1044#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbUpdateNot_v2_No: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdate_isSun_v3_yes: TdxBarButton
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' = '#1044#1040
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1044#1040
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_isSun_v3_No: TdxBarButton
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbSetClose: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbClearClose: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbinResolution_224_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbisResolution_224_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_inTop_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_inTop_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbUpdate_isNot_Sun_v4_yes: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbUpdate_isNot_Sun_v4_No: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdateGoods_KoeffSUN: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v2-'#1055#1048')'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      Visible = ivAlways
      ImageIndex = 43
    end
    object bbUpdateGoods_LimitSUN: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton2: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bsUpdate: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton19'
        end
        item
          Visible = True
          ItemName = 'dxBarButton27'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end>
    end
    object bbUpdateInvisibleSUN: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdateisSupplementSUN1: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdateExceptionUKTZED: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateNotMarion_Yes'
        end
        item
          Visible = True
          ItemName = 'bbSetClose'
        end
        item
          Visible = True
          ItemName = 'bbisResolution_224_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_Yes'
        end
        item
          Visible = True
          ItemName = 'bbtUpdate_isFirst_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSecond_Yes'
        end>
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = #1057#1085#1103#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 58
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateNotMarion_No'
        end
        item
          Visible = True
          ItemName = 'bbClearClose'
        end
        item
          Visible = True
          ItemName = 'bbinResolution_224_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isFirst_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSecond_No'
        end>
    end
    object dxBarSubItem4: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <>
    end
    object bbUpdate_inPresent_Revert: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton3: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076 +
        #1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076 +
        #1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton4: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton5: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1'
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1'
      Visible = ivAlways
      ImageIndex = 66
    end
    object dxBarButton6: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087 +
        #1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087 +
        #1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton7: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton8: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton9: TdxBarButton
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 76
    end
    object dxBarButton10: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton11: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton12: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton13: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Visible = ivAlways
      ImageIndex = 43
    end
    object bbUpdateAdditional: TdxBarButton
      Action = actUpdateAdditional
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = ProtocolOpenMainForm
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = mactUpdateGoodsAdditional
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = mactUpdate_isExpDateExcSite
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = mactSiteDiscont
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072'+'#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object bbtUpdate_isFirst_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_isSecond_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_isFirst_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdate_isSecond_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 77
    end
    object dxBarButton19: TdxBarButton
      Action = mactUpdate_Published_Revert
      Category = 0
    end
    object dxBarButton20: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarSubItem5: TdxBarSubItem
      Caption = #1057#1077#1088#1074#1077#1088' '#1089#1072#1081#1090#1072
      Category = 0
      Visible = ivAlways
      ImageIndex = 41
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton21'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton23'
        end
        item
          Visible = True
          ItemName = 'dxBarButton24'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton25'
        end
        item
          Visible = True
          ItemName = 'dxBarButton26'
        end>
    end
    object dxBarButton21: TdxBarButton
      Action = actFD_DownloadPublishedSite
      Category = 0
    end
    object dxBarButton22: TdxBarButton
      Action = mactUpdatePublishedSite_Revert
      Category = 0
    end
    object dxBarButton23: TdxBarButton
      Action = mactUpdatePublishedSite_Yes
      Category = 0
    end
    object dxBarButton24: TdxBarButton
      Action = mactUpdatePublishedSite_No
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = '-'
      Category = 0
      Hint = '-'
      Visible = ivAlways
    end
    object dxBarButton25: TdxBarButton
      Action = mactUpdatePublishedSiteAll_Yes
      Category = 0
    end
    object dxBarButton26: TdxBarButton
      Action = mactUpdatePublishedSiteAll_No
      Category = 0
    end
    object dxBarSeparator2: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
    end
    object dxBarSeparator3: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object dxBarSeparator4: TdxBarSeparator
      Caption = 'New Separator'
      Category = 0
      Hint = 'New Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object dxBarButton27: TdxBarButton
      Action = actUpdate_Multiplicity
      Category = 0
    end
    object dxBarButton28: TdxBarButton
      Action = maUpdate_isMultiplicityError
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
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
    ColorRuleList = <
      item
        ColorColumn = IsTop
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Code
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = IsClose
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isFirst
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Name
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = NDSKindName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isSecond
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isPromo
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isPublished
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = ConditionsKeepName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    SearchAsFilter = False
    Left = 344
    Top = 176
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 256
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isClose'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTop'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MorionCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MakerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormDispensingId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormDispensingName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NumberPlates'
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'QtyPackage'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRecipe'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isRecipe'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v1'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v2'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v4'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_Supplementv1'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v1'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v2'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v4'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Supplementv1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaWages'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelSummaWages'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090 +
          #1086#1083#1100#1085#1080#1082#1072
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentWages'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentWages'
        Value = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaWagesStore'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelSummaWagesStore'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
          #1083#1072#1076#1086#1074#1097#1080#1082#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentWagesStore'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentWagesStore'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
          #1083#1072#1076#1086#1074#1097#1080#1082#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitSupplementSUN1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Multiplicity'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MultiplicityLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1080#1076#1072#1078#1077'"'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkupLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' % '#1085#1072#1094#1077#1085#1082#1080
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerNameUkr'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = '0'
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsRecipe'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerNameUkr'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontSiteStart'
        Value = '01.01.2016'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontSiteEnd'
        Value = '01.01.2016'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontPercentSite'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontAmountSite'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Host'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Port'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_DataBase'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Username'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MySQL_Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JSON'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dosage'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Volume'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsWhoCanList'
        Value = '0'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMethodApplId'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSignOriginId'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Dosage'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Volume'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsWhoCan'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsMethodAppl'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsSignOrigin'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 64
  end
  object spGetOnInsert: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
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
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MorionCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 208
  end
  object spUpdate_Goods_Published: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Published'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisPublished'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPublished'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 107
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 336
    Top = 104
  end
  object spUpdate_Goods_isNotUploadSites: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isNotUploadSites'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotUploadSites'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotUploadSites'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisNotUploadSites'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isNotUploadSites'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 184
  end
  object spUpdate_isMultiplicityError_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isMultiplicityError_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMultiplicityError'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMultiplicityError'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 160
  end
  object spUpdateGoodsAdditional: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsAdditionalFilter'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerName'
        Value = ''
        Component = FormParams
        ComponentItem = 'MakerName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_MakerName'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFormDispensingId'
        Value = ''
        Component = FormParams
        ComponentItem = 'FormDispensingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_FormDispensing'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberPlates'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'NumberPlates'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_NumberPlates'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQtyPackage'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'QtyPackage'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_QtyPackage'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRecipe'
        Value = False
        Component = FormParams
        ComponentItem = 'IsRecipe'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_IsRecipe'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerNameUkr'
        Value = Null
        Component = FormParams
        ComponentItem = 'MakerNameUkr'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerNameUkr'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_MakerNameUkr'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDosage'
        Value = Null
        Component = FormParams
        ComponentItem = 'Dosage'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Dosage'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_Dosage'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVolume'
        Value = Null
        Component = FormParams
        ComponentItem = 'Volume'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Volume'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_Volume'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsWhoCanList'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsWhoCanList'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsWhoCan'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_GoodsWhoCan'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsMethodApplId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsMethodApplId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsMethodAppl'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_GoodsMethodAppl'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSignOriginId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsSignOriginId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsSignOrigin'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_GoodsSignOrigin'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 200
  end
  object spUpdate_inExpDateExcSite_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inExpDateExcSite_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisExpDateExcSite'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isExpDateExcSite'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 336
  end
  object spUpdate_SiteDiscont: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_SiteDiscont'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscontSiteStart'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontSiteStart'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscontSiteEnd'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontSiteEnd'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscontPercentSite'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontPercentSite'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscontAmountSite'
        Value = Null
        Component = FormParams
        ComponentItem = 'DiscontAmountSite'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 368
  end
  object spUpdate_Published_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Published_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininIsPublished'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsPublished'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 224
  end
  object spSite_Param: TdsdStoredProc
    StoredProcName = 'gpGet_MySQL_Site_Param'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outHost'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Host'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPort'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDataBase'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_DataBase'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUsername'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Username'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassword'
        Value = Null
        Component = FormParams
        ComponentItem = 'MySQL_Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 288
  end
  object spUpdate_PublishedSite: TdsdStoredProc
    StoredProcName = 'gpUpdate_GoodsMain_PublishedSite'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJSON'
        Value = Null
        Component = FormParams
        ComponentItem = 'JSON'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 312
  end
  object spUpdate_Published_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Published_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininIsPublished'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 272
  end
  object spUpdate_Published_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Published_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininIsPublished'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 344
  end
  object spUpdate_PublishedAll: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_PublishedAll'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPublished'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isPublished'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPublishedSite'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPublishedSite'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 376
  end
  object spUpdate_Multiplicity: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Multiplicity'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMultiplicity'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'Multiplicity'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 112
  end
end
