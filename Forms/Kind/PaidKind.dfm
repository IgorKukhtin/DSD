inherited PaidKindForm: TPaidKindForm
  Caption = #1058#1080#1087#1099' '#1086#1087#1083#1072#1090
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxGrid: TcxGrid
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
        Width = 252
      end
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited ActionList: TActionList
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
        end>
    end
  end
  inherited dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PaidKind'
  end
end
