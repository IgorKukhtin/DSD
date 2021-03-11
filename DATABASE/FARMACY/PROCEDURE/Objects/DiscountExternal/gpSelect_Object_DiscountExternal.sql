-- Function: gpSelect_Object_DiscountExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountExternal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountExternal(
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , URL TVarChar
             , Service TVarChar
             , Port TVarChar
             , isGoodsForProject Boolean
             , isOneSupplier Boolean
             , isTwoPackages Boolean
             , isErased Boolean
              ) AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternal());
     vbUserId := lpGetUserBySession (inSession);

     vbUnitKey := COALESCE (lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey :: Integer;
     IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                   WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
     THEN
       vbUnitId := 0;
     END IF;


   RETURN QUERY 
   SELECT Object_DiscountExternal.Id               AS Id
        , Object_DiscountExternal.ObjectCode       AS Code
        , Object_DiscountExternal.ValueData        AS Name

        , ObjectString_URL.ValueData               AS URL
        , ObjectString_Service.ValueData           AS Service
        , ObjectString_Port.ValueData              AS Port
        , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
        , COALESCE(ObjectBoolean_OneSupplier.ValueData, False)      AS isOneSupplier
        , COALESCE(ObjectBoolean_TwoPackages.ValueData, False)      AS isTwoPackages

        , Object_DiscountExternal.isErased

   FROM Object AS Object_DiscountExternal
      LEFT JOIN ObjectString AS ObjectString_URL
                             ON ObjectString_URL.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_URL.DescId = zc_ObjectString_DiscountExternal_URL()
      LEFT JOIN ObjectString AS ObjectString_Service
                             ON ObjectString_Service.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_Service.DescId = zc_ObjectString_DiscountExternal_Service()
      LEFT JOIN ObjectString AS ObjectString_Port
                             ON ObjectString_Port.ObjectId = Object_DiscountExternal.Id 
                            AND ObjectString_Port.DescId = zc_ObjectString_DiscountExternal_Port()
      LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                              ON ObjectBoolean_GoodsForProject.ObjectId = Object_DiscountExternal.Id 
                             AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()
      LEFT JOIN ObjectBoolean AS ObjectBoolean_OneSupplier
                              ON ObjectBoolean_OneSupplier.ObjectId = Object_DiscountExternal.Id 
                             AND ObjectBoolean_OneSupplier.DescId = zc_ObjectBoolean_DiscountExternal_OneSupplier()
      LEFT JOIN ObjectBoolean AS ObjectBoolean_TwoPackages
                              ON ObjectBoolean_TwoPackages.ObjectId = Object_DiscountExternal.Id 
                             AND ObjectBoolean_TwoPackages.DescId = zc_ObjectBoolean_DiscountExternal_TwoPackages()
   WHERE Object_DiscountExternal.DescId = zc_Object_DiscountExternal()
     AND (vbUnitId = 0
       OR COALESCE (ObjectString_URL.ValueData, '') = ''
       OR Object_DiscountExternal.Id IN (SELECT ObjectLink_DiscountExternal.ChildObjectId
                                         FROM ObjectLink AS ObjectLink_Unit
                                              INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                                    ON ObjectLink_DiscountExternal.ObjectId = ObjectLink_Unit.ObjectId
                                                                   AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                              INNER JOIN Object AS Object_DiscountExternalTools ON Object_DiscountExternalTools.ID = ObjectLink_Unit.ObjectId
                                                               AND Object_DiscountExternalTools.isErased = False
                                         WHERE ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountExternalTools_Unit()
                                           AND ObjectLink_Unit.ChildObjectId = vbUnitId
                                        ) AND Object_DiscountExternal.isErased = False
         );
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_DiscountExternal ('3')

select * from gpSelect_Object_DiscountExternal( inSession := '3991136');