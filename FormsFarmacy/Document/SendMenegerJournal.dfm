inherited SendMenegerJournalForm: TSendMenegerJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'  ('#1084#1077#1085#1077#1076#1078#1077#1088#1099')>'
  ExplicitHeight = 574
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
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSendMenegerForm'
      FormNameParam.Value = 'TSendMenegerForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSendMenegerForm'
      FormNameParam.Value = 'TSendMenegerForm'
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
