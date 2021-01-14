-- Function: gpUpdate_MovementGoodsBarCode_Checked(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementGoodsBarCode_Checked (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementGoodsBarCode_Checked(
    IN inBarCode             TVarChar  , -- штрихкод документа продажи 
    IN inSession             TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId Integer;
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- только в этом случае - ничего не делаем, т.к. из дельфи вызывается "лишний" раз
     IF COALESCE (TRIM (inBarCode), '') = ''
     THEN
         RETURN; -- !!!выход!!!
     END IF;

     -- Определяется <Физическое лицо> - кто сканировал документ
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- Проверка
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
          RAISE EXCEPTION 'Ошибка.У пользователя <%> не определно значение <Физ.лицо>.', lfGet_Object_ValueData (vbUserId);
     END IF;

     -- по штрих коду определяем документ  
     vbId:= (SELECT Movement.Id
             FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS Id) AS tmp
                 INNER JOIN Movement ON Movement.Id = tmp.Id
                                  AND Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Loss())
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
             );

     -- Проверка
     IF COALESCE (vbId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ с кодом <%> не найден.', inBarCode;
     END IF;

     -- сохранили свойство <проверен (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), vbId, True);
     -- сохранили свойство <Дата/время>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Checked(), vbId, CURRENT_TIMESTAMP);
     -- сохранили связь с <пользователь>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Checked(), vbId, vbMemberId_user);
   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.18         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_ReportCollation(inBarCode := '201000923136' ,  inSession := '5');
