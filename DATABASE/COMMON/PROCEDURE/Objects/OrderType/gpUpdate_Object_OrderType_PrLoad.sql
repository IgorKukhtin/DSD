-- Function: gpUpdate_Object_OrderType_PrLoad()

DROP FUNCTION IF EXISTS gpUpdate_Object_OrderType_PrLoad(Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_OrderType_PrLoad(
    IN inGoodsCode       Integer    ,    -- ключ объекта <Подразделение>
    IN inisOrderPr1      Integer    ,    --
    IN inisOrderPr2      Integer    ,    --
    IN inisOrderPr3      Integer    ,    --
    IN inisOrderPr4      Integer    ,    --
    IN inisOrderPr5      Integer    ,    --
    IN inisOrderPr6      Integer    ,    --
    IN inisOrderPr7      Integer    ,    --
    IN inisInPr1         Integer    ,    --
    IN inisInPr2         Integer    ,    --
    IN inisInPr3         Integer    ,    --
    IN inisInPr4         Integer    ,    --
    IN inisInPr5         Integer    ,    --
    IN inisInPr6         Integer    ,    --
    IN inisInPr7         Integer    ,    --
    IN inSession         TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbGoodsId     Integer;
   DECLARE vbOrderTypeId Integer;
BEGIN

   IF COALESCE(inGoodsCode, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);


   -- по коду товара находим сам товар и OrderType
   vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr1(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisOrderPr1,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr2(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisOrderPr2,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr3(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisOrderPr3,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr4(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisOrderPr4,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr5(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisOrderPr5,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr6(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisOrderPr6,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr7(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisOrderPr7,0) = 1 THEN TRUE ELSE FALSE END)

         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr1(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisInPr1,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr2(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisInPr2,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr3(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisInPr3,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr4(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisInPr4,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr5(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisInPr5,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr6(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisInPr6,0) = 1 THEN TRUE ELSE FALSE END)
         , lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr7(), OL_OrderType_Goods.ObjectId, CASE WHEN COALESCE (inisInPr7,0) = 1 THEN TRUE ELSE FALSE END)
         -- сохранили протокол
         , lpInsert_ObjectProtocol (OL_OrderType_Goods.ObjectId, vbUserId)
         
   FROM ObjectLink AS OL_OrderType_Goods
   WHERE OL_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
     AND OL_OrderType_Goods.ChildObjectId = vbGoodsId;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         *
*/