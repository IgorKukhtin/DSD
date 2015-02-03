 DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ToolsWeighing_Branch (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ToolsWeighing_Branch(
    IN inScaleName               TVarChar  ,
    IN inScaleNameUser           TVarChar  ,
    IN inMovementDescCount       TVarChar  ,
    IN inServiceComPort          TVarChar  ,
    IN inServiceisPreviewPrint   TVarChar  ,
    IN inSession                 TVarChar
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId Integer;
   DECLARE vbScaleId Integer;
   DECLARE vbServiceId Integer;
   DECLARE vbMovementId Integer;

   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());
   vbId := 0; vbScaleId:= 0; vbServiceId := 0; vbMovementId:= 0;
   -- Создали Scale_X
   vbScaleId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, '', inScaleName, '', inScaleNameUser, 0, inSession);

   -- Создали Service
   vbServiceId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, '', 'Service', '', 'Служебные', vbScaleId, inSession);
   -- Создали Service -> ComPort
   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inServiceComPort, 'ComPort', '', 'Ком порт', vbServiceId, inSession);
   -- Создали Service -> isPreviewPrint
   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inServiceisPreviewPrint, 'isPreviewPrint', '', 'Просмотр перед печатью', vbServiceId, inSession);

   -- Создали Movement
   vbMovementId:= gpInsertUpdate_Object_ToolsWeighing (0, 0, '', 'Movement', '', 'Документы', vbScaleId, inSession);
   -- Создали Movement -> DescCount
   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inMovementDescCount, 'DescCount', '', 'Количество операций', vbServiceId, inSession);


   -- Создали Movement -> MovementDesc_X
--   PERFORM gpInsertUpdate_Object_ToolsWeighing (0, 0, inMovementDescCount, 'MovementDesc_1', '', 'Количество операций', vbServiceId, inSession);

  RETURN vbScaleId;




/*
   -- Если добавляли
   IF vbOldId <> ioId THEN
      -- Установить свойство лист\папка у себя
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ToolsWeighing_Branch (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.03.14                                                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ToolsWeighing_Branch ('Scale_3', 'Рабочая группа - Экспедиция ГП3', '10', '1', 'false', '2');
