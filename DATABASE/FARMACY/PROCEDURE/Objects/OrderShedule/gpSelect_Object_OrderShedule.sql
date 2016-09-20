-- Function: gpSelect_Object_OrderShedule()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderShedule(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderShedule(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer,
               Value1 TFloat, Value2 TFloat, Value3 TFloat, Value4 TFloat, 
               Value5 TFloat, Value6 TFloat, Value7 TFloat, Value8 TVarChar,
               OurJuridicalName TVarChar,
               UnitId Integer, UnitName TVarChar,
               JuridicalName TVarChar,
               ContractId Integer, ContractName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_OrderShedule());

   RETURN QUERY 
       SELECT 
             Object_OrderShedule.Id           AS Id
           , Object_OrderShedule.ObjectCode   AS Code
       
           , '0' ::TFloat   AS Value1
           , '1' ::TFloat   AS Value2
           , '2' ::TFloat   AS Value3
           , '3' ::TFloat   AS Value4
           , '0' ::TFloat   AS Value5
           , '0' ::TFloat   AS Value6
           , '0' ::TFloat   AS Value7
           , Object_OrderShedule.ValueData ::TVarChar   AS Value8
         
           , Object_Unit_Juridical.ValueData  AS OurJuridicalName
           , Object_Unit.Id                   AS UnitId
           , Object_Unit.ValueData            AS UnitName 

           , Object_Contract_Juridical.ValueData  AS JuridicalName
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ValueData            AS ContractName 
                     
           , Object_OrderShedule.isErased     AS isErased
           
       FROM Object AS Object_OrderShedule
           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Contract
                                ON ObjectLink_OrderShedule_Contract.ObjectId = Object_OrderShedule.Id
                               AND ObjectLink_OrderShedule_Contract.DescId = zc_ObjectLink_OrderShedule_Contract()
           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_OrderShedule_Contract.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_OrderShedule_Unit
                                ON ObjectLink_OrderShedule_Unit.ObjectId = Object_OrderShedule.Id
                               AND ObjectLink_OrderShedule_Unit.DescId = zc_ObjectLink_OrderShedule_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderShedule_Unit.ChildObjectId    

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Unit_Juridical ON Object_Unit_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId       

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                ON ObjectLink_Contract_Juridical.ObjectId = Object_Contract.Id
                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
           LEFT JOIN Object AS Object_Contract_Juridical ON Object_Contract_Juridical.Id = ObjectLink_Contract_Juridical.ChildObjectId   

       WHERE Object_OrderShedule.DescId = zc_Object_OrderShedule();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_OrderShedule(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderShedule ('2')