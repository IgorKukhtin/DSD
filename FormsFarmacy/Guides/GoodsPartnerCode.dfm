inherited GoodsPartnerCodeForm: TGoodsPartnerCodeForm
  Caption = #1050#1086#1076#1099' '#1087#1088#1086#1076#1072#1074#1094#1086#1074
  ClientHeight = 423
  ClientWidth = 782
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 790
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 782
    Height = 397
    ExplicitWidth = 782
    ExplicitHeight = 397
    ClientRectBottom = 397
    ClientRectRight = 782
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 782
      ExplicitHeight = 397
      inherited cxGrid: TcxGrid
        Width = 377
        Height = 397
        Align = alNone
        ExplicitWidth = 377
        ExplicitHeight = 397
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 324
          end
        end
      end
      object edJuridical: TcxButtonEdit
        Left = 232
        Top = 40
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Width = 121
      end
      object cxLabel1: TcxLabel
        Left = 184
        Top = 40
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      isShowModal = True
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'Code'
          Component = MasterCDS
          ComponentItem = 'Code'
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods'
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 144
    Top = 88
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
          Visible = True
          ItemName = 'bbGridToExcel'
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
          ItemName = 'bbLabel'
        end
        item
          Visible = True
          ItemName = 'bbJuridical'
        end>
    end
    object bbLabel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbJuridical: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edJuridical
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SearchAsFilter = False
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 288
    Top = 92
  end
end
