-- Function: gpInsertUpdate_Object_Contract_Personal_Load (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract_Personal_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract_Personal_Load(
    IN inContractCode               Integer   , -- 
    IN inContractName               TVarChar   , -- 
    IN inPersonalName               TVarChar   , -- Ответственный (сотрудник)
    IN inPersonalTradeName          TVarChar   , -- ТП (сотрудник)
    IN inPersonalCollationName      TVarChar   , -- Бухг.сверка (сотрудник)
    IN inPersonalSigningName        TVarChar   , -- Сотрудник (подписант) 
    IN inSession                    TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbPersonalId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbPersonalTradeId Integer;
    DECLARE vbPersonalCollationId Integer;
    DECLARE vbPersonalSigningId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
    -- vbUserId:= lpGetUserBySession (inSession);

    -- Проверка
    IF COALESCE(inContractCode, 0) = 0
    THEN
        RETURN;
    END IF;

    --
    IF COALESCE (inContractCode, 0) <> 0
    THEN 
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM Object_Contract_View AS tmp_View WHERE tmp_View.ContractCode = inContractCode)
         THEN
             RAISE EXCEPTION 'Ошибка.Договор <%> с таки кодом = <%> не один.', inContractName, inContractCode;
         END IF;

         -- поиск договор
         vbContractId:= (SELECT tmp_View.ContractId
                         FROM Object_Contract_View AS tmp_View
                         WHERE tmp_View.ContractCode = inContractCode
                         );

         -- Проверка
         IF COALESCE (vbContractId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Договор <(%) %> не найден.', inContractCode, inContractName;
         END IF;
    END IF;
 
    -- 1.1. Ответственный (сотрудник)
    IF COALESCE (TRIM (inPersonalName), '') <> ''
    THEN 
         -- Проверка
         IF 1 < (SELECT COUNT(*)
                 FROM Object
                      JOIN ObjectBoolean ON ObjectBoolean.ObjectId = Object.Id AND ObjectBoolean.DescId = zc_ObjectBoolean_Personal_Main() AND ObjectBoolean.ValueData = TRUE
                      JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_Personal_Unit()
                      JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink.ChildObjectId
                                                AND Object_Unit.ValueData NOT ILIKE 'ЗСУ'
                 WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalName) AND Object.isErased = FALSE
                )
         THEN
             RAISE EXCEPTION 'Ошибка.Ответственный (сотрудник) с таким ФИО = <%> не один.', inPersonalName;
         END IF;

         -- поиск
         vbPersonalId := (SELECT Object.Id
                          FROM Object
                               JOIN ObjectBoolean ON ObjectBoolean.ObjectId = Object.Id AND ObjectBoolean.DescId = zc_ObjectBoolean_Personal_Main() AND ObjectBoolean.ValueData = TRUE
                               JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id AND ObjectLink.DescId = zc_ObjectLink_Personal_Unit()
                               JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink.ChildObjectId
                                                         AND Object_Unit.ValueData NOT ILIKE 'ЗСУ'
                          WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalName) AND Object.isErased = FALSE
                         );
         IF COALESCE (vbPersonalId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Ответственный (сотрудник) = <%> не найдено.', inPersonalName;
         END IF;

         -- сохранили связь с <Сотрудники (отвественное лицо)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), vbContractId, vbPersonalId);

    END IF;

    -- 2.1. ТП (сотрудник)
    IF COALESCE (TRIM (inPersonalTradeName), '') <> ''
    THEN 
         -- поиск
         vbPersonalTradeId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalTradeName) AND Object.isErased = FALSE);
         IF COALESCE (vbPersonalTradeId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <ТП (сотрудник)> <%> не найдено.', inPersonalTradeName;
         END IF;

         -- сохранили связь с <Сотрудники (торговый)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalTrade(), vbContractId, vbPersonalTradeId);

    END IF;
    
    -- 3.1. Бухг.сверка (сотрудник)
    IF COALESCE (TRIM (inPersonalCollationName), '') <> ''
    THEN 
         -- поиск
         vbPersonalCollationId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalCollationName) AND Object.isErased = FALSE);
         IF COALESCE (vbPersonalCollationId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Бухг.сверка (сотрудник)> <%> не найдено.', inPersonalCollationName;
         END IF;

         -- сохранили связь с <Сотрудники (сверка)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalCollation(), vbContractId, vbPersonalCollationId);

    END IF;

    -- 4.1. Сотрудник (подписант)
    IF COALESCE (TRIM (inPersonalSigningName), '') <> ''
    THEN 
         -- поиск
         vbPersonalSigningId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalSigningName) AND Object.isErased = FALSE);
         IF COALESCE (vbPersonalSigningId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Сотрудник (подписант)> <%> не найдено.', inPersonalSigningName;
         END IF;

         -- сохранили связь с <Сотрудники (подписант)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalSigning(), vbContractId, vbPersonalSigningId);

    END IF;
 
 
    -- 5. сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inObjectId:= vbContractId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);
 

    -- проверка - что б Админ ничего не ломал
    IF vbUserId = 5 OR vbUserId = 9457
    THEN
        RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.26         *
*/

-- тест