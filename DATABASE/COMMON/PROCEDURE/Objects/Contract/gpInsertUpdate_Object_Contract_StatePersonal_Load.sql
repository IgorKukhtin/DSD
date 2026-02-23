-- Function: gpInsertUpdate_Object_Contract_StatePersonal_Load (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract_StatePersonal_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract_StatePersonal_Load(
    IN inContractCode               Integer   , -- 
    IN inPersonalName               TVarChar   , -- Ответственный (сотрудник)
    IN inPersonalName_new           TVarChar   , -- Ответственный (сотрудник) новый
    IN inContractStateKindName_new  TVarChar   , -- Состояник договора - "закрити"
    IN inSession                    TVarChar     -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbContractId Integer;
    DECLARE vbPersonalId_new Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

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
             RAISE EXCEPTION 'Ошибка.Договор с кодом <(%) %> не найден.', inContractCode;
         END IF;
    END IF;

    --Ответственный (сотрудник)
    IF COALESCE (TRIM (inPersonalName), '') <> COALESCE (TRIM (inPersonalName_new), '')
    THEN 
         -- поиск
         vbPersonalId_new := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Personal() AND TRIM (Object.ValueData) ILIKE TRIM (inPersonalName_new));
         IF COALESCE (vbPersonalId_new, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Значение <Ответственный (сотрудник) новый <%> не найдено.', inPersonalName_new;
         END IF;
         
         -- сохранили связь с <Сотрудники (отвественное лицо)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_Personal(), vbContractId, vbPersonalId_new);

    END IF;

    --Состояние договора
    IF COALESCE (TRIM (inContractStateKindName_new), '') = 'закрити'
    THEN 
         -- сохранили связь с <Состояние договора>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractStateKind(), vbContractId, zc_Enum_ContractStateKind_Close());
    END IF;


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
 19.02.26         *
*/

-- тест