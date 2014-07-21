inherited MovementLoadForm: TMovementLoadForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1075#1088#1091#1079#1082#1080
  ClientHeight = 399
  ClientWidth = 772
  ExplicitWidth = 788
  ExplicitHeight = 438
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 772
    Height = 371
    ExplicitWidth = 597
    ExplicitHeight = 371
    ClientRectBottom = 367
    ClientRectRight = 768
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 589
      ExplicitHeight = 363
      inherited cxGrid: TcxGrid
        Width = 764
        Height = 363
        ExplicitLeft = -16
        ExplicitWidth = 764
        ExplicitHeight = 363
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object clTotalCount: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clTotalSumm: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object clJuridicalId: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
            DataBinding.FieldName = 'JuridicalId'
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object clUnitId: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'UnitId'
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object clNDSKindId: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindId'
            HeaderAlignmentVert = vaCenter
            Width = 101
          end
          object clIsAllGoodsConcat: TcxGridDBColumn
            Caption = #1057#1086#1086#1090#1074#1077#1090#1089#1090#1074#1080#1103
            DataBinding.FieldName = 'IsAllGoodsConcat'
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 216
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    object actOpenPriceList: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100
      ImageIndex = 1
      FormName = 'TPriceListItemsLoadForm'
      FormNameParam.Value = 'TPriceListItemsLoadForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
        end>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_MovementLoad'
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      28
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpen'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
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
end
