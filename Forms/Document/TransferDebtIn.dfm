inherited TransferDebtInForm: TTransferDebtInForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1087#1088#1080#1093#1086#1076')>'
  ClientHeight = 532
  ClientWidth = 1140
  ExplicitWidth = 1156
  ExplicitHeight = 567
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 166
    Width = 1140
    Height = 268
    ExplicitTop = 166
    ExplicitWidth = 1140
    ExplicitHeight = 268
    ClientRectBottom = 268
    ClientRectRight = 1140
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1140
      ExplicitHeight = 244
      inherited cxGrid: TcxGrid
        Width = 1140
        Height = 244
        ExplicitWidth = 1140
        ExplicitHeight = 244
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChildDiff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Kind = skSum
              Column = colPrice
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChildDiff
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colName: TcxGridDBColumn [2]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 220
          end
          object colGoodsKindName: TcxGridDBColumn [3]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colMeasureName: TcxGridDBColumn [4]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object colChangePercentAmount: TcxGridDBColumn [5]
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089
            DataBinding.FieldName = 'ChangePercentAmount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colAmount: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colAmountChild: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1074#1103#1079#1082#1072')'
            DataBinding.FieldName = 'AmountChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountChildDiff: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1079#1085#1080#1094#1072')'
            DataBinding.FieldName = 'AmountChildDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colPrice: TcxGridDBColumn [9]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colCountForPrice: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colAmountSumm: TcxGridDBColumn [11]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
    object cxTabSheetTaxCorrective: TcxTabSheet
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
      ImageIndex = 2
      object cxGridTaxCorrective: TcxGrid
        Left = 0
        Top = 0
        Width = 1140
        Height = 244
        Align = alClient
        TabOrder = 0
        object cxGridTaxCorrectiveDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = TaxCorrectiveDS
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
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummPVAT
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
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummPVAT
            end>
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
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colStatus: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colIsError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'IsError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clincInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object clincInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object colInvNumberPartner_Child: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Child'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actTaxJournalChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object colOperDate_Child: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object colPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object colOKPO_From: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_From'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object colVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colTotalSummVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colTotalSummMVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummMVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colTotalSummPVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummPVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object colContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colChecked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colDocument: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085
            DataBinding.FieldName = 'Document'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colIsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object colIsElectron: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object colIsMedoc: TcxGridDBColumn
            Caption = #1052#1077#1076#1086#1082
            DataBinding.FieldName = 'IsMedoc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
        object cxGridTaxCorrectiveLevel: TcxGridLevel
          GridView = cxGridTaxCorrectiveDBTableView
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1140
    Height = 140
    TabOrder = 3
    ExplicitWidth = 1140
    ExplicitHeight = 140
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 91
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 91
      ExplicitWidth = 89
      Width = 89
    end
    inherited cxLabel2: TcxLabel
      Left = 91
      ExplicitLeft = 91
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 183
      ExplicitHeight = 22
      Width = 183
    end
    object cxLabel3: TcxLabel
      Left = 440
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 440
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 200
    end
    object edTo: TcxButtonEdit
      Left = 650
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 200
    end
    object cxLabel4: TcxLabel
      Left = 650
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edContractFrom: TcxButtonEdit
      Left = 469
      Top = 63
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Width = 114
    end
    object cxLabel9: TcxLabel
      Left = 469
      Top = 45
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel6: TcxLabel
      Left = 383
      Top = 45
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKindFrom: TcxButtonEdit
      Left = 383
      Top = 63
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 13
      Width = 77
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 200
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 14
      Width = 128
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 334
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 15
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 334
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 803
      Top = 63
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      TabOrder = 17
      Width = 144
    end
    object cxLabel8: TcxLabel
      Left = 803
      Top = 45
      Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
    end
    object cxLabel10: TcxLabel
      Left = 594
      Top = 44
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKindTo: TcxButtonEdit
      Left = 594
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 20
      Width = 77
    end
    object cxLabel11: TcxLabel
      Left = 680
      Top = 45
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object edContractTo: TcxButtonEdit
      Left = 680
      Top = 63
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 22
      Width = 114
    end
    object edPartnerFrom: TcxButtonEdit
      Left = 255
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 23
      Text = ' '
      Width = 174
    end
    object cxLabel12: TcxLabel
      Left = 257
      Top = 5
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1086#1090' '#1082#1086#1075#1086')'
    end
    object cxLabel13: TcxLabel
      Left = 956
      Top = 45
      Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 956
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 26
      Width = 93
    end
    object edIsChecked: TcxCheckBox
      Left = 258
      Top = 106
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 27
      Width = 118
    end
    object cxLabel17: TcxLabel
      Left = 383
      Top = 88
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 383
      Top = 106
      TabOrder = 29
      Width = 584
    end
    object cxLabel18: TcxLabel
      Left = 859
      Top = 5
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1082#1086#1084#1091')'
    end
    object edPartner: TcxButtonEdit
      Left = 859
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 31
      Text = ' '
      Width = 190
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 105
    Top = 88
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  end
  object edPriceList: TcxButtonEdit [3]
    Left = 105
    Top = 106
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 144
  end
  object cxLabel14: TcxLabel [4]
    Left = 8
    Top = 88
    Caption = #8470' '#1076#1086#1082'.'#1091' '#1082#1086#1085#1090#1088'.'
  end
  object edInvNumberPartner: TcxTextEdit [5]
    Left = 8
    Top = 106
    TabOrder = 9
    Width = 84
  end
  object cxLabel16: TcxLabel [6]
    Left = 186
    Top = 5
    Caption = #8470' '#1079'.'#1084'.'
  end
  object edInvNumberMark: TcxTextEdit [7]
    Left = 186
    Top = 23
    TabOrder = 11
    Width = 63
  end
  object cxSplitter1: TcxSplitter [8]
    Left = 0
    Top = 434
    Width = 1140
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = cxGrid1
  end
  object cxGrid1: TcxGrid [9]
    Left = 0
    Top = 442
    Width = 1140
    Height = 90
    Align = alBottom
    PopupMenu = PopupMenu
    TabOrder = 13
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DetailDS
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
          Column = AmountPartner
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
          Column = AmountPartner
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.IncSearch = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object isError: TcxGridDBColumn
        Caption = #1054#1096#1080#1073#1082#1072
        DataBinding.FieldName = 'isError'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 209
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object Amount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1080#1074#1103#1079#1082#1072')'
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object AmountPartner: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'AmountPartner'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object Price: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object DescName_Sale: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1076#1086#1082'.'
        DataBinding.FieldName = 'DescName_Sale'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InvNumberPartner: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'InvNumberPartner'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object InvNumber_Master: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082'. '#1085#1072#1083#1086#1075'.'
        DataBinding.FieldName = 'InvNumber_Master'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object InvNumberPartner_Master: TcxGridDBColumn
        Caption = #8470' '#1085#1072#1083#1086#1075'.'
        DataBinding.FieldName = 'InvNumberPartner_Master'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
        DataBinding.FieldName = 'OperDate'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object OperDatePartner: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
        DataBinding.FieldName = 'OperDatePartner'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object OperDate_Master: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
        DataBinding.FieldName = 'OperDate_Master'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ContractCode_Sale: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'ContractCode_Sale'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 71
      end
      object ContractName_Sale: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'ContractName_Sale'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 67
      end
      object ContractCode_Tax: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
        DataBinding.FieldName = 'ContractCode_Tax'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object ContractName_Tax: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
        DataBinding.FieldName = 'ContractName_Tax'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 67
      end
      object DocumentTaxKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
        DataBinding.FieldName = 'DocumentTaxKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 160
      end
      object FromName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'FromName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object ToCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'ToCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object ToName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'ToName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1087#1088#1086#1076#1072#1078#1072')'
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object MovementId_sale: TcxGridDBColumn
        Caption = 'Id1'
        DataBinding.FieldName = 'MovementId_sale'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object MovementItemId_sale: TcxGridDBColumn
        Caption = 'Id2'
        DataBinding.FieldName = 'MovementItemId_sale'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 344
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AncestorDocumentForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Top = 360
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    inherited actMISetUnErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    object MedocAction: TMedocAction [4]
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'MedocAction'
      HeaderDataSet = PrintItemsCDS
      ItemsDataSet = PrintItemsCDS
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end>
    end
    object actOpenTax: TdsdOpenForm [7]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Hint = '<'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      ImageIndex = 26
      FormName = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'DocumentChildId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = 'False'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = 'False'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate_Child'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actTaxJournalChoice: TOpenChoiceForm [8]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TaxJournalSelectForm'
      FormName = 'TTaxJournalChoiceForm'
      FormNameParam.Value = 'TTaxJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'DocumentChildId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'InvNumberPartner_Child'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate_Tax'
          Value = 'NULL'
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate_Child'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'FromId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenReportCheckAmountForm: TdsdOpenForm [9]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1074' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1074' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      ImageIndex = 26
      FormName = 'TReport_CheckAmount_ReturnInToSaleForm'
      FormNameParam.Value = 'TReport_CheckAmount_ReturnInToSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartnerFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesPartnerFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
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
          Name = 'inInvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportCheckForm: TdsdOpenForm [10]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      ImageIndex = 24
      FormName = 'TReport_Check_ReturnInToSaleForm'
      FormNameParam.Value = 'TReport_Check_ReturnInToSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartnerFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesPartnerFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
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
          Name = 'inInvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportForm: TdsdOpenForm [11]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 25
      FormName = 'TReport_Goods_SalebyReturnInForm'
      FormNameParam.Value = 'TReport_Goods_SalebyReturnInForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartnerFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesPartnerFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = ''
          Component = PaidKindFromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = ''
          Component = PaidKindFromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
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
          Name = 'inContractId'
          Value = ''
          Component = ContractFromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractName'
          Value = ''
          Component = ContractFromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = ''
      Hint = ''
      ImageIndex = -1
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
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportName'
      ReportNameParam.ParamType = ptInput
    end
    object mactPrint: TMultiAction [15]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintProcName
        end
        item
          Action = actPrint
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actAddMask: TdsdExecStoredProc
      TabSheet = tsMain
    end
    object actOpenTaxCorrective: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 1
      FormName = 'TTaxCorrectiveForm'
      FormNameParam.Value = 'TTaxCorrectiveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = 'False'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actTaxCorrective: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTaxCorrective
      StoredProcList = <
        item
          StoredProc = spTaxCorrective
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>'
      ImageIndex = 41
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089 +
        ' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>?'
      InfoAfterExecute = 
        #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088 +
        #1080#1074#1103#1079#1082#1086#1081')>.'
    end
    object actCorrective: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCorrective
      StoredProcList = <
        item
          StoredProc = spCorrective
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>'
      ImageIndex = 42
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073 +
        #1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>?'
      InfoAfterExecute = 
        #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' ' +
        #1087#1088#1080#1074#1103#1079#1082#1080')>.'
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actSPPrintProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName
      StoredProcList = <
        item
          StoredProc = spGetReportName
        end>
      Caption = 'actSPPrintProcName'
    end
    object actUnCompleteTaxCorrective: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementUnCompleteTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementUnCompleteTaxCorrective
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = TaxCorrectiveDS
    end
    object actSetErasedTaxCorrective: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementSetErasedTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementSetErasedTaxCorrective
        end
        item
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 13
      Status = mtDelete
      DataSource = TaxCorrectiveDS
    end
    object actCompleteTaxCorrective: TdsdChangeMovementStatus
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementCompleteTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementCompleteTaxCorrective
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 12
      Status = mtComplete
      DataSource = TaxCorrectiveDS
    end
    object actPrint_ReturnIn_by_TaxCorrective: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' ('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081' '#1082' '#1082#1086#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072#1084')'
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103' ('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081' '#1082' '#1082#1086#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072#1084')'
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReturnIn_By_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1082#1083#1080#1077#1085#1090#1091')'
      ReportNameParam.Value = 'PrintMovement_ReturnIn_By_TaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameTaxCorrective
      StoredProcList = <
        item
          StoredProc = spGetReportNameTaxCorrective
        end>
      Caption = 'actSPPrintTaxCorrectiveProcName'
    end
    object actPrint_TaxCorrective_Us: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Us
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_TaxCorrective_Client: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1082#1083#1080#1077#1085#1090#1091')'
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_TaxCorrective_Client: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object mactPrint_TaxCorrective_Us: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
    end
    object actUpdateAuto: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAuto
      StoredProcList = <
        item
          StoredProc = spUpdateAuto
        end
        item
          StoredProc = spSelect_MI_Child
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>'
      ImageIndex = 7
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>.'
    end
    object actMedocProcedure: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = 'actMedocProcedure'
    end
    object actUpdateIsMedoc: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIsMedoc
      StoredProcList = <
        item
          StoredProc = spUpdateIsMedoc
        end>
      Caption = 'actUpdateIsMedoc'
    end
    object mactMeDoc: TMultiAction
      Category = 'TaxLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actMedocProcedure
        end
        item
          Action = MedocAction
        end
        item
          Action = actUpdateIsMedoc
        end>
      InfoAfterExecute = #1060#1072#1081#1083' '#1091#1089#1087#1077#1096#1085#1086' '#1074#1099#1075#1088#1091#1078#1077#1085
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      ImageIndex = 30
    end
  end
  inherited MasterDS: TDataSource
    Left = 96
    Top = 360
  end
  inherited MasterCDS: TClientDataSet
    Left = 56
    Top = 360
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_TransferDebtIn'
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
        Name = 'inPriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
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
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
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
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
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
          ItemName = 'bbUpdateAuto'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbCompleteTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportForm'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportCheckForm'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportCheckAmountForm'
        end
        item
          Visible = True
          ItemName = 'bbtMeDoc'
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
          ItemName = 'bbOpenTax'
        end
        item
          Visible = True
          ItemName = 'bbOpenTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbPrint_ReturnIn_by_TaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTaxCorrective_Client'
        end
        item
          Visible = True
          ItemName = 'bbPrintTaxCorrective_Us'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited bbPrint: TdxBarButton
      Action = mactPrint
    end
    object bbPrintTaxCorrective_Client: TdxBarButton [5]
      Action = mactPrint_TaxCorrective_Client
      Category = 0
    end
    object bbPrintTaxCorrective_Us: TdxBarButton [6]
      Action = mactPrint_TaxCorrective_Us
      Category = 0
    end
    object bbTaxCorrective: TdxBarButton
      Action = actTaxCorrective
      Category = 0
    end
    object bbCorrective: TdxBarButton
      Action = actCorrective
      Category = 0
    end
    object bbCompleteTaxCorrective: TdxBarButton
      Action = actCompleteTaxCorrective
      Category = 0
    end
    object bbUnCompleteTaxCorrective: TdxBarButton
      Action = actUnCompleteTaxCorrective
      Category = 0
    end
    object bbSetErasedTaxCorrective: TdxBarButton
      Action = actSetErasedTaxCorrective
      Category = 0
    end
    object bbPrint_ReturnIn_by_TaxCorrective: TdxBarButton
      Action = actPrint_ReturnIn_by_TaxCorrective
      Category = 0
    end
    object bbtMeDoc: TdxBarButton
      Action = mactMeDoc
      Category = 0
    end
    object bbOpenTaxCorrective: TdxBarButton
      Action = actOpenTaxCorrective
      Category = 0
    end
    object bbOpenTax: TdxBarButton
      Action = actOpenTax
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbOpenReportCheckAmountForm: TdxBarButton
      Action = actOpenReportCheckAmountForm
      Category = 0
    end
    object bbOpenReportCheckForm: TdxBarButton
      Action = actOpenReportCheckForm
      Category = 0
    end
    object bbUpdateAuto: TdxBarButton
      Action = actUpdateAuto
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 2
      end>
    Left = 14
    Top = 313
  end
  inherited PopupMenu: TPopupMenu
    Left = 680
    Top = 208
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
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
        Name = 'ReportNameSale'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSaleTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSaleBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportName'
        Value = 'PrintMovement_TaxCorrective'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 248
  end
  inherited StatusGuides: TdsdGuides
    Left = 64
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_TransferDebtIn'
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
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransferDebtIn'
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
        Name = 'inMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberMark'
        Value = Null
        Component = edInvNumberMark
        DataType = ftString
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
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
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
        Name = 'Checked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
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
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
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
        DataType = ftString
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
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractFromId'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractFromName'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractToId'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractToName'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindFromName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindToName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
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
        Name = 'PartnerFromId'
        Value = '0'
        Component = GuidesPartnerFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerFromName'
        Value = ' '
        Component = GuidesPartnerFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentTaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransferDebtIn'
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
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberMark'
        Value = Null
        Component = edInvNumberMark
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
        Name = 'inChecked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = 'False'
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
        Name = 'inChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
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
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractFromId'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractToId'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerFromId'
        Value = '0'
        Component = GuidesPartnerFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 170
    Top = 296
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edInvNumberPartner
      end
      item
        Control = edInvNumberMark
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edPaidKindFrom
      end
      item
        Control = edContractFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPaidKindTo
      end
      item
        Control = edContractTo
      end
      item
        Control = edPartnerFrom
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edChangePercent
      end
      item
        Control = edIsChecked
      end
      item
        Control = ceComment
      end
      item
        Control = edPartner
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 496
    Top = 328
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TransferDebtOut_SetErased'
    Left = 830
    Top = 336
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TransferDebtOut_SetUnErased'
    Left = 758
    Top = 344
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TransferDebtIn'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
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
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 312
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TransferDebtIn'
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInput
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
        Value = 0.000000000000000000
        DataType = ftFloat
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
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 264
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 396
    Top = 196
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 222
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
        Component = PriceListGuides
      end>
    Left = 472
    Top = 272
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 265
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 310
  end
  object PaidKindFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKindFrom
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 64
  end
  object ContractFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractFrom
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 512
    Top = 72
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn_Print'
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
    Left = 319
    Top = 208
  end
  object spGetReportName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn_ReportName'
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
        Name = 'inDescName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_ReturnIn_ReportName'
        Value = 'PrintMovement_TaxCorrective'
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 224
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
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
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 552
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 744
  end
  object PaidKindToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKindTo
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
    Top = 56
  end
  object ContractToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTo
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 64
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 164
    Top = 96
  end
  object GuidesPartnerFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartnerFrom
    Key = '0'
    TextValue = ' '
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPartnerFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ' '
        Component = GuidesPartnerFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 16
  end
  object DocumentTaxKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTaxKind
    FormNameParam.Value = 'TDocumentTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 984
    Top = 72
  end
  object spCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
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
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateTax'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxLink'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 244
  end
  object spTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
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
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateTax'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxLink'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 296
  end
  object spSelectPrintTaxCorrective_Us: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
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
      end
      item
        Name = 'inisClientCopy'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 666
    Top = 306
  end
  object spSelectPrintTaxCorrective_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
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
      end
      item
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 586
    Top = 354
  end
  object TaxCorrectiveCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 768
    Top = 186
  end
  object TaxCorrectiveDS: TDataSource
    DataSet = TaxCorrectiveCDS
    Left = 869
    Top = 186
  end
  object spSelectTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_DocChild'
    DataSet = TaxCorrectiveCDS
    DataSets = <
      item
        DataSet = TaxCorrectiveCDS
      end>
    Params = <
      item
        Name = 'inDocumentMasterId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 930
    Top = 226
  end
  object spMovementSetErasedTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 281
  end
  object spMovementCompleteTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ouStatusCode'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'StatusCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = 'True'
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 329
  end
  object spMovementUnCompleteTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 385
  end
  object gpUpdateTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_DocChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'InvNumberPartner'
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
        Name = 'inMovement_ChildId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'DocumentChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1003
    Top = 202
  end
  object spGetReportNameTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TaxCorrective_ReportName'
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
        Name = 'gpGet_Movement_TaxCorrective_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTaxCorrective'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 344
  end
  object spUpdateIsMedoc: TdsdStoredProc
    StoredProcName = 'gpUpdate_IsMedoc'
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
      end>
    PackSize = 1
    Left = 752
    Top = 264
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    Key = '0'
    TextValue = ' '
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 920
    Top = 16
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 40
    Top = 456
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 104
    Top = 448
  end
  object spSelect_MI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemChild_ReturnIn'
    DataSet = DetailCDS
    DataSets = <
      item
        DataSet = DetailCDS
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
    Left = 200
    Top = 456
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
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
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    SearchAsFilter = False
    Left = 302
    Top = 457
  end
  object spUpdateAuto: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_Auto'
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
        Name = 'inStartDateSale'
        Value = 42181d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 364
  end
end
