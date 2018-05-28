-- Function: gpSelect_Object_Price_SaveToXls (TVarChar)
/*
  процедура вызывается в программе: SaveToXlsUnit
*/

DROP FUNCTION IF EXISTS gpSelect_Object_Price_SaveToXls(Integer, Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price_SaveToXls(
    IN inUnitId      Integer,       -- подразделение
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , Price TFloat
             , DateChange TDateTime
             , MCSValue TFloat
             , MCSDateChange TDateTime
             , isErased boolean
             , MCSIsClose Boolean
             , MCSNotRecalc Boolean
             , Remains TFloat
             , Fix Boolean
             ) AS
$BODY$
BEGIN

    RETURN QUERY
    WITH
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

    SELECT       gpSelect_Object_Price.Id
               , gpSelect_Object_Price.GoodsCode
               , gpSelect_Object_Price.GoodsName
               , gpSelect_Object_Price.Price
               , gpSelect_Object_Price.DateChange
               , gpSelect_Object_Price.MCSValue
               , gpSelect_Object_Price.MCSDateChange
               , gpSelect_Object_Price.isErased
               , gpSelect_Object_Price.MCSIsClose
               , gpSelect_Object_Price.MCSNotRecalc
               , CASE WHEN (gpSelect_Object_Price.Remains - coalesce(Reserve_Goods.ReserveAmount, 0)) > 0
                 THEN gpSelect_Object_Price.Remains - coalesce(Reserve_Goods.ReserveAmount, 0) ELSE Null END ::TFloat as Remains
               , gpSelect_Object_Price.Fix
      from gpSelect_Object_Price(inUnitId, inGoodsId, inisShowAll, inisShowDel,  inSession) as gpSelect_Object_Price
        LEFT OUTER JOIN Reserve AS Reserve_Goods
                                ON Reserve_Goods.ObjectId = gpSelect_Object_Price.Id
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites 
                                ON ObjectBoolean_isNotUploadSites.ObjectId = gpSelect_Object_Price.GoodsId 
                               AND ObjectBoolean_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()
      WHERE COALESCE(ObjectBoolean_isNotUploadSites.ValueData, false) = False
      ORDER BY gpSelect_Object_Price.GoodsName;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Price_SaveToXls(Integer, Boolean,Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Шаблий О.В. 
 24.05.18         *
 26.04.18         *

*/
-- тест
--select * from gpSelect_Object_Price_SaveToXls(inUnitId := 183292 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
