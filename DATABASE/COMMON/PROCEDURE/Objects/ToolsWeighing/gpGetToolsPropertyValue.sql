DROP FUNCTION IF EXISTS gpGetToolsPropertyValue (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpGetToolsPropertyValue(
    IN inLevel1                  TVarChar  ,
    IN inLevel2                  TVarChar  ,
    IN inLevel3                  TVarChar  ,
    IN inLevel4                  TVarChar  ,
    IN inValueData               TVarChar  ,
    IN inSession                 TVarChar
)
RETURNS TABLE (Value TVarChar)
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

   vbValueData := (SELECT Object_ToolsWeighing_View.ValueData FROM Object_ToolsWeighing_View WHERE Object_ToolsWeighing_View.NameFull=vbNameFull);

   --если не найдено значение по указанному пути
   IF COALESCE (vbValueData,'-99999999999999999')='-99999999999999999' THEN
    vbValueData := '';
    vbParentId := 0;
    -- 1
    IF inLevel1 <> '' THEN
      vbToolsId := 0;
      IF inLevel2 = '' THEN vbValueData := inValueData; END IF;
      vbToolsId := (SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View
                    WHERE Object_ToolsWeighing_View.Name = inLevel1
                      AND Object_ToolsWeighing_View.isLeaf = FALSE
                      AND ((Object_ToolsWeighing_View.ParentID = vbParentId) OR (Object_ToolsWeighing_View.ParentID IS NULL)));

      IF COALESCE(vbToolsId, 0) = 0 THEN
        vbToolsId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, vbValueData, inLevel1, inLevel1, '', vbParentId, inSession);
      END IF;
      vbParentId := vbToolsId;
    END IF;
    -- 1
    -- 2
    IF inLevel2 <> '' THEN
      vbToolsId := 0;
      IF inLevel3 = '' THEN vbValueData := inValueData; END IF;
      vbToolsId := (SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View
                    WHERE Object_ToolsWeighing_View.Name = inLevel2
                      AND Object_ToolsWeighing_View.isLeaf = FALSE
                      AND Object_ToolsWeighing_View.ParentID = vbParentId);

      IF COALESCE(vbToolsId, 0) = 0 THEN
        vbToolsId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, vbValueData, inLevel2, inLevel1||' '||inLevel2, '', vbParentId, inSession);
      END IF;
      vbParentId := vbToolsId;
    END IF;
    -- 2
    -- 3
    IF inLevel3 <> '' THEN
      vbToolsId := 0;
      IF inLevel4 = '' THEN vbValueData := inValueData; END IF;
      vbToolsId := (SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View
                    WHERE Object_ToolsWeighing_View.Name = inLevel3
                      AND Object_ToolsWeighing_View.isLeaf = FALSE
                      AND Object_ToolsWeighing_View.ParentID = vbParentId);

      IF COALESCE(vbToolsId, 0) = 0 THEN
        vbToolsId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, vbValueData, inLevel3, inLevel1||' '||inLevel2||' '||inLevel3, '', vbParentId, inSession);
      END IF;
      vbParentId := vbToolsId;
    END IF;
    -- 3
    -- 4
    IF inLevel4 <> '' THEN
      vbToolsId := 0;
      vbValueData := inValueData;
      vbToolsId := (SELECT Object_ToolsWeighing_View.Id FROM Object_ToolsWeighing_View
                    WHERE Object_ToolsWeighing_View.Name = inLevel4
                      AND Object_ToolsWeighing_View.isLeaf = TRUE
                      AND Object_ToolsWeighing_View.ParentID = vbParentId);

      IF COALESCE(vbToolsId, 0) = 0 THEN
        vbToolsId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, vbValueData, inLevel4, vbNameFull, '', vbParentId, inSession);
      END IF;
      vbParentId := vbToolsId;
    END IF;
    -- 4

   END IF;

-- RETURN (vbValueData);
    RETURN QUERY
       SELECT vbValueData;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetToolsPropertyValue (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.03.14                                                         * change result to table
 13.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Movement', 'MovementDesc_1', '', '98751', '2');
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Movement', 'MovementDesc_1', 'DescId', '6',  '2');
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Movement', 'MovementDesc_1', 'FromId', '0', '2');
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Movement', 'MovementDesc_1', 'ToId', '0', '2');
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Movement', 'MovementDesc_1', 'PaidKindId', '0', '2');
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Service', 'ComPort', '', '1', 'Ком порт', '2');
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Service', 'isPreviewPrint', '', 'false', '2');
-- SELECT * FROM gpGetToolsPropertyValue ('Scale_1', 'Service', 'isActive', '', 'false', '2');