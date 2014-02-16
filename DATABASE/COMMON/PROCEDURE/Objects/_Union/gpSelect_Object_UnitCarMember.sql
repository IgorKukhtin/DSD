-- Function: gpSelect_Object_UnitCarMember()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitCarMember (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitCarMember(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, DescName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_UnitCarMember());
     vbUserId := inSession;

     RETURN QUERY
       
     SELECT Object_Unit.Id
          , Object_Unit.ObjectCode AS Code
          , Object_Unit.ValueData AS Name
           
          , ObjectDesc.ItemName AS DescName
          , Object_Unit.isErased
     FROM Object AS Object_Unit
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
         
     WHERE Object_Unit.DescId = Zc_Object_Unit()
   UNION ALL
     SELECT Object_Car.Id
          , Object_Car.ObjectCode AS Code     
          , Object_Car.ValueData AS Name
          
          , ObjectDesc.ItemName AS DescName
          , Object_Car.isErased
     FROM Object AS Object_Car
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Car.DescId
     WHERE Object_Car.DescId = zc_Object_Car()
   UNION ALL
     SELECT Object_Member.Id
          , Object_Member.ObjectCode AS Code     
          , Object_Member.ValueData AS Name
          
          , ObjectDesc.ItemName AS DescName
          , Object_Member.isErased
     FROM Object AS Object_Member
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
     WHERE Object_Member.DescId = zc_Object_Member()   
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UnitCarMember (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitCarMember (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_UnitCarMember (inSession := '9818')
