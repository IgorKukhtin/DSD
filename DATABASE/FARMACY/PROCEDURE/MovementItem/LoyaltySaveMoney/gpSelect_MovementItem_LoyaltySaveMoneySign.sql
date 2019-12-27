-- Function: gpSelect_MovementItem_LoyaltySaveMoneySign()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_LoyaltySaveMoneySign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LoyaltySaveMoneySign(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id             Integer
             , Amount         TFloat
             , ChangePercent  TFloat
             , isErased       Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ����� <�������� ����>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- ���������
    RETURN QUERY

       SELECT MovementItem.Id
            , MovementItem.Amount 
            , MIFloat_ChangePercent.ValueData  AS ChangePercent
            , MovementItem.IsErased
       FROM MovementItem 
   
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()                                    

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId = zc_MI_Sign()
         AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
       ORDER BY Amount;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.11.19                                                       *
*/

-- select * from gpSelect_MovementItem_LoyaltySaveMoneySign(inMovementId := 0 , inIsErased := 'False' ,  inSession := '3'::TVarChar);