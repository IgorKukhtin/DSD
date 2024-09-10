-- Function: gpInsertUpdate_Object_Receipt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Receipt (Integer, Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Receipt (Integer, Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Receipt (Integer, Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Receipt(
 INOUT ioId                  Integer   , -- ключ объекта <Составляющие рецептур>
    IN inMaskId              Integer   , -- ключ документа маски
    IN inCode                Integer   , -- Код
    IN inReceiptCode         TVarChar  , -- Код рецептуры
    IN inComment             TVarChar  , -- Комментарий
    IN inValue               TFloat    , -- Значение (Количество)
    IN inValueCost           TFloat    , -- Значение затрат(Количество)
    IN inTaxExit             TFloat    , -- % выхода
    IN inPartionValue        TFloat    , -- Количество в партии (количество в кутере)
    IN inPartionCount        TFloat    , -- Минимальное количество партий (количество кутеров, значение или 0.5 или 1)
    IN inWeightPackage       TFloat    , -- Вес упаковки
    IN inTaxLossCEH          TFloat    , --
    IN inTaxLossTRM          TFloat    , --
    IN inTaxLossVPR          TFloat    , --
    IN inRealDelicShp        TFloat    , --
    IN inValuePF             TFloat    ,
    IN inStartDate           TDateTime , -- Начальная дата
    IN inEndDate             TDateTime , -- Конечная дата
    IN inIsMain              Boolean   , -- Признак главный
    IN inGoodsId             Integer   , -- ссылка на Товары
    IN inGoodsKindId         Integer   , -- ссылка на Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров (готовая продукция)
    IN inReceiptCostId       Integer   , -- Затраты в рецептурах
    IN inReceiptKindId       Integer   , -- Виды рецептур
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbName TVarChar;
   DECLARE vbCode_calc Integer; 
   DECLARE vbIsUpdate Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Receipt());
   

   -- проверка <Товар>
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Товар> должно быть установлено.';
   END IF;

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;
   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Receipt()); 


   -- расчет названия
   vbName:= TRIM (TRIM ((SELECT ValueData FROM Object WHERE DescId = zc_Object_Goods() AND Id = inGoodsId))
         || ' ' || COALESCE ((SELECT ValueData FROM Object WHERE DescId = zc_Object_GoodsKind() AND Id = inGoodsKindId AND inGoodsKindId <> zc_GoodsKind_WorkProgress()), ''))
         || '-' || TRIM (inComment)
         || '-' || TRIM (inReceiptCode);

   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Receipt(), vbCode_calc);
   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Receipt(), vbName);
   -- проверка уникальности для свойства <Код рецептуры>
   PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Receipt_Code(), inReceiptCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Receipt(), vbCode_calc, vbName);
   
   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_Goods(), ioId, inGoodsId);   
   -- сохранили связь с <Видом товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь с <Виды товаров (готовая продукция)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_GoodsKindComplete(), ioId, inGoodsKindCompleteId);
   -- сохранили связь с <Затраты в рецептурах>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptCost(), ioId, inReceiptCostId);
   -- сохранили связь с <Виды рецептур>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptKind(), ioId, inReceiptKindId);

   -- сохранили свойство <Код рецептуры>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Receipt_Code(), ioId, inReceiptCode);
   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Receipt_Comment(), ioId, inComment);


   -- сохранили свойство <Значение (Количество)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_Value(), ioId, inValue);
   -- сохранили свойство <Значение затрат(Количество)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_ValueCost(), ioId, inValueCost);
   -- сохранили свойство <% выхода>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxExit(), ioId, inTaxExit);
   -- сохранили свойство <Количество в партии (количество в кутере)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_PartionValue(), ioId, inPartionValue);
   -- сохранили свойство <Минимальное количество партий (количество кутеров, значение или 0.5 или 1)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_PartionCount(), ioId, inPartionCount);
   -- сохранили свойство <Вес упаковки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_WeightPackage(), ioId, inWeightPackage);

   -- сохранили свойство <Значение>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxLossCEH(), ioId, inTaxLossCEH);
   -- сохранили свойство <Значение >
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxLossTRM(), ioId, inTaxLossTRM);
   -- сохранили свойство <Значение >
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxLossVPR(), ioId, inTaxLossVPR);
   -- сохранили свойство <Значение >
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_RealDelicShp(), ioId, inRealDelicShp);
   -- сохранили свойство <Значение >
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_ValuePF(), ioId, inValuePF);
      
   -- сохранили свойство <Начальная дата>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_Start(), ioId, inStartDate);
   -- сохранили свойство <Конечная дата>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_End(), ioId, inEndDate);
 
   -- сохранили свойство <Признак главный>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Receipt_Main(), ioId, inIsMain);

   -- Проверка
   IF inIsMain = TRUE
   THEN
       IF EXISTS (SELECT 1
                  FROM ObjectLink AS ObjectLink_Receipt_Goods
                     --INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                     --                                   AND Object_Receipt.isErased = FALSE
                       INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                ON ObjectBoolean_Main.ObjectId  = ObjectLink_Receipt_Goods.ObjectId
                                               AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                               AND ObjectBoolean_Main.ValueData = TRUE
                       LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                            ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                           AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                       LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                            ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                           AND ObjectLink_Receipt_GoodsKindComplete.DescId   = zc_ObjectLink_Receipt_GoodsKindComplete()
                  WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                    AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                    AND COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                    AND COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) = CASE WHEN COALESCE (inGoodsKindCompleteId, 0) = 0 THEN zc_GoodsKind_Basis() ELSE inGoodsKindCompleteId END
                    AND ObjectLink_Receipt_Goods.ObjectId <> COALESCE (ioId, 0)
                 )
       THEN
           RAISE EXCEPTION 'Ошибка.Код существующей главной рецептуры с такими параметрами = <%>.Дублирование запрещено'
               , (SELECT Object_Receipt.ObjectCode
                  FROM ObjectLink AS ObjectLink_Receipt_Goods
                       LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                      -- AND Object_Receipt.isErased = FALSE
                       INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                ON ObjectBoolean_Main.ObjectId  = ObjectLink_Receipt_Goods.ObjectId
                                               AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                               AND ObjectBoolean_Main.ValueData = TRUE
                       LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                            ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                           AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                       LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKindComplete
                                            ON ObjectLink_Receipt_GoodsKindComplete.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                           AND ObjectLink_Receipt_GoodsKindComplete.DescId   = zc_ObjectLink_Receipt_GoodsKindComplete()
                  WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                    AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                    AND COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                    AND COALESCE (ObjectLink_Receipt_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) = CASE WHEN COALESCE (inGoodsKindCompleteId, 0) = 0 THEN zc_GoodsKind_Basis() ELSE inGoodsKindCompleteId END
                    AND ObjectLink_Receipt_Goods.ObjectId <> COALESCE (ioId, 0)
                 )
           ;
       END IF;
   END IF;

   IF COALESCE (inMaskId, 0) <> 0
      THEN
          -- записываем строки документа
   PERFORM gpInsertUpdate_Object_ReceiptChild (ioId                 := 0
                                             , inValue              := tmp.Value
                                             , inIsWeightMain       := tmp.IsWeightMain
                                             , inIsTaxExit          := tmp.IsTaxExit
                                             , inisSave             := TRUE
                                             , inisDel              := FALSE
                                             , ioStartDate          := tmp.StartDate
                                             , ioEndDate            := tmp.EndDate
                                             , inComment            := tmp.Comment 
                                             , inReceiptId          := ioId            --tmp.ReceiptId
                                             , inReceiptLevelId     := tmp.ReceiptLevelId
                                             , inGoodsId            := tmp.GoodsId
                                             , inGoodsKindId        := tmp.GoodsKindId
                                             , inSession            := inSession
                                              ) 
   FROM gpSelect_Object_ReceiptChild (inMaskId, 0, 0, FALSE, inSession)  AS tmp
   WHERE tmp.ReceiptId = inMaskId;
      
   END IF;
   
   -- !!!пересчитали связь с рецепт "поиск"!!!
   PERFORM lpUpdate_Object_Receipt_Parent (0, inGoodsId, vbUserId);

   -- !!!пересчитали итоговые кол-ва по рецепту!!!
   PERFORM lpUpdate_Object_Receipt_Total (ioId, vbUserId);

   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Receipt (Integer, Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.07.24         *
 15.03.15         * add inMaskId
 13.02.15                                        * all
 24.12.14         *
 19.07.13         * rename zc_ObjectDate_               
 10.07.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Receipt ()
