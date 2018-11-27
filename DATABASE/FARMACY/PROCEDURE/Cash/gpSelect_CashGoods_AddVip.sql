-- Function: gpSelect_CashGoods_AddVip()

DROP FUNCTION IF EXISTS gpSelect_CashGoods_AddVip (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoods_AddVip(
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer,
               Code Integer,
               Name TVarChar,
               Price TFloat)

AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbUnitIdStr  TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;

    -- ������ ������� ������ ������ �� ������ �������������
     RETURN QUERY
     WITH tmpContainer AS (SELECT DISTINCT Container.ObjectId AS GoodsID
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount > 0
                         )
       , tmpObject_Price AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price
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

    SELECT tmpObject_Price.GoodsId                     AS Id
         , Object_Goods.ObjectCode                     AS Code
         , Object_Goods.ValueData                      AS Name
         , COALESCE(tmpObject_Price.Price,0)::TFloat   AS Price
    FROM
        tmpObject_Price

        INNER JOIN tmpContainer ON tmpContainer.GoodsID = tmpObject_Price.GoodsId

        LEFT OUTER JOIN Object AS Object_Goods 
                               ON Object_Goods.Id = tmpObject_Price.GoodsId
    ORDER BY Object_Goods.ObjectCode;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 20.11.18                                                                                     *
*/

-- ����
-- SELECT * FROM gpSelect_CashGoods_AddVip (inSession := '3354092');