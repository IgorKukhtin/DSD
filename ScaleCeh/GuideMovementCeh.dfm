object GuideMovementCehForm: TGuideMovementCehForm
  Left = 578
  Top = 242
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')>'
  ClientHeight = 572
  ClientWidth = 1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object GridPanel: TPanel
    Left = 0
    Top = 41
    Width = 1091
    Height = 531
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 1091
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object ButtonExit: TSpeedButton
        Left = 326
        Top = 4
        Width = 31
        Height = 29
        Action = actExit
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888808077708888888880807770880800008080777088888880008077
          7088888880088078708800808000807770888888000000777088888888008007
          7088888880008077708888888800800770888888888880000088888888888888
          8888888888884444888888888888488488888888888844448888}
        ParentShowHint = False
        ShowHint = True
      end
      object bbRefresh: TSpeedButton
        Left = 18
        Top = 3
        Width = 31
        Height = 29
        Action = actRefresh
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777000000
          00007777770FFFFFFFF000700000FF0F00F0E00BFBFB0FFFFFF0E0BFBF000FFF
          F0F0E0FBFBFBF0F00FF0E0BFBF00000B0FF0E0FBFBFBFBF0FFF0E0BF0000000F
          FFF0000BFB00B0FF00F07770000B0FFFFFF0777770B0FFFF000077770B0FF00F
          0FF07770B00FFFFF0F077709070FFFFF00777770770000000777}
        ParentShowHint = False
        ShowHint = True
      end
      object bbChoice: TSpeedButton
        Left = 86
        Top = 3
        Width = 31
        Height = 29
        Action = actChoice
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888888888888888888888888888888888888873333333333338887BB3B33B3B3
          B38887B3B3B13B3B3388873B3B9913B3B38887B3B399973B3388873B397B9973
          B38887B397BBB997338887FFFFFFFF91BB8888FBBBBB88891888888FFFF88888
          9188888888888888898888888888888888988888888888888888}
        ParentShowHint = False
        ShowHint = True
      end
      object bbPrint: TSpeedButton
        Left = 433
        Top = 3
        Width = 31
        Height = 29
        Hint = #1055#1077#1095#1072#1090#1100
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000000788888077777777777888788888888887
          778878888889F9F7708878888888888777787FFFFFFFFFF7777887F0000000FF
          7778887FFFFFFF0FF7788887F888880777888888788888F8888888888F888880
          8888888887777777888888888888888888888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbPrintClick
      end
      object bbViewMI: TSpeedButton
        Left = 248
        Top = 3
        Width = 31
        Height = 29
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888880000000000000888FBFBFBFBFBFB088878BFBFBFBFBF088808FBFBFBFB
          FB0888FFBFBFBFBFBF088878FBFBFBFBFB088808BFBFBFBFBF0888FBFBFBFBFB
          FB088878BFBFBFBFBF088808FBFBFBFBFB0888FFBFBFBFBFBF088878FBFBFBFB
          FB088808BFBFBFBFBF0888FBFBFBFBFBFB088877777777777778}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbViewMIClick
      end
    end
    object cxDBGrid: TcxGrid
      Left = 0
      Top = 33
      Width = 1091
      Height = 498
      Align = alClient
      TabOrder = 1
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalCountTare
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalCountTare
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object StartWeighing: TcxGridDBColumn
          Caption = #1053#1072#1095'. '#1074#1079#1074#1077#1096'.'
          DataBinding.FieldName = 'StartWeighing'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object EndWeighing: TcxGridDBColumn
          Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'.'
          DataBinding.FieldName = 'EndWeighing'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object Status: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
          DataBinding.FieldName = 'StatusCode'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 11
              Value = 1
            end
            item
              Description = #1055#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 12
              Value = 2
            end
            item
              Description = #1059#1076#1072#1083#1077#1085
              ImageIndex = 13
              Value = 3
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object isProductionIn: TcxGridDBColumn
          Caption = #1055#1088#1080#1093#1086#1076
          DataBinding.FieldName = 'isProductionIn'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object MovementDescNumber: TcxGridDBColumn
          Caption = #8470' '#1086#1087#1077#1088'.'
          DataBinding.FieldName = 'MovementDescNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object MovementDescName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          DataBinding.FieldName = 'MovementDescName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object DocumentKindName: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          DataBinding.FieldName = 'DocumentKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object OperDate_parent: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
          DataBinding.FieldName = 'OperDate_parent'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object OperDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
          DataBinding.FieldName = 'OperDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object InvNumber: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'.'
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InvNumber_parent: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
          DataBinding.FieldName = 'InvNumber_parent'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object PartionGoods: TcxGridDBColumn
          Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
          DataBinding.FieldName = 'PartionGoods'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object WeighingNumber: TcxGridDBColumn
          Caption = #8470' '#1074#1079#1074#1077#1096'.'
          DataBinding.FieldName = 'WeighingNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object FromName: TcxGridDBColumn
          Caption = #1054#1090' '#1082#1086#1075#1086
          DataBinding.FieldName = 'FromName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object ToName: TcxGridDBColumn
          Caption = #1050#1086#1084#1091
          DataBinding.FieldName = 'ToName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object UserName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          DataBinding.FieldName = 'UserName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object TotalCount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086
          DataBinding.FieldName = 'TotalCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object TotalCountTare: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
          DataBinding.FieldName = 'TotalCountTare'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object SubjectDocName: TcxGridDBColumn
          Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'SubjectDocName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
          Options.Editing = False
          Width = 80
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object ParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 1091
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object gbInvNumber_parent: TGroupBox
      Left = 280
      Top = 0
      Width = 137
      Height = 41
      Align = alLeft
      Caption = #8470' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
      TabOrder = 0
      object EditInvNumber_parent: TEdit
        Left = 5
        Top = 17
        Width = 125
        Height = 22
        TabOrder = 0
        Text = 'EditInvNumber_parent'
        OnChange = EditInvNumber_parentChange
      end
    end
    object GroupBox1: TGroupBox
      Left = 140
      Top = 0
      Width = 140
      Height = 41
      Align = alLeft
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
      TabOrder = 1
      object deEnd: TcxDateEdit
        Left = 7
        Top = 16
        EditValue = 42005d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        Properties.OnChange = deEndPropertiesChange
        TabOrder = 0
        Width = 110
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 140
      Height = 41
      Align = alLeft
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072
      TabOrder = 2
      object deStart: TcxDateEdit
        Left = 7
        Top = 16
        EditValue = 42005d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        Properties.OnChange = deStartPropertiesChange
        TabOrder = 0
        Width = 110
      end
    end
    object cbPrintMovement: TCheckBox
      Left = 560
      Top = 20
      Width = 86
      Height = 17
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = cbPrintMovementClick
    end
    object cbPrintTransport: TCheckBox
      Left = 656
      Top = 20
      Width = 48
      Height = 17
      Caption = #1058#1058#1053
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Visible = False
    end
    object cbPrintPreview: TCheckBox
      Left = 433
      Top = 20
      Width = 121
      Height = 17
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1077#1095#1072#1090#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 320
    Top = 336
  end
  object spSelect: TdsdStoredProc
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 264
    Top = 296
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    OnFilterRecord = CDSFilterRecord
    Left = 272
    Top = 384
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxDBGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoice
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 408
    Top = 392
  end
  object ActionList: TActionList
    Left = 384
    Top = 168
    object actRefresh: TAction
      Category = 'ScaleLib'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      OnExecute = actRefreshExecute
    end
    object actChoice: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103
      OnExecute = actChoiceExecute
    end
    object actExit: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actViewMI: TdsdInsertUpdateAction
      Category = 'ScaleLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      FormName = 'TWeighingPartnerForm'
      FormNameParam.Value = 'TWeighingPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 184
  end
end
