DROP FUNCTION IF EXISTS gpGetToolsPropertyId (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpGetToolsPropertyId(
    IN inLevel1                  TVarChar  ,
    IN inLevel2                  TVarChar  ,
    IN inLevel3                  TVarChar  ,
    IN inLevel4                  TVarChar  ,
    IN inSession                 TVarChar
)
RETURNS TABLE (Value Integer)
--  RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbToolsId Integer;
   DECLARE vbParentId Integer;
   DECLARE vbNameFull TVarChar;
   DECLARE vbValueData TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());
    vbNameFull := inLevel1;

   IF inLevel2 <> '' THEN
    vbNameFull := vbNameFull ||' '|| inLevel2;
   END IF;

   IF inLevel3 <> '' THEN
    vbNameFull := vbNameFull ||' '|| inLevel3;
   END IF;

   IF inLevel4 <> '' THEN
    vbNameFull := vbNameFull ||' '|| inLevel4;
   END IF;

    RETURN QUERY
       SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View WHERE Object_ToolsWeighing_View.NameFull=vbNameFull;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetToolsPropertyId (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Movement', 'MovementDesc_1', '', '98751', '2');
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Movement', 'MovementDesc_1', 'DescId', '6',  '2');
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Movement', 'MovementDesc_1', 'FromId', '0', '2');
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Movement', 'MovementDesc_1', 'ToId', '0', '2');
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Movement', 'MovementDesc_1', 'PaidKindId', '0', '2');
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Service', 'ComPort', '', '1', 'Ком порт', '2');
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Service', 'isPreviewPrint', '', 'false', '2');
-- SELECT * FROM gpGetToolsPropertyId ('Scale_1', 'Service', 'isActivef4545', '', '2');
