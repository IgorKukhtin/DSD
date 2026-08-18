object Report_SoldTable_Commerc_OlapForm: TReport_SoldTable_Commerc_OlapForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1055#1083#1072#1085' '#1092#1072#1082#1090' '#1087#1088#1086#1076#1072#1078#1110' ('#1082#1086#1084#1077#1088#1094#1110#1103')>'
  ClientHeight = 600
  ClientWidth = 1140
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PanelHead: TPanel
    Left = 0
    Top = 0
    Width = 1140
    Height = 159
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 11
      Top = 24
      EditValue = 46023d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 79
    end
    object deEnd: TcxDateEdit
      Left = 11
      Top = 61
      EditValue = 46023d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 79
    end
    object cxLabel1: TcxLabel
      Left = 11
      Top = 7
      Caption = #1055#1077#1088#1080#1086#1076' '#1089':'
    end
    object cxLabel2: TcxLabel
      Left = 11
      Top = 45
      AutoSize = False
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086':'
      Height = 17
      Width = 60
    end
    object cxLabel4: TcxLabel
      Left = 512
      Top = 7
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 512
      Top = 24
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 236
    end
    object cxLabel5: TcxLabel
      Left = 512
      Top = 45
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103':'
    end
    object edInfoMoney: TcxButtonEdit
      Left = 512
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 122
    end
    object edSearchGoodsName: TcxTextEdit
      Left = 128
      Top = 104
      TabOrder = 8
      DesignSize = (
        114
        21)
      Width = 114
    end
    object cxLabel6: TcxLabel
      Left = 5
      Top = 104
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1090#1086#1074#1072#1088#1091':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchContractNumber: TcxTextEdit
      Left = 316
      Top = 104
      TabOrder = 10
      DesignSize = (
        132
        21)
      Width = 132
    end
    object cxLabel7: TcxLabel
      Left = 250
      Top = 104
      Caption = #1044#1086#1075#1086#1074#1110#1088':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel9: TcxLabel
      Left = 460
      Top = 104
      Caption = #1070#1088'.'#1086#1089#1086#1073#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchJuridicalName: TcxTextEdit
      Left = 539
      Top = 104
      TabOrder = 13
      DesignSize = (
        127
        21)
      Width = 127
    end
    object cxLabel11: TcxLabel
      Left = 28
      Top = 131
      Caption = #1058#1086#1088#1075'.'#1084#1077#1088#1077#1078#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchRetailName: TcxTextEdit
      Left = 128
      Top = 131
      TabOrder = 15
      DesignSize = (
        114
        21)
      Width = 114
    end
    object cxLabel8: TcxLabel
      Left = 103
      Top = 7
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edBranch: TcxButtonEdit
      Left = 102
      Top = 24
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 140
    end
    object cxLabel20: TcxLabel
      Left = 103
      Top = 45
      Caption = #1056#1077#1075#1080#1086#1085':'
    end
    object edArea: TcxButtonEdit
      Left = 103
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 140
    end
    object cxLabel3: TcxLabel
      Left = 255
      Top = 45
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object edRetail: TcxButtonEdit
      Left = 255
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 21
      Width = 151
    end
    object edPaidKind: TcxButtonEdit
      Left = 412
      Top = 67
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 81
    end
    object cxLabel12: TcxLabel
      Left = 412
      Top = 51
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object cxLabel13: TcxLabel
      Left = 255
      Top = 7
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 255
      Top = 24
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 25
      Width = 245
    end
    object cxLabel14: TcxLabel
      Left = 639
      Top = 45
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072':'
    end
    object еdTradeMark: TcxButtonEdit
      Left = 639
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 109
    end
    object edSearchPartnerName: TcxTextEdit
      Left = 767
      Top = 104
      TabOrder = 28
      DesignSize = (
        116
        21)
      Width = 116
    end
    object cxLabel15: TcxLabel
      Left = 677
      Top = 104
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
  end
  object cxDBPivotGrid: TcxDBPivotGrid
    Left = 0
    Top = 185
    Width = 1140
    Height = 232
    Align = alClient
    DataSource = MasterDS
    Groups = <>
    OptionsView.RowGrandTotalWidth = 456
    TabOrder = 1
    object pvOperDate: TcxDBPivotGridField
      AreaIndex = 52
      IsCaptionAssigned = True
      Caption = #1044#1072#1090#1072
      DataBinding.FieldName = 'OperDate'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvMonthDate: TcxDBPivotGridField
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1052#1110#1089#1103#1094#1100
      DataBinding.FieldName = 'MonthDate'
      PropertiesClassName = 'TcxDateEditProperties'
      Properties.DisplayFormat = 'mmmm yyyy'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvYear: TcxDBPivotGridField
      AreaIndex = 51
      IsCaptionAssigned = True
      Caption = #1056#1110#1082
      DataBinding.FieldName = 'Year'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvBranchName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1060#1110#1083#1110#1103
      DataBinding.FieldName = 'BranchName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvBranchKAMName: TcxDBPivotGridField
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1060#1110#1083#1110#1103' / '#1050#1040#1052
      DataBinding.FieldName = 'BranchKAMName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvJuridicalName: TcxDBPivotGridField
      AreaIndex = 10
      IsCaptionAssigned = True
      Caption = #1070#1088'.'#1086#1089#1086#1073#1072
      DataBinding.FieldName = 'JuridicalName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvRetailName: TcxDBPivotGridField
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1110#1074#1077#1083#1100#1085#1072' '#1084#1077#1088#1077#1078#1072
      DataBinding.FieldName = 'RetailName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvOKPO: TcxDBPivotGridField
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1054#1050#1055#1054
      DataBinding.FieldName = 'OKPO'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvSectionName: TcxDBPivotGridField
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1057#1077#1075#1084#1077#1085#1090
      DataBinding.FieldName = 'SectionName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvContractCode: TcxDBPivotGridField
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1076#1086#1075'.'
      DataBinding.FieldName = 'ContractCode'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvContractNumber: TcxDBPivotGridField
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1044#1086#1075#1086#1074#1110#1088
      DataBinding.FieldName = 'ContractNumber'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvContractTagGroupName: TcxDBPivotGridField
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1072' '#1086#1079#1085#1072#1082#1072' '#1076#1086#1075'.'
      DataBinding.FieldName = 'ContractTagGroupName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvContractTagName: TcxDBPivotGridField
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1054#1079#1085#1072#1082#1072' '#1076#1086#1075'.'
      DataBinding.FieldName = 'ContractTagName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvAreaName: TcxDBPivotGridField
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1056#1077#1075#1110#1086#1085
      DataBinding.FieldName = 'AreaName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPartnerCode: TcxDBPivotGridField
      AreaIndex = 13
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      DataBinding.FieldName = 'PartnerCode'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPartnerId: TcxDBPivotGridField
      AreaIndex = 14
      IsCaptionAssigned = True
      Caption = #1050#1083#1102#1095'-2'
      DataBinding.FieldName = 'PartnerID'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPartnerName: TcxDBPivotGridField
      AreaIndex = 11
      IsCaptionAssigned = True
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
      DataBinding.FieldName = 'PartnerName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvTypeCommercName: TcxDBPivotGridField
      AreaIndex = 15
      IsCaptionAssigned = True
      Caption = #1058#1080#1087' '#1074#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
      DataBinding.FieldName = 'TypeCommercName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvCityKindName: TcxDBPivotGridField
      AreaIndex = 16
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1085'.'#1087'.'
      DataBinding.FieldName = 'CityKindName'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvCityName: TcxDBPivotGridField
      AreaIndex = 17
      IsCaptionAssigned = True
      Caption = #1053#1072#1089#1077#1083#1077#1085#1080#1081' '#1087#1091#1085#1082#1090
      DataBinding.FieldName = 'CityName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvAddress: TcxDBPivotGridField
      AreaIndex = 18
      IsCaptionAssigned = True
      Caption = #1040#1076#1088#1077#1089#1072
      DataBinding.FieldName = 'Address'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPartnerCategory: TcxDBPivotGridField
      AreaIndex = 12
      IsCaptionAssigned = True
      Caption = #1050#1072#1090#1077#1075#1086#1088#1110#1103' '#1058#1058
      DataBinding.FieldName = 'PartnerCategory'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPartnerTagName: TcxDBPivotGridField
      AreaIndex = 19
      IsCaptionAssigned = True
      Caption = #1054#1079#1085#1072#1082#1072' '#1058#1058
      DataBinding.FieldName = 'PartnerTagName'
      Visible = True
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_1: TcxDBPivotGridField
      AreaIndex = 21
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-1'
      DataBinding.FieldName = 'PersonalName_1'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_2: TcxDBPivotGridField
      AreaIndex = 22
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-2'
      DataBinding.FieldName = 'PersonalName_2'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_3: TcxDBPivotGridField
      AreaIndex = 23
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-3'
      DataBinding.FieldName = 'PersonalName_3'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_4: TcxDBPivotGridField
      AreaIndex = 24
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-4'
      DataBinding.FieldName = 'PersonalName_4'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_5: TcxDBPivotGridField
      AreaIndex = 25
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-5'
      DataBinding.FieldName = 'PersonalName_5'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_6: TcxDBPivotGridField
      AreaIndex = 26
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-6'
      DataBinding.FieldName = 'PersonalName_6'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_1: TcxDBPivotGridField
      AreaIndex = 27
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-1'
      DataBinding.FieldName = 'PositionName_1'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_2: TcxDBPivotGridField
      AreaIndex = 28
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-2'
      DataBinding.FieldName = 'PositionName_2'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_3: TcxDBPivotGridField
      AreaIndex = 29
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-3'
      DataBinding.FieldName = 'PositionName_3'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_4: TcxDBPivotGridField
      AreaIndex = 30
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-4'
      DataBinding.FieldName = 'PositionName_4'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_5: TcxDBPivotGridField
      AreaIndex = 31
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-5'
      DataBinding.FieldName = 'PositionName_5'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_6: TcxDBPivotGridField
      AreaIndex = 32
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-6'
      DataBinding.FieldName = 'PositionName_6'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_1: TcxDBPivotGridField
      AreaIndex = 33
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-1'
      DataBinding.FieldName = 'UnitName_1'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_2: TcxDBPivotGridField
      AreaIndex = 34
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-2'
      DataBinding.FieldName = 'UnitName_2'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_3: TcxDBPivotGridField
      AreaIndex = 35
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-3'
      DataBinding.FieldName = 'UnitName_3'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_4: TcxDBPivotGridField
      AreaIndex = 36
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-4'
      DataBinding.FieldName = 'UnitName_4'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_5: TcxDBPivotGridField
      AreaIndex = 37
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-5'
      DataBinding.FieldName = 'UnitName_5'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_6: TcxDBPivotGridField
      AreaIndex = 38
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-6'
      DataBinding.FieldName = 'UnitName_6'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_1ret: TcxDBPivotGridField
      AreaIndex = 39
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-1 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'PersonalName_1ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_21ret: TcxDBPivotGridField
      AreaIndex = 40
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-2 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'PersonalName_2ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPersonalName_3ret: TcxDBPivotGridField
      AreaIndex = 41
      IsCaptionAssigned = True
      Caption = #1055#1030#1041' '#1056'-3 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'PersonalName_3ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_1ret: TcxDBPivotGridField
      AreaIndex = 42
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-1 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'PositionName_1ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_2ret: TcxDBPivotGridField
      AreaIndex = 43
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-2 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'PositionName_2ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvPositionName_3ret: TcxDBPivotGridField
      AreaIndex = 44
      IsCaptionAssigned = True
      Caption = #1055#1086#1089#1072#1076#1072' '#1056'-3 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'PositionName_3ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_1ret: TcxDBPivotGridField
      AreaIndex = 45
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-1 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'UnitName_1ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_2ret: TcxDBPivotGridField
      AreaIndex = 46
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-2 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'UnitName_2ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvUnitName_3ret: TcxDBPivotGridField
      AreaIndex = 47
      IsCaptionAssigned = True
      Caption = #1055#1110#1076#1088#1086#1079#1076#1110#1083' '#1056'-3 ('#1084#1077#1088#1077#1078#1110')'
      DataBinding.FieldName = 'UnitName_3ret'
      UniqueName = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object pvTradeMarkName: TcxDBPivotGridField
      AreaIndex = 56
      IsCaptionAssigned = True
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
      DataBinding.FieldName = 'TradeMarkName'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupNameFull: TcxDBPivotGridField
      AreaIndex = 53
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
      DataBinding.FieldName = 'GoodsGroupNameFull'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvGoodsGroupName: TcxDBPivotGridField
      AreaIndex = 54
      IsCaptionAssigned = True
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsGroupName'
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsCode: TcxDBPivotGridField
      AreaIndex = 49
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' '#1090#1086#1074'.'
      DataBinding.FieldName = 'GoodsCode'
      Width = 50
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088
      DataBinding.FieldName = 'GoodsName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsGroupDirectionName: TcxDBPivotGridField
      AreaIndex = 57
      IsCaptionAssigned = True
      Caption = #1040#1085#1072#1083#1110#1090#1080#1095#1085#1072' '#1043#1088#1091#1087#1087#1072
      DataBinding.FieldName = 'GoodsGroupDirectionName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsName_ukr: TcxDBPivotGridField
      AreaIndex = 58
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088' ('#1091#1082#1088'.)'
      DataBinding.FieldName = 'GoodsName_ukr'
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsKindName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
      DataBinding.FieldName = 'GoodsKindName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvMeasureName: TcxDBPivotGridField
      Area = faRow
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1045#1076'. '#1080#1079#1084'.'
      DataBinding.FieldName = 'MeasureName'
      Visible = True
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsCode_basis: TcxDBPivotGridField
      AreaIndex = 50
      IsCaptionAssigned = True
      Caption = #1050#1086#1076' ('#1094#1077#1093')'
      DataBinding.FieldName = 'GoodsCode_basis'
      Width = 50
      UniqueName = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object pvGoodsName_basis: TcxDBPivotGridField
      AreaIndex = 66
      IsCaptionAssigned = True
      Caption = #1058#1086#1074#1072#1088' ('#1094#1077#1093')'
      DataBinding.FieldName = 'GoodsName_basis'
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvGoodsKindName_basis: TcxDBPivotGridField
      AreaIndex = 59
      IsCaptionAssigned = True
      Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1094#1077#1093')'
      DataBinding.FieldName = 'GoodsKindName_basis'
      Width = 150
      UniqueName = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
    end
    object pvMeasureName_basis: TcxDBPivotGridField
      AreaIndex = 55
      IsCaptionAssigned = True
      Caption = #1045#1076'. '#1080#1079#1084'. ('#1094#1077#1093')'
      DataBinding.FieldName = 'MeasureName_basis'
      UniqueName = #1057#1086#1089#1090#1072#1074
    end
    object pvInfoMoneyName: TcxDBPivotGridField
      AreaIndex = 48
      IsCaptionAssigned = True
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      DataBinding.FieldName = 'InfoMoneyName'
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvPaidKindName: TcxDBPivotGridField
      AreaIndex = 20
      IsCaptionAssigned = True
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1080
      DataBinding.FieldName = 'PaidKindName'
      Visible = True
      Width = 55
      UniqueName = #1050#1086#1083'-'#1074#1086' '#1044#1086#1083#1075'.'
    end
    object pvReturn_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 0
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088', '#1074#1077#1089' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Return_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvReturn_Summ: TcxDBPivotGridField
      AreaIndex = 61
      IsCaptionAssigned = True
      Caption = #1042#1086#1079#1074#1088', '#1075#1088#1085' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Return_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_Weight_noPromo: TcxDBPivotGridField
      Area = faData
      AreaIndex = 1
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076' '#1073#1077#1079' '#1040#1082#1094#1080#1081', '#1074#1077#1089' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Sale_Weight_noPromo'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_Summ_NoPromo: TcxDBPivotGridField
      AreaIndex = 60
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076' '#1073#1077#1079' '#1040#1082#1094#1080#1081', '#1075#1088#1085' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Sale_Summ_NoPromo'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvPromo_Weight: TcxDBPivotGridField
      Area = faData
      AreaIndex = 2
      IsCaptionAssigned = True
      Caption = #1040#1082#1094#1080#1080', '#1074#1077#1089' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Promo_Weight'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvPromo_Summ: TcxDBPivotGridField
      AreaIndex = 62
      IsCaptionAssigned = True
      Caption = #1040#1082#1094#1080#1080', '#1075#1088#1085' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Promo_Summ'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_Weight_noReturn: TcxDBPivotGridField
      Area = faData
      AreaIndex = 3
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'., '#1074#1077#1089' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Sale_Weight_noReturn'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_Summ_NoReturn: TcxDBPivotGridField
      AreaIndex = 63
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'., '#1075#1088#1085' ('#1060#1040#1050#1058')'
      DataBinding.FieldName = 'Sale_Summ_NoReturn'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_Summ_plan: TcxDBPivotGridField
      Area = faData
      AreaIndex = 5
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'., '#1075#1088#1085' ('#1055#1051#1040#1053')'
      DataBinding.FieldName = 'Sale_Summ_plan'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSale_weight_plan: TcxDBPivotGridField
      Area = faData
      AreaIndex = 4
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076'. '#1073#1077#1079' '#1074#1086#1079#1074#1088'., '#1074#1077#1089' ('#1055#1051#1040#1053')'
      DataBinding.FieldName = 'Sale_weight_plan'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvPromo_weight_plan: TcxDBPivotGridField
      Area = faData
      AreaIndex = 6
      IsCaptionAssigned = True
      Caption = #1040#1082#1094#1080#1080', '#1074#1077#1089' ('#1055#1051#1040#1053')'
      DataBinding.FieldName = 'Promo_weight_plan'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvPromo_Summ_plan: TcxDBPivotGridField
      Area = faData
      AreaIndex = 7
      IsCaptionAssigned = True
      Caption = #1040#1082#1094#1080#1080', '#1075#1088#1085' ('#1055#1051#1040#1053')'
      DataBinding.FieldName = 'Promo_Summ_plan'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSaleNoPromo_weight_plan: TcxDBPivotGridField
      Area = faData
      AreaIndex = 8
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076' '#1073#1077#1079' '#1040#1082#1094#1080#1081', '#1074#1077#1089' ('#1055#1051#1040#1053')'
      DataBinding.FieldName = 'SaleNoPromo_weight_plan'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvSaleNoPromo_Summ_plan: TcxDBPivotGridField
      Area = faData
      AreaIndex = 9
      IsCaptionAssigned = True
      Caption = #1055#1088#1086#1076' '#1073#1077#1079' '#1040#1082#1094#1080#1081', '#1075#1088#1085' ('#1055#1051#1040#1053')'
      DataBinding.FieldName = 'SaleNoPromo_Summ_plan'
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      Width = 80
      UniqueName = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
    end
    object pvPersentWeight: TcxDBPivotGridField
      AreaIndex = 64
      IsCaptionAssigned = True
      Caption = '% '#1074#1080#1082#1086#1085#1072#1085#1085#1103', '#1082#1075
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097'.'
    end
    object pvPersentSumm: TcxDBPivotGridField
      AreaIndex = 65
      IsCaptionAssigned = True
      Caption = '% '#1074#1080#1082#1086#1085#1072#1085#1085#1103', '#1075#1088#1085
      PropertiesClassName = 'TcxCurrencyEditProperties'
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
      Styles.ColumnHeader = dmMain.cxRemainsContentStyle
      Visible = True
      UniqueName = '% '#1074#1080#1082#1086#1085#1072#1085#1085#1103', '#1075#1088#1085
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 417
    Width = 1140
    Height = 183
    Align = alBottom
    TabOrder = 3
    Visible = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
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
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = 'C'#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Goods_Search
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 111
      end
      object Goods_Search: TcxGridDBColumn
        Caption = #1082#1086#1076' -'#1058#1086#1074#1072#1088' '
        DataBinding.FieldName = 'Goods_Search'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 157
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 33
      end
      object GoodsName_basis: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088' '#1094#1077#1093
        DataBinding.FieldName = 'GoodsName_basis'
        Width = 70
      end
      object cxJuridicalName: TcxGridDBColumn
        Caption = #1070#1088'. '#1086#1089#1086#1073#1072
        DataBinding.FieldName = 'JuridicalName'
      end
      object RetailName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
        DataBinding.FieldName = 'RetailName'
        Width = 70
      end
      object ContractNumber: TcxGridDBColumn
        Caption = #1044#1086#1075#1086#1074#1110#1088
        DataBinding.FieldName = 'ContractNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 42
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object PartnerName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
        DataBinding.FieldName = 'PartnerName'
        Width = 70
      end
      object Member_Search: TcxGridDBColumn
        Caption = #1060#1048#1054' ('#1091#1088#1086#1074#1085#1080')'
        DataBinding.FieldName = 'Member_Search'
        Width = 70
      end
      object Position_Search: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1091#1088#1086#1074#1085#1080')'
        DataBinding.FieldName = 'Position_Search'
        Width = 70
      end
      object Unit_Search: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1091#1088#1086#1074#1085#1080')'
        DataBinding.FieldName = 'Unit_Search'
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object edSearchMember: TcxTextEdit
    Left = 316
    Top = 131
    TabOrder = 4
    DesignSize = (
      132
      21)
    Width = 132
  end
  object cxLabel10: TcxLabel
    Left = 278
    Top = 130
    Caption = #1055#1030#1041':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchUnit: TcxTextEdit
    Left = 767
    Top = 131
    TabOrder = 7
    DesignSize = (
      116
      21)
    Width = 116
  end
  object cxLabel16: TcxLabel
    Left = 696
    Top = 130
    Caption = #1055#1110#1076#1088#1086#1079#1110#1083':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchPosition: TcxTextEdit
    Left = 539
    Top = 131
    TabOrder = 11
    DesignSize = (
      127
      21)
    Width = 127
  end
  object cxLabel17: TcxLabel
    Left = 475
    Top = 130
    Caption = #1055#1086#1089#1072#1076#1072':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 832
    Top = 24
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 952
    Top = 32
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
      end
      item
        Component = GuidesGoodsGroup
        Properties.Strings = (
          'key'
          'TextValue')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 1008
    Top = 24
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
    Left = 952
    Top = 88
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
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
      Action = actExportToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 792
    Top = 88
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxDBPivotGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_SoldTable_Commerc_OlapDialogForm'
      FormNameParam.Value = 'TReport_SoldTable_Commerc_OlapDialogForm'
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
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GuidesGoodsGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = ''
          Component = GuidesInfoMoney
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = ''
          Component = GuidesInfoMoney
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AreaId'
          Value = Null
          Component = GuidesArea
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AreaName'
          Value = Null
          Component = GuidesArea
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkId'
          Value = Null
          Component = GuidesTradeMark
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkName'
          Value = Null
          Component = GuidesTradeMark
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_SoldTable_Commerc_Olap'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTradeMarkId'
        Value = Null
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 72
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 1048
    Top = 104
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 56
    Top = 32
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesGoodsGroup
      end
      item
        Component = GuidesInfoMoney
      end
      item
        Component = GuidesArea
      end
      item
        Component = GuidesBranch
      end
      item
        Component = GuidesJuridical
      end
      item
        Component = GuidesPaidKind
      end
      item
        Component = GuidesRetail
      end
      item
        Component = GuidesTradeMark
      end>
    Left = 1080
    Top = 24
  end
  object PivotAddOn: TPivotAddOn
    ErasedFieldName = 'isErased'
    PivotGrid = cxDBPivotGrid
    OnDblClickActionList = <>
    ActionItemList = <>
    ColorRuleList = <>
    SummaryList = <>
    Left = 776
    Top = 16
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 888
    Top = 24
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
  end
  object cfPersentWeight: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPersentWeight
    GridFields = <
      item
        Field = pvSale_Weight_noReturn
      end
      item
        Field = pvSale_weight_plan
      end>
    CalcFieldsType = cfDivision
    Left = 704
    Top = 488
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 565
    Top = 46
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchGoodsName
    DataSet = MasterCDS
    Column = Goods_Search
    ColumnList = <
      item
        Column = Goods_Search
      end
      item
        Column = cxJuridicalName
        TextEdit = edSearchJuridicalName
      end
      item
        Column = RetailName
        TextEdit = edSearchRetailName
      end
      item
        Column = ContractNumber
        TextEdit = edSearchContractNumber
      end
      item
        Column = PartnerName
        TextEdit = edSearchPartnerName
      end
      item
        Column = Position_Search
        TextEdit = edSearchPosition
      end
      item
        Column = Unit_Search
        TextEdit = edSearchUnit
      end
      item
        Column = Member_Search
        TextEdit = edSearchMember
      end>
    CheckBoxList = <>
    Left = 608
    Top = 88
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 37
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 316
    Top = 45
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    Key = '0'
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 8
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 48
  end
  object GuidesTradeMark: TdsdGuides
    KeyField = 'Id'
    LookupControl = еdTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTradeMark
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 680
    Top = 42
  end
  object cfPersentSumm: TdsdPivotGridCalcFields
    PivotGrid = cxDBPivotGrid
    CalcField = pvPersentSumm
    GridFields = <
      item
        Field = pvSale_Summ_NoReturn
      end
      item
        Field = pvSale_Summ_plan
      end>
    CalcFieldsType = cfDivision
    Left = 808
    Top = 480
  end
end
