-- Function: gpSelect_CashGoods()

DROP FUNCTION IF EXISTS gpSelect_CashGoods (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoods(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsId   Integer, 
               GoodsCode Integer, 
               GoodsName TVarChar, 
               Price     TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
-- if inSession = '3' then return; end if;

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    RETURN QUERY
    WITH
    tmpObject_Price AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )

    SELECT
         tmpObject_Price.GoodsId                     AS GoodsId
       , Object_Goods.ObjectCode                     AS GoodsCode
       , Object_Goods.ValueData                      AS GoodsName
       , COALESCE(tmpObject_Price.Price,0)::TFloat   AS Price
       

    FROM
        tmpObject_Price

        LEFT OUTER JOIN Object AS Object_Goods 
                               ON Object_Goods.Id = tmpObject_Price.GoodsId
    ORDER BY Object_Goods.ObjectCode LIMIT 100;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashGoods (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 11.09.18                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_CashGoods (inSession:= '308120')

