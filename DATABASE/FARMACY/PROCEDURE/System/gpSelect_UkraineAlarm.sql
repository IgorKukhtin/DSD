-- Function:  gpSelect_UkraineAlarm

DROP FUNCTION IF EXISTS gpSelect_UkraineAlarm (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_UkraineAlarm (
    IN inStartDate TDateTime,
    IN inEndDate TDateTime,
    IN inSession TVarChar
)
RETURNS TABLE (ID            Integer
             , regionId      Integer
             , regionName    TVarChar
             , startDate     TDateTime
             , endDate       TDateTime
             , alertType     TVarChar
             , Color_Calc    Integer
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- для остальных...
   RETURN QUERY
   SELECT UkraineAlarm.ID
        , UkraineAlarm.regionId
        , CASE WHEN UkraineAlarm.regionId = 42 THEN 'Кам’янський район'
               WHEN UkraineAlarm.regionId = 44 THEN 'Дніпровський район'
               WHEN UkraineAlarm.regionId = 47 THEN 'Нікопольський район'
               WHEN UkraineAlarm.regionId = 332 THEN 'м. Дніпро та Дніпровська територіальна громада'
               WHEN UkraineAlarm.regionId = 351 THEN 'м. Нікополь та Нікопольська територіальна громада'
               WHEN UkraineAlarm.regionId = 300 THEN 'м. Кам’янське та Кам’янська територіальна громада'
               ELSE 'Дніпропетровська область' END::TVarChar
        , UkraineAlarm.startDate
        , UkraineAlarm.endDate
        , UkraineAlarm.alertType
        , CASE WHEN UkraineAlarm.endDate IS NULL THEN zc_Color_Red() ELSE zc_Color_White() END AS Color_Calc

   FROM UkraineAlarm
   WHERE UkraineAlarm.startDate >= inStartDate
     AND UkraineAlarm.startDate < inEndDate + INTERVAL '1 DAY';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.04.18        *                                                                         *

*/

-- тест
-- 
select * from gpSelect_UkraineAlarm ('2022-08-01'::TDateTime, '2022-08-31'::TDateTime, '3');