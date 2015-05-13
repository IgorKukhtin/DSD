-- Function: gpSelect_Object_GlobalConst()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, ValueText TVarChar, EnumName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       SELECT Object_GlobalConst.Id
            , COALESCE (ActualBankStatement.ValueData, CURRENT_DATE) :: TDateTime AS OperDate
            , Object_GlobalConst.ValueData AS ValueText
            , ObjectString.ValueData AS EnumName
       FROM Object AS Object_GlobalConst
            LEFT JOIN ObjectDate AS ActualBankStatement 
                                 ON ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()
                                AND ActualBankStatement.ObjectId = Object_GlobalConst.Id
            LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_GlobalConst.Id
                                  AND ObjectString.DescId = zc_ObjectString_Enum()
       WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
         AND Object_GlobalConst.ObjectCode < 100
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConst(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                                        * add EnumName
 06.04.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GlobalConst (zfCalc_UserAdmin())
