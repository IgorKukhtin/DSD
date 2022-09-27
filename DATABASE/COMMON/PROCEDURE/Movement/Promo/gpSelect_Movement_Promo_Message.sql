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
      WITH tmpReport AS (SELECT gpSelect.MovementId, gpSelect.InvNumber, gpSelect.OperDate
                              , gpSelect.DateStartSale           -- ���� �������� �� ��������� �����
                              , gpSelect.DeteFinalSale           -- ���� �������� �� ��������� �����
                              , gpSelect.DateStartPromo          -- ���� ���������� �����
                              , gpSelect.DateFinalPromo          -- ���� ���������� �����
                              , gpSelect.RetailName              -- ����, � ������� �������� �����
                              , gpSelect.AreaName                -- ������
                              , gpSelect.TradeMarkName           -- �������� �����
                              , gpSelect.GoodsId        
                              , gpSelect.GoodsCode               -- ��� �������
                              , gpSelect.GoodsName               -- �������
                              , gpSelect.GoodsKindName           -- ������������ ������� <��� ������>
                              , gpSelect.GoodsKindCompleteName   -- ������������ ������� <��� ������(����������)>
                              , gpSelect.MeasureName             -- ������� ���������
                              , gpSelect.PriceWithVAT            -- ����������� ��������� ���� � ������ ���, ���
                              , gpSelect.Price                   -- * ���� ������������ � ���, ���
                              , gpSelect.CostPromo               -- * ��������� �������
                              , gpSelect.PriceSale               -- * ���� �� �����/������ ��� ����������
                              , gpSelect.AdvertisingName         -- * �������.���������
                              , gpSelect.Comment                 -- ����������
                              , gpSelect.CommentMain             --
  
                         FROM gpSelect_Report_Promo_Result (inStartDate:= inOperDate, inEndDate:= inOperDate + INTERVAL '7 DAY'
                                                          , inIsPromo:= TRUE, inIsTender:= FALSE, inIsGoodsKind:= TRUE
                                                          , inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inJuridicalId:= 0
                                                          , inSession:= inSession
                                                           ) AS gpSelect
                         WHERE gpSelect.DateStartSale  = CURRENT_DATE + INTERVAL '2 DAY'
                            OR gpSelect.DateStartPromo = CURRENT_DATE + INTERVAL '2 DAY'
                        )
       , tmpListTelegramId AS (SELECT DISTINCT ObjectString_Area_TelegramId.ValueData AS TelegramId
                               FROM ObjectString AS ObjectString_Area_TelegramId
                               WHERE ObjectString_Area_TelegramId.DescId    = zc_ObjectString_Area_TelegramId()
                                 AND ObjectString_Area_TelegramId.ValueData <> ''
                              )
       , tmpListArea AS (SELECT tmpReport.MovementId
                              , STRING_AGG (DISTINCT Object_Area.ValueData, ';')  AS AreaName
                              , COALESCE (tmpListTelegramId.TelegramId, ObjectString_Area_TelegramId.ValueData) AS TelegramId
                              , COALESCE (ObjectString_Area_TelegramBotToken.ValueData, '5733732182:AAFsuEi0lAGAx4O4ZoIO8C4bfnJvKHr020c') AS TelegramBotToken
                         FROM tmpReport
                              INNER JOIN Movement AS Movement_PromoPartner
                                                  ON Movement_PromoPartner.ParentId = tmpReport.MovementId
                                                 AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                                                 AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                              INNER JOIN MovementItem AS MI_PromoPartner
                                                      ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                     AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                     AND MI_PromoPartner.IsErased   = FALSE
                              INNER JOIN ObjectLink AS ObjectLink_Partner_Area
                                                    ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                                   AND ObjectLink_Partner_Area.DescId   = zc_ObjectLink_Partner_Area()
                              LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
                              LEFT JOIN ObjectString AS ObjectString_Area_TelegramId
                                                     ON ObjectString_Area_TelegramId.ObjectId  = ObjectLink_Partner_Area.ChildObjectId
                                                    AND ObjectString_Area_TelegramId.DescId    = zc_ObjectString_Area_TelegramId()
                                                    AND ObjectString_Area_TelegramId.ValueData <> ''
                              LEFT JOIN ObjectString AS ObjectString_Area_TelegramBotToken
                                                     ON ObjectString_Area_TelegramBotToken.ObjectId  = ObjectLink_Partner_Area.ChildObjectId
                                                    AND ObjectString_Area_TelegramBotToken.DescId    = zc_ObjectString_Area_TelegramBotToken()
                                                    AND ObjectString_Area_TelegramBotToken.ValueData <> ''
                              -- !!! ���� ��!!!
                              LEFT JOIN tmpListTelegramId ON ObjectLink_Partner_Area.ChildObjectId = 310819 
                              
                         GROUP BY tmpReport.MovementId
                                , COALESCE (tmpListTelegramId.TelegramId, ObjectString_Area_TelegramId.ValueData)
                                , COALESCE (ObjectString_Area_TelegramBotToken.ValueData, '5733732182:AAFsuEi0lAGAx4O4ZoIO8C4bfnJvKHr020c')
                        )
      -- ���������
      SELECT CASE WHEN tmpListArea.TelegramId <> '' AND MovementDate_Message.ValueData IS NULL
                      THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isSend
             
           , tmpListArea.AreaName   :: TVarChar AS AreaName    -- ������
           , tmpReport.AreaName                 AS AreaName_all-- ������
           , COALESCE (MovementDate_Message.ValueData, zc_DateStart()) :: TDateTime AS OperDate_message

           , tmpListArea.TelegramId :: TVarChar AS TelegramId
         --, '-1001660847836' :: TVarChar AS TelegramId
           , COALESCE (tmpListArea.TelegramBotToken, (SELECT MAX (tmpListArea.TelegramBotToken) FROM tmpListArea WHERE tmpListArea.TelegramBotToken <> '')) :: TVarChar AS TelegramBotToken

           , ('�����.'
           || ' ����: '    || tmpReport.RetailName || '.'
           || ' ������: '  || tmpReport.AreaName   || '.'
           || ' �������: ' || tmpReport.GoodsName  || '.'
           || ' �������� �����: '          || COALESCE (tmpReport.TradeMarkName, '')           || '.'
           || ' ��� ��������: '            || COALESCE (tmpReport.GoodsKindCompleteName, '')   || '.'
           || ' ���� ������ ��������: '    || zfConvert_DateToString (tmpReport.DateStartSale) || '.'
           || ' ���� ��������� ��������: ' || zfConvert_DateToString (tmpReport.DeteFinalSale) || '.' 
           || ' ���� ������ �����: '       || zfConvert_DateToString (tmpReport.DateStartSale) || '.' 
           || ' ���� ��������� �����: '    || zfConvert_DateToString (tmpReport.DeteFinalSale) || '.' 
           || ' �������. ���������: '      || COALESCE (tmpReport.AdvertisingName, '')         || '.'
             ) :: TBlob AS Msg

           , CASE WHEN tmpReport.DateStartSale  = CURRENT_DATE + INTERVAL '2 DAY' THEN TRUE ELSE FALSE END :: Boolean AS isStartSale
           , CASE WHEN tmpReport.DateStartPromo = CURRENT_DATE + INTERVAL '2 DAY' THEN TRUE ELSE FALSE END :: Boolean AS isStartPromo

           , tmpReport.MovementId, tmpReport.InvNumber, tmpReport.OperDate
           , tmpReport.DateStartSale           -- ���� �������� �� ��������� �����
           , tmpReport.DeteFinalSale           -- ���� �������� �� ��������� �����
           , tmpReport.DateStartPromo          -- ���� ���������� �����
           , tmpReport.DateFinalPromo          -- ���� ���������� �����
           , tmpReport.RetailName              -- ����, � ������� �������� �����
           , tmpReport.TradeMarkName           -- �������� �����
           , tmpReport.GoodsId        
           , tmpReport.GoodsCode               -- ��� �������
           , tmpReport.GoodsName               -- �������
           , tmpReport.GoodsKindName           -- ������������ ������� <��� ������>
           , tmpReport.GoodsKindCompleteName   -- ������������ ������� <��� ������(����������)>
           , tmpReport.MeasureName             -- ������� ���������
           , tmpReport.PriceWithVAT            -- ����������� ��������� ���� � ������ ���, ���
           , tmpReport.Price                   -- * ���� ������������ � ���, ���
           , tmpReport.CostPromo               -- * ��������� �������
           , tmpReport.PriceSale               -- * ���� �� �����/������ ��� ����������
           , tmpReport.AdvertisingName         -- * �������.���������
           , tmpReport.Comment                 -- ����������
           , tmpReport.CommentMain             --
      FROM tmpReport
           LEFT JOIN tmpListArea ON tmpListArea.MovementId = tmpReport.MovementId
           LEFT JOIN MovementDate AS MovementDate_Message
                                  ON MovementDate_Message.MovementId = tmpReport.MovementId
                                 AND MovementDate_Message.DescId     = zc_MovementDate_Message()
      WHERE 1= 0
      ORDER BY tmpReport.DateStartSale
             , tmpReport.DateStartPromo
             , tmpReport.MovementId
             , tmpReport.GoodsCode
             , tmpReport.GoodsKindCompleteName
    --LIMIT 1
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
