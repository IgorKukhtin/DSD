inherited ReturnInCashForm: TReturnInCashForm
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    ExplicitWidth = 655
    inherited tsMain: TcxTabSheet
      ExplicitTop = 24
      ExplicitWidth = 655
      inherited cxGrid: TcxGrid
        ExplicitWidth = 655
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
  inherited DataPanel: TPanel
    TabOrder = 2
    inherited ceStatus: TcxButtonEdit
      Enabled = False
    end
  end
  inherited ActionList: TActionList
    inherited actPrint: TdsdPrintAction
      DataSets = <
        item
        end
        item
        end>
    end
    object actCashCloseReturnDialog: TdsdOpenStaticForm
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      Caption = #1055#1077#1095#1072#1090#1100' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1075#1086' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1075#1086' '#1095#1077#1082#1072
      ShortCut = 107
      ImageIndex = 3
      FormName = 'TCashCloseReturnDialogForm'
      FormNameParam.Value = 'TCashCloseReturnDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
          ItemName = 'bbMovementItemContainer'
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
        end
        item
          Visible = True
          ItemName = 'bbApplicationTemplate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbCashCloseReturnDialog'
        end>
    end
    object bbCashCloseReturnDialog: TdxBarButton
      Action = actCashCloseReturnDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
  end
  inherited GuidesUnit: TdsdGuides
    DisableGuidesOpen = True
  end
end
