-- Function: gpSelect_ObjectHistory_MarginCategoryItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_MarginCategoryItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_MarginCategoryItem(
    IN inMarginCategoryItemId        Integer   , -- Элемент категории наценки (наценки в аптеке)
    IN inSession                     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               Value TFloat, Price TFloat
               )
AS
$BODY$
BEGIN
     -- Выбираем данные
    RETURN QUERY
        WITH 
        ObjectHistory_MarginCategoryItem AS
           (SELECT * 
            FROM ObjectHistory
            WHERE ObjectHistory.ObjectId = inMarginCategoryItemId
              AND ObjectHistory.DescId = zc_ObjectHistory_MarginCategoryItem()
            )

     SELECT ObjectHistory_MarginCategoryItem.Id                                   AS Id
          , COALESCE(ObjectHistory_MarginCategoryItem.StartDate, Empty.StartDate) AS StartDate
          , ObjectHistoryFloat_MarginCategoryItem_Value.ValueData                 AS Value
          , ObjectHistoryFloat_MarginCategoryItem_Price.ValueData                 AS Price
     FROM ObjectHistory_MarginCategoryItem
            FULL JOIN (SELECT zc_DateStart()          AS StartDate
                            , inMarginCategoryItemId  AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_MarginCategoryItem.ObjectID
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MarginCategoryItem_Price
                                         ON ObjectHistoryFloat_MarginCategoryItem_Price.ObjectHistoryId = ObjectHistory_MarginCategoryItem.Id
                                        AND ObjectHistoryFloat_MarginCategoryItem_Price.DescId = zc_ObjectHistoryFloat_MarginCategoryItem_Price()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MarginCategoryItem_Value
                                         ON ObjectHistoryFloat_MarginCategoryItem_Value.ObjectHistoryId = ObjectHistory_MarginCategoryItem.Id
                                        AND ObjectHistoryFloat_MarginCategoryItem_Value.DescId = zc_ObjectHistoryFloat_MarginCategoryItem_Value()
     ;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 09.02.17         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_MarginCategoryItem (0, '')
