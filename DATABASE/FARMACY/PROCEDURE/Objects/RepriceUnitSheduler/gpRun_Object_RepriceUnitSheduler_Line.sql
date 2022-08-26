-- Function: gpRun_Object_RepriceUnitSheduler_Line()

DROP FUNCTION IF EXISTS gpRun_Object_RepriceUnitSheduler_Line(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Object_RepriceUnitSheduler_Line(
    IN InId                Integer,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());
   

    -- Переоценки
  PERFORM  gpRun_Object_RepriceUnitSheduler_UnitReprice(Object_RepriceUnitSheduler.Id, 
                                                        COALESCE (ObjectLink_User.ChildObjectId::TVarChar, inSession))
  FROM Object AS Object_RepriceUnitSheduler

           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RepriceUnitSheduler_Unit()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()  

           LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RepriceUnitSheduler_User()

  WHERE Object_RepriceUnitSheduler.DescId = zc_Object_RepriceUnitSheduler()
    AND Object_RepriceUnitSheduler.isErased = FALSE
    AND Object_RepriceUnitSheduler.Id = InId;
    

    -- Уравнивание
  PERFORM  gpRun_Object_RepriceUnitSheduler_UnitEqual(Object_RepriceUnitSheduler.Id, 
                                                      ObjectLink_Unit_UnitRePrice.ChildObjectId, 
                                                      COALESCE (ObjectLink_User.ChildObjectId::TVarChar, inSession))
  FROM Object AS Object_RepriceUnitSheduler

           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RepriceUnitSheduler_Unit()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()  

           INNER JOIN ObjectBoolean AS ObjectBoolean_Equal
                                   ON ObjectBoolean_Equal.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectBoolean_Equal.DescId = zc_ObjectBoolean_RepriceUnitSheduler_Equal()
                                  AND ObjectBoolean_Equal.ValueData = TRUE

           LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitRePrice
                                 ON ObjectLink_Unit_UnitRePrice.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_UnitRePrice.DescId = zc_ObjectLink_Unit_UnitRePrice()

           LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RepriceUnitSheduler_User()

  WHERE Object_RepriceUnitSheduler.DescId = zc_Object_RepriceUnitSheduler()
    AND Object_RepriceUnitSheduler.isErased = FALSE
    AND Object_RepriceUnitSheduler.Id = InId;

  -- !!!ВРЕМЕННО для ТЕСТА!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', InId, inSession;
  END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRun_Object_RepriceUnitSheduler_Line(Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 26.08.22        *
*/

-- тест
-- 
SELECT * FROM gpRun_Object_RepriceUnitSheduler_Line (0, '3')