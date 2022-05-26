-- Function: gpSelect_ObjectHistory_ServiceItemOnDate ()

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
             , Value_before TFloat
             , Price_before TFloat
             , Area_before  TFloat
             , Value_after TFloat
             , Price_after TFloat
             , Area_after  TFloat
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
                     AND Object.isErased = False
                     AND inUnitId = 0
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
                                       AND ObjectHistory.StartDate <= inOperDate
                                       AND ObjectHistory.EndDate >= inOperDate
                                     )
       --данные предыдущеного и следующего периодов
     , ObjectHistory_after AS (SELECT tmp.ObjectId
   		                            , ObjectHistoryFloat_Value_after.ValueData   AS Value_after
                                    , ObjectHistoryFloat_Price_after.ValueData   AS Price_after
                                    , ObjectHistoryFloat_Area_after.ValueData    AS Area_after
                               FROM (SELECT ObjectHistory_ServiceItem.ObjectId
                                        , ObjectHistory_after.Id  AS Id_after
                                        , ObjectHistory_after.StartDate AS StartDate
                                        , MIN (ObjectHistory_after.StartDate) OVER (PARTITION BY ObjectHistory_ServiceItem.ObjectId) AS StartDate_after
                                   FROM ObjectHistory_ServiceItem
                                        LEFT JOIN ObjectHistory AS ObjectHistory_after
                                                                ON ObjectHistory_after.ObjectId = ObjectHistory_ServiceItem.ObjectId
                                                               AND ObjectHistory_after.DescId = zc_ObjectHistory_ServiceItem()
                                                               AND ObjectHistory_after.StartDate >= ObjectHistory_ServiceItem.EndDate
                                   ) AS tmp    

                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value_after
                                                               ON ObjectHistoryFloat_Value_after.ObjectHistoryId = tmp.Id_after
                                                              AND ObjectHistoryFloat_Value_after.DescId = zc_ObjectHistoryFloat_ServiceItem_Value()
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price_after
                                                               ON ObjectHistoryFloat_Price_after.ObjectHistoryId = tmp.Id_after
                                                              AND ObjectHistoryFloat_Price_after.DescId = zc_ObjectHistoryFloat_ServiceItem_Price()           
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Area_after
                                                               ON ObjectHistoryFloat_Area_after.ObjectHistoryId = tmp.Id_after
                                                              AND ObjectHistoryFloat_Area_after.DescId = zc_ObjectHistoryFloat_ServiceItem_Area()  
                             WHERE tmp.StartDate = tmp.StartDate_after
                             )

     , ObjectHistory_before AS (SELECT tmp.ObjectId
   		                            , ObjectHistoryFloat_Value_before.ValueData   AS Value_before
                                    , ObjectHistoryFloat_Price_before.ValueData   AS Price_before
                                    , ObjectHistoryFloat_Area_before.ValueData    AS Area_before
                               FROM (SELECT ObjectHistory_ServiceItem.ObjectId
                                        , ObjectHistory_before.Id  AS Id_before
                                        , ObjectHistory_before.EndDate AS EndDate
                                        , MAX (ObjectHistory_before.EndDate)  OVER (PARTITION BY ObjectHistory_ServiceItem.ObjectId) AS EndDate_before
                                   FROM ObjectHistory_ServiceItem
                                        LEFT JOIN ObjectHistory AS ObjectHistory_before
                                                                ON ObjectHistory_before.ObjectId = ObjectHistory_ServiceItem.ObjectId
                                                               AND ObjectHistory_before.DescId = zc_ObjectHistory_ServiceItem()
                                                               AND ObjectHistory_before.EndDate <= ObjectHistory_ServiceItem.StartDate
                                   ) AS tmp    

                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value_before
                                                               ON ObjectHistoryFloat_Value_before.ObjectHistoryId = tmp.Id_before
                                                              AND ObjectHistoryFloat_Value_before.DescId = zc_ObjectHistoryFloat_ServiceItem_Value()
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price_before
                                                               ON ObjectHistoryFloat_Price_before.ObjectHistoryId = tmp.Id_before
                                                              AND ObjectHistoryFloat_Price_before.DescId = zc_ObjectHistoryFloat_ServiceItem_Price()           
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Area_before
                                                               ON ObjectHistoryFloat_Area_before.ObjectHistoryId = tmp.Id_before
                                                              AND ObjectHistoryFloat_Area_before.DescId = zc_ObjectHistoryFloat_ServiceItem_Area()  
                             WHERE tmp.EndDate = tmp.EndDate_before
                             )
                             
                             
                             
       SELECT
             ObjectHistory_ServiceItem.Id                                   AS Id
           , COALESCE(ObjectHistory_ServiceItem.StartDate, CURRENT_DATE) ::TDateTime AS StartDate
           , COALESCE(ObjectHistory_ServiceItem.EndDate,  zc_DateEnd())     AS EndDate
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

           , ObjectHistory_before.Value_before ::TFloat
           , ObjectHistory_before.Price_before ::TFloat
           , ObjectHistory_before.Area_before  ::TFloat

           , ObjectHistory_after.Value_after ::TFloat
           , ObjectHistory_after.Price_after ::TFloat
           , ObjectHistory_after.Area_after  ::TFloat

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
