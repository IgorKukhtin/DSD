DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Availabilities(TBlob,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Availabilities(
    IN inGoodsId       TBlob,       -- � ������� ����� �������
    IN inUnitId        Integer,     -- �������������
    IN inSession       TVarChar     -- ������ ������������
)
RETURNS TABLE (--id Integer, 
               product_id Integer, pharmacy_id Integer, supplier_id Integer, quantity TVarChar, price TFloat) AS
$BODY$
BEGIN
    inGoodsId := ','||inGoodsId||',';
    RETURN QUERY
        WITH
        tmpObject_Price AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                 , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                            FROM ObjectLink AS ObjectLink_Price_Unit
                                 LEFT JOIN ObjectLink AS Price_Goods
                                        ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                       AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                 LEFT JOIN ObjectFloat AS Price_Value
                                        ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                       AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                              AND ObjectLink_Price_Unit.ChildObjectId = inUnitId 
                            )
        ---
        SELECT
            --id	int(10) unsigned �������������� ����������	�� ������
            Container.ObjectId              AS product_id   --�� ������
           ,Container.WhereObjectId         AS pharmacy_id  --�� ������
           ,0::Integer                      AS supplier_id  --�� ���������� 
           ,SUM(Container.Amount)::TVarChar AS quantity     --���-�� (*������� � ����������)
           ,tmpObject_Price.Price           AS price        --����, (*������� � ����������)
        FROM Container 
            LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Container.ObjectId
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = inUnitId
          AND Container.Amount > 0
          AND tmpObject_Price.Price > 0
          AND position((','||Container.ObjectId||',')::TVarChar IN inGoodsId)>0
        GROUP BY Container.ObjectId
                ,Container.WhereObjectId
                ,tmpObject_Price.Price
        ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Availabilities(TBlob,Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 12.06.17         *
 27.10.15                                                         *
 
*/

-- ����
 --SELECT * FROM gpSelect_Object_Goods_Availabilities('29638,38407,36235,38407',183292,'2');