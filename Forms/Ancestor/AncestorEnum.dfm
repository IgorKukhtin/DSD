inherited AncestorEnumForm: TAncestorEnumForm
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.ChoiceAction = ChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxGrid: TcxGrid
    inherited cxGridDBTableView: TcxGridDBTableView
      Styles.Inactive = nil
      Styles.Selection = nil
      Styles.Footer = nil
      Styles.Header = nil
    end
  end
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  inherited ActionList: TActionList
    object ChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      Params = <
        item
          Name = 'Key'
          Component = MainDataCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = MainDataCDS
          ComponentItem = 'Name'
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = MainDataDS
    end
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbChoice: TdxBarButton
      Action = ChoiceGuides
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = ChoiceGuides
      end>
    ActionItemList = <
      item
        Action = ChoiceGuides
        ShortCut = 13
      end>
  end
end
