inherited Report_CheckTaxCorrective_NPPForm: TReport_CheckTaxCorrective_NPPForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#8470' '#1087'/'#1087' '#1074' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077'>'
  ClientHeight = 359
  ClientWidth = 1234
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitLeft = -444
  ExplicitWidth = 1250
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 1234
    Height = 244
    TabOrder = 3
    ExplicitTop = 115
    ExplicitWidth = 823
    ExplicitHeight = 244
    ClientRectBottom = 244
    ClientRectRight = 1234
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 823
      ExplicitHeight = 244
      inherited cxGrid: TcxGrid
        Width = 1234
        Height = 244
        ExplicitWidth = 823
        ExplicitHeight = 244
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
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm_original
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTaxDiff_calc
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm_original
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTaxDiff_calc
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ItemName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1080#1087' '#1085#1072#1083#1086#1075#1086#1074#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            Options.Editing = False
            Width = 67
          end
          object IsRegistered: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1089#1090#1088'.'
            DataBinding.FieldName = 'isRegistered'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
            Options.Editing = False
            Width = 45
          end
          object IsElectron: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object DateRegistered: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088'.'
            DataBinding.FieldName = 'DateRegistered'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082'. '#1053#1072#1083#1086#1075#1086#1074#1072#1103'/'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072
            Width = 68
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1053#1072#1083#1086#1075#1086#1074#1072#1103'/'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072
            Width = 55
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1053#1072#1083#1086#1075#1086#1074#1072#1103'/'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072
            Width = 72
          end
          object OperDate_Tax: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1053#1072#1083#1086#1075#1086#1074#1072#1103
            Options.Editing = False
            Width = 70
          end
          object InvNumberPartner_Tax: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1053#1072#1083#1086#1075#1086#1074#1072#1103
            Options.Editing = False
            Width = 55
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isLineNum: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#8470' '#1087'/'#1087
            DataBinding.FieldName = 'isLineNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1064#1048#1041#1050#1040': '#1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#8470' '#1087'/'#1087' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' '#1086#1090' '#1088#1072#1089#1095#1077#1090#1085#1086#1075#1086
            Options.Editing = False
            Width = 43
          end
          object LineNum_calc: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1050#1086#1088#1088'. ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'LineNum_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' '#1088#1072#1089#1095#1077#1090' - '#1089#1082#1074#1086#1079#1085#1072#1103' '#1085#1091#1084#1077#1088#1072#1094#1080#1103
            Width = 75
          end
          object LineNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' - '#1089#1082#1074#1086#1079#1085#1072#1103' '#1085#1091#1084#1077#1088#1072#1094#1080#1103
            Options.Editing = False
            Width = 55
          end
          object LineNumTaxCorr_calc: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1053#1053'-'#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'LineNumTaxCorr_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1082#1086#1090#1086#1088#1099#1081' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1091#1077#1090#1089#1103
            Options.Editing = False
            Width = 70
          end
          object LineNumTax: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' ('#1053#1053')'
            DataBinding.FieldName = 'LineNumTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1053#1072#1083#1086#1075#1086#1074#1086#1081
            Width = 55
          end
          object isAmountTax: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1082#1086#1083'-'#1074#1086' '#1074' 7/1'
            DataBinding.FieldName = 'isAmountTax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1064#1048#1041#1050#1040': '#1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1076#1083#1103' '#1082#1086#1083'-'#1074#1072' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 7/1'#1089#1090#1088#1086#1082#1072' '#1086#1090' '#1088#1072#1089#1095#1077#1090#1085#1086#1075#1086
            Options.Editing = False
            Width = 50
          end
          object AmountTax: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' 7/1 ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'AmountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 7/1'#1089#1090#1088#1086#1082#1072' ('#1088#1072#1089#1095#1077#1090')'
            Options.Editing = False
            Width = 70
          end
          object AmountTax_calc: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' 7/1'
            DataBinding.FieldName = 'AmountTax_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 7/1'#1089#1090#1088#1086#1082#1072
            Options.Editing = False
            Width = 55
          end
          object SummTaxDiff_calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1050#1054#1056#1056'. '#1076#1083#1103' '#1053#1053'-'#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'SummTaxDiff_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1050#1054#1056#1056#1045#1050#1058#1048#1056#1054#1042#1050#1048' "'#1086#1082#1088#1091#1075#1083#1077#1085#1080#1081'" '#1076#1083#1103' '#1053#1053'-'#1050#1086#1088#1088'.'
            Width = 75
          end
          object PriceTax_calc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1083#1103' '#1050#1086#1088#1088'.'#1094#1077#1085#1099
            DataBinding.FieldName = 'PriceTax_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 9/1'#1089#1090#1088#1086#1082#1072
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 36
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 135
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 55
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1053#1072#1083#1086#1075#1086#1074#1072#1103'/'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1062#1077#1085#1072' '#1053#1072#1083#1086#1075#1086#1074#1072#1103'/'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072
            Width = 55
          end
          object AmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1053#1072#1083#1086#1075#1086#1074#1072#1103'/'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1050#1054#1056#1056#1045#1050#1058#1048#1056#1054#1042#1050#1048' "'#1086#1082#1088#1091#1075#1083#1077#1085#1080#1081 +
              '"'
            Width = 80
          end
          object AmountSumm_original: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057' ('#1073#1077#1079' '#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'AmountSumm_original'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1057#1091#1084#1084#1072' '#1053#1072#1083#1086#1075#1086#1074#1072#1103'/'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1041#1045#1047' '#1091#1095#1077#1090#1072' '#1050#1054#1056#1056#1045#1050#1058#1048#1056#1054#1042#1050#1048' "'#1086#1082#1088#1091#1075#1083#1077#1085#1080 +
              #1081'"'
            Width = 85
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1234
    Height = 89
    ExplicitWidth = 823
    ExplicitHeight = 89
    inherited deStart: TcxDateEdit
      Left = 4
      Top = 59
      EditValue = 43190d
      Properties.SaveTime = False
      ExplicitLeft = 4
      ExplicitTop = 59
    end
    inherited deEnd: TcxDateEdit
      Left = 98
      Top = 59
      EditValue = 43191d
      Properties.SaveTime = False
      ExplicitLeft = 98
      ExplicitTop = 59
    end
    inherited cxLabel1: TcxLabel
      Left = 4
      Top = 42
      ExplicitLeft = 4
      ExplicitTop = 42
    end
    inherited cxLabel2: TcxLabel
      Left = 98
      Top = 42
      ExplicitLeft = 98
      ExplicitTop = 42
    end
    object cxLabel4: TcxLabel
      Left = 217
      Top = 42
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 217
      Top = 59
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 592
    end
    object cxLabel8: TcxLabel
      Left = 98
      Top = 0
      Caption = #8470' '#1085#1072#1083#1086#1075#1086#1074#1086#1081
    end
    object edDocumentTax: TcxButtonEdit
      Left = 98
      Top = 17
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 110
    end
    object cxLabel10: TcxLabel
      Left = 4
      Top = 0
      Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075#1086#1074#1086#1081
    end
    object edOperDate_Tax: TcxDateEdit
      Left = 4
      Top = 17
      EditValue = 42342d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 9
      Width = 87
    end
    object edJuridical: TcxButtonEdit
      Left = 217
      Top = 17
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 256
    end
    object cxLabel3: TcxLabel
      Left = 217
      Top = 0
      Caption = #1070#1088'. '#1083#1080#1094#1086
    end
    object cxLabel11: TcxLabel
      Left = 482
      Top = 0
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
    end
    object edPartner: TcxButtonEdit
      Left = 482
      Top = 17
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 13
      Text = ' '
      Width = 327
    end
  end
  inherited ActionList: TActionList
    object actRefreshStart: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckTC_NPPDialogForm'
      FormNameParam.Value = 'TReport_CheckTC_NPPDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxId'
          Value = ''
          Component = GuidesDocumentTax
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxName'
          Value = ''
          Component = GuidesDocumentTax
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
      ImageIndex = 62
      Value = True
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1057#1045
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1042#1057#1045
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_CheckTaxCorrective_NPP'
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = 41640d
        Component = GuidesDocumentTax
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = 'TRUE'
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
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
          ItemName = 'bbShowAll'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 72
    Top = 96
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesGoods
      end
      item
        Component = GuidesDocumentTax
      end>
    Left = 144
    Top = 56
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 56
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = ''
        Component = GuidesDocumentTax
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = GuidesDocumentTax
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 224
  end
  object GuidesDocumentTax: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTax
    FormNameParam.Value = 'TTaxJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDocumentTax
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDocumentTax
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Tax'
        Value = 'NULL'
        Component = edOperDate_Tax
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 16
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_TaxParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = GuidesDocumentTax
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42132d
        Component = edOperDate_Tax
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = GuidesDocumentTax
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 208
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    Key = '0'
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'JuridicalId'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 8
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    Key = '0'
    TextValue = ' '
    FormNameParam.Value = 'TContractChoicePartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoicePartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 16
  end
end
