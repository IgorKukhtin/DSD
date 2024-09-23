-- Function: gpGet_Movement_PromoTrade_SignByPrint()

DROP FUNCTION IF EXISTS gpGet_Movement_PromoTrade_SignByPrint (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PromoTrade_SignByPrint(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TextSign TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN;
    END IF;

        -- ���������
        RETURN QUERY

        SELECT CASE WHEN EXISTS (SELECT 1 
                                 FROM gpSelect_MI_Sign (inMovementId, FALSE, inSession) AS tmp
                                 WHERE tmp.isSign = FALSE
                                 LIMIT 1) THEN '�� ���������' 
                    ELSE '���������'
               END :: TVarChar AS TextSign        
        ;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.24         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_PromoTrade_SignByPrint (inMovementId:=29301131, inSession:= zfCalc_UserAdmin())