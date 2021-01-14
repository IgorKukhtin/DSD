-- Function: gpUpdate_MovementGoodsBarCode_Checked()

DROP FUNCTION IF EXISTS gpUpdate_MovementGoodsBarCode_UnChecked (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementGoodsBarCode_UnChecked(
    IN inId                  Integer  , -- штрихкод документа продажи 
    IN inSession             TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());
     vbUserId:= lpGetUserBySession (inSession);

     -- только в этом случае - ничего не делаем, 
     IF COALESCE (inId, 0) = 0
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


     -- сохранили свойство <проверен (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inId, FALSE);
     -- сохранили свойство <Дата/время>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Checked(), inId, CURRENT_TIMESTAMP);
     -- сохранили связь с <пользователь>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Checked(), inId, vbMemberId_user);
   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.18         *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementGoodsBarCode_UnChecked(inBarCode := '201000923136' ,  inSession := '5');
