-- Названия накопительных скидок

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountPeriod (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountPeriod(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет 
    IN inSession     TVarChar            -- сессия пользователя   
)
RETURNS TABLE (Id Integer, Code Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PeriodId Integer, PeriodCode Integer, PeriodName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountPeriod());


   -- результат
   RETURN QUERY
       SELECT
             Object_DiscountPeriod.Id              AS Id
           , Object_DiscountPeriod.ObjectCode      AS Code
           , Object_Unit.Id                        AS UnitId
           , Object_Unit.ObjectCode                AS UnitCode
           , Object_Unit.ValueData                 AS UnitName
           , Object_Period.Id                      AS PeriodId
           , Object_Period.ObjectCode              AS PeriodCode
           , Object_Period.ValueData               AS PeriodName
           , ObjectDate_StartDate.ValueData        AS StartDate
           , ObjectDate_EndDate.ValueData          AS EndDate
           , Object_DiscountPeriod.isErased        AS isErased

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

       WHERE Object_DiscountPeriod.DescId = zc_Object_DiscountPeriod()
         AND (Object_DiscountPeriod.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
22.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountPeriod (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
