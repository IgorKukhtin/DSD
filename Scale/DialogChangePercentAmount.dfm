inherited DialogChangePercentAmountForm: TDialogChangePercentAmountForm
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
  ClientHeight = 234
  ClientWidth = 330
  OldCreateOrder = True
  Position = poScreenCenter
  OnResize = nil
  ExplicitWidth = 346
  ExplicitHeight = 273
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 193
    Width = 330
    ExplicitTop = 193
    ExplicitWidth = 330
    inherited bbOk: TBitBtn
      Left = 20
      Top = 6
      ExplicitLeft = 20
      ExplicitTop = 6
    end
    inherited bbCancel: TBitBtn
      Left = 233
      Top = 6
      ExplicitLeft = 233
      ExplicitTop = 6
    end
    object btnSaveAll: TBitBtn
      Left = 109
      Top = 6
      Width = 118
      Height = 25
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045
      Default = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        88888888488884088888848C88884870888884C888848C4708888C448848CCC4
        70888888888CCCCC470888888888CCCCC488888108888CCCCC888818708888CC
        C88881891708888C888818999170888888888999991708811188889999918888
        9188888999998889818888889998889888888888898888888888}
      TabOrder = 2
      OnClick = btnSaveAllClick
    end
  end
  object PanelNumberValue: TPanel
    Left = 0
    Top = 96
    Width = 330
    Height = 97
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 69
      Top = 59
      Width = 56
      Height = 14
      Alignment = taCenter
      Caption = '% '#1057#1082#1080#1076#1082#1080':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object rgDiscountAmountPartner: TRadioGroup
      Left = 0
      Top = 0
      Width = 330
      Height = 46
      Align = alTop
      Caption = #1042#1080#1076' '#1089#1082#1080#1076#1082#1080
      Columns = 2
      Items.Strings = (
        #1079#1072' '#1082#1072#1095#1077#1089#1090#1074#1086
        #1079#1072' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1091)
      TabOrder = 0
    end
    object DiscountAmountPartnerEdit: TcxCurrencyEdit
      Left = 131
      Top = 56
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.'
      Properties.Nullable = False
      TabOrder = 1
      OnExit = DiscountAmountPartnerEditExit
      Width = 76
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 330
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 330
      Height = 14
      Align = alTop
      Caption = ' '#1055#1086#1089#1090#1072#1074#1097#1080#1082':'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 67
    end
    object PartnertEdit: TEdit
      Left = 4
      Top = 17
      Width = 280
      Height = 22
      TabOrder = 0
      Text = 'PartnertEdit'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 48
    Width = 330
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label3: TLabel
      Left = 4
      Top = 2
      Width = 36
      Height = 14
      Caption = #8470' '#1076#1086#1082
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 94
      Top = 2
      Width = 100
      Height = 14
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086#1089#1090'. '#8470
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelDateValue: TLabel
      Left = 217
      Top = 2
      Width = 103
      Height = 14
      Alignment = taCenter
      Caption = #1044#1072#1090#1072' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object InvNumberEdit: TEdit
      Left = 4
      Top = 20
      Width = 77
      Height = 22
      ReadOnly = True
      TabOrder = 0
      Text = 'InvNumberEdit'
    end
    object InvNumberPartnerEdit: TEdit
      Left = 87
      Top = 20
      Width = 105
      Height = 22
      ReadOnly = True
      TabOrder = 1
      Text = 'InvNumberPartnerEdit'
    end
    object DateValueEdit: TcxDateEdit
      Left = 217
      Top = 20
      EditValue = 41640d
      Properties.DateButtons = [btnToday]
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 95
    end
  end
  object ActionList: TActionList
    Left = 176
    Top = 8
    object actWeighingPartner_ActDiffF: TdsdInsertUpdateAction
      Category = 'ScaleLib'
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1040#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1040#1082#1090' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1081
      ImageIndex = 43
      FormName = 'TWeighingPartner_ActDiffForm'
      FormNameParam.Value = 'TWeighingPartner_ActDiffForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId_DocPartner'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId_DocPartner'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 80
  end
end
