-- Function: gpInsertUpdate_Object_DiscountExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternal(
 INOUT ioId                            Integer   , -- ключ объекта
    IN inCode                          Integer   , -- код объекта 
    IN inName                          TVarChar  , -- значение
    IN inURL                           TVarChar  , --
    IN inService                       TVarChar  , -- 
    IN inPort                          TVarChar  , -- 
    IN inisGoodsForProject             Boolean   , -- Товар только для проекта (дисконтные карты)
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternal());
   vbUserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_DiscountExternal());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternal(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_URL(), ioId, inURL);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_Service(), ioId, inService);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_DiscountExternal_Port(), ioId, inPort);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_DiscountExternal_GoodsForProject(), ioId, inisGoodsForProject);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternal (ioId:=0, inCode:=0, inValue:='КУКУ', inDiscountExternalKindId:=0, inSession:='2')
-- Function: gpGet_Object_DiscountExternal_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternal_Unit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternal_Unit(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , URL          TVarChar
             , Service      TVarChar
             , Port         TVarChar
             , UserName     TVarChar
             , Password     TVarChar
             , ExternalUnit TVarChar
              )
AS
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

       -- Результат
       RETURN QUERY
       SELECT
             Object_DiscountExternal.Id         AS Id
           , Object_DiscountExternal.ObjectCode AS Code
           , Object_DiscountExternal.ValueData  AS Name

           , ObjectString_URL.ValueData       AS URL
           , ObjectString_Service.ValueData   AS Service
           , ObjectString_Port.ValueData      AS Port

           , CASE WHEN COALESCE (ObjectBoolean_NotUseAPI.ValueData, False) = TRUE THEN '' ELSE ObjectString_User.ValueData END::TVarChar  AS UserName
           , CASE WHEN COALESCE (ObjectBoolean_NotUseAPI.ValueData, False) = TRUE THEN '' ELSE ObjectString_Password.ValueData END::TVarChar         AS Password
           , CASE WHEN COALESCE (ObjectBoolean_NotUseAPI.ValueData, False) = TRUE THEN '' ELSE ObjectString_ExternalUnit.ValueData END::TVarChar     AS ExternalUnit

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
            INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ChildObjectId = Object_DiscountExternal.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
            INNER JOIN ObjectLink AS ObjectLink_Unit
                                  ON ObjectLink_Unit.ObjectId      = ObjectLink_DiscountExternal.ObjectId
                                 AND ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountExternalTools_Unit()
                                 AND ObjectLink_Unit.ChildObjectId = vbUnitId

            LEFT JOIN ObjectString AS ObjectString_User
                                   ON ObjectString_User.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_User.DescId = zc_ObjectString_DiscountExternalTools_User()
            LEFT JOIN ObjectString AS ObjectString_Password
                                   ON ObjectString_Password.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_Password.DescId = zc_ObjectString_DiscountExternalTools_Password()
            LEFT JOIN ObjectString AS ObjectString_ExternalUnit
                                   ON ObjectString_ExternalUnit.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                  AND ObjectString_ExternalUnit.DescId = zc_ObjectString_DiscountExternalTools_ExternalUnit()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotUseAPI
                                    ON ObjectBoolean_NotUseAPI.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                   AND ObjectBoolean_NotUseAPI.DescId = zc_ObjectBoolean_DiscountExternalTools_NotUseAPI()

       WHERE Object_DiscountExternal.Id = inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountExternal_Unit (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 29.05.17                                                       * ExternalUnit
 12.08.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountExternal_Unit (2488964, zfCalc_UserAdmin())
