DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_ExpirationDate(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_ExpirationDate(
    IN inMovementItemId      Integer   , -- строка документа
    IN inMovementId          Integer   , -- документ
    IN inJuridicalId         Integer   , -- Поставщик
    IN inExpirationDate      TDateTime , -- Срок годности
   OUT outExpirationDate     TDateTime , -- Срок годности
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

--    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
--              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
--    THEN
--      RAISE EXCEPTION 'Ошибка. У вас нет прав выполнять эту операцию.';     
--    END IF;     

    -- определяется
    SELECT 
        StatusId
      , InvNumber 
    INTO 
        vbStatusId
      , vbInvNumber   
    FROM 
        Movement 
    WHERE
        Id = inMovementId;
     
    --
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF NOT EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_ChangeExpirationDate
                  WHERE ObjectBoolean_ChangeExpirationDate.ObjectId = inJuridicalId
                    AND ObjectBoolean_ChangeExpirationDate.DescId = zc_ObjectBoolean_Juridical_ChangeExpirationDate()
                    AND ObjectBoolean_ChangeExpirationDate.ValueData = TRUE)
    THEN
        RAISE EXCEPTION 'Ошибка. По поставщику запрещено изменять срок годности.';
    END IF;

    -- Сохранили <Срок годности>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inMovementItemId, inExpirationDate);
    
    outExpirationDate := inExpirationDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.07.21                                                       *
*/

-- select * from gpUpdate_MovementItem_Income_ExpirationDate(inMovementItemId := 427266561 , inMovementId := 23186807 , inJuridicalId := 1311462 , inExpirationDate := ('07.07.2021')::TDateTime ,  inSession := '3');