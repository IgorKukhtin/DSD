object ScreenKeyboardForm: TScreenKeyboardForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = #1045#1082#1088#1072#1085#1085#1072' '#1082#1083#1072#1074#1110#1072#1090#1091#1088#1072
  ClientHeight = 189
  ClientWidth = 558
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object TouchKeyboard: TTouchKeyboard
    Left = 4
    Top = 4
    Width = 550
    Height = 180
    Color = clWhite
    GradientEnd = clWhite
    GradientStart = clWhite
    Layout = 'Standard'
    ParentColor = False
    CustomCaptionOverrides = {
      01000000060000000200000012520069006700680074004300740072006C0002
      200002000000105200690067006800740041006C007400022000020000000E4C
      0065006600740041006C00740002200002000000104C00650066007400430074
      0072006C00022000020000000843006100700073000220000200000006540061
      006200022000}
  end
  object TextEdit: TEdit
    Left = 8
    Top = 194
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'TextEdit'
    OnKeyPress = TextEditKeyPress
  end
  object UpdateTimer: TTimer
    Interval = 50
    OnTimer = UpdateTimerTimer
    Left = 288
    Top = 48
  end
end
