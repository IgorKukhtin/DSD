-- Function: gpSelect_Cash_BankPOSTerminal()

DROP FUNCTION IF EXISTS gpSelect_Cash_BankPOSTerminal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_BankPOSTerminal (
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (id Integer, Code Integer, Name TVarChar
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;


   RETURN QUERY
   SELECT
         Object_BankPOSTerminal.Id                                      AS Id
       , Object_BankPOSTerminal.ObjectCode                              AS Code
       , Object_BankPOSTerminal.ValueData                               AS Name

   FROM ObjectLink AS ObjectLink_UnitBankPOSTerminal_Unit

        JOIN ObjectLink AS ObjectLink_UnitBankPOSTerminal_BankPOSTerminal
                        ON ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ObjectId = ObjectLink_UnitBankPOSTerminal_Unit.ObjectId
                       AND ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.DescId = zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal()

        JOIN Object AS Object_UnitBankPOSTerminal
                    ON Object_UnitBankPOSTerminal.ID = ObjectLink_UnitBankPOSTerminal_Unit.ObjectId

        JOIN Object AS Object_BankPOSTerminal
                    ON Object_BankPOSTerminal.ID = ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ChildObjectId

   WHERE ObjectLink_UnitBankPOSTerminal_Unit.DescId = zc_ObjectLink_UnitBankPOSTerminal_Unit()
     AND COALESCE (Object_UnitBankPOSTerminal.isErased, False) = False
     AND ObjectLink_UnitBankPOSTerminal_Unit.ChildObjectid = vbUnitId;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.02.19                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_Cash_BankPOSTerminal( '308120')