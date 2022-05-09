-- Function: gpGet_MovementItem_PriceSubgroups()

DROP FUNCTION IF EXISTS gpGet_MovementItem_PriceSubgroups (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_PriceSubgroups(
    IN inId                Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Price TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    
     vbUserId:= lpGetUserBySession (inSession);
    -- zc_Enum_Process_InsertUpdate_MI_CompetitorMarkups
    
    IF COALESCE (inId, 0) = 0
    THEN

        -- �������� ���� ������������ �� ����� ���������
        PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());

        RETURN QUERY
        SELECT
            0                                         AS Id
          , 0::TFloat                                 AS Price;
    ELSE
        RETURN QUERY
        SELECT
            MovementItem.Id
          , MovementItem.Amount                       AS Price
        FROM MovementItem
        WHERE MovementItem.Id =  inId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementItem_PriceSubgroups (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.22                                                        *
*/

-- 

select * from gpGet_MovementItem_PriceSubgroups(inId := 0 ,  inSession := '3');
