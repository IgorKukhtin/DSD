-- Function: lpInsertUpdate_Object_Goods_Flat()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Flat(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_Flat(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть
    IN inUserId              Integer   ,    --
    IN inMakerId             Integer   ,    -- Производитель
    IN inMakerName           TVarChar  ,    -- Производитель
    IN inCheckName           Boolean  DEFAULT true ,
    IN inAreaId              Integer  DEFAULT 0,      --
    IN inNameUkr             TVarChar DEFAULT '',     -- Название украинское
    IN inCodeUKTZED          TVarChar DEFAULT '',    -- Код УКТЗЭД
    IN inExchangeId          Integer  DEFAULT 0       -- Од:
)
RETURNS Integer
AS
$BODY$
  DECLARE vbCode Integer;
  DECLARE vbGoodsMainID Integer;
BEGIN

   -- попытка преобразовать код
   BEGIN
        vbCode:= inCode :: Integer;
   EXCEPTION
        WHEN data_exception
        THEN vbCode := 0;
   END;

      -- ********** Если это главный товар
   IF COALESCE (inObjectId, 0) = 0
   THEN

     -- !!!проверка уникальности <Наименование> для "любого" inObjectId
     IF inCheckName = TRUE
     THEN
        IF EXISTS (SELECT Name
                   FROM Object_Goods_Main
                   WHERE Name = inName AND Id <> COALESCE(ioId, 0)
                  )
        THEN
           -- RAISE EXCEPTION 'Значение <(%) %> не уникально для справочника <Товары - общие>.', inCode, inName;
           PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
             Format('Значение <(%s) %s> не уникально для справочника <Товары - общие>.', inCode, inName) , inUserId);
        END IF;
     END IF;

       -- Проверяем правельность кода товара
     IF COALESCE(vbCode, 0) = 0
     THEN
       -- RAISE EXCEPTION 'Значение кода товара <%> не допустимо для главного товара.', inCode;
       PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
         Format('Значение кода товара <%s> не допустимо для главного товара.', inCode) , inUserId);
     END IF;

       -- проверка уникальности <Код>
       -- !!!для "общего справочника" - ObjectCode
     IF EXISTS (SELECT 1 FROM Object_Goods_Main
                WHERE ObjectCode = vbCode AND Id <> COALESCE (ioId, 0)
               )
     THEN
        --RAISE EXCEPTION 'Код "%" не уникально для справочника "Товары - общие"', inCode;
        PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
          Format('Код "%s" не уникально для справочника "Товары - общие"', inCode) , inUserId);
     END IF;

       -- Если новый или нет то создаем
     IF COALESCE (ioId, 0) = 0
     THEN
       INSERT INTO Object_Goods_Main (ObjectCode, Name, isErased, isClose)
       VALUES (vbCode, inName, False, False)
       RETURNING Id INTO ioId;
     ELSEIF NOT EXISTS (SELECT 1 FROM Object_Goods_Main WHERE Object_Goods_Main.ID = ioId)
     THEN
       INSERT INTO Object_Goods_Main (ID, ObjectCode, Name, isErased, isClose)
       VALUES (ioId, vbCode, inName, False, False);
     END IF;

       -- Изменяем поля
     UPDATE Object_Goods_Main SET ObjectCode   = vbCode
                                , Name         = inName
                                , GoodsGroupID = inGoodsGroupId
                                , MeasureID    = inMeasureId
                                , NDSKindID    = inNDSKindId
                                , NameUkr      = inNameUkr
                                , CodeUKTZED   = inCodeUKTZED
                                , ExchangeId   = inExchangeId
     WHERE Object_Goods_Main.ID = ioId;

     -- ****** Если товар поставщика
   ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Juridical())
   THEN

     -- !!!проверка уникальности <Наименование> для "любого" inObjectId
     IF inCheckName = TRUE
     THEN
        IF EXISTS (SELECT Name
                   FROM Object_Goods_Juridical
                   WHERE Name = inName AND Id <> COALESCE(ioId, 0)
                     AND JuridicalID = inObjectId
                     AND (-- если Регион соответсвует
                          COALESCE (Object_Goods_Juridical.AreaId, 0) = inAreaId
                          -- или Это регион zc_Area_Basis - тогда ищем в регионе "пусто"
                       OR (inAreaId = zc_Area_Basis() AND Object_Goods_Juridical.AreaId IS NULL)
                          -- или Это регион "пусто" - тогда ищем в регионе zc_Area_Basis
                       OR (inAreaId = 0 AND Object_Goods_Juridical.AreaId = zc_Area_Basis())
                         )
                  )
        THEN
          --RAISE EXCEPTION 'Значение <(%)%>%не уникально для справочника <Товары поставщиков>.', inCode, inName
          --                , ' поставщик <' || COALESCE (lfGet_Object_ValueData (inObjectId), '') || '> ';
          PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
            Format('Значение <(%s)%s>%sне уникально для справочника <Товары поставщиков>.', inCode, inName,
                   ' поставщик <' || COALESCE (lfGet_Object_ValueData (inObjectId), '') || '> ') , inUserId);
        END IF;
     END IF;

       -- проверка уникальности <Код>
       -- !!!для inObjectId - Code (TVarChar)
     IF EXISTS (SELECT 1 FROM Object_Goods_Juridical
                WHERE Code = inCode AND Id <> COALESCE (ioId, 0)
                  AND JuridicalID = inObjectId
                  AND (-- если Регион соответсвует
                       COALESCE (Object_Goods_Juridical.AreaId, 0) = inAreaId
                       -- или Это регион zc_Area_Basis - тогда ищем в регионе "пусто"
                    OR (inAreaId = zc_Area_Basis() AND Object_Goods_Juridical.AreaId IS NULL)
                       -- или Это регион "пусто" - тогда ищем в регионе zc_Area_Basis
                    OR (inAreaId = 0 AND Object_Goods_Juridical.AreaId = zc_Area_Basis())
                      )
               )
     THEN
        -- RAISE EXCEPTION 'Код "%" не уникально для справочника "Товары поставщиков"', inCode;
        PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
            Format('Код "%s" не уникально для справочника "Товары поставщиков"', inCode) , inUserId);
     END IF;

       -- Если новый или нет то создаем
     IF COALESCE (ioId, 0) = 0
     THEN
       INSERT INTO Object_Goods_Juridical (ObjectCode, Name, isErased, JuridicalID)
       VALUES (vbCode, inName, False, inObjectId)
       RETURNING Id INTO ioId;
     ELSEIF NOT EXISTS (SELECT 1 FROM Object_Goods_Juridical WHERE Object_Goods_Juridical.ID = ioId)
     THEN
       INSERT INTO Object_Goods_Juridical (ID, ObjectCode, Name, isErased, JuridicalID)
       VALUES (ioId, vbCode, inName, False, inObjectId);
     END IF;

       -- Изменяем поля
     UPDATE Object_Goods_Juridical SET ObjectCode   = vbCode
                                     , Name         = inName
                                     , Code         = inCode
                                     , JuridicalID  = inObjectId
                                     , MakerName    = inMakerName
                                     , UserUpdateID = inUserId
                                     , DateUpdate   = CURRENT_TIMESTAMP
     WHERE Object_Goods_Juridical.ID = ioId;

     -- ************* Если товар сети
   ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Retail())
   THEN
       -- Проверяем правельность кода товара
     IF COALESCE(vbCode, 0) = 0
     THEN
       --RAISE EXCEPTION 'Значение кода товара <%> не допустимо для товара сети.', inCode;
       PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
            Format('Значение кода товара <%s> не допустимо для товара сети.', inCode) , inUserId);
     END IF;

       -- Находим главный товар
     IF EXISTS (SELECT * FROM Object_Goods_Main WHERE Object_Goods_Main.ObjectCode = vbCode)
     THEN
       SELECT Object_Goods_Main.ID
       INTO vbGoodsMainID
       FROM Object_Goods_Main
       WHERE Object_Goods_Main.ObjectCode = vbCode;
     ELSE
       -- RAISE EXCEPTION 'По коду товара <%> не не найден главный товар.', inCode;
       PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
            Format('По коду товара <%s> не не найден главный товар.', inCode) , inUserId);
     END IF;

     -- Проверяем название с главным товаром
     IF NOT EXISTS(SELECT Name
                   FROM Object_Goods_Main
                   WHERE Name = inName AND Id = vbGoodsMainID
                  )
     THEN
        -- RAISE EXCEPTION 'Название товара <(%) %> не совпадает с <Товары - общие>.', inCode, inName;
        PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
            Format('Название товара <(%s) %s> не совпадает с <Товары - общие>.', inCode, inName) , inUserId);
     END IF;

       -- Если новый или нет то создаем
     IF COALESCE (ioId, 0) = 0
     THEN
       INSERT INTO Object_Goods_Retail (GoodsMainID, RetailID, isErased, UserInsertID, DateInsert)
       VALUES ( vbGoodsMainID, inObjectId, False, inUserId, CURRENT_TIMESTAMP)
       RETURNING Id INTO ioId;
     ELSEIF NOT EXISTS (SELECT 1 FROM Object_Goods_Retail WHERE Object_Goods_Retail.ID = ioId)
     THEN
       INSERT INTO Object_Goods_Retail (ID, GoodsMainID, RetailID, isErased, UserInsertID, DateInsert)
       VALUES (ioId, vbGoodsMainID, inObjectId, False, inUserId, CURRENT_TIMESTAMP);
     ELSEIF EXISTS (SELECT 1 FROM Object_Goods_Retail
                    WHERE Object_Goods_Retail.ID = ioId
                      AND (Object_Goods_Retail.GoodsMainID <> vbGoodsMainID
                        OR Object_Goods_Retail.RetailID <> inObjectId))
     THEN

         -- Изменяем поля товара сети
       UPDATE Object_Goods_Retail SET GoodsMainID   = vbGoodsMainID
                                    , RetailID      = inObjectId
                                    , UserUpdateID = inUserId
                                    , DateUpdate   = CURRENT_TIMESTAMP
       WHERE Object_Goods_Retail.ID = ioId;
     END IF;

       -- Изменяем поля в главном товаре
     UPDATE Object_Goods_Main SET GoodsGroupID = inGoodsGroupId
                                , MeasureID    = inMeasureId
                                , NDSKindID    = inNDSKindId
                                , NameUkr      = inNameUkr
                                , CodeUKTZED   = inCodeUKTZED
                                , ExchangeId   = inExchangeId
     WHERE Object_Goods_Main.ID = vbGoodsMainID;
   ELSE
/*     RAISE EXCEPTION 'Значение <(%) %> не допустимо.', inObjectId,
       COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                 FROM Object AS Object_GoodsObject
                      LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                 WHERE Object_GoodsObject.Id = inObjectId), '');
*/
        PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat',
            Format('Значение <(%s) %s> не допустимо.', inObjectId,
                   COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                   FROM Object AS Object_GoodsObject
                      LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                   WHERE Object_GoodsObject.Id = inObjectId), '')) , inUserId);
  END IF;

   -- сохранили протокол - !!!только для "общего справочника"!!!
/*   IF COALESCE (inObjectId, 0) = 0
   THEN
       PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   END IF;
*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods_Flat(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.10.19                                                       *

*/

-- тест
--
/*
 SELECT * FROM lpInsertUpdate_Object_Goods_Flat (ioId             :=  1
                                               , inCode           :=  '34950'
                                               , inName           :=  'Лаферон фл 1млн ЕД N5 11112 '
                                               , inGoodsGroupId   :=  394770
                                               , inMeasureId      :=  323
                                               , inNDSKindId      :=  9
                                               , inObjectId       :=  59610
                                               , inUserId         :=  3
                                               , inMakerId        :=  Null
                                               , inMakerName      := '22222'
                                               , inCheckName      :=  True
                                               , inAreaId         := 0
                                               , inNameUkr        := '2222'
                                               , inCodeUKTZED     := ''
                                               , inExchangeId     :=  0)

select GoodsGroupId, * from Object_Goods_Retail
    left outer join Object_Goods_Main on Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainID
where Object_Goods_Retail.ID = 30502

select * from Object_Goods_View  where ID =   30502
*/


/*select * from gpInsertUpdate_Object_Goods(ioId := 30502 , inCode := '6' , inName := 'Лаферон фл 1млн ЕД N5 ' , inGoodsGroupId := 394770 , inMeasureId := 323 ,
 inNDSKindId := 9 , inMinimumLot := 0 , inReferCode := 0 , inReferPrice := 0 , inPrice := 0 , inIsClose := 'False' , inTOP := 'False' , inPercentMarkup := 0 ,
 inMorionCode := 66753 , inBarCode := '' , inNameUkr := '' , inCodeUKTZED := '' , inExchangeId := 0 ,  inSession := '3');
 */