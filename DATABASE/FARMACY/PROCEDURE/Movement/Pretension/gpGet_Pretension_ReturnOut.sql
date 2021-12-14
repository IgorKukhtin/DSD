-- Function: gpGet_Pretension_ReturnOut()

DROP FUNCTION IF EXISTS gpGet_Pretension_ReturnOut(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Pretension_ReturnOut(
    IN inMovementId          Integer   ,    -- Ключ документа
   OUT outReturnOutId        TVarChar  ,    -- Возврат поставщику
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());

   
   IF EXISTS(SELECT 1
             FROM MovementLinkMovement 
             WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
               AND MovementLinkMovement.MovementChildId = inMovementId)
   THEN
     SELECT MovementLinkMovement.MovementId
     INTO outReturnOutId
     FROM MovementLinkMovement 
     WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
       AND MovementLinkMovement.MovementChildId = inMovementId;
   ELSE
     RAISE EXCEPTION 'Возврат поставщику по претензии не найден.';
   END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.12.21                                                       *
*/

select * from gpGet_Pretension_ReturnOut(inMovementId := 26087688 ,  inSession := '3');