-- Function: gpSelect_ObjectHistory_ServiceItemOnDate ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_ServiceItemLast (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_ServiceItemOnDate (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_ServiceItemOnDate(
    IN inUnitId             Integer   , -- отдел
    IN inInfoMoneyId        Integer   , -- Статья
    IN inOperDate           TDateTime ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, NameFull TVarChar, UnitGroupNameFull TVarChar
             , Value TFloat, Price TFloat, Area TFloat

             , StartDate_before TDateTime, EndDate_before TDateTime
             , Value_before TFloat, Price_before TFloat, Area_before TFloat

             , StartDate_after TDateTime, EndDate_after TDateTime
             , Value_after TFloat, Price_after TFloat, Area_after TFloat
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
       WITH
       tmpUnit AS (SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId
                   FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup
                   WHERE inUnitId <> 0
                  UNION
                   SELECT Object.Id AS UnitId
                   FROM Object
                   WHERE Object.DescId = zc_Object_Unit()
                     AND Object.isErased = FALSE
                   --AND inUnitId = 0
                   )

     , tmpServiceItem AS (SELECT ObjectLink_Unit.ObjectId           AS ObjectId
                               , ObjectLink_Unit.ChildObjectId      AS UnitId
                               , ObjectLink_InfoMoney.ChildObjectId AS InfoMoneyId
                          FROM ObjectLink AS ObjectLink_Unit
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = COALESCE (ObjectLink_Unit.ChildObjectId,0)
                               LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                    ON ObjectLink_InfoMoney.ObjectId = ObjectLink_Unit.ObjectId
                                                   AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_ServiceItem_InfoMoney()
                          WHERE ObjectLink_Unit.DescId = zc_ObjectLink_ServiceItem_Unit()
                            AND (COALESCE (ObjectLink_InfoMoney.ChildObjectId,0) = inInfoMoneyId OR inInfoMoneyId = 0)
                          )
       -- данные  на дату
     , ObjectHistory_ServiceItem AS (SELECT *
                                     FROM ObjectHistory
                                     WHERE ObjectHistory.ObjectId IN (SELECT DISTINCT tmpServiceItem.ObjectId FROM tmpServiceItem)
                                       AND ObjectHistory.DescId = zc_ObjectHistory_ServiceItem()
                                       AND inOperDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
                                    )
       -- данные предыдущеного периода
     , ObjectHistory_before AS (SELECT tmp.ObjectId
                                     , tmp.StartDate
                                     , tmp.EndDate
                                     , ObjectHistoryFloat_Value.ValueData   AS Value
                                     , ObjectHistoryFloat_Price.ValueData   AS Price
                                     , ObjectHistoryFloat_Area.ValueData    AS Area
                                FROM (SELECT ObjectHistory.Id AS ObjectHistoryId
                                           , ObjectHistory_ServiceItem.ObjectId
                                           , ObjectHistory.StartDate
                                           , ObjectHistory.EndDate
                                           , ROW_NUMBER() OVER (PARTITION BY ObjectHistory_ServiceItem.ObjectId ORDER BY ObjectHistory.EndDate DESC) AS Ord
                                      FROM ObjectHistory_ServiceItem
                                           LEFT JOIN ObjectHistory AS ObjectHistory
                                                                   ON ObjectHistory.ObjectId  = ObjectHistory_ServiceItem.ObjectId
                                                                  AND ObjectHistory.DescId    = zc_ObjectHistory_ServiceItem()
                                                                  AND ObjectHistory.EndDate < ObjectHistory_ServiceItem.StartDate
                                    ) AS tmp

                                   LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                                ON ObjectHistoryFloat_Value.ObjectHistoryId = tmp.ObjectHistoryId
                                                               AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_ServiceItem_Value()
                                   LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                                ON ObjectHistoryFloat_Price.ObjectHistoryId = tmp.ObjectHistoryId
                                                               AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_ServiceItem_Price()
                                   LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Area
                                                                ON ObjectHistoryFloat_Area.ObjectHistoryId = tmp.ObjectHistoryId
                                                               AND ObjectHistoryFloat_Area.DescId = zc_ObjectHistoryFloat_ServiceItem_Area()
                                WHERE tmp.Ord = 1
                               )
       -- данные следующего периода
     , ObjectHistory_after AS (SELECT tmp.ObjectId
                                    , tmp.StartDate
                                    , tmp.EndDate
                                    , ObjectHistoryFloat_Value.ValueData   AS Value
                                    , ObjectHistoryFloat_Price.ValueData   AS Price
                                    , ObjectHistoryFloat_Area.ValueData    AS Area
                               FROM (SELECT ObjectHistory.Id AS ObjectHistoryId
                                          , ObjectHistory_ServiceItem.ObjectId
                                          , ObjectHistory.StartDate
                                          , ObjectHistory.EndDate
                                          , ROW_NUMBER() OVER (PARTITION BY ObjectHistory_ServiceItem.ObjectId ORDER BY ObjectHistory.StartDate) AS Ord
                                     FROM ObjectHistory_ServiceItem
                                          LEFT JOIN ObjectHistory AS ObjectHistory
                                                                  ON ObjectHistory.ObjectId  = ObjectHistory_ServiceItem.ObjectId
                                                                 AND ObjectHistory.DescId    = zc_ObjectHistory_ServiceItem()
                                                                 AND ObjectHistory.StartDate > ObjectHistory_ServiceItem.EndDate
                                   ) AS tmp

                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                               ON ObjectHistoryFloat_Value.ObjectHistoryId = tmp.ObjectHistoryId
                                                              AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_ServiceItem_Value()
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                               ON ObjectHistoryFloat_Price.ObjectHistoryId = tmp.ObjectHistoryId
                                                              AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_ServiceItem_Price()
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Area
                                                               ON ObjectHistoryFloat_Area.ObjectHistoryId = tmp.ObjectHistoryId
                                                              AND ObjectHistoryFloat_Area.DescId = zc_ObjectHistoryFloat_ServiceItem_Area()
                               WHERE tmp.Ord = 1
                              )
       -- Результат
       SELECT
             ObjectHistory_ServiceItem.Id                                   AS Id
           , ObjectHistory_ServiceItem.StartDate                            AS StartDate
           , ObjectHistory_ServiceItem.EndDate                              AS EndDate
           , Object_InfoMoney.Id                                            AS InfoMoneyId
           , Object_InfoMoney.ObjectCode                                    AS InfoMoneyCode
           , Object_InfoMoney.ValueData                                     AS InfoMoneyName
           , Object_CommentInfoMoney.Id                                     AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData                              AS CommentInfoMoneyName

           , Object_Unit.Id                                                 AS UnitId
           , Object_Unit.ObjectCode                                         AS UnitCode
           , Object_Unit.ValueData                                          AS UnitName
           , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS NameFull
           , ObjectString_Unit_GroupNameFull.ValueData                      AS UnitGroupNameFull

           , ObjectHistoryFloat_ServiceItem_Value.ValueData                 AS Value
           , ObjectHistoryFloat_ServiceItem_Price.ValueData                 AS Price
           , ObjectHistoryFloat_ServiceItem_Area.ValueData                  AS Area

           , ObjectHistory_before.StartDate
           , ObjectHistory_before.EndDate
           , ObjectHistory_before.Value      ::TFloat
           , ObjectHistory_before.Price      ::TFloat
           , ObjectHistory_before.Area       ::TFloat

           , ObjectHistory_after.StartDate
           , ObjectHistory_after.EndDate
           , ObjectHistory_after.Value       ::TFloat
           , ObjectHistory_after.Price       ::TFloat
           , ObjectHistory_after.Area        ::TFloat

           , FALSE AS isErased

       FROM ObjectHistory_ServiceItem
            /*FULL JOIN (SELECT zc_DateStart() AS StartDate, inUnitId AS ObjectId
                       WHERE inUnitId <> 0) AS Empty
                                            ON Empty.ObjectId = ObjectHistory_ServiceItem.ObjectId*/

            LEFT JOIN tmpServiceItem ON tmpServiceItem.ObjectId = ObjectHistory_ServiceItem.ObjectId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpServiceItem.UnitId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpServiceItem.InfoMoneyId

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_ServiceItem_CommentInfoMoney
                                        ON ObjectHistoryLink_ServiceItem_CommentInfoMoney.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                       AND ObjectHistoryLink_ServiceItem_CommentInfoMoney.DescId = zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = ObjectHistoryLink_ServiceItem_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Value
                                         ON ObjectHistoryFloat_ServiceItem_Value.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Value.DescId = zc_ObjectHistoryFloat_ServiceItem_Value()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Price
                                         ON ObjectHistoryFloat_ServiceItem_Price.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Price.DescId = zc_ObjectHistoryFloat_ServiceItem_Price()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Area
                                         ON ObjectHistoryFloat_ServiceItem_Area.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Area.DescId = zc_ObjectHistoryFloat_ServiceItem_Area()

            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

            LEFT JOIN ObjectHistory_before ON ObjectHistory_before.ObjectId = ObjectHistory_ServiceItem.ObjectId
            LEFT JOIN ObjectHistory_after ON ObjectHistory_after.ObjectId = ObjectHistory_ServiceItem.ObjectId
;



END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.22         *
 04.05.22         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_ServiceItemOnDate (1, 0, '01.02.2022', zfCalc_UserAdmin())
