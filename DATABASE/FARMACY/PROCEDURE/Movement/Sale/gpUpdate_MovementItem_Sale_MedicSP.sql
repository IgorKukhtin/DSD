-- Function: gpUpdate_MovementItem_Sale_MedicSP()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_MedicSP(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_MedicSP(
    IN inMovementId     Integer   ,    -- ключ документа
    IN inMedicSPId      Integer   ,    -- 
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisSUN Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 11584730 ))
   THEN
     RAISE EXCEPTION 'Изменение ФИО врача вам запрещено, обратитесь к системному администратору'; 
   END IF;
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicSP(), inMovementId, inMedicSPId);
   

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.01.22                                                       *
*/

-- select * from gpUpdate_MovementItem_Sale_MedicSP(inMovementId := 26547205 , inMedicSPId := 4253851 ,  inSession := '3');