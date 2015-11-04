DROP VIEW IF EXISTS MovementItem_PromoCondition_View;

CREATE OR REPLACE VIEW MovementItem_PromoCondition_View AS
    SELECT
        MovementItem.Id                    AS Id                  -- �������������
      , MovementItem.MovementId            AS MovementId          -- ��� ��������� <�����>
      , MovementItem.ObjectId              AS ConditionPromoId    -- �� ������� <������� ������� � �����>
      , Object_ConditionPromo.ObjectCode   AS ConditionPromoCode  -- ��� ������� <������� ������� � �����>
      , Object_ConditionPromo.ValueData    AS ConditionPromoName  -- ������������ ������� <������� ������� � �����>
      , MovementItem.Amount                AS Amount              -- �������� (% ������ / % �����������)
    FROM  MovementItem
        LEFT JOIN MovementItemLinkObject AS MILinkObject_ConditionPromo
                                         ON MILinkObject_ConditionPromo.MovementItemId = MovementItem.ObjectId
                                        AND MILinkObject_ConditionPromo.DescId = zc_MILinkObject_ConditionPromo()
        LEFT JOIN Object AS Object_ConditionPromo
                         ON Object_ConditionPromo.Id = MILinkObject_ConditionPromo.ObjectId
        
    WHERE 
        MovementItem.DescId = zc_MI_Master();


ALTER TABLE MovementItem_PromoCondition_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 02.11.15                                                         *
*/