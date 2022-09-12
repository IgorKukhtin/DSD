-- Function: gpSelect_Object_InternetRepair(Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InternetRepair (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InternetRepair(
    IN inIsShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Provider TVarChar, ContractNumber TVarChar, Phone TVarChar, WhoSignedContract TVarChar, Notes TBlob
             , NotesVarChar TVarChar
             , isErased Boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY 
       SELECT
              Object_InternetRepair.Id                       AS Id 
            , Object_InternetRepair.ObjectCode               AS Code
            , Object_InternetRepair.ValueData                AS Name
            , Object_Unit.Id                                 AS UnitID 
            , Object_Unit.ObjectCode                         AS UnitCode
            , Object_Unit.ValueData                          AS UnitName
            
            , ObjectString_Provider.ValueData                AS Provider
            , ObjectString_ContractNumber.ValueData          AS ContractNumber
            , ObjectString_Phone.ValueData                   AS Phone
            , ObjectString_WhoSignedContract.ValueData       AS WhoSignedContract
            , ObjectBlob_Notes.ValueData                     AS Notes
            
            , REPLACE(ObjectBlob_Notes.ValueData, CHR(13)||CHR(10), ' ')::TVarChar           AS NotesVarChar
            
            , Object_InternetRepair.isErased                 AS isErased
       FROM Object AS Object_InternetRepair

           LEFT JOIN ObjectLink AS ObjectLink_InternetRepair
                                ON ObjectLink_InternetRepair.ObjectId = Object_InternetRepair.Id
                               AND ObjectLink_InternetRepair.DescId = zc_ObjectLink_InternetRepair_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_InternetRepair.ChildObjectId
           
           LEFT JOIN ObjectString AS ObjectString_Provider
                                  ON ObjectString_Provider.ObjectId = Object_InternetRepair.Id
                                 AND ObjectString_Provider.DescId = zc_ObjectString_InternetRepair_Provider()
           LEFT JOIN ObjectString AS ObjectString_ContractNumber
                                  ON ObjectString_ContractNumber.ObjectId = Object_InternetRepair.Id
                                 AND ObjectString_ContractNumber.DescId = zc_ObjectString_InternetRepair_ContractNumber()
           LEFT JOIN ObjectString AS ObjectString_Phone
                                  ON ObjectString_Phone.ObjectId = Object_InternetRepair.Id
                                 AND ObjectString_Phone.DescId = zc_ObjectString_InternetRepair_Phone()
           LEFT JOIN ObjectString AS ObjectString_WhoSignedContract
                                  ON ObjectString_WhoSignedContract.ObjectId = Object_InternetRepair.Id
                                 AND ObjectString_WhoSignedContract.DescId = zc_ObjectString_InternetRepair_WhoSignedContract()

           LEFT JOIN ObjectBlob AS ObjectBlob_Notes
                                ON ObjectBlob_Notes.ObjectId = Object_InternetRepair.Id
                               AND ObjectBlob_Notes.DescId = zc_ObjectBlob_InternetRepair_Notes()

       WHERE Object_InternetRepair.DescId = zc_Object_InternetRepair()
         AND (Object_InternetRepair.isErased = False OR inIsShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  ALTER FUNCTION gpSelect_Object_InternetRepair (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.09.22                                                       *              
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_InternetRepair (false, zfCalc_UserAdmin())