inherited Report_GoodsOnJuridicalRemainsForm: TReport_GoodsOnJuridicalRemainsForm
  Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1102#1088' '#1083#1080#1094#1072#1084
  ClientHeight = 338
  ClientWidth = 612
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 634
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 72
    Width = 612
    Height = 266
    TabOrder = 3
    ExplicitTop = 68
    ExplicitWidth = 812
    ExplicitHeight = 270
    ClientRectBottom = 266
    ClientRectRight = 612
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 812
      ExplicitHeight = 270
      inherited cxGrid: TcxGrid
        Width = 612
        Height = 266
        ExplicitWidth = 812
        ExplicitHeight = 270
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaWithVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = JuridicalName
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'JuridicalCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 298
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object SummaWithVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'SummaWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 612
    Height = 46
    ExplicitWidth = 812
    ExplicitHeight = 46
    inherited deStart: TcxDateEdit
      Left = 131
      Top = 4
      ExplicitLeft = 131
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      Visible = False
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 19
      Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095#1072#1083#1086':'
      ExplicitLeft = 19
      ExplicitWidth = 105
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      Visible = False
      ExplicitLeft = 8
      ExplicitTop = 33
    end
  end
  object сbIsDeferredSend: TcxCheckBox [2]
    Left = 234
    Top = -2
    Action = actRefreshIsPartion
    TabOrder = 6
    Width = 295
  end
  object cbIsDeferredReturnOut: TcxCheckBox [3]
    Left = 234
    Top = 18
    Action = actRefreshPartionPrice
    TabOrder = 7
    Width = 263
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081
      Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1074#1086#1079#1074#1088#1072#1090#1086#1074
      Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1074#1086#1079#1074#1088#1072#1090#1086#1074
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsOnJuridicalRemainsDialogForm'
      FormNameParam.Value = 'TReport_GoodsOnJuridicalRemainsDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDeferredSend'
          Value = False
          Component = сbIsDeferredSend
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDeferredReturnOut'
          Value = False
          Component = cbIsDeferredReturnOut
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 168
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsOnJuridicalRemains'
    Params = <
      item
        Name = 'inRemainsDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDeferredSend'
        Value = Null
        Component = сbIsDeferredSend
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDeferredReturnOut'
        Value = Null
        Component = cbIsDeferredReturnOut
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 216
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 144
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
          ItemName = 'bbExecuteDialog'
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
    object bbGoodsPartyReport: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Visible = ivAlways
      ImageIndex = 39
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1086#1074' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1081' '#1090#1086#1074#1072#1088#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1086#1074' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1072#1088#1090#1080#1081' '#1090#1086#1074#1072#1088#1072
      Visible = ivAlways
      ImageIndex = 42
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 424
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 272
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
      end
      item
        Component = deStart
      end>
    Left = 96
    Top = 144
  end
end
