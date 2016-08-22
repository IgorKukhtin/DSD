-- Function: gpUpdate_Movement_Check_ConfirmedKind()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ConfirmedKind (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ConfirmedKind(
    IN inMovementId        Integer  , -- 
 INOUT ioConfirmedKindName TVarChar ,  -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbConfirmedKindId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);


    -- поиск
    vbConfirmedKindId:= (SELECT Object.Id FROM ObjectString JOIN Object ON Object.Id = ObjectString.ObjectId AND Object.DescId = zc_Object_ConfirmedKind() WHERE LOWER (ObjectString.ValueData) = LOWER (ioConfirmedKindName) AND ObjectString.DescId = zc_ObjectString_Enum());
    ioConfirmedKindName:= COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = vbConfirmedKindId), '');

    -- Проверка
    IF NOT EXISTS (SELECT 1
                   FROM Movement
                        INNER JOIN MovementLinkObject AS MLO ON MLO.MovementId = Movement.Id
                                                            AND MLO.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                            AND MLO.ObjectId = CASE WHEN vbConfirmedKindId = zc_Enum_ConfirmedKind_Complete()
                                                                                         THEN zc_Enum_ConfirmedKind_UnComplete()
                                                                                    WHEN vbConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete()
                                                                                         THEN zc_Enum_ConfirmedKind_Complete()
                                                                               END
                        /*INNER JOIN MovementString AS MS ON MS.MovementId = Movement.Id
                                                       AND MS.DescId = zc_MovementString_InvNumberOrder()
                                                       AND MS.ValueData <> ''*/
                   WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Check() AND Movement.OperDate >= CURRENT_DATE - INTERVAL '7 DAY'
                  )
    THEN
        ioConfirmedKindName:= '';
        vbConfirmedKindId:= 0;
    END IF;

    IF vbConfirmedKindId > 0
    THEN 
        -- сохранили связь
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), inMovementId, vbConfirmedKindId);
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.08.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Check_ConfirmedKind (inSession:= zfCalc_UserAdmin())
