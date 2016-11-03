DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckError (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckError(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, MovementId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat 
             , NDS TFloat
             , PriceSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             , List_UID TVarChar
             , isErased Boolean
             , Color_CalcError Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;   
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
        WITH 
            tmpRemains AS(SELECT Container.ObjectId                  AS GoodsId
                               , SUM(Container.Amount)::TFloat       AS Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                          GROUP BY Container.ObjectId
                          )
          , tmpMov AS(SELECT Movement.Id
                      FROM Movement
                        INNER JOIN MovementString AS MovementString_CommentError
                                                  ON MovementString_CommentError.MovementId = Movement.Id
                                                 AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                      WHERE Movement.DescId = zc_Movement_Check()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                       
                     )
       -- ���������
       SELECT
             MovementItem.Id          AS Id,
             MovementItem.MovementId  AS MovementId 
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount      AS Amount
           , MIFloat_Price.ValueData  AS Price
           , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat AS AmountSumm
           , ObjectFloat_NDSKind_NDS.ValueData AS NDS
           , MIFloat_PriceSale.ValueData         AS PriceSale
           , MIFloat_ChangePercent.ValueData     AS ChangePercent
           , MIFloat_SummChangePercent.ValueData AS SummChangePercent
           , MIFloat_AmountOrder.ValueData       AS AmountOrder
           , MIString_UID.ValueData              AS List_UID
           , MovementItem.isErased

           , CASE WHEN COALESCE (tmpRemains.Amount,0) < COALESCE (MovementItem.Amount,0) THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END  AS Color_CalcError

       FROM tmpMov
          INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 
          LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                      ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                      ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                               ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
          
          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
          LEFT JOIN MovementItemString AS MIString_UID
                                       ON MIString_UID.MovementItemId = MovementItem.Id
                                      AND MIString_UID.DescId = zc_MIString_UID()

          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
     WHERE MovementItem.isErased = FALSE;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckError (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�. ��������� �.�
 04.11.16         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_CheckError ('3')
