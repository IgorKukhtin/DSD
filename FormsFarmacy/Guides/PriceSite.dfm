inherited PriceSiteForm: TPriceSiteForm
  Caption = #1055#1088#1072#1081#1089' - '#1083#1080#1089#1090' '#1076#1083#1103' '#1089#1072#1081#1090#1072
  ClientHeight = 422
  ClientWidth = 829
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 845
  ExplicitHeight = 461
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel [0]
    Left = 0
    Top = 0
    Width = 829
    Height = 41
    Align = alTop
    TabOrder = 5
    object cxLabel2: TcxLabel
      Left = 14
      Top = 9
      Caption = #1058#1086#1074#1072#1088':'
    end
  end
  inherited PageControl: TcxPageControl
    Top = 67
    Width = 829
    Height = 355
    ExplicitTop = 67
    ExplicitWidth = 829
    ExplicitHeight = 355
    ClientRectBottom = 355
    ClientRectRight = 829
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 829
      ExplicitHeight = 355
      inherited cxGrid: TcxGrid
        Width = 829
        Height = 355
        ExplicitWidth = 829
        ExplicitHeight = 355
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Reserved
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaReserved
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DeferredSend
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Reserved
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaReserved
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DeferredSend
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.CellEndEllipsis = True
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064'/'#1050' '#1087#1088#1086#1080#1079#1074'.'
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064'/'#1050' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 234
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            Properties.MinValue = 0.010000000000000000
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object SummaRemains: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'SummaRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1080#1079#1084'. '#1094#1077#1085#1099
            DataBinding.FieldName = 'DateChange'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object Fix: TcxGridDBColumn
            AlternateCaption = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072
            Caption = #1060#1080#1082#1089'. '#1094#1077#1085#1072
            DataBinding.FieldName = 'Fix'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072
            Width = 48
          end
          object FixDateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' "'#1060#1080#1082#1089'. '#1094#1077#1085#1072'"'
            DataBinding.FieldName = 'FixDateChange'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1089#1072#1081#1090#1072')'
            DataBinding.FieldName = 'PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
            Width = 70
          end
          object PercentMarkupDateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' % '#1085#1072#1094#1077#1085#1082#1080' ('#1089#1072#1081#1090#1072')'
            DataBinding.FieldName = 'PercentMarkupDateChange'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' % '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 74
          end
          object IntenalSPName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1057#1055' (2)'
            DataBinding.FieldName = 'IntenalSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object isClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 67
          end
          object Goods_isTop: TcxGridDBColumn
            Caption = #1058#1054#1055' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Goods_isTop'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object TOPDateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1058#1054#1055' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'TOPDateChange'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object Goods_PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Goods_PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 70
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            DataBinding.FieldName = 'isPromo'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.AllowGrayed = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object StartDate: TcxGridDBColumn
            Caption = #1048#1089#1090#1086#1088#1080#1103' '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object PriceRetSP: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1094#1077#1085#1072' '#1088#1077#1072#1083#1080#1079' '#1087#1086' '#1057#1055' (12)'
            DataBinding.FieldName = 'PriceRetSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object PriceOptSP: TcxGridDBColumn
            Caption = #1054#1087#1090#1086#1074#1086'- '#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087'. (11)'
            DataBinding.FieldName = 'PriceOptSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 91
          end
          object DiffSP2: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' '#1075#1086#1089'-'#1074#1086#1084' '#1087#1086' '#1057#1055', '#1075#1088#1085
            DataBinding.FieldName = 'DiffSP2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1083#1072#1090#1072' '#1075#1086#1089'-'#1074#1086#1084' '#1087#1086' '#1057#1055', '#1075#1088#1085' (15)'
            Options.Editing = False
            Width = 75
          end
          object PaymentSP: TcxGridDBColumn
            Caption = #1044#1086#1087#1083#1072#1090#1072' '#1087#1072#1094#1080#1077#1085#1090#1086#1084' '#1087#1086' '#1057#1055', '#1075#1088#1085
            DataBinding.FieldName = 'PaymentSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1083#1072#1090#1072' '#1087#1072#1094#1080#1077#1085#1090#1086#1084' '#1087#1086' '#1057#1055', '#1075#1088#1085' (16)'
            Options.Editing = False
            Width = 84
          end
          object PriceSiteSP: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1057#1055
            DataBinding.FieldName = 'PriceSiteSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1057#1055
            Options.Editing = False
            Width = 61
          end
          object Reserved: TcxGridDBColumn
            Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            DataBinding.FieldName = 'Reserved'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            Options.Editing = False
            Width = 55
          end
          object SummaReserved: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1086#1090#1083'. '#1090#1086#1074#1072#1088#1091' ('#1095#1077#1082')'
            DataBinding.FieldName = 'SummaReserved'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1086#1090#1083#1086#1078#1077#1085#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091' ('#1095#1077#1082')'
            Options.Editing = False
            Width = 55
          end
          object DeferredSend: TcxGridDBColumn
            Caption = #1054#1090#1083'. '#1074' '#1087#1077#1088#1077#1084#1077#1097'.'
            DataBinding.FieldName = 'DeferredSend'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1093
            Options.Editing = False
            Width = 64
          end
          object MinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
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
          object isErased: TcxGridDBColumn
            AlternateCaption = #1058#1086#1074#1072#1088' '#1091#1076#1072#1083#1077#1085
            Caption = #1061
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1091#1076#1072#1083#1077#1085
            Options.Editing = False
            Width = 27
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object CheckPriceSiteDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'CheckPriceDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 82
          end
          object Color_ExpirationDate: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ExpirationDate'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
    end
  end
  object ceGoods: TcxButtonEdit [2]
    Left = 58
    Top = 8
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1074#1072#1088'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 6
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1074#1072#1088'>'
    Width = 285
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
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      PostDataSetAfterExecute = True
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088#1099' '#1089' '#1094#1077#1085#1072#1084#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088#1099' '#1089' '#1094#1077#1085#1072#1084#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actShowDel: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 65
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 64
      ImageIndexFalse = 65
    end
    object dsdUpdatePriceSite: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'dsdUpdatePriceSite'
      DataSource = MasterDS
    end
    object actPriceSiteHistoryOpen: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1094#1077#1085
      Hint = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1094#1077#1085
      ImageIndex = 35
      FormName = 'TPriceSiteHistoryForm'
      FormNameParam.Value = 'TPriceSiteHistoryForm'
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
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      FormName = 'TPriceSiteDialogForm'
      FormNameParam.Value = 'TPriceSiteDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object dsdOpenForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
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
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PriceSite'
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowDel'
        Value = Null
        Component = actShowDel
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 184
  end
  inherited BarManager: TdxBarManager
    Left = 184
    Top = 176
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
          ItemName = 'bbChoice'
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
          ItemName = 'dxBarButton7'
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
          ItemName = 'dxBarButton2'
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
          ItemName = 'bbOpenForm'
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
    object dxBarControlContainerItemUnit: TdxBarControlContainerItem
      Caption = #1042#1099#1073#1086#1088' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Action = actShowAll
      Category = 0
      AllowAllUp = True
    end
    object dxBarButton2: TdxBarButton
      Action = actShowDel
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1058#1047
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1058#1047
      Visible = ivAlways
      ImageIndex = 41
    end
    object dxBarButton4: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1094#1077#1085#1099
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1094#1077#1085#1099
      Visible = ivAlways
      ImageIndex = 75
    end
    object dxBarButton5: TdxBarButton
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1053#1058#1047
      Category = 0
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1053#1058#1047
      Visible = ivAlways
      ImageIndex = 38
    end
    object dxBarButton6: TdxBarButton
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1053#1058#1047
      Category = 0
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1053#1058#1047
      Visible = ivAlways
      ImageIndex = 52
    end
    object dxBarButton7: TdxBarButton
      Action = actPriceSiteHistoryOpen
      Category = 0
    end
    object bbOpenForm: TdxBarButton
      Action = dsdOpenForm
      Category = 0
    end
    object bb: TdxBarButton
      Caption = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
      Category = 0
      Hint = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
      Visible = ivAlways
      ImageIndex = 27
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end>
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 200
    Top = 104
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PriceSite'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
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
        Name = 'inPercentMarkup'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFix'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Fix'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDateChange'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFixDateChange'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPercentMarkupDateChange'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkupDateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 248
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GoodsGuides
      end
      item
      end>
    Left = 344
    Top = 192
  end
end
