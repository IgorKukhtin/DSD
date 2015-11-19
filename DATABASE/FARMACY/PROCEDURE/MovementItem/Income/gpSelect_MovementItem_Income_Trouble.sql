-- Function: gpSelect_MovementItem_Income_Trouble()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_Trouble (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_Trouble(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsCode TVarChar, PartnerGoodsName TVarChar
             , Amount TFloat
             , AmountManual TFloat
             , AmountDiff TFloat
             , ReasonDifferencesId Integer
             , ReasonDifferencesName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;

    RETURN QUERY
    SELECT
        MovementItem.Id
      , MovementItem.GoodsId
      , MovementItem.GoodsCode
      , MovementItem.GoodsName
      , MovementItem.PartnerGoodsCode
      , MovementItem.PartnerGoodsName
      , MovementItem.Amount
      , MovementItem.AmountManual
      , (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0))::TFloat as AmountDiff
      , MovementItem.ReasonDifferencesId
      , MovementItem.ReasonDifferencesName      
    FROM 
        MovementItem_Income_View AS MovementItem 
    WHERE
        MovementItem.MovementId = inMovementId
        AND 
        MovementItem.isErased   = FALSE
        AND
        (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0)) <> 0;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Income_Trouble (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 18.11.15                                                                        *
*/
