-- Function: gpSelect_Movement_Promo_Message()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo_Message (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo_Message(
    IN inOperDate      TDateTime , -- ���� ���������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (isSend               Boolean
             , AreaName             TVarChar  -- ������
             , AreaName_all         TBlob     -- ������
             , OperDate_message     TDateTime
             , TelegramId           TVarChar
             , TelegramBotToken     TVarChar
             , Msg                  TBlob     -- ������
             , isStartSale          Boolean
             , isStartPromo         Boolean
             , MovementId           Integer   -- �� ��������� �����
             , InvNumber            Integer   -- � ��������� �����
             , OperDate             TDateTime --
             , DateStartSale        TDateTime -- ���� �������� �� ��������� �����
             , DeteFinalSale        TDateTime -- ���� �������� �� ��������� �����
             , DateStartPromo       TDateTime -- ���� ���������� �����
             , DateFinalPromo       TDateTime -- ���� ���������� �����
             , RetailName           TBlob     -- ����, � ������� �������� �����
             , TradeMarkName        TVarChar  -- �������� �����
             , GoodsId              Integer
             , GoodsCode            Integer   -- ��� �������
             , GoodsName            TVarChar  -- �������
             , GoodsKindName        TVarChar  -- ������������ ������� <��� ������>
             , GoodsKindCompleteName TVarChar -- ������������ ������� <��� ������(����������)>
             , MeasureName          TVarChar  -- ������� ���������
             , PriceWithVAT         TFloat    -- ����������� ��������� ���� � ������ ���, ���
             , Price                TFloat    -- * ���� ������������ � ���, ���
             , CostPromo            TFloat    -- * ��������� �������
             , PriceSale            TFloat    -- * ���� �� �����/������ ��� ����������
             , AdvertisingName      TBlob     -- * �������.���������
             , Comment              TVarChar  -- ����������
             , CommentMain          TVarChar  --
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    
    -- ���������
    RETURN QUERY
      -- ���������
      SELECT TRUE :: Boolean AS isSend
             
           , 'AreaName'   :: TVarChar AS AreaName    -- ������
           , 'AreaName_all' :: TBlob AS AreaName_all-- ������
           , CURRENT_DATE :: TDateTime AS OperDate_message

           , '-4889574969' :: TVarChar AS TelegramId
--           , '8397089850:AAG3YSsJeqVXwfDorhVoPH4fIBC5iGuhkvQ' :: TVarChar AS TelegramBotToken -- @test_1001744702809_bot
           , '5733732182:AAFsuEi0lAGAx4O4ZoIO8C4bfnJvKHr020c' :: TVarChar AS TelegramBotToken --  @alan_01_bot

           , ('test send ...'
             ) :: TBlob AS Msg

           , TRUE:: Boolean AS isStartSale
           , TRUE AS isStartPromo

           , 0 :: Integer AS MovementId, 0 :: Integer AS InvNumber
           , CURRENT_DATE :: TDateTime AS OperDate
           , CURRENT_DATE :: TDateTime AS DateStartSale           -- ���� �������� �� ��������� �����
           , CURRENT_DATE :: TDateTime AS DeteFinalSale           -- ���� �������� �� ��������� �����
           , CURRENT_DATE :: TDateTime AS DateStartPromo          -- ���� ���������� �����
           , CURRENT_DATE :: TDateTime AS DateFinalPromo          -- ���� ���������� �����

           , 'RetailName'    :: TBlob AS RetailName              -- ����, � ������� �������� �����
           , 'TradeMarkName' :: TVarChar AS TradeMarkName           -- �������� �����
           , 0 :: Integer GoodsId        
           , 0 :: Integer GoodsCode               -- ��� �������
           , 'GoodsName' :: TVarChar AS GoodsName               -- �������
           , 'GoodsKindName' :: TVarChar AS GoodsKindName           -- ������������ ������� <��� ������>
           , 'GoodsKindCompleteName' :: TVarChar AS GoodsKindCompleteName   -- ������������ ������� <��� ������(����������)>
           , 'MeasureName' :: TVarChar AS MeasureName             -- ������� ���������
           , 0 :: TFloat AS PriceWithVAT            -- ����������� ��������� ���� � ������ ���, ���
           , 0 :: TFloat AS Price                   -- * ���� ������������ � ���, ���
           , 0 :: TFloat AS CostPromo               -- * ��������� �������
           , 0 :: TFloat AS PriceSale               -- * ���� �� �����/������ ��� ����������
           , 'AdvertisingName' :: TBlob AS AdvertisingName         -- * �������.���������
           , 'Comment' :: TVarChar AS Comment                 -- ����������
           , 'CommentMain' :: TVarChar AS CommentMain             --
      WHERE 1=1
        AND vbUserId = 5
     ;
                                                         
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.22                                        *
*/

-- delete from MovementDate where DescId = zc_MovementDate_Message()
-- SELECT * FROM gpSelect_Movement_Promo_Message (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Movement_Promo_Message (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inSession:= zfCalc_UserAdmin());