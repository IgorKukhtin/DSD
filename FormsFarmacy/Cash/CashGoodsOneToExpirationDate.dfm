inherited CashGoodsOneToExpirationDateForm: TCashGoodsOneToExpirationDateForm
  Caption = #1054#1089#1090#1072#1090#1086#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
  ClientHeight = 336
  ClientWidth = 570
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 586
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 570
    Height = 310
    ExplicitWidth = 570
    ExplicitHeight = 310
    ClientRectBottom = 310
    ClientRectRight = 570
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 570
      ExplicitHeight = 310
      inherited cxGrid: TcxGrid
        Width = 570
        Height = 310
        ExplicitWidth = 570
        ExplicitHeight = 310
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.000'
              Kind = skSum
              Column = SummCard
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1084#1077#1076#1080#1082#1086#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 285
          end
          object SummCard: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Options.Editing = False
            Width = 104
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 256
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 183
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_CashGoodsOneToExpirationDate'
    Params = <
      item
        Name = 'inGoodsID'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 336
    Top = 216
  end
  inherited PopupMenu: TPopupMenu
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 104
  end
end
