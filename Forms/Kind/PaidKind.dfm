inherited PaidKindForm: TPaidKindForm
  ActiveControl = cxGrid
  Caption = #1058#1080#1087#1099' '#1086#1087#1083#1072#1090
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    ExplicitLeft = 0
    ExplicitTop = 26
    ExplicitWidth = 575
    ExplicitHeight = 282
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        ExplicitTop = 0
        ExplicitHeight = 282
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 252
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Component = MainDataCDS
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Component = MainDataCDS
          ComponentItem = 'Name'
          DataType = ftString
        end>
    end
  end
  inherited spMainData: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PaidKind'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
