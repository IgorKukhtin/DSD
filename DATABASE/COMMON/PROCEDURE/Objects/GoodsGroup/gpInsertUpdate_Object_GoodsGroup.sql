-- Function: gpInsertUpdate_Object_GoodsGroup()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId                  Integer   ,    -- ключ объекта <Группа товаров>
    IN inCode                Integer   ,    -- Код объекта <Группа товаров>
    IN inCodeUKTZED          TVarChar  ,    -- Код товару згідно з УКТ ЗЕД
    IN inTaxImport           TVarChar  ,    -- признак импортированного товара
    IN inDKPP                TVarChar  ,    -- Послуги згідно з ДКПП
    IN inTaxAction           TVarChar  ,    -- Код виду діяльності сільск-господар товаровиробника
    IN inName                TVarChar  ,    -- Название объекта <Группа товаров>
    IN inParentId            Integer   ,    -- ссылка на группу товаров
    IN inGroupStatId         Integer   ,    -- ссылка на группу товаров (статистика)
    IN inGoodsGroupAnalystId Integer   ,    -- ***Группа аналитики
    IN inTradeMarkId         Integer   ,    -- ***Торговая марка
    IN inGoodsTagId          Integer   ,    -- ***Признак товара
    IN inGoodsPlatformId     Integer   ,    -- ***Производственная площадка
    IN inInfoMoneyId         Integer   ,    -- ***УП статья назначения 
    IN inisAsset             Boolean   ,    -- Признак - ОС
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
   DECLARE vbParentId_old Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO vbCode FROM Object WHERE Object.DescId = zc_Object_GoodsGroup();
   ELSE
       vbCode := inCode;
   END IF; 
   
   -- предыдущее значение
   vbParentId_old:= (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = ioId AND ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent());

   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsGroup(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), vbCode);

   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink (ioId, zc_ObjectLink_GoodsGroup_Parent(), inParentId);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsGroup(), inCode, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_GoodsGroupStat(), ioId, inGroupStatId);
   
   -- сохранили связь с <Группа аналитики>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst(), ioId, inGoodsGroupAnalystId);

   -- сохранили связь с <Торговая марка>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_TradeMark(), ioId, inTradeMarkId);
  
   -- сохранили связь с <Признак товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_GoodsTag(), ioId, inGoodsTagId);

   -- сохранили связь с <Производственная площадка>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_GoodsPlatform(), ioId, inGoodsPlatformId);

   -- сохранили связь с <УП статья назначения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_InfoMoney(), ioId, inInfoMoneyId);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_UKTZED(), ioId, inCodeUKTZED);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_TaxImport(), ioId, inTaxImport);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_DKPP(), ioId, inDKPP);
   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsGroup_TaxAction(), ioId, inTaxAction);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsGroup_Asset(), ioId, inisAsset);

   -- Список
   CREATE TEMP TABLE _tmpList ON COMMIT DROP AS
                      -- !!! опускаемся на все уровни вниз !!!!
                      SELECT ioId AS GoodsGroupId
                     UNION ALL
                      SELECT vbParentId_old AS GoodsGroupId WHERE vbParentId_old <> 0
                     UNION ALL
                      SELECT ObjectLink.ObjectId AS GoodsGroupId
                      FROM ObjectLink
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId IN (ioId, vbParentId_old)
                     UNION ALL
                      SELECT ObjectLink_Child1.ObjectId AS GoodsGroupId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId IN (ioId, vbParentId_old)
                     UNION ALL
                      SELECT ObjectLink_Child2.ObjectId AS GoodsGroupId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId IN (ioId, vbParentId_old)
                     UNION ALL
                      SELECT ObjectLink_Child3.ObjectId AS GoodsGroupId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId IN (ioId, vbParentId_old)
                     UNION ALL
                      SELECT ObjectLink_Child4.ObjectId AS GoodsGroupId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ChildObjectId = ObjectLink_Child3.ObjectId
                                                               AND ObjectLink_Child4.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId IN (ioId, vbParentId_old)
                     UNION ALL
                      SELECT ObjectLink_Child5.ObjectId AS GoodsGroupId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ChildObjectId = ObjectLink_Child3.ObjectId
                                                               AND ObjectLink_Child4.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child5 ON ObjectLink_Child5.ChildObjectId = ObjectLink_Child4.ObjectId
                                                               AND ObjectLink_Child5.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId IN (ioId, vbParentId_old)
                     ;

   -- обновили свойство <Полное название группы> у всех товаров этой группы
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ObjectLink.ObjectId, lfGet_Object_TreeNameFull (ObjectLink.ChildObjectId, zc_ObjectLink_GoodsGroup_Parent()))
   FROM ObjectLink
        INNER JOIN _tmpList ON _tmpList.GoodsGroupId = ObjectLink.ChildObjectId
   WHERE ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup()
  ;

/* !!!больше не надо, т.к. меняется у товара!!!  
   -- изменили свойство <группа статистики> у всех товаров этой группы
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupStat(), ObjectLink.ObjectId, inGroupStatId)
   FROM ObjectLink
        INNER JOIN _tmpList ON _tmpList.GoodsGroupId = ObjectLink.ChildObjectId
   WHERE ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup()
  ;
*/

   -- обновили свойства у всех товаров этой группы
   CREATE TEMP TABLE _tmpInsert ON COMMIT DROP AS
   SELECT CASE WHEN tmp.isInfomoney OR tmp.isTradeMark OR tmp.isGoodsTag OR tmp.isGoodsGroupAnalyst OR tmp.isGoodsPlatform THEN 0 ELSE 0 END :: Integer AS tmpValue
   FROM
  (SELECT -- ***<УП статья назначения>
          CASE WHEN ObjectLink_Infomoney0.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney0.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney0.ChildObjectId) END
               WHEN ObjectLink_Infomoney1.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney1.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney1.ChildObjectId) END
               WHEN ObjectLink_Infomoney2.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney2.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney2.ChildObjectId) END
               WHEN ObjectLink_Infomoney3.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney3.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney3.ChildObjectId) END
               WHEN ObjectLink_Infomoney4.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney4.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney4.ChildObjectId) END
               WHEN ObjectLink_Infomoney5.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney5.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney5.ChildObjectId) END
               WHEN ObjectLink_Infomoney6.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney6.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney6.ChildObjectId) END
               WHEN ObjectLink_Infomoney7.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney7.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney7.ChildObjectId) END
               WHEN ObjectLink_Infomoney8.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney8.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney8.ChildObjectId) END
               WHEN ObjectLink_Infomoney9.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney9.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney9.ChildObjectId) END
               WHEN ObjectLink_Infomoney10.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_Infomoney10.ChildObjectId <> COALESCE (ObjectLink_Infomoney.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Infomoney(), ObjectLink.ObjectId, ObjectLink_Infomoney10.ChildObjectId) END
          END AS isInfomoney
          -- ***<Торговая марка>
        , CASE WHEN ObjectLink_TradeMark0.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark0.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark0.ChildObjectId) END
               WHEN ObjectLink_TradeMark1.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark1.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark1.ChildObjectId) END
               WHEN ObjectLink_TradeMark2.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark2.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark2.ChildObjectId) END
               WHEN ObjectLink_TradeMark3.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark3.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark3.ChildObjectId) END
               WHEN ObjectLink_TradeMark4.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark4.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark4.ChildObjectId) END
               WHEN ObjectLink_TradeMark5.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark5.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark5.ChildObjectId) END
               WHEN ObjectLink_TradeMark6.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark6.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark6.ChildObjectId) END
               WHEN ObjectLink_TradeMark7.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark7.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark7.ChildObjectId) END
               WHEN ObjectLink_TradeMark8.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark8.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark8.ChildObjectId) END
               WHEN ObjectLink_TradeMark9.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark9.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark9.ChildObjectId) END
               WHEN ObjectLink_TradeMark10.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_TradeMark10.ChildObjectId <> COALESCE (ObjectLink_TradeMark.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ObjectLink.ObjectId, ObjectLink_TradeMark10.ChildObjectId) END
          END AS isTradeMark

          -- ***<Признак товара>
        , CASE WHEN ObjectLink_GoodsTag0.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag0.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag0.ChildObjectId) END
               WHEN ObjectLink_GoodsTag1.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag1.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag1.ChildObjectId) END
               WHEN ObjectLink_GoodsTag2.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag2.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag2.ChildObjectId) END
               WHEN ObjectLink_GoodsTag3.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag3.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag3.ChildObjectId) END
               WHEN ObjectLink_GoodsTag4.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag4.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag4.ChildObjectId) END
               WHEN ObjectLink_GoodsTag5.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag5.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag5.ChildObjectId) END
               WHEN ObjectLink_GoodsTag6.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag6.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag6.ChildObjectId) END
               WHEN ObjectLink_GoodsTag7.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag7.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag7.ChildObjectId) END
               WHEN ObjectLink_GoodsTag8.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag8.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag8.ChildObjectId) END
               WHEN ObjectLink_GoodsTag9.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag9.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag9.ChildObjectId) END
               WHEN ObjectLink_GoodsTag10.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsTag10.ChildObjectId <> COALESCE (ObjectLink_GoodsTag.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ObjectLink.ObjectId, ObjectLink_GoodsTag10.ChildObjectId) END
          END AS isGoodsTag

          -- ***<Группа аналитики>
        , CASE WHEN ObjectLink_GoodsGroupAnalyst0.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst0.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst0.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst1.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst1.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst1.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst2.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst2.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst2.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst3.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst3.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst3.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst4.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst4.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst4.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst5.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst5.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst5.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst6.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst6.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst6.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst7.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst7.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst7.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst8.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst8.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst8.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst9.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst9.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst9.ChildObjectId) END
               WHEN ObjectLink_GoodsGroupAnalyst10.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsGroupAnalyst10.ChildObjectId <> COALESCE (ObjectLink_GoodsGroupAnalyst.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ObjectLink.ObjectId, ObjectLink_GoodsGroupAnalyst10.ChildObjectId) END
          END AS isGoodsGroupAnalyst

          -- ***<Производственная площадка>
        , CASE WHEN ObjectLink_GoodsPlatform0.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform0.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform0.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform1.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform1.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform1.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform2.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform2.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform2.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform3.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform3.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform3.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform4.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform4.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform4.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform5.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform5.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform5.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform6.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform6.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform6.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform7.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform7.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform7.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform8.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform8.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform8.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform9.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform9.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform9.ChildObjectId) END
               WHEN ObjectLink_GoodsPlatform10.ChildObjectId <> 0
                    THEN CASE WHEN ObjectLink_GoodsPlatform10.ChildObjectId <> COALESCE (ObjectLink_GoodsPlatform.ChildObjectId, 0) THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ObjectLink.ObjectId, ObjectLink_GoodsPlatform10.ChildObjectId) END
          END AS isGoodsPlatform

   FROM ObjectLink
        INNER JOIN _tmpList ON _tmpList.GoodsGroupId = ObjectLink.ChildObjectId
        --  св-ва товара
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark
                             ON ObjectLink_TradeMark.ObjectId = ObjectLink.ObjectId
                            AND ObjectLink_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                             ON ObjectLink_GoodsTag.ObjectId = ObjectLink.ObjectId
                            AND ObjectLink_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst
                             ON ObjectLink_GoodsGroupAnalyst.ObjectId = ObjectLink.ObjectId
                            AND ObjectLink_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform
                             ON ObjectLink_GoodsPlatform.ObjectId = ObjectLink.ObjectId
                            AND ObjectLink_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                             ON ObjectLink_InfoMoney.ObjectId = ObjectLink.ObjectId
                            AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

        --  св-ва Группы товаров - 0
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark0
                             ON ObjectLink_TradeMark0.ObjectId = ObjectLink.ChildObjectId
                            AND ObjectLink_TradeMark0.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag0
                             ON ObjectLink_GoodsTag0.ObjectId = ObjectLink.ChildObjectId
                            AND ObjectLink_GoodsTag0.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst0
                             ON ObjectLink_GoodsGroupAnalyst0.ObjectId = ObjectLink.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst0.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform0
                             ON ObjectLink_GoodsPlatform0.ObjectId = ObjectLink.ChildObjectId
                            AND ObjectLink_GoodsPlatform0.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney0
                             ON ObjectLink_InfoMoney0.ObjectId = ObjectLink.ChildObjectId
                            AND ObjectLink_InfoMoney0.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 1
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup1
                             ON ObjectLink_GoodsGroup1.ObjectId = ObjectLink.ChildObjectId
                            AND ObjectLink_GoodsGroup1.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark1
                             ON ObjectLink_TradeMark1.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_TradeMark1.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag1
                             ON ObjectLink_GoodsTag1.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsTag1.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst1
                             ON ObjectLink_GoodsGroupAnalyst1.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst1.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform1
                             ON ObjectLink_GoodsPlatform1.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsPlatform1.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney1
                             ON ObjectLink_InfoMoney1.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_InfoMoney1.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 2
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup2
                             ON ObjectLink_GoodsGroup2.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup2.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark2
                             ON ObjectLink_TradeMark2.ObjectId = ObjectLink_GoodsGroup2.ChildObjectId
                            AND ObjectLink_TradeMark2.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag2
                             ON ObjectLink_GoodsTag2.ObjectId = ObjectLink_GoodsGroup2.ChildObjectId
                            AND ObjectLink_GoodsTag2.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst2
                             ON ObjectLink_GoodsGroupAnalyst2.ObjectId = ObjectLink_GoodsGroup2.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst2.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform2
                             ON ObjectLink_GoodsPlatform2.ObjectId = ObjectLink_GoodsGroup2.ChildObjectId
                            AND ObjectLink_GoodsPlatform2.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney2
                             ON ObjectLink_InfoMoney2.ObjectId = ObjectLink_GoodsGroup2.ChildObjectId
                            AND ObjectLink_InfoMoney2.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()


        --  св-ва Группы товаров - 3
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup3
                             ON ObjectLink_GoodsGroup3.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup3.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark3
                             ON ObjectLink_TradeMark3.ObjectId = ObjectLink_GoodsGroup3.ChildObjectId
                            AND ObjectLink_TradeMark3.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag3
                             ON ObjectLink_GoodsTag3.ObjectId = ObjectLink_GoodsGroup3.ChildObjectId
                            AND ObjectLink_GoodsTag3.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst3
                             ON ObjectLink_GoodsGroupAnalyst3.ObjectId = ObjectLink_GoodsGroup3.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst3.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform3
                             ON ObjectLink_GoodsPlatform3.ObjectId = ObjectLink_GoodsGroup3.ChildObjectId
                            AND ObjectLink_GoodsPlatform3.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney3
                             ON ObjectLink_InfoMoney3.ObjectId = ObjectLink_GoodsGroup3.ChildObjectId
                            AND ObjectLink_InfoMoney3.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 4
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup4
                             ON ObjectLink_GoodsGroup4.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup4.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark4
                             ON ObjectLink_TradeMark4.ObjectId = ObjectLink_GoodsGroup4.ChildObjectId
                            AND ObjectLink_TradeMark4.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag4
                             ON ObjectLink_GoodsTag4.ObjectId = ObjectLink_GoodsGroup4.ChildObjectId
                            AND ObjectLink_GoodsTag4.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst4
                             ON ObjectLink_GoodsGroupAnalyst4.ObjectId = ObjectLink_GoodsGroup4.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst4.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform4
                             ON ObjectLink_GoodsPlatform4.ObjectId = ObjectLink_GoodsGroup4.ChildObjectId
                            AND ObjectLink_GoodsPlatform4.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney4
                             ON ObjectLink_InfoMoney4.ObjectId = ObjectLink_GoodsGroup4.ChildObjectId
                            AND ObjectLink_InfoMoney4.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 5
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup5
                             ON ObjectLink_GoodsGroup5.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup5.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark5
                             ON ObjectLink_TradeMark5.ObjectId = ObjectLink_GoodsGroup5.ChildObjectId
                            AND ObjectLink_TradeMark5.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag5
                             ON ObjectLink_GoodsTag5.ObjectId = ObjectLink_GoodsGroup5.ChildObjectId
                            AND ObjectLink_GoodsTag5.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst5
                             ON ObjectLink_GoodsGroupAnalyst5.ObjectId = ObjectLink_GoodsGroup5.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst5.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform5
                             ON ObjectLink_GoodsPlatform5.ObjectId = ObjectLink_GoodsGroup5.ChildObjectId
                            AND ObjectLink_GoodsPlatform5.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney5
                             ON ObjectLink_InfoMoney5.ObjectId = ObjectLink_GoodsGroup5.ChildObjectId
                            AND ObjectLink_InfoMoney5.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 6
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup6
                             ON ObjectLink_GoodsGroup6.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup6.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark6
                             ON ObjectLink_TradeMark6.ObjectId = ObjectLink_GoodsGroup6.ChildObjectId
                            AND ObjectLink_TradeMark6.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag6
                             ON ObjectLink_GoodsTag6.ObjectId = ObjectLink_GoodsGroup6.ChildObjectId
                            AND ObjectLink_GoodsTag6.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst6
                             ON ObjectLink_GoodsGroupAnalyst6.ObjectId = ObjectLink_GoodsGroup6.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst6.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform6
                             ON ObjectLink_GoodsPlatform6.ObjectId = ObjectLink_GoodsGroup6.ChildObjectId
                            AND ObjectLink_GoodsPlatform6.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney6
                             ON ObjectLink_InfoMoney6.ObjectId = ObjectLink_GoodsGroup6.ChildObjectId
                            AND ObjectLink_InfoMoney6.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 7
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup7
                             ON ObjectLink_GoodsGroup7.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup7.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark7
                             ON ObjectLink_TradeMark7.ObjectId = ObjectLink_GoodsGroup7.ChildObjectId
                            AND ObjectLink_TradeMark7.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag7
                             ON ObjectLink_GoodsTag7.ObjectId = ObjectLink_GoodsGroup7.ChildObjectId
                            AND ObjectLink_GoodsTag7.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst7
                             ON ObjectLink_GoodsGroupAnalyst7.ObjectId = ObjectLink_GoodsGroup7.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst7.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform7
                             ON ObjectLink_GoodsPlatform7.ObjectId = ObjectLink_GoodsGroup7.ChildObjectId
                            AND ObjectLink_GoodsPlatform7.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney7
                             ON ObjectLink_InfoMoney7.ObjectId = ObjectLink_GoodsGroup7.ChildObjectId
                            AND ObjectLink_InfoMoney7.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 8
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup8
                             ON ObjectLink_GoodsGroup8.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup8.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark8
                             ON ObjectLink_TradeMark8.ObjectId = ObjectLink_GoodsGroup8.ChildObjectId
                            AND ObjectLink_TradeMark8.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag8
                             ON ObjectLink_GoodsTag8.ObjectId = ObjectLink_GoodsGroup8.ChildObjectId
                            AND ObjectLink_GoodsTag8.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst8
                             ON ObjectLink_GoodsGroupAnalyst8.ObjectId = ObjectLink_GoodsGroup8.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst8.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform8
                             ON ObjectLink_GoodsPlatform8.ObjectId = ObjectLink_GoodsGroup8.ChildObjectId
                            AND ObjectLink_GoodsPlatform8.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney8
                             ON ObjectLink_InfoMoney8.ObjectId = ObjectLink_GoodsGroup8.ChildObjectId
                            AND ObjectLink_InfoMoney8.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 9
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup9
                             ON ObjectLink_GoodsGroup9.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup9.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark9
                             ON ObjectLink_TradeMark9.ObjectId = ObjectLink_GoodsGroup9.ChildObjectId
                            AND ObjectLink_TradeMark9.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag9
                             ON ObjectLink_GoodsTag9.ObjectId = ObjectLink_GoodsGroup9.ChildObjectId
                            AND ObjectLink_GoodsTag9.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst9
                             ON ObjectLink_GoodsGroupAnalyst9.ObjectId = ObjectLink_GoodsGroup9.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst9.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform9
                             ON ObjectLink_GoodsPlatform9.ObjectId = ObjectLink_GoodsGroup9.ChildObjectId
                            AND ObjectLink_GoodsPlatform9.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney9
                             ON ObjectLink_InfoMoney9.ObjectId = ObjectLink_GoodsGroup9.ChildObjectId
                            AND ObjectLink_InfoMoney9.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

        --  св-ва Группы товаров - 10
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup10
                             ON ObjectLink_GoodsGroup10.ObjectId = ObjectLink_GoodsGroup1.ChildObjectId
                            AND ObjectLink_GoodsGroup10.DescId = zc_ObjectLink_GoodsGroup_Parent()
        LEFT JOIN ObjectLink AS ObjectLink_TradeMark10
                             ON ObjectLink_TradeMark10.ObjectId = ObjectLink_GoodsGroup10.ChildObjectId
                            AND ObjectLink_TradeMark10.DescId = zc_ObjectLink_GoodsGroup_TradeMark()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTag10
                             ON ObjectLink_GoodsTag10.ObjectId = ObjectLink_GoodsGroup10.ChildObjectId
                            AND ObjectLink_GoodsTag10.DescId = zc_ObjectLink_GoodsGroup_GoodsTag()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupAnalyst10
                             ON ObjectLink_GoodsGroupAnalyst10.ObjectId = ObjectLink_GoodsGroup10.ChildObjectId
                            AND ObjectLink_GoodsGroupAnalyst10.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPlatform10
                             ON ObjectLink_GoodsPlatform10.ObjectId = ObjectLink_GoodsGroup10.ChildObjectId
                            AND ObjectLink_GoodsPlatform10.DescId = zc_ObjectLink_GoodsGroup_GoodsPlatform()
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoney10
                             ON ObjectLink_InfoMoney10.ObjectId = ObjectLink_GoodsGroup10.ChildObjectId
                            AND ObjectLink_InfoMoney10.DescId = zc_ObjectLink_GoodsGroup_InfoMoney()

   WHERE ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup()
  ) AS tmp;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.17         *
 18.11.15         * add zc_ObjectLink_GoodsGroup_InfoMoney
 14.04.15         * add GoodsPlatform
 24.11.14         * add GoodsGroupAnalyst             
 15.09.14         * add GoodsTag
 11.09.14         * add TradeMark
 04.09.14         * add свойство <группа статистики> обновление
 13.01.14                                        * zc_ObjectString_Goods_GroupNameFull
 11.05.13                                        * rem lpCheckUnique_Object_ValueData
 12.06.13         *
 16.06.13                                        * красота
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup()
