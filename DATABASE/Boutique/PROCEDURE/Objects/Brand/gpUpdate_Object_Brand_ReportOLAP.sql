-- Торговая марка

DROP FUNCTION IF EXISTS gpUpdate_Object_Brand_ReportOLAP (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Brand_ReportOLAP(
    IN inId           Integer,
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


   -- Находим по св-вам
   vbReportOLAPId := lpInsertFind_Object_ReportOLAP (inCode     := 1
                                                   , inObjectId := inId
                                                   , inUserId   := vbUserId
                                                    );
   -- изменили для vbReportOLAPId
   PERFORM lpUpdate_Object_isErased (inObjectId:= vbReportOLAPId, inIsErased:= NOT inIsReportOLAP, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
30.04.18                                         *
*/
