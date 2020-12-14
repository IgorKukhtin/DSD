 -- Function: lfGet_User_MobileCheck (Integer, Integer)

DROP FUNCTION IF EXISTS lfGet_User_MobileCheck (Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_User_MobileCheck(
    IN inMemberId         Integer   , -- торговый агент
    IN inUserId           Integer     -- пользователь
)

-- возвращается - с какими параметрами пользователь может просматривать данные с мобильного устройства
RETURNS TABLE (MemberId Integer, UserId Integer)
AS
$BODY$
   DECLARE vbIsProjectMobile Boolean;
   DECLARE vbUserId_Member   Integer;
BEGIN
     -- Только так определяется что пользователь inUserId - Торговый агент - т.е. у него есть моб телефон, альтернатива - потом заведем спец роль и захардкодим её
     vbIsProjectMobile:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inUserId AND ObjectBoolean.DescId = zc_ObjectBoolean_User_ProjectMobile());


     IF inMemberId > 0
     THEN
         -- Определяется для <Физическое лицо> - его UserId
         vbUserId_Member:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ChildObjectId = inMemberId);
         -- Проверка
         IF COALESCE (vbUserId_Member, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для ФИО <%> не определено значение <Пользователь>.', lfGet_Object_ValueData (inMemberId);
         END IF;

     ELSEIF vbIsProjectMobile = TRUE
     THEN
         -- в этом случае - видит только себя
         vbUserId_Member:= inUserId;
         -- !!!меняем значение!!! - Определяется для UserId - его <Физическое лицо>
         inMemberId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Member() AND OL.ObjectId = inUserId);
     ELSE
         -- в этом случае - видит ВСЕ
         vbUserId_Member:= 0;
         -- !!!меняем значение!!!
         inMemberId:= 0;
     END IF;


     -- Проверка - Торговый агент видит только себя
     IF vbIsProjectMobile = TRUE AND vbUserId_Member <> inUserId
     THEN
         RAISE EXCEPTION 'Ошибка.Недостаточно прав доступа.';
     END IF;



   -- Результат
   RETURN QUERY 
     SELECT inMemberId      AS MemberId
          , vbUserId_Member AS UserId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.17                                        *
*/

-- тест
-- SELECT * FROM lfGet_User_MobileCheck (974195, zfCalc_UserAdmin() :: Integer)
