-- Function: gpInsertUpdate_Object_OrderType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderType (Integer, Integer, TVarChar, TFloat, TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderType(
 INOUT ioId	                   Integer   ,    -- ключ объекта <> 
    IN inCode                  Integer   ,    -- код объекта <> 
    IN inName                  TVarChar  ,    -- Название объекта  

    IN inTermProduction        TFloat  ,    -- 
    IN inNormInDays            TFloat  ,    -- 
    IN inStartProductionInDays TFloat  ,    -- 
        
    IN inKoeff1           TFloat  ,    -- 
    IN inKoeff2           TFloat  ,    -- 
    IN inKoeff3           TFloat  ,    -- 
    IN inKoeff4           TFloat  ,    -- 
    IN inKoeff5           TFloat  ,    -- 
    IN inKoeff6           TFloat  ,    -- 
    IN inKoeff7           TFloat  ,    -- 
    IN inKoeff8           TFloat  ,    -- 
    IN inKoeff9           TFloat  ,    -- 
    IN inKoeff10          TFloat  ,    -- 
    IN inKoeff11          TFloat  ,            
    IN inKoeff12          TFloat  ,    
    IN inGoodsId          Integer   ,    -- товар
    IN inUnitId           Integer   ,    -- Качественное удостоверение
    IN inSession          TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_OrderType());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка уникальности товара
     IF COALESCE (inGoodsId, 0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка. Не установлено значение <Товар>.';
     ELSE
         IF exists (SELECT ChildObjectId FROM ObjectLink where DescId = zc_ObjectLink_OrderType_Goods() and ChildObjectId = inGoodsId AND coalesce (ObjectId,0) <> coalesce (ioId,0))
         THEN 
             RAISE EXCEPTION 'Ошибка. Значение <%> уже есть в справочнике.', lfGet_Object_ValueData (vbGoodsId);
         END IF;   
     END IF;   

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_OrderType());
    
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderType(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderType(), inCode, inName);
                                --, inAccessKeyId:= (SELECT Object_Branch.AccessKeyId FROM Object AS Object_Branch WHERE Object_Branch.Id = inBranchId));
   
   
      -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_TermProduction(), ioId, inTermProduction);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_NormInDays(), ioId, inNormInDays);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_StartProductionInDays(), ioId, inStartProductionInDays);
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff1(), ioId, inKoeff1);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff2(), ioId, inKoeff2);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff3(), ioId, inKoeff3);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff4(), ioId, inKoeff4);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff5(), ioId, inKoeff5);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff6(), ioId, inKoeff6);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff7(), ioId, inKoeff7);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff8(), ioId, inKoeff8);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff9(), ioId, inKoeff9);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff10(), ioId, inKoeff10);   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff11(), ioId, inKoeff11);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff12(), ioId, inKoeff12);   
   -- 
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_OrderType_Goods(), ioId, inGoodsId);
   -- 
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_OrderType_Unit(), ioId, inUnitId);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
 /*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.03.15         * 
             

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_OrderType()
