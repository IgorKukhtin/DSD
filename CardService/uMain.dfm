object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'CardService'
  ClientHeight = 233
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 30
    Height = 16
    Caption = 'Login'
  end
  object Label2: TLabel
    Left = 24
    Top = 54
    Width = 55
    Height = 16
    Caption = 'Password'
  end
  object Label3: TLabel
    Left = 23
    Top = 104
    Width = 56
    Height = 16
    Caption = 'Card num'
  end
  object LabelResult: TLabel
    Left = 360
    Top = 48
    Width = 65
    Height = 16
    Caption = 'LabelResult'
  end
  object Label4: TLabel
    Left = 23
    Top = 144
    Width = 48
    Height = 16
    Caption = 'BarCode'
  end
  object bCheckCard: TButton
    Left = 128
    Top = 176
    Width = 97
    Height = 41
    Caption = 'Check card'
    TabOrder = 0
    OnClick = bCheckCardClick
  end
  object eLogin: TEdit
    Left = 104
    Top = 21
    Width = 121
    Height = 24
    TabOrder = 1
    Text = 'PANI'
  end
  object ePassword: TEdit
    Left = 104
    Top = 51
    Width = 121
    Height = 24
    TabOrder = 2
    Text = 'pass'
  end
  object eCardNum: TEdit
    Left = 104
    Top = 101
    Width = 121
    Height = 24
    TabOrder = 3
    Text = '4820043367665'
    OnChange = eCardNumChange
  end
  object bCheckSale: TButton
    Left = 320
    Top = 176
    Width = 113
    Height = 41
    Caption = 'Check card sale'
    TabOrder = 4
    OnClick = bCheckSaleClick
  end
  object eBarCode: TEdit
    Left = 104
    Top = 144
    Width = 121
    Height = 24
    TabOrder = 5
    Text = '4034541002175'
  end
  object eResult: TEdit
    Left = 256
    Top = 146
    Width = 300
    Height = 24
    TabOrder = 6
    Text = 'eResult'
  end
  object eCardNumRes: TEdit
    Left = 256
    Top = 100
    Width = 300
    Height = 24
    TabOrder = 7
    Text = 'eCardNumRes'
    OnChange = eCardNumChange
  end
  object HTTPRIO1: THTTPRIO
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 600
    Top = 16
  end
end
