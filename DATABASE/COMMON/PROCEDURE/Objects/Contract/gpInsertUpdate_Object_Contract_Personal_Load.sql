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
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

    -- Проверка
    IF COALESCE(inContractCode, 0) = 0
    THEN
        RETURN;
    END IF;

    --
    IF COALESCE (inContractCode, 0) <> 0
    THEN 
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
 
    --Ответственный (сотрудник)
    IF COALESCE (TRIM (inPersonalName), '') <> ''
    THEN 
         -- поиск
         vbPersonalId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalName));
         IF COALESCE (vbPersonalId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Ответственный (сотрудник)Ю <%> не найдено.', inPersonalName;
         END IF;
    END IF;

    --ТП (сотрудник)
    IF COALESCE (TRIM (inPersonalTradeName), '') <> ''
    THEN 
         -- поиск
         vbPersonalTradeId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalTradeName));
         IF COALESCE (vbPersonalTradeId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <ТП (сотрудник)> <%> не найдено.', inPersonalTradeName;
         END IF;
    END IF;
    
    --Бухг.сверка (сотрудник)
    IF COALESCE (TRIM (inPersonalCollationName), '') <> ''
    THEN 
         -- поиск
         vbPersonalCollationId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalCollationName));
         IF COALESCE (vbPersonalCollationId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Бухг.сверка (сотрудник)> <%> не найдено.', inPersonalCollationName;
         END IF;
    END IF;

    --Сотрудник (подписант)
    IF COALESCE (TRIM (inPersonalSigningName), '') <> ''
    THEN 
         -- поиск
         vbPersonalSigningId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalSigningName));
         IF COALESCE (vbPersonalSigningId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Сотрудник (подписант)> <%> не найдено.', inPersonalSigningName;
         END IF;
    END IF;


    -- сохранили связь с <Сотрудники (отвественное лицо)>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), vbContractId, vbPersonalId);
    -- сохранили связь с <Сотрудники (торговый)>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalTrade(), vbContractId, vbPersonalTradeId);
    -- сохранили связь с <Сотрудники (сверка)>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalCollation(), vbContractId, vbPersonalCollationId);
    -- сохранили связь с <Сотрудники (подписант)>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_PersonalSigning(), vbContractId, vbPersonalSigningId);
 
 
    -- сохранили протокол
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