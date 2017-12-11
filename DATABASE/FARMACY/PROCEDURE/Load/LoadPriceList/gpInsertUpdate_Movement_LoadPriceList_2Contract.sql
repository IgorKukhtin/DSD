-- Function: gpInsertUpdate_Movement_LoadPriceList_2Contract()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_2Contract (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_2Contract (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_2Contract (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList_2Contract(
    IN inJuridicalId         Integer   , -- Юридические лица
    IN inContractId1         Integer   , -- Договор
    IN inContractId2         Integer   , -- Договор
    IN inAreaId              Integer   , -- Регион
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice1              TFloat    ,  
    IN inPrice2              TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- Срок годности
    IN inPackCount           TVarChar  ,  
    IN inProducerName        TVarChar  , 
    IN inNDSinPrice          Boolean   ,
    IN inCodeUKTZED          TVarChar  ,
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

	
    -- такое не загружаем
    IF COALESCE (inPrice1, 0) = 0 AND COALESCE (inPrice2, 0) = 0 THEN 
        RETURN;
    END IF;
  
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
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
      );
     -- !!!Удаление!!! предыдущих данных - шапка
    DELETE FROM LoadPriceList WHERE Id IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
      );
  
    -- !!!Удаление-2!!! предыдущих данных - элементы
    DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = 0
                                      AND inAreaId > 0
      );
     -- !!!Удаление-2!!! предыдущих данных - шапка
    DELETE FROM LoadPriceList WHERE Id IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = 0
                                      AND inAreaId > 0
      );

    -- сохранили - inContractId1 and inPrice1
    PERFORM lpInsertUpdate_Movement_LoadPriceList_Contract (inJuridicalId   := inJuridicalId
                                                          , inContractId    := inContractId1
                                                          , inAreaId        := inAreaId
                                                          , inCommonCode    := inCommonCode
                                                          , inBarCode       := inBarCode
                                                          , inCodeUKTZED    := inCodeUKTZED
                                                          , inGoodsCode     := inGoodsCode
                                                          , inGoodsName     := inGoodsName
                                                          , inGoodsNDS      := inGoodsNDS
                                                          , inPrice         := inPrice1
                                                          , inRemains       := inRemains
                                                          , inExpirationDate:= inExpirationDate
                                                          , inPackCount     := inPackCount
                                                          , inProducerName  := inProducerName
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inUserId        := vbUserId
                                                           );
  

    -- сохранили - inContractId2 and inPrice2
    PERFORM lpInsertUpdate_Movement_LoadPriceList_Contract (inJuridicalId   := inJuridicalId
                                                          , inContractId    := inContractId2
                                                          , inAreaId        := inAreaId
                                                          , inCommonCode    := inCommonCode
                                                          , inBarCode       := inBarCode
                                                          , inCodeUKTZED    := inCodeUKTZED
                                                          , inGoodsCode     := inGoodsCode
                                                          , inGoodsName     := inGoodsName
                                                          , inGoodsNDS      := inGoodsNDS
                                                          , inPrice         := inPrice2
                                                          , inRemains       := inRemains
                                                          , inExpirationDate:= inExpirationDate
                                                          , inPackCount     := inPackCount
                                                          , inProducerName  := inProducerName
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inUserId        := vbUserId
                                                           );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 11.12.17         * inCodeUKTZED
 10.12.2016                                      *
 14.03.2016                                      * all
 07.10.2015                                                                    *загрузка сразу в 2 прайса
 17.02.15                        *   убрал вьюхи из поиска. 
 11.11.14                        *   
 28.10.14                        *   
 22.10.14                        *   Поменял очередность поиска
 18.09.14                        *  
*/
