-- Function: gpSelect_MovementItem_PromoCondition()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCondition (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCondition(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (
        Id                 Integer  --�������������
      , MovementId         Integer  --�� ��������� <�����>
      , ConditionPromoId   Integer  --�� ������� <������� ������� � �����>
      , ConditionPromoCode Integer  --��� �������  <������� ������� � �����>
      , ConditionPromoName TVarChar --������������ ������� <������� ������� � �����>
      , Amount             TFloat   --��������
      , Comment            TVarChar --�����������
      , isErased           Boolean  --������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoCondition());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
        SELECT
            MI_PromoCondition.Id                 --�������������
          , MI_PromoCondition.MovementId         --�� ��������� <�����>
          , MI_PromoCondition.ConditionPromoId   --�� ������� <�����>
          , MI_PromoCondition.ConditionPromoCode --��� �������  <�����>
          , MI_PromoCondition.ConditionPromoName --������������ ������� <�����>
          , MI_PromoCondition.Amount             --% ������ �� �����
          , MI_PromoCondition.Comment            --�����������
          , MI_PromoCondition.isErased           --������
        FROM
            MovementItem_PromoCondition_View AS MI_PromoCondition
        WHERE
            MI_PromoCondition.MovementId = inMovementId
            AND
            (
                MI_PromoCondition.isErased = FALSE
                OR
                inIsErased = TRUE
            );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoCondition (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 25.11.15                                                          * Comment
 05.11.15                                                          *
*/