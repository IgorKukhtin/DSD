object Report_IncomeConsumptionBalanceForm: TReport_IncomeConsumptionBalanceForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082
  ClientHeight = 660
  ClientWidth = 1329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1329
    Height = 31
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 4
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object Panel2: TPanel
    Left = 1064
    Top = 57
    Width = 265
    Height = 603
    Align = alRight
    ShowCaption = False
    TabOrder = 2
    object Panel3: TPanel
      Left = 1
      Top = 265
      Width = 263
      Height = 337
      Align = alClient
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      object cxgChoiceGoods: TcxGrid
        Left = 0
        Top = 21
        Width = 263
        Height = 285
        Align = alClient
        TabOrder = 0
        object cxgChoiceGoodsDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.Insert.Visible = False
          Navigator.Buttons.Append.Visible = False
          Navigator.Buttons.Delete.Visible = False
          Navigator.Buttons.Edit.Visible = False
          Navigator.Buttons.Post.Visible = False
          Navigator.Buttons.Cancel.Visible = False
          Navigator.Buttons.Refresh.Visible = False
          DataController.DataSource = dsGoods
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          FilterRow.Visible = True
          FilterRow.ApplyChanges = fracImmediately
          Images = dmMain.SortImageList
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.MultiSelect = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.Indicator = True
          object cxgChoiceGoodsDBTableViewColumn1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsId'
            PropertiesClassName = 'TcxTextEditProperties'
            Width = 66
          end
          object cxgChoiceGoodsDBTableViewColumn2: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'GoodsName'
            Options.Editing = False
            Width = 195
          end
        end
        object cxgChoiceGoodsLevel: TcxGridLevel
          Caption = #1052#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099
          GridView = cxgChoiceGoodsDBTableView
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 263
        Height = 21
        Align = alTop
        Caption = #1052#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099
        TabOrder = 1
      end
      object Panel7: TPanel
        Left = 0
        Top = 306
        Width = 263
        Height = 31
        Align = alBottom
        ShowCaption = False
        TabOrder = 2
        object cxButton2: TcxButton
          Left = 1
          Top = 1
          Width = 127
          Height = 29
          Align = alClient
          Action = actSetGoods
          TabOrder = 0
        end
        object cxButton3: TcxButton
          Left = 128
          Top = 1
          Width = 134
          Height = 29
          Align = alRight
          Action = actAddGoods
          TabOrder = 1
        end
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 263
      Height = 256
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel4'
      TabOrder = 1
      object cxgChoicePrpmo: TcxGrid
        Left = 0
        Top = 21
        Width = 263
        Height = 210
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.Insert.Visible = False
          Navigator.Buttons.Append.Visible = False
          Navigator.Buttons.Delete.Visible = False
          Navigator.Buttons.Edit.Visible = False
          Navigator.Buttons.Post.Visible = False
          Navigator.Buttons.Cancel.Visible = False
          Navigator.Buttons.Refresh.Visible = False
          DataController.DataSource = dsPromo
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.Indicator = True
          object cxGridDBColumn1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PromoID'
            PropertiesClassName = 'TcxTextEditProperties'
            Width = 66
          end
          object cxGridDBColumn2: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            Options.Editing = False
            Width = 195
          end
        end
        object cxGridLevel1: TcxGridLevel
          Caption = #1050#1086#1085#1090#1088#1072#1082#1090
          GridView = cxGridDBTableView1
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 263
        Height = 21
        Align = alTop
        Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
        TabOrder = 1
      end
      object cxButton1: TcxButton
        Left = 0
        Top = 231
        Width = 263
        Height = 25
        Align = alBottom
        Action = actSetPromo
        TabOrder = 2
      end
    end
    object cxSplitter2: TcxSplitter
      Left = 1
      Top = 257
      Width = 263
      Height = 8
      AlignSplitter = salTop
      Control = Panel2
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 1056
    Top = 57
    Width = 8
    Height = 603
    AlignSplitter = salRight
    Control = Panel2
  end
  object cxIncomeConsumptionBalance: TcxGrid
    Left = 0
    Top = 57
    Width = 1056
    Height = 603
    Align = alClient
    TabOrder = 7
    object cxIncomeConsumptionBalanceDBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skSum
          Column = colSaldoIn
        end
        item
          Kind = skSum
          Column = colSummaIn
        end
        item
          Kind = skSum
          Column = colAmountIncome
        end
        item
          Kind = skSum
          Column = colAmountIncomeSumWith
        end
        item
          Kind = skSum
          Column = colAmountIncomeSum
        end
        item
          Kind = skSum
          Column = colAmountReturnOut
        end
        item
          Kind = skSum
          Column = colAmountReturnOutSum
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column1
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column2
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column3
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column4
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column5
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column6
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column7
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column8
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column9
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column10
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column11
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column12
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column13
        end
        item
          Kind = skSum
          Column = cxIncomeConsumptionBalanceDBBandedTableView1Column14
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      Bands = <
        item
        end
        item
          Caption = #1052#1077#1076#1080#1082#1072#1084#1077#1085#1090
        end
        item
          Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
        end
        item
          Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        end
        item
          Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
        end
        item
          Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1085#1072' '#1082#1072#1089#1089#1072#1093
        end
        item
          Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1073'/'#1085
        end
        item
          Caption = #1055#1077#1088#1077#1091#1095#1077#1090
        end
        item
          Caption = #1057#1087#1080#1089#1072#1085#1080#1077
        end
        item
          Caption = #1055#1077#1088#1077#1084#1077#1096#1077#1085#1080#1077
        end
        item
          Caption = #1050#1086#1085#1077#1095#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
        end>
      object colParentName: TcxGridDBBandedColumn
        Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
        DataBinding.FieldName = 'ParentName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 140
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colUnitName: TcxGridDBBandedColumn
        Caption = #1040#1087#1090#1077#1082#1072
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 149
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colGoodsId: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsId'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 48
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colGoodsName: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 164
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colSaldoIn: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'SaldoIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colSummaIn: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'SummaIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colAmountIncome: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'AmountIncome'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colAmountIncomeSumWith: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountIncomeSumWith'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 3
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colAmountIncomeSum: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountIncomeSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 3
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colAmountReturnOut: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'AmountReturnOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colAmountReturnOutSum: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountReturnOutSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 4
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column1: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'AmountCheck'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 5
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column2: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1077' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountCheckSumJuridical'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 5
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column3: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountCheckSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 5
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column4: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'AmountSale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 6
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column5: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1079#1072#1082#1091#1087#1082#1077' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountSaleSumJuridical'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 6
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column6: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1079#1077#1072#1083#1080#1079'. '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountSaleSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 6
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column7: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'AmountInventory'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 7
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column8: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountInventorySum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 7
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column9: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'AmountLoss'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 8
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column10: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountLossSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 8
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column11: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'AmountSend'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 9
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column12: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'AmountSendSum'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 9
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column13: TcxGridDBBandedColumn
        Caption = #1082#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1096#1090
        DataBinding.FieldName = 'SaldoOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.000'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 10
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxIncomeConsumptionBalanceDBBandedTableView1Column14: TcxGridDBBandedColumn
        Caption = #1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057', '#1075#1088#1085
        DataBinding.FieldName = 'SummaOut'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 80
        Position.BandIndex = 10
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
    object cxIncomeConsumptionBalanceLevel1: TcxGridLevel
      GridView = cxIncomeConsumptionBalanceDBBandedTableView1
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 144
    Top = 264
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 264
  end
  object cxPropertiesStore: TcxPropertiesStore
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
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 272
    Top = 200
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 144
    Top = 200
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbToExcel: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
    object bbStaticText: TdxBarButton
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint2: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16464
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Action = actSetGoods
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actSetPromo
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Action = actExportExel
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Category = 0
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportExel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxIncomeConsumptionBalance
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
      DefaultFileName = 'IncomeConsumptionBalance'
    end
    object dsdOpenForm1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdOpenForm1'
      FormName = 'TReport_IncomeConsumptionBalanceForm'
      FormNameParam.Value = 'TReport_IncomeConsumptionBalanceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'dsdExecStoredProc1'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actSetGoods: TAction
      Category = 'DSDLib'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      Hint = #1059#1089#1090#1072#1085#1086#1089#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084' '#1085#1072' '#1087#1086#1074#1086#1076' '#1075#1088#1080#1076
      ImageIndex = 33
      OnExecute = actSetGoodsExecute
    end
    object actSetPromo: TAction
      Category = 'DSDLib'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1085#1072' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099
      Hint = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1092#1080#1083#1100#1090#1088' '#1085#1072' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1086#1084#1091' '#1082#1086 +
        #1085#1090#1088#1072#1082#1090#1091
      ImageIndex = 34
      OnExecute = actSetPromoExecute
    end
    object actAddGoods: TAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082' '#1092#1080#1083#1100#1090#1088#1091
      Hint = 
        #1044#1086#1073#1072#1074#1080#1090#1100' '#1082' '#1092#1080#1083#1100#1090#1088#1091' '#1085#1072' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1099' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1086#1084#1091' '#1082 +
        #1086#1085#1090#1088#1072#1082#1090#1091
      ImageIndex = 34
      OnExecute = actAddGoodsExecute
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_IncomeConsumptionBalance'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end
      item
        DataSet = cdsGoods
      end
      item
        DataSet = cdsPromo
      end
      item
        DataSet = cdsPromoGoods
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 264
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 528
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 384
    Top = 56
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 488
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = '01.01.2016'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = '01.01.2016'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 448
    Top = 200
  end
  object dsGoods: TDataSource
    DataSet = cdsGoods
    Left = 144
    Top = 328
  end
  object cdsGoods: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 328
  end
  object dsPromo: TDataSource
    DataSet = cdsPromo
    Left = 144
    Top = 384
  end
  object cdsPromo: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 384
  end
  object cdsPromoGoods: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 448
  end
end
