inherited ConvertRemainsForm: TConvertRemainsForm
  Caption = #1050#1086#1085#1074#1077#1088#1090#1072#1094#1080#1103' '#1086#1089#1090#1072#1090#1082#1086#1074
  ClientHeight = 479
  ClientWidth = 987
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1009
  ExplicitHeight = 535
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 121
    Width = 987
    Height = 358
    ExplicitTop = 121
    ExplicitWidth = 987
    ExplicitHeight = 358
    ClientRectBottom = 358
    ClientRectRight = 987
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 987
      ExplicitHeight = 334
      inherited cxGrid: TcxGrid
        Width = 987
        Height = 326
        ExplicitWidth = 987
        ExplicitHeight = 326
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####;-,0.####; '
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; '
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####;-,0.####; '
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; '
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; '
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; '
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; '
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; '
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; '
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; '
              Kind = skSum
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Number: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Number'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0;-0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 352
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object Measure: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'Measure'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1085#1076#1089
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object UKTZED: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091#1082#1090#1079#1076
            DataBinding.FieldName = 'UKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object VAT: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'VAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object Comment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Color_UKTZED: TcxGridDBColumn
            DataBinding.FieldName = 'Color_UKTZED'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object Color_Code: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Code'
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 326
        Width = 987
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 987
    Height = 89
    TabOrder = 3
    ExplicitWidth = 987
    ExplicitHeight = 89
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 108
      EditValue = 44081d
      Properties.AssignedValues.DisplayFormat = True
      ExplicitLeft = 108
    end
    inherited cxLabel2: TcxLabel
      Left = 108
      ExplicitLeft = 108
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 62
      ExplicitTop = 62
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    object lblUnit: TcxLabel
      Left = 223
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel7: TcxLabel
      Left = 223
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 223
      Top = 62
      Properties.ReadOnly = False
      TabOrder = 8
      Width = 426
    end
    object edUnitName: TcxButtonEdit
      Left = 223
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Width = 426
    end
  end
  inherited ActionList: TActionList
    Left = 215
    Top = 319
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
        end
        item
        end>
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    inherited actAddMask: TdsdExecStoredProc
      AfterAction = actRefresh
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1087#1086#1083#1085#1086#1075#1086' '#1087#1077#1088#1077#1095#1085#1103' '#1087#1086' '#1089#1077#1090#1080
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1087#1086#1083#1085#1086#1075#1086' '#1087#1077#1088#1077#1095#1085#1103' '#1087#1086' '#1089#1077#1090#1080
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
      Hint = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actTotalSumm
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099'?'
      Caption = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object actSelectPrint: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = 'actSelectPrint'
    end
    object actPrintXLS: TdsdExportToXLS
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actSelectPrint
      ItemsDataSet = PrintItemsCDS
      FileName = 'ConvertRemains'
      FileNameParam.Value = 'ConvertRemains'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 3.000000000000000000
      SignHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = [fsBold]
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = [fsBold]
      SignFont.Charset = DEFAULT_CHARSET
      SignFont.Color = clWindowText
      SignFont.Height = -11
      SignFont.Name = 'Tahoma'
      SignFont.Style = []
      ColumnParams = <
        item
          Caption = #1082#1086#1076
          FieldName = 'GoodsCode'
          DataType = ftInteger
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 7
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          FieldName = 'GoodsName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 44
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skText
          KindText = #1048#1090#1086#1075#1086':'
        end
        item
          Caption = #1077#1076'.'#1080#1079#1084
          FieldName = 'Measure'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 5
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1082#1086#1083'-'#1074#1086
          FieldName = 'Amount'
          DataType = ftFloat
          DecimalPlace = 3
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 9
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1094#1077#1085#1072' '#1089' '#1085#1076#1089
          FieldName = 'PriceWithVAT'
          DataType = ftFloat
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 9
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1089#1091#1084#1084' '#1089' '#1085#1076#1089
          FieldName = 'Summa'
          DataType = ftFloat
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 12
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
        end
        item
          Caption = #1082#1086#1076' '#1091#1082#1090#1079#1076
          FieldName = 'UKTZED'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1087#1088#1080#1079#1085#1072#1082' '#1085#1076#1089
          FieldName = 'VAT'
          DataType = ftFloat
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 5
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
      AccelerateDraw = True
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
    end
    object actTotalSumm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTotalSumm
      StoredProcList = <
        item
          StoredProc = spTotalSumm
        end>
      Caption = 'actSelectPrint'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ConvertRemains'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      32
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbactStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 41
    end
    object dxBarButton1: TdxBarButton
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
      Category = 0
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
      Visible = ivAlways
      ImageIndex = 10
    end
    object dxBarButton2: TdxBarButton
      Action = actAddMask
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Visible = ivAlways
      ImageIndex = 1
    end
    object dxBarButton4: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1084#1077#1085#1090#1072#1088#1080#1081' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1057#1059#1053
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1084#1077#1085#1090#1072#1088#1080#1081' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080' '#1057#1059#1053
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdateRedCheck: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1050#1088#1072#1089#1085#1099#1081' '#1095#1077#1082'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1050#1088#1072#1089#1085#1099#1081' '#1095#1077#1082'"'
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbComplete: TdxBarButton
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Category = 0
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Visible = ivAlways
      ImageIndex = 12
    end
    object bbUpdate_Deferred: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1083#1086#1078#1077#1085#1086' '#1074' '#1082#1072#1089#1089#1077'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1054#1090#1083#1086#1078#1077#1085#1086' '#1074' '#1082#1072#1089#1089#1077'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Visible = ivAlways
      ImageIndex = 80
    end
    object dxBarButton5: TdxBarButton
      Action = macStartLoad
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actPrintXLS
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_Code
        ColorValueList = <>
      end
      item
        ColorColumn = UKTZED
        BackGroundValueColumn = Color_UKTZED
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 11
      end>
    SearchAsFilter = False
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentSendId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ConvertRemains'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ConvertRemains'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ConvertRemains'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesUnit
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actRefresh
      end>
    Left = 288
    Top = 216
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edUnitName
      end
      item
      end
      item
        Control = edComment
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 200
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 120
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem_ConvertRemains'
    Left = 550
    Top = 224
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem_ConvertRemains'
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ConvertRemains'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemains_Amount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains_Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentTRID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CommentTRID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isExplanation'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Explanation'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isDeferred'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiffSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiffSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRemains_FactAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains_FactAmount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRemains_FactSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains_FactSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDeficit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Deficit'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDeficitSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DeficitSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outProficit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Proficit'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outProficitSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ProficitSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 320
    Top = 288
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_ConvertRemainsMasc'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 552
    Top = 312
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ConvertRemains_TotalSumm'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummPrimeCost'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 652
    Top = 196
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ConvertRemains_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 391
    Top = 208
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 476
    Top = 206
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 476
    Top = 257
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TConvertRemainsForm;zc_Object_ImportSetting_ConvertRemains'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 160
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitName
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 16
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsSPSearch_1303Form;zc_Object_ImportSetting_GoodsSPSearch_13' +
          '03'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 776
    Top = 240
  end
  object spTotalSumm: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ConvertRemains_TotalSumm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 647
    Top = 312
  end
end
