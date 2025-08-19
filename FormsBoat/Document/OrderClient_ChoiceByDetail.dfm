inherited OrderClient_ChoiceByDetailForm: TOrderClient_ChoiceByDetailForm
  Caption = #1042#1099#1073#1086#1088' '#1091#1079#1083#1072
  ClientHeight = 480
  ClientWidth = 535
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 551
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 535
    Height = 380
    ExplicitTop = 59
    ExplicitWidth = 535
    ExplicitHeight = 380
    ClientRectBottom = 380
    ClientRectRight = 535
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 535
      ExplicitHeight = 380
      inherited cxGrid: TcxGrid
        Width = 535
        Height = 380
        ExplicitWidth = 535
        ExplicitHeight = 380
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Name: TcxGridDBColumn
            Caption = #1059#1079#1077#1083
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 300
          end
          object Article: TcxGridDBColumn
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 152
          end
        end
      end
    end
  end
  object Panel_btn: TPanel [1]
    Left = 0
    Top = 439
    Width = 535
    Height = 41
    Align = alBottom
    TabOrder = 5
    object btnFormClose: TcxButton
      Left = 218
      Top = 8
      Width = 90
      Height = 25
      Action = actFormClose
      TabOrder = 0
    end
    object btnChoiceGuides: TcxButton
      Left = 85
      Top = 8
      Width = 90
      Height = 25
      Action = actChoiceGuides
      TabOrder = 1
    end
    object btnInsert_client: TcxButton
      Left = 534
      Top = 8
      Width = 120
      Height = 25
      Caption = #1050#1083#1080#1077#1085#1090
      OptionsImage.ImageIndex = 48
      TabOrder = 2
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 0
    Width = 535
    Height = 33
    Align = alTop
    TabOrder = 6
    object lbSearchName: TcxLabel
      Left = 6
      Top = 6
      Caption = #1055#1086#1080#1089#1082' '#1059#1079#1077#1083':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchName: TcxTextEdit
      Left = 94
      Top = 7
      TabOrder = 1
      DesignSize = (
        200
        21)
      Width = 200
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderClient_ChoiceByDetail'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Top = 80
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
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbChoice'
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
    object bbInsert_Partner: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 16433
    end
    object bbInsert_client: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 0
      ShortCut = 16434
    end
    object bbUpdate_client: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 1
    end
    object bbLieferanten: TdxBarSubItem
      Caption = 'Lieferanten'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert_Partner'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_partner'
        end>
    end
    object bbKunden: TdxBarSubItem
      Caption = 'Kunden'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert_client'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_client'
        end>
    end
    object bbUpdate_partner: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 1
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
    Top = 176
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchName
    DataSet = MasterCDS
    Column = Name
    ColumnList = <
      item
        Column = Name
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 416
    Top = 112
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 120
  end
end
