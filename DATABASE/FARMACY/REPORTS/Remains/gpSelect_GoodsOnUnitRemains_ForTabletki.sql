-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForTabletki (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletki(
    IN inUnitId  Integer = 183292, -- Подразделение
    IN inSession TVarChar = '' -- сессия пользователя
)
RETURNS TABLE (RowData TBlob)
AS
$BODY$
BEGIN
    CREATE TEMP TABLE _Result(RowData TBlob) ON COMMIT DROP;
    
    --Шапка
    INSERT INTO _Result(RowData) Values ('<?xml version="1.0" encoding="utf-8"?>');
    INSERT INTO _Result(RowData) Values ('<Offers>');
    --Тело
    WITH
        Remains AS
        (
            SELECT
                Container.ObjectId
               ,MAX(Object_PartnerGoods.MakerName) AS MakerName
               ,SUM(Container.Amount) AS Amount
            FROM
                Container
                LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                    ON CLI_MI.ContainerId = Container.Id
                                                   AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                 ON MILinkObject_Goods.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                LEFT JOIN Object_Goods_View AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId                
            WHERE
                Container.DescId = zc_Container_Count()
                AND
                Container.WhereObjectId = inUnitId
            GROUP BY
                Container.ObjectId
            HAVING
                SUM(Container.Amount) > 0
        )
    INSERT INTO _Result(RowData)
    SELECT
        '<Offer Code="'||CAST(Object_Goods.ObjectCode AS TVarChar)||'" Name="'||replace(replace(replace(Object_Goods.ValueData, '"', ''),'&','&amp;'),'''','')||'" Producer="'||replace(replace(replace(COALESCE(Remains.MakerName,''),'"',''),'&','&amp;'),'''','')||'" Price="'||to_char(Object_Price.Price,'FM9999990.00')||'" Quantity="'||CAST(Remains.Amount AS TVarChar)||'" />'
    FROM
        Remains
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Remains.ObjectId
        LEFT OUTER JOIN Object_Price_View AS Object_Price
                                          ON Object_Price.GoodsId = Remains.ObjectId
                                         AND Object_Price.UnitId = inUnitId;
    --подвал
    INSERT INTO _Result(RowData) Values ('</Offers>');
        

    -- Результат
    RETURN QUERY
        SELECT _Result.RowData FROM _Result;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletki (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 15.01.16                                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletki (inUnitId := 183292, inSession:= '2')