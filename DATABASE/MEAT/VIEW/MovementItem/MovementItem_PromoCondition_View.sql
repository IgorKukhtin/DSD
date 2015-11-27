--

DROP VIEW IF EXISTS MovementItem_PromoCondition_View;

CREATE OR REPLACE VIEW MovementItem_PromoCondition_View AS
    SELECT
        MovementItem.Id                    AS Id                  -- �������������
      , MovementItem.MovementId            AS MovementId          -- ��� ��������� <�����>
      , MovementItem.ObjectId              AS ConditionPromoId    -- �� ������� <������� ������� � �����>
      , Object_ConditionPromo.ObjectCode   AS ConditionPromoCode  -- ��� ������� <������� ������� � �����>
      , Object_ConditionPromo.ValueData    AS ConditionPromoName  -- ������������ ������� <������� ������� � �����>
      , MovementItem.Amount                AS Amount              -- �������� (% ������ / % �����������)
      , MIString_Comment.ValueData         AS Comment             -- ����������
      , MovementItem.isErased              AS isErased            -- ������
    FROM  MovementItem
        LEFT JOIN Object AS Object_ConditionPromo
                         ON Object_ConditionPromo.Id = MovementItem.ObjectId
        LEFT OUTER JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MovementItem.ID
                                          AND MIString_Comment.DescId = zc_MIString_Comment()
        
    WHERE MovementItem.DescId = zc_MI_Child();


ALTER TABLE MovementItem_PromoCondition_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 02.11.15                                                         *
*/

-- ����
-- SELECT * FROM MovementItem_PromoCondition_View WHERE MovementId = 2641111
