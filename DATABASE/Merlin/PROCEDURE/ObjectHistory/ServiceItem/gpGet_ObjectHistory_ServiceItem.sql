-- Function: gpGet_ObjectHistory_ServiceItem ()

---DROP FUNCTION IF EXISTS gpGet_ObjectHistory_ServiceItem (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ObjectHistory_ServiceItem (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_ServiceItem(
    IN inUnitId             Integer   , --
    IN inInfoMoneyId        Integer   , --
    IN inOperDate           TDateTime , -- Дата Истории
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
             , Value TFloat, Price TFloat, Area TFloat
               )
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
       WITH
       tmpServiceItem AS (SELECT ObjectLink_Unit.ObjectId           AS ObjectId
                               , ObjectLink_Unit.ChildObjectId      AS UnitId
                               , ObjectLink_InfoMoney.ChildObjectId AS InfoMoneyId
                          FROM ObjectLink AS ObjectLink_Unit
                               LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                    ON ObjectLink_InfoMoney.ObjectId = ObjectLink_Unit.ObjectId
                                                   AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_ServiceItem_InfoMoney()
                          WHERE ObjectLink_Unit.DescId = zc_ObjectLink_ServiceItem_Unit()
                            AND COALESCE (ObjectLink_Unit.ChildObjectId,0) = inUnitId
                            AND (COALESCE (ObjectLink_InfoMoney.ChildObjectId,0) = COALESCE (inInfoMoneyId,0))
                          )

     , ObjectHistory_ServiceItem AS (SELECT * FROM ObjectHistory
                                     WHERE ObjectHistory.ObjectId IN (SELECT DISTINCT tmpServiceItem.ObjectId FROM tmpServiceItem)
                                       AND ObjectHistory.DescId = zc_ObjectHistory_ServiceItem()
                                       AND inOperDate >= ObjectHistory.StartDate AND inOperDate < ObjectHistory.EndDate
                                    )


       SELECT
             ObjectHistory_ServiceItem.Id                                   AS Id
           , COALESCE(ObjectHistory_ServiceItem.StartDate, CURRENT_DATE) ::TDateTime AS StartDate
           --, COALESCE(ObjectHistory_ServiceItem.EndDate, zc_DateEnd()) AS EndDate

           , Object_Unit.Id                                                 AS UnitId
           , Object_Unit.ValueData                                          AS UnitName

           , Object_InfoMoney.Id                                            AS InfoMoneyId
           , Object_InfoMoney.ObjectCode                                    AS InfoMoneyCode
           , Object_InfoMoney.ValueData                                     AS InfoMoneyName
           , Object_CommentInfoMoney.Id                                     AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData                              AS CommentInfoMoneyName

           , ObjectHistoryFloat_ServiceItem_Value.ValueData                 AS Value
           , ObjectHistoryFloat_ServiceItem_Price.ValueData                 AS Price
           , ObjectHistoryFloat_ServiceItem_Area.ValueData                  AS Area

       FROM ObjectHistory_ServiceItem
            /*FULL JOIN (SELECT zc_DateStart() AS StartDate, inUnitId AS ObjectId ) AS Empty
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
;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_ObjectHistory_ServiceItem (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.04.16         * add InvNumberBranch 
 26.11.15         * add MainName
 18.02.14                        *
*/

-- тест
-- SELECT * FROM gpGet_ObjectHistory_ServiceItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP, zfCalc_UserAdmin())
