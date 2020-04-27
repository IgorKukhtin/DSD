inherited LossFundJournalForm: TLossFundJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1057#1087#1080#1089#1072#1085#1080#1077' ('#1088#1072#1073#1086#1090#1072' '#1089' '#1092#1086#1085#1076#1086#1084')>'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    TabOrder = 2
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object SummaFund: TcxGridDBColumn [9]
            Caption = #1057#1091#1084#1084#1072' '#1080#1079' '#1092#1086#1085#1076#1072
            DataBinding.FieldName = 'SummaFund'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TLossFundForm'
      FormNameParam.Value = 'TLossFundForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TLossFundForm'
      FormNameParam.Value = 'TLossFundForm'
    end
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
        end
        item
          DataSet = PrintItemsCDS
        end>
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
