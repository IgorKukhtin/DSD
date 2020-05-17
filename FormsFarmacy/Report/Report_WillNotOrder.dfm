inherited Report_WillNotOrderForm: TReport_WillNotOrderForm
  Caption = #1058#1086#1074#1072#1088#1099' '#1082#1086#1090#1086#1088#1099#1077' '#1085#1077' '#1079#1072#1082#1072#1078#1091#1090
  ClientHeight = 375
  ClientWidth = 551
  AddOnFormData.Params = FormParams
  ExplicitWidth = 567
  ExplicitHeight = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 123
    Width = 551
    Height = 252
    TabOrder = 3
    ExplicitTop = 67
    ExplicitWidth = 730
    ExplicitHeight = 308
    ClientRectBottom = 252
    ClientRectRight = 551
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 730
      ExplicitHeight = 308
      inherited cxGrid: TcxGrid
        Width = 551
        Height = 252
        ExplicitWidth = 730
        ExplicitHeight = 308
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1087#1080#1089#1077#1081' 0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsInUnit
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = RemainsSUN
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 225
          end
          object RemainsInUnit: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1090#1086#1095#1082#1077
            DataBinding.FieldName = 'RemainsInUnit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 83
          end
          object RemainsSUN: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1089#1088#1086#1082#1086#1074#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'RemainsSUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object MCS: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 551
    Height = 97
    ExplicitWidth = 730
    ExplicitHeight = 97
    inherited deStart: TcxDateEdit
      Left = 427
      Top = 101
      Visible = False
      ExplicitLeft = 427
      ExplicitTop = 101
    end
    inherited deEnd: TcxDateEdit
      Left = 636
      Top = 101
      Visible = False
      ExplicitLeft = 636
      ExplicitTop = 101
    end
    inherited cxLabel1: TcxLabel
      Left = 336
      Top = 102
      Visible = False
      ExplicitLeft = 336
      ExplicitTop = 102
    end
    inherited cxLabel2: TcxLabel
      Left = 526
      Top = 102
      Visible = False
      ExplicitLeft = 526
      ExplicitTop = 102
    end
    object cxMemo1: TcxMemo
      AlignWithMargins = True
      Left = 4
      Top = 4
      TabStop = False
      Align = alClient
      Lines.Strings = (
        #1042#1053#1048#1052#1040#1053#1048#1045' '#1057#1045#1043#1054#1044#1053#1071' '#1052#1045#1053#1045#1044#1046#1045#1056' '#1053#1045' '#1057#1052#1054#1046#1045#1058' '#1042#1040#1052' '#1057#1044#1045#1051#1040#1058#1068' '#1040#1042#1058#1054#1047#1040#1050#1040#1047' '#1055#1054' '
        #1055#1054#1047#1048#1062#1048#1071#1052' '#1053#1048#1046#1045', '#1044#1054' '#1058#1045#1061' '#1055#1054#1056' '#1055#1054#1050#1040' '#1042#1067' '#1053#1045' '#1055#1056#1054#1044#1040#1044#1048#1058#1045' '#1054#1057#1058#1040#1058#1054#1050' '#1057#1056#1054#1050#1054#1042#1054#1049' '
        #1055#1040#1056#1058#1048#1048'!!'
        #1053#1040#1049#1044#1048#1058#1045' '#1069#1058#1054#1058' '#1058#1054#1042#1040#1056' '#1048' '#1055#1056#1054#1044#1040#1049#1058#1045' '#1045#1043#1054'.')
      ParentColor = True
      ParentFont = False
      Properties.Alignment = taCenter
      Properties.ReadOnly = True
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.TextColor = clRed
      Style.IsFontAssigned = True
      TabOrder = 4
      ExplicitLeft = 184
      ExplicitTop = 28
      ExplicitWidth = 185
      Height = 89
      Width = 543
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_WillNotOrderDialogForm'
      FormNameParam.Value = 'TReport_WillNotOrderDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 296
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Left = 192
    Top = 152
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderInternal_WillNotOrder'
    Params = <
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 448
    Top = 168
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 104
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 80
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 264
  end
end
