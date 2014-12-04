inherited OrderKindForm: TOrderKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1042#1080#1076#1086#1074' '#1079#1072#1082#1072#1079#1072'>'
  ClientHeight = 335
  ClientWidth = 314
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 322
  ExplicitHeight = 362
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 314
    Height = 309
    ExplicitTop = 26
    ExplicitWidth = 314
    ExplicitHeight = 309
    ClientRectBottom = 309
    ClientRectRight = 314
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 314
      ExplicitHeight = 309
      inherited cxGrid: TcxGrid
        Width = 314
        Height = 309
        ExplicitWidth = 314
        ExplicitHeight = 309
        inherited cxGridDBTableView: TcxGridDBTableView
          OnDblClick = nil
          OnKeyDown = nil
          OnKeyPress = nil
          OnCustomDrawCell = nil
          DataController.Filter.OnChanged = nil
          OptionsView.Footer = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object clName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 208
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TOrderKindEditForm'
      FormNameParam.Value = 'TOrderKindEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TOrderKindEditForm'
      FormNameParam.Value = 'TOrderKindEditForm'
    end
  end
  inherited MasterCDS: TClientDataSet
    AfterInsert = nil
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_OrderKind'
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
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
  end
end
