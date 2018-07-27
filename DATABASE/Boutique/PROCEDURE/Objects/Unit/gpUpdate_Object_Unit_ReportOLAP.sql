-- Подразделение

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_ReportOLAP (Integer, Boolean,  TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_ReportOLAP(
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
   vbUserId:= lpGetUserBySession (inSession);


   -- Находим по св-вам
   vbReportOLAPId := lpInsertFind_Object_ReportOLAP (inCode     := zc_ReportOLAP_Unit()
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
27.07.18          *
*/
