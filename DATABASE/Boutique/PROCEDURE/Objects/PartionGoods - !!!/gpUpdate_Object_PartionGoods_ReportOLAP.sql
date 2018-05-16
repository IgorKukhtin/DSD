-- 
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionGoods_ReportOLAP (Integer, Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionGoods_ReportOLAP(
    IN inCode               Integer,
    IN inObjectId           Integer,
    IN inIsReportOLAP Boolean, 
    IN inSession      TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbReportOLAPId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Brand());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inObjectId, 0) = 0 
   THEN
        RAISE EXCEPTION 'Ошибка.Элемент товара или партии не определен.'; 
   END IF;

   -- Находим по св-вам
   vbReportOLAPId := lpInsertFind_Object_ReportOLAP (inCode     := inCode
                                                   , inObjectId := inObjectId
                                                   , inUserId   := vbUserId
                                                    );
   -- изменили для vbReportOLAPId
   PERFORM lpUpdate_Object_isErased (inObjectId:= vbReportOLAPId, inIsErased:= NOT inIsReportOLAP, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
15.05.18          *
*/
