-- Function: gpUpdate_Object_OrderType_Pr()

DROP FUNCTION IF EXISTS gpUpdate_Object_OrderType_Pr(Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean
                                                   , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_OrderType_Pr(
    IN inId              Integer   ,    -- ключ объекта <Подразделение>
    IN inisOrderPr1      Boolean    ,    --
    IN inisOrderPr2      Boolean    ,    --
    IN inisOrderPr3      Boolean    ,    --
    IN inisOrderPr4      Boolean    ,    --
    IN inisOrderPr5      Boolean    ,    --
    IN inisOrderPr6      Boolean    ,    --
    IN inisOrderPr7      Boolean    ,    --
    IN inisInPr1         Boolean    ,    --
    IN inisInPr2         Boolean    ,    --
    IN inisInPr3         Boolean    ,    --
    IN inisInPr4         Boolean    ,    --
    IN inisInPr5         Boolean    ,    --
    IN inisInPr6         Boolean    ,    --
    IN inisInPr7         Boolean    ,    --
    IN inSession         TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr1(), inId, inisOrderPr1);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr2(), inId, inisOrderPr2);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr3(), inId, inisOrderPr3);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr4(), inId, inisOrderPr4);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr5(), inId, inisOrderPr5);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr6(), inId, inisOrderPr6);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_OrderPr7(), inId, inisOrderPr7);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr1(), inId, inisInPr1);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr2(), inId, inisInPr2);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr3(), inId, inisInPr3);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr4(), inId, inisInPr4);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr5(), inId, inisInPr5);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr6(), inId, inisInPr6);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_OrderType_InPr7(), inId, inisInPr7);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         *
*/