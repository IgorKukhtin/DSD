object GoogleOTPDialogPswForm: TGoogleOTPDialogPswForm
  Left = 1106
  Top = 458
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 110
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object bbPanel: TPanel
    Left = 0
    Top = 69
    Width = 322
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 0
    ExplicitTop = 55
    object bbOk: TBitBtn
      Left = 44
      Top = 6
      Width = 79
      Height = 25
      Caption = 'OK'
      Default = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = bbOkClick
    end
    object bbCancel: TBitBtn
      Left = 208
      Top = 6
      Width = 79
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PanelNumberValue: TPanel
    Left = 0
    Top = 0
    Width = 322
    Height = 69
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 55
    object LabelNumberValue: TLabel
      Left = 0
      Top = 0
      Width = 205
      Height = 14
      Align = alTop
      Alignment = taCenter
      Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1076' '#1080#1079' Google Authenticator'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object NumberValueEdit: TcxCurrencyEdit
      Left = 102
      Top = 25
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.AssignedValues.DisplayFormat = True
      Properties.DecimalPlaces = 0
      TabOrder = 0
      Width = 135
    end
  end
end
