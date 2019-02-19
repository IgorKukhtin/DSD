-- Function: gpSelect_Object_UnitBankPOSTerminal_Link()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitBankPOSTerminal_Link (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitBankPOSTerminal_Link (
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (id Integer, UnitId Integer, BankPOSTerminalID Integer, 
               Code Integer, Name TVarChar, isErased Boolean
              ) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
         ObjectLink_UnitBankPOSTerminal_Unit.ObjectId                   AS ID
       , ObjectLink_UnitBankPOSTerminal_Unit.ChildObjectid              AS UnitId 
       , ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ChildObjectID   AS BankPOSTerminalID

       , Object_BankPOSTerminal.ObjectCode                              AS Code
       , Object_BankPOSTerminal.ValueData                               AS Name
       , Object_UnitBankPOSTerminal.isErased                            AS isErased

   FROM ObjectLink AS ObjectLink_UnitBankPOSTerminal_Unit
   
        JOIN ObjectLink AS ObjectLink_UnitBankPOSTerminal_BankPOSTerminal 
                        ON ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ObjectId = ObjectLink_UnitBankPOSTerminal_Unit.ObjectId
                       AND ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.DescId = zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal()
                       
        JOIN Object AS Object_UnitBankPOSTerminal
                    ON Object_UnitBankPOSTerminal.ID = ObjectLink_UnitBankPOSTerminal_Unit.ObjectId

        JOIN Object AS Object_BankPOSTerminal
                    ON Object_BankPOSTerminal.ID = ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ChildObjectId

   WHERE ObjectLink_UnitBankPOSTerminal_Unit.DescId = zc_ObjectLink_UnitBankPOSTerminal_Unit();        

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
-- SELECT * FROM gpSelect_Object_UnitBankPOSTerminal_Link( '3')
