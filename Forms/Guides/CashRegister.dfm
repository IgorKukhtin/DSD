inherited CashRegisterForm: TCashRegisterForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1072#1089#1089#1086#1074#1099#1093' '#1072#1087#1087#1072#1088#1072#1090#1086#1074'>'
  ClientHeight = 374
  ClientWidth = 769
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 785
  ExplicitHeight = 413
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 769
    Height = 348
    ExplicitWidth = 396
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 769
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 396
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 769
        Height = 348
        ExplicitWidth = 396
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 145
          end
          object SerialNumber: TcxGridDBColumn
            Caption = #1057#1077#1088'. '#1085#1086#1084#1077#1088
            DataBinding.FieldName = 'SerialNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object clCashRegisterKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1082#1072#1089#1089#1099
            DataBinding.FieldName = 'CashRegisterKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object TimePUSHFinal1: TcxGridDBColumn
            Caption = #1042#1077#1095#1077#1088#1085#1077#1077' PUSH 1'
            DataBinding.FieldName = 'TimePUSHFinal1'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'HH:NN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object TimePUSHFinal2: TcxGridDBColumn
            Caption = #1042#1077#1095#1077#1088#1085#1077#1077' PUSH 2'
            DataBinding.FieldName = 'TimePUSHFinal2'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'HH:NN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 203
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Width = 92
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TCashRegisterEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TCashRegisterEditForm'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_CashRegister'
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
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
  end
end
