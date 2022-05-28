-- Function: gpGet_ObjectHistory_ServiceItem ()

---DROP FUNCTION IF EXISTS gpGet_ObjectHistory_ServiceItem (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ObjectHistory_ServiceItem (Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_ObjectHistory_ServiceItem (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_ServiceItem(
    IN inId                 Integer   , --
    IN inUnitId             Integer   , --
    IN inInfoMoneyId        Integer   , --
    IN inStartDate          TDateTime , -- Дата Истории
    IN inEndDate            TDateTime , -- Дата Истории
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyName TVarChar
             , Value TFloat, Price TFloat, Area TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     -- Выбираем данные
     RETURN QUERY
       WITH tmpServiceItem AS (SELECT ObjectLink_Unit.ObjectId           AS ObjectId
                                    , ObjectLink_Unit.ChildObjectId      AS UnitId
                                    , ObjectLink_InfoMoney.ChildObjectId AS InfoMoneyId
                               FROM ObjectLink AS ObjectLink_Unit
                                    LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                         ON ObjectLink_InfoMoney.ObjectId = ObjectLink_Unit.ObjectId
                                                        AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_ServiceItem_InfoMoney()
                               WHERE ObjectLink_Unit.DescId             = zc_ObjectLink_ServiceItem_Unit()
                                 AND ObjectLink_Unit.ChildObjectId      = inUnitId
                                 AND ObjectLink_InfoMoney.ChildObjectId = inInfoMoneyId
                               )
            -- Ищем не по inId а по параметрам
          , ObjectHistory_ServiceItem AS (SELECT * FROM ObjectHistory
                                          WHERE ObjectHistory.ObjectId = (SELECT DISTINCT tmpServiceItem.ObjectId FROM tmpServiceItem)
                                            AND ObjectHistory.DescId   = zc_ObjectHistory_ServiceItem()
                                            AND inStartDate BETWEEN ObjectHistory.StartDate AND ObjectHistory.EndDate
                                         )
       -- Результат
       SELECT
             ObjectHistory_ServiceItem.Id                                   AS Id
           , CASE WHEN inId > 0 THEN inStartDate WHEN ObjectHistory_ServiceItem.ObjectId IS NULL THEN DATE_TRUNC ('MONTH', CURRENT_DATE)                                          ELSE inEndDate + INTERVAL '1 DAY'  END :: TDateTime AS StartDate
           , CASE WHEN inId > 0 THEN inEndDate   WHEN ObjectHistory_ServiceItem.ObjectId IS NULL THEN DATE_TRUNC ('MONTH', CURRENT_DATE) + INTERVAL '13 MONTH' - INTERVAL '1 DAY' ELSE inEndDate + INTERVAL '1 YEAR' END :: TDateTime AS EndDate

           , Object_Unit.Id                                                 AS UnitId
           , TRIM (COALESCE (ObjectString_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName

           , Object_InfoMoney.Id                                            AS InfoMoneyId
           , Object_InfoMoney.ObjectCode                                    AS InfoMoneyCode
           , Object_InfoMoney.ValueData                                     AS InfoMoneyName
           , CASE WHEN TRIM (Object_CommentInfoMoney.ValueData) = '' THEN 0 ELSE Object_CommentInfoMoney.Id END  :: Integer AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ValueData                              AS CommentInfoMoneyName

           , CASE WHEN inId > 0 THEN ObjectHistoryFloat_ServiceItem_Value.ValueData ELSE 0 END :: TFloat AS Value
           , CASE WHEN inId > 0 THEN ObjectHistoryFloat_ServiceItem_Price.ValueData ELSE 0 END :: TFloat AS Price
           , ObjectHistoryFloat_ServiceItem_Area.ValueData                                               AS Area

       FROM tmpServiceItem
            LEFT JOIN ObjectHistory_ServiceItem ON ObjectHistory_ServiceItem.ObjectId = tmpServiceItem.ObjectId

            LEFT JOIN Object AS Object_Unit      ON Object_Unit.Id      = tmpServiceItem.UnitId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpServiceItem.InfoMoneyId

            LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                                   ON ObjectString_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_GroupNameFull.DescId = zc_ObjectString_Unit_GroupNameFull()

            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_CommentInfoMoney
                                        ON ObjectHistoryLink_CommentInfoMoney.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                       AND ObjectHistoryLink_CommentInfoMoney.DescId          = zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = ObjectHistoryLink_CommentInfoMoney.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Value
                                         ON ObjectHistoryFloat_ServiceItem_Value.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Value.DescId          = zc_ObjectHistoryFloat_ServiceItem_Value()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Price
                                         ON ObjectHistoryFloat_ServiceItem_Price.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Price.DescId          = zc_ObjectHistoryFloat_ServiceItem_Price()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ServiceItem_Area
                                         ON ObjectHistoryFloat_ServiceItem_Area.ObjectHistoryId = ObjectHistory_ServiceItem.Id
                                        AND ObjectHistoryFloat_ServiceItem_Area.DescId          = zc_ObjectHistoryFloat_ServiceItem_Area()

      ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.04.16         * add InvNumberBranch
 26.11.15         * add MainName
 18.02.14                        *
*/

-- тест
-- SELECT * FROM gpGet_ObjectHistory_ServiceItem (zc_PriceList_ProductionSeparate(), CURRENT_TIMESTAMP, zfCalc_UserAdmin())
