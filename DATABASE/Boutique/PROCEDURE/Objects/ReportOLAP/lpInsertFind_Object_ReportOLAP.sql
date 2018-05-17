-- Function: lpInsertFind_Object_ReportOLAP (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_ReportOLAP (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ReportOLAP(
    IN inCode         Integer,       -- 
    IN inObjectId     Integer,       -- 
    IN inUserId       Integer        --
)
RETURNS Integer
AS
$BODY$
   DECLARE vbId Integer;
BEGIN
     -- проверка - свойство должно быть установлено
     IF COALESCE (inCode, 0) <= 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <inCode>.';
     END IF;
     IF COALESCE (inCode, 0) NOT IN (zc_ReportOLAP_Brand(), zc_ReportOLAP_Goods(), zc_ReportOLAP_Partion()) THEN
        RAISE EXCEPTION 'Ошибка.Нельзя такое значение <inCode> = <%>.', inCode;
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inObjectId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <inObjectId>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inUserId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <inUserId>.';
     END IF;


     -- Находим по св-вам
     vbId:= (SELECT Object.Id
             FROM Object
                  INNER JOIN ObjectLink AS ObjectLink_Object
                                        ON ObjectLink_Object.ObjectId      = Object.Id
                                       AND ObjectLink_Object.DescId        = zc_ObjectLink_ReportOLAP_Object()
                                       AND ObjectLink_Object.ChildObjectId = inObjectId
                  INNER JOIN ObjectLink AS ObjectLink_User
                                        ON ObjectLink_User.ObjectId      = Object.Id
                                       AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                       AND ObjectLink_User.ChildObjectId = inUserId
             WHERE Object.DescId     = zc_Object_ReportOLAP()
               AND Object.ObjectCode = inCode
            );


     -- Если не нашли
     IF COALESCE (vbId, 0) = 0
     THEN
         -- сохранили <Объект>
         vbId := lpInsertUpdate_Object (vbId, zc_Object_ReportOLAP(), inCode, '');

         -- сохранили связь с <Object>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportOLAP_Object(), vbId, inObjectId);

         -- сохранили связь с <User>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportOLAP_User(), vbId, inUserId);

     END IF; -- if COALESCE (vbId, 0) = 0


     -- Возвращаем значение
     RETURN (vbId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.04.17                                         *
*/

-- тест
--