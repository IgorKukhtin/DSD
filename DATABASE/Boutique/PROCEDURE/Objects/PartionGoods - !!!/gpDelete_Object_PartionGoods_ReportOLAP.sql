-- 
DROP FUNCTION IF EXISTS gpDelete_Object_PartionGoods_ReportOLAP (TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_PartionGoods_ReportOLAP(
    IN inSession      TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbReportOLAPId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Delete_Object_Brand());
     vbUserId:= lpGetUserBySession (inSession);


     -- удаляем все по пользователю
     PERFORM lpUpdate_Object_isErased (inObjectId:= Object.Id, inIsErased:= TRUE, inUserId:= vbUserId)
     FROM Object
         INNER JOIN ObjectLink AS ObjectLink_User
                               ON ObjectLink_User.ObjectId      = Object.Id
                              AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                              AND ObjectLink_User.ChildObjectId = vbUserId
     WHERE Object.DescId     = zc_Object_ReportOLAP()
       AND Object.ObjectCode IN (zc_ReportOLAP_Goods(), zc_ReportOLAP_Partion())
       AND Object.isErased   = FALSE
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
15.05.18          *
*/
