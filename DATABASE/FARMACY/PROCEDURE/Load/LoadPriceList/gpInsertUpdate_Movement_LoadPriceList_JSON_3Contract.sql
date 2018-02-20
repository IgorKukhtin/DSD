-- Function: gpInsertUpdate_Movement_LoadPriceList_JSON_3Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_JSON_3Contract (Integer, Integer, Integer, Integer, Integer, Boolean, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList_JSON_3Contract(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inContractId1         Integer   , -- Договор
    IN inContractId2         Integer   , -- Договор
    IN inContractId3         Integer   , -- Договор
    IN inAreaId              Integer   , -- Регион
    IN inNDSinPrice          Boolean   , -- цена с ндс
    IN inJSON                Text      , -- json 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);
  
    -- Проверка 
    IF COALESCE (inJuridicalId, 0) = 0 THEN 
        RAISE EXCEPTION 'Не установлено значение параметра Юридическое лицо (JuridicalId)';
    END IF;
    -- Проверка что передано таки Юр лицо а не Договор
    IF (SELECT DescId FROM Object WHERE Id = inJuridicalId) <> zc_Object_Juridical() THEN
        RAISE EXCEPTION 'Не правильно передается значение параметра Юридическое лицо (JuridicalId)';
    END IF;
    -- Проверка что передано таки Договор а не Юр лицо - будет в lp
  

    -- !!!Удаление!!! предыдущих данных - элементы
    DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2, inContractId3)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
      );
    -- !!!Удаление!!! предыдущих данных - шапка
    DELETE FROM LoadPriceList WHERE Id IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2, inContractId3)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
      );
  
    -- !!!Удаление-2!!! предыдущих данных - элементы
    DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2, inContractId3)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = 0
                                      AND inAreaId > 0
      );
    -- !!!Удаление-2!!! предыдущих данных - шапка
    DELETE FROM LoadPriceList WHERE Id IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2, inContractId3)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = 0
                                      AND inAreaId > 0
      );

    -- сохраняем 1 контракт
    PERFORM lpInsertUpdate_Movement_LoadPriceList_JSON (inJuridicalId       := inJuridicalId
                                                          , inContractId    := inContractId1
                                                          , inAreaId        := inAreaId
                                                          , inPriceNum      := 1
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inJSON          := inJSON
                                                          , inUserId        := vbUserId
                                                           );
                                                           
    -- сохраняем 2 контракт
    PERFORM lpInsertUpdate_Movement_LoadPriceList_JSON (inJuridicalId       := inJuridicalId
                                                          , inContractId    := inContractId2
                                                          , inAreaId        := inAreaId
                                                          , inPriceNum      := 2
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inJSON          := inJSON
                                                          , inUserId        := vbUserId
                                                           );
                                                           
    -- сохраняем 3 контракт
    PERFORM lpInsertUpdate_Movement_LoadPriceList_JSON (inJuridicalId       := inJuridicalId
                                                          , inContractId    := inContractId3
                                                          , inAreaId        := inAreaId
                                                          , inPriceNum      := 3
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inJSON          := inJSON
                                                          , inUserId        := vbUserId
                                                           );                                                       

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Подмогильный В.В.
 19.02.18                                                                                     * загрузка из json
 11.12.17         * inCodeUKTZED
 10.12.2016                                      *
*/
