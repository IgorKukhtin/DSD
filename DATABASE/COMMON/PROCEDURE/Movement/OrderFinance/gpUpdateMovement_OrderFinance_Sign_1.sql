-- Function: gpUpdateMovement_OrderFinance_Sign_1()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Sign_1 (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Sign_1 (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_Sign_1(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inisSign_1            Boolean   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId     Integer;
            vbMemberId   Integer;
            vbMemberId_1 Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
                   FROm ObjectLink AS ObjectLink_User_Member
                   WHERE ObjectLink_User_Member.ObjectId = vbUserId
                     AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  );

     vbMemberId_1 := (SELECT MovementLinkObject_Member_1.ObjectId
                      FROM MovementLinkObject AS MovementLinkObject_Member_1
                      WHERE MovementLinkObject_Member_1.MovementId = inMovementId
                        AND MovementLinkObject_Member_1.DescId = zc_MovementLinkObject_Member_1()
                     );

   /*  IF COALESCE (vbMemberId,0) <> COALESCE (vbMemberId_1,0)
     THEN
         RAISE EXCEPTION 'Ошибка.У пользователя нет доступа изменять значения <Согласован-1>.';
     END IF;
     */

     -- сохранили свойство  <Согласован-1>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Sign_1(), inMovementId, inisSign_1);

     IF COALESCE (inisSign_1, FALSE) = TRUE
     THEN
         -- сохранили свойство <Дата/время Согласован-1>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sign_1(), inMovementId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили свойство <Дата/время Согласован-1>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sign_1(), inMovementId, NULL ::TDateTime);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.25         *
*/


-- тест
--