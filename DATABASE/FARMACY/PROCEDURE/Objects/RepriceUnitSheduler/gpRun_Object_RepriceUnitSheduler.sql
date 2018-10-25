-- Function: gpRun_Object_RepriceUnitSheduler()

DROP FUNCTION IF EXISTS gpRun_Object_RepriceUnitSheduler(TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Object_RepriceUnitSheduler(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

    -- Переоценки
  PERFORM  gpRun_Object_RepriceUnitSheduler_UnitReprice(Object_RepriceUnitSheduler.Id, inSession)
  FROM Object AS Object_RepriceUnitSheduler
  WHERE Object_RepriceUnitSheduler.DescId = zc_Object_RepriceUnitSheduler()
    AND Object_RepriceUnitSheduler.isErased = FALSE;

    -- Уравнивание
  PERFORM  gpRun_Object_RepriceUnitSheduler_UnitEqual(Object_RepriceUnitSheduler.Id, ObjectLink_Unit_UnitRePrice.ChildObjectId, inSession)
  FROM Object AS Object_RepriceUnitSheduler

           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RepriceUnitSheduler_Unit()

           INNER JOIN ObjectBoolean AS ObjectBoolean_Equal
                                   ON ObjectBoolean_Equal.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectBoolean_Equal.DescId = zc_ObjectBoolean_RepriceUnitSheduler_Equal()
                                  AND ObjectBoolean_Equal.ValueData = TRUE

           LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitRePrice
                                 ON ObjectLink_Unit_UnitRePrice.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_UnitRePrice.DescId = zc_ObjectLink_Unit_UnitRePrice()


  WHERE Object_RepriceUnitSheduler.DescId = zc_Object_RepriceUnitSheduler()
    AND Object_RepriceUnitSheduler.isErased = FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRun_Object_RepriceUnitSheduler(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 22.10.18        *
*/

-- тест
-- SELECT * FROM gpRun_Object_RepriceUnitSheduler ('3')