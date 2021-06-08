inherited RepriceSiteForm: TRepriceSiteForm
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1076#1083#1103' '#1089#1072#1081#1090#1072
  ClientHeight = 368
  ClientWidth = 982
  ExplicitWidth = 998
  ExplicitHeight = 407
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 982
    Height = 342
    ExplicitWidth = 982
    ExplicitHeight = 342
    ClientRectBottom = 342
    ClientRectRight = 982
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 982
      ExplicitHeight = 342
      inherited cxGrid: TcxGrid
        Width = 982
        Height = 342
        ExplicitWidth = 982
        ExplicitHeight = 342
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colGoodsName
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colReprice: TcxGridDBColumn
            AlternateCaption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
            Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
            DataBinding.FieldName = 'Reprice'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
            Options.Editing = False
            Width = 64
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 289
          end
          object colRemainsCount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'RemainsCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colOldPrice: TcxGridDBColumn
            Caption = #1058#1077#1082#1091#1097#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'LastPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object colPriceFix_Goods: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'.'#1094#1077#1085#1072' '#1089#1077#1090#1080
            DataBinding.FieldName = 'PriceFix_Goods'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object colNewPrice: TcxGridDBColumn
            Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'NewPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colMidPriceSale: TcxGridDBColumn
            Caption = #1057#1088'.'#1094#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'. '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MidPriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colMidPriceDiff: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1086#1090' '#1089#1088'.'#1094#1077#1085#1099
            DataBinding.FieldName = 'MidPriceDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '+0.0%;-0.0%; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colPercent: TcxGridDBColumn
            Caption = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'PriceDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '+0.0%;-0.0%; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object colMinMarginPercent: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1076#1083#1103' '#1089#1072#1081#1090#1072
            DataBinding.FieldName = 'MinMarginPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colNDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.## %'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object colExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object colIsOneJuridical: TcxGridDBColumn
            Caption = #1054#1076#1080#1085' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'isOneJuridical'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object colisPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object colContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colJuridical_Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Juridical_Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object colMarginPercent: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. % '#1085#1072#1094#1077#1085#1082#1080' '#1089#1077#1090#1080
            DataBinding.FieldName = 'MarginPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object colJuridical_GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'Juridical_GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 187
          end
          object colProducerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'ProducerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object colSumReprice: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'SumReprice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 127
          end
          object colMinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
          end
          object colUnitId: TcxGridDBColumn
            DataBinding.FieldName = 'UnitId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
          end
          object colGoodsId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
          end
          object colJuridicalId: TcxGridDBColumn
            DataBinding.FieldName = 'JuridicalId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object colContractId: TcxGridDBColumn
            DataBinding.FieldName = 'ContractId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object colId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object colIsTop_Goods: TcxGridDBColumn
            Caption = #1058#1086#1087' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsTop_Goods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1087' '#1089#1077#1090#1080
            Options.Editing = False
          end
          object colContract_Percent: TcxGridDBColumn
            DataBinding.FieldName = 'Contract_Percent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object colJuridical_Percent: TcxGridDBColumn
            DataBinding.FieldName = 'Juridical_Percent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object colAreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object colisResolution_224: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
            DataBinding.FieldName = 'isResolution_224'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object colisPromoBonus: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'. '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'isPromoBonus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colRepricePromo: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1103#1090#1100' '#1074' '#1085#1086#1095#1085#1086#1081' '#1087#1086' '#1087#1088#1086#1084#1086
            DataBinding.FieldName = 'RepricePromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object colJuridicalPromoName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1074#1097#1080#1082' '#1076#1083#1103' '#1085#1086#1095#1085#1086#1081' '#1087#1086' '#1087#1088#1086#1084#1086
            DataBinding.FieldName = 'JuridicalPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object colContractPromoName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1082#1090' '#1076#1083#1103' '#1085#1086#1095#1085#1086#1081' '#1087#1086' '#1087#1088#1086#1084#1086
            DataBinding.FieldName = 'ContractPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object colNewPricePromo: TcxGridDBColumn
            Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072' '#1076#1083#1103' '#1085#1086#1095#1085#1086#1081' '#1087#1086' '#1087#1088#1086#1084#1086
            DataBinding.FieldName = 'NewPricePromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colPriceDiffPromo: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1076#1083#1103' '#1085#1086#1095#1085#1086#1081' '#1087#1086' '#1087#1088#1086#1084#1086
            DataBinding.FieldName = 'PriceDiffPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taRightJustify
            Properties.DisplayFormat = '+0.0%;-0.0%; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_AllGoodsPrice_Site'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
