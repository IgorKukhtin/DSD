-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);*/

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar
                                                  , Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                  , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                  , TVarChar);
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                     Integer   , -- ключ объекта <Товар>
    IN inCode                   Integer   , -- Код объекта <Товар>
    IN inName                   TVarChar  , -- Название объекта <Товар>
    IN inArticle                TVarChar,
    IN inArticleVergl           TVarChar,
    IN inEAN                    TVarChar,
    IN inASIN                   TVarChar,
    IN inMatchCode              TVarChar,
    IN inFeeNumber              TVarChar,
    IN inComment                TVarChar,
    IN inisArc                  Boolean,
    IN inFeet                   TFloat,
    IN inMetres                 TFloat,   
    IN inAmountMin              TFloat,
    IN inAmountRefer            TFloat,
    IN inEKPrice                TFloat,
    IN inEmpfPrice              TFloat,
    IN inGoodsGroupId           Integer,
    IN inMeasureId              Integer,
    IN inGoodsTagId             Integer,
    IN inGoodsTypeId            Integer,
    IN inGoodsSizeId            Integer,
    IN inProdColorId            Integer,
    IN inPartnerId              Integer,
    IN inUnitId                 Integer,
    IN inDiscountPartnerId      Integer,
    IN inTaxKindId              Integer,
    IN inEngineId               Integer,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGroupNameFull TVarChar;
   DECLARE vbIsInsert Boolean;
   DECLARE vbInfoMoneyId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   --
   IF COALESCE (ioId, 0) = 0
   THEN
       -- Если код не установлен, определяем его как последний+1
       inCode:= lfGet_ObjectCode (inCode, zc_Object_Goods());

   ELSEIF COALESCE (inCode, 0) = 0
   THEN
       -- Нашли код
       inCode:= (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   END IF;


   -- проверка уникальности <Код>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), inCode, vbUserId); END IF;

   -- !!! проверка уникальности <ArticleNr>
   IF inArticle <> '' 
   THEN
       PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Article(), inArticle, vbUserId);
   END IF;


   -- проверка <inName>
   IF TRIM (COALESCE (inName, '')) = ''
   THEN
       --RAISE EXCEPTION 'Ошибка.Значение <Название> должно быть установлено.';
       RAISE EXCEPTION '% <%> <%>'
                     , lfMessageTraslate (inMessage       := 'Ошибка.Значение <Название> должно быть установлено.'
                                        , inProcedureName := 'gpInsertUpdate_Object_Goods'
                                        , inUserId        := vbUserId
                                         )
                     , inArticle, inEAN
                      ;
   END IF;

   -- проверка <GoodsGroupId>
   IF COALESCE (inGoodsGroupId, 0) = 0
   THEN
       --RAISE EXCEPTION 'Ошибка.Значение <Группа товаров> должно быть установлено.';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Значение <Группа товаров> должно быть установлено.'
                                             , inProcedureName := 'gpInsertUpdate_Object_Goods'
                                             , inUserId        := vbUserId);
   END IF;

   -- из ближайшей группы где установлено <УП статья назначения>
   vbInfoMoneyId:= lfGet_Object_GoodsGroup_InfomoneyId (inGoodsGroupId);
   -- проверка <InfoMoneyId>
   /*IF COALESCE (vbInfoMoneyId, 0) = 0
   THEN
       --RAISE EXCEPTION 'Ошибка.Значение <УП статья назначения> не найдена для группы <%>.', lfGet_Object_ValueData (inGoodsGroupId);
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Значение <УП статья назначения> не найдена для группы <%>.'  :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Goods'           :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := lfGet_Object_ValueData (inGoodsGroupId) :: TVarChar
                                             );
   END IF;
   */

   -- из ближайшей группы где установлено <Признак товара>
   --inGoodsTagId:= lfGet_Object_GoodsGroup_GoodsTagId (inGoodsGroupId);

   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), inCode, inName, NULL);

   -- сохранили свойство <Полное название группы>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
   -- сохранили свойство <>
   IF inFeeNumber <> ''
   THEN
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_FeeNumber(), ioId, TRIM (inFeeNumber));
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ArticleVergl(), ioId, inArticleVergl);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_EAN(), ioId, inEAN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ASIN(), ioId, inASIN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MatchCode(), ioId, inMatchCode);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Min(), ioId, inAmountMin);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Refer(), ioId, inAmountRefer);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_EKPrice(), ioId, inEKPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_EmpfPrice(), ioId, inEmpfPrice);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Feet(), ioId, inFeet);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Metres(), ioId, inMetres);


   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили вязь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ioId, inGoodsTagId);
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsType(), ioId, inGoodsTypeId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsSize(), ioId, inGoodsSizeId);
   -- сохранили связь с <>
   IF inProdColorId > 0 THEN
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), ioId, inProdColorId);
   END IF;
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Partner(), ioId, inPartnerId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Unit(), ioId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_DiscountPartner(), ioId, inDiscountPartnerId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TaxKind(), ioId, inTaxKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Engine(), ioId, inEngineId);

   -- сохранили связь с ***<УП статья назначения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, vbInfoMoneyId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Arc(), ioId, inisArc);
   -- сохранили свойство <>
   --PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_PartnerDate(), ioId, inPartnerDate);


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата изменения>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (изменение)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   END IF;


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.22         *
 11.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
