-- Function: gpSelect_GoodsOnUnitRemains_ForTabletki

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
                            
                LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites 
                                        ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId 
                                       AND ObjectBoolean_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()
            WHERE
                Container.DescId = zc_Container_Count()
                AND
                COALESCE(ObjectBoolean_isNotUploadSites.ValueData, false) = False
                AND
                Container.WhereObjectId = inUnitId
            GROUP BY
                Container.ObjectId
            HAVING
                SUM(Container.Amount) > 0
        ), 
		Reserve as (
			SELECT 
                MovementItem.ObjectId,    
				SUM(MovementItem.Amount) as ReserveAmount
            FROM Movement 
                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                INNER JOIN Object AS Object_Unit  
                                              ON MovementLinkObject_Unit.ObjectID = Object_Unit.ID
                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
            WHERE  
                 Movement.DescId = zc_Movement_Check() 
				 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                 AND  MovementLinkObject_Unit.ObjectID = inUnitId
            GROUP BY MovementItem.ObjectId)
				
    INSERT INTO _Result(RowData)
    SELECT
        '<Offer Code="'||CAST(Object_Goods.ObjectCode AS TVarChar)||'" Name="'||replace(replace(replace(Object_Goods.ValueData, '"', ''),'&','&amp;'),'''','')||'" Producer="'||replace(replace(replace(COALESCE(Remains.MakerName,''),'"',''),'&','&amp;'),'''','')||'" Price="'||to_char(Object_Price.Price,'FM9999990.00')||'" Quantity="'||CAST((Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0)) AS TVarChar)||'" PriceReserve="'||to_char(Object_Price.Price,'FM9999990.00')||'" />'
    FROM
        Remains
        INNER JOIN (SELECT MIN(Remains.ObjectId) AS ObjectId FROM Remains 
                                INNER JOIN Object AS Object_Goods
                                                  ON Object_Goods.Id = Remains.ObjectId GROUP BY Object_Goods.ObjectCode) AS T1
                                                  ON T1.ObjectId = Remains.ObjectId
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Remains.ObjectId
        LEFT OUTER JOIN Object_Price_View AS Object_Price
                                          ON Object_Price.GoodsId = Remains.ObjectId
                                         AND Object_Price.UnitId = inUnitId
		LEFT OUTER JOIN Reserve AS Reserve_Goods 
		                                  ON Reserve_Goods.ObjectId = Remains.ObjectId
	WHERE (Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0)) > 0;
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В. 
 23.07.18                                                                                      *
 24.05.18                                                                                      *
 29.03.18                                                                                      *
 15.01.16                                                                       *


*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletki (inUnitId := 183292, inSession:= '3')

