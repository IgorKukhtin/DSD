-- DROP FUNCTION lpInsert_LoginProtocol;

DROP FUNCTION IF EXISTS lpInsert_LoginProtocol (TVarChar, TVarChar, Integer, Boolean, Boolean, Boolean);

CREATE OR REPLACE FUNCTION lpInsert_LoginProtocol(
    IN inUserLogin    TVarChar,
    IN inIP           TVarChar,
    IN inUserId       Integer,
    IN inIsConnect    Boolean,
    IN inIsProcess    Boolean,
    IN inIsExit       Boolean
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId_connect  Integer;
   DECLARE vbId_process  Integer;
BEGIN
 
     -- Если подключился - почти ничего не делаем
     IF inIsConnect = TRUE
     THEN
         -- Сохранили
         INSERT INTO LoginProtocol (UserId, OperDate, ProtocolData)
            SELECT inUserId, CURRENT_TIMESTAMP
                , '<XML>'
               || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
               || '<Field FieldName = "Логин" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
               || '<Field FieldName = "Действие" FieldValue = "Подключение"/>'
               || '</XML>'
                ;
     ELSE
         -- Найдем что есть в протоколе подключения
         SELECT MAX (CASE WHEN POSITION (LOWER ('Подключение') IN LOWER (ProtocolData)) > 0 THEN Id ELSE 0 END) AS Id_connect
              , MAX (CASE WHEN POSITION (LOWER ('Работает')    IN LOWER (ProtocolData)) > 0 THEN Id ELSE 0 END) AS Id_process
                INTO vbId_connect, vbId_process
         FROM LoginProtocol
         WHERE OperDate >= CURRENT_DATE AND OperDate < CURRENT_DATE + INTERVAL '1 DAY'
           AND UserId = inUserId;

         -- Если пользователь не выходил, но изменлась дата - делаем ему "виртуальный" вход
         IF COALESCE (vbId_connect, 0) = 0
         THEN
             -- Сохранили
             INSERT INTO LoginProtocol (UserId, OperDate, ProtocolData)
                SELECT inUserId, CURRENT_TIMESTAMP
                     , '<XML>'
                    || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
                    || '<Field FieldName = "Логин" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
                    || '<Field FieldName = "Действие" FieldValue = "Подключение (виртуальное)"/>'
                    || '</XML>'
                   ;

         END IF;


         -- если не было режима "Работает"
         IF COALESCE (vbId_process, 0) = 0
         THEN
             -- создали в протоколе что Пользователь - "Работает" или "Выход"
             INSERT INTO LoginProtocol (UserId, OperDate, ProtocolData)
                SELECT inUserId, CURRENT_TIMESTAMP
                     , '<XML>'
                    || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
                    || '<Field FieldName = "Логин" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
                    || '<Field FieldName = "Действие" FieldValue = "' || CASE WHEN inIsProcess = TRUE THEN 'Работает' ELSE 'Выход' END || '"/>'
                    || '</XML>'
                   ;
         ELSE
             -- изменили в протоколе что Пользователь - "Работает" или "Выход"
             UPDATE LoginProtocol
                    SET OperDate     = CURRENT_TIMESTAMP
                      , ProtocolData = 
                           '<XML>'
                        || '<Field FieldName = "IP" FieldValue = "' || zfStrToXmlStr (inIP) || '"/>'
                        || '<Field FieldName = "Логин" FieldValue = "' || zfStrToXmlStr (inUserLogin) || '"/>'
                        || '<Field FieldName = "Действие" FieldValue = "' || CASE WHEN inIsProcess = TRUE THEN 'Работает' ELSE 'Выход' END || '"/>'
                        || '</XML>'
             WHERE Id = vbId_process;

         END IF;

         
         -- Проверка
         IF COALESCE (inIsProcess, FALSE) <> TRUE AND COALESCE (inIsExit, FALSE) <> TRUE
         THEN
             --RAISE EXCEPTION 'Ошибка.inIsConnect - <%> + inIsProcess - <%> + inIsExit - <%>', inIsConnect, inIsProcess, inIsExit;
             RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.inIsConnect - <%> + inIsProcess - <%> + inIsExit - <%>' :: TVarChar
                                                   , inProcedureName := 'lpInsert_LoginProtocol' :: TVarChar
                                                   , inUserId        := inUserId
                                                   , inParam1        := inIsConnect :: TVarChar
                                                   , inParam2        := inIsProcess :: TVarChar
                                                   , inParam3        := inIsExit    :: TVarChar
                                                   );
         END IF;

    END IF;
   
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsert_LoginProtocol (TVarChar, TVarChar, Integer, Boolean, Boolean, Boolean) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.11.16                                        *
*/
