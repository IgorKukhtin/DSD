-- Названия накопительных скидок

DROP FUNCTION IF EXISTS gpGet_Object_DiscountPeriod (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountPeriod(
    IN inId          Integer,       -- Ключь <Названия накопительных скидок>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , UnitId Integer, UnitName TVarChar
             , PeriodId Integer, PeriodName TVarChar
             , StartDate TDateTime, EndDate TDateTime
) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountPeriod());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                              AS Id
           , lfGet_ObjectCode(0, zc_Object_DiscountPeriod())  AS Code
           ,  0 :: Integer                              AS UnitId
           , '' :: TVarChar                             AS UnitName
           ,  0 :: Integer                              AS PeriodId
           , '' :: TVarChar                             AS PeriodName
           , CURRENT_DATE :: TDateTime                  AS StartDate   
           , CURRENT_DATE :: TDateTime                  AS EndDate   
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_DiscountPeriod.Id              AS Id
           , Object_DiscountPeriod.ObjectCode      AS Code
           , Object_Unit.Id                        AS UnitId
           , Object_Unit.ValueData                 AS UnitName
           , Object_Period.Id                      AS PeriodId
           , Object_Period.ValueData               AS PeriodName
           , ObjectDate_StartDate.ValueData        AS StartDate
           , ObjectDate_EndDate.ValueData          AS EndDate

       FROM Object as Object_DiscountPeriod
            LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriod_Unit
                                 ON ObjectLink_DiscountPeriod_Unit.ObjectId = Object_DiscountPeriod.Id
                                AND ObjectLink_DiscountPeriod_Unit.DescId = zc_ObjectLink_DiscountPeriod_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_DiscountPeriod_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriod_Period
                                 ON ObjectLink_DiscountPeriod_Period.ObjectId = Object_DiscountPeriod.Id
                                AND ObjectLink_DiscountPeriod_Period.DescId = zc_ObjectLink_DiscountPeriod_Period()
            LEFT JOIN Object AS Object_Period ON Object_Period.Id = ObjectLink_DiscountPeriod_Period.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_StartDate 
                                 ON ObjectDate_StartDate.ObjectId = Object_DiscountPeriod.Id
                                AND ObjectDate_StartDate.DescId = zc_ObjectDate_DiscountPeriod_StartDate()

            LEFT JOIN ObjectDate AS ObjectDate_EndDate 
                                 ON ObjectDate_EndDate.ObjectId = Object_DiscountPeriod.Id
                                AND ObjectDate_EndDate.DescId = zc_ObjectDate_DiscountPeriod_EndDate()
       WHERE Object_DiscountPeriod.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 23.02.18         *
*/

-- тест
-- SELECT * FROM gpSelect_DiscountPeriod (1,'2')
