-- Function: gpSelect_Object_CardFuel (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CardFuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CardFuel(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PersonalDriverId Integer, PersonalDriverCode Integer, PersonalDriverName TVarChar
             , CarId Integer, CarCode Integer, CarName TVarChar
             , PaidKindId Integer, PaidKindCode Integer, PaidKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_CardFuel());

   RETURN QUERY 
       SELECT
             Object_CardFuel.Id         AS Id
           , Object_CardFuel.ObjectCode AS Code
           , Object_CardFuel.ValueData  AS NAME
                      
           , Object_PersonalDriver.Id         AS PersonalDriverId 
           , Object_PersonalDriver.ObjectCode AS PersonalDriverCode
           , Object_PersonalDriver.ValueData  AS PersonalDriverName

           , Object_Car.Id         AS CarId 
           , Object_Car.ObjectCode AS CarCode
           , Object_Car.ValueData  AS CarName
           
           , Object_PaidKind.Id         AS PaidKindId 
           , Object_PaidKind.ObjectCode AS PaidKindCode
           , Object_PaidKind.ValueData  AS PaidKindName
                       
           , Object_Juridical.Id         AS JuridicalId 
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName
           
           , Object_Goods.Id         AS GoodsId 
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName            
            
           , Object_CardFuel.isErased   AS isErased
           
       FROM Object AS Object_CardFuel
            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PersonalDriver ON ObjectLink_CardFuel_PersonalDriver.ObjectId = Object_CardFuel.Id
                                                         AND ObjectLink_CardFuel_PersonalDriver.DescId = zc_ObjectLink_CardFuel_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_CardFuel_PersonalDriver.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Car ON ObjectLink_CardFuel_Car.ObjectId = Object_CardFuel.Id
                                                         AND ObjectLink_CardFuel_Car.DescId = zc_ObjectLink_CardFuel_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_CardFuel_Car.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_PaidKind ON ObjectLink_CardFuel_PaidKind.ObjectId = Object_CardFuel.Id
                                                         AND ObjectLink_CardFuel_PaidKind.DescId = zc_ObjectLink_CardFuel_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_CardFuel_PaidKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical ON ObjectLink_CardFuel_Juridical.ObjectId = Object_CardFuel.Id
                                                         AND ObjectLink_CardFuel_Juridical.DescId = zc_ObjectLink_CardFuel_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_CardFuel_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Goods ON ObjectLink_CardFuel_Goods.ObjectId = Object_CardFuel.Id
                                                         AND ObjectLink_CardFuel_Goods.DescId = zc_ObjectLink_CardFuel_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_CardFuel_Goods.ChildObjectId
   
   WHERE Object_CardFuel.DescId = zc_Object_CardFuel();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CardFuel (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.13          *  add Unit, CardFuelKind, Freight

*/

-- тест
-- SELECT * FROM gpSelect_Object_CardFuel('2')
